package com.food.controller.customer;

import java.io.IOException;

import com.food.dao.MenuDAO;
import com.food.daoimpl.MenuDAOImpl;
import com.food.model.Cart;
import com.food.model.Menu;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    private MenuDAO menuDAO;

    @Override
    public void init() {
        menuDAO = new MenuDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();

        Cart cart = (Cart) session.getAttribute("cart");

        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }

        String action = req.getParameter("action");

        if (action != null) {

            int menuId =
                    Integer.parseInt(req.getParameter("menuId"));

            switch (action) {

                case "add":

                    Menu menu = menuDAO.getMenuById(menuId);

                    // First item in cart
                    if (cart.isEmpty()) {

                        cart.setRestaurantId(
                                menu.getRestaurantId()
                        );
                    }

                    // Another restaurant selected
                    else if (cart.getRestaurantId()
                            != menu.getRestaurantId()) {

                    	req.setAttribute(
                    		    "error",
                    		    "Your cart already contains items from another restaurant. Clear the cart to add this item."
                    		);

                        req.setAttribute(
                                "newMenuId",
                                menuId
                        );

                        req.getRequestDispatcher(
                                "/customer/cart.jsp"
                        ).forward(req, resp);

                        return;
                    }

                    cart.addItem(menu);
                    break;


                case "replace":

                    Menu newMenu =
                            menuDAO.getMenuById(menuId);

                    cart.clearCart();

                    cart.setRestaurantId(
                            newMenu.getRestaurantId()
                    );

                    cart.addItem(newMenu);

                    break;


                case "increase":

                    cart.increaseQuantity(menuId);
                    break;


                case "decrease":

                    cart.decreaseQuantity(menuId);

                    if (cart.isEmpty()) {
                        cart.setRestaurantId(-1);
                    }

                    break;


                case "remove":

                    cart.removeItem(menuId);

                    if (cart.isEmpty()) {
                        cart.setRestaurantId(-1);
                    }

                    break;
            }
        }

        req.getRequestDispatcher("/customer/cart.jsp")
           .forward(req, resp);
    }
}