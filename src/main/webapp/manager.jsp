<%@ page import="com.abhi.model.User" %>

<%
response.setHeader("Cache-Control", "no-cache,no-store,must-revalidate");
response.setHeader("Pragma","no-cache");
response.setDateHeader("Expires", 0);

User user = (User) session.getAttribute("user");

if(user == null || !"manager".equals(user.getRole())){
    response.sendRedirect("login.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Manager Dashboard</title>
</head>
<body>

<h2>Manager Dashboard 😎</h2>

<p>Welcome <%= user.getName() %></p>

<a href="addTask.jsp">➕ Add Task</a><br><br>
<a href="managerTasks.jsp">📋 View Assigned Tasks</a><br><br>
<a href="logout">Logout</a>

</body>
</html>