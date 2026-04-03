package com.abhi.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.abhi.model.User;
import com.abhi.util.DBUtil;

public class UserDAO {
	public User login(String email, String password) {
		User user = null; 
		try {
			Connection conn = DBUtil.getConnection();
			String sql = "Select * from users where email = ? and password = ?";
			PreparedStatement ps = conn.prepareStatement(sql );
			ps.setString(1, email);
			ps.setString(2, password);
			ResultSet rs = ps.executeQuery();
			if(rs.next()) {
				user = new User();
				user.setEid(rs.getInt("eid"));
				user.setName(rs.getString("name"));
				user.setEmail(rs.getString("email")); 
				user.setRole(rs.getString("role"));
			}
		} catch (ClassNotFoundException | SQLException e) {
			e.printStackTrace();
		}
		return user;
	}
	public boolean registerUser(User user) {

	    boolean status = false;

	    try {
	        Connection con = DBUtil.getConnection();

	        String sql = "INSERT INTO users(name, email, password, role) VALUES(?,?,?,?)";

	        PreparedStatement ps = con.prepareStatement(sql);

	        ps.setString(1, user.getName());
	        ps.setString(2, user.getEmail());
	        ps.setString(3, user.getPassword());
	        ps.setString(4, user.getRole());

	        int rows = ps.executeUpdate();

	        if (rows > 0) {
	            status = true;
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return status;
	}


	public List<User> getAllUsers() {

	    List<User> list = new ArrayList<>();

	    try {
	        Connection con = DBUtil.getConnection();

	        String sql = "SELECT * FROM users";

	        PreparedStatement ps = con.prepareStatement(sql);

	        ResultSet rs = ps.executeQuery();

	        while (rs.next()) {
	            User user = new User();

	            user.setEid(rs.getInt("eid"));
	            user.setName(rs.getString("name"));
	            user.setEmail(rs.getString("email"));
	            user.setRole(rs.getString("role"));

	            list.add(user);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return list;
	}
	public boolean updateRole(int eid, String role) {

	    boolean status = false;

	    try {
	        Connection con = DBUtil.getConnection();

	        String sql = "UPDATE users SET role=? WHERE eid=?";

	        PreparedStatement ps = con.prepareStatement(sql);

	        ps.setString(1, role);
	        ps.setInt(2, eid);

	        int rows = ps.executeUpdate();

	        if (rows > 0) {
	            status = true;
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return status;
	}
	public List<User> getAllEmployees() {

	    List<User> list = new ArrayList<>();

	    try {
	        Connection con = DBUtil.getConnection();

	        String sql = "SELECT * FROM users WHERE role='employee'";

	        PreparedStatement ps = con.prepareStatement(sql);

	        ResultSet rs = ps.executeQuery();

	        while (rs.next()) {
	            User user = new User();

	            user.setEid(rs.getInt("eid"));
	            user.setName(rs.getString("name"));

	            list.add(user);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return list;
	}
}
