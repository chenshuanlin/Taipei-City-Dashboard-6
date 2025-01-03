<%@ page language="java" contentType="application/json; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ page import="java.sql.*"%> <%@ page
import="org.json.simple.*"%> <%
response.setContentType("application/json;charset=UTF-8");
response.setHeader("Cache-Control", "no-cache"); String plateNumber =
request.getParameter("車牌號碼"); // 這是調試用的，打印收到的車牌號碼
System.out.println("Received plate number: " + plateNumber); JSONArray jsonArray
= new JSONArray(); try { // 連接資料庫 String jdbcUrl =
"jdbc:mysql://localhost:3306/罰單超速系統?useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Taipei";
String dbUser = "root"; String dbPassword = "ma20040822"; Connection conn =
DriverManager.getConnection(jdbcUrl, dbUser, dbPassword); // 查詢資料 String sql
= "SELECT * FROM 車輛違規資料表 WHERE 車牌號碼 = ?"; PreparedStatement pstmt =
conn.prepareStatement(sql); pstmt.setString(1, plateNumber); ResultSet rs =
pstmt.executeQuery(); // 處理查詢結果 while (rs.next()) { JSONObject record =
new JSONObject(); record.put("id", rs.getString("編號"));
record.put("plateNumber", rs.getString("車牌號碼")); record.put("date",
rs.getString("違規日期")); record.put("location", rs.getString("違規地點"));
record.put("violation", rs.getString("違規項目")); record.put("status",
rs.getString("狀態")); jsonArray.add(record); } // 關閉資源 rs.close();
pstmt.close(); conn.close(); // 打印返回的 JSON 資料到伺服器控制台
System.out.println("Returned JSON Data: " + jsonArray.toString()); //
如果查詢結果沒有資料，添加一個消息 if (jsonArray.isEmpty()) { JSONObject
noRecord = new JSONObject(); noRecord.put("message", "查無資料");
jsonArray.add(noRecord); } } catch (Exception e) { // 錯誤處理 JSONObject error
= new JSONObject(); error.put("error", "查詢失敗：" + e.getMessage());
jsonArray.add(error); } // 返回資料給前端 out.print(jsonArray.toString()); %>
