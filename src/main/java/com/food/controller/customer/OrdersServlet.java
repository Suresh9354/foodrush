package com.food.controller.customer;

import java.io.IOException;
import java.util.List;

import com.food.dao.OrderDAO;
import com.food.daoimpl.OrderDAOImpl;
import com.food.model.Order;
import com.food.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/orders")
public class OrdersServlet extends HttpServlet {

    private OrderDAO orderDAO;

    @Override
    public void init() {
        orderDAO = new OrderDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();

        User user =
                (User) session.getAttribute("loggedInUser");

        List<Order> orders =
                orderDAO.getOrdersByUserId(user.getUserId());

        req.setAttribute("orders", orders);

        req.getRequestDispatcher("/customer/orders.jsp")
           .forward(req, resp);
    }
}