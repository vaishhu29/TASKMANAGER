import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;
import util.DBConnection;

public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        String firstname = req.getParameter("firstname");
        String lastname  = req.getParameter("lastname");
        String username  = req.getParameter("username");
        String email     = req.getParameter("email");
        String password  = req.getParameter("password");
        String confirm   = req.getParameter("confirm");

        //  Basic validation
        if (username == null || password == null || confirm == null ||
            username.isEmpty() || password.isEmpty()) {

            res.getWriter().println("All fields are required");
            return;
        }

        // Password match check
        if (!password.equals(confirm)) {
            res.getWriter().println("Passwords do not match");
            return;
        }

        try (Connection con = DBConnection.getConnection()) {

            // Check if user already exists
            PreparedStatement check = con.prepareStatement(
                "SELECT * FROM users WHERE username=?"
            );
            check.setString(1, username);
            ResultSet rs = check.executeQuery();

            if (rs.next()) {
                res.getWriter().println("Username already exists");
                return;
            }

            // ✅ Insert user
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO users(firstname, lastname, username, email, password) VALUES (?,?,?,?,?)"
            );

            ps.setString(1, firstname);
            ps.setString(2, lastname);
            ps.setString(3, username);
            ps.setString(4, email);
            ps.setString(5, HashUtil.hashPassword(password));

            ps.executeUpdate();

            res.sendRedirect("login.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            res.getWriter().println("Registration failed");
        }
    }
}