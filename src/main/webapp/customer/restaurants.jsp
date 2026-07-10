<%@page import="java.util.List"%>
<%@page import="com.food.model.Restaurant"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
List<Restaurant> restaurants = (List<Restaurant>) request.getAttribute("allRestaurants");
%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">

<title>FoodRush | Restaurants</title>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/global.css">

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/navbar.css">

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/footer.css">

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/assets/css/restaurants.css?v=<%= System.currentTimeMillis() %>">

</head>

<body>

	<jsp:include page="/components/navbar.jsp" />


	<section class="restaurant-section">

		<div class="container">

			<div class="section-header" data-aos="fade-up">

				<h1>Popular Restaurants</h1>

				<p>Discover the best food around you</p>

			</div>


			<div class="restaurant-grid">

				<%
				if (restaurants != null) {
					int rIdx = 0;
					for (Restaurant r : restaurants) {
						rIdx++;
				%>

				<div class="restaurant-card" data-aos="fade-up" data-aos-delay="<%= 100 + ((rIdx - 1) % 4) * 100 %>">

					<div class="restaurant-image">

						<img src="${pageContext.request.contextPath}/<%=r.getImageUrl()%>"
							alt="<%=r.getName()%>">

					</div>


					<div class="restaurant-content">

						<h2><%=r.getName()%></h2>

						<p class="cuisine">
							<%=r.getCuisine()%>
						</p>

						<div class="restaurant-info">

							<span> <span class="rating-star">⭐</span> <%=r.getRating()%>
							</span> <span> 🕒 <%=r.getDeliveryTime()%> mins
							</span>

						</div>

						<p class="address">
							<%=r.getAddress()%>
						</p>

						<a
							href="${pageContext.request.contextPath}/menu?restaurantId=<%=r.getRestaurantId()%>"
							class="btn btn-primary"> View Menu </a>

					</div>

				</div>

				<%
				}
				}
				%>

			</div>

		</div>

	</section>


	<jsp:include page="/components/footer.jsp" />

</body>
</html>