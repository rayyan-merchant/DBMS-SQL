-- 1. Database Design using DDL

CREATE TABLE Members(
    MemberID NUMBER PRIMARY KEY,
    Name VARCHAR2(50) NOT NULL,
    Email VARCHAR2(100) UNIQUE NOT NULL,
    JoinDate DATE DEFAULT SYSDATE
);

CREATE TABLE Books(
    BookID NUMBER PRIMARY KEY,
    Title VARCHAR2(200) NOT NULL,
    Author VARCHAR2(100) NOT NULL,
    CopiesAvailable NUMBER CHECK (CopiesAvailable >= 0)
);

CREATE TABLE IssuedBooks(
    IssueID NUMBER PRIMARY KEY,
    MemberID NUMBER,
    BookID NUMBER,
    IssueDate DATE DEFAULT SYSDATE,
    ReturnDate DATE,
    CONSTRAINT fk_member FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
    CONSTRAINT fk_book FOREIGN KEY (BookID) REFERENCES Books(BookID),
    -- CONSTRAINT chk_return CHECK (ReturnDate IS NULL OR ReturnDate >= IssueDate)
);



-- 2. Database Catalog Design





-- 3. DML Queries for Daily Operations

-- A. Insert at least 3 Members and 3 Books.

INSERT INTO Members (MemberID, Name, Email) 
VALUES (1, 'Rayyan', 'rayyan@gmail.com');

INSERT INTO Members (MemberID, Name, Email) 
VALUES (2, 'Malik', 'malik@gmail.com');

INSERT INTO Members (MemberID, Name, Email) 
VALUES (3, 'Arham', 'arham@gmail.com');

INSERT INTO Books (BookID, Title, Author, CopiesAvailable) 
VALUES (101, 'Database Systems', 'Ramez Elmasri', 5);

INSERT INTO Books (BookID, Title, Author, CopiesAvailable) 
VALUES (102, 'Operating Systems Concepts', 'Silberschatz', 3);

INSERT INTO Books (BookID, Title, Author, CopiesAvailable) 
VALUES (103, 'Artificial Intelligence', 'Stuart Russell', 4);

select * from books;
select * from members;

-- B. Record the issuance of a book to a member and update the available copies.
INSERT INTO IssuedBooks (IssueID, MemberID, BookID) 
VALUES (1001, 1, 101);

UPDATE Books
SET CopiesAvailable = CopiesAvailable - 1
WHERE BookID = 101;

select * from books;

select * from IssuedBooks

-- C. Display the names of all members and their issued books using a JOIN query.

SELECT m.Name AS MemberName,
       b.Title AS BookTitle,
       ib.IssueDate,
       ib.ReturnDate
FROM Members m
Inner JOIN IssuedBooks ib 
ON m.MemberID = ib.MemberID
inner JOIN Books b 
ON ib.BookID = b.BookID;


-- 4. Constraint Violation Demonstration

-- a) Key Constraint Violation (Duplicate MemberID)
INSERT INTO Members (MemberID, Name, Email)
VALUES (1, 'ahmed', 'ahmed@gmail.com');

-- b) Referential integrity Violation (Invalid Foreign Key)
INSERT INTO IssuedBooks (IssueID, MemberID, BookID)
VALUES (2001, 10, 101);

-- c) Check Constraint Violation 
INSERT INTO Books (BookID, Title, Author, CopiesAvailable)
VALUES (201, 'Data Science', 'Rayyan', -5);




-- 6.

-- a) Find Members with No Issued Books
SELECT MemberID, Name
FROM Members
WHERE MemberID NOT IN (
    SELECT DISTINCT MemberID
    FROM IssuedBooks
);

-- b) Find Books with Highest Copies
SELECT BookID, Title, CopiesAvailable
FROM Books
WHERE CopiesAvailable = (
    SELECT MAX(CopiesAvailable)
    FROM Books
);

-- c) Find the Most Active Member
SELECT MemberID, Name
FROM Members
WHERE MemberID = (
    SELECT MemberID
    FROM (
        SELECT MemberID, COUNT(*) AS TotalIssued
        FROM IssuedBooks
        GROUP BY MemberID
        ORDER BY TotalIssued DESC
    ) 
    WHERE ROWNUM = 1
);

-- d) Find the Books Not Issued
SELECT BookID, Title
FROM Books
WHERE BookID NOT IN (
    SELECT DISTINCT BookID
    FROM IssuedBooks
);

-- e) Members with Books Overdue (Assume books are overdue if the ReturnDate is NULL and IssueDate is more than 30 days ago.
SELECT MemberID, Name
FROM Members
WHERE MemberID IN (
    SELECT MemberID
    FROM IssuedBooks
    WHERE ReturnDate IS NULL
      AND IssueDate < SYSDATE - 30
);
