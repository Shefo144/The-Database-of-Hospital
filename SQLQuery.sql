-- 1. تنظيف البيئة (مسح القاعدة القديمة للبدء من جديد بدون أخطاء التكرار)
USE master;
GO
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'HospitalDB')
BEGIN
    ALTER DATABASE HospitalDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE HospitalDB;
END
GO

-- 2. إنشاء قاعدة البيانات من جديد
CREATE DATABASE HospitalDB;
GO
USE HospitalDB;
GO

-- 3. إنشاء الجداول (DDL)
CREATE TABLE Branches (
    Branch_ID INT PRIMARY KEY,
    Branch_Name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE Doctors (
    Doctor_ID INT PRIMARY KEY,
    Doctor_Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Specialty VARCHAR(50),
    Branch_ID INT
);

CREATE TABLE Nursing (
    Nurse_ID INT PRIMARY KEY,
    Nurse_Name VARCHAR(100) NOT NULL,
    Shift VARCHAR(20),
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
    Age INT,
    Branch_ID INT
);
GO

-- 4. إدخال البيانات (DML)
INSERT INTO Branches (Branch_ID, Branch_Name) VALUES (1,'Mansoura Branch'),(2,'Cairo Branch'),(3,'Alex Branch');
INSERT INTO Doctors (Doctor_ID, Doctor_Name, Email, Specialty, Branch_ID) VALUES (1,'Dr Ahmed','ahmed@gmail.com','Cardiology',1),(2,'Dr Mona','mona@gmail.com','Dermatology',2);
INSERT INTO Patients (Patient_ID, Patient_Name, Disease, Age, Branch_ID) VALUES (1,'Ali','Flu',25,1),(2,'Omar','Fracture',30,2);
GO

-- 5. تنفيذ كافة تعديلات الـ Alter المطلوبة في الكود الأصلي
ALTER TABLE Doctors ADD CONSTRAINT FK_Doctors_Branch FOREIGN KEY (Branch_ID) REFERENCES Branches(Branch_ID);
ALTER TABLE Nursing ALTER COLUMN Shift VARCHAR(30);
ALTER TABLE Branches ADD Location VARCHAR(50) DEFAULT 'Cairo';
ALTER TABLE Patients ADD CONSTRAINT CHK_Age CHECK (Age > 0);
ALTER TABLE Doctors ADD Phone VARCHAR(15);
ALTER TABLE Doctors DROP COLUMN Phone;

-- تغيير اسم العمود من Doctor_Name إلى DName
EXEC sp_rename 'Doctors.Doctor_Name', 'DName', 'COLUMN';
GO

-- 6. تحديث وحذف بعض البيانات (حسب كودك الأصلي)
UPDATE Patients SET Disease = 'Cold' WHERE Patient_ID = 1;
DELETE FROM Nursing WHERE Nurse_ID = 2; -- لن يحذف شيء لعدم وجود بيانات بالجدول حالياً
GO

-- 7. عرض النتائج النهائية (الاستعلامات DQL)
-- سيظهر لكِ عدة جداول في الأسفل (Results)

PRINT '--- جدول الفروع ---';
SELECT * FROM Branches;

PRINT '--- جدول الأطباء (لاحظي تغيير اسم العمود لـ DName) ---';
SELECT * FROM Doctors;

PRINT '--- جدول المرضى (بعد التعديل) ---';
SELECT * FROM Patients;

PRINT '--- استعلام خاص: الأطباء في فرع القاهرة والإسكندرية ---';
SELECT * FROM Doctors 
WHERE Branch_ID IN (SELECT Branch_ID FROM Branches WHERE Branch_Name IN ('Cairo Branch','Alex Branch'));
GO