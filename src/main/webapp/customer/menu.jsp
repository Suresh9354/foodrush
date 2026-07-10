<%@page import="java.util.List"%>
<%@page import="com.food.model.Menu"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
List<Menu> menuList =
(List<Menu>) request.getAttribute("menuList");
%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">

<title>FoodRush | Menu</title>

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/global.css">

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/navbar.css">

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/footer.css">

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/menu.css?v=<%= System.currentTimeMillis() %>">

</head>

<body>

<jsp:include page="/components/navbar.jsp"/>

<section class="menu-section">

    <div class="container">

        <div class="section-header" data-aos="fade-up">

            <h1><%= request.getAttribute("categoryTitle") != null ? request.getAttribute("categoryTitle") + " Menu" : "Restaurant Menu" %></h1>

            <p>Choose your favorite dishes</p>

        </div>


        <div class="menu-grid">

            <%
            if(menuList != null){
                int mIdx = 0;
                for(Menu menu : menuList){
                    mIdx++;
            %>

            <div class="menu-card" data-aos="fade-up" data-aos-delay="<%= 100 + ((mIdx - 1) % 4) * 100 %>">

                <div class="menu-image">

                    <img
                    src="${pageContext.request.contextPath}/<%=menu.getImageUrl()%>"
                    alt="<%=menu.getItemName()%>">

                </div>


                <div class="menu-content">

                    <h2>
                        <%=menu.getItemName()%>
                    </h2>

                    <p class="description">
                        <%=menu.getDescription()%>
                    </p>

                    <div class="menu-footer">

                        <span class="price">

                            ₹ <%=menu.getPrice()%>

                        </span>

                        <a
                        href="${pageContext.request.contextPath}/cart?action=add&menuId=<%=menu.getMenuId()%>"
                        class="btn btn-primary">

                            Add To Cart

                        </a>

                    </div>

                </div>

            </div>

            <%
                }
            }
            %>

        </div>

    </div>

</section>

<jsp:include page="/components/footer.jsp"/>

</body>
</html>