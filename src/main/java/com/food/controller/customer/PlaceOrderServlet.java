package com.food.controller.customer;

import java.io.IOException;

import com.food.dao.OrderDAO;
import com.food.dao.OrderItemDAO;
import com.food.daoimpl.OrderDAOImpl;
import com.food.daoimpl.OrderItemDAOImpl;
import com.food.model.Cart;
import com.food.model.CartItem;
import com.food.model.Order;
import com.food.model.OrderItem;
import com.food.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/place-order")
public class PlaceOrderServlet extends HttpServlet {

    private OrderDAO orderDAO;
    private OrderItemDAO orderItemDAO;

    @Override
    public void init() {

        orderDAO = new OrderDAOImpl();
        orderItemDAO = new OrderItemDAOImpl();
    }

    @Override
    protected void doPost(HttpServletRequest req,
                          HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();

        User user =
                (User) session.getAttribute("loggedInUser");

        Cart cart =
                (Cart) session.getAttribute("cart");

        if (user == null || cart == null || cart.isEmpty()) {

            resp.sendRedirect(
                    req.getContextPath() + "/cart"
            );

            return;
        }

        String address =
                req.getParameter("address");

        String paymentMethod =
                req.getParameter("paymentMethod");


        // Use Grand Total
        double grandTotal =
                cart.getGrandTotal();


        Order order = new Order(

                user.getUserId(),
                grandTotal,
                "PLACED",
                paymentMethod,
                address
        );


        java.util.List<OrderItem> items = new java.util.ArrayList<>();
        for (CartItem item : cart.getItems()) {
            OrderItem orderItem =
                    new OrderItem(
                            0,
                            item.getMenuId(),
                            item.getQuantity(),
                            item.getPrice()
                    );
            items.add(orderItem);
        }

        int orderId = orderDAO.placeOrder(order, items);

        if (orderId > 0) {
            // Clear cart after successful order
            cart.clearCart();
            resp.sendRedirect(
                    req.getContextPath() + "/order-status?orderId=" + orderId
            );
        } else {
            resp.sendRedirect(
                    req.getContextPath() + "/cart?error=order_failed"
            );
        }
    }
}