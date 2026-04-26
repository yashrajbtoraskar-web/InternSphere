/* ============================================================
   COMMON.JS — InternSphere Micro-interactions & UX
   ============================================================ */

document.addEventListener('DOMContentLoaded', () => {
    initAnimations();
    initAlertDismiss();
    initSearchFilter();
    initTooltips();
});

/* ---- Scroll-triggered fade-in ---- */
function initAnimations() {
    const observerOpts = { threshold: 0.1, rootMargin: '0px 0px -40px 0px' };
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('animate-in');
                observer.unobserve(entry.target);
            }
        });
    }, observerOpts);

    document.querySelectorAll('.stat-card, .opportunity-card, .card, .table-container, .inline-form, .form-card, .system-status, .eligibility-panel').forEach(el => {
        el.style.opacity = '0';
        el.style.transform = 'translateY(16px)';
        el.style.transition = 'opacity 0.5s cubic-bezier(0.4,0,0.2,1), transform 0.5s cubic-bezier(0.4,0,0.2,1)';
        observer.observe(el);
    });

    // Stagger stat cards
    document.querySelectorAll('.stats-grid .stat-card').forEach((card, i) => {
        card.style.transitionDelay = (i * 80) + 'ms';
    });
}

// Trigger animation class
const style = document.createElement('style');
style.textContent = '.animate-in { opacity: 1 !important; transform: translateY(0) !important; }';
document.head.appendChild(style);

/* ---- Auto-dismiss alerts ---- */
function initAlertDismiss() {
    document.querySelectorAll('.alert').forEach(alert => {
        setTimeout(() => {
            alert.style.transition = 'opacity 0.4s, transform 0.4s, max-height 0.4s';
            alert.style.opacity = '0';
            alert.style.transform = 'translateY(-8px)';
            alert.style.maxHeight = '0';
            alert.style.padding = '0';
            alert.style.margin = '0';
            alert.style.overflow = 'hidden';
        }, 5000);
    });
}

/* ---- Global Search Filter ---- */
function initSearchFilter() {
    const search = document.getElementById('globalSearch');
    if (!search) return;
    search.addEventListener('input', (e) => {
        const q = e.target.value.toLowerCase();
        document.querySelectorAll('tbody tr').forEach(row => {
            const text = row.textContent.toLowerCase();
            row.style.display = text.includes(q) ? '' : 'none';
        });
    });
}

/* ---- Tooltips ---- */
function initTooltips() {
    document.querySelectorAll('[title]').forEach(el => {
        el.addEventListener('mouseenter', (e) => {
            const tip = document.createElement('div');
            tip.className = 'tooltip-popup';
            tip.textContent = el.getAttribute('title');
            tip.style.cssText = 'position:fixed;padding:4px 10px;background:var(--surface-highest);color:var(--on-surface);font-size:11px;border-radius:4px;z-index:9999;pointer-events:none;white-space:nowrap;box-shadow:0 2px 8px rgba(0,0,0,0.3)';
            document.body.appendChild(tip);
            const rect = el.getBoundingClientRect();
            tip.style.left = rect.left + rect.width / 2 - tip.offsetWidth / 2 + 'px';
            tip.style.top = rect.top - tip.offsetHeight - 6 + 'px';
            el._tooltip = tip;
            el._origTitle = el.getAttribute('title');
            el.removeAttribute('title');
        });
        el.addEventListener('mouseleave', (e) => {
            if (el._tooltip) { el._tooltip.remove(); el.setAttribute('title', el._origTitle); }
        });
    });
}

/* ---- Ripple Effect on Buttons ---- */
document.addEventListener('click', (e) => {
    const btn = e.target.closest('.btn');
    if (!btn) return;
    const ripple = document.createElement('span');
    const rect = btn.getBoundingClientRect();
    const size = Math.max(rect.width, rect.height);
    ripple.style.cssText = `position:absolute;width:${size}px;height:${size}px;border-radius:50%;background:rgba(255,255,255,0.2);transform:scale(0);animation:ripple 0.6s ease-out;pointer-events:none;left:${e.clientX - rect.left - size/2}px;top:${e.clientY - rect.top - size/2}px`;
    btn.style.position = 'relative';
    btn.style.overflow = 'hidden';
    btn.appendChild(ripple);
    setTimeout(() => ripple.remove(), 600);
});

const rippleStyle = document.createElement('style');
rippleStyle.textContent = '@keyframes ripple{to{transform:scale(2.5);opacity:0}}';
document.head.appendChild(rippleStyle);

/* ---- Stat Bar Animation ---- */
document.querySelectorAll('.stat-bar span').forEach(bar => {
    const h = bar.style.height;
    bar.style.height = '0';
    setTimeout(() => { bar.style.height = h; }, 300 + Math.random() * 500);
});

/* ---- Number Counter Animation ---- */
document.querySelectorAll('.stat-value').forEach(el => {
    const val = parseInt(el.textContent);
    if (isNaN(val) || val === 0) return;
    let current = 0;
    const step = Math.max(1, Math.floor(val / 30));
    const interval = setInterval(() => {
        current += step;
        if (current >= val) { current = val; clearInterval(interval); }
        el.textContent = current.toLocaleString();
    }, 30);
});
