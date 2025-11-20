<?php
session_start();

require_once $_SERVER['DOCUMENT_ROOT'] . '/Smile-ify/includes/config.php';
require_once BASE_PATH . '/includes/db.php';

if (!isset($_SESSION['user_id']) || $_SESSION['role'] !== 'admin') {
    header("Location: " . BASE_URL . "/index.php");
    exit();
}

function isValidEmailDomain($email) {
    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        return false;
    }
    $domain = substr(strrchr($email, "@"), 1);
    return checkdnsrr($domain, "MX");
}

function generateUniqueUsername($lastName, $firstName, $conn) {
    $username_base = $lastName . '_' . strtoupper(substr($firstName, 0, 1));
    $username = $username_base;
    $counter = 0;

    $check_sql = "SELECT username FROM users WHERE username = ?";
    $check_stmt = $conn->prepare($check_sql);

    do {
        if ($counter > 0) {
            $username = $username_base . $counter;
        }

        $check_stmt->bind_param("s", $username);
        $check_stmt->execute();
        $check_stmt->store_result();
        $counter++;
    } while ($check_stmt->num_rows > 0);

    $check_stmt->close();
    return $username;
}

function generatePassword($lastName) {
    $cleanLastName = preg_replace("/[^a-zA-Z]/", "", $lastName);
    $prefix = strtolower($cleanLastName);
    $number = rand(1000, 9999);
    $specials = ['!', '@', '#', '$', '%'];
    $symbol = $specials[array_rand($specials)];
    return $prefix . $number . $symbol;
}

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $lastName            = trim($_POST['lastName']);
    $firstName           = trim($_POST['firstName']);
    $middleName          = trim($_POST['middleName']);
    $gender              = $_POST['gender'];
    $dateofBirth         = $_POST['dateofBirth'];
    $email               = trim($_POST['email']);
    $contactNumber       = trim($_POST['contactNumber']);
    $appointmentBranch   = $_POST['appointmentBranch'];
    $appointmentServices = $_POST['appointmentServices'];
    $appointmentDentist  = $_POST['appointmentDentist'];
    $appointmentDate     = $_POST['appointmentDate'];
    $appointmentTime     = $_POST['appointmentTime'];
    $notes               = $_POST['notes'];

    if ($appointmentDentist === "none" || empty($appointmentDentist)) {
        $appointmentDentist = null;
    }

    if (!isValidEmailDomain($email)) {
        $_SESSION['updateError'] = "Invalid or unreachable email domain.";
        header("Location: " . BASE_URL . "/Admin/index.php");
        exit();
    }

    try {
        $conn->begin_transaction();

        $username = generateUniqueUsername($lastName, $firstName, $conn);
        $default_password = generatePassword($lastName);
        $hashed_password  = password_hash($default_password, PASSWORD_DEFAULT);

        [$dob_enc, $dob_iv, $dob_tag] = encryptField($dateofBirth);
        [$contact_enc, $contact_iv, $contact_tag] = encryptField($contactNumber);

        $insert_patient = $conn->prepare("
            INSERT INTO users 
            (username, password, last_name, first_name, middle_name, gender,
            date_of_birth, date_of_birth_iv, date_of_birth_tag,
            email,
            contact_number, contact_number_iv, contact_number_tag,
            role, status, branch_id)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'patient', 'Active', ?)
        ");

        $insert_patient->bind_param(
            "sssssssssssssi",
            $username,
            $hashed_password,
            $lastName,
            $firstName,
            $middleName,
            $gender,
            $dob_enc,
            $dob_iv,
            $dob_tag,
            $email,
            $contact_enc,
            $contact_iv,
            $contact_tag,
            $appointmentBranch
        );

        $insert_patient->execute();
        $user_id = $insert_patient->insert_id;
        $insert_patient->close();

        $appointment_sql = "
            INSERT INTO appointment_transaction 
            (user_id, branch_id, dentist_id, appointment_date, appointment_time, notes, status) 
            VALUES (?, ?, ?, ?, ?, ?, 'Booked')
        ";
        $appointment_stmt = $conn->prepare($appointment_sql);
        $appointment_stmt->bind_param(
            "iiisss",
            $user_id, $appointmentBranch, $appointmentDentist,
            $appointmentDate, $appointmentTime, $notes
        );
        $appointment_stmt->execute();
        $appointment_id = $appointment_stmt->insert_id;
        $appointment_stmt->close();

        if (!empty($appointmentServices) && is_array($appointmentServices)) {
            $service_sql = "INSERT INTO appointment_services (appointment_transaction_id, service_id) VALUES (?, ?)";
            $service_stmt = $conn->prepare($service_sql);

            foreach ($appointmentServices as $serviceId) {
                $service_stmt->bind_param("ii", $appointment_id, $serviceId);
                $service_stmt->execute();
            }

            $service_stmt->close();
        }

        $welcome_msg = "Welcome to Smile-ify! Your account was created.";
        $notif1 = $conn->prepare("INSERT INTO notifications (user_id, message) VALUES (?, ?)");
        $notif1->bind_param("is", $user_id, $welcome_msg);
        $notif1->execute();
        $notif1->close();

        $msg = "Your appointment on $appointmentDate at $appointmentTime was successfully booked!";
        $notif2 = $conn->prepare("INSERT INTO notifications (user_id, message) VALUES (?, ?)");
        $notif2->bind_param("is", $user_id, $msg);
        $notif2->execute();
        $notif2->close();

        $conn->commit();

        $servicesHtml = "";
        $totalPrice = 0;
        $totalDuration = 0;

        if (!empty($appointmentServices) && is_array($appointmentServices)) {
            $placeholders = implode(',', array_fill(0, count($appointmentServices), '?'));
            $types = str_repeat('i', count($appointmentServices));

            $stmt = $conn->prepare("SELECT name, price, duration_minutes FROM service WHERE service_id IN ($placeholders)");
            $stmt->bind_param($types, ...$appointmentServices);
            $stmt->execute();
            $result = $stmt->get_result();

            $servicesHtml .= "<ul>";
            while ($row = $result->fetch_assoc()) {
                $servicesHtml .= "<li>{$row['name']} - ₱" . number_format($row['price'], 2) . " ({$row['duration_minutes']} mins)</li>";
                $totalPrice += $row['price'];
                $totalDuration += (int)$row['duration_minutes'];
            }
            $servicesHtml .= "</ul>";
            $stmt->close();
        }

        $totalFormatted = number_format($totalPrice, 2);

        $appointmentDateTime = new DateTime("$appointmentDate $appointmentTime");
        $appointmentDateTime->modify("+{$totalDuration} minutes");
        $formattedEndTime = $appointmentDateTime->format('h:i A');

        $branch_sql = "SELECT address FROM branch WHERE branch_id = ?";
        $branch_stmt = $conn->prepare($branch_sql);
        $branch_stmt->bind_param("i", $appointmentBranch);
        $branch_stmt->execute();
        $branch_result = $branch_stmt->get_result();
        $branch_row = $branch_result->fetch_assoc();
        $branchAddress = $branch_row['address'] ?? 'N/A';
        $branch_stmt->close();

        require BASE_PATH . '/Mail/phpmailer/PHPMailerAutoload.php';
        $mail = new PHPMailer;
        $mail->CharSet = 'UTF-8';
        $mail->Encoding = 'base64';
        $mail->isSMTP();
        $mail->Host       = SMTP_HOST;
        $mail->Port       = SMTP_PORT;
        $mail->SMTPAuth   = SMTP_AUTH;
        $mail->SMTPSecure = SMTP_SECURE;
        $mail->Username   = SMTP_USER;
        $mail->Password   = SMTP_PASS;

        $mail->setFrom('smileify.web@gmail.com', 'Smile-ify Team');
        $mail->addAddress($email);

        $mail->isHTML(true);
        $mail->Subject = "Smile-ify Login Credentials and Appointment Details";
        $mail->Body = "
            <p>Dear <strong>$username</strong>,</p>
            <p>Your Smile-ify account has been successfully verified.</p>
            <p>You may now log in using the following credentials:</p>
            <p>
                <strong>Username:</strong> $username<br>
                <strong>Password:</strong> $default_password
            </p>
                <p style='color:#c0392b; font-weight:bold;'>
                    NOTE: Kindly change your password after your first login to ensure account security.
                </p>
            <hr>
            <p><strong>Appointment Details:</strong></p>
            <p>
                <strong>Date:</strong> $appointmentDate<br>
                <strong>Time:</strong> $appointmentTime<br>
                <strong>Estimated End Time:</strong> $formattedEndTime<br>
                <strong>Location:</strong> $branchAddress
            </p>
            <p><strong>Selected Services:</strong></p>
            $servicesHtml
            <p><strong>Total:</strong> ₱{$totalFormatted} ({$totalDuration} mins total)</p>
            <br>
            <p><i>Smile with confidence.</i></p>
            <p>Best regards,<br><strong>Smile-ify</strong></p>
        ";

        if (!$mail->send()) {
            throw new Exception("Mailer Error: " . $mail->ErrorInfo);
        }

        $_SESSION['updateSuccess'] = "Walk-in patient booked and credentials emailed successfully.";
        header("Location: " . BASE_URL . "/Admin/pages/calendar.php");
        exit;

    } catch (Exception $e) {
        $conn->rollback();
        error_log("Error booking walk-in appointment: " . $e->getMessage());
        $_SESSION['updateError'] = "Failed to book walk-in appointment. Please try again.";
        header("Location: " . BASE_URL . "/Admin/index.php");
        exit;
    }
}
?>
