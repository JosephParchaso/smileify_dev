<?php
session_start();

require_once $_SERVER['DOCUMENT_ROOT'] . '/Smile-ify/includes/config.php';
require_once BASE_PATH . '/includes/db.php';

if (!isset($_SESSION['user_id']) || $_SESSION['role'] !== 'admin') {
    header("Location: " . BASE_URL . "/index.php");
    exit();
}

if ($_SERVER["REQUEST_METHOD"] === "POST") {

    $user_id          = intval($_POST['user_id'] ?? 0);
    $branch_id        = intval($_POST['appointmentBranch'] ?? 0);
    $appointmentServices = $_POST['appointmentServices'] ?? [];
    $dentist_id       = !empty($_POST['appointmentDentist']) && $_POST['appointmentDentist'] !== 'none'
                        ? intval($_POST['appointmentDentist'])
                        : null;
    $appointment_date = $_POST['appointmentDate'] ?? null;
    $appointment_time = $_POST['appointmentTime'] ?? null;
    $notes            = trim($_POST['notes'] ?? '');

    if (!$user_id || !$branch_id || empty($appointmentServices) || !$appointment_date || !$appointment_time) {
        $_SESSION['updateError'] = "Missing required fields.";
        header("Location: " . BASE_URL . "/Admin/pages/patients.php");
        exit();
    }

    try {
        $conn->begin_transaction();

        $sql = "
            INSERT INTO appointment_transaction 
            (user_id, branch_id, dentist_id, appointment_date, appointment_time, notes, status)
            VALUES (?, ?, ?, ?, ?, ?, 'Booked')
        ";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param(
            "iiisss",
            $user_id,
            $branch_id,
            $dentist_id,
            $appointment_date,
            $appointment_time,
            $notes
        );
        $stmt->execute();
        $appointment_id = $stmt->insert_id;
        $stmt->close();

        if (!empty($appointmentServices)) {

            $sql = "
                INSERT INTO appointment_services 
                (appointment_transaction_id, service_id, quantity)
                VALUES (?, ?, 1)
            ";
            $stmt = $conn->prepare($sql);

            foreach ($appointmentServices as $service_id) {
                $sid = intval($service_id);
                $stmt->bind_param("ii", $appointment_id, $sid);
                $stmt->execute();
            }

            $stmt->close();
        }

        $update = $conn->prepare("UPDATE users SET status = 'Active', date_updated = NOW() WHERE user_id = ?");
        $update->bind_param("i", $user_id);
        $update->execute();
        $update->close();

        $msg = "Your appointment on $appointment_date at $appointment_time was successfully booked!";
        $notif = $conn->prepare("INSERT INTO notifications (user_id, message) VALUES (?, ?)");
        $notif->bind_param("is", $user_id, $msg);
        $notif->execute();
        $notif->close();

        $conn->commit();

        $_SESSION['updateSuccess'] = "Appointment booked successfully!";
        header("Location: " . BASE_URL . "/Admin/pages/patients.php");
        exit();

    } catch (Exception $e) {

        $conn->rollback();
        error_log("Error booking appointment: " . $e->getMessage());

        $_SESSION['updateError'] = "Failed to book appointment. Please try again.";
        header("Location: " . BASE_URL . "/Admin/pages/patients.php");
        exit();
    }
}

$conn->close();
?>
