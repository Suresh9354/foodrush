<%@ page language="java"
contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<title>FoodRush | Register</title>

<link rel="stylesheet"
href="${pageContext.request.contextPath}/assets/css/auth.css">

</head>

<body>

<div class="auth-container" data-aos="fade-up">

    <div class="auth-left">

        <img
        src="${pageContext.request.contextPath}/assets/images/logo/logo.png"
        alt="FoodRush">

        <h1>Join FoodRush</h1>

        <p>

            Fast delivery. Fresh food. Best restaurants.

        </p>

    </div>


    <div class="auth-right">

        <form
        action="${pageContext.request.contextPath}/register"
        method="post"
        class="auth-form">

            <h2>Create Account</h2>


            <input
                type="text"
                name="name"
                placeholder="Full Name"
                required>


            <input
                type="email"
                name="email"
                placeholder="Email"
                required>


            <input
                type="text"
                name="phone"
                placeholder="Phone Number"
                required>


            <textarea
                name="address"
                placeholder="Address"
                rows="3"
                required></textarea>


            <input
                type="password"
                name="password"
                id="passwordInput"
                placeholder="Password"
                required>

            <div class="password-strength-container" id="strengthContainer" style="display: none;">
                <div class="strength-bar-track">
                    <div class="strength-bar-fill" id="strengthFill"></div>
                </div>
                <span class="strength-text" id="strengthText"></span>
            </div>


            <button type="submit">

                Register

            </button>


            <p class="bottom-text">

                Already have an account?

                <a href="${pageContext.request.contextPath}/auth/login.jsp">

                    Login

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
<script src="${pageContext.request.contextPath}/assets/js/register.js"></script>

</body>
</html>