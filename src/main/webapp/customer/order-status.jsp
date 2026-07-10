<%@page import="java.util.List"%>
<%@page import="com.food.model.Order"%>
<%@page import="com.food.model.OrderItem"%>
<%@page import="com.food.model.Menu"%>
<%@page import="com.food.model.Restaurant"%>
<%@page import="com.food.controller.customer.OrderStatusServlet.OrderItemDetail"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
    Order order = (Order) request.getAttribute("order");
    List<OrderItemDetail> itemDetails = (List<OrderItemDetail>) request.getAttribute("itemDetails");
    Double itemTotal = (Double) request.getAttribute("itemTotal");
    Double deliveryFee = (Double) request.getAttribute("deliveryFee");
    Double platformFee = (Double) request.getAttribute("platformFee");
    Double gst = (Double) request.getAttribute("gst");
    Double grandTotal = (Double) request.getAttribute("grandTotal");
    Double savedAmount = (Double) request.getAttribute("savedAmount");
%>

<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>FoodRush | Order Status</title>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/global.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/navbar.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/footer.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/order-status.css?v=<%= System.currentTimeMillis() %>">
</head>

<body>

	<jsp:include page="/components/navbar.jsp" />

	<section class="order-status-section">
		<div class="container">

	
<%
    boolean isCancelled = Boolean.TRUE.equals(request.getAttribute("isCancelled"));
    String currentStatus = order != null ? order.getStatus() : "PLACED";
%>
<div class="status-header-container">

    <div class="success-icon-wrapper <%= isCancelled ? "cancelled" : "" %>">
        <% if (isCancelled) { %>
            <!-- Cancel Cross Icon -->
            <svg viewBox="0 0 24 24"
                 fill="none"
                 stroke="currentColor"
                 stroke-width="3"
                 stroke-linecap="round"
                 stroke-linejoin="round">
                <line x1="18" y1="6" x2="6" y2="18"></line>
                <line x1="6" y1="6" x2="18" y2="18"></line>
            </svg>
        <% } else { %>
            <!-- Success Check Icon -->
            <svg viewBox="0 0 24 24"
                 fill="none"
                 stroke="currentColor"
                 stroke-width="3"
                 stroke-linecap="round"
                 stroke-linejoin="round">
                <polyline points="20 6 9 17 4 12"></polyline>
            </svg>

            <!-- Confetti -->
            <div class="confetti-decor c1"></div>
            <div class="confetti-decor c2"></div>
            <div class="confetti-decor c3"></div>
            <div class="confetti-decor c4"></div>
        <% } %>
    </div>

    <h1 class="status-title">
        <% 
            if (isCancelled) {
                out.print("Order Cancelled");
            } else if ("Delivered".equalsIgnoreCase(currentStatus)) {
                out.print("Order Delivered!");
            } else if ("Out for Delivery".equalsIgnoreCase(currentStatus)) {
                out.print("Out for Delivery!");
            } else if ("Preparing".equalsIgnoreCase(currentStatus)) {
                out.print("Preparing Order...");
            } else {
                out.print("Order Placed!");
            }
        %>
    </h1>

    <p class="status-subtitle">
        <% 
            if (isCancelled) {
                out.print("We're sorry, your order has been cancelled.");
            } else if ("Delivered".equalsIgnoreCase(currentStatus)) {
                out.print("Your order has been delivered successfully. Enjoy your meal!");
            } else if ("Out for Delivery".equalsIgnoreCase(currentStatus)) {
                out.print("Your delivery partner is on the way with your food.");
            } else if ("Preparing".equalsIgnoreCase(currentStatus)) {
                out.print("The restaurant is preparing your delicious meal.");
            } else {
                out.print("Thank you for your order. We've received your order and will begin preparing it soon.");
            }
        %>
    </p>

    <div class="order-id-badge-container">
        <span class="order-id-label">Order ID</span>

        <span class="order-id-val">
            #ORD${order.orderId}
        </span>
    </div>

</div>


<div class="info-summary-grid">

    <!-- Order Placed -->
    <div class="info-item-box" data-aos="fade-up" data-aos-delay="100">

        <div class="info-icon-circle no-bg">
            <img
                src="${pageContext.request.contextPath}/assets/images/icons/calendar.png"
                alt="Order Placed On">
        </div>

        <div class="info-text-col">

            <span class="info-item-label">
                Order Placed On
            </span>

            <span class="info-item-value">
                ${orderPlacedDate}
            </span>

            <span class="info-item-subvalue">
                ${orderPlacedTime}
            </span>

        </div>

    </div>


    <!-- Estimated Delivery -->
    <div class="info-item-box" data-aos="fade-up" data-aos-delay="150">

        <div class="info-icon-circle no-bg">
            <img
                src="${pageContext.request.contextPath}/assets/images/icons/Estimated Delivery.png"
                alt="Estimated Delivery">
        </div>

        <div class="info-text-col">

            <span class="info-item-label">
                Estimated Delivery
            </span>

            <span class="info-item-value">
                30–40 mins
            </span>

            <span class="info-item-subvalue">
                ${estTimeRange}
            </span>

        </div>

    </div>


    <!-- Delivery Type -->
    <div class="info-item-box" data-aos="fade-up" data-aos-delay="200">

        <div class="info-icon-circle no-bg">
            <img
                src="${pageContext.request.contextPath}/assets/images/icons/Home Delivery.png"
                alt="Delivery Type">
        </div>

        <div class="info-text-col">

            <span class="info-item-label">
                Delivery Type
            </span>

            <span class="info-item-value">
                Home Delivery
            </span>

            <span class="info-item-subvalue">
                To saved address
            </span>

        </div>

    </div>


    <!-- Payment Method -->
    <div class="info-item-box" data-aos="fade-up" data-aos-delay="250">

        <div class="info-icon-circle no-bg">
            <img
                src="${pageContext.request.contextPath}/assets/images/icons/Payment Method.png"
                alt="Payment Method">
        </div>

        <div class="info-text-col">

            <span class="info-item-label">
                Payment Method
            </span>

            <span class="info-item-value">
                ${paymentMethodDisplay}
            </span>

            <span class="info-item-subvalue">
                Amount: ₹${order.totalAmount}
            </span>

        </div>

    </div>

</div>

			
	<div class="timeline-card" data-aos="fade-up" data-aos-delay="300">

    <% if (isCancelled) { %>
        <h3 class="card-section-title" style="color: #EF4444;">
            Order Status: Cancelled
        </h3>
        <div style="display: flex; align-items: center; gap: 16px; padding: 20px; background: #FEF2F2; border: 1px solid #FCA5A5; border-radius: 12px; margin-top: 20px;">
            <div style="background: #EF4444; width: 48px; height: 48px; border-radius: 50%; display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="12" cy="12" r="10"></circle>
                    <line x1="15" y1="9" x2="9" y2="15"></line>
                    <line x1="9" y1="9" x2="15" y2="15"></line>
                </svg>
            </div>
            <div>
                <h4 style="margin: 0; color: #991B1B; font-family: 'Outfit'; font-weight: 600; font-size: 1.05rem;">This order has been cancelled</h4>
                <p style="margin: 4px 0 0 0; color: #7F1D1D; font-size: 0.88rem; line-height: 1.4;">We're sorry for the inconvenience. If any payment was processed, a refund will be initiated to your payment source.</p>
            </div>
        </div>
    <% } else { %>
        <h3 class="card-section-title">
            Order Status
        </h3>

        <div class="status-timeline-wrapper">

            <!-- Timeline Base Line -->
            <div class="status-timeline-line"></div>

            <!-- Progress Line -->
            <div class="status-timeline-progress-line"
                 style="width: ${progressWidth};">
            </div>

           
            <div class="timeline-node ${step1Completed ? 'completed' : ''} ${step1Active ? 'active' : ''}" data-aos="zoom-in" data-aos-delay="400">

                <div class="timeline-node-circle plain">

                    <img src="${pageContext.request.contextPath}/assets/images/icons/Order Confirmed.png"
                        alt="Order Confirmed">
               </div>

                <span class="timeline-node-title">
                    Order Confirmed
                </span>

                <span class="timeline-node-desc">
                    Your order is accepted
                </span>

                <% if (Boolean.TRUE.equals(request.getAttribute("step1Active")) || Boolean.TRUE.equals(request.getAttribute("step2Completed"))) { %>

                    <span class="timeline-node-time">
                        ${orderPlacedTime}
                    </span>

                <% } %>

            </div>

            
            <div class="timeline-node ${step2Completed ? 'completed' : ''} ${step2Active ? 'active' : ''}" data-aos="zoom-in" data-aos-delay="450">

                <div class="timeline-node-circle plain">

                    <img
                        src="${pageContext.request.contextPath}/assets/images/icons/Preparing Order.png"
                        alt="Preparing Order">

                </div>

                <span class="timeline-node-title">
                    Preparing Order
                </span>

                <span class="timeline-node-desc">
                    We're preparing your food
                </span>

            </div>

           
            <div class="timeline-node ${step3Completed ? 'completed' : ''} ${step3Active ? 'active' : ''}" data-aos="zoom-in" data-aos-delay="500">

                <div class="timeline-node-circle plain">

                    <img
                        src="${pageContext.request.contextPath}/assets/images/icons/cargo-truck.png"
                        alt="Out for Delivery">

                </div>

                <span class="timeline-node-title">
                    Out for Delivery
                </span>

                <span class="timeline-node-desc">
                    Your delivery partner is on the way
                </span>

            </div>

           
            <div class="timeline-node ${step4Completed ? 'completed' : ''} ${step4Active ? 'active' : ''}" data-aos="zoom-in" data-aos-delay="550">

                <div class="timeline-node-circle plain">

                    <img
                        src="${pageContext.request.contextPath}/assets/images/icons/Delivered.png"
                        alt="Out for Delivery">

                </div>

                <span class="timeline-node-title">
                    Delivered
                </span>

                <span class="timeline-node-desc">
                    Enjoy your delicious meal!
                </span>

            </div>

        </div>
    <% } %>

</div>
			

<div class="details-billing-container" data-aos="fade-up" data-aos-delay="600">

 
    <div class="status-sub-card">

        <h3 class="sub-card-title">
            Order Details
        </h3>

        <div class="order-items-list">

            <%
                if (itemDetails != null) {

                    for (OrderItemDetail detail : itemDetails) {

                        OrderItem item = detail.getOrderItem();
                        Menu menu = detail.getMenu();
                        Restaurant rest = detail.getRestaurant();

                        String name = (menu != null)
                                ? menu.getItemName()
                                : "Item Details";

                        String restName = (rest != null)
                                ? rest.getName()
                                : "FoodRush Restaurant";

                        String imgUrl =
                                (menu != null && menu.getImageUrl() != null)
                                ? menu.getImageUrl()
                                : "assets/images/menu/idlisambar.png";
            %>

            <div class="order-item-row">

                <div class="order-item-img-wrapper">
                    <img
                        src="${pageContext.request.contextPath}/<%= imgUrl %>"
                        alt="<%= name %>"
                        onerror="this.src='${pageContext.request.contextPath}/assets/images/menu/idlisambar.png';">
                </div>

                <div class="order-item-info">

                    <h4 class="order-item-name">
                        <%= name %>
                    </h4>

                    <p class="order-item-restaurant">
                        <%= restName %>
                    </p>

                    <span class="order-item-qty">
                        Qty : <%= item.getQuantity() %>
                    </span>

                </div>

                <div class="order-item-price">
                    ₹<%= (int) (item.getPrice() * item.getQuantity()) %>
                </div>

            </div>

            <%
                    }
                }
            %>

        </div>



    </div>

    <div class="status-sub-card">

        <h3 class="sub-card-title">
            Bill Details
        </h3>

        <div class="bill-row-item">
            <span>Item Total</span>
            <span>₹${itemTotal.intValue()}</span>
        </div>

        <div class="bill-row-item">

            <span>
                Delivery Fee

                <span class="info-tooltip-trigger"
                      title="Delivery charges based on distance">

                    <svg fill="none"
                         stroke="currentColor"
                         stroke-width="2"
                         viewBox="0 0 24 24">

                        <circle cx="12" cy="12" r="10"></circle>
                        <line x1="12" y1="16" x2="12" y2="12"></line>
                        <line x1="12" y1="8" x2="12.01" y2="8"></line>

                    </svg>

                </span>

            </span>

            <span>
                ${deliveryFee == 0 ? 'FREE' : '₹'}${deliveryFee == 0 ? '' : deliveryFee.intValue()}
            </span>

        </div>

        <div class="bill-row-item">

            <span>

                Platform Fee

                <span class="info-tooltip-trigger"
                      title="Platform usage fee">

                    <svg fill="none"
                         stroke="currentColor"
                         stroke-width="2"
                         viewBox="0 0 24 24">

                        <circle cx="12" cy="12" r="10"></circle>
                        <line x1="12" y1="16" x2="12" y2="12"></line>
                        <line x1="12" y1="8" x2="12.01" y2="8"></line>

                    </svg>

                </span>

            </span>

            <span>
                ₹${platformFee.intValue()}
            </span>

        </div>

        <div class="bill-row-item">
            <span>GST & Taxes (5%)</span>
            <span>₹${gst.intValue()}</span>
        </div>

        <div class="bill-row-item bold-total">

            <span class="bill-total-label">
                To Pay
            </span>

            <span class="bill-total-price">
                ₹${grandTotal.intValue()}
            </span>

        </div>

        <!-- Savings Banner -->
        <div class="savings-alert-banner">

            <div class="savings-icon-circle">

                <svg width="14"
                     height="14"
                     viewBox="0 0 24 24"
                     fill="none"
                     stroke="currentColor"
                     stroke-width="2"
                     stroke-linecap="round"
                     stroke-linejoin="round">

                    <path d="M20.59 13.41l-7.17 7.17a2 2 0 0 1-2.83 0L2 12V2h10l8.59 8.59a2 2 0 0 1 0 2.82z"></path>

                    <line x1="7" y1="7" x2="7.01" y2="7"></line>

                </svg>

            </div>

            <div class="savings-text-col">

                <span class="savings-main-msg">
                    You saved ₹${savedAmount.intValue()} on this order
                </span>

                <span class="savings-sub-msg">
                    with promotional offers applied
                </span>

            </div>

        </div>

    </div>

</div>

<div class="help-section-card" data-aos="slide-up" data-aos-delay="650">

    <div class="help-left-col">

        <div class="timeline-node-circle plain">

            <img
                src="${pageContext.request.contextPath}/assets/images/icons/support.png"
                alt="Support">

        </div>

        <div class="help-text-col">

            <h4 class="help-title-text">
                Need Help?
            </h4>

            <p class="help-desc-text">
                Our customer support team is available 24/7 to assist you.
            </p>

        </div>

    </div>

    <div class="help-actions-row">

        <!-- Chat Button -->
        <button class="btn-help-action">

            <img
                src="${pageContext.request.contextPath}/assets/images/icons/chat.png"
                alt="Chat">

            Chat with Us

        </button>

        <!-- Call Button -->
        <button class="btn-help-action">

            <img
                src="${pageContext.request.contextPath}/assets/images/icons/phone-call.png"
                alt="Call">

            Call Us

        </button>

    </div>

</div>
			<!-- ===========================
     Footer Navigation Buttons
=========================== -->
<div class="footer-actions-container" data-aos="fade-up" data-aos-delay="700">

    <%
        boolean isCancelable = "PLACED".equalsIgnoreCase(currentStatus) || "Pending".equalsIgnoreCase(currentStatus);
        if (isCancelable) {
    %>
        <!-- Cancel Order Button -->
        <form action="${pageContext.request.contextPath}/order-status" method="POST" style="display: inline-block;" onsubmit="return confirm('Are you sure you want to cancel this order?');">
            <input type="hidden" name="orderId" value="${order.orderId}">
            <input type="hidden" name="action" value="cancel">
            <button type="submit" class="btn-footer-nav outline" style="border-color: #EF4444; color: #EF4444; background: transparent; cursor: pointer; display: inline-flex; align-items: center; justify-content: center; gap: 8px; font-family: inherit; font-size: inherit; font-weight: inherit; padding: 12px 24px; border-radius: 8px; text-decoration: none; outline: none; border-style: solid; border-width: 1px;">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="12" cy="12" r="10"></circle>
                    <line x1="15" y1="9" x2="9" y2="15"></line>
                    <line x1="9" y1="9" x2="15" y2="15"></line>
                </svg>
                Cancel Order
            </button>
        </form>
    <% } %>

    <!-- My Orders Button -->
    <a href="${pageContext.request.contextPath}/orders"
       class="btn-footer-nav outline">

        <img
            src="${pageContext.request.contextPath}/assets/images/icons/order-list.png"
            alt="My Orders">

        My Orders

    </a>

    <!-- Back to Home Button -->
    <a href="${pageContext.request.contextPath}/home"
       class="btn-footer-nav solid">

        <img
            src="${pageContext.request.contextPath}/assets/images/icons/home.png"
            alt="Home">

        Back to Home

    </a>

</div>


<p class="bottom-gratitude-text">

    We hope you enjoy your meal! ❤️

    <span>
        Thanks for choosing FoodRush.
    </span>

</p>

 </div>
</section>

	<jsp:include page="/components/footer.jsp" />

</body>

</html>