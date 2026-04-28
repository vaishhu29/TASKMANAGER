import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;
import util.DBConnection;

public class AddCategoryServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        String type = req.getParameter("type"); // status / priority
        String name = req.getParameter("name");

        try(Connection con = DBConnection.getConnection()){

            String sql = type.equals("status") ?
                "INSERT INTO task_status(name) VALUES(?)" :
                "INSERT INTO task_priority(name) VALUES(?)";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, name);
            ps.executeUpdate();

        }catch(Exception e){
            e.printStackTrace();
        }

        res.sendRedirect("categories.jsp");
    }
}