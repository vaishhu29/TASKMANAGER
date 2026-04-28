<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
String name = (String)session.getAttribute("name");
String email = (String)session.getAttribute("email");

if(name == null){
    response.sendRedirect("login.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Settings</title>

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
    padding:30px;
    border-radius:15px;
    box-shadow:0 10px 25px rgba(0,0,0,0.08);
}

/* PROFILE */
.profile-header{
    display:flex;
    align-items:center;
    gap:15px;
}

.profile-icon{
    width:70px;
    height:70px;
    border-radius:50%;
    background:#e2e8f0;
    display:flex;
    align-items:center;
    justify-content:center;
    font-size:28px;
    cursor:pointer;
    overflow:hidden;
}

.profile-icon img{
    width:100%;
    height:100%;
    object-fit:cover;
    border-radius:50%;
}

/* MODAL */
.modal-overlay{
    display:none;
    position:fixed;
    top:0;
    left:0;
    width:100%;
    height:100%;
    background:rgba(0,0,0,0.5);
    justify-content:center;
    align-items:center;
}

.modal-box{
    background:white;
    padding:25px;
    border-radius:15px;
    width:400px;
}

/* AVATAR GRID */
.avatar-grid{
    display:grid;
    grid-template-columns:repeat(5,1fr);
    gap:10px;
}

.avatar-grid button{
    padding:10px;
    border-radius:10px;
    border:none;
    font-size:20px;
    background:#f1f5f9;
}

.avatar-grid button:hover{
    background:#6366f1;
    color:white;
}
</style>

</head>

<body>

<!-- SIDEBAR -->
<div class="sidebar">
<h5><%= name %></h5>

<div class="menu">
<a href="dashboard.jsp">Dashboard</a>
<a href="mytasks.jsp">My Task</a>
<a href="categories.jsp">Task Categories</a>
<a href="settings.jsp" class="active">Settings</a>
<a href="help.jsp">Help</a>
<a href="logout">Logout</a>
</div>
</div>

<!-- CONTENT -->
<div class="content">

<div class="card-box">

<div class="d-flex justify-content-between">
<h4>Account Information</h4>
<a href="dashboard.jsp">Go Back</a>
</div>

<hr>

<!-- PROFILE -->
<div class="profile-header">

<div id="profileDisplay" class="profile-icon" onclick="openModal()">
    <span id="profileIcon">👤</span>
    <img id="profilePreview" style="display:none;">
</div>

<div>
<h5><%= name %></h5>
<small><%= email %></small>
</div>

</div>

<hr>

<!-- FORM -->
<form onsubmit="return false;">
<input class="form-control mb-2" placeholder="First Name">
<input class="form-control mb-2" placeholder="Last Name">
<input class="form-control mb-2" value="<%= email %>">

<button type="button" class="btn btn-primary" onclick="saveProfile()">Save</button>
</form>

</div>

</div>

<!-- MODAL -->
<div id="modal" class="modal-overlay">
<div class="modal-box">

<div class="d-flex justify-content-between">
<h5>Update Profile</h5>
<span onclick="closeModal()" style="cursor:pointer;">✖</span>
</div>

<hr>

<!-- UPLOAD -->
<label style="cursor:pointer;">
<div class="profile-icon">📸</div>
<input type="file" id="uploadImage" hidden>
</label>

<h6 class="mt-3">Choose Avatar</h6>

<div class="avatar-grid">
<button onclick="setAvatar('😀')">😀</button>
<button onclick="setAvatar('😎')">😎</button>
<button onclick="setAvatar('👩')">👩</button>
<button onclick="setAvatar('👨')">👨</button>
<button onclick="setAvatar('🧑')">🧑</button>
<button onclick="setAvatar('👩‍💻')">👩‍💻</button>
<button onclick="setAvatar('👨‍💻')">👨‍💻</button>
<button onclick="setAvatar('🤓')">🤓</button>
</div>

<!-- REMOVE BUTTON -->
<button onclick="removeAvatar()" class="btn btn-danger w-100 mt-3">
    Remove Avatar
</button>

</div>
</div>

<script>
function openModal(){
    document.getElementById("modal").style.display="flex";
}
function closeModal(){
    document.getElementById("modal").style.display="none";
}

/* LOAD SAVED PROFILE */
window.onload = function(){
    let saved = localStorage.getItem("profileImage");

    if(saved){
        if(saved.startsWith("data:image")){
            document.getElementById("profilePreview").src = saved;
            document.getElementById("profilePreview").style.display="block";
            document.getElementById("profileIcon").style.display="none";
        } else {
            document.getElementById("profileIcon").innerText = saved;
            document.getElementById("profileIcon").style.display="block";
            document.getElementById("profilePreview").style.display="none";
        }
    }
};

/* SELECT EMOJI */
function setAvatar(emoji){
    localStorage.setItem("profileImage", emoji);

    document.getElementById("profileIcon").innerText = emoji;
    document.getElementById("profileIcon").style.display="block";
    document.getElementById("profilePreview").style.display="none";

    closeModal();
}

/* IMAGE UPLOAD */
document.getElementById("uploadImage").addEventListener("change", function(e){

    let file = e.target.files[0];
    if(!file) return;

    let reader = new FileReader();

    reader.onload = function(){
        let data = reader.result;

        localStorage.setItem("profileImage", data);

        document.getElementById("profilePreview").src = data;
        document.getElementById("profilePreview").style.display="block";
        document.getElementById("profileIcon").style.display="none";
    };

    reader.readAsDataURL(file);
});

/* REMOVE AVATAR */
function removeAvatar(){
    localStorage.removeItem("profileImage");

    document.getElementById("profileIcon").innerText = "👤";
    document.getElementById("profileIcon").style.display="block";

    document.getElementById("profilePreview").style.display="none";
    document.getElementById("profilePreview").src = "";

    closeModal();
}

/* SAVE BUTTON */
function saveProfile(){
    alert("Profile saved successfully ✅");
}
</script>

</body>
</html>