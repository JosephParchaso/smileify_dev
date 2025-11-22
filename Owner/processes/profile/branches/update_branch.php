<?php
session_start();
require_once $_SERVER['DOCUMENT_ROOT'] . '/Smile-ify/includes/config.php';
require_once BASE_PATH . '/includes/db.php';

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    if (!isset($_SESSION['user_id']) || $_SESSION['role'] !== 'owner') {
        $_SESSION['updateError'] = "Unauthorized access.";
        header("Location: " . BASE_URL . "/index.php");
        exit;
    }

    $branch_id     = intval($_POST["branch_id"] ?? 0);
    $branchName    = trim($_POST["branchName"] ?? "");
    $nickname      = trim($_POST["nickname"] ?? "");
    $address       = trim($_POST["address"] ?? "");
    $phone_number  = trim($_POST["contactNumber"] ?? "");
    $map_url       = trim($_POST["map_url"] ?? "");
    $status        = $_POST["status"] ?? "Active";

    try {
        $check_sql = "SELECT name, nickname, address, phone_number, status, map_url
                        FROM branch
                        WHERE branch_id = ?";
        $check_stmt = $conn->prepare($check_sql);
        $check_stmt->bind_param("i", $branch_id);
        $check_stmt->execute();
        $current = $check_stmt->get_result()->fetch_assoc();
        $check_stmt->close();

        if (!$current) {
            $_SESSION['updateError'] = "Branch not found.";
        } else {
            if (
                $current['name'] !== $branchName ||
                $current['nickname'] !== $nickname ||
                $current['address'] !== $address ||
                $current['phone_number'] !== $phone_number ||
                $current['status'] !== $status ||
                $current['map_url'] !== $map_url
            ) {
                $sql = "UPDATE branch 
                        SET name = ?, 
                            nickname = ?, 
                            address = ?, 
                            phone_number = ?, 
                            status = ?, 
                            map_url = ?,
                            date_updated = NOW()
                        WHERE branch_id = ?";
                $stmt = $conn->prepare($sql);
                if (!$stmt) {
                    throw new Exception("Prepare failed: " . $conn->error);
                }

                $stmt->bind_param(
                    "ssssssi",
                    $branchName, $nickname, $address, $phone_number,
                    $status, $map_url, $branch_id
                );

                if ($stmt->execute() && $stmt->affected_rows > 0) {
                    $_SESSION['updateSuccess'] = "Branch updated successfully!";
                }

                $stmt->close();
            }
        }
    } catch (Exception $e) {
        $_SESSION['updateError'] = "Database error: " . $e->getMessage();
    }

    header("Location: " . BASE_URL . "/Owner/pages/profile.php");
    exit;
} else {
    header("Location: " . BASE_URL . "/index.php");
    exit;
}

$conn->close();
