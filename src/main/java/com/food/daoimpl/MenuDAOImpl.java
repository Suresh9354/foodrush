package com.food.daoimpl;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.food.dao.MenuDAO;
import com.food.model.Menu;
import com.food.util.DBConnection;

public class MenuDAOImpl implements MenuDAO {

    private static final String INSERT =
            "INSERT INTO menu_items(restaurant_id,item_name,description,price,category,image_url,is_available) VALUES(?,?,?,?,?,?,?)";

    private static final String GET_BY_ID =
            "SELECT * FROM menu_items WHERE menu_id=?";

    private static final String GET_BY_RESTAURANT =
            "SELECT * FROM menu_items WHERE restaurant_id=? AND is_available=true";

    private static final String GET_ALL =
            "SELECT * FROM menu_items";

    private static final String UPDATE =
            "UPDATE menu_items SET item_name=?,description=?,price=?,category=?,image_url=?,is_available=? WHERE menu_id=?";

    private static final String DELETE =
            "DELETE FROM menu_items WHERE menu_id=?";


    @Override
    public boolean addMenuItem(Menu menu) {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(INSERT)) {

            ps.setInt(1, menu.getRestaurantId());
            ps.setString(2, menu.getItemName());
            ps.setString(3, menu.getDescription());
            ps.setDouble(4, menu.getPrice());
            ps.setString(5, menu.getCategory());
            ps.setString(6, menu.getImageUrl());
            ps.setBoolean(7, menu.isAvailable());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }


    @Override
    public Menu getMenuById(int id) {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(GET_BY_ID)) {

            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return extractMenu(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }


    @Override
    public List<Menu> getMenuByRestaurantId(int restaurantId) {

        List<Menu> menus = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(GET_BY_RESTAURANT)) {

            ps.setInt(1, restaurantId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                menus.add(extractMenu(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return menus;
    }


    @Override
    public List<Menu> getAllMenuItems() {

        List<Menu> menus = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(GET_ALL)) {

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                menus.add(extractMenu(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return menus;
    }


    @Override
    public boolean updateMenuItem(Menu menu) {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(UPDATE)) {

            ps.setString(1, menu.getItemName());
            ps.setString(2, menu.getDescription());
            ps.setDouble(3, menu.getPrice());
            ps.setString(4, menu.getCategory());
            ps.setString(5, menu.getImageUrl());
            ps.setBoolean(6, menu.isAvailable());
            ps.setInt(7, menu.getMenuId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }


    @Override
    public boolean deleteMenuItem(int id) {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(DELETE)) {

            ps.setInt(1, id);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }


    private Menu extractMenu(ResultSet rs) throws SQLException {

        Menu menu = new Menu();

        menu.setMenuId(rs.getInt("menu_id"));
        menu.setRestaurantId(rs.getInt("restaurant_id"));
        menu.setItemName(rs.getString("item_name"));
        menu.setDescription(rs.getString("description"));
        menu.setPrice(rs.getDouble("price"));
        menu.setCategory(rs.getString("category"));
        menu.setImageUrl(rs.getString("image_url"));
        menu.setAvailable(rs.getBoolean("is_available"));

        return menu;
    }
}