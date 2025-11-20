<?php
session_start();

require_once $_SERVER['DOCUMENT_ROOT'] . '/Smile-ify/includes/config.php';
require_once BASE_PATH . '/includes/db.php';

if (!isset($_SESSION['user_id']) || $_SESSION['role'] !== 'admin') {
    session_unset();
    session_destroy();
    header("Location: " . BASE_URL . "/index.php");
    exit();
}

$currentPage = 'index';

$updateSuccess = $_SESSION['updateSuccess'] ?? "";
$updateError = $_SESSION['updateError'] ?? "";

require_once BASE_PATH . '/includes/header.php';
require_once BASE_PATH . '/Admin/includes/navbar.php';
?>

<title>Home</title>

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

<div class="dashboard">
    <div class="cards">
        <div class="card">
            <h2><span class="material-symbols-outlined">calendar_month</span> Upcoming Appointments</h2>
            <div class="appointment">Today: <span id="todayCount">0</span></div>
            <div class="appointment">This Week: <span id="weekCount">0</span></div>
            <div class="appointment">This Month: <span id="monthCount">0</span></div>
            <a href="<?= BASE_URL ?>/Admin/pages/calendar.php" class="card-link">View Calendar</a>
            <a href="#" class="card-link" onclick="openBookingModal()"><span class="material-symbols-outlined">calendar_add_on</span> Book Appointment</a>
        </div>  
        
        <div id="bookingModal" class="booking-modal">
            <div class="booking-modal-content">
                
                <form action="<?= BASE_URL ?>/Admin/processes/index/insert_appointment.php" method="POST" autocomplete="off">
                    <div class="form-group">
                        <input type="text" id="lastName" name="lastName" class="form-control" placeholder=" " required />
                        <label for="lastName" class="form-label">Last Name <span class="required">*</span></label>
                    </div>

                    <div class="form-group">
                        <input type="text" id="firstName" name="firstName" class="form-control" placeholder=" " required />
                        <label for="firstName" class="form-label">First Name <span class="required">*</span></label>
                    </div>

                    <div class="form-group">
                        <input type="text" id="middleName" name="middleName" class="form-control" placeholder=" " />
                        <label for="middleName" class="form-label">Middle Name</label>
                    </div>

                    <div class="form-group">
                        <input type="email" id="email" name="email" class="form-control" placeholder=" " required autocomplete="off"/>
                        <label for="email" class="form-label">Email Address <span class="required">*</span></label>
                    </div>
                    
                    <div class="form-group">
                        <select id="gender" name="gender" class="form-control" required>
                            <option value="" disabled selected hidden></option>
                            <option value="female">Female</option>
                            <option value="male">Male</option>
                        </select>
                        <label for="gender" class="form-label">Gender <span class="required">*</span></label>
                    </div>

                    <div class="form-group">
                        <input type="date" id="dateofBirth" name="dateofBirth" class="form-control" required />
                        <label for="dateofBirth" class="form-label">Date of Birth <span class="required">*</span></label>
                        <span id="dobError" class="error-msg-calendar error" style="display: none;"></span>
                    </div>

                    <div class="form-group phone-group">
                        <input type="tel" id="contactNumber" name="contactNumber" class="form-control" 
                            oninput="this.value = this.value.replace(/[^0-9]/g, '')" 
                            pattern="[0-9]{10}" title="Mobile number must be 10 digits" 
                            required maxlength="10" />
                        <label for="contactNumber" class="form-label">Mobile Number <span class="required">*</span></label>
                        <span class="phone-prefix">+63</span>
                    </div>

                    <div class="form-group">
                        <select id="appointmentBranch" name="appointmentBranch" class="form-control" required>
                            <option value="" disabled selected hidden></option>
                            <?php
                            $sql = "SELECT branch_id, name, status FROM branch WHERE status = 'Active'";
                            $result = $conn->query($sql);

                            if ($result->num_rows > 0) {
                                while($row = $result->fetch_assoc()) {
                                    echo "<option value='" . $row["branch_id"] . "'>" . htmlspecialchars($row["name"]) . "</option>";
                                }
                            } else {
                                echo "<option disabled>No branches available</option>";
                            }
                            ?>
                        </select>
                        <label for="appointmentBranch" class="form-label">Branch <span class="required">*</span></label>
                    </div>

                    <div class="form-group">
                        <input type="date" id="appointmentDate" name="appointmentDate" class="form-control" required />
                        <label for="appointmentDate" class="form-label">Date <span class="required">*</span></label>
                        <span id="dateError" class="error-msg-calendar error" style="display:none;">
                            Sundays are not available for appointments. Please select another date.
                        </span>
                    </div>

                    <div class="form-group">
                        <select id="appointmentTime" name="appointmentTime" class="form-control" required></select>
                        <label for="appointmentTime" class="form-label">Time <span class="required">*</span></label>
                        <div id="estimatedEnd" class="text-gray-600 mt-2"></div>
                    </div>

                    <div class="form-group">
                        <div id="servicesContainer" class="checkbox-group">
                            <p class="loading-text">Select a branch to load available services</p>
                        </div>
                    </div>

                    <div class="form-group">
                        <select id="appointmentDentist" name="appointmentDentist" class="form-control" required>
                            <option value="" disabled selected hidden></option>
                        </select>
                        <label for="appointmentDentist" class="form-label">Dentist <span class="required">*</span></label>
                    </div>

                    <div class="form-group">
                        <textarea id="notes" name="notes" class="form-control" rows="3" placeholder=" " autocomplete="off"></textarea>
                        <label for="notes" class="form-label">Add a note</label>
                    </div>

                    <div class="button-group">
                        <button type="submit" class="form-button confirm-btn">Confirm</button>
                        <button type="button" class="form-button cancel-btn" onclick="closeBookingModal()">Cancel</button>
                    </div>
                </form>
            </div>
        </div>

        <div class="card">
            <h2><span class="material-symbols-outlined">groups</span> Patients</h2>
            <div class="appointment">New This Month: <span id="newPatientsCount">0</span></div>
            <div class="appointment">Total: <span id="totalPatientsCount">0</span></div>
            <a href="<?= BASE_URL ?>/Admin/pages/patients.php" class="card-link">Manage Patients</a>
        </div>

        <div class="card">
            <h2><span class="material-symbols-outlined">inventory_2</span> Supplies</h2>
            <div id="lowSuppliesContainer">
                <div class="announcement">Loading</div>
            </div>
            <a href="<?= BASE_URL ?>/Admin/pages/supplies.php" class="card-link">Manage Supplies</a>
        </div>

        <div class="card">
            <h2><span class="material-symbols-outlined">bar_chart</span> Promo</h2>
            <div class="appointment">Total Availed: <span id="promoAvailedCount">0</span></div>
            <div id="promoAvailedList" class="announcement"></div>
            <a href="<?= BASE_URL ?>/Admin/pages/reports.php" class="card-link">View Detailed Reports</a>
        </div>

        <div class="card">
            <h2><span class="material-symbols-outlined">notifications</span> Recent Notifications</h2>

            <?php if (empty($notifications)): ?>
                <div class="announcement">No notifications</div>
            <?php else: ?>
                <?php foreach (array_slice($notifications, 0, 3) as $n): ?>
                    <div class="announcement <?= $n['is_read'] ? '' : 'unread' ?>">
                        <div class="notif-message"><?= htmlspecialchars($n['message']) ?></div>
                        <div class="notif-date"><?= date('M d, Y H:i', strtotime($n['date_created'])) ?></div>
                    </div>
                <?php endforeach; ?>
            <?php endif; ?>
        </div>

        <div class="card">
            <h2><span class="material-symbols-outlined">bolt</span> Quick Links</h2>
            <div class="quick-links">
                <a href="<?= BASE_URL ?>/Admin/pages/services.php"><span class="material-symbols-outlined">medical_services</span> Manage Services</a>
                <a href="<?= BASE_URL ?>/Admin/pages/promos.php"><span class="material-symbols-outlined">local_offer</span> Manage Promos</a>
                <a href="<?= BASE_URL ?>/Admin/pages/profile.php"><span class="material-symbols-outlined">manage_accounts</span> Profile Settings</a>
            </div>
        </div>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", () => {
        const adminBranchId = "<?= $_SESSION['branch_id'] ?? '' ?>";
        const branchSelect = document.getElementById("appointmentBranch");

        if (adminBranchId && branchSelect) {
            const observer = new MutationObserver(() => {
                const modal = document.getElementById("bookingModal");
                if (modal && modal.style.display === "block") {
                    const option = branchSelect.querySelector(`option[value='${adminBranchId}']`);
                    if (option && !branchSelect.value) {
                        option.selected = true;
                        branchSelect.dispatchEvent(new Event("change", { bubbles: true }));
                    }
                }
            });

            observer.observe(document.body, {
                attributes: true,
                subtree: true,
                attributeFilter: ["style", "class"]
            });
        }
    });
    
    document.addEventListener("DOMContentLoaded", function () {
        document.querySelectorAll("form").forEach(form => {
            form.addEventListener("submit", function () {
                const btn = form.querySelector("button[type='submit']");
                if (btn) {
                    btn.disabled = true;
                    btn.innerText = "Processing...";
                }
            });
        });
    });
</script>

<?php require_once BASE_PATH . '/includes/footer.php'; ?>
