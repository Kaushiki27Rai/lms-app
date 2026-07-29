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
    <title>Student Dashboard - LMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .grid-2 { display: grid; grid-template-columns: 2fr 1fr; gap: 1.5rem; }
        .grid-3 { display: grid; grid-template-columns: repeat(4, 1fr); gap: 1.25rem; }
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
                <li><a href="${pageContext.request.contextPath}/dashboard" class="sidebar-link active"><i class="bi bi-grid-1x2-fill"></i> Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/courses?action=my-courses" class="sidebar-link"><i class="bi bi-journal-bookmark-fill"></i> My Courses</a></li>
                <li><a href="${pageContext.request.contextPath}/courses" class="sidebar-link"><i class="bi bi-compass"></i> Explore Courses</a></li>
                <li><a href="#" class="sidebar-link"><i class="bi bi-file-earmark-text"></i> Assignments</a></li>
                <li><a href="#" class="sidebar-link"><i class="bi bi-calendar3"></i> Calendar</a></li>
                <li><a href="#" class="sidebar-link"><i class="bi bi-chat-left-dots"></i> Discussions</a></li>
                <li><a href="#" class="sidebar-link"><i class="bi bi-graph-up-arrow"></i> Progress</a></li>
                <li><a href="#" class="sidebar-link"><i class="bi bi-gear"></i> Settings</a></li>
            </ul>
        </aside>

        <!-- Main Workspace -->
        <main class="main-content">
            <!-- Topbar -->
            <header class="topbar">
                <div class="search-box">
                    <i class="bi bi-search"></i>
                    <input type="text" class="lms-input" placeholder="Search courses, lessons, topics...">
                </div>

                <div style="display: flex; align-items: center; gap: 1.25rem;">
                    <div style="position: relative; cursor: pointer;">
                        <i class="bi bi-bell" style="font-size: 1.25rem; color: var(--secondary);"></i>
                        <span style="position: absolute; top: -2px; right: -2px; width: 8px; height: 8px; background: var(--error); border-radius: 50%;"></span>
                    </div>

                    <div style="display: flex; align-items: center; gap: 0.75rem;">
                        <img src="<%= currentUser.getProfilePic() %>" style="width: 40px; height: 40px; border-radius: 50%; object-fit: cover;">
                        <div>
                            <strong style="display: block; font-size: 0.9rem; line-height: 1.2;"><%= currentUser.getUsername() %></strong>
                            <span class="badge-lms badge-student"><%= currentUser.getRole() %></span>
                        </div>
                    </div>

                    <a href="${pageContext.request.contextPath}/auth?action=logout" class="btn-lms btn-lms-outline" style="padding: 0.5rem 0.9rem; font-size: 0.85rem;">
                        <i class="bi bi-box-arrow-right"></i> Logout
                    </a>
                </div>
            </header>

            <!-- Welcome Header -->
            <div style="margin-bottom: 2rem;">
                <h1 style="font-size: 1.8rem; font-weight: 800; color: var(--text);">Hello <%= currentUser.getUsername() %> 👋</h1>
                <p style="color: var(--secondary); font-size: 0.95rem;">What would you like to learn today?</p>
            </div>

            <!-- Learning Analytics Summary Cards -->
            <div class="grid-3" style="margin-bottom: 2rem;">
                <div class="lms-card" style="padding: 1.25rem;">
                    <span style="color: var(--secondary); font-size: 0.8rem; font-weight: 600;">Weekly Learning</span>
                    <h3 style="font-size: 1.5rem; font-weight: 800; margin-top: 0.25rem; color: var(--primary);">14.2 Hours</h3>
                </div>
                <div class="lms-card" style="padding: 1.25rem;">
                    <span style="color: var(--secondary); font-size: 0.8rem; font-weight: 600;">Attendance</span>
                    <h3 style="font-size: 1.5rem; font-weight: 800; margin-top: 0.25rem; color: var(--accent);">96.5%</h3>
                </div>
                <div class="lms-card" style="padding: 1.25rem;">
                    <span style="color: var(--secondary); font-size: 0.8rem; font-weight: 600;">Average Score</span>
                    <h3 style="font-size: 1.5rem; font-weight: 800; margin-top: 0.25rem; color: var(--warning);">88.5%</h3>
                </div>
                <div class="lms-card" style="padding: 1.25rem;">
                    <span style="color: var(--secondary); font-size: 0.8rem; font-weight: 600;">Course Completion</span>
                    <h3 style="font-size: 1.5rem; font-weight: 800; margin-top: 0.25rem; color: var(--text);">76% Overall</h3>
                </div>
            </div>

            <div class="grid-2">
                <!-- Left Column -->
                <div>
                    <!-- Continue Learning Card -->
                    <div class="lms-card" style="padding: 1.75rem; margin-bottom: 2rem; background: linear-gradient(135deg, #1E3A8A, #2563EB); color: #FFFFFF;">
                        <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 1rem;">
                            <div>
                                <span style="background: rgba(255,255,255,0.2); padding: 0.3rem 0.75rem; border-radius: 20px; font-size: 0.75rem; font-weight: 600;">Continue Learning</span>
                                <h2 style="font-size: 1.4rem; font-weight: 800; margin-top: 0.5rem; color: #FFFFFF;">Data Structures & Algorithms</h2>
                                <p style="color: rgba(255,255,255,0.8); font-size: 0.85rem; margin-top: 0.2rem;">Module 3: Binary Search Trees & Traversal</p>
                            </div>
                            <a href="${pageContext.request.contextPath}/courses?action=view&id=1" class="btn-lms" style="background: #FFFFFF; color: var(--primary); font-weight: 700;">
                                Resume <i class="bi bi-play-fill"></i>
                            </a>
                        </div>

                        <div style="margin-top: 1.5rem;">
                            <div style="display: flex; justify-content: space-between; font-size: 0.8rem; font-weight: 600; margin-bottom: 0.4rem; color: rgba(255,255,255,0.9);">
                                <span>Course Progress</span>
                                <span>76%</span>
                            </div>
                            <div class="progress-bar-container" style="background: rgba(255,255,255,0.2);">
                                <div class="progress-bar-fill" style="width: 76%; background: #10B981;"></div>
                            </div>
                        </div>
                    </div>

                    <!-- Recent Announcements -->
                    <div class="lms-card" style="padding: 1.5rem;">
                        <h3 style="font-size: 1.1rem; font-weight: 700; margin-bottom: 1rem;"><i class="bi bi-megaphone" style="color: var(--primary); margin-right: 0.5rem;"></i> Recent Announcements</h3>
                        
                        <div style="display: flex; flex-direction: column; gap: 1rem;">
                            <div style="padding-bottom: 1rem; border-bottom: 1px solid var(--border);">
                                <strong style="font-size: 0.95rem; display: block;">New Lecture Notes Uploaded</strong>
                                <span style="font-size: 0.8rem; color: var(--secondary);">Data Structures & Algorithms • Posted 2 hours ago</span>
                            </div>
                            <div style="padding-bottom: 1rem; border-bottom: 1px solid var(--border);">
                                <strong style="font-size: 0.95rem; display: block;">SQL Assessment Quiz Scheduled</strong>
                                <span style="font-size: 0.8rem; color: var(--secondary);">Database Management • Scheduled for Friday at 2:00 PM</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right Column: Upcoming Timeline & Calendar -->
                <div>
                    <div class="lms-card" style="padding: 1.5rem; margin-bottom: 1.5rem;">
                        <h3 style="font-size: 1.1rem; font-weight: 700; margin-bottom: 1rem;"><i class="bi bi-clock-history" style="color: var(--warning); margin-right: 0.5rem;"></i> Upcoming Assignments</h3>

                        <div style="display: flex; flex-direction: column; gap: 1rem;">
                            <div style="display: flex; align-items: center; justify-content: space-between; padding: 0.75rem; background: var(--bg); border-radius: 10px;">
                                <div>
                                    <strong style="font-size: 0.9rem; display: block;">BST Implementation</strong>
                                    <span style="font-size: 0.75rem; color: var(--secondary);">Data Structures</span>
                                </div>
                                <span style="font-size: 0.8rem; font-weight: 700; color: var(--error);">Tomorrow</span>
                            </div>

                            <div style="display: flex; align-items: center; justify-content: space-between; padding: 0.75rem; background: var(--bg); border-radius: 10px;">
                                <div>
                                    <strong style="font-size: 0.9rem; display: block;">SQL Normalization</strong>
                                    <span style="font-size: 0.75rem; color: var(--secondary);">Database Systems</span>
                                </div>
                                <span style="font-size: 0.8rem; font-weight: 700; color: var(--warning);">Friday</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <!-- AI Study Assistant FAB -->
    <button class="ai-fab" onclick="alert('🤖 AI Assistant: Summarising lecture notes and predicting topics for tomorrow\'s quiz!')">
        <i class="bi bi-robot" style="font-size: 1.5rem;"></i>
    </button>

</body>
</html>
