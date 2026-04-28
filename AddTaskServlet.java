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
        String deadline = req.getParameter("deadline");
        String statusId = req.getParameter("status_id");
        String priorityId = req.getParameter("priority_id");

        // 🔒 Validation
        if (title == null || title.trim().isEmpty()
            || statusId == null || priorityId == null) {

            res.sendRedirect("dashboard.jsp?error=empty");
            return;
        }

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                "INSERT INTO tasks(title, deadline, status_id, priority_id, user_id) VALUES (?, ?, ?, ?, ?)")) {

            ps.setString(1, title);

            // Safe date handling
            if (deadline != null && !deadline.isEmpty()) {
                ps.setDate(2, Date.valueOf(deadline));
            } else {
                ps.setNull(2, java.sql.Types.DATE);
            }

            ps.setInt(3, Integer.parseInt(statusId));
            ps.setInt(4, Integer.parseInt(priorityId));
            ps.setInt(5, userId);

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