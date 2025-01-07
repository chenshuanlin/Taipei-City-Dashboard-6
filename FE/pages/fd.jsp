<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ page import="java.sql.*"%> <%@ page
import="java.text.SimpleDateFormat"%> <%@ page import="java.util.Calendar"%>
<!DOCTYPE html>
<html lang="zh">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>罰單</title>
    <style>
      * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
      }

      body {
        font-family: "微軟正黑體", sans-serif;
        padding: 20px;
        background-color: #f5f5f5;
      }

      .ticket {
        max-width: 800px;
        margin: 0 auto;
        background: white;
        padding: 30px;
        border: 1px solid #000;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
      }

      .header {
        display: flex;
        justify-content: space-between;
        margin-bottom: 30px;
        border-bottom: 2px solid #000;
        padding-bottom: 15px;
      }

      .left-boxes {
        display: flex;
        flex-direction: column;
        gap: 10px;
      }

      .checkbox-container {
        border: 1px solid #000;
        padding: 5px 10px;
      }

      .title {
        font-size: 24px;
        font-weight: bold;
        text-align: center;
        flex-grow: 1;
        margin: 0 20px;
      }

      .right-section {
        text-align: right;
      }

      .form-grid {
        display: grid;
        grid-template-columns: repeat(6, 1fr);
        gap: 10px;
        margin-bottom: 30px;
      }

      .grid-label {
        font-weight: bold;
        background-color: #f5f5f5;
        padding: 8px;
        border: 1px solid #000;
      }

      .grid-value {
        padding: 8px;
        border: 1px solid #000;
      }

      .notes-section {
        margin: 20px 0;
        padding: 15px;
        border: 1px solid #000;
        line-height: 1.8;
      }

      .footer {
        display: flex;
        justify-content: space-between;
        margin-top: 30px;
        padding-top: 15px;
        border-top: 1px solid #000;
      }

      .stamp-box {
        width: 120px;
        height: 120px;
        border: 1px solid #000;
        display: flex;
        align-items: center;
        justify-content: center;
        text-align: center;
      }
    </style>
  </head>
  <body>
    <% String url =
    "jdbc:mysql://localhost:3306/violation_db?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Taipei";
    String dbUser = "root"; String dbPassword = "ma20040822"; String caseId =
    request.getParameter("id"); Connection conn = null; PreparedStatement pstmt
    = null; ResultSet rs = null; try {
    Class.forName("com.mysql.cj.jdbc.Driver"); conn =
    DriverManager.getConnection(url, dbUser, dbPassword); String sql = "SELECT
    v.*, vt.ViolationName, vt.ViolationDescription, " + "vt.PenaltyCategory,
    vt.FineAmount, vbi.OwnerName " + "FROM ViolationCaseInfo v " + "JOIN
    ViolationTypeInfo vt ON v.ViolationTypeID = vt.ViolationTypeID " + "LEFT
    JOIN VehicleBasicInfo vbi ON v.VehicleID = vbi.VehicleID " + "WHERE v.CaseID
    = ?"; pstmt = conn.prepareStatement(sql); pstmt.setString(1, caseId); rs =
    pstmt.executeQuery(); if (rs.next()) { SimpleDateFormat sdf = new
    SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); Calendar cal =
    Calendar.getInstance(); %>

    <div class="ticket">
      <div class="header">
        <div class="left-boxes">
          <div class="checkbox-container">違規舉發通知</div>
          <div class="checkbox-container">☑ 汽車駕駛人</div>
        </div>
        <div class="title">違反道路交通管理事件通知單</div>
        <div class="right-section">
          <div class="serial-number">
            字號：<%= rs.getString("TicketID") != null ?
            rs.getString("TicketID") : "N/A" %>
          </div>
          <div class="barcode"></div>
        </div>
      </div>

      <div class="form-grid">
        <div class="grid-label">車主姓名</div>
        <div class="grid-value" style="grid-column: span 2">
          <%= rs.getString("Name") != null ? rs.getString("Name") : "N/A" %>
        </div>
        <div class="grid-label">車牌號碼</div>
        <div class="grid-value" style="grid-column: span 2">
          <%= rs.getString("LicensePlate") != null ?
          rs.getString("LicensePlate") : "N/A" %>
        </div>

        <div class="grid-label">違規地址</div>
        <div class="grid-value" style="grid-column: span 5">
          <%= rs.getString("ViolationLocation") != null ?
          rs.getString("ViolationLocation") : "N/A" %>
        </div>

        <div class="grid-label">違規時間</div>
        <div class="grid-value" style="grid-column: span 5">
          <%= rs.getTimestamp("ViolationTime") != null ?
          sdf.format(rs.getTimestamp("ViolationTime")) : "N/A" %>
        </div>

        <div class="grid-label">違規事由</div>
        <div class="grid-value" style="grid-column: span 5">
          <%= rs.getString("ViolationName") != null ?
          rs.getString("ViolationName") : "N/A" %><br />
          <%= rs.getString("ViolationDescription") != null ?
          rs.getString("ViolationDescription") : "N/A" %>
        </div>

        <div class="grid-label">罰鍰金額</div>
        <div class="grid-value" style="grid-column: span 5">
          NT$ <%= rs.getDouble("FineAmount") %>
        </div>

        <div class="grid-label">處罰類別</div>
        <div class="grid-value" style="grid-column: span 2">
          <%= rs.getString("PenaltyCategory") != null ?
          rs.getString("PenaltyCategory") : "N/A" %>
        </div>

        <div class="grid-label">繳費狀態</div>
        <div class="grid-value" style="grid-column: span 2">
          <%= rs.getString("Status") != null ? rs.getString("Status") : "N/A" %>
        </div>

        <div class="grid-label">舉發單位</div>
        <div class="grid-value" style="grid-column: span 5">
          臺北市政府警察局
        </div>
      </div>

      <div class="notes-section">
        注意事項：<br />
        1.本單經勾記「得採網際網路、語音轉帳、郵政或向受委託代收處所繳納罰鍰」者，請依本單所列印之到期繳納。<br />
        2.本單經勾記「須至應到案處所接受裁決」者，須依應到案日期前，攜帶本通知單及駕駛人駕照、行車執照、身分證明文件至指定處所辦理。<br />
        3.被通知人認為舉發之違規事件與事實不符者，應於通知單收受日期起七日內，檢具
        相關證據及足資辨識之通知。<br />
        4.應到案期限末日為星期六、日、國定假日或其他休息日時，以休息日之次日代之。<br />
        5.不服舉發事實，應於接獲本單30日內，向處罰機關提出申訴<br />
      </div>

      <div class="footer">
        <div>
          中華民國 <%= cal.get(Calendar.YEAR) - 1911 %> 年 <%=
          cal.get(Calendar.MONTH) + 1 %> 月 <%= cal.get(Calendar.DATE) %> 日
        </div>
        <div class="stamp-box">機關戳章</div>
      </div>
    </div>

    <% } else { out.println("找不到指定的罰單資料"); } } catch(Exception e) {
    out.println("發生錯誤：" + e.getMessage()); e.printStackTrace(); } finally {
    // 關閉資料庫連接 try { if(rs != null) rs.close(); if(pstmt != null)
    pstmt.close(); if(conn != null) conn.close(); } catch(SQLException e) {
    e.printStackTrace(); } } %>
  </body>
</html>
