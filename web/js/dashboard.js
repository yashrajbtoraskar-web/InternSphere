/* ============================================================
   DASHBOARD.JS — Dashboard-specific interactions
   ============================================================ */

document.addEventListener('DOMContentLoaded', () => {
    initFilterChips();
    initLiveTime();
});

/* ---- Filter Chips Toggle ---- */
function initFilterChips() {
    document.querySelectorAll('.filter-chips .chip').forEach(chip => {
        chip.addEventListener('click', () => {
            document.querySelectorAll('.filter-chips .chip').forEach(c => c.classList.remove('active'));
            chip.classList.add('active');
            // Visual feedback
            chip.style.transform = 'scale(0.95)';
            setTimeout(() => chip.style.transform = '', 150);
        });
    });
}

/* ---- Live Clock in System Status ---- */
function initLiveTime() {
    const timeEl = document.querySelector('.status-item:last-child .text-xs');
    if (!timeEl) return;
    setInterval(() => {
        const now = new Date();
        timeEl.textContent = now.toLocaleTimeString();
    }, 1000);
}
