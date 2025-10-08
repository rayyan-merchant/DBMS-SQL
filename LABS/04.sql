create table departments(
    dep_id number primary key,
    dep_name varchar(20)
);

create table students(
    stud_id number(3) primary key,
    stud_name varchar(20),
    dep_id number,
    gpa decimal (3,2),
    fee decimal(10,2),
    foreign key(dep_id) references Departments(dep_id)
    );

create table faculty(
    fac_id number(3) primary key,
    fac_name varchar(20),
    dep_id number,
    salary number (10),
    join_date DATE,
    foreign key(dep_id) references departments(dep_id)
    );



create table courses(
    course_id number primary key,
    course_name varchar(20),
    dep_id number,
    foreign key(dep_id) references departments(dep_id)
    );
    

create table enroll(
    stud_id number,
    course_id number,
    primary key (stud_id,course_id),
    foreign key (stud_id) references students(stud_id),
    foreign key(course_id) references courses(course_id)
    );
    
    



insert into departments(dep_id,dep_name) values (1,'CS');
insert into departments(dep_id,dep_name) values (2,'DS');
insert into departments(dep_id,dep_name) values (3,'AI');
insert into departments(dep_id,dep_name) values (4,'SE');



insert into students(stud_id,stud_name,dep_id,gpa,fee) values
(100,'ali',1,3.2,100000);
insert into students(stud_id,stud_name,dep_id,gpa,fee) values
(101,'aiman',2,2.2,150000);
insert into students(stud_id,stud_name,dep_id,gpa,fee) values
(102,'amna',3,3.9,100000);
insert into students(stud_id,stud_name,dep_id,gpa,fee) values
(103,'ahmed',4,1.2,180000);
insert into students(stud_id,stud_name,dep_id,gpa,fee) values
(104,'fahad',1,3.8,100000);
insert into students(stud_id,stud_name,dep_id,gpa,fee) values
(105,'faheem',2,1.9,150000);




insert into faculty(fac_id,fac_name,dep_id,salary,join_date) values
(200,'dr.rija',1,200000,to_date('29-03-2005','dd-mm-yyyy'));
insert into faculty(fac_id,fac_name,dep_id,salary,join_date) values
(201,'dr.ali',2,250000,to_date('14-05-1999','dd-mm-yyyy'));
insert into faculty(fac_id,fac_name,dep_id,salary,join_date) values
(202,'dr.arham',3,100000,to_date('02-01-2007','dd-mm-yyyy'));
insert into faculty(fac_id,fac_name,dep_id,salary,join_date) values
(203,'dr.dania',4,230000,to_date('17-05-2005','dd-mm-yyyy'));
insert into faculty(fac_id,fac_name,dep_id,salary,join_date) values
(204,'dr.hussain',1,90000,to_date('12-12-2005','dd-mm-yyyy'));
insert into faculty(fac_id,fac_name,dep_id,salary,join_date) values
(205,'dr.hunaiza',3,200000,to_date('21-12-2000','dd-mm-yyyy'));



    
insert into courses(course_id,course_name,dep_id) values
(300,'Programming',1);
insert into courses(course_id,course_name,dep_id) values
(301,'ML',2);
insert into courses(course_id,course_name,dep_id) values
(302,'DB',3);
insert into courses(course_id,course_name,dep_id) values
(303,'OOP',1);
insert into courses(course_id,course_name,dep_id) values
(304,'FSE',4);
insert into courses(course_id,course_name,dep_id) values
(305,'TBW',2);


insert into enroll(stud_id,course_id) values
(100,301);
insert into enroll(stud_id,course_id) values
(101,300);
insert into enroll(stud_id,course_id) values
(102,302);
insert into enroll(stud_id,course_id) values
(103,302);
insert into enroll(stud_id,course_id) values
(104,303);
insert into enroll(stud_id,course_id) values
(105,304);
insert into enroll(stud_id,course_id) values
(105,305);



select * from students;
select * from departments;
select * from faculty;
select * from enroll;
select * from courses;


-- Q1. List each department and the number of students in it.

select dep_id, COUNT(*) as no_of_students
FROM students
GROUP by dep_id;

-- or

SELECT 
    d.dep_id,
    d.dep_name,
    (
        SELECT COUNT(*) 
        FROM students s 
        WHERE s.dep_id = d.dep_id
    ) AS no_of_students
FROM 
    departments d;




-- Q2: Find departments where the average GPA of students is greater than 3.0.

select dep_name
from DEPARTMENTS
where dep_id IN (
    select dep_id
    from students
    group by dep_id
    having  AVG(gpa) > 3.0
);



-- Q3: Display the average fee paid by students grouped by course.


select c.course_id, course_name, ROUND(AVG(s.fee),2) as avg_fee
from students s
JOIN enroll e
on e.stud_id = s.STUD_ID
JOIN courses c
on e.COURSE_ID = c.COURSE_ID
group by c.course_id, course_name; 


-- or 

SELECT 
    c.course_id,
    c.course_name,
    (
        SELECT ROUND(AVG(s.fee), 2)
        FROM enroll e
        JOIN students s ON e.stud_id = s.stud_id
        WHERE e.course_id = c.course_id
    ) AS avg_fee
FROM 
    courses c;



-- Q4.Count how many faculty members are assigned to each department.


select d.dep_id, d.dep_name, count(f.fac_id) faculty_count
from faculty f
RIGHT join DEPARTMENTS d
on d.DEP_ID = f.dep_id
group by d.dep_name, d.dep_id;


-- or

SELECT 
    d.dep_id,
    d.dep_name,
    (
        SELECT COUNT(*) 
        FROM faculty f 
        WHERE f.dep_id = d.dep_id
    ) AS faculty_count
FROM 
    departments d;



-- Q5.Find faculty members whose salary is higher than the average salary.

select *
from faculty
where SALARY > (
        select avg(salary)
        from FACULTY
);



-- Q6. Show students whose GPA is higher than at least one student in the CS department.

select *
from students
where gpa > ANY(
    select gpa
    from students
    where dep_id = (
        select dep_id
        from departments
        where dep_name = 'CS'
    )
);



--  Q7: Display the top 3 students with the highest GPA.

select * 
from(
    select *
    from students
    order by gpa desc
)
where rownum <= 3;



-- Q8: Find students enrolled in all the courses that student Ali is enrolled in.

select *
from students s
where stud_id = (
    select stud_id 
    from enroll 
    where course_id IN(
        select course_id 
        from enroll
        where stud_id = (
            select stud_id
            from students
            where stud_name = 'ali'
        )
    )
);



-- or

SELECT s.stud_id, s.stud_name
FROM students s
WHERE NOT EXISTS (
    SELECT course_id
    FROM enroll e_ali
    WHERE e_ali.stud_id = (
        SELECT stud_id
        FROM students
        WHERE LOWER(stud_name) = 'ali'
    )
    MINUS
    SELECT course_id
    FROM enroll e_stud
    WHERE e_stud.stud_id = s.stud_id
);




-- Q9. Show the total fees collected per department.

select dep_id, dep_name, (
                        select SUM(fee)
                        from students s
                        where s.dep_id = d.dep_id) as total_fee
from DEPARTMENTS d;




-- Q10. Display courses taken by students who have GPA above 3.


select DISTINCT c.*
from courses c
join enroll e on e.course_id = c.course_id
join students s on e.stud_id = s.stud_id
where s.gpa > 3;

-- or

select *
from courses
where course_id IN(
    select course_id
    from enroll 
    where stud_id IN(
        select stud_id 
        from students
        where gpa > 3
    )
);



-- Q11. Show departments where the total fees collected exceed 1 million.

select dep_id, dep_name
from departments 
where DEP_ID IN (
    select dep_id
    from students
    group by dep_id
    having SUM(fee) > 1000000
);




-- Q12. Display faculty departments where more than 5 faculty members earn above 100,000 salary.

select dep_id, dep_name
from departments
where DEP_ID IN (
    select dep_id
    from faculty
    where salary > 100000
    group by dep_id
    HAVING COUNT(fac_id) > 5
);



-- Q13. Delete all students whose GPA is below the overall average GPA.

DELETE from students
where GPA < (
    select avg_gpa 
    from (
        select AVG(gpa) as avg_gpa
        from students
    )
);



-- Q14: Delete courses that have no students enrolled. (nice)

delete from courses
where course_id NOT IN (
    select DISTINCT course_id
    from enroll
);
    
    

-- Q15. Copy all students who paid more than the average fee into a new table HighFee_Students.

create table HighFee_Students (
    stud_id number(3) primary key,
    stud_name varchar(20),
    dep_id number,
    gpa decimal (3,2),
    fee decimal(10,2),
    foreign key(dep_id) references Departments(dep_id)
)

insert into highfee_students
select *
from students
where fee < (
    select AVG(fee)
    from students
);



-- Q16: Insert faculty into Retired_Faculty if their joining date is earlier than the minimum joining date in the university.

create table retired_faculty(
    fac_id number(3) primary key,
    fac_name varchar(20),
    dep_id number,
    salary number (10),
    join_date DATE,
    foreign key(dep_id) references departments(dep_id)
    );
    

INSERT into RETIRED_FACULTY
select *
from faculty
where join_date < TO_DATE('2000-01-01', 'yyyy-mm-dd');




-- Q17: Find the department having the maximum total fee collected.


select d.dep_id, d.dep_name
from DEPARTMENTS d
where d.dep_id = (
    select dep_id
    from students
    group by dep_id
    HAVING SUM(fee) = (
        select MAX(SUM(fee))
        from students
        group by dep_id
    )
);



-- Q18: Show the top 3 courses with the highest enrollments using ROWNUM or LIMIT.

select *
FROM (
    select course_id, COUNT(stud_id) as enrollments
    from enroll
    group by course_id
    order by enrollments desc
) 
where rownum < 4;



-- Q19 Display students who have enrolled in more than 3 courses and have GPA greater than the overall average .

select *
from students
where stud_id IN (
    select stud_id
    from enroll
    group by stud_id
    HAVING COUNT(course_id) > 3
)
AND gpa > (
    select AVG(gpa)
    from students
);








-- Q20. Find faculty who do not teach any course and insert them into Unassigned_Faculty.

create table Unassigned_faculty(
    fac_id number(3) primary key,
    fac_name varchar(20),
    dep_id number,
    salary number (10),
    join_date DATE,
    foreign key(dep_id) references departments(dep_id)
    );
    
INSERT into Unassigned_faculty
select * 
from faculty f
where f.dep_id not in(
    SELECT distinct c.dep_id
    from courses c
)







