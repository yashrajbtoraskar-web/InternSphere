/* ============================================================
   FORMS.JS — Form validation & dynamic UI
   ============================================================ */

document.addEventListener('DOMContentLoaded', () => {
    initFormValidation();
    initDeleteConfirm();
});

function initFormValidation() {
    document.querySelectorAll('form').forEach(form => {
        form.addEventListener('submit', (e) => {
            const btn = form.querySelector('button[type="submit"]');
            if (btn && !btn.disabled) {
                btn.disabled = true;
                btn.style.opacity = '0.7';
                const origText = btn.innerHTML;
                btn.innerHTML = '&#9203; Processing...';
                setTimeout(() => {
                    btn.disabled = false;
                    btn.style.opacity = '1';
                    btn.innerHTML = origText;
                }, 5000);
            }
        });
    });

    // Real-time CGPA validation
    document.querySelectorAll('input[name="cgpa"]').forEach(input => {
        input.addEventListener('input', () => {
            const val = parseFloat(input.value);
            if (val > 10) input.value = '10.00';
            if (val < 0) input.value = '0.00';
        });
    });
}

function initDeleteConfirm() {
    document.querySelectorAll('form[onsubmit]').forEach(form => {
        form.style.display = 'inline';
    });
}
