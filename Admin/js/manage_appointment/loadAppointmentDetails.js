document.addEventListener("DOMContentLoaded", function () {
    const appointmentCard = document.getElementById("appointmentCard");
    if (!appointmentCard) return;

    fetch(`${BASE_URL}/Admin/processes/manage_appointment/get_appointment_details.php?id=${appointmentId}`)
        .then(response => {
            if (!response.ok) {
                throw new Error("Forbidden or failed to load.");
            }
            return response.json();
        })
        .then(data => {
            if (data.error) {
                appointmentCard.innerHTML = `<p>${data.error}</p>`;
                return;
            }

            appointmentCard.innerHTML = `
                <h3>${data.full_name}</h3>
                <p><strong>Gender:</strong><span>${data.gender}</span></p>
                <p><strong>Date of Birth:</strong><span>${data.date_of_birth}</span></p>
                <p><strong>Email:</strong><span>${data.email}</span></p>
                <p><strong>Contact Number:</strong><span>${data.contact_number}</span></p>
                <p><strong>Address:</strong><span>${data.address}</span></p>
                <p><strong>Registered:</strong><span>${data.joined}</span></p>
                <p><strong>Last Updated:</strong><span>${data.date_updated}</span></p>
                <hr>
                <h3>Appointment Details</h3>
                <p><strong>Appointment ID:</strong><span>${data.appointment_transaction_id}</span></p>
                <p><strong>Branch:</strong><span>${data.branch}</span></p>
                <p><strong>Service:</strong><span>${data.services}</span></p>
                <p><strong>Dentist:</strong><span>${data.dentist}</span></p>
                <p><strong>Date:</strong><span>${data.appointment_date}</span></p>
                <p><strong>Time:</strong><span>${data.appointment_time}</span></p>
                <p><strong>Status:</strong><span>${data.status}</span></p>
                <p><strong>Notes:</strong><span>${data.notes || '-'}</span></p>
                <p><strong>Date Booked:</strong><span>${data.date_created}</span></p>
                <div class="button-group button-group-profile">
                    <button class="confirm-btn" id="markDone">Complete Transaction</button>
                    <button class="confirm-btn" id="reSched">Resched Appointment</button>
                    <button class="cancel-btn-appointment" id="markCancel">Cancel Appointment</button>
                </div>
            `;

            const completeBtn = document.getElementById("markDone");
            const cancelBtn = document.getElementById("markCancel");

            if (completeBtn) {
                completeBtn.addEventListener("click", () => {
                    openStatusModal({
                        action: "complete",
                        formAction: `${BASE_URL}/Admin/processes/manage_appointment/complete_dental_transaction.php`,
                        message: "Are you sure you want to <strong>complete</strong> this patient's transaction?"
                    });
                });
            }

            if (cancelBtn) {
                cancelBtn.addEventListener("click", () => {
                    openStatusModal({
                        action: "cancel",
                        formAction: `${BASE_URL}/Admin/processes/manage_appointment/cancel_appointment.php`,
                        message: "Are you sure you want to <strong>cancel</strong> this patient's transaction?"
                    });
                });
            }

            function openStatusModal({ action, formAction, message }) {
                const modal = document.getElementById("setStatusModal");
                const form = document.getElementById("statusForm");
                const messageBox = document.getElementById("statusMessage");
                const statusInput = document.getElementById("statusValue");
                const userInput = document.getElementById("statusUserId");
                const appointmentInput = document.getElementById("statusAppointmentId");

                form.action = formAction;
                messageBox.innerHTML = message;
                statusInput.value = action;
                userInput.value = data.user_id;
                appointmentInput.value = appointmentId;
                modal.style.display = "block";
            }

            window.closeStatusModal = function () {
                document.getElementById("setStatusModal").style.display = "none";
            };

            window.addEventListener("click", (e) => {
                const modal = document.getElementById("setStatusModal");
                if (e.target === modal) modal.style.display = "none";
            });
        })
        .catch(error => {
            appointmentCard.innerHTML = "<p>Error loading profile.</p>";
            console.error("Fetch error:", error);
        });
});
