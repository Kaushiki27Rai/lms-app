package com.lms.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL = setting("DB_URL", "jdbc:mysql://localhost:3306/ManagementSystems?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&connectTimeout=2000");
    private static final String USER = setting("DB_USERNAME", "root");
    private static final String PASSWORD = setting("DB_PASSWORD", "");

    private static boolean driverLoaded = false;

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            driverLoaded = true;
        } catch (ClassNotFoundException e) {
            System.out.println("INFO: MySQL JDBC Driver not found in classpath. Fallback mode enabled.");
        }
    }

    public static Connection getConnection() throws SQLException {
        if (!driverLoaded) {
            throw new SQLException("MySQL driver not loaded.");
        }
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    private static String setting(String name, String defaultValue) {
        String value = System.getenv(name);
        return value == null || value.trim().isEmpty() ? defaultValue : value.trim();
    }
}
