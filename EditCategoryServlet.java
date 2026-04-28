import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;
import util.DBConnection;

public class EditCategoryServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        int id = Integer.parseInt(req.getParameter("id"));
        String name = req.getParameter("name");
        String type = req.getParameter("type");

        try(Connection con = DBConnection.getConnection()){

            String sql = type.equals("status") ?
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