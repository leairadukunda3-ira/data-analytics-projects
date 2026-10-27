
-- Q1.Create a database named employee, then import data_science_team.csv proj_table.csv and emp_record_table.csv into the employee database 
-- from the given resources.

-- creating database named employee

CREATE DATABASE employee;

-- using database

use employee;






-- Q2.Create an ER diagram for the given employee database
-- ER Diagram was created in Draw.io .i will share it as a seperate document

-- Q3.Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and DEPARTMENT from the employee record table, and make a list of employees 
-- and details of their department.

SELECT EMP_ID,FIRST_NAME,LAST_NAME,GENDER, DEPT FROM
emp_record_table;


-- Q4. Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING if the EMP_RATING is: less than two

SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING
FROM emp_record_table
WHERE EMP_RATING < 2;

-- greater than four 

SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING
FROM emp_record_table
WHERE EMP_RATING > 4;

-- between two and four

SELECT EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING
FROM emp_record_table
WHERE EMP_RATING between 2 and 4;

-- Q5.Write a query to concatenate the FIRST_NAME and the LAST_NAME of employees in the Finance department from the employee table 
-- and then give the resultant column alias as NAME.


SELECT
CONCAT(FIRST_NAME,' ',LAST_NAME) as NAME,
DEPT
FROM emp_record_table
WHERE DEPT ="Finance";


-- Q6.Write a query to list only those employees who have someone reporting to them. Also, show the number of reporters (including the President).
SELECT 
m.EMP_ID,
m.FIRST_NAME,
m.LAST_NAME,
COUNT(e.EMP_ID) AS REPORTER_COUNT
FROM emp_record_table e
JOIN emp_record_table m
ON e.MANAGER_ID = m.EMP_ID
GROUP BY m.EMP_ID, m.FIRST_NAME, m.LAST_NAME; 

-- Q7.Write a query to list down all the employees from the healthcare and finance departments using union. Take data from the employee record table.

SELECT *
FROM emp_record_table
WHERE DEPT='Healthcare'

UNION 

SELECT *
FROM emp_record_table
WHERE DEPT='Finance';

-- Q8.Write a query to list down employee details such as EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPARTMENT, and EMP_RATING grouped by dept. 
-- Also include the respective employee rating along with the max emp rating for the department.

SELECT EMP_ID,FIRST_NAME,LAST_NAME,ROLE,DEPT,EMP_RATING,	
MAX(EMP_RATING)  OVER (PARTITION  BY DEPT) AS maximum_Dept_rating
FROM emp_record_table;


-- Q9. Write a query to calculate the minimum and the maximum salary of the employees in each role. Take data from the employee record table.

SELECT ROLE,
MAX(SALARY) AS maxinum_salary,
MIN(SALARY)  AS minimun_salary
FROM emp_record_table
GROUP BY ROLE;


-- Q10. Write a query to assign ranks to each employee based on their experience. Take data from the employee record table.

SELECT EMP_ID,FIRST_NAME,LAST_NAME,EXP,
RANK() OVER (ORDER BY EXP DESC) AS employee_rank
FROM emp_record_table;

-- Q11.Write a query to create a view that displays employees in various countries whose salary is more than six thousand. 
-- Take data from the employee record table.

CREATE VIEW RICH_EMP AS
SELECT EMP_ID,FIRST_NAME,LAST_NAME,COUNTRY,
SALARY
FROM emp_record_table
WHERE  SALARY > 6000;

-- TO VIEW
SELECT * FROM RICH_EMP;

-- Q12. Write a nested query to find employees with experience of more than ten years. Take data from the employee record table.

   
SELECT *
FROM emp_record_table
WHERE EMP_ID IN
(
SELECT EMP_ID
FROM emp_record_table
WHERE EXP > 10
);

-- Q13 Write a query to create a stored procedure to retrieve the details of the employees whose experience is more than three years.
-- Take data from the employee record table.

DELIMITER //
CREATE  PROCEDURE EMPLOYEE_EXP()

BEGIN

SELECT *
FROM  emp_record_table
WHERE EXP > 3;
 
 END //
 DELIMITER ;
 
 -- TO RUN PROCEDURE
 CALL EMPLOYEE_EXP();
 
 -- q14.Write a query using stored functions in the project table to check whether the job profile assigned to each employee in the 
 -- data science team matches the organization’s set standard.The standard being:

-- For an employee with experience less than or equal to 2 years assign 'JUNIOR DATA SCIENTIST',
-- For an employee with the experience of 2 to 5 years assign 'ASSOCIATE DATA SCIENTIST',

-- For an employee with the experience of 5 to 10 years assign 'SENIOR DATA SCIENTIST',

-- For an employee with the experience of 10 to 12 years assign 'LEAD DATA SCIENTIST',

-- For an employee with the experience of 12 to 16 years assign 'MANAGER'.
 
 
 DELIMITER //
 
 CREATE FUNCTION verify_job_profile(EXP INT)
 RETURNS VARCHAR(50)
 DETERMINISTIC
 BEGIN
 DECLARE job_profile VARCHAR(50);

IF EXP <= 2 THEN
SET job_profile = 'JUNIOR DATA SCIENTIST';

ELSEIF EXP> 2 AND exp <= 5 THEN
SET job_profile = 'ASSOCIATE DATA SCIENTIST';

ELSEIF EXP > 5 AND exp <= 10 THEN
SET job_profile = 'SENIOR DATA SCIENTIST';

ELSEIF EXP > 10 AND exp <= 12 THEN
SET job_profile = 'LEAD DATA SCIENTIST';

ELSEIF EXP > 12 AND exp <= 16 THEN
SET job_profile = 'MANAGER';

END IF;

RETURN job_profile;
END //

DELIMITER ;

-- TO USE THE FUNCTION:
SELECT EMP_ID,FIRST_NAME,LAST_NAME,EXP,
verify_job_profile(EXP) AS EMPLOYEE_JOB_PROFILE
FROM data_science_team;


-- Q15. Create an index to improve the cost and performance of the query to find the employee whose FIRST_NAME is ‘Eric’ 
-- in the employee table after checking the execution plan.

-- TO CHECK EXECUTION PLAN
SELECT*
FROM emp_record_table
WHERE FIRST_NAME ='Eric';

-- To create index:
CREATE INDEX idx_firstname
ON emp_record_table(FIRST_NAME);
 


-- Q16.Write a query to calculate the bonus for all the employees, based on their ratings and salaries (Use the formula: 5% of salary * employee rating).

 SELECT  EMP_ID,FIRST_NAME,LAST_NAME,SALARY,
 EMP_RATING,
 (SALARY * 0.05 * EMP_RATING ) AS BONUS
 FROM emp_record_table;

-- Q17 Write a query to calculate the average salary distribution based on the continent and country. Take data from the employee record table.

SELECT COUNTRY,CONTINENT,AVG(SALARY) AS average_salary
FROM emp_record_table
GROUP BY COUNTRY,CONTINENT;

