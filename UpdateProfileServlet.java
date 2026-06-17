import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;
import util.DBConnection;

public class UpdateProfileServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        String firstname = req.getParameter("firstname");
        String lastname = req.getParameter("lastname");
        String email = req.getParameter("email");

        if (firstname == null || firstname.trim().isEmpty() ||
            lastname == null || lastname.trim().isEmpty() ||
            email == null || email.trim().isEmpty()) {
            res.sendRedirect("settings.jsp?error=empty");
            return;
        }

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                "UPDATE users SET firstname=?, lastname=?, email=? WHERE id=?")) {

            ps.setString(1, firstname);
            ps.setString(2, lastname);
            ps.setString(3, email);
            ps.setInt(4, userId);

            int rows = ps.executeUpdate();

            if (rows > 0) {
                // Update session variables
                session.setAttribute("name", firstname);
                session.setAttribute("email", email);
                res.sendRedirect("settings.jsp?success=updated");
            } else {
                res.sendRedirect("settings.jsp?error=notfound");
            }

        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect("settings.jsp?error=db");
        }
    }
}
