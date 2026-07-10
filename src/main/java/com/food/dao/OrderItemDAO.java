package com.food.dao;

import java.util.List;

import com.food.model.OrderItem;

public interface OrderItemDAO {

    boolean addOrderItem(OrderItem item);

    List<OrderItem> getItemsByOrderId(int orderId);
}