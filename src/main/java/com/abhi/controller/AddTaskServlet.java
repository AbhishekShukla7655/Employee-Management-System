package com.abhi.controller;

import java.io.IOException;

import com.abhi.dao.TaskDAO;
import com.abhi.model.Task;
import com.abhi.model.User;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/addTask")
public class AddTaskServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

    	HttpSession session = req.getSession(false);

    	if(session == null){
    	    res.sendRedirect("login.jsp");
    	    return;
    	}

    	User user = (User) session.getAttribute("user");

    	if(user == null){
    	    res.sendRedirect("login.jsp");
    	    return;
    	}

        String title = req.getParameter("title");
        String description = req.getParameter("description");
        int assignedTo = Integer.parseInt(req.getParameter("assignedTo"));

        Task task = new Task();
        task.setTitle(title);
        task.setDescription(description);
        task.setAssignedBy(user.getEid()); // manager id
        task.setAssignedTo(assignedTo);
        task.setStatus("pending");

        TaskDAO dao = new TaskDAO();
        boolean result = dao.addTask(task);

        if(result){
        	res.sendRedirect("manager.jsp");
        } else {
            res.getWriter().println("Failed ❌");
        }
    }
}