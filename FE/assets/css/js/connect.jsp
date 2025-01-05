<%@ page import="java.sql.*" %>
    <% // 資料庫連線參數 String dbURL="jdbc:mysql://localhost:3306/test_db" ; // 資料庫URL String dbUser="root" ; // 資料庫用戶名 String
        dbPassword="1234" ; // 資料庫密碼 // 獲取表單提交的資料 String name=request.getParameter("name"); String
        email=request.getParameter("email"); Connection conn=null; PreparedStatement pstmt=null; try { // 建立資料庫連線
        Class.forName("com.mysql.cj.jdbc.Driver"); // 加載 MySQL 驅動 conn=DriverManager.getConnection(dbURL, dbUser,
        dbPassword); // 插入資料到資料庫 String sql="INSERT INTO users (name, email) VALUES (?, ?)" ;
        pstmt=conn.prepareStatement(sql); pstmt.setString(1, name); pstmt.setString(2, email); int
        rows=pstmt.executeUpdate(); if (rows> 0) {
        out.println("<h1>資料新增成功！</h1>");
        } else {
        out.println("<h1>資料新增失敗！</h1>");
        }
        } catch (Exception e) {
        out.println("<h1>錯誤: " + e.getMessage() + "</h1>");
        e.printStackTrace();
        } finally {
        // 關閉連線
        try {
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
        } catch (SQLException e) {
        e.printStackTrace();
        }
        }
        %>