// Smooth scroll to section
function scrollToSection(sectionId) {
    document.getElementById(sectionId).scrollIntoView({ behavior: "smooth" });
}

// Fade-in animation when section enters viewport
const observer = new IntersectionObserver(entries => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.classList.add('visible');
        }
    });
}, { threshold: 0.2 });

// Apply observer to all sections
const sections = document.querySelectorAll('.fade-in');
sections.forEach(sec => observer.observe(sec));

// Adding visible class styling via JS
// (CSS class will handle animation)

// Floating glowing cursor effect (extra animation)
document.addEventListener('mousemove', function(e) {
    let glow = document.getElementById('cursor-glow');
    if (glow) {
        glow.style.left = e.pageX + 'px';
        glow.style.top = e.pageY + 'px';
    }
});

// Create the glow element dynamically
window.onload = () => {
    const glow = document.createElement('div');
    glow.id = 'cursor-glow';
    glow.style.position = 'absolute';
    glow.style.width = '25px';
    glow.style.height = '25px';
    glow.style.borderRadius = '50%';
    glow.style.pointerEvents = 'none';
    glow.style.background = 'rgba(10, 214, 255, 0.5)';
    glow.style.boxShadow = '0 0 25px rgba(10, 214, 255, 0.8)';
    glow.style.transform = 'translate(-50%, -50%)';
    document.body.appendChild(glow);
};
