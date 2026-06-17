<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
request.setAttribute("activePage", "settings");
String name = (String)session.getAttribute("name");
String email = (String)session.getAttribute("email");
Integer userId = (Integer)session.getAttribute("userId");

if(userId == null){
    response.sendRedirect("login.jsp");
    return;
}

String firstname = "";
String lastname = "";
String emailDb = "";

try(Connection con = DBConnection.getConnection()){
    PreparedStatement ps = con.prepareStatement("SELECT firstname, lastname, email FROM users WHERE id=?");
    ps.setInt(1, userId);
    ResultSet rs = ps.executeQuery();
    if(rs.next()){
        firstname = rs.getString("firstname");
        lastname = rs.getString("lastname");
        emailDb = rs.getString("email");
    }
    rs.close(); ps.close();
} catch(Exception e){
    e.printStackTrace();
}

String success = request.getParameter("success");
String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html>
<head>
    <title>TaskFlow - Settings</title>
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
            max-width: 700px;
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

        .profile-setup {
            display: flex;
            align-items: center;
            gap: 24px;
            margin-bottom: 30px;
            padding-bottom: 25px;
            border-bottom: 1px solid #f1f5f9;
        }

        .avatar-holder {
            position: relative;
        }

        .avatar-preview {
            width: 90px;
            height: 90px;
            border-radius: 50%;
            background: linear-gradient(135deg, #6366f1, #a855f7);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 40px;
            color: white;
            overflow: hidden;
            box-shadow: 0 8px 20px rgba(99, 102, 241, 0.2);
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .avatar-preview:hover {
            transform: scale(1.05);
        }

        .avatar-preview img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .avatar-edit-badge {
            position: absolute;
            bottom: 0;
            right: 0;
            background: #6366f1;
            color: white;
            width: 28px;
            height: 28px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 13px;
            border: 2px solid white;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
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

        .alert {
            border-radius: 12px;
            border: none;
            padding: 15px;
            font-size: 14px;
            margin-bottom: 24px;
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
            max-width: 440px;
            border-radius: 24px;
            padding: 30px;
            box-shadow: 0 20px 50px rgba(15, 23, 42, 0.15);
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

        .avatar-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 12px;
            margin-top: 15px;
        }

        .avatar-btn {
            border: 1px solid #f1f5f9;
            background: #f8fafc;
            font-size: 28px;
            height: 64px;
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s ease;
        }

        .avatar-btn:hover {
            background: #eff6ff;
            border-color: #bfdbfe;
            transform: scale(1.05);
        }

        .upload-area {
            border: 2px dashed #cbd5e1;
            border-radius: 16px;
            padding: 20px;
            text-align: center;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .upload-area:hover {
            border-color: #6366f1;
            background: rgba(99, 102, 241, 0.02);
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
            <h3>Account Settings</h3>
            <p>Update your personal information and customize your profile appearance.</p>
        </div>

        <!-- ALERTS -->
        <% if("updated".equals(success)){ %>
            <div class="alert alert-success d-flex align-items-center gap-2">
                <i class="bi bi-check-circle-fill"></i> Profile details updated successfully!
            </div>
        <% } %>

        <% if("empty".equals(error)){ %>
            <div class="alert alert-warning d-flex align-items-center gap-2">
                <i class="bi bi-exclamation-triangle-fill"></i> Please fill in all required fields.
            </div>
        <% } %>

        <% if("db".equals(error)){ %>
            <div class="alert alert-danger d-flex align-items-center gap-2">
                <i class="bi bi-x-circle-fill"></i> Database error occurred. Try again later.
            </div>
        <% } %>

        <!-- SETTINGS CONTAINER -->
        <div class="card-box">
            <h5><i class="bi bi-person-fill text-primary"></i> Profile Information</h5>

            <!-- AVATAR SETTINGS -->
            <div class="profile-setup">
                <div class="avatar-holder" onclick="openModal()">
                    <div class="avatar-preview">
                        <span id="pageProfileIcon">👤</span>
                        <img id="pageProfilePreview" style="display:none;">
                    </div>
                    <div class="avatar-edit-badge">
                        <i class="bi bi-camera-fill"></i>
                    </div>
                </div>
                <div>
                    <h6 class="fw-bold mb-1"><%= firstname %> <%= lastname %></h6>
                    <p class="text-muted small mb-0">Click the avatar to upload an image or choose an emoji.</p>
                </div>
            </div>

            <!-- FORM -->
            <form action="updateProfile" method="post">
                <div class="row g-3 mb-4">
                    <div class="col-md-6">
                        <label class="form-label text-muted small fw-bold">FIRST NAME</label>
                        <input type="text" name="firstname" class="form-control" value="<%= firstname %>" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label text-muted small fw-bold">LAST NAME</label>
                        <input type="text" name="lastname" class="form-control" value="<%= lastname %>" required>
                    </div>
                    <div class="col-md-12">
                        <label class="form-label text-muted small fw-bold">EMAIL ADDRESS</label>
                        <input type="email" name="email" class="form-control" value="<%= emailDb %>" required>
                    </div>
                </div>
                
                <button type="submit" class="btn btn-primary">Save Changes</button>
            </form>
        </div>

    </div>

    <!-- AVATAR SELECTION MODAL -->
    <div id="avatarModal" class="modal-overlay">
        <div class="modal-box">
            <div class="modal-header">
                <h5>Customize Avatar</h5>
                <button class="modal-close" onclick="closeModal()">✖</button>
            </div>
            
            <!-- Custom Image Upload -->
            <div class="upload-area mb-4" onclick="document.getElementById('fileUpload').click()">
                <i class="bi bi-cloud-arrow-up-fill text-primary" style="font-size:32px;"></i>
                <h6 class="mt-2 mb-1 fw-bold">Upload Custom Image</h6>
                <p class="text-muted small mb-0">PNG or JPG up to 1MB</p>
                <input type="file" id="fileUpload" style="display:none;" accept="image/*">
            </div>

            <h6 class="text-uppercase text-muted small fw-bold mb-3">Or choose an avatar emoji</h6>
            <div class="avatar-grid">
                <button class="avatar-btn btn" onclick="setAvatar('😀')">😀</button>
                <button class="avatar-btn btn" onclick="setAvatar('😎')">😎</button>
                <button class="avatar-btn btn" onclick="setAvatar('👩‍💻')">👩‍💻</button>
                <button class="avatar-btn btn" onclick="setAvatar('👨‍💻')">👨‍💻</button>
                <button class="avatar-btn btn" onclick="setAvatar('🦁')">🦁</button>
                <button class="avatar-btn btn" onclick="setAvatar('🚀')">🚀</button>
                <button class="avatar-btn btn" onclick="setAvatar('⚡')">⚡</button>
                <button class="avatar-btn btn" onclick="setAvatar('🎯')">🎯</button>
            </div>

            <button onclick="removeAvatar()" class="btn btn-light text-danger w-100 mt-4 py-2" style="border-radius:12px; font-weight:600;">
                <i class="bi bi-trash"></i> Remove Avatar
            </button>
        </div>
    </div>

    <!-- SCRIPTS -->
    <script>
        function openModal() {
            document.getElementById('avatarModal').style.display = 'flex';
        }
        function closeModal() {
            document.getElementById('avatarModal').style.display = 'none';
        }

        // Close on overlay click
        window.onclick = function(e) {
            if(e.target.classList.contains('modal-overlay')) {
                closeModal();
            }
        }

        // Load Avatar
        function loadAvatar() {
            let saved = localStorage.getItem("profileImage");
            let img = document.getElementById("pageProfilePreview");
            let icon = document.getElementById("pageProfileIcon");

            if (img && icon) {
                if (saved) {
                    if (saved.startsWith("data:image")) {
                        img.src = saved;
                        img.style.display = "block";
                        icon.style.display = "none";
                    } else {
                        icon.innerText = saved;
                        icon.style.display = "block";
                        img.style.display = "none";
                    }
                } else {
                    icon.innerText = "👤";
                    icon.style.display = "block";
                    img.style.display = "none";
                }
            }
        }

        // Set Emoji Avatar
        function setAvatar(emoji) {
            localStorage.setItem("profileImage", emoji);
            loadAvatar();
            // Fire storage event manually for sidebar on same page
            window.dispatchEvent(new Event('storage'));
            closeModal();
        }

        // Handle Image Upload
        document.getElementById('fileUpload').addEventListener('change', function(e) {
            let file = e.target.files[0];
            if (!file) return;

            let reader = new FileReader();
            reader.onload = function() {
                let data = reader.result;
                localStorage.setItem("profileImage", data);
                loadAvatar();
                window.dispatchEvent(new Event('storage'));
                closeModal();
            };
            reader.readAsDataURL(file);
        });

        // Remove Avatar
        function removeAvatar() {
            localStorage.removeItem("profileImage");
            loadAvatar();
            window.dispatchEvent(new Event('storage'));
            closeModal();
        }

        // Load immediately
        loadAvatar();
    </script>
</body>
</html>