<%@ page import="java.sql.*" %> <%@ page contentType="text/html; charset=UTF-8"
%>
<!DOCTYPE html>
<html>
  <head>
    <title>Violation Case Information</title>
    <style>
      table {
        width: 100%;
        border-collapse: collapse;
      }
      th,
      td {
        border: 1px solid #ddd;
        padding: 8px;
      }
      th {
        background-color: #f2f2f2;
        text-align: left;
      }
    </style>
  </head>
  <body>
    <h1>Violation Case Information</h1>
    <table>
      <thead>
        <tr>
          <th>CaseID</th>
          <th>VehicleID</th>
          <th>ViolationTypeID</th>
          <th>ViolationLocation</th>
          <th>ViolationTime</th>
          <th>AssistantID</th>
          <th>TicketID</th>
          <th>CaseDescription</th>
        </tr>
      </thead>
      <tbody>
        <% String dbURL = "jdbc:mysql://localhost:3306/your_database"; String
        dbUser = "your_username"; String dbPassword = "your_password"; String
        query = "SELECT * FROM ViolationCaseInfo"; try (Connection conn =
        DriverManager.getConnection(dbURL, dbUser, dbPassword); Statement stmt =
        conn.createStatement(); ResultSet rs = stmt.executeQuery(query)) { while
        (rs.next()) { out.println("
        <tr>
          "); out.println("
          <td>" + rs.getString("CaseID") + "</td>
          "); out.println("
          <td>" + rs.getString("VehicleID") + "</td>
          "); out.println("
          <td>" + rs.getInt("ViolationTypeID") + "</td>
          "); out.println("
          <td>" + rs.getString("ViolationLocation") + "</td>
          "); out.println("
          <td>" + rs.getTimestamp("ViolationTime") + "</td>
          "); out.println("
          <td>" + rs.getString("AssistantID") + "</td>
          "); out.println("
          <td>" + rs.getString("TicketID") + "</td>
          "); out.println("
          <td>" + rs.getString("CaseDescription") + "</td>
          "); out.println("
        </tr>
        "); } } catch (Exception e) { e.printStackTrace(); out.println("
        <tr>
          <td colspan="8">Error loading data.</td>
        </tr>
        "); } %>
      </tbody>
    </table>
  </body>
</html>
