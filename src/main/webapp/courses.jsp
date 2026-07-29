<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.lms.model.Course" %>
<%@ page import="com.lms.model.User" %>
<%@ page import="java.util.List" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/auth?action=login");
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
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color: #f4f6f9; font-family: 'Segoe UI', sans-serif; }
        .course-card { border: none; border-radius: 12px; transition: transform 0.2s, box-shadow 0.2s; }
        .course-card:hover { transform: translateY(-4px); box-shadow: 0 10px 20px rgba(0,0,0,0.08); }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top">
        <div class="container">
            <a class="navbar-brand text-primary fw-bold" href="${pageContext.request.contextPath}/dashboard">
                <i class="bi bi-journal-bookmark-fill me-2"></i>LMS Platform
            </a>
            <div class="collapse navbar-collapse">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item"><a class="nav-link text-secondary" href="${pageContext.request.contextPath}/dashboard">Dashboard</a></li>
                    <li class="nav-item"><a class="nav-link active text-white" href="${pageContext.request.contextPath}/courses">Explore Courses</a></li>
                    <li class="nav-item"><a class="nav-link text-secondary" href="${pageContext.request.contextPath}/courses?action=my-courses">My Courses</a></li>
                </ul>
                <div class="d-flex align-items-center gap-3">
                    <% if ("instructor".equalsIgnoreCase(currentUser.getRole()) || "admin".equalsIgnoreCase(currentUser.getRole())) { %>
                        <a href="${pageContext.request.contextPath}/courses?action=create" class="btn btn-primary btn-sm">
                            <i class="bi bi-plus-lg me-1"></i>Create Course
                        </a>
                    <% } %>
                    <span class="text-light small">Hello, <strong><%= currentUser.getUsername() %></strong></span>
                    <a href="${pageContext.request.contextPath}/auth?action=logout" class="btn btn-outline-danger btn-sm">Logout</a>
                </div>
            </div>
        </div>
    </nav>

    <div class="container my-5">
        <div class="d-flex align-items-center justify-content-between mb-4">
            <div>
                <h2 class="fw-bold text-dark mb-1"><%= pageTitle %></h2>
                <p class="text-secondary">Explore and master new skills with our curriculum.</p>
            </div>
        </div>

        <% if (request.getParameter("msg") != null && "course_created".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>Course created successfully!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <div class="row g-4">
            <% if (courses != null && !courses.isEmpty()) { 
                for (Course c : courses) { %>
                    <div class="col-md-6 col-lg-4">
                        <div class="card course-card h-100 p-4 bg-white">
                            <div class="d-flex align-items-center justify-content-between mb-3">
                                <span class="badge bg-primary bg-opacity-10 text-primary px-3 py-2 rounded-pill">Course</span>
                                <span class="text-muted small"><i class="bi bi-person-circle me-1"></i><%= c.getInstructorName() != null ? c.getInstructorName() : "Instructor" %></span>
                            </div>
                            <h4 class="fw-bold text-dark mb-2"><%= c.getTitle() %></h4>
                            <p class="text-secondary small flex-grow-1"><%= c.getDescription() %></p>
                            <div class="pt-3 border-top d-flex align-items-center justify-content-between">
                                <span class="text-muted small"><i class="bi bi-calendar3 me-1"></i><%= c.getStartDate() %></span>
                                <a href="${pageContext.request.contextPath}/courses?action=view&id=<%= c.getCourseId() %>" class="btn btn-outline-primary btn-sm">
                                    View Details <i class="bi bi-arrow-right ms-1"></i>
                                </a>
                            </div>
                        </div>
                    </div>
            <%  } 
               } else { %>
                <div class="col-12 text-center py-5">
                    <i class="bi bi-journal-x text-muted display-4"></i>
                    <h5 class="text-secondary mt-3">No courses available at the moment.</h5>
                </div>
            <% } %>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
