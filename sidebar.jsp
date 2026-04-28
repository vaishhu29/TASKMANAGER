<%
String name = (String)session.getAttribute("name");
Integer userId = (Integer)session.getAttribute("userId");

if(userId == null){
    response.sendRedirect("login.jsp");
    return;
}
%>

<style>
.sidebar {
    width:250px;
    height:100vh;
    position:fixed;
    background:#000;
    color:white;
    padding:20px;
}
.profile {
    text-align:center;
    margin-bottom:20px;
}
.profile img {
    width:70px;
    border-radius:50%;
}
.menu a {
    display:block;
    padding:12px;
    color:#bbb;
    text-decoration:none;
    border-radius:10px;
    margin:5px 0;
}
.menu a:hover {
    background:#1f2937;
}
.active {
    background:white !important;
    color:black !important;
}
.profile-img {
    width:70px;
    height:70px;
    border-radius:50%;
    background:#e2e8f0;
    display:flex;
    align-items:center;
    justify-content:center;
    font-size:28px;
    cursor:pointer;
    transition:0.2s;
}

.profile-img:hover {
    background:#cbd5e1;
}
</style>

<div class="sidebar">

<div class="profile">
<a href="settings.jsp">
    <div class="profile-img" onclick="document.getElementById('profileUpload').click()">
    
</div>

<input type="file" id="profileUpload" style="display:none;">
</a>
<h6><%= (name != null) ? name : "User" %></h6>
</div>

<div class="menu">
<a href="dashboard.jsp">Dashboard</a>
<a href="mytasks.jsp">My Task</a>
<a href="categories.jsp">Task Categories</a>
<a href="settings.jsp">Settings</a>
<a href="help.jsp">Help</a>
<a href="logout">Logout</a>
</div>

</div>