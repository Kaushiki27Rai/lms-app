<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.lms.model.Course" %>
<%@ page import="com.lms.model.Lesson" %>
<%@ page import="com.lms.model.Assignment" %>
<%@ page import="com.lms.model.Announcement" %>
<%@ page import="com.lms.model.User" %>
<%@ page import="java.util.List" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/auth");
        return;
    }
    Course course = (Course) request.getAttribute("course");
    Boolean isEnrolled = (Boolean) request.getAttribute("isEnrolled");
    List<Lesson> modules = (List<Lesson>) request.getAttribute("modules");
    List<Assignment> assignments = (List<Assignment>) request.getAttribute("assignments");
    if (isEnrolled == null) isEnrolled = false;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= course != null ? course.getTitle() : "Course Details" %> - LMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .course-banner {
            height: 240px;
            border-radius: var(--radius-card);
            background-size: cover;
            background-position: center;
            position: relative;
            margin-bottom: 2rem;
            display: flex;
            align-items: flex-end;
            padding: 2rem;
            color: #FFFFFF;
        }
        .course-banner::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            background: linear-gradient(180deg, rgba(0,0,0,0.2) 0%, rgba(0,0,0,0.8) 100%);
            border-radius: var(--radius-card);
        }
        .banner-content { position: relative; z-index: 2; width: 100%; }
        .tabs-nav {
            display: flex;
            gap: 1.5rem;
            border-bottom: 1px solid var(--border);
            margin-bottom: 2rem;
        }
        .tab-btn {
            padding: 0.75rem 0.25rem;
            font-weight: 600;
            color: var(--secondary);
            cursor: pointer;
            border-bottom: 2px solid transparent;
            transition: all 0.2s;
        }
        .tab-btn.active { color: var(--primary); border-bottom-color: var(--primary); }
        .tab-content-panel { display: none; }
        .tab-content-panel.active { display: block; }
        .accordion-item {
            border: 1px solid var(--border);
            border-radius: 12px;
            margin-bottom: 1rem;
            overflow: hidden;
            background: #FFFFFF;
        }
        .accordion-header {
            padding: 1.25rem;
            background: #FFFFFF;
            cursor: pointer;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-weight: 700;
        }
        .accordion-body {
            padding: 1.25rem;
            border-top: 1px solid var(--border);
            background: var(--bg);
            display: none;
        }
        .accordion-item.open .accordion-body { display: block; }
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
                <li><a href="${pageContext.request.contextPath}/courses" class="sidebar-link active"><i class="bi bi-journal-bookmark-fill"></i> Courses</a></li>
                <li><a href="#" class="sidebar-link"><i class="bi bi-file-earmark-text"></i> Assignments</a></li>
                <li><a href="#" class="sidebar-link"><i class="bi bi-gear"></i> Settings</a></li>
            </ul>
        </aside>

        <main class="main-content">
            <% if (course != null) { %>
                <!-- Banner -->
                <div class="course-banner" style="background-image: url('<%= course.getBannerUrl() != null ? course.getBannerUrl() : "https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=800" %>');">
                    <div class="banner-content">
                        <span class="badge-lms" style="background: var(--primary); color: #FFFFFF; margin-bottom: 0.5rem;"><%= course.getCategory() %></span>
                        <h1 style="font-size: 2.2rem; font-weight: 800; margin-bottom: 0.3rem; color: #FFFFFF;"><%= course.getTitle() %></h1>
                        <p style="color: rgba(255,255,255,0.85); font-size: 0.95rem;">Instructor: <%= course.getInstructorName() != null ? course.getInstructorName() : "Dr. Smith" %></p>
                    </div>
                </div>

                <!-- Tabs Header -->
                <div class="tabs-nav">
                    <div class="tab-btn active" onclick="switchTab('modules')">Modules & Syllabus</div>
                    <div class="tab-btn" onclick="switchTab('assignments')">Assignments</div>
                    <div class="tab-btn" onclick="switchTab('quizzes')">Quizzes</div>
                    <div class="tab-btn" onclick="switchTab('discussion')">Discussion Forum</div>
                </div>

                <!-- TAB 1: MODULES -->
                <div class="tab-content-panel active" id="tab-modules">
                    <% if (modules != null && !modules.isEmpty()) {
                        int mIdx = 1;
                        for (Lesson m : modules) { %>
                            <div class="accordion-item <%= mIdx == 1 ? "open" : "" %>" onclick="toggleAccordion(this)">
                                <div class="accordion-header">
                                    <span><i class="bi bi-folder2-open" style="color: var(--primary); margin-right: 0.5rem;"></i> Module <%= mIdx++ %>: <%= m.getTitle() %></span>
                                    <i class="bi bi-chevron-down"></i>
                                </div>
                                <div class="accordion-body">
                                    <p style="color: var(--secondary); margin-bottom: 1rem;"><%= m.getContent() %></p>
                                    <div style="display: flex; gap: 1rem;">
                                        <a href="#" class="btn-lms btn-lms-secondary" style="font-size: 0.85rem;" onclick="event.stopPropagation(); alert('Playing video lecture...')">
                                            <i class="bi bi-play-circle"></i> Watch Video Lecture
                                        </a>
                                        <a href="#" class="btn-lms btn-lms-outline" style="font-size: 0.85rem;" onclick="event.stopPropagation(); alert('Downloading PDF lecture notes...')">
                                            <i class="bi bi-file-earmark-pdf"></i> PDF Notes
                                        </a>
                                    </div>
                                </div>
                            </div>
                    <% } } else { %>
                        <div class="lms-card" style="padding: 2.5rem; text-align: center; color: var(--secondary);">
                            <i class="bi bi-journal-x" style="font-size: 2.5rem;"></i>
                            <p style="margin-top: 0.5rem;">No modules published for this course yet.</p>
                        </div>
                    <% } %>
                </div>

                <!-- TAB 2: ASSIGNMENTS -->
                <div class="tab-content-panel" id="tab-assignments">
                    <% if (assignments != null && !assignments.isEmpty()) {
                        for (Assignment a : assignments) { %>
                            <div class="lms-card" style="padding: 1.5rem; margin-bottom: 1.25rem;">
                                <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 0.75rem;">
                                    <div>
                                        <h3 style="font-size: 1.1rem; font-weight: 700;"><%= a.getTitle() %></h3>
                                        <span style="font-size: 0.8rem; color: var(--secondary);">Due: <%= a.getDueDate() %> • Max Marks: <%= a.getMaxMarks() %></span>
                                    </div>
                                    <span class="badge-lms badge-student"><%= a.getStatus() %></span>
                                </div>
                                <p style="color: var(--secondary); font-size: 0.9rem; margin-bottom: 1rem;"><%= a.getInstructions() %></p>
                                
                                <form action="${pageContext.request.contextPath}/assignments" method="POST" enctype="multipart/form-data" style="display: flex; gap: 1rem; align-items: center;">
                                    <input type="hidden" name="assignmentId" value="<%= a.getAssignmentId() %>">
                                    <input type="file" name="submissionFile" class="lms-input" style="max-width: 320px;" required>
                                    <button type="submit" class="btn-lms btn-lms-primary">Submit Work</button>
                                </form>
                            </div>
                    <% } } else { %>
                        <div class="lms-card" style="padding: 2.5rem; text-align: center; color: var(--secondary);">
                            <i class="bi bi-file-earmark-check" style="font-size: 2.5rem;"></i>
                            <p style="margin-top: 0.5rem;">No assignments due for this course.</p>
                        </div>
                    <% } %>
                </div>

                <!-- TAB 3: QUIZZES -->
                <div class="tab-content-panel" id="tab-quizzes">
                    <div class="lms-card" style="padding: 1.5rem;">
                        <div style="display: flex; justify-content: space-between; align-items: center;">
                            <div>
                                <h3 style="font-size: 1.1rem; font-weight: 700;">Data Structures Assessment Quiz</h3>
                                <span style="font-size: 0.8rem; color: var(--secondary);">3 Questions • Timed (15 Mins)</span>
                            </div>
                            <a href="${pageContext.request.contextPath}/quizzes?action=take&id=1" class="btn-lms btn-lms-primary">
                                Start Quiz <i class="bi bi-pencil-square"></i>
                            </a>
                        </div>
                    </div>
                </div>

                <!-- TAB 4: DISCUSSION FORUM -->
                <div class="tab-content-panel" id="tab-discussion">
                    <div class="lms-card" style="padding: 1.5rem; margin-bottom: 1.5rem;">
                        <h3 style="font-size: 1.1rem; font-weight: 700; margin-bottom: 1rem;">Course Discussion Forum</h3>
                        <div style="display: flex; gap: 1rem;">
                            <input type="text" class="lms-input" placeholder="Ask a question about this course..." id="forumInput">
                            <button class="btn-lms btn-lms-primary" onclick="alert('Question posted to discussion forum!')">Post</button>
                        </div>
                    </div>
                </div>
            <% } %>
        </main>
    </div>

    <script>
        function switchTab(tabId) {
            document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
            document.querySelectorAll('.tab-content-panel').forEach(p => p.classList.remove('active'));
            
            event.target.classList.add('active');
            document.getElementById('tab-' + tabId).classList.add('active');
        }

        function toggleAccordion(item) {
            item.classList.toggle('open');
        }
    </script>
</body>
</html>
