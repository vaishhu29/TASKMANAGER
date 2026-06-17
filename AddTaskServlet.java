import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;
import util.DBConnection;

public class AddTaskServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        String title = req.getParameter("title");
        String description = req.getParameter("description");
        String deadline = req.getParameter("deadline");

        // 🔒 Validation
        if (title == null || title.trim().isEmpty()) {
            res.sendRedirect("dashboard.jsp?error=empty");
            return;
        }

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                "INSERT INTO tasks(title, description, deadline, status, user_id) VALUES (?, ?, ?, 'PENDING', ?)")) {

            ps.setString(1, title);
            ps.setString(2, description);

            // Safe date handling
            if (deadline != null && !deadline.isEmpty()) {
                ps.setDate(3, Date.valueOf(deadline));
            } else {
                ps.setNull(3, java.sql.Types.DATE);
            }

            ps.setInt(4, userId);

            int rows = ps.executeUpdate();
            System.out.println("✔ Task added: " + rows);

        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect("dashboard.jsp?error=db");
            return;
        }

        res.sendRedirect("dashboard.jsp?success=added");
    }
}