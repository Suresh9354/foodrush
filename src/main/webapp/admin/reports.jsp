<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.food.dao.*, com.food.daoimpl.*, com.food.model.*, java.util.*" %>
<%
    request.setAttribute("activePage", "reports");

    RestaurantDAO restaurantDAO = new RestaurantDAOImpl();
    OrderDAO orderDAO = new OrderDAOImpl();
    UserDAO userDAO = new UserDAOImpl();

    List<Restaurant> allRestaurants = null;
    List<Order> allOrders = null;
    List<User> allUsers = null;
    boolean isDbConnected = true;

    try {
        allRestaurants = restaurantDAO.getAllRestaurants();
        allOrders = orderDAO.getAllOrders();
        allUsers = userDAO.getAllUsers();
        if (allRestaurants == null || allOrders == null || allUsers == null) {
            isDbConnected = false;
        }
    } catch (Exception e) {
        isDbConnected = false;
    }

    if (allRestaurants == null) allRestaurants = new ArrayList<>();
    if (allOrders == null) allOrders = new ArrayList<>();
    if (allUsers == null) allUsers = new ArrayList<>();

    // Primary Metric Aggregators
    double totalRevenue = 0;
    int totalOrdersCount = allOrders.size();
    int activeUsersCount = allUsers.size();
    int cancelledOrdersCount = 0;
    int deliveredOrdersCount = 0;
    int preparingOrdersCount = 0;
    int deliveryOrdersCount = 0;

    // Database Payment Method aggregators
    int payOnline = 0;
    int payCod = 0;
    int payWallet = 0;

    for (Order o : allOrders) {
        if (!"Cancelled".equalsIgnoreCase(o.getStatus())) {
            totalRevenue += o.getTotalAmount();
            if ("Delivered".equalsIgnoreCase(o.getStatus())) {
                deliveredOrdersCount++;
            } else if ("Out for Delivery".equalsIgnoreCase(o.getStatus())) {
                deliveryOrdersCount++;
            } else {
                preparingOrdersCount++; // PLACED, Preparing, Pending go here
            }
        } else {
            cancelledOrdersCount++;
        }

        // Payment Method breakdown
        String pm = o.getPaymentMethod();
        if (pm != null) {
            if (pm.toLowerCase().contains("online") || pm.toLowerCase().contains("card") || pm.toLowerCase().contains("upi")) {
                payOnline++;
            } else if (pm.toLowerCase().contains("cod") || pm.toLowerCase().contains("cash")) {
                payCod++;
            } else {
                payWallet++;
            }
        } else {
            payCod++;
        }
    }

    // Average Order Value (AOV)
    double avgOrderValue = totalOrdersCount == 0 ? 0 : totalRevenue / (totalOrdersCount - cancelledOrdersCount > 0 ? (totalOrdersCount - cancelledOrdersCount) : 1);

    // Dynamic Top Restaurants by Revenue
    List<Map<String, Object>> topRestList = new ArrayList<>();
    if (isDbConnected && totalOrdersCount > 0) {
        try (java.sql.Connection conn = com.food.util.DBConnection.getConnection();
             java.sql.PreparedStatement ps = conn.prepareStatement(
                 "SELECT r.name, SUM(oi.price * oi.quantity) AS revenue " +
                 "FROM orders o " +
                 "JOIN order_items oi ON o.order_id = oi.order_id " +
                 "JOIN menu_items m ON oi.menu_id = m.menu_id " +
                 "JOIN restaurants r ON m.restaurant_id = r.restaurant_id " +
                 "WHERE o.status != 'Cancelled' " +
                 "GROUP BY r.restaurant_id, r.name " +
                 "ORDER BY revenue DESC LIMIT 5")) {
            try (java.sql.ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("name", rs.getString("name"));
                    map.put("revenue", rs.getDouble("revenue"));
                    topRestList.add(map);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Dynamic Category Sales
    List<Map<String, Object>> categorySales = new ArrayList<>();
    if (isDbConnected && totalOrdersCount > 0) {
        try (java.sql.Connection conn = com.food.util.DBConnection.getConnection();
             java.sql.PreparedStatement ps = conn.prepareStatement(
                 "SELECT m.category, SUM(oi.price * oi.quantity) AS revenue, COUNT(DISTINCT o.order_id) AS orders_count " +
                 "FROM orders o " +
                 "JOIN order_items oi ON o.order_id = oi.order_id " +
                 "JOIN menu_items m ON oi.menu_id = m.menu_id " +
                 "WHERE o.status != 'Cancelled' " +
                 "GROUP BY m.category " +
                 "ORDER BY revenue DESC LIMIT 4")) {
            try (java.sql.ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("category", rs.getString("category"));
                    map.put("revenue", rs.getDouble("revenue"));
                    map.put("count", rs.getInt("orders_count"));
                    categorySales.add(map);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Daily revenue & order trends for last 7 days (No mock defaults, only original data)
    Calendar cal = Calendar.getInstance();
    java.text.SimpleDateFormat sdfLabel = new java.text.SimpleDateFormat("dd MMM");
    java.text.SimpleDateFormat sdfComp = new java.text.SimpleDateFormat("yyyy-MM-dd");

    String[] dayLabels = new String[7];
    double[] dailyRevenues = new double[7];
    int[] dailyOrders = new int[7];

    for (int i = 6; i >= 0; i--) {
        cal.setTime(new Date());
        cal.add(Calendar.DATE, -i);
        Date d = cal.getTime();
        dayLabels[6 - i] = sdfLabel.format(d);
        
        dailyRevenues[6 - i] = 0.0;
        dailyOrders[6 - i] = 0;
        
        if (isDbConnected) {
            String dateStr = sdfComp.format(d);
            try (java.sql.Connection conn = com.food.util.DBConnection.getConnection();
                 java.sql.PreparedStatement ps = conn.prepareStatement(
                     "SELECT COUNT(*) AS total_count, SUM(total_amount) AS total_revenue " +
                     "FROM orders WHERE DATE(order_date) = ? AND status != 'Cancelled'")) {
                ps.setString(1, dateStr);
                try (java.sql.ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        int c = rs.getInt("total_count");
                        double r = rs.getDouble("total_revenue");
                        dailyOrders[6 - i] = c;
                        dailyRevenues[6 - i] = r;
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    // Calculate maximum values for charts scaling
    double maxRevenueVal = 1000;
    for (double r : dailyRevenues) {
        if (r > maxRevenueVal) maxRevenueVal = r;
    }
    double maxOrdersVal = 10;
    for (int o : dailyOrders) {
        if (o > maxOrdersVal) maxOrdersVal = o;
    }

    // Recent orders list
    List<Map<String, Object>> recentOrders = new ArrayList<>();
    if (isDbConnected) {
        try (java.sql.Connection conn = com.food.util.DBConnection.getConnection();
             java.sql.PreparedStatement ps = conn.prepareStatement(
                 "SELECT o.order_id, u.name AS customer_name, r.name AS restaurant_name, o.total_amount, o.payment_method, o.status, o.order_date " +
                 "FROM orders o " +
                 "JOIN users u ON o.user_id = u.user_id " +
                 "LEFT JOIN order_items oi ON o.order_id = oi.order_id " +
                 "LEFT JOIN menu_items m ON oi.menu_id = m.menu_id " +
                 "LEFT JOIN restaurants r ON m.restaurant_id = r.restaurant_id " +
                 "GROUP BY o.order_id " +
                 "ORDER BY o.order_date DESC LIMIT 5")) {
            try (java.sql.ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("orderId", rs.getInt("order_id"));
                    map.put("customerName", rs.getString("customer_name"));
                    map.put("restaurantName", rs.getString("restaurant_name") != null ? rs.getString("restaurant_name") : "N/A");
                    map.put("totalAmount", rs.getDouble("total_amount"));
                    map.put("paymentMethod", rs.getString("payment_method") != null ? rs.getString("payment_method") : "Online Payment");
                    map.put("status", rs.getString("status"));
                    map.put("orderDate", rs.getTimestamp("order_date"));
                    recentOrders.add(map);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FoodRush Admin | Reports & Analytics</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/admin-global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/table.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/forms.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/buttons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/responsive.css">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/reports.css">
</head>
<body>
    <div class="admin-layout">
        <jsp:include page="/components/sidebar.jsp" />
        
        <div class="main-content">
            <jsp:include page="/components/topbar.jsp" />
            
            <div class="content-wrapper">
                <!-- 6 Stats Cards Row -->
                <div class="reports-stats-grid">
                    <!-- Card 1: Revenue -->
                    <div class="stat-card-micro">
                        <div class="stat-card-micro-left">
                            <div class="stat-icon-wrapper-micro orange">
                                <i class="bi bi-currency-rupee"></i>
                            </div>
                            <div class="micro-details">
                                <span class="micro-label">Total Revenue</span>
                                <h2 class="micro-value">₹<%= String.format("%,d", (int)totalRevenue) %></h2>
                                <span class="micro-trend green">
                                    <i class="bi bi-arrow-up-short"></i> 18.6% 
                                    <span class="micro-trend-text">from last week</span>
                                </span>
                            </div>
                        </div>
                        <div class="stat-chart-micro">
                            <svg width="45" height="24" viewBox="0 0 45 24">
                                <path d="M0,18 Q11,8 22,14 T45,4" fill="none" stroke="#FF5A1F" stroke-width="1.8"></path>
                            </svg>
                        </div>
                    </div>
                    
                    <!-- Card 2: Total Orders -->
                    <div class="stat-card-micro">
                        <div class="stat-card-micro-left">
                            <div class="stat-icon-wrapper-micro green">
                                <i class="bi bi-bag-check"></i>
                            </div>
                            <div class="micro-details">
                                <span class="micro-label">Total Orders</span>
                                <h2 class="micro-value"><%= String.format("%,d", totalOrdersCount) %></h2>
                                <span class="micro-trend green">
                                    <i class="bi bi-arrow-up-short"></i> 16.2% 
                                    <span class="micro-trend-text">from last week</span>
                                </span>
                            </div>
                        </div>
                        <div class="stat-chart-micro">
                            <svg width="45" height="24" viewBox="0 0 45 24">
                                <path d="M0,20 Q11,10 22,16 T45,6" fill="none" stroke="#10B981" stroke-width="1.8"></path>
                            </svg>
                        </div>
                    </div>

                    <!-- Card 3: Avg Order Value -->
                    <div class="stat-card-micro">
                        <div class="stat-card-micro-left">
                            <div class="stat-icon-wrapper-micro yellow">
                                <i class="bi bi-credit-card-2-front"></i>
                            </div>
                            <div class="micro-details">
                                <span class="micro-label">Average Order Value</span>
                                <h2 class="micro-value">₹<%= String.format("%,d", (int)avgOrderValue) %></h2>
                                <span class="micro-trend green">
                                    <i class="bi bi-arrow-up-short"></i> 9.8% 
                                    <span class="micro-trend-text">from last week</span>
                                </span>
                            </div>
                        </div>
                        <div class="stat-chart-micro">
                            <svg width="45" height="24" viewBox="0 0 45 24">
                                <path d="M0,15 Q11,20 22,8 T45,12" fill="none" stroke="#F59E0B" stroke-width="1.8"></path>
                            </svg>
                        </div>
                    </div>

                    <!-- Card 4: Total Customers -->
                    <div class="stat-card-micro">
                        <div class="stat-card-micro-left">
                            <div class="stat-icon-wrapper-micro blue">
                                <i class="bi bi-people"></i>
                            </div>
                            <div class="micro-details">
                                <span class="micro-label">Total Customers</span>
                                <h2 class="micro-value"><%= String.format("%,d", activeUsersCount) %></h2>
                                <span class="micro-trend green">
                                    <i class="bi bi-arrow-up-short"></i> 14.4% 
                                    <span class="micro-trend-text">from last week</span>
                                </span>
                            </div>
                        </div>
                        <div class="stat-chart-micro">
                            <svg width="45" height="24" viewBox="0 0 45 24">
                                <path d="M0,18 Q11,14 22,16 T45,4" fill="none" stroke="#3B82F6" stroke-width="1.8"></path>
                            </svg>
                        </div>
                    </div>



                    <!-- Card 6: Cancelled Orders -->
                    <div class="stat-card-micro">
                        <div class="stat-card-micro-left">
                            <div class="stat-icon-wrapper-micro red">
                                <i class="bi bi-x-circle"></i>
                            </div>
                            <div class="micro-details">
                                <span class="micro-label">Cancelled Orders</span>
                                <h2 class="micro-value"><%= String.format("%,d", cancelledOrdersCount) %></h2>
                                <span class="micro-trend red">
                                    <i class="bi bi-arrow-down-short"></i> 5.6% 
                                    <span class="micro-trend-text">from last week</span>
                                </span>
                            </div>
                        </div>
                        <div class="stat-chart-micro">
                            <svg width="45" height="24" viewBox="0 0 45 24">
                                <path d="M0,12 Q11,18 22,8 T45,20" fill="none" stroke="#EF4444" stroke-width="1.8"></path>
                            </svg>
                        </div>
                    </div>
                </div>

                <!-- Advanced Filter Bar -->
                <div class="table-filter-bar">
                    <div class="filter-group-left">
                        <select id="report-date-filter" class="filter-select" style="min-width: 190px;">
                            <option value="july">03 Jul 2025 - 09 Jul 2025</option>
                            <option value="today">Today</option>
                            <option value="yesterday">Yesterday</option>
                            <option value="week" selected>Last 7 Days</option>
                            <option value="month">Last 30 Days</option>
                        </select>
                        <select id="report-restaurant-filter" class="filter-select">
                            <option value="all">All Restaurants</option>
                            <% for(Restaurant r : allRestaurants) { %>
                                <option value="<%= r.getRestaurantId() %>"><%= r.getName() %></option>
                            <% } %>
                            <% if(allRestaurants.isEmpty()) { %>
                                <option value="1">KFC</option>
                                <option value="2">Dominos Pizza</option>
                                <option value="3">Burger King</option>
                            <% } %>
                        </select>
                        <select id="report-category-filter" class="filter-select">
                            <option value="all">All Categories</option>
                            <option value="main">Main Course</option>
                            <option value="snacks">Snacks</option>
                            <option value="beverages">Beverages</option>
                            <option value="desserts">Desserts</option>
                        </select>
                        <select id="report-payment-filter" class="filter-select">
                            <option value="all">All Payment Methods</option>
                            <option value="online">Online Payment</option>
                            <option value="cod">COD</option>
                            <option value="wallet">Wallet</option>
                        </select>
                        <button class="btn btn-secondary" onclick="resetFilters()">Reset</button>
                    </div>
                    <button class="btn btn-primary" onclick="exportReport()" style="background-color: #FF5A1F; border-color: #FF5A1F;">
                        <i class="bi bi-download"></i> Export Report
                    </button>
                </div>

                <!-- Charts Row (Revenue & Orders) -->
                <div class="charts-row-dual">
                    <!-- Daily Revenue Area Chart -->
                    <div class="chart-card-full">
                        <div class="chart-card-header">
                            <h3 class="chart-card-title">Revenue Overview</h3>
                            <select class="chart-card-dropdown">
                                <option value="daily">Daily</option>
                                <option value="weekly">Weekly</option>
                            </select>
                        </div>
                        <div style="width: 100%; height: 160px; overflow: hidden; display: flex; align-items: flex-end;">
                            <svg width="100%" height="150" viewBox="0 0 500 150" preserveAspectRatio="none" style="overflow: visible;">
                                <defs>
                                    <linearGradient id="revGrad" x1="0" y1="0" x2="0" y2="1">
                                        <stop offset="0%" stop-color="#FF5A1F" stop-opacity="0.3"></stop>
                                        <stop offset="100%" stop-color="#FF5A1F" stop-opacity="0.0"></stop>
                                    </linearGradient>
                                </defs>
                                <!-- Grid Lines -->
                                <line x1="30" y1="30" x2="470" y2="30" stroke="#F1F2F4" stroke-dasharray="4,4"></line>
                                <line x1="30" y1="80" x2="470" y2="80" stroke="#F1F2F4" stroke-dasharray="4,4"></line>
                                <line x1="30" y1="130" x2="470" y2="130" stroke="#E5E7EB" stroke-width="1"></line>
                                
                                <% 
                                    StringBuilder revPath = new StringBuilder("M ");
                                    StringBuilder revAreaPath = new StringBuilder("M 30,130 ");
                                    double stepX = 440.0 / 6.0;
                                    for (int i = 0; i < 7; i++) {
                                        double x = 30 + i * stepX;
                                        double y = 130 - (dailyRevenues[i] / maxRevenueVal) * 100.0;
                                        if (i == 0) {
                                            revPath.append(x).append(",").append(y);
                                        } else {
                                            revPath.append(" L ").append(x).append(",").append(y);
                                        }
                                        revAreaPath.append(" L ").append(x).append(",").append(y);
                                    }
                                    revAreaPath.append(" L 470,130 Z");
                                %>
                                <!-- Area path -->
                                <path d="<%= revAreaPath.toString() %>" fill="url(#revGrad)"></path>
                                <!-- Line path -->
                                <path d="<%= revPath.toString() %>" fill="none" stroke="#FF5A1F" stroke-width="2.5"></path>
                                
                                <!-- Tooltip dots & labels -->
                                <% 
                                    for (int i = 0; i < 7; i++) {
                                        double x = 30 + i * stepX;
                                        double y = 130 - (dailyRevenues[i] / maxRevenueVal) * 100.0;
                                %>
                                    <circle cx="<%= x %>" cy="<%= y %>" r="4.5" fill="#FF5A1F" stroke="#FFFFFF" stroke-width="2" style="cursor: pointer;"></circle>
                                    <text x="<%= x %>" y="<%= y - 10 %>" text-anchor="middle" font-size="8.5" font-family="'Outfit'" font-weight="600" fill="#1F2937">₹<%= String.format("%,d", (int)(dailyRevenues[i]/1000)) %>k</text>
                                    <text x="<%= x %>" y="145" text-anchor="middle" font-size="9" font-family="'Outfit'" font-weight="500" fill="#9CA3AF"><%= dayLabels[i] %></text>
                                <% } %>
                            </svg>
                        </div>
                    </div>

                    <!-- Daily Orders Area Chart -->
                    <div class="chart-card-full">
                        <div class="chart-card-header">
                            <h3 class="chart-card-title">Orders Overview</h3>
                            <select class="chart-card-dropdown">
                                <option value="daily">Daily</option>
                                <option value="weekly">Weekly</option>
                            </select>
                        </div>
                        <div style="width: 100%; height: 160px; overflow: hidden; display: flex; align-items: flex-end;">
                            <svg width="100%" height="150" viewBox="0 0 500 150" preserveAspectRatio="none" style="overflow: visible;">
                                <defs>
                                    <linearGradient id="ordGrad" x1="0" y1="0" x2="0" y2="1">
                                        <stop offset="0%" stop-color="#10B981" stop-opacity="0.3"></stop>
                                        <stop offset="100%" stop-color="#10B981" stop-opacity="0.0"></stop>
                                    </linearGradient>
                                </defs>
                                <!-- Grid Lines -->
                                <line x1="30" y1="30" x2="470" y2="30" stroke="#F1F2F4" stroke-dasharray="4,4"></line>
                                <line x1="30" y1="80" x2="470" y2="80" stroke="#F1F2F4" stroke-dasharray="4,4"></line>
                                <line x1="30" y1="130" x2="470" y2="130" stroke="#E5E7EB" stroke-width="1"></line>
                                
                                <% 
                                    StringBuilder ordPath = new StringBuilder("M ");
                                    StringBuilder ordAreaPath = new StringBuilder("M 30,130 ");
                                    for (int i = 0; i < 7; i++) {
                                        double x = 30 + i * stepX;
                                        double y = 130 - (dailyOrders[i] / maxOrdersVal) * 100.0;
                                        if (i == 0) {
                                            ordPath.append(x).append(",").append(y);
                                        } else {
                                            ordPath.append(" L ").append(x).append(",").append(y);
                                        }
                                        ordAreaPath.append(" L ").append(x).append(",").append(y);
                                    }
                                    ordAreaPath.append(" L 470,130 Z");
                                %>
                                <!-- Area path -->
                                <path d="<%= ordAreaPath.toString() %>" fill="url(#ordGrad)"></path>
                                <!-- Line path -->
                                <path d="<%= ordPath.toString() %>" fill="none" stroke="#10B981" stroke-width="2.5"></path>
                                
                                <!-- Tooltip dots & labels -->
                                <% 
                                    for (int i = 0; i < 7; i++) {
                                        double x = 30 + i * stepX;
                                        double y = 130 - (dailyOrders[i] / maxOrdersVal) * 100.0;
                                %>
                                    <circle cx="<%= x %>" cy="<%= y %>" r="4.5" fill="#10B981" stroke="#FFFFFF" stroke-width="2" style="cursor: pointer;"></circle>
                                    <text x="<%= x %>" y="<%= y - 10 %>" text-anchor="middle" font-size="8.5" font-family="'Outfit'" font-weight="600" fill="#1F2937"><%= dailyOrders[i] %></text>
                                    <text x="<%= x %>" y="145" text-anchor="middle" font-size="9" font-family="'Outfit'" font-weight="500" fill="#9CA3AF"><%= dayLabels[i] %></text>
                                <% } %>
                            </svg>
                        </div>
                    </div>
                </div>

                <!-- Three Column Analytics Row -->
                <div class="analytics-row-triple">
                    <!-- Column 1: Orders by Status Donut -->
                    <div class="analytics-card">
                        <div class="analytics-card-header">Orders by Status</div>
                        <%
                            double statusDelPct = totalOrdersCount == 0 ? 0 : (deliveredOrdersCount * 100.0) / totalOrdersCount;
                            double statusPrepPct = totalOrdersCount == 0 ? 0 : (preparingOrdersCount * 100.0) / totalOrdersCount;
                            double statusOufPct = totalOrdersCount == 0 ? 0 : (deliveryOrdersCount * 100.0) / totalOrdersCount;
                            double statusCanPct = totalOrdersCount == 0 ? 0 : (cancelledOrdersCount * 100.0) / totalOrdersCount;

                            double s1 = statusDelPct;
                            double s2 = s1 + statusPrepPct;
                            double s3 = s2 + statusOufPct;
                        %>
                        <div class="donut-container">
                            <div class="donut-circle" style="background: conic-gradient(var(--success) 0% <%= s1 %>%, var(--warning) <%= s1 %>% <%= s2 %>%, var(--info) <%= s2 %>% <%= s3 %>%, var(--danger) <%= s3 %>% 100%);">
                                <div class="donut-circle-label">
                                    <span class="donut-center-val"><%= String.format("%,d", totalOrdersCount) %></span>
                                    <span class="donut-center-lbl">Total Orders</span>
                                </div>
                            </div>
                            <div class="donut-legend">
                                <div class="legend-item">
                                    <div class="legend-key-wrapper">
                                        <div class="legend-color-dot" style="background-color: var(--success);"></div>
                                        <span class="legend-label-text">Delivered</span>
                                    </div>
                                    <span class="legend-val-pct"><%= String.format("%.1f%%", statusDelPct) %> <span class="legend-val-num">(<%= deliveredOrdersCount %>)</span></span>
                                </div>
                                <div class="legend-item">
                                    <div class="legend-key-wrapper">
                                        <div class="legend-color-dot" style="background-color: var(--warning);"></div>
                                        <span class="legend-label-text">Preparing</span>
                                    </div>
                                    <span class="legend-val-pct"><%= String.format("%.1f%%", statusPrepPct) %> <span class="legend-val-num">(<%= preparingOrdersCount %>)</span></span>
                                </div>
                                <div class="legend-item">
                                    <div class="legend-key-wrapper">
                                        <div class="legend-color-dot" style="background-color: var(--info);"></div>
                                        <span class="legend-label-text">Out for Delivery</span>
                                    </div>
                                    <span class="legend-val-pct"><%= String.format("%.1f%%", statusOufPct) %> <span class="legend-val-num">(<%= deliveryOrdersCount %>)</span></span>
                                </div>
                                <div class="legend-item">
                                    <div class="legend-key-wrapper">
                                        <div class="legend-color-dot" style="background-color: var(--danger);"></div>
                                        <span class="legend-label-text">Cancelled</span>
                                    </div>
                                    <span class="legend-val-pct"><%= String.format("%.1f%%", statusCanPct) %> <span class="legend-val-num">(<%= cancelledOrdersCount %>)</span></span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Column 2: Top Restaurants Progress List -->
                    <div class="analytics-card">
                        <div class="analytics-card-header" style="display: flex; justify-content: space-between; align-items: center;">
                            <span>Top Restaurants by Revenue</span>
                            <a href="${pageContext.request.contextPath}/admin/restaurants.jsp" style="font-size: 0.75rem; font-weight: 600; color: var(--primary-color); text-decoration: none;">View All</a>
                        </div>
                        <div class="progress-list">
                            <%
                                double highestRestRevenue = 100;
                                if (!topRestList.isEmpty()) {
                                    highestRestRevenue = (Double) topRestList.get(0).get("revenue");
                                }
                                int rank = 1;
                                for (Map<String, Object> rMap : topRestList) {
                                    String name = (String) rMap.get("name");
                                    double rev = (Double) rMap.get("revenue");
                                    double pct = (rev * 100.0) / highestRestRevenue;
                                    
                                    String color = "var(--primary-color)";
                                    if (rank == 1) color = "linear-gradient(90deg, #FF5A1F, #FF7E40)";
                                    else if (rank == 2) color = "linear-gradient(90deg, #F59E0B, #FBBF24)";
                                    else if (rank == 3) color = "linear-gradient(90deg, #3B82F6, #60A5FA)";
                                    else if (rank == 4) color = "linear-gradient(90deg, #10B981, #34D399)";
                                    else color = "#6B7280";
                            %>
                                <div class="progress-item-wrapper">
                                    <div class="progress-item-header">
                                        <span class="progress-item-name">
                                            <span class="progress-item-rank"><%= rank %>.</span>
                                            <%= name %>
                                        </span>
                                        <span class="progress-item-val">₹<%= String.format("%,d", (int)rev) %></span>
                                    </div>
                                    <div class="progress-bar-container">
                                        <div class="progress-bar-fill" style="width: <%= pct %>%; background: <%= color %>;"></div>
                                    </div>
                                </div>
                            <%
                                    rank++;
                                }
                            %>
                        </div>
                    </div>

                    <!-- Column 3: Orders by Payment Method Donut -->
                    <div class="analytics-card">
                        <div class="analytics-card-header">Orders by Payment Method</div>
                        <%
                            double onlinePct = totalOrdersCount == 0 ? 0 : (payOnline * 100.0) / totalOrdersCount;
                            double codPct = totalOrdersCount == 0 ? 0 : (payCod * 100.0) / totalOrdersCount;
                            double walletPct = totalOrdersCount == 0 ? 0 : (payWallet * 100.0) / totalOrdersCount;

                            double p1 = onlinePct;
                            double p2 = p1 + codPct;
                        %>
                        <div class="donut-container">
                            <div class="donut-circle" style="background: conic-gradient(var(--success) 0% <%= p1 %>%, var(--info) <%= p1 %>% <%= p2 %>%, var(--warning) <%= p2 %>% 100%);">
                                <div class="donut-circle-label">
                                    <span class="donut-center-val"><%= String.format("%,d", totalOrdersCount) %></span>
                                    <span class="donut-center-lbl">Total Orders</span>
                                </div>
                            </div>
                            <div class="donut-legend">
                                <div class="legend-item">
                                    <div class="legend-key-wrapper">
                                        <div class="legend-color-dot" style="background-color: var(--success);"></div>
                                        <span class="legend-label-text">Online Payment</span>
                                    </div>
                                    <span class="legend-val-pct"><%= String.format("%.1f%%", onlinePct) %> <span class="legend-val-num">(<%= payOnline %>)</span></span>
                                </div>
                                <div class="legend-item">
                                    <div class="legend-key-wrapper">
                                        <div class="legend-color-dot" style="background-color: var(--info);"></div>
                                        <span class="legend-label-text">COD</span>
                                    </div>
                                    <span class="legend-val-pct"><%= String.format("%.1f%%", codPct) %> <span class="legend-val-num">(<%= payCod %>)</span></span>
                                </div>
                                <div class="legend-item">
                                    <div class="legend-key-wrapper">
                                        <div class="legend-color-dot" style="background-color: var(--warning);"></div>
                                        <span class="legend-label-text">Wallet</span>
                                    </div>
                                    <span class="legend-val-pct"><%= String.format("%.1f%%", walletPct) %> <span class="legend-val-num">(<%= payWallet %>)</span></span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Bottom Row: Recent Orders & Category Sales -->
                <div class="bottom-grid-layout">
                    <!-- Recent Orders Overview Table -->
                    <div class="bottom-card-container">
                        <div class="recent-orders-header">
                            <h3 class="chart-card-title">Recent Orders Overview</h3>
                            <a href="${pageContext.request.contextPath}/admin/orders.jsp" class="btn btn-secondary btn-sm" style="font-size: 0.8rem; padding: 6px 12px; text-decoration: none;">
                                View All Orders
                            </a>
                        </div>
                        <div class="table-container" style="box-shadow: none; border-radius: 8px;">
                            <table class="admin-table">
                                <thead>
                                    <tr>
                                        <th>Order ID</th>
                                        <th>Customer</th>
                                        <th>Restaurant</th>
                                        <th>Amount</th>
                                        <th>Payment Method</th>
                                        <th>Status</th>
                                        <th>Date & Time</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (Map<String, Object> oMap : recentOrders) { 
                                        int oId = (Integer) oMap.get("orderId");
                                        String cust = (String) oMap.get("customerName");
                                        String rest = (String) oMap.get("restaurantName");
                                        double amt = (Double) oMap.get("totalAmount");
                                        String pm = (String) oMap.get("paymentMethod");
                                        String st = (String) oMap.get("status");
                                        java.sql.Timestamp oDate = (java.sql.Timestamp) oMap.get("orderDate");
                                        
                                        String statusClass = st != null ? st.toLowerCase().replace(" ", "-") : "delivered";
                                        String formattedDate = oDate != null ? new java.text.SimpleDateFormat("dd MMM yyyy, hh:mm a").format(oDate) : "N/A";
                                    %>
                                        <tr>
                                            <td style="font-weight: 600; color: var(--text-muted);">#FR<%= oId %></td>
                                            <td style="font-weight: 500;"><%= cust %></td>
                                            <td><%= rest %></td>
                                            <td style="font-weight: 600; color: var(--text-color);">₹<%= String.format("%.2f", amt) %></td>
                                            <td>
                                                <span style="font-size: 0.82rem; display: inline-flex; align-items: center; gap: 4px;">
                                                    <i class="bi <%= pm.toLowerCase().contains("cod") ? "bi-cash-coin" : "bi-credit-card" %>"></i>
                                                    <%= pm %>
                                                </span>
                                            </td>
                                            <td>
                                                <span class="report-status-badge <%= statusClass %>"><%= st %></span>
                                            </td>
                                            <td style="font-size: 0.82rem; color: var(--text-muted);"><%= formattedDate %></td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Sales by Category Donut -->
                    <div class="bottom-card-container">
                        <div class="analytics-card-header" style="margin-bottom: 8px;">Sales by Category</div>
                        <%
                            double totalCatRevenue = 0;
                            for (Map<String, Object> cMap : categorySales) {
                                totalCatRevenue += (Double) cMap.get("revenue");
                            }
                            if (totalCatRevenue == 0) totalCatRevenue = 1;

                            double c1 = categorySales.size() > 0 ? ((Double)categorySales.get(0).get("revenue") * 100.0) / totalCatRevenue : 0;
                            double c2 = c1 + (categorySales.size() > 1 ? ((Double)categorySales.get(1).get("revenue") * 100.0) / totalCatRevenue : 0);
                            double c3 = c2 + (categorySales.size() > 2 ? ((Double)categorySales.get(2).get("revenue") * 100.0) / totalCatRevenue : 0);
                        %>
                        <div class="donut-container" style="flex-direction: column; gap: 16px;">
                            <div class="donut-circle" style="width: 120px; height: 120px; background: conic-gradient(#8B5CF6 0% <%= c1 %>%, #3B82F6 <%= c1 %>% <%= c2 %>%, #F59E0B <%= c2 %>% <%= c3 %>%, #EF4444 <%= c3 %>% 100%);">
                                <div class="donut-circle-label">
                                    <span class="donut-center-val" style="font-size: 1.05rem;">₹<%= String.format("%,d", (int)totalCatRevenue) %></span>
                                    <span class="donut-center-lbl" style="font-size: 0.6rem;">Total Sales</span>
                                </div>
                            </div>
                            <div class="donut-legend" style="width: 100%; padding: 0 10px;">
                                <%
                                    String[] colors = {"#8B5CF6", "#3B82F6", "#F59E0B", "#EF4444"};
                                    int ci = 0;
                                    for (Map<String, Object> cMap : categorySales) {
                                        String cat = (String) cMap.get("category");
                                        double rev = (Double) cMap.get("revenue");
                                        double pct = (rev * 100.0) / totalCatRevenue;
                                        String clr = colors[ci % colors.length];
                                %>
                                    <div class="legend-item">
                                        <div class="legend-key-wrapper">
                                            <div class="legend-color-dot" style="background-color: <%= clr %>;"></div>
                                            <span class="legend-label-text"><%= cat %></span>
                                        </div>
                                        <span class="legend-val-pct"><%= String.format("%.1f%%", pct) %> <span class="legend-val-num">(₹<%= String.format("%,d", (int)rev) %>)</span></span>
                                    </div>
                                <%
                                        ci++;
                                    }
                                %>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <jsp:include page="/components/footer.jsp" />
        </div>
    </div>

    <div id="report-data"
         data-total-revenue="<%= (int)totalRevenue %>"
         data-total-orders="<%= totalOrdersCount %>"
         data-avg-order-value="<%= (int)avgOrderValue %>"
         data-active-users="<%= activeUsersCount %>"
         data-cancelled-orders="<%= cancelledOrdersCount %>"
         data-top-restaurants='[
            <% int cr = 0; for (Map<String, Object> rMap : topRestList) { 
                if (cr > 0) out.print(","); %>
                {"name": "<%= rMap.get("name").toString().replace("\"", "\\\"") %>", "revenue": <%= rMap.get("revenue") %>}
            <% cr++; } %>
         ]'
         data-category-sales='[
            <% int cc = 0; for (Map<String, Object> cMap : categorySales) { 
                if (cc > 0) out.print(","); %>
                {"category": "<%= cMap.get("category").toString().replace("\"", "\\\"") %>", "count": <%= cMap.get("count") %>, "revenue": <%= cMap.get("revenue") %>}
            <% cc++; } %>
         ]'></div>

    <script src="${pageContext.request.contextPath}/assets/js/admin/sidebar.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/admin/reports.js"></script>
</body>
</html>
