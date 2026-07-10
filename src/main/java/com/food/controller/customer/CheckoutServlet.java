package com.food.controller.customer;

import java.io.IOException;

import com.food.model.Cart;
import com.food.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null) {

            resp.sendRedirect(
                    req.getContextPath() + "/auth/login.jsp"
            );

            return;
        }

        User user =
                (User) session.getAttribute("loggedInUser");

        Cart cart =
                (Cart) session.getAttribute("cart");

        if (user == null) {

            resp.sendRedirect(
                    req.getContextPath() + "/auth/login.jsp"
            );

            return;
        }

        if (cart == null || cart.isEmpty()) {

            resp.sendRedirect(
                    req.getContextPath() + "/cart"
            );

            return;
        }

        double itemTotal = cart.getTotalAmount();

        double deliveryFee =
                itemTotal >= 299 ? 0 : 40;

        double platformFee = 10;

        double gst = itemTotal * 0.05;

        double grandTotal =
                itemTotal
                + deliveryFee
                + platformFee
                + gst;

        req.setAttribute("itemTotal", itemTotal);
        req.setAttribute("deliveryFee", deliveryFee);
        req.setAttribute("platformFee", platformFee);
        req.setAttribute("gst", gst);
        req.setAttribute("grandTotal", grandTotal);

        req.getRequestDispatcher(
                "/customer/checkout.jsp"
        ).forward(req, resp);
    }
}