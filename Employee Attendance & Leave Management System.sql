CREATE DATABASE EmployeeManagementDB;
USE EmployeeManagementDB;
select * from employees;
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Department VARCHAR(50) NOT NULL,
    Position VARCHAR(50) NOT NULL,
    Salary DECIMAL(10,2) CHECK (Salary >= 0)
    );
CREATE TABLE Attendance (
    RecordID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeID INT,
    Date DATE NOT NULL,
    Status ENUM('Present', 'Absent', 'Late') NOT NULL,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID) ON DELETE CASCADE
);
CREATE TABLE Leaves (
    LeaveID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeID INT,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    Reason TEXT,
    Status ENUM('Pending', 'Approved', 'Rejected') DEFAULT 'Pending',
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID) ON DELETE CASCADE
);
CREATE TABLE Payroll (
    PayrollID INT PRIMARY KEY AUTO_INCREMENT,
    EmployeeID INT,
    Month VARCHAR(10) NOT NULL,
    Amount DECIMAL(10,2) CHECK (Amount >= 0),
    PaymentStatus ENUM('Paid', 'Pending') DEFAULT 'Pending',
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID) ON DELETE CASCADE
);
INSERT INTO Employees (Name, Department, Position, Salary) VALUES 
('Praveen Murugesan', 'HR', 'Manager', 60000),
('Yukendran Velmurugan', 'IT', 'Software Engineer', 75000),
('Arun kandasamy', 'Finance', 'Accountant', 55000),
('Mahesh Rajadurai', 'IT', 'Data Analyst', 70000),
('Balamurugan Madaswamy', 'Marketing', 'Social Media Manager', 65000);
INSERT INTO Attendance (EmployeeID, Date, Status) VALUES 
(1, '2025-03-01', 'Present'),
(2, '2025-03-01', 'Late'),
(3, '2025-03-01', 'Absent'),
(4, '2025-03-01', 'Present'),
(5, '2025-03-01', 'Present'),
(1, '2025-03-02', 'Present'),
(2, '2025-03-02', 'Present'),
(3, '2025-03-02', 'Absent'),
(4, '2025-03-02', 'Late'),
(5, '2025-03-02', 'Present');
select * from attendance;
SELECT * from employees;
DELETE from attendance where recordid >10;
INSERT INTO Leaves (EmployeeID, StartDate, EndDate, Reason, Status) VALUES 
(1, '2025-03-10', '2025-03-12', 'Family Emergency', 'Pending'),
(3, '2025-03-15', '2025-03-20', 'Medical Leave', 'Approved'),
(5, '2025-04-05', '2025-04-07', 'Vacation', 'Pending');
INSERT INTO Payroll (EmployeeID, Month, Amount, PaymentStatus) VALUES 
(1, 'March', 60000, 'Paid'),
(2, 'March', 75000, 'Paid'),
(3, 'March', 55000, 'Pending'),
(4, 'March', 70000, 'Paid'),
(5, 'March', 65000, 'Paid');
-- Find employees earning between 50k and 80k
SELECT Name, Salary FROM Employees WHERE Salary BETWEEN 50000 AND 80000;
-- Find employees in IT who earn more than 70k
SELECT Name, Salary FROM Employees WHERE Department = 'IT' AND Salary > 70000;
-- Increase all salaries by 10%
UPDATE Employees SET Salary = Salary * 1.1;
-- Alter Table to Add Email Column
ALTER TABLE Employees  
ADD column Email VARCHAR(100) NOT NULL;
-- alter Table with unique constraint
ALTER TABLE Employees  
ADD CONSTRAINT unique_email UNIQUE (Email);
desc employees;
-- Updating Values in Altered column
UPDATE Employees SET Email = 'Praveen.kumar@gmail.com' WHERE EmployeeID = 1;
UPDATE Employees SET Email = 'yuga1234@email.com' WHERE EmployeeID = 2;
UPDATE Employees SET Email = 'Arunprince33@gmail.com' WHERE EmployeeID = 3;
UPDATE Employees SET Email = 'rajaduraimahesh33@email.com' WHERE EmployeeID = 4;
UPDATE Employees SET Email = 'bala.m02@email.com' WHERE EmployeeID = 5;
UPDATE Employees SET Email = 'Vignesh.IT@gmail.com' WHERE EmployeeID = 6;
-- Left Join
SELECT E.Name, A.Date, A.Status  
FROM Employees E  
LEFT JOIN Attendance A  
ON E.EmployeeID = A.EmployeeID;
-- Right Join
SELECT E.Name, A.Date, A.Status  
FROM Employees E  
RIGHT JOIN Attendance A  
ON E.EmployeeID = A.EmployeeID;
-- Find employees who were absent on a specific date
SELECT E.Name, A.Date, A.Status 
FROM Employees E
JOIN Attendance A ON E.EmployeeID = A.EmployeeID
WHERE A.Status = 'Absent' AND A.Date = '2025-03-01';
--  Count total absences per employee
SELECT E.Name, COUNT(A.RecordID) AS TotalAbsences 
FROM Employees E
JOIN Attendance A ON E.EmployeeID = A.EmployeeID
WHERE A.Status = 'Absent'
GROUP BY E.Name;
-- List pending leave requests
SELECT E.Name, L.StartDate, L.EndDate, L.Reason, L.Status 
FROM Employees E
JOIN Leaves L ON E.EmployeeID = L.EmployeeID
WHERE L.Status = 'Pending';
-- Find total salary paid for each department
SELECT Department, SUM(Salary) AS TotalSalary 
FROM Employees 
GROUP BY Department;
-- Track pending payroll payments
SELECT E.Name, P.Month, P.Amount 
FROM Employees E
JOIN Payroll P ON E.EmployeeID = P.EmployeeID
WHERE P.PaymentStatus = 'Pending';
-- Find employees who have taken the most leaves
SELECT E.Name, COUNT(L.LeaveID) AS TotalLeaves
FROM Employees E
JOIN Leaves L ON E.EmployeeID = L.EmployeeID
WHERE L.Status = 'Approved'
GROUP BY E.Name
ORDER BY TotalLeaves DESC;
-- Get employee payroll details with salary differences
SELECT E.Name, E.Salary, P.Amount AS PaidSalary, 
       (E.Salary - P.Amount) AS RemainingSalary, P.PaymentStatus
FROM Employees E
JOIN Payroll P ON E.EmployeeID = P.EmployeeID;
-- Find Employees in Departments that Start with 'F' or 'I'
SELECT Name, Department FROM Employees WHERE Department LIKE 'F%' OR Department LIKE 'I%';
-- Stored Procedure to Add a New Employee
DELIMITER //
CREATE PROCEDURE AddEmployee (
    IN empName VARCHAR(100), 
    IN empDepartment VARCHAR(50), 
    IN empPosition VARCHAR(50), 
    IN empSalary DECIMAL(10,2),
    IN empEmail VARCHAR(100)
)
BEGIN
    INSERT INTO Employees (Name, Department, Position, Salary, Email)  
    VALUES (empName, empDepartment, empPosition, empSalary, empEmail);
END //
DELIMITER ;
-- deleting Stored procedure 
DROP PROCEDURE IF EXISTS AddEmployee;
CALL AddEmployee('John Doe', 'IT', 'Software Engineer', 75000, 'john.doe@email.com');
CALL AddEmployee('Vignesh Perumal', 'IT', 'QA Engineer', 72000,'vignesh.perumal001@gmail.com');

-- Stored Procedure to Mark Employee Attendance
DELIMITER //
CREATE PROCEDURE MarkAttendance (
    IN empID INT, 
    IN attDate DATE, 
    IN attStatus ENUM('Present', 'Absent', 'Late')
)
BEGIN
    INSERT INTO Attendance (EmployeeID, Date, Status) 
    VALUES (empID, attDate, attStatus);
END //
DELIMITER ;
CALL MarkAttendance(4, '2025-03-18', 'absent');
DELIMITER //
-- Stored Procedure to Approve a Leave Request
CREATE PROCEDURE ApproveLeave (
    IN leaveID INT
)
BEGIN
    UPDATE Leaves 
    SET Status = 'Approved' 
    WHERE LeaveID = leaveID;
END //
DELIMITER ;
CALL ApproveLeave(1);
set sql_safe_updates = 0;
--  Stored Procedure to Process Payroll Payments
DELIMITER //
CREATE PROCEDURE ProcessPayroll (
    IN empID INT, 
    IN payMonth VARCHAR(10), 
    IN payAmount DECIMAL(10,2)
)
BEGIN
    INSERT INTO Payroll (EmployeeID, Month, Amount, PaymentStatus) 
    VALUES (empID, payMonth, payAmount, 'Paid');
END //
DELIMITER ;
CALL ProcessPayroll(3, 'March', 55000);
-- Trigger to Automatically Add Payroll Record When a New Employee is Added
DELIMITER //
CREATE TRIGGER AfterEmployeeInsert
AFTER INSERT ON Employees
FOR EACH ROW
BEGIN
    INSERT INTO Payroll (EmployeeID, Month, Amount, PaymentStatus)
    VALUES (NEW.EmployeeID, 'March', NEW.Salary, 'Pending');
END //
DELIMITER ;
-- Trigger to Update Payroll Status When Salary is Paid
DELIMITER //
CREATE TRIGGER AfterPayrollInsert
AFTER INSERT ON Payroll
FOR EACH ROW
BEGIN
    UPDATE Employees 
    SET Salary = NEW.Amount
    WHERE EmployeeID = NEW.EmployeeID;
END //
DELIMITER ;
-- Trigger to Prevent Overlapping Leave Requests
DELIMITER //
CREATE TRIGGER PreventOverlappingLeaves
BEFORE INSERT ON Leaves
FOR EACH ROW
BEGIN
    DECLARE countLeave INT;
    
    SELECT COUNT(*) INTO countLeave 
    FROM Leaves 
    WHERE EmployeeID = NEW.EmployeeID 
    AND ((NEW.StartDate BETWEEN StartDate AND EndDate) 
    OR (NEW.EndDate BETWEEN StartDate AND EndDate));
    
    IF countLeave > 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: Employee already has a leave request during this period!';
    END IF;
END //
DELIMITER ;
-- Trigger to Auto-Update Leave Status When Attendance is Marked
-- If an employee is marked "Present" on a leave date, the leave request is rejected automatically
DELIMITER //
CREATE TRIGGER AutoUpdateLeaveStatus
AFTER INSERT ON Attendance
FOR EACH ROW
BEGIN
    UPDATE Leaves 
    SET Status = 'Rejected' 
    WHERE EmployeeID = NEW.EmployeeID 
    AND StartDate = NEW.Date;
END //
DELIMITER ;
-- Employee Attendance Summary
CREATE VIEW AttendanceSummary AS
SELECT E.Name, E.Department, A.Date, A.Status
FROM Employees E
JOIN Attendance A ON E.EmployeeID = A.EmployeeID;
SELECT * FROM AttendanceSummary WHERE Status = 'Absent';
-- Approved Leave Requests
CREATE VIEW ApprovedLeaves AS
SELECT E.Name, L.StartDate, L.EndDate, L.Reason 
FROM Employees E
JOIN Leaves L ON E.EmployeeID = L.EmployeeID
WHERE L.Status = 'Approved';
SELECT * FROM ApprovedLeaves;
-- Employees with Pending Payroll Payments
CREATE VIEW PendingPayroll AS
SELECT E.Name, P.Month, P.Amount, P.PaymentStatus
FROM Employees E
JOIN Payroll P ON E.EmployeeID = P.EmployeeID
WHERE P.PaymentStatus = 'Pending';
SELECT * FROM PendingPayroll;
-- SUBQUERIES Find Employees Who Earn More Than the Average Salary
SELECT Name, Salary FROM Employees  
WHERE Salary > (SELECT AVG(Salary) FROM Employees);
-- SUBQUERIES Find Employees Who Have Taken a Leave
SELECT Name FROM Employees  
WHERE EmployeeID IN (SELECT EmployeeID FROM Leaves);
-- Correlated Subquery: Find Employees Who Have More Than 2 Leave Requests
SELECT Name FROM Employees E  
WHERE (SELECT COUNT(*) FROM Leaves L WHERE L.EmployeeID = E.EmployeeID) > 2;
-- Creating Users
CREATE USER 'HR'@'localhost' IDENTIFIED BY 'HRpassword';
CREATE USER 'Payroll_Clerk'@'localhost' IDENTIFIED BY 'PayrollPasscode';
-- Granting Permissions
GRANT ALL PRIVILEGES ON hr_database.* TO 'HR'@'localhost';
GRANT SELECT, INSERT, UPDATE ON hr_database.* TO 'HR'@'localhost';
FLUSH PRIVILEGES;
SELECT user, host FROM mysql.user;
-- Revoking Permissions
REVOKE INSERT, UPDATE ON EmployeeManagementDB.Employees FROM 'HR_Manager'@'localhost';
-- Checking User Privileges 
SHOW GRANTS FOR 'HR_Manager'@'localhost';
SHOW GRANTS FOR 'Payroll_Clerk'@'localhost';
-- Index on Employee Name for Faster Lookups
CREATE INDEX idx_EmployeeName ON Employees (Name);
-- Index on Attendance Date for Quick Date-Based Searches
CREATE INDEX idx_AttendanceDate ON Attendance (Date);
-- Find Names That Start with 'A'
SELECT Name FROM Employees WHERE Name REGEXP '^A';
-- Find Names That End with 'n'
SELECT Name FROM Employees WHERE Name REGEXP 'n$';
-- Find Names That Start with 'A' or 'P'
SELECT Name FROM Employees WHERE Name REGEXP '^(A|P)';
-- Find Emails Ending in '.com'
SELECT Email FROM Employees WHERE Email REGEXP '.com$';
-- Find Employee Names Containing Only Letters (No Numbers or Special Characters)
SELECT Name FROM Employees WHERE Name REGEXP '^[A-Za-z ]+$';


