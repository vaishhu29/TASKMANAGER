<%@ page contentType="text/html;charset=UTF-8" %>
<%
String sidebarName = (String)session.getAttribute("name");
Integer sidebarUserId = (Integer)session.getAttribute("userId");
if(sidebarUserId == null){
    response.sendRedirect("login.jsp");
    return;
}
String activePage = (String)request.getAttribute("activePage");
%>
<!-- Google Fonts & Bootstrap Icons -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">

<style>
:root {
    --sb-bg: #0f172a;
    --sb-hover: #1e293b;
    --sb-active: #6366f1;
    --sb-text: #94a3b8;
    --sb-text-active: #ffffff;
}

.sidebar {
    width: 260px;
    height: 100vh;
    position: fixed;
    top: 0;
    left: 0;
    background: linear-gradient(185deg, #0f172a 0%, #1e293b 100%);
    color: white;
    padding: 24px 20px;
    display: flex;
    flex-direction: column;
    z-index: 1000;
    box-shadow: 4px 0 24px rgba(0,0,0,0.15);
}

.sidebar-brand {
    font-size: 20px;
    font-weight: 700;
    letter-spacing: -0.5px;
    background: linear-gradient(90deg, #818cf8, #c084fc);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    margin-bottom: 30px;
    display: flex;
    align-items: center;
    gap: 10px;
}

.sidebar-brand i {
    font-size: 24px;
    background: linear-gradient(90deg, #818cf8, #c084fc);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
}

.profile-section {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 12px;
    background: rgba(255,255,255,0.03);
    border-radius: 12px;
    border: 1px solid rgba(255,255,255,0.05);
    margin-bottom: 24px;
    text-decoration: none;
    color: inherit;
    transition: all 0.3s ease;
}

.profile-section:hover {
    background: rgba(255,255,255,0.08);
    border-color: rgba(255,255,255,0.1);
    color: white;
}

.sb-profile-img {
    width: 48px;
    height: 48px;
    border-radius: 50%;
    background: linear-gradient(135deg, #6366f1, #a855f7);
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 22px;
    overflow: hidden;
    color: white;
    box-shadow: 0 4px 12px rgba(99,102,241,0.3);
}

.sb-profile-img img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.profile-info {
    display: flex;
    flex-direction: column;
    overflow: hidden;
}

.profile-info .sb-name {
    font-size: 14px;
    font-weight: 600;
    color: #f8fafc;
    white-space: nowrap;
    text-overflow: ellipsis;
    overflow: hidden;
}

.profile-info .sb-role {
    font-size: 11px;
    color: #64748b;
}

.sidebar-menu {
    display: flex;
    flex-direction: column;
    gap: 6px;
    flex-grow: 1;
}

.sidebar-menu a {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 12px 16px;
    color: var(--sb-text);
    text-decoration: none;
    border-radius: 10px;
    font-size: 14px;
    font-weight: 500;
    transition: all 0.2s ease;
}

.sidebar-menu a i {
    font-size: 18px;
}

.sidebar-menu a:hover {
    background: var(--sb-hover);
    color: #f8fafc;
    transform: translateX(4px);
}

.sidebar-menu a.active {
    background: var(--sb-active);
    color: var(--sb-text-active);
    font-weight: 600;
    box-shadow: 0 4px 14px rgba(99, 102, 241, 0.4);
}

.sidebar-menu a.active:hover {
    transform: none;
}

.sidebar-footer {
    margin-top: auto;
}

.sidebar-footer a {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 12px 16px;
    color: #ef4444;
    text-decoration: none;
    border-radius: 10px;
    font-size: 14px;
    font-weight: 500;
    transition: all 0.2s ease;
}

.sidebar-footer a:hover {
    background: rgba(239, 68, 68, 0.1);
    transform: translateX(4px);
}
</style>

<div class="sidebar">
    <div class="sidebar-brand">
        <i class="bi bi-check2-square"></i>
        <span>TaskFlow</span>
    </div>

    <a href="settings.jsp" class="profile-section">
        <div class="sb-profile-img">
            <span id="sbProfileIcon">👤</span>
            <img id="sbProfilePreview" style="display:none;">
        </div>
        <div class="profile-info">
            <span class="sb-name"><%= (sidebarName != null) ? sidebarName : "User" %></span>
            <span class="sb-role">Developer</span>
        </div>
    </a>

    <div class="sidebar-menu">
        <a href="dashboard.jsp" class="<%= "dashboard".equals(activePage) ? "active" : "" %>">
            <i class="bi bi-grid-1x2-fill"></i>
            <span>Dashboard</span>
        </a>
        <a href="mytasks.jsp" class="<%= "mytasks".equals(activePage) ? "active" : "" %>">
            <i class="bi bi-list-task"></i>
            <span>My Tasks</span>
        </a>
        <a href="categories.jsp" class="<%= "categories".equals(activePage) ? "active" : "" %>">
            <i class="bi bi-tags-fill"></i>
            <span>Categories</span>
        </a>
        <a href="settings.jsp" class="<%= "settings".equals(activePage) ? "active" : "" %>">
            <i class="bi bi-gear-fill"></i>
            <span>Settings</span>
        </a>
        <a href="help.jsp" class="<%= "help".equals(activePage) ? "active" : "" %>">
            <i class="bi bi-question-circle-fill"></i>
            <span>Help & Support</span>
        </a>
    </div>

    <div class="sidebar-footer">
        <a href="logout">
            <i class="bi bi-box-arrow-left"></i>
            <span>Sign Out</span>
        </a>
    </div>
</div>

<script>
(function() {
    function loadSidebarAvatar() {
        let saved = localStorage.getItem("profileImage");
        let img = document.getElementById("sbProfilePreview");
        let icon = document.getElementById("sbProfileIcon");
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
    loadSidebarAvatar();
    window.addEventListener("load", loadSidebarAvatar);
    window.addEventListener("storage", function(e) {
        if (e.key === "profileImage") {
            loadSidebarAvatar();
        }
    });
})();
</script>