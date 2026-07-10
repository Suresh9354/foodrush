package com.food.dao;

import java.util.List;

import com.food.model.Order;

public interface OrderDAO {

    int addOrder(Order order);

    List<Order> getOrdersByUserId(int userId);

    Order getOrderById(int orderId);

    boolean updateOrderStatus(int orderId, String status);

    List<Order> getAllOrders();

    int placeOrder(Order order, List<com.food.model.OrderItem> items);
}