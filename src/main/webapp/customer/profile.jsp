<%@page import="com.food.model.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
User user = (User) request.getAttribute("user");

if(user == null){
    user = (User) session.getAttribute("loggedInUser");
}
%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<title>FoodRush | Profile</title>

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/global.css">

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/navbar.css">

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/footer.css">

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/profile.css?v=<%= System.currentTimeMillis() %>">

</head>

<body>

<jsp:include page="/components/navbar.jsp"/>

<section class="profile-section">

    <div class="container">

        <div class="profile-card" data-aos="fade-up">

            <% if (request.getAttribute("successMessage") != null) { %>
                <div class="alert alert-success">
                    <%= request.getAttribute("successMessage") %>
                </div>
            <% } else if (request.getAttribute("errorMessage") != null) { %>
                <div class="alert alert-danger">
                    <%= request.getAttribute("errorMessage") %>
                </div>
            <% } %>

            <div class="profile-header">

                <div class="profile-avatar" data-aos="zoom-in" data-aos-delay="200">

                    <%=user.getName().charAt(0)%>

                </div>

                <h1>

                    Welcome,
                    <%=user.getName()%>

                </h1>

            </div>

            <form action="${pageContext.request.contextPath}/profile" method="POST">

                <div class="profile-body">

                    <div class="profile-item" data-aos="fade-up" data-aos-delay="300">

                        <label>Name</label>
                       

                        <input type="text" name="name" class="profile-input" value="<%=user.getName()%>" readonly required>

                    </div>


                    <div class="profile-item" data-aos="fade-up" data-aos-delay="350">

                        <label>Email</label>

                        <p>
                            <%=user.getEmail()%>
                        </p>

                    </div>


                    <div class="profile-item" data-aos="fade-up" data-aos-delay="400">

                        <label>Phone</label>

                        <input type="text" name="phone" class="profile-input" value="<%=user.getPhone()%>" readonly required>

                    </div>


                    <div class="profile-item" data-aos="fade-up" data-aos-delay="450">

                        <label>Address</label>

                        <input type="text" name="address" class="profile-input" value="<%=user.getAddress()%>" readonly required>

                    </div>


                    <div class="profile-item" data-aos="fade-up" data-aos-delay="500">

                        <label>Role</label>

                        <p>
                            <%=user.getRole()%>
                        </p>

                    </div>

                </div>


                <div class="profile-actions" data-aos="fade-up" data-aos-delay="550">

                    <button type="button" class="btn btn-primary default-btn-group" id="editBtn">
                        Edit Profile
                    </button>

                    <a href="${pageContext.request.contextPath}/orders"
                       class="btn btn-outline default-btn-group">
                        My Orders
                    </a>

                    <a href="${pageContext.request.contextPath}/logout"
                       class="btn btn-outline default-btn-group logout-link">
                        Logout
                    </a>

                    <button type="submit" class="btn btn-primary edit-btn-group">
                        Save Changes
                    </button>

                    <button type="button" class="btn btn-outline edit-btn-group" id="cancelBtn">
                        Cancel
                    </button>

                </div>

            </form>

        </div>

    </div>

</section>

<jsp:include page="/components/footer.jsp"/>

<script src="${pageContext.request.contextPath}/assets/js/profile.js"></script>

</body>
</html>