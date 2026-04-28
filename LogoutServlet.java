import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;


public class LogoutServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
    throws IOException {

        HttpSession session = req.getSession();
        session.invalidate();

        res.sendRedirect("login.jsp");
    }
}