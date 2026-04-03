package com.abhi.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;

import com.abhi.dao.UserDAO;
import com.abhi.model.User;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String email = request.getParameter("email");
		String password = request.getParameter("password");
		
		UserDAO dao = new UserDAO();
		User user = dao.login(email, password);
		
		PrintWriter out = response.getWriter();
		
		if(user!=null) {
			HttpSession session = request.getSession();
			session.setAttribute("user", user);
			String role = user.getRole();

			if("admin".equalsIgnoreCase(role)) {
			    response.sendRedirect("admin.jsp");
			} 
			else if("manager".equalsIgnoreCase(role)) {
			    response.sendRedirect("manager.jsp");
			} 
			else {
			    response.sendRedirect("employee.jsp");
			}
			
		}else {
			out.println("Invalid User or password");
		}
		
	}

}
