package com.abhi.controller;

import java.io.IOException;

import com.abhi.dao.UserDAO;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/updateRole")
public class UpdateRoleServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        int eid = Integer.parseInt(req.getParameter("eid"));
        String role = req.getParameter("role");

        UserDAO dao = new UserDAO();
        dao.updateRole(eid, role);

        res.sendRedirect("admin.jsp");
    }
}