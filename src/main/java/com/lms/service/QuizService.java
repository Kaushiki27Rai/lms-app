package com.lms.service;

import com.lms.dao.QuizDao;
import com.lms.model.Question;
import com.lms.model.Quiz;
import com.lms.model.QuizSubmission;

import java.util.List;
import java.util.Map;

public class QuizService {

    private final QuizDao quizDao;

    public QuizService() {
        this.quizDao = new QuizDao();
    }

    public QuizService(QuizDao quizDao) {
        this.quizDao = quizDao;
    }

    public List<Quiz> getCourseQuizzes(int courseId) {
        return quizDao.getQuizzesByCourse(courseId);
    }

    public Quiz getQuizDetails(int quizId) {
        return quizDao.getQuizWithQuestions(quizId);
    }

    public double evaluateAndSubmit(int quizId, int studentId, Map<Integer, String> studentAnswers) {
        Quiz quiz = quizDao.getQuizWithQuestions(quizId);
        if (quiz == null || quiz.getQuestions().isEmpty()) {
            return 0.0;
        }

        int correctCount = 0;
        List<Question> questions = quiz.getQuestions();

        for (Question q : questions) {
            String selectedOption = studentAnswers.get(q.getQuestionId());
            if (selectedOption != null && selectedOption.equalsIgnoreCase(q.getCorrectOption())) {
                correctCount++;
            }
        }

        double scorePercentage = ((double) correctCount / questions.size()) * 100.0;

        QuizSubmission submission = new QuizSubmission(quizId, studentId, Math.round(scorePercentage * 100.0) / 100.0);
        quizDao.saveSubmission(submission);

        return submission.getScore();
    }

    public List<QuizSubmission> getStudentSubmissions(int studentId) {
        return quizDao.getStudentSubmissions(studentId);
    }
}
