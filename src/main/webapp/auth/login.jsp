<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<title>FoodRush | Login</title>

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/auth.css">

</head>

<body>

<div class="auth-container" data-aos="fade-up">

    <div class="auth-left">

        <img
        src="${pageContext.request.contextPath}/assets/images/logo/logo.png"
        alt="FoodRush">

        <h1>Welcome Back!</h1>

        <p>
            Order delicious food from your favorite restaurants.
        </p>

    </div>


    <div class="auth-right">

        <form
        action="${pageContext.request.contextPath}/login"
        method="post"
        class="auth-form">

            <h2>Login</h2>

            <%
                String error = (String) request.getAttribute("error");
                String paramError = request.getParameter("error");
                if (error != null) {
            %>
                <div class="error-msg">
                    <%= error %>
                </div>
            <%
                } else if ("unauthorized".equals(paramError)) {
            %>
                <div class="error-msg">
                    Access Denied. Admin privileges required.
                </div>
            <%
                }
            %>


            <input
                type="email"
                name="email"
                placeholder="Enter Email"
                required>


            <input
                type="password"
                name="password"
                placeholder="Enter Password"
                required>


            <button type="submit">

                Login

            </button>


            <p class="bottom-text">

                Don't have an account?

                <a href="${pageContext.request.contextPath}/auth/register.jsp">

                    Register

                </a>

            </p>

        </form>

    </div>

</div>

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

</body>
</html>