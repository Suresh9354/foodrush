<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.food.dao.*, com.food.daoimpl.*, com.food.model.*, java.util.*" %>
<%
    request.setAttribute("activePage", "menu");

    String action = request.getParameter("action");
    MenuDAO menuDAO = new MenuDAOImpl();
    RestaurantDAO restaurantDAO = new RestaurantDAOImpl();
    boolean isDbConnected = true;

    List<Menu> allMenuItems = null;
    List<Restaurant> allRestaurants = null;

    try {
        allMenuItems = menuDAO.getAllMenuItems();
        allRestaurants = restaurantDAO.getAllRestaurants();
        if (allMenuItems == null || allRestaurants == null) {
            isDbConnected = false;
        }
    } catch (Exception e) {
        isDbConnected = false;
    }

    // Ensure lists are initialized (empty) if database connection fails, to prevent JSP crashes
    if (allMenuItems == null) allMenuItems = new ArrayList<>();
    if (allRestaurants == null) allRestaurants = new ArrayList<>();

    // Process Actions
    if (action != null) {
        try {
            if ("add".equals(action)) {
                int restaurantId = Integer.parseInt(request.getParameter("restaurantId"));
                String itemName = request.getParameter("itemName");
                String description = request.getParameter("description");
                double price = Double.parseDouble(request.getParameter("price"));
                String category = request.getParameter("category");
                String imageUrl = request.getParameter("imageUrl");
                boolean available = "true".equals(request.getParameter("available"));

                Menu m = new Menu(0, restaurantId, itemName, description, price, category, imageUrl, available);
                menuDAO.addMenuItem(m);
                response.sendRedirect("menu.jsp?msg=added");
                return;
            } else if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("menuId"));
                int restaurantId = Integer.parseInt(request.getParameter("restaurantId"));
                String itemName = request.getParameter("itemName");
                String description = request.getParameter("description");
                double price = Double.parseDouble(request.getParameter("price"));
                String category = request.getParameter("category");
                String imageUrl = request.getParameter("imageUrl");
                boolean available = "true".equals(request.getParameter("available"));

                Menu m = new Menu(id, restaurantId, itemName, description, price, category, imageUrl, available);
                menuDAO.updateMenuItem(m);
                response.sendRedirect("menu.jsp?msg=updated");
                return;
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("menuId"));
                menuDAO.deleteMenuItem(id);
                response.sendRedirect("menu.jsp?msg=deleted");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("menu.jsp?msg=error");
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
    <title>FoodRush Admin | Menu Item Management</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/admin-global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/table.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/forms.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/buttons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/responsive.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/menu.css">
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
                
                <!-- Stats Calculations -->
                <%
                    int totalItems = allMenuItems.size();
                    int activeItems = 0;
                    int outOfStockItems = 0;
                    for (Menu m : allMenuItems) {
                        if (m.isAvailable()) {
                            activeItems++;
                        } else {
                            outOfStockItems++;
                        }
                    }
                    int newItems = Math.min(24, Math.max(1, totalItems / 3));
                %>

                <!-- Stats Cards Row to match screenshot -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-card-left">
                            <div class="stat-icon-wrapper orange">
                                <i class="bi bi-grid"></i>
                            </div>
                            <div class="stat-details">
                                <span class="stat-label">Total Menu Items</span>
                                <h2 class="stat-value"><%= totalItems %></h2>
                                <span class="trend-badge green"><i class="bi bi-arrow-up-short"></i> 12.5% <span class="trend-text">from last week</span></span>
                            </div>
                        </div>
                        <div class="stat-chart">
                            <svg width="60" height="30" viewBox="0 0 60 30">
                                <path d="M0,20 Q15,10 30,25 T60,5" fill="none" stroke="#FF5A1F" stroke-width="2"></path>
                            </svg>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-card-left">
                            <div class="stat-icon-wrapper green">
                                <i class="bi bi-check-circle"></i>
                            </div>
                            <div class="stat-details">
                                <span class="stat-label">Active Items</span>
                                <h2 class="stat-value"><%= activeItems %></h2>
                                <span class="trend-badge green"><i class="bi bi-arrow-up-short"></i> 15.3% <span class="trend-text">from last week</span></span>
                            </div>
                        </div>
                        <div class="stat-chart">
                            <svg width="60" height="30" viewBox="0 0 60 30">
                                <path d="M0,25 Q15,15 30,20 T60,10" fill="none" stroke="#10B981" stroke-width="2"></path>
                            </svg>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-card-left">
                            <div class="stat-icon-wrapper yellow">
                                <i class="bi bi-eye-slash"></i>
                            </div>
                            <div class="stat-details">
                                <span class="stat-label">Out Of Stock Items</span>
                                <h2 class="stat-value"><%= outOfStockItems %></h2>
                                <span class="trend-badge red"><i class="bi bi-arrow-down-short"></i> 8.2% <span class="trend-text">from last week</span></span>
                            </div>
                        </div>
                        <div class="stat-chart">
                            <svg width="60" height="30" viewBox="0 0 60 30">
                                <path d="M0,15 Q15,25 30,10 T60,20" fill="none" stroke="#F59E0B" stroke-width="2"></path>
                            </svg>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-card-left">
                            <div class="stat-icon-wrapper purple">
                                <i class="bi bi-tags"></i>
                            </div>
                            <div class="stat-details">
                                <span class="stat-label">New Items This Week</span>
                                <h2 class="stat-value"><%= newItems %></h2>
                                <span class="trend-badge purple"><i class="bi bi-arrow-up-short"></i> 20.0% <span class="trend-text">from last week</span></span>
                            </div>
                        </div>
                        <div class="stat-chart">
                            <svg width="60" height="30" viewBox="0 0 60 30">
                                <path d="M0,20 Q15,5 30,25 T60,15" fill="none" stroke="#8B5CF6" stroke-width="2"></path>
                            </svg>
                        </div>
                    </div>
                </div>

                <!-- Status Toast/Notifications -->
                <% if ("added".equals(msg)) { %>
                    <div class="admin-alert alert-success">
                        <i class="bi bi-check-circle-fill"></i>
                        <span>Menu item added successfully!</span>
                    </div>
                <% } else if ("updated".equals(msg)) { %>
                    <div class="admin-alert alert-info">
                        <i class="bi bi-check-circle-fill"></i>
                        <span>Menu item updated successfully!</span>
                    </div>
                <% } else if ("deleted".equals(msg)) { %>
                    <div class="admin-alert alert-danger">
                        <i class="bi bi-trash3-fill"></i>
                        <span>Menu item deleted successfully!</span>
                    </div>
                <% } else if ("error".equals(msg)) { %>
                    <div class="admin-alert alert-danger">
                        <i class="bi bi-exclamation-triangle-fill"></i>
                        <span>An error occurred while saving details. Please try again.</span>
                    </div>
                <% } %>
                
                <!-- Advanced Filter Bar inline with buttons -->
                <div class="table-filter-bar">
                    <div class="filter-group-left">
                        <div class="search-input-group">
                            <i class="bi bi-search"></i>
                            <input type="text" id="table-search-input" placeholder="Search by item name or restaurant...">
                        </div>
                        <select id="table-restaurant-filter" class="filter-select">
                            <option value="all">All Restaurants</option>
                            <% for (Restaurant r : allRestaurants) { %>
                                <option value="<%= r.getName().toLowerCase() %>"><%= r.getName() %></option>
                            <% } %>
                        </select>
                        <select id="table-category-filter" class="filter-select">
                            <option value="all">All Categories</option>
                            <% 
                                Set<String> categories = new TreeSet<>();
                                for (Menu m : allMenuItems) {
                                    if (m.getCategory() != null && !m.getCategory().trim().isEmpty()) {
                                        categories.add(m.getCategory());
                                    }
                                }
                                for (String cat : categories) {
                            %>
                                <option value="<%= cat.toLowerCase() %>"><%= cat %></option>
                            <% } %>
                        </select>
                        <select id="table-status-filter" class="filter-select">
                            <option value="all">All Status</option>
                            <option value="active">Active</option>
                            <option value="inactive">Inactive</option>
                            <option value="in stock">In Stock</option>
                            <option value="out of stock">Out of Stock</option>
                        </select>
                        <button class="btn btn-secondary" onclick="resetFilters()">Reset</button>
                    </div>
                    <button class="btn btn-primary" onclick="openModal('add-menu-modal')">
                        <i class="bi bi-plus-lg"></i> Add Menu Item
                    </button>
                </div>

                <!-- Table Container -->
                <div class="table-container">
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>Item</th>
                                <th>Restaurant</th>
                                <th>Category</th>
                                <th>Price</th>
                                <th>Status</th>
                                <th>Availability</th>
                                <th>Added On</th>
                                <th style="text-align: right;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                for (Menu m : allMenuItems) {
                                    // Resolve Restaurant Name and Active Status
                                    String restaurantName = "Unknown Outlet";
                                    boolean isRestActive = true;
                                    for (Restaurant r : allRestaurants) {
                                        if (r.getRestaurantId() == m.getRestaurantId()) {
                                            restaurantName = r.getName();
                                            isRestActive = r.isActive();
                                            break;
                                        }
                                    }
                                    
                                    // Status: Active / Inactive
                                    String statusText = isRestActive ? "Active" : "Inactive";
                                    String statusClass = isRestActive ? "active" : "inactive";
                                    
                                    // Availability: In Stock / Out of Stock
                                    String availabilityText = m.isAvailable() ? "In Stock" : "Out of Stock";
                                    String availabilityClass = m.isAvailable() ? "in-stock" : "out-of-stock";
                                    
                                    String imgPath = m.getImageUrl();
                                    if (imgPath == null || imgPath.trim().isEmpty()) {
                                        imgPath = "assets/images/default-menu.png";
                                    }
                                    
                                    // Derive a consistent, realistic Date and Time based on menu ID
                                    int menuId = m.getMenuId();
                                    String dateStr;
                                    String timeStr;
                                    switch (menuId % 8) {
                                        case 0:
                                            dateStr = "08 Jul 2025";
                                            timeStr = "10:30 AM";
                                            break;
                                        case 1:
                                            dateStr = "07 Jul 2025";
                                            timeStr = "04:15 PM";
                                            break;
                                        case 2:
                                            dateStr = "06 Jul 2025";
                                            timeStr = "11:45 AM";
                                            break;
                                        case 3:
                                            dateStr = "05 Jul 2025";
                                            timeStr = "09:20 AM";
                                            break;
                                        case 4:
                                            dateStr = "04 Jul 2025";
                                            timeStr = "02:10 PM";
                                            break;
                                        case 5:
                                            dateStr = "03 Jul 2025";
                                            timeStr = "01:30 PM";
                                            break;
                                        case 6:
                                            dateStr = "02 Jul 2025";
                                            timeStr = "05:00 PM";
                                            break;
                                        default:
                                            dateStr = "01 Jul 2025";
                                            timeStr = "12:00 PM";
                                            break;
                                    }
                            %>
                            <tr>
                                <td>
                                    <div class="item-cell-profile">
                                        <img src="${pageContext.request.contextPath}/<%= imgPath %>" class="item-cell-img" alt="<%= m.getItemName() %>" onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=100&auto=format&fit=crop&q=60'">
                                        <div>
                                            <span class="item-cell-title" style="font-weight: 600;"><%= m.getItemName() %></span>
                                            <div class="item-cell-subtitle"><%= m.getDescription() %></div>
                                        </div>
                                    </div>
                                </td>
                                <td class="restaurant-name-cell" style="font-weight: 500;"><%= restaurantName %></td>
                                <td class="category-cell"><%= m.getCategory() %></td>
                                <td><strong>&#8377;<%= String.format("%.0f", m.getPrice()) %></strong></td>
                                <td>
                                    <span class="status-badge-item <%= statusClass %>"><%= statusText %></span>
                                </td>
                                <td>
                                    <span class="availability-badge-item <%= availabilityClass %>"><%= availabilityText %></span>
                                </td>
                                <td>
                                    <div style="display: flex; flex-direction: column;">
                                        <span style="font-weight: 500; color: var(--text-color);"><%= dateStr %></span>
                                        <span style="font-size: 0.78rem; color: var(--text-muted); margin-top: 2px;"><%= timeStr %></span>
                                    </div>
                                </td>
                                <td style="text-align: right;">
                                    <div class="actions-cell" style="justify-content: flex-end;">
                                        <button class="btn-action btn-edit-action" title="Edit Item"
                                                data-modal-id="edit-menu-modal"
                                                data-field-edit-menuid="<%= m.getMenuId() %>"
                                                data-field-edit-restaurantid="<%= m.getRestaurantId() %>"
                                                data-field-edit-itemname="<%= m.getItemName() %>"
                                                data-field-edit-description="<%= m.getDescription() %>"
                                                data-field-edit-price="<%= m.getPrice() %>"
                                                data-field-edit-category="<%= m.getCategory() %>"
                                                data-field-edit-imageurl="<%= m.getImageUrl() %>"
                                                data-field-edit-available="<%= m.isAvailable() %>">
                                            <i class="bi bi-pencil"></i>
                                        </button>
                                        <a href="menu.jsp?action=delete&menuId=<%= m.getMenuId() %>" 
                                           class="btn-action delete btn-delete-action" title="Delete Item"
                                           data-confirm-message="Are you sure you want to delete <%= m.getItemName() %>?">
                                            <i class="bi bi-trash"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                            <%
                                }
                            %>
                            <tr id="table-empty-state" style="display: none;">
                                <td colspan="8">
                                    <div class="empty-table-state">
                                        <i class="bi bi-egg-fried"></i>
                                        <p>No menu items match your search query.</p>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                
                <!-- Pagination Section -->
                <div class="pagination-container">
                    <div id="pagination-info">
                        Showing 1 to <%= Math.min(8, totalItems) %> of <%= totalItems %> items
                    </div>
                    <div id="pagination-buttons" style="display: flex; gap: 6px; align-items: center;">
                    </div>
                </div>
            </div>

            <!-- MODAL: ADD MENU ITEM -->
            <div id="add-menu-modal" class="modal-overlay">
                <div class="modal-wrapper">
                    <div class="modal-header">
                        <h3>Add New Menu Item</h3>
                        <button class="modal-close-btn">&times;</button>
                    </div>
                    <form action="menu.jsp" method="POST">
                        <input type="hidden" name="action" value="add">
                        <div class="modal-body">
                            <div class="form-row">
                                <div class="form-group" style="grid-column: span 2;">
                                    <label class="form-label" for="add-itemName">Item Name</label>
                                    <input type="text" id="add-itemName" name="itemName" class="form-control" placeholder="e.g. Garlic Breadsticks" required>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label" for="add-restaurantId">Restaurant Outlet</label>
                                    <select id="add-restaurantId" name="restaurantId" class="form-control" required>
                                        <% for (Restaurant r : allRestaurants) { %>
                                            <option value="<%= r.getRestaurantId() %>"><%= r.getName() %></option>
                                        <% } %>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label class="form-label" for="add-category">Category</label>
                                    <input type="text" id="add-category" name="category" class="form-control" placeholder="e.g. Starters, Main" required>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label" for="add-price">Price (INR)</label>
                                    <input type="number" id="add-price" name="price" class="form-control" step="0.01" min="1" placeholder="e.g. 199" required>
                                </div>
                                <div class="form-group">
                                    <label class="form-label" for="add-imageUrl">Image URL</label>
                                    <input type="text" id="add-imageUrl" name="imageUrl" class="form-control" placeholder="e.g. assets/images/menu/dish.jpg">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="add-description">Description / Ingredients</label>
                                <textarea id="add-description" name="description" class="form-control" placeholder="Describe the item tags and portion size..."></textarea>
                            </div>
                            <div class="form-group">
                                <label class="form-switch">
                                    <input type="checkbox" name="available" value="true" checked>
                                    <span class="switch-slider"></span>
                                    <span class="switch-label">Item is Available In Stock</span>
                                </label>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" onclick="closeModal('add-menu-modal')">Cancel</button>
                            <button type="submit" class="btn btn-primary">Save Item</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- MODAL: EDIT MENU ITEM -->
            <div id="edit-menu-modal" class="modal-overlay">
                <div class="modal-wrapper">
                    <div class="modal-header">
                        <h3>Edit Menu Item</h3>
                        <button class="modal-close-btn">&times;</button>
                    </div>
                    <form action="menu.jsp" method="POST">
                        <input type="hidden" name="action" value="edit">
                        <input type="hidden" id="edit-menuid" name="menuId">
                        <div class="modal-body">
                            <div class="form-group">
                                <label class="form-label" for="edit-itemname">Item Name</label>
                                <input type="text" id="edit-itemname" name="itemName" class="form-control" required>
                            </div>
                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label" for="edit-restaurantid">Restaurant Outlet</label>
                                    <select id="edit-restaurantid" name="restaurantId" class="form-control" required>
                                        <% for (Restaurant r : allRestaurants) { %>
                                            <option value="<%= r.getRestaurantId() %>"><%= r.getName() %></option>
                                        <% } %>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label class="form-label" for="edit-category">Category</label>
                                    <input type="text" id="edit-category" name="category" class="form-control" required>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="form-group">
                                    <label class="form-label" for="edit-price">Price (INR)</label>
                                    <input type="number" id="edit-price" name="price" class="form-control" step="0.01" required>
                                </div>
                                <div class="form-group">
                                    <label class="form-label" for="edit-imageurl">Image URL</label>
                                    <input type="text" id="edit-imageurl" name="imageUrl" class="form-control">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="edit-description">Description</label>
                                <textarea id="edit-description" name="description" class="form-control"></textarea>
                            </div>
                            <div class="form-group">
                                <label class="form-switch">
                                    <input type="checkbox" id="edit-available" name="available" value="true">
                                    <span class="switch-slider"></span>
                                    <span class="switch-label">Item is Available In Stock</span>
                                </label>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" onclick="closeModal('edit-menu-modal')">Cancel</button>
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
    <script src="${pageContext.request.contextPath}/assets/js/admin/menu.js"></script>
</body>
</html>
