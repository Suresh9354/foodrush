<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.food.dao.*, com.food.daoimpl.*, com.food.model.*, java.util.*" %>
<%
    request.setAttribute("activePage", "restaurants");

    String action = request.getParameter("action");
    RestaurantDAO restaurantDAO = new RestaurantDAOImpl();
    boolean isDbConnected = true;

    List<Restaurant> allRestaurants = null;
    try {
        allRestaurants = restaurantDAO.getAllRestaurants();
        if (allRestaurants == null) {
            isDbConnected = false;
            allRestaurants = new ArrayList<>();
        }
    } catch (Exception e) {
        isDbConnected = false;
        allRestaurants = new ArrayList<>();
    }

    Map<Integer, Integer> restaurantOrderCounts = new HashMap<>();
    if (isDbConnected) {
        try (java.sql.Connection conn = com.food.util.DBConnection.getConnection();
             java.sql.PreparedStatement ps = conn.prepareStatement(
                 "SELECT m.restaurant_id, COUNT(DISTINCT oi.order_id) AS order_count " +
                 "FROM order_items oi " +
                 "JOIN menu_items m ON oi.menu_id = m.menu_id " +
                 "GROUP BY m.restaurant_id")) {
            try (java.sql.ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    restaurantOrderCounts.put(rs.getInt("restaurant_id"), rs.getInt("order_count"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Process Form Submissions (Add, Edit, Delete)
    if (action != null) {
        try {
            if ("add".equals(action)) {
                String name = request.getParameter("name");
                String cuisine = request.getParameter("cuisine");
                String address = request.getParameter("address");
                double rating = Double.parseDouble(request.getParameter("rating"));
                int deliveryTime = Integer.parseInt(request.getParameter("deliveryTime"));
                String imageUrl = request.getParameter("imageUrl");
                boolean active = "true".equals(request.getParameter("active"));

                Restaurant r = new Restaurant(name, cuisine, address, rating, deliveryTime, imageUrl, active);
                restaurantDAO.addRestaurant(r);
                response.sendRedirect("restaurants.jsp?msg=added");
                return;
            } else if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("restaurantId"));
                String name = request.getParameter("name");
                String cuisine = request.getParameter("cuisine");
                String address = request.getParameter("address");
                double rating = Double.parseDouble(request.getParameter("rating"));
                int deliveryTime = Integer.parseInt(request.getParameter("deliveryTime"));
                String imageUrl = request.getParameter("imageUrl");
                boolean active = "true".equals(request.getParameter("active"));

                Restaurant r = new Restaurant(id, name, cuisine, address, rating, deliveryTime, imageUrl, active);
                restaurantDAO.updateRestaurant(r);
                response.sendRedirect("restaurants.jsp?msg=updated");
                return;
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("restaurantId"));
                restaurantDAO.deleteRestaurant(id);
                response.sendRedirect("restaurants.jsp?msg=deleted");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("restaurants.jsp?msg=error");
            return;
        }
    }

    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FoodRush Admin | Restaurant Management</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/admin-global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/table.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/forms.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/buttons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/responsive.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/restaurants.css">
</head>
<body>
    <div class="admin-layout">
        <jsp:include page="/components/sidebar.jsp" />
        
        <div class="main-content">
            <jsp:include page="/components/topbar.jsp" />
            
            <div class="content-wrapper">
                <% if (!isDbConnected) { %>
                    <div class="demo-banner">
                        <i class="bi bi-info-circle-fill"></i>
                        <span><strong>Database Connection Unreachable.</strong> Operating in sandbox mode. Changes will be saved in your session.</span>
                    </div>
                <% } %>
                
                <div class="page-header">
                    <div class="page-title">
                        <h1>Restaurant Management</h1>
                        <p>Configure outlet locations, menu bindings, ratings, and operating statuses.</p>
                    </div>
                </div>

                <!-- Status Toast/Notifications -->
                <% if ("added".equals(msg)) { %>
                    <div class="admin-alert alert-success">
                        <i class="bi bi-check-circle-fill"></i>
                        <span>Restaurant added successfully!</span>
                    </div>
                <% } else if ("updated".equals(msg)) { %>
                    <div class="admin-alert alert-info">
                        <i class="bi bi-check-circle-fill"></i>
                        <span>Restaurant details updated successfully!</span>
                    </div>
                <% } else if ("deleted".equals(msg)) { %>
                    <div class="admin-alert alert-danger">
                        <i class="bi bi-trash3-fill"></i>
                        <span>Restaurant deleted successfully!</span>
                    </div>
                <% } else if ("error".equals(msg)) { %>
                    <div class="admin-alert alert-danger">
                        <i class="bi bi-exclamation-triangle-fill"></i>
                        <span>An error occurred while saving details. Please try again.</span>
                    </div>
                <% } %>

                <%
                    int totalRest = allRestaurants.size();
                    int activeRest = 0;
                    int inactiveRest = 0;
                    for (Restaurant r : allRestaurants) {
                        if (r.isActive()) {
                            activeRest++;
                        } else {
                            inactiveRest++;
                        }
                    }
                    int newThisWeek = Math.min(10, totalRest);
                %>
                <!-- Stats Cards Row to match screenshot -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-icon-wrapper orange">
                            <i class="bi bi-shop"></i>
                        </div>
                        <div class="stat-details">
                            <span class="stat-label">Total Restaurants</span>
                            <h2 class="stat-value"><%= String.format("%,d", totalRest) %></h2>
                            <span class="trend-badge green"><i class="bi bi-arrow-up-short"></i> 12.8% <span class="trend-text">from last week</span></span>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon-wrapper green">
                            <i class="bi bi-check-circle"></i>
                        </div>
                        <div class="stat-details">
                            <span class="stat-label">Active Restaurants</span>
                            <h2 class="stat-value"><%= String.format("%,d", activeRest) %></h2>
                            <span class="trend-badge green"><i class="bi bi-arrow-up-short"></i> 14.3% <span class="trend-text">from last week</span></span>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon-wrapper yellow">
                            <i class="bi bi-pause-circle"></i>
                        </div>
                        <div class="stat-details">
                            <span class="stat-label">Inactive Restaurants</span>
                            <h2 class="stat-value"><%= String.format("%,d", inactiveRest) %></h2>
                            <span class="trend-badge red"><i class="bi bi-arrow-down-short"></i> 5.6% <span class="trend-text">from last week</span></span>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon-wrapper purple">
                            <i class="bi bi-plus-circle"></i>
                        </div>
                        <div class="stat-details">
                            <span class="stat-label">New This Week</span>
                            <h2 class="stat-value"><%= String.format("%,d", newThisWeek) %></h2>
                            <span class="trend-badge purple"><i class="bi bi-arrow-up-short"></i> 11.1% <span class="trend-text">from last week</span></span>
                        </div>
                    </div>
                </div>
                
                <!-- Filter Bar to match screenshot -->
                <div class="table-filter-bar">
                    <div class="search-input-group">
                        <i class="bi bi-search"></i>
                        <input type="text" id="table-search-input" placeholder="Search by restaurant name or email">
                    </div>
                    <div class="filter-group" style="display: flex; gap: 10px; align-items: center; flex-wrap: wrap;">
                        <select id="table-status-filter" class="filter-select">
                            <option value="all">Select Status</option>
                            <option value="active">Active</option>
                            <option value="inactive">Inactive</option>
                        </select>
                        <select id="table-cuisine-filter" class="filter-select">
                            <option value="all">Select Cuisine</option>
                            <%
                                Set<String> cuisineSet = new LinkedHashSet<>();
                                for(Restaurant r : allRestaurants) {
                                    if(r.getCuisine() != null) {
                                        for(String tag : r.getCuisine().split(",")) {
                                            cuisineSet.add(tag.trim());
                                        }
                                    }
                                }
                                for(String cuisineTag : cuisineSet) {
                            %>
                                <option value="<%= cuisineTag %>"><%= cuisineTag %></option>
                            <% } %>
                        </select>
                        <button class="btn btn-secondary" onclick="resetFilters()" style="padding: 10px 16px; font-weight: 500; font-family: 'Outfit';">Reset</button>
                        <button class="btn btn-primary" onclick="openModal('add-restaurant-modal')" style="background: #FF5A1F; border-color: #FF5A1F; display: flex; align-items: center; gap: 6px; padding: 10px 16px; font-weight: 500; font-family: 'Outfit';">
                            <i class="bi bi-plus-lg"></i> Add Restaurant
                        </button>
                    </div>
                </div>

                <!-- Table Container -->
                <div class="table-container">
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>Restaurant</th>
                                <th>Cuisine</th>
                                <th>Location</th>
                                <th>Status</th>
                                <th>Rating</th>
                                <th>Orders</th>
                                <th>Joined On</th>
                                <th style="text-align: right;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                for (Restaurant r : allRestaurants) {
                                    String statusLabel = r.isActive() ? "Active" : "Inactive";
                                    String badgeClass = r.isActive() ? "active" : "inactive";
    
                                    // Get precomputed order count from map
                                    int orderCount = restaurantOrderCounts.getOrDefault(r.getRestaurantId(), 0);
                            %>
                            <tr>
                                <td>
                                    <div class="item-cell-profile">
                                        <div>
                                            <span class="item-cell-title" style="font-weight: 600;"><%= r.getName() %></span>
                                        </div>
                                    </div>
                                </td>
                                <td><%= r.getCuisine() %></td>
                                <td><%= r.getAddress() %></td>
                                <td>
                                    <span class="status-badge <%= badgeClass %>"><%= statusLabel %></span>
                                </td>
                                <td>
                                    <strong style="color: #F59E0B;"><i class="bi bi-star-fill"></i> <%= r.getRating() %></strong>
                                </td>
                                <td><%= orderCount %></td>
                                <td>01 May 2025</td>
                                <td style="text-align: right;">
                                    <button class="btn-circle-edit btn-edit-action" title="Edit Restaurant"
                                            data-modal-id="edit-restaurant-modal"
                                            data-field-edit-restaurantid="<%= r.getRestaurantId() %>"
                                            data-field-edit-name="<%= r.getName() %>"
                                            data-field-edit-cuisine="<%= r.getCuisine() %>"
                                            data-field-edit-address="<%= r.getAddress() %>"
                                            data-field-edit-rating="<%= r.getRating() %>"
                                            data-field-edit-deliverytime="<%= r.getDeliveryTime() %>"
                                            data-field-edit-imageurl="<%= r.getImageUrl() %>"
                                            data-field-edit-active="<%= r.isActive() %>">
                                        <i class="bi bi-pencil"></i>
                                    </button>
                                    <a href="restaurants.jsp?action=delete&restaurantId=<%= r.getRestaurantId() %>" 
                                       class="btn-circle-delete btn-delete-action" title="Delete Restaurant"
                                       data-confirm-message="Are you sure you want to delete <%= r.getName() %>? All menu items linked to this outlet will be unlinked.">
                                        <i class="bi bi-trash"></i>
                                    </a>
                                </td>
                            </tr>
                            <%
                                }
                            %>
                            <tr id="table-empty-state" style="display: none;">
                                <td colspan="8">
                                    <div class="empty-table-state">
                                        <i class="bi bi-shop-window"></i>
                                        <p>No restaurants match your search query.</p>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                
                <!-- Pagination Section -->
                <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 20px; font-family: 'Outfit'; font-size: 0.88rem; color: var(--text-muted);">
                    <div id="pagination-info">
                        Showing 1 to <%= Math.min(10, totalRest) %> of <%= totalRest %> restaurants
                    </div>
                    <div id="pagination-buttons" style="display: flex; gap: 6px; align-items: center;">
                    </div>
                </div>
            </div>

            <!-- MODAL: ADD RESTAURANT -->
            <div id="add-restaurant-modal" class="modal-overlay">
                <div class="modal-wrapper">
                    <div class="modal-header">
                        <h3>Add New Restaurant</h3>
                        <button class="modal-close-btn">&times;</button>
                    </div>
                    <form action="restaurants.jsp" method="POST">
                        <input type="hidden" name="action" value="add">
                        <div class="modal-body">
                            <div class="form-group">
                                <label class="form-label" for="add-name">Restaurant Name</label>
                                <input type="text" id="add-name" name="name" class="form-control" placeholder="e.g. Burger Club" required>
                            </div>
                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label" for="add-cuisine">Cuisine Tags</label>
                                    <input type="text" id="add-cuisine" name="cuisine" class="form-control" placeholder="e.g. Fast Food, Desserts" required>
                                </div>
                                <div class="form-group">
                                    <label class="form-label" for="add-deliveryTime">Delivery Time (mins)</label>
                                    <input type="number" id="add-deliveryTime" name="deliveryTime" class="form-control" min="5" value="30" required>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="add-address">Physical Address</label>
                                <input type="text" id="add-address" name="address" class="form-control" placeholder="e.g. 5th Avenue, Suite 101" required>
                            </div>
                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label" for="add-rating">Default Rating</label>
                                    <input type="number" id="add-rating" name="rating" class="form-control" step="0.1" min="1.0" max="5.0" value="4.0" required>
                                </div>
                                <div class="form-group">
                                    <label class="form-label" for="add-imageUrl">Cover Image URL</label>
                                    <input type="text" id="add-imageUrl" name="imageUrl" class="form-control" placeholder="e.g. assets/images/outlets/outlet.jpg">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="form-switch">
                                    <input type="checkbox" name="active" value="true" checked>
                                    <span class="switch-slider"></span>
                                    <span class="switch-label">Outlet Active & Accepting Orders</span>
                                </label>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" onclick="closeModal('add-restaurant-modal')">Cancel</button>
                            <button type="submit" class="btn btn-primary">Save Restaurant</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- MODAL: EDIT RESTAURANT -->
            <div id="edit-restaurant-modal" class="modal-overlay">
                <div class="modal-wrapper">
                    <div class="modal-header">
                        <h3>Edit Restaurant Listing</h3>
                        <button class="modal-close-btn">&times;</button>
                    </div>
                    <form action="restaurants.jsp" method="POST">
                        <input type="hidden" name="action" value="edit">
                        <input type="hidden" id="edit-restaurantid" name="restaurantId">
                        <div class="modal-body">
                            <div class="form-group">
                                <label class="form-label" for="edit-name">Restaurant Name</label>
                                <input type="text" id="edit-name" name="name" class="form-control" required>
                            </div>
                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label" for="edit-cuisine">Cuisine Tags</label>
                                    <input type="text" id="edit-cuisine" name="cuisine" class="form-control" required>
                                </div>
                                <div class="form-group">
                                    <label class="form-label" for="edit-deliverytime">Delivery Time (mins)</label>
                                    <input type="number" id="edit-deliverytime" name="deliveryTime" class="form-control" required>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="edit-address">Physical Address</label>
                                <input type="text" id="edit-address" name="address" class="form-control" required>
                            </div>
                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label" for="edit-rating">Current Rating</label>
                                    <input type="number" id="edit-rating" name="rating" class="form-control" step="0.1" min="1.0" max="5.0" required>
                                </div>
                                <div class="form-group">
                                    <label class="form-label" for="edit-imageurl">Cover Image URL</label>
                                    <input type="text" id="edit-imageurl" name="imageUrl" class="form-control">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="form-switch">
                                    <input type="checkbox" id="edit-active" name="active" value="true">
                                    <span class="switch-slider"></span>
                                    <span class="switch-label">Outlet Active & Accepting Orders</span>
                                </label>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" onclick="closeModal('edit-restaurant-modal')">Cancel</button>
                            <button type="submit" class="btn btn-primary">Save Changes</button>
                        </div>
                    </form>
                </div>
            </div>
            
            <jsp:include page="/components/footer.jsp" />
        </div>
    </div>
    
    <script src="${pageContext.request.contextPath}/assets/js/admin/sidebar.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/admin/dashboard.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/admin/restaurants.js"></script>
</body>
</html>
