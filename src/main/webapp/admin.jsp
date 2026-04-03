<%@ page import="java.util.*, com.abhi.model.*, com.abhi.dao.*" %>

<%
response.setHeader("Cache-Control", "no-cache,no-store,must-revalidate");
response.setHeader("Pragma","no-cache");
response.setDateHeader("Expires", 0);

User user = (User) session.getAttribute("user");

if(user == null || !"admin".equals(user.getRole())){
    response.sendRedirect("login.jsp");
    return;
}

UserDAO dao = new UserDAO();
List<User> users = dao.getAllUsers();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Dashboard</title>
</head>
<body>

<h2>Admin Dashboard 🔥</h2>

<table border="1">
<tr>
    <th>ID</th>
    <th>Name</th>
    <th>Email</th>
    <th>Role</th>
    <th>Change Role</th>
</tr>

<%
for(User u : users){
%>

<tr>
    <td><%= u.getEid() %></td>
    <td><%= u.getName() %></td>
    <td><%= u.getEmail() %></td>
    <td><%= u.getRole() %></td>

    <td>
        <form action="updateRole" method="post">
            <input type="hidden" name="eid" value="<%= u.getEid() %>">

            <select name="role">
                <option value="employee">Employee</option>
                <option value="manager">Manager</option>
                <option value="admin">Admin</option>
            </select>

            <button type="submit">Update</button>
        </form>
    </td>
</tr>

<%
}
%>

</table>

<br>
<a href="logout">Logout</a>

</body>
</html>