document.addEventListener('DOMContentLoaded', () => {
    const editBtn = document.getElementById('editBtn');
    const cancelBtn = document.getElementById('cancelBtn');
    const profileCard = document.querySelector('.profile-card');
    const inputs = document.querySelectorAll('.profile-input');
    
    // Store original values to restore on Cancel
    const originalValues = {};
    
    if (editBtn && cancelBtn && profileCard) {
        editBtn.addEventListener('click', () => {
            profileCard.classList.add('is-editing');
            inputs.forEach(input => {
                originalValues[input.name] = input.value;
                input.removeAttribute('readonly');
            });
            if (inputs.length > 0) {
                inputs[0].focus();
            }
        });
        
        cancelBtn.addEventListener('click', () => {
            profileCard.classList.remove('is-editing');
            inputs.forEach(input => {
                input.value = originalValues[input.name] || '';
                input.setAttribute('readonly', 'true');
            });
        });
    }

    // Auto-dismiss alert messages with smooth transition collapse
    document.querySelectorAll('.alert').forEach(alert => {
        if (!alert.querySelector('.alert-close-btn')) {
            const closeBtn = document.createElement('button');
            closeBtn.className = 'alert-close-btn';
            closeBtn.innerHTML = '&times;';
            closeBtn.addEventListener('click', (e) => {
                e.preventDefault();
                dismissAlert(alert);
            });
            alert.appendChild(closeBtn);
        }

        // Auto dismiss after 3 seconds
        setTimeout(() => {
            dismissAlert(alert);
        }, 3000);
    });

    function dismissAlert(alert) {
        if (!alert) return;
        alert.style.transition = 'all 0.3s cubic-bezier(0.4, 0, 0.2, 1)';
        const currentHeight = alert.offsetHeight;
        alert.style.height = currentHeight + 'px';
        
        alert.offsetHeight; // Force reflow

        alert.style.opacity = '0';
        alert.style.transform = 'translateY(-8px)';
        alert.style.height = '0';
        alert.style.paddingTop = '0';
        alert.style.paddingBottom = '0';
        alert.style.marginTop = '0';
        alert.style.marginBottom = '0';
        alert.style.borderWidth = '0';
        alert.style.overflow = 'hidden';

        setTimeout(() => {
            alert.remove();
        }, 300);
    }
});
