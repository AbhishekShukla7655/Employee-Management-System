<%@ page import="java.util.*, com.abhi.model.*" %>

<%
response.setHeader("Cache-Control", "no-cache,no-store,must-revalidate");
response.setHeader("Pragma","no-cache");
response.setDateHeader("Expires", 0);

User user = (User) session.getAttribute("user");

if(user == null || !"employee".equals(user.getRole())){
    response.sendRedirect("login.jsp");
    return;
}

com.abhi.dao.TaskDAO dao = new com.abhi.dao.TaskDAO();
List<Task> tasks = dao.getTasksByEmployee(user.getEid());
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Tasks</title>
</head>
<body>

<h2>My Tasks</h2>

<table border="1">
<tr>
    <th>Title</th>
    <th>Description</th>
    <th>Status</th>
</tr>

<%
for(Task t : tasks){
%>

<tr>
    <td><%= t.getTitle() %></td>
    <td><%= t.getDescription() %></td>
    <td>
    <%= t.getStatus() %>

    <% if("pending".equalsIgnoreCase(t.getStatus())){ %>

        <form action="updateTask" method="post" style="display:inline;">
            <input type="hidden" name="tid" value="<%= t.getTid() %>">
            <button type="submit">Complete</button>
        </form>

    <% } %>

</td>
</tr>

<%
}
%>

</table>

<br>
<a href="employee.jsp">Back</a>

</body>
</html>