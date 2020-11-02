-- 1. Find all the employees who work in the ‘Human Resources’ department.

SELECT *
FROM employees
WHERE department = 'Human Resources';

-- 2. Get the first_name, last_name, and country of the employees who work in the ‘Legal’ department.

SELECT
	first_name,
	last_name,
	country,
	department 
FROM employees 
WHERE department = 'Legal';

-- 3. Count the number of employees based in Portugal.

SELECT
	COUNT(id) AS number_of_employees_portugal
FROM employees
WHERE country = 'Portugal';

-- 4. Count the number of employees based in either Portugal or Spain.

SELECT
	COUNT(id) AS number_of_employees_spain_or_portugal
FROM employees
WHERE 
	country = 'Spain' OR country = 'Portugal'

-- 5. Count the number of pay_details records lacking a local_account_no.

SELECT
	COUNT(id) AS num_pay_records_lacking_acc_no
FROM employees
WHERE pay_detail_id IS NULL;

-- 6. Get a table with employees first_name and last_name ordered alphabetically by last_name (put any NULLs last).

SELECT
	first_name,
	last_name
FROM employees
ORDER BY last_name ASC NULLS LAST;

-- 7. How many employees have a first_name beginning with ‘F’?

SELECT
	COUNT(id) AS first_name_beg_with_f
FROM employees
WHERE first_name LIKE 'F%'

-- 8. Count the number of pension enrolled employees not based in either France or Germany.

SELECT
	COUNT(id) AS num_pension_enrolled_except_france_germany
FROM employees 
WHERE country NOT IN ('France', 'Germany') AND pension_enrol = TRUE


-- 9. Obtain a count by department of the employees who started work with the corporation in 2003.

SELECT 
	COUNT(id) AS employees_started_2003
FROM employees 
WHERE start_date BETWEEN '2003-01-01' AND '2003-12-31';

-- 10. Obtain a table showing department, fte_hours and the number of employees in each department 
-- who work each fte_hours pattern. Order the table alphabetically by department, and then
-- in ascending order of fte_hours.

SELECT
	department, 
	fte_hours,
	COUNT(id) AS num_employees_fte_hours_by_department
FROM employees
GROUP BY department, fte_hours
ORDER BY 
	department ASC,
	fte_hours ASC;

			
-- 11. Obtain a table showing any departments in which there are two or more employees lacking a stored first name. Order the 
-- table in descending order of the number of employees lacking a first name, and then in alphabetical order by department.


SELECT
	department, 
	COUNT(id) AS number_of_no_first_name
FROM employees 
WHERE first_name IS NULL
GROUP BY department 
HAVING COUNT(id) >= 2
ORDER BY 
	COUNT(id) DESC, 
	department ASC;

-- 12. Find the proportion of employees in each department who are grade 1.

SELECT 
	department,
	COUNT(id)
FROM employees 
WHERE grade = 1
GROUP BY department;

-- this is as far as i got --









	
	
	



