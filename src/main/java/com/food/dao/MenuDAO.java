package com.food.dao;

import java.util.List;
import com.food.model.Menu;

public interface MenuDAO {

    boolean addMenuItem(Menu menu);

    Menu getMenuById(int id);

    List<Menu> getMenuByRestaurantId(int restaurantId);

    List<Menu> getAllMenuItems();

    boolean updateMenuItem(Menu menu);

    boolean deleteMenuItem(int id);
}