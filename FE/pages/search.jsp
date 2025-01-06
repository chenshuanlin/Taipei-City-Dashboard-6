<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="zh-TW">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>車輛違規查詢系統</title>
    <link rel="stylesheet" href="../assets/css/search.css">
</head>

<body>
    <%
    // 資料庫連接參數 - 使用字串而不是變數
    String url = "jdbc:mysql://localhost:3306/SpeedingViolationSystem?useUnicode=true&characterEncoding=utf8";
    String dbUser = "root";  // 使用字串 "root"
    String dbPassword = "ma20040822";  // 使用字串 "ma20040822"
    
    // 獲取搜尋的車牌號碼
    String licensePlate = request.getParameter("plateNumber");
    %>

    <div class="container">
        <div class="header">
            <h1>車輛違規查詢系統</h1>
        </div>

        <div class="search-section">
            <div class="search-box">
                <form method="post" action="">
                    <input type="text" class="search-input" name="plateNumber" placeholder="請輸入車牌號碼" 
                           value="<%= licensePlate != null ? licensePlate : "" %>">
                    <button type="submit" class="search-btn">查詢</button>
                </form>
            </div>

            <%
            if (licensePlate != null && !licensePlate.trim().isEmpty()) {
                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;
                
                try {
                    Class.forName("com.mysql.jdbc.Driver");
                    conn = DriverManager.getConnection(url, dbUser, dbPassword);  // 使用正確的變數名稱
                    
                    // 修改 SQL 查詢以加入違規類型資訊
                    String sql = "SELECT v.CaseID, v.LicensePlate, " +
                               "v.ViolationLocation, v.Status, v.ViolationTime, " +
                               "v.CaseDescription, vt.ViolationName, vt.ViolationDescription, " +
                               "vt.PenaltyCategory, vt.FineAmount " +
                               "FROM ViolationCaseInfo v " +
                               "JOIN ViolationTypeInfo vt ON v.ViolationTypeID = vt.ViolationTypeID " +
                               "WHERE v.LicensePlate = ? " +
                               "ORDER BY  v.ViolationTime DESC";
                               
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, licensePlate);
                    rs = pstmt.executeQuery();
                    
                    boolean hasResults = false;
                    while (rs.next()) {
                        if (!hasResults) {
                            hasResults = true;
                            %>
                            <div class="result-section show">
                                <div class="violation-list">
                                    <div class="violation-header">
                                        <div>案件編號</div>
                                        <div>車牌號碼</div>
                                        <div>違規日期時間</div>
                                        <div>違規地點</div>
                                        <div>違規項目</div>
                                        <div>罰款金額</div>
                                        <div>狀態</div>
                                    </div>
                            <%
                        }
                        %>
                        <div class="violation-item">
                            <div><%= rs.getString("CaseID") %></div>
                            <div><%= rs.getString("LicensePlate") %></div>
                            <div><%= rs.getTimestamp("ViolationTime") %></div>
                            <div><%= rs.getString("ViolationLocation") %></div>
                            <div class="violation-details" onclick="showDetails(this)">
                                <%= rs.getString("ViolationName") %>
                                <div class="details-popup">
                                    <strong>違規說明：</strong> <%= rs.getString("ViolationDescription") %><br>
                                    <strong>類別：</strong> <%= rs.getString("PenaltyCategory") %><br>
                                    <strong>案件描述：</strong> <%= rs.getString("CaseDescription") != null ? rs.getString("CaseDescription") : "無" %>
                                </div>
                            </div>
                            <div class="fine-amount">NT$ <%= String.format("%,.0f", rs.getDouble("FineAmount")) %></div>
                            <div class="status-<%= rs.getString("Status").toLowerCase() %>">
                                <%= rs.getString("Status") %>
                            </div>
                        </div>
                        <%
                    }
                    
                    if (!hasResults) {
                        %>
                        <div class="no-result">
                            查無此車牌號碼的違規紀錄
                        </div>
                        <%
                    } else {
                        %>
                            </div>
                        </div>
                        <%
                    }
                    
                } catch (Exception e) {
                    out.println("查詢發生錯誤：" + e.getMessage());
                } finally {
                    try {
                        if (rs != null) rs.close();
                        if (pstmt != null) pstmt.close();
                        if (conn != null) conn.close();
                    } catch (SQLException e) {
                        out.println("關閉連接時發生錯誤：" + e.getMessage());
                    }
                }
            }
            %>
        </div>
    </div>

    <!-- 保持原有的 CSS 和 JavaScript 代碼 -->
    <style>
    .violation-header, .violation-item {
        display: grid;
        grid-template-columns: 1fr 1fr 2fr 2fr 2fr 1fr 1fr;
        gap: 10px;
        padding: 10px;
        align-items: center;
    }
    
    .violation-details {
        cursor: pointer;
        position: relative;
    }
    
    .violation-details:hover {
        color: #0066cc;
    }
    
    .details-popup {
        display: none;
        position: absolute;
        background: white;
        border: 1px solid #ddd;
        padding: 15px;
        border-radius: 5px;
        box-shadow: 0 2px 5px rgba(0,0,0,0.2);
        z-index: 1000;
        width: 300px;
        left: 50%;
        transform: translateX(-50%);
    }
    
    .fine-amount {
        text-align: right;
        font-weight: bold;
    }
    
    .status-pending { 
        background-color: #ffd700;
        padding: 5px 10px;
        border-radius: 3px;
        text-align: center;
    }
    .status-processed { 
        background-color: #90ee90;
        padding: 5px 10px;
        border-radius: 3px;
        text-align: center;
    }
    .status-closed { 
        background-color: #d3d3d3;
        padding: 5px 10px;
        border-radius: 3px;
        text-align: center;
    }
    </style>

    <script>
    function showDetails(element) {
        const popup = element.querySelector('.details-popup');
        const allPopups = document.querySelectorAll('.details-popup');
        
        allPopups.forEach(p => {
            if (p !== popup) {
                p.style.display = 'none';
            }
        });
        
        if (popup.style.display === 'block') {
            popup.style.display = 'none';
        } else {
            popup.style.display = 'block';
        }
    }

    document.addEventListener('click', function(event) {
        if (!event.target.closest('.violation-details')) {
            document.querySelectorAll('.details-popup').forEach(popup => {
                popup.style.display = 'none';
            });
        }
    });
    </script>
</body>
</html>