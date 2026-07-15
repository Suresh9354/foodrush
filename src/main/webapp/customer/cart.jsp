<%@page import="com.food.model.Cart"%>
<%@page import="com.food.model.CartItem"%>
<%@page import="java.util.Collection"%>
<%@page import="com.food.dao.RestaurantDAO"%>
<%@page import="com.food.daoimpl.RestaurantDAOImpl"%>
<%@page import="com.food.model.Restaurant"%>
<%@page import="com.food.dao.MenuDAO"%>
<%@page import="com.food.daoimpl.MenuDAOImpl"%>
<%@page import="com.food.model.Menu"%>
<%@ page pageEncoding="UTF-8"%>

<%
Cart cart = (Cart) session.getAttribute("cart");

Collection<CartItem> items = null;
double total = 0;

if (cart != null) {
	items = cart.getItems();
	total = cart.getTotalAmount();
}

String error = (String) request.getAttribute("error");
Integer newMenuId = (Integer) request.getAttribute("newMenuId");

RestaurantDAO restaurantDAO = new RestaurantDAOImpl();
MenuDAO menuDAO = new MenuDAOImpl();

int restaurantId = -1;
Restaurant cartRestaurant = null;

if (cart != null) {
	restaurantId = cart.getRestaurantId();
	if (restaurantId != -1) {
		cartRestaurant = restaurantDAO.getRestaurantById(restaurantId);
	}
}
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>FoodRush | Cart</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css?v=1.1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/navbar.css?v=1.1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css?v=1.1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/cart.css?v=1.1">
</head>
<body>

	<jsp:include page="/components/navbar.jsp" />

	<section class="cart-section">
		<div class="container" data-aos="fade-up" data-aos-delay="250">

			<div class="cart-header-main">
				<h1 class="cart-title">Your Cart</h1>
				<div class="accent-line-cart"></div>
			</div>

			<%
			if (error != null) {
			%>
			<div class="cart-error">
				<h3>⚠ Cart Conflict</h3>
				<p><%=error%></p>
				<div class="cart-error-actions">
					<a href="${pageContext.request.contextPath}/cart" class="cancel-btn"> Cancel </a>
					<a href="${pageContext.request.contextPath}/cart?action=replace&menuId=<%=newMenuId%>" class="replace-btn"> Clear Cart & Add </a>
				</div>
			</div>
			<%
			}
			%>

			<%
			if (items == null || items.isEmpty()) {
			%>
			<div class="empty-cart">
				<h2>Your cart is empty 🛒</h2>
				<p class="empty-subtitle">Add items to get started on your delicious meal!</p>
				<a href="${pageContext.request.contextPath}/restaurants" class="btn btn-primary mt-2"> Explore Restaurants </a>
			</div>
			<%
			} else {
			%>
			<div class="cart-container">
				
				<!-- Left Column: Items List -->
				<div class="cart-items-column">
					<div class="items-header-row">
						<span>ITEMS (<%=items.size()%>)</span>
						<span>PRICE</span>
					</div>

					<%
					int itemIdx = 0;
					for (CartItem item : items) {
						itemIdx++;
						Menu menuInfo = menuDAO.getMenuById(item.getMenuId());
						String category = "Food";
						if (menuInfo != null && menuInfo.getCategory() != null && !menuInfo.getCategory().trim().isEmpty() && !menuInfo.getCategory().equalsIgnoreCase("null")) {
							category = menuInfo.getCategory();
						}
						String resName = cartRestaurant != null ? cartRestaurant.getName() : "Restaurant";
					%>
					<div class="cart-card" >
						<div class="cart-card-image-wrapper">
							<img src="${pageContext.request.contextPath}/<%=item.getImageUrl()%>" alt="<%=item.getName()%>" onerror="this.src='${pageContext.request.contextPath}/assets/images/menu/idlivada.png'">
						</div>

						<div class="cart-info">
							<h3><%=item.getName()%></h3>
							<p class="restaurant-name"><%=resName%></p>
							<div class="cuisine-tag">
								<span class="veg-icon"><span class="veg-circle"></span></span>
								<span><%=category%></span>
							</div>
							<p class="item-price">₹<%=String.format("%.0f", item.getPrice())%></p>
						</div>

						<div class="quantity-stepper">
							<a class="stepper-btn" href="${pageContext.request.contextPath}/cart?action=decrease&menuId=<%=item.getMenuId()%>">−</a>
							<span class="stepper-value"><%=item.getQuantity()%></span>
							<a class="stepper-btn" href="${pageContext.request.contextPath}/cart?action=increase&menuId=<%=item.getMenuId()%>">+</a>
						</div>

						<div class="item-total">
							₹<%=String.format("%.0f", item.getTotalPrice())%>
						</div>

						<a class="remove-btn-icon" href="${pageContext.request.contextPath}/cart?action=remove&menuId=<%=item.getMenuId()%>" title="Remove Item">
							<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
								<polyline points="3 6 5 6 21 6"></polyline>
								<path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
								<line x1="10" y1="11" x2="10" y2="17"></line>
								<line x1="14" y1="11" x2="14" y2="17"></line>
							</svg>
						</a>
					</div>
					<%
					}
					%>

					<!-- Add More Items Link -->
					<a href="${pageContext.request.contextPath}/menu?restaurantId=<%=restaurantId%>" class="add-more-card">
						<div class="add-more-content">
							<svg class="add-more-icon" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
								<circle cx="12" cy="12" r="10"></circle>
								<line x1="12" y1="8" x2="12" y2="16"></line>
								<line x1="8" y1="12" x2="16" y2="12"></line>
							</svg>
							<span>Add more items from restaurants</span>
						</div>
						<svg class="arrow-right-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
							<line x1="5" y1="12" x2="19" y2="12"></line>
							<polyline points="12 5 19 12 12 19"></polyline>
						</svg>
					</a>
				</div>

				<!-- Right Column: Sticky Summary -->
				<div class="cart-summary-column">
					<div class="cart-summary-card">
						<%
						double itemTotal = total;
						double deliveryFee = cart != null ? cart.getDeliveryFee() : 0;
						double packagingFee = cart != null ? cart.getPlatformFee() : 0;
						double gst = cart != null ? cart.getGST() : 0;
						double grandTotal = cart != null ? cart.getGrandTotal() : 0;
						int totalItemsCount = 0;
						if (items != null) {
							for (CartItem item : items) {
								totalItemsCount += item.getQuantity();
							}
						}
						%>

						<div class="summary-title">BILL DETAILS</div>

						<div class="summary-row">
							<span>Item Total (<%=totalItemsCount%> Items)</span>
							<span>₹<%=String.format("%.0f", itemTotal)%></span>
						</div>

						<div class="summary-row">
							<span class="info-label">
								Delivery Fee
								<svg class="info-icon" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="16" x2="12" y2="12"></line><line x1="12" y1="8" x2="12.01" y2="8"></line></svg>
							</span>
							<span><%= deliveryFee == 0 ? "FREE" : "₹" + String.format("%.0f", deliveryFee) %></span>
						</div>

						<div class="summary-row">
							<span class="info-label">
								Packaging Fee
								<svg class="info-icon" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="16" x2="12" y2="12"></line><line x1="12" y1="8" x2="12.01" y2="8"></line></svg>
							</span>
							<span>₹<%=String.format("%.0f", packagingFee)%></span>
						</div>

						<div class="summary-row">
							<span class="info-label">GST (5%)</span>
							<span>₹<%=String.format("%.1f", gst)%></span>
						</div>

						<hr class="summary-divider">

						<div class="summary-row to-pay-row">
							<span>To Pay</span>
							<span class="to-pay-price">₹<%=String.format("%.0f", grandTotal)%></span>
						</div>

						<!-- Savings offer banner -->
						<div class="saving-banner">
							<svg class="saving-icon" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
								<circle cx="12" cy="8" r="7"></circle>
								<polyline points="8.21 13.89 7 23 12 20 17 23 15.79 13.88"></polyline>
							</svg>
							<div class="saving-content">
								<span class="saving-title">You saved ₹60 on this order</span>
								<span class="saving-subtitle">with offers</span>
							</div>
						</div>

						<!-- Checkout Button -->
						<a href="${pageContext.request.contextPath}/checkout" class="checkout-btn-new">
							Proceed to Checkout
						</a>

						<!-- Safe payments trust badge -->
						<div class="secure-payments-badge">
							<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
								<path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
								<polyline points="9 11 11 13 15 9"></polyline>
							</svg>
							<span>100% Safe & Secure Payments</span>
						</div>
					</div>
				</div>

			</div>
			<%
			}
			%>

		</div>
	</section>

	<jsp:include page="/components/footer.jsp" />

</body>
</html>