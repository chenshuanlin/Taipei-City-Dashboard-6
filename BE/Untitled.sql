CREATE DATABASE TrafficViolation;
DROP TABLE IF EXISTS Violations;

USE TrafficViolation;

CREATE TABLE Violations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    idNumber VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    location VARCHAR(255) NOT NULL,
    licensePlate VARCHAR(20) NOT NULL,
    violationTime DATETIME NOT NULL,
    violationType VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    photoPath VARCHAR(255) NOT NULL,
    submittedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
