<?php
// 資料庫連線設定
$host = "3306"; // 主機
$username = "0000"; // 使用者名稱
$password = "ma20040822"; 
$dbname = "car"; 

// 建立連線
$conn = new mysqli($host, $username, $password, $dbname);

// 檢查連線
if ($conn->connect_error) {
    die("資料庫連線失敗：" . $conn->connect_error);
}
?>
