<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.food.model.User" %>
<%@ page import="com.food.model.Cart" %>
<%@ page import="com.food.model.CartItem" %>
<%
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    Cart navbarCart = (Cart) session.getAttribute("cart");
    int navbarCartCount = 0;
    if (navbarCart != null && navbarCart.getCartItems() != null) {
        for (CartItem item : navbarCart.getItems()) {
            navbarCartCount += item.getQuantity();
        }
    }
%>
<nav class="navbar">
    <div class="logo">
        <a href="${pageContext.request.contextPath}/home">
            <svg class="logo-svg" viewBox="0 0 48 48" fill="none" xmlns="http://www.w3.org/2000/svg">
                <!-- Orange delivery cloche with speed lines -->
                <path d="M8 32H40C41.1 32 42 31.1 42 30V28H6V30C6 31.1 6.9 32 8 32Z" fill="var(--primary-color)" />
                <path d="M24 10C15.16 10 8 17.16 8 26H40C40 17.16 32.84 10 24 10Z" fill="var(--primary-color)" />
                <circle cx="24" cy="7" r="3" fill="var(--primary-color)" />
                <path d="M4 18H1" stroke="var(--primary-color)" stroke-width="3" stroke-linecap="round"/>
                <path d="M6 22H2" stroke="var(--primary-color)" stroke-width="3" stroke-linecap="round"/>
                <path d="M5 14H2" stroke="var(--primary-color)" stroke-width="3" stroke-linecap="round"/>
            </svg>
            <span class="logo-text">FoodRush</span>
        </a>
    </div>

    <ul class="nav-links">
        <li><a href="${pageContext.request.contextPath}/home" class="active">Home</a></li>
        <li><a href="${pageContext.request.contextPath}/home#categories">Categories</a></li>
        <li><a href="${pageContext.request.contextPath}/home#restaurant">Restaurants</a></li>
        <li><a href="${pageContext.request.contextPath}/home#offers">Offers</a></li>
        <li><a href="${pageContext.request.contextPath}/home#about-us">About Us</a></li>
    </ul>

    <div class="nav-actions">
        <a href="${pageContext.request.contextPath}/cart" class="cart-btn">
            <svg class="cart-icon" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="9" cy="21" r="1"></circle>
                <circle cx="20" cy="21" r="1"></circle>
                <path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"></path>
            </svg>
            <% if (navbarCartCount > 0) { %>
                <span class="cart-badge"><%= navbarCartCount %></span>
            <% } else { %>
                <span class="cart-badge" style="display: none;">0</span>
            <% } %>
        </a>

        <% if (loggedInUser != null) { %>
            <a href="${pageContext.request.contextPath}/profile" class="profile-btn">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                    <circle cx="12" cy="7" r="4"></circle>
                </svg>
                <span><%= loggedInUser.getName() %></span>
            </a>
            <a href="${pageContext.request.contextPath}/logout" class="logout-btn">Logout</a>
        <% } else { %>
            <a href="${pageContext.request.contextPath}/auth/login.jsp" class="login-btn btn btn-primary">Login</a>
        <% } %>
    </div>
</nav>

<script>
    window.contextPath = '${pageContext.request.contextPath}';
</script>
<script src="https://unpkg.com/aos@next/dist/aos.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', () => {
        AOS.init({
            duration: 800,
            easing: 'ease-out-cubic',
            once: true,
            offset: 80
        });
    });
</script>
<script src="${pageContext.request.contextPath}/assets/js/navbar.js"></script>