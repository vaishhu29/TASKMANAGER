<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
request.setAttribute("activePage", "help");
String name = (String)session.getAttribute("name");
Integer userId = (Integer)session.getAttribute("userId");

if(userId == null){
    response.sendRedirect("login.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
    <title>TaskFlow - Help & Support</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background: #f8fafc;
            margin: 0;
            color: #1e293b;
        }
        
        .content {
            margin-left: 260px;
            padding: 40px;
            min-height: 100vh;
        }

        .header-section {
            margin-bottom: 30px;
        }

        .header-section h3 {
            font-weight: 700;
            color: #0f172a;
            margin: 0;
        }

        .header-section p {
            color: #64748b;
            margin: 5px 0 0 0;
            font-size: 14px;
        }

        .card-box {
            background: white;
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.02);
            border: 1px solid rgba(0, 0, 0, 0.02);
            margin-bottom: 30px;
        }

        .card-box h5 {
            font-weight: 700;
            color: #0f172a;
            margin-bottom: 25px;
            font-size: 18px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .contact-item {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 20px;
        }

        .contact-icon {
            width: 44px;
            height: 44px;
            border-radius: 12px;
            background: rgba(99, 102, 241, 0.1);
            color: #6366f1;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
        }

        .contact-info p {
            margin: 0;
            font-size: 14px;
        }

        .faq-item {
            border-bottom: 1px solid #f1f5f9;
            padding: 20px 0;
        }

        .faq-item:last-child {
            border-bottom: none;
        }

        .faq-question {
            font-weight: 600;
            font-size: 15px;
            color: #0f172a;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .faq-answer {
            font-size: 14px;
            color: #64748b;
            line-height: 1.6;
            padding-left: 24px;
        }
    </style>
</head>
<body>

    <!-- SIDEBAR -->
    <jsp:include page="sidebar.jsp" />

    <!-- MAIN CONTENT -->
    <div class="content">
        
        <!-- HEADER -->
        <div class="header-section">
            <h3>Help & Support</h3>
            <p>Find answers to common questions or reach out to our team.</p>
        </div>

        <div class="row g-4">
            
            <!-- CONTACT INFO -->
            <div class="col-md-5">
                <div class="card-box">
                    <h5><i class="bi bi-headset text-primary"></i> Contact Support</h5>
                    
                    <div class="contact-item">
                        <div class="contact-icon">
                            <i class="bi bi-envelope-fill"></i>
                        </div>
                        <div class="contact-info">
                            <p class="text-muted small fw-bold">EMAIL SUPPORT</p>
                            <p class="fw-semibold">support@taskflow.com</p>
                        </div>
                    </div>

                    <div class="contact-item">
                        <div class="contact-icon">
                            <i class="bi bi-telephone-fill"></i>
                        </div>
                        <div class="contact-info">
                            <p class="text-muted small fw-bold">PHONE NUMBER</p>
                            <p class="fw-semibold">+91 98765 43210</p>
                        </div>
                    </div>

                    <div class="contact-item">
                        <div class="contact-icon">
                            <i class="bi bi-clock-fill"></i>
                        </div>
                        <div class="contact-info">
                            <p class="text-muted small fw-bold">BUSINESS HOURS</p>
                            <p class="fw-semibold">Monday – Friday, 9 AM – 6 PM</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- FAQ SECTION -->
            <div class="col-md-7">
                <div class="card-box">
                    <h5><i class="bi bi-question-circle-fill text-info"></i> Frequently Asked Questions</h5>
                    
                    <div class="faq-item pt-0">
                        <div class="faq-question">
                            <i class="bi bi-patch-question text-primary"></i>
                            <span>How do I add a new task?</span>
                        </div>
                        <div class="faq-answer">
                            Click the blue "+ Add Task" button on the top right of your Dashboard. Fill in the title, description, and optional due date, then click "Add Task".
                        </div>
                    </div>

                    <div class="faq-item">
                        <div class="faq-question">
                            <i class="bi bi-patch-question text-primary"></i>
                            <span>How do I complete a task?</span>
                        </div>
                        <div class="faq-answer">
                            You can mark a task complete by clicking the green check mark (✔) button on the task card on the Dashboard, or via the "My Tasks" page.
                        </div>
                    </div>

                    <div class="faq-item">
                        <div class="faq-question">
                            <i class="bi bi-patch-question text-primary"></i>
                            <span>Can I customize task statuses?</span>
                        </div>
                        <div class="faq-answer">
                            Yes, navigate to the "Categories" tab from the sidebar. You can add, edit, or delete custom task statuses and priority levels there.
                        </div>
                    </div>

                    <div class="faq-item pb-0">
                        <div class="faq-question">
                            <i class="bi bi-patch-question text-primary"></i>
                            <span>How do I change my profile avatar?</span>
                        </div>
                        <div class="faq-answer">
                            Go to "Settings" page and click on your profile avatar image. A dialog box will appear where you can upload a local image file or select an emoji as your avatar.
                        </div>
                    </div>
                </div>
            </div>

        </div>

    </div>

</body>
</html>