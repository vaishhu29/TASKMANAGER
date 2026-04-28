<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>

<%
String name = (String)session.getAttribute("name");
Integer userId = (Integer)session.getAttribute("userId");

if(userId == null){
    response.sendRedirect("login.jsp");
    return;
}

int total=0,pending=0,completed=0;
%>

<!DOCTYPE html>
<html>
<head>
<title>Dashboard</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>
body{
    margin:0;
    font-family:'Segoe UI';
    background:#f4f6fb;
}

/* SIDEBAR */
.sidebar{
    width:250px;
    height:100vh;
    position:fixed;
    background:linear-gradient(180deg,#0f172a,#1e293b);
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

#profileIcon{ font-size:28px; }

.profile-img img{
    width:100%;
    height:100%;
    object-fit:cover;
}

/* MENU */
.menu a{
    display:block;
    padding:12px;
    color:#cbd5f5;
    text-decoration:none;
    border-radius:10px;
    margin:6px 0;
}

.menu a:hover{ background:#334155; }

.menu .active{ background:#6366f1; }

/* CONTENT */
.content{
    margin-left:250px;
    padding:30px;
}

/* HEADER */
.header{
    display:flex;
    justify-content:space-between;
    align-items:center;
}

/* BUTTON */
.add-btn{
    background:#2563eb;
    color:white;
    border:none;
    padding:10px 18px;
    border-radius:10px;
}

/* CARD */
.card-box{
    background:white;
    padding:20px;
    border-radius:16px;
    box-shadow:0 8px 18px rgba(0,0,0,0.05);
}

/* STATS */
.stat{
    text-align:center;
}

/* TASK */
.task{
    padding:12px;
    border-radius:12px;
    background:#f1f5f9;
    margin-top:10px;
}

/* EMPTY */
.empty{
    text-align:center;
    padding:20px;
    color:#64748b;
}

/* CHART FIX */
.chart-box{
    height:260px;
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
<a href="dashboard.jsp" class="active">Dashboard</a>
<a href="mytasks.jsp">My Task</a>
<a href="categories.jsp">Task Categories</a>
<a href="settings.jsp">Settings</a>
<a href="help.jsp">Help</a>
<a href="logout">Logout</a>
</div>

</div>

<!-- CONTENT -->
<div class="content">

<div class="header mb-4">
<h3>Welcome, <%= name %></h3>
<button class="add-btn" onclick="openModal()">+ Add Task</button>
</div>

<!-- STATS -->
<div class="row g-3 mb-4">

<div class="col-md-4">
<div class="card-box stat">
<h6>Total Tasks</h6>
<h3><%= total %></h3>
</div>
</div>

<div class="col-md-4">
<div class="card-box stat">
<h6>Pending</h6>
<h3 style="color:#f59e0b"><%= pending %></h3>
</div>
</div>

<div class="col-md-4">
<div class="card-box stat">
<h6>Completed</h6>
<h3 style="color:#22c55e"><%= completed %></h3>
</div>
</div>

</div>

<div class="row g-4">

<!-- LEFT -->
<div class="col-md-7">

<div class="card-box">
<h5>Pending Tasks</h5>

<%
try(Connection con = DBConnection.getConnection()){

PreparedStatement ps = con.prepareStatement(
"SELECT * FROM tasks WHERE user_id=? AND status='PENDING'"
);
ps.setInt(1,userId);
ResultSet rs = ps.executeQuery();

boolean hasPending=false;

while(rs.next()){
hasPending=true;
pending++;
total++;
%>

<div class="task">

<b><%= rs.getString("title") %></b><br>

<%
String desc = rs.getString("description");
if(desc!=null && !desc.trim().equals("")){
%>
<small><%= desc %></small><br>
<% } %>

<small> <%= rs.getDate("deadline") %></small>

</div>

<% } %>

<% if(!hasPending){ %>
<div class="empty">No pending tasks </div>
<% } %>

<%
rs.close();
ps.close();

PreparedStatement ps2 = con.prepareStatement(
"SELECT * FROM tasks WHERE user_id=? AND status='COMPLETED'"
);
ps2.setInt(1,userId);
ResultSet rs2 = ps2.executeQuery();
%>

</div>

</div>

<!-- RIGHT -->
<div class="col-md-5">

<div class="card-box text-center">
<h6>Task Analytics</h6>
<div class="chart-box">
<canvas id="chart"></canvas>
</div>
</div>

</div>

</div>

<!-- COMPLETED -->
<div class="card-box mt-4">
<h5>Completed Tasks</h5>

<%
boolean hasCompleted=false;

while(rs2.next()){
hasCompleted=true;
completed++;
total++;
%>

<div class="task">

<b><%= rs2.getString("title") %></b><br>

<%
String desc2 = rs2.getString("description");
if(desc2!=null && !desc2.trim().equals("")){
%>
<small> <%= desc2 %></small><br>
<% } %>

<small><%= rs2.getDate("deadline") %></small>

</div>

<% } %>

<% if(!hasCompleted){ %>
<div class="empty">No completed tasks</div>
<% } %>

<%
rs2.close();
ps2.close();
}
catch(Exception e){
out.println("Error");
}
%>

</div>

</div>

<!-- MODAL -->
<div id="modal" style="display:none;position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,0.5);">
<div style="background:white;width:400px;margin:100px auto;padding:20px;border-radius:12px;">

<h5>Add Task</h5>

<form action="addTask" method="post">

<input type="text" name="title" class="form-control mb-2" placeholder="Task Title" required>

<textarea name="description" class="form-control mb-2" placeholder="Description"></textarea>

<input type="date" name="deadline" class="form-control mb-2">

<button class="btn btn-success">Add</button>
<button type="button" class="btn btn-secondary" onclick="closeModal()">Cancel</button>

</form>

</div>
</div>

<!-- CHART -->
<script>
new Chart(document.getElementById("chart"),{
type:'doughnut',
data:{
labels:['Pending','Completed'],
datasets:[{
data:[<%= pending %>,<%= completed %>],
backgroundColor:['#f59e0b','#22c55e']
}]
},
options:{
plugins:{ legend:{ position:'bottom' } }
}
});
</script>

<!-- MODAL -->
<script>
function openModal(){ document.getElementById("modal").style.display="block"; }
function closeModal(){ document.getElementById("modal").style.display="none"; }
</script>

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