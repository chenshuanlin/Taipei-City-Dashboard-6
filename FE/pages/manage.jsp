<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>罰單管理系統</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: '微軟正黑體', sans-serif;
            line-height: 1.6;
            padding: 20px;
            background-color: #f5f5f5;
        }
		.actions {
            margin-bottom: 20px;
            display: flex;
            gap: 10px;
            justify-content: flex-end;
        }

        button {
            padding: 8px 16px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        button:hover {
            background-color: #45a049;
        }
		.icon {
        width: 24px;
        height: 24px;
        fill: currentColor;
        vertical-align: middle;
      }

      .preview-icon {
        margin-right: 5px;
        color: #4caf50;
      }
        .tickets-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
		
		.action-button {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 5px;
      }

      .close-icon {
        width: 20px;
        height: 20px;
        margin-right: 5px;
      }

      /* 修改預覽按鈕樣式 */
      .preview-button {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 5px;
        padding: 6px 12px;
        border-radius: 4px;
        background-color: #4caf50;
        color: white;
        border: none;
        cursor: pointer;
        transition: background-color 0.3s;
      }
	  h1 {
        text-align: center;
        margin-bottom: 20px;
        color: #333;
      }
      .preview-button:hover {
        background-color: #45a049;
      }

      .close-btn {
        display: flex;
        align-items: center;
        padding: 8px 16px;
        background-color: #fff;
        border: 1px solid #ddd;
        border-radius: 4px;
        cursor: pointer;
        transition: background-color 0.3s;
      }

      .close-btn:hover {
        background-color: #f5f5f5;
      }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        .table th, .table td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: left;
        }
        .table th {
            background-color: #f8f8f8;
            font-weight: bold;
        }
        .status-paid { color: #2e7d32; }
        .status-unpaid { color: #c62828; }
        .pagination {
            margin-top: 20px;
            display: flex;
            justify-content: center;
            gap: 10px;
        }
        .pagination a {
            padding: 8px 12px;
            border: 1px solid #ddd;
            text-decoration: none;
            color: #333;
            border-radius: 4px;
        }
        .pagination a:hover {
            background-color: #f5f5f5;
        }
        .pagination .active {
            background-color: #4CAF50;
            color: white;
            border-color: #4CAF50;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>罰單管理系統</h1>
        
        <%
            // 資料庫連接設定
            String url = "jdbc:mysql://localhost:3306/SpeedingViolationSystem?useUnicode=true&characterEncoding=utf8";
            String dbUser = "root";
            String dbPassword = "ma20040822";
            
            // 分頁設定
            int pageSize = 10;
            int currentPage = request.getParameter("page") != null ? 
                Integer.parseInt(request.getParameter("page")) : 1;
            
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            
            try {
                // 載入資料庫驅動程式
                Class.forName("com.mysql.jdbc.Driver");
                
                // 建立資料庫連接
                conn = DriverManager.getConnection(url, dbUser, dbPassword);
                
                // 計算總記錄數
                Statement stmt = conn.createStatement();
                rs = stmt.executeQuery("SELECT COUNT(*) FROM ViolationCaseInfo");
                int totalRecords = 0;
                if (rs.next()) {
                    totalRecords = rs.getInt(1);
                }
                int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
                
                // 查詢當前頁面的資料
                String sql = "SELECT * FROM ViolationCaseInfo ORDER BY ViolationTime DESC LIMIT ? OFFSET ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, pageSize);
                pstmt.setInt(2, (currentPage - 1) * pageSize);
                rs = pstmt.executeQuery();
                
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        %>
		<div class="actions">
            <button onclick="selectAll()" class="action-button">
                <svg class="icon">
                    <use xlink:href="#download-icon" />
                </svg>
                全選
            </button>
            <button onclick="downloadSelected()" class="action-button">
                <svg class="icon">
                    <use xlink:href="#download-icon" />
                </svg>
                下載選中罰單
            </button>
            <button onclick="printSelected()" class="action-button">
                <svg class="icon">
                    <use xlink:href="#print-icon" />
                </svg>
                列印選中罰單
            </button>
        </div>
        <table class="table">
            <thead>
                <tr>
					<th>
						<input
						  type="checkbox"
						  class="ticket-checkbox"
						  onclick="toggleAll(this)"
						/>
					  </th>
                    <th>案件編號</th>
                    <th>車牌號碼</th>
                    <th>違規時間</th>
                    <th>違規地點</th>
                    <th>案件描述</th>
                    <th>狀態</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
                <% while(rs.next()) { %>
                    <tr>
						<td><input type="checkbox" class="ticket-checkbox" /></td>

                        <td><%= rs.getString("CaseID") %></td>
                        <td><%= rs.getString("LicensePlate") %></td>
                        <td><%= sdf.format(rs.getTimestamp("ViolationTime")) %></td>
                        <td><%= rs.getString("ViolationLocation") %></td>
                        <td><%= rs.getString("CaseDescription") %></td>
                        <td class="status-<%= rs.getString("Status").equals("已繳費") ? "paid" : "unpaid" %>">
                            <%= rs.getString("Status") %>
                        </td>
                        <td>
                            <a href="caseDetail.jsp?id=<%= rs.getString("CaseID") %>">查看詳情</a>
                        </td>
                    </tr>
                <% } %>
            </tbody>
        </table>
        
        <div class="pagination">
            <% if(currentPage > 1) { %>
                <a href="?page=<%= currentPage-1 %>">上一頁</a>
            <% } %>
            
            <% for(int i = 1; i <= totalPages; i++) { %>
                <a href="?page=<%= i %>" class="<%= i == currentPage ? "active" : "" %>">
                    <%= i %>
                </a>
            <% } %>
            
            <% if(currentPage < totalPages) { %>
                <a href="?page=<%= currentPage+1 %>">下一頁</a>
            <% } %>
        </div>
        
        <%
            } catch(Exception e) {
                out.println("發生錯誤：" + e.getMessage());
                e.printStackTrace();
            } finally {
                // 關閉資料庫連接
                try {
                    if(rs != null) rs.close();
                    if(pstmt != null) pstmt.close();
                    if(conn != null) conn.close();
                } catch(SQLException e) {
                    e.printStackTrace();
                }
            }
        %>
    </div>
	<script>
		function toggleAll(checkbox) {
			// 獲取所有的罰單複選框
			const ticketCheckboxes = document.querySelectorAll('.ticket-checkbox');
			
			// 將所有複選框的狀態設置為與全選複選框相同
			ticketCheckboxes.forEach(cb => {
				if (cb !== checkbox) { // 排除觸發事件的全選複選框本身
					cb.checked = checkbox.checked;
				}
			});
		}
		
		function selectAll() {
			// 獲取全選複選框（表頭中的複選框）
			const headerCheckbox = document.querySelector('thead .ticket-checkbox');
			
			// 設置為勾選狀態
			headerCheckbox.checked = true;
			
			// 觸發全選事件
			toggleAll(headerCheckbox);
		}
		</script>
</body>
</html>