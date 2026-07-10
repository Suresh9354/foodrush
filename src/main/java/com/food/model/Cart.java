package com.food.model;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

public class Cart {

    private Map<Integer, CartItem> items = new HashMap<>();

    // Current restaurant of the cart
    private int restaurantId = -1;

    public int getRestaurantId() {
        return restaurantId;
    }

    public void setRestaurantId(int restaurantId) {
        this.restaurantId = restaurantId;
    }

    public Map<Integer, CartItem> getCartItems() {
        return items;
    }

    public Collection<CartItem> getItems() {
        return items.values();
    }

    public boolean isEmpty() {
        return items.isEmpty();
    }

    public void clearCart() {
        items.clear();
        restaurantId = -1;
    }

    public void addItem(Menu menu) {

        int menuId = menu.getMenuId();

        if (items.containsKey(menuId)) {

            CartItem item = items.get(menuId);

            item.setQuantity(item.getQuantity() + 1);

        } else {

            CartItem item = new CartItem();

            item.setMenuId(menu.getMenuId());
            item.setName(menu.getItemName());
            item.setPrice(menu.getPrice());
            item.setImageUrl(menu.getImageUrl());
            item.setQuantity(1);

            items.put(menuId, item);
        }
    }

    public void removeItem(int menuId) {

        items.remove(menuId);

        if (items.isEmpty()) {
            restaurantId = -1;
        }
    }

    public void increaseQuantity(int menuId) {

        if (items.containsKey(menuId)) {

            CartItem item = items.get(menuId);

            item.setQuantity(item.getQuantity() + 1);
        }
    }

    public void decreaseQuantity(int menuId) {

        if (items.containsKey(menuId)) {

            CartItem item = items.get(menuId);

            if (item.getQuantity() > 1) {

                item.setQuantity(item.getQuantity() - 1);

            } else {

                items.remove(menuId);
            }
        }

        if (items.isEmpty()) {
            restaurantId = -1;
        }
    }

    public double getTotalAmount() {

        double total = 0;

        for (CartItem item : items.values()) {

            total += item.getTotalPrice();
        }

        return total;
    }


    // Delivery charge
    public double getDeliveryFee() {

        return getTotalAmount() >= 299 ? 0 : 40;
    }


    // Platform fee
    public double getPlatformFee() {

        return 10;
    }


    // GST (5%)
    public double getGST() {

        return getTotalAmount() * 0.05;
    }


    // Final amount
    public double getGrandTotal() {

        return getTotalAmount()
                + getDeliveryFee()
                + getPlatformFee()
                + getGST();
    }
}