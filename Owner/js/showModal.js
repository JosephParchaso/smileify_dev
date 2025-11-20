document.addEventListener("DOMContentLoaded", () => {
    const employeeModal = document.getElementById("manageModal");
    const employeeBody = document.getElementById("modalBody");

    const today = new Date();
    today.setHours(0, 0, 0, 0);

    const tomorrow = new Date(today);
    tomorrow.setDate(today.getDate() + 1);
    const tomorrowISO = tomorrow.toISOString().split("T")[0];

    document.body.addEventListener("focusin", function (e) {
        if (e.target && e.target.id === "dateofBirth") {
            e.target.setAttribute("min", "1900-01-01");
            e.target.setAttribute("max", today.toISOString().split("T")[0]);
        }

        if (e.target && e.target.id === "dateStarted") {
            e.target.setAttribute("min", tomorrowISO);
        }
    });

    document.body.addEventListener("change", function (e) {
        if (e.target && e.target.id === "dateStarted") {
            const dateInput = e.target;
            const errorEl = document.getElementById("dateError");

            if (dateInput.value) {
                const selectedDate = new Date(dateInput.value);
                selectedDate.setHours(0, 0, 0, 0);
                const day = selectedDate.getDay();

                const now = new Date();
                now.setHours(0, 0, 0, 0);
                const tomorrowCheck = new Date(now);
                tomorrowCheck.setDate(now.getDate() + 1);

                if (isNaN(selectedDate)) {
                    errorEl.textContent = "Please enter a valid date.";
                    errorEl.style.display = "block";
                    dateInput.value = "";
                } else if (selectedDate < tomorrowCheck) {
                    errorEl.textContent = "Please enter a valid date.";
                    errorEl.style.display = "block";
                    dateInput.value = "";
                } else if (day === 0) {
                    errorEl.textContent =
                        "Sundays are not available. Please select another date.";
                    errorEl.style.display = "block";
                    dateInput.value = "";
                } else {
                    errorEl.style.display = "none";
                }
            }
        }
    });

    document.body.addEventListener("click", function (e) {
        if (e.target.classList.contains("btn-action")) {
            const id = e.target.getAttribute("data-id");
            const type = e.target.getAttribute("data-type");

            let url = "";
            if (type === "admin") {
                url = `${BASE_URL}/Owner/processes/employees/get_admin_details.php?id=${id}`;
            } else if (type === "dentist") {
                url = `${BASE_URL}/Owner/processes/employees/get_dentist_details.php?id=${id}`;
            }

            fetch(url)
            .then(response => response.json())
            .then(data => {
                if (data.error) {
                    employeeBody.innerHTML = `<p style="color:red;">${data.error}</p>`;
                    employeeModal.style.display = "block";
                    return;
                }

                if (type === "admin") {
                    renderAdminForm(data);
                } else if (type === "dentist") {
                    renderDentistForm(data);
                }

                employeeModal.style.display = "block";
            })
            .catch(() => {
                employeeBody.innerHTML = `<p style="color:red;">Error loading details</p>`;
                employeeModal.style.display = "block";
            });
        }
    });

    document.body.addEventListener("click", function (e) {
        if (e.target.id === "addAdminBtn") {
            renderAdminForm(null);
            employeeModal.style.display = "block";
        }
        if (e.target.id === "addDentistBtn") {
            renderDentistForm(null);
            employeeModal.style.display = "block";
        }
    });

    function renderAdminForm(data) {
        const isEdit = !!data;
        employeeBody.innerHTML = `
            <h2>${isEdit ? "Manage Secretary" : "Add Secretary"}</h2>
            <form id="adminForm" action="${BASE_URL}/Owner/processes/employees/${isEdit ? "update_admin.php" : "insert_admin.php"}" method="POST" autocomplete="off">
                ${isEdit ? `<input type="hidden" name="user_id" value="${data.user_id}">` : ""}

                ${isEdit ? `
                <div class="form-group">
                    <input type="text" id="userName" class="form-control" value="${data.username}" disabled  autocomplete="off">
                    <label for="userName" class="form-label">Username</label>
                </div>` : ""}

                <div class="form-group">
                    <input type="text" id="lastName" name="lastName" class="form-control"
                        value="${isEdit ? data.last_name : ""}" required placeholder=" " autocomplete="off">
                    <label for="lastName" class="form-label">Last Name <span class="required">*</span></label>
                </div>

                <div class="form-group">
                    <input type="text" id="firstName" name="firstName" class="form-control"
                        value="${isEdit ? data.first_name : ""}" required placeholder=" " autocomplete="off">
                    <label for="firstName" class="form-label">First Name <span class="required">*</span></label>
                </div>

                <div class="form-group">
                    <input type="text" id="middleName" name="middleName" class="form-control"
                        value="${isEdit ? (data.middle_name || "") : ""}" placeholder=" " autocomplete="off">
                    <label for="middleName" class="form-label">Middle Name</label>
                </div>

                <div class="form-group">
                    <select id="gender" name="gender"  class="form-control" required>
                        <option value="" disabled selected hidden></option>
                        <option value="Male" ${isEdit && data.gender === "Male" ? "selected" : ""}>Male</option>
                        <option value="Female" ${isEdit && data.gender === "Female" ? "selected" : ""}>Female</option>
                    </select>
                    <label for="gender" class="form-label">Gender <span class="required">*</span></label>
                </div>

                <div class="form-group">
                    <input type="date" id="dateofBirth" name="dateofBirth" class="form-control"
                        value="${isEdit ? data.date_of_birth : ""}" required autocomplete="off">
                    <label for="dateofBirth" class="form-label">Date of Birth <span class="required">*</span></label>
                    <span id="dobError" class="error-msg-calendar error" style="display: none;"></span>
                </div>

                <div class="form-group">
                    <input type="email" id="email" name="email" class="form-control"
                        value="${isEdit ? data.email : ""}" required placeholder=" " autocomplete="off">
                    <label for="email" class="form-label">Email <span class="required">*</span></label>
                </div>

                <div class="form-group phone-group">
                    <input type="tel" id="contactNumber" name="contactNumber"  class="form-control"
                        value="${isEdit ? data.contact_number : ""}" oninput="this.value = this.value.replace(/[^0-9]/g, '')" pattern="[0-9]{10}" title="Mobile number must be 10 digits" required maxlength="10" autocomplete="off">
                    <label for="contactNumber" class="form-label">Mobile Number <span class="required">*</span></label>
                    <span class="phone-prefix">+63</span>
                </div>

                <div class="form-group">
                    <input type="text" id="address" name="address" class="form-control"
                        value="${isEdit ? data.address : ""}" required placeholder=" " autocomplete="off">
                    <label for="address" class="form-label">Address <span class="required">*</span></label>
                </div>

                <div class="form-group">
                    <select id="branchAssignment" name="branchAssignment" class="form-control" required>
                        <option value="" disabled selected hidden></option>
                    </select>
                    <label for="branchAssignment" class="form-label">Branch <span class="required">*</span></label>
                </div>

                <div class="form-group">
                    <select id="status" name="status" class="form-control" required>
                        <option value="" disabled selected hidden></option>
                        <option value="Active" ${isEdit && data.status === "Active" ? "selected" : ""}>Active</option>
                        <option value="Inactive" ${isEdit && data.status === "Inactive" ? "selected" : ""}>Inactive</option>
                    </select>
                    <label for="status" class="form-label">Status <span class="required">*</span></label>
                </div>
                            
                <div class="form-group">
                    <input  
                        type="date" 
                        id="dateStarted" 
                        name="dateStarted"
                        class="form-control"
                        value="${isEdit ? data.date_started : ''}"
                        ${isEdit && hasStarted(data.date_started) ? "disabled" : "required"}
                        autocomplete="off"
                    >
                    <label for="dateStarted" class="form-label">Start Date <span class="required">*</span></label>

                    ${isEdit && hasStarted(data.date_started)
                        ? `
                            <input type="hidden" name="dateStarted" value="${data.date_started}">
                            <small style="color:#999; font-size:0.85em;">
                                The staff has already started. Start date can no longer be edited.
                            </small>
                        `
                        : `
                            <span id="dateError" class="error-msg-calendar error" style="display:none;">
                                Sundays are not available for work. Please select another date.
                            </span>
                        `
                    }
                </div>

                ${isEdit ? `
                <div class="form-group">
                    <input type="text" id="dateCreated" class="form-control" value="${data.date_created}" disabled>
                    <label for="dateCreated" class="form-label">Date Created</label>
                </div>` : ""}

                ${isEdit ? `
                <div class="form-group">
                    <input type="text" id="dateUpdated" class="form-control" value="${data.date_updated ? data.date_updated : '-'}" disabled>
                    <label for="dateUpdated" class="form-label">Last Updated</label>
                </div>` : ""}

                <div class="button-group button-group-profile">
                    <button type="submit" class="form-button confirm-btn">${isEdit ? "Save Changes" : "Add Secretary"}</button>
                    <button type="button" class="form-button cancel-btn" onclick="closeEmployeeModal()">Cancel</button>
                </div>
            </form>
        `;

        fetch(`${BASE_URL}/Owner/processes/employees/get_branches.php`)
        .then(res => res.json())
        .then(branches => {
            const branchSelect = document.getElementById("branchAssignment");
            branches.forEach(branch => {
                const option = document.createElement("option");
                option.value = branch.branch_id;
                option.textContent = branch.name;
                if (isEdit && branch.branch_id == data.branch_id) option.selected = true;
                branchSelect.appendChild(option);
            });
        });
    }
    
    function renderDentistForm(data) {
        const isEdit = !!data;
        const selectedBranches = isEdit && data.branches ? data.branches.map(b => parseInt(b)) : [];
        const selectedServices = isEdit && data.services ? data.services.map(s => parseInt(s)) : [];
        
        employeeBody.innerHTML = `
            <h2>${isEdit ? "Manage Dentist" : "Add Dentist"}</h2>
            <form id="dentistForm" action="${BASE_URL}/Owner/processes/employees/${isEdit ? "update_dentist.php" : "insert_dentist.php"}" method="POST" enctype="multipart/form-data" autocomplete="off">
                ${isEdit ? `<input type="hidden" name="dentist_id" value="${data.dentist_id}">` : ""}

                <div class="form-group" style="position: relative; margin-bottom: 18px;">
                    <input type="file" id="profileImage" name="profileImage" class="form-control" accept="image/*" ${isEdit ? "" : ""}>
                    <label for="profileImage" class="form-label" style="display: block; margin-top: 6px; margin-bottom: 4px;">Profile Picture </label>
                    
                    ${isEdit && data.profile_image 
                        ? `<div class="mt-2" style="margin-top: 6px;">
                                <p style="margin-bottom: 4px;">Current Profile Picture:</p>
                                <div style="display: flex; flex-direction: column; align-items: flex-start; gap: 6px;">
                                    <img src="${BASE_URL}/images/dentists/profile/${data.profile_image}" alt="Profile Image"
                                        style="max-width:150px; border:1px solid #ccc; padding:4px; border-radius:4px;; margin-bottom: 6px;">
                                    <button type="button" class="confirm-btn"
                                        style="width:150px; margin-top:4px;"
                                        onclick="clearImage('profileImage', 'profileCleared')">Remove</button>
                                </div>
                                <input type="hidden" name="profileCleared" id="profileCleared" value="0">
                        </div>`
                        : ""
                    }
                </div>

                <div class="form-group">
                    <input type="text" id="lastName" name="lastName" class="form-control"
                        value="${isEdit ? data.last_name : ""}" required placeholder=" " autocomplete="off">
                    <label for="lastName" class="form-label">Last Name <span class="required">*</span></label>
                </div>

                <div class="form-group">
                    <input type="text" id="firstName" name="firstName" class="form-control"
                        value="${isEdit ? data.first_name : ""}" required placeholder=" " autocomplete="off">
                    <label for="firstName" class="form-label">First Name <span class="required">*</span></label>
                </div>

                <div class="form-group">
                    <input type="text" id="middleName" name="middleName" class="form-control"
                        value="${isEdit ? (data.middle_name || "") : ""}" placeholder=" " autocomplete="off">
                    <label for="middleName" class="form-label">Middle Name</label>
                </div>

                <div class="form-group">
                    <select id="gender" name="gender" class="form-control" required>
                        <option value="" disabled selected hidden></option>
                        <option value="Male" ${isEdit && data.gender === "Male" ? "selected" : ""}>Male</option>
                        <option value="Female" ${isEdit && data.gender === "Female" ? "selected" : ""}>Female</option>
                    </select>
                    <label for="gender" class="form-label">Gender <span class="required">*</span></label>
                </div>

                <div class="form-group">
                    <input type="date" id="dateofBirth" name="dateofBirth" class="form-control"
                        value="${isEdit ? data.date_of_birth : ""}" required autocomplete="off">
                    <label for="dateofBirth" class="form-label">Date of Birth <span class="required">*</span></label>
                    <span id="dobError" class="error-msg-calendar error" style="display: none;">
                        Date of birth cannot be in the future.
                    </span>
                </div>

                <div class="form-group">
                    <input type="email" id="email" name="email" class="form-control"
                        value="${isEdit ? data.email : ""}" required placeholder=" " autocomplete="off">
                    <label for="email" class="form-label">Email <span class="required">*</span></label>
                </div>

                <div class="form-group phone-group">
                    <input type="tel" id="contactNumber" name="contactNumber" class="form-control" 
                        value="${isEdit ? data.contact_number : ""}" oninput="this.value = this.value.replace(/[^0-9]/g, '')" pattern="[0-9]{10}" title="Mobile number must be 10 digits" required maxlength="10" autocomplete="off">
                    <label for="contactNumber" class="form-label">Mobile Number <span class="required">*</span></label>
                    <span class="phone-prefix">+63</span>
                </div>

                <div class="form-group">
                    <input type="text" id="licenseNumber" name="licenseNumber" class="form-control"
                        value="${isEdit ? data.license_number : ""}" required placeholder=" " autocomplete="off">
                    <label for="licenseNumber" class="form-label">License Number <span class="required">*</span></label>
                </div>

                <div class="form-group">
                    <div id="branchAssignment" class="checkbox-group"></div>
                </div>

                <div class="form-group">
                    <div id="branchScheduleContainer" class="schedule-days-container"></div>
                </div>

                <div class="form-group">
                    <div id="servicesCheckboxes" class="checkbox-group"></div>
                </div>

                <div class="form-group">
                    <select id="status" name="status" class="form-control" required>
                        <option value="" disabled selected hidden></option>
                        <option value="Active" ${isEdit && data.status === "Active" ? "selected" : ""}>Active</option>
                        <option value="Inactive" ${isEdit && data.status === "Inactive" ? "selected" : ""}>Inactive</option>
                    </select>
                    <label for="status" class="form-label">Status <span class="required">*</span></label>
                </div>

                <div class="form-group" style="position: relative; margin-bottom: 18px;">
                    <input type="file" id="signatureImage" name="signatureImage" class="form-control" accept="image/*">
                    <label for="signatureImage" class="form-label" style="display: block; margin-top: 6px; margin-bottom: 4px;">Signature Image </label>

                    ${isEdit && data.signature_image 
                        ? `<div class="mt-2" style="margin-top: 6px;">
                                <p style="margin-bottom: 4px;">Current Signature:</p>
                                <div style="display: flex; flex-direction: column; align-items: flex-start; gap: 6px;">
                                    <img src="${BASE_URL}/images/dentists/signature/${data.signature_image}" alt="Signature"
                                        style="max-width:150px; border:1px solid #ccc; padding:4px; border-radius:4px;; margin-bottom: 6px;">
                                    <button type="button" class="confirm-btn"
                                        style="width:150px; margin:4px 0px 10px 0px;"
                                        onclick="clearImage('signatureImage', 'signatureCleared')">Remove</button>
                                </div>
                                <input type="hidden" name="signatureCleared" id="signatureCleared" value="0">
                        </div>`
                        : ""
                    }
                </div>
                
                <div class="form-group">
                    <input  
                        type="date" 
                        id="dateStarted" 
                        name="dateStarted"
                        class="form-control"
                        value="${isEdit ? data.date_started : ''}"
                        ${isEdit && hasStarted(data.date_started) ? "disabled" : "required"}
                        autocomplete="off"
                    >
                    <label for="dateStarted" class="form-label">Start Date <span class="required">*</span></label>

                    ${isEdit && hasStarted(data.date_started)
                        ? `
                            <input type="hidden" name="dateStarted" value="${data.date_started}">
                            <small style="color:#999; font-size:0.85em;">
                                The staff has already started. Start date can no longer be edited.
                            </small>
                        `
                        : `
                            <span id="dateError" class="error-msg-calendar error" style="display:none;">
                                Sundays are not available for work. Please select another date.
                            </span>
                        `
                    }
                </div>

                ${isEdit ? `
                <div class="form-group">
                    <input type="text" id="dateCreated" class="form-control" value="${data.date_created}" disabled>
                    <label for="dateCreated" class="form-label">Date Created</label>
                </div>` : ""}

                ${isEdit ? `
                <div class="form-group">
                    <input type="text" id="dateUpdated" class="form-control" value="${data.date_updated ? data.date_updated : '-'}" disabled>
                    <label for="dateUpdated" class="form-label">Last Updated</label>
                </div>` : ""}

                <div class="button-group button-group-profile">
                    <button type="submit" class="form-button confirm-btn">${isEdit ? "Save Changes" : "Add Dentist"}</button>
                    <button type="button" class="form-button cancel-btn" onclick="closeEmployeeModal()">Cancel</button>
                </div>
            </form>
        `;

        fetch(`${BASE_URL}/Owner/processes/employees/get_branches.php`)
        .then(res => res.json())
        .then(branches => {

            const container = document.getElementById("branchAssignment");
            container.innerHTML = "";

            branches.forEach(branch => {
                const wrapper = document.createElement("div");
                wrapper.innerHTML = `
                    <div class="checkbox-item">
                        <input type="checkbox" id="branch_${branch.branch_id}" name="branches[]" value="${branch.branch_id}"
                            ${isEdit ? (selectedBranches.includes(parseInt(branch.branch_id)) ? "checked" : "") : "checked"}>
                        <label for="branch_${branch.branch_id}">${branch.name}</label>  
                    </div>
                `;
                container.appendChild(wrapper);
            });

            const scheduleContainer = document.getElementById("branchScheduleContainer");
            scheduleContainer.innerHTML = "";

            const days = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];
            const savedSchedule = isEdit ? data.branch_schedule || {} : {};

            days.forEach(day => {
                const dayWrapper = document.createElement("div");
                dayWrapper.classList.add("day-schedule-wrapper");

                dayWrapper.innerHTML = `
                    <h4>${day}</h4>
                    <div class="schedule-rows" id="rows_${day}"></div>
                    <button type="button" class="add-schedule-btn" data-day="${day}">+ Add schedule</button>
                `;

                scheduleContainer.appendChild(dayWrapper);

                const rowsContainer = dayWrapper.querySelector(`#rows_${day}`);

                if (savedSchedule[day]) {
                    savedSchedule[day].forEach(entry => {
                        addScheduleRow(day, rowsContainer, branches, entry);
                    });
                }
            });

            scheduleContainer.querySelectorAll(".add-schedule-btn").forEach(btn => {
                btn.addEventListener("click", () => {
                    const day = btn.dataset.day;
                    const rowsContainer = document.getElementById(`rows_${day}`);
                    addScheduleRow(day, rowsContainer, branches);
                });
            });

            function addScheduleRow(day, rowsContainer, branches, saved = null) {

                const checkedBranches = Array.from(
                    document.querySelectorAll("#branchAssignment input[type=checkbox]:checked")
                ).map(cb => ({
                    branch_id: cb.value,
                    name: cb.nextElementSibling.textContent
                }));

                const startVal = saved ? (saved.start_time ?? "") : "";
                const endVal   = saved ? (saved.end_time ?? "") : "";

                const WHOLE_DAY_START = "09:00";
                const WHOLE_DAY_END   = "16:30";

                const isWholeDay =
                    saved && (
                        (startVal === "" && endVal === "") || 
                        (startVal?.slice(0,5) === WHOLE_DAY_START && endVal?.slice(0,5) === WHOLE_DAY_END)
                    );

                const row = document.createElement("div");
                row.classList.add("schedule-row");

                row.innerHTML = `
                    <select name="schedule[${day}][branch][]" required>
                        <option value="" disabled ${!saved ? "selected" : ""}>Select Branch</option>
                        ${checkedBranches.map(b => `
                            <option value="${b.branch_id}" ${saved && saved.branch_id == b.branch_id ? "selected" : ""}>
                                ${b.name}
                            </option>
                        `).join("")}
                    </select>

                    <input type="time" class="start-time" name="schedule[${day}][start][]" 
                        value="${startVal}" ${isWholeDay ? "disabled" : ""}>

                    <input type="time" class="end-time" name="schedule[${day}][end][]" 
                        value="${endVal}" ${isWholeDay ? "disabled" : ""}>

                    <button type="button" class="whole-day-btn">${isWholeDay ? "Undo" : "Whole Day"}</button>
                    <button type="button" class="remove-row-btn">×</button>
                `;

                const startInput = row.querySelector(".start-time");
                const endInput = row.querySelector(".end-time");
                const wholeDayBtn = row.querySelector(".whole-day-btn");

                wholeDayBtn.addEventListener("click", () => toggleWholeDay(wholeDayBtn));

                row.querySelector(".remove-row-btn").addEventListener("click", () => {
                    const day = row.closest(".day-schedule-wrapper").querySelector("h4").textContent;
                    row.remove();
                    updateAddScheduleButton(day);
                    updateWholeDayVisibility(day);
                });

                rowsContainer.appendChild(row);
                updateAddScheduleButton(day);
                updateWholeDayVisibility(day);
            }

            container.querySelectorAll("input[type=checkbox]").forEach(chk => {
                chk.addEventListener("change", () => {

                    document.querySelectorAll(".schedule-row select").forEach(select => {
                        const selectedValue = select.value;

                        const checkedBranches = Array.from(
                            document.querySelectorAll("#branchAssignment input[type=checkbox]:checked")
                        ).map(cb => ({
                            branch_id: cb.value,
                            name: cb.nextElementSibling.textContent
                        }));

                        select.innerHTML = `
                            <option value="" disabled>Select Branch</option>
                            ${checkedBranches.map(b => `
                                <option value="${b.branch_id}">${b.name}</option>
                            `).join("")}
                        `;

                        if (checkedBranches.some(b => b.branch_id == selectedValue)) {
                            select.value = selectedValue;
                        }
                    });
                });
            });
        });

        fetch(`${BASE_URL}/Owner/processes/employees/get_services.php`)
        .then(res => res.json())
        .then(services => {
            const container = document.getElementById("servicesCheckboxes");
            container.innerHTML = "";

            services.forEach(service => {
                const wrapper = document.createElement("div");
                wrapper.innerHTML = `
                    <div class="checkbox-item">
                        <input type="checkbox" id="service_${service.service_id}" name="services[]" value="${service.service_id}"
                            ${isEdit ? (selectedServices.includes(parseInt(service.service_id)) ? "checked" : "") : "checked"}>
                        <label for="service_${service.service_id}">${service.name}</label>
                    </div>
                `;
                container.appendChild(wrapper);
            });
        });
    }

    function hasStarted(dateStarted) {
        if (!dateStarted) return false;
        const today = new Date();
        today.setHours(0,0,0,0);

        const started = new Date(dateStarted);
        started.setHours(0,0,0,0);

        return started <= today;
    }

    function toggleWholeDay(button) {
        const row = button.closest(".schedule-row");
        const rowsContainer = row.parentElement;
        const start = row.querySelector(".start-time");
        const end = row.querySelector(".end-time");

        const day = row.closest(".day-schedule-wrapper")
                    .querySelector("h4").textContent;

        if (button.textContent === "Whole Day") {
            rowsContainer.querySelectorAll(".schedule-row").forEach(r => {
                if (r !== row) r.remove();
            });
            start.disabled = true;
            end.disabled = true;
            start.value = "";
            end.value = "";

            start.insertAdjacentHTML("afterend",
                `<input type="hidden" name="${start.name}" value="">`);
            end.insertAdjacentHTML("afterend",
                `<input type="hidden" name="${end.name}" value="">`);

            button.textContent = "Undo";

        } else {
            start.disabled = false;
            end.disabled = false;

            row.querySelectorAll("input[type=hidden]").forEach(h => h.remove());

            button.textContent = "Whole Day";
        }

        updateAddScheduleButton(day);
        updateWholeDayVisibility(day);
    }

    function updateAddScheduleButton(day) {
        const rowsContainer = document.getElementById(`rows_${day}`);
        const hasWholeDay = rowsContainer.querySelector(".start-time:disabled");

        const addBtn = document.querySelector(`button.add-schedule-btn[data-day="${day}"]`);

        if (hasWholeDay) {
            addBtn.style.display = "none";
        } else {
            addBtn.style.display = "inline-block";
        }
    }

    function updateWholeDayVisibility(day) {
        const rowsContainer = document.getElementById(`rows_${day}`);
        const rows = rowsContainer.querySelectorAll(".schedule-row");

        rows.forEach(row => {
            const wholeBtn = row.querySelector(".whole-day-btn");
            const start = row.querySelector(".start-time");
            const end = row.querySelector(".end-time");

            if (rows.length > 1) {
                wholeBtn.style.display = "none";
            } else {
                wholeBtn.style.display = "inline-block";
            }
        });
    }
});

function clearImage(inputId, hiddenId) {
    const input = document.getElementById(inputId);
    const hidden = document.getElementById(hiddenId);

    if (input) input.value = "";
    if (hidden) hidden.value = "1";

    const imgPreview = input.closest(".form-group").querySelector("img");
    if (imgPreview) imgPreview.remove();

    const btn = input.closest(".form-group").querySelector("button");
    if (btn) btn.remove();
}

function closeEmployeeModal() {
    document.getElementById("manageModal").style.display = "none";
}
