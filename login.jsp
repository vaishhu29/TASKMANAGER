<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login</title>

<meta name="viewport" content="width=device-width, initial-scale=1.0">

<!-- Bootstrap -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Font Awesome -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

<style>
body {
    margin: 0;
    font-family: 'Segoe UI', sans-serif;
    background: #f1f5f9;
}

/* Layout */
.container-box {
    display: flex;
    height: 100vh;
}

/* LEFT SIDE (FORM) */
.left {
    width: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
}

.form-box {
    width: 75%;
}

/* RIGHT SIDE (IMAGE) */
.right {
    width: 50%;
    background: linear-gradient(135deg, #60a5fa, #a78bfa);
    display: flex;
    align-items: center;
    justify-content: center;
}

.right img {
    width: 70%;
}

/* Inputs */
.input-group {
    position: relative;
    margin-bottom: 15px;
}

.input-icon {
    position: absolute;
    margin-top: 10px;
    margin-left: 10px;
    color: gray;
}

.form-control {
    padding-left: 40px;
}

/* Button */
.btn-custom {
    background: #ef4444;
    color: white;
    border-radius: 8px;
}

.btn-custom:hover {
    background: #dc2626;
}

/* Footer */
.login-footer {
    font-size: 14px;
    margin-top: 10px;
}
</style>

</head>

<body>

<div class="container-box">

<!-- LEFT SIDE -->
<div class="left">

<div class="form-box">

<h3 class="mb-4">Sign In</h3>

<!-- 🔴 ERROR MESSAGE -->
<%
String error = request.getParameter("error");
if(error != null){
%>
<div class="alert alert-danger">
    <% if("invalid".equals(error)){ %>
        Invalid username or password
    <% } else if("empty".equals(error)){ %>
        Please fill all fields
    <% } else { %>
        Something went wrong
    <% } %>
</div>
<% } %>

<form action="login" method="post">

<div class="input-group">
    <i class="fa fa-user input-icon"></i>
    <input type="text" name="username" class="form-control" placeholder="Enter Username" required>
</div>

<div class="input-group">
    <i class="fa fa-lock input-icon"></i>
    <input type="password" name="password" class="form-control" placeholder="Enter Password" required>
</div>

<div class="form-check mb-3">
    <input class="form-check-input" type="checkbox">
    <label class="form-check-label">Remember Me</label>
</div>

<button class="btn btn-custom w-100">Login</button>

<div class="login-footer mt-3">
    <p>Or login with</p>
    <i class="fab fa-facebook me-2"></i>
    <i class="fab fa-google me-2"></i>
    <i class="fab fa-twitter"></i>

    <p class="mt-2">
        Don't have an account? <a href="register.jsp">Create One</a>
    </p>
</div>

</form>

</div>

</div>

<!-- RIGHT SIDE -->
<div class="right">
    <img src="https://cdn-icons-png.flaticon.com/512/3135/3135715.png">
</div>

</div>

</body>
</html>