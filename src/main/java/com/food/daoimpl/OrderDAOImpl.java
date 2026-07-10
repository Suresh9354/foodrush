package com.food.daoimpl;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.food.dao.OrderDAO;
import com.food.model.Order;
import com.food.util.DBConnection;

public class OrderDAOImpl implements OrderDAO {

    private static final String INSERT =
            "INSERT INTO orders(user_id,total_amount,status,payment_method,delivery_address) VALUES(?,?,?,?,?)";

    private static final String GET_BY_USER =
            "SELECT * FROM orders WHERE user_id=? ORDER BY order_date DESC";

    private static final String GET_BY_ID =
            "SELECT * FROM orders WHERE order_id=?";

    private static final String GET_ALL =
            "SELECT * FROM orders ORDER BY order_date DESC";

    private static final String UPDATE_STATUS =
            "UPDATE orders SET status=? WHERE order_id=?";

    @Override
    public int addOrder(Order order) {

        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(
                    INSERT,
                    Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, order.getUserId());
            ps.setDouble(2, order.getTotalAmount());
            ps.setString(3, order.getStatus());
            ps.setString(4, order.getPaymentMethod());
            ps.setString(5, order.getDeliveryAddress());

            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();

            if(rs.next()) {
                return rs.getInt(1);
            }

        } catch(Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    @Override
    public List<Order> getOrdersByUserId(int userId) {

        List<Order> orders = new ArrayList<>();

        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(GET_BY_USER)) {

            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            while(rs.next()) {

                Order order = new Order();

                order.setOrderId(rs.getInt("order_id"));
                order.setUserId(rs.getInt("user_id"));
                order.setTotalAmount(rs.getDouble("total_amount"));
                order.setStatus(rs.getString("status"));
                order.setPaymentMethod(rs.getString("payment_method"));
                order.setDeliveryAddress(rs.getString("delivery_address"));
                order.setOrderDate(rs.getTimestamp("order_date"));

                orders.add(order);
            }

        } catch(Exception e) {
            e.printStackTrace();
        }

        return orders;
    }

    @Override
    public Order getOrderById(int orderId) {
        Order order = null;
        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(GET_BY_ID)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if(rs.next()) {
                order = new Order();
                order.setOrderId(rs.getInt("order_id"));
                order.setUserId(rs.getInt("user_id"));
                order.setTotalAmount(rs.getDouble("total_amount"));
                order.setStatus(rs.getString("status"));
                order.setPaymentMethod(rs.getString("payment_method"));
                order.setDeliveryAddress(rs.getString("delivery_address"));
                order.setOrderDate(rs.getTimestamp("order_date"));
            }
        } catch(Exception e) {
            e.printStackTrace();
        }
        return order;
    }

    @Override
    public boolean updateOrderStatus(int orderId, String status) {
        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(UPDATE_STATUS)) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch(Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(GET_ALL)) {
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                Order order = new Order();
                order.setOrderId(rs.getInt("order_id"));
                order.setUserId(rs.getInt("user_id"));
                order.setTotalAmount(rs.getDouble("total_amount"));
                order.setStatus(rs.getString("status"));
                order.setPaymentMethod(rs.getString("payment_method"));
                order.setDeliveryAddress(rs.getString("delivery_address"));
                order.setOrderDate(rs.getTimestamp("order_date"));
                orders.add(order);
            }
        } catch(Exception e) {
            e.printStackTrace();
        }
        return orders;
    }

    @Override
    public int placeOrder(Order order, List<com.food.model.OrderItem> items) {
        Connection con = null;
        PreparedStatement psOrder = null;
        PreparedStatement psItem = null;
        ResultSet rsKeys = null;
        int orderId = 0;

        try {
            con = DBConnection.getConnection();
            if (con == null) {
                return 0;
            }
            con.setAutoCommit(false);

            // 1. Insert Order
            psOrder = con.prepareStatement(INSERT, Statement.RETURN_GENERATED_KEYS);
            psOrder.setInt(1, order.getUserId());
            psOrder.setDouble(2, order.getTotalAmount());
            psOrder.setString(3, order.getStatus());
            psOrder.setString(4, order.getPaymentMethod());
            psOrder.setString(5, order.getDeliveryAddress());
            psOrder.executeUpdate();

            rsKeys = psOrder.getGeneratedKeys();
            if (rsKeys.next()) {
                orderId = rsKeys.getInt(1);
            } else {
                throw new SQLException("Creating order failed, no ID obtained.");
            }

            // 2. Insert Order Items using batch insertion
            String insertItemSql = "INSERT INTO order_items(order_id,menu_id,quantity,price) VALUES(?,?,?,?)";
            psItem = con.prepareStatement(insertItemSql);
            for (com.food.model.OrderItem item : items) {
                psItem.setInt(1, orderId);
                psItem.setInt(2, item.getMenuId());
                psItem.setInt(3, item.getQuantity());
                psItem.setDouble(4, item.getPrice());
                psItem.addBatch();
            }
            psItem.executeBatch();

            // Commit transaction
            con.commit();
            return orderId;

        } catch (Exception e) {
            e.printStackTrace();
            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        } finally {
            try { if (rsKeys != null) rsKeys.close(); } catch (Exception e) {}
            try { if (psOrder != null) psOrder.close(); } catch (Exception e) {}
            try { if (psItem != null) psItem.close(); } catch (Exception e) {}
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
        return 0;
    }
}