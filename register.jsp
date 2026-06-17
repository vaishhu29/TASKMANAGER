<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>TaskFlow - Create Account</title>
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

        .register-container {
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

        .register-left {
            width: 50%;
            background: linear-gradient(135deg, #6366f1 0%, #06b6d4 100%);
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 50px;
            color: white;
            position: relative;
        }

        .register-left::after {
            content: '';
            position: absolute;
            width: 300px;
            height: 300px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            bottom: -50px;
            left: -50px;
        }

        .register-left h2 {
            font-weight: 800;
            font-size: 32px;
            letter-spacing: -0.5px;
            margin-bottom: 15px;
            text-align: center;
        }

        .register-left p {
            font-size: 15px;
            color: rgba(255, 255, 255, 0.8);
            text-align: center;
            max-width: 320px;
            line-height: 1.6;
        }

        .register-left img {
            width: 70%;
            margin-top: 30px;
            filter: drop-shadow(0 10px 20px rgba(0,0,0,0.15));
            animation: float 4s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }

        .register-right {
            width: 50%;
            padding: 50px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .brand-logo {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 22px;
            font-weight: 800;
            letter-spacing: -0.5px;
            background: linear-gradient(90deg, #818cf8, #06b6d4);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 25px;
            justify-content: center;
        }

        .brand-logo i {
            font-size: 26px;
            color: #818cf8;
            -webkit-text-fill-color: initial;
        }

        .register-right h3 {
            font-weight: 700;
            color: white;
            font-size: 24px;
            margin-bottom: 5px;
            text-align: center;
        }

        .register-right p.subtitle {
            color: #94a3b8;
            font-size: 13px;
            margin-bottom: 25px;
            text-align: center;
        }

        .input-group {
            position: relative;
            margin-bottom: 15px;
        }

        .input-icon {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: #64748b;
            font-size: 15px;
            z-index: 10;
        }

        .form-control {
            background: rgba(15, 23, 42, 0.3) !important;
            border: 1px solid rgba(255, 255, 255, 0.08) !important;
            border-radius: 12px;
            padding: 12px 12px 12px 46px;
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
            background: linear-gradient(90deg, #6366f1, #06b6d4);
            color: white;
            border-radius: 12px;
            border: none;
            padding: 13px;
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

        .login-link {
            color: #94a3b8;
            font-size: 14px;
            text-align: center;
            margin-top: 20px;
            margin-bottom: 0;
        }

        .login-link a {
            color: #818cf8;
            text-decoration: none;
            font-weight: 600;
        }

        .login-link a:hover {
            text-decoration: underline;
        }

        @media(max-width: 768px) {
            .register-container {
                flex-direction: column;
            }
            .register-left, .register-right {
                width: 100%;
                padding: 30px;
            }
            .register-left {
                padding-top: 50px;
                padding-bottom: 50px;
            }
            .register-left img {
                display: none;
            }
        }
    </style>
</head>
<body>

    <div class="register-container">
        
        <!-- LEFT SIDE: HERO -->
        <div class="register-left">
            <h2>Start your journey.</h2>
            <p>Create a free account to gain full access to TaskFlow's clean organization boards.</p>
            <img src="https://cdn-icons-png.flaticon.com/512/2092/2092063.png" alt="Illustration">
        </div>

        <!-- RIGHT SIDE: FORM -->
        <div class="register-right">
            <div class="brand-logo">
                <i class="bi bi-check2-square"></i>
                <span>TaskFlow</span>
            </div>
            
            <h3>Create Account</h3>
            <p class="subtitle">Join us today to supercharge your workflow.</p>

            <form action="register" method="post">
                <div class="row g-2 mb-3">
                    <div class="col-6">
                        <div class="input-group mb-0">
                            <i class="bi bi-person input-icon"></i>
                            <input type="text" name="firstname" class="form-control" placeholder="First Name" required>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="input-group mb-0">
                            <i class="bi bi-person input-icon"></i>
                            <input type="text" name="lastname" class="form-control" placeholder="Last Name" required>
                        </div>
                    </div>
                </div>

                <div class="input-group">
                    <i class="bi bi-shield-lock input-icon"></i>
                    <input type="text" name="username" class="form-control" placeholder="Choose Username" required>
                </div>

                <div class="input-group">
                    <i class="bi bi-envelope input-icon"></i>
                    <input type="email" name="email" class="form-control" placeholder="Email Address" required>
                </div>

                <div class="input-group">
                    <i class="bi bi-lock input-icon"></i>
                    <input type="password" name="password" class="form-control" placeholder="Password" required>
                </div>

                <div class="input-group">
                    <i class="bi bi-lock-fill input-icon"></i>
                    <input type="password" name="confirm" class="form-control" placeholder="Confirm Password" required>
                </div>

                <div class="form-check mb-4">
                    <input class="form-check-input" type="checkbox" id="agreeTerms" required>
                    <label class="form-check-label" for="agreeTerms">I agree to the Terms & Conditions</label>
                </div>

                <button type="submit" class="btn btn-custom w-100">Sign Up</button>
            </form>

            <p class="login-link">
                Already have an account? <a href="login.jsp">Sign In</a>
            </p>
        </div>

    </div>

</body>
</html>