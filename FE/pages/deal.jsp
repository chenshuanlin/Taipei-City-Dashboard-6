<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <% // 檢查 session 是否有效 String assistantId = (String)
session.getAttribute("assistantId"); String assistantName = (String)
session.getAttribute("assistantName"); if (assistantId == null || assistantName
== null) { response.sendRedirect("login.jsp"); return; } %>
<!DOCTYPE html>
<html lang="zh-TW">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>交通局佐理人管理系統</title>
    <link rel="stylesheet" href="../assets/css/deal.css" />
    <style>
      /* 簡化樣式 */
      .user-info {
        position: fixed;
        top: 20px;
        right: 20px;
        background-color: #fff;
        padding: 10px 15px;
        border-radius: 5px;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
      }
      .user-info span {
        font-size: 14px;
        color: #333;
      }
      .logout-btn {
        padding: 5px 10px;
        background-color: #f44336;
        color: #fff;
        border: none;
        border-radius: 3px;
        text-decoration: none;
        cursor: pointer;
      }
    </style>
  </head>
  <body>
    <div class="user-info">
      <span>帳號：<%= assistantId %></span>
      <span>姓名：<%= assistantName %></span>
      <a href="logout.jsp" class="logout-btn">登出</a>
    </div>
    <div class="container">
      <div class="sidebar">
        <div class="logo">交通局佐理人管理系統</div>
        <div class="menu-item active" data-section="case-management">
          案件管理
        </div>
        <div class="menu-item" data-section="statistics">數據統計</div>
        <!--<div class="menu-item" data-section="personnel">人員管理</div>
            <div class="menu-item" data-section="settings">系統設定</div>-->
      </div>

      <div class="main-content">
        <!-- 案件管理 -->
        <div id="case-management" class="content-section active">
          <div class="header">
            <h1>案件管理</h1>
          </div>

          <div class="nav-buttons">
            <a href="../pages/all.html" class="nav-btn home-btn">回到首頁</a>
            <a href="../pages/login.html" class="nav-btn logout-btn">登出</a>
          </div>

          <div class="status-cards">
            <div class="card">
              <div class="card-title">待處理案件</div>
              <div class="card-value">24</div>
            </div>
            <div class="card">
              <div class="card-title">處理中案件</div>
              <div class="card-value">15</div>
            </div>
            <div class="card">
              <div class="card-title">已處理案件</div>
              <div class="card-value">158</div>
            </div>
          </div>

          <div class="case-list">
            <div class="list-header">
              <div>案件編號</div>
              <div>檢舉時間</div>
              <div>違規地點</div>
              <div>違規項目</div>
              <div>狀態</div>
              <div>操作</div>
            </div>

            <div class="list-item">
              <div>TIC001</div>
              <div>2025/01/02</div>
              <div>中山路一段</div>
              <div>違規停車</div>
              <div><span class="status-badge status-pending">待處理</span></div>
              <div>
                <button
                  class="action-btn"
                  onclick="showCaseDetail('TIC001', '待處理')"
                >
                  處理
                </button>
              </div>
            </div>

            <div class="list-item">
              <div>TIC002</div>
              <div>2025/01/02</div>
              <div>忠孝東路</div>
              <div>闖紅燈</div>
              <div>
                <span class="status-badge status-processing">處理中</span>
              </div>
              <div>
                <button
                  class="action-btn"
                  onclick="showCaseDetail('TIC002', '處理中')"
                >
                  查看
                </button>
              </div>
            </div>

            <div class="list-item">
              <div>TIC003</div>
              <div>2025/01/01</div>
              <div>南京東路</div>
              <div>超速</div>
              <div>
                <span class="status-badge status-completed">已處理</span>
              </div>
              <div>
                <button
                  class="action-btn"
                  onclick="showCaseDetail('TIC003', '已處理')"
                >
                  查看
                </button>
              </div>
            </div>
          </div>

          <div class="header">
            <h1>案件管理</h1>
            <button class="action-btn" onclick="showAIFailedCases()">
              AI辨識失敗清單
            </button>
          </div>

          <div class="ai-failed-list" id="aiFailed">
            <h2>AI辨識失敗清單</h2>
            <div class="image-grid">
              <div class="image-card">
                <img src="/api/placeholder/400/300" alt="違規照片1" />
                <div class="details">
                  <p>拍攝時間: 2025/01/02 14:30</p>
                  <p>地點: 中山路二段</p>
                  <button
                    class="action-btn verify-btn"
                    onclick="showVerificationModal('IMG001')"
                  >
                    進行人工辨識
                  </button>
                </div>
              </div>
              <div class="image-card">
                <img src="/api/placeholder/400/300" alt="違規照片2" />
                <div class="details">
                  <p>拍攝時間: 2025/01/02 15:45</p>
                  <p>地點: 復興南路</p>
                  <button
                    class="action-btn verify-btn"
                    onclick="showVerificationModal('IMG002')"
                  >
                    進行人工辨識
                  </button>
                </div>
              </div>
            </div>
          </div>

          <div id="verificationModal" class="modal">
            <div class="modal-content">
              <span class="close" onclick="closeVerificationModal()"
                >&times;</span
              >
              <h2>人工辨識</h2>
              <div class="verify-content">
                <img
                  src="/api/placeholder/600/400"
                  alt="待辨識照片"
                  style="width: 100%; margin: 20px 0"
                />
                <div>
                  <p><strong>違規類型：</strong></p>
                  <select
                    id="violationType"
                    style="width: 100%; padding: 10px; margin: 10px 0"
                  >
                    <option value="">請選擇違規類型</option>
                    <option value="parking">違規停車</option>
                    <option value="redlight">闖紅燈</option>
                    <option value="speed">超速</option>
                  </select>
                  <textarea
                    id="verificationNote"
                    placeholder="請輸入備註說明"
                    style="
                      width: 100%;
                      padding: 10px;
                      margin: 10px 0;
                      height: 100px;
                    "
                  ></textarea>
                  <button class="action-btn" onclick="submitVerification()">
                    確認送出
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- 數據統計 -->
        <div id="statistics" class="content-section">
          <h1>數據統計</h1>
          <p>數據統計內容</p>
        </div>

        <!-- 人員管理 -->
        <!--<div id="personnel" class="content-section">
                <h1>人員管理</h1>
                <p>人員管理內容</p>
            </div>-->

        <!-- 系統設定 -->
        <!--<div id="settings" class="content-section">
                <h1>系統設定</h1>
                <p>系統設定內容</p>
            </div>-->
      </div>
    </div>

    <!-- 案件詳情模態框 -->
    <div id="caseModal" class="modal">
      <div class="modal-content">
        <span class="close" onclick="closeModal()">&times;</span>
        <h2>案件詳情</h2>
        <div id="caseDetail" class="case-detail">
          <!-- 案件詳情內容將由JavaScript動態插入 -->
        </div>
      </div>
    </div>
    <script>
      // 節省 JavaScript 定義
      document.querySelectorAll(".menu-item").forEach((item) => {
        item.addEventListener("click", () => {
          document
            .querySelectorAll(".menu-item")
            .forEach((i) => i.classList.remove("active"));
          document
            .querySelectorAll(".content-section")
            .forEach((section) => section.classList.remove("active"));
          item.classList.add("active");
          const sectionId = item.getAttribute("data-section");
          document.getElementById(sectionId).classList.add("active");
        });
      });
    </script>
  </body>
</html>
