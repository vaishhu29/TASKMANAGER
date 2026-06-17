import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;
import util.DBConnection;

public class DeleteCategoryServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        int id = Integer.parseInt(req.getParameter("id"));
        String type = req.getParameter("type");

        try(Connection con = DBConnection.getConnection()){

            String sql = "status".equals(type) ?
                "DELETE FROM task_status WHERE id=?" :
                "DELETE FROM task_priority WHERE id=?";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            ps.executeUpdate();

        }catch(Exception e){
            e.printStackTrace();
        }

        res.sendRedirect("categories.jsp");
    }
}