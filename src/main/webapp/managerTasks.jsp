<%@ page import="java.util.*, com.abhi.model.*, com.abhi.dao.*" %>

<%
response.setHeader("Cache-Control", "no-cache,no-store,must-revalidate");
response.setHeader("Pragma","no-cache");
response.setDateHeader("Expires", 0);

User user = (User) session.getAttribute("user");

if(user == null || !"manager".equals(user.getRole())){
    response.sendRedirect("login.jsp");
    return;
}

TaskDAO dao = new TaskDAO();
List<Task> tasks = dao.getTasksByManager(user.getEid());
%>

<h2>Tasks Assigned By You</h2>

<table border="1">
<tr>
    <th>Title</th>
    <th>Description</th>
    <th>Assigned To</th>
    <th>Status</th>
</tr>

<%
for(Task t : tasks){
%>

<tr>
    <td><%= t.getTitle() %></td>
    <td><%= t.getDescription() %></td>
    <td><%= t.getAssignedTo() %></td>
    <td><%= t.getStatus() %></td>
</tr>

<%
}
%>

</table>

<br>
<a href="manager.jsp">Back</a>