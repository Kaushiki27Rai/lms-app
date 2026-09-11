<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.lms.model.Course" %>
<%@ page import="com.lms.model.User" %>
<%@ page import="java.util.List" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/auth");
        return;
    }
    List<Course> courses = (List<Course>) request.getAttribute("courses");
    String pageTitle = (String) request.getAttribute("pageTitle");
    if (pageTitle == null) pageTitle = "Courses";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= pageTitle %> - LMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .courses-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 1.5rem;
            margin-top: 2rem;
        }
        .course-card-banner {
            height: 160px;
            border-radius: var(--radius-card) var(--radius-card) 0 0;
            background-size: cover;
            background-position: center;
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
                <li><a href="${pageContext.request.contextPath}/dashboard" class="sidebar-link"><i class="bi bi-grid-1x2-fill"></i> Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/courses?action=my-courses" class="sidebar-link <%= "My Enrolled Courses".equals(pageTitle) ? "active" : "" %>"><i class="bi bi-journal-bookmark-fill"></i> My Courses</a></li>
                <li><a href="${pageContext.request.contextPath}/courses" class="sidebar-link <%= "Explore All Courses".equals(pageTitle) ? "active" : "" %>"><i class="bi bi-compass"></i> Explore Courses</a></li>
                <li><a href="#" class="sidebar-link"><i class="bi bi-gear"></i> Settings</a></li>
            </ul>
        </aside>

        <main class="main-content">
            <!-- Header -->
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem;">
                <div>
                    <h1 style="font-size: 1.8rem; font-weight: 800;"><%= pageTitle %></h1>
                    <p style="color: var(--secondary); font-size: 0.95rem;">Master new skills with our curriculum.</p>
                </div>

                <% if ("instructor".equalsIgnoreCase(currentUser.getRole()) || "admin".equalsIgnoreCase(currentUser.getRole())) { %>
                    <a href="${pageContext.request.contextPath}/courses?action=create" class="btn-lms btn-lms-primary">
                        <i class="bi bi-plus-lg"></i> Create Course
                    </a>
                <% } %>
            </div>

            <!-- Dynamic Courses Grid -->
            <div class="courses-grid">
                <% if (courses != null && !courses.isEmpty()) {
                    for (Course c : courses) { %>
                        <div class="lms-card" style="overflow: hidden;">
                            <div class="course-card-banner" style="background-image: url('<%= c.getBannerUrl() != null ? c.getBannerUrl() : "https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=800" %>');"></div>
                            
                            <div style="padding: 1.5rem;">
                                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.75rem;">
                                    <span class="badge-lms badge-student"><%= c.getCategory() %></span>
                                    <span style="font-size: 0.8rem; color: var(--secondary);"><i class="bi bi-person"></i> <%= c.getInstructorName() != null ? c.getInstructorName() : "Dr. Smith" %></span>
                                </div>
                                <h3 style="font-size: 1.15rem; font-weight: 700; margin-bottom: 0.5rem;"><%= c.getTitle() %></h3>
                                <p style="color: var(--secondary); font-size: 0.85rem; margin-bottom: 1.25rem; line-height: 1.4;"><%= c.getDescription() %></p>

                                <div style="display: flex; justify-content: space-between; align-items: center; pt-3; border-top: 1px solid var(--border);">
                                    <span style="font-size: 0.8rem; color: var(--secondary);"><i class="bi bi-calendar3"></i> <%= c.getStartDate() %></span>
                                    <a href="${pageContext.request.contextPath}/courses?action=view&id=<%= c.getCourseId() %>" class="btn-lms btn-lms-secondary" style="font-size: 0.85rem; padding: 0.4rem 0.9rem;">
                                        View Course <i class="bi bi-arrow-right"></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                <% } } else { %>
                    <!-- Empty State -->
                    <div class="lms-card" style="grid-column: 1 / -1; padding: 4rem; text-align: center;">
                        <i class="bi bi-journal-x" style="font-size: 3.5rem; color: var(--secondary);"></i>
                        <h3 style="font-size: 1.25rem; font-weight: 700; margin-top: 1rem;">No Courses Found</h3>
                        <p style="color: var(--secondary); margin-top: 0.25rem;">No courses available matching your request.</p>
                    </div>
                <% } %>
            </div>
        </main>
    </div>

</body>
</html>
