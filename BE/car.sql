-- 創建資料庫，名稱為罰單超速系統
CREATE DATABASE IF NOT EXISTS 罰單超速系統
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;


USE 罰單超速系統;

SET foreign_key_checks = 0;

DROP TABLE IF EXISTS 車主基本資料表;
DROP TABLE IF EXISTS 車輛基本資料表;
DROP TABLE IF EXISTS 違規型態資料表;
DROP TABLE IF EXISTS 執法人員資料表;
DROP TABLE IF EXISTS 佐理員資料表;
DROP TABLE IF EXISTS 違規罰單資料表;
DROP TABLE IF EXISTS 列印檔資料表;
DROP TABLE IF EXISTS 違規案件資料表;
DROP TABLE IF EXISTS 交通違規舉報資料表;

CREATE TABLE 車主基本資料表 (
    車主編號 VARCHAR(10) PRIMARY KEY,  
    姓名 VARCHAR(50) NOT NULL,          
    身份證字號 VARCHAR(20) NOT NULL UNIQUE,  
    電話號碼 VARCHAR(20),               
    地址 VARCHAR(100)                  
);
CREATE TABLE 交通違規舉報資料表 (
    編號 INT AUTO_INCREMENT PRIMARY KEY,
    檢舉人姓名 VARCHAR(100),
    身分證字號 VARCHAR(20),
    電子郵件 VARCHAR(255),
    聯絡電話 VARCHAR(15),
    違規地點 VARCHAR(255),
    違規時間 DATETIME,
    車牌號碼 VARCHAR(20),
    違規項目 VARCHAR(255),
    違規照片 BLOB COMMENT,
    違規說明 TEXT COMMENT,
    建立時間 DATETIME DEFAULT CURRENT_TIMESTAMP ,
    更新時間 DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新時間'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='交通違規舉報資料表';

CREATE TABLE 車輛違規資料表 (
    編號 INT AUTO_INCREMENT PRIMARY KEY,  -- 自動遞增主鍵
    車牌號碼 VARCHAR(20) NOT NULL,        -- 車牌號碼
    違規日期 DATE NOT NULL,               -- 違規日期
    違規地點 VARCHAR(255) NOT NULL,       -- 違規地點
    違規項目 VARCHAR(255) NOT NULL,       -- 違規項目
    狀態 VARCHAR(10) NOT NULL, -- 違規狀態
    建立時間 DATETIME DEFAULT CURRENT_TIMESTAMP, -- 紀錄創建時間
    更新時間 DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP -- 紀錄更新時間
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='車輛違規紀錄表';

INSERT INTO 車輛違規資料表 (編號, 車牌號碼, 違規日期, 違規地點, 違規項目, 狀態,建立時間,更新時間) VALUES 
('C001', '123 SKT', '2024/01/02', '台北市文山區萬壽路 50 巷 10 號', '闖紅燈','已繳費', '2019/01/02', '2019/01/02'),
('C002', 'JRX-4176', '2022/01/02', '台北市文山區萬壽路 50 巷 10 號', '闖紅燈','已繳費', '2019/01/02', '2019/01/02'),
('C003', 'VVJ-808', '2023/01/02', '台北市文山區萬壽路 50 巷 10 號','闖紅燈','已繳費', '2019/01/02', '2019/01/02');

CREATE TABLE 車輛基本資料表 (
    車輛編號 VARCHAR(10) PRIMARY KEY, 
    車牌號碼 VARCHAR(10),            
    車主編號 VARCHAR(10),        
    廠牌 VARCHAR(20),           
    型號 VARCHAR(20),                
    顏色 VARCHAR(20),
	車種 VARCHAR(20),
    FOREIGN KEY (車主編號) REFERENCES 車主基本資料表(車主編號)
);


CREATE TABLE 違規型態資料表 (
    違規類型編號 INT PRIMARY KEY AUTO_INCREMENT,  
    違規名稱 VARCHAR(100),                       
    違規描述 TEXT,                               
    處罰分類 VARCHAR(50),                          
    罰款金額 DECIMAL(10, 2)                        
);


CREATE TABLE 執法人員資料表 (
    執法人員編號 VARCHAR(10) PRIMARY KEY,
    執法人員姓名 VARCHAR(50),
    執法人員所屬單位 VARCHAR(50)
);

CREATE TABLE 佐理員資料表 (
    佐理員編號 VARCHAR(10) PRIMARY KEY,
    佐理員姓名 VARCHAR(50),
    佐理員所屬單位 VARCHAR(50)
);

CREATE TABLE 違規罰單資料表 (
    罰單編號 VARCHAR(20) PRIMARY KEY,  
    車輛編號 VARCHAR(10),           
    違規類型編號 INT,               
    違規地點 VARCHAR(100),            
    違規時間 DATETIME,           
    處理人員編號 VARCHAR(10),       
    照相地點 VARCHAR(100),            
    照相地點經度 DECIMAL(10, 6),   
    照相地點緯度 DECIMAL(10, 6),    
    違規照片 LONGBLOB,               
    開罰單位 VARCHAR(100),          
    當地限速 INT, 
    實際時速 INT, 
    照相機設備編號 VARCHAR(20),    
    FOREIGN KEY (車輛編號) REFERENCES 車輛基本資料表(車輛編號),
    FOREIGN KEY (違規類型編號) REFERENCES 違規類型資料表(違規類型編號),
    FOREIGN KEY (處理人員編號) REFERENCES 執法人員資料表(執法人員編號)
);


CREATE TABLE 違規案件資料表 (
    案件編號 VARCHAR(20) PRIMARY KEY,  
    車輛編號 VARCHAR(10),           
    違規類型編號 INT,               
    違規地點 VARCHAR(100),            
    違規時間 DATETIME,           
    佐理員編號 VARCHAR(10),       
    罰單編號 VARCHAR(20),
    案件描述 TEXT,
    FOREIGN KEY (車輛編號) REFERENCES 車輛基本資料表(車輛編號),
    FOREIGN KEY (違規類型編號) REFERENCES 違規型態資料表(違規類型編號),
    FOREIGN KEY (佐理員編號) REFERENCES 佐理員資料表(佐理員編號),
    FOREIGN KEY (罰單編號) REFERENCES 違規罰單資料表(罰單編號)
);

CREATE TABLE 列印檔資料表 (
    列印編號 VARCHAR(10) PRIMARY KEY,
    列單編號 VARCHAR(10),
    列印日期 DATE,
    列印時間 TIME
);

INSERT INTO 車輛基本資料表 (車輛編號, 車牌號碼, 車主編號, 廠牌, 型號, 顏色, 車種) VALUES 
('C001', '123 SKT', 'O001', 'Lexus', 'RX', '灰色', '小客車'),
('C002', 'JRX-4176', 'O002', 'BMW', 'iX', '綠色', '貨車'),
('C003', 'VVJ-808', 'O003', 'Mazda', 'Mazda6', '銀色', '機車'),
('C004', 'MBZ-1898', 'O004', 'Mazda', 'CX-5', '金色', '小客車'),
('C005', '6042 ZP', 'O005', 'Mercedes-Benz', 'GLE', '紅色', '機車'),
('C006', '035-TWM', 'O006', 'Mitsubishi', 'Lancer', '灰色', '機車'),
('C007', 'HEW-9474', 'O007', 'Toyota', 'Prius', '白色', '機車'),
('C008', 'VHW 228', 'O008', 'Nissan', 'Altima', '黃色', '機車'),
('C009', 'EDA-021', 'O009', 'Honda', 'HR-V', '藍色', '小客車'),
('C010', '055-EYR', 'O010', 'Nissan', 'Kicks', '紅色', '小客車'),
('C011', 'WLP 431', 'O011', 'Honda', 'Civic', '灰色', '小客車'),
('C012', 'USA1707', 'O012', 'Mitsubishi', 'Lancer', '黃色', '小客車'),
('C013', 'E34 3FO', 'O013', 'Tesla', 'Model 3', '灰色', '小客車'),
('C014', '3093', 'O014', 'Tesla', 'Model 3', '黃色', '小客車'),
('C015', '112 9MT', 'O015', 'Mazda', 'Mazda3', '紅色', '小客車'),
('C016', '9MZ 982', 'O016', 'Lexus', 'RX', '白色', '小客車'),
('C017', '6297', 'O017', 'Toyota', 'Corolla', '藍色', '小客車'),
('C018', '534CXI', 'O018', 'Lexus', 'UX', '黑色', '貨車'),
('C019', 'SE9 5840', 'O019', 'Mazda', 'Mazda3', '灰色', '貨車'),
('C020', '331-YZL', 'O020', 'Nissan', 'Sentra', '黃色', '小客車'),
('C021', 'KIR 933', 'O021', 'BMW', '3 Series', '灰色', '小客車'),
('C022', '51-J210', 'O022', 'Mazda', 'MX-5', '金色', '機車'),
('C023', 'TJJ-0441', 'O023', 'Toyota', 'Prius', '白色', '大客車'),
('C024', '166-MUG', 'O024', 'Honda', 'Fit', '金色', '大客車'),
('C025', '97-9742A', 'O025', 'Mercedes-Benz', 'C-Class', '黑色', '貨車'),
('C026', '2CT8670', 'O026', 'Ford', 'Explorer', '黃色', '小客車'),
('C027', '3EWY276', 'O027', 'BMW', 'X3', '白色', '小客車'),
('C028', '4TH9369', 'O028', 'Nissan', 'Sentra', '銀色', '小客車'),
('C029', '0LV J85', 'O029', 'Mazda', 'MX-5', '藍色', '大客車'),
('C030', '7567', 'O030', 'Ford', 'Focus', '綠色', '機車'),
('C031', '4U 6744T', 'O031', 'Honda', 'Fit', '白色', '大客車'),
('C032', '456 FBU', 'O032', 'Nissan', 'Sentra', '藍色', '小客車'),
('C033', 'Q40 8KS', 'O033', 'Honda', 'Accord', '銀色', '機車'),
('C034', '37T G58', 'O034', 'Honda', 'HR-V', '黃色', '機車'),
('C035', '249 QW6', 'O035', 'Honda', 'HR-V', '綠色', '大客車'),
('C036', '5TG 123', 'O036', 'Mazda', 'CX-30', '黑色', '小客車'),
('C037', 'RKL 335', 'O037', 'Honda', 'Accord', '綠色', '小客車'),
('C038', '79XE866', 'O038', 'Mazda', 'Mazda6', '藍色', '大客車'),
('C039', '85Y V11', 'O039', 'BMW', '3 Series', '綠色', '小客車'),
('C040', '0MO 899', 'O040', 'Honda', 'Civic', '紅色', '小客車'),
('C041', '0L 0362X', 'O041', 'Mazda', 'CX-30', '白色', '大客車'),
('C042', '949-ZOI', 'O042', 'Toyota', 'Prius', '藍色', '機車'),
('C043', '2-J7320', 'O043', 'Lexus', 'NX', '銀色', '機車'),
('C044', 'B11 7LW', 'O044', 'Mitsubishi', 'ASX', '白色', '大客車'),
('C045', 'UZY-842', 'O045', 'Ford', 'Ranger', '銀色', '大客車'),
('C046', '48FF122', 'O046', 'Mercedes-Benz', 'C-Class', '黃色', '小客車'),
('C047', '914-500', 'O047', 'Toyota', 'Corolla', '金色', '小客車'),
('C048', 'D37 5IH', 'O048', 'Mitsubishi', 'Delica', '金色', '機車s'),
('C049', 'T21 9WZ', 'O049', 'Toyota', 'Altis', '黑色', '機車'),
('C050', '686 3HM', 'O050', 'BMW', '5 Series', '白色', '大客車');



INSERT INTO 車主基本資料表 (車主編號, 姓名, 身份證字號, 電話號碼, 地址) VALUES 
('O001', '尹美玲', 'I080306654', '0910-846294', '台北市大安區信義路五段 100 號'),
('O002', '陳筱涵', 'T046746543', '07-39898386', '台北市中山區中山北路一段 50 號'),
('O003', '孫淑華', 'E575890923', '0959-862297', '台北市士林區天母東路 200 號'),
('O004', '王家瑜', 'U328279064', '04-7587333', '台北市北投區溫泉路 88 巷 5 號'),
('O005', '劉宇軒', 'E491937390', '050 31457530', '台北市文山區木柵路三段 50 號'),
('O006', '何建宏', 'I667933570', '09-41481242', '台北市大同區延平北路二段 75 號'),
('O007', '鄧佳玲', 'H252385095', '027 51288467', '台北市信義區松高路 30 號'),
('O008', '李馨儀', 'R974215707', '054 60807847', '台北市萬華區西園路一段 10 巷 3 號'),
('O009', '王怡伶', 'E900014590', '0945691926', '台北市南港區經貿二路 300 號'),
('O010', '高雅萍', 'U661715984', '03-2318461', '台北市內湖區新湖一路 15 巷 7 號'),
('O011', '劉傑克', 'D658744678', '02-57946400', '台北市中正區青島東路 3 號'),
('O012', '吳哲瑋', 'R394793271', '03-6493001', '台北市松山區八德路四段 150 巷 5 號'),
('O013', '丁琬婷', 'X971236871', '(08) 51972391', '台北市信義區基隆路一段 90 號'),
('O014', '陳郁婷', 'C489896519', '07-3631431', '台北市大安區和平東路三段 20 號'),
('O015', '戴冠宇', 'K301312246', '(02) 53115642', '台北市中山區南京東路五段 88 巷 12 號'),
('O016', '徐羽', 'O147373563', '06 3223736', '台北市士林區承德路四段 250 號'),
('O017', '劉詩涵', 'A434434581', '(02) 25213230', '台北市內湖區文德路 30 巷 18 號'),
('O018', '章雅芳', 'L353494735', '07-95532512', '台北市萬華區桂林路 45 號'),
('O019', '秦懿', 'U007489159', '090 80654196', '台北市南港區三重路 15 巷 2 號'),
('O020', '陳靜怡', 'M334454177', '01-35254579', '台北市信義區永吉路 100 巷 8 號'),
('O021', '裴庭瑋', 'C374745604', '(08) 65581950', '台北市松山區健康路 20 號'),
('O022', '楊佳玲', 'A755735283', '(01) 77326084', '台北市文山區興隆路二段 50 巷 10 號'),
('O023', '何佩君', 'O136636771', '02 6213649', '台北市北投區裕民街 150 號'),
('O024', '康淑芬', 'B304709006', '0900304276', '台北市大同區重慶北路三段 10 號'),
('O025', '何琬婷', 'G855807339', '036 11068176', '台北市士林區石牌路二段 25 號'),
('O026', '趙彥廷', 'R904550212', '09-6529919', '台北市萬華區西藏路 35 號'),
('O027', '朱筱涵', 'D879400472', '01-8891971', '台北市內湖區康寧路三段 5 巷 15 號'),
('O028', '胡雅玲', 'Q613892501', '(00) 14849884', '台北市信義區松隆路 80 號'),
('O029', '秦雅萍', 'L565634460', '04 7221910', '台北市中正區汀洲路三段 200 巷 5 號'),
('O030', '杜淑慧', 'D072636608', '074 73950939', '台北市北投區大業路 45 號'),
('O031', '劉佩君', 'G227569183', '03 3360305', '台北市大安區敦化南路二段 25 號'),
('O032', '劉惠如', 'V673952892', '(02) 87040941', '台北市文山區羅斯福路六段 150 號'),
('O033', '張淑玲', 'N803258711', '04-1518651', '台北市內湖區成功路五段 50 巷 3 號'),
('O034', '李志偉', 'D642582825', '01-96624748', '台北市中山區中山北路三段 88 號'),
('O035', '李雅涵', 'X559886958', '0919-638450', '台北市士林區中正路 300 巷 2 號'),
('O036', '朱雅芳', 'M716514915', '04 6864505', '台北市北投區中央北路一段 12 巷 5 號'),
('O037', '葛佳玲', 'R692844930', '(08) 62668619', '台北市萬華區艋舺大道 20 號'),
('O038', '梁雅筑', 'L346460452', '0965543006', '台北市中正區寧波西街 5 號'),
('O039', '賴欣怡', 'R543011876', '05-3526996', '台北市士林區德行路 50 號'),
('O040', '王琬婷', 'B761951998', '06 5070725', '台北市松山區八德路三段 15 號'),
('O041', '楊雅琪', 'N226810021', '0996156331', '台北市信義區基隆路三段 100 號'),
('O042', '林志偉', 'J548524203', '(03) 35048545', '台北市北投區永安街 5 號'),
('O043', '黃俊賢', 'I882495900', '(09) 60949656', '台北市士林區雙溪路 8 巷 3 號'),
('O044', '王慧君', 'S778791530', '05-94441446', '台北市大安區和平東路一段 30 號'),
('O045', '王俊賢', 'M119033739', '0949875589', '台北市北投區立德路 15 號'),
('O046', '章欣怡', 'H590755740', '013 49332593', '台北市文山區萬壽路 50 巷 10 號'),
('O047', '黃淑慧', 'Z071141409', '0961-657760', '台北市大同區延平北路五段 75 號'),
('O048', '羅建宏', 'C319941488', '010 43908883', '台北市中山區民權東路六段 35 巷 2 號'),
('O049', '沈詩婷', 'R017013146', '05-8993765', '台北市松山區復興南路一段 60 號'),
('O050', '王雅文', 'G175793525', '0978-336641', '台北市中正區館前路 88 號');

INSERT INTO 違規型態資料表 (違規類型編號, 違規名稱, 違規描述, 處罰分類, 罰款金額) VALUES
(1, '超速 10-20 公里', '駕駛速度超過法定限速 10 至 20 公里', '交通安全', 1500.00),
(2, '超速 20-30 公里', '駕駛速度超過法定限速 20 至 30 公里', '交通安全', 2000.00),
(3, '超速 30-40 公里', '駕駛速度超過法定限速 30 至 40 公里', '交通安全', 3000.00),
(4, '超速 40-50 公里', '駕駛速度超過法定限速 40 至 50 公里', '交通安全', 4000.00),
(5, '超速 50 公里以上', '駕駛速度超過法定限速 50 公里以上', '交通安全', 5000.00),
(6, '超速學區內 10 公里以上', '學區內駕駛速度超過法定限速 10 公里以上', '交通安全', 3000.00),
(7, '高速公路超速 20-40 公里', '高速公路駕駛速度超過法定限速 20 至 40 公里', '交通安全', 4000.00),
(8, '高速公路超速 40 公里以上', '高速公路駕駛速度超過法定限速 40 公里以上', '交通安全', 6000.00);
(8, '高速公路超速 40 公里以上', '高速公路駕駛速度超過法定限速 40 公里以上', '交通安全', 6000.00);

INSERT INTO 執法人員資料表 (執法人員編號, 執法人員姓名, 執法人員所屬單位) VALUES
('L001', '李偉民', '台北市警察局交通大隊'),
('L002', '王家豪', '台北市警察局交通大隊'),
('L003', '張淑芬', '台北市警察局交通大隊'),
('L004', '陳建宏', '台北市警察局交通大隊'),
('L005', '林筱薇', '台北市警察局交通大隊');


INSERT INTO 佐理員資料表 (佐理員編號, 佐理員姓名, 佐理員所屬單位) VALUES
('E001', '李佳玲', '台北市警察局交通大隊'),
('E002', '鄧佩君', '台北市警察局交通大隊'),
('E003', '黃立平', '台北市警察局交通大隊'),
('E004', '陳美芬', '台北市警察局交通大隊'),
('E005', '吳宗憲', '台北市警察局交通大隊');

INSERT INTO 違規罰單資料表 (
    罰單編號, 車輛編號, 違規類型編號, 違規地點, 違規時間, 執法人員編號, 照相地點, 照相地點經度, 照相地點緯度, 違規照片, 開罰單位, 當地限速, 實際時速,照相機設備編號
) VALUES
('F001', 'C001', 1, '台北市信義區松高路與基隆路交叉口', '2024-12-01 14:35:00', 'L001', '松高路路口', 121.567894, 25.035123, NULL, '台北市警察局交通大隊', 50, 63, 'CAM001'),
('F002', 'C002', 3, '台北市中山區南京東路與復興北路交叉口', '2024-12-02 16:20:00', 'L002', '南京東路路口', 121.544567, 25.052432, NULL, '台北市警察局交通大隊', 60, 78, 'CAM002'),
('F003', 'C003', 5, '台北市士林區中山北路與天母東路交叉口', '2024-12-03 10:50:00', 'L003', '天母東路路口', 121.533891, 25.101023, NULL, '台北市警察局交通大隊', 40, 90, 'CAM003'),
('F004', 'C004', 2, '台北市大安區和平東路與敦化南路交叉口', '2024-12-04 12:15:00', 'L004', '和平東路路口', 121.543012, 25.026789, NULL, '台北市警察局交通大隊', 50, 73, 'CAM004'),
('F005', 'C005', 4, '台北市文山區木柵路與興隆路交叉口', '2024-12-05 09:45:00', 'L005', '木柵路路口', 121.554321, 24.998765, NULL, '台北市警察局交通大隊', 60, 91, 'CAM005'),
('F006', 'C006', 6, '台北市信義區松仁路與信義路交叉口', '2024-12-06 17:30:00', 'L005', '松仁路路口', 121.561234, 25.034567, NULL, '台北市警察局交通大隊', 40, 59, 'CAM006'),
('F007', 'C007', 8, '台北市內湖區康寧路與成功路交叉口', '2024-12-07 19:00:00', 'L004', '康寧路路口', 121.590123, 25.067891, NULL, '台北市警察局交通大隊', 80, 103, 'CAM007'),
('F008', 'C008', 7, '台北市萬華區桂林路與和平西路交叉口', '2024-12-08 13:10:00', 'L001', '桂林路路口', 121.497812, 25.032456, NULL, '台北市警察局交通大隊', 70, 95, 'CAM008'),
('F009', 'C009', 1, '台北市中正區忠孝西路與博愛路交叉口', '2024-12-09 11:40:00', 'L002', '忠孝西路路口', 121.516789, 25.030123, NULL, '台北市警察局交通大隊', 50, 64, 'CAM009'),
('F010', 'C010', 3, '台北市北投區石牌路與承德路交叉口', '2024-12-10 08:25:00', 'L003', '石牌路路口', 121.500432, 25.123987, NULL, '台北市警察局交通大隊', 60, 79, 'CAM010'),
('F011', 'C011', 2, '台北市松山區八德路與民生路交叉口', '2024-12-11 14:10:00', 'L005', '八德路路口', 121.560789, 25.049321, NULL, '台北市警察局交通大隊', 50, 72, 'CAM011'),
('F012', 'C012', 4, '台北市南港區經貿一路與忠孝東路交叉口', '2024-12-12 10:00:00', 'L003', '經貿一路路口', 121.599123, 25.038765, NULL, '台北市警察局交通大隊', 70, 98, 'CAM012'),
('F013', 'C013', 5, '台北市士林區德行路與中山北路交叉口', '2024-12-13 15:45:00', 'L004', '德行路路口', 121.531890, 25.097654, NULL, '台北市警察局交通大隊', 50, 80, 'CAM013'),
('F014', 'C014', 6, '台北市大安區敦化南路與仁愛路交叉口', '2024-12-14 09:30:00', 'L005', '敦化南路路口', 121.544321, 25.028901, NULL, '台北市警察局交通大隊', 40, 59, 'CAM014'),
('F015', 'C015', 7, '台北市中山區民權東路與松江路交叉口', '2024-12-15 13:50:00', 'L004', '民權東路路口', 121.537456, 25.058712, NULL, '台北市警察局交通大隊', 70, 97, 'CAM015'),
('F016', 'C016', 8, '台北市內湖區新湖一路與成功路交叉口', '2024-12-16 16:20:00', 'L003', '新湖一路路口', 121.601234, 25.069876, NULL, '台北市警察局交通大隊', 80, 106, 'CAM016'),
('F017', 'C017', 2, '台北市萬華區西園路與艋舺大道交叉口', '2024-12-17 11:15:00', 'L002', '西園路路口', 121.497123, 25.030678, NULL, '台北市警察局交通大隊', 50, 73, 'CAM017'),
('F018', 'C018', 4, '台北市文山區興隆路與木柵路交叉口', '2024-12-18 18:35:00', 'L001', '興隆路路口', 121.551789, 24.998123, NULL, '台北市警察局交通大隊', 60, 88, 'CAM018'),
('F019', 'C019', 5, '台北市北投區中央北路與中山北路交叉口', '2024-12-19 07:50:00', 'L001', '中央北路路口', 121.515678, 25.105321, NULL, '台北市警察局交通大隊', 50, 81, 'CAM019'),
('F020', 'C020', 3, '台北市中正區南海路與濟南路交叉口', '2024-12-20 12:45:00', 'L005', '南海路路口', 121.514567, 25.029987, NULL, '台北市警察局交通大隊', 60, 82, 'CAM020'),
('F021', 'C021', 2, '台北市信義區基隆路與信義路交叉口', '2024-12-21 09:15:00', 'L001', '基隆路路口', 121.565432, 25.034567, NULL, '台北市警察局交通大隊', 50, 73, 'CAM021'),
('F022', 'C022', 4, '台北市內湖區新湖一路與內湖路交叉口', '2024-12-22 14:40:00', 'L002', '新湖一路路口', 121.591234, 25.070123, NULL, '台北市警察局交通大隊', 60, 85, 'CAM022'),
('F023', 'C023', 6, '台北市文山區木柵路與指南路交叉口', '2024-12-23 18:30:00', 'L003', '木柵路路口', 121.550789, 24.999321, NULL, '台北市警察局交通大隊', 40, 61, 'CAM023'),
('F024', 'C024', 3, '台北市北投區中央北路與石牌路交叉口', '2024-12-24 08:45:00', 'L004', '中央北路路口', 121.513567, 25.104890, NULL, '台北市警察局交通大隊', 60, 81, 'CAM024'),
('F025', 'C025', 5, '台北市中正區忠孝西路與館前路交叉口', '2024-12-25 15:20:00', 'L005', '忠孝西路路口', 121.517654, 25.030123, NULL, '台北市警察局交通大隊', 50, 70, 'CAM025'),
('F026', 'C026', 8, '台北市大安區仁愛路與敦化南路交叉口', '2024-12-26 17:35:00', 'L003', '仁愛路路口', 121.545890, 25.028712, NULL, '台北市警察局交通大隊', 80, 104, 'CAM026'),
('F027', 'C027', 7, '台北市萬華區和平西路與艋舺大道交叉口', '2024-12-27 10:25:00', 'L002', '和平西路路口', 121.495678, 25.030456, NULL, '台北市警察局交通大隊', 70, 94, 'CAM027'),
('F028', 'C028', 1, '台北市中山區民權東路與南京東路交叉口', '2024-12-28 13:50:00', 'L001', '民權東路路口', 121.536123, 25.059876, NULL, '台北市警察局交通大隊', 50, 64, 'CAM028'),
('F029', 'C029', 3, '台北市信義區松高路與信義路交叉口', '2024-12-29 11:15:00', 'L004', '松高路路口', 121.562890, 25.035678, NULL, '台北市警察局交通大隊', 60, 79, 'CAM029'),
('F030', 'C030', 4, '台北市士林區中山北路與德行路交叉口', '2024-12-30 09:40:00', 'L002', '德行路路口', 121.530123, 25.099765, NULL, '台北市警察局交通大隊', 60, 85, 'CAM030'),
('F031', 'C031', 2, '台北市松山區南京東路與復興北路交叉口', '2024-12-31 14:55:00', 'L001', '南京東路路口', 121.548765, 25.052567, NULL, '台北市警察局交通大隊', 50, 73, 'CAM031'),
('F032', 'C032', 6, '台北市大安區和平東路與信義路交叉口', '2025-01-01 16:20:00', 'L002', '和平東路路口', 121.541234, 25.026789, NULL, '台北市警察局交通大隊', 40, 61, 'CAM032'),
('F033', 'C033', 5, '台北市內湖區康寧路與成功路交叉口', '2025-01-02 19:00:00', 'L003', '康寧路路口', 121.589123, 25.068901, NULL, '台北市警察局交通大隊', 50, 77, 'CAM033'),
('F034', 'C034', 7, '台北市中正區忠孝西路與博愛路交叉口', '2025-01-03 11:45:00', 'L004', '忠孝西路路口', 121.518765, 25.031234, NULL, '台北市警察局交通大隊', 70, 97, 'CAM034'),
('F035', 'C035', 8, '台北市文山區木柵路與興隆路交叉口', '2025-01-04 18:50:00', 'L005', '木柵路路口', 121.552345, 24.997654, NULL, '台北市警察局交通大隊', 80, 108, 'CAM035'),
('F036', 'C036', 3, '台北市士林區中山北路與文林路交叉口', '2025-01-05 10:10:00', 'L003', '中山北路路口', 121.534567, 25.092345, NULL, '台北市警察局交通大隊', 60, 84, 'CAM036'),
('F037', 'C037', 2, '台北市大同區延平北路與重慶北路交叉口', '2025-01-06 09:25:00', 'L002', '延平北路路口', 121.512345, 25.072345, NULL, '台北市警察局交通大隊', 50, 72, 'CAM037'),
('F038', 'C038', 4, '台北市文山區指南路與興隆路交叉口', '2025-01-07 14:30:00', 'L001', '指南路路口', 121.554321, 24.997890, NULL, '台北市警察局交通大隊', 60, 89, 'CAM038'),
('F039', 'C039', 6, '台北市內湖區瑞光路與內湖路交叉口', '2025-01-08 16:45:00', 'L004', '瑞光路路口', 121.600789, 25.076543, NULL, '台北市警察局交通大隊', 40, 62, 'CAM039'),
('F040', 'C040', 5, '台北市信義區基隆路與松高路交叉口', '2025-01-09 19:00:00', 'L005', '基隆路路口', 121.565123, 25.034123, NULL, '台北市警察局交通大隊', 50, 73, 'CAM040'),
('F041', 'C041', 7, '台北市松山區民權東路與延吉街交叉口', '2025-01-10 13:20:00', 'L001', '民權東路路口', 121.553456, 25.053456, NULL, '台北市警察局交通大隊', 70, 98, 'CAM041'),
('F042', 'C042', 8, '台北市北投區石牌路與中央北路交叉口', '2025-01-11 10:55:00', 'L002', '石牌路路口', 121.501234, 25.123456, NULL, '台北市警察局交通大隊', 80, 109, 'CAM042'),
('F043', 'C043', 1, '台北市中正區忠孝東路與博愛路交叉口', '2025-01-12 09:35:00', 'L003', '忠孝東路路口', 121.519876, 25.032345, NULL, '台北市警察局交通大隊', 50, 74, 'CAM043'),
('F044', 'C044', 3, '台北市文山區木柵路與興隆路交叉口', '2025-01-13 17:20:00', 'L004', '木柵路路口', 121.552789, 24.996789, NULL, '台北市警察局交通大隊', 60, 83, 'CAM044'),
('F045', 'C045', 4, '台北市大安區和平東路與敦化南路交叉口', '2025-01-14 08:50:00', 'L005', '和平東路路口', 121.533789, 25.033567, NULL, '台北市警察局交通大隊', 60, 85, 'CAM045'),
('F046', 'C046', 2, '台北市內湖區康寧路與成功路交叉口', '2025-01-15 10:30:00', 'L002', '康寧路路口', 121.593456, 25.077123, NULL, '台北市警察局交通大隊', 50, 75, 'CAM046'),
('F047', 'C047', 5, '台北市信義區基隆路與松高路交叉口', '2025-01-16 12:40:00', 'L001', '基隆路路口', 121.560123, 25.032345, NULL, '台北市警察局交通大隊', 70, 95, 'CAM047'),
('F048', 'C048', 3, '台北市中山區長安東路與民生東路交叉口', '2025-01-17 11:00:00', 'L002', '長安東路路口', 121.531234, 25.055678, NULL, '台北市警察局交通大隊', 60, 82, 'CAM048'),
('F049', 'C049', 7, '台北市文山區木柵路與興隆路交叉口', '2025-01-18 14:30:00', 'L003', '木柵路路口', 121.552678, 24.998123, NULL, '台北市警察局交通大隊', 80, 108, 'CAM049'),
('F050', 'C050', 6, '台北市北投區石牌路與中央北路交叉口', '2025-01-19 09:10:00', 'L004', '石牌路路口', 121.500123, 25.124567, NULL, '台北市警察局交通大隊', 60, 80, 'CAM050');

INSERT INTO 違規案件資料表 (案件編號, 車輛編號, 違規類型編號, 違規地點, 違規時間, 佐理員編號, 罰單編號, 案件描述) VALUES
('A001', 'C001', 1, '台北市信義區松高路與基隆路交叉口', '2024-12-01 14:35:00', 'E001', 'F001', '駕駛超速 10-20 公里'),
('A002', 'C002', 3, '台北市中山區南京東路與復興北路交叉口', '2024-12-02 16:20:00', 'E002', 'F002', '駕駛超速 30-40 公里'),
('A003', 'C003', 5, '台北市士林區中山北路與天母東路交叉口', '2024-12-03 10:50:00', 'E003', 'F003', '駕駛超速 50 公里以上'),
('A004', 'C004', 2, '台北市大安區和平東路與敦化南路交叉口', '2024-12-04 12:15:00', 'E004', 'F004', '駕駛超速 20-30 公里'),
('A005', 'C005', 4, '台北市文山區木柵路與興隆路交叉口', '2024-12-05 09:45:00', 'E005', 'F005', '駕駛超速 40-50 公里'),
('A006', 'C006', 6, '台北市信義區松仁路與信義路交叉口', '2024-12-06 17:30:00', 'E001', 'F006', '駕駛超速學區內 10 公里以上'),
('A007', 'C007', 8, '台北市內湖區康寧路與成功路交叉口', '2024-12-07 19:00:00', 'E002', 'F007', '駕駛高速公路超速 20-40 公里'),
('A008', 'C008', 7, '台北市萬華區桂林路與和平西路交叉口', '2024-12-08 13:10:00', 'E003', 'F008', '駕駛高速公路超速 40 公里以上'),
('A009', 'C009', 1, '台北市中正區忠孝西路與博愛路交叉口', '2024-12-09 11:40:00', 'E004', 'F009', '駕駛超速 10-20 公里'),
('A010', 'C010', 3, '台北市北投區石牌路與承德路交叉口', '2024-12-10 08:25:00', 'E005', 'F010', '駕駛超速 30-40 公里'),
('A011', 'C011', 2, '台北市松山區八德路與民生路交叉口', '2024-12-11 14:10:00', 'E001', 'F011', '駕駛超速 20-30 公里'),
('A012', 'C012', 4, '台北市南港區經貿一路與忠孝東路交叉口', '2024-12-12 10:00:00', 'E002', 'F012', '駕駛超速 40-50 公里'),
('A013', 'C013', 5, '台北市士林區德行路與中山北路交叉口', '2024-12-13 15:45:00', 'E003', 'F013', '駕駛超速 50 公里以上'),
('A014', 'C014', 6, '台北市大安區敦化南路與仁愛路交叉口', '2024-12-14 09:30:00', 'E004', 'F014', '駕駛超速學區內 10 公里以上'),
('A015', 'C015', 7, '台北市中山區民權東路與松江路交叉口', '2024-12-15 13:50:00', 'E005', 'F015', '駕駛高速公路超速 20-40 公里'),
('A016', 'C016', 8, '台北市內湖區新湖一路與成功路交叉口', '2024-12-16 16:20:00', 'E001', 'F016', '駕駛高速公路超速 40 公里以上'),
('A017', 'C017', 2, '台北市萬華區西園路與艋舺大道交叉口', '2024-12-17 11:15:00', 'E002', 'F017', '駕駛超速 20-30 公里'),
('A018', 'C018', 4, '台北市文山區興隆路與木柵路交叉口', '2024-12-18 18:35:00', 'E003', 'F018', '駕駛超速 40-50 公里'),
('A019', 'C019', 5, '台北市北投區中央北路與中山北路交叉口', '2024-12-19 07:50:00', 'E004', 'F019', '駕駛超速 50 公里以上'),
('A020', 'C020', 3, '台北市中正區南海路與濟南路交叉口', '2024-12-20 12:45:00', 'E001', 'F020', '駕駛超速 30-40 公里'),
('A021', 'C021', 2, '台北市信義區基隆路與信義路交叉口', '2024-12-21 09:15:00', 'E002', 'F021', '駕駛超速 20-30 公里'),
('A022', 'C022', 4, '台北市內湖區新湖一路與內湖路交叉口', '2024-12-22 14:40:00', 'E003', 'F022', '駕駛超速 40-50 公里'),
('A023', 'C023', 6, '台北市文山區木柵路與指南路交叉口', '2024-12-23 18:30:00', 'E004', 'F023', '駕駛超速學區內 10 公里以上'),
('A024', 'C024', 3, '台北市大同區延平北路與重慶北路交叉口', '2024-12-24 08:00:00', 'E005', 'F024', '駕駛超速 30-40 公里'),
('A025', 'C025', 5, '台北市內湖區瑞光路與內湖路交叉口', '2024-12-25 11:30:00', 'E001', 'F025', '駕駛超速 50 公里以上'),
('A026', 'C026', 2, '台北市內湖區康寧路與成功路交叉口', '2024-12-26 10:00:00', 'E002', 'F026', '駕駛超速 20-30 公里'),
('A027', 'C027', 4, '台北市松山區民權東路與南京東路交叉口', '2024-12-27 12:15:00', 'E003', 'F027', '駕駛超速 40-50 公里'),
('A028', 'C028', 6, '台北市文山區木柵路與興隆路交叉口', '2024-12-28 15:00:00', 'E004', 'F028', '駕駛超速學區內 10 公里以上'),
('A029', 'C029', 5, '台北市內湖區成功路與康寧路交叉口', '2024-12-29 14:00:00', 'E005', 'F029', '駕駛超速 50 公里以上'),
('A030', 'C030', 3, '台北市大安區忠孝東路與青島東路交叉口', '2024-12-30 16:20:00', 'E001', 'F030', '駕駛超速 30-40 公里'),
('A031', 'C031', 7, '台北市信義區基隆路與信義路交叉口', '2025-01-01 13:10:00', 'E002', 'F031', '駕駛高速公路超速 20-40 公里'),
('A032', 'C032', 8, '台北市北投區石牌路與中央北路交叉口', '2025-01-02 09:00:00', 'E003', 'F032', '駕駛高速公路超速 40 公里以上'),
('A033', 'C033', 2, '台北市中山區南京東路與復興北路交叉口', '2025-01-03 15:25:00', 'E004', 'F033', '駕駛超速 20-30 公里'),
('A034', 'C034', 4, '台北市內湖區瑞光路與內湖路交叉口', '2025-01-04 10:15:00', 'E005', 'F034', '駕駛超速 40-50 公里'),
('A035', 'C035', 6, '台北市士林區中山北路與天母東路交叉口', '2025-01-05 16:30:00', 'E001', 'F035', '駕駛超速學區內 10 公里以上'),
('A036', 'C036', 5, '台北市大安區和平東路與敦化南路交叉口', '2025-01-06 11:40:00', 'E002', 'F036', '駕駛超速 50 公里以上'),
('A037', 'C037', 3, '台北市文山區木柵路與興隆路交叉口', '2025-01-07 18:00:00', 'E003', 'F037', '駕駛超速 30-40 公里'),
('A038', 'C038', 7, '台北市內湖區成功路與康寧路交叉口', '2025-01-08 14:20:00', 'E004', 'F038', '駕駛高速公路超速 20-40 公里'),
('A039', 'C039', 8, '台北市中正區忠孝東路與博愛路交叉口', '2025-01-09 09:10:00', 'E005', 'F039', '駕駛高速公路超速 40 公里以上'),
('A040', 'C040', 2, '台北市北投區石牌路與中山北路交叉口', '2025-01-10 15:30:00', 'E001', 'F040', '駕駛超速 20-30 公里'),
('A041', 'C041', 3, '台北市文山區木柵路與指南路交叉口', '2025-01-11 13:25:00', 'E002', 'F041', '駕駛超速 30-40 公里'),
('A042', 'C042', 5, '台北市信義區基隆路與松高路交叉口', '2025-01-12 10:40:00', 'E003', 'F042', '駕駛超速 50 公里以上'),
('A043', 'C043', 6, '台北市中山區民權東路與松江路交叉口', '2025-01-13 11:55:00', 'E004', 'F043', '駕駛超速學區內 10 公里以上'),
('A044', 'C044', 2, '台北市南港區經貿一路與忠孝東路交叉口', '2025-01-14 12:30:00', 'E005', 'F044', '駕駛超速 20-30 公里'),
('A045', 'C045', 3, '台北市松山區八德路與民生路交叉口', '2025-01-15 14:00:00', 'E001', 'F045', '駕駛超速 30-40 公里'),
('A046', 'C046', 7, '台北市大安區和平東路與敦化南路交叉口', '2025-01-16 16:10:00', 'E002', 'F046', '駕駛高速公路超速 20-40 公里'),
('A047', 'C047', 8, '台北市文山區木柵路與指南路交叉口', '2025-01-17 18:20:00', 'E003', 'F047', '駕駛高速公路超速 40 公里以上'),
('A048', 'C048', 2, '台北市內湖區瑞光路與內湖路交叉口', '2025-01-18 09:30:00', 'E004', 'F048', '駕駛超速 20-30 公里'),
('A049', 'C049', 4, '台北市信義區松高路與基隆路交叉口', '2025-01-19 10:10:00', 'E005', 'F049', '駕駛超速 40-50 公里'),
('A050', 'C050', 3, '台北市中山區長安東路與民生東路交叉口', '2025-01-20 13:15:00', 'E001', 'F050', '駕駛超速 30-40 公里');

select * from 車輛基本資料表;
select * from 車主基本資料表;
select * from 違規型態資料表;
select * from 違規罰單資料表;
select * from 執法人員資料表;
select * from 佐理員資料表;
select * from 違規案件資料表;


DROP VIEW IF EXISTS 案件類型統計;
CREATE VIEW 案件類型統計 AS
SELECT 
    vt.違規名稱 AS 違規類型,
    COUNT(da.案件編號) AS 案件數量,
    ROUND(COUNT(da.案件編號) / (SELECT COUNT(*) FROM 違規案件資料表) * 100, 2) AS 案件類型百分比
FROM 
    違規案件資料表 da
JOIN 
    違規型態資料表 vt ON da.違規類型編號 = vt.違規類型編號
GROUP BY 
    vt.違規名稱;

SELECT * FROM 案件類型統計;

 #---------------------------------------------

DROP VIEW IF EXISTS 月度案件數量趨勢;
CREATE VIEW 月度案件數量趨勢 AS
SELECT 
    DATE_FORMAT(da.違規時間, '%Y-%m') AS 案件月份,
    COUNT(da.案件編號) AS 月度案件數量
FROM 
    違規案件資料表 da
GROUP BY 
    DATE_FORMAT(da.違規時間, '%Y-%m')
ORDER BY 
    月度案件數量 DESC;
    
SELECT * FROM 月度案件數量趨勢;

#--------------------------------

DROP VIEW IF EXISTS 違規統計;
CREATE VIEW 違規統計 AS
SELECT 
    c.車主編號,
    c.姓名 AS 車主姓名,
    COUNT(da.案件編號) AS 違規案件數量
FROM 
    車主基本資料表 c
JOIN 
    車輛基本資料表 v ON c.車主編號 = v.車主編號
JOIN 
    違規案件資料表 da ON v.車輛編號 = da.車輛編號
GROUP BY 
    c.車主編號, c.姓名;

SELECT * FROM 違規統計;

#----------------------------------------------

DROP VIEW IF EXISTS 違規熱點地圖;
CREATE VIEW 違規熱點地圖 AS
SELECT
    da.違規地點, 
    COUNT(da.案件編號) AS 案件數量,
    pf.照相地點經度 AS 經度,
    pf.照相地點緯度 AS 緯度
FROM
    違規罰單資料表 pf
JOIN
    違規案件資料表 da ON pf.罰單編號 = da.罰單編號
GROUP BY
    da.違規地點, pf.照相地點經度, pf.照相地點緯度
ORDER BY
    案件數量 DESC;

SELECT * FROM 違規熱點地圖;

#--------------------------------------------------
DROP VIEW IF EXISTS 違規車種分布;
CREATE VIEW 違規車種分布 AS
SELECT 
    車種,
    COUNT(da.案件編號) AS 案件數量,
    ROUND(COUNT(da.案件編號) / (SELECT COUNT(*) FROM 違規案件資料表) * 100, 2) AS 百分比
FROM 
    車輛基本資料表 v
JOIN 
    違規案件資料表 da ON v.車輛編號 = da.車輛編號
GROUP BY 
    車種
ORDER BY 
    案件數量 DESC;

SELECT * FROM 違規車種分布;
#---------------------------------------------------
DROP VIEW IF EXISTS 超速情況分類;
CREATE VIEW 超速情況分類 AS
SELECT 
    vt.違規名稱 AS 超速類型,
    COUNT(da.案件編號) AS 案件數量
FROM 
    違規型態資料表 vt
JOIN 
    違規案件資料表 da ON vt.違規類型編號 = da.違規類型編號
WHERE 
    vt.處罰分類 = '交通安全' AND vt.違規名稱 LIKE '超速%'
GROUP BY 
    vt.違規名稱
ORDER BY 
    案件數量 DESC;

SELECT * FROM 超速情況分類;
#---------------------------------------
DROP VIEW IF EXISTS 違規時段分布;
CREATE VIEW 違規時段分布 AS
SELECT 
    CASE 
        WHEN HOUR(違規時間) BETWEEN 0 AND 6 THEN '凌晨(0-6)'
        WHEN HOUR(違規時間) BETWEEN 7 AND 12 THEN '早上(7-12)'
        WHEN HOUR(違規時間) BETWEEN 13 AND 18 THEN '下午(13-18)'
        ELSE '晚上(19-23)'
    END AS 時段,
    COUNT(案件編號) AS 案件數量
FROM 
    違規案件資料表
GROUP BY 
    時段
ORDER BY 
    FIELD(時段, '凌晨(0-6)', '早上(7-12)', '下午(13-18)', '晚上(19-23)');

SELECT * FROM 違規時段分布;

#---------------------------------------------------------
DROP VIEW IF EXISTS 區域案件分布;
CREATE VIEW 區域案件分布 AS
SELECT 
    SUBSTRING_INDEX(違規地點, '區', 1) AS 行政區,
    COUNT(案件編號) AS 案件數量,
    ROUND(COUNT(案件編號) / (SELECT COUNT(*) FROM 違規案件資料表) * 100, 2) AS 百分比
FROM 
    違規案件資料表
GROUP BY 
    行政區
ORDER BY 
    案件數量 DESC;

SELECT * FROM 區域案件分布;

#----------------------------------------------------------
DROP VIEW IF EXISTS 年度車種違規趨勢;
CREATE VIEW 年度車種違規趨勢 AS
SELECT 
    YEAR(da.違規時間) AS 年度,
    v.車種,
    COUNT(da.案件編號) AS 案件數量
FROM 
    車輛基本資料表 v
JOIN 
    違規案件資料表 da ON v.車輛編號 = da.車輛編號
GROUP BY 
    YEAR(da.違規時間), v.車種
ORDER BY 
    年度, 案件數量 DESC;

SELECT * FROM 年度車種違規趨勢;

#----------------------------------------------------------
DROP VIEW IF EXISTS 違規高風險地點;
CREATE VIEW 違規高風險地點 AS
SELECT 
    違規地點,
    COUNT(案件編號) AS 過去案件數量,
    CASE 
        WHEN COUNT(案件編號) > 50 THEN '高風險'
        WHEN COUNT(案件編號) BETWEEN 20 AND 50 THEN '中風險'
        ELSE '低風險'
    END AS 風險等級
FROM 
    違規案件資料表
GROUP BY 
    違規地點
ORDER BY 
    過去案件數量 DESC;


#------------------------------------------------
DROP VIEW IF EXISTS 年度區域違規排行;
CREATE VIEW 年度區域違規排行 AS
SELECT 
    YEAR(違規時間) AS 年度,
    SUBSTRING_INDEX(違規地點, '區', 1) AS 行政區,
    COUNT(案件編號) AS 案件數量
FROM 
    違規案件資料表
GROUP BY 
    年度, 行政區
ORDER BY 
    年度, 案件數量 DESC;

SELECT * FROM 年度區域違規排行;
#--------------------------------------

SELECT 
    CASE 
        WHEN HOUR(違規時間) BETWEEN 0 AND 6 THEN '凌晨(0-6)'
        WHEN HOUR(違規時間) BETWEEN 7 AND 12 THEN '早上(7-12)'
        WHEN HOUR(違規時間) BETWEEN 13 AND 18 THEN '下午(13-18)'
        ELSE '晚上(19-23)'
    END AS 時段,
    COUNT(案件編號) AS 案件數量
FROM 
    違規案件資料表
GROUP BY 
    時段
ORDER BY 
    FIELD(時段, '凌晨(0-6)', '早上(7-12)', '下午(13-18)', '晚上(19-23)');

#----------------------------------------------按車種和時段分類違規案件  
SELECT 
    車種 AS x_axis,
    CASE 
        WHEN HOUR(違規時間) BETWEEN 0 AND 6 THEN '凌晨(0-6)'
        WHEN HOUR(違規時間) BETWEEN 7 AND 12 THEN '早上(7-12)'
        WHEN HOUR(違規時間) BETWEEN 13 AND 18 THEN '下午(13-18)'
        ELSE '晚上(19-23)'
    END AS y_axis,
    COUNT(案件編號) AS data
FROM 
    車輛基本資料表 v
JOIN 
    違規案件資料表 da ON v.車輛編號 = da.車輛編號
GROUP BY 
    車種, y_axis
ORDER BY 
    車種, FIELD(y_axis, '凌晨(0-6)', '早上(7-12)', '下午(13-18)', '晚上(19-23)');


#--------------------------------------行政區與案件類型的案件數量分布
SELECT 
    SUBSTRING_INDEX(違規地點, '區', 1) AS x_axis,
    vt.違規名稱 AS y_axis,
    COUNT(案件編號) AS data
FROM 
    違規案件資料表 da
JOIN 
    違規型態資料表 vt ON da.違規類型編號 = vt.違規類型編號
GROUP BY 
    x_axis, y_axis
ORDER BY 
    x_axis, data DESC;

#-------------------------------- 年度與車種的案件數量分布
SELECT 
    YEAR(違規時間) AS x_axis,
    車種 AS y_axis,
    COUNT(案件編號) AS data
FROM 
    車輛基本資料表 v
JOIN 
    違規案件資料表 da ON v.車輛編號 = da.車輛編號
GROUP BY 
    x_axis, y_axis
ORDER BY 
    x_axis, data DESC;
#---------------------------------------------年度與違規類型的案件數量分布
SELECT 
    YEAR(違規時間) AS x_axis,
    vt.違規名稱 AS y_axis,
    COUNT(案件編號) AS data
FROM 
    違規案件資料表 da
JOIN 
    違規型態資料表 vt ON da.違規類型編號 = vt.違規類型編號
GROUP BY 
    x_axis, y_axis
ORDER BY 
    x_axis, data DESC;
#-------------------------------------------------------高頻違規地點與時段的分布
SELECT 
    違規地點 AS x_axis,
    CASE 
        WHEN HOUR(違規時間) BETWEEN 0 AND 6 THEN '凌晨(0-6)'
        WHEN HOUR(違規時間) BETWEEN 7 AND 12 THEN '早上(7-12)'
        WHEN HOUR(違規時間) BETWEEN 13 AND 18 THEN '下午(13-18)'
        ELSE '晚上(19-23)'
    END AS y_axis,
    COUNT(案件編號) AS data
FROM 
    違規案件資料表
GROUP BY 
    x_axis, y_axis
ORDER BY 
    data DESC
LIMIT 10;

#-------------------------------------------行政區違規率
SELECT 
    SUBSTRING_INDEX(違規地點, '區', 1) AS x_axis,
    COUNT(案件編號) AS y_axis,
    ROUND(COUNT(案件編號) / (SELECT COUNT(*) FROM 違規案件資料表) * 100, 2) AS data
FROM 
    違規案件資料表
GROUP BY 
    x_axis
ORDER BY 
    y_axis DESC;

#---------------------------------------------違規天數分布 (星期幾最多違規)
SELECT 
    CASE DAYOFWEEK(違規時間)
        WHEN 1 THEN '星期日'
        WHEN 2 THEN '星期一'
        WHEN 3 THEN '星期二'
        WHEN 4 THEN '星期三'
        WHEN 5 THEN '星期四'
        WHEN 6 THEN '星期五'
        ELSE '星期六'
    END AS x_axis,
    COUNT(案件編號) AS y_axis,
    ROUND(COUNT(案件編號) / (SELECT COUNT(*) FROM 違規案件資料表) * 100, 2) AS data
FROM 
    違規案件資料表
GROUP BY 
    x_axis
ORDER BY 
    y_axis DESC;

#--------------------------------------------模擬天氣影響

ALTER TABLE 違規案件資料表 ADD COLUMN 天氣狀況 VARCHAR(20);
SET SQL_SAFE_UPDATES = 0;

UPDATE 違規案件資料表 
SET 天氣狀況 = CASE
    -- 春季 (3-5月)
    WHEN MONTH(違規時間) BETWEEN 3 AND 5 THEN 
        CASE
            WHEN RAND() < 0.3 THEN '晴天'
            WHEN RAND() BETWEEN 0.3 AND 0.6 THEN '雨天'
            ELSE '陰天'
        END
    -- 夏季 (6-8月)
    WHEN MONTH(違規時間) BETWEEN 6 AND 8 THEN 
        CASE
            WHEN RAND() < 0.6 THEN '晴天'
            WHEN RAND() BETWEEN 0.6 AND 0.8 THEN '雨天'
            ELSE '陰天'
        END
    -- 秋季 (9-11月)
    WHEN MONTH(違規時間) BETWEEN 9 AND 11 THEN 
        CASE
            WHEN RAND() < 0.5 THEN '晴天'
            WHEN RAND() BETWEEN 0.5 AND 0.7 THEN '雨天'
            ELSE '陰天'
        END
    -- 冬季 (12-2月)
    ELSE 
        CASE
            WHEN RAND() < 0.4 THEN '晴天'
            WHEN RAND() BETWEEN 0.4 AND 0.6 THEN '雨天'
            ELSE '陰天'
        END
END
WHERE 案件編號 BETWEEN 'A001' AND 'A500';

SELECT 天氣狀況, COUNT(*) AS 案件數量
FROM 違規案件資料表
GROUP BY 天氣狀況;
#-------------------------------------天氣對違規案件的影響分析
SELECT 
    天氣狀況 AS x_axis,
    COUNT(案件編號) AS y_axis,
    ROUND(COUNT(案件編號) / (SELECT COUNT(*) FROM 違規案件資料表) * 100, 2) AS data
FROM 
    違規案件資料表
GROUP BY 
    天氣狀況
ORDER BY 
    y_axis DESC;
#-------------------------------------天氣與不同違規類型的關聯
SELECT 
    天氣狀況 AS x_axis,
    vt.違規名稱 AS y_axis,
    COUNT(da.案件編號) AS data
FROM 
    違規案件資料表 da
JOIN 
    違規型態資料表 vt ON da.違規類型編號 = vt.違規類型編號
GROUP BY 
    天氣狀況, vt.違規名稱
ORDER BY 
    天氣狀況, data DESC;
#------------------------------------- 天氣與高風險地點分析
SELECT 
    天氣狀況 AS x_axis,
    違規地點 AS y_axis,
    COUNT(案件編號) AS data
FROM 
    違規案件資料表
GROUP BY 
    天氣狀況, 違規地點
ORDER BY 
    x_axis, data DESC
LIMIT 10;
#------------------------------------月度天氣與違規趨勢
SELECT 
    DATE_FORMAT(違規時間, '%Y-%m') AS x_axis,
    天氣狀況 AS y_axis,
    COUNT(案件編號) AS data
FROM 
    違規案件資料表
GROUP BY 
    DATE_FORMAT(違規時間, '%Y-%m'), 天氣狀況
ORDER BY 
    x_axis, y_axis;

#----------------------------------------天氣與車種違規分析
SELECT 
    天氣狀況 AS x_axis,
    v.車種 AS y_axis,
    COUNT(da.案件編號) AS data
FROM 
    違規案件資料表 da
JOIN 
    車輛基本資料表 v ON da.車輛編號 = v.車輛編號
GROUP BY 
    天氣狀況, v.車種
ORDER BY 
    x_axis, data DESC;

#-----------------------------------------------------天氣對違規時段分布的影響
SELECT 
    CASE 
        WHEN HOUR(違規時間) BETWEEN 0 AND 6 THEN '凌晨(0-6)'
        WHEN HOUR(違規時間) BETWEEN 7 AND 12 THEN '早上(7-12)'
        WHEN HOUR(違規時間) BETWEEN 13 AND 18 THEN '下午(13-18)'
        ELSE '晚上(19-23)'
    END AS x_axis,
    天氣狀況 AS y_axis,
    COUNT(案件編號) AS data
FROM 
    違規案件資料表
GROUP BY 
    x_axis, 天氣狀況
ORDER BY 
    x_axis, data DESC;

#-----------------------------------------------天氣與違規速度分析
SELECT 
    天氣狀況 AS x_axis,
    ROUND(AVG(實際時速 - 當地限速), 2) AS y_axis, 
    COUNT(案件編號) AS data
FROM 
    違規罰單資料表 pf
JOIN 
    違規案件資料表 da ON pf.罰單編號 = da.罰單編號
GROUP BY 
    天氣狀況
ORDER BY 
    y_axis DESC;

#----------------------------地區天氣違規次數

SELECT 
    SUBSTRING_INDEX(違規地點, '區', 1) AS x_axis, -- 地區作為 X 軸
    天氣狀況 AS y_axis,                         -- 天氣作為 Y 軸
    COUNT(案件編號) AS data                     -- 違規次數作為數據
FROM 
    違規案件資料表
GROUP BY 
    x_axis, y_axis
ORDER BY 
    data DESC;







