import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;
import java.sql.*;
public class TaskAPI extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
    throws IOException {

        res.setContentType("application/json");

        PrintWriter out = res.getWriter();

        try{
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/task_manager",
                "root","root"
            );

            ResultSet rs = con.createStatement()
                .executeQuery("SELECT * FROM tasks");

            out.print("[");

            while(rs.next()){
                out.print("{\"title\":\""+rs.getString("title")+"\"},");
            }

            out.print("]");

        }catch(Exception e){
            out.print("error");
        }
    }
}