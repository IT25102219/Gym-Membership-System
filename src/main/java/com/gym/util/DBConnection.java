package com.gym.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public class DBConnection {

    private static final String DEFAULT_DB_URL =
        "jdbc:mysql://localhost:3306/gym_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";

    private static final String DEFAULT_DB_USER = "root";

    private static final String DEFAULT_DB_PASS = "root";

    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";

    private static final Map<String, String> ENV_CACHE = new ConcurrentHashMap<>();

    private static volatile boolean ENV_LOADED = false;

    public static Connection getConnection() {
        try {
            Class.forName(DRIVER);

            String dbUrl = getConfigValue("DB_URL", DEFAULT_DB_URL);
            String dbUser = getConfigValue("DB_USERNAME", DEFAULT_DB_USER);
            String dbPass = getConfigValue("DB_PASSWORD", DEFAULT_DB_PASS);
            Connection connection = DriverManager.getConnection(dbUrl, dbUser, dbPass);

            return connection;

        } catch (ClassNotFoundException e) {
            throw new RuntimeException(
                "MySQL JDBC Driver not found. Check pom.xml for mysql-connector-j dependency. Error: "
                + e.getMessage(), e
            );

        } catch (SQLException e) {
            throw new RuntimeException(
                "Cannot connect to MySQL database. Possible causes: " +
                "1) MySQL not running, 2) Wrong password, " +
                "3) gym_db not created (run database_setup.sql). Error: "
                + e.getMessage(), e
            );
        }
    }

    private static String getConfigValue(String key, String fallback) {
        String envValue = System.getenv(key);
        if (envValue != null && !envValue.trim().isEmpty()) {
            return envValue.trim();
        }
        loadDotEnvIfNeeded();
        String dotEnvValue = ENV_CACHE.get(key);
        if (dotEnvValue != null && !dotEnvValue.trim().isEmpty()) {
            return dotEnvValue.trim();
        }
        return fallback;
    }

    private static synchronized void loadDotEnvIfNeeded() {
        if (ENV_LOADED) {
            return;
        }
        try {
            Path envPath = Path.of(".env");
            if (Files.exists(envPath)) {
                List<String> lines = Files.readAllLines(envPath);
                for (String line : lines) {
                    String trimmed = line.trim();
                    if (trimmed.isEmpty() || trimmed.startsWith("#")) {
                        continue;
                    }
                    int idx = trimmed.indexOf('=');
                    if (idx > 0) {
                        String key = trimmed.substring(0, idx).trim();
                        String value = trimmed.substring(idx + 1).trim();
                        ENV_CACHE.put(key, value);
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("Warning: Could not read .env file. Using defaults/environment only. " + e.getMessage());
        } finally {
            ENV_LOADED = true;
        }
    }

    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close(); 
            } catch (SQLException e) {
                System.err.println("Warning: Could not close database connection. " + e.getMessage());
            }
        }
    }
}
