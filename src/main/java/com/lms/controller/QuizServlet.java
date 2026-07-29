package com.lms.controller;

import com.lms.model.Question;
import com.lms.model.Quiz;
import com.lms.model.User;
import com.lms.service.QuizService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/quizzes")
public class QuizServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private QuizService quizService;

    @Override
    public void init() throws ServletException {
        this.quizService = new QuizService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth");
            return;
        }

        String action = request.getParameter("action");
        if ("take".equalsIgnoreCase(action)) {
            int quizId = Integer.parseInt(request.getParameter("id"));
            Quiz quiz = quizService.getQuizDetails(quizId);
            request.setAttribute("quiz", quiz);
            request.getRequestDispatcher("/quiz.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        int quizId = Integer.parseInt(request.getParameter("quizId"));

        Quiz quiz = quizService.getQuizDetails(quizId);
        Map<Integer, String> studentAnswers = new HashMap<>();

        if (quiz != null && quiz.getQuestions() != null) {
            for (Question q : quiz.getQuestions()) {
                String selected = request.getParameter("q_" + q.getQuestionId());
                if (selected != null) {
                    studentAnswers.put(q.getQuestionId(), selected);
                }
            }
        }

        double score = quizService.evaluateAndSubmit(quizId, currentUser.getUserId(), studentAnswers);

        request.setAttribute("quiz", quiz);
        request.setAttribute("studentAnswers", studentAnswers);
        request.setAttribute("finalScore", score);
        request.setAttribute("quizSubmitted", true);
        request.getRequestDispatcher("/quiz.jsp").forward(request, response);
    }
}
