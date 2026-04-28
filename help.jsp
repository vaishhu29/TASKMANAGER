<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
String name = (String)session.getAttribute("name");
if(name == null){
    response.sendRedirect("login.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Help & Support</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">

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
    color:#cbd5f5;
    text-decoration:none;
    border-radius:10px;
    margin:6px 0;
}

.menu a:hover{
    background:#334155;
}

.menu .active{
    background:#6366f1;
}

/* CONTENT */
.content{
    margin-left:260px;
    padding:30px;
}

/* CARD */
.card-box{
    background:white;
    padding:25px;
    border-radius:16px;
    box-shadow:0 8px 20px rgba(0,0,0,0.05);
    margin-bottom:20px;
}

/* FAQ */
.faq-item{
    margin-bottom:10px;
    padding:10px;
    border-radius:8px;
    transition:0.2s;
}

.faq-item:hover{
    background:#f1f5f9;
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
<a href="mytasks.jsp">My Task</a>
<a href="categories.jsp">Task Categories</a>
<a href="settings.jsp">Settings</a>
<a href="help.jsp" class="active">Help</a>
<a href="logout">Logout</a>
</div>

</div>

<!-- CONTENT -->
<div class="content">

<h3 class="mb-4">Help & Support</h3>

<!-- CONTACT -->
<div class="card-box">

<h5 class="mb-3">Contact Information</h5>

<p><i class="bi bi-envelope"></i> <b>Email:</b> support@taskmanager.com</p>
<p><i class="bi bi-telephone"></i> <b>Phone:</b> +91 9876543210</p>
<p><i class="bi bi-clock"></i> <b>Working Hours:</b> 9 AM – 6 PM</p>

</div>

<!-- FAQ -->
<div class="card-box">

<h5 class="mb-3">Frequently Asked Questions</h5>

<div class="faq-item">
<i class="bi bi-question-circle"></i>
<b> How to add a task?</b><br>
<small>Click the "Add Task" button on the dashboard.</small>
</div>

<div class="faq-item">
<i class="bi bi-check-circle"></i>
<b> How to complete a task?</b><br>
<small>Click the ✔ button next to the task.</small>
</div>

<div class="faq-item">
<i class="bi bi-trash"></i>
<b> How to delete a task?</b><br>
<small>Click the ✖ button next to the task.</small>
</div>

<div class="faq-item">
<i class="bi bi-folder"></i>
<b> How to add categories?</b><br>
<small>Go to "Task Categories" page and create one.</small>
</div>

</div>

</div>

<!-- AVATAR SCRIPT -->
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
</script>

</body>
</html>