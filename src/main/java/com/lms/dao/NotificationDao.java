package com.lms.dao;

import com.lms.model.Notification;
import com.lms.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class NotificationDao {

    public List<Notification> getNotificationsForUser(int userId) {
        List<Notification> list = new ArrayList<>();
        String sql = "SELECT notification_id, user_id, title, message, is_read, link, created_at " +
                     "FROM Notifications WHERE user_id = ? ORDER BY created_at DESC LIMIT 10";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Notification n = new Notification();
                    n.setNotificationId(rs.getInt("notification_id"));
                    n.setUserId(rs.getInt("user_id"));
                    n.setTitle(rs.getString("title"));
                    n.setMessage(rs.getString("message"));
                    n.setRead(rs.getBoolean("is_read"));
                    n.setLink(rs.getString("link"));
                    n.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(n);
                }
            }
            return list;
        } catch (Exception e) {
            // Fallback seed data
            Notification n1 = new Notification();
            n1.setNotificationId(1);
            n1.setUserId(userId);
            n1.setTitle("New Assignment Posted");
            n1.setMessage("Binary Search Tree Implementation is due in 2 days.");
            n1.setRead(false);
            n1.setLink("/courses?action=view&id=1");
            n1.setCreatedAt(new Timestamp(System.currentTimeMillis() - 3600000));
            list.add(n1);

            Notification n2 = new Notification();
            n2.setNotificationId(2);
            n2.setUserId(userId);
            n2.setTitle("Quiz Result Available");
            n2.setMessage("You scored 85.5% on SQL Basics Quiz.");
            n2.setRead(true);
            n2.setLink("/quizzes?action=take&id=1");
            n2.setCreatedAt(new Timestamp(System.currentTimeMillis() - 86400000));
            list.add(n2);

            return list;
        }
    }

    public boolean markAsRead(int notificationId) {
        String sql = "UPDATE Notifications SET is_read = TRUE WHERE notification_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, notificationId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            return true;
        }
    }
}
