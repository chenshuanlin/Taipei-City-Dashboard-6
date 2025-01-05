<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="zh">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>登入/註冊</title>
    <link rel="stylesheet" href="../assets/css/log.css" />
  </head>
  <body>
    <div class="container" id="loginPage">
      <h2 class="form-title">登入</h2>
      <form id="loginForm" method="post" action="login.jsp">
        <div class="form-group">
          <label for="loginEmail">帳號</label>
          <input type="text" id="loginEmail" name="assistantId" required />
        </div>
        <div class="form-group">
          <label for="loginPassword">密碼</label>
          <input type="password" id="loginPassword" name="password" required />
        </div>
        <button type="submit">登入</button>
      </form>
    </div>

    <% if ("POST".equalsIgnoreCase(request.getMethod())) { String assistantId =
    request.getParameter("assistantId"); String password =
    request.getParameter("password"); Connection conn = null; PreparedStatement
    pstmt = null; ResultSet rs = null; try {
    Class.forName("com.mysql.jdbc.Driver"); String url =
    "jdbc:mysql://localhost:3306/SpeedingViolationSystem?useUnicode=true&characterEncoding=utf8";
    String dbUser = "root"; String dbPassword = "ma20040822"; conn =
    DriverManager.getConnection(url, dbUser, dbPassword); String sqlQuery =
    "SELECT * FROM AssistantInfo WHERE AssistantID = ? AND Password = ?"; pstmt
    = conn.prepareStatement(sqlQuery); pstmt.setString(1, assistantId);
    pstmt.setString(2, password); rs = pstmt.executeQuery(); if (rs.next()) {
    session.setAttribute("assistantId", assistantId);
    response.sendRedirect("../pages/deal.jsp"); } else { %>
    <script>
      alert("登入失敗！請檢查您的帳號和密碼。");
    </script>
    <% } } catch (Exception e) { %>
    <script>
      alert("系統錯誤：<%= e.getMessage() %>");
    </script>
    <% } finally { try { if (rs != null) rs.close(); } catch (SQLException e) {
    } try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { } try {
    if (conn != null) conn.close(); } catch (SQLException e) { } } } %>
  </body>
</html>
