<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Learning Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f0f2f5;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .form-container {
            background: #ffffff;
            padding: 2rem;
            border-radius: 12px;
            box-shadow: 0 6px 8px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 400px;
            transition: all 0.3s ease-in-out;
        }
        .form-section {
            display: none;
        }
        .form-section.active {
            display: block;
        }
        .form-container h2 {
            color: #333;
        }
        .form-container .form-control {
            border-radius: 6px;
            border: 1px solid #ddd;
        }
        .form-container .form-control:focus {
            border-color: #007bff;
            box-shadow: 0 0 5px rgba(0, 123, 255, 0.5);
        }
        .form-container .form-check-input {
            margin-right: 0.5rem;
        }
        .btn {
            border-radius: 6px;
        }
        .btn-primary {
            background-color: #007bff;
            border-color: #007bff;
        }
        .btn-primary:hover {
            background-color: #0056b3;
            border-color: #004089;
        }
        .btn-success {
            background-color: #28a745;
            border-color: #28a745;
        }
        .btn-success:hover {
            background-color: #218838;
            border-color: #1e7e34;
        }
        .form-container img {
            max-width: 100%;
            border-radius: 12px;
            margin-bottom: 1rem;
        }
        .text-center a {
            color: #007bff;
            text-decoration: none;
        }
        .text-center a:hover {
            text-decoration: underline;
        }
        .password-strength {
            display: none;
            margin-top: 0.5rem;
        }
        .password-strength-bar {
            height: 6px;
            width: 0%;
            background: #f1f1f1;
            border-radius: 3px;
        }
        .password-strength-bar.weak {
            background: #ff6b6b;
        }
        .password-strength-bar.medium {
            background: #ffae3b;
        }
        .password-strength-bar.strong {
            background: #4caf50;
        }
        .invalid-feedback {
            display: none;
        }
        .was-validated .invalid-feedback {
            display: block;
        }
        .loading-spinner {
            display: none;
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
        }
    </style>
</head>
<body>
    <div class="form-container">
        <!-- Login Form -->
        <div id="login-section" class="form-section active">
            <form id="login-form" class="needs-validation" novalidate>
                <h2 class="text-center mb-4">Login</h2>
                <div class="mb-3">
                    <label for="email" class="form-label">Email</label>
                    <input type="email" class="form-control" id="email" required>
                    <div class="invalid-feedback">Please enter a valid email.</div>
                </div>
                <div class="mb-3">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" class="form-control" id="password" required>
                    <div class="invalid-feedback">Password is required.</div>
                    <div class="password-strength">
                        <div class="password-strength-bar" id="password-strength-bar"></div>
                    </div>
                </div>
                <div class="form-check mb-3">
                    <input type="checkbox" class="form-check-input" id="remember-me">
                    <label class="form-check-label" for="remember-me">Remember Me</label>
                </div>
                <button type="submit" class="btn btn-primary w-100">Login</button>
                <p class="text-center mt-3">
                    <a href="#" id="show-register">Create an account</a>
                </p>
                <p class="text-center">
                    <a href="#" id="forgot-password">Forgot Password?</a>
                </p>
            </form>
        </div>

        <!-- Registration Form -->
        <div id="register-section" class="form-section">
            <form id="register-form" class="needs-validation" novalidate>
                <h2 class="text-center mb-4">Register</h2>
                <div class="mb-3">
                    <label for="full-name" class="form-label">Full Name</label>
                    <input type="text" class="form-control" id="full-name" required>
                    <div class="invalid-feedback">Please enter your full name.</div>
                </div>
                <div class="mb-3">
                    <label for="register-email" class="form-label">Email</label>
                    <input type="email" class="form-control" id="register-email" required>
                    <div class="invalid-feedback">Please enter a valid email.</div>
                </div>
                <div class="mb-3">
                    <label for="register-password" class="form-label">Password</label>
                    <input type="password" class="form-control" id="register-password" required>
                    <div class="password-strength">
                        <div class="password-strength-bar" id="password-strength-bar"></div>
                    </div>
                    <div class="invalid-feedback">Password must be at least 8 characters long and include a mix of letters, numbers, and symbols.</div>
                </div>
                <div class="mb-3">
                    <label for="confirm-password" class="form-label">Confirm Password</label>
                    <input type="password" class="form-control" id="confirm-password" required>
                    <div class="invalid-feedback">Passwords must match.</div>
                </div>
                <button type="submit" class="btn btn-success w-100">Register</button>
                <p class="text-center mt-3">
                    <a href="#" id="show-login">Already have an account? Login</a>
                </p>
            </form>
        </div>

        <!-- Merge additional form code for LMS -->
        <form id="lms-login-form" class="needs-validation" novalidate>
            <h3 class="mb-4 text-center">Learning Management Platform - User Login</h3>
            <div class="mb-3">
                <label for="nameInput" class="form-label">Full Name</label>
                <input type="text" class="form-control" id="nameInput" placeholder="Enter your full name" required>
            </div>
            <div class="mb-3">
                <label for="dobInput" class="form-label">Date of Birth</label>
                <input type="date" class="form-control" id="dobInput" required>
            </div>
            <div class="mb-3">
                <label for="emailInput" class="form-label">Email Address</label>
                <input type="email" class="form-control" id="emailInput" placeholder="Enter your email" required>
            </div>
            <div class="mb-3">
                <label for="roleSelect" class="form-label">Role</label>
                <select class="form-select" id="roleSelect" required>
                    <option value="" disabled selected>Select your role</option>
                    <option value="student">Student</option>
                    <option value="teacher">Teacher</option>
                    <option value="admin">Admin</option>
                </select>
            </div>
            <div class="mb-3">
                <label for="courseInput" class="form-label">Course (Optional)</label>
                <input type="text" class="form-control" id="courseInput" placeholder="Enter your course name">
            </div>
            <div class="mb-3">
                <label for="passwordInput" class="form-label">Password</label>
                <input type="password" class="form-control" id="passwordInput" placeholder="Enter your password" required>
                <div class="password-strength">
                    <div class="password-strength-bar" id="password-strength-bar"></div>
                </div>
            </div>
            <div class="mb-3">
                <label for="profilePictureInput" class="form-label">Profile Picture</label>
                <input type="file" class="form-control" id="profilePictureInput" accept="image/*">
            </div>
            <div class="mb-3 form-check">
                <input type="checkbox" class="form-check-input" id="termsCheck" required>
                <label class="form-check-label" for="termsCheck">
                    I agree to the <a href="#" target="_blank">Terms and Conditions</a>.
                </label>
            </div>
            <button type="submit" class="btn btn-primary w-100">Login</button>
        </form>
    </div>

    <script>
        document.getElementById('show-register').addEventListener('click', function(e) {
            e.preventDefault();
            document.getElementById('login-section').classList.remove('active');
            document.getElementById('register-section').classList.add('active');
        });

        document.getElementById('show-login').addEventListener('click', function(e) {
            e.preventDefault();
            document.getElementById('register-section').classList.remove('active');
            document.getElementById('login-section').classList.add('active');
        });

        document.getElementById('forgot-password').addEventListener('click', function(e) {
            e.preventDefault();
            alert('Password reset link sent to your email.');
        });

        // Password strength indicator
        const passwordInput = document.getElementById('register-password');
        const passwordStrengthBar = document.getElementById('password-strength-bar');
        passwordInput.addEventListener('input', function() {
            const password = passwordInput.value;
            let strength = 0;

            if (password.length >= 8) strength += 1;
            if (/[A-Z]/.test(password)) strength += 1;
            if (/[0-9]/.test(password)) strength += 1;
            if (/[^A-Za-z0-9]/.test(password)) strength += 1;

            passwordStrengthBar.style.width = (strength * 25) + '%';

            passwordStrengthBar.className = 'password-strength-bar';
            if (strength < 2) {
                passwordStrengthBar.classList.add('weak');
            } else if (strength < 3) {
                passwordStrengthBar.classList.add('medium');
            } else {
                passwordStrengthBar.classList.add('strong');
            }
        });

        // Form validation
        document.querySelectorAll('form').forEach(form => {
            form.addEventListener('submit', event => {
                if (!form.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                }
                form.classList.add('was-validated');
            });
        });
    </script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>