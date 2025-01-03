-- Create database
CREATE DATABASE IF NOT EXISTS SpeedingTicketSystem
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE SpeedingTicketSystem;

SET foreign_key_checks = 0;

DROP TABLE IF EXISTS OwnerInfo;
DROP TABLE IF EXISTS VehicleInfo;
DROP TABLE IF EXISTS ViolationTypes;
DROP TABLE IF EXISTS EnforcementOfficers;
DROP TABLE IF EXISTS Assistants;
DROP TABLE IF EXISTS ViolationTickets;
DROP TABLE IF EXISTS PrintRecords;
DROP TABLE IF EXISTS ViolationCases;
DROP TABLE IF EXISTS TrafficViolationReports;

CREATE TABLE OwnerInfo (
    OwnerID VARCHAR(10) PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    IDNumber VARCHAR(20) NOT NULL UNIQUE,
    PhoneNumber VARCHAR(20),
    Address VARCHAR(100)
);

CREATE TABLE TrafficViolationReports (
    ReportID INT AUTO_INCREMENT PRIMARY KEY,
    ReporterName VARCHAR(100),
    IDNumber VARCHAR(20),
    Email VARCHAR(255),
    ContactNumber VARCHAR(15),
    ViolationLocation VARCHAR(255),
    ViolationTime TIME,
    LicensePlate VARCHAR(20),
    ViolationItem VARCHAR(255),
    ViolationPhoto BLOB COMMENT 'Violation Photo',
    ViolationDescription TEXT COMMENT 'Violation Description',
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Updated Time'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Traffic Violation Reports';

CREATE TABLE VehicleViolationRecords (
    RecordID INT AUTO_INCREMENT PRIMARY KEY,
    LicensePlate VARCHAR(20) NOT NULL,
    ViolationDate DATE NOT NULL,
    ViolationLocation VARCHAR(255) NOT NULL,
    ViolationItem VARCHAR(255) NOT NULL,
    Status VARCHAR(10) NOT NULL,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Vehicle Violation Records';

INSERT INTO VehicleViolationRecords (RecordID, LicensePlate, ViolationDate, ViolationLocation, ViolationItem, Status, CreatedAt, UpdatedAt) VALUES 
(1, '123 SKT', '2019-01-02', 'Wanshou Rd. Lane 50, No. 10, Wenshan District, Taipei City', 'Red Light Violation', 'Paid', '2019-01-02', '2019-01-02'),
(2, 'JRX-4176', '2022-01-02', 'Wanshou Rd. Lane 50, No. 10, Wenshan District, Taipei City', 'Red Light Violation', 'Paid', '2019-01-02', '2019-01-02'),
(3, 'VVJ-808', '2023-01-02', 'Wanshou Rd. Lane 50, No. 10, Wenshan District, Taipei City', 'Red Light Violation', 'Paid', '2019-01-02', '2019-01-02');

CREATE TABLE VehicleInfo (
    VehicleID VARCHAR(10) PRIMARY KEY,
    LicensePlate VARCHAR(10),
    OwnerID VARCHAR(10),
    Brand VARCHAR(20),
    Model VARCHAR(20),
    Color VARCHAR(20),
    VehicleType VARCHAR(20),
    FOREIGN KEY (OwnerID) REFERENCES OwnerInfo(OwnerID)
);

CREATE TABLE ViolationTypes (
    ViolationTypeID INT PRIMARY KEY AUTO_INCREMENT,
    ViolationName VARCHAR(100),
    ViolationDescription TEXT,
    PenaltyCategory VARCHAR(50),
    FineAmount DECIMAL(10, 2)
);

CREATE TABLE EnforcementOfficers (
    OfficerID VARCHAR(10) PRIMARY KEY,
    OfficerName VARCHAR(50),
    Department VARCHAR(50)
);

CREATE TABLE Assistants (
    AssistantID VARCHAR(10) PRIMARY KEY,
    Username VARCHAR(10),
    Password VARCHAR(10),
    AssistantName VARCHAR(50),
    Department VARCHAR(50)
);

CREATE TABLE ViolationTickets (
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
    FOREIGN KEY (VehicleID) REFERENCES VehicleInfo(VehicleID),
    FOREIGN KEY (ViolationTypeID) REFERENCES ViolationTypes(ViolationTypeID),
    FOREIGN KEY (OfficerID) REFERENCES EnforcementOfficers(OfficerID)
);

CREATE TABLE ViolationCases (
    CaseID VARCHAR(20) PRIMARY KEY,
    VehicleID VARCHAR(10),
    ViolationTypeID INT,
    ViolationLocation VARCHAR(100),
    ViolationTime DATETIME,
    AssistantID VARCHAR(10),
    TicketID VARCHAR(20),
    CaseDescription TEXT,
    FOREIGN KEY (VehicleID) REFERENCES VehicleInfo(VehicleID),
    FOREIGN KEY (ViolationTypeID) REFERENCES ViolationTypes(ViolationTypeID),
    FOREIGN KEY (AssistantID) REFERENCES Assistants(AssistantID),
    FOREIGN KEY (TicketID) REFERENCES ViolationTickets(TicketID)
);

CREATE TABLE PrintRecords (
    PrintID VARCHAR(10) PRIMARY KEY,
    PrintBatchID VARCHAR(10),
    PrintDate DATE,
    PrintTime TIME
);
INSERT INTO VehicleInfo (VehicleID, LicensePlate, OwnerID, Brand, Model, Color, VehicleType) VALUES
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

INSERT INTO OwnerInfo (OwnerID, Name, IDNumber, PhoneNumber, Address) VALUES
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
('O043', '黃俊賢', 'I882495900', '(09) 60949656', '台北市士林區雙溪路 8 巷 3
