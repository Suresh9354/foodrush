package com.food.controller.customer;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Calendar;

import com.food.dao.MenuDAO;
import com.food.dao.OrderDAO;
import com.food.dao.OrderItemDAO;
import com.food.dao.RestaurantDAO;
import com.food.daoimpl.MenuDAOImpl;
import com.food.daoimpl.OrderDAOImpl;
import com.food.daoimpl.OrderItemDAOImpl;
import com.food.daoimpl.RestaurantDAOImpl;
import com.food.model.Menu;
import com.food.model.Order;
import com.food.model.OrderItem;
import com.food.model.Restaurant;
import com.food.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/order-status")
public class OrderStatusServlet extends HttpServlet {

    private OrderDAO orderDAO;
    private OrderItemDAO orderItemDAO;
    private MenuDAO menuDAO;
    private RestaurantDAO restaurantDAO;

    @Override
    public void init() {
        orderDAO = new OrderDAOImpl();
        orderItemDAO = new OrderItemDAOImpl();
        menuDAO = new MenuDAOImpl();
        restaurantDAO = new RestaurantDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedInUser") : null;

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login.jsp");
            return;
        }

        String orderIdStr = req.getParameter("orderId");
        if (orderIdStr == null || orderIdStr.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/orders");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdStr);
            Order order = orderDAO.getOrderById(orderId);

            if (order == null || order.getUserId() != user.getUserId()) {
                resp.sendRedirect(req.getContextPath() + "/orders");
                return;
            }

            List<OrderItem> items = orderItemDAO.getItemsByOrderId(orderId);
            List<OrderItemDetail> itemDetails = new ArrayList<>();

            double itemTotal = 0;
            for (OrderItem item : items) {
                Menu menu = menuDAO.getMenuById(item.getMenuId());
                Restaurant restaurant = null;
                if (menu != null) {
                    restaurant = restaurantDAO.getRestaurantById(menu.getRestaurantId());
                }
                itemDetails.add(new OrderItemDetail(item, menu, restaurant));
                itemTotal += item.getPrice() * item.getQuantity();
            }

            // Calculate fees consistent with Cart logic
            double deliveryFee = itemTotal >= 299 ? 0 : 40;
            double platformFee = 10;
            double gst = itemTotal * 0.05;

            // Simulated savings matching the design:
            double savedAmount = itemTotal >= 200 ? 60 : 30;

            Timestamp orderTime = order.getOrderDate();
            SimpleDateFormat fullDateFormatter = new SimpleDateFormat("dd MMM, yyyy");
            SimpleDateFormat timeFormatter = new SimpleDateFormat("hh:mm a");
            String orderPlacedDate = "";
            String orderPlacedTime = "";
            String estTimeRange = "";

            if (orderTime != null) {
                orderPlacedDate = fullDateFormatter.format(orderTime);
                orderPlacedTime = timeFormatter.format(orderTime);

                Calendar cal = Calendar.getInstance();
                cal.setTimeInMillis(orderTime.getTime());
                cal.add(Calendar.MINUTE, 30);
                String estStart = timeFormatter.format(cal.getTime());
                cal.add(Calendar.MINUTE, 10);
                String estEnd = timeFormatter.format(cal.getTime());
                estTimeRange = "(" + estStart + " - " + estEnd + ")";
            } else {
                orderPlacedDate = "Today";
                orderPlacedTime = "--:--";
                estTimeRange = "";
            }

            String orderStatus = (order.getStatus() != null) ? order.getStatus() : "PLACED";

            boolean isCancelled = "Cancelled".equalsIgnoreCase(orderStatus);

            boolean step1Completed = true;
            boolean step1Active = "PLACED".equalsIgnoreCase(orderStatus) || "Pending".equalsIgnoreCase(orderStatus);
            boolean step2Completed = !"PLACED".equalsIgnoreCase(orderStatus) && !"Pending".equalsIgnoreCase(orderStatus) && !isCancelled;
            boolean step2Active = "Preparing".equalsIgnoreCase(orderStatus);
            boolean step3Completed = "Out for Delivery".equalsIgnoreCase(orderStatus) || "Delivered".equalsIgnoreCase(orderStatus);
            boolean step3Active = "Out for Delivery".equalsIgnoreCase(orderStatus);
            boolean step4Completed = "Delivered".equalsIgnoreCase(orderStatus);
            boolean step4Active = "Delivered".equalsIgnoreCase(orderStatus);

            String progressWidth = "0%";
            if (isCancelled) {
                progressWidth = "0%";
            } else if (step4Completed) {
                progressWidth = "100%";
            } else if (step3Completed) {
                progressWidth = "66%";
            } else if (step2Completed) {
                progressWidth = "33%";
            }

            String paymentMethodDisplay = order.getPaymentMethod();
            if ("COD".equalsIgnoreCase(paymentMethodDisplay)) {
                paymentMethodDisplay = "Cash on Delivery";
            } else if ("UPI".equalsIgnoreCase(paymentMethodDisplay)) {
                paymentMethodDisplay = "UPI Payment";
            } else if ("CARD".equalsIgnoreCase(paymentMethodDisplay)) {
                paymentMethodDisplay = "Credit / Debit Card";
            }

            req.setAttribute("order", order);
            req.setAttribute("itemDetails", itemDetails);
            req.setAttribute("itemTotal", itemTotal);
            req.setAttribute("deliveryFee", deliveryFee);
            req.setAttribute("platformFee", platformFee);
            req.setAttribute("gst", gst);
            req.setAttribute("grandTotal", order.getTotalAmount()); // use actual stored total
            req.setAttribute("savedAmount", savedAmount);

            req.setAttribute("orderPlacedDate", orderPlacedDate);
            req.setAttribute("orderPlacedTime", orderPlacedTime);
            req.setAttribute("estTimeRange", estTimeRange);
            req.setAttribute("step1Completed", step1Completed);
            req.setAttribute("step1Active", step1Active);
            req.setAttribute("step2Completed", step2Completed);
            req.setAttribute("step2Active", step2Active);
            req.setAttribute("step3Completed", step3Completed);
            req.setAttribute("step3Active", step3Active);
            req.setAttribute("step4Completed", step4Completed);
            req.setAttribute("step4Active", step4Active);
            req.setAttribute("progressWidth", progressWidth);
            req.setAttribute("paymentMethodDisplay", paymentMethodDisplay);
            req.setAttribute("isCancelled", isCancelled);

            req.getRequestDispatcher("/customer/order-status.jsp").forward(req, resp);

        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/orders");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedInUser") : null;

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login.jsp");
            return;
        }

        String action = req.getParameter("action");
        String orderIdStr = req.getParameter("orderId");

        if ("cancel".equals(action) && orderIdStr != null && !orderIdStr.trim().isEmpty()) {
            try {
                int orderId = Integer.parseInt(orderIdStr);
                Order order = orderDAO.getOrderById(orderId);

                if (order != null && order.getUserId() == user.getUserId()) {
                    String status = order.getStatus();
                    if ("PLACED".equalsIgnoreCase(status) || "Pending".equalsIgnoreCase(status)) {
                        orderDAO.updateOrderStatus(orderId, "Cancelled");
                    }
                }
            } catch (NumberFormatException e) {
                // Ignore and fall through to redirect
            }
        }
        
        if (orderIdStr != null && !orderIdStr.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/order-status?orderId=" + orderIdStr);
        } else {
            resp.sendRedirect(req.getContextPath() + "/orders");
        }
    }

    public static class OrderItemDetail {
        private OrderItem orderItem;
        private Menu menu;
        private Restaurant restaurant;

        public OrderItemDetail(OrderItem orderItem, Menu menu, Restaurant restaurant) {
            this.orderItem = orderItem;
            this.menu = menu;
            this.restaurant = restaurant;
        }

        public OrderItem getOrderItem() {
            return orderItem;
        }

        public Menu getMenu() {
            return menu;
        }

        public Restaurant getRestaurant() {
            return restaurant;
        }
    }
}
