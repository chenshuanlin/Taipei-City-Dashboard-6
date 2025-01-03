import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import java.nio.file.*;
import java.util.*;

@WebServlet("/submitReport")
public class SubmitReportServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 資料庫連線設置
        String jdbcURL = "jdbc:mysql://localhost:3306/TrafficViolation";
        String jdbcUsername = "root";
        String jdbcPassword = "ma20040822";

        // 取得表單資料
        String name = request.getParameter("name");
        String idNumber = request.getParameter("idNumber");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String location = request.getParameter("location");
        String licensePlate = request.getParameter("licensePlate");
        String violationTime = request.getParameter("violationTime");
        String violationType = request.getParameter("violationType");
        String description = request.getParameter("description");

        // 處理圖片上傳
        Part filePart = request.getPart("photo");
        String photoPath = "uploads/" + Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String uploadDir = getServletContext().getRealPath("/") + "uploads";
        File uploadDirFile = new File(uploadDir);
        if (!uploadDirFile.exists()) {
            uploadDirFile.mkdir();
        }
        filePart.write(uploadDir + "/" + filePart.getSubmittedFileName());

        // 建立資料庫連線並插入資料
        try (Connection conn = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword)) {
            String sql = "INSERT INTO Reports (name, idNumber, email, phone, location, licensePlate, violationTime, violationType, description, photoPath) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement statement = conn.prepareStatement(sql)) {
                statement.setString(1, name);
                statement.setString(2, idNumber);
                statement.setString(3, email);
                statement.setString(4, phone);
                statement.setString(5, location);
                statement.setString(6, licensePlate);
                statement.setString(7, violationTime);
                statement.setString(8, violationType);
                statement.setString(9, description);
                statement.setString(10, photoPath);

                int result = statement.executeUpdate();
                if (result > 0) {
                    response.sendRedirect("success.jsp");
                } else {
                    response.sendRedirect("error.jsp");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}
