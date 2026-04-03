package com.abhi.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {

	public static Connection getConnection() throws SQLException, ClassNotFoundException {
		
		Class.forName("com.mysql.cj.jdbc.Driver");
		
		String url = "jdbc:mysql://localhost:3306/EMS";		
		String user="root";
		String password="Abhishek@123";
		
		return DriverManager.getConnection(url,user,password);
		
	}
}
