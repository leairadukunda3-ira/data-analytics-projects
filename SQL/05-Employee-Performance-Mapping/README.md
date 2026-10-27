# 👥 Employee Performance Mapping (SQL)

![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=flat-square&logo=mysql&logoColor=white)
![Window Functions](https://img.shields.io/badge/Window%20Functions-RANK%20%7C%20OVER-blue?style=flat-square)
![Stored Procedures](https://img.shields.io/badge/Stored%20Procedures%20%26%20Functions-orange?style=flat-square)
![Views & Indexes](https://img.shields.io/badge/Views%20%26%20Indexes-informational?style=flat-square)

[← Back to portfolio](../../README.md)

---

## 📌 Project Overview

I built an `employee` database in **MySQL** from three CSV files and wrote **17 queries**. They answer HR questions about performance ratings, salaries, experience, reporting lines and job-title standards.

The project moves from basic `SELECT` filtering up to **self-joins, window functions, views, stored procedures, a user-defined function and indexing**.

## 🎯 Business Questions

- Which employees are under-performing (rating < 2), meeting expectations (2–4) or excelling (> 4)?
- Who manages people, and how many direct reports do they have?
- What are the salary ranges by role, and how does pay vary by country and continent?
- How do employees rank by experience?
- Does each data scientist's job title match the company's experience-based standard?
- What bonus does each employee earn, based on salary and rating?

## 📂 Dataset

| Table | Rows | Key columns |
|-------|------|-------------|
| [`emp_record_table`](data/emp_record_table.csv) | 19 | EMP_ID, FIRST_NAME, LAST_NAME, GENDER, ROLE, DEPT, EXP, COUNTRY, CONTINENT, SALARY, EMP_RATING, MANAGER_ID, PROJ_ID |
| [`data_science_team`](data/data_science_team.csv) | 13 | EMP_ID, FIRST_NAME, LAST_NAME, GENDER, ROLE, DEPT, EXP, COUNTRY, CONTINENT |
| [`proj_table`](data/proj_table.csv) | 6 | PROJECT_ID, PROJ_NAME, DOMAIN, START_DATE, CLOSURE_DATE, DEV_QTR, STATUS |

The employees work in **Retail (7), Automotive (4), Healthcare (4) and Finance (3)**, plus the President. They are based in **7 countries**: USA, Canada, Germany, India, Colombia, France and China.

---

## 🔧 What Each Query Does

| # | Task | SQL techniques |
|---|------|----------------|
| Q1 | Create the `employee` database and import the 3 CSVs | `CREATE DATABASE`, `USE` |
| Q3 | List employees with their department | `SELECT` |
| Q4 | Split employees into rating bands: < 2, > 4 and 2–4 | `WHERE`, `BETWEEN` |
| Q5 | Full names of Finance employees as a single `NAME` column | `CONCAT`, alias |
| Q6 | Managers and the number of people reporting to them | **Self-join** on `MANAGER_ID`, `COUNT`, `GROUP BY` |
| Q7 | Employees in Healthcare and Finance | `UNION` |
| Q8 | Each employee's rating next to the highest rating in their department | `MAX() OVER (PARTITION BY DEPT)` |
| Q9 | Minimum and maximum salary per role | `MIN`, `MAX`, `GROUP BY` |
| Q10 | Rank employees by experience | `RANK() OVER (ORDER BY EXP DESC)` |
| Q11 | View of employees earning more than 6,000 | `CREATE VIEW` |
| Q12 | Employees with more than 10 years of experience | **Nested subquery** (`IN`) |
| Q13 | Reusable query for employees with more than 3 years of experience | **Stored procedure** |
| Q14 | Check each data scientist's title against the experience standard | **User-defined function** with `IF / ELSEIF` |
| Q15 | Speed up the search for `FIRST_NAME = 'Eric'` | Execution plan + `CREATE INDEX` |
| Q16 | Bonus = 5% of salary × rating | Calculated column |
| Q17 | Average salary by continent and country | `AVG`, `GROUP BY` |

> Q2 asked for an ER diagram, which was drawn in draw.io as a separate document.

### Highlighted Queries

**Managers and their reporting count (self-join)**

```sql
SELECT m.EMP_ID, m.FIRST_NAME, m.LAST_NAME,
       COUNT(e.EMP_ID) AS REPORTER_COUNT
FROM emp_record_table e
JOIN emp_record_table m ON e.MANAGER_ID = m.EMP_ID
GROUP BY m.EMP_ID, m.FIRST_NAME, m.LAST_NAME;
```

**Department maximum next to each employee's rating (window function)**

```sql
SELECT EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPT, EMP_RATING,
       MAX(EMP_RATING) OVER (PARTITION BY DEPT) AS maximum_Dept_rating
FROM emp_record_table;
```

**Job-title standard check (stored function)**

```sql
CREATE FUNCTION verify_job_profile(EXP INT)
RETURNS VARCHAR(50) DETERMINISTIC
BEGIN
  DECLARE job_profile VARCHAR(50);
  IF EXP <= 2 THEN SET job_profile = 'JUNIOR DATA SCIENTIST';
  ELSEIF EXP > 2  AND EXP <= 5  THEN SET job_profile = 'ASSOCIATE DATA SCIENTIST';
  ELSEIF EXP > 5  AND EXP <= 10 THEN SET job_profile = 'SENIOR DATA SCIENTIST';
  ELSEIF EXP > 10 AND EXP <= 12 THEN SET job_profile = 'LEAD DATA SCIENTIST';
  ELSEIF EXP > 12 AND EXP <= 16 THEN SET job_profile = 'MANAGER';
  END IF;
  RETURN job_profile;
END
```

---

## 💡 Key Findings

1. **All 13 data scientists hold the title that the experience standard expects** (Q14). This includes 2 Junior, 4 Associate, 5 Senior and 2 Lead data scientists.
2. **12 of 19 employees earn more than 6,000** and appear in the `RICH_EMP` view (Q11).
3. **8 employees have more than 10 years of experience** (Q12). They form the senior pool for leadership roles.
4. **Retail is the largest department** with 7 of the 18 non-President staff.

## 📁 Files

| File | Description |
|------|-------------|
| [`sql/employee_performance_mapping.sql`](sql/employee_performance_mapping.sql) | Full script with every question and query, commented |
| [`data/`](data/) | The 3 source CSV files |

## ▶️ How to Run

1. Open the script in **MySQL Workbench** and run the `CREATE DATABASE` / `USE` lines.
2. Import the 3 CSVs from [`data/`](data/) with the *Table Data Import Wizard*. Keep the file names as table names.
3. Run the remaining queries one at a time. Run the stored procedure and function blocks whole, including their `DELIMITER` lines.

[← Back to portfolio](../../README.md)
