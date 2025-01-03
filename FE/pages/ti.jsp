<!DOCTYPE html>
<html lang="zh-TW">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>交通違規舉報系統</title>
    <style>
      * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        font-family: "Microsoft JhengHei", sans-serif;
      }

      body {
        background-color: #f5f5f5;
        padding: 20px;
      }

      .container {
        max-width: 1200px;
        margin: 0 auto;
      }

      .header {
        background-color: #1a73e8;
        color: white;
        padding: 20px;
        text-align: center;
        font-size: 24px;
        border-radius: 10px 10px 0 0;
      }

      .card {
        background-color: white;
        border-radius: 0 0 10px 10px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        padding: 20px;
      }

      .form-title {
        text-align: center;
        margin-bottom: 30px;
        color: #333;
      }

      .form-section {
        margin-bottom: 30px;
        padding: 20px;
        border: 1px solid #ddd;
        border-radius: 8px;
      }

      .section-title {
        margin-bottom: 20px;
        color: #1a73e8;
        border-bottom: 2px solid #1a73e8;
        padding-bottom: 5px;
      }

      .grid-2 {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 20px;
      }

      .form-group {
        margin-bottom: 15px;
      }

      label {
        display: block;
        margin-bottom: 5px;
        color: #555;
      }

      .form-input {
        width: 100%;
        padding: 8px;
        border: 1px solid #ddd;
        border-radius: 4px;
        font-size: 16px;
      }

      .form-textarea {
        width: 100%;
        height: 150px;
        padding: 8px;
        border: 1px solid #ddd;
        border-radius: 4px;
        resize: vertical;
      }

      .upload-area {
        border: 2px dashed #1a73e8;
        padding: 20px;
        text-align: center;
        border-radius: 4px;
        margin-bottom: 15px;
        cursor: pointer;
      }

      .file-input {
        display: none;
      }

      .upload-label {
        color: #1a73e8;
        cursor: pointer;
      }

      .preview-area {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
        gap: 10px;
        margin-top: 15px;
      }

      .preview-image {
        width: 100%;
        height: 150px;
        object-fit: cover;
        border-radius: 4px;
      }

      .button-group {
        display: flex;
        gap: 15px;
        justify-content: center;
        margin-top: 30px;
      }

      .btn {
        padding: 10px 30px;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        font-size: 16px;
        transition: background-color 0.3s;
      }

      .btn-submit {
        background-color: #1a73e8;
        color: white;
      }

      .btn-reset {
        background-color: #ffa726;
        color: white;
      }

      .btn-cancel {
        background-color: #ef5350;
        color: white;
      }

      /* 新增成功頁面樣式 */
      .success-container {
        text-align: center;
        padding: 40px 20px;
      }

      .success-icon {
        width: 80px;
        height: 80px;
        background-color: #4caf50;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 0 auto 20px;
      }

      .success-icon::before {
        content: "✓";
        color: white;
        font-size: 40px;
      }

      .success-title {
        color: #4caf50;
        font-size: 24px;
        margin-bottom: 15px;
      }

      .success-message {
        color: #666;
        font-size: 16px;
        margin-bottom: 30px;
        line-height: 1.6;
      }

      .case-number {
        background-color: #f5f5f5;
        padding: 15px;
        border-radius: 8px;
        display: inline-block;
        margin-bottom: 30px;
      }

      .case-number span {
        font-weight: bold;
        color: #1a73e8;
      }

      .next-steps {
        background-color: #f8f9fa;
        padding: 20px;
        border-radius: 8px;
        text-align: left;
        margin-bottom: 30px;
      }

      .next-steps h3 {
        color: #333;
        margin-bottom: 15px;
      }

      .next-steps ul {
        list-style-type: none;
        padding-left: 0;
      }

      .next-steps li {
        margin-bottom: 10px;
        padding-left: 25px;
        position: relative;
      }

      .next-steps li::before {
        content: "•";
        color: #1a73e8;
        position: absolute;
        left: 10px;
      }

      .btn-secondary {
        background-color: #f5f5f5;
        color: #333;
        border: 1px solid #ddd;
      }

      @media print {
        .btn,
        .upload-area {
          display: none;
        }

        .card {
          box-shadow: none;
          padding: 0;
        }

        .preview-image {
          page-break-inside: avoid;
        }
      }

      @media (max-width: 768px) {
        .grid-2 {
          grid-template-columns: 1fr;
        }
      }
    </style>
  </head>

  <body>
    <div class="container">
      <div class="header">交通違規舉報系統</div>
      <div class="card">
        <h2 class="form-title">違規舉發單</h2>
        <form
          id="violationForm"
          action="submit_form.php"
          method="post"
          enctype="multipart/form-data"
        >
          <!-- 檢舉人資訊 -->
          <div class="form-section">
            <h3 class="section-title">檢舉人資訊</h3>
            <div class="grid-2">
              <div class="form-group">
                <label>姓名：</label>
                <input type="text" name="name" class="form-input" required />
              </div>
              <div class="form-group">
                <label>身分證字號：</label>
                <input
                  type="text"
                  name="idNumber"
                  class="form-input"
                  required
                />
              </div>
              <div class="form-group">
                <label>電子郵件：</label>
                <input type="email" name="email" class="form-input" required />
              </div>
              <div class="form-group">
                <label>聯絡電話：</label>
                <input type="tel" name="phone" class="form-input" required />
              </div>
            </div>
          </div>

          <!-- 違規資訊 -->
          <div class="form-section">
            <h3 class="section-title">違規資訊</h3>
            <div class="grid-2">
              <div class="form-group">
                <label>違規地點：</label>
                <input
                  type="text"
                  name="location"
                  class="form-input"
                  required
                />
              </div>
              <div class="form-group">
                <label>車牌號碼：</label>
                <input
                  type="text"
                  name="licensePlate"
                  class="form-input"
                  required
                />
              </div>
              <div class="form-group">
                <label>違規時間：</label>
                <input
                  type="datetime-local"
                  name="violationTime"
                  class="form-input"
                  required
                />
              </div>
              <div class="form-group">
                <label>違規項目：</label>
                <input
                  type="text"
                  name="violationType"
                  class="form-input"
                  required
                />
              </div>
            </div>
          </div>

          <!-- 違規照片 -->
          <div class="form-section">
            <h3 class="section-title">違規照片上傳</h3>
            <input
              type="file"
              name="photo"
              class="form-input"
              accept="image/*"
              required
            />
          </div>

          <!-- 違規說明 -->
          <div class="form-section">
            <h3 class="section-title">違規說明</h3>
            <textarea
              name="description"
              class="form-textarea"
              required
            ></textarea>
          </div>

          <!-- 提交按鈕 -->
          <div class="button-group">
            <button type="submit" class="btn btn-submit">提交</button>
          </div>
        </form>
      </div>
    </div>

    <script>
      document
        .getElementById("violationForm")
        .addEventListener("submit", function (e) {
          e.preventDefault();
          const formData = new FormData(this);
          generateSuccessPage(formData);
        });

      document
        .getElementById("imageUpload")
        .addEventListener("change", function (e) {
          const previewArea = document.getElementById("previewArea");
          previewArea.innerHTML = "";

          Array.from(e.target.files).forEach((file) => {
            const reader = new FileReader();
            reader.onload = function (event) {
              const img = document.createElement("img");
              img.src = event.target.result;
              img.className = "preview-image";
              previewArea.appendChild(img);
            };
            reader.readAsDataURL(file);
          });
        });

      function generateSuccessPage(formData) {
        // 隱藏表單
        document.getElementById("violationForm").style.display = "none";

        // 獲取容器
        const container = document.querySelector(".card");

        // 插入成功頁面
        container.innerHTML = `
                <div class="success-container">
                    <div class="success-icon"></div>
                    <h2 class="success-title">舉報提交成功！</h2>
                    <p class="success-message">
                        感謝您對交通安全的關注與貢獻。<br>
                        我們已收到您的舉報資訊，並將盡快處理。
                    </p>
                    
                    <div class="case-number">
                        案件編號：<span id="caseNumber"></span>
                    </div>

                    <div class="next-steps">
                        <h3>後續處理流程：</h3>
                        <ul>
                            <li>我們將在 3 個工作天內完成初步審核</li>
                            <li>審核結果將透過電子郵件通知</li>
                            <li>若需補充資料，我們會主動與您聯繫</li>
                            <li>您可以使用案件編號查詢處理進度</li>
                        </ul>
                    </div>

                    <div class="action-buttons">
                        <button onclick="window.print()" class="btn btn-secondary">列印舉報內容</button>
                        <button onclick="window.location.reload()" class="btn btn-primary">提交新舉報</button>
                    </div>
                </div>
            `;

        // 生成並顯示案件編號
        const caseNumber = generateCaseNumber();
        document.getElementById("caseNumber").textContent = caseNumber;
      }

      // 生成案件編號的函數
      function generateCaseNumber() {
        const date = new Date();
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, "0");
        const day = String(date.getDate()).padStart(2, "0");
        const random = Math.floor(Math.random() * 10000)
          .toString()
          .padStart(4, "0");
        return `VR${year}${month}${day}${random}`;
      }
    </script>
  </body>
</html>
