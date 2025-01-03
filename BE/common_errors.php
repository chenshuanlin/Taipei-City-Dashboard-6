<?php
// common_errors.php
try {
    $conn = new PDO(
        "mysql:host=" . localhost . ";dbname=" . car,
        root,
        ma20040822
    );
    
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    echo "連接成功\n";
    
} catch(PDOException $e) {
    $error_message = $e->getMessage();
    
    // 分析常見錯誤
    if (strpos($error_message, "Access denied") !== false) {
        echo "錯誤：使用者名稱或密碼錯誤\n";
    }
    else if (strpos($error_message, "Unknown database") !== false) {
        echo "錯誤：找不到指定的資料庫\n";
    }
    else if (strpos($error_message, "Connection refused") !== false) {
        echo "錯誤：無法連接到資料庫伺服器，請確認：\n";
        echo "1. MySQL 服務是否已啟動\n";
        echo "2. 伺服器位址是否正確\n";
        echo "3. 防火牆設定是否允許連接\n";
    }
    else {
        echo "發生錯誤：" . $error_message . "\n";
    }
}
?>