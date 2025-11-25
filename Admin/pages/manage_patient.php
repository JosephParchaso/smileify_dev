<?php
session_start();

$currentPage = 'patients';
require_once $_SERVER['DOCUMENT_ROOT'] . '/Smile-ify/includes/config.php';

if (!isset($_SESSION['user_id']) || $_SESSION['role'] !== 'admin') {
    session_unset();
    session_destroy();
    header("Location: " . BASE_URL . "/index.php");
    exit();
}

require_once BASE_PATH . '/includes/header.php';
require_once BASE_PATH . '/Admin/includes/navbar.php';

$userId = $_GET['id'] ?? null;
if (!$userId) {
    echo "<p>No patient selected.</p>";
    require_once BASE_PATH . '/includes/footer.php';
    exit();
}
$updateSuccess = $_SESSION['updateSuccess'] ?? "";
$updateError   = $_SESSION['updateError'] ?? "";

$backTab = $_GET['tab'] ?? 'recent';
?>
<title>Patient Details</title>

<div class="profile-container">
    <div class="profile-section">

        <div class="back-button-container">
            <a href="<?= BASE_URL ?>/Admin/pages/patients.php?tab=<?= htmlspecialchars($backTab) ?>" class="back-button-icon">
                <span class="material-symbols-outlined">arrow_back</span>
            </a>
        </div>

        <div class="profile-card" id="patientCard">
            <p>Loading profile...</p>
        </div>
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

    <div class="tabs-container">
        <div class="tabs-patient">
            <div class="tab active" onclick="switchTab('appointment_history')">Appointment History</div>
            <div class="tab" onclick="switchTab('dental_transaction')">Dental Transactions</div>
        </div> 

        <div class="tab-content active" id="appointment_history">
            <table id="appointmentTable" class="transaction-table">
            </table>
        </div>

        <div class="tab-content" id="dental_transaction">
            <table id="transactionTable" class="transaction-table">
            </table>
        </div>
    </div>

    <div id="manageModal" class="manage-calendar-modal">
        <div class="manage-calendar-modal-content">
            <div id="modalBody" class="manage-calendar-modal-content-body">
                <!-- Appointment info will be loaded here -->
            </div>
        </div>
    </div>

    <div id="transactionModal" class="transaction-record-modal">
        <div class="transaction-record-modal-content">
            <div id="transactionModalBody">
                <!-- Transaction info will be loaded here -->
            </div>
        </div>
    </div>
</div>

<div id="setStatusModal" class="edit-profile-modal">
    <div class="edit-profile-modal-content">
        <form id="statusForm" method="POST" action="<?= BASE_URL ?>/Admin/processes/manage_patient/update_status.php" autocomplete="off">
            <input type="hidden" name="user_id" id="statusUserId">
            <input type="hidden" name="status" id="statusValue">

            <p id="statusMessage">Are you sure you want to update this patient’s status?</p>

            <div class="button-group">
                <button type="submit" class="form-button confirm-btn">Confirm</button>
                <button type="button" class="form-button cancel-btn" onclick="closeStatusModal()">Cancel</button>
            </div>
        </form>
    </div>
</div>

<div id="manageAppointmentModal" class="manage-patient-modal">
    <div class="manage-patient-modal-content">
        <div id="appointmentModalBody" class="manage-patient-modal-content-body">
            <!-- Appointment Booking info will be loaded here -->
        </div>
    </div>
</div>

<div id="medCertModal" class="manage-patient-modal">
    <div class="manage-patient-modal-content">
        <h2>Dental Certificate</h2>

        <form id="medCertForm" method="POST" action="<?= BASE_URL ?>/Admin/processes/manage_patient/upload_medcert.php" enctype="multipart/form-data" autocomplete="off">
        <input type="hidden" name="dental_transaction_id" id="transactionIdInput">

        <div id="receiptPreview" style="text-align:center; margin:15px 0; display:flex; justify-content:center;">
            <img id="receiptImage" alt="Payment QR Code" style="width: 250px; height: 440px;">
        </div>

        <div id="paymentSection" style="display: none;">
            <div class="form-group">
                <select id="paymentMethod" name="payment_method" class="form-control" required>
                    <option value="">Select Payment Method</option>
                    <option value="cash">Cash</option>
                    <option value="cashless">Cashless</option>
                </select>
                <label for="paymentMethod" class="form-label">Payment Method <span class="required">*</span></label>
            </div>

            <div class="form-group" id="receiptUploadGroup" style="display: none;">
                <input type="file" id="receiptUpload" name="receipt_upload" class="form-control" accept="image/*">
                <label for="receiptUpload" class="form-label">Upload Receipt (if Cashless)</label>
            </div>

            <div class="form-group">
                <textarea id="notesMedcert" name="medcert_notes" class="form-control" placeholder=" "></textarea>
                <label for="notesMedcert" class="form-label">Notes</label>
            </div>
        </div>

        <div class="form-group">
            <input type="text" id="fitnessStatus" name="fitness_status" class="form-control" placeholder=" " required />
            <label for="fitnessStatus" class="form-label">Period of Rest <span class="required">*</span></label>
        </div>

        <div class="form-group">
            <input type="text" id="diagnosis" name="diagnosis" class="form-control" placeholder=" " required />
            <label for="diagnosis" class="form-label">Diagnosis <span class="required">*</span></label>
        </div>

        <div class="form-group">
            <textarea id="remarks" name="remarks" class="form-control" placeholder=" " required></textarea>
            <label for="remarks" class="form-label">Remarks <span class="required">*</span></label>
        </div>

        <div class="button-group">
            <button type="submit" class="confirm-btn">Save</button>
        </div>
        </form>
    </div>
</div>

<div id="imageModal" class="promo-modal">
    <div class="promo-modal-content">
        <img id="imageModalContent" src="" alt="Receipt Preview">
    </div>
</div>

<div id="medCertReceiptModal" class="booking-modal">
    <div class="booking-modal-content" id="medCertReceiptBody">
        <!-- Receipt will be loaded dynamically -->
    </div>
</div>

<script>
    const userId = "<?= htmlspecialchars($userId) ?>";

    document.addEventListener("DOMContentLoaded", () => {
        const receiptImage = document.getElementById("receiptImage");
        const imageModal = document.getElementById("imageModal");
        const imageModalContent = document.getElementById("imageModalContent");

        if (receiptImage) {
            receiptImage.addEventListener("click", () => {
                if (receiptImage.src) {
                    imageModalContent.src = receiptImage.src;
                    imageModal.style.display = "flex";
                }
            });
        }

        imageModal.addEventListener("click", () => {
            imageModal.style.display = "none";
        });
    });
    
    function closeMedCertReceiptModal() {
        document.getElementById("medCertReceiptModal").style.display = "none";
    }

    document.addEventListener("click", (e) => {
        const modal = document.getElementById("medCertReceiptModal");
        if (e.target === modal) closeMedCertReceiptModal();
    });
</script>

<?php require_once BASE_PATH . '/includes/footer.php'; ?>
