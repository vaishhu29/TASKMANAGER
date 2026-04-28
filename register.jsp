<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Register</title>

<meta name="viewport" content="width=device-width, initial-scale=1.0">

<!-- Bootstrap -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Icons -->
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

/* Left Illustration */
.left {
    width: 50%;
    background: linear-gradient(135deg, #6366f1, #06b6d4);
    display: flex;
    align-items: center;
    justify-content: center;
}

.left img {
    width: 70%;
}

/* Right Form */
.right {
    width: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
}

.form-box {
    width: 80%;
}

.form-control {
    padding-left: 40px;
}

.input-icon {
    position: absolute;
    margin-top: 10px;
    margin-left: 10px;
    color: gray;
}

.input-group {
    position: relative;
    margin-bottom: 15px;
}

.btn-custom {
    background: #ef4444;
    color: white;
    border-radius: 8px;
}

.btn-custom:hover {
    background: #dc2626;
}
</style>

</head>

<body>

<div class="container-box">

<!-- LEFT SIDE -->
<div class="left">
    <img src="https://cdn-icons-png.flaticon.com/512/3135/3135715.png">
</div>

<!-- RIGHT SIDE -->
<div class="right">

<div class="form-box">

<h3 class="mb-4 text-center">Sign Up</h3>

<form action="register" method="post">

<div class="input-group">
    <i class="fa fa-user input-icon"></i>
    <input type="text" name="firstname" class="form-control" placeholder="First Name" required>
</div>

<div class="input-group">
    <i class="fa fa-user input-icon"></i>
    <input type="text" name="lastname" class="form-control" placeholder="Last Name" required>
</div>

<div class="input-group">
    <i class="fa fa-user input-icon"></i>
    <input type="text" name="username" class="form-control" placeholder="Username" required>
</div>

<div class="input-group">
    <i class="fa fa-envelope input-icon"></i>
    <input type="email" name="email" class="form-control" placeholder="Email" required>
</div>

<div class="input-group">
    <i class="fa fa-lock input-icon"></i>
    <input type="password" name="password" class="form-control" placeholder="Password" required>
</div>

<div class="input-group">
    <i class="fa fa-lock input-icon"></i>
    <input type="password" name="confirm" class="form-control" placeholder="Confirm Password" required>
</div>

<div class="form-check mb-3">
    <input class="form-check-input" type="checkbox" required>
    <label class="form-check-label">I agree to all terms</label>
</div>

<button class="btn btn-custom w-100">Register</button>

<p class="mt-3 text-center">
Already have an account? <a href="login.jsp">Sign In</a>
</p>

</form>

</div>

</div>

</div>

</body>
</html>