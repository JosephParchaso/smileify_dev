<?php
session_start();

require_once $_SERVER['DOCUMENT_ROOT'] . '/Smile-ify/includes/config.php';
require_once BASE_PATH . '/includes/db.php';

if (!isset($_SESSION['user_id']) || $_SESSION['role'] !== 'owner') {
    echo json_encode(["data" => []]);
    exit();
}

$sql = "SELECT 
            d.dentist_id,
            CONCAT(d.first_name, ' ', IFNULL(d.middle_name, ''), ' ', d.last_name) AS name,
            GROUP_CONCAT(DISTINCT b.nickname ORDER BY b.nickname SEPARATOR ', ') AS branches,
            d.status
        FROM dentist d
        LEFT JOIN dentist_branch db ON d.dentist_id = db.dentist_id
        LEFT JOIN branch b ON db.branch_id = b.branch_id
        GROUP BY d.dentist_id
        ORDER BY d.last_name ASC";

$result = $conn->query($sql);

$dentists = [];
while ($row = $result->fetch_assoc()) {
    $dentists[] = [
        $row['dentist_id'],
        'Dr. ' . $row['name'], 
        ($row['branches'] ?? '-'),
        $row['status'],
        '<button class="btn-action" data-type="dentist" data-id="'.$row['dentist_id'].'">Manage</button>',
    ];
}

header('Content-Type: application/json');
echo json_encode(["data" => $dentists]);
$conn->close();
