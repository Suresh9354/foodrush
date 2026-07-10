document.addEventListener('DOMContentLoaded', () => {
    const passwordInput = document.getElementById('passwordInput');
    const strengthFill = document.getElementById('strengthFill');
    const strengthText = document.getElementById('strengthText');
    const strengthContainer = document.getElementById('strengthContainer');
    
    if (passwordInput && strengthFill) {
        passwordInput.addEventListener('input', () => {
            const val = passwordInput.value;
            let score = 0;
            
            if (val.length >= 6) score++;
            if (/[A-Z]/.test(val)) score++;
            if (/[0-9]/.test(val)) score++;
            if (/[^A-Za-z0-9]/.test(val)) score++;
            
            let width = '0%';
            let color = '#eee';
            let label = '';
            
            if (val.length > 0) {
                strengthContainer.style.display = 'block';
                if (score === 1) { width = '25%'; color = '#ff4d4d'; label = 'Weak'; }
                else if (score === 2) { width = '50%'; color = '#ff9933'; label = 'Medium'; }
                else if (score === 3) { width = '75%'; color = '#ffcc00'; label = 'Strong'; }
                else if (score >= 4) { width = '100%'; color = '#2ebd59'; label = 'Very Strong'; }
            } else {
                strengthContainer.style.display = 'none';
            }
            
            strengthFill.style.width = width;
            strengthFill.style.backgroundColor = color;
            if (strengthText) strengthText.innerText = 'Strength: ' + label;
        });
    }
});
