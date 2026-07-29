package com.lms.dao;

import com.lms.model.Course;
import com.lms.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CourseDao {

    public List<Course> getAllCourses() {
        List<Course> list = new ArrayList<>();
        String sql = "SELECT C.course_id, C.title, C.description, C.instructor_id, U.username AS instructor_name, " +
                     "C.start_date, C.end_date, C.created_at " +
                     "FROM Courses C LEFT JOIN Users U ON C.instructor_id = U.user_id " +
                     "ORDER BY C.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Course course = mapRowToCourse(rs);
                course.setInstructorName(rs.getString("instructor_name"));
                list.add(course);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching all courses: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    public Course getCourseById(int courseId) {
        String sql = "SELECT C.course_id, C.title, C.description, C.instructor_id, U.username AS instructor_name, " +
                     "C.start_date, C.end_date, C.created_at " +
                     "FROM Courses C LEFT JOIN Users U ON C.instructor_id = U.user_id " +
                     "WHERE C.course_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, courseId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Course course = mapRowToCourse(rs);
                    course.setInstructorName(rs.getString("instructor_name"));
                    return course;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error fetching course by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public List<Course> getEnrolledCoursesForStudent(int userId) {
        List<Course> list = new ArrayList<>();
        String sql = "SELECT C.course_id, C.title, C.description, C.instructor_id, U.username AS instructor_name, " +
                     "C.start_date, C.end_date, C.created_at " +
                     "FROM Courses C " +
                     "JOIN Enrollments E ON C.course_id = E.course_id " +
                     "LEFT JOIN Users U ON C.instructor_id = U.user_id " +
                     "WHERE E.user_id = ? ORDER BY E.enrollment_date DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Course course = mapRowToCourse(rs);
                    course.setInstructorName(rs.getString("instructor_name"));
                    list.add(course);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error fetching enrolled courses: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    public boolean isStudentEnrolled(int userId, int courseId) {
        String sql = "SELECT COUNT(*) FROM Enrollments WHERE user_id = ? AND course_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, courseId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error checking enrollment status: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean enrollStudent(int userId, int courseId) {
        if (isStudentEnrolled(userId, courseId)) {
            return true; // Already enrolled
        }
        String sql = "INSERT INTO Enrollments (user_id, course_id) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, courseId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error enrolling student in course: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean createCourse(Course course) {
        String sql = "INSERT INTO Courses (title, description, instructor_id, start_date, end_date) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, course.getTitle());
            ps.setString(2, course.getDescription());
            ps.setInt(3, course.getInstructorId());
            ps.setDate(4, course.getStartDate());
            ps.setDate(5, course.getEndDate());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error creating course: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    private Course mapRowToCourse(ResultSet rs) throws SQLException {
        return new Course(
                rs.getInt("course_id"),
                rs.getString("title"),
                rs.getString("description"),
                rs.getInt("instructor_id"),
                rs.getDate("start_date"),
                rs.getDate("end_date"),
                rs.getTimestamp("created_at")
        );
    }
}
