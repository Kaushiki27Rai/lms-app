package com.lms.util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtils {

    public static String hashPassword(String password) {
        if (password == null || password.isEmpty()) throw new IllegalArgumentException("Password is required");
        return BCrypt.hashpw(password, BCrypt.gensalt(12));
    }

    public static boolean verifyPassword(String rawPassword, String hashedPassword) {
        if (hashedPassword == null || rawPassword == null) {
            return false;
        }
        return hashedPassword.startsWith("$2a$") || hashedPassword.startsWith("$2b$") || hashedPassword.startsWith("$2y$")
                ? BCrypt.checkpw(rawPassword, hashedPassword)
                : rawPassword.equals(hashedPassword); // legacy rows are upgraded after successful sign-in
    }

    public static boolean needsUpgrade(String storedHash) { return storedHash != null && !storedHash.startsWith("$2"); }
}
