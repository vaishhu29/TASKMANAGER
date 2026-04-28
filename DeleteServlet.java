import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;
import util.DBConnection;


public class DeleteServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {

        HttpSession s = req.getSession(false);
        if (s == null) { res.sendRedirect("login.jsp"); return; }

        int uid = (int) s.getAttribute("userId");
        int id = Integer.parseInt(req.getParameter("id"));

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "DELETE FROM tasks WHERE id=? AND user_id=?")) {

            ps.setInt(1, id);
            ps.setInt(2, uid);
            ps.executeUpdate();

        } catch (Exception e) { e.printStackTrace(); }

        res.sendRedirect("dashboard.jsp");
    }
}