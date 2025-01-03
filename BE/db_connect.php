<?php
// 資料庫連線設定
$host = "localhost"; // 主機
$port = "3306"; // 埠號
$username = "root"; // 使用者名稱
$password = "ma20040822"; 
$dbname = "car"; 

// 建立連線
$conn = new mysqli($host, $username, $password, $dbname, $port);

// 檢查連線
if ($conn->connect_error) {
    die("資料庫連線失敗：" . $conn->connect_error);
}

echo "資料庫連線成功！";
?>
