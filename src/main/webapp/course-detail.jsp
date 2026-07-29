<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.lms.model.Course" %>
<%@ page import="com.lms.model.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/auth?action=login");
        return;
    }
    Course course = (Course) request.getAttribute("course");
    Boolean isEnrolled = (Boolean) request.getAttribute("isEnrolled");
    if (isEnrolled == null) isEnrolled = false;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= course != null ? course.getTitle() : "Course Details" %> - LMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color: #f4f6f9; font-family: 'Segoe UI', sans-serif; }
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
                    <li class="nav-item"><a class="nav-link text-white active" href="${pageContext.request.contextPath}/courses">Courses</a></li>
                </ul>
                <div class="d-flex align-items-center gap-3">
                    <a href="${pageContext.request.contextPath}/auth?action=logout" class="btn btn-outline-danger btn-sm">Logout</a>
                </div>
            </div>
        </div>
    </nav>

    <div class="container my-5">
        <% if (request.getParameter("msg") != null && "enrolled".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>You have successfully enrolled in this course!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>

        <% if (course != null) { %>
            <div class="row g-4">
                <div class="col-lg-8">
                    <div class="card border-0 shadow-sm p-4 rounded-4 bg-white mb-4">
                        <span class="badge bg-primary bg-opacity-10 text-primary w-auto align-self-start px-3 py-2 rounded-pill mb-3">Active Course</span>
                        <h2 class="fw-bold text-dark mb-3"><%= course.getTitle() %></h2>
                        <p class="text-secondary leading-relaxed"><%= course.getDescription() %></p>
                        <div class="d-flex gap-4 mt-4 pt-3 border-top text-muted small">
                            <span><i class="bi bi-person-circle me-1 text-primary"></i>Instructor: <strong><%= course.getInstructorName() != null ? course.getInstructorName() : "Dr. Smith" %></strong></span>
                            <span><i class="bi bi-calendar-event me-1 text-primary"></i>Duration: <%= course.getStartDate() %> to <%= course.getEndDate() %></span>
                        </div>
                    </div>

                    <!-- Quizzes Section -->
                    <div class="card border-0 shadow-sm p-4 rounded-4 bg-white">
                        <h4 class="fw-bold mb-3"><i class="bi bi-patch-question text-warning me-2"></i>Course Assessment Quiz</h4>
                        <p class="text-secondary small mb-3">Test your knowledge on course concepts.</p>
                        <div class="d-flex align-items-center justify-content-between p-3 bg-light rounded-3">
                            <div>
                                <h6 class="fw-bold mb-1">SQL Basics Quiz</h6>
                                <span class="text-muted small">Multiple Choice Assessment (10 mins)</span>
                            </div>
                            <a href="${pageContext.request.contextPath}/quizzes?action=take&id=1" class="btn btn-warning text-dark font-weight-bold">
                                Take Quiz <i class="bi bi-pencil-square ms-1"></i>
                            </a>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="card border-0 shadow-sm p-4 rounded-4 bg-white sticky-top" style="top: 90px;">
                        <h4 class="fw-bold text-dark mb-3">Enrollment</h4>
                        <% if (isEnrolled) { %>
                            <div class="alert alert-success text-center mb-0">
                                <i class="bi bi-check-circle-fill me-2 fs-5"></i>You are Enrolled
                            </div>
                        <% } else { %>
                            <form action="${pageContext.request.contextPath}/courses" method="POST">
                                <input type="hidden" name="action" value="enroll"/>
                                <input type="hidden" name="courseId" value="<%= course.getCourseId() %>"/>
                                <button type="submit" class="btn btn-primary btn-lg w-100 fw-bold">
                                    Enroll Now <i class="bi bi-arrow-right-circle ms-1"></i>
                                </button>
                            </form>
                        <% } %>
                    </div>
                </div>
            </div>
        <% } %>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
