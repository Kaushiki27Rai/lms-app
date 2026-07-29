package com.lms.dao;

import com.lms.model.Question;
import com.lms.model.Quiz;
import com.lms.model.QuizSubmission;
import com.lms.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

public class QuizDao {

    private static final List<Quiz> mockQuizzes = new CopyOnWriteArrayList<>();
    private static final List<QuizSubmission> mockSubmissions = new CopyOnWriteArrayList<>();

    static {
        Quiz sqlQuiz = new Quiz(1, 1, "SQL Basics Quiz", "Test your knowledge on SQL queries, JOINs, and database tables.", new Timestamp(System.currentTimeMillis()));

        List<Question> questions = new ArrayList<>();
        questions.add(new Question(1, 1, "Which SQL keyword is used to retrieve data from a database?", "GET", "SELECT", "FETCH", "OPEN", "B"));
        questions.add(new Question(2, 1, "Which clause is used to filter records in SQL?", "ORDER BY", "GROUP BY", "WHERE", "HAVING", "C"));
        questions.add(new Question(3, 1, "Which JOIN returns all rows when there is a match in one of the tables?", "INNER JOIN", "FULL OUTER JOIN", "LEFT JOIN", "CROSS JOIN", "B"));

        sqlQuiz.setQuestions(questions);
        mockQuizzes.add(sqlQuiz);
    }

    public List<Quiz> getQuizzesByCourse(int courseId) {
        List<Quiz> list = new ArrayList<>();
        String sql = "SELECT quiz_id, course_id, title, description, date FROM Quizzes WHERE course_id = ? ORDER BY date DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, courseId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowToQuiz(rs));
                }
            }
            return list;
        } catch (Exception e) {
            return new ArrayList<>(mockQuizzes);
        }
    }

    public Quiz getQuizWithQuestions(int quizId) {
        String sql = "SELECT quiz_id, course_id, title, description, date FROM Quizzes WHERE quiz_id = ?";
        Quiz quiz = null;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, quizId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    quiz = mapRowToQuiz(rs);
                }
            }
        } catch (Exception e) {
            // Fallback
        }

        if (quiz != null) {
            quiz.setQuestions(getQuestionsByQuiz(quizId));
            return quiz;
        }

        return mockQuizzes.stream().filter(q -> q.getQuizId() == quizId).findFirst().orElse(mockQuizzes.get(0));
    }

    public List<Question> getQuestionsByQuiz(int quizId) {
        List<Question> list = new ArrayList<>();
        String sql = "SELECT question_id, quiz_id, question_text, option_a, option_b, option_c, option_d, correct_option " +
                     "FROM Questions WHERE quiz_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, quizId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new Question(
                            rs.getInt("question_id"),
                            rs.getInt("quiz_id"),
                            rs.getString("question_text"),
                            rs.getString("option_a"),
                            rs.getString("option_b"),
                            rs.getString("option_c"),
                            rs.getString("option_d"),
                            rs.getString("correct_option")
                    ));
                }
            }
            return list;
        } catch (Exception e) {
            Quiz found = mockQuizzes.stream().filter(q -> q.getQuizId() == quizId).findFirst().orElse(mockQuizzes.get(0));
            return found.getQuestions();
        }
    }

    public boolean saveSubmission(QuizSubmission submission) {
        String sql = "INSERT INTO QuizSubmissions (quiz_id, student_id, score, submission_date) VALUES (?, ?, ?, NOW())";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, submission.getQuizId());
            ps.setInt(2, submission.getStudentId());
            ps.setDouble(3, submission.getScore());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            submission.setSubmissionId(mockSubmissions.size() + 1);
            submission.setQuizTitle("SQL Basics Quiz");
            submission.setSubmissionDate(new Timestamp(System.currentTimeMillis()));
            mockSubmissions.add(submission);
            return true;
        }
    }

    public List<QuizSubmission> getStudentSubmissions(int studentId) {
        List<QuizSubmission> list = new ArrayList<>();
        String sql = "SELECT S.submission_id, S.quiz_id, Q.title AS quiz_title, S.student_id, S.score, S.submission_date " +
                     "FROM QuizSubmissions S JOIN Quizzes Q ON S.quiz_id = Q.quiz_id " +
                     "WHERE S.student_id = ? ORDER BY S.submission_date DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    QuizSubmission sub = new QuizSubmission(
                            rs.getInt("submission_id"),
                            rs.getInt("quiz_id"),
                            rs.getInt("student_id"),
                            rs.getDouble("score"),
                            rs.getTimestamp("submission_date")
                    );
                    sub.setQuizTitle(rs.getString("quiz_title"));
                    list.add(sub);
                }
            }
            return list;
        } catch (Exception e) {
            return new ArrayList<>(mockSubmissions);
        }
    }

    private Quiz mapRowToQuiz(ResultSet rs) throws SQLException {
        return new Quiz(
                rs.getInt("quiz_id"),
                rs.getInt("course_id"),
                rs.getString("title"),
                rs.getString("description"),
                rs.getTimestamp("date")
        );
    }
}
