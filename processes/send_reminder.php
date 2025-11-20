<?php
if (php_sapi_name() === 'cli') {
    $_SERVER['HTTP_HOST'] = 'localhost';
    $_SERVER['REQUEST_URI'] = '/Smile-ify/processes/send_reminder.php';
    $_SERVER['DOCUMENT_ROOT'] = 'D:/xampp/htdocs';
}

require_once __DIR__ . '/../includes/config.php';
require_once BASE_PATH . '/includes/db.php';
require_once BASE_PATH . '/includes/mail_function.php';

date_default_timezone_set('Asia/Manila');

$logFile = BASE_PATH . '/Mail/phpmailer/reminder_log.txt';
file_put_contents($logFile, '[' . date('Y-m-d H:i:s') . "] Script started\n", FILE_APPEND);

$hoursBefore = 25;
$minutesBefore = 0;
$windowMinutes = 30; 

$now = new DateTime();
$targetStart = (clone $now)->modify("+{$hoursBefore} hours +{$minutesBefore} minutes");
$targetEnd   = (clone $now)->modify("+{$hoursBefore} hours +{$minutesBefore} minutes +{$windowMinutes} minutes");

$currentDateTime = $targetStart->format('Y-m-d H:i:s');
$nextDateTime = $targetEnd->format('Y-m-d H:i:s');

file_put_contents(
    $logFile,
    '[' . date('Y-m-d H:i:s') . "] Checking between $currentDateTime and $nextDateTime\n",
    FILE_APPEND
);

$stmt = $conn->prepare("
    SELECT 
        at.appointment_transaction_id,
        at.appointment_date,
        at.appointment_time,
        u.email,
        u.first_name,
        u.middle_name,
        u.last_name,
        b.address
    FROM appointment_transaction at
    JOIN users u ON at.user_id = u.user_id
    JOIN branch b ON at.branch_id = b.branch_id
    WHERE at.status = 'Booked'
        AND at.reminder_sent = 0
        AND CONCAT(at.appointment_date, ' ', at.appointment_time)
            BETWEEN ? AND ?
");

$stmt->bind_param('ss', $currentDateTime, $nextDateTime);
$stmt->execute();
$result = $stmt->get_result();

$sentCount = 0;

while ($appt = $result->fetch_assoc()) {
    $fullname = trim("{$appt['first_name']} {$appt['middle_name']} {$appt['last_name']}");
    $apptDateTime = date('F j, Y g:i A', strtotime($appt['appointment_date'] . ' ' . $appt['appointment_time']));
    $branch = $appt['address'];
    $to = $appt['email'];
    $subject = "Dental Appointment Reminder";
    
    $message = "
        <p>Hi {$fullname},</p>
        <p>This is a friendly reminder that your dental appointment is scheduled for <b>{$apptDateTime}</b> at <b>{$branch}</b>.</p>
        <p>Please contact us if you need to reschedule or confirm your visit.</p>
        <p>Thank you,<br><b>Smile Dental Clinic</b></p>
    ";

    if (sendMail($to, $subject, $message)) {
        $sentCount++;
        file_put_contents($logFile, '[' . date('Y-m-d H:i:s') . "] Reminder sent to {$to}\n", FILE_APPEND);

        $update = $conn->prepare("UPDATE appointment_transaction SET reminder_sent = 1 WHERE appointment_transaction_id = ?");
        $update->bind_param('i', $appt['appointment_transaction_id']);
        $update->execute();
        $update->close();
    } else {
        file_put_contents($logFile, '[' . date('Y-m-d H:i:s') . "] Failed to send reminder to {$to}\n", FILE_APPEND);
    }
}

$stmt->close();
$conn->close();

$output = "Reminders checked at " . date('Y-m-d H:i:s') . ". Sent to {$sentCount} recipient(s).";
echo $output;
file_put_contents($logFile, $output . "\n\n", FILE_APPEND);
?>
