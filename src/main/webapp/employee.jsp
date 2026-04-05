<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.abhi.model.*, java.util.*" %>

<%
  response.setHeader("Cache-Control", "no-cache,no-store,must-revalidate");
  response.setHeader("Pragma", "no-cache");
  response.setDateHeader("Expires", 0);

  User user = (User) session.getAttribute("user");
  if (user == null) { response.sendRedirect("index.jsp"); return; }
  if (!"employee".equalsIgnoreCase(user.getRole())) { response.sendRedirect("index.jsp"); return; }

  com.abhi.dao.TaskDAO dao = new com.abhi.dao.TaskDAO();
  List<Task> tasks = dao.getTasksByEmployee(user.getEid());

  List<Task> pendingTasks   = new ArrayList<>();
  List<Task> completedTasks = new ArrayList<>();
  int inProgressCount = 0;

  for (Task t : tasks) {
    if ("completed".equalsIgnoreCase(t.getStatus())) {
      completedTasks.add(t);
    } else {
      pendingTasks.add(t);
      if ("in_progress".equalsIgnoreCase(t.getStatus())) inProgressCount++;
    }
  }

  String successMsg = (String) session.getAttribute("successMsg");
  String errorMsg   = (String) session.getAttribute("errorMsg");
  session.removeAttribute("successMsg");
  session.removeAttribute("errorMsg");

  String photoPath = user.getPhotoPath();
  boolean hasPhoto = (photoPath != null && !photoPath.trim().isEmpty());
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Employee Dashboard</title>
<link href="https://fonts.googleapis.com/css2?family=Rajdhani:wght@400;500;600;700&family=Exo+2:wght@300;400;500;600&display=swap" rel="stylesheet">
<style>
  :root {
    --bg-base:        #050d1a;
    --bg-card:        #0d1e35;
    --bg-sidebar:     #071220;
    --border:         rgba(64,140,220,0.18);
    --border-bright:  rgba(64,180,255,0.35);
    --accent:         #3ab4f2;
    --text-primary:   #ddeeff;
    --text-secondary: #7a9bbf;
    --text-muted:     #3e6080;
    --status-progress:#e8a020;
    --status-notstart:#e05050;
    --status-complete:#22c97a;
    --shadow-card:    0 4px 24px rgba(0,10,30,0.6);
    --shadow-glow:    0 0 20px rgba(58,180,242,0.12);
  }
  *,*::before,*::after{box-sizing:border-box;margin:0;padding:0;}
  body{
    font-family:'Exo 2',sans-serif;background:var(--bg-base);color:var(--text-primary);
    min-height:100vh;display:flex;flex-direction:column;
    background-image:
      radial-gradient(ellipse 80% 60% at 70% -10%,rgba(20,80,160,0.35) 0%,transparent 60%),
      radial-gradient(ellipse 60% 50% at -10% 80%,rgba(10,50,120,0.30) 0%,transparent 55%),
      linear-gradient(180deg,#050d1a 0%,#070f1e 60%,#050d1a 100%);
  }
  .topbar{display:flex;align-items:center;justify-content:space-between;padding:18px 36px;
    border-bottom:1px solid var(--border);background:rgba(5,13,26,0.85);
    backdrop-filter:blur(8px);position:sticky;top:0;z-index:100;}
  .topbar-title{font-family:'Rajdhani',sans-serif;font-size:2rem;font-weight:700;letter-spacing:0.04em;
    background:linear-gradient(90deg,#3ab4f2,#a0d8f8);-webkit-background-clip:text;
    -webkit-text-fill-color:transparent;background-clip:text;}
  .topbar-title span{color:#fff;-webkit-text-fill-color:#fff;}
  .topbar-btn{width:40px;height:40px;border-radius:10px;border:1px solid var(--border-bright);
    background:rgba(58,180,242,0.07);color:var(--accent);cursor:pointer;
    display:flex;align-items:center;justify-content:center;font-size:1rem;transition:background 0.2s;}
  .topbar-btn:hover{background:rgba(58,180,242,0.16);}
  .layout{display:flex;flex:1;}

  /* Sidebar */
  .sidebar{width:240px;min-height:calc(100vh - 73px);background:var(--bg-sidebar);
    border-right:1px solid var(--border);display:flex;flex-direction:column;
    align-items:center;padding:36px 16px 24px;gap:8px;flex-shrink:0;}

  /* Avatar */
  .avatar-container{position:relative;margin-bottom:16px;cursor:pointer;}
  .avatar-wrap{width:100px;height:100px;border-radius:50%;border:3px solid var(--accent);
    box-shadow:0 0 0 5px rgba(58,180,242,0.12),var(--shadow-glow);overflow:hidden;
    background:linear-gradient(135deg,#1a3a5c,#0d2240);
    display:flex;align-items:center;justify-content:center;font-size:2.8rem;}
  .avatar-wrap img{width:100%;height:100%;object-fit:cover;display:block;}
  .avatar-overlay{position:absolute;inset:0;border-radius:50%;background:rgba(0,10,30,0.65);
    display:flex;flex-direction:column;align-items:center;justify-content:center;
    opacity:0;transition:opacity 0.2s;font-size:0.65rem;color:var(--accent);
    font-weight:600;letter-spacing:0.05em;text-transform:uppercase;gap:4px;}
  .avatar-overlay .cam{font-size:1.3rem;}
  .avatar-container:hover .avatar-overlay{opacity:1;}
  #photoInput{display:none;}

  .emp-name{font-family:'Rajdhani',sans-serif;font-size:1.25rem;font-weight:700;
    color:#fff;text-align:center;letter-spacing:0.02em;}
  .emp-role{font-size:0.82rem;color:var(--accent);text-align:center;margin-bottom:4px;
    font-weight:600;letter-spacing:0.05em;text-transform:uppercase;}
  .emp-id{font-size:0.78rem;color:var(--text-muted);text-align:center;margin-bottom:20px;}
  .divider{width:80%;height:1px;background:var(--border);margin:8px 0;}
  .nav-item{width:100%;display:flex;align-items:center;gap:10px;padding:10px 16px;
    border-radius:10px;text-decoration:none;color:var(--text-secondary);font-size:0.9rem;
    font-weight:500;transition:all 0.2s;cursor:pointer;border:none;background:transparent;}
  .nav-item.active{background:rgba(58,180,242,0.13);color:var(--accent);border:1px solid rgba(58,180,242,0.25);}
  .nav-item:hover{background:rgba(58,180,242,0.08);color:var(--text-primary);}
  .nav-item.logout{color:#e05050;}
  .nav-item.logout:hover{background:rgba(224,80,80,0.1);color:#ff7070;}

  /* Stats */
  .stats-row{display:flex;gap:16px;margin-bottom:28px;flex-wrap:wrap;}
  .stat-card{flex:1;min-width:120px;background:var(--bg-card);border:1px solid var(--border);
    border-radius:12px;padding:18px 20px;display:flex;flex-direction:column;gap:6px;
    box-shadow:var(--shadow-card);transition:box-shadow 0.2s;}
  .stat-card:hover{box-shadow:var(--shadow-card),var(--shadow-glow);}
  .stat-label{font-size:0.72rem;text-transform:uppercase;letter-spacing:0.1em;color:var(--text-muted);font-weight:600;}
  .stat-value{font-family:'Rajdhani',sans-serif;font-size:2rem;font-weight:700;}
  .stat-value.blue  {color:var(--accent);}
  .stat-value.orange{color:var(--status-progress);}
  .stat-value.red   {color:var(--status-notstart);}
  .stat-value.green {color:var(--status-complete);}

  /* Main */
  .main{flex:1;padding:32px 36px;overflow-x:hidden;}
  .greeting{display:flex;align-items:center;justify-content:space-between;margin-bottom:24px;flex-wrap:wrap;gap:12px;}
  .greeting-text{font-family:'Rajdhani',sans-serif;font-size:1.4rem;font-weight:600;
    color:var(--text-primary);letter-spacing:0.02em;display:flex;align-items:center;gap:10px;}

  /* Task section */
  .task-section{background:var(--bg-card);border:1px solid var(--border);border-radius:14px;
    margin-bottom:24px;overflow:hidden;box-shadow:var(--shadow-card);transition:box-shadow 0.3s;}
  .task-section:hover{box-shadow:var(--shadow-card),var(--shadow-glow);}
  .section-header{display:flex;align-items:center;gap:12px;padding:16px 24px;
    border-bottom:1px solid var(--border);background:rgba(58,180,242,0.04);
    cursor:pointer;user-select:none;}
  .toggle-icon{width:26px;height:26px;border-radius:6px;border:1px solid var(--border-bright);
    display:flex;align-items:center;justify-content:center;font-size:0.7rem;
    color:var(--accent);background:rgba(58,180,242,0.1);transition:transform 0.3s;}
  .section-header h2{font-family:'Rajdhani',sans-serif;font-size:1.1rem;font-weight:600;
    letter-spacing:0.06em;color:var(--text-primary);text-transform:uppercase;}
  .count-badge{padding:2px 10px;border-radius:20px;font-size:0.78rem;font-weight:600;
    background:rgba(58,180,242,0.18);color:var(--accent);border:1px solid rgba(58,180,242,0.3);}
  .task-table{width:100%;border-collapse:collapse;}
  .task-table thead tr{background:rgba(58,180,242,0.04);border-bottom:1px solid var(--border);}
  .task-table th{padding:12px 20px;text-align:left;font-size:0.75rem;font-weight:600;
    letter-spacing:0.1em;text-transform:uppercase;color:var(--text-muted);}
  .task-table tbody tr{border-bottom:1px solid rgba(64,140,220,0.08);transition:background 0.18s;}
  .task-table tbody tr:last-child{border-bottom:none;}
  .task-table tbody tr:hover{background:rgba(58,180,242,0.05);}
  .task-table td{padding:14px 20px;font-size:0.88rem;vertical-align:middle;color:var(--text-primary);}
  .title-cell{display:flex;flex-direction:column;gap:3px;}
  .title-cell .title{font-weight:600;font-size:0.9rem;}
  .title-cell .desc{color:var(--text-secondary);font-size:0.78rem;}
  .badge{display:inline-flex;align-items:center;padding:4px 12px;border-radius:20px;
    font-size:0.75rem;font-weight:600;letter-spacing:0.04em;white-space:nowrap;}
  .badge-progress  {background:rgba(232,160,32,0.15);color:var(--status-progress);border:1px solid rgba(232,160,32,0.35);}
  .badge-notstarted{background:rgba(224,80,80,0.12);color:var(--status-notstart);border:1px solid rgba(224,80,80,0.3);}
  .badge-complete  {background:rgba(34,201,122,0.12);color:var(--status-complete);border:1px solid rgba(34,201,122,0.3);}
  .date-cell,.assignee-cell{color:var(--text-secondary);font-size:0.84rem;white-space:nowrap;}
  .status-select{background:rgba(58,180,242,0.06);border:1px solid var(--border);
    border-radius:7px;color:var(--text-primary);font-family:'Exo 2',sans-serif;
    font-size:0.8rem;padding:5px 8px;outline:none;cursor:pointer;}
  .status-select option{background:#0d1e35;}
  .btn-update{display:inline-flex;align-items:center;gap:5px;padding:5px 14px;
    border-radius:8px;border:1px solid rgba(58,180,242,0.35);
    background:rgba(58,180,242,0.1);color:var(--accent);font-size:0.78rem;
    font-weight:600;cursor:pointer;font-family:'Exo 2',sans-serif;
    transition:all 0.2s;margin-top:6px;}
  .btn-update:hover{background:rgba(58,180,242,0.2);}
  .collapsible-body{overflow:hidden;transition:max-height 0.35s ease;}
  .collapsed .collapsible-body{max-height:0!important;}
  .collapsed .toggle-icon{transform:rotate(-90deg);}
  .alert{display:flex;align-items:center;gap:10px;padding:12px 18px;border-radius:10px;
    margin-bottom:20px;font-size:0.88rem;font-weight:500;}
  .alert-success{background:rgba(34,201,122,0.1);border:1px solid rgba(34,201,122,0.3);color:var(--status-complete);}
  .alert-error{background:rgba(224,80,80,0.1);border:1px solid rgba(224,80,80,0.3);color:var(--status-notstart);}
  ::-webkit-scrollbar{width:6px;}
  ::-webkit-scrollbar-track{background:var(--bg-base);}
  ::-webkit-scrollbar-thumb{background:rgba(58,180,242,0.25);border-radius:3px;}
  @media(max-width:768px){.sidebar{display:none;}.main{padding:20px 16px;}.stats-row{flex-direction:column;}}
</style>
</head>
<body>

<header class="topbar">
  <div class="topbar-title"><span>Employee </span>Dashboard</div>
  <div style="display:flex;gap:10px;">
    <button class="topbar-btn">&#128276;</button>
  </div>
</header>

<div class="layout">
  <aside class="sidebar">

    <!-- ── Profile Photo ── -->
        <div class="avatar-container" onclick="document.getElementById('photoInput').click()" title="Click to change photo">
      <div class="avatar-wrap" id="avatarWrap">
        <% if (hasPhoto) { %>
          <img src="<%= photoPath %>" alt="Profile Photo">
        <% } else { %>
          &#128100;
        <% } %>
      </div>
      <div class="avatar-overlay">
        <span class="cam">&#128247;</span>
        Change Photo
      </div>
    </div>
    <!-- Hidden form — submits to UploadPhotoServlet -->
    <form id="photoForm" action="uploadPhoto" method="post" enctype="multipart/form-data" style="display:none;">
      <input type="file" id="photoInput" name="photo" accept="image/*">
    </form>
    
    <div class="emp-name"><%= user.getName() %></div>
    <div class="emp-role">Employee</div>
    <div class="emp-id">Employee ID: <%= user.getEid() %></div>
    <div class="divider"></div>
    <a class="nav-item active" href="#"><span>&#9783;</span> Dashboard</a>
    <div class="divider"></div>
    <a class="nav-item logout" href="logout"><span>&#9211;</span> Logout</a>
  </aside>

  <main class="main">

    <% if (successMsg != null) { %><div class="alert alert-success">&#10003; &nbsp;<%= successMsg %></div><% } %>
    <% if (errorMsg   != null) { %><div class="alert alert-error">&#9888; &nbsp;<%= errorMsg %></div><% } %>

    <div class="greeting">
      <div class="greeting-text"><span>&#128203;</span> Hello, here are your tasks for the day</div>
    </div>

    <!-- Stats -->
    <div class="stats-row">
      <div class="stat-card"><div class="stat-label">Total Tasks</div><div class="stat-value blue"><%= tasks.size() %></div></div>
      <div class="stat-card"><div class="stat-label">Pending</div><div class="stat-value red"><%= pendingTasks.size() - inProgressCount %></div></div>
      <div class="stat-card"><div class="stat-label">In Progress</div><div class="stat-value orange"><%= inProgressCount %></div></div>
      <div class="stat-card"><div class="stat-label">Completed</div><div class="stat-value green"><%= completedTasks.size() %></div></div>
    </div>

    <!-- Pending Tasks -->
    <div class="task-section" id="pendingSection">
      <div class="section-header" onclick="toggleSection('pendingSection')">
        <div class="toggle-icon">&#9660;</div>
        <h2>Pending Tasks</h2>
        <span class="count-badge"><%= pendingTasks.size() %></span>
      </div>
      <div class="collapsible-body" style="max-height:3000px">
        <table class="task-table">
          <thead><tr><th>Title</th><th>Status</th><th>Assigned Date</th><th>Assigned By</th><th>Due Date</th><th>Action</th></tr></thead>
          <tbody>
            <% if (pendingTasks.isEmpty()) { %>
            <tr><td colspan="6" style="text-align:center;color:var(--text-muted);padding:28px;">No pending tasks 🎉</td></tr>
            <% } else { for (Task t : pendingTasks) { %>
            <tr>
              <td><div class="title-cell"><span class="title"><%= t.getTitle() %></span><span class="desc"><%= t.getDescription() != null ? t.getDescription() : "" %></span></div></td>
              <td>
                <% if ("in_progress".equalsIgnoreCase(t.getStatus())) { %><span class="badge badge-progress">In Progress</span>
                <% } else { %><span class="badge badge-notstarted">Not Started</span><% } %>
              </td>
              <td class="date-cell"><%= t.getAssignedDate() != null ? t.getAssignedDate() : "—" %></td>
              <td class="assignee-cell"><%= t.getAssignedByName() != null ? t.getAssignedByName() : "—" %></td>
              <td class="date-cell"><%= t.getDueDate() != null ? t.getDueDate() : "—" %></td>
              <td>
                <form action="updateTask" method="post">
                  <input type="hidden" name="tid" value="<%= t.getTid() %>">
                  <select name="status" class="status-select">
                    <option value="pending"     <%= "pending".equalsIgnoreCase(t.getStatus())     ? "selected":"" %>>Pending</option>
                    <option value="in_progress" <%= "in_progress".equalsIgnoreCase(t.getStatus()) ? "selected":"" %>>In Progress</option>
                    <option value="completed"   <%= "completed".equalsIgnoreCase(t.getStatus())   ? "selected":"" %>>Completed</option>
                  </select><br>
                  <button type="submit" class="btn-update">&#10003; Update</button>
                </form>
              </td>
            </tr>
            <% } } %>
          </tbody>
        </table>
      </div>
    </div>

    <!-- Completed Tasks -->
    <div class="task-section" id="completedSection">
      <div class="section-header" onclick="toggleSection('completedSection')">
        <div class="toggle-icon">&#9660;</div>
        <h2>Completed Tasks</h2>
        <span class="count-badge"><%= completedTasks.size() %></span>
      </div>
      <div class="collapsible-body" style="max-height:3000px">
        <table class="task-table">
          <thead><tr><th>Title</th><th>Status</th><th>Assigned Date</th><th>Assigned By</th><th>Due Date</th></tr></thead>
          <tbody>
            <% if (completedTasks.isEmpty()) { %>
            <tr><td colspan="5" style="text-align:center;color:var(--text-muted);padding:28px;">No completed tasks yet.</td></tr>
            <% } else { for (Task t : completedTasks) { %>
            <tr>
              <td><div class="title-cell"><span class="title"><%= t.getTitle() %></span><span class="desc"><%= t.getDescription() != null ? t.getDescription() : "" %></span></div></td>
              <td><span class="badge badge-complete">Completed</span></td>
              <td class="date-cell"><%= t.getAssignedDate() != null ? t.getAssignedDate() : "—" %></td>
              <td class="assignee-cell"><%= t.getAssignedByName() != null ? t.getAssignedByName() : "—" %></td>
              <td class="date-cell"><%= t.getDueDate() != null ? t.getDueDate() : "—" %></td>
            </tr>
            <% } } %>
          </tbody>
        </table>
      </div>
    </div>

  </main>
</div>

<script>
  function toggleSection(id) {
    const section = document.getElementById(id);
    const body = section.querySelector('.collapsible-body');
    if (section.classList.contains('collapsed')) {
      section.classList.remove('collapsed');
      body.style.maxHeight = body.scrollHeight + 'px';
      setTimeout(() => body.style.maxHeight = '3000px', 350);
    } else {
      body.style.maxHeight = body.scrollHeight + 'px';
      requestAnimationFrame(() => { section.classList.add('collapsed'); body.style.maxHeight = '0'; });
    }
  }

  document.getElementById('photoInput').addEventListener('change', function() {
    const file = this.files[0];
    if (!file) return;
    const reader = new FileReader();
    reader.onload = e => {
      document.getElementById('avatarWrap').innerHTML =
        '<img src="' + e.target.result + '" style="width:100%;height:100%;object-fit:cover;">';
    };
    reader.readAsDataURL(file);
    document.getElementById('photoForm').submit();
  });
</script>
</body>
</html>
