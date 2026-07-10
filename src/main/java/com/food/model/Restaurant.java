package com.food.model;

public class Restaurant {

    private int restaurantId;
    private String name;
    private String cuisine;
    private String address;
    private double rating;
    private int deliveryTime;
    private String imageUrl;
    private boolean active;

    public Restaurant() {
    }

    public Restaurant(String name, String cuisine,
                      String address, double rating,
                      int deliveryTime, String imageUrl,
                      boolean active) {

        this.name = name;
        this.cuisine = cuisine;
        this.address = address;
        this.rating = rating;
        this.deliveryTime = deliveryTime;
        this.imageUrl = imageUrl;
        this.active = active;
    }

    public Restaurant(int restaurantId, String name,
                      String cuisine, String address,
                      double rating, int deliveryTime,
                      String imageUrl, boolean active) {

        this.restaurantId = restaurantId;
        this.name = name;
        this.cuisine = cuisine;
        this.address = address;
        this.rating = rating;
        this.deliveryTime = deliveryTime;
        this.imageUrl = imageUrl;
        this.active = active;
    }

    public int getRestaurantId() {
        return restaurantId;
    }

    public void setRestaurantId(int restaurantId) {
        this.restaurantId = restaurantId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCuisine() {
        return cuisine;
    }

    public void setCuisine(String cuisine) {
        this.cuisine = cuisine;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public double getRating() {
        return rating;
    }

    public void setRating(double rating) {
        this.rating = rating;
    }

    public int getDeliveryTime() {
        return deliveryTime;
    }

    public void setDeliveryTime(int deliveryTime) {
        this.deliveryTime = deliveryTime;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }
}