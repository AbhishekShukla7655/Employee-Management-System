package com.abhi.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {

	public static Connection getConnection() throws SQLException, ClassNotFoundException {

		Class.forName("org.postgresql.Driver");
		String url = System.getenv("DB_URL");
		String user = System.getenv("DB_USERNAME");
		String password = System.getenv("DB_PASSWORD");

		return DriverManager.getConnection(url, user, password);

	}
}
