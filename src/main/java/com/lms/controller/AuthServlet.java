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

@WebServlet("/auth")
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

        String action = request.getParameter("action");
        if (action == null) {
            action = "login";
        }

        switch (action) {
            case "logout":
                HttpSession session = request.getSession(false);
                if (session != null) {
                    session.invalidate();
                }
                response.sendRedirect(request.getContextPath() + "/auth?action=login&msg=logged_out");
                break;
            case "register":
                request.getRequestDispatcher("/registration.jsp").forward(request, response);
                break;
            case "login":
            default:
                request.getRequestDispatcher("/registration.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = "login";
        }

        if ("register".equalsIgnoreCase(action)) {
            handleRegister(request, response);
        } else if ("login".equalsIgnoreCase(action)) {
            handleLogin(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/auth?action=login");
        }
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        String result = userService.register(username, email, password, role);

        if ("SUCCESS".equals(result)) {
            request.setAttribute("successMessage", "Account created successfully! Please log in.");
            request.getRequestDispatcher("/registration.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMessage", result);
            request.setAttribute("prevUsername", username);
            request.setAttribute("prevEmail", email);
            request.getRequestDispatcher("/registration.jsp").forward(request, response);
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

            // Redirect based on user role
            if ("instructor".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/dashboard?role=instructor");
            } else if ("admin".equalsIgnoreCase(user.getRole())) {
                response.sendRedirect(request.getContextPath() + "/dashboard?role=admin");
            } else {
                response.sendRedirect(request.getContextPath() + "/dashboard?role=student");
            }
        } else {
            request.setAttribute("errorMessage", "Invalid email or password.");
            request.setAttribute("prevEmail", email);
            request.getRequestDispatcher("/registration.jsp").forward(request, response);
        }
    }
}
