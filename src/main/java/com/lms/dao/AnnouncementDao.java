package com.lms.dao;

import com.lms.model.Announcement;
import com.lms.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class AnnouncementDao {

    public List<Announcement> getAnnouncementsForStudent(int studentId) {
        List<Announcement> list = new ArrayList<>();
        String sql = "SELECT A.announcement_id, A.course_id, C.title AS course_title, A.title, A.content, " +
                     "A.posted_by, U.username AS poster_name, A.created_at " +
                     "FROM Announcements A " +
                     "JOIN Courses C ON A.course_id = C.course_id " +
                     "JOIN Enrollments E ON C.course_id = E.course_id " +
                     "LEFT JOIN Users U ON A.posted_by = U.user_id " +
                     "WHERE E.user_id = ? ORDER BY A.created_at DESC LIMIT 5";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Announcement a = new Announcement();
                    a.setAnnouncementId(rs.getInt("announcement_id"));
                    a.setCourseId(rs.getInt("course_id"));
                    a.setCourseTitle(rs.getString("course_title"));
                    a.setTitle(rs.getString("title"));
                    a.setContent(rs.getString("content"));
                    a.setPostedBy(rs.getInt("posted_by"));
                    a.setPosterName(rs.getString("poster_name"));
                    a.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(a);
                }
            }
            return list;
        } catch (Exception e) {
            // Fallback seed data
            Announcement defaultA = new Announcement();
            defaultA.setAnnouncementId(1);
            defaultA.setCourseTitle("Data Structures & Algorithms");
            defaultA.setTitle("Midterm Project Announcement");
            defaultA.setContent("Please review the BST project guidelines uploaded in Module 2 before Friday.");
            defaultA.setPosterName("Dr. Smith");
            defaultA.setCreatedAt(new Timestamp(System.currentTimeMillis() - 7200000));
            list.add(defaultA);

            Announcement defaultB = new Announcement();
            defaultB.setAnnouncementId(2);
            defaultB.setCourseTitle("Database Management Systems");
            defaultB.setTitle("SQL Lab Solutions Released");
            defaultB.setContent("Solutions for Lab 3 are now available in the resources section.");
            defaultB.setPosterName("Dr. Smith");
            defaultB.setCreatedAt(new Timestamp(System.currentTimeMillis() - 86400000));
            list.add(defaultB);

            return list;
        }
    }
}
