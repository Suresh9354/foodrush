function togglePassword(inputId, iconEl) {
    const input = document.getElementById(inputId);
    if (input) {
        if (input.type === 'password') {
            input.type = 'text';
            iconEl.classList.remove('bi-eye-slash');
            iconEl.classList.add('bi-eye');
        } else {
            input.type = 'password';
            iconEl.classList.remove('bi-eye');
            iconEl.classList.add('bi-eye-slash');
        }
    }
}
