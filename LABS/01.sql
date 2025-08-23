DB LAB 01
23K-0073


Q1. Write a SQL query to retrieve employees who are not in department 100.

select * 
from employees 
where department_id <> 100


Q2. Write a SQL query to retrieve whose salary is either 10000 , 12000 or 15000.

select * 
from employees 
where salary IN(10000, 12000, 15000)


Q3. Write a SQL query to display the first name and salary of employees whose salary is
less than OR equal to 25000.

select first_name, salary 
from employees 
where salary <= 25000






Q4. Write a SQL query to retrieve employees who are not in department 60.

select * 
from employees 
where department_id <> 60


Q5. Write a SQL query retrieve employees who are in between department 60 to 80

select * 
from employees 
where department_id between 60 and 80


Q6. Display all details of departments.

select * from departments


Q7. Retrieve employees whose first name is “Steve”

select * 
from employees 
where first_name = “Steven”


Q8. Display employees who earn between 15000 and 25000 and work in department 80

select * 
from employees 
where (salary BETWEEN 15000 AND 25000) AND (department_id = 80)

Q9. Display employees who earn less than the salary of any employee in department 100.

select * 
from employees 
where salary < ANY ( select salary from employees where department_id = 100)


Q10. Display employees whose department ID is unique in the employees table.

select * 
from employees e 
where 1 = ( 
select count(*) 
from employees
 where department_id = e.department_id )



Q11. Retrieve employees hired between 01-JAN-05 and 31-DEC-06.

select * 
from employees 
where hire_date between 
TO_DATE('01-JAN-2005', 'DD-MON-YYYY') AND 	
TO_DATE('31-DEC-2006', 'DD-MON-YYYY')


Q12. Retrieve employees who do not have a manager.

select * 
from employees 
where manager_id IS NULL



Q13. Retrieve employees whose salary is less than all employees earning more than
8000.

select * 
from employees 
where salary < ALL 
(select salary 
from employees 
where salary > 8000)


Q14. Retrieve employees whose salary is greater than any salary in department 90.

select * 
from employees 
where salary > ANY
( select salary 
from employees 
where department_id = 90)


Q15. Retrieve departments that have at least one employee.


select department_name 
from departments d 
where EXISTS 
(select * 
from employees e 
where e.department_id = d.department_id)






Q16. Retrieve departments that do not have any employee.

select department_name 
from departments d 
where NOT EXISTS 
(select * 
from employees e 
where e.department_id = d.department_id)


Q17. Retrieve employees whose salary is not between 5000 and 15000

select * 
from employees 
where salary NOT BETWEEN 5000 AND 15000


Q18. Retrieve employees who are in departments 10, 20, or 30, but not 40.

select * 
from employees 
where department_id IN (10,20,30) AND department_id != 40


Q19. Display employees whose salary is less than the minimum salary of department 50.

select * 
from employees 
where salary < 
( select MIN(salary) 
from employees 
where department_id = 50 )


Q20. Display employees whose salary is greater than the maximum salary of department
90.

select * 
from employees 
where salary > 
( select MAX(salary) 
from employees 
where department_id = 90 )


 

