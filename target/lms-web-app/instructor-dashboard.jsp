<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.lms.model.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/auth");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Instructor Portal - LMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .grid-2 { display: grid; grid-template-columns: 2fr 1fr; gap: 1.5rem; }
        .grid-4 { display: grid; grid-template-columns: repeat(4, 1fr); gap: 1.25rem; }
        .quick-action-btn {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 1rem;
            background: #FFFFFF;
            border: 1px solid var(--border);
            border-radius: var(--radius-btn);
            color: var(--text);
            text-decoration: none;
            font-weight: 600;
            font-size: 0.9rem;
            transition: all 0.2s ease;
        }
        .quick-action-btn:hover {
            border-color: var(--primary);
            background: var(--primary-light);
            color: var(--primary);
        }
    </style>
</head>
<body>

    <div class="app-layout">
        <!-- Sidebar Navigation -->
        <aside class="sidebar">
            <a href="${pageContext.request.contextPath}/dashboard" class="sidebar-brand">
                <i class="bi bi-book-half"></i> LMS
            </a>
            <ul class="sidebar-nav">
                <li><a href="${pageContext.request.contextPath}/dashboard" class="sidebar-link active"><i class="bi bi-speedometer2"></i> Management Hub</a></li>
                <li><a href="${pageContext.request.contextPath}/courses" class="sidebar-link"><i class="bi bi-journal-bookmark-fill"></i> Courses</a></li>
                <li><a href="#" class="sidebar-link"><i class="bi bi-people-fill"></i> Students</a></li>
                <li><a href="#" class="sidebar-link"><i class="bi bi-file-earmark-text"></i> Assignments</a></li>
                <li><a href="#" class="sidebar-link"><i class="bi bi-calendar2-check"></i> Attendance</a></li>
                <li><a href="#" class="sidebar-link"><i class="bi bi-award"></i> Grades</a></li>
                <li><a href="#" class="sidebar-link"><i class="bi bi-bar-chart-line"></i> Analytics</a></li>
                <li><a href="#" class="sidebar-link"><i class="bi bi-gear"></i> Settings</a></li>
            </ul>
        </aside>

        <!-- Main Workspace -->
        <main class="main-content">
            <!-- Topbar -->
            <header class="topbar">
                <div>
                    <h1 style="font-size: 1.6rem; font-weight: 800; color: var(--text);">Instructor Dashboard</h1>
                    <span style="font-size: 0.85rem; color: var(--secondary);"><%= currentUser.getDepartment() != null ? currentUser.getDepartment() : "Faculty of Computer Science" %></span>
                </div>

                <div style="display: flex; align-items: center; gap: 1.25rem;">
                    <div style="display: flex; align-items: center; gap: 0.75rem;">
                        <img src="<%= currentUser.getProfilePic() %>" style="width: 40px; height: 40px; border-radius: 50%; object-fit: cover;">
                        <div>
                            <strong style="display: block; font-size: 0.9rem; line-height: 1.2;"><%= currentUser.getUsername() %></strong>
                            <span class="badge-lms badge-instructor"><%= currentUser.getDesignation() != null ? currentUser.getDesignation() : "Instructor" %></span>
                        </div>
                    </div>

                    <a href="${pageContext.request.contextPath}/auth?action=logout" class="btn-lms btn-lms-outline" style="padding: 0.5rem 0.9rem; font-size: 0.85rem;">
                        <i class="bi bi-box-arrow-right"></i> Logout
                    </a>
                </div>
            </header>

            <!-- Management Stats Cards -->
            <div class="grid-4" style="margin-bottom: 2rem;">
                <div class="lms-card" style="padding: 1.25rem;">
                    <span style="color: var(--secondary); font-size: 0.8rem; font-weight: 600;">Total Students</span>
                    <h3 style="font-size: 1.5rem; font-weight: 800; margin-top: 0.25rem; color: var(--primary);">128 Active</h3>
                </div>
                <div class="lms-card" style="padding: 1.25rem;">
                    <span style="color: var(--secondary); font-size: 0.8rem; font-weight: 600;">Managed Courses</span>
                    <h3 style="font-size: 1.5rem; font-weight: 800; margin-top: 0.25rem; color: var(--accent);">4 Courses</h3>
                </div>
                <div class="lms-card" style="padding: 1.25rem;">
                    <span style="color: var(--secondary); font-size: 0.8rem; font-weight: 600;">Avg Attendance</span>
                    <h3 style="font-size: 1.5rem; font-weight: 800; margin-top: 0.25rem; color: var(--text);">94.2%</h3>
                </div>
                <div class="lms-card" style="padding: 1.25rem;">
                    <span style="color: var(--secondary); font-size: 0.8rem; font-weight: 600;">Pending Grading</span>
                    <h3 style="font-size: 1.5rem; font-weight: 800; margin-top: 0.25rem; color: var(--warning);">12 Submissions</h3>
                </div>
            </div>

            <!-- Quick Management Actions -->
            <div style="margin-bottom: 2rem;">
                <h3 style="font-size: 1.1rem; font-weight: 700; margin-bottom: 1rem;">Quick Actions</h3>
                <div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 1rem;">
                    <a href="${pageContext.request.contextPath}/courses?action=create" class="quick-action-btn">
                        <i class="bi bi-plus-circle-fill" style="color: var(--primary); font-size: 1.2rem;"></i> Create Course
                    </a>
                    <a href="#" class="quick-action-btn">
                        <i class="bi bi-cloud-upload-fill" style="color: var(--accent); font-size: 1.2rem;"></i> Upload Material
                    </a>
                    <a href="#" class="quick-action-btn">
                        <i class="bi bi-pencil-square" style="color: var(--warning); font-size: 1.2rem;"></i> Create Quiz
                    </a>
                    <a href="#" class="quick-action-btn">
                        <i class="bi bi-file-earmark-plus-fill" style="color: #9333EA; font-size: 1.2rem;"></i> Create Assignment
                    </a>
                </div>
            </div>

            <div class="grid-2">
                <!-- Today's Classes & Pending Submissions -->
                <div>
                    <div class="lms-card" style="padding: 1.5rem; margin-bottom: 1.5rem;">
                        <h3 style="font-size: 1.1rem; font-weight: 700; margin-bottom: 1rem;"><i class="bi bi-calendar-event" style="color: var(--primary); margin-right: 0.5rem;"></i> Today's Schedule</h3>
                        <div style="display: flex; flex-direction: column; gap: 1rem;">
                            <div style="display: flex; align-items: center; justify-content: space-between; padding: 1rem; background: var(--bg); border-radius: 12px;">
                                <div>
                                    <strong style="display: block; font-size: 0.95rem;">Data Structures & Algorithms</strong>
                                    <span style="font-size: 0.8rem; color: var(--secondary);">Lecture Hall 3 • 10:00 AM - 11:30 AM</span>
                                </div>
                                <span class="badge-lms badge-instructor">Live Soon</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- At-Risk Students & Activity Feed -->
                <div>
                    <div class="lms-card" style="padding: 1.5rem;">
                        <h3 style="font-size: 1.1rem; font-weight: 700; margin-bottom: 1rem;"><i class="bi bi-exclamation-triangle" style="color: var(--warning); margin-right: 0.5rem;"></i> Student Risk Alerts</h3>
                        <div style="font-size: 0.85rem; color: var(--secondary);">
                            <p><strong>1 Student At Risk:</strong> Low attendance (62%) in DBMS course. AI recommendation sent to student.</p>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

</body>
</html>
