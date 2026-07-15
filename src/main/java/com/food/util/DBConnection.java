package com.food.util;

import java.sql.Connection;
import java.sql.SQLException;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

public class DBConnection {

    // Local database configuration
    private static final String LOCAL_URL =
            "jdbc:mysql://localhost:3306/foodrush_db";

    private static final String LOCAL_USER = "root";
    private static final String LOCAL_PASSWORD = "root";

    // One connection pool for the entire application
    private static final HikariDataSource dataSource;

    static {

        HikariConfig config = new HikariConfig();

        // Check cloud environment variables
        String url = System.getenv("DB_URL");
        String user = System.getenv("DB_USER");
        String password = System.getenv("DB_PASSWORD");

        // If cloud variables are not available, use local MySQL
        if (url == null || url.isBlank()) {

            url = LOCAL_URL;
            user = LOCAL_USER;
            password = LOCAL_PASSWORD;

            System.out.println("Database mode: LOCAL MySQL");

        } else {

            System.out.println("Database mode: CLOUD MySQL (Aiven)");
        }

        // Database configuration
        config.setJdbcUrl(url);
        config.setUsername(user);
        config.setPassword(password);
        config.setDriverClassName("com.mysql.cj.jdbc.Driver");

        // Connection pool configuration
        config.setMaximumPoolSize(10);
        config.setMinimumIdle(2);

        config.setConnectionTimeout(30000);
        config.setIdleTimeout(600000);
        config.setMaxLifetime(1800000);

        config.setPoolName("FoodRushHikariPool");

        // Create connection pool only once
        dataSource = new HikariDataSource(config);

        System.out.println(
                "HikariCP connection pool initialized successfully!"
        );
    }


    private DBConnection() {
        // Prevent object creation
    }


    public static Connection getConnection() {

        try {

            return dataSource.getConnection();

        } catch (SQLException e) {

            throw new RuntimeException(
                    "Failed to get database connection from HikariCP pool.",
                    e
            );
        }
    }
}