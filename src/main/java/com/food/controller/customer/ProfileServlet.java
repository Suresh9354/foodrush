package com.food.controller.customer;

import java.io.IOException;

import com.food.dao.UserDAO;
import com.food.daoimpl.UserDAOImpl;
import com.food.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("loggedInUser");
        req.setAttribute("user", user);

        req.getRequestDispatcher("/customer/profile.jsp")
           .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req,
                          HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User loggedInUser = (User) session.getAttribute("loggedInUser");

        if (loggedInUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String name = req.getParameter("name");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");

        // Update fields
        loggedInUser.setName(name);
        loggedInUser.setPhone(phone);
        loggedInUser.setAddress(address);

        boolean success = userDAO.updateUser(loggedInUser);

        if (success) {
            session.setAttribute("loggedInUser", loggedInUser);
            req.setAttribute("successMessage", "Profile updated successfully!");
        } else {
            req.setAttribute("errorMessage", "Failed to update profile. Please try again.");
        }

        req.setAttribute("user", loggedInUser);
        req.getRequestDispatcher("/customer/profile.jsp")
           .forward(req, resp);
    }
}