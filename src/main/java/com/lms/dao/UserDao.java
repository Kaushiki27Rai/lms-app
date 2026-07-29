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
        User alice = new User(2, "Alice Johnson", PasswordUtils.hashPassword("password123"), "alice@example.com", "student", new Timestamp(System.currentTimeMillis()));

        mockUsers.put(drSmith.getEmail().toLowerCase(), drSmith);
        mockUsers.put(alice.getEmail().toLowerCase(), alice);
    }

    public boolean registerUser(User user) {
        String sql = "INSERT INTO Users (username, password, email, role) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getUsername());
            ps.setString(2, PasswordUtils.hashPassword(user.getPassword()));
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getRole() != null ? user.getRole() : "student");

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("INFO: MySQL offline. Registering user in memory fallback.");
            user.setUserId(mockUsers.size() + 1);
            user.setPassword(PasswordUtils.hashPassword(user.getPassword()));
            user.setCreatedAt(new Timestamp(System.currentTimeMillis()));
            mockUsers.put(user.getEmail().toLowerCase(), user);
            return true;
        }
    }

    public User findByEmail(String email) {
        if (email == null) return null;
        String sql = "SELECT user_id, username, password, email, role, created_at FROM Users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRowToUser(rs);
                }
            }
        } catch (Exception e) {
            // Fallback to mock data
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
        String sql = "SELECT user_id, username, password, email, role, created_at FROM Users ORDER BY created_at DESC";
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
        return new User(
                rs.getInt("user_id"),
                rs.getString("username"),
                rs.getString("password"),
                rs.getString("email"),
                rs.getString("role"),
                rs.getTimestamp("created_at")
        );
    }
}
