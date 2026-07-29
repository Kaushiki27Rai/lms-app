package com.lms.service;

import com.lms.dao.UserDao;
import com.lms.model.User;

public class UserService {

    private final UserDao userDao;

    public UserService() {
        this.userDao = new UserDao();
    }

    public UserService(UserDao userDao) {
        this.userDao = userDao;
    }

    public String register(String username, String email, String password, String role) {
        if (username == null || username.trim().isEmpty()) {
            return "Username is required.";
        }
        if (email == null || !email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            return "Please enter a valid email address.";
        }
        if (password == null || password.length() < 6) {
            return "Password must be at least 6 characters long.";
        }

        if (userDao.existsByEmail(email.trim())) {
            return "An account with this email already exists.";
        }

        String validRole = (role != null && (role.equalsIgnoreCase("instructor") || role.equalsIgnoreCase("admin")))
                ? role.toLowerCase()
                : "student";

        User newUser = new User(username.trim(), password, email.trim().toLowerCase(), validRole);
        boolean success = userDao.registerUser(newUser);

        return success ? "SUCCESS" : "Registration failed due to a database error.";
    }

    public User login(String email, String password) {
        if (email == null || password == null || email.trim().isEmpty() || password.isEmpty()) {
            return null;
        }
        return userDao.authenticate(email.trim().toLowerCase(), password);
    }
}
