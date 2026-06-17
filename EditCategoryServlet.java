import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;
import util.DBConnection;

public class EditCategoryServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        String idParam = req.getParameter("id");
        String type = req.getParameter("type");

        if (idParam == null || type == null) {
            res.sendRedirect("categories.jsp");
            return;
        }

        int id = Integer.parseInt(idParam);
        String name = "";

        try (Connection con = DBConnection.getConnection()) {
            String sql = "status".equals(type) ?
                "SELECT name FROM task_status WHERE id=?" :
                "SELECT name FROM task_priority WHERE id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                name = rs.getString("name");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        req.setAttribute("id", id);
        req.setAttribute("type", type);
        req.setAttribute("name", name);
        req.getRequestDispatcher("editCategory.jsp").forward(req, res);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        int id = Integer.parseInt(req.getParameter("id"));
        String name = req.getParameter("name");
        String type = req.getParameter("type");

        try(Connection con = DBConnection.getConnection()){

            String sql = "status".equals(type) ?
                "UPDATE task_status SET name=? WHERE id=?" :
                "UPDATE task_priority SET name=? WHERE id=?";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, name);
            ps.setInt(2, id);

            ps.executeUpdate();

        }catch(Exception e){
            e.printStackTrace();
        }

        res.sendRedirect("categories.jsp");
    }
}