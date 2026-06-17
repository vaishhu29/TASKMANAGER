<%@ page contentType="text/html;charset=UTF-8" %>
<%
request.setAttribute("activePage", "categories");
String id = String.valueOf(request.getAttribute("id"));
String type = (String)request.getAttribute("type");
String name = (String)request.getAttribute("name");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Category</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background: #f8fafc;
            margin: 0;
        }
        .content {
            margin-left: 280px;
            padding: 40px;
        }
        .card-box {
            background: white;
            padding: 30px;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.03);
            max-width: 500px;
            margin: auto;
            border: 1px solid rgba(0,0,0,0.03);
        }
        .form-control {
            border-radius: 12px;
            padding: 12px;
            border: 1px solid #e2e8f0;
            font-size: 15px;
        }
        .form-control:focus {
            box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.1);
            border-color: #6366f1;
        }
        .btn-primary {
            background: linear-gradient(135deg, #6366f1, #4f46e5);
            border: none;
            border-radius: 12px;
            padding: 12px;
            font-weight: 600;
        }
        .btn-primary:hover {
            background: linear-gradient(135deg, #4f46e5, #4338ca);
        }
        .btn-light {
            border-radius: 12px;
            padding: 12px;
            font-weight: 500;
        }
    </style>
</head>
<body>

    <jsp:include page="sidebar.jsp" />

    <div class="content">
        <div class="card-box mt-5">
            <h4 class="mb-4">Edit <%= type != null ? type.toUpperCase() : "Category" %></h4>
            
            <form action="editCategory" method="post">
                <input type="hidden" name="id" value="<%= id %>">
                <input type="hidden" name="type" value="<%= type %>">
                
                <div class="mb-4">
                    <label class="form-label text-muted small fw-bold">CATEGORY NAME</label>
                    <input type="text" name="name" class="form-control" value="<%= name %>" required placeholder="Enter name">
                </div>
                
                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-primary w-100">Save Changes</button>
                    <a href="categories.jsp" class="btn btn-light w-100">Cancel</a>
                </div>
            </form>
        </div>
    </div>

</body>
</html>
