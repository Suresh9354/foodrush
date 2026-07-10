package com.food.daoimpl;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.food.dao.OrderItemDAO;
import com.food.model.OrderItem;
import com.food.util.DBConnection;

public class OrderItemDAOImpl implements OrderItemDAO {

    private static final String INSERT =
            "INSERT INTO order_items(order_id,menu_id,quantity,price) VALUES(?,?,?,?)";

    private static final String GET_BY_ORDER =
            "SELECT * FROM order_items WHERE order_id=?";

    @Override
    public boolean addOrderItem(OrderItem item) {

        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(INSERT)) {

            ps.setInt(1, item.getOrderId());
            ps.setInt(2, item.getMenuId());
            ps.setInt(3, item.getQuantity());
            ps.setDouble(4, item.getPrice());

            return ps.executeUpdate() > 0;

        } catch(Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public List<OrderItem> getItemsByOrderId(int orderId) {
        List<OrderItem> list = new ArrayList<>();
        try(Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(GET_BY_ORDER)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            while(rs.next()) {
                OrderItem item = new OrderItem();
                item.setOrderItemId(rs.getInt("order_item_id"));
                item.setOrderId(rs.getInt("order_id"));
                item.setMenuId(rs.getInt("menu_id"));
                item.setQuantity(rs.getInt("quantity"));
                item.setPrice(rs.getDouble("price"));
                list.add(item);
            }
        } catch(Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}