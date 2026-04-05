package com.abhi.controller;

import java.io.IOException;

import com.abhi.dao.TaskDAO;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/updateTask")
public class UpdateTaskServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int tid = Integer.parseInt(request.getParameter("tid"));
        String status = request.getParameter("status");

        TaskDAO dao = new TaskDAO();
        dao.updateTaskStatus(tid, status);

        response.sendRedirect("employee.jsp");
    }
}