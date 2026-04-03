package com.abhi.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.abhi.model.Task;
import com.abhi.util.DBUtil;

public class TaskDAO {

    public boolean addTask(Task task) {

        boolean status = false;

        try {
            Connection con = DBUtil.getConnection();

            String sql = "INSERT INTO tasks(title, description, assigned_by, assigned_to, status) VALUES(?,?,?,?,?)";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, task.getTitle());
            ps.setString(2, task.getDescription());
            ps.setInt(3, task.getAssignedBy());
            ps.setInt(4, task.getAssignedTo());
            ps.setString(5, task.getStatus());

            int rows = ps.executeUpdate();

            if (rows > 0) {
                status = true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }
    
    public List<Task> getTasksByEmployee(int empId) {

        List<Task> list = new ArrayList<>();

        try {
            Connection con = DBUtil.getConnection();

            String sql = "SELECT * FROM tasks WHERE assigned_to=?";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, empId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Task task = new Task();

                task.setTid(rs.getInt("tid"));
                task.setTitle(rs.getString("title"));
                task.setDescription(rs.getString("description"));
                task.setAssignedBy(rs.getInt("assigned_by"));
                task.setAssignedTo(rs.getInt("assigned_to"));
                task.setStatus(rs.getString("status"));

                list.add(task);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    
    public boolean updateTaskStatus(int tid, String status) {

        boolean flag = false;

        try {
            Connection con = DBUtil.getConnection();

            String sql = "UPDATE tasks SET status=? WHERE tid=?";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, status);
            ps.setInt(2, tid);

            int rows = ps.executeUpdate();

            if (rows > 0) {
                flag = true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return flag;
    }
    public List<Task> getTasksByManager(int managerId) {

        List<Task> list = new ArrayList<>();

        try {
            Connection con = DBUtil.getConnection();

            String sql = "SELECT * FROM tasks WHERE assigned_by=?";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, managerId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Task t = new Task();

                t.setTid(rs.getInt("tid"));
                t.setTitle(rs.getString("title"));
                t.setDescription(rs.getString("description"));
                t.setAssignedTo(rs.getInt("assigned_to"));
                t.setStatus(rs.getString("status"));

                list.add(t);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    
}