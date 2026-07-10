<%@page import="java.util.List"%>
<%@page import="com.food.model.Order"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
List<Order> orders =
(List<Order>) request.getAttribute("orders");
%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">

<title>FoodRush | My Orders</title>

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/global.css">

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/navbar.css">

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/footer.css">

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/orders.css">

</head>

<body>

<jsp:include page="/components/navbar.jsp"/>

<section class="orders-section">

    <div class="container">

        <h1 class="orders-title">

            My Orders

        </h1>

        <%
        if(orders == null || orders.isEmpty()){
        %>

        <div class="empty-orders">

            <h2>No Orders Yet 🍔</h2>

            <p>Start ordering your favorite food.</p>

            <a
            href="${pageContext.request.contextPath}/restaurants"
            class="btn btn-primary">

                Browse Restaurants

            </a>

        </div>

        <%
        }
        else{
        %>

        <div class="orders-container">

            <%
            int orderIdx = 0;
            for(Order order : orders){
                orderIdx++;
            %>

            <div class="order-card" data-aos="fade-up" data-aos-delay="<%= 100 + ((orderIdx - 1) % 4) * 100 %>">

                <div class="order-header">

                    <div>

                        <h3>

                            Order #<%=order.getOrderId()%>

                        </h3>

                        <p>

                            <%=order.getOrderDate()%>

                        </p>

                    </div>


                    <%
                        String currentStatus = order.getStatus() != null ? order.getStatus() : "PLACED";
                        String statusClass = "";
                        if ("Delivered".equalsIgnoreCase(currentStatus)) {
                            statusClass = "status-delivered";
                        } else if ("Cancelled".equalsIgnoreCase(currentStatus)) {
                            statusClass = "status-cancelled";
                        } else if ("Preparing".equalsIgnoreCase(currentStatus) || "Out for Delivery".equalsIgnoreCase(currentStatus)) {
                            statusClass = "status-preparing";
                        } else {
                            statusClass = "status-pending";
                        }
                    %>
                    <span class="status <%= statusClass %>">

                        <%=currentStatus%>

                    </span>

                </div>


                <div class="order-details">

                    <p>

                        Payment:
                        <strong>
                            <%=order.getPaymentMethod()%>
                        </strong>

                    </p>

                    <p>

                        Address:
                        <strong>
                            <%=order.getDeliveryAddress()%>
                        </strong>

                    </p>

                </div>


                <div class="order-footer" style="display: flex; justify-content: space-between; align-items: center; margin-top: 20px; padding-top: 20px; border-top: 1px solid #f3f4f6;">

                    <div class="order-total" style="font-size: 24px; font-weight: 700; color: var(--primary-color);">

                        Total:

                        ₹ <%=order.getTotalAmount()%>

                    </div>

                    <a href="${pageContext.request.contextPath}/order-status?orderId=<%=order.getOrderId()%>" 
                       class="btn btn-primary" 
                       style="text-decoration: none; padding: 10px 20px; border-radius: 8px; font-weight: 600; font-size: 0.9rem;">
                        Track Order
                    </a>

                </div>

            </div>

            <%
            }
            %>

        </div>

        <%
        }
        %>

    </div>

</section>

<jsp:include page="/components/footer.jsp"/>

</body>
</html>