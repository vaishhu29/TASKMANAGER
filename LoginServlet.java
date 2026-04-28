import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;
import util.DBConnection;

public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        //  Basic validation
        if (username == null || password == null ||
            username.isEmpty() || password.isEmpty()) {

            res.sendRedirect("login.jsp?error=empty");
            return;
        }

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                 "SELECT * FROM users WHERE username=? AND password=?")) {

            ps.setString(1, username);
            ps.setString(2, HashUtil.hashPassword(password));

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                HttpSession session = req.getSession();

session.setAttribute("username", rs.getString("username")); // login name
session.setAttribute("name", rs.getString("firstname"));    // display name
session.setAttribute("email", rs.getString("email"));
session.setAttribute("userId", rs.getInt("id"));
                res.sendRedirect("dashboard.jsp");

            } else {
                //  Redirect with error (clean UI handling)
                res.sendRedirect("login.jsp?error=invalid");
            }

        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect("login.jsp?error=server");
        }
    }
}