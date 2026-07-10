<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String uri = request.getRequestURI();
    boolean isAdminPage = uri.contains("/admin/") || "admin".equalsIgnoreCase((String)request.getAttribute("layout"));
    if (isAdminPage) {
%>
    <footer class="admin-footer">
        <div class="admin-footer-content">
            <p>&copy; <%= java.util.Calendar.getInstance().get(java.util.Calendar.YEAR) %> <strong>FoodRush Admin Dashboard</strong>. All rights reserved.</p>
            <div class="admin-footer-links">
                <a href="#" class="admin-footer-link">Privacy Policy</a>
                <a href="#" class="admin-footer-link">Terms of Service</a>
                <a href="#" class="admin-footer-link">Support</a>
            </div>
        </div>
    </footer>
<%
    } else {
%>
<footer class="footer">
    <div class="container footer-container">
        <!-- Brand Info Column -->
        <div class="footer-col brand-col">
            <div class="footer-logo">
                <svg class="footer-logo-svg" viewBox="0 0 48 48" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M8 32H40C41.1 32 42 31.1 42 30V28H6V30C6 31.1 6.9 32 8 32Z" fill="var(--primary-color)" />
                    <path d="M24 10C15.16 10 8 17.16 8 26H40C40 17.16 32.84 10 24 10Z" fill="var(--primary-color)" />
                    <circle cx="24" cy="7" r="3" fill="var(--primary-color)" />
                    <path d="M4 18H1" stroke="var(--primary-color)" stroke-width="3" stroke-linecap="round"/>
                    <path d="M6 22H2" stroke="var(--primary-color)" stroke-width="3" stroke-linecap="round"/>
                    <path d="M5 14H2" stroke="var(--primary-color)" stroke-width="3" stroke-linecap="round"/>
                </svg>
                <span class="footer-logo-text">FoodRush</span>
            </div>
            <p class="footer-brand-desc">Delicious food, delivered fast to your doorstep. Satisfy your cravings in minutes.</p>
            <div class="social-links">
                <!-- Facebook -->
                <a href="#" aria-label="Facebook">
                    <svg width="18" height="18" fill="currentColor" viewBox="0 0 24 24"><path d="M9 8h-3v4h3v12h5v-12h3.642l.358-4h-4v-1.667c0-.955.192-1.333 1.115-1.333h2.885v-5h-3.808c-3.596 0-5.192 1.583-5.192 4.615v3.385z"/></svg>
                </a>
                <!-- Instagram -->
                <a href="#" aria-label="Instagram">
                    <svg width="18" height="18" fill="currentColor" viewBox="0 0 24 24"><path d="M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.849 0 3.205-.012 3.584-.069 4.849-.149 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07-3.204 0-3.584-.012-4.849-.07-3.26-.149-4.771-1.699-4.919-4.92-.058-1.265-.07-1.644-.07-4.849 0-3.204.013-3.583.07-4.849.149-3.227 1.664-4.771 4.919-4.919 1.266-.057 1.645-.069 4.849-.069zm0-2c-3.259 0-3.667.014-4.947.072-4.358.2-6.78 2.618-6.98 6.98-.059 1.281-.073 1.689-.073 4.948 0 3.259.014 3.668.072 4.948.2 4.358 2.618 6.78 6.98 6.98 1.281.058 1.689.072 4.948.072 3.259 0 3.668-.014 4.948-.072 4.354-.2 6.782-2.618 6.979-6.98.059-1.28.073-1.689.073-4.948 0-3.259-.014-3.667-.072-4.947-.196-4.354-2.617-6.78-6.979-6.98-1.281-.059-1.69-.073-4.949-.073zm0 5.838c-3.403 0-6.162 2.759-6.162 6.162s2.759 6.163 6.162 6.163 6.162-2.759 6.162-6.163c0-3.403-2.759-6.162-6.162-6.162zm0 10.162c-2.209 0-4-1.79-4-4 0-2.209 1.791-4 4-4s4 1.791 4 4c0 2.21-1.791 4-4 4zm6.406-11.845c-.796 0-1.441.645-1.441 1.44s.645 1.44 1.441 1.44c.795 0 1.439-.645 1.439-1.44s-.644-1.44-1.439-1.44z"/></svg>
                </a>
                <!-- Twitter -->
                <a href="#" aria-label="Twitter">
                    <svg width="18" height="18" fill="currentColor" viewBox="0 0 24 24"><path d="M24 4.557c-.883.392-1.832.656-2.828.775 1.017-.609 1.798-1.574 2.165-2.724-.951.564-2.005.974-3.127 1.195-.897-.957-2.178-1.555-3.594-1.555-3.179 0-5.515 2.966-4.797 6.045-4.091-.205-7.719-2.165-10.148-5.144-1.29 2.213-.669 5.108 1.523 6.574-.806-.026-1.566-.247-2.229-.616-.054 2.281 1.581 4.415 3.949 4.89-.693.188-1.452.232-2.224.084.626 1.956 2.444 3.379 4.6 3.419-2.07 1.623-4.678 2.348-7.29 2.04 2.179 1.397 4.768 2.212 7.548 2.212 9.142 0 14.307-7.721 13.995-14.646 1.014-.733 1.88-1.65 2.56-2.695z"/></svg>
                </a>
                <!-- YouTube -->
                <a href="#" aria-label="YouTube">
                    <svg width="18" height="18" fill="currentColor" viewBox="0 0 24 24"><path d="M23.498 6.163c-.272-1.016-1.071-1.815-2.087-2.087-1.838-.497-9.211-.497-9.211-.497s-7.373 0-9.211.497c-1.016.272-1.815 1.071-2.087 2.087-.497 1.838-.497 5.712-.497 5.712s0 3.874.497 5.713c.272 1.016 1.071 1.815 2.087 2.087 1.838.497 9.211.497 9.211.497s7.373 0 9.211-.497c1.016-.272 1.815-1.071 2.087-2.087.497-1.838.497-5.713.497-5.713s0-3.874-.497-5.712zm-14.498 8.837v-6l5.2 3-5.2 3z"/></svg>
                </a>
            </div>
        </div>

        <!-- Column 2: About Us -->
        <div class="footer-col">
            <h3>About Us</h3>
            <ul>
                <li><a href="#">Who We Are</a></li>
                <li><a href="#">Careers</a></li>
                <li><a href="#">Blog</a></li>
                <li><a href="#">Terms & Conditions</a></li>
                <li><a href="#">Privacy Policy</a></li>
            </ul>
        </div>

        <!-- Column 3: Help -->
        <div class="footer-col">
            <h3>Help</h3>
            <ul>
                <li><a href="#">Help Center</a></li>
                <li><a href="#">How It Works</a></li>
                <li><a href="#">Shipping & Delivery</a></li>
                <li><a href="#">Cancellation & Refund</a></li>
                <li><a href="#">Contact Us</a></li>
            </ul>
        </div>

        <!-- Column 4: Categories -->
        <div class="footer-col">
            <h3>Categories</h3>
            <ul>
                <li><a href="${pageContext.request.contextPath}/home#categories">South Indian</a></li>
                <li><a href="${pageContext.request.contextPath}/home#categories">North Indian</a></li>
                <li><a href="${pageContext.request.contextPath}/home#categories">Chinese</a></li>
                <li><a href="${pageContext.request.contextPath}/home#categories">Biryani</a></li>
                <li><a href="${pageContext.request.contextPath}/home#categories">Burgers</a></li>
                <li><a href="${pageContext.request.contextPath}/home#categories">Desserts</a></li>
            </ul>
        </div>

        <!-- Column 5: App & Newsletter -->
        <div class="footer-col app-newsletter-col">
            <h3>Download Our App</h3>
            <div class="app-badges">
                <!-- App Store Badge -->
                <a href="#" class="store-badge" aria-label="App Store">
                    <svg viewBox="0 0 135 40" width="120" height="36" fill="currentColor">
                        <rect width="135" height="40" rx="6" fill="#000" />
                        <!-- Simplified App Store Visual layout -->
                        <path d="M18.7 13.5c-.1-.8.4-1.5 1.1-1.9-.4-.5-1.1-.9-1.9-.9-1 0-1.8.6-2.3.6-.5 0-1.1-.5-1.9-.5-1.1 0-2.1.7-2.6 1.7-1.1 1.9-.3 4.8.8 6.3.5.7 1.1 1.6 1.9 1.5.8-.1 1.1-.5 2.1-.5s1.3.5 2.1.4c.8-.1 1.4-.7 1.9-1.4.5-.8.7-1.6.8-1.6-.1-.1-1.3-.5-1.3-2.1zM16.4 10c.4-.5.7-1.2.6-1.9-.6.1-1.3.4-1.7 1-.4.4-.7 1.1-.6 1.8.7.1 1.3-.3 1.7-.9z" fill="#FFF"/>
                        <text x="35" y="16" fill="#FFF" font-size="7" font-weight="bold">Download on the</text>
                        <text x="35" y="28" fill="#FFF" font-size="12" font-weight="bold">App Store</text>
                    </svg>
                </a>
                <!-- Google Play Badge -->
                <a href="#" class="store-badge" aria-label="Google Play">
                    <svg viewBox="0 0 135 40" width="120" height="36" fill="currentColor">
                        <rect width="135" height="40" rx="6" fill="#000" />
                        <!-- Simplified Google Play Triangle logo -->
                        <path d="M12.5 10.5v19l14-9.5-14-9.5z" fill="#FF5A00"/>
                        <text x="35" y="16" fill="#FFF" font-size="7" font-weight="bold">GET IT ON</text>
                        <text x="35" y="28" fill="#FFF" font-size="12" font-weight="bold">Google Play</text>
                    </svg>
                </a>
            </div>
            
            <h3 class="newsletter-heading">Subscribe to our newsletter</h3>
            <div class="newsletter-form">
                <input type="email" placeholder="Enter your email" aria-label="Email address">
                <button type="submit" aria-label="Subscribe">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="22" y1="2" x2="11" y2="13"></line>
                        <polygon points="22 2 15 22 11 13 2 9 22 2"></polygon>
                    </svg>
                </button>
            </div>
        </div>
    </div>

    <!-- Bottom Copyright and payment column -->
    <div class="footer-bottom">
        <div class="container footer-bottom-container">
            <p class="copyright-text">&copy; 2026 FoodRush. All rights reserved.</p>
            
            <div class="payment-and-secure">
                <div class="payment-methods">
                    <!-- Visa SVG -->
                    <span class="payment-icon" title="Visa">
                        <svg width="32" height="20" viewBox="0 0 36 24" fill="none">
                            <rect width="36" height="24" rx="3" fill="#1A1F71"/>
                            <path d="M13.666 16.34l1.624-10.08h2.603l-1.623 10.08h-2.604zm8.653-9.8c-.5-.22-1.32-.46-2.31-.46-2.54 0-4.34 1.35-4.35 3.3 0 1.43 1.28 2.23 2.25 2.7.99.49 1.33.8 1.33 1.23-.02.66-.79.97-1.53.97-1.02 0-1.57-.16-2.4-.53l-.33-.16-.36 2.2c.6.27 1.7.51 2.85.52 2.69 0 4.44-1.33 4.45-3.39.01-1.13-.67-2-2.15-2.7-.89-.46-1.44-.76-1.44-1.22.01-.42.47-.86 1.48-.86.83-.02 1.44.18 1.91.38l.23.1.37-2.28zm4.499 9.8l1.458-10.08h2.036c.45 0 .83.26.98.66l3.322 9.42H32.48l-.66-1.8H28.79l-.36 1.8h-2.13zm2.593-3.66l.72-3.59.41 2.05.28 1.54h-1.41zm-21.737-6.42l-2.54 6.9L7.433 7.84A1.916 1.916 0 005.69 6.54H2.033l.036.17 3.565 7.89-1.503 3.65h2.583l4.072-11.71h-2.583z" fill="#FFF"/>
                        </svg>
                    </span>
                    <!-- Mastercard SVG -->
                    <span class="payment-icon" title="Mastercard">
                        <svg width="32" height="20" viewBox="0 0 36 24" fill="none">
                            <rect width="36" height="24" rx="3" fill="#222"/>
                            <circle cx="14.5" cy="12" r="7" fill="#EB001B"/>
                            <circle cx="21.5" cy="12" r="7" fill="#F79E1B" fill-opacity="0.8"/>
                        </svg>
                    </span>
                    <!-- UPI / Paytm text represent -->
                    <span class="payment-text-badge">UPI</span>
                    <span class="payment-text-badge">Paytm</span>
                </div>
                
                <div class="secure-badge">
                    <svg class="lock-icon" width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                        <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                        <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                    </svg>
                    <span>100% Secure Payment</span>
                </div>
            </div>
        </div>
    </div>
</footer>
<%
    }
%>