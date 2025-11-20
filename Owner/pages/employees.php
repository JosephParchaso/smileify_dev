<?php
session_start();

$currentPage = 'employees';
require_once $_SERVER['DOCUMENT_ROOT'] . '/Smile-ify/includes/config.php';

if (!isset($_SESSION['user_id']) || $_SESSION['role'] !== 'owner') {
    session_unset();
    session_destroy();
    header("Location: " . BASE_URL . "/index.php");
    exit();
}
require_once BASE_PATH . '/includes/header.php';
require_once BASE_PATH . '/Owner/includes/navbar.php';
$activeTab = $_GET['tab'] ?? 'admin';
$updateSuccess = $_SESSION['updateSuccess'] ?? '';
$updateError   = $_SESSION['updateError'] ?? '';
?>
<title>Employees</title>

<div class="tabs-container">
    <div class="tabs">
        <div class="tab <?= $activeTab === 'admin' ? 'active' : '' ?>" onclick="switchTab('admin')">Secretaries</div>
        <div class="tab <?= $activeTab === 'dentist' ? 'active' : '' ?>" onclick="switchTab('dentist')">Dentists</div>
    </div>
    
    <?php if (!empty($updateSuccess) || !empty($updateError)): ?>
        <div id="toastContainer">
            <?php if (!empty($updateSuccess)): ?>
                <div class="toast success"><?= htmlspecialchars($updateSuccess) ?></div>
                <?php unset($_SESSION['updateSuccess']); ?>
            <?php endif; ?>

            <?php if (!empty($updateError)): ?>
                <div class="toast error"><?= htmlspecialchars($updateError) ?></div>
                <?php unset($_SESSION['updateError']); ?>
            <?php endif; ?>
        </div>
    <?php endif; ?>

    <div class="tab-content <?= $activeTab === 'admin' ? 'active' : '' ?>" id="admin">
        <table id="adminsTable" class="transaction-table"></table>
    </div>

    <div class="tab-content <?= $activeTab === 'dentist' ? 'active' : '' ?>" id="dentist">
        <table id="dentistsTable" class="transaction-table"></table>
    </div>
</div>

<div id="manageModal" class="manage-employee-modal">
    <div class="manage-employee-modal-content">
        <div id="modalBody" class="manage-employee-modal-content-body">
            <!-- Appointment info will be loaded here -->
        </div>
    </div>
</div>

<?php require_once BASE_PATH . '/includes/footer.php'; ?>
