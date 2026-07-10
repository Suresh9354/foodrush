<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String activePage = (String) request.getAttribute("activePage");
    if (activePage == null) {
        activePage = "";
    }
%>
<aside class="sidebar">
    <div class="sidebar-brand">
        <a href="${pageContext.request.contextPath}/admin/dashboard.jsp" class="sidebar-logo">
            <img src="${pageContext.request.contextPath}/assets/images/logo/logo.png" alt="Logo" style="width: 32px; height: 32px; object-fit: contain; margin-right: 4px;">
            <span class="sidebar-logo-text">
                <span class="brand-name">FoodRush</span>
                <span class="brand-sub">Admin Panel</span>
            </span>
        </a>
    </div>
    
    <div class="sidebar-menu">
        <ul class="sidebar-menu-list">
            <li class="sidebar-menu-item <%= "dashboard".equals(activePage) ? "active" : "" %>">
                <a href="${pageContext.request.contextPath}/admin/dashboard.jsp">
                    <i class="bi bi-grid-fill"></i>
                    <span>Dashboard</span>
                </a>
            </li>
            
            <li class="sidebar-menu-item <%= "orders".equals(activePage) ? "active" : "" %>">
                <a href="${pageContext.request.contextPath}/admin/orders.jsp">
                    <i class="bi bi-receipt"></i>
                    <span>Orders</span>
                </a>
            </li>
            
            <li class="sidebar-menu-item <%= "restaurants".equals(activePage) ? "active" : "" %>">
                <a href="${pageContext.request.contextPath}/admin/restaurants.jsp">
                    <i class="bi bi-shop"></i>
                    <span>Restaurants</span>
                </a>
            </li>
            
            <li class="sidebar-menu-item <%= "menu".equals(activePage) ? "active" : "" %>">
                <a href="${pageContext.request.contextPath}/admin/menu.jsp">
                    <i class="bi bi-journal-text"></i>
                    <span>Menu Management</span>
                </a>
            </li>
            
            <li class="sidebar-menu-item <%= "users".equals(activePage) ? "active" : "" %>">
                <a href="${pageContext.request.contextPath}/admin/users.jsp">
                    <i class="bi bi-people"></i>
                    <span>Users</span>
                </a>
            </li>
                   
            <li class="sidebar-menu-item <%= "reports".equals(activePage) ? "active" : "" %>">
                <a href="${pageContext.request.contextPath}/admin/reports.jsp">
                    <i class="bi bi-bar-chart-line"></i>
                    <span>Reports & Analytics</span>
                </a>
            </li>
                 
            <li class="sidebar-menu-item <%= "settings".equals(activePage) ? "active" : "" %>">
                <a href="${pageContext.request.contextPath}/admin/settings.jsp">
                    <i class="bi bi-gear"></i>
                    <span>Settings</span>
                </a>
            </li>
        </ul>
        
        <!-- Promo Widget Card matching mockup -->
        <div class="sidebar-promo-card">
            <div class="sidebar-promo-illustration">
                <img src="${pageContext.request.contextPath}/assets/images/logo/dashboardlogo.png" alt="Dashboard Logo" style="max-height: 150%; max-width: 140%; object-fit: contain; border-radius: 6px;">
            </div>
            <p>Manage your food delivery platform efficiently</p>
        </div>
    </div>
    
    <div class="sidebar-footer">
        <a href="${pageContext.request.contextPath}/logout" class="btn-logout">
            <i class="bi bi-box-arrow-left"></i>
            <span>Logout</span>
        </a>
    </div>
</aside>
<div class="sidebar-overlay"></div>
