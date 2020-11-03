

----- Week 3, Day 2
----- SQL Lab and Homework
----- Stuart McColl

-- Question 1

-- Get a table of all employees details, together with their 
-- local_account_no and local_sort_code, if they have them.

SELECT 
	employees.*,
	pay_details.local_account_no, 
	pay_details.local_sort_code 
FROM employees
LEFT JOIN pay_details
ON employees.pay_detail_id = pay_details.id;


-- Question 2

-- Amend your query from question 1 above to also return the 
-- name of the team that each employee belongs to.

SELECT
	employees.*,
	pay_details.local_account_no,
	pay_details.local_sort_code
FROM employees
LEFT JOIN pay_details
ON employees.pay_detail_id = pay_details.id 
LEFT JOIN teams
ON employees.team_id = teams.id;


-- Question 3

-- Find the first name, last name and team name of employees 
-- who are members of teams for which the charge cost is greater 
-- than 80. Order the employees alphabetically by last name.

SELECT 
	employees.first_name,
	employees.last_name,
	teams."name" AS team_name -- changed 'name' to 'team name'
FROM employees 
INNER JOIN teams 
ON employees.team_id = teams.id 
WHERE CAST(teams.charge_cost AS INT) > 80
ORDER BY employees.last_name ASC NULLS LAST;


-- Question 4

-- Breakdown the number of employees in each of the teams, 
-- including any teams without members. Order the table by 
-- increasing size of team.

SELECT 
	teams."name" AS team_name,
	COUNT(employees.id) AS num_employees_each_team
FROM employees 
RIGHT JOIN teams 
ON employees.team_id = teams.id
GROUP BY teams."name" 
ORDER BY teams."name";


-- Question 5

-- The effective_salary of an employee is defined as their 
-- fte_hours multiplied by their salary. Get a table for each 
-- employee showing their id, first_name, last_name, fte_hours, 
-- salary and effective_salary, along with a running total of 
-- effective_salary with employees placed in ascending order of 
-- effective_salary.

SELECT 
	employees.id,	
	employees.first_name,
	employees.last_name,
	employees.salary,
	employees.fte_hours,
	employees.fte_hours * employees.salary AS effective_salary,
	SUM(employees.fte_hours * employees.salary)
	OVER (ORDER BY employees.fte_hours * employees.salary ASC NULLS LAST)
		AS running_total_effetive_salary
FROM employees;


-- Question 6

-- The total_day_charge of a team is defined as the charge_cost 
-- of the team multiplied by the number of employees in the team. 
-- Calculate the total_day_charge for each team.

SELECT 
	teams."name",
	COUNT(employees.id) * CAST(teams.charge_cost AS INT) AS total_day_charge
FROM employees
INNER JOIN teams
ON employees.team_id = teams.id
GROUP BY teams.id;


-- Question 7

-- How would you amend your query from question 6 above to show 
-- only those teams with a total_day_charge greater than 5000?


SELECT 
	teams."name",
	COUNT(employees.id) * CAST(teams.charge_cost AS INT) AS total_day_charge
FROM employees
INNER JOIN teams
ON employees.team_id = teams.id
GROUP BY teams.id
HAVING COUNT(employees.id) * CAST(teams.charge_cost AS INT) > 5000;





























