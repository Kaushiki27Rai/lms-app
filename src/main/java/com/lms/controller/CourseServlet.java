package com.lms.controller;

import com.lms.dao.AssignmentDao;
import com.lms.dao.CourseDao;
import com.lms.dao.ModuleDao;
import com.lms.model.Assignment;
import com.lms.model.Course;
import com.lms.model.Lesson;
import com.lms.model.User;
import com.lms.service.CourseService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/courses")
public class CourseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private CourseService courseService;
    private CourseDao courseDao;
    private ModuleDao moduleDao;
    private AssignmentDao assignmentDao;

    @Override
    public void init() throws ServletException {
        this.courseService = new CourseService();
        this.courseDao = new CourseDao();
        this.moduleDao = new ModuleDao();
        this.assignmentDao = new AssignmentDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "view":
                int courseId = Integer.parseInt(request.getParameter("id"));
                Course course = courseService.getCourseDetails(courseId);
                boolean isEnrolled = courseService.isStudentEnrolled(currentUser.getUserId(), courseId);
                List<Lesson> modules = moduleDao.getModulesByCourse(courseId);
                List<Assignment> assignments = assignmentDao.getAssignmentsByCourse(courseId, currentUser.getUserId());

                request.setAttribute("course", course);
                request.setAttribute("isEnrolled", isEnrolled);
                request.setAttribute("modules", modules);
                request.setAttribute("assignments", assignments);
                request.getRequestDispatcher("/course-detail.jsp").forward(request, response);
                break;
            case "my-courses":
                List<Course> enrolled = courseService.getStudentCourses(currentUser.getUserId());
                request.setAttribute("courses", enrolled);
                request.setAttribute("pageTitle", "My Enrolled Courses");
                request.getRequestDispatcher("/courses.jsp").forward(request, response);
                break;
            case "create":
                if (!"instructor".equalsIgnoreCase(currentUser.getRole()) && !"admin".equalsIgnoreCase(currentUser.getRole())) {
                    response.sendRedirect(request.getContextPath() + "/courses");
                    return;
                }
                request.getRequestDispatcher("/create-course.jsp").forward(request, response);
                break;
            case "list":
            default:
                List<Course> allCourses = courseService.getAllCourses();
                request.setAttribute("courses", allCourses);
                request.setAttribute("pageTitle", "Explore All Courses");
                request.getRequestDispatcher("/courses.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        if ("enroll".equalsIgnoreCase(action)) {
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            boolean success = courseService.enrollStudent(currentUser.getUserId(), courseId);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/courses?action=view&id=" + courseId + "&msg=enrolled");
            } else {
                response.sendRedirect(request.getContextPath() + "/courses?action=view&id=" + courseId + "&error=failed");
            }
        } else if ("create".equalsIgnoreCase(action)) {
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");

            String result = courseService.createCourse(title, description, currentUser.getUserId(), startDate, endDate);
            if ("SUCCESS".equals(result)) {
                response.sendRedirect(request.getContextPath() + "/courses?msg=course_created");
            } else {
                request.setAttribute("errorMessage", result);
                request.getRequestDispatcher("/create-course.jsp").forward(request, response);
            }
        }
    }
}
