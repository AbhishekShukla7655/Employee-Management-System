<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

    
 <%@ page import="com.abhi.model.User" %>
    
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Employee Dashboard</title>
</head>
<body>

<%

response.setHeader("Cache-Control", "no-cache,no-store,must-revalidate");
response.setHeader("Pragma","no-cache");
response.setDateHeader("Expires", 0);

User user  = (User) session.getAttribute("user");

if(user==null){
	response.sendRedirect("login.jsp");
	return;
}
if(!"employee".equals(user.getRole())){
	response.sendRedirect("login.jsp");
	return;
}
%>

<h1>Employee Dashboard 👨‍💻</h1>
<p>Welcome <%= user.getName() %></p>

<a href="viewTasks.jsp">📋 View My Tasks</a><br><br>

<a href="logout">Logout</a>





</body>
</html>