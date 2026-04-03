package com.abhi.controller;

import java.io.IOException;

import com.abhi.dao.TaskDAO;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/updateTask")
public class UpdateTaskServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        int tid = Integer.parseInt(req.getParameter("tid"));

        TaskDAO dao = new TaskDAO();
        dao.updateTaskStatus(tid, "completed");

        res.sendRedirect("viewTasks.jsp");
    }
}