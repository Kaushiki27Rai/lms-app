package com.lms.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class PasswordUtils {

    public static String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(password.getBytes());
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 algorithm not available", e);
        }
    }

    public static boolean verifyPassword(String rawPassword, String hashedPassword) {
        if (hashedPassword == null || rawPassword == null) {
            return false;
        }
        // Direct comparison for plain text legacy passwords in demo schema
        if (rawPassword.equals(hashedPassword)) {
            return true;
        }
        // Hashed comparison
        return hashPassword(rawPassword).equalsIgnoreCase(hashedPassword);
    }
}
