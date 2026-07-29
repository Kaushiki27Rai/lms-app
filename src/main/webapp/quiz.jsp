<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.lms.model.Quiz" %>
<%@ page import="com.lms.model.Question" %>
<%@ page import="com.lms.model.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%
    User currentUser = (User) session.getAttribute("user");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/auth");
        return;
    }
    Quiz quiz = (Quiz) request.getAttribute("quiz");
    Boolean quizSubmitted = (Boolean) request.getAttribute("quizSubmitted");
    Double finalScore = (Double) request.getAttribute("finalScore");
    Map<Integer, String> studentAnswers = (Map<Integer, String>) request.getAttribute("studentAnswers");
    if (quizSubmitted == null) quizSubmitted = false;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= quiz != null ? quiz.getTitle() : "Quiz" %> - LMS Assessment</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .quiz-container { max-width: 800px; margin: 2rem auto 4rem; padding: 0 1.5rem; }
        .question-card { margin-bottom: 1.5rem; padding: 1.75rem; }
        .options-group { display: flex; flex-direction: column; gap: 0.75rem; margin-top: 1rem; }
        .option-item {
            display: flex;
            align-items: center;
            padding: 1rem 1.25rem;
            border: 2px solid var(--border);
            border-radius: var(--radius-btn);
            background: #FFFFFF;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .option-item:hover { border-color: var(--primary); background: var(--primary-light); }
        .option-item input[type="radio"] {
            margin-right: 1rem;
            width: 18px;
            height: 18px;
            accent-color: var(--primary);
            cursor: pointer;
        }
        .option-item.selected { border-color: var(--primary); background: var(--primary-light); font-weight: 600; }
        .correct-answer { border-color: var(--accent) !important; background: #ECFDF5 !important; }
        .incorrect-answer { border-color: var(--error) !important; background: #FEF2F2 !important; }
    </style>
</head>
<body>

    <!-- Header -->
    <header style="background: #FFFFFF; border-bottom: 1px solid var(--border); padding: 1rem 2rem; display: flex; justify-content: space-between; align-items: center;">
        <a href="${pageContext.request.contextPath}/dashboard" class="sidebar-brand" style="margin: 0;">
            <i class="bi bi-book-half"></i> LMS Assessment
        </a>
        <a href="${pageContext.request.contextPath}/dashboard" class="btn-lms btn-lms-outline" style="font-size: 0.85rem;">
            Exit Quiz
        </a>
    </header>

    <div class="quiz-container">
        <% if (quizSubmitted) { %>
            <!-- QUIZ RESULT SUMMARY -->
            <div class="lms-card" style="padding: 2.5rem; text-align: center; margin-bottom: 2rem;">
                <div style="width: 70px; height: 70px; background: #FEF3C7; color: var(--warning); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 1.25rem; font-size: 2rem;">
                    <i class="bi bi-trophy-fill"></i>
                </div>
                <h1 style="font-size: 2rem; font-weight: 800;">Quiz Completed!</h1>
                <p style="color: var(--secondary); margin-top: 0.25rem;">Your assessment score has been recorded.</p>
                
                <div style="font-size: 3.5rem; font-weight: 800; color: var(--primary); margin: 1.5rem 0;">
                    <%= finalScore %>%
                </div>

                <div style="display: flex; gap: 1rem; justify-content: center; margin-top: 1.5rem;">
                    <a href="${pageContext.request.contextPath}/dashboard" class="btn-lms btn-lms-primary">
                        Return to Dashboard
                    </a>
                    <a href="${pageContext.request.contextPath}/courses" class="btn-lms btn-lms-secondary">
                        Browse Courses
                    </a>
                </div>
            </div>

            <!-- DETAILED QUESTION REVIEW -->
            <h3 style="font-size: 1.25rem; font-weight: 700; margin-bottom: 1rem;">Question Review</h3>
            <% if (quiz != null && quiz.getQuestions() != null) {
                int revIdx = 1;
                for (Question q : quiz.getQuestions()) { 
                    String userAns = studentAnswers != null ? studentAnswers.get(q.getQuestionId()) : "";
                    boolean isCorrect = q.getCorrectOption().equalsIgnoreCase(userAns);
            %>
                <div class="lms-card question-card">
                    <div style="display: flex; justify-content: space-between; align-items: flex-start;">
                        <h4 style="font-size: 1.05rem; font-weight: 700; color: var(--text);">
                            Q<%= revIdx++ %>. <%= q.getQuestionText() %>
                        </h4>
                        <% if (isCorrect) { %>
                            <span class="badge-lms" style="background: #ECFDF5; color: var(--accent);"><i class="bi bi-check-circle-fill"></i> Correct</span>
                        <% } else { %>
                            <span class="badge-lms" style="background: #FEF2F2; color: var(--error);"><i class="bi bi-x-circle-fill"></i> Incorrect</span>
                        <% } %>
                    </div>

                    <div class="options-group">
                        <div class="option-item <%= "A".equalsIgnoreCase(q.getCorrectOption()) ? "correct-answer" : ("A".equalsIgnoreCase(userAns) ? "incorrect-answer" : "") %>">
                            <strong>A.</strong> &nbsp; <%= q.getOptionA() %>
                        </div>
                        <div class="option-item <%= "B".equalsIgnoreCase(q.getCorrectOption()) ? "correct-answer" : ("B".equalsIgnoreCase(userAns) ? "incorrect-answer" : "") %>">
                            <strong>B.</strong> &nbsp; <%= q.getOptionB() %>
                        </div>
                        <div class="option-item <%= "C".equalsIgnoreCase(q.getCorrectOption()) ? "correct-answer" : ("C".equalsIgnoreCase(userAns) ? "incorrect-answer" : "") %>">
                            <strong>C.</strong> &nbsp; <%= q.getOptionC() %>
                        </div>
                        <div class="option-item <%= "D".equalsIgnoreCase(q.getCorrectOption()) ? "correct-answer" : ("D".equalsIgnoreCase(userAns) ? "incorrect-answer" : "") %>">
                            <strong>D.</strong> &nbsp; <%= q.getOptionD() %>
                        </div>
                    </div>
                </div>
            <% } } %>

        <% } else if (quiz != null) { %>
            <!-- QUIZ QUESTION PLAYER -->
            <div class="lms-card" style="padding: 1.75rem; margin-bottom: 2rem;">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.5rem;">
                    <span class="badge-lms badge-warning"><i class="bi bi-clock"></i> Timed Assessment</span>
                    <span style="font-size: 0.85rem; color: var(--secondary);"><%= quiz.getQuestions().size() %> Questions</span>
                </div>
                <h1 style="font-size: 1.6rem; font-weight: 800;"><%= quiz.getTitle() %></h1>
                <p style="color: var(--secondary); font-size: 0.9rem; margin-top: 0.25rem;"><%= quiz.getDescription() %></p>
            </div>

            <form action="${pageContext.request.contextPath}/quizzes" method="POST">
                <input type="hidden" name="quizId" value="<%= quiz.getQuizId() %>"/>

                <% if (quiz.getQuestions() != null && !quiz.getQuestions().isEmpty()) { 
                    int qIdx = 1;
                    for (Question q : quiz.getQuestions()) { %>
                        <div class="lms-card question-card">
                            <h4 style="font-size: 1.05rem; font-weight: 700; color: var(--text); margin-bottom: 1rem;">
                                Q<%= qIdx++ %>. <%= q.getQuestionText() %>
                            </h4>

                            <div class="options-group">
                                <label class="option-item" onclick="highlightOption(this)">
                                    <input type="radio" name="q_<%= q.getQuestionId() %>" value="A" required>
                                    <span><strong>A.</strong> &nbsp; <%= q.getOptionA() %></span>
                                </label>

                                <label class="option-item" onclick="highlightOption(this)">
                                    <input type="radio" name="q_<%= q.getQuestionId() %>" value="B">
                                    <span><strong>B.</strong> &nbsp; <%= q.getOptionB() %></span>
                                </label>

                                <label class="option-item" onclick="highlightOption(this)">
                                    <input type="radio" name="q_<%= q.getQuestionId() %>" value="C">
                                    <span><strong>C.</strong> &nbsp; <%= q.getOptionC() %></span>
                                </label>

                                <label class="option-item" onclick="highlightOption(this)">
                                    <input type="radio" name="q_<%= q.getQuestionId() %>" value="D">
                                    <span><strong>D.</strong> &nbsp; <%= q.getOptionD() %></span>
                                </label>
                            </div>
                        </div>
                <% } } else { %>
                    <div class="lms-card" style="padding: 3rem; text-align: center;">
                        <i class="bi bi-patch-question" style="font-size: 3rem; color: var(--secondary);"></i>
                        <p style="margin-top: 1rem; color: var(--secondary);">No questions available for this quiz.</p>
                    </div>
                <% } %>

                <button type="submit" class="btn-lms btn-lms-primary" style="width: 100%; padding: 1rem; font-size: 1.05rem;">
                    Submit Quiz Answers <i class="bi bi-send-fill"></i>
                </button>
            </form>
        <% } %>
    </div>

    <script>
        function highlightOption(labelElement) {
            const group = labelElement.closest('.options-group');
            group.querySelectorAll('.option-item').forEach(el => el.classList.remove('selected'));
            labelElement.classList.add('selected');
        }
    </script>
</body>
</html>
