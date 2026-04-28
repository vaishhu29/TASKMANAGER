<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>

<%
String name = (String)session.getAttribute("name");
if(name == null){
    response.sendRedirect("login.jsp");
    return;
}

String success = request.getParameter("success");
String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html>
<head>
<title>Task Categories</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">

<style>
body{background:#f1f5f9;font-family:'Segoe UI';}

/* SIDEBAR */
.sidebar{
    width:250px;height:100vh;position:fixed;
    background:linear-gradient(180deg,#0f172a,#1e293b);
    color:white;padding:20px;
}

/* PROFILE */
.profile-box{text-align:center;margin-bottom:20px;}
.profile-img{
    width:70px;height:70px;border-radius:50%;
    background:#e2e8f0;display:flex;align-items:center;justify-content:center;
    margin:auto;overflow:hidden;
}
#profileIcon{font-size:28px;}
.profile-img img{width:100%;height:100%;object-fit:cover;}
.profile-name{margin-top:10px;color:#e2e8f0;}

/* MENU */
.menu a{
    display:block;padding:12px;color:#cbd5f5;
    text-decoration:none;border-radius:10px;margin:6px 0;
}
.menu a:hover{background:#334155;}
.menu .active{background:#6366f1;color:white;}

/* CONTENT */
.content{margin-left:270px;padding:30px;}

/* CARD */
.card-box{
    background:white;padding:20px;border-radius:16px;
    box-shadow:0 10px 25px rgba(0,0,0,0.08);margin-bottom:20px;
}

/* TABLE */
.table tbody tr:hover{background:#f8fafc;}

/* BADGE */
.badge-status{background:#e0f2fe;color:#0369a1;}
.badge-priority{background:#fef3c7;color:#92400e;}
</style>
</head>

<body>

<!-- SIDEBAR -->
<div class="sidebar">

<div class="profile-box">
<div class="profile-img">
<span id="profileIcon"></span>
<img id="profilePreview" style="display:none;">
</div>
<div class="profile-name"><%= name %></div>
</div>

<div class="menu">
<a href="dashboard.jsp">Dashboard</a>
<a href="mytasks.jsp">My Task</a>
<a href="categories.jsp" class="active">Task Categories</a>
<a href="settings.jsp">Settings</a>
<a href="help.jsp">Help</a>
<a href="logout">Logout</a>
</div>

</div>

<!-- CONTENT -->
<div class="content">

<div class="d-flex justify-content-between align-items-center mb-3">
<h3>Task Categories</h3>
<a href="dashboard.jsp" class="btn btn-light">⬅ Back</a>
</div>

<!-- ALERTS -->
<% if("1".equals(success)){ %>
<div class="alert alert-success">Category added successfully</div>
<% } %>

<% if("exists".equals(error)){ %>
<div class="alert alert-warning">Category already exists</div>
<% } %>

<% if("invalid".equals(error)){ %>
<div class="alert alert-danger">Invalid input</div>
<% } %>

<!-- ADD CATEGORY -->
<div class="card-box">

<h5 class="mb-3"><i class="bi bi-plus-circle"></i> Add New Category</h5>

<form action="addCategory" method="post" class="d-flex gap-2">

<select name="type" class="form-control" required>
<option value="">Type</option>
<option value="status">Status</option>
<option value="priority">Priority</option>
</select>

<input type="text" name="name" class="form-control" placeholder="Enter name" required>

<button class="btn btn-primary">Create</button>
</form>

</div>

<!-- STATUS -->
<div class="card-box">
<h5><i class="bi bi-flag"></i> Task Status</h5>

<table class="table text-center">
<thead>
<tr>
<th>ID</th>
<th>Name</th>
<th>Action</th>
</tr>
</thead>
<tbody>

<%
try(Connection con = DBConnection.getConnection()){

PreparedStatement ps = con.prepareStatement("SELECT * FROM task_status");
ResultSet rs = ps.executeQuery();

boolean hasData=false;

while(rs.next()){
hasData=true;
%>

<tr>
<td><%= rs.getInt("id") %></td>
<td><span class="badge badge-status"><%= rs.getString("name") %></span></td>
<td>
<a href="editCategory?id=<%= rs.getInt("id") %>&type=status"
   class="btn btn-warning btn-sm">Edit</a>

<a href="deleteCategory?id=<%= rs.getInt("id") %>&type=status"
   class="btn btn-danger btn-sm">Delete</a>
</td>
</tr>

<% } %>

<% if(!hasData){ %>
<tr><td colspan="3">No status added</td></tr>
<% } %>

</tbody>
</table>

</div>

<!-- PRIORITY -->
<div class="card-box">
<h5><i class="bi bi-lightning"></i> Task Priority</h5>

<table class="table text-center">
<thead>
<tr>
<th>ID</th>
<th>Name</th>
<th>Action</th>
</tr>
</thead>
<tbody>

<%
PreparedStatement ps2 = con.prepareStatement("SELECT * FROM task_priority");
ResultSet rs2 = ps2.executeQuery();

boolean hasPriority=false;

while(rs2.next()){
hasPriority=true;
%>

<tr>
<td><%= rs2.getInt("id") %></td>
<td><span class="badge badge-priority"><%= rs2.getString("name") %></span></td>
<td>
<a href="editCategory?id=<%= rs2.getInt("id") %>&type=priority"
   class="btn btn-warning btn-sm">Edit</a>

<a href="deleteCategory?id=<%= rs2.getInt("id") %>&type=priority"
   class="btn btn-danger btn-sm">Delete</a>
</td>
</tr>

<% } %>

<% if(!hasPriority){ %>
<tr><td colspan="3">No priority added</td></tr>
<% } %>

<%
rs.close(); ps.close();
rs2.close(); ps2.close();
}
catch(Exception e){
out.println("<p style='color:red'>Database Error</p>");
}
%>

</tbody>
</table>

</div>

</div>

<!-- AVATAR -->
<script>
window.onload=function(){
let saved=localStorage.getItem("profileImage");

let img=document.getElementById("profilePreview");
let icon=document.getElementById("profileIcon");

if(saved){
if(saved.startsWith("data:image")){
img.src=saved;
img.style.display="block";
icon.style.display="none";
}else{
icon.innerText=saved;
}
}else{
icon.innerText="👤";
}
};
</script>

</body>
</html>