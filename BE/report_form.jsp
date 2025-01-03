<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<html>
  <head>
    <title>交通違規舉報表單</title>
  </head>
  <body>
    <h1>交通違規舉報表單</h1>
    <form action="submitReport" method="post" enctype="multipart/form-data">
      <label for="name">姓名:</label>
      <input type="text" id="name" name="name" required /><br /><br />

      <label for="idNumber">身份證號碼:</label>
      <input type="text" id="idNumber" name="idNumber" required /><br /><br />

      <label for="email">電子郵件:</label>
      <input type="email" id="email" name="email" required /><br /><br />

      <label for="phone">電話號碼:</label>
      <input type="text" id="phone" name="phone" required /><br /><br />

      <label for="location">違規地點:</label>
      <input type="text" id="location" name="location" required /><br /><br />

      <label for="licensePlate">車牌號碼:</label>
      <input
        type="text"
        id="licensePlate"
        name="licensePlate"
        required
      /><br /><br />

      <label for="violationTime">違規時間:</label>
      <input
        type="datetime-local"
        id="violationTime"
        name="violationTime"
        required
      /><br /><br />

      <label for="violationType">違規類型:</label>
      <input
        type="text"
        id="violationType"
        name="violationType"
        required
      /><br /><br />

      <label for="description">違規描述:</label><br />
      <textarea
        id="description"
        name="description"
        rows="4"
        cols="50"
        required
      ></textarea
      ><br /><br />

      <label for="photo">違規照片:</label>
      <input
        type="file"
        id="photo"
        name="photo"
        accept="image/*"
        required
      /><br /><br />

      <input type="submit" value="提交報告" />
    </form>
  </body>
</html>
