package com.internsphere.util;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {
    private static final String URL;
    private static final String USER;
    private static final String PASSWORD;

    static {
        String envUrl = System.getenv("MYSQL_PUBLIC_URL");
        if (envUrl != null && envUrl.startsWith("mysql://")) {
            envUrl = envUrl.replace("mysql://", "");
            String[] parts = envUrl.split("@");
            String[] userPass = parts[0].split(":");
            String hostDb = parts[1];
            USER = userPass[0];
            PASSWORD = userPass[1];
            URL = "jdbc:mysql://" + hostDb + "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
        } else {
            URL = "jdbc:mysql://localhost:3306/internsphere?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
            USER = "root";
            PASSWORD = "shabnampatil";
        }
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL JDBC Driver not found", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    public static void close(AutoCloseable... resources) {
        for (AutoCloseable r : resources) {
            if (r != null) {
                try { r.close(); } catch (Exception ignored) {}
            }
        }
    }
}