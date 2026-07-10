<%@ page import="com.food.dao.*, com.food.daoimpl.*, com.food.model.*, java.util.*" %>
<%
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    String adminName = (loggedInUser != null) ? loggedInUser.getName() : "Admin";
    String adminRole = (loggedInUser != null && "admin".equalsIgnoreCase(loggedInUser.getRole())) ? "Super Admin" : "Super Admin";
    String firstLetter = adminName.isEmpty() ? "A" : adminName.substring(0, 1).toUpperCase();
    
    // Determine dynamic page title and subtitle matching layout
    String activePage = (String) request.getAttribute("activePage");
    String title = "Dashboard";
    String subtitle = "Overview of your FoodRush platform";
    
    if ("restaurants".equals(activePage)) {
        title = "Restaurants";
        subtitle = "Configure outlet locations, menu bindings, ratings, and operating statuses";
    } else if ("menu".equals(activePage)) {
        title = "Menu Management";
        subtitle = "Configure menu items, prices, classifications, and availabilities";
    } else if ("orders".equals(activePage)) {
        title = "Orders";
        subtitle = "Monitor, dispatch, and track active client delivery requests";
    } else if ("users".equals(activePage)) {
        title = "Users";
        subtitle = "View registered profiles, contact details, and account authorization privileges";
    } else if ("reports".equals(activePage)) {
        title = "Reports & Analytics";
        subtitle = "Track platform revenue, order distributions, and system statistics";
    } else if ("settings".equals(activePage)) {
        title = "Settings";
        subtitle = "Manage administrator credentials, profile details, and platform preferences";
    }

    // Dynamic date range (last 7 days)
    java.text.SimpleDateFormat sdfRange = new java.text.SimpleDateFormat("dd MMM yyyy");
    Calendar calRange = Calendar.getInstance();
    Date today = new Date();
    calRange.add(Calendar.DATE, -6);
    Date sixDaysAgo = calRange.getTime();
    String dateRangeStr = sdfRange.format(sixDaysAgo) + " - " + sdfRange.format(today);

    // Dynamic notification count (pending orders)
    int notificationCount = 0;
    try {
        OrderDAO topbarOrderDAO = new OrderDAOImpl();
        List<Order> topbarOrders = topbarOrderDAO.getAllOrders();
        if (topbarOrders != null) {
            for (Order o : topbarOrders) {
                if ("Pending".equalsIgnoreCase(o.getStatus()) || "Preparing".equalsIgnoreCase(o.getStatus()) || "Out for Delivery".equalsIgnoreCase(o.getStatus())) {
                    notificationCount++;
                }
            }
        }
    } catch (Exception e) {
        notificationCount = 0;
    }
%>
<header class="topbar">
    <div class="topbar-left">
        <button id="mobile-sidebar-toggle" title="Toggle Sidebar">
            <i class="bi bi-list"></i>
        </button>
        <div class="topbar-title-block">
            <h1 class="topbar-title"><%= title %></h1>
            <p class="topbar-subtitle"><%= subtitle %></p>
        </div>
    </div>
    
    <div class="topbar-right">
        <!-- Date Selector Filter Group -->
        <div class="topbar-date" title="Select Date Range">
            <i class="bi bi-calendar3"></i>
            <span id="topbar-date-range"><%= dateRangeStr %></span>
            <i class="bi bi-chevron-down" style="font-size: 0.72rem; margin-left: 2px;"></i>
        </div>
        
        <!-- Notifications bell matching layout with count '8' badge -->
        <div class="topbar-notifications" title="Notifications" onclick="alert('No new system alerts.');">
            <i class="bi bi-bell"></i>
            <span class="notification-badge"><%= notificationCount %></span>
        </div>
        
        <div class="topbar-profile" onclick="window.location.href='${pageContext.request.contextPath}/admin/settings.jsp'" title="Admin Profile">
            <div class="topbar-profile-avatar-wrapper">
                <div class="topbar-profile-initials" style="display: flex;"><%= firstLetter %></div>
            </div>
            <div class="topbar-profile-info">
                <span class="topbar-profile-name"><%= adminName %></span>
                <span class="topbar-profile-role"><%= adminRole %></span>
            </div>
        </div>
    </div>
</header>
