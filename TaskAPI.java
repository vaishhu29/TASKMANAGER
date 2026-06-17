import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;
import util.DBConnection;

public class TaskAPI extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        res.setContentType("application/json");
        PrintWriter out = res.getWriter();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT * FROM tasks");
             ResultSet rs = ps.executeQuery()) {

            StringBuilder json = new StringBuilder();
            json.append("[");
            boolean first = true;

            while (rs.next()) {
                if (!first) {
                    json.append(",");
                }
                json.append("{\"title\":\"").append(rs.getString("title")).append("\"}");
                first = false;
            }
            json.append("]");

            out.print(json.toString());

        } catch (Exception e) {
            out.print("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }
}