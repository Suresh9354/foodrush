package com.food.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String LOCAL_URL =
            "jdbc:mysql://localhost:3306/foodrush_db";

    private static final String LOCAL_USER = "root";
    private static final String LOCAL_PASSWORD = "root";


    public static Connection getConnection() {

        try {

            Class.forName("com.mysql.cj.jdbc.Driver");

            String url = System.getenv("DB_URL");
            String user = System.getenv("DB_USER");
            String password = System.getenv("DB_PASSWORD");


            if (url == null || url.isBlank()) {

                url = LOCAL_URL;
                user = LOCAL_USER;
                password = LOCAL_PASSWORD;

                System.out.println(
                        "Database mode: LOCAL MySQL"
                );

            } else {

                System.out.println(
                        "Database mode: CLOUD MySQL (Aiven)"
                );
            }


            Connection con = DriverManager.getConnection(
                    url,
                    user,
                    password
            );

            System.out.println(
                    "Database connected successfully!"
            );

            return con;


        } catch (ClassNotFoundException e) {

            throw new RuntimeException(
                    "MySQL JDBC Driver not found.",
                    e
            );

        } catch (SQLException e) {

            throw new RuntimeException(
                    "Database connection failed.",
                    e
            );
        }
    }
}