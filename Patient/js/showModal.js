document.addEventListener("DOMContentLoaded", () => {
    const appointmentModal = document.getElementById("manageModal");
    const appointmentBody = document.getElementById("modalBody");

    const transactionModal = document.getElementById("transactionModal");
    const transactionBody = document.getElementById("transactionModalBody");

    document.body.addEventListener("click", function(e) {
        if (e.target.classList.contains("btn-action")) {
            const id = e.target.getAttribute("data-id");
            const type = e.target.getAttribute("data-type");

            let url = "";
            if (type === "appointment") {
                url = `${BASE_URL}/Patient/processes/profile/get_appointment_details.php?id=${id}`;
            } else if (type === "transaction") {
                url = `${BASE_URL}/Patient/processes/profile/get_dental_transaction_details.php?id=${id}`;
            }

            fetch(url)
                .then(response => response.json())
                .then(data => {
                    if (data.error) {
                        if (type === "appointment") {
                            appointmentBody.innerHTML = `<p style="color:red;">${data.error}</p>`;
                            appointmentModal.style.display = "block";
                        } else {
                            transactionBody.innerHTML = `<p style="color:red;">${data.error}</p>`;
                            transactionModal.style.display = "block";
                        }
                        return;
                    }

                    if (type === "appointment") {
                        appointmentBody.innerHTML = `
                            <h2>Appointment Details</h2>
                            <p><strong>Dentist:</strong><span>${data.dentist ?? 'Available Dentist'}</span></p>
                            <p><strong>Branch:</strong><span>${data.branch}<span></p>
                            <p><strong>Service:</strong><span>${data.services || '-'}</p>
                            <p><strong>Date:</strong><span>${
                                data.appointment_date
                                    ? new Date(data.appointment_date).toLocaleDateString('en-US', { month: 'long', day: 'numeric', year: 'numeric' })
                                    : ''
                            }</span></p>
                            <p><strong>Time:</strong><span>${
                                data.appointment_time
                                    ? new Date(`1970-01-01T${data.appointment_time}`).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit', hour12: true })
                                    : ''
                            }</span></p>
                            <p><strong>Notes:</strong><span>${data.notes || '-'}</span></p>
                            <p><strong>Status:</strong><span>${data.status}<span></p>
                            <p><strong>Date Booked:</strong><span>${
                                data.date_created
                                    ? new Date(data.date_created).toLocaleDateString('en-US', { month: 'long', day: 'numeric', year: 'numeric' })
                                    : '-'
                            }</span></p>
                        `;
                        appointmentModal.style.display = "block";
                    } 

                    else if (type === "transaction") {

                        // ===== MEDCERT VALIDITY =====
                        let medCertButtonHtml = "";
                        let medCertExpired = false;

                        if (data.date_created) {
                            const createdDate = new Date(data.date_created);
                            const now = new Date();
                            const diffDays = (now - createdDate) / (1000 * 60 * 60 * 24);
                            medCertExpired = diffDays >= 7;
                        }

                        if (medCertExpired && data.medcert_status !== 'Expired') {
                            medCertButtonHtml = `<button class="confirm-btn expired-btn" disabled>Expired</button>`;
                        } else {
                            medCertButtonHtml =
                                data.medcert_status === 'None'
                                    ? `<button class="confirm-btn" id="requestMedicalCertificate" data-id="${data.dental_transaction_id}">Request Dental Certificate</button>`
                                    : data.medcert_status === 'Requested'
                                        ? `<button class="confirm-btn pending-btn" disabled>Pending</button>`
                                        : data.medcert_status === 'Eligible'
                                            ? `<button class="confirm-btn" id="downloadMedicalCertificate">Download Dental Certificate</button>`
                                            : data.medcert_status === 'Issued'
                                                ? `<button class="confirm-btn issued-btn" id="viewMedCertReceipt" data-id="${data.dental_transaction_id}">Issued</button>`
                                                : data.medcert_status === 'Expired'
                                                    ? `<button class="confirm-btn expired-btn" id="viewMedCertReceipt" data-id="${data.dental_transaction_id}">Expired</button>`
                                                    : '';
                        }

                        // ===== PRESCRIPTIONS VALIDITY =====
                        let prescriptionButtonHtml = "";

                        const hasPrescriptions = data.prescriptions && data.prescriptions.length > 0;

                        let isExpired = false;
                        if (data.date_created) {
                            const createdDate = new Date(data.date_created);
                            const now = new Date();
                            const diffYears = (now - createdDate) / (1000 * 60 * 60 * 24 * 365);
                            isExpired = diffYears >= 1;
                        }

                        if (!hasPrescriptions) {
                            prescriptionButtonHtml = `<button class="confirm-btn" disabled>No Prescription Available</button>`;
                        } else if (isExpired) {
                            prescriptionButtonHtml = `<button class="confirm-btn expired-btn" disabled>Expired</button>`;
                        } else if (data.prescription_downloaded == 0) {
                            prescriptionButtonHtml = `<button class="confirm-btn" id="downloadPrescription">Download Prescription</button>`;
                        } else {
                            prescriptionButtonHtml = `<button class="confirm-btn" disabled>Issued</button>`;
                        }

                        transactionBody.innerHTML = `
                            <div class="transaction-columns">
                                <div class="transaction-section">
                                    <h3>Dental Transaction</h3>
                                    <p><strong>Dentist:</strong><span>${data.dentist ?? 'Available Dentist'}</span></p>
                                    <p><strong>Branch:</strong><span>${data.branch}</span></p>
                                    <p><strong>Service:</strong><span>${data.services}</span></p>
                                    <p><strong>Date:</strong><span>${
                                        data.appointment_date
                                            ? new Date(data.appointment_date).toLocaleDateString('en-US', { month: 'long', day: 'numeric', year: 'numeric' })
                                            : ''
                                    }</span></p>
                                    <p><strong>Time:</strong><span>${
                                        data.appointment_time
                                            ? new Date(`1970-01-01T${data.appointment_time}`).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit', hour12: true })
                                            : ''
                                    }</span></p>
                                    <p><strong>Amount Paid:</strong><span>${data.total}</span></p>
                                    <p><strong>Additional:</strong><span>${data.additional_payment || '-'}</span></p>
                                    <p><strong>Method:</strong><span>${data.payment_method}</span></p>
                                    <p><strong>Notes:</strong><span>${data.notes || '-'}</span></p>
                                    <p><strong>Date Recorded:</strong><span>${
                                        data.date_created
                                            ? new Date(data.date_created).toLocaleDateString('en-US', { month: 'long', day: 'numeric', year: 'numeric' })
                                            : '-'
                                    }</span></p>
                                    <p><strong>Certificate Request Date:</strong>
                                        <span>${
                                            data.medcert_requested_date
                                                ? new Date(data.medcert_requested_date).toLocaleDateString('en-US', { month: 'long', day: 'numeric', year: 'numeric' })
                                                : '-'
                                        }</span>
                                    </p>
                                    <p><strong>Certificate Notes:</strong><span>${data.medcert_notes || '-'}</span></p>

                                    <div class="button-group button-group-profile">
                                        ${medCertButtonHtml}
                                    </div>
                                </div>

                                <div class="transaction-section">
                                    <h3>Vitals</h3>
                                    <p><strong>Body Temp:</strong><span>${data.body_temp}</span></p>
                                    <p><strong>Pulse Rate:</strong><span>${data.pulse_rate}</span></p>
                                    <p><strong>Respiratory Rate:</strong><span>${data.respiratory_rate}</span></p>
                                    <p><strong>Blood Pressure:</strong><span>${data.blood_pressure}</span></p>
                                    <p><strong>Height:</strong><span>${data.height}</span></p>
                                    <p><strong>Weight:</strong><span>${data.weight}</span></p>
                                    <p><strong>Swelling:</strong><span>${data.is_swelling}</span></p>
                                    <p><strong>Sensitivity:</strong><span>${data.is_sensitive}</span></p>
                                    <p><strong>Bleeding:</strong><span>${data.is_bleeding}</span></p>

                                    <div class="button-group button-group-profile" style="margin-top:10px;">
                                        ${
                                            data.xray_results && data.xray_results.length > 0
                                                ? `<button class="confirm-btn" id="viewXrayResult" data-id="${data.dental_transaction_id}">View Results</button>`
                                                : ``
                                        }
                                    </div>
                                </div>

                                <div class="transaction-section">
                                    <h3>Prescription</h3>
                                    <div id="prescriptionList"></div>

                                    <div class="button-group button-group-profile">
                                        ${prescriptionButtonHtml}
                                    </div>
                                </div>
                            </div>
                        `;

                        // ===== PRESCRIPTIONS LIST =====
                        let prescriptionHtml = '';
                        if (data.prescriptions && data.prescriptions.length > 0) {
                            data.prescriptions.forEach(p => {
                                prescriptionHtml += `
                                    <div class="prescription-item">
                                        <p><strong>Drug:</strong><span>${p.drug}</span></p>
                                        <p><strong>Frequency:</strong><span>${p.frequency}</span></p>
                                        <p><strong>Dosage:</strong><span>${p.dosage}</span></p>
                                        <p><strong>Duration:</strong><span>${p.duration}</span></p>
                                        <p><strong>Quantity:</strong><span>${p.quantity}</span></p>
                                        <p><strong>Instructions:</strong><span>${p.instructions}</span></p>
                                        <hr>
                                    </div>
                                `;
                            });
                        } else {
                            prescriptionHtml = `<p>No prescriptions recorded.</p>`;
                        }

                        document.getElementById("prescriptionList").innerHTML = prescriptionHtml;
                        transactionModal.style.display = "block";

                        // ========= DOWNLOAD Dental Certificate =========
                        const medCertBtn = document.getElementById("downloadMedicalCertificate");
                        if (medCertBtn) {
                            medCertBtn.addEventListener("click", async () => {
                                const { jsPDF } = window.jspdf;
                                const doc = new jsPDF();

                                async function getBase64ImageFromUrl(url) {
                                    const res = await fetch(url);
                                    const blob = await res.blob();
                                    return new Promise((resolve, reject) => {
                                        const reader = new FileReader();
                                        reader.onloadend = () => resolve(reader.result);
                                        reader.onerror = reject;
                                        reader.readAsDataURL(blob);
                                    });
                                }

                                const pageHeight = doc.internal.pageSize.getHeight();

                                // ===== HEADER =====
                                const logoUrl = `${BASE_URL}/images/logo/logo_default.png`;
                                const logoBase64 = await getBase64ImageFromUrl(logoUrl);
                                doc.addImage(logoBase64, "PNG", 10, 10, 50, 30);

                                doc.setFont("helvetica", "bold");
                                doc.setFontSize(14);
                                doc.text("Arriesgado Dental Clinic", 105, 18, { align: "center" });

                                const response = await fetch(`${BASE_URL}/Patient/processes/profile/get_branches.php`);
                                const branchesData = await response.json();
                                const branchesText = branchesData.branches ? branchesData.branches.join(" • ") : "-";

                                doc.setFont("helvetica", "normal");
                                doc.setFontSize(11);
                                doc.text(branchesText, 105, 25, { align: "center" });
                                doc.text("Contact Us: 09955446451", 105, 31, { align: "center" });
                                doc.text("Smile-ify@gmail.com", 105, 37, { align: "center" });
                                doc.text("Clinic Hours: 9AM - 3PM | Mon–Sun (All Branches)", 105, 43, { align: "center" });

                                doc.line(10, 48, 200, 48);

                                // ===== TITLE =====
                                doc.setFont("helvetica", "bold");
                                doc.setFontSize(18);
                                doc.text("Dental Certificate", 105, 60, { align: "center" });

                                // ===== PATIENT INFO =====
                                const patientFullName = `${data.patient_last_name}, ${data.patient_first_name} ${data.patient_middle_name ? data.patient_middle_name[0] + '.' : ''}`;
                                let patientAge = "-";
                                if (data.patient_dob) {
                                    const dob = new Date(data.patient_dob);
                                    const diff = Date.now() - dob.getTime();
                                    patientAge = Math.floor(diff / (1000 * 60 * 60 * 24 * 365.25)) + " yrs";
                                }

                                const formattedDate = data.date_created
                                    ? new Date(data.date_created).toLocaleDateString("en-US", {
                                        year: "numeric",
                                        month: "long",
                                        day: "numeric"
                                    })
                                    : "-";

                                let y = 80;
                                doc.setFontSize(12);
                                doc.setFont("helvetica", "normal");

                                // ===== MAIN CERTIFICATE BODY =====
                                doc.text(
                                    `This is to certify that ${patientFullName}, aged ${patientAge}, was examined and treated at Arriesgado Dental Clinic on ${formattedDate}.`,
                                    20, y, { maxWidth: 170, align: "justify" }
                                );
                                y += 20;

                                // ===== DIAGNOSIS =====
                                const diagnosis = data.diagnosis && data.diagnosis.trim() !== "" ? data.diagnosis : "Not specified.";
                                doc.setFont("helvetica", "normal");
                                doc.setFontSize(12);
                                doc.text(
                                    `The patient was diagnosed with ${diagnosis.toLowerCase()}.`,
                                    20, y, { maxWidth: 170, align: "justify" }
                                );
                                y += 15;

                                // ===== SERVICES / PROCEDURES =====
                                let servicesText = "";
                                if (data.services) {
                                    let filtered = Array.isArray(data.services)
                                        ? data.services
                                            .map(s => s.service_name || s.name || s)
                                            .filter(name => !/Dental Certificate/i.test(name)) // exclude "Dental Certificate"
                                        : (data.services_text || data.services || "")
                                            .split(",")
                                            .filter(name => !/Dental Certificate/i.test(name.trim()));

                                    if (filtered.length > 0) {
                                        servicesText = filtered.join(", ");
                                    }
                                }

                                if (servicesText) {
                                    doc.text(
                                        "The patient underwent the following dental procedure(s):",
                                        20, y, { maxWidth: 170 }
                                    );
                                    y += 8;
                                    const serviceLines = doc.splitTextToSize(servicesText, 160);
                                    doc.text(serviceLines, 30, y);
                                    y += serviceLines.length * 8 + 10;
                                }

                                // ===== FITNESS STATUS =====
                                const fitness = data.fitness_status && data.fitness_status.trim() !== "" ? data.fitness_status : "Fit for dental procedures.";
                                doc.setFont("helvetica", "bold");
                                doc.text("Fitness Status:", 20, y);
                                doc.setFont("helvetica", "normal");
                                doc.text(fitness, 60, y);
                                y += 10;

                                // ===== REMARKS =====
                                const remarks = data.remarks && data.remarks.trim() !== "" ? data.remarks : "No additional remarks.";
                                doc.setFont("helvetica", "bold");
                                doc.text("Remarks:", 20, y);
                                doc.setFont("helvetica", "normal");
                                doc.text(remarks, 60, y);
                                y += 20;

                                // ===== RECOMMENDATION =====
                                doc.setFont("helvetica", "normal");
                                doc.text(
                                    "It is hereby recommended that the patient take adequate rest and avoid strenuous activity as advised by the attending dentist.",
                                    20, y, { maxWidth: 170, align: "justify" }
                                );
                                y += 20;

                                doc.text(
                                    "This certificate is issued upon the patient’s request for whatever legal or personal purpose it may serve.",
                                    20, y, { maxWidth: 170, align: "justify" }
                                );
                                y += 20;

                                doc.text(
                                    `Issued this ${formattedDate} at Arriesgado Dental Clinic.`,
                                    20, y, { maxWidth: 170 }
                                );

                                // ===== SIGNATURE =====
                                if (data.dentist_last_name || data.dentist_first_name) {
                                    let sigY = y + 25;

                                    const bottomMargin = 40;
                                    if (sigY > pageHeight - bottomMargin) {
                                        doc.addPage();
                                        sigY = 60;
                                    }

                                    const sigUrl = `${BASE_URL}/images/dentists/signature/${data.signature_image}`;
                                    let hasSignature = false;

                                    if (data.signature_image) {
                                        try {
                                            const sigBase64 = await getBase64ImageFromUrl(sigUrl);
                                            doc.addImage(sigBase64, "PNG", 125, sigY, 50, 20);
                                            hasSignature = true;
                                        } catch (err) {
                                            console.warn("Could not load signature", err);
                                        }
                                    }

                                    const lineY = hasSignature ? sigY + 25 : sigY + 20;
                                    doc.line(120, lineY, 200, lineY);

                                    const nameY = lineY + 8;
                                    const licenseY = lineY + 16;

                                    const dentistFullName = `${data.dentist_last_name}, ${data.dentist_first_name} ${
                                        data.dentist_middle_name ? data.dentist_middle_name[0] + '.' : ''
                                    }`;

                                    doc.text("Dr. " + dentistFullName, 160, nameY, { align: "center" });
                                    doc.text("License No: " + (data.license_number ?? "-"), 160, licenseY, { align: "center" });
                                }

                                // ===== PAGE NUMBER =====
                                const pageCount = doc.internal.getNumberOfPages();
                                for (let i = 1; i <= pageCount; i++) {
                                    doc.setPage(i);
                                    doc.setFontSize(10);
                                    doc.text(`Page ${i} of ${pageCount}`, 105, pageHeight - 10, { align: "center" });
                                }

                                // ===== SAVE FILE =====
                                const safeName = (data.patient_last_name || "patient").replace(/\s+/g, "_");
                                const safeDate = (data.date_created ? data.date_created.split(" ")[0] : "unknown");
                                const fileName = `${safeName}_${safeDate}_medical_certificate.pdf`;
                                doc.save(fileName);

                                // ===== UPDATE STATUS TO ISSUED =====
                                try {
                                    const updateResponse = await fetch(`${BASE_URL}/Patient/processes/profile/update_medcert_status.php`, {
                                        method: "POST",
                                    headers: { "Content-Type": "application/json" },
                                        body: JSON.stringify({
                                            dental_transaction_id: data.dental_transaction_id,
                                            new_status: "Issued"
                                        })
                                    });

                                    const updateResult = await updateResponse.json();

                                    if (updateResult.success) {
                                        medCertBtn.textContent = "Issued";
                                        medCertBtn.disabled = true;
                                        medCertBtn.classList.add("issued-btn");
                                    } else {
                                        console.warn("Failed to update Certificate status:", updateResult.error);
                                    }
                                } catch (error) {
                                    console.error("Error updating Certificate status:", error);
                                }
                            });
                        }

                        // ========= DOWNLOAD PRESCRIPTION =========
                        const btn = document.getElementById("downloadPrescription");
                        if (btn) {
                            btn.addEventListener("click", async () => {
                                const { jsPDF } = window.jspdf;
                                const doc = new jsPDF();

                                async function getBase64ImageFromUrl(url) {
                                    const res = await fetch(url);
                                    const blob = await res.blob();
                                    return new Promise((resolve, reject) => {
                                        const reader = new FileReader();
                                        reader.onloadend = () => resolve(reader.result);
                                        reader.onerror = reject;
                                        reader.readAsDataURL(blob);
                                    });
                                }

                                const pageHeight = doc.internal.pageSize.getHeight();
                                // ===== HEADER =====
                                const logoUrl = `${BASE_URL}/images/logo/logo_default.png`;
                                const logoBase64 = await getBase64ImageFromUrl(logoUrl);
                                doc.addImage(logoBase64, "PNG", 10, 10, 50, 30);

                                doc.setFontSize(14);
                                doc.setFont("helvetica", "bold");
                                doc.text("Arriesgado Dental Clinic", 105, 15, { align: "center" });

                                // Branches
                                const response = await fetch(`${BASE_URL}/Patient/processes/profile/get_branches.php`);
                                const branchesData = await response.json();
                                const branchesText = branchesData.branches ? branchesData.branches.join(" • ") : "-";

                                doc.setFontSize(11);
                                doc.setFont("helvetica", "normal");
                                doc.text(branchesText, 105, 22, { align: "center" });
                                doc.text("Contact Us: 09955446451", 105, 28, { align: "center" });
                                doc.text("Smile-ify@gmail.com", 105, 34, { align: "center" });
                                doc.text("Clinic Hours: 9AM - 3PM | Mon–Sun (All Branches)", 105, 40, { align: "center" });

                                doc.line(10, 45, 200, 45);

                                // ===== PATIENT INFO =====
                                const patientFullName = `${data.patient_last_name}, ${data.patient_first_name} ${data.patient_middle_name ? data.patient_middle_name[0] + '.' : ''}`;
                                let patientAge = "-";
                                if (data.patient_dob) {
                                    const dob = new Date(data.patient_dob);
                                    const diff = Date.now() - dob.getTime();
                                    patientAge = Math.floor(diff / (1000 * 60 * 60 * 24 * 365.25)) + " yrs";
                                }

                                doc.setFontSize(12);
                                const leftLabelX = 10;
                                const leftValueX = 45;
                                const leftLineEndX = 115;

                                const rightLabelX = 125;
                                const rightValueX = 145;
                                const rightLineEndX = 190;

                               // === Row 1: Patient Name & Age ===
                                doc.setFont("helvetica", "bold");
                                doc.text("Patient Name:", leftLabelX, 55);
                                doc.line(leftValueX, 55, leftLineEndX, 55);

                                doc.text("Age:", rightLabelX, 55);
                                doc.line(rightValueX, 55, rightLineEndX, 55);

                                doc.setFont("helvetica", "normal");
                                doc.text(patientFullName || "-", leftValueX + 2, 54);
                                doc.text(patientAge || "-", rightValueX + 2, 54);

                                // === Row 2: Date Issued & Branch ===
                                const row2Y = 67;
                                doc.setFont("helvetica", "bold");
                                doc.text("Date Issued:", leftLabelX, row2Y);
                                doc.line(leftValueX, row2Y, leftLineEndX, row2Y);

                                doc.text("Branch:", rightLabelX, row2Y);
                                doc.line(rightValueX, row2Y, rightLineEndX, row2Y);

                                doc.setFont("helvetica", "normal");
                                const formattedDate = data.date_created
                                    ? new Date(data.date_created).toLocaleDateString("en-US", {
                                        year: "numeric",
                                        month: "long",
                                        day: "numeric"
                                    })
                                    : "-";
                                doc.text(formattedDate, leftValueX + 2, row2Y - 1);
                                doc.text(data.branch || "-", rightValueX + 2, row2Y - 1);

                                // ===== PRESCRIPTIONS =====
                                const prescripY = row2Y + 15;
                                doc.setFont("helvetica", "bold");
                                doc.text("Prescription:", 10, prescripY);

                                doc.setFontSize(22);
                                doc.setFont("helvetica", "bolditalic");
                                doc.text("Rx", 12, prescripY + 15);
                                doc.setFontSize(12);
                                doc.setFont("helvetica", "normal");

                                let y = prescripY + 25;

                                doc.setFont("helvetica", "normal");
                                if (data.prescriptions && data.prescriptions.length > 0) {
                                    data.prescriptions.forEach((p, index) => {
                                        if (y > pageHeight - 40) {
                                            doc.addPage();
                                            y = 20;
                                        }

                                        doc.text(`${index + 1}. ${p.drug} | ${p.dosage} | ${p.frequency} | ${p.duration} | Qty: ${p.quantity}`, 10, y);
                                        y += 6;

                                        if (p.instructions) {
                                            doc.text(`   Notes: ${p.instructions}`, 15, y);
                                            y += 6;
                                        }
                                        y += 3;
                                    });
                                } else {
                                    doc.text("No prescriptions recorded.", 10, y);
                                }

                                // ===== SIGNATURE =====
                                if (data.dentist_last_name || data.dentist_first_name) {
                                    let sigY = y + 5;
                                    if (sigY < 60) sigY = 60;

                                    if (sigY > pageHeight - 80) {
                                        doc.addPage();
                                        sigY = 50;
                                    }

                                    const sigUrl = `${BASE_URL}/images/dentists/signature/${data.signature_image}`;
                                    let hasSignature = false;

                                    if (data.signature_image) {
                                        try {
                                            const sigBase64 = await getBase64ImageFromUrl(sigUrl);
                                            doc.addImage(sigBase64, "PNG", 125, sigY, 50, 30);
                                            hasSignature = true;
                                        } catch (err) {
                                            console.warn("Could not load signature", err);
                                        }
                                    }

                                    const lineY = hasSignature ? sigY + 35 : sigY + 25;
                                    doc.line(120, lineY, 200, lineY);

                                    const nameY = lineY + 10;
                                    const licenseY = lineY + 20;

                                    const dentistFullName = `${data.dentist_last_name}, ${data.dentist_first_name} ${
                                        data.dentist_middle_name ? data.dentist_middle_name[0] + '.' : ''
                                    }`;

                                    doc.text("Dr. " + dentistFullName, 160, nameY, { align: "center" });
                                    doc.text("License No: " + (data.license_number ?? "-"), 160, licenseY, { align: "center" });
                                }

                                // ===== PAGE NUMBERS =====
                                const pageCount = doc.internal.getNumberOfPages();
                                for (let i = 1; i <= pageCount; i++) {
                                    doc.setPage(i);
                                    doc.setFontSize(10);
                                    doc.setFont("helvetica", "normal");
                                    doc.text(`Page ${i} of ${pageCount}`, 105, pageHeight - 10, { align: "center" });
                                }

                                // Save PDF
                                const safeName = (data.patient_last_name || "patient").replace(/\s+/g, "_");
                                const safeDate = (data.date_created ? data.date_created.split(" ")[0] : "unknown");
                                const fileName = `${safeName}_${safeDate}.pdf`;
                                doc.save(fileName);

                                // ===== UPDATE STATUS =====
                                try {
                                    const res = await fetch(
                                        `${BASE_URL}/Patient/processes/profile/update_prescription_status.php`,
                                        {
                                            method: "POST",
                                            headers: { "Content-Type": "application/json" },
                                            body: JSON.stringify({
                                                transaction_id: data.dental_transaction_id
                                            })
                                        }
                                    );

                                    const json = await res.json();

                                    if (json.success) {
                                        btn.textContent = "Issued";
                                        btn.disabled = true;
                                    } else {
                                        console.error("Update failed:", json.error);
                                        window.location.href = `${BASE_URL}/Patient/processes/profile/update_prescription_status.php?error=1`;
                                    }
                                } catch (err) {
                                    console.error("Update fetch error:", err);
                                    window.location.href = `${BASE_URL}/Patient/processes/profile/update_prescription_status.php?error=1`;
                                }
                            });
                        }
                    }
                })
                .catch(err => {
                    if (type === "appointment") {
                        appointmentBody.innerHTML = `<p style="color:red;">Error loading details</p>`;
                        appointmentModal.style.display = "block";
                    } else {
                        transactionBody.innerHTML = `<p style="color:red;">Error loading details</p>`;
                        transactionModal.style.display = "block";
                    }
                });
        }
    });

    window.onclick = (e) => {
        if (e.target == appointmentModal) {
            appointmentModal.style.display = "none";
        }
        if (e.target == transactionModal) {
            transactionModal.style.display = "none";
        }
    };

    document.body.addEventListener("click", function(e) {
        if (e.target && e.target.id === "requestMedicalCertificate") {
            const medCertModal = document.getElementById("medCertModal");
            const transactionId = e.target.getAttribute("data-id");
            document.getElementById("transactionIdInput").value = transactionId;
            medCertModal.style.display = "block";
        }
    });

    window.addEventListener("click", (e) => {
        const medCertModal = document.getElementById("medCertModal");
        if (e.target === medCertModal) {
            medCertModal.style.display = "none";
        }
    });

    document.body.addEventListener("click", async function (e) {
        if (e.target && e.target.id === "viewMedCertReceipt") {
            const transactionId = e.target.getAttribute("data-id");

            try {
                const response = await fetch(`${BASE_URL}/Patient/processes/profile/get_medcert_receipt.php?id=${transactionId}`);
                const data = await response.json();

                if (data.success && data.file_path) {
                    const imgUrl = `${BASE_URL}${data.file_path}`;
                    const modal = document.getElementById("medCertReceiptModal");
                    const modalBody = document.getElementById("medCertReceiptBody");

                    modalBody.innerHTML = `
                        <h2>Dental Certificate Payment Receipt</h2>
                        <img src="${imgUrl}" alt="Dental Certificate Receipt" style="width:50%;display:block;margin:auto;border-radius:4px;">
                    `;
                    modal.style.display = "flex";
                }
            } catch (error) {
                console.error("Error loading receipt:", error);
            }
        }
    });

    document.body.addEventListener("click", async function (e) {
        if (e.target && e.target.id === "viewXrayResult") {
            const transactionId = e.target.getAttribute("data-id");

            try {
                const response = await fetch(`${BASE_URL}/Patient/processes/profile/get_xray_results.php?id=${transactionId}`);
                const data = await response.json();

                if (data.success && data.files.length > 0) {
                    const modal = document.getElementById("medCertReceiptModal");
                    const modalBody = document.getElementById("medCertReceiptBody");

                    let html = `<h2>X-ray Result</h2>`;

                    data.files.forEach((item) => {
                        const file = item.file_path;

                        const createdDate = item.date_created
                            ? new Date(item.date_created).toLocaleDateString("en-US", {
                                month: "long",
                                day: "numeric",
                                year: "numeric",
                            })
                            : "Unknown Date";

                        let fixedPath = file.startsWith("/") ? file : "/" + file;
                        const fileUrl = `${BASE_URL}${fixedPath}`;
                        const isPdf = file.toLowerCase().endsWith(".pdf");

                        html += `
                            <div style="margin:20px 0; text-align:center;">
                                <p style="margin-top:-10px; color:#777; font-size:14px;">${createdDate}</p>
                                ${
                                    isPdf
                                        ? `<iframe src="${fileUrl}" style="width:80%; height:500px; border:none;"></iframe>`
                                        : `<img src="${fileUrl}" style="width:50%; border-radius:5px; display:block; margin:auto;">`
                                }
                            </div>
                        `;
                    });

                    modalBody.innerHTML = html;
                    modal.style.display = "flex";

                } else {
                    alert("No X-ray results available.");
                }
            } catch (error) {
                console.error("Error loading x-ray results:", error);
            }
        }
    });
});
