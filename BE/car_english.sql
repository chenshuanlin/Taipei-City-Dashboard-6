CREATE DATABASE IF NOT EXISTS SpeedingViolationSystem
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE SpeedingViolationSystem;

SET foreign_key_checks = 0;

DROP TABLE IF EXISTS OwnerBasicInfo;
DROP TABLE IF EXISTS VehicleBasicInfo;
DROP TABLE IF EXISTS ViolationTypeInfo;
DROP TABLE IF EXISTS EnforcementOfficerInfo;
DROP TABLE IF EXISTS AssistantInfo;
DROP TABLE IF EXISTS ViolationTicketInfo;
DROP TABLE IF EXISTS PrintFileInfo;
DROP TABLE IF EXISTS ViolationCaseInfo;

CREATE TABLE OwnerBasicInfo (
    OwnerID VARCHAR(10) PRIMARY KEY,  
    Name VARCHAR(50) NOT NULL,        
    IDNumber VARCHAR(20) NOT NULL UNIQUE,  
    PhoneNumber VARCHAR(20),         
    Address VARCHAR(100)             
);

CREATE TABLE TrafficViolationReport (
    ReportID INT AUTO_INCREMENT PRIMARY KEY COMMENT 'Unique identifier',
    ReporterName VARCHAR(100) COMMENT 'Name of the reporter',
    IDNumber VARCHAR(20) COMMENT 'ID number',
    Email VARCHAR(255) COMMENT 'Email address',
    ContactNumber VARCHAR(15) COMMENT 'Contact number',
    ViolationLocation VARCHAR(255) COMMENT 'Location of the violation',
    ViolationTime DATETIME COMMENT 'Time of the violation',
    LicensePlate VARCHAR(20) COMMENT 'License plate number',
    ViolationDetails VARCHAR(255) COMMENT 'Violation details',
    ViolationPhoto BLOB COMMENT 'Violation photo',
    ViolationDescription TEXT COMMENT 'Description of the violation',
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
    UpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Traffic Violation Report';

CREATE TABLE VehicleBasicInfo (
    VehicleID VARCHAR(10) PRIMARY KEY, 
    LicensePlate VARCHAR(10),            
    OwnerID VARCHAR(10),                
    Brand VARCHAR(20),                   
    Model VARCHAR(20),                   
    Color VARCHAR(20),                   
    VehicleType VARCHAR(20),             
    FOREIGN KEY (OwnerID) REFERENCES OwnerBasicInfo(OwnerID)
);

CREATE TABLE ViolationTypeInfo (
    ViolationTypeID INT PRIMARY KEY AUTO_INCREMENT,  
    ViolationName VARCHAR(100),                     
    ViolationDescription TEXT,                      
    PenaltyCategory VARCHAR(50),                    
    FineAmount DECIMAL(10, 2)                       
);

CREATE TABLE EnforcementOfficerInfo (
    OfficerID VARCHAR(10) PRIMARY KEY,
	Password VARCHAR(255) NOT NULL,
    OfficerName VARCHAR(50),
    OfficerDepartment VARCHAR(50)
);

CREATE TABLE AssistantInfo (
    AssistantID VARCHAR(10) PRIMARY KEY,
	Password VARCHAR(255) NOT NULL,
    AssistantName VARCHAR(50),
    AssistantDepartment VARCHAR(50)
);


CREATE TABLE ViolationTicketInfo (
    TicketID VARCHAR(20) PRIMARY KEY,  
    VehicleID VARCHAR(10),            
    ViolationTypeID INT,             
    ViolationLocation VARCHAR(100),   
    ViolationTime DATETIME,          
    OfficerID VARCHAR(10),           
    PhotoLocation VARCHAR(100),      
    PhotoLongitude DECIMAL(10, 6),   
    PhotoLatitude DECIMAL(10, 6),    
    ViolationPhoto LONGBLOB,         
    IssuingUnit VARCHAR(100),        
    SpeedLimit INT,                  
    ActualSpeed INT,                 
    CameraID VARCHAR(20),            
    FOREIGN KEY (VehicleID) REFERENCES VehicleBasicInfo(VehicleID),
    FOREIGN KEY (ViolationTypeID) REFERENCES ViolationTypeInfo(ViolationTypeID),
    FOREIGN KEY (OfficerID) REFERENCES EnforcementOfficerInfo(OfficerID)
);
CREATE TABLE ViolationCaseInfo (
    CaseID VARCHAR(20) PRIMARY KEY,                 -- 案件編號
    LicensePlate VARCHAR(15),                      -- 車牌號碼
    ViolationTime DATETIME,                        -- 違規時間 (包含日期與時間)
    ViolationLocation VARCHAR(255),               -- 違規地點
    CaseDescription TEXT,                         -- 案件描述
    Status ENUM('已繳費', '未繳費') NOT NULL,        -- 案件狀態
    ViolationTypeID INT,                          -- 外鍵，參考違規類型表
    VehicleID VARCHAR(10),                                -- 外鍵，參考車輛基本信息
	AssistantID VARCHAR(10),                         -- 外鍵，參考協助人員信息
    TicketID VARCHAR(20),                                 -- 外鍵，參考罰單信息
    FOREIGN KEY (VehicleID) REFERENCES VehicleBasicInfo(VehicleID) ON DELETE CASCADE,
    FOREIGN KEY (ViolationTypeID) REFERENCES ViolationTypeInfo(ViolationTypeID) ON DELETE CASCADE,
    FOREIGN KEY (AssistantID) REFERENCES AssistantInfo(AssistantID) ON DELETE SET NULL,
    FOREIGN KEY (TicketID) REFERENCES ViolationTicketInfo(TicketID) ON DELETE SET NULL
);


CREATE TABLE PrintFileInfo (
    PrintID VARCHAR(10) PRIMARY KEY,
    ListID VARCHAR(10),
    PrintDate DATE,
    PrintTime TIME
);

INSERT INTO VehicleBasicInfo (VehicleID, LicensePlate, OwnerID, Brand, Model, Color, VehicleType) VALUES
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

INSERT INTO OwnerBasicInfo (OwnerID, Name, IDNumber, PhoneNumber, Address) VALUES
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

INSERT INTO ViolationTypeInfo (ViolationTypeID, ViolationName, ViolationDescription, PenaltyCategory, FineAmount) VALUES
(1, '超速 10-20 公里', '駕駛速度超過法定限速 10 至 20 公里', '交通安全', 1500.00),
(2, '超速 20-30 公里', '駕駛速度超過法定限速 20 至 30 公里', '交通安全', 2000.00),
(3, '超速 30-40 公里', '駕駛速度超過法定限速 30 至 40 公里', '交通安全', 3000.00),
(4, '超速 40-50 公里', '駕駛速度超過法定限速 40 至 50 公里', '交通安全', 4000.00),
(5, '超速 50 公里以上', '駕駛速度超過法定限速 50 公里以上', '交通安全', 5000.00),
(6, '超速學區內 10 公里以上', '學區內駕駛速度超過法定限速 10 公里以上', '交通安全', 3000.00),
(7, '高速公路超速 20-40 公里', '高速公路駕駛速度超過法定限速 20 至 40 公里', '交通安全', 4000.00),
(8, '高速公路超速 40 公里以上', '高速公路駕駛速度超過法定限速 40 公里以上', '交通安全', 6000.00);

INSERT INTO ViolationCaseInfo (CaseID, VehicleID, LicensePlate, ViolationTypeID, ViolationLocation, ViolationTime, AssistantID, TicketID, CaseDescription, Status) 
VALUES
('A001', 'C001', '123 SKT', 1, '台北市信義區松高路與基隆路交叉口', '2024-12-01 14:35:00', 'E001', 'F001', '駕駛超速 10-20 公里', '已繳費'),
('A002', 'C002', 'JRX-4176', 3, '台北市中山區南京東路與復興北路交叉口', '2024-12-02 16:20:00', 'E002', 'F002', '駕駛超速 30-40 公里', '已繳費'),
('A003', 'C003', 'VVJ-808', 5, '台北市士林區中山北路與天母東路交叉口', '2024-12-03 10:50:00', 'E003', 'F003', '駕駛超速 50 公里以上', '未繳費'),
('A004', 'C004', 'MBZ-1898', 2, '台北市大安區和平東路與敦化南路交叉口', '2024-12-04 12:15:00', 'E004', 'F004', '駕駛超速 20-30 公里', '未繳費'),
('A005', 'C005', '6042 ZP', 4, '台北市文山區木柵路與興隆路交叉口', '2024-12-05 09:45:00', 'E005', 'F005', '駕駛超速 40-50 公里', '未繳費'),
('A006', 'C006', '035-TWM', 6, '台北市信義區松仁路與信義路交叉口', '2024-12-06 17:30:00', 'E001', 'F006', '駕駛超速學區內 10 公里以上', '已繳費'),
('A007', 'C007', 'HEW-9474', 8, '台北市內湖區康寧路與成功路交叉口', '2024-12-07 19:00:00', 'E002', 'F007', '駕駛高速公路超速 20-40 公里', '未繳費'),
('A008', 'C008', 'VHW 228', 7, '台北市萬華區桂林路與和平西路交叉口', '2024-12-08 13:10:00', 'E003', 'F008', '駕駛高速公路超速 40 公里以上', '已繳費'),
('A009', 'C009', 'EDA-021', 1, '台北市中正區忠孝西路與博愛路交叉口', '2024-12-09 11:40:00', 'E004', 'F009', '駕駛超速 10-20 公里', '已繳費'),
('A010', 'C010', '055-EYR', 3, '台北市北投區石牌路與承德路交叉口', '2024-12-10 08:25:00', 'E005', 'F010', '駕駛超速 30-40 公里', '已繳費'),
('A011', 'C011', 'WLP 431', 2, '台北市松山區八德路與民生路交叉口', '2024-12-11 14:10:00', 'E001', 'F011', '駕駛超速 20-30 公里', '已繳費'),
('A012', 'C012', 'USA1707', 4, '台北市南港區經貿一路與忠孝東路交叉口', '2024-12-12 10:00:00', 'E002', 'F012', '駕駛超速 40-50 公里', '已繳費'),
('A013', 'C013', 'E34 3FO', 5, '台北市士林區德行路與中山北路交叉口', '2024-12-13 15:45:00', 'E003', 'F013', '駕駛超速 50 公里以上', '已繳費'),
('A014', 'C014', '3093', 6, '台北市大安區敦化南路與仁愛路交叉口', '2024-12-14 09:30:00', 'E004', 'F014', '駕駛超速學區內 10 公里以上', '已繳費'),
('A015', 'C015', '112 9MT', 7, '台北市中山區民權東路與松江路交叉口', '2024-12-15 13:50:00', 'E005', 'F015', '駕駛高速公路超速 20-40 公里', '已繳費'),
('A016', 'C016', '9MZ 982', 8, '台北市內湖區新湖一路與成功路交叉口', '2024-12-16 16:20:00', 'E001', 'F016', '駕駛高速公路超速 40 公里以上', '已繳費'),
('A017', 'C017', '6297', 2, '台北市萬華區西園路與艋舺大道交叉口', '2024-12-17 11:15:00', 'E002', 'F017', '駕駛超速 20-30 公里', '未繳費'),
('A018', 'C018', '534CXI', 4, '台北市文山區興隆路與木柵路交叉口', '2024-12-18 18:35:00', 'E003', 'F018', '駕駛超速 40-50 公里', '未繳費'),
('A019', 'C019', 'SE9 5840', 5, '台北市北投區中央北路與中山北路交叉口', '2024-12-19 07:50:00', 'E004', 'F019', '駕駛超速 50 公里以上', '未繳費'),
('A020', 'C020', '331-YZL', 3, '台北市中正區南海路與濟南路交叉口', '2024-12-20 12:45:00', 'E001', 'F020', '駕駛超速 30-40 公里', '未繳費'),
('A021', 'C021', 'KIR 933', 1, '台北市信義區基隆路與光復南路交叉口', '2024-12-21 14:15:00', 'E002', 'F021', '駕駛超速 10-20 公里', '未繳費'),
('A022', 'C022', '51-J210', 2, '台北市內湖區舊宗路與瑞光路交叉口', '2024-12-22 13:25:00', 'E003', 'F022', '駕駛超速 20-30 公里', '已繳費'),
('A023', 'C023', 'TJJ-0441', 3, '台北市士林區福德路與承德路交叉口', '2024-12-23 09:10:00', 'E004', 'F023', '駕駛超速 30-40 公里', '未繳費'),
('A024', 'C024', '166-MUG', 4, '台北市大安區和平東路與新生南路交叉口', '2024-12-24 16:50:00', 'E005', 'F024', '駕駛超速 40-50 公里', '已繳費'),
('A025', 'C025', '97-9742A', 5, '台北市中山區南京東路與松江路交叉口', '2024-12-25 11:20:00', 'E001', 'F025', '駕駛超速 50 公里以上', '已繳費'),
('A026', 'C026', '2CT8670', 6, '台北市中正區忠孝西路與林森南路交叉口', '2024-12-26 18:10:00', 'E002', 'F026', '駕駛超速學區內 10 公里以上', '已繳費'),
('A027', 'C027', '3EWY276', 7, '台北市萬華區西園路與桂林路交叉口', '2024-12-27 07:35:00', 'E003', 'F027', '駕駛高速公路超速 20-40 公里', '已繳費'),
('A028', 'C028', '4TH9369', 8, '台北市北投區承德路與中央北路交叉口', '2024-12-28 15:30:00', 'E004', 'F028', '駕駛高速公路超速 40 公里以上', '未繳費'),
('A029', 'C029', '0LV J85', 1, '台北市南港區忠孝東路與松山路交叉口', '2024-12-29 14:00:00', 'E005', 'F029', '駕駛超速 10-20 公里', '未繳費'),
('A030', 'C030', '7567', 2, '台北市信義區松山路與永吉路交叉口', '2024-12-30 10:40:00', 'E001', 'F030', '駕駛超速 20-30 公里', '未繳費'),
('A031', 'C031', '4U 6744T', 3, '台北市中山區林森北路與南京東路交叉口', '2024-12-31 18:45:00', 'E002', 'F031', '駕駛超速 30-40 公里', '未繳費'),
('A032', 'C032', '456 FBU', 4, '台北市大安區新生南路與羅斯福路交叉口', '2025-01-01 12:00:00', 'E003', 'F032', '駕駛超速 40-50 公里', '未繳費'),
('A033', 'C033', 'Q40 8KS', 5, '台北市北投區中山北路與德行路交叉口', '2025-01-02 10:20:00', 'E004', 'F033', '駕駛超速 50 公里以上', '未繳費'),
('A034', 'C034', '37T G58', 6, '台北市萬華區桂林路與和平西路交叉口', '2025-01-03 09:50:00', 'E005', 'F034', '駕駛超速學區內 10 公里以上', '已繳費'),
('A035', 'C035', '249 QW6', 7, '台北市士林區天母東路與中山北路交叉口', '2025-01-04 14:25:00', 'E001', 'F035', '駕駛高速公路超速 20-40 公里', '未繳費'),
('A036', 'C036', '5TG 123', 8, '台北市松山區光復南路與忠孝東路交叉口', '2025-01-05 13:40:00', 'E002', 'F036', '駕駛高速公路超速 40 公里以上', '已繳費'),
('A037', 'C037', 'RKL 335', 1, '台北市信義區松高路與基隆路交叉口', '2025-01-06 14:35:00', 'E003', 'F037', '駕駛超速 10-20 公里', '未繳費'),
('A038', 'C038', '79XE866', 2, '台北市中山區南京東路與復興北路交叉口', '2025-01-07 16:20:00', 'E004', 'F038', '駕駛超速 20-30 公里', '已繳費'),
('A039', 'C039', '85Y V11', 3, '台北市士林區中山北路與天母東路交叉口', '2025-01-08 10:50:00', 'E005', 'F039', '駕駛超速 30-40 公里', '已繳費'),
('A040', 'C040', '0MO 899', 4, '台北市大安區和平東路與敦化南路交叉口', '2025-01-09 12:15:00', 'E001', 'F040', '駕駛超速 40-50 公里', '未繳費'),
('A041', 'C041', '0L 0362X', 5, '台北市文山區木柵路與興隆路交叉口', '2025-01-10 09:45:00', 'E002', 'F041', '駕駛超速 50 公里以上', '已繳費'),
('A042', 'C042', '949-ZOI', 6, '台北市信義區松仁路與信義路交叉口', '2025-01-11 17:30:00', 'E003', 'F042', '駕駛超速學區內 10 公里以上', '未繳費'),
('A043', 'C043', '2-J7320', 7, '台北市內湖區康寧路與成功路交叉口', '2025-01-12 19:00:00', 'E004', 'F043', '駕駛高速公路超速 20-40 公里', '未繳費'),
('A044', 'C044', 'B11 7LW', 8, '台北市萬華區桂林路與和平西路交叉口', '2025-01-13 13:10:00', 'E005', 'F044', '駕駛高速公路超速 40 公里以上', '已繳費'),
('A045', 'C045', 'UZY-842', 1, '台北市中正區忠孝西路與博愛路交叉口', '2025-01-14 11:40:00', 'E001', 'F045', '駕駛超速 10-20 公里', '未繳費'),
('A046', 'C046', '48FF122', 2, '台北市北投區石牌路與承德路交叉口', '2025-01-15 08:25:00', 'E002', 'F046', '駕駛超速 20-30 公里', '已繳費'),
('A047', 'C047', '914-500', 3, '台北市松山區八德路與民生路交叉口', '2025-01-16 14:10:00', 'E003', 'F047', '駕駛超速 30-40 公里', '未繳費'),
('A048', 'C048', 'D37 5IH', 4, '台北市南港區經貿一路與忠孝東路交叉口', '2025-01-17 10:00:00', 'E004', 'F048', '駕駛超速 40-50 公里', '已繳費'),
('A049', 'C049', 'T21 9WZ', 5, '台北市士林區德行路與中山北路交叉口', '2025-01-18 15:45:00', 'E005', 'F049', '駕駛超速 50 公里以上', '未繳費'),
('A050', 'C050', '686 3HM', 6, '台北市大安區敦化南路與仁愛路交叉口', '2025-01-19 09:30:00', 'E001', 'F050', '駕駛超速學區內 10 公里以上', '已繳費');

INSERT INTO ViolationTicketInfo (
    TicketID, VehicleID, ViolationTypeID, ViolationLocation, ViolationTime, OfficerID, PhotoLocation, PhotoLongitude, PhotoLatitude, ViolationPhoto, IssuingUnit, SpeedLimit, ActualSpeed, CameraID
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


INSERT INTO AssistantInfo (AssistantID, AssistantName, AssistantDepartment,Password) VALUES
('L001', '李偉民', '台北市警察局交通大隊','0000'),
('L002', '王家豪', '台北市警察局交通大隊','0000'),
('L003', '張淑芬', '台北市警察局交通大隊','0000'),
('L004', '陳建宏', '台北市警察局交通大隊','0000'),
('L005', '林筱薇', '台北市警察局交通大隊','0000');

INSERT INTO EnforcementOfficerInfo (OfficerID, OfficerName, OfficerDepartment,Password) VALUES
('L001', '李偉民', '台北市警察局交通大隊','0000'),
('L002', '王家豪', '台北市警察局交通大隊','0000'),
('L003', '張淑芬', '台北市警察局交通大隊','0000'),
('L004', '陳建宏', '台北市警察局交通大隊','0000'),
('L005', '林筱薇', '台北市警察局交通大隊','0000');

SELECT * FROM VehicleBasicInfo;
SELECT * FROM OwnerBasicInfo;
SELECT * FROM ViolationTypeInfo;
SELECT * FROM ViolationTicketInfo;
SELECT * FROM EnforcementOfficerInfo;

SELECT * FROM AssistantInfo;

SELECT * FROM ViolationCaseInfo;


-- Case Type Statistics View
DROP VIEW IF EXISTS CaseTypeStatistics;
CREATE VIEW CaseTypeStatistics AS
SELECT 
    vt.ViolationName AS ViolationType,
    COUNT(da.CaseID) AS CaseCount,
    ROUND(COUNT(da.CaseID) / (SELECT COUNT(*) FROM ViolationCaseInfo) * 100, 2) AS CaseTypePercentage
FROM 
    ViolationCaseInfo da
JOIN 
    ViolationTypeInfo vt ON da.ViolationTypeID = vt.ViolationTypeID
GROUP BY 
    vt.ViolationName;

SELECT * FROM CaseTypeStatistics;

-- Monthly Case Trend View
DROP VIEW IF EXISTS MonthlyCaseTrend;
CREATE VIEW MonthlyCaseTrend AS
SELECT 
    DATE_FORMAT(da.ViolationTime, '%Y-%m') AS CaseMonth,
    COUNT(da.CaseID) AS MonthlyCaseCount
FROM 
    ViolationCaseInfo da
GROUP BY 
    DATE_FORMAT(da.ViolationTime, '%Y-%m')
ORDER BY 
    MonthlyCaseCount DESC;

SELECT * FROM MonthlyCaseTrend;

-- Violation Statistics View
DROP VIEW IF EXISTS ViolationStatistics;
CREATE VIEW ViolationStatistics AS
SELECT 
    o.OwnerID,
    o.Name AS OwnerName,
    COUNT(da.CaseID) AS ViolationCaseCount
FROM 
    OwnerBasicInfo o
JOIN 
    VehicleBasicInfo v ON o.OwnerID = v.OwnerID
JOIN 
    ViolationCaseInfo da ON v.VehicleID = da.VehicleID
GROUP BY 
    o.OwnerID, o.Name;

SELECT * FROM ViolationStatistics;

-- Violation Hotspot Map View
DROP VIEW IF EXISTS ViolationHotspotMap;
CREATE VIEW ViolationHotspotMap AS
SELECT
    da.ViolationLocation, 
    COUNT(da.CaseID) AS CaseCount,
    pf.CameraLongitude AS Longitude,
    pf.CameraLatitude AS Latitude
FROM
    ViolationTicketInfo pf
JOIN
    ViolationCaseInfo da ON pf.TicketID = da.TicketID
GROUP BY
    da.ViolationLocation, pf.CameraLongitude, pf.CameraLatitude
ORDER BY
    CaseCount DESC;

SELECT * FROM ViolationHotspotMap;

-- Vehicle Type Distribution View
DROP VIEW IF EXISTS VehicleTypeDistribution;
CREATE VIEW VehicleTypeDistribution AS
SELECT 
    VehicleType,
    COUNT(da.CaseID) AS CaseCount,
    ROUND(COUNT(da.CaseID) / (SELECT COUNT(*) FROM ViolationCaseInfo) * 100, 2) AS Percentage
FROM 
    VehicleBasicInfo v
JOIN 
    ViolationCaseInfo da ON v.VehicleID = da.VehicleID
GROUP BY 
    VehicleType
ORDER BY 
    CaseCount DESC;

SELECT * FROM VehicleTypeDistribution;

-- Speeding Classification View
DROP VIEW IF EXISTS SpeedingClassification;
CREATE VIEW SpeedingClassification AS
SELECT 
    vt.ViolationName AS SpeedingType,
    COUNT(da.CaseID) AS CaseCount
FROM 
    ViolationTypeInfo vt
JOIN 
    ViolationCaseInfo da ON vt.ViolationTypeID = da.ViolationTypeID
WHERE 
    vt.PenaltyCategory = 'Traffic Safety' AND vt.ViolationName LIKE 'Speeding%'
GROUP BY 
    vt.ViolationName
ORDER BY 
    CaseCount DESC;

SELECT * FROM SpeedingClassification;

-- Violation Time Period Distribution View
DROP VIEW IF EXISTS ViolationTimePeriodDistribution;
CREATE VIEW ViolationTimePeriodDistribution AS
SELECT 
    CASE 
        WHEN HOUR(ViolationTime) BETWEEN 0 AND 6 THEN 'Midnight (0-6)'
        WHEN HOUR(ViolationTime) BETWEEN 7 AND 12 THEN 'Morning (7-12)'
        WHEN HOUR(ViolationTime) BETWEEN 13 AND 18 THEN 'Afternoon (13-18)'
        ELSE 'Evening (19-23)'
    END AS TimePeriod,
    COUNT(CaseID) AS CaseCount
FROM 
    ViolationCaseInfo
GROUP BY 
    TimePeriod
ORDER BY 
    FIELD(TimePeriod, 'Midnight (0-6)', 'Morning (7-12)', 'Afternoon (13-18)', 'Evening (19-23)');

SELECT * FROM ViolationTimePeriodDistribution;

-- Regional Case Distribution View
DROP VIEW IF EXISTS RegionalCaseDistribution;
CREATE VIEW RegionalCaseDistribution AS
SELECT 
    SUBSTRING_INDEX(ViolationLocation, 'District', 1) AS AdministrativeRegion,
    COUNT(CaseID) AS CaseCount,
    ROUND(COUNT(CaseID) / (SELECT COUNT(*) FROM ViolationCaseInfo) * 100, 2) AS Percentage
FROM 
    ViolationCaseInfo
GROUP BY 
    AdministrativeRegion
ORDER BY 
    CaseCount DESC;

SELECT * FROM RegionalCaseDistribution;
