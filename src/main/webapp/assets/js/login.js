/*
  FOODRUSH LOGIN — JavaScript
  Each food PNG is a separate cutout positioned individually.
  Animations target .float-wrap inside each named #layer ID.
*/

document.addEventListener('DOMContentLoaded', () => {

    const container   = document.getElementById('loginContainer');
    const composition = document.getElementById('foodComposition');
    const loginForm   = document.getElementById('loginForm');
    const submitBtn   = document.getElementById('submitBtn');
    const pwInput     = document.getElementById('passwordInput');
    const pwToggle    = document.getElementById('pwToggle');
    const eyeIcon     = document.getElementById('eyeIcon');

    const qs  = (sel) => document.querySelector(sel);
    const qsa = (sel) => [...document.querySelectorAll(sel)];

    const existing = (selectors) =>
        (Array.isArray(selectors) ? selectors : [selectors])
            .flatMap((sel) => {
                const node = qs(sel);
                return node ? [node] : [];
            });

    const revealPage = () => {
        if (container) container.style.opacity = '1';
        qsa('.food-item, .feature-item').forEach((el) => { el.style.opacity = '1'; });
    };

    if (typeof gsap === 'undefined') {
        console.warn('FoodRush login: GSAP not loaded, skipping animations.');
        revealPage();
        return;
    }

    const reducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
    const fallbackTimer = setTimeout(revealPage, 2500);

    if (!reducedMotion) {

        /* PREVENT FOUC (Flash of Unstyled Content) */
        gsap.set('.animate-on-load', { visibility: 'visible' });

        /* 1. BACKGROUND is already visible and stationary */

        /* 2. FOODRUSH LOGO */
        gsap.set('#logoWrapper', { opacity: 0, x: -25, y: -10, scale: 0.97 });

        /* 3. GOOD FOOD HEADING */
        gsap.set('#headingRow1', { opacity: 0, y: 30, clipPath: 'inset(100% 0% 0% 0%)' });

        /* 4. GREAT MOOD! */
        gsap.set('#headingRow2', { opacity: 0, x: -25, scale: 0.96 });

        /* 5. DESCRIPTION */
        gsap.set('#brandingDesc', { opacity: 0, y: 15, filter: 'blur(5px)' });

        /* 6. SMARTPHONE */
        gsap.set('#phoneLayer .float-wrap', { opacity: 0, y: 70, scale: 0.92 });

        /* 7. SCOOTER */
        gsap.set('#scooterLayer .float-wrap', { opacity: 0, x: -140, y: 8, rotation: -1.5 });

        /* 8. BURGER AND WOODEN BOARD */
        gsap.set('#boardLayer .float-wrap', { opacity: 0, x: -35, y: 20, scale: 0.96 });
        gsap.set('#burgerLayer .float-wrap', { opacity: 0, y: 45, scale: 0.88 });

        /* 9. FRENCH FRIES */
        gsap.set('#friesLayer .float-wrap', { opacity: 0, x: -55, rotation: -3, scale: 0.95 });

        /* 10. KETCHUP BOWL */
        gsap.set('#ketchupLayer .float-wrap', { opacity: 0, scale: 0.65, y: 8 });

        /* 11. PASTA BOWL */
        gsap.set('#pastaLayer .float-wrap', { opacity: 0, x: 70, y: 10, scale: 0.95 });

        /* 12. PIZZA */
        gsap.set('#pizzaLayer .float-wrap', { opacity: 0, y: 90, scale: 0.88 });

        /* 13. GREEN LEAVES */
        gsap.set([
            '#leaf1Layer .float-wrap', '#leaf2Layer .float-wrap',
            '#leaf3Layer .float-wrap', '#leaf4Layer .float-wrap'
        ], { opacity: 0, scale: 0.75, y: 12 });

        /* 14. FEATURE CARD */
        gsap.set('#featuresCard', { opacity: 0, y: 45, scale: 0.98 });
        gsap.set('.feature-item', { opacity: 0, y: 12 });

        /* RIGHT PANEL EXTRAS */
        gsap.set('.sparkle', { opacity: 0, scale: 0.6 });
        gsap.set('.dot-grid', { opacity: 0 });

        /* 15. WELCOME BACK HEADING */
        gsap.set('#formTitle', { opacity: 0, x: 35, filter: 'blur(4px)' });
        gsap.set('#formSubtitle', { opacity: 0, y: 10 });

        /* 16. LOGIN FORM - STAGGERED UI ENTRANCE */
        const formStaggerList = [];
        if (qs('#alertMsg')) formStaggerList.push(qs('#alertMsg'));
        
        qsa('.field-group').forEach(group => {
            const label = group.querySelector('.field-label');
            const box = group.querySelector('.field-box');
            if (label) formStaggerList.push(label);
            if (box) formStaggerList.push(box);
        });
        
        const meta = qs('#formMeta');
        if (meta) formStaggerList.push(meta);
        const prompt = qs('#signupPrompt');
        if (prompt) formStaggerList.push(prompt);
        
        const formInputs = qsa('.field-box input, .field-box textarea');

        gsap.set(formStaggerList, { opacity: 0, y: 18 });
        gsap.set(formInputs, { scale: 0.985 });

        /* 17. LOGIN BUTTON */
        gsap.set('#submitBtn', { opacity: 0, y: 20, scale: 0.96 });

        const tl = gsap.timeline({
            defaults: { ease: 'power3.out' },
            onComplete: () => {
                clearTimeout(fallbackTimer);
                gsap.set('#brandingDesc', { clearProps: 'filter' });
                gsap.set('#formTitle', { clearProps: 'filter' });
            }
        });

        tl
        /* 0.15s -> Logo begins */
        .to('#logoWrapper', { opacity: 1, x: 0, y: 0, scale: 1, duration: 0.8 }, 0.15)
        
        /* 0.30s -> Heading begins */
        .to('#headingRow1', { opacity: 1, y: 0, clipPath: 'inset(0% 0% 0% 0%)', duration: 0.9, ease: 'power3.out' }, 0.30)
        
        /* 0.35s -> Great Mood! */
        .to('#headingRow2', { opacity: 1, x: 0, scale: 1, duration: 0.8, ease: 'power2.out' }, 0.35)
        
        /* 0.45s -> Description begins */
        .to('#brandingDesc', { opacity: 1, y: 0, filter: 'blur(0px)', duration: 0.7, ease: 'power2.out' }, 0.45)
        
        /* 0.60s -> Phone begins (Vertical rise then settle) */
        .to('#phoneLayer .float-wrap', { opacity: 1, y: -2, scale: 1, duration: 1.2, ease: 'power3.out' }, 0.60)
        .to('#phoneLayer .float-wrap', { y: 0, duration: 0.4, ease: 'power2.inOut' }, ">-0.2")

        /* 0.75s -> Scooter begins (Drive in then settle) */
        .to('#scooterLayer .float-wrap', { opacity: 1, x: 0, y: 0, rotation: 0, duration: 1.2, ease: 'power3.out' }, 0.75)
        .to('#scooterLayer .float-wrap', { y: -2, duration: 0.15, ease: 'power2.out' }, ">-0.1")
        .to('#scooterLayer .float-wrap', { y: 0, duration: 0.15, ease: 'power2.in' }, ">")

        /* 0.90s -> Board then Burger (Layered Reveal) */
        .to('#boardLayer .float-wrap', { opacity: 1, x: 0, y: 0, scale: 1, duration: 0.9, ease: 'power3.out' }, 0.90)
        .to('#burgerLayer .float-wrap', { opacity: 1, y: 0, scale: 1, duration: 0.9, ease: 'power3.out' }, 1.05)

        /* 1.10s -> Fries begin */
        .to('#friesLayer .float-wrap', { opacity: 1, x: 0, rotation: 0, scale: 1, duration: 0.8, ease: 'power2.out' }, 1.10)
        
        /* 1.15s -> Ketchup begins */
        .to('#ketchupLayer .float-wrap', { opacity: 1, scale: 1, y: 0, duration: 0.6, ease: 'power2.out' }, 1.15)
        
        /* 1.20s -> Pasta begins */
        .to('#pastaLayer .float-wrap', { opacity: 1, x: 0, y: 0, scale: 1, duration: 1.1, ease: 'power3.out' }, 1.20)
        
        /* 1.35s -> Pizza begins */
        .to('#pizzaLayer .float-wrap', { opacity: 1, y: 0, scale: 1, duration: 1.2, ease: 'power3.out' }, 1.35)
        
        /* 1.45s -> Feature card begins */
        .to('#featuresCard', { opacity: 1, y: 0, scale: 1, duration: 1.0, ease: 'power3.out' }, 1.45)
        .to('.feature-item', { opacity: 1, y: 0, duration: 0.6, stagger: 0.1, ease: 'power2.out' }, 1.55)
        
        /* Right Panel Background Decor */
        .to('.sparkle', { opacity: 1, scale: 1, duration: 0.7, stagger: 0.15, ease: 'power2.out' }, 1.30)
        .to('.dot-grid', { opacity: 1, duration: 0.6 }, 1.40)

        /* 0.55s / 0.70s -> Login heading begins */
        .to('#formTitle', { opacity: 1, x: 0, filter: 'blur(0px)', duration: 0.9, ease: 'power2.out' }, 0.55)
        .to('#formSubtitle', { opacity: 1, y: 0, duration: 0.7, ease: 'power2.out' }, 0.70)
        
        /* 1.20s -> Login form controls continue revealing */
        .to(formStaggerList, { opacity: 1, y: 0, duration: 0.75, stagger: 0.12, ease: 'power3.out' }, 1.20)
        .to(formInputs, { scale: 1, duration: 0.6, stagger: 0.12, ease: 'power2.out' }, 1.25)
        
        /* 17. LOGIN BUTTON (Special Reveal) */
        .to('#submitBtn', { opacity: 1, y: 0, scale: 1, duration: 0.8, ease: 'power3.out' }, 1.6)
        
        /* 1.80s -> Green Leaves Staggered Organic Reveal */
        .to('#leaf1Layer .float-wrap', { opacity: 1, scale: 1, x: 0, y: 0, rotation: "+=5", duration: 0.8, ease: 'sine.out' }, 1.80)
        .to('#leaf2Layer .float-wrap', { opacity: 1, scale: 1, x: 0, y: 0, rotation: "-=8", duration: 0.75, ease: 'sine.out' }, 1.88)
        .to('#leaf3Layer .float-wrap', { opacity: 1, scale: 1, x: 0, y: 0, rotation: "+=6", duration: 0.85, ease: 'sine.out' }, 1.96)
        .to('#leaf4Layer .float-wrap', { opacity: 1, scale: 1, x: 0, y: 0, rotation: "-=5", duration: 0.9, ease: 'sine.out' }, 2.04);
        
        /* Add continuous float to leaves */
        gsap.to(['#leaf1Layer .float-wrap', '#leaf2Layer .float-wrap', '#leaf3Layer .float-wrap', '#leaf4Layer .float-wrap'], {
            y: "+=3", rotation: "+=2", duration: 4, repeat: -1, yoyo: true, ease: 'sine.inOut', delay: 3.5
        });

        /* Button Hover Effects */
        const btn = qs('#submitBtn');
        if (btn) {
            btn.addEventListener('mouseenter', () => gsap.to(btn, { y: -2, scale: 1.01, duration: 0.2, ease: 'power2.out', overwrite: 'auto' }));
            btn.addEventListener('mouseleave', () => gsap.to(btn, { y: 0, scale: 1, duration: 0.2, ease: 'power2.out', overwrite: 'auto' }));
            btn.addEventListener('mousedown', () => gsap.to(btn, { scale: 0.98, duration: 0.1, ease: 'power1.inOut', overwrite: 'auto' }));
            btn.addEventListener('mouseup', () => gsap.to(btn, { scale: 1.01, duration: 0.1, ease: 'power1.inOut', overwrite: 'auto' }));
        }

    } else {
        clearTimeout(fallbackTimer);
        gsap.set([
            container,
            '#logoWrapper', '#headingRow1', '#headingRow2', '#brandingDesc',
            '#phoneLayer .float-wrap', '#boardLayer .float-wrap',
            '#burgerLayer .float-wrap', '#friesLayer .float-wrap',
            '#ketchupLayer .float-wrap', '#scooterLayer .float-wrap',
            '#pizzaLayer .float-wrap', '#pastaLayer .float-wrap',
            '#leaf1Layer .float-wrap', '#leaf2Layer .float-wrap',
            '#leaf3Layer .float-wrap', '#leaf4Layer .float-wrap',
            '#featuresCard', '.feature-item',
            '#loginRight', '.sparkle', '.dot-grid',
            ...existing([
                '#formTitle', '#formSubtitle', '#groupUsername .field-label', '#groupUsername .field-box',
                '#groupPassword .field-label', '#groupPassword .field-box',
                '#formMeta', '#submitBtn', '#signupPrompt', '#alertMsg'
            ])
        ], { opacity: 1, x: 0, y: 0, scale: 1, rotate: 0, clearProps: 'all' });
        gsap.set('.animate-on-load', { visibility: 'visible' });
    }





    /* ── Password toggle ── */
    const EYE_OPEN = `
        <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
        <circle cx="12" cy="12" r="3"/>`;
    const EYE_CLOSED = `
        <path d="M17.94 17.94A10.07 10.07 0 0112 20c-7 0-11-8-11-8a18.45 18.45 0 015.06-5.94M9.9 4.24A9.12 9.12 0 0112 4c7 0 11 8 11 8a18.5 18.5 0 01-2.16 3.19m-6.72-1.07a3 3 0 11-4.24-4.24"/>
        <line x1="1" y1="1" x2="23" y2="23"/>`;

    if (pwToggle && pwInput && eyeIcon) {
        pwToggle.addEventListener('click', () => {
            const isHidden = pwInput.type === 'password';
            pwInput.type = isHidden ? 'text' : 'password';
            eyeIcon.innerHTML = isHidden ? EYE_CLOSED : EYE_OPEN;
            pwToggle.setAttribute('aria-label', isHidden ? 'Hide password' : 'Show password');

            if (!reducedMotion) {
                gsap.fromTo(pwToggle,
                    { scale: 1 },
                    { scale: 0.8, duration: 0.08, yoyo: true, repeat: 1, ease: 'power2.inOut' }
                );
            }
        });
    }


    /* ── Submit animation ── */
    if (loginForm && submitBtn) {
        let submitting = false;

        loginForm.addEventListener('submit', (e) => {
            if (submitting) return;
            e.preventDefault();
            submitting = true;

            const label   = submitBtn.querySelector('.btn-label');
            const spinner = submitBtn.querySelector('.btn-spinner');
            if (label)   label.style.display   = 'none';
            if (spinner) spinner.style.display = 'inline-block';
            submitBtn.style.pointerEvents = 'none';

            if (!reducedMotion) {
                const exitTl = gsap.timeline({
                    onComplete: () => loginForm.submit()
                });

                /* Food elements float up and fade out */
                exitTl.to(qsa('.food-item .float-wrap'), {
                    y: -30, opacity: 0, duration: 0.45, stagger: 0.02, ease: 'power2.in'
                }, 0);

                /* Left side content slides left and fades out */
                exitTl.to(['#logoWrapper', '.left-content', '#featuresCard'], {
                    x: -40, opacity: 0, duration: 0.45, stagger: 0.05, ease: 'power2.in'
                }, 0);

                /* Right form container slides right and fades out */
                exitTl.to('#formWrapper', {
                    x: 40, opacity: 0, duration: 0.45, ease: 'power2.in'
                }, 0.1);
                
                /* Optional: fade the background slightly just before submit */
                exitTl.to(container, { opacity: 0, duration: 0.3 }, 0.4);

            } else {
                loginForm.submit();
            }
        });
    }

});
