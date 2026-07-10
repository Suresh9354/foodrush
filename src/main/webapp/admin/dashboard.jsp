<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.food.dao.*, com.food.daoimpl.*, com.food.model.*, java.util.*" %>
<%
    request.setAttribute("activePage", "dashboard");

    RestaurantDAO restaurantDAO = new RestaurantDAOImpl();
    UserDAO userDAO = new UserDAOImpl();
    OrderDAO orderDAO = new OrderDAOImpl();

    List<Restaurant> allRestaurants = null;
    List<User> allUsers = null;
    List<Order> allOrders = null;
    boolean isDbConnected = true;

    try {
        allRestaurants = restaurantDAO.getAllRestaurants();
        allUsers = userDAO.getAllUsers();
        allOrders = orderDAO.getAllOrders();
        
        if (allRestaurants == null || allUsers == null || allOrders == null) {
            isDbConnected = false;
        }
    } catch (Exception e) {
        isDbConnected = false;
    }

    // Ensure lists are initialized (empty) if database connection fails, to prevent JSP crashes
    if (allRestaurants == null) allRestaurants = new ArrayList<>();
    if (allUsers == null) allUsers = new ArrayList<>();
    if (allOrders == null) allOrders = new ArrayList<>();

    double totalRevenue = 0;
    int todayOrdersCount = 0;
    int pendingOrdersCount = 0;
    
    int deliveredCount = 0;
    int preparingCount = 0;
    int deliveryCount = 0;
    int cancelledCount = 0;
    
    for (Order o : allOrders) {
        if ("Delivered".equalsIgnoreCase(o.getStatus())) {
            totalRevenue += o.getTotalAmount();
            deliveredCount++;
        } else if ("Preparing".equalsIgnoreCase(o.getStatus())) {
            preparingCount++;
            pendingOrdersCount++;
        } else if ("Out for Delivery".equalsIgnoreCase(o.getStatus())) {
            deliveryCount++;
            pendingOrdersCount++;
        } else if ("Cancelled".equalsIgnoreCase(o.getStatus())) {
            cancelledCount++;
        } else if ("Pending".equalsIgnoreCase(o.getStatus())) {
            preparingCount++; // Group pending under preparing for overview chart
            pendingOrdersCount++;
        }
        
        if (o.getOrderDate() != null && System.currentTimeMillis() - o.getOrderDate().getTime() < 86400000L) {
            todayOrdersCount++;
        }
    }
    
    int totalRestCount = allRestaurants.size();
    int totalUsersCount = allUsers.size();
    int totalCount = allOrders.size();
    
    double deliveredPct = totalCount == 0 ? 0 : (deliveredCount * 100.0) / totalCount;
    double preparingPct = totalCount == 0 ? 0 : (preparingCount * 100.0) / totalCount;
    double deliveryPct = totalCount == 0 ? 0 : (deliveryCount * 100.0) / totalCount;
    double cancelledPct = totalCount == 0 ? 0 : (cancelledCount * 100.0) / totalCount;

    // Calculate last 7 days metrics
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd MMM");
    Calendar cal = Calendar.getInstance();
    String[] dayLabels = new String[7];
    int[] dailyOrderCounts = new int[7];
    double[] dailyRevenues = new double[7];
    
    for (int i = 6; i >= 0; i--) {
        cal.setTime(new Date());
        cal.add(Calendar.DATE, -i);
        Date d = cal.getTime();
        dayLabels[6 - i] = sdf.format(d);
        
        int count = 0;
        double rev = 0;
        
        java.text.SimpleDateFormat sdfComp = new java.text.SimpleDateFormat("yyyy-MM-dd");
        String dateStr = sdfComp.format(d);
        
        for (Order o : allOrders) {
            if (o.getOrderDate() != null) {
                String oDateStr = sdfComp.format(o.getOrderDate());
                if (dateStr.equals(oDateStr)) {
                    count++;
                    if ("Delivered".equalsIgnoreCase(o.getStatus())) {
                        rev += o.getTotalAmount();
                    }
                }
            }
        }
        dailyOrderCounts[6 - i] = count;
        dailyRevenues[6 - i] = rev;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FoodRush | Admin Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/admin-global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/table.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/forms.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/buttons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin/responsive.css">
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
                        <span><strong>Database Connection Unreachable.</strong> FoodRush is currently operating in demo sandbox mode. Changes will be saved in your session.</span>
                    </div>
                <% } %>
                
                <!-- Stats Grid -->
                <div class="stats-grid">
                    <!-- Total Orders -->
                    <div class="stat-card">
                        <div class="stat-left">
                            <div class="stat-icon-box orders">
                                <i class="bi bi-bag-fill"></i>
                            </div>
                            <div class="stat-details">
                                <span class="stat-label">Total Orders</span>
                                <div class="stat-value"><%= String.format("%,d", allOrders.size()) %></div>
                                <div class="stat-trend up">
                                    <i class="bi bi-arrow-up-short"></i> 18.6% <span class="stat-trend-time">from last week</span>
                                </div>
                            </div>
                        </div>
                        <div class="stat-right">
                            <svg class="stat-sparkline" viewBox="0 0 80 30" fill="none">
                                <path d="M0,15 Q15,5 30,22 T60,8 T80,18" stroke="#FF5A1F" stroke-width="2" stroke-linecap="round"/>
                            </svg>
                        </div>
                    </div>
                    
                    <!-- Total Revenue -->
                    <div class="stat-card">
                        <div class="stat-left">
                            <div class="stat-icon-box revenue">
                                <i class="bi bi-currency-rupee"></i>
                            </div>
                            <div class="stat-details">
                                <span class="stat-label">Total Revenue</span>
                                <div class="stat-value">&#8377;<%= String.format("%,d", (int)totalRevenue) %></div>
                                <div class="stat-trend up">
                                    <i class="bi bi-arrow-up-short"></i> 22.4% <span class="stat-trend-time">from last week</span>
                                </div>
                            </div>
                        </div>
                        <div class="stat-right">
                            <svg class="stat-sparkline" viewBox="0 0 80 30" fill="none">
                                <path d="M0,20 Q15,10 30,25 T60,5 T80,12" stroke="#10B981" stroke-width="2" stroke-linecap="round"/>
                            </svg>
                        </div>
                    </div>
                    
                    <!-- Total Users -->
                    <div class="stat-card">
                        <div class="stat-left">
                            <div class="stat-icon-box users">
                                <i class="bi bi-people-fill"></i>
                            </div>
                            <div class="stat-details">
                                <span class="stat-label">Total Users</span>
                                <div class="stat-value"><%= String.format("%,d", allUsers.size()) %></div>
                                <div class="stat-trend up">
                                    <i class="bi bi-arrow-up-short"></i> 15.3% <span class="stat-trend-time">from last week</span>
                                </div>
                            </div>
                        </div>
                        <div class="stat-right">
                            <svg class="stat-sparkline" viewBox="0 0 80 30" fill="none">
                                <path d="M0,25 Q15,15 30,20 T60,10 T80,5" stroke="#8B5CF6" stroke-width="2" stroke-linecap="round"/>
                            </svg>
                        </div>
                    </div>
                    
                    <!-- Total Restaurants -->
                    <div class="stat-card">
                        <div class="stat-left">
                            <div class="stat-icon-box restaurants">
                                <i class="bi bi-shop"></i>
                            </div>
                            <div class="stat-details">
                                <span class="stat-label">Total Restaurants</span>
                                <div class="stat-value"><%= totalRestCount %></div>
                                <div class="stat-trend up">
                                    <i class="bi bi-arrow-up-short"></i> 12.8% <span class="stat-trend-time">from last week</span>
                                </div>
                            </div>
                        </div>
                        <div class="stat-right">
                            <svg class="stat-sparkline" viewBox="0 0 80 30" fill="none">
                                <path d="M0,10 Q15,25 30,12 T60,22 T80,8" stroke="#3B82F6" stroke-width="2" stroke-linecap="round"/>
                            </svg>
                        </div>
                    </div>
                </div>
                
                <!-- Middle Grid: Order Line Chart, Top Restaurants, and Recent Orders -->
                <div class="dashboard-middle-grid">
                    <!-- Order Overview Chart Card -->
                    <div class="dashboard-panel chart-panel">
                        <div class="panel-header">
                            <h3>Order Overview</h3>
                            <div class="panel-header-filter">
                                <span>This Week</span>
                                <i class="bi bi-chevron-down"></i>
                            </div>
                        </div>
                        <div class="chart-wrapper">
                            <canvas id="orderOverviewChart"
                                    data-labels='["<%= dayLabels[0] %>", "<%= dayLabels[1] %>", "<%= dayLabels[2] %>", "<%= dayLabels[3] %>", "<%= dayLabels[4] %>", "<%= dayLabels[5] %>", "<%= dayLabels[6] %>"]'
                                    data-values='[<%= dailyOrderCounts[0] %>, <%= dailyOrderCounts[1] %>, <%= dailyOrderCounts[2] %>, <%= dailyOrderCounts[3] %>, <%= dailyOrderCounts[4] %>, <%= dailyOrderCounts[5] %>, <%= dailyOrderCounts[6] %>]'></canvas>
                        </div>
                    </div>
                    
                    <!-- Top Restaurants Card -->
                    <div class="dashboard-panel top-restaurants-panel">
                        <div class="panel-header">
                            <h3>Top Restaurants</h3>
                            <a href="${pageContext.request.contextPath}/admin/restaurants.jsp" class="panel-action">View All</a>
                        </div>
                        <div class="top-restaurants-list">
                            <!-- KFC -->
                            <div class="top-restaurant-item">
                                <span class="restaurant-rank">1</span>
                                <img src="https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=60&h=60" alt="KFC" class="restaurant-logo">
                                <div class="restaurant-info">
                                    <span class="restaurant-name">KFC</span>
                                    <span class="restaurant-orders">325 orders</span>
                                </div>
                                <div class="restaurant-revenue-trend">
                                    <span class="restaurant-rev">&#8377;86,250</span>
                                    <span class="restaurant-trend up"><i class="bi bi-arrow-up-short"></i> 20.5%</span>
                                </div>
                            </div>
                            <!-- Dominos Pizza -->
                            <div class="top-restaurant-item">
                                <span class="restaurant-rank">2</span>
                                <img src="https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=60&h=60" alt="Dominos Pizza" class="restaurant-logo">
                                <div class="restaurant-info">
                                    <span class="restaurant-name">Dominos Pizza</span>
                                    <span class="restaurant-orders">298 orders</span>
                                </div>
                                <div class="restaurant-revenue-trend">
                                    <span class="restaurant-rev">&#8377;75,650</span>
                                    <span class="restaurant-trend up"><i class="bi bi-arrow-up-short"></i> 18.2%</span>
                                </div>
                            </div>
                            <!-- Burger King -->
                            <div class="top-restaurant-item">
                                <span class="restaurant-rank">3</span>
                                <img src="https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=60&h=60" alt="Burger King" class="restaurant-logo">
                                <div class="restaurant-info">
                                    <span class="restaurant-name">Burger King</span>
                                    <span class="restaurant-orders">276 orders</span>
                                </div>
                                <div class="restaurant-revenue-trend">
                                    <span class="restaurant-rev">&#8377;62,340</span>
                                    <span class="restaurant-trend up"><i class="bi bi-arrow-up-short"></i> 15.6%</span>
                                </div>
                            </div>
                            <!-- Meghana Foods -->
                            <div class="top-restaurant-item">
                                <span class="restaurant-rank">4</span>
                                <img src="https://images.unsplash.com/photo-1633945274405-b6c8069047b0?auto=format&fit=crop&w=60&h=60" alt="Meghana Foods" class="restaurant-logo">
                                <div class="restaurant-info">
                                    <span class="restaurant-name">Meghana Foods</span>
                                    <span class="restaurant-orders">241 orders</span>
                                </div>
                                <div class="restaurant-revenue-trend">
                                    <span class="restaurant-rev">&#8377;51,230</span>
                                    <span class="restaurant-trend up"><i class="bi bi-arrow-up-short"></i> 14.1%</span>
                                </div>
                            </div>
                            <!-- Barbeque Nation -->
                            <div class="top-restaurant-item">
                                <span class="restaurant-rank">5</span>
                                <img src="https://images.unsplash.com/photo-1544787219-7f47ccb76574?auto=format&fit=crop&w=60&h=60" alt="Barbeque Nation" class="restaurant-logo">
                                <div class="restaurant-info">
                                    <span class="restaurant-name">Barbeque Nation</span>
                                    <span class="restaurant-orders">198 orders</span>
                                </div>
                                <div class="restaurant-revenue-trend">
                                    <span class="restaurant-rev">&#8377;48,750</span>
                                    <span class="restaurant-trend up"><i class="bi bi-arrow-up-short"></i> 11.3%</span>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Recent Orders Card with Food Images -->
                    <div class="dashboard-panel recent-orders-panel">
                        <div class="panel-header">
                            <h3>Recent Orders</h3>
                            <a href="${pageContext.request.contextPath}/admin/orders.jsp" class="panel-action">View All</a>
                        </div>
                        <div class="recent-orders-list">
                            <%
                                int orderIdx = 0;
                                for (Order o : allOrders) {
                                    orderIdx++;
                                    if (orderIdx > 5) break; // Limit to 5
                                    
                                    String restaurantName = "KFC";
                                    String foodImg = "https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=60&h=60"; // Pizza Hut or KFC mockup
                                    if (orderIdx == 2) {
                                        restaurantName = "Dominos Pizza";
                                        foodImg = "https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=60&h=60";
                                    } else if (orderIdx == 3) {
                                        restaurantName = "Burger King";
                                        foodImg = "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=60&h=60";
                                    } else if (orderIdx == 4) {
                                        restaurantName = "Meghana Foods";
                                        foodImg = "https://images.unsplash.com/photo-1633945274405-b6c8069047b0?auto=format&fit=crop&w=60&h=60";
                                    } else if (orderIdx == 5) {
                                        restaurantName = "Starbucks";
                                        foodImg = "https://images.unsplash.com/photo-1544787219-7f47ccb76574?auto=format&fit=crop&w=60&h=60";
                                    }
                                    
                                    String statusClass = o.getStatus().toLowerCase().replace(" ", "_");
                            %>
                            <div class="recent-order-item">
                                <div class="recent-order-left">
                                    <img src="<%= foodImg %>" alt="Food Item" class="recent-order-food-img">
                                    <div class="recent-order-info">
                                        <span class="recent-order-id">#FR<%= 12560 + o.getOrderId() %></span>
                                        <span class="recent-order-restaurant"><%= restaurantName %></span>
                                    </div>
                                </div>
                                <div class="recent-order-right">
                                    <span class="recent-order-amount">&#8377;<%= (int) o.getTotalAmount() %></span>
                                    <span class="recent-order-status-badge <%= statusClass %>"><%= o.getStatus() %></span>
                                </div>
                            </div>
                            <%
                                }
                                if (allOrders.isEmpty()) {
                            %>
                            <div class="empty-list-state">
                                <i class="bi bi-inbox"></i>
                                <p>No orders placed today.</p>
                            </div>
                            <%
                                }
                            %>
                        </div>
                    </div>
                </div>
                
                <!-- Bottom Grid: Order Status Overview, Revenue Overview, and Quick Actions -->
                <div class="dashboard-bottom-grid">
                    <!-- Order Status Overview Donut Chart Card -->
                    <div class="dashboard-panel order-status-panel">
                        <div class="panel-header">
                            <h3>Order Status Overview</h3>
                        </div>
                        <div class="order-status-content">
                            <div class="donut-chart-container">
                                <canvas id="orderStatusChart"
                                        data-delivered="<%= deliveredCount %>"
                                        data-preparing="<%= preparingCount %>"
                                        data-delivery="<%= deliveryCount %>"
                                        data-cancelled="<%= cancelledCount %>"></canvas>
                                <div class="chart-center-text">
                                    <span class="chart-center-number"><%= String.format("%,d", totalCount) %></span>
                                    <span class="chart-center-label">Total</span>
                                </div>
                            </div>
                            
                            <div class="donut-legend">
                                <div class="legend-item">
                                    <span class="legend-dot delivered"></span>
                                    <span class="legend-label">Delivered</span>
                                    <span class="legend-count"><%= String.format("%,d (%.1f%%)", deliveredCount, deliveredPct) %></span>
                                </div>
                                <div class="legend-item">
                                    <span class="legend-dot preparing"></span>
                                    <span class="legend-label">Preparing</span>
                                    <span class="legend-count"><%= String.format("%,d (%.1f%%)", preparingCount, preparingPct) %></span>
                                </div>
                                <div class="legend-item">
                                    <span class="legend-dot delivery"></span>
                                    <span class="legend-label">Out for Delivery</span>
                                    <span class="legend-count"><%= String.format("%,d (%.1f%%)", deliveryCount, deliveryPct) %></span>
                                </div>
                                <div class="legend-item">
                                    <span class="legend-dot cancelled"></span>
                                    <span class="legend-label">Cancelled</span>
                                    <span class="legend-count"><%= String.format("%,d (%.1f%%)", cancelledCount, cancelledPct) %></span>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Revenue Overview Bar Chart Card -->
                    <div class="dashboard-panel revenue-panel">
                        <div class="panel-header">
                            <div class="revenue-header-title">
                                <h3>Revenue Overview</h3>
                                <span class="revenue-subtitle">Total Revenue</span>
                                <h2 class="revenue-value">&#8377;<%= String.format("%,d", (int)totalRevenue) %></h2>
                                <span class="revenue-trend-badge"><i class="bi bi-arrow-up-short"></i> <%= String.format("%.1f%%", deliveredPct) %> <span class="trend-time">delivered</span></span>
                            </div>
                            <div class="panel-header-filter">
                                <span>This Week</span>
                                <i class="bi bi-chevron-down"></i>
                            </div>
                        </div>
                        <div class="chart-wrapper">
                            <canvas id="revenueOverviewChart"
                                    data-labels='["<%= dayLabels[0] %>", "<%= dayLabels[1] %>", "<%= dayLabels[2] %>", "<%= dayLabels[3] %>", "<%= dayLabels[4] %>", "<%= dayLabels[5] %>", "<%= dayLabels[6] %>"]'
                                    data-values='[<%= (int)dailyRevenues[0] %>, <%= (int)dailyRevenues[1] %>, <%= (int)dailyRevenues[2] %>, <%= (int)dailyRevenues[3] %>, <%= (int)dailyRevenues[4] %>, <%= (int)dailyRevenues[5] %>, <%= (int)dailyRevenues[6] %>]'></canvas>
                        </div>
                    </div>
                    
                    <!-- Quick Actions Grid Card -->
                    <div class="dashboard-panel quick-actions-panel">
                        <div class="panel-header">
                            <h3>Quick Actions</h3>
                        </div>
                        <div class="quick-actions-grid">
                            <div class="quick-action-btn orders" onclick="window.location.href='${pageContext.request.contextPath}/admin/restaurants.jsp?openAdd=true'">
                                <div class="action-icon-box orange">
                                    <i class="bi bi-shop"></i>
                                </div>
                                <span>Add Restaurant</span>
                            </div>
                            <div class="quick-action-btn menu" onclick="window.location.href='${pageContext.request.contextPath}/admin/menu.jsp?openAdd=true'">
                                <div class="action-icon-box green">
                                    <i class="bi bi-egg-fried"></i>
                                </div>
                                <span>Add Menu Item</span>
                            </div>
                            <div class="quick-action-btn categories" onclick="alert('Categories panel coming soon!');">
                                <div class="action-icon-box purple">
                                    <i class="bi bi-grid-3x3-gap"></i>
                                </div>
                                <span>Add Category</span>
                            </div>
                            <div class="quick-action-btn notifications" onclick="alert('Notification panel coming soon!');">
                                <div class="action-icon-box blue">
                                    <i class="bi bi-bell"></i>
                                </div>
                                <span>Send Notification</span>
                            </div>
                            <div class="quick-action-btn reports" onclick="window.location.href='${pageContext.request.contextPath}/admin/reports.jsp'">
                                <div class="action-icon-box red">
                                    <i class="bi bi-bar-chart-line"></i>
                                </div>
                                <span>View Reports</span>
                            </div>
                            <div class="quick-action-btn settings" onclick="window.location.href='${pageContext.request.contextPath}/admin/settings.jsp'">
                                <div class="action-icon-box grey">
                                    <i class="bi bi-gear"></i>
                                </div>
                                <span>System Settings</span>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Recent Activities Horizontal Ticker Ticker Row -->
                <div class="dashboard-panel recent-activities-ticker-card">
                    <div class="ticker-title">Recent Activities</div>
                    <div class="ticker-content">
                        <%
                            int actIdx = 0;
                            for (Order o : allOrders) {
                                actIdx++;
                                if (actIdx > 3) break;
                                String timeAgo = "recently";
                                if (o.getOrderDate() != null) {
                                    long diffMs = System.currentTimeMillis() - o.getOrderDate().getTime();
                                    long mins = diffMs / 60000L;
                                    if (mins < 1) {
                                        timeAgo = "just now";
                                    } else if (mins < 60) {
                                        timeAgo = mins + " mins ago";
                                    } else {
                                        timeAgo = (mins / 60) + " hours ago";
                                    }
                                }
                        %>
                        <div class="ticker-item">
                            <span class="ticker-dot orange"></span>
                            <span class="ticker-text">New order <strong>#FR<%= 12560 + o.getOrderId() %></strong> of <strong>&#8377;<%= (int)o.getTotalAmount() %></strong> received (<%= o.getStatus() %>) <span class="ticker-time"><%= timeAgo %></span></span>
                        </div>
                        <%
                            }
                            int userIdx = 0;
                            for (User u : allUsers) {
                                userIdx++;
                                if (userIdx > 2) break;
                                String timeAgo = "recently";
                                if (u.getCreatedAt() != null) {
                                    long diffMs = System.currentTimeMillis() - u.getCreatedAt().getTime();
                                    long mins = diffMs / 60000L;
                                    if (mins < 1) {
                                        timeAgo = "just now";
                                    } else if (mins < 60) {
                                        timeAgo = mins + " mins ago";
                                    } else {
                                        timeAgo = (mins / 60) + " hours ago";
                                    }
                                }
                        %>
                        <div class="ticker-item">
                            <span class="ticker-dot green"></span>
                            <span class="ticker-text">New user <strong><%= u.getName() %></strong> registered <span class="ticker-time"><%= timeAgo %></span></span>
                        </div>
                        <%
                            }
                            if (allOrders.isEmpty() && allUsers.isEmpty()) {
                        %>
                        <div class="ticker-item">
                            <span class="ticker-dot blue"></span>
                            <span class="ticker-text">No recent platform activities logged.</span>
                        </div>
                        <%
                            }
                        %>
                    </div>
                </div>
            </div>
            
            <jsp:include page="/components/footer.jsp" />
        </div>
    </div>
    
    <script src="${pageContext.request.contextPath}/assets/js/admin/sidebar.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/admin/dashboard.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/admin/dashboard-page.js"></script>
</body>
</html>
