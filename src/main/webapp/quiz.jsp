<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.lms.model.Quiz" %>
<%@ page import="com.lms.model.Question" %>
<%@ page import="com.lms.model.User" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/auth?action=login");
        return;
    }
    Quiz quiz = (Quiz) request.getAttribute("quiz");
    Boolean quizSubmitted = (Boolean) request.getAttribute("quizSubmitted");
    Double finalScore = (Double) request.getAttribute("finalScore");
    if (quizSubmitted == null) quizSubmitted = false;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= quiz != null ? quiz.getTitle() : "Quiz" %> - LMS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color: #f4f6f9; font-family: 'Segoe UI', sans-serif; }
        .option-label { border: 1px solid #dee2e6; border-radius: 8px; padding: 12px 16px; cursor: pointer; transition: all 0.2s; }
        .option-label:hover { background-color: #e9ecef; border-color: #0d6efd; }
        .form-check-input:checked + .option-label { background-color: #e7f1ff; border-color: #0d6efd; font-weight: 600; }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-dark bg-dark sticky-top">
        <div class="container">
            <a class="navbar-brand text-primary fw-bold" href="${pageContext.request.contextPath}/dashboard">
                <i class="bi bi-journal-bookmark-fill me-2"></i>LMS Platform
            </a>
            <div class="d-flex align-items-center gap-3">
                <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-outline-light btn-sm">Exit Quiz</a>
            </div>
        </div>
    </nav>

    <div class="container my-5" style="max-width: 760px;">
        <% if (quizSubmitted) { %>
            <!-- Quiz Score Banner -->
            <div class="card border-0 shadow-sm p-5 text-center rounded-4 bg-white mb-4">
                <div class="mb-3">
                    <i class="bi bi-trophy-fill text-warning display-3"></i>
                </div>
                <h2 class="fw-bold text-dark mb-1">Quiz Complete!</h2>
                <p class="text-secondary">Here is your score calculation result:</p>
                <div class="display-4 fw-bold text-primary my-3"><%= finalScore %>%</div>
                <div class="d-flex justify-content-center gap-3 mt-3">
                    <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary btn-lg px-4">Back to Dashboard</a>
                    <a href="${pageContext.request.contextPath}/courses" class="btn btn-outline-secondary btn-lg px-4">Browse Courses</a>
                </div>
            </div>
        <% } else if (quiz != null) { %>
            <div class="card border-0 shadow-sm p-4 rounded-4 bg-white mb-4">
                <div class="d-flex align-items-center justify-content-between mb-2">
                    <span class="badge bg-warning bg-opacity-10 text-warning px-3 py-2 rounded-pill">Quiz Assessment</span>
                    <span class="text-muted small"><i class="bi bi-clock me-1"></i>Timed</span>
                </div>
                <h2 class="fw-bold text-dark mb-1"><%= quiz.getTitle() %></h2>
                <p class="text-secondary small mb-0"><%= quiz.getDescription() %></p>
            </div>

            <form action="${pageContext.request.contextPath}/quizzes" method="POST">
                <input type="hidden" name="quizId" value="<%= quiz.getQuizId() %>"/>

                <% if (quiz.getQuestions() != null && !quiz.getQuestions().isEmpty()) { 
                    int qIndex = 1;
                    for (Question q : quiz.getQuestions()) { %>
                        <div class="card border-0 shadow-sm p-4 rounded-4 bg-white mb-4">
                            <h5 class="fw-bold text-dark mb-3">Q<%= qIndex++ %>. <%= q.getQuestionText() %></h5>
                            
                            <div class="d-flex flex-column gap-2">
                                <div class="form-check p-0">
                                    <input type="radio" class="btn-check" name="q_<%= q.getQuestionId() %>" id="q_<%= q.getQuestionId() %>_a" value="A" required>
                                    <label class="option-label d-block" for="q_<%= q.getQuestionId() %>_a">
                                        <strong>A.</strong> <%= q.getOptionA() %>
                                    </label>
                                </div>

                                <div class="form-check p-0">
                                    <input type="radio" class="btn-check" name="q_<%= q.getQuestionId() %>" id="q_<%= q.getQuestionId() %>_b" value="B">
                                    <label class="option-label d-block" for="q_<%= q.getQuestionId() %>_b">
                                        <strong>B.</strong> <%= q.getOptionB() %>
                                    </label>
                                </div>

                                <div class="form-check p-0">
                                    <input type="radio" class="btn-check" name="q_<%= q.getQuestionId() %>" id="q_<%= q.getQuestionId() %>_c" value="C">
                                    <label class="option-label d-block" for="q_<%= q.getQuestionId() %>_c">
                                        <strong>C.</strong> <%= q.getOptionC() %>
                                    </label>
                                </div>

                                <div class="form-check p-0">
                                    <input type="radio" class="btn-check" name="q_<%= q.getQuestionId() %>" id="q_<%= q.getQuestionId() %>_d" value="D">
                                    <label class="option-label d-block" for="q_<%= q.getQuestionId() %>_d">
                                        <strong>D.</strong> <%= q.getOptionD() %>
                                    </label>
                                </div>
                            </div>
                        </div>
                <%  } 
                   } %>

                <button type="submit" class="btn btn-success btn-lg w-100 fw-bold py-3">
                    Submit Answers <i class="bi bi-send-fill ms-2"></i>
                </button>
            </form>
        <% } %>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
