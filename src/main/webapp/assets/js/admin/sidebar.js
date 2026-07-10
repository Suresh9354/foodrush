/* ==========================================================================
   FOODRUSH ADMIN DASHBOARD - SIDEBAR NAVIGATION JS
   ========================================================================== */

document.addEventListener('DOMContentLoaded', () => {
    // 1. Sync Active Menu Link Based on URL
    const currentPath = window.location.pathname;
    const menuItems = document.querySelectorAll('.sidebar-menu-item');
    
    menuItems.forEach(item => {
        const link = item.querySelector('a');
        if (link) {
            const href = link.getAttribute('href');
            // If the URL matches the menu link, mark as active
            if (currentPath.includes(href) && href !== '#') {
                // Clear previous actives just in case
                menuItems.forEach(i => i.classList.remove('active'));
                item.classList.add('active');
            }
        }
    });

    // 2. Mobile Responsive Sidebar Drawer Toggle
    const mobileToggle = document.getElementById('mobile-sidebar-toggle');
    const sidebar = document.querySelector('.sidebar');
    const overlay = document.querySelector('.sidebar-overlay');

    if (mobileToggle && sidebar && overlay) {
        mobileToggle.addEventListener('click', () => {
            sidebar.classList.add('show');
        });

        // Close sidebar when clicking outside on overlay
        overlay.addEventListener('click', () => {
            sidebar.classList.remove('show');
        });
    }

    // 3. Current Date Display in Topbar
    const dateContainer = document.getElementById('topbar-current-date');
    if (dateContainer) {
        const options = { weekday: 'short', year: 'numeric', month: 'short', day: 'numeric' };
        const today = new Date();
        dateContainer.textContent = today.toLocaleDateString('en-US', options);
    }
});
