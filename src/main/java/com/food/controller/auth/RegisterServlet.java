package com.food.controller.auth;

import java.io.IOException;

import com.food.dao.UserDAO;
import com.food.daoimpl.UserDAOImpl;
import com.food.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAOImpl();
    }

    @Override
    protected void doPost(HttpServletRequest req,
                          HttpServletResponse resp)
            throws ServletException, IOException {

        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");

        User existingUser = userDAO.getUserByEmail(email);

        if (existingUser != null) {

            req.setAttribute("error",
                    "Email already exists!");

            req.getRequestDispatcher("auth/register.jsp")
               .forward(req, resp);

            return;
        }

        User user = new User(
                name,
                email,
                password,
                phone,
                address
        );

        boolean status = userDAO.addUser(user);

        if (status) {

            resp.sendRedirect("auth/login.jsp");

        } else {

            req.setAttribute("error",
                    "Registration failed!");

            req.getRequestDispatcher("auth/register.jsp")
               .forward(req, resp);
        }
    }
}