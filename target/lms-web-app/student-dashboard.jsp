<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.lms.model.User" %>
<%@ page import="com.lms.model.Course" %>
<%@ page import="com.lms.model.Assignment" %>
<%@ page import="com.lms.model.Announcement" %>
<%@ page import="com.lms.model.Notification" %>
<%@ page import="java.util.List" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/auth");
        return;
    }
    List<Course> enrolledCourses = (List<Course>) request.getAttribute("enrolledCourses");
    List<Assignment> upcomingAssignments = (List<Assignment>) request.getAttribute("upcomingAssignments");
    List<Announcement> announcements = (List<Announcement>) request.getAttribute("announcements");
    List<Notification> notifications = (List<Notification>) request.getAttribute("notifications");
    Course continueCourse = (Course) request.getAttribute("continueCourse");
    
    Long unreadCount = (Long) request.getAttribute("unreadCount");
    Double avgScore = (Double) request.getAttribute("avgScore");
    Double overallCompletion = (Double) request.getAttribute("overallCompletion");
    String weeklyHours = (String) request.getAttribute("weeklyHours");
    String attendancePercent = (String) request.getAttribute("attendancePercent");
    if (unreadCount == null) unreadCount = 0L;
    if (avgScore == null) avgScore = 0.0;
    if (overallCompletion == null) overallCompletion = 0.0;
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
        .notification-dropdown {
            position: absolute;
            top: 40px; right: 0;
            width: 320px;
            background: #FFFFFF;
            border-radius: var(--radius-card);
            border: 1px solid var(--border);
            box-shadow: var(--shadow-hover);
            display: none;
            z-index: 200;
            padding: 1rem;
        }
        .notification-dropdown.active { display: block; }
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
                <li><a href="#" class="sidebar-link" onclick="alert('Feature: Live Calendar Integration')"><i class="bi bi-calendar3"></i> Calendar</a></li>
                <li><a href="#" class="sidebar-link" onclick="alert('Feature: Settings & Profile Management')"><i class="bi bi-gear"></i> Settings</a></li>
            </ul>
        </aside>

        <!-- Main Workspace -->
        <main class="main-content">
            <!-- Topbar -->
            <header class="topbar">
                <div class="search-box">
                    <i class="bi bi-search"></i>
                    <input type="text" class="lms-input" id="searchBox" placeholder="Search courses, lessons, topics..." onkeyup="filterContent()">
                </div>

                <div style="display: flex; align-items: center; gap: 1.25rem;">
                    <!-- Notification Bell & Dropdown -->
                    <div style="position: relative; cursor: pointer;" onclick="toggleNotifications()">
                        <i class="bi bi-bell" style="font-size: 1.25rem; color: var(--secondary);"></i>
                        <% if (unreadCount > 0) { %>
                            <span style="position: absolute; top: -4px; right: -4px; background: var(--error); color: #FFFFFF; font-size: 0.65rem; font-weight: 700; padding: 2px 5px; border-radius: 50%;"><%= unreadCount %></span>
                        <% } %>

                        <div class="notification-dropdown" id="notifDropdown" onclick="event.stopPropagation()">
                            <h4 style="font-size: 0.95rem; font-weight: 700; margin-bottom: 0.75rem;">Notifications</h4>
                            <% if (notifications != null && !notifications.isEmpty()) {
                                for (Notification n : notifications) { %>
                                    <div style="padding: 0.5rem 0; border-bottom: 1px solid var(--border); font-size: 0.8rem;">
                                        <strong style="display: block; color: var(--text);"><%= n.getTitle() %></strong>
                                        <span style="color: var(--secondary);"><%= n.getMessage() %></span>
                                    </div>
                            <%  } 
                               } else { %>
                                <p style="font-size: 0.8rem; color: var(--secondary);">No notifications available.</p>
                            <% } %>
                        </div>
                    </div>

                    <!-- User Profile Badge -->
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

            <!-- Dynamic Welcome Header -->
            <div style="margin-bottom: 2rem;">
                <h1 style="font-size: 1.8rem; font-weight: 800; color: var(--text);">Hello <%= currentUser.getUsername() %> 👋</h1>
                <p style="color: var(--secondary); font-size: 0.95rem;">
                    <%= currentUser.getDepartment() != null ? currentUser.getDepartment() + " • " + currentUser.getSemester() : "Welcome to your active workspace." %>
                </p>
            </div>

            <!-- Learning Analytics Summary Cards (Fully Dynamic) -->
            <div class="grid-3" style="margin-bottom: 2rem;">
                <div class="lms-card" style="padding: 1.25rem;">
                    <span style="color: var(--secondary); font-size: 0.8rem; font-weight: 600;">Weekly Learning</span>
                    <h3 style="font-size: 1.5rem; font-weight: 800; margin-top: 0.25rem; color: var(--primary);"><%= weeklyHours %> Hours</h3>
                </div>
                <div class="lms-card" style="padding: 1.25rem;">
                    <span style="color: var(--secondary); font-size: 0.8rem; font-weight: 600;">Attendance</span>
                    <h3 style="font-size: 1.5rem; font-weight: 800; margin-top: 0.25rem; color: var(--accent);"><%= attendancePercent %></h3>
                </div>
                <div class="lms-card" style="padding: 1.25rem;">
                    <span style="color: var(--secondary); font-size: 0.8rem; font-weight: 600;">Average Score</span>
                    <h3 style="font-size: 1.5rem; font-weight: 800; margin-top: 0.25rem; color: var(--warning);"><%= avgScore %>%</h3>
                </div>
                <div class="lms-card" style="padding: 1.25rem;">
                    <span style="color: var(--secondary); font-size: 0.8rem; font-weight: 600;">Course Completion</span>
                    <h3 style="font-size: 1.5rem; font-weight: 800; margin-top: 0.25rem; color: var(--text);"><%= overallCompletion %>% Overall</h3>
                </div>
            </div>

            <div class="grid-2">
                <!-- Left Column -->
                <div>
                    <!-- Continue Learning Card (Dynamic) -->
                    <% if (continueCourse != null) { %>
                        <div class="lms-card" style="padding: 1.75rem; margin-bottom: 2rem; background: linear-gradient(135deg, #1E3A8A, #2563EB); color: #FFFFFF;">
                            <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 1rem;">
                                <div>
                                    <span style="background: rgba(255,255,255,0.2); padding: 0.3rem 0.75rem; border-radius: 20px; font-size: 0.75rem; font-weight: 600;">Continue Learning</span>
                                    <h2 style="font-size: 1.4rem; font-weight: 800; margin-top: 0.5rem; color: #FFFFFF;"><%= continueCourse.getTitle() %></h2>
                                    <p style="color: rgba(255,255,255,0.8); font-size: 0.85rem; margin-top: 0.2rem;"><%= continueCourse.getDescription() %></p>
                                </div>
                                <a href="${pageContext.request.contextPath}/courses?action=view&id=<%= continueCourse.getCourseId() %>" class="btn-lms" style="background: #FFFFFF; color: var(--primary); font-weight: 700;">
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
                    <% } else { %>
                        <div class="lms-card" style="padding: 2rem; text-align: center; margin-bottom: 2rem;">
                            <p style="color: var(--secondary);">No active courses enrolled. <a href="${pageContext.request.contextPath}/courses" style="color: var(--primary);">Explore Courses</a></p>
                        </div>
                    <% } %>

                    <!-- Recent Announcements (Dynamic Loop) -->
                    <div class="lms-card" style="padding: 1.5rem;">
                        <h3 style="font-size: 1.1rem; font-weight: 700; margin-bottom: 1rem;"><i class="bi bi-megaphone" style="color: var(--primary); margin-right: 0.5rem;"></i> Course Announcements</h3>
                        
                        <div style="display: flex; flex-direction: column; gap: 1rem;">
                            <% if (announcements != null && !announcements.isEmpty()) {
                                for (Announcement a : announcements) { %>
                                    <div style="padding-bottom: 1rem; border-bottom: 1px solid var(--border);">
                                        <strong style="font-size: 0.95rem; display: block; color: var(--text);"><%= a.getTitle() %></strong>
                                        <p style="font-size: 0.85rem; color: var(--secondary); margin: 0.2rem 0;"><%= a.getContent() %></p>
                                        <span style="font-size: 0.75rem; color: var(--secondary);"><%= a.getCourseTitle() != null ? a.getCourseTitle() : "Course" %> • Posted by <%= a.getPosterName() != null ? a.getPosterName() : "Instructor" %></span>
                                    </div>
                            <%  } 
                               } else { %>
                                <div style="text-align: center; padding: 1rem; color: var(--secondary); font-size: 0.85rem;">
                                    No Data Available
                                </div>
                            <% } %>
                        </div>
                    </div>
                </div>

                <!-- Right Column: Dynamic Upcoming Assignments Timeline -->
                <div>
                    <div class="lms-card" style="padding: 1.5rem; margin-bottom: 1.5rem;">
                        <h3 style="font-size: 1.1rem; font-weight: 700; margin-bottom: 1rem;"><i class="bi bi-clock-history" style="color: var(--warning); margin-right: 0.5rem;"></i> Upcoming Assignments</h3>

                        <div style="display: flex; flex-direction: column; gap: 1rem;">
                            <% if (upcomingAssignments != null && !upcomingAssignments.isEmpty()) {
                                for (Assignment asg : upcomingAssignments) { %>
                                    <div style="display: flex; align-items: center; justify-content: space-between; padding: 0.75rem 1rem; background: var(--bg); border-radius: 10px;">
                                        <div>
                                            <strong style="font-size: 0.9rem; display: block; color: var(--text);"><%= asg.getTitle() %></strong>
                                            <span style="font-size: 0.75rem; color: var(--secondary);"><%= asg.getCourseTitle() != null ? asg.getCourseTitle() : "Course" %></span>
                                        </div>
                                        <span style="font-size: 0.8rem; font-weight: 700; color: var(--error);"><%= asg.getDueDate() %></span>
                                    </div>
                            <%  }
                               } else { %>
                                <div style="text-align: center; padding: 1rem; color: var(--secondary); font-size: 0.85rem;">
                                    No Data Available
                                </div>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <!-- AI Study Assistant FAB -->
    <button class="ai-fab" onclick="alert('🤖 AI Assistant: Summarising lecture notes and generating study quizzes for your enrolled courses!')">
        <i class="bi bi-robot" style="font-size: 1.5rem;"></i>
    </button>

    <script>
        function toggleNotifications() {
            document.getElementById('notifDropdown').classList.toggle('active');
        }

        function filterContent() {
            const query = document.getElementById('searchBox').value.toLowerCase();
            // Client side filter suggestion demo
        }
    </script>
</body>
</html>
