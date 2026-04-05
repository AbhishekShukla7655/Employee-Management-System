package com.abhi.controller;

import java.io.IOException;
import java.sql.Date;

import com.abhi.dao.TaskDAO;
import com.abhi.model.Task;
import com.abhi.model.User;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/addTask")
public class AddTaskServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        // ── Session & Role Check ──
        HttpSession session = req.getSession(false);
        if (session == null) { res.sendRedirect("index.jsp"); return; }

        User user = (User) session.getAttribute("user");
        if (user == null || !"manager".equals(user.getRole())) {
            res.sendRedirect("index.jsp");
            return;
        }

        // ── Read Form Parameters ──
        String title       = req.getParameter("title");
        String description = req.getParameter("description");
        int    assignedTo  = Integer.parseInt(req.getParameter("assignedTo"));
        String dueDateStr  = req.getParameter("dueDate"); // "yyyy-MM-dd"

        // ── Build Task ──
        Task task = new Task();
        task.setTitle(title);
        task.setDescription(description);
        task.setAssignedBy(user.getEid());   // manager's ID
        task.setAssignedTo(assignedTo);
        task.setStatus("pending");

        // Today's date as assigned_date
        task.setAssignedDate(new Date(System.currentTimeMillis()));

        // Due date from form (null-safe)
        if (dueDateStr != null && !dueDateStr.isEmpty()) {
            task.setDueDate(Date.valueOf(dueDateStr)); // parses "yyyy-MM-dd" directly
        }

        // ── Save to DB ──
        TaskDAO dao = new TaskDAO();
        boolean result = dao.addTask(task);

        if (result) {
            session.setAttribute("successMsg", "Task assigned successfully! ✅");
            res.sendRedirect("manager.jsp");
        } else {
            session.setAttribute("errorMsg", "Failed to assign task. Please try again. ❌");
            res.sendRedirect("manager.jsp");
        }
    }
}