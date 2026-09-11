<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - LMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body {
            background: linear-gradient(135deg, #F8FAFC 0%, #EFF6FF 50%, #F1F5F9 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 1.5rem;
        }
        .login-card {
            width: 100%;
            max-width: 420px;
            padding: 2.5rem;
        }
        .social-btn {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.75rem;
            width: 100%;
            padding: 0.75rem;
            border-radius: var(--radius-btn);
            border: 1px solid var(--border);
            background: #FFFFFF;
            font-weight: 500;
            color: var(--text);
            cursor: pointer;
            transition: all 0.2s ease;
            text-decoration: none;
            margin-bottom: 0.75rem;
            font-size: 0.95rem;
        }
        .social-btn:hover {
            background: var(--bg);
            border-color: var(--secondary);
        }
        .divider {
            display: flex;
            align-items: center;
            text-align: center;
            margin: 1.5rem 0;
            color: var(--secondary);
            font-size: 0.85rem;
        }
        .divider::before, .divider::after {
            content: '';
            flex: 1;
            border-bottom: 1px solid var(--border);
        }
        .divider::before { margin-right: 0.75rem; }
        .divider::after { margin-left: 0.75rem; }
    </style>
</head>
<body>

    <div class="glass-card login-card">
        <div style="text-align: center; margin-bottom: 2rem;">
            <a href="${pageContext.request.contextPath}/" class="sidebar-brand" style="justify-content: center; margin-bottom: 0.5rem;">
                <i class="bi bi-book-half"></i> LMS
            </a>
            <h2 style="font-size: 1.75rem; font-weight: 800; color: var(--text);">Welcome Back</h2>
            <p style="color: var(--secondary); font-size: 0.9rem; margin-top: 0.25rem;">Enter your credentials to access your portal</p>
        </div>

        <% if (request.getAttribute("errorMessage") != null) { %>
            <div style="background: #FEF2F2; border: 1px solid #FCA5A5; color: #991B1B; padding: 0.75rem 1rem; border-radius: 10px; font-size: 0.9rem; margin-bottom: 1.5rem;">
                <i class="bi bi-exclamation-circle-fill" style="margin-right: 0.35rem;"></i>
                <%= request.getAttribute("errorMessage") %>
            </div>
        <% } %>

        <% if (request.getAttribute("successMessage") != null) { %>
            <div style="background: #ECFDF5; border: 1px solid #6EE7B7; color: #065F46; padding: 0.75rem 1rem; border-radius: 10px; font-size: 0.9rem; margin-bottom: 1.5rem;">
                <i class="bi bi-check-circle-fill" style="margin-right: 0.35rem;"></i>
                <%= request.getAttribute("successMessage") %>
            </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/auth" method="POST">
            <input type="hidden" name="action" value="login"/>

            <div style="margin-bottom: 1.25rem;">
                <label style="display: block; font-size: 0.85rem; font-weight: 600; color: var(--secondary); margin-bottom: 0.4rem;">Email</label>
                <input type="email" name="email" class="lms-input" placeholder="name@domain.com" 
                       value="<%= request.getAttribute("prevEmail") != null ? request.getAttribute("prevEmail") : "" %>" required>
            </div>

            <div style="margin-bottom: 1.5rem;">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.4rem;">
                    <label style="font-size: 0.85rem; font-weight: 600; color: var(--secondary);">Password</label>
                    <a href="#" style="font-size: 0.85rem; color: var(--primary); text-decoration: none; font-weight: 500;">Forgot Password?</a>
                </div>
                <input type="password" name="password" class="lms-input" placeholder="••••••••" required>
            </div>

            <button type="submit" class="btn-lms btn-lms-primary" style="width: 100%; margin-bottom: 1rem;">
                Login <i class="bi bi-arrow-right"></i>
            </button>
        </form>

        <div class="divider">or continue with</div>

        <a href="#" class="social-btn">
            <i class="bi bi-google" style="color: #EA4335;"></i> Continue with Google
        </a>
        <a href="#" class="social-btn">
            <i class="bi bi-microsoft" style="color: #00A4EF;"></i> Continue with Microsoft
        </a>

        <p style="text-align: center; margin-top: 1.75rem; font-size: 0.9rem; color: var(--secondary);">
            Don't have an account? <a href="${pageContext.request.contextPath}/signup" style="color: var(--primary); font-weight: 600; text-decoration: none;">Create Account</a>
        </p>
    </div>

</body>
</html>
