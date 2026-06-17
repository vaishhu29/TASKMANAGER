<%
Integer userId = (Integer)session.getAttribute("userId");
if(userId != null){
    response.sendRedirect("dashboard.jsp");
} else {
    response.sendRedirect("login.jsp");
}
%>