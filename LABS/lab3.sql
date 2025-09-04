------------------------- IN-LAB ---------------------------

-- Q1: create a table named employees with the following columns, emp_id ,
-- emp_name , salary(should be greater than 20000) , dept_id(reference) from departments table.

CREATE TABLE DEPARTMENTS (
    dept_id NUMBER(6) PRIMARY KEY,
    dept_name VARCHAR2(20)
);

CREATE TABLE EMPLOYEES(
    emp_id Number(6) PRIMARY KEY,
    emp_name VARCHAR2(10),
    salary NUMBER(10),
    dept_id Number(6),
    CONSTRAINT salary_check CHECK(salary>20000),
    FOREIGN KEY(dept_id) REFERENCES DEPARTMENTS(dept_id)
);

-- Q2: Change column name from emp_name to full_name.

ALTER TABLE EMPLOYEES 
RENAME COLUMN emp_name TO full_name;


-- Q3: Drop the check constraint on salary and try inserting an employee with salary = 5000.

ALTER TABLE EMPLOYEES DROP CONSTRAINT salary_check;

INSERT INTO DEPARTMENTS VALUES(1, 'HR');

INSERT INTO EMPLOYEES VALUES(000001, 'Rayyan', 5000, 1);


-- Q4: Create a table departments with columns dept_id (PK), dept_name (UNIQUE). Insert 3 records.

CREATE TABLE DEPARTMENTS (
    dept_id NUMBER(6) PRIMARY KEY,
    dept_name VARCHAR2(20) UNIQUE
);

INSERT INTO DEPARTMENTS VALUES(2, 'Marketing');
INSERT INTO DEPARTMENTS VALUES(3, 'Finance');
INSERT INTO DEPARTMENTS VALUES(4, 'Sales');


-- Q5: Add a foreign key from employees.dept_id to departments.dept_id.

ALTER TABLE EMPLOYEES 
ADD CONSTRAINT fk_emp_dept 
FOREIGN KEY (dept_id)
REFERENCES DEPARTMENTS(dept_id);


-- Q6: Add a new column bonus NUMBER(6,2) in employees with a default value of 1000.

ALTER TABLE EMPLOYEES
ADD( Bonus NUMBER(6,2) DEFAULT(1000) );


-- Q7: Forgot to add city have default value Karachi and age column(should be greater than 18).

ALTER TABLE EMPLOYEES
ADD(
    City VARCHAR2(20) DEFAULT 'Karachi',
    Age Number(3),
    Constraint age_check CHECK(age>18)
);


-- Q8: Delete records have id 1 and id 3.

DELETE FROM EMPLOYEES 
WHERE emp_id IN(1,3);


-- Q9: Change the length of full_name and city column length must be 20 characters.

ALTER TABLE EMPLOYEES
MODIFY(
    full_name VARCHAR(20),
    City VARCHAR(20)
);


-- Q10: Add email column and set unique constraint.

ALTER TABLE EMPLOYEES
ADD ( 
    Email VARCHAR(50),
    CONSTRAINT unique_email UNIQUE(email) 
);



-------------------- POST LAB TASKS --------------------

-- Q11: A company policy says no employee can have the same bonus amount. Add a UNIQUE constraint on bonus and test it with two records.

ALTER TABLE EMPLOYEES
MODIFY BONUS NUMBER(6,2) UNIQUE;


-- Q12: Add a dob DATE column in staff and add a constraint that ensures employees must be at least 18 years old.

ALTER TABLE EMPLOYEES
ADD ( 
    DOB DATE
);  -- A age check constraint was already added previously


-- Q13: Insert an employee with invalid date of birth (less than 18 years old) and check the error

INSERT INTO EMPLOYEES (emp_id, full_name, salary, dept_id, city, age, email, dob)
VALUES (20, 'Arham', 25000, 2, 'Karachi', 17, 'arham@example.com', DATE '2012-05-10');


-- Q14: Drop the dept_id foreign key and insert an employee with a non-existing department. Then re-add the constraint and check again.

ALTER TABLE EMPLOYEES
DROP CONSTRAINT fk_emp_dept;

INSERT INTO EMPLOYEES (emp_id, full_name, salary, dept_id, city, age, dob, email)
VALUES (30, 'Hassan', 40000, 999, 'Lahore', 25, DATE '1999-08-12', 'hassan@example.com');

ALTER TABLE EMPLOYEES
ADD CONSTRAINT fk_emp_dept
FOREIGN KEY (dept_id) REFERENCES DEPARTMENTS(dept_id);
-- This command failed since there exist a row with non existent dept_id


-- Q15: Drop age and city columns.

ALTER TABLE EMPLOYEES
DROP COLUMN age;
ALTER TABLE EMPLOYEES
DROP COLUMN city;


-- Q16: Display departments and employees of that departments.

select d.dept_id, d.dept_name, e.emp_id, e.full_name
from departments d
left join employees e
ON d.dept_id = e.dept_id;


-- Q17: Rename the column salary to monthly_salary and ensure constraints remain intact

ALTER TABLE EMPLOYEES
RENAME COLUMN salary TO monthly_salary;


-- Q18: Write a query to display all departments that have no employees.

select d.dept_id, d.dept_name
from departments d
left join employees e
ON d.dept_id = e.dept_id
WHERE e.emp_id IS NULL;


-- Q19: Write a query to empty the table of students

TRUNCATE TABLE EMPLOYEES;


-- Q20: Find the department that has the maximum number of employees.

select 