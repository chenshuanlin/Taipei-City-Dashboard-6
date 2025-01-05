<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <title>罰單管理系統</title>
	<style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: system-ui, -apple-system, sans-serif;
        }

        body {
            background-color: #f5f5f5;
            padding: 20px;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .header-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .bulk-actions {
            display: flex;
            gap: 10px;
        }

        .bulk-btn {
            padding: 8px 16px;
            background: #4a90e2;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .bulk-btn.print {
            background: #34c759;
        }

        .search-section {
            display: flex;
            gap: 20px;
            margin-bottom: 30px;
            align-items: center;
        }

        .date-range {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        input[type="date"] {
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }

        .search-btn {
            padding: 8px 20px;
            background: #4a90e2;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .filter-buttons {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }

        .filter-btn {
            padding: 6px 16px;
            background: #f0f0f0;
            border: 1px solid #ddd;
            border-radius: 4px;
            cursor: pointer;
        }

        .filter-btn.active {
            background: #4a90e2;
            color: white;
            border-color: #4a90e2;
        }

        .tickets-container {
            display: grid;
            gap: 20px;
        }

        .ticket {
            border: 1px solid #ddd;
            padding: 15px;
            border-radius: 4px;
            background: white;
            position: relative;
        }

        .checkbox-container {
            display: flex;
            align-items: center;
            padding-right: 10px;
            border-right: 1px solid #eee;
        }

        /* 新的checkbox樣式 */
        .ticket-checkbox {
            width: 20px;
            height: 20px;
            cursor: pointer;
            accent-color: #4a90e2;
        }

        /* 新的ticket內容容器樣式 */
        .ticket-main-content {
            flex: 1;
        }

        .ticket-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            color: #666;
        }

        .ticket-content {
            margin-bottom: 10px;
        }

        .ticket-actions {
            display: flex;
            gap: 10px;
        }

        .action-btn {
            padding: 4px 8px;
            border-radius: 4px;
            border: none;
            cursor: pointer;
        }

        .action-btn.view {
            background: #4a90e2;
            color: white;
        }

        .action-btn.download {
            background: #34c759;
            color: white;
        }

        .action-btn.delete {
            background: #ff3b30;
            color: white;
        }

        #loading {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: rgba(0, 0, 0, 0.8);
            color: white;
            padding: 20px;
            border-radius: 8px;
        }
    </style>
</head>
<body>
    <div class="tickets-container" id="ticketsContainer">
        <c:forEach var="ticket" items="${tickets}">
            <div class="ticket" data-id="${ticket.id}" data-status="${ticket.status}">
                <input type="checkbox" class="ticket-checkbox">
                <div class="ticket-header">
                    <span>罰單編號：${ticket.id}</span>
                    <span>處理日期：${ticket.date}</span>
                </div>
                <div class="ticket-content">
                    <p>違規事項：${ticket.violation}</p>
                    <p>地點：${ticket.location}</p>
                    <p>罰款金額：${ticket.amount} 元</p>
                </div>
                <div class="ticket-actions">
                    <button class="action-btn view" onclick="viewTicket('${ticket.id}')">查看</button>
                    <button class="action-btn download" onclick="downloadTicket('${ticket.id}')">下載</button>
                    <button class="action-btn delete" onclick="deleteTicket('${ticket.id}')">刪除</button>
                </div>
            </div>
        </c:forEach>
    </div>
</body>
</html>
