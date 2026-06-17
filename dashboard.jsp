<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
request.setAttribute("activePage", "dashboard");
String name = (String)session.getAttribute("name");
Integer userId = (Integer)session.getAttribute("userId");

if(userId == null){
    response.sendRedirect("login.jsp");
    return;
}

int total=0, pending=0, completed=0, skippedCount=0;

// Fetch metrics at the top of the page before rendering elements
try(Connection con = DBConnection.getConnection()){
    
    // Pending count
    PreparedStatement psPending = con.prepareStatement(
        "SELECT COUNT(*) FROM tasks WHERE user_id=? AND status='PENDING'"
    );
    psPending.setInt(1, userId);
    ResultSet rsPending = psPending.executeQuery();
    if(rsPending.next()) pending = rsPending.getInt(1);
    rsPending.close(); psPending.close();

    // Completed count
    PreparedStatement psCompleted = con.prepareStatement(
        "SELECT COUNT(*) FROM tasks WHERE user_id=? AND status='COMPLETED'"
    );
    psCompleted.setInt(1, userId);
    ResultSet rsCompleted = psCompleted.executeQuery();
    if(rsCompleted.next()) completed = rsCompleted.getInt(1);
    rsCompleted.close(); psCompleted.close();

    total = pending + completed;

    // Skipped days count
    PreparedStatement psSkipped = con.prepareStatement(
        "SELECT COUNT(*) FROM skip_days WHERE user_id=?"
    );
    psSkipped.setInt(1, userId);
    ResultSet rsSkipped = psSkipped.executeQuery();
    if(rsSkipped.next()) skippedCount = rsSkipped.getInt(1);
    rsSkipped.close(); psSkipped.close();

} catch(Exception e) {
    e.printStackTrace();
}
%>

<!DOCTYPE html>
<html>
<head>
    <title>TaskFlow - Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        .header-title h3 {
            font-weight: 700;
            color: #0f172a;
            margin: 0;
        }

        .header-title p {
            color: #64748b;
            margin: 5px 0 0 0;
            font-size: 14px;
        }

        .action-buttons {
            display: flex;
            gap: 12px;
        }

        .btn-custom {
            padding: 12px 20px;
            border-radius: 12px;
            font-weight: 600;
            font-size: 14px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            border: none;
            transition: all 0.2s ease;
        }

        .btn-add-task {
            background: linear-gradient(135deg, #6366f1, #4f46e5);
            color: white;
            box-shadow: 0 4px 14px rgba(99, 102, 241, 0.3);
        }

        .btn-add-task:hover {
            background: linear-gradient(135deg, #4f46e5, #4338ca);
            transform: translateY(-2px);
            color: white;
        }

        .btn-skip-day {
            background: white;
            color: #64748b;
            border: 1px solid #e2e8f0;
        }

        .btn-skip-day:hover {
            background: #f1f5f9;
            color: #1e293b;
            transform: translateY(-2px);
        }

        .card-stat {
            background: white;
            padding: 24px;
            border-radius: 20px;
            border: 1px solid rgba(0, 0, 0, 0.02);
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.02);
            display: flex;
            align-items: center;
            gap: 20px;
            transition: all 0.3s ease;
        }

        .card-stat:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.05);
        }

        .stat-icon {
            width: 54px;
            height: 54px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 24px;
        }

        .icon-total { background: rgba(99, 102, 241, 0.1); color: #6366f1; }
        .icon-pending { background: rgba(245, 158, 11, 0.1); color: #f59e0b; }
        .icon-completed { background: rgba(34, 197, 94, 0.1); color: #22c55e; }
        .icon-skipped { background: rgba(239, 68, 68, 0.1); color: #ef4444; }

        .stat-info h4 {
            margin: 0;
            font-size: 28px;
            font-weight: 700;
            color: #0f172a;
        }

        .stat-info p {
            margin: 0;
            font-size: 13px;
            color: #64748b;
            font-weight: 500;
        }

        .card-box {
            background: white;
            border-radius: 20px;
            padding: 28px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.02);
            border: 1px solid rgba(0, 0, 0, 0.02);
            margin-bottom: 30px;
        }

        .card-box h5 {
            font-weight: 700;
            color: #0f172a;
            margin-bottom: 20px;
            font-size: 18px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .task-list {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .task-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 16px 20px;
            background: #f8fafc;
            border-radius: 14px;
            border-left: 4px solid #cbd5e1;
            transition: all 0.2s ease;
        }

        .task-item:hover {
            transform: translateX(4px);
            background: #f1f5f9;
        }

        .task-item.pending {
            border-left-color: #f59e0b;
        }

        .task-item.completed {
            border-left-color: #22c55e;
        }

        .task-item.completed .task-title {
            text-decoration: line-through;
            color: #94a3b8;
        }

        .task-content {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

        .task-title {
            font-weight: 600;
            font-size: 15px;
            color: #1e293b;
        }

        .task-desc {
            font-size: 13px;
            color: #64748b;
        }

        .task-meta {
            display: flex;
            gap: 12px;
            font-size: 12px;
            color: #94a3b8;
            align-items: center;
            margin-top: 2px;
        }

        .task-meta span {
            display: flex;
            align-items: center;
            gap: 4px;
        }

        .task-actions {
            display: flex;
            gap: 8px;
        }

        .btn-action {
            width: 36px;
            height: 36px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            border: none;
            background: white;
            color: #64748b;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            transition: all 0.2s ease;
            text-decoration: none;
        }

        .btn-action-complete:hover {
            background: #22c55e;
            color: white;
            box-shadow: 0 4px 12px rgba(34, 197, 94, 0.3);
        }

        .btn-action-delete:hover {
            background: #ef4444;
            color: white;
            box-shadow: 0 4px 12px rgba(239, 68, 68, 0.3);
        }

        .empty-state {
            text-align: center;
            padding: 40px 20px;
            color: #94a3b8;
        }

        .empty-state i {
            font-size: 48px;
            margin-bottom: 12px;
            display: block;
            color: #cbd5e1;
        }

        /* MODALS */
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(15, 23, 42, 0.6);
            backdrop-filter: blur(4px);
            z-index: 1050;
            justify-content: center;
            align-items: center;
        }

        .modal-box {
            background: white;
            width: 100%;
            max-width: 500px;
            border-radius: 24px;
            padding: 30px;
            box-shadow: 0 20px 50px rgba(15, 23, 42, 0.15);
            border: 1px solid rgba(255,255,255,0.1);
            animation: modalFadeIn 0.3s ease;
        }

        @keyframes modalFadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: none;
            padding: 0 0 15px 0;
        }

        .modal-header h5 {
            font-weight: 700;
            margin: 0;
            font-size: 18px;
        }

        .modal-close {
            background: none;
            border: none;
            font-size: 20px;
            color: #94a3b8;
            cursor: pointer;
        }

        .form-control {
            border-radius: 12px;
            padding: 12px;
            border: 1px solid #e2e8f0;
            font-size: 14px;
        }

        .form-control:focus {
            box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.1);
            border-color: #6366f1;
        }

        .chart-container {
            position: relative;
            margin: auto;
            height: 220px;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        /* Skip Day items */
        .skipped-day-pill {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: #fee2e2;
            color: #ef4444;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            margin: 4px;
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
            <div class="header-title">
                <h3>Welcome back, <%= name %>!</h3>
                <p>Here's an overview of your productivity today.</p>
            </div>
            <div class="action-buttons">
                <button class="btn-custom btn-skip-day" onclick="openModal('skipModal')">
                    <i class="bi bi-calendar-x"></i> Skip Day
                </button>
                <button class="btn-custom btn-add-task" onclick="openModal('taskModal')">
                    <i class="bi bi-plus-lg"></i> Add Task
                </button>
            </div>
        </div>

        <!-- STATS GRID -->
        <div class="row g-4 mb-4">
            <div class="col-md-3">
                <div class="card-stat">
                    <div class="stat-icon icon-total">
                        <i class="bi bi-grid"></i>
                    </div>
                    <div class="stat-info">
                        <h4><%= total %></h4>
                        <p>Total Tasks</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card-stat">
                    <div class="stat-icon icon-pending">
                        <i class="bi bi-clock-history"></i>
                    </div>
                    <div class="stat-info">
                        <h4 style="color:#f59e0b"><%= pending %></h4>
                        <p>Pending</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card-stat">
                    <div class="stat-icon icon-completed">
                        <i class="bi bi-check-circle"></i>
                    </div>
                    <div class="stat-info">
                        <h4 style="color:#22c55e"><%= completed %></h4>
                        <p>Completed</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card-stat">
                    <div class="stat-icon icon-skipped">
                        <i class="bi bi-calendar-event"></i>
                    </div>
                    <div class="stat-info">
                        <h4 style="color:#ef4444"><%= skippedCount %></h4>
                        <p>Skipped Days</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- MAIN LAYOUT -->
        <div class="row g-4">
            
            <!-- LEFT COLUMN: PENDING TASKS -->
            <div class="col-md-7">
                <div class="card-box">
                    <h5><i class="bi bi-collection-play-fill text-warning"></i> Pending Tasks</h5>
                    <div class="task-list">
                        <%
                        try(Connection con = DBConnection.getConnection()){
                            PreparedStatement ps = con.prepareStatement(
                                "SELECT * FROM tasks WHERE user_id=? AND status='PENDING' ORDER BY deadline ASC"
                            );
                            ps.setInt(1, userId);
                            ResultSet rs = ps.executeQuery();
                            boolean hasPending = false;
                            
                            while(rs.next()){
                                hasPending = true;
                                int taskId = rs.getInt("id");
                                String taskTitle = rs.getString("title");
                                String taskDesc = rs.getString("description");
                                Date taskDeadline = rs.getDate("deadline");
                        %>
                                <div class="task-item pending">
                                    <div class="task-content">
                                        <span class="task-title"><%= taskTitle %></span>
                                        <% if(taskDesc != null && !taskDesc.trim().isEmpty()) { %>
                                            <span class="task-desc"><%= taskDesc %></span>
                                        <% } %>
                                        <div class="task-meta">
                                            <% if(taskDeadline != null) { %>
                                                <span><i class="bi bi-calendar"></i> <%= taskDeadline %></span>
                                            <% } else { %>
                                                <span><i class="bi bi-calendar"></i> No deadline</span>
                                            <% } %>
                                        </div>
                                    </div>
                                    <div class="task-actions">
                                        <a href="complete?id=<%= taskId %>" class="btn-action btn-action-complete" title="Mark Complete">
                                            <i class="bi bi-check-lg"></i>
                                        </a>
                                        <a href="delete?id=<%= taskId %>" class="btn-action btn-action-delete" title="Delete Task">
                                            <i class="bi bi-trash"></i>
                                        </a>
                                    </div>
                                </div>
                        <%
                            }
                            if(!hasPending) {
                        %>
                                <div class="empty-state">
                                    <i class="bi bi-clipboard2-check"></i>
                                    No pending tasks. You're all caught up!
                                </div>
                        <%
                            }
                            rs.close(); ps.close();
                        } catch(Exception e) {
                            out.println("<p class='text-danger'>Database Error fetching pending tasks.</p>");
                        }
                        %>
                    </div>
                </div>

                <!-- COMPLETED TASKS -->
                <div class="card-box">
                    <h5><i class="bi bi-check-circle-fill text-success"></i> Completed Tasks</h5>
                    <div class="task-list">
                        <%
                        try(Connection con = DBConnection.getConnection()){
                            PreparedStatement ps = con.prepareStatement(
                                "SELECT * FROM tasks WHERE user_id=? AND status='COMPLETED' ORDER BY id DESC LIMIT 5"
                            );
                            ps.setInt(1, userId);
                            ResultSet rs = ps.executeQuery();
                            boolean hasCompleted = false;
                            
                            while(rs.next()){
                                hasCompleted = true;
                                int taskId = rs.getInt("id");
                                String taskTitle = rs.getString("title");
                                String taskDesc = rs.getString("description");
                                Date taskDeadline = rs.getDate("deadline");
                        %>
                                <div class="task-item completed">
                                    <div class="task-content">
                                        <span class="task-title"><%= taskTitle %></span>
                                        <% if(taskDesc != null && !taskDesc.trim().isEmpty()) { %>
                                            <span class="task-desc"><%= taskDesc %></span>
                                        <% } %>
                                        <div class="task-meta">
                                            <% if(taskDeadline != null) { %>
                                                <span><i class="bi bi-calendar"></i> <%= taskDeadline %></span>
                                            <% } %>
                                        </div>
                                    </div>
                                    <div class="task-actions">
                                        <a href="delete?id=<%= taskId %>" class="btn-action btn-action-delete" title="Delete Task">
                                            <i class="bi bi-trash"></i>
                                        </a>
                                    </div>
                                </div>
                        <%
                            }
                            if(!hasCompleted) {
                        %>
                                <div class="empty-state">
                                    <i class="bi bi-clipboard2"></i>
                                    No completed tasks yet.
                                </div>
                        <%
                            }
                            rs.close(); ps.close();
                        } catch(Exception e) {
                            out.println("<p class='text-danger'>Database Error fetching completed tasks.</p>");
                        }
                        %>
                    </div>
                </div>
            </div>

            <!-- RIGHT COLUMN: ANALYTICS & SKIPPED DAYS -->
            <div class="col-md-5">
                
                <!-- ANALYTICS CARD -->
                <div class="card-box text-center">
                    <h5><i class="bi bi-pie-chart-fill text-primary"></i> Task Analytics</h5>
                    <div class="chart-container">
                        <% if(total > 0) { %>
                            <canvas id="analyticsChart"></canvas>
                        <% } else { %>
                            <div class="empty-state">
                                <i class="bi bi-bar-chart"></i>
                                No task data available. Add tasks to see analytics.
                            </div>
                        <% } %>
                    </div>
                </div>

                <!-- SKIPPED DAYS CARD -->
                <div class="card-box">
                    <h5><i class="bi bi-calendar-x-fill text-danger"></i> Skipped Days</h5>
                    <div>
                        <%
                        try(Connection con = DBConnection.getConnection()){
                            PreparedStatement ps = con.prepareStatement(
                                "SELECT * FROM skip_days WHERE user_id=? ORDER BY skip_date DESC LIMIT 10"
                            );
                            ps.setInt(1, userId);
                            ResultSet rs = ps.executeQuery();
                            boolean hasSkipped = false;
                            
                            while(rs.next()){
                                hasSkipped = true;
                                Date skipDate = rs.getDate("skip_date");
                        %>
                                <span class="skipped-day-pill">
                                    <i class="bi bi-calendar-minus"></i> <%= skipDate %>
                                </span>
                        <%
                            }
                            if(!hasSkipped) {
                        %>
                                <div class="empty-state py-3">
                                    No skipped days registered yet.
                                </div>
                        <%
                            }
                            rs.close(); ps.close();
                        } catch(Exception e) {
                            out.println("<p class='text-danger'>Database Error.</p>");
                        }
                        %>
                    </div>
                </div>

            </div>

        </div>

    </div>

    <!-- TASK MODAL -->
    <div id="taskModal" class="modal-overlay">
        <div class="modal-box">
            <div class="modal-header">
                <h5>Add New Task</h5>
                <button class="modal-close" onclick="closeModal('taskModal')">✖</button>
            </div>
            <form action="addTask" method="post">
                <div class="mb-3">
                    <label class="form-label text-muted small fw-bold">TASK TITLE</label>
                    <input type="text" name="title" class="form-control" placeholder="What needs to be done?" required>
                </div>
                <div class="mb-3">
                    <label class="form-label text-muted small fw-bold">DESCRIPTION</label>
                    <textarea name="description" class="form-control" rows="3" placeholder="Add some details..."></textarea>
                </div>
                <div class="mb-4">
                    <label class="form-label text-muted small fw-bold">DUE DATE</label>
                    <input type="date" name="deadline" class="form-control">
                </div>
                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-custom btn-add-task w-100 justify-content-center">Add Task</button>
                    <button type="button" class="btn btn-custom btn-skip-day w-100 justify-content-center" onclick="closeModal('taskModal')">Cancel</button>
                </div>
            </form>
        </div>
    </div>

    <!-- SKIP DAY MODAL -->
    <div id="skipModal" class="modal-overlay">
        <div class="modal-box">
            <div class="modal-header">
                <h5>Register Skipped Day</h5>
                <button class="modal-close" onclick="closeModal('skipModal')">✖</button>
            </div>
            <form action="skipDay" method="post">
                <div class="mb-4">
                    <label class="form-label text-muted small fw-bold">SELECT DATE</label>
                    <input type="date" name="skipDate" class="form-control" required value="<%= new java.sql.Date(System.currentTimeMillis()) %>">
                </div>
                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-custom btn-add-task w-100 justify-content-center" style="background:linear-gradient(135deg, #ef4444, #dc2626); box-shadow: 0 4px 14px rgba(239, 68, 68, 0.3);">Register</button>
                    <button type="button" class="btn btn-custom btn-skip-day w-100 justify-content-center" onclick="closeModal('skipModal')">Cancel</button>
                </div>
            </form>
        </div>
    </div>

    <!-- SCRIPT FOR MODALS & CHARTS -->
    <script>
        function openModal(id) {
            document.getElementById(id).style.display = "flex";
        }
        function closeModal(id) {
            document.getElementById(id).style.display = "none";
        }

        // Close modals on clicking overlay
        window.onclick = function(event) {
            if (event.target.classList.contains('modal-overlay')) {
                event.target.style.display = "none";
            }
        }

        <% if(total > 0) { %>
        // Initialize Chart
        window.addEventListener('load', function() {
            const ctx = document.getElementById('analyticsChart').getContext('2d');
            new Chart(ctx, {
                type: 'doughnut',
                data: {
                    labels: ['Pending', 'Completed'],
                    datasets: [{
                        data: [<%= pending %>, <%= completed %>],
                        backgroundColor: ['#f59e0b', '#22c55e'],
                        borderWidth: 0,
                        hoverOffset: 4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom',
                            labels: {
                                font: {
                                    family: 'Plus Jakarta Sans',
                                    size: 12,
                                    weight: '500'
                                },
                                padding: 15
                            }
                        }
                    },
                    cutout: '70%'
                }
            });
        });
        <% } %>
    </script>
</body>
</html>