create database if not exists employeemanagementsystem;
use employeemanagementsystem;
select * from jobdepartment;
select * from salary_bonus;
select * from employee;
select * from qualification;
select * from leaves;
select * from payroll;

-- 1. EMPLOYEE INSIGHTS
#1.How many unique employees are currently in the system?

SELECT COUNT(DISTINCT empID) AS Total_Employees
FROM Employee;

#2.which departments have the highest number of employees?

SELECT
    jd.jobdept AS Department,
    COUNT(e.empID) AS Total_Employees
FROM Employee e
JOIN JobDepartment jd
ON e.JobID = jd.JobID
GROUP BY jd.jobdept
ORDER BY Total_Employees DESC;

#3.What is the average salary per department?

SELECT
    jd.jobdept AS Department,
    ROUND(AVG(sb.amount),2) AS Average_Salary
FROM Employee e
JOIN JobDepartment jd
ON e.JobID = jd.JobID
JOIN Salary_Bonus sb
ON jd.JobID = sb.JobID
GROUP BY jd.jobdept;



#4.Who are the top 5 highest-paid employees?


SELECT
    e.empID,
    CONCAT(e.firstname,' ',e.lastname) AS Employee_Name,
    sb.amount AS Salary
FROM Employee e
JOIN Salary_Bonus sb
ON e.JobID = sb.JobID
ORDER BY sb.amount DESC
LIMIT 5;

#5.What is the total salary expenditure across the company?

SELECT
SUM(sb.amount) AS Total_Salary
FROM Employee e
JOIN Salary_Bonus sb
ON e.JobID = sb.JobID;

-- 2. JOB ROLE AND DEPARTMENT ANALYSIS

#6.How many different job roles exist in each department?

SELECT
jobdept AS Department,
COUNT(DISTINCT name) AS Total_Job_Roles
FROM JobDepartment
GROUP BY jobdept;

#7.What is the average salary range per department?

SELECT
jd.jobdept,
ROUND(AVG(sb.amount),2) AS Avg_Salary
FROM JobDepartment jd
JOIN Salary_Bonus sb
ON jd.JobID=sb.JobID
GROUP BY jd.jobdept;

#8.=

SELECT
jd.name AS Job_Role,
sb.amount
FROM JobDepartment jd
JOIN Salary_Bonus sb
ON jd.JobID=sb.JobID
ORDER BY sb.amount DESC;

#9.Which departments have the highest total salary allocation?

SELECT
jd.jobdept,
SUM(sb.amount) AS Total_Salary
FROM Employee e
JOIN JobDepartment jd
ON e.JobID=jd.JobID
JOIN Salary_Bonus sb
ON jd.JobID=sb.JobID
GROUP BY jd.jobdept
ORDER BY Total_Salary DESC;

-- 3. QUALIFICATION AND SKILLS ANALYSIS

#10.How many employees have at least one qualification listed?

select
COUNT(DISTINCT EmpID) AS Qualified_Employees
FROM Qualification;

#11.Which positions require the most qualifications?


SELECT
Position,
COUNT(*) AS Total_Qualifications
FROM Qualification
GROUP BY Position
ORDER BY Total_Qualifications DESC;



#12.Which employees have the highest number of qualifications?


SELECT
e.empID,
CONCAT(e.firstname,' ',e.lastname) AS Employee_Name,
COUNT(q.QualID) AS Total_Qualifications
FROM Employee e
JOIN Qualification q
ON e.empID=q.EmpID
GROUP BY e.empID,e.firstname,e.lastname
ORDER BY Total_Qualifications DESC;

-- 4. LEAVE AND ABSENCE PATTERNS

#13.Which year had the most employees taking leaves?

SELECT
YEAR(date) AS Leave_Year,
COUNT(DISTINCT empID) AS Employees
FROM Leaves
GROUP BY YEAR(date)
ORDER BY Employees DESC;

#14.What is the average number of leave days taken by its employees per department?
SELECT
jd.jobdept,
ROUND(COUNT(l.leaveID)/COUNT(DISTINCT e.empID),2) AS Avg_Leave_Days
FROM Employee e
JOIN JobDepartment jd
ON e.JobID=jd.JobID
LEFT JOIN Leaves l
ON e.empID=l.empID
GROUP BY jd.jobdept;

#15.Which employees have taken the most leaves?

SELECT
e.empID,
CONCAT(e.firstname,' ',e.lastname) AS Employee_Name,
COUNT(l.leaveID) AS Leave_Count
FROM Employee e
JOIN Leaves l
ON e.empID=l.empID
GROUP BY e.empID,e.firstname,e.lastname
ORDER BY Leave_Count DESC;

#16.What is the total number of leave days taken company-wide?

SELECT
COUNT(*) AS Total_Leave_Days
FROM Leaves;

#17.How do leave days correlate with payroll amounts?

SELECT
e.empID,
CONCAT(e.firstname,' ',e.lastname) AS Employee_Name,
COUNT(l.leaveID) AS Leave_Days,
AVG(p.totalamount) AS Payroll
FROM Employee e
LEFT JOIN Leaves l
ON e.empID=l.empID
JOIN Payroll p
ON e.empID=p.empID
GROUP BY e.empID,e.firstname,e.lastname;


-- 5. PAYROLL AND COMPENSATION ANALYSIS

#18.What is the total monthly payroll processed?


SELECT
YEAR(date) AS Year,
MONTH(date) AS Month,
SUM(totalamount) AS Total_Payroll
FROM Payroll
GROUP BY YEAR(date),MONTH(date)
ORDER BY Year,Month;

#19.What is the average bonus given per department?

SELECT
jd.jobdept,
ROUND(AVG(sb.bonus),2) AS Avg_Bonus
FROM JobDepartment jd
JOIN Salary_Bonus sb
ON jd.JobID=sb.JobID
GROUP BY jd.jobdept;

#20.Which department receives the highest total bonuses?

SELECT
jd.jobdept,
SUM(sb.bonus) AS Total_Bonus
FROM Employee e
JOIN JobDepartment jd
ON e.JobID=jd.JobID
JOIN Salary_Bonus sb
ON jd.JobID=sb.JobID
GROUP BY jd.jobdept
ORDER BY Total_Bonus DESC;

#21.What is the average value of total_amount after considering leave deductions?

SELECT
ROUND(AVG(totalamount),2) AS Average_Payroll
FROM Payroll;


