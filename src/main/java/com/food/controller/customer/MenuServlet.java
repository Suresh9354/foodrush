package com.food.controller.customer;

import java.io.IOException;
import java.util.List;

import com.food.dao.MenuDAO;
import com.food.daoimpl.MenuDAOImpl;
import com.food.model.Menu;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/menu")
public class MenuServlet extends HttpServlet {

    private MenuDAO menuDAO;

    @Override
    public void init() {
        menuDAO = new MenuDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse resp)
            throws ServletException, IOException {

        String category = req.getParameter("category");
        List<Menu> menuList;

        if (category != null && !category.trim().isEmpty()) {
            List<Menu> allItems = menuDAO.getAllMenuItems();
            menuList = new java.util.ArrayList<>();
            for (Menu item : allItems) {
                if (item.isAvailable()) {
                    boolean matches = false;
                    if (item.getCategory() != null && item.getCategory().equalsIgnoreCase(category)) {
                        matches = true;
                    } else if (item.getItemName() != null && item.getItemName().toLowerCase().contains(category.toLowerCase())) {
                        matches = true;
                    }
                    if (matches) {
                        menuList.add(item);
                    }
                }
            }
            req.setAttribute("categoryTitle", category);
        } else {
            String restaurantIdStr = req.getParameter("restaurantId");
            int restaurantId = 0;
            if (restaurantIdStr != null && !restaurantIdStr.trim().isEmpty()) {
                restaurantId = Integer.parseInt(restaurantIdStr);
            }
            menuList = menuDAO.getMenuByRestaurantId(restaurantId);
        }

        req.setAttribute("menuList", menuList);

        req.getRequestDispatcher("/customer/menu.jsp")
           .forward(req, resp);
    }
}