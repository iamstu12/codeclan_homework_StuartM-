

----- Week 3, Day 3
----- Final SQL Lab and Homework
----- Stuart McColl


-- Question 1

-- Are there any pay_details records lacking both a 
-- local_account_no and iban number?

SELECT *
FROM pay_details
WHERE pay_details.local_account_no IS NULL
	AND pay_details IS NULL;


-- Question 2
	
-- Get a table of employees first_name, last_name and 
-- country, ordered alphabetically first by country and 
-- then by last_name (put any NULLs last).
	
SELECT
	employees.first_name,
	employees.last_name,
	employees.country 
FROM employees
ORDER BY employees.country ASC NULLS LAST,
	employees.last_name ASC NULLS LAST;
	

-- Question 3

-- Find the details of the top ten highest paid 
-- employees in the corporation.

SELECT *
FROM employees
ORDER BY employees.salary DESC NULLS LAST
LIMIT 10;


-- Question 4

-- Find the first_name, last_name and salary of 
-- the lowest paid employee in Hungary.

SELECT
	employees.first_name,
	employees.last_name,
	employees.salary,
	employees.country 
FROM employees
WHERE employees.country = 'Hungary'
ORDER BY employees.salary DESC NULLS LAST
LIMIT 1;


-- Question 5

-- Find all the details of any employees with 
-- a ‘yahoo’ email address?

SELECT *
FROM employees
WHERE employees.email LIKE '%yahoo%';


-- Question 6

-- Provide a breakdown of the numbers of employees 
-- enrolled, not enrolled, and with unknown enrollment 
-- status in the corporation pension scheme.

SELECT
	employees.pension_enrol,
	COUNT (employees.id) AS num_of_employees
FROM employees
GROUP BY employees.pension_enrol;


-- Question 7

-- What is the maximum salary among those employees in 
-- the ‘Engineering’ department who work 1.0 full-time 
-- equivalent hours (fte_hours)?
	
SELECT 
	employees.first_name,
	employees.last_name,
	employees.fte_hours,
	employees.department,
	employees.salary 
FROM employees 
WHERE employees.department LIKE 'Engineering' AND fte_hours = '1.0'
ORDER BY salary DESC NULLS LAST
LIMIT 1;


-- Question 8

-- Get a table of country, number of employees in that country, 
-- and the average salary of employees in that country for any 
-- countries in which more than 30 employees are based. Order the 
-- table by average salary descending.

SELECT
	employees.country,
	COUNT(employees.id) AS employee_count,
	AVG(employees.salary) AS avg_salary
FROM employees
GROUP BY employees.country 
HAVING COUNT(employees.id) > 30
ORDER BY AVG(employees.salary) DESC NULLS LAST;


-- Question 9

-- Return a table containing each employees first_name, 
-- last_name, full-time equivalent hours (fte_hours), salary, 
-- and a new column effective_yearly_salary which should contain 
-- fte_hours multiplied by salary.

SELECT
	employees.id,
	employees.first_name,
	employees.last_name,
	employees.fte_hours,
	employees.salary,
	employees.fte_hours * salary AS effective_salary
FROM employees;


-- Question 10

-- Find the first name and last name of all employees who lack a local_tax_code.

SELECT 
	employees.first_name,
	employees.last_name,
	pay_details.local_tax_code
FROM employees 
INNER JOIN pay_details
ON employees.id = pay_details.id 
WHERE pay_details.local_tax_code IS NULL;


-- Question 11

-- The expected_profit of an employee is 
-- defined as (48 * 35 * charge_cost - salary) * fte_hours, 
-- where charge_cost depends upon the team to which the employee
--  belongs. Get a table showing expected_profit for each employee.
	
	SELECT
	teams.id,
	teams.charge_cost,
	employees.salary,
	employees.first_name,
	employees.last_name,
	employees.fte_hours,
	(48 * 35 * CAST(teams.charge_cost AS INT) - employees.salary) * employees.fte_hours AS expected_profit
FROM employees
LEFT JOIN teams 
ON employees.team_id = teams.id


-- Question 12

-- [Tough] Get a list of the id, first_name, last_name, salary 
-- and fte_hours of employees in the largest department. Add two 
-- extra columns showing the ratio of each employee’s salary to 
-- that department’s average salary, and each employee’s fte_hours 
-- to that department’s average fte_hours.

SELECT 
	employees.id,
	employees.first_name,
	employees.last_name,
	employees.salary,
	employees.fte_hours,
	employees.salary / AVG (employees.salary) 
	OVER (PARTITION BY employees.department) AS average_salary_ratio,
	employees.fte_hours / AVG (employees.fte_hours) 
	OVER (PARTITION BY employees.department) AS ratio_department_hours
FROM employees
LEFT JOIN (SELECT department, 
	COUNT(employees.id)
	FROM employees 
	GROUP BY department 
	ORDER BY COUNT(employees.id) DESC NULLS LAST 
	LIMIT 1)  AS top
ON employees.department = top.department;


-- Extension Questions

-- Question 1 -  Return a table of those employee first_names shared by more than 
-- one employee, together with a count of the number of times each 
-- first_name occurs. Omit employees without a stored first_name from the table. 
-- Order the table descending by count, and then alphabetically by first_name.

SELECT 
	DISTINCT(employees.first_name),
	COUNT(employees.id) AS first_name_count
FROM employees
WHERE employees.first_name IS NOT NULL
GROUP BY employees.first_name 
ORDER BY COUNT(employees.id) DESC NULLS LAST,
employees.first_name ASC;


-- Question 2 - Have a look again at your table for core question 6. It will 
-- likely contain a blank cell for the row relating to employees with ‘unknown’ 
-- pension enrollment status. This is ambiguous: it would be better if this cell 
-- contained ‘unknown’ or something similar. Can you find a way to do this, perhaps 
-- using a combination of COALESCE() and CAST(), or a CASE statement?

SELECT
	COALESCE(CAST(pension_enrol AS VARCHAR), 'unknown')
	AS pension_enrol,
	COUNT (employees.id) AS num_of_employees_enrolled
FROM employees
GROUP BY employees.pension_enrol;


-- Question 3 - Find the first name, last name, email address and start date of all 
-- the employees who are members of the ‘Equality and Diversity’ committee. Order the 
-- member employees by their length of service in the company, longest first.

SELECT
	employees.first_name,
	employees.last_name,
	employees.email,
	employees.start_date,
	committees."name" AS commitee_name
FROM employees
LEFT JOIN employees_committees
ON employees.id = employees_committees.employee_id
LEFT JOIN committees
ON employees_committees.committee_id = committees.id 
WHERE committees."name" = 'Equality and Diversity'
ORDER BY employees.start_date ASC NULLS LAST;



	
	
	
	
	
	
	

















	
	
	
	
	
