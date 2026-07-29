<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.lms.model.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null || (!"instructor".equalsIgnoreCase(currentUser.getRole()) && !"admin".equalsIgnoreCase(currentUser.getRole()))) {
        response.sendRedirect(request.getContextPath() + "/courses");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create New Course - LMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color: #f4f6f9; font-family: 'Segoe UI', sans-serif; }
    </style>
</head>
<body>

    <div class="container my-5" style="max-width: 650px;">
        <div class="card border-0 shadow-sm p-4 rounded-4 bg-white">
            <h3 class="fw-bold text-dark mb-1"><i class="bi bi-plus-circle text-primary me-2"></i>Create New Course</h3>
            <p class="text-secondary small mb-4">Add a new course curriculum to the LMS platform.</p>

            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="alert alert-danger mb-4"><%= request.getAttribute("errorMessage") %></div>
            <% } %>

            <form action="${pageContext.request.contextPath}/courses" method="POST">
                <input type="hidden" name="action" value="create"/>

                <div class="mb-3">
                    <label class="form-label fw-bold small text-secondary">Course Title</label>
                    <input type="text" name="title" class="form-control" placeholder="e.g. Advanced Java Programming" required>
                </div>

                <div class="mb-3">
                    <label class="form-label fw-bold small text-secondary">Course Description</label>
                    <textarea name="description" class="form-control" rows="4" placeholder="Detailed outline of the course..." required></textarea>
                </div>

                <div class="row g-3 mb-4">
                    <div class="col-md-6">
                        <label class="form-label fw-bold small text-secondary">Start Date</label>
                        <input type="date" name="startDate" class="form-control" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-bold small text-secondary">End Date</label>
                        <input type="date" name="endDate" class="form-control" required>
                    </div>
                </div>

                <div class="d-flex gap-3">
                    <a href="${pageContext.request.contextPath}/courses" class="btn btn-outline-secondary w-50">Cancel</a>
                    <button type="submit" class="btn btn-primary w-50 fw-bold">Publish Course</button>
                </div>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
