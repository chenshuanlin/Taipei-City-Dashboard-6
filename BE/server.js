const express = require("express");
const mysql = require("mysql2/promise");
const cors = require("cors");
const multer = require("multer");

const app = express();

// 詳細的 CORS 設定
app.use(
  cors({
    origin: "http://127.0.0.1:5500/FE/pages/ti1.html", // 或你的前端網址
    methods: ["GET", "POST"],
    allowedHeaders: ["Content-Type"],
  })
);

app.use(express.json());
const upload = multer();

const pool = mysql.createPool({
  host: "localhost",
  user: "your_username",
  password: "your_password",
  database: "your_database",
  waitForConnections: true,
  connectionLimit: 10,
});

app.post("/api/violations", upload.single("違規照片"), async (req, res) => {
  try {
    const {
      檢舉人姓名,
      身分證字號,
      電子郵件,
      聯絡電話,
      違規地點,
      違規時間,
      車牌號碼,
      違規項目,
      違規說明,
    } = req.body;

    const [result] = await pool.execute(
      `INSERT INTO 交通違規舉報資料表 (
        檢舉人姓名, 身分證字號, 電子郵件, 聯絡電話,
        違規地點, 違規時間, 車牌號碼, 違規項目,
        違規照片, 違規說明
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        檢舉人姓名,
        身分證字號,
        電子郵件,
        聯絡電話,
        違規地點,
        違規時間,
        車牌號碼,
        違規項目,
        req.file ? req.file.buffer : null,
        違規說明,
      ]
    );

    res.json({ message: "舉報成功", id: result.insertId });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "資料儲存失敗" });
  }
});

app.get("/api/violations", async (req, res) => {
  try {
    const [rows] = await pool.execute("SELECT * FROM 交通違規舉報資料表");
    res.json(rows);
  } catch (error) {
    res.status(500).json({ message: "查詢失敗" });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
