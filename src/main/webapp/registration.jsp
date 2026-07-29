<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Learning Management System - Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background-color: #f4f6f9;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
        }
        .auth-card {
            background: #ffffff;
            border-radius: 16px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.08);
            width: 100%;
            max-width: 440px;
            padding: 2.5rem;
            transition: all 0.3s ease;
        }
        .brand-header {
            text-align: center;
            margin-bottom: 2rem;
        }
        .brand-icon {
            font-size: 2.5rem;
            color: #0d6efd;
        }
        .nav-pills .nav-link {
            color: #6c757d;
            font-weight: 500;
            border-radius: 8px;
        }
        .nav-pills .nav-link.active {
            background-color: #0d6efd;
            color: #fff;
        }
        .form-control, .form-select {
            border-radius: 8px;
            padding: 0.65rem 0.9rem;
            border: 1px solid #ced4da;
        }
        .form-control:focus, .form-select:focus {
            border-color: #0d6efd;
            box-shadow: 0 0 0 0.2rem rgba(13, 110, 253, 0.15);
        }
        .btn-primary {
            border-radius: 8px;
            padding: 0.65rem;
            font-weight: 600;
        }
        .password-strength-bar {
            height: 4px;
            width: 0%;
            border-radius: 2px;
            transition: width 0.3s ease;
            margin-top: 6px;
        }
        .weak { background-color: #dc3545; }
        .medium { background-color: #ffc107; }
        .strong { background-color: #198754; }
    </style>
</head>
<body>

    <div class="auth-card">
        <div class="brand-header">
            <i class="bi bi-journal-bookmark-fill brand-icon"></i>
            <h3 class="mt-2 mb-1 text-dark fw-bold">LMS Portal</h3>
            <p class="text-muted small">Access your learning management system</p>
        </div>

        <%-- Alerts --%>
        <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                <%= request.getAttribute("errorMessage") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <% if (request.getAttribute("successMessage") != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>
                <%= request.getAttribute("successMessage") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <%-- Navigation Tabs --%>
        <ul class="nav nav-pills nav-fill mb-4" id="authTab" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active" id="login-tab" data-bs-toggle="pill" data-bs-target="#login-pane" type="button">Login</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="register-tab" data-bs-toggle="pill" data-bs-target="#register-pane" type="button">Register</button>
            </li>
        </ul>

        <div class="tab-content" id="authTabContent">
            <%-- Login Form --%>
            <div class="tab-pane fade show active" id="login-pane" role="tabpanel">
                <form action="${pageContext.request.contextPath}/auth" method="POST">
                    <input type="hidden" name="action" value="login"/>
                    
                    <div class="mb-3">
                        <label for="loginEmail" class="form-label text-secondary small fw-bold">Email Address</label>
                        <input type="email" class="form-control" id="loginEmail" name="email" 
                               value="<%= request.getAttribute("prevEmail") != null ? request.getAttribute("prevEmail") : "" %>"
                               placeholder="user@domain.com" required>
                    </div>

                    <div class="mb-3">
                        <label for="loginPassword" class="form-label text-secondary small fw-bold">Password</label>
                        <input type="password" class="form-control" id="loginPassword" name="password" 
                               placeholder="Enter your password" required>
                    </div>

                    <button type="submit" class="btn btn-primary w-100 mt-2">
                        Sign In <i class="bi bi-arrow-right-short"></i>
                    </button>
                </form>
            </div>

            <%-- Register Form --%>
            <div class="tab-pane fade" id="register-pane" role="tabpanel">
                <form action="${pageContext.request.contextPath}/auth" method="POST" id="registerForm">
                    <input type="hidden" name="action" value="register"/>

                    <div class="mb-3">
                        <label for="regUsername" class="form-label text-secondary small fw-bold">Full Name</label>
                        <input type="text" class="form-control" id="regUsername" name="username" 
                               value="<%= request.getAttribute("prevUsername") != null ? request.getAttribute("prevUsername") : "" %>"
                               placeholder="John Doe" required>
                    </div>

                    <div class="mb-3">
                        <label for="regEmail" class="form-label text-secondary small fw-bold">Email Address</label>
                        <input type="email" class="form-control" id="regEmail" name="email" 
                               value="<%= request.getAttribute("prevEmail") != null ? request.getAttribute("prevEmail") : "" %>"
                               placeholder="user@domain.com" required>
                    </div>

                    <div class="mb-3">
                        <label for="regRole" class="form-label text-secondary small fw-bold">Select Role</label>
                        <select class="form-select" id="regRole" name="role" required>
                            <option value="student" selected>Student</option>
                            <option value="instructor">Instructor / Teacher</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label for="regPassword" class="form-label text-secondary small fw-bold">Password</label>
                        <input type="password" class="form-control" id="regPassword" name="password" 
                               placeholder="At least 6 characters" required>
                        <div class="password-strength-bar" id="passwordStrengthBar"></div>
                    </div>

                    <button type="submit" class="btn btn-primary w-100 mt-2">
                        Create Account <i class="bi bi-person-plus-fill ms-1"></i>
                    </button>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const passwordInput = document.getElementById('regPassword');
        const strengthBar = document.getElementById('passwordStrengthBar');

        if (passwordInput) {
            passwordInput.addEventListener('input', function() {
                const val = passwordInput.value;
                let score = 0;
                if (val.length >= 6) score++;
                if (/[A-Z]/.test(val)) score++;
                if (/[0-9]/.test(val)) score++;
                if (/[^A-Za-z0-9]/.test(val)) score++;

                strengthBar.className = 'password-strength-bar';
                if (score === 0) {
                    strengthBar.style.width = '0%';
                } else if (score <= 2) {
                    strengthBar.style.width = '33%';
                    strengthBar.classList.add('weak');
                } else if (score === 3) {
                    strengthBar.style.width = '66%';
                    strengthBar.classList.add('medium');
                } else {
                    strengthBar.style.width = '100%';
                    strengthBar.classList.add('strong');
                }
            });
        }
    </script>
</body>
</html>
