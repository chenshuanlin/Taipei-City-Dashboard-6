<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="java.sql.*" %>
        <!DOCTYPE html>
        <html lang="zh-TW">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>車輛違規查詢系統</title>
            <link rel="stylesheet" href="search.css">
        </head>

        <body>
            <% // 資料庫連接參數 String
                url="jdbc:mysql://localhost:3306/SpeedingViolationSystem?useUnicode=true&characterEncoding=utf8" ;
                String dbUser="root" ; String dbPassword="1234" ; // 獲取搜尋的車牌號碼並進行 trim 處理 String
                licensePlate=request.getParameter("plateNumber"); licensePlate=(licensePlate !=null) ?
                licensePlate.trim() : "" ; boolean isSearchSubmitted=request.getMethod().equals("POST"); %>

                <div class="container">
                    <div class="header">
                        <h1>車輛違規查詢系統</h1>
                    </div>

                    <div class="search-section">
                        <div class="search-box">
                            <form method="post" action="">
                                <input type="text" class="search-input" name="plateNumber" placeholder="請輸入車牌號碼"
                                    value="<%= licensePlate %>">
                                <button type="submit" class="search-btn">查詢</button>
                            </form>
                        </div>

                        <div class="results-container">
                            <% // 只有當表單被提交時才執行查詢 if (isSearchSubmitted) { if (licensePlate.isEmpty()) { %>
                                <div class="no-result">
                                    請輸入車牌號碼
                                </div>
                                <% } else { Connection conn=null; PreparedStatement pstmt=null; ResultSet rs=null;
                                    boolean hasResults=false; try { Class.forName("com.mysql.jdbc.Driver");
                                    conn=DriverManager.getConnection(url, dbUser, dbPassword); String
                                    sql="SELECT v.CaseID, v.LicensePlate, "
                                    + "v.ViolationLocation, v.Status, v.ViolationTime, "
                                    + "v.CaseDescription, vt.ViolationName, vt.ViolationDescription, "
                                    + "vt.PenaltyCategory, vt.FineAmount " + "FROM ViolationCaseInfo v "
                                    + "JOIN ViolationTypeInfo vt ON v.ViolationTypeID = vt.ViolationTypeID "
                                    + "WHERE v.LicensePlate = ? " + "ORDER BY v.ViolationTime DESC" ;
                                    pstmt=conn.prepareStatement(sql); pstmt.setString(1, licensePlate);
                                    rs=pstmt.executeQuery(); hasResults=rs.isBeforeFirst(); if (hasResults) { %>
                                    <div class="violations-list">
                                        <div class="violation-header">
                                            <div>案件編號</div>
                                            <div>車牌號碼</div>
                                            <div>違規日期時間</div>
                                            <div>違規地點</div>
                                            <div>違規項目</div>
                                            <div>罰款金額</div>
                                            <div>狀態</div>
                                        </div>
                                        <% while (rs.next()) { %>
                                            <div class="violation-item">
                                                <div>
                                                    <%= rs.getString("CaseID") %>
                                                </div>
                                                <div>
                                                    <%= rs.getString("LicensePlate") %>
                                                </div>
                                                <div>
                                                    <%= rs.getTimestamp("ViolationTime") %>
                                                </div>
                                                <div>
                                                    <%= rs.getString("ViolationLocation") %>
                                                </div>
                                                <div class="violation-details" onclick="showDetails(this)">
                                                    <%= rs.getString("ViolationName") %>
                                                        <div class="details-popup">
                                                            <strong>違規說明：</strong>
                                                            <%= rs.getString("ViolationDescription") %><br>
                                                                <strong>類別：</strong>
                                                                <%= rs.getString("PenaltyCategory") %><br>
                                                                    <strong>案件描述：</strong>
                                                                    <%= rs.getString("CaseDescription") !=null ?
                                                                        rs.getString("CaseDescription") : "無" %>
                                                        </div>
                                                </div>
                                                <div class="fine-amount">NT$ <%= String.format("%,.0f",
                                                        rs.getDouble("FineAmount")) %>
                                                </div>
                                                <div class="status-<%= rs.getString(" Status").toLowerCase() %>">
                                                    <%= rs.getString("Status") %>
                                                </div>
                                            </div>
                                            <% } %>
                                    </div>
                                    <% } else { %>
                                        <div class="no-result">
                                            查無此車牌號碼「<%= licensePlate %>」的違規紀錄
                                        </div>
                                        <% } } catch (Exception e) { %>
                                            <div class="error-message">
                                                查詢發生錯誤：<%= e.getMessage() %>
                                            </div>
                                            <% } finally { if (rs !=null) try { rs.close(); } catch (SQLException e) {}
                                                if (pstmt !=null) try { pstmt.close(); } catch (SQLException e) {} if
                                                (conn !=null) try { conn.close(); } catch (SQLException e) {} } } } %>
                        </div>
                    </div>
                </div>

                <script>
                    function showDetails(element) {
                        const popup = element.querySelector('.details-popup');
                        const allPopups = document.querySelectorAll('.details-popup');

                        // 先關閉所有其他的 popup
                        allPopups.forEach(p => {
                            if (p !== popup) {
                                p.style.display = 'none';
                            }
                        });

                        // 切換目前點擊的 popup
                        popup.style.display = popup.style.display === 'block' ? 'none' : 'block';
                    }

                    // 點擊其他地方時關閉所有 popup
                    document.addEventListener('click', function (event) {
                        if (!event.target.closest('.violation-details')) {
                            document.querySelectorAll('.details-popup').forEach(popup => {
                                popup.style.display = 'none';
                            });
                        }
                    });
                </script>
        </body>

        </html>