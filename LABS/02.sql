-- Q1. Find the total salary of all employees.
SELECT SUM(salary) AS TotalSalary 
FROM employees;

-- Q2. Find the average salary of employees.
SELECT ROUND(AVG(salary)) AS AverageSalary 
FROM employees;

-- Q3. Count the number of employees reporting to each manager.
SELECT manager_id, COUNT(*) AS EmployeeCount 
FROM employees 
WHERE manager_id IS NOT NULL 
GROUP BY manager_id;

-- Q4. Select employees who have the lowest salary.
SELECT * 
FROM employees 
WHERE salary = (SELECT MIN(salary) FROM employees);

-- Q5. Display the current system date in the format DD-MM-YYYY.
SELECT TO_CHAR(SYSDATE, 'DD-MM-YYYY') AS CurrentDate 
FROM dual;

-- Q6. Display the current system date with full day, month, and year (e.g., MONDAY AUGUST 2025).
SELECT TO_CHAR(SYSDATE, 'DAY MONTH YYYY') AS CurrentDateFull 
FROM dual;

-- Q7. Find all employees hired on a Wednesday.
SELECT * 
FROM employees 
WHERE TO_CHAR(hire_date, 'DAY') = 'WEDNESDAY';

-- Q8. Calculate months between 01-JAN-2025 and 01-OCT-2024.
SELECT MONTHS_BETWEEN(
    TO_DATE('01-JAN-2025', 'DD-MON-YYYY'), 
    TO_DATE('01-OCT-2024', 'DD-MON-YYYY')
) AS MonthDifference 
FROM dual;

-- Q9. Find how many months each employee has worked in the company (using hire_date).
SELECT employee_id, first_name, last_name, 
       FLOOR(MONTHS_BETWEEN(SYSDATE, hire_date)) AS MonthsWorked
FROM employees;

-- Q10. Extract the first 5 characters from each employee’s last name.
SELECT SUBSTR(last_name, 1, 5) AS LastNamePrefix 
FROM employees;

-- Q11. Pad employee first names with * on the left side to make them 15 characters wide.
SELECT LPAD(first_name, 15, '*') AS PaddedFirstName 
FROM employees;

-- Q12. Remove leading spaces from ' Oracle'.
SELECT LTRIM(' Oracle') AS TrimmedString 
FROM dual;

-- Q13. Display each employee’s name with the first letter capitalized.
SELECT INITCAP(first_name || ' ' || last_name) AS FullName 
FROM employees;

-- Q14. Find the next Monday after 20-AUG-2022.
SELECT NEXT_DAY(TO_DATE('20-AUG-2022', 'DD-MON-YYYY'), 'MONDAY') AS NextMonday 
FROM dual;

-- Q15. Convert '25-DEC-2023' (string) to a date and display it in MM-YYYY format.
SELECT TO_CHAR(TO_DATE('25-DEC-2023', 'DD-MON-YYYY'), 'MM-YYYY') AS MonthYear 
FROM dual;

-- Q16. Display all distinct salaries in ascending order.
SELECT DISTINCT salary 
FROM employees 
ORDER BY salary ASC;

-- Q17. Display the salary of each employee rounded to the nearest hundred.
SELECT employee_id, first_name, last_name, ROUND(salary, -2) AS RoundedSalary 
FROM employees;

-- Q18. Find the department that has the maximum number of employees.
SELECT department_id, COUNT(*) AS EmployeeCount 
FROM employees 
WHERE department_id IS NOT NULL 
GROUP BY department_id 
ORDER BY EmployeeCount DESC 
FETCH FIRST 1 ROWS ONLY;

-- Q19. Find the top 3 highest-paid departments by total salary expense.
SELECT department_id, SUM(salary) AS TotalSalary 
FROM employees 
WHERE department_id IS NOT NULL 
GROUP BY department_id 
ORDER BY TotalSalary DESC 
FETCH FIRST 3 ROWS ONLY;

-- Q20. Find the department that has the maximum number of employees. (duplicate of Q18)
SELECT department_id, COUNT(*) AS EmployeeCount 
FROM employees 
WHERE department_id IS NOT NULL 
GROUP BY department_id 
ORDER BY EmployeeCount DESC 
FETCH FIRST 1 ROWS ONLY;
