<?php
session_start();

require_once $_SERVER['DOCUMENT_ROOT'] . '/Smile-ify/includes/config.php';
require_once BASE_PATH . '/includes/header.php';
require_once BASE_PATH . '/includes/db.php';

$query = $conn->query("
    SELECT 
        a.title,
        a.description,
        a.type,
        ba.start_date,
        ba.end_date,
        ba.status,
        ba.branch_id,
        b.address
    FROM announcements a
    INNER JOIN branch_announcements ba 
        ON a.announcement_id = ba.announcement_id
    INNER JOIN branch b 
        ON ba.branch_id = b.branch_id
    WHERE ba.status = 'Active'
    ORDER BY ba.date_created DESC
    LIMIT 5
");

$announcements = $query->fetch_all(MYSQLI_ASSOC);

$loginSuccess = '';
$loginError = '';
$otpError = '';
$usernameError = '';
$showForgotPasswordModal = false;

if (isset($_SESSION['show_forgot_modal'])) {
    $showForgotPasswordModal = true;
    unset($_SESSION['show_forgot_modal']);
}
if (isset($_SESSION['login_success'])) {
    $loginSuccess = $_SESSION['login_success'];
    unset($_SESSION['login_success']);
}
if (isset($_SESSION['login_error'])) {
    $loginError = $_SESSION['login_error'];
    unset($_SESSION['login_error']);
}
if (isset($_SESSION['otp_error'])) {
    $otpError = $_SESSION['otp_error'];
    unset($_SESSION['otp_error']);
}
if (isset($_SESSION['username_error'])) {
    $usernameError = $_SESSION['username_error'];
    unset($_SESSION['username_error']);
}
if (isset($_SESSION['timeoutError'])) {
    $timeoutError = $_SESSION['timeoutError'];
    unset($_SESSION['timeoutError']);
}

?>
<head>    
    <title>Welcome!</title>
</head>

<script>
document.addEventListener("DOMContentLoaded", function () {
    <?php if (!empty($usernameError) && $showForgotPasswordModal): ?>
        openForgotPasswordModal();
    <?php endif; ?>
});
</script>

<body>

    <div class="main-container">
        <div class="motto-container">
            <p class="motto">Creating vibrant smile for healthy lifestyle!</p>
        </div>

        <div class="login-container">
            <img src="<?= BASE_URL ?>/images/logo/logo_default.png" alt="Logo" class="logo" />
            
            <?php if (!empty($loginSuccess)): ?>
                <div class="success flash-msg"><?php echo htmlspecialchars($loginSuccess); ?></div>
            <?php endif; ?>

            <?php if (!empty($loginError)): ?>
                <div class="error flash-msg"><?php echo htmlspecialchars($loginError); ?></div>
            <?php endif; ?>

            <?php if (!empty($otpError)): ?>
                <div class="error flash-msg"><?php echo htmlspecialchars($otpError); ?></div>
            <?php endif; ?>

            <?php if (!empty($timeoutError)): ?>
                <div class="error flash-msg"><?php echo htmlspecialchars($timeoutError); ?></div>
            <?php endif; ?>

            <form action="<?= BASE_URL ?>/processes/OTP Processes/login/request_otp_login.php" method="POST" autocomplete="off">
                <div class="form-group">
                    <input type="text" id="userName" name="userName" class="form-control" placeholder=" " required autocomplete="off"/>
                    <label for="userName" class="form-label">Username</label>
                </div>

                <div class="form-group">
                    <input type="password" id="passWord" name="passWord" class="form-control" placeholder=" " required/>
                    <label for="passWord" class="form-label">Password</label>
                    <span onclick="togglePassword('passWord')" style="position: absolute; top: 50%; right: 12px; transform: translateY(-50%); cursor: pointer; font-size: 14px;">👁</span>
                </div>

                <div style="text-align: right; margin-bottom: 10px;">
                    <button type="button" class="forgot-password-link" onclick="openForgotPasswordModal()">
                        Forgot password?
                    </button>
                </div>

                <button type="submit" class="form-button">Sign In</button>
                <div class="divider"><span>or</span></div>
                <button type="button" class="form-button"  onclick="openBookingModal()">Book an Appointment</button>
            </form>
        </div>
    </div>

    <div id="bookingModal" class="booking-modal">
        <div class="booking-modal-content">
            
            <form action="<?= BASE_URL ?>/processes/OTP Processes/request_otp.php" method="POST" autocomplete="off">
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
                    <span id="dobError" class="error-msg-calendar error" style="display: none;">
                        Date of birth cannot be in the future.
                    </span>
                </div>

                <div class="form-group phone-group">
                    <input type="tel" id="contactNumber" name="contactNumber" class="form-control" oninput="this.value = this.value.replace(/[^0-9]/g, '')" pattern="[0-9]{10}" title="Mobile number must be 10 digits" required maxlength="10" />
                    <label for="contactNumber" class="form-label">Mobile Number <span class="required">*</span></label>
                    <span class="phone-prefix">+63</span>
                </div>

                <div class="form-group">
                    <select id="appointmentBranch" name="appointmentBranch" class="form-control" required>
                        <option value="" disabled selected hidden></option>
                        <?php

                        $sql = "SELECT branch_id, name, status FROM branch WHERE status = 'Active' ";
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
                    <span id="dateError" class="error-msg-calendar error">
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
                    <textarea id="notes" name="notes" class="form-control" rows="3" placeholder=" "autocomplete="off"></textarea>
                    <label for="notes" class="form-label">Add a note</label>
                </div>

                <div class="button-group">
                    <button type="submit" class="form-button confirm-btn">Confirm</button>
                    <button type="button" class="form-button cancel-btn" onclick="closeBookingModal()">Cancel</button>
                </div>
            </form>
        </div>
    </div>

    <div id="forgotpasswordModal" class="forgot-password-modal">
        <div class="forgot-password-modal-content">
            <?php if (!empty($usernameError)): ?>
                <div class="error"><?php echo htmlspecialchars($usernameError); ?></div>
            <?php endif; ?>
            <form action="<?= BASE_URL ?>/processes/OTP Processes/forgot_password/request_otp_forgot_password.php" method="POST">
                <div class="form-group">
                    <input type="text" id="username" name="username" class="form-control" placeholder=" " required autocomplete="off"/>
                    <label for="username" class="form-label">Enter Username <span class="required">*</span></label>
                </div>

                <div class="button-group">
                    <button type="submit" class="form-button confirm-btn">Confirm</button>
                    <button type="button" class="form-button cancel-btn" onclick="closeForgotPasswordModal()">Cancel</button>
                </div>
            </form>
        </div>
    </div>

    <div class="tagline-container">
        <div class="column1" style="background-color: #e7c6ff">
            <img src="<?= BASE_URL ?>/images/icons/experienced_dentist.png" alt="Experienced Dentist">
            <h2>Experienced Dentist</h2>
            <p>With the team's expertise, your smile is in the best hands possible.</p>
        </div>
        <div class="column2" style="background-color: #c8b6ff">
            <img src="<?= BASE_URL ?>/images/icons/advance_treament.png" alt="Advance Treatment">
            <h2>Advance Treatment</h2>
            <p>Backed by expertise and advanced technology, our team ensures your satisfaction.</p>
        </div>
        <div class="column3" style="background-color: #b8c0ff">
            <img src="<?= BASE_URL ?>/images/icons/guaranteed_results.png" alt="Guaranteed Results">
            <h2>Guaranteed Results</h2>
            <p>Skilled team and techniques ensure your smile transformation is delivered.</p>
        </div>
        <div class="column4" style="background-color: #bbd0ff">
            <img src="<?= BASE_URL ?>/images/icons/affordable_rates.png" alt="Affordable Rates">
            <h2>Affordable Rates</h2>
            <p>Offers affordable rates and top-notch care, so you get the best of both worlds.</p>
        </div>
    </div>

    <div class="center-button">
        <a href="#" onclick="openDentistsModal()" class="educational-button">
            Available Dentists
        </a>
    </div>

    <div id="dentistsModal" class="booking-modal">
        <div class="booking-modal-content">
            <h2>Available Dentists</h2>
            <p>Below is the list of dentists, their assigned branches, schedules and services.</p>

            <div id="dentistsContainer" style="max-height: 400px; overflow-y: auto;">
                <p>Loading dentists...</p>
            </div>

            <div class="button-group">
                <button type="button" class="cancel-btn" onclick="closeDentistsModal()">Close</button>
            </div>
        </div>
    </div>
                    
    <div class="welcome-container">
        <div class="welcome-text">We are open and welcoming, Patients!</div>
    </div>

    <p class="description">
        Make the best choice for your dental health – choose us.
    </p>

    <div class="service-container">
        <div class="grid">
            <div class="image-column">
                <img src="<?= BASE_URL ?>/images/services/checkup.jpg" alt="Check Up and Cleaning">
                <p>Check Up and Cleaning</p>
            </div>
            <div class="image-column">
                <img src="<?= BASE_URL ?>/images/services/root_canal.jpg" alt="Root Canal">
                <p>Root Canal</p>
            </div>
            <div class="image-column">
                <img src="<?= BASE_URL ?>/images/services/crown.jpg" alt="Crown">
                <p>Crown</p>
            </div>
            <div class="image-column">
                <img src="<?= BASE_URL ?>/images/services/veneers.jpg" alt="Veneers">
                <p>Veneers</p>
            </div>
            <div class="image-column">
                <img src="<?= BASE_URL ?>/images/services/index_brace.jpg" alt="Braces">
                <p>Braces</p>
            </div>
            <div class="image-column">
                <img src="<?= BASE_URL ?>/images/services/denture.jpg" alt="Dentures and Porcelain">
                <p>Dentures and Porcelain</p>
            </div>
        </div>
    </div>

    <div class="promo-container">
        <div class="welcome-text">Promos</div>
        <div class="promos swiper promo-slider">
            <div class="swiper-wrapper" id="promoWrapper">
                <!-- promos will be loaded here via JS -->
            </div>

            <div class="swiper-pagination"></div>
            <div class="swiper-button-next"></div>
            <div class="swiper-button-prev"></div>
        </div>
    </div>

    <div class="aboutus-wrapper">
        <div class="aboutus-info">
            <p class="aboutus-heading">About Us</p>
                <p class="aboutus-paragraph">
                    Arriesgado Dental Clinic is a busy dental practice that serves a large patient population in Cebu City, Philippines. We have three (3) branches located in Babag Lapu-Lapu City, Pusok Lapu-Lapu City and Mandaue City. We offer a wide range of dental services, including general dentistry and orthodontics. <br><br>
                    Our commitment to quality means that we use only the best materials and techniques to ensure that our services meet your expectations and exceed them. <br><br>
                    Our convenient location means that you won't have to travel far to take advantage of our services, making it easy for you to fit us into your busy schedule. <br><br>
                    So whether you're looking for a regular dental check up or a complete dental rehabilitation, we've got you covered.
                </p>
            <div class="educational-container">
                <button onclick="openEducationalModal()" class="educational-button" id="openEducationalModal">View Infographics</button>
            </div>
        </div>
        
        <div class="announcement-panel">
            <h3 class="announce-title">Announcements</h3>

            <?php if (empty($announcements)): ?>
                <p>No announcements.</p>
            <?php else: ?>

                <?php foreach ($announcements as $item): ?>

                    <?php
                        $start = $item['start_date'] ? date("F j, Y", strtotime($item['start_date'])) : null;
                        $end   = $item['end_date'] ? date("F j, Y", strtotime($item['end_date'])) : null;

                        if ($start && $end) {
                            if ($item['start_date'] === $item['end_date']) {
                                $dateDisplay = "On: $start";
                            } else {
                                $dateDisplay = "From: $start to $end";
                            }
                        } else {
                            $dateDisplay = "";
                        }
                    ?>

                    <div class="announcement-card">
                        <h4><?= htmlspecialchars($item['title']) ?></h4>
                        <p><?= htmlspecialchars($item['description']) ?></p>

                        <small>
                            <?= $dateDisplay ?><br>
                            Branch: <?= htmlspecialchars($item['address']) ?>
                        </small>
                    </div>

                <?php endforeach; ?>

            <?php endif; ?>
        </div>
    </div>

    <div id="promoModal" class="promo-modal">
        <div class="promo-modal-content">
            <img id="promoModalImg" src="" alt="Promo Image" class="modal-img">
            <div class="modal-details">
                <h3 id="promoTitle"></h3>
                <p id="promoDesc"></p>
                <p id="promoDate"></p>
                <p id="promoBranch"></p>
            </div>
        </div>
    </div>

    <div id="educationalModal" class="educational-modal">
        <div class="educational-modal-content" id="educationalModalContent">
        </div>
    </div>


    <?php require_once BASE_PATH . '/includes/footer.php'; ?>
</body>

<script>
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
