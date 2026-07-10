package com.food.filter;

import java.io.IOException;
import com.food.model.User;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebFilter("/admin/*")
public class AdminAuthFilter extends HttpFilter {

    @Override
    protected void doFilter(HttpServletRequest request,
                            HttpServletResponse response,
                            FilterChain chain)
            throws IOException, ServletException {

        HttpSession session = request.getSession(false);
        User user = null;

        if (session != null) {
            user = (User) session.getAttribute("loggedInUser");
        }

        // Strict Authorization Check: User must be logged in AND have ADMIN role
        if (user != null && "ADMIN".equalsIgnoreCase(user.getRole())) {
            chain.doFilter(request, response);
        } else {
            // Redirect to login page with an unauthorized error query parameter
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp?error=unauthorized");
        }
    }
}
