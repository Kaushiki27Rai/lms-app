package com.lms.dao;

import com.lms.model.Question;
import com.lms.model.Quiz;
import com.lms.model.QuizSubmission;
import com.lms.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class QuizDao {

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
        } catch (SQLException e) {
            System.err.println("Error fetching quizzes for course: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
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
        } catch (SQLException e) {
            System.err.println("Error fetching quiz details: " + e.getMessage());
            e.printStackTrace();
        }

        if (quiz != null) {
            quiz.setQuestions(getQuestionsByQuiz(quizId));
        }
        return quiz;
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
        } catch (SQLException e) {
            System.err.println("Error fetching questions for quiz: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    public boolean saveSubmission(QuizSubmission submission) {
        String sql = "INSERT INTO QuizSubmissions (quiz_id, student_id, score, submission_date) VALUES (?, ?, ?, NOW())";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, submission.getQuizId());
            ps.setInt(2, submission.getStudentId());
            ps.setDouble(3, submission.getScore());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error saving quiz submission: " + e.getMessage());
            e.printStackTrace();
            return false;
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
        } catch (SQLException e) {
            System.err.println("Error fetching student submissions: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
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
