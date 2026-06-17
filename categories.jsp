<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
request.setAttribute("activePage", "categories");
String name = (String)session.getAttribute("name");
Integer userId = (Integer)session.getAttribute("userId");

if(userId == null){
    response.sendRedirect("login.jsp");
    return;
}

String success = request.getParameter("success");
String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html>
<head>
    <title>TaskFlow - Categories</title>
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

        .form-control, .form-select {
            border-radius: 12px;
            padding: 12px;
            border: 1px solid #e2e8f0;
            font-size: 14px;
        }

        .form-control:focus, .form-select:focus {
            box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.1);
            border-color: #6366f1;
        }

        .btn-primary {
            background: linear-gradient(135deg, #6366f1, #4f46e5);
            border: none;
            border-radius: 12px;
            padding: 12px 24px;
            font-weight: 600;
            font-size: 14px;
            box-shadow: 0 4px 14px rgba(99, 102, 241, 0.2);
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #4f46e5, #4338ca);
        }

        .table {
            margin: 0;
        }

        .table th {
            font-weight: 600;
            color: #64748b;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border-bottom: 2px solid #f1f5f9;
            padding: 15px 10px;
        }

        .table td {
            padding: 15px 10px;
            vertical-align: middle;
            color: #334155;
            font-size: 14px;
            border-bottom: 1px solid #f1f5f9;
        }

        .badge-status {
            background: #e0f2fe;
            color: #0369a1;
            padding: 4px 10px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 12px;
        }

        .badge-priority {
            background: #fef3c7;
            color: #b45309;
            padding: 4px 10px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 12px;
        }

        .btn-sm {
            padding: 6px 12px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 12px;
        }

        .alert {
            border-radius: 12px;
            border: none;
            padding: 15px;
            font-size: 14px;
            margin-bottom: 24px;
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
            <h3>Task Categories</h3>
            <p>Customize and manage statuses and priority levels for your tasks.</p>
        </div>

        <!-- ALERTS -->
        <% if("1".equals(success)){ %>
            <div class="alert alert-success d-flex align-items-center gap-2">
                <i class="bi bi-check-circle-fill"></i> Category added successfully!
            </div>
        <% } %>

        <% if("exists".equals(error)){ %>
            <div class="alert alert-warning d-flex align-items-center gap-2">
                <i class="bi bi-exclamation-triangle-fill"></i> Category already exists.
            </div>
        <% } %>

        <% if("invalid".equals(error)){ %>
            <div class="alert alert-danger d-flex align-items-center gap-2">
                <i class="bi bi-x-circle-fill"></i> Invalid inputs. Please try again.
            </div>
        <% } %>

        <!-- ADD CATEGORY FORM -->
        <div class="card-box">
            <h5><i class="bi bi-plus-circle text-primary"></i> Add New Category</h5>
            
            <form action="addCategory" method="post" class="row g-3 align-items-end">
                <div class="col-md-3">
                    <label class="form-label text-muted small fw-bold">CATEGORY TYPE</label>
                    <select name="type" class="form-select" required>
                        <option value="status">Status</option>
                        <option value="priority">Priority</option>
                    </select>
                </div>
                <div class="col-md-6">
                    <label class="form-label text-muted small fw-bold">CATEGORY NAME</label>
                    <input type="text" name="name" class="form-control" placeholder="e.g. In Progress, High Priority" required>
                </div>
                <div class="col-md-3">
                    <button type="submit" class="btn btn-primary w-100">Create Category</button>
                </div>
            </form>
        </div>

        <div class="row">
            
            <!-- STATUS LIST -->
            <div class="col-md-6">
                <div class="card-box">
                    <h5><i class="bi bi-flag text-info"></i> Task Statuses</h5>
                    
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Name</th>
                                    <th class="text-end">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                try(Connection con = DBConnection.getConnection()){
                                    PreparedStatement ps = con.prepareStatement("SELECT * FROM task_status");
                                    ResultSet rs = ps.executeQuery();
                                    boolean hasStatus = false;

                                    while(rs.next()){
                                        hasStatus = true;
                                        int idVal = rs.getInt("id");
                                        String nameStr = rs.getString("name");
                                %>
                                        <tr>
                                            <td><%= idVal %></td>
                                            <td><span class="badge-status"><%= nameStr %></span></td>
                                            <td class="text-end">
                                                <a href="editCategory?id=<%= idVal %>&type=status" class="btn btn-light btn-sm text-warning me-1">
                                                    <i class="bi bi-pencil"></i> Edit
                                                </a>
                                                <a href="deleteCategory?id=<%= idVal %>&type=status" class="btn btn-light btn-sm text-danger" onclick="return confirm('Are you sure you want to delete this status?')">
                                                    <i class="bi bi-trash"></i> Delete
                                                </a>
                                            </td>
                                        </tr>
                                <%
                                    }
                                    if(!hasStatus) {
                                %>
                                        <tr>
                                            <td colspan="3" class="text-center py-4 text-muted">No custom statuses added yet.</td>
                                        </tr>
                                <%
                                    }
                                    rs.close(); ps.close();
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- PRIORITY LIST -->
            <div class="col-md-6">
                <div class="card-box">
                    <h5><i class="bi bi-lightning text-warning"></i> Task Priorities</h5>
                    
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Name</th>
                                    <th class="text-end">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    PreparedStatement ps2 = con.prepareStatement("SELECT * FROM task_priority");
                                    ResultSet rs2 = ps2.executeQuery();
                                    boolean hasPriority = false;

                                    while(rs2.next()){
                                        hasPriority = true;
                                        int idVal = rs2.getInt("id");
                                        String nameStr = rs2.getString("name");
                                %>
                                        <tr>
                                            <td><%= idVal %></td>
                                            <td><span class="badge-priority"><%= nameStr %></span></td>
                                            <td class="text-end">
                                                <a href="editCategory?id=<%= idVal %>&type=priority" class="btn btn-light btn-sm text-warning me-1">
                                                    <i class="bi bi-pencil"></i> Edit
                                                </a>
                                                <a href="deleteCategory?id=<%= idVal %>&type=priority" class="btn btn-light btn-sm text-danger" onclick="return confirm('Are you sure you want to delete this priority level?')">
                                                    <i class="bi bi-trash"></i> Delete
                                                </a>
                                            </td>
                                        </tr>
                                <%
                                    }
                                    if(!hasPriority) {
                                %>
                                        <tr>
                                            <td colspan="3" class="text-center py-4 text-muted">No custom priorities added yet.</td>
                                        </tr>
                                <%
                                    }
                                    rs2.close(); ps2.close();
                                } catch(Exception e) {
                                    out.println("<tr><td colspan='3' class='text-danger'>Database Error.</td></tr>");
                                }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

        </div>

    </div>

</body>
</html>