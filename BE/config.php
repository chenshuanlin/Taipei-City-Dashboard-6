<?php
// config.php
define('DB_SERVER', 'localhost');
define('DB_USERNAME', 'root');
define('DB_PASSWORD', 'ma20040822');
define('DB_NAME', 'car');

// 建立資料庫連接
function getConnection() {
    try {
        $conn = new PDO(
            "mysql:host=" . localhost . ";dbname=" .交通違規舉報資料表 . ";charset=utf8mb4",
            DB_USERNAME,
            DB_PASSWORD,
            array(
                PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8mb4"
            )
        );
        return $conn;
    } catch(PDOException $e) {
        die("連接失敗: " . $e->getMessage());
    }
}
?>