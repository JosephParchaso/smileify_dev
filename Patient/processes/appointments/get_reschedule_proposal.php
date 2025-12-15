<?php
session_start();
require_once $_SERVER['DOCUMENT_ROOT'] . '/Smile-ify/includes/config.php';
require_once BASE_PATH . '/includes/db.php';

if (!isset($_SESSION['user_id'])) {
    echo json_encode(["success" => false, "message" => "Unauthorized"]);
    exit;
}

$userId = (int)$_SESSION['user_id'];
$appointmentId = (int)($_GET['appointment_id'] ?? 0);

if ($appointmentId <= 0) {
    echo json_encode([
        "success" => false,
        "message" => "Invalid appointment reference."
    ]);
    exit;
}

$appt = $conn->query("
    SELECT 
        at.appointment_transaction_id,
        at.branch_id,
        b.name AS branch_name,
        at.appointment_date,
        at.appointment_time,
        CONCAT(u.first_name,' ',u.last_name) AS patient_name,
        CONCAT(d.first_name,' ',d.last_name) AS original_dentist
    FROM appointment_transaction at
    JOIN branch b ON b.branch_id = at.branch_id
    JOIN users u ON u.user_id = at.user_id
    JOIN dentist d ON d.dentist_id = at.dentist_id
    WHERE at.appointment_transaction_id = $appointmentId
    AND at.status = 'Pending Reschedule'
    AND (
        at.user_id = $userId
        OR u.guardian_id = $userId
    )
    LIMIT 1
")->fetch_assoc();

if (!$appt) {
    echo json_encode([
        "success" => false,
        "message" => "No pending appointment found."
    ]);
    exit;
}

$originalBranch = (int)$appt['branch_id'];

$serviceIds = [];
$resSvc = $conn->query("
    SELECT service_id
    FROM appointment_services
    WHERE appointment_transaction_id = $appointmentId
");
while ($r = $resSvc->fetch_assoc()) {
    $serviceIds[] = (int)$r['service_id'];
}
if (empty($serviceIds)) {
    echo json_encode(["success" => false, "message" => "Appointment has no services assigned."]);
    exit;
}
$serviceIdList = implode(',', $serviceIds);

$timeSlots = [
    '09:00:00','09:30:00','10:00:00','10:30:00','11:00:00','11:30:00',
    '13:00:00','13:30:00','14:00:00','14:30:00','15:00:00','15:30:00'
];

$datesToCheck = [];
$start = new DateTime($appt['appointment_date']);
$start->modify('+1 day'); 

for ($i = 0; $i < 14; $i++) {
    $d = clone $start;
    $d->modify("+$i day");
    $datesToCheck[] = $d;
}

$foundInOriginalBranch = false;

foreach ($datesToCheck as $date) {
    $dateStr = $date->format('Y-m-d');

    $branches = $conn->query("
        SELECT branch_id, name
        FROM branch
        WHERE status = 'Active'
        ORDER BY (branch_id = $originalBranch) DESC
    ");

    while ($b = $branches->fetch_assoc()) {
        if ($foundInOriginalBranch && $b['branch_id'] != $originalBranch) {
            continue;
        }

        $dayName = $date->format('l');

        $closedRes = $conn->query("
            SELECT 1
            FROM branch_announcements ba
            JOIN announcements a ON a.announcement_id = ba.announcement_id
            WHERE a.type = 'Closed'
                AND ba.status = 'Active'
                AND ba.branch_id = {$b['branch_id']}
                AND ba.start_date <= '$dateStr'
                AND ba.end_date >= '$dateStr'
            LIMIT 1
        ");
        if ($closedRes && $closedRes->num_rows > 0) continue;

        $dentists = $conn->query("
            SELECT 
                d.dentist_id,
                CONCAT(d.first_name,' ',d.last_name) AS name,
                MAX(ds.start_time) AS start_time,
                MIN(ds.end_time)   AS end_time
            FROM dentist d
            JOIN dentist_branch db ON db.dentist_id = d.dentist_id
            JOIN dentist_schedule ds
                ON ds.dentist_id = d.dentist_id
                AND ds.branch_id = db.branch_id
            WHERE d.status = 'Active'
                AND db.branch_id = {$b['branch_id']}
                AND ds.day = '$dayName'
            GROUP BY d.dentist_id
        ");

        while ($d = $dentists->fetch_assoc()) {

            $chk = $conn->query("
                SELECT COUNT(DISTINCT service_id) AS cnt
                FROM dentist_service
                WHERE dentist_id = {$d['dentist_id']}
                    AND service_id IN ($serviceIdList)
            ")->fetch_assoc();
            if ((int)$chk['cnt'] !== count($serviceIds)) continue;

            $booked = [];
            $res = $conn->query("
                SELECT appointment_time
                FROM appointment_transaction
                WHERE branch_id = {$b['branch_id']}
                    AND dentist_id = {$d['dentist_id']}
                    AND appointment_date = '$dateStr'
                    AND status = 'Booked'
            ");
            while ($r = $res->fetch_assoc()) {
                $booked[$r['appointment_time']] = true;
            }

            foreach ($timeSlots as $slot) {

                if ($slot < $d['start_time'] || $slot >= $d['end_time']) continue;
                if (isset($booked[$slot])) continue;

                if ($b['branch_id'] == $originalBranch) {
                    $foundInOriginalBranch = true;
                }

                echo json_encode([
                    "success" => true,
                    "appointment_id" => $appointmentId,
                    "patient" => $appt['patient_name'],
                    "original_branch" => $appt['branch_name'],
                    "original_date" => date('F d, Y', strtotime($appt['appointment_date'])),
                    "original_time" => date('h:i A', strtotime($appt['appointment_time'])),
                    "original_dentist" => $appt['original_dentist'],
                    "branch_id" => $b['branch_id'],
                    "branch" => $b['name'],
                    "dentist_id" => $d['dentist_id'],
                    "dentist" => $d['name'],
                    "date" => date('F d, Y', strtotime($dateStr)),
                    "time" => date('h:i A', strtotime($slot)),
                    "date_raw" => $dateStr,
                    "time_raw" => $slot
                ]);
                exit;
            }
        }
    }
}

echo json_encode([
    "success" => false,
    "message" => "No available slots found in the next 14 days."
]);
