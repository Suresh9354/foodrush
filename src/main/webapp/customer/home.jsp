<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.food.model.Restaurant" %>
<%
    List<Restaurant> restaurants = (List<Restaurant>) request.getAttribute("restaurants");
    List<String> categories = (List<String>) request.getAttribute("categories");
%>

<%!
public String getCategoryImage(String category, String contextPath) {
    if (category == null) return contextPath + "/assets/images/menu/idlivada.png";
    String lower = category.toLowerCase().trim();
    if (lower.contains("biryani") || lower.contains("biriyani")) {
        return contextPath + "/assets/images/categories/biriyani.jpeg";
    } else if (lower.contains("burger")) {
        return contextPath + "/assets/images/categories/Burger.png";
    } else if (lower.contains("pizza")) {
        return contextPath + "/assets/images/categories/pizzaa.png";
    } else if (lower.contains("kfc")) {
        return contextPath + "/assets/images/categories/kfc_bucket.png";
    } else if (lower.contains("cake") || lower.contains("bakery")) {
        return contextPath + "/assets/images/categories/cake.png";
    } else if (lower.contains("beverage") || lower.contains("coffee") || lower.contains("cappuccino") || lower.contains("drink")) {
        return contextPath + "/assets/images/categories/coffee.png";
    }else if (lower.contains("fried chicken")) {
        return contextPath + "/assets/images/categories/friedchiken.png";
    }  else {
        return contextPath + "/assets/images/categories/idlivada.png";
    }
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FoodRush | Delicious Food, Delivered Fast</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/global.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/navbar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css?v=<%= System.currentTimeMillis() %>">
</head>
<body>

    <!-- NAVBAR HEADER -->
    <jsp:include page="/components/navbar.jsp"/>

    <!-- HERO SECTION -->
    <section class="hero-section">
        <div class="container hero-container">
            <div class="hero-left">
                <div class="fresh-pill">
                    <span class="fire-emoji">🔥</span> Hot & Fresh Delivered
                </div>
                <h1 class="hero-title">Delicious Food,<br>Delivered <span class="highlight">Fast</span></h1>
                <div class="accent-line"></div>
                <p class="hero-subtitle">Order your favorite meals from top restaurants and get them delivered to your doorstep in no time.</p>
                
                <!-- Search Bar -->
                <div class="search-bar-container">
                    <div class="search-input-wrapper">
                        <svg class="search-icon" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <circle cx="11" cy="11" r="8"></circle>
                            <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                        </svg>
                        <input type="text" id="restaurantSearch" placeholder="Search Restaurant...">
                    </div>
                    <button class="btn btn-primary search-btn" onclick="triggerSearch()">Search</button>
                </div>

                <!-- Quality Badges -->
                <div class="quality-badges">
                    <div class="badge-item">
                        <div class="badge-icon-wrapper">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="var(--primary-color)" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                <polyline points="20 6 9 17 4 12"></polyline>
                            </svg>
                        </div>
                        <div class="badge-text">
                            <h4>Fast Delivery</h4>
                            <p>On time, every time</p>
                        </div>
                    </div>
                    <div class="badge-item">
                        <div class="badge-icon-wrapper">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="var(--primary-color)" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                <polyline points="20 6 9 17 4 12"></polyline>
                            </svg>
                        </div>
                        <div class="badge-text">
                            <h4>Best Offers</h4>
                            <p>Great deals & discounts</p>
                        </div>
                    </div>
                    <div class="badge-item">
                        <div class="badge-icon-wrapper">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="var(--primary-color)" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                <polyline points="20 6 9 17 4 12"></polyline>
                            </svg>
                        </div>
                        <div class="badge-text">
                            <h4>Safe & Secure</h4>
                            <p>100% contactless</p>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="hero-right-spacer"></div>
        </div>
    </section>

    <!-- FLOATING STATS BANNER -->
    <div class="stats-banner-container">
        <div class="container stats-banner">
            <div class="stat-item">
                <div class="stat-icon-wrapper">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <rect x="3" y="3" width="7" height="9"></rect>
                        <rect x="14" y="3" width="7" height="5"></rect>
                        <rect x="14" y="12" width="7" height="9"></rect>
                        <rect x="3" y="16" width="7" height="5"></rect>
                    </svg>
                </div>
                <div class="stat-content">
                    <h3>500+</h3>
                    <p>Restaurants</p>
                </div>
            </div>
            <div class="stat-item">
                <div class="stat-icon-wrapper">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                        <circle cx="9" cy="7" r="4"></circle>
                        <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                        <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                    </svg>
                </div>
                <div class="stat-content">
                    <h3>50K+</h3>
                    <p>Happy Customers</p>
                </div>
            </div>
            <div class="stat-item">
                <div class="stat-icon-wrapper">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M6 2L3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4z"></path>
                        <line x1="3" y1="6" x2="21" y2="6"></line>
                        <path d="M16 10a4 4 0 0 1-8 0"></path>
                    </svg>
                </div>
                <div class="stat-content">
                    <h3>100K+</h3>
                    <p>Orders Delivered</p>
                </div>
            </div>
            <div class="stat-item">
                <div class="stat-icon-wrapper">
                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon>
                    </svg>
                </div>
                <div class="stat-content">
                    <h3>4.7</h3>
                    <p>Top Rating</p>
                </div>
            </div>
        </div>
    </div>

    <!-- POPULAR CATEGORIES SECTION -->
    <section class="section categories-section" id="categories">
        <div class="container">
            <div class="section-header-carousel" data-aos="fade-up">
                <h2 class="section-title">What's on your mind?</h2>
                <div class="carousel-controls">
                    <button class="ctrl-btn prev-btn" onclick="slideCategories('prev')">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 18 9 12 15 6"></polyline></svg>
                    </button>
                    <button class="ctrl-btn next-btn" onclick="slideCategories('next')">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="9 18 15 12 9 6"></polyline></svg>
                    </button>
                </div>
            </div>
            
            <div class="category-carousel-wrapper no-scrollbar" id="categoryCarousel">
                <%
                if (categories != null) {
                    int catIdx = 0;
                    for (String category : categories) {
                        catIdx++;
                        String imgUrl = getCategoryImage(category, request.getContextPath());
                %>
                <a href="${pageContext.request.contextPath}/menu?category=<%= category %>" class="category-slide" data-aos="fade-up" data-aos-delay="<%= 100 + ((catIdx - 1) % 4) * 50 %>">
                    <div class="category-circle">
                        <img src="<%= imgUrl %>" alt="<%= category %>" onerror="this.src='${pageContext.request.contextPath}/assets/images/menu/idlivada.png'">
                    </div>
                    <span><%= category %></span>
                </a>
                <%
                    }
                }
                %>
            </div>
        </div>
    </section>

    <!-- POPULAR RESTAURANTS SECTION -->
    <section class="section restaurants-section" id="restaurant">
        <div class="container">
            <div class="section-header-carousel" data-aos="fade-up">
                <div>
                    <h2 class="section-title" id="restaurant-section-title">Top Restaurants</h2>
                    <p class="section-subtitle" id="restaurant-section-subtitle">Best food options available near you</p>
                </div>
                <div class="carousel-controls">
                    <a href="${pageContext.request.contextPath}/restaurants" class="btn btn-outline">View All Restaurants</a>
                </div>
            </div>

            <div class="restaurants-carousel-wrapper no-scrollbar" id="restaurantCarousel">
                <%
                if (restaurants != null && !restaurants.isEmpty()) {
                    int idx = 0;
                    for (Restaurant r : restaurants) {
                        idx++;
                        String discountTag = "";
                        if (idx % 4 == 1) {
                            discountTag = "70% OFF UPTO ₹130";
                        } else if (idx % 4 == 2) {
                            discountTag = "60% OFF UPTO ₹120";
                        } else if (idx % 4 == 3) {
                            discountTag = "ITEMS AT ₹69";
                        } else {
                            discountTag = "ITEMS AT ₹59";
                        }
                %>
                <div class="restaurant-card-wrapper" data-aos="fade-up" data-aos-delay="<%= 100 + ((idx - 1) % 4) * 100 %>" data-name="<%= r.getName().toLowerCase() %>" data-cuisine="<%= r.getCuisine().toLowerCase() %>">
                    <div class="card restaurant-card">
                        <div class="restaurant-image-wrapper">
                            <img src="${pageContext.request.contextPath}/<%= r.getImageUrl() %>" alt="<%= r.getName() %>" onerror="this.src='${pageContext.request.contextPath}/assets/images/restaurants/burgerking.png'">
                            <div class="discount-badge"><%= discountTag %></div>
                        </div>
                        <div class="restaurant-card-content">
                            <h3 class="restaurant-card-title"><%= r.getName() %></h3>
                            <div class="restaurant-meta">
                                <span class="rating-badge">
                                    <svg class="star-icon" viewBox="0 0 24 24" fill="currentColor">
                                        <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon>
                                    </svg>
                                    <%= r.getRating() %>
                                </span>
                                <span class="meta-dot">•</span>
                                <span class="delivery-time"><%= r.getDeliveryTime() %>-<%= r.getDeliveryTime() + 10 %> mins</span>
                            </div>
                            <p class="cuisine-list"><%= r.getCuisine() %></p>
                            <p class="restaurant-address"><%= r.getAddress() %></p>
                            
                            <div class="card-action-bar">
                                <a href="${pageContext.request.contextPath}/menu?restaurantId=<%= r.getRestaurantId() %>" class="btn btn-primary order-btn">
                                    <span>View Menu</span>
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                        <line x1="5" y1="12" x2="19" y2="12"></line>
                                        <polyline points="12 5 19 12 12 19"></polyline>
                                    </svg>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
                <%
                    }
                } else {
                %>
                <div class="no-restaurants">
                    <p>No active restaurants found. Please contact support.</p>
                </div>
                <%
                }
                %>
            </div>
            
            <!-- Filter Message for Empty Searches -->
            <div class="no-results-message" id="noResultsMessage">
                <svg width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="var(--light-text)" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="11" cy="11" r="8"></circle>
                    <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                </svg>
                <h3>No Restaurants Found</h3>
                <p>We couldn't find any restaurants matching your search or filter. Try checking your spelling or selecting another category.</p>
                <button class="btn btn-outline" onclick="resetFilters()">Clear Filters</button>
            </div>
        </div>
    </section>

    <!-- BEST OFFERS SECTION -->
    <section class="section offers-section" id="offers">
        <div class="container">
            <div class="section-header-carousel">
                <div>
                    <h2 class="section-title">Best Offers For You</h2>
                    <p class="section-subtitle">Delicious deals to make your day better</p>
                </div>
                <div class="carousel-controls">
                    <button class="ctrl-btn prev-btn" onclick="slideOffers('prev')">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 18 9 12 15 6"></polyline></svg>
                    </button>
                    <button class="ctrl-btn next-btn" onclick="slideOffers('next')">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="9 18 15 12 9 6"></polyline></svg>
                    </button>
                </div>
            </div>

            <div class="offers-carousel-wrapper no-scrollbar" id="offersCarousel">
                <!-- Coupon 1 -->
                <div class="offer-card-wrapper">
                    <div class="card offer-card promo-orange">
                        <div class="offer-left">
                            <span class="offer-badge">FLAT</span>
                            <span class="offer-value">50% OFF</span>
                            <span class="offer-desc">On First Order</span>
                            <div class="promo-code-box">
                                <span>USE CODE: <strong>FOOD50</strong></span>
                            </div>
                        </div>
                        <div class="offer-right">
                            <img src="${pageContext.request.contextPath}/assets/images/categories/idlivada.png" alt="Dosa Deal">
                        </div>
                    </div>
                </div>
                <!-- Coupon 2 -->
                <div class="offer-card-wrapper">
                    <div class="card offer-card promo-yellow">
                        <div class="offer-left">
                            <span class="offer-badge">UPTO</span>
                            <span class="offer-value">40% OFF</span>
                            <span class="offer-desc">On Biryani's</span>
                            <div class="promo-code-box">
                                <span>USE CODE: <strong>BIRYANI40</strong></span>
                            </div>
                        </div>
                        <div class="offer-right">
                            <img src="${pageContext.request.contextPath}/assets/images/categories/friedchiken.png" alt="Biryani Deal">
                        </div>
                    </div>
                </div>
                <!-- Coupon 3 -->
                <div class="offer-card-wrapper">
                    <div class="card offer-card promo-red">
                        <div class="offer-left">
                            <span class="offer-badge">FLAT</span>
                            <span class="offer-value">₹60 OFF</span>
                            <span class="offer-desc">On Orders Above ₹199</span>
                            <div class="promo-code-box">
                                <span>USE CODE: <strong>SAVE60</strong></span>
                            </div>
                        </div>
                        <div class="offer-right">
                            <img src="${pageContext.request.contextPath}/assets/images/categories/Burger.png" alt="Burger Deal">
                        </div>
                    </div>
                </div>
                <!-- Coupon 4 -->
                <div class="offer-card-wrapper">
                    <div class="card offer-card promo-blue">
                        <div class="offer-left">
                            <span class="offer-value offer-value-free">FREE</span>
                            <span class="offer-value offer-value-delivery">DELIVERY</span>
                            <span class="offer-desc">On Orders Above ₹149</span>
                            <div class="promo-code-box">
                                <span>NO CODE REQUIRED</span>
                            </div>
                        </div>
                        <div class="offer-right">
                            <div class="scooter-fallback">
                                
                              <img src="${pageContext.request.contextPath}/assets/images/logo/scootyadmin.png" alt="Burger Deal">
                        
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- TESTIMONIALS SECTION -->
    <section class="section testimonials-section" id="about-us">
        <div class="container">
            <div class="section-header-carousel">
                <div>
                    <h2 class="section-title">What Our Customers Say</h2>
                    <p class="section-subtitle">Real reviews from real food lovers</p>
                </div>
                <div class="carousel-controls">
                    <button class="ctrl-btn prev-btn" onclick="slideTestimonials('prev')">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="15 18 9 12 15 6"></polyline></svg>
                    </button>
                    <button class="ctrl-btn next-btn" onclick="slideTestimonials('next')">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="9 18 15 12 9 6"></polyline></svg>
                    </button>
                </div>
            </div>

            <div class="testimonials-carousel-wrapper no-scrollbar" id="testimonialsCarousel">
                <!-- Review 1 -->
                <div class="testimonial-card-wrapper">
                    <div class="card testimonial-card">
                        <div class="testimonial-top">
                            <div class="user-profile">
                                <div class="avatar-initial color-a">AR</div>
                                <div class="user-meta">
                                    <h4>Arjun R.</h4>
                                    <div class="rating-stars">★★★★★</div>
                                    <span class="review-date">2 days ago</span>
                                </div>
                            </div>
                            <div class="food-thumbnail">
                                <img src="${pageContext.request.contextPath}/assets/images/menu/dosa.jpg" alt="Dosa">
                            </div>
                        </div>
                        <div class="testimonial-body">
                            <p class="quote-text">"Amazing South Indian meals! Dosa was crispy and sambhar was perfect. Will order again!"</p>
                        </div>
                        <div class="quote-icon">“</div>
                    </div>
                </div>
                <!-- Review 2 -->
                <div class="testimonial-card-wrapper">
                    <div class="card testimonial-card">
                        <div class="testimonial-top">
                            <div class="user-profile">
                                <div class="avatar-initial color-b">PS</div>
                                <div class="user-meta">
                                    <h4>Priya S.</h4>
                                    <div class="rating-stars">★★★★★</div>
                                    <span class="review-date">3 days ago</span>
                                </div>
                            </div>
                            <div class="food-thumbnail">
                                <img src="${pageContext.request.contextPath}/assets/images/categories/biriyani.jpeg" alt="Biryani">
                            </div>
                        </div>
                        <div class="testimonial-body">
                            <p class="quote-text">"Biryani was flavorful and well packed. Delivery was on time. Loved it!"</p>
                        </div>
                        <div class="quote-icon">“</div>
                    </div>
                </div>
                <!-- Review 3 -->
                <div class="testimonial-card-wrapper">
                    <div class="card testimonial-card">
                        <div class="testimonial-top">
                            <div class="user-profile">
                                <div class="avatar-initial color-c">KM</div>
                                <div class="user-meta">
                                    <h4>Karthik M.</h4>
                                    <div class="rating-stars">★★★★★</div>
                                    <span class="review-date">1 week ago</span>
                                </div>
                            </div>
                            <div class="food-thumbnail">
                                <img src="${pageContext.request.contextPath}/assets/images/categories/Burger.png" alt="Burger">
                            </div>
                        </div>
                        <div class="testimonial-body">
                            <p class="quote-text">"Great food quality and hygienic packaging. Highly recommended!"</p>
                        </div>
                        <div class="quote-icon">“</div>
                    </div>
                </div>
                <!-- Review 4 -->
                <div class="testimonial-card-wrapper">
                    <div class="card testimonial-card">
                        <div class="testimonial-top">
                            <div class="user-profile">
                                <div class="avatar-initial color-d">SL</div>
                                <div class="user-meta">
                                    <h4>Sneha L.</h4>
                                    <div class="rating-stars">★★★★★</div>
                                    <span class="review-date">1 week ago</span>
                                </div>
                            </div>
                            <div class="food-thumbnail">
                                <img src="${pageContext.request.contextPath}/assets/images/categories/cake.png" alt="Cake">
                            </div>
                        </div>
                        <div class="testimonial-body">
                            <p class="quote-text">"I love the variety of dishes and the offers are just awesome!"</p>
                        </div>
                        <div class="quote-icon">“</div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- FOOTER -->
    <jsp:include page="/components/footer.jsp"/>

    <!-- CLIENT FILTERS & CAROUSEL SCRIPT -->
    <script src="${pageContext.request.contextPath}/assets/js/home.js?v=<%= System.currentTimeMillis() %>"></script>
</body>
</html>