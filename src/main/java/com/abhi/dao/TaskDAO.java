package com.abhi.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.abhi.model.Task;
import com.abhi.util.DBUtil;

public class TaskDAO {

    // ── Add new task (called from AddTaskServlet) ──────────────────────────────
    public boolean addTask(Task task) {

        boolean status = false;

        try {
            Connection con = DBUtil.getConnection();

            String sql = "INSERT INTO tasks (title, description, assigned_by, assigned_to, status, assigned_date, due_date) "
                       + "VALUES (?, ?, ?, ?, ?, ?, ?)";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, task.getTitle());
            ps.setString(2, task.getDescription());
            ps.setInt(3,    task.getAssignedBy());
            ps.setInt(4,    task.getAssignedTo());
            ps.setString(5, "pending");
            ps.setDate(6,   new java.sql.Date(task.getAssignedDate().getTime()));
            ps.setDate(7,   new java.sql.Date(task.getDueDate().getTime()));

            int rows = ps.executeUpdate();
            if (rows > 0) status = true;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }

    // ── Get all tasks assigned TO an employee (employee dashboard) ─────────────
    public List<Task> getTasksByEmployee(int empId) {

        List<Task> list = new ArrayList<>();

        try {
            Connection con = DBUtil.getConnection();

            // JOIN users to get the manager's name (assigned_by)
            String sql = "SELECT t.*, u.name AS assigned_by_name " +
                         "FROM tasks t " +
                         "JOIN users u ON t.assigned_by = u.eid " +
                         "WHERE t.assigned_to = ?";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, empId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Task task = new Task();

                task.setTid(rs.getInt("tid"));
                task.setTitle(rs.getString("title"));
                task.setDescription(rs.getString("description"));
                task.setAssignedBy(rs.getInt("assigned_by"));
                task.setAssignedByName(rs.getString("assigned_by_name")); // manager name
                task.setAssignedTo(rs.getInt("assigned_to"));
                task.setStatus(rs.getString("status"));
                task.setAssignedDate(rs.getDate("assigned_date"));
                task.setDueDate(rs.getDate("due_date"));

                list.add(task);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ── Update task status (called from UpdateTaskServlet) ─────────────────────
    public boolean updateTaskStatus(int tid, String status) {

        boolean flag = false;

        try {
            Connection con = DBUtil.getConnection();

            String sql = "UPDATE tasks SET status = ? WHERE tid = ?";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, tid);

            int rows = ps.executeUpdate();
            if (rows > 0) flag = true;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return flag;
    }

    // ── Get all tasks assigned BY a manager (manager dashboard) ───────────────
    public List<Task> getTasksByManager(int managerId) {

        List<Task> list = new ArrayList<>();

        try {
            Connection con = DBUtil.getConnection();

            // JOIN users to get the employee's name (assigned_to)
            String sql = "SELECT t.*, u.name AS assigned_to_name " +
                         "FROM tasks t " +
                         "JOIN users u ON t.assigned_to = u.eid " +
                         "WHERE t.assigned_by = ?";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, managerId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Task t = new Task();

                t.setTid(rs.getInt("tid"));
                t.setTitle(rs.getString("title"));
                t.setDescription(rs.getString("description"));
                t.setStatus(rs.getString("status"));
                t.setAssignedTo(rs.getInt("assigned_to"));
                t.setAssignedToName(rs.getString("assigned_to_name")); // employee name
                t.setAssignedDate(rs.getDate("assigned_date"));
                t.setDueDate(rs.getDate("due_date"));

                list.add(t);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}