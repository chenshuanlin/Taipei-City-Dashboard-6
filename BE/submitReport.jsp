<%@ page import="java.sql.*" %> <% // 接收表單資料 String name =
request.getParameter("name"); String idNumber =
request.getParameter("idNumber"); String email = request.getParameter("email");
String phone = request.getParameter("phone"); String location =
request.getParameter("location"); String licensePlate =
request.getParameter("licensePlate"); String violationTime =
request.getParameter("violationTime"); String violationType =
request.getParameter("violationType"); String description =
request.getParameter("description"); // 資料庫連線資訊 String jdbcURL =
"jdbc:mysql://localhost:3306/car"; String jdbcUsername = "root"; String
jdbcPassword = "ma20040822"; Connection connection = null; PreparedStatement
preparedStatement = null; try { // 加載 JDBC 驅動
Class.forName("com.mysql.cj.jdbc.Driver"); // 建立資料庫連線 connection =
DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword); // 插入資料的
SQL 語句 String sql = "INSERT INTO violation_reports (name, id_number, email,
phone, location, license_plate, violation_time, violation_type, description)
VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)"; preparedStatement =
connection.prepareStatement(sql); preparedStatement.setString(1, name);
preparedStatement.setString(2, idNumber); preparedStatement.setString(3, email);
preparedStatement.setString(4, phone); preparedStatement.setString(5, location);
preparedStatement.setString(6, licensePlate); preparedStatement.setString(7,
violationTime); preparedStatement.setString(8, violationType);
preparedStatement.setString(9, description); // 執行資料庫插入 int rows =
preparedStatement.executeUpdate(); if (rows > 0) { out.println("
<h2>舉報成功！</h2>
"); } else { out.println("
<h2>舉報失敗，請稍後再試。</h2>
"); } } catch (Exception e) { e.printStackTrace(); out.println("
<h2>發生錯誤：" + e.getMessage() + "</h2>
"); } finally { // 關閉資源 try { if (preparedStatement != null)
preparedStatement.close(); if (connection != null) connection.close(); } catch
(SQLException ex) { ex.printStackTrace(); } } %>
