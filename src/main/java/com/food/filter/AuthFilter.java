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

@WebFilter({
    "/home",
    "/restaurants",
    "/menu",
    "/cart",
    "/orders",
    "/profile",
    "/place-order",
    "/order-status"
})
public class AuthFilter extends HttpFilter {

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

        if (user != null) {

            chain.doFilter(request, response);

        } else {

            response.sendRedirect(
                request.getContextPath() + "/auth/login.jsp"
            );
        }
    }
}