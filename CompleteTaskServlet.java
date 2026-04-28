import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;
import util.DBConnection;

public class CompleteTaskServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        String idParam = req.getParameter("id");

        if (idParam == null) {
            res.sendRedirect("dashboard.jsp");
            return;
        }

        int taskId;

        try {
            taskId = Integer.parseInt(idParam);
        } catch (NumberFormatException e) {
            res.sendRedirect("dashboard.jsp?error=invalidId");
            return;
        }

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     "UPDATE tasks SET status='COMPLETED' WHERE id=? AND user_id=?")) {

            ps.setInt(1, taskId);
            ps.setInt(2, userId);

            int rows = ps.executeUpdate();

            if (rows > 0) {
                System.out.println("✔ Task completed: " + taskId);
            } else {
                System.out.println("⚠ No task updated (invalid id or unauthorized)");
            }

        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect("dashboard.jsp?error=db");
            return;
        }

        res.sendRedirect("dashboard.jsp?success=completed");
    }
}