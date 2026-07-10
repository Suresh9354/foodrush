<%@page import="com.food.model.Cart"%>
<%@page import="com.food.model.User"%>
<%@page import="com.food.model.CartItem"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
Cart cart = (Cart) session.getAttribute("cart");
User user = (User) session.getAttribute("loggedInUser");

if (cart == null || cart.isEmpty()) {
	response.sendRedirect(request.getContextPath() + "/cart");
	return;
}

double itemTotal = cart.getTotalAmount();
double deliveryFee = cart.getDeliveryFee();
double platformFee = cart.getPlatformFee();
double gst = cart.getGST();
double grandTotal = cart.getGrandTotal();

String address = (user != null && user.getAddress() != null) ? user.getAddress() : "";
String phone = (user != null && user.getPhone() != null) ? user.getPhone() : "";

String addressDisplay = address;
if (addressDisplay.trim().isEmpty()) {
    addressDisplay = "No address saved. Click Edit to enter a delivery address.";
}

int totalItemsCount = 0;
for (CartItem item : cart.getItems()) {
    totalItemsCount += item.getQuantity();
}
%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>FoodRush | Checkout</title>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/global.css">

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/navbar.css">

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/footer.css">

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/checkout.css?v=<%= System.currentTimeMillis() %>">

</head>

<body>

	<jsp:include page="/components/navbar.jsp" />

	<section class="checkout-section">

		<div class="container">

			<div class="checkout-header">
				<h1 class="checkout-title">Checkout</h1>
			</div>

			<form action="${pageContext.request.contextPath}/place-order" method="post">
				
				<!-- Hidden field to hold the submitted address -->
				<textarea name="address" id="addressInput" required><%= address %></textarea>
				
				<div class="checkout-container">

					<!-- Left Column -->
					<div class="checkout-left-column">

						<!-- 1. Delivery Address Block -->
						<div class="checkout-card" data-aos="fade-right">
							<div class="step-title-row">
								<span class="step-badge">1</span>
								<h2 class="step-heading">Delivery Address</h2>
							</div>

							<!-- Display Mode -->
							<div class="address-display-box" id="addressDisplayBox">
								<div class="address-pin-wrapper">
									<div class="pin-circle">
										<svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#ff5a00" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
											<path d="M12 2a8 8 0 0 0-8 8c0 5.25 8 12 8 12s8-6.75 8-12a8 8 0 0 0-8-8z"></path>
											<circle cx="12" cy="10" r="3"></circle>
										</svg>
									</div>
								</div>
								<div class="address-details-wrapper">
									<div class="address-tag-row">
										<span class="address-tag-title">Home</span>
										<span class="address-tag-badge">Default</span>
									</div>
									<p class="address-lines-text" id="addressDisplayText">
										<%= addressDisplay.replace("\n", "<br>") %>
									</p>
									<p class="address-phone-text">
										Phone: <span id="addressPhoneText"><%= phone.isEmpty() ? "+91 98765 43210" : phone %></span>
									</p>
								</div>
								<div class="address-edit-btn-wrapper">
									<button type="button" class="btn-edit-address">
										<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#ff5a00" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
											<path d="M12 20h9"></path>
											<path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"></path>
										</svg>
										Edit
									</button>
								</div>
							</div>

							<!-- Edit Mode (Hidden initially) -->
							<div class="address-edit-box" id="addressEditBox">
								<div class="form-group-textarea">
									<label for="addressTextarea">Update Delivery Address</label>
									<textarea id="addressTextarea" rows="4" placeholder="Enter your full address (flat number, street, area, landmark, pincode)"><%= address %></textarea>
								</div>
								<div class="address-edit-actions">
									<button type="button" class="btn btn-save-address">Save</button>
									<button type="button" class="btn btn-cancel-address">Cancel</button>
								</div>
							</div>
						</div>

						<!-- 2. Payment Method Block -->
						<div class="checkout-card mt-3" data-aos="fade-left">
							<div class="step-title-row">
								<span class="step-badge">2</span>
								<h2 class="step-heading">Payment Method</h2>
							</div>

							<div class="payment-selection-wrapper">
								<label class="payment-dropdown-label">Select Payment Method</label>
								
								<div class="custom-payment-select" id="customPaymentSelect">
									
									<!-- Selected Display -->
									<div class="select-trigger-box">
										<div class="trigger-selected-value" id="triggerSelectedValue">
											<img src="${pageContext.request.contextPath}/assets/images/icons/cash-on-delivery.png" alt="Cash on Delivery" class="payment-icon-img">
											<span class="selected-text-main">Cash on Delivery</span>
										</div>
										<svg class="chevron-arrow-icon" id="dropdownChevron" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#ff5a00" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
											<polyline points="6 9 12 15 18 9"></polyline>
										</svg>
									</div>

									<!-- Options List -->
									<div class="options-list-dropdown" id="optionsListDropdown">
										
										<!-- COD Option -->
										<div class="payment-option-item selected" data-value="COD">
											<div class="option-item-icon-col">
												<img src="${pageContext.request.contextPath}/assets/images/icons/cash-on-delivery.png" alt="Cash on Delivery" class="payment-icon-img">
											</div>
											<div class="option-item-text-col">
												<span class="option-item-title-text">Cash on Delivery</span>
												<span class="option-item-desc-text">Pay when your order is delivered</span>
											</div>
											<div class="option-item-check-col">
												<div class="check-circle-indicator">
													<svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
														<polyline points="20 6 9 17 4 12"></polyline>
													</svg>
												</div>
											</div>
										</div>

										<!-- UPI Option -->
										<div class="payment-option-item" data-value="UPI">
											<div class="option-item-icon-col">
												<div class="upi-logo-custom">UPI</div>
											</div>
											<div class="option-item-text-col">
												<span class="option-item-title-text">UPI</span>
												<span class="option-item-desc-text">Pay using any UPI app</span>
											</div>
											<div class="option-item-check-col">
												<div class="check-circle-indicator">
													<svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
														<polyline points="20 6 9 17 4 12"></polyline>
													</svg>
												</div>
											</div>
										</div>

										<!-- CARD Option -->
										<div class="payment-option-item" data-value="CARD">
											<div class="option-item-icon-col">
												<img src="${pageContext.request.contextPath}/assets/images/icons/credit-card.png" alt="Cards" class="payment-icon-img">
											</div>
											<div class="option-item-text-col">
												<span class="option-item-title-text">Cards</span>
												<span class="option-item-desc-text">Debit / Credit Card</span>
											</div>
											<div class="option-item-check-col">
												<div class="check-circle-indicator">
													<svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
														<polyline points="20 6 9 17 4 12"></polyline>
													</svg>
												</div>
											</div>
										</div>

									</div>
								</div>

								<!-- Hidden Select Input for submitting -->
								<input type="hidden" name="paymentMethod" id="paymentMethodHidden" value="COD">

							</div>
						</div>

					</div>

					<!-- Right Column (Bill Details) -->
					<div class="checkout-right-column">
						
						<div class="checkout-bill-card" data-aos="fade-up" data-aos-delay="200">
							
							<h3 class="bill-title">Bill Details</h3>
							
							<div class="bill-details-rows">
								
								<div class="bill-row">
									<span class="bill-label">Item Total (<%= totalItemsCount %> <%= totalItemsCount == 1 ? "Item" : "Items" %>)</span>
									<span class="bill-value">₹<%= String.format("%.2f", itemTotal) %></span>
								</div>

								<div class="bill-row">
									<span class="bill-label flex-align-center">
										Delivery Fee
										<span class="info-tooltip-trigger" title="Standard shipping rates apply">
											<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
												<circle cx="12" cy="12" r="10"></circle>
												<line x1="12" y1="16" x2="12" y2="12"></line>
												<line x1="12" y1="8" x2="12.01" y2="8"></line>
											</svg>
										</span>
									</span>
									<span class="bill-value <%= deliveryFee == 0 ? "free-text" : "" %>">
										<%= deliveryFee == 0 ? "FREE" : "₹" + String.format("%.2f", deliveryFee) %>
									</span>
								</div>

								<div class="bill-row">
									<span class="bill-label flex-align-center">
										Packaging Fee
										<span class="info-tooltip-trigger" title="Packaging and platform operation charge">
											<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
												<circle cx="12" cy="12" r="10"></circle>
												<line x1="12" y1="16" x2="12" y2="12"></line>
												<line x1="12" y1="8" x2="12.01" y2="8"></line>
											</svg>
										</span>
									</span>
									<span class="bill-value">₹<%= String.format("%.2f", platformFee) %></span>
								</div>

								<div class="bill-row">
									<span class="bill-label">GST (5%)</span>
									<span class="bill-value">₹<%= String.format("%.2f", gst) %></span>
								</div>

							</div>

							<div class="divider-bill"></div>

							<div class="bill-total-row">
								<span class="total-label">To Pay</span>
								<span class="total-value">₹<%= String.format("%.0f", grandTotal) %></span>
							</div>

							<!-- Secure Payment Banner -->
							<div class="secure-payment-banner">
								<svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#1aa465" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
									<path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
									<polyline points="9 11 11 13 15 9"></polyline>
								</svg>
								<span class="secure-text">Your payment is 100% secure</span>
							</div>

							<!-- Submit Button -->
							<button type="submit" class="btn btn-place-order-large">
								<svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#ffffff" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
									<rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
									<path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
								</svg>
								Place Order
							</button>

							<!-- Dynamic helper text notice -->
							<div class="payment-method-bottom-notice">
								<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
									<path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path>
								</svg>
								<span id="paymentNoticeText">You will pay when your order is delivered</span>
							</div>

						</div>

					</div>

				</div>

			</form>

		</div>

	</section>

	<jsp:include page="/components/footer.jsp" />

	<script src="${pageContext.request.contextPath}/assets/js/checkout.js?v=<%= System.currentTimeMillis() %>"></script>

</body>
</html>