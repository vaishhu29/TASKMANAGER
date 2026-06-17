<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>TaskFlow - Sign In</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
            overflow-x: hidden;
        }

        .login-container {
            width: 100%;
            max-width: 1000px;
            background: rgba(30, 41, 59, 0.4);
            backdrop-filter: blur(16px);
            border-radius: 28px;
            border: 1px solid rgba(255, 255, 255, 0.08);
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.3);
            overflow: hidden;
            display: flex;
            margin: 20px;
        }

        .login-left {
            width: 50%;
            padding: 50px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .login-right {
            width: 50%;
            background: linear-gradient(135deg, #6366f1 0%, #a855f7 100%);
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 50px;
            color: white;
            position: relative;
        }

        .login-right::after {
            content: '';
            position: absolute;
            width: 300px;
            height: 300px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            top: -50px;
            right: -50px;
        }

        .login-right h2 {
            font-weight: 800;
            font-size: 32px;
            letter-spacing: -0.5px;
            margin-bottom: 15px;
            text-align: center;
        }

        .login-right p {
            font-size: 15px;
            color: rgba(255, 255, 255, 0.8);
            text-align: center;
            max-width: 320px;
            line-height: 1.6;
        }

        .login-right img {
            width: 70%;
            margin-top: 30px;
            filter: drop-shadow(0 10px 20px rgba(0,0,0,0.15));
            animation: float 4s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }

        .brand-logo {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 22px;
            font-weight: 800;
            letter-spacing: -0.5px;
            background: linear-gradient(90deg, #818cf8, #c084fc);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 35px;
        }

        .brand-logo i {
            font-size: 26px;
            color: #818cf8;
            -webkit-text-fill-color: initial;
        }

        .login-left h3 {
            font-weight: 700;
            color: white;
            font-size: 26px;
            margin-bottom: 8px;
        }

        .login-left p.subtitle {
            color: #94a3b8;
            font-size: 14px;
            margin-bottom: 30px;
        }

        .input-group {
            position: relative;
            margin-bottom: 20px;
        }

        .input-icon {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: #64748b;
            font-size: 16px;
            z-index: 10;
        }

        .form-control {
            background: rgba(15, 23, 42, 0.3) !important;
            border: 1px solid rgba(255, 255, 255, 0.08) !important;
            border-radius: 12px;
            padding: 14px 14px 14px 46px;
            color: white !important;
            font-size: 14px;
            transition: all 0.2s ease;
        }

        .form-control::placeholder {
            color: #475569;
        }

        .form-control:focus {
            box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.15);
            border-color: #6366f1 !important;
        }

        .btn-custom {
            background: linear-gradient(90deg, #6366f1, #a855f7);
            color: white;
            border-radius: 12px;
            border: none;
            padding: 14px;
            font-weight: 700;
            font-size: 15px;
            letter-spacing: 0.5px;
            transition: all 0.2s ease;
            box-shadow: 0 4px 15px rgba(99, 102, 241, 0.2);
            margin-top: 10px;
        }

        .btn-custom:hover {
            opacity: 0.95;
            transform: translateY(-1px);
            box-shadow: 0 6px 20px rgba(99, 102, 241, 0.35);
        }

        .form-check-label {
            color: #94a3b8;
            font-size: 13px;
        }

        .form-check-input {
            background-color: rgba(15, 23, 42, 0.4);
            border-color: rgba(255, 255, 255, 0.1);
        }

        .form-check-input:checked {
            background-color: #6366f1;
            border-color: #6366f1;
        }

        .register-link {
            color: #94a3b8;
            font-size: 14px;
            text-align: center;
            margin-top: 25px;
        }

        .register-link a {
            color: #818cf8;
            text-decoration: none;
            font-weight: 600;
        }

        .register-link a:hover {
            text-decoration: underline;
        }

        .alert {
            background: rgba(239, 68, 68, 0.1);
            border: 1px solid rgba(239, 68, 68, 0.2);
            color: #fca5a5;
            border-radius: 12px;
            font-size: 14px;
            padding: 12px;
            margin-bottom: 20px;
        }

        @media(max-width: 768px) {
            .login-container {
                flex-direction: column-reverse;
            }
            .login-left, .login-right {
                width: 100%;
                padding: 30px;
            }
            .login-right {
                padding-top: 50px;
                padding-bottom: 50px;
            }
            .login-right img {
                display: none;
            }
        }
    </style>
</head>
<body>

    <div class="login-container">
        
        <!-- LEFT SIDE: FORM -->
        <div class="login-left">
            <div class="brand-logo">
                <i class="bi bi-check2-square"></i>
                <span>TaskFlow</span>
            </div>
            
            <h3>Welcome back</h3>
            <p class="subtitle">Please sign in to access your dashboard.</p>

            <!-- ERROR ALERTS -->
            <%
            String error = request.getParameter("error");
            if(error != null){
            %>
                <div class="alert d-flex align-items-center gap-2">
                    <i class="bi bi-exclamation-triangle-fill"></i>
                    <span>
                        <% if("invalid".equals(error)){ %>
                            Invalid username or password.
                        <% } else if("empty".equals(error)){ %>
                            Please fill in all required fields.
                        <% } else { %>
                            An unexpected error occurred.
                        <% } %>
                    </span>
                </div>
            <% } %>

            <form action="login" method="post">
                <div class="input-group">
                    <i class="bi bi-person input-icon"></i>
                    <input type="text" name="username" class="form-control" placeholder="Enter Username" required autocomplete="username">
                </div>

                <div class="input-group">
                    <i class="bi bi-lock input-icon"></i>
                    <input type="password" name="password" class="form-control" placeholder="Enter Password" required autocomplete="current-password">
                </div>

                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="rememberMe">
                        <label class="form-check-label" for="rememberMe">Remember Me</label>
                    </div>
                </div>

                <button type="submit" class="btn btn-custom w-100">Sign In</button>
            </form>

            <p class="register-link">
                Don't have an account? <a href="register.jsp">Create One</a>
            </p>
        </div>

        <!-- RIGHT SIDE: HERO -->
        <div class="login-right">
            <h2>Track. Focus. Achieve.</h2>
            <p>Elevate your productivity and streamline your tasks with TaskFlow's advanced management system.</p>
            <img src="https://cdn-icons-png.flaticon.com/512/2092/2092063.png" alt="Illustration">
        </div>

    </div>

</body>
</html>