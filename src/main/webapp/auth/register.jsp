<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FoodRush | Register</title>
    <meta name="description" content="Create an account on FoodRush.">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Caveat:wght@700&family=Outfit:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/login.css?v=11">
    <script>document.documentElement.classList.add('js');</script>
</head>
<body>

<div class="login-container" id="loginContainer">

    <%-- ── 1. LEFT BRANDING COLUMN ─────────────────────────── --%>
    <div class="login-left animate-on-load">

        <div class="logo-wrapper animate-on-load" id="logoWrapper">
            <div class="logo-branding">
                <img src="${pageContext.request.contextPath}/assets/images/login/logo.png"
                     alt="FoodRush" class="logo-icon">
                <div class="logo-text-block">
                    <div class="logo-title">
                        <span class="logo-food">Food</span><span class="logo-rush">Rush</span>
                    </div>
                    <div class="logo-tagline">Delicious Food, Delivered Fast</div>
                </div>
            </div>
        </div>

        <div class="left-content animate-on-load" id="leftContent">
            <h1 class="branding-title">
                <span class="heading-row-1" id="headingRow1">Join the</span>
                <span class="heading-row-2" id="headingRow2">FoodRush!</span>
            </h1>
            <p class="branding-desc" id="brandingDesc">
                Fast delivery. Fresh food. Best restaurants.
            </p>
        </div>

        <div class="features-card animate-on-load" id="featuresCard">
            <div class="feature-item">
                <div class="feature-icon-wrap">
                    <svg viewBox="0 0 24 24" fill="none"><path stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" d="M6 2L3 6v14a2 2 0 002 2h14a2 2 0 002-2V6l-3-4zM3 6h18M16 10a4 4 0 01-8 0"/></svg>
                </div>
                <div class="feature-text">
                    <h3>Fresh &amp; Quality</h3>
                    <p>Handpicked ingredients for you</p>
                </div>
            </div>
            <div class="feature-item">
                <div class="feature-icon-wrap">
                    <svg viewBox="0 0 24 24" fill="none"><path stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" d="M5 17H3a2 2 0 01-2-2V5a2 2 0 012-2h11l5 5v9a2 2 0 01-2 2h-1"/><circle cx="7" cy="17" r="2" stroke="currentColor" stroke-width="1.8"/><circle cx="17" cy="17" r="2" stroke="currentColor" stroke-width="1.8"/><path stroke="currentColor" stroke-width="1.8" stroke-linecap="round" d="M9 17h6"/></svg>
                </div>
                <div class="feature-text">
                    <h3>Fast Delivery</h3>
                    <p>On time, everytime at your door</p>
                </div>
            </div>
            <div class="feature-item">
                <div class="feature-icon-wrap">
                    <svg viewBox="0 0 24 24" fill="none"><path stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/><path stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" d="M9 12l2 2 4-4"/></svg>
                </div>
                <div class="feature-text">
                    <h3>Secure Payment</h3>
                    <p>100% safe &amp; secure payments</p>
                </div>
            </div>
        </div>

    </div>

    <%-- ── 2. FOOD SCENE ── --%>
    <div class="food-composition animate-on-load" id="foodComposition">
        <div class="food-item food-phone" id="phoneLayer"><div class="parallax-wrap" data-speed="4"><div class="float-wrap phone-float"><img src="${pageContext.request.contextPath}/assets/images/login/phone.png" alt="Delivery app"></div></div></div>
        <div class="food-item food-board" id="boardLayer"><div class="parallax-wrap" data-speed="2"><div class="float-wrap board-float"><img src="${pageContext.request.contextPath}/assets/images/login/wooden-board.png" alt="" aria-hidden="true"></div></div></div>
        <div class="food-item food-burger" id="burgerLayer"><div class="parallax-wrap" data-speed="3"><div class="float-wrap burger-float"><img src="${pageContext.request.contextPath}/assets/images/login/Burger.png" alt="Fresh burger"></div></div></div>
        <div class="food-item food-fries" id="friesLayer"><div class="parallax-wrap" data-speed="5"><div class="float-wrap fries-float"><img src="${pageContext.request.contextPath}/assets/images/login/fries.png" alt="Golden fries"></div></div></div>
        <div class="food-item food-ketchup" id="ketchupLayer"><div class="parallax-wrap" data-speed="4"><div class="float-wrap ketchup-float"><img src="${pageContext.request.contextPath}/assets/images/login/ketchup-bowl.png" alt="Ketchup"></div></div></div>
        <div class="food-item food-scooter" id="scooterLayer"><div class="parallax-wrap" data-speed="5"><div class="float-wrap scooter-float"><img src="${pageContext.request.contextPath}/assets/images/login/scooter.png" alt="Delivery scooter"></div></div></div>
        <div class="food-item food-pizza" id="pizzaLayer"><div class="parallax-wrap" data-speed="2"><div class="float-wrap pizza-float"><img src="${pageContext.request.contextPath}/assets/images/login/pizza.png" alt="Fresh pizza"></div></div></div>
        <div class="food-item food-pasta" id="pastaLayer"><div class="parallax-wrap" data-speed="3"><div class="float-wrap pasta-float"><img src="${pageContext.request.contextPath}/assets/images/login/pasta-bowl.png" alt="Pasta bowl"></div></div></div>
        
        <div class="food-item food-leaf food-leaf-1" id="leaf1Layer"><div class="parallax-wrap" data-speed="8"><div class="float-wrap leaf1-float"><img src="${pageContext.request.contextPath}/assets/images/login/leaf-1.png" alt="" aria-hidden="true"></div></div></div>
        <div class="food-item food-leaf food-leaf-2" id="leaf2Layer"><div class="parallax-wrap" data-speed="7"><div class="float-wrap leaf2-float"><img src="${pageContext.request.contextPath}/assets/images/login/leaf-2.png" alt="" aria-hidden="true"></div></div></div>
        <div class="food-item food-leaf food-leaf-3" id="leaf3Layer"><div class="parallax-wrap" data-speed="6"><div class="float-wrap leaf3-float"><img src="${pageContext.request.contextPath}/assets/images/login/leaf-3.png" alt="" aria-hidden="true"></div></div></div>
        <div class="food-item food-leaf food-leaf-4" id="leaf4Layer"><div class="parallax-wrap" data-speed="9"><div class="float-wrap leaf4-float"><img src="${pageContext.request.contextPath}/assets/images/login/leaf-4.png" alt="" aria-hidden="true"></div></div></div>
    </div>

    <%-- ── 3. RIGHT PANEL — Orange form ─────────────────── --%>
    <div class="login-right animate-on-load" id="loginRight">
        <div class="sparkle sparkle-tr" aria-hidden="true"><svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 0L14.6 9.4 24 12 14.6 14.6 12 24 9.4 14.6 0 12 9.4 9.4z"/></svg></div>
        <div class="sparkle sparkle-bl" aria-hidden="true"><svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 0L14.6 9.4 24 12 14.6 14.6 12 24 9.4 14.6 0 12 9.4 9.4z"/></svg></div>
        <div class="dot-grid" aria-hidden="true"></div>

        <div class="form-wrapper" id="formWrapper" style="margin-top: -30px; margin-bottom: 20px;">
            <form action="${pageContext.request.contextPath}/register" method="post" class="login-form" id="loginForm" novalidate>

                <h2 class="form-title" id="formTitle" style="margin-bottom: 5px;">Create Account</h2>
                <p class="form-subtitle" id="formSubtitle" style="margin-bottom: 15px;">Sign up to get started</p>

                <%
                    String error = (String) request.getAttribute("error");
                    if (error != null) {
                %>
                <div class="alert-msg" role="alert" id="alertMsg">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/>
                    </svg>
                    <span><%= error %></span>
                </div>
                <% } %>

                <!-- Name Field -->
                <div class="field-group" id="groupName" style="margin-bottom: 8px;">
                    <label for="nameInput" class="field-label">Full Name</label>
                    <div class="field-box">
                        <span class="field-icon">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/><circle cx="12" cy="7" r="4"/>
                            </svg>
                        </span>
                        <input type="text" id="nameInput" name="name" placeholder="Enter your full name" required>
                    </div>
                </div>

                <!-- Email Field -->
                <div class="field-group" id="groupUsername" style="margin-bottom: 8px;">
                    <label for="emailInput" class="field-label">Email Address</label>
                    <div class="field-box">
                        <span class="field-icon">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"/><polyline points="22,6 12,13 2,6"/>
                            </svg>
                        </span>
                        <input type="email" id="emailInput" name="email" placeholder="Enter your email" required>
                    </div>
                </div>

                <!-- Phone Field -->
                <div class="field-group" id="groupPhone" style="margin-bottom: 8px;">
                    <label for="phoneInput" class="field-label">Phone Number</label>
                    <div class="field-box">
                        <span class="field-icon">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M22 16.92v3a2 2 0 01-2.18 2 19.79 19.79 0 01-8.63-3.07 19.5 19.5 0 01-6-6 19.79 19.79 0 01-3.07-8.67A2 2 0 014.11 2h3a2 2 0 012 1.72 12.84 12.84 0 00.7 2.81 2 2 0 01-.45 2.11L8.09 9.91a16 16 0 006 6l1.27-1.27a2 2 0 012.11-.45 12.84 12.84 0 002.81.7A2 2 0 0122 16.92z"/>
                            </svg>
                        </span>
                        <input type="text" id="phoneInput" name="phone" placeholder="Enter your phone number" required>
                    </div>
                </div>

                <!-- Address Field -->
                <div class="field-group" id="groupAddress" style="margin-bottom: 8px;">
                    <label for="addressInput" class="field-label">Address</label>
                    <div class="field-box" style="height: auto; padding-top: 10px; padding-bottom: 10px;">
                        <span class="field-icon" style="align-self: flex-start; margin-top: 2px;">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0118 0z"/><circle cx="12" cy="10" r="3"/>
                            </svg>
                        </span>
                        <textarea id="addressInput" name="address" placeholder="Enter your address" rows="2" required></textarea>
                    </div>
                </div>

                <!-- Password Field -->
                <div class="field-group" id="groupPassword" style="margin-bottom: 10px;">
                    <label for="passwordInput" class="field-label">Password</label>
                    <div class="field-box">
                        <span class="field-icon">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0110 0v4"/>
                            </svg>
                        </span>
                        <input type="password" id="passwordInput" name="password" placeholder="Enter a secure password" required>
                        <button type="button" id="pwToggle" class="pw-toggle" aria-label="Show password">
                            <svg id="eyeIcon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>
                            </svg>
                        </button>
                    </div>
                    
                </div>

                <button type="submit" class="submit-btn" id="submitBtn">
                    <span class="btn-label">REGISTER</span>
                    <span class="btn-spinner" aria-hidden="true"></span>
                </button>

                <p class="signup-prompt" id="signupPrompt">
                    Already have an account?
                    <a href="${pageContext.request.contextPath}/auth/login.jsp" class="signup-link">Login</a>
                </p>

            </form>
        </div>

    </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.5/gsap.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/login.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/register.js"></script>
</body>
</html>