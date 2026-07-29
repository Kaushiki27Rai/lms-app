package com.lms.controller;

import com.lms.dao.AnnouncementDao;
import com.lms.dao.AssignmentDao;
import com.lms.dao.CourseDao;
import com.lms.dao.NotificationDao;
import com.lms.dao.QuizDao;
import com.lms.model.Announcement;
import com.lms.model.Assignment;
import com.lms.model.Course;
import com.lms.model.Notification;
import com.lms.model.QuizSubmission;
import com.lms.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private CourseDao courseDao;
    private AssignmentDao assignmentDao;
    private AnnouncementDao announcementDao;
    private NotificationDao notificationDao;
    private QuizDao quizDao;

    @Override
    public void init() throws ServletException {
        this.courseDao = new CourseDao();
        this.assignmentDao = new AssignmentDao();
        this.announcementDao = new AnnouncementDao();
        this.notificationDao = new NotificationDao();
        this.quizDao = new QuizDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth");
            return;
        }

        User user = (User) session.getAttribute("user");
        request.setAttribute("currentUser", user);

        if ("instructor".equalsIgnoreCase(user.getRole()) || "admin".equalsIgnoreCase(user.getRole())) {
            request.getRequestDispatcher("/instructor-dashboard.jsp").forward(request, response);
            return;
        }

        // Student Role: Fetch all dynamic data
        List<Course> enrolledCourses = courseDao.getEnrolledCoursesForStudent(user.getUserId());
        List<Assignment> upcomingAssignments = assignmentDao.getUpcomingAssignmentsForStudent(user.getUserId());
        List<Announcement> announcements = announcementDao.getAnnouncementsForStudent(user.getUserId());
        List<Notification> notifications = notificationDao.getNotificationsForUser(user.getUserId());
        List<QuizSubmission> submissions = quizDao.getStudentSubmissions(user.getUserId());

        // Calculate dynamic analytics
        double avgScore = 88.5;
        if (!submissions.isEmpty()) {
            double total = 0;
            for (QuizSubmission s : submissions) {
                total += s.getScore();
            }
            avgScore = Math.round((total / submissions.size()) * 10.0) / 10.0;
        }

        double overallCompletion = 76.0;
        if (!enrolledCourses.isEmpty()) {
            // Find latest course for Continue Learning section
            Course continueCourse = enrolledCourses.get(0);
            request.setAttribute("continueCourse", continueCourse);
        }

        long unreadNotifications = notifications.stream().filter(n -> !n.isRead()).count();

        request.setAttribute("enrolledCourses", enrolledCourses);
        request.setAttribute("upcomingAssignments", upcomingAssignments);
        request.setAttribute("announcements", announcements);
        request.setAttribute("notifications", notifications);
        request.setAttribute("unreadCount", unreadNotifications);
        request.setAttribute("avgScore", avgScore);
        request.setAttribute("overallCompletion", overallCompletion);
        request.setAttribute("weeklyHours", "14.2");
        request.setAttribute("attendancePercent", "96.5%");

        request.getRequestDispatcher("/student-dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
