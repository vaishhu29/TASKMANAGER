<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
request.setAttribute("activePage", "mytasks");
String name = (String)session.getAttribute("name");
Integer userId = (Integer)session.getAttribute("userId");

if(userId == null){
    response.sendRedirect("login.jsp");
    return;
}

int total = 0, pending = 0, completed = 0;

try(Connection con = DBConnection.getConnection()){
    
    // Get task counts
    PreparedStatement psCount = con.prepareStatement(
        "SELECT status, COUNT(*) as count FROM tasks WHERE user_id=? GROUP BY status"
    );
    psCount.setInt(1, userId);
    ResultSet rsCount = psCount.executeQuery();
    
    while(rsCount.next()){
        int count = rsCount.getInt("count");
        String status = rsCount.getString("status");
        total += count;
        if("PENDING".equals(status)) pending = count;
        if("COMPLETED".equals(status)) completed = count;
    }
    rsCount.close(); psCount.close();

} catch(Exception e){
    e.printStackTrace();
}
%>

<!DOCTYPE html>
<html>
<head>
    <title>TaskFlow - My Tasks</title>
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

        .card-stat-mini {
            background: white;
            padding: 16px 20px;
            border-radius: 16px;
            border: 1px solid rgba(0, 0, 0, 0.02);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.01);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .card-stat-mini h4 {
            margin: 0;
            font-weight: 700;
            color: #0f172a;
        }

        .card-stat-mini span {
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
            height: 100%;
        }

        .card-box h5 {
            font-weight: 700;
            color: #0f172a;
            margin-bottom: 20px;
            font-size: 18px;
        }

        .task-list-container {
            max-height: 60vh;
            overflow-y: auto;
            padding-right: 5px;
        }

        /* Custom Scrollbar */
        .task-list-container::-webkit-scrollbar {
            width: 6px;
        }
        .task-list-container::-webkit-scrollbar-track {
            background: #f1f5f9;
            border-radius: 10px;
        }
        .task-list-container::-webkit-scrollbar-thumb {
            background: #cbd5e1;
            border-radius: 10px;
        }

        .task-item {
            padding: 16px 20px;
            background: #f8fafc;
            border-radius: 14px;
            border-left: 4px solid #cbd5e1;
            margin-bottom: 12px;
            cursor: pointer;
            transition: all 0.2s ease;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .task-item:hover {
            transform: translateX(4px);
            background: #f1f5f9;
        }

        .task-item.active-task {
            background: #eff6ff;
            border-left-color: #3b82f6;
        }

        .task-item.pending {
            border-left-color: #f59e0b;
        }

        .task-item.completed {
            border-left-color: #22c55e;
        }

        .task-title {
            font-weight: 600;
            font-size: 14px;
            color: #1e293b;
            display: block;
            margin-bottom: 4px;
        }

        .task-date {
            font-size: 12px;
            color: #94a3b8;
        }

        .badge-status {
            font-size: 11px;
            font-weight: 600;
            padding: 4px 10px;
            border-radius: 20px;
        }

        .badge-pending {
            background: #fef3c7;
            color: #d97706;
        }

        .badge-completed {
            background: #dcfce7;
            color: #15803d;
        }

        .details-panel {
            background: white;
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.02);
            border: 1px solid rgba(0, 0, 0, 0.02);
            min-height: 350px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            color: #94a3b8;
            text-align: center;
        }

        .details-panel.has-data {
            align-items: flex-start;
            text-align: left;
            color: #1e293b;
            justify-content: flex-start;
        }

        .details-header {
            width: 100%;
            border-bottom: 1px solid #f1f5f9;
            padding-bottom: 20px;
            margin-bottom: 20px;
        }

        .details-header h4 {
            font-weight: 700;
            margin: 0 0 10px 0;
            color: #0f172a;
        }

        .details-body {
            font-size: 15px;
            line-height: 1.6;
            color: #475569;
            flex-grow: 1;
            width: 100%;
        }

        .details-footer {
            width: 100%;
            border-top: 1px solid #f1f5f9;
            padding-top: 20px;
            margin-top: 20px;
            display: flex;
            gap: 12px;
        }

        .btn-custom {
            padding: 10px 18px;
            border-radius: 10px;
            font-weight: 600;
            font-size: 13px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            text-decoration: none;
            transition: all 0.2s ease;
        }

        .btn-complete {
            background: #22c55e;
            color: white;
        }

        .btn-complete:hover {
            background: #16a34a;
            color: white;
        }

        .btn-delete {
            background: #ef4444;
            color: white;
        }

        .btn-delete:hover {
            background: #dc2626;
            color: white;
        }

        .empty-state {
            text-align: center;
            padding: 50px 20px;
            color: #94a3b8;
        }

        .empty-state i {
            font-size: 48px;
            margin-bottom: 12px;
            display: block;
            color: #cbd5e1;
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
            <h3>My Tasks</h3>
            <p>View, track, and manage all your tasks in one place.</p>
        </div>

        <!-- COUNTERS -->
        <div class="row g-3 mb-4">
            <div class="col-md-4">
                <div class="card-stat-mini">
                    <span>Total Tasks</span>
                    <h4><%= total %></h4>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card-stat-mini">
                    <span>Pending Tasks</span>
                    <h4 class="text-warning"><%= pending %></h4>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card-stat-mini">
                    <span>Completed Tasks</span>
                    <h4 class="text-success"><%= completed %></h4>
                </div>
            </div>
        </div>

        <!-- WORKSPACE GRID -->
        <div class="row g-4">
            
            <!-- LEFT PANEL: LIST OF TASKS -->
            <div class="col-md-6">
                <div class="card-box">
                    <h5>Task Directory</h5>
                    
                    <div class="task-list-container">
                        <%
                        try(Connection con = DBConnection.getConnection()){
                            PreparedStatement ps = con.prepareStatement(
                                "SELECT * FROM tasks WHERE user_id=? ORDER BY id DESC"
                            );
                            ps.setInt(1, userId);
                            ResultSet rs = ps.executeQuery();
                            boolean hasTasks = false;

                            while(rs.next()){
                                hasTasks = true;
                                int taskId = rs.getInt("id");
                                String titleStr = rs.getString("title");
                                String descStr = rs.getString("description");
                                if(descStr == null) descStr = "";
                                Date deadlineDate = rs.getDate("deadline");
                                String deadlineStr = (deadlineDate != null) ? deadlineDate.toString() : "No deadline";
                                String status = rs.getString("status");

                                String titleEscaped = titleStr.replace("\"", "&quot;").replace("<", "&lt;").replace(">", "&gt;");
                                String descEscaped = descStr.replace("\"", "&quot;").replace("<", "&lt;").replace(">", "&gt;").replace("\n", "&#10;").replace("\r", "");
                        %>
                                <div class="task-item <%= status.toLowerCase() %>" id="task-<%= taskId %>"
                                     data-id="<%= taskId %>"
                                     data-title="<%= titleEscaped %>"
                                     data-description="<%= descEscaped %>"
                                     data-deadline="<%= deadlineStr %>"
                                     data-status="<%= status %>"
                                     onclick="selectTaskElement(this)">
                                    <div>
                                        <span class="task-title"><%= titleStr %></span>
                                        <span class="task-date"><i class="bi bi-calendar-event"></i> <%= deadlineStr %></span>
                                    </div>
                                    <span class="badge-status <%= "COMPLETED".equals(status) ? "badge-completed" : "badge-pending" %>">
                                        <%= status %>
                                    </span>
                                </div>
                        <%
                            }
                            if(!hasTasks) {
                        %>
                                <div class="empty-state">
                                    <i class="bi bi-journal-x"></i>
                                    No tasks available. Go back to Dashboard to create one!
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

            <!-- RIGHT PANEL: TASK DETAIL -->
            <div class="col-md-6">
                <div class="details-panel" id="detailsPanel">
                    <i class="bi bi-blockquote-left" style="font-size:40px; margin-bottom:15px;"></i>
                    <h5>No Task Selected</h5>
                    <p class="mb-0">Select a task from the directory list on the left to see details and perform actions.</p>
                </div>
            </div>

        </div>

    </div>

    <!-- SELECTION JAVASCRIPT -->
    <script>
        function selectTaskElement(element) {
            const id = element.getAttribute('data-id');
            const title = element.getAttribute('data-title');
            const description = element.getAttribute('data-description');
            const deadline = element.getAttribute('data-deadline');
            const status = element.getAttribute('data-status');
            selectTask(id, title, description, deadline, status);
        }

        function selectTask(id, title, description, deadline, status) {
            // Remove active class from all items
            const items = document.querySelectorAll('.task-item');
            items.forEach(item => item.classList.remove('active-task'));

            // Add active class to selected item
            const selectedItem = document.getElementById('task-' + id);
            if(selectedItem) {
                selectedItem.classList.add('active-task');
            }

            // Populate details panel
            const panel = document.getElementById('detailsPanel');
            panel.classList.add('has-data');

            // Format deadline display
            let deadlineHtml = '<i class="bi bi-calendar-check"></i> <b>Due Date:</b> ' + deadline;

            // Actions html
            let actionsHtml = '';
            if(status === 'PENDING') {
                actionsHtml += 
                    '<a href="complete?id=' + id + '" class="btn-custom btn-complete">' +
                    '    <i class="bi bi-check2-circle"></i> Mark Complete' +
                    '</a>';
            }
            actionsHtml += 
                '<a href="delete?id=' + id + '" class="btn-custom btn-delete">' +
                '    <i class="bi bi-trash3"></i> Delete Task' +
                '</a>';

            panel.innerHTML = 
                '<div class="details-header">' +
                '    <h4>' + title + '</h4>' +
                '    <span class="badge-status ' + (status === 'COMPLETED' ? 'badge-completed' : 'badge-pending') + '">' + status + '</span>' +
                '</div>' +
                '<div class="details-body">' +
                '    <div class="mb-3 text-muted small">' +
                '        ' + deadlineHtml +
                '    </div>' +
                '    <h6 class="text-uppercase text-muted small fw-bold mb-2">Description</h6>' +
                '    <p style="white-space: pre-line;">' + (description || '<i>No description provided for this task.</i>') + '</p>' +
                '</div>' +
                '<div class="details-footer">' +
                '    ' + actionsHtml +
                '</div>';
        }
    </script>

</body>
</html>