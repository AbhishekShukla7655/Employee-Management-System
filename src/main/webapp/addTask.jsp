<%@ page import="java.util.*, com.abhi.dao.*, com.abhi.model.*" %>

<%
User user = (User) session.getAttribute("user");

// Session + Role check
if(user == null || !"manager".equals(user.getRole())){
    response.sendRedirect("index.jsp");
    return;
}

// Employee list fetch
UserDAO dao = new UserDAO();
List<User> empList = dao.getAllEmployees();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add Task</title>
</head>
<body>

<h2>Add Task</h2>

<form action="addTask" method="post">

    <label>Title:</label><br>
    <input type="text" name="title" required><br><br>

    <label>Description:</label><br>
    <textarea name="description"></textarea><br><br>

    <label>Select Employee:</label><br>
    <select name="assignedTo" required>
        <option value="">-- Select Employee --</option>

<%
for(User u : empList){
%>
        <option value="<%= u.getEid() %>">
            <%= u.getName() %> (ID: <%= u.getEid() %>)
        </option>
<%
}
%>

    </select><br><br>

    <button type="submit">Assign Task</button>

</form>

<br>
<a href="manager.jsp">Back</a>

</body>
</html>