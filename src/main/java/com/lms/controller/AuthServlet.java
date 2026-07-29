package com.lms.controller;

import com.lms.model.User;
import com.lms.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet({"/auth", "/login", "/signup", "/logout"})
public class AuthServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private UserService userService;

    @Override
    public void init() throws ServletException {
        this.userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();
        String action = request.getParameter("action");

        if ("/logout".equalsIgnoreCase(path) || "logout".equalsIgnoreCase(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            response.sendRedirect(request.getContextPath() + "/auth?msg=logged_out");
            return;
        }

        if ("/signup".equalsIgnoreCase(path) || "signup".equalsIgnoreCase(action)) {
            request.getRequestDispatcher("/signup.jsp").forward(request, response);
            return;
        }

        // Default Login View
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getServletPath();
        String action = request.getParameter("action");

        if ("/signup".equalsIgnoreCase(path) || "signup".equalsIgnoreCase(action) || "register".equalsIgnoreCase(action)) {
            handleRegister(request, response);
        } else {
            handleLogin(request, response);
        }
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User newUser = new User();
        newUser.setUsername(request.getParameter("username"));
        newUser.setEmail(request.getParameter("email"));
        newUser.setPassword(request.getParameter("password"));
        
        String role = request.getParameter("role");
        if (role == null || role.trim().isEmpty()) role = "student";
        newUser.setRole(role.toLowerCase());

        if ("instructor".equalsIgnoreCase(role)) {
            newUser.setEmployeeId(request.getParameter("employeeId"));
            newUser.setDepartment(request.getParameter("department"));
            newUser.setDesignation(request.getParameter("designation"));
            newUser.setExpertise(request.getParameter("expertise"));
        } else {
            newUser.setStudentId(request.getParameter("studentId"));
            newUser.setDepartment(request.getParameter("department"));
            newUser.setSemester(request.getParameter("semester"));
            newUser.setYear(request.getParameter("year"));
        }

        String result = userService.registerUserFull(newUser);

        if ("SUCCESS".equals(result)) {
            request.setAttribute("successMessage", "Account created successfully! Please log in below.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMessage", result);
            request.setAttribute("user", newUser);
            request.getRequestDispatcher("/signup.jsp").forward(request, response);
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        User user = userService.login(email, password);

        if (user != null) {
            HttpSession session = request.getSession(true);
            session.setAttribute("user", user);
            session.setAttribute("userRole", user.getRole());

            response.sendRedirect(request.getContextPath() + "/dashboard");
        } else {
            request.setAttribute("errorMessage", "Invalid email address or password.");
            request.setAttribute("prevEmail", email);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}
