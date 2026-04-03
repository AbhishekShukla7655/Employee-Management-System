package com.abhi.controller;

import java.io.IOException;

import com.abhi.dao.UserDAO;
import com.abhi.model.User;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        // Create User Object
        User user = new User();
        user.setName(name);
        user.setEmail(email);
        user.setPassword(password);

        // Default role
        user.setRole("employee");

        // Save to DB
        UserDAO dao = new UserDAO();
        boolean result = dao.registerUser(user);

        if (result) {
        	res.sendRedirect("login.jsp");
        } else {
            res.getWriter().println("Something went wrong ❌");
        }
    }
}