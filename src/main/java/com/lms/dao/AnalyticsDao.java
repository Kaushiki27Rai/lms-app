package com.lms.dao;

import com.lms.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.LinkedHashMap;
import java.util.Map;

/** Uses database aggregates so dashboards do not load every activity row into memory. */
public class AnalyticsDao {
    public Map<String, Object> studentMetrics(int studentId) {
        Map<String, Object> metrics = new LinkedHashMap<>();
        String sql = "SELECT " +
                "COALESCE((SELECT AVG(progress_percentage) FROM Enrollments WHERE user_id=?),0) completion, " +
                "COALESCE((SELECT AVG(score) FROM QuizSubmissions WHERE student_id=?),0) quizScore, " +
                "COALESCE((SELECT 100.0*SUM(status IN ('Present','Late'))/NULLIF(COUNT(*),0) FROM Attendance WHERE student_id=?),0) attendance, " +
                "COALESCE((SELECT SUM(duration_mins)/60.0 FROM LearningSessions WHERE user_id=? AND created_at >= DATE_SUB(NOW(),INTERVAL 7 DAY)),0) weeklyHours, " +
                "COALESCE((SELECT 100.0*COUNT(DISTINCT s.assignment_id)/NULLIF(COUNT(DISTINCT a.assignment_id),0) FROM Enrollments e JOIN Assignments a ON a.course_id=e.course_id LEFT JOIN AssignmentSubmissions s ON s.assignment_id=a.assignment_id AND s.student_id=e.user_id WHERE e.user_id=?),0) assignmentRate, " +
                "COALESCE((SELECT COUNT(*) FROM Assignments a JOIN Enrollments e ON e.course_id=a.course_id LEFT JOIN AssignmentSubmissions s ON s.assignment_id=a.assignment_id AND s.student_id=e.user_id WHERE e.user_id=? AND a.due_date<NOW() AND s.submission_id IS NULL),0) missedAssignments";
        try (Connection c = DBConnection.getConnection(); PreparedStatement p = c.prepareStatement(sql)) {
            for (int i=1; i<=6; i++) p.setInt(i, studentId);
            try (ResultSet r=p.executeQuery()) { if (r.next()) {
                metrics.put("courseCompletionPercentage", round(r.getDouble("completion")));
                metrics.put("averageQuizScore", round(r.getDouble("quizScore")));
                metrics.put("attendancePercentage", round(r.getDouble("attendance")));
                metrics.put("weeklyLearningHours", round(r.getDouble("weeklyHours")));
                metrics.put("assignmentSubmissionRate", round(r.getDouble("assignmentRate")));
                metrics.put("missedAssignments", r.getInt("missedAssignments"));
            }}
        } catch (Exception ignored) { }
        defaults(metrics);
        return metrics;
    }
    public boolean instructorOwnsStudent(int instructorId, int studentId) {
        String sql = "SELECT 1 FROM Courses c JOIN Enrollments e ON e.course_id=c.course_id WHERE c.instructor_id=? AND e.user_id=? LIMIT 1";
        try (Connection c=DBConnection.getConnection(); PreparedStatement p=c.prepareStatement(sql)) {
            p.setInt(1,instructorId); p.setInt(2,studentId); try(ResultSet r=p.executeQuery()){ return r.next(); }
        } catch (Exception ignored) { return false; }
    }
    private void defaults(Map<String,Object> m) {
        m.putIfAbsent("courseCompletionPercentage", 0.0); m.putIfAbsent("averageQuizScore", 0.0);
        m.putIfAbsent("attendancePercentage", 0.0); m.putIfAbsent("weeklyLearningHours", 0.0);
        m.putIfAbsent("assignmentSubmissionRate", 0.0); m.putIfAbsent("missedAssignments", 0);
    }
    private double round(double value) { return Math.round(value * 10.0) / 10.0; }
}
