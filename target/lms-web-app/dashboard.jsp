<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.lms.model.User" %>
<%
    User currentUser = (User) request.getAttribute("currentUser");
    if (currentUser == null) {
        currentUser = (User) session.getAttribute("user");
    }
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/auth?action=login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LMS Dashboard - <%= currentUser.getUsername() %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background-color: #f4f6f9;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .navbar-brand {
            font-weight: 700;
            letter-spacing: 0.5px;
        }
        .stat-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            transition: transform 0.2s ease;
        }
        .stat-card:hover {
            transform: translateY(-3px);
        }
        .role-badge {
            text-transform: capitalize;
        }
    </style>
</head>
<body>

    <!-- Top Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top">
        <div class="container">
            <a class="navbar-brand text-primary" href="#">
                <i class="bi bi-journal-bookmark-fill me-2"></i>LMS Platform
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navContent">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navContent">
                <ul class="navbar-header nav me-auto">
                    <li class="nav-item"><a class="nav-link text-white active" href="#">Dashboard</a></li>
                    <li class="nav-item"><a class="nav-link text-secondary" href="#">Courses</a></li>
                    <li class="nav-item"><a class="nav-link text-secondary" href="#">Quizzes</a></li>
                </ul>
                <div class="d-flex align-items-center gap-3">
                    <span class="text-light small">
                        Welcome, <strong><%= currentUser.getUsername() %></strong> 
                        <span class="badge bg-primary ms-1 role-badge"><%= currentUser.getRole() %></span>
                    </span>
                    <a href="${pageContext.request.contextPath}/auth?action=logout" class="btn btn-outline-danger btn-sm">
                        <i class="bi bi-box-arrow-right me-1"></i>Logout
                    </a>
                </div>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="container my-5">
        <div class="row mb-4">
            <div class="col">
                <h2 class="fw-bold text-dark mb-1">Welcome back, <%= currentUser.getUsername() %> 👋</h2>
                <p class="text-secondary">Here is an overview of your Learning Management System.</p>
            </div>
        </div>

        <!-- Quick Stats Grid -->
        <div class="row g-4 mb-5">
            <div class="col-md-4">
                <div class="card stat-card p-4 bg-white">
                    <div class="d-flex align-items-center justify-content-between">
                        <div>
                            <span class="text-secondary small fw-bold uppercase">Enrolled Courses</span>
                            <h3 class="fw-bold text-dark mt-2 mb-0">3 Active</h3>
                        </div>
                        <div class="bg-primary bg-opacity-10 text-primary p-3 rounded-circle">
                            <i class="bi bi-book fs-3"></i>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card stat-card p-4 bg-white">
                    <div class="d-flex align-items-center justify-content-between">
                        <div>
                            <span class="text-secondary small fw-bold">Upcoming Quizzes</span>
                            <h3 class="fw-bold text-dark mt-2 mb-0">1 Scheduled</h3>
                        </div>
                        <div class="bg-warning bg-opacity-10 text-warning p-3 rounded-circle">
                            <i class="bi bi-patch-question fs-3"></i>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card stat-card p-4 bg-white">
                    <div class="d-flex align-items-center justify-content-between">
                        <div>
                            <span class="text-secondary small fw-bold">Average Score</span>
                            <h3 class="fw-bold text-success mt-2 mb-0">85.5%</h3>
                        </div>
                        <div class="bg-success bg-opacity-10 text-success p-3 rounded-circle">
                            <i class="bi bi-trophy fs-3"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Role Specific Section -->
        <div class="card border-0 shadow-sm rounded-4 p-4">
            <h4 class="fw-bold mb-3">Recent Activity</h4>
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th>Course Name</th>
                            <th>Role</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td><strong class="text-dark">Introduction to SQL</strong></td>
                            <td><span class="badge bg-info text-dark text-capitalize"><%= currentUser.getRole() %></span></td>
                            <td><span class="badge bg-success">In Progress</span></td>
                            <td><button class="btn btn-sm btn-outline-primary">Continue Learning</button></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
