function validateLMSForm() {
     const name = document.getElementById('nameInput').value.trim();
     const dob = document.getElementById('dobInput').value.trim();
     const email = document.getElementById('emailInput').value.trim();
     const role = document.getElementById('roleSelect').value.trim();
     const password = document.getElementById('passwordInput').value.trim();
     const confirmPassword = document.getElementById('confirm-password').value.trim();
     const termsCheck = document.getElementById('termsCheck').checked;

     if (!name || !dob || !email || !role || !password) {
         alert('All fields are required!');
         return false;
     }

     const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
     if (!emailRegex.test(email)) {
         alert('Invalid email format!');
         return false;
     }

     if (password.length < 8) {
         alert('Password must be at least 8 characters long!');
         return false;
     }

     if (password !== confirmPassword) {
         alert('Passwords must match!');
         return false;
     }

     if (!termsCheck) {
         alert('You must agree to the terms and conditions!');
         return false;
     }

     return true;
 }

 const passwordInput = document.getElementById('passwordInput');
 const passwordStrengthBar = document.getElementById('password-strength-bar');
 passwordInput.addEventListener('input', function () {
     const password = passwordInput.value;
     let strength = 0;

     if (password.length >= 8) strength++;
     if (/[A-Z]/.test(password)) strength++;
     if (/[0-9]/.test(password)) strength++;
     if (/[^A-Za-z0-9]/.test(password)) strength++;

     passwordStrengthBar.style.width = (strength * 25) + '%';
     passwordStrengthBar.className = 'password-strength-bar';

     if (strength < 2) passwordStrengthBar.classList.add('weak');
     else if (strength < 3) passwordStrengthBar.classList.add('medium');
     else passwordStrengthBar.classList.add('strong');
 });