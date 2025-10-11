-- ===== Department =====
CREATE TABLE department (
    dpt_id INT PRIMARY KEY,
    dpt_name VARCHAR2(30)
);

INSERT INTO department VALUES (1, 'HR');
INSERT INTO department VALUES (2, 'IT');
INSERT INTO department VALUES (3, 'Sales');
INSERT INTO department VALUES (4, 'Logistics');


-- ===== Employee =====
CREATE TABLE employee (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR2(30),
    dpt_id INT,
    CONSTRAINT dpt_fk FOREIGN KEY (dpt_id) REFERENCES department(dpt_id)
);

INSERT INTO employee VALUES (1, 'Alice', 1);
INSERT INTO employee VALUES (2, 'Bob', 2);
INSERT INTO employee VALUES (3, 'Charlie', 2);
INSERT INTO employee VALUES (4, 'David', 2);
INSERT INTO employee VALUES (5, 'Eve', 1);
INSERT INTO employee VALUES (6, 'Frank', 3);
INSERT INTO employee VALUES (7, 'George', 3);

-- Add Manager Relationship
ALTER TABLE employee ADD (mngr_id INT, CONSTRAINT mngr_fk FOREIGN KEY (mngr_id) REFERENCES employee(emp_id));

UPDATE employee SET mngr_id = 2 WHERE emp_id IN (3, 4);
UPDATE employee SET mngr_id = 1 WHERE emp_id = 5;
UPDATE employee SET mngr_id = 6 WHERE emp_id = 7;


-- ===== emp_project =====
CREATE TABLE emp_project (
    proj_id INT PRIMARY KEY,
    proj_name VARCHAR2(20)
);

ALTER TABLE employee ADD (proj_id INT, CONSTRAINT proj_fk FOREIGN KEY (proj_id) REFERENCES emp_project(proj_id));

INSERT INTO emp_project VALUES (1, 'Orange');
INSERT INTO emp_project VALUES (2, 'Mango');
INSERT INTO emp_project VALUES (3, 'Apple');

UPDATE employee SET proj_id = 1 WHERE emp_id IN (1, 3, 6);
UPDATE employee SET proj_id = 2 WHERE emp_id IN (2, 4, 5);


-- ===== Student =====
CREATE TABLE student (
    std_id INT PRIMARY KEY,
    std_name VARCHAR2(50),
    city VARCHAR2(50)
);

INSERT INTO student VALUES (1, 'Alice', 'Karachi');
INSERT INTO student VALUES (2, 'Bob', 'Lahore');
INSERT INTO student VALUES (3, 'Eve', 'Karachi');


-- ===== Teacher =====
CREATE TABLE teacher (
    tch_id INT PRIMARY KEY,
    tch_name VARCHAR2(50),
    city VARCHAR2(50)
);

INSERT INTO teacher VALUES (1, 'Charlie', 'Karachi');
INSERT INTO teacher VALUES (2, 'David', 'Islamabad');


-- ===== Course =====
CREATE TABLE course (
    crs_id INT PRIMARY KEY,
    crs_name VARCHAR2(20)
);

INSERT INTO course VALUES (1, 'PF');
INSERT INTO course VALUES (2, 'Stats');
INSERT INTO course VALUES (3, 'DBS');
INSERT INTO course VALUES (4, 'AI');


-- ===== Faculty =====
CREATE TABLE faculty (
    ft_id INT PRIMARY KEY,
    ft_name VARCHAR2(30)
);

INSERT INTO faculty VALUES (1, 'Dr. Ahsan');
INSERT INTO faculty VALUES (2, 'Dr. Ali');
INSERT INTO faculty VALUES (3, 'Dr. Fatima');

ALTER TABLE faculty ADD (crs_id INT, CONSTRAINT faculty_crs_fk FOREIGN KEY (crs_id) REFERENCES course(crs_id));

UPDATE faculty SET crs_id = 1 WHERE ft_id IN (1, 2);
UPDATE faculty SET crs_id = 2 WHERE ft_id = 3;


-- ===== Customer & Orders =====
CREATE TABLE customer (
    cst_id INT PRIMARY KEY,
    cst_name VARCHAR2(20)
);

CREATE TABLE cust_order (
    ord_id INT PRIMARY KEY,
    cst_id INT,
    CONSTRAINT cust_fk FOREIGN KEY (cst_id) REFERENCES customer(cst_id)
);

INSERT INTO customer VALUES (1, 'Ali');
INSERT INTO customer VALUES (2, 'Abser');
INSERT INTO customer VALUES (3, 'Owais');
INSERT INTO customer VALUES (4, 'Fasih');

INSERT INTO cust_order VALUES (1, 1);
INSERT INTO cust_order VALUES (2, 1);
INSERT INTO cust_order VALUES (3, 2);


-- ===== Enrollment =====
CREATE TABLE enrollment (
    std_id INT,
    crs_id INT,
    tch_id INT,
    PRIMARY KEY (std_id, crs_id),
    FOREIGN KEY (std_id) REFERENCES student(std_id),
    FOREIGN KEY (crs_id) REFERENCES course(crs_id),
    FOREIGN KEY (tch_id) REFERENCES teacher(tch_id)
);

INSERT INTO enrollment VALUES (1, 1, 1);
INSERT INTO enrollment VALUES (1, 2, 2);
INSERT INTO enrollment VALUES (2, 1, 1);
INSERT INTO enrollment VALUES (2, 2, 2);


-- ===== Employee Additional Columns =====
ALTER TABLE employee ADD (salary INT, hire_date DATE);

UPDATE employee SET salary = 50000 WHERE dpt_id = 1;
UPDATE employee SET salary = 60000 WHERE dpt_id = 2;
UPDATE employee SET salary = 40000 WHERE dpt_id = 3;

UPDATE employee SET hire_date = TO_DATE('15-01-2020', 'DD-MM-YYYY') WHERE emp_id = 1;
UPDATE employee SET hire_date = TO_DATE('20-03-2020', 'DD-MM-YYYY') WHERE emp_id = 2;
UPDATE employee SET hire_date = TO_DATE('03-12-2021', 'DD-MM-YYYY') WHERE emp_id = 3;

INSERT INTO employee VALUES (8, 'David', 2, 2, 70000, NULL, NULL, NULL);







-- Q1: Display all possible pairs of employees and departments
SELECT * FROM employee e CROSS JOIN department d;

-- Q2: Show all departments and employees, even if no employees are assigned
SELECT * FROM department d LEFT JOIN employee e ON d.dpt_id = e.dpt_id;

-- Q3: Display employee names with their manager names
SELECT e1.emp_name AS "Employee Name", e2.emp_name AS "Manager Name"
FROM employee e1
JOIN employee e2 ON e1.mngr_id = e2.emp_id;

-- Q4: Find employees who have not been assigned any project
SELECT * FROM employee WHERE proj_id IS NULL;

-- Q5: Display student names with their enrolled course names
ALTER TABLE student ADD (crs_id INT, CONSTRAINT std_crs_fk FOREIGN KEY (crs_id) REFERENCES course(crs_id));

UPDATE student SET crs_id = 2 WHERE std_id IN (1, 3);
UPDATE student SET crs_id = 1 WHERE std_id = 2;

SELECT s.std_name, c.crs_name
FROM student s
JOIN course c ON s.crs_id = c.crs_id;

-- Q6: Display all customers with their orders
SELECT * FROM customer c LEFT JOIN cust_order co ON c.cst_id = co.cst_id;

-- Q7: Show all departments and employees (even if a department has none)
SELECT d.dpt_name, e.emp_name
FROM department d LEFT JOIN employee e ON d.dpt_id = e.dpt_id;

-- Q8: Display all pairs of teachers and subjects (courses)
SELECT f.ft_name, c.crs_name
FROM faculty f CROSS JOIN course c;

-- Q9: Show all departments along with total employees
SELECT d.dpt_name AS "Department", COUNT(e.emp_id) AS "Total Employees"
FROM department d
JOIN employee e ON d.dpt_id = e.dpt_id
GROUP BY d.dpt_name;

-- Q10: Show each student, their course, and their teacher
ALTER TABLE student ADD (ft_id INT, CONSTRAINT std_ft_fk FOREIGN KEY (ft_id) REFERENCES faculty(ft_id));

UPDATE student SET ft_id = 1 WHERE std_id = 1;
UPDATE student SET ft_id = 2 WHERE std_id = 2;
UPDATE student SET ft_id = 3 WHERE std_id = 3;

SELECT s.std_name, f.ft_name, c.crs_name
FROM student s
JOIN course c ON s.crs_id = c.crs_id
JOIN faculty f ON s.ft_id = f.ft_id;

-- Q11: Show all students and teachers where student city = teacher city
SELECT s.std_name, t.tch_name
FROM student s
JOIN teacher t ON s.city = t.city;

-- Q12: Employees and their managers (including those without)
SELECT e.emp_name AS "Employee Name", m.emp_name AS "Manager Name"
FROM employee e
LEFT JOIN employee m ON m.emp_id = e.mngr_id;

-- Q13: Find employees who don’t belong to any department
SELECT e.emp_name AS "Employee Name"
FROM employee e
WHERE e.dpt_id IS NULL;

-- Q14: Show average salary per department where avg > 50,000
SELECT d.dpt_name AS "Department Name", AVG(e.salary) AS "Average Salary"
FROM department d
JOIN employee e ON d.dpt_id = e.dpt_id
GROUP BY d.dpt_id, d.dpt_name
HAVING AVG(e.salary) > 50000;

-- Q15: Employees earning more than average in their department
SELECT e.emp_name AS "Employee Name"
FROM employee e
WHERE e.salary > (SELECT AVG(salary) FROM employee WHERE dpt_id = e.dpt_id);

-- Q16: Departments where no employee earns less than 30,000
SELECT d.dpt_name AS "Department Name"
FROM department d
JOIN employee e ON d.dpt_id = e.dpt_id
GROUP BY d.dpt_id, d.dpt_name
HAVING MIN(e.salary) > 30000;

-- Q17: Students and their courses where city = 'Lahore'
SELECT s.std_name, c.crs_name
FROM student s
JOIN enrollment e ON s.std_id = e.std_id
JOIN course c ON e.crs_id = c.crs_id
WHERE s.city LIKE 'Lahore';

-- Q18: Employees with manager and department where hire date BETWEEN 2020–2023
SELECT
  e.emp_name AS "Employee Name",
  m.emp_name AS "Manager Name",
  d.dpt_name AS "Department Name"
FROM employee e
LEFT JOIN employee m ON e.mngr_id = m.emp_id
LEFT JOIN department d ON e.dpt_id = d.dpt_id
WHERE e.hire_date BETWEEN TO_DATE('01-01-2020', 'DD-MM-YYYY') AND TO_DATE('01-01-2023', 'DD-MM-YYYY');

-- Q19: Students enrolled in courses taught by ‘Sir Ali’
UPDATE teacher SET tch_name = 'Sir Ali' WHERE tch_id = 1;

SELECT s.std_name
FROM student s
JOIN enrollment e ON s.std_id = e.std_id
JOIN teacher t ON e.tch_id = t.tch_id
WHERE t.tch_name LIKE 'Sir Ali';

-- Q20: Employees whose manager is from the same department
SELECT e.emp_name AS "Employee Name"
FROM employee e
JOIN employee m ON e.mngr_id = m.emp_id
WHERE m.dpt_id = e.dpt_id;

