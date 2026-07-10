document.addEventListener('DOMContentLoaded', () => {
    const navbar = document.querySelector('.navbar');
    if (!navbar) return;
    
    const hasHero = document.querySelector('.hero-section') !== null;
    
    // Non-hero pages get dynamic body padding to offset the fixed navbar
    if (!hasHero) {
        document.body.style.paddingTop = navbar.offsetHeight + 'px';
    } else {
        navbar.classList.add('navbar-transparent');
    }
    
    let lastScrollY = window.scrollY;
    
    window.addEventListener('scroll', () => {
        // Handle transparent / scrolled transition
        if (window.scrollY > 20) {
            navbar.classList.add('navbar-scrolled');
            if (hasHero) {
                navbar.classList.remove('navbar-transparent');
            }
        } else {
            navbar.classList.remove('navbar-scrolled');
            if (hasHero) {
                navbar.classList.add('navbar-transparent');
            }
        }
        
        // YouTube style hide/show on scroll
        if (window.scrollY > lastScrollY && window.scrollY > 150) {
            // Scrolling down - hide
            navbar.classList.add('navbar-hidden');
        } else {
            // Scrolling up - show
            navbar.classList.remove('navbar-hidden');
        }
        
        lastScrollY = window.scrollY;
    }, { passive: true });
    
    // Scroll Reveal Intersection Observer for Apple-like entrance transitions
    const revealObserver = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('reveal-visible');
                revealObserver.unobserve(entry.target);
            }
        });
    }, {
        threshold: 0.08,
        rootMargin: '0px 0px -50px 0px'
    });
    
    // Observe elements to reveal them on scroll
    const revealElements = document.querySelectorAll(
        '.category-slide, .restaurant-card-wrapper, .offer-card-wrapper, .testimonial-card-wrapper'
    );
    revealElements.forEach(el => {
        el.classList.add('reveal');
        revealObserver.observe(el);
    });
});
