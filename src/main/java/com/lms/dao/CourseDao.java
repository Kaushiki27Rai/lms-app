package com.lms.dao;

import com.lms.model.Course;
import com.lms.util.DBConnection;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArrayList;

public class CourseDao {

    private static final List<Course> mockCourses = new CopyOnWriteArrayList<>();
    private static final ConcurrentHashMap<String, Boolean> mockEnrollments = new ConcurrentHashMap<>();

    static {
        Course sqlCourse = new Course(1, "Data Structures & Algorithms", "Master trees, graphs, dynamic programming, and complexity analysis.", 1, new Date(System.currentTimeMillis()), new Date(System.currentTimeMillis() + 30L * 24 * 3600 * 1000), new Timestamp(System.currentTimeMillis()));
        sqlCourse.setInstructorName("Dr. Smith");
        sqlCourse.setCategory("Computer Science");
        sqlCourse.setBannerUrl("https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=800");

        Course javaCourse = new Course(2, "Database Management Systems", "Relational database design, SQL queries, indexing, and transaction management.", 1, new Date(System.currentTimeMillis()), new Date(System.currentTimeMillis() + 60L * 24 * 3600 * 1000), new Timestamp(System.currentTimeMillis()));
        javaCourse.setInstructorName("Dr. Smith");
        javaCourse.setCategory("Computer Science");
        javaCourse.setBannerUrl("https://images.unsplash.com/photo-1544383835-bda2bc66a55d?w=800");

        mockCourses.add(sqlCourse);
        mockCourses.add(javaCourse);

        // Seed student enrollment for Alice
        mockEnrollments.put("2_1", true);
        mockEnrollments.put("2_2", true);
    }

    public List<Course> getAllCourses() {
        List<Course> list = new ArrayList<>();
        String sql = "SELECT C.course_id, C.title, C.description, C.category, C.banner_url, C.instructor_id, U.username AS instructor_name, " +
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
            return list;
        } catch (Exception e) {
            return new ArrayList<>(mockCourses);
        }
    }

    public Course getCourseById(int courseId) {
        String sql = "SELECT C.course_id, C.title, C.description, C.category, C.banner_url, C.instructor_id, U.username AS instructor_name, " +
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
        } catch (Exception e) {
            // Fallback
        }
        return mockCourses.stream().filter(c -> c.getCourseId() == courseId).findFirst().orElse(mockCourses.get(0));
    }

    public List<Course> getEnrolledCoursesForStudent(int userId) {
        List<Course> list = new ArrayList<>();
        String sql = "SELECT C.course_id, C.title, C.description, C.category, C.banner_url, C.instructor_id, U.username AS instructor_name, " +
                     "C.start_date, C.end_date, C.created_at " +
                     "FROM Courses C JOIN Enrollments E ON C.course_id = E.course_id " +
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
            return list;
        } catch (Exception e) {
            List<Course> enrolled = new ArrayList<>();
            for (Course c : mockCourses) {
                if (isStudentEnrolled(userId, c.getCourseId())) {
                    enrolled.add(c);
                }
            }
            return enrolled;
        }
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
        } catch (Exception e) {
            return mockEnrollments.containsKey(userId + "_" + courseId);
        }
        return mockEnrollments.containsKey(userId + "_" + courseId);
    }

    public boolean enrollStudent(int userId, int courseId) {
        if (isStudentEnrolled(userId, courseId)) {
            return true;
        }
        String sql = "INSERT INTO Enrollments (user_id, course_id) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, courseId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            mockEnrollments.put(userId + "_" + courseId, true);
            return true;
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
        } catch (Exception e) {
            course.setCourseId(mockCourses.size() + 1);
            course.setInstructorName("Dr. Smith");
            mockCourses.add(course);
            return true;
        }
    }

    private Course mapRowToCourse(ResultSet rs) throws SQLException {
        Course c = new Course(
                rs.getInt("course_id"),
                rs.getString("title"),
                rs.getString("description"),
                rs.getInt("instructor_id"),
                rs.getDate("start_date"),
                rs.getDate("end_date"),
                rs.getTimestamp("created_at")
        );
        try {
            c.setCategory(rs.getString("category"));
            c.setBannerUrl(rs.getString("banner_url"));
        } catch (Exception ignored) {}
        return c;
    }
}
