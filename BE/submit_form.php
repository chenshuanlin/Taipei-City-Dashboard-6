<?php
// 引入資料庫連線檔案
include('db_connect.php');

// 檢查是否收到 POST 請求
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // 接收表單資料
    $name = $_POST['name'];
    $idNumber = $_POST['idNumber'];
    $email = $_POST['email'];
    $phone = $_POST['phone'];
    $location = $_POST['location'];
    $violationTime = $_POST['violationTime'];
    $licensePlate = $_POST['licensePlate'];
    $violationType = $_POST['violationType'];
    $description = $_POST['description'];

    // 處理上傳照片
    $photo = null;
    if (isset($_FILES['photo']) && $_FILES['photo']['error'] == 0) {
        $photo = file_get_contents($_FILES['photo']['tmp_name']); // 將照片轉為二進位格式
    }

    // 插入資料到資料庫
    $stmt = $conn->prepare("INSERT INTO `交通違規舉報資料表` (
        `檢舉人姓名`, `身分證字號`, `電子郵件`, `聯絡電話`, `違規地點`, `違規時間`,
        `車牌號碼`, `違規項目`, `違規照片`, `違規說明`
    ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");

    $stmt->bind_param(
        "sssssssssb",
        $name, $idNumber, $email, $phone, $location, $violationTime,
        $licensePlate, $violationType, $photo, $description
    );

    if ($stmt->execute()) {
        echo "舉報資料已成功提交！";
    } else {
        echo "提交失敗：" . $stmt->error;
    }

    $stmt->close();
    $conn->close();
}
?>
