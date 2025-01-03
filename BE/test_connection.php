<?php
// 資料庫連線設定
$host = "3306"; // 主機
$username = "root"; // 使用者名稱
$password = "ma20040822"; // 密碼
$dbname = "car"; // 資料庫名稱

// 建立連線
$conn = new mysqli($host, $username, $password, $dbname);

// 檢查連線
if ($conn->connect_error) {
    die("資料庫連線失敗：" . $conn->connect_error);
} else {
    echo "成功連接到資料庫！";
}

// 測試查詢資料庫中的表格名稱
$sql = "SHOW TABLES";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    echo "<br>資料庫中包含以下表格：<br>";
    while ($row = $result->fetch_row()) {
        echo $row[0] . "<br>";
    }
} else {
    echo "<br>資料庫中沒有表格。";
}

// 關閉連線
$conn->close();
?>
