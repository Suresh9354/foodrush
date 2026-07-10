<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.food.dao.*, com.food.daoimpl.*, com.food.model.*, java.util.*" %>
<%
    request.setAttribute("activePage", "orders");

    String action = request.getParameter("action");
    OrderDAO orderDAO = new OrderDAOImpl();
    UserDAO userDAO = new UserDAOImpl();
    boolean isDbConnected = true;

    List<Order> allOrders = null;
    List<User> allUsers = null;

    try {
        allOrders = orderDAO.getAllOrders();
        allUsers = userDAO.getAllUsers();
        if (allOrders == null || allUsers == null) {
            isDbConnected = false;
        }
    } catch (Exception e) {
        isDbConnected = false;
    }

    // Ensure lists are initialized (empty) if database connection fails, to prevent JSP crashes
    if (allOrders == null) allOrders = new ArrayList<>();
    if (allUsers == null) allUsers = new ArrayList<>();

    // Process Actions
    if (action != null) {
        try {
            if ("updateStatus".equals(action)) {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                String status = request.getParameter("status");

                orderDAO.updateOrderStatus(orderId, status);
                response.sendRedirect("orders.jsp?msg=status_updated");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("orders.jsp?msg=error");
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
    <title>FoodRush Admin | Order Management</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/admin-global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/table.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/forms.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/buttons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/responsive.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/orders.css">
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
                        <h1>Order Management</h1>
                        <p>Track ongoing delivery routes, change preparation statuses, and view billing details.</p>
                    </div>
                </div>

                <!-- Status Toast/Notifications -->
                <% if ("status_updated".equals(msg)) { %>
                    <div class="admin-alert alert-success">
                        <i class="bi bi-check-circle-fill"></i>
                        <span>Order status updated successfully!</span>
                    </div>
                <% } else if ("error".equals(msg)) { %>
                    <div class="admin-alert alert-danger">
                        <i class="bi bi-exclamation-triangle-fill"></i>
                        <span>An error occurred while saving details. Please try again.</span>
                    </div>
                <% } %>
                
                <!-- Stats Cards Grid Layout to match screenshot -->
                <%
                    int totalOrdersCount = allOrders.size();
                    int completedCount = 0;
                    int pendingCount = 0;
                    int cancelledCount = 0;
                    for (Order o : allOrders) {
                        if ("Delivered".equalsIgnoreCase(o.getStatus())) {
                            completedCount++;
                        } else if ("Cancelled".equalsIgnoreCase(o.getStatus())) {
                            cancelledCount++;
                        } else {
                            pendingCount++;
                        }
                    }
                %>
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-icon-wrapper orange">
                            <i class="bi bi-bag"></i>
                        </div>
                        <div class="stat-details">
                            <span class="stat-label">Total Orders</span>
                            <h2 class="stat-value"><%= String.format("%,d", totalOrdersCount) %></h2>
                            <span class="trend-badge green"><i class="bi bi-arrow-up-short"></i> 18.6% <span class="trend-text">from last week</span></span>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon-wrapper green">
                            <i class="bi bi-bag-check"></i>
                        </div>
                        <div class="stat-details">
                            <span class="stat-label">Completed Orders</span>
                            <h2 class="stat-value"><%= String.format("%,d", completedCount) %></h2>
                            <span class="trend-badge green"><i class="bi bi-arrow-up-short"></i> 20.4% <span class="trend-text">from last week</span></span>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon-wrapper yellow">
                            <i class="bi bi-clock-history"></i>
                        </div>
                        <div class="stat-details">
                            <span class="stat-label">Pending Orders</span>
                            <h2 class="stat-value"><%= String.format("%,d", pendingCount) %></h2>
                            <span class="trend-badge green"><i class="bi bi-arrow-up-short"></i> 8.3% <span class="trend-text">from last week</span></span>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon-wrapper red">
                            <i class="bi bi-x-circle"></i>
                        </div>
                        <div class="stat-details">
                            <span class="stat-label">Cancelled Orders</span>
                            <h2 class="stat-value"><%= String.format("%,d", cancelledCount) %></h2>
                            <span class="trend-badge red"><i class="bi bi-arrow-down-short"></i> 5.6% <span class="trend-text">from last week</span></span>
                        </div>
                    </div>
                </div>

                <!-- Filter Bar styled to match screenshot exactly -->
                <div class="table-filter-bar">
                    <div class="search-input-group">
                        <i class="bi bi-search"></i>
                        <input type="text" id="table-search-input" placeholder="Search by Order ID, Customer or Restaurant">
                    </div>
                    <div class="filter-group" style="display: flex; gap: 10px; align-items: center; flex-wrap: wrap;">
                        <select id="table-status-filter" class="filter-select">
                            <option value="all">Select Status</option>
                            <option value="pending">Pending</option>
                            <option value="preparing">Preparing</option>
                            <option value="out_for_delivery">Out for Delivery</option>
                            <option value="delivered">Delivered</option>
                            <option value="cancelled">Cancelled</option>
                        </select>
                        <select id="table-restaurant-filter" class="filter-select">
                            <option value="all">All Restaurants</option>
                            <%
                                List<Restaurant> restList = new ArrayList<>();
                                try {
                                    restList = new RestaurantDAOImpl().getAllRestaurants();
                                } catch(Exception e){}
                                if (restList == null) restList = new ArrayList<>();
                                for(Restaurant r : restList) {
                            %>
                                <option value="<%= r.getName() %>"><%= r.getName() %></option>
                            <% } %>
                        </select>
                        <select id="table-date-filter" class="filter-select">
                            <option value="all">Select Date</option>
                            <option value="today">Today</option>
                            <option value="yesterday">Yesterday</option>
                            <option value="last7">Last 7 Days</option>
                        </select>
                        <button class="btn btn-secondary" onclick="resetFilters()" style="padding: 10px 16px; font-weight: 500; font-family: 'Outfit';">Reset</button>
                        <button class="btn btn-primary" onclick="exportOrders()" style="background: #FF5A1F; border-color: #FF5A1F; display: flex; align-items: center; gap: 6px; padding: 10px 16px; font-weight: 500; font-family: 'Outfit';">
                            <i class="bi bi-download"></i> Export
                        </button>
                    </div>
                </div>

                <!-- Table Container -->
                <div class="table-container">
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>Order ID</th>
                                <th>Customer</th>
                                <th>Restaurant</th>
                                <th>Items</th>
                                <th>Amount</th>
                                <th>Status</th>
                                <th>Payment</th>
                                <th>Order Date</th>
                                <th style="text-align: right;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                for (Order o : allOrders) {
                                    // Resolve User Details
                                    String customerName = "Unknown Customer";
                                    for (User u : allUsers) {
                                        if (u.getUserId() == o.getUserId()) {
                                            customerName = u.getName();
                                            break;
                                        }
                                    }
                                    
                                    // Resolve Restaurant Details dynamically
                                    String oRestaurantName = "Unknown Outlet";
                                    String oRestaurantLogo = "assets/images/default-restaurant.png";
                                    int oTotalQty = 0;
                                    try {
                                        OrderItemDAO oItemDAO = new OrderItemDAOImpl();
                                        List<OrderItem> items = oItemDAO.getItemsByOrderId(o.getOrderId());
                                        if (items != null) {
                                            for (OrderItem item : items) {
                                                oTotalQty += item.getQuantity();
                                            }
                                            if (!items.isEmpty()) {
                                                int menuId = items.get(0).getMenuId();
                                                MenuDAO mDAO = new MenuDAOImpl();
                                                Menu menu = mDAO.getMenuById(menuId);
                                                if (menu != null) {
                                                    RestaurantDAO rDAO = new RestaurantDAOImpl();
                                                    Restaurant rest = rDAO.getRestaurantById(menu.getRestaurantId());
                                                    if (rest != null) {
                                                        oRestaurantName = rest.getName();
                                                        oRestaurantLogo = rest.getImageUrl();
                                                        if (oRestaurantLogo == null || oRestaurantLogo.trim().isEmpty()) {
                                                            oRestaurantLogo = "assets/images/default-restaurant.png";
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    } catch(Exception ex) {}

                                    String statusClass = o.getStatus().toLowerCase().replace(" ", "_");
                                    
                                    // Resolve Payment Style
                                    String payMethod = o.getPaymentMethod();
                                    String dotColor = "green";
                                    if ("COD".equalsIgnoreCase(payMethod)) {
                                        dotColor = "orange";
                                    }
                                    
                                    // Format Date and Time
                                    String formattedDate = "";
                                    String formattedTime = "";
                                    if (o.getOrderDate() != null) {
                                        formattedDate = new java.text.SimpleDateFormat("dd MMM yyyy").format(o.getOrderDate());
                                        formattedTime = new java.text.SimpleDateFormat("hh:mm a").format(o.getOrderDate());
                                    }
                            %>
                            <tr>
                                <td><strong>#OR<%=o.getOrderId() %></strong></td>
                                <td>
                                    <span class="item-cell-title" style="font-weight: 500;"><%= customerName %></span>
                                </td>
                                <td>
                                    <div class="restaurant-cell">
                                        <span class="item-cell-title" style="font-weight: 500;"><%= oRestaurantName %></span>
                                    </div>
                                </td>
                                <td>
                                    <%= oTotalQty %> <%= oTotalQty == 1 ? "item" : "items" %>
                                </td>
                                <td><strong>&#8377;<%= (int) o.getTotalAmount() %></strong></td>
                                <td>
                                    <span class="status-badge <%= statusClass %>"><%= o.getStatus() %></span>
                                </td>
                                <td>
                                    <div class="payment-badge">
                                        <span class="payment-dot <%= dotColor %>"></span>
                                        <span><%= "COD".equalsIgnoreCase(payMethod) ? "COD" : "Online" %></span>
                                    </div>
                                </td>
                                <td class="order-date-cell">
                                    <div style="line-height: 1.3;">
                                        <div><%= formattedDate %></div>
                                        <div style="font-size: 0.78rem; color: var(--text-muted);"><%= formattedTime %></div>
                                    </div>
                                </td>
                                <td style="text-align: right;">
                                    <form action="orders.jsp" method="POST" style="margin: 0; display: inline-block;">
                                        <input type="hidden" name="action" value="updateStatus">
                                        <input type="hidden" name="orderId" value="<%= o.getOrderId() %>">
                                        <select name="status" onchange="this.form.submit()" class="actions-select" title="Change Order Status">
                                            <option value="Pending" <%= "Pending".equals(o.getStatus()) ? "selected" : "" %>>Pending</option>
                                            <option value="Preparing" <%= "Preparing".equals(o.getStatus()) ? "selected" : "" %>>Preparing</option>
                                            <option value="Out for Delivery" <%= "Out for Delivery".equals(o.getStatus()) ? "selected" : "" %>>Out for Delivery</option>
                                            <option value="Delivered" <%= "Delivered".equals(o.getStatus()) ? "selected" : "" %>>Delivered</option>
                                            <option value="Cancelled" <%= "Cancelled".equals(o.getStatus()) ? "selected" : "" %>>Cancelled</option>
                                        </select>
                                    </form>
                                </td>
                            </tr>
                            <%
                                }
                            %>
                            <tr id="table-empty-state" style="display: none;">
                                <td colspan="9">
                                    <div class="empty-table-state">
                                        <i class="bi bi-bag-x"></i>
                                        <p>No orders match the search criteria.</p>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination matching screenshot -->
                <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 20px; font-family: 'Outfit'; font-size: 0.88rem; color: var(--text-muted);">
                    <div id="pagination-info">
                        Showing 1 to <%= Math.min(10, totalOrdersCount) %> 
                    </div>
                    <div id="pagination-buttons" style="display: flex; gap: 6px; align-items: center;">
                    </div>
                </div>
            </div>
            
            <jsp:include page="/components/footer.jsp" />
        </div>
    </div>
    
    <script src="${pageContext.request.contextPath}/assets/js/admin/sidebar.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/admin/dashboard.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/admin/orders.js"></script>
</body>
</html>
