package com.food.daoimpl;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.food.dao.RestaurantDAO;
import com.food.model.Restaurant;
import com.food.util.DBConnection;

public class RestaurantDAOImpl implements RestaurantDAO {

    private static final String INSERT =
            "INSERT INTO restaurants(name,cuisine,address,rating,delivery_time,image_url,is_active) VALUES(?,?,?,?,?,?,?)";

    private static final String GET_BY_ID =
            "SELECT * FROM restaurants WHERE restaurant_id=?";

    private static final String GET_ALL =
            "SELECT * FROM restaurants WHERE is_active=true";

    private static final String UPDATE =
            "UPDATE restaurants SET name=?, cuisine=?, address=?, rating=?, delivery_time=?, image_url=?, is_active=? WHERE restaurant_id=?";

    private static final String DELETE =
            "DELETE FROM restaurants WHERE restaurant_id=?";


    @Override
    public boolean addRestaurant(Restaurant restaurant) {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(INSERT)) {

            ps.setString(1, restaurant.getName());
            ps.setString(2, restaurant.getCuisine());
            ps.setString(3, restaurant.getAddress());
            ps.setDouble(4, restaurant.getRating());
            ps.setInt(5, restaurant.getDeliveryTime());
            ps.setString(6, restaurant.getImageUrl());
            ps.setBoolean(7, restaurant.isActive());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }


    @Override
    public Restaurant getRestaurantById(int id) {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(GET_BY_ID)) {

            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return extractRestaurant(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }


    @Override
    public List<Restaurant> getAllRestaurants() {

        List<Restaurant> restaurants = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(GET_ALL)) {

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                restaurants.add(extractRestaurant(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return restaurants;
    }


    @Override
    public boolean updateRestaurant(Restaurant restaurant) {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(UPDATE)) {

            ps.setString(1, restaurant.getName());
            ps.setString(2, restaurant.getCuisine());
            ps.setString(3, restaurant.getAddress());
            ps.setDouble(4, restaurant.getRating());
            ps.setInt(5, restaurant.getDeliveryTime());
            ps.setString(6, restaurant.getImageUrl());
            ps.setBoolean(7, restaurant.isActive());
            ps.setInt(8, restaurant.getRestaurantId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }


    @Override
    public boolean deleteRestaurant(int id) {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(DELETE)) {

            ps.setInt(1, id);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }


    private Restaurant extractRestaurant(ResultSet rs) throws SQLException {

        Restaurant restaurant = new Restaurant();

        restaurant.setRestaurantId(rs.getInt("restaurant_id"));
        restaurant.setName(rs.getString("name"));
        restaurant.setCuisine(rs.getString("cuisine"));
        restaurant.setAddress(rs.getString("address"));
        restaurant.setRating(rs.getDouble("rating"));
        restaurant.setDeliveryTime(rs.getInt("delivery_time"));
        restaurant.setImageUrl(rs.getString("image_url"));
        restaurant.setActive(rs.getBoolean("is_active"));

        return restaurant;
    }
}