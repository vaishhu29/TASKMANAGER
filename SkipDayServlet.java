import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;
import util.DBConnection;

public class SkipDayServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String date = request.getParameter("skipDate");

        HttpSession session = request.getSession();
        int userId = (int) session.getAttribute("userId");

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                "INSERT INTO skip_days(skip_date, user_id) VALUES (?, ?)"
             )) {

            ps.setString(1, date);
            ps.setInt(2, userId);

            ps.executeUpdate();

        } catch(Exception e){
            e.printStackTrace();
        }

        response.sendRedirect("dashboard.jsp");
    }
}