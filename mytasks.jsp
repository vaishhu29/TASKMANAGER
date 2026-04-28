<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>

<%
String name = (String)session.getAttribute("name");
Integer userId = (Integer)session.getAttribute("userId");

if(userId == null){
    response.sendRedirect("login.jsp");
    return;
}

Connection con = DBConnection.getConnection();

/* -------- STATS -------- */
int total = 0, pending = 0, completed = 0;

PreparedStatement psCount = con.prepareStatement(
"SELECT status, COUNT(*) as count FROM tasks WHERE user_id=? GROUP BY status"
);
psCount.setInt(1, userId);

ResultSet rsCount = psCount.executeQuery();

while(rsCount.next()){
    total += rsCount.getInt("count");

    if("PENDING".equals(rsCount.getString("status")))
        pending = rsCount.getInt("count");

    if("COMPLETED".equals(rsCount.getString("status")))
        completed = rsCount.getInt("count");
}

/* -------- TASK LIST -------- */
PreparedStatement ps = con.prepareStatement(
"SELECT * FROM tasks WHERE user_id=? ORDER BY id DESC"
);
ps.setInt(1, userId);

ResultSet rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
<title>My Tasks</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
body{
    margin:0;
    font-family:'Segoe UI';
    background:#f4f6fb;
}

/* SIDEBAR */
.sidebar{
    width:260px;
    height:100vh;
    position:fixed;
    background:#0f172a;
    color:white;
    padding:20px;
}

/* PROFILE */
.profile{
    text-align:center;
    margin-bottom:25px;
}

.profile-img{
    width:70px;
    height:70px;
    border-radius:50%;
    background:#e2e8f0;
    display:flex;
    align-items:center;
    justify-content:center;
    margin:auto;
    overflow:hidden;
}

#profileIcon{
    font-size:28px;
}

.profile-img img{
    width:100%;
    height:100%;
    object-fit:cover;
}

/* MENU */
.menu a{
    display:block;
    padding:12px;
    color:#94a3b8;
    text-decoration:none;
    border-radius:10px;
    margin:6px 0;
}

.menu a:hover{
    background:#1e293b;
    color:white;
}

.menu .active{
    background:white;
    color:black;
}

/* CONTENT */
.content{
    margin-left:260px;
    padding:30px;
}

/* STATS */
.stat{
    background:white;
    padding:20px;
    border-radius:12px;
    text-align:center;
    flex:1;
    box-shadow:0 4px 12px rgba(0,0,0,0.05);
}

/* TASK LIST */
.task{
    padding:12px;
    border-radius:10px;
    margin-top:10px;
    background:#f8fafc;
    cursor:pointer;
    transition:0.2s;
}

.task:hover{
    background:#e2e8f0;
}

/* BADGES */
.pending{
    background:#fef3c7;
    color:#92400e;
    padding:4px 10px;
    border-radius:20px;
}
.completed{
    background:#dcfce7;
    color:#166534;
    padding:4px 10px;
    border-radius:20px;
}

/* RIGHT PANEL */
.right{
    background:white;
    padding:25px;
    border-radius:12px;
    box-shadow:0 4px 12px rgba(0,0,0,0.05);
}

/* EMPTY */
.empty{
    text-align:center;
    color:#94a3b8;
    padding:30px;
}
</style>
</head>

<body>

<!-- SIDEBAR -->
<div class="sidebar">

<div class="profile">

<div class="profile-img">
    <span id="profileIcon"></span>
    <img id="profilePreview" style="display:none;">
</div>

<h6 class="mt-2"><%= name %></h6>

</div>

<div class="menu">
<a href="dashboard.jsp">Dashboard</a>
<a href="mytasks.jsp" class="active">My Task</a>
<a href="categories.jsp">Task Categories</a>
<a href="settings.jsp">Settings</a>
<a href="help.jsp">Help</a>
<a href="logout">Logout</a>
</div>

</div>

<!-- CONTENT -->
<div class="content">

<h3 class="mb-4">My Tasks</h3>

<!-- STATS -->
<div class="d-flex gap-3 mb-4">
<div class="stat">
<h4><%= total %></h4>
<small>Total</small>
</div>

<div class="stat">
<h4 class="text-warning"><%= pending %></h4>
<small>Pending</small>
</div>

<div class="stat">
<h4 class="text-success"><%= completed %></h4>
<small>Completed</small>
</div>
</div>

<div class="row">

<!-- LEFT -->
<div class="col-md-6">

<div class="card-box">
<h5>Recent Tasks</h5>

<%
boolean hasTasks=false;

while(rs.next()){
hasTasks=true;
String status = rs.getString("status");
%>

<div class="task"
onclick="showDetails('<%= rs.getString("title") %>','<%= status %>','<%= rs.getDate("deadline") %>')">

<b><%= rs.getString("title") %></b><br>
<small><%= rs.getDate("deadline") %></small>

<div class="mt-2">
<span class="<%= status.equals("COMPLETED")?"completed":"pending" %>">
<%= status %>
</span>
</div>

</div>

<% } %>

<% if(!hasTasks){ %>
<div class="empty">
No tasks yet
</div>
<% } %>

</div>

</div>

<!-- RIGHT -->
<div class="col-md-6">

<div class="right" id="details">
<h5>Select a task</h5>
<p class="text-muted">Click on task to view details</p>
</div>

</div>

</div>

</div>

<!-- AVATAR FIX (IMPORTANT) -->
<script>
window.addEventListener("load", function(){

    let saved = localStorage.getItem("profileImage");

    let img = document.getElementById("profilePreview");
    let icon = document.getElementById("profileIcon");

    if(saved){
        if(saved.startsWith("data:image")){
            img.src = saved;
            img.style.display = "block";
            icon.style.display = "none";
        } else {
            icon.innerText = saved;
            icon.style.display = "block";
            img.style.display = "none";
        }
    } else {
        icon.innerText = "👤";
    }

});

function showDetails(title,status,deadline){
document.getElementById("details").innerHTML = `
<h5>${title}</h5>
<p><b>Status:</b> ${status}</p>
<p><b>Deadline:</b> ${deadline}</p>
`;
}
</script>

</body>
</html>