// ── Navbar scroll effect ──────────────────────
const navbar = document.getElementById('navbar');

function updateNavbar() {
    if (window.scrollY > 40) {
        navbar.classList.add('scrolled');
    } else {
        navbar.classList.remove('scrolled');
    }
}

// Check on page load immediately
updateNavbar();
window.addEventListener('scroll', updateNavbar);

// ── Mobile Menu ────────────────────────────────
const hamburger = document.getElementById('hamburger');
const navLinks = document.querySelector('.nav-links');
if (hamburger) {
    hamburger.addEventListener('click', () => {
        navLinks.classList.toggle('open');
        hamburger.classList.toggle('active');
    });
    document.addEventListener('click', (e) => {
        if (!hamburger.contains(e.target) && !navLinks.contains(e.target)) {
            navLinks.classList.remove('open');
        }
    });
}

// ── Auto-remove flash messages ─────────────────
document.querySelectorAll('.flash').forEach(f => {
    setTimeout(() => {
        f.style.opacity = '0';
        f.style.transform = 'translateX(40px)';
        f.style.transition = 'all 0.4s ease';
        setTimeout(() => f.remove(), 400);
    }, 5000);
});

// ── Scroll reveal animation ────────────────────
const observer = new IntersectionObserver((entries) => {
    entries.forEach(e => {
        if (e.isIntersecting) {
            e.target.style.opacity = '1';
            e.target.style.transform = 'translateY(0)';
        }
    });
}, { threshold: 0.1 });

document.querySelectorAll('.package-card, .why-card, .testimonial-card').forEach(el => {
    el.style.opacity = '0';
    el.style.transform = 'translateY(24px)';
    el.style.transition = 'all 0.6s ease';
    observer.observe(el);
});