<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account - LMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body {
            background: linear-gradient(135deg, #F8FAFC 0%, #EFF6FF 50%, #F1F5F9 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem 1.5rem;
        }
        .signup-card {
            width: 100%;
            max-width: 500px;
            padding: 2.5rem;
        }
        .step-indicator {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 2rem;
            position: relative;
        }
        .step-item {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background: var(--border);
            color: var(--secondary);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 0.85rem;
            z-index: 2;
            transition: all 0.3s ease;
        }
        .step-item.active {
            background: var(--primary);
            color: #FFFFFF;
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);
        }
        .role-option {
            border: 2px solid var(--border);
            border-radius: var(--radius-card);
            padding: 1.25rem;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 1rem;
            transition: all 0.2s ease;
        }
        .role-option:hover, .role-option.selected {
            border-color: var(--primary);
            background: var(--primary-light);
        }
        .step-panel {
            display: none;
        }
        .step-panel.active {
            display: block;
        }
    </style>
</head>
<body>

    <div class="glass-card signup-card">
        <div style="text-align: center; margin-bottom: 1.5rem;">
            <a href="${pageContext.request.contextPath}/" class="sidebar-brand" style="justify-content: center; margin-bottom: 0.5rem;">
                <i class="bi bi-book-half"></i> LMS
            </a>
            <h2 style="font-size: 1.6rem; font-weight: 800;">Create Your Account</h2>
            <p style="color: var(--secondary); font-size: 0.85rem;" id="stepTitle">Step 1: Account Information</p>
        </div>

        <% if (request.getAttribute("errorMessage") != null) { %>
            <div style="background: #FEF2F2; border: 1px solid #FCA5A5; color: #991B1B; padding: 0.75rem 1rem; border-radius: 10px; font-size: 0.85rem; margin-bottom: 1.5rem;">
                <i class="bi bi-exclamation-circle-fill" style="margin-right: 0.35rem;"></i>
                <%= request.getAttribute("errorMessage") %>
            </div>
        <% } %>

        <div class="step-indicator">
            <div class="step-item active" id="stepBadge1">1</div>
            <div class="step-item" id="stepBadge2">2</div>
            <div class="step-item" id="stepBadge3">3</div>
        </div>

        <form action="${pageContext.request.contextPath}/auth" method="POST" id="signupForm">
            <input type="hidden" name="action" value="signup"/>

            <!-- STEP 1: Basic Info -->
            <div class="step-panel active" id="step1">
                <div style="margin-bottom: 1.25rem;">
                    <label style="display: block; font-size: 0.85rem; font-weight: 600; color: var(--secondary); margin-bottom: 0.4rem;">Full Name</label>
                    <input type="text" name="username" class="lms-input" placeholder="Kaushiki Rai" required>
                </div>

                <div style="margin-bottom: 1.25rem;">
                    <label style="display: block; font-size: 0.85rem; font-weight: 600; color: var(--secondary); margin-bottom: 0.4rem;">Email Address</label>
                    <input type="email" name="email" class="lms-input" placeholder="name@domain.com" required>
                </div>

                <div style="margin-bottom: 1.25rem;">
                    <label style="display: block; font-size: 0.85rem; font-weight: 600; color: var(--secondary); margin-bottom: 0.4rem;">Password</label>
                    <input type="password" name="password" id="pwd" class="lms-input" placeholder="At least 6 characters" required>
                </div>

                <button type="button" class="btn-lms btn-lms-primary" style="width: 100%; margin-top: 1rem;" onclick="goToStep(2)">
                    Continue <i class="bi bi-arrow-right"></i>
                </button>
            </div>

            <!-- STEP 2: Role & Specific Details -->
            <div class="step-panel" id="step2">
                <label style="display: block; font-size: 0.85rem; font-weight: 600; color: var(--secondary); margin-bottom: 0.75rem;">Choose Your Role</label>
                
                <div class="role-option selected" id="optStudent" onclick="selectRole('student')">
                    <input type="radio" name="role" value="student" id="roleStudent" checked style="accent-color: var(--primary);">
                    <div>
                        <strong style="display: block; font-size: 0.95rem;">Student</strong>
                        <span style="font-size: 0.8rem; color: var(--secondary);">Enroll in courses, submit assignments, and track grades</span>
                    </div>
                </div>

                <div class="role-option" id="optInstructor" onclick="selectRole('instructor')">
                    <input type="radio" name="role" value="instructor" id="roleInstructor" style="accent-color: var(--primary);">
                    <div>
                        <strong style="display: block; font-size: 0.95rem;">Instructor</strong>
                        <span style="font-size: 0.8rem; color: var(--secondary);">Create courses, grade assignments, and manage students</span>
                    </div>
                </div>

                <!-- Student Specific Fields -->
                <div id="studentFields">
                    <div style="margin-bottom: 1rem;">
                        <label style="display: block; font-size: 0.8rem; font-weight: 600; color: var(--secondary); margin-bottom: 0.3rem;">Student ID</label>
                        <input type="text" name="studentId" class="lms-input" placeholder="STU-2024-01">
                    </div>
                    <div style="display: flex; gap: 0.75rem; margin-bottom: 1rem;">
                        <div style="flex: 1;">
                            <label style="display: block; font-size: 0.8rem; font-weight: 600; color: var(--secondary); margin-bottom: 0.3rem;">Department</label>
                            <input type="text" name="department" class="lms-input" placeholder="Computer Science">
                        </div>
                        <div style="flex: 1;">
                            <label style="display: block; font-size: 0.8rem; font-weight: 600; color: var(--secondary); margin-bottom: 0.3rem;">Semester</label>
                            <input type="text" name="semester" class="lms-input" placeholder="4th Semester">
                        </div>
                    </div>
                </div>

                <!-- Instructor Specific Fields -->
                <div id="instructorFields" style="display: none;">
                    <div style="margin-bottom: 1rem;">
                        <label style="display: block; font-size: 0.8rem; font-weight: 600; color: var(--secondary); margin-bottom: 0.3rem;">Employee ID</label>
                        <input type="text" name="employeeId" class="lms-input" placeholder="EMP-109">
                    </div>
                    <div style="margin-bottom: 1rem;">
                        <label style="display: block; font-size: 0.8rem; font-weight: 600; color: var(--secondary); margin-bottom: 0.3rem;">Designation</label>
                        <input type="text" name="designation" class="lms-input" placeholder="Senior Professor">
                    </div>
                </div>

                <div style="display: flex; gap: 0.75rem; margin-top: 1rem;">
                    <button type="button" class="btn-lms btn-lms-outline" style="flex: 1;" onclick="goToStep(1)">Back</button>
                    <button type="button" class="btn-lms btn-lms-primary" style="flex: 2;" onclick="goToStep(3)">Continue</button>
                </div>
            </div>

            <!-- STEP 3: Finishing Step -->
            <div class="step-panel" id="step3">
                <div style="text-align: center; padding: 1rem 0;">
                    <i class="bi bi-shield-check" style="font-size: 3rem; color: var(--accent);"></i>
                    <h3 style="font-size: 1.25rem; font-weight: 700; margin-top: 0.5rem;">Almost Done!</h3>
                    <p style="color: var(--secondary); font-size: 0.85rem; margin-top: 0.25rem;">Click finish to complete your account setup and enter your dashboard.</p>
                </div>

                <div style="display: flex; gap: 0.75rem; margin-top: 1.5rem;">
                    <button type="button" class="btn-lms btn-lms-outline" style="flex: 1;" onclick="goToStep(2)">Back</button>
                    <button type="submit" class="btn-lms btn-lms-primary" style="flex: 2;">Finish & Register</button>
                </div>
            </div>
        </form>

        <p style="text-align: center; margin-top: 1.75rem; font-size: 0.9rem; color: var(--secondary);">
            Already have an account? <a href="${pageContext.request.contextPath}/login" style="color: var(--primary); font-weight: 600; text-decoration: none;">Login</a>
        </p>
    </div>

    <script>
        function selectRole(role) {
            document.getElementById('roleStudent').checked = (role === 'student');
            document.getElementById('roleInstructor').checked = (role === 'instructor');

            document.getElementById('optStudent').classList.toggle('selected', role === 'student');
            document.getElementById('optInstructor').classList.toggle('selected', role === 'instructor');

            document.getElementById('studentFields').style.display = (role === 'student') ? 'block' : 'none';
            document.getElementById('instructorFields').style.display = (role === 'instructor') ? 'block' : 'none';
        }

        function goToStep(step) {
            document.querySelectorAll('.step-panel').forEach(p => p.classList.remove('active'));
            document.querySelectorAll('.step-item').forEach(b => b.classList.remove('active'));

            document.getElementById('step' + step).classList.add('active');
            document.getElementById('stepBadge' + step).classList.add('active');

            const titles = { 1: "Step 1: Account Information", 2: "Step 2: Role Details", 3: "Step 3: Verification & Finish" };
            document.getElementById('stepTitle').innerText = titles[step];
        }

        // Auto pre-select role from URL parameter ?role=instructor
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get('role') === 'instructor') {
            selectRole('instructor');
        }
    </script>
</body>
</html>
