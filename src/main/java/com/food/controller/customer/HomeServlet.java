package com.food.controller.customer;

import java.io.IOException;
import java.util.List;
import java.util.ArrayList;

import com.food.dao.RestaurantDAO;
import com.food.daoimpl.RestaurantDAOImpl;
import com.food.model.Restaurant;
import com.food.dao.MenuDAO;
import com.food.daoimpl.MenuDAOImpl;
import com.food.model.Menu;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {

    private RestaurantDAO restaurantDAO;
    private MenuDAO menuDAO;

    @Override
    public void init() {
        restaurantDAO = new RestaurantDAOImpl();
        menuDAO = new MenuDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse resp)
            throws ServletException, IOException {

        // 1. Fetch and sort top restaurants
        List<Restaurant> restaurants = restaurantDAO.getAllRestaurants();
        if (restaurants != null) {
            restaurants.sort((r1, r2) -> Double.compare(r2.getRating(), r1.getRating()));
            if (restaurants.size() > 4) {
                restaurants = restaurants.subList(0, 4);
            }
        }
        req.setAttribute("restaurants", restaurants);

        // 2. Fetch unique categories from menu items in database
        List<Menu> allMenuItems = menuDAO.getAllMenuItems();
        List<String> categories = new ArrayList<>();
        if (allMenuItems != null) {
            for (Menu item : allMenuItems) {
                String cat = item.getCategory();
                if (cat != null && !cat.trim().isEmpty() && !cat.equalsIgnoreCase("null")) {
                    cat = cat.trim();
                    if (!categories.contains(cat)) {
                        categories.add(cat);
                    }
                }
            }
        }

        // Fallback default menu categories if database is empty/unpopulated
        if (categories.isEmpty()) {
            categories.add("Biryani");
            categories.add("Burger");
            categories.add("Pizza");
            categories.add("kfc");
            categories.add("Cake");
            categories.add("Beverages");
            categories.add("fried chicken");
        }
        req.setAttribute("categories", categories);

        req.getRequestDispatcher("customer/home.jsp")
           .forward(req, resp);
    }
}