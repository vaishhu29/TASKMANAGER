<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
String user = (String)session.getAttribute("user");
Integer userId = (Integer)session.getAttribute("userId");

if(user == null){
    response.sendRedirect("login.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Dashboard</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>
body { font-family: Arial; margin:0; background:#f4f6f9; }

.sidebar {
    width: 220px;
    height: 100vh;
    background: #1e293b;
    color: white;
    position: fixed;
    padding: 20px;
}

.sidebar h2 { text-align:center; }

.sidebar a {
    display:block;
    padding:10px;
    color:white;
    text-decoration:none;
    margin:5px 0;
}

.sidebar a:hover { background:#334155; }

.content {
    margin-left: 240px;
    padding: 20px;
}

.card {
    background:white;
    padding:15px;
    border-radius:10px;
    margin:10px 0;
}

.grid {
    display:grid;
    grid-template-columns:1fr 1fr;
    gap:15px;
}

@media(max-width:768px){
    .grid { grid-template-columns:1fr; }
}

.task {
    border-left:5px solid blue;
    padding:10px;
    margin:10px 0;
}

.completed {
    border-left:5px solid green;
    text-decoration:line-through;
}
</style>
</head>

<body>

<div class="sidebar">
    <h2>Task Manager</h2>
    <a href="#">Profile</a>
    <a href="#add">Add Task</a>
    <a href="#tasks">Tasks</a>
    <a href="#upcoming">Upcoming</a>
    <a href="#chart">Analytics</a>
    <a href="logout">Logout</a>
</div>

<div class="content">

<h2>Welcome, <%= user %></h2>

<div class="grid">

<div class="card" id="add">
<h3>Add Task</h3>
<form action="addTask" method="post">
<input type="text" name="title" placeholder="Task" required><br><br>
<input type="date" name="deadline" required><br><br>
<button>Add</button>
</form>
</div>

<div class="card">
<h3>Profile</h3>
<p>Username: <b><%= user %></b></p>
</div>

</div>

<div class="card" id="tasks">
<h3>All Tasks</h3>

<%
int pending=0, completed=0;

Connection con = null;

try{
con = DriverManager.getConnection(
"jdbc:mysql://localhost:3306/task_manager","root","root"
);

PreparedStatement ps = con.prepareStatement(
"SELECT * FROM tasks WHERE user_id=? ORDER BY deadline"
);
ps.setInt(1,userId);

ResultSet rs = ps.executeQuery();

while(rs.next()){
String status = rs.getString("status");
boolean isPending = "PENDING".equals(status);

if(isPending) pending++; else completed++;
%>

<div class="task <%= isPending?"":"completed" %>">
<b><%= rs.getString("title") %></b><br>
Deadline: <%= rs.getDate("deadline") %><br>
Status: <%= status %>
</div>

<%
}

rs.close();
ps.close();

}catch(Exception e){
out.println("<p style='color:red;'>Database error</p>");
}
%>

</div>

<div class="card" id="upcoming">
<h3>Upcoming Tasks</h3>

<%
try{
PreparedStatement ps2 = con.prepareStatement(
"SELECT * FROM tasks WHERE user_id=? AND status='PENDING' ORDER BY deadline LIMIT 3"
);
ps2.setInt(1,userId);

ResultSet rs2 = ps2.executeQuery();

while(rs2.next()){
%>

<p><%= rs2.getString("title") %> - <%= rs2.getDate("deadline") %></p>

<%
}
}catch(Exception e){}
%>

</div>

<div class="card" id="chart">
<h3>Analytics</h3>
<canvas id="chart1"></canvas>
</div>

<script>
new Chart(document.getElementById("chart1"),{
type:'doughnut',
data:{
labels:['Pending','Completed'],
datasets:[{
data:[<%= pending %>,<%= completed %>]
}]
}
});
</script>

</div>

</body>
</html>