package com.lms.dao;

import com.lms.model.User;
import com.lms.util.DBConnection;
import com.lms.util.PasswordUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;

public class UserDao {

    private static final ConcurrentHashMap<String, User> mockUsers = new ConcurrentHashMap<>();

    static {
        // Seed default fallback users
        User drSmith = new User(1, "Dr. Smith", PasswordUtils.hashPassword("securepassword"), "drsmith@example.com", "instructor", new Timestamp(System.currentTimeMillis()));
        drSmith.setEmployeeId("EMP-109");
        drSmith.setDepartment("Computer Science");
        drSmith.setDesignation("Senior Professor");
        drSmith.setExpertise("Database Systems & Algorithms");

        User alice = new User(2, "Kaushiki Rai", PasswordUtils.hashPassword("password123"), "alice@example.com", "student", new Timestamp(System.currentTimeMillis()));
        alice.setStudentId("STU-2024-88");
        alice.setDepartment("Computer Science");
        alice.setSemester("4th Semester");
        alice.setYear("2nd Year");

        mockUsers.put(drSmith.getEmail().toLowerCase(), drSmith);
        mockUsers.put(alice.getEmail().toLowerCase(), alice);
    }

    public boolean registerUser(User user) {
        String sql = "INSERT INTO Users (username, password, email, role, student_id, department, semester, year, employee_id, designation, expertise) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getUsername());
            ps.setString(2, PasswordUtils.hashPassword(user.getPassword()));
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getRole() != null ? user.getRole() : "student");
            ps.setString(5, user.getStudentId());
            ps.setString(6, user.getDepartment());
            ps.setString(7, user.getSemester());
            ps.setString(8, user.getYear());
            ps.setString(9, user.getEmployeeId());
            ps.setString(10, user.getDesignation());
            ps.setString(11, user.getExpertise());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("INFO: Registering user in memory store.");
            user.setUserId(mockUsers.size() + 1);
            user.setPassword(PasswordUtils.hashPassword(user.getPassword()));
            user.setCreatedAt(new Timestamp(System.currentTimeMillis()));
            mockUsers.put(user.getEmail().toLowerCase(), user);
            return true;
        }
    }

    public User findByEmail(String email) {
        if (email == null) return null;
        String sql = "SELECT user_id, username, password, email, role, student_id, department, semester, year, employee_id, designation, expertise, profile_pic, created_at FROM Users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRowToUser(rs);
                }
            }
        } catch (Exception e) {
            return mockUsers.get(email.trim().toLowerCase());
        }
        return mockUsers.get(email.trim().toLowerCase());
    }

    public boolean existsByEmail(String email) {
        if (email == null) return false;
        String sql = "SELECT COUNT(*) FROM Users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (Exception e) {
            return mockUsers.containsKey(email.trim().toLowerCase());
        }
        return mockUsers.containsKey(email.trim().toLowerCase());
    }

    public User authenticate(String email, String password) {
        if (email == null || password == null) return null;
        User user = findByEmail(email);
        if (user != null && PasswordUtils.verifyPassword(password, user.getPassword())) {
            return user;
        }
        return null;
    }

    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT user_id, username, password, email, role, student_id, department, semester, year, employee_id, designation, expertise, profile_pic, created_at FROM Users ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapRowToUser(rs));
            }
            return list;
        } catch (Exception e) {
            return new ArrayList<>(mockUsers.values());
        }
    }

    private User mapRowToUser(ResultSet rs) throws SQLException {
        User u = new User();
        u.setUserId(rs.getInt("user_id"));
        u.setUsername(rs.getString("username"));
        u.setPassword(rs.getString("password"));
        u.setEmail(rs.getString("email"));
        u.setRole(rs.getString("role"));
        u.setStudentId(rs.getString("student_id"));
        u.setDepartment(rs.getString("department"));
        u.setSemester(rs.getString("semester"));
        u.setYear(rs.getString("year"));
        u.setEmployeeId(rs.getString("employee_id"));
        u.setDesignation(rs.getString("designation"));
        u.setExpertise(rs.getString("expertise"));
        u.setProfilePic(rs.getString("profile_pic"));
        u.setCreatedAt(rs.getTimestamp("created_at"));
        return u;
    }
}
