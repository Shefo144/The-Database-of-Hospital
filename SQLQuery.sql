USE master;
GO

IF EXISTS (SELECT * FROM sys.databases WHERE name = 'HospitalDB')
BEGIN
    ALTER DATABASE HospitalDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE HospitalDB;
END
GO


CREATE DATABASE HospitalDB;
GO
USE HospitalDB;
GO


CREATE TABLE Branches (
    Branch_ID INT PRIMARY KEY,
    Branch_Name VARCHAR(50) UNIQUE NOT NULL,
    Location VARCHAR(50) DEFAULT 'Cairo'
);

CREATE TABLE Doctors (
    Doctor_ID INT PRIMARY KEY,
    DName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Specialty VARCHAR(50),
    Branch_ID INT,
    CONSTRAINT FK_Doctors_Branch FOREIGN KEY (Branch_ID) REFERENCES Branches(Branch_ID)
);

CREATE TABLE Nursing (
    Nurse_ID INT PRIMARY KEY,
    Nurse_Name VARCHAR(100) NOT NULL,
    Shift VARCHAR(30),
    Branch_ID INT
);

CREATE TABLE HR (
    HR_ID INT PRIMARY KEY,
    HR_Name VARCHAR(100) NOT NULL,
    Branch_ID INT
);

CREATE TABLE Manager (
    Manager_ID INT PRIMARY KEY,
    Manager_Name VARCHAR(100) NOT NULL,
    Branch_ID INT
);

CREATE TABLE Patients (
    Patient_ID INT PRIMARY KEY,
    Patient_Name VARCHAR(100) NOT NULL,
    Disease VARCHAR(100),
    Age INT CHECK (Age > 0),
    Branch_ID INT
);
GO


INSERT INTO Branches (Branch_ID, Branch_Name) VALUES
(1,'Mansoura Branch'),
(2,'Cairo Branch'),
(3,'Alex Branch');

INSERT INTO Doctors (Doctor_ID, DName, Email, Specialty, Branch_ID) VALUES
(1,'Dr Ahmed','ahmed@gmail.com','Cardiology',1),
(2,'Dr Mona','mona@gmail.com','Dermatology',2);

INSERT INTO Patients (Patient_ID, Patient_Name, Disease, Age, Branch_ID) VALUES
(1,'Ali','Flu',25,1),
(2,'Omar','Fracture',30,2);
GO


-- 
UPDATE Patients 
SET Disease = 'Cold' 
WHERE Patient_ID = 1;

-- 
DELETE FROM Nursing 
WHERE Nurse_ID = 2;
GO

--
SELECT * FROM Branches;

SELECT * FROM Doctors;

SELECT * FROM Patients;

SELECT * FROM Doctors 
WHERE Branch_ID IN (
    SELECT Branch_ID 
    FROM Branches 
    WHERE Branch_Name IN ('Cairo Branch','Alex Branch')
);
GO
