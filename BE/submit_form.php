<?php
// 資料庫連線
$servername = "localhost"; // 伺服器名稱
$username = "root"; // 資料庫使用者名稱
$password = "ma20040822"; // 資料庫密碼
$dbname = "TrafficViolation"; // 資料庫名稱

$conn = new mysqli($servername, $username, $password, $dbname);

// 檢查連線
if ($conn->connect_error) {
    die("連線失敗：" . $conn->connect_error);
}

// 接收表單資料
$name = $_POST['name'];
$idNumber = $_POST['idNumber'];
$email = $_POST['email'];
$phone = $_POST['phone'];
$location = $_POST['location'];
$licensePlate = $_POST['licensePlate'];
$violationTime = $_POST['violationTime'];
$violationType = $_POST['violationType'];
$description = $_POST['description'];

// 處理照片上傳
$targetDir = "uploads/";
$photoName = basename($_FILES["photo"]["name"]);
$targetFilePath = $targetDir . $photoName;

if (move_uploaded_file($_FILES["photo"]["tmp_name"], $targetFilePath)) {
    $photoPath = $targetFilePath;
} else {
    die("照片上傳失敗！");
}

// 插入資料庫
$sql = "INSERT INTO Reports (name, idNumber, email, phone, location, licensePlate, violationTime, violationType, description, photoPath)
        VALUES ('$name', '$idNumber', '$email', '$phone', '$location', '$licensePlate', '$violationTime', '$violationType', '$description', '$photoPath')";

if ($conn->query($sql) === TRUE) {
    echo "資料提交成功！案件編號：" . $conn->insert_id;
} else {
    echo "錯誤：" . $sql . "<br>" . $conn->error;
}

// 關閉連線
$conn->close();
?>
