-- 1. Creating Tables

CREATE TABLE Patient(
    Patient_ID NUMBER PRIMARY KEY,
    Name VARCHAR2(100) NOT NULL,
    Gender CHAR(1) CHECK (Gender IN('M', 'F')),
    DOB DATE,
    Email VARCHAR2(100) UNIQUE,
    Phone VARCHAR2(15),
    Address VARCHAR2(200),
    Username VARCHAR2(50),
    Password VARCHAR2(50)
);

CREATE TABLE Doctor(
    Doctor_ID NUMBER PRIMARY KEY,
    Name VARCHAR2(100) NOT NULL,
    Specialization VARCHAR2(100),
    Username VARCHAR2(50),
    Password VARCHAR2(50)
);

CREATE TABLE Appointment(
    Appointment_ID NUMBER PRIMARY KEY,
    Appointment_Date DATE,
    Appointment_Time VARCHAR2(20),
    Status VARCHAR2(20),
    Clinic_Number VARCHAR2(10),
    Patient_ID NUMBER,
    Doctor_ID NUMBER,
    FOREIGN KEY (Patient_ID) REFERENCES Patient(Patient_ID),
    FOREIGN KEY (Doctor_ID) REFERENCES Doctor(Doctor_ID)
);

CREATE TABLE Prescription(
    Prescription_ID NUMBER PRIMARY KEY,
    Date DATE,
    Doctor_Advice VARCHAR2(500),
    Followup_Required VARCHAR2(10),
    Patient_ID NUMBER,
    Doctor_ID NUMBER,
    FOREIGN KEY (Patient_ID) REFERENCES Patient(Patient_ID),
    FOREIGN KEY (Doctor_ID) REFERENCES Doctor(Doctor_ID)
);

CREATE TABLE Invoice(
    Invoice_ID NUMBER PRIMARY KEY,
    Invoice_Date DATE,
    Amount NUMBER(10,2),
    Payment_Status VARCHAR2(20),
    Payment_Method VARCHAR2(50),
    Patient_ID NUMBER,
    FOREIGN KEY (Patient_ID) REFERENCES Patient(Patient_ID)
);

CREATE TABLE Tests(
    Test_ID NUMBER PRIMARY KEY,
    Blood_Test VARCHAR2(10),
    X_Ray VARCHAR2(10),
    MRI VARCHAR2(10),
    CT_Scan VARCHAR2(10)
);


-- 2) Insert Sample Data

-- Patients
insert into patient (patientid, name, gender, dob, email, phone, address, username, password)
values (1, 'Alice Khan', 'F', to_date('1990-05-12','yyyy-mm-dd'), 'alice@example.com', '0300123456', '123 Main St', 'alice', 'pass123');

insert into patient (patientid, name, gender, dob, email, phone, address, username, password)
values (2, 'Bilal Ahmed', 'M', to_date('1985-08-23','yyyy-mm-dd'), 'bilal@example.com', '0300765432', '456 Park Ave', 'bilal', 'pass456');

insert into patient (patientid, name, gender, dob, email, phone, address, username, password)
values (3, 'Sara Malik', 'F', to_date('1992-11-03','yyyy-mm-dd'), 'sara@example.com', '0300987654', '789 Oak St', 'sara', 'pass789');

-- Doctors
insert into doctor (doctorid, name, specialization, username, password)
values (1, 'Dr. Ahmed', 'Cardiology', 'drahmed', 'docpass1');

insert into doctor (doctorid, name, specialization, username, password)
values (2, 'Dr. Fatima', 'Neurology', 'drfatima', 'docpass2');

-- Appointments
insert into appointment (appointmentid, appointment_date, appointment_time, status, clinic_number, patientid, doctorid)
values (1, to_date('2025-09-01','yyyy-mm-dd'), '10:00', 'Booked', 'C101', 1, 1);

insert into appointment (appointmentid, appointment_date, appointment_time, status, clinic_number, patientid, doctorid)
values (2, to_date('2025-09-02','yyyy-mm-dd'), '11:00', 'Cancelled', 'C102', 2, 2);

insert into appointment (appointmentid, appointment_date, appointment_time, status, clinic_number, patientid, doctorid)
values (3, to_date('2025-09-03','yyyy-mm-dd'), '09:30', 'Booked', 'C101', 3, 1);

-- Prescriptions
insert into prescription (prescriptionid, prescription_date, doctor_advice, followup_required, patientid, doctorid)
values (1, to_date('2025-09-02','yyyy-mm-dd'), 'Take 1 tablet daily', 'Y', 1, 1);

insert into prescription (prescriptionid, prescription_date, doctor_advice, followup_required, patientid, doctorid)
values (2, to_date('2025-09-03','yyyy-mm-dd'), 'Apply ointment twice daily', 'N', 2, 2);

-- Invoices
insert into invoice (invoiceid, invoice_date, amount, payment_status, payment_method, patientid)
values (101, to_date('2025-09-01','yyyy-mm-dd'), 5000, 'Pending', 'Cash', 1);

insert into invoice (invoiceid, invoice_date, amount, payment_status, payment_method, patientid)
values (102, to_date('2025-09-02','yyyy-mm-dd'), 3000, 'Paid', 'Card', 2);

insert into invoice (invoiceid, invoice_date, amount, payment_status, payment_method, patientid)
values (103, to_date('2025-09-03','yyyy-mm-dd'), 4500, 'Paid', 'Cash', 3);

-- Tests
insert into tests (testid, blood_test, xray, mri, ct_scan)
values (1, 'Yes', 'No', 'No', 'No');

insert into tests (testid, blood_test, xray, mri, ct_scan)
values (2, 'No', 'Yes', 'No', 'No');

insert into tests (testid, blood_test, xray, mri, ct_scan)
values (3, 'Yes', 'No', 'Yes', 'No');



-- 3. DML Queries

-- a) Update the phone number and email of a patient in the Patient table.
UPDATE Patient
SET Phone = '03001234567', Email = 'anonymous@gmail.com'
WHERE Patient_ID = 1;

-- b) Update the payment status of an invoice in the Invoice table from "Unpaid" to "Paid".
UPDATE Invoice
SET Payment_Status = 'Paid'
WHERE Invoice_ID = 101 AND Payment_Status = 'Unpaid';

-- c) Delete all cancelled appointments from the Appointment table.
DELETE FROM Appointment
WHERE Status = 'Cancelled';

-- d) Delete an invoice from the Invoice table for a patient who has been refunded.
DELETE FROM Invoice
WHERE Patient_ID = 1 AND Payment_Status = 'Refunded';

-- e) Select all appointments that are still "Booked".
SELECT *
FROM Appointment
WHERE Status = 'Booked';

-- f) Select all invoices that are "Unpaid".
SELECT *
FROM Invoice
WHERE Payment_Status = 'Unpaid';

-- g) Select all lab tests of type "Blood Test".
SELECT *
FROM Tests
WHERE Blood_Test = 'Yes';

-- h) Select all prescriptions issued on '2025-09-02'.
SELECT *
FROM Prescription
WHERE Date = TO_DATE('2025-09-02', 'YYYY-MM-DD');


-- Advance SQL Queries


-- a) Show all patients with their doctors booked.
SELECT p.Patient_ID, p.Name AS Patient_Name, d.Doctor_ID, d.Name AS Doctor_Name
FROM Appointment a
JOIN Patient p 
ON a.Patient_ID = p.Patient_ID
JOIN Doctor d 
ON a.Doctor_ID = d.Doctor_ID
WHERE a.Status = 'Booked';

-- b) Show all lab tests of patients and the doctor who requested them.
SELECT p.Name AS Patient_Name, d.Name AS Doctor_Name, 
       t.Test_ID, t.Blood_Test, t.X_Ray, t.MRI, t.CT_Scan
FROM Tests t
JOIN Patient p 
ON t.Patient_ID = p.Patient_ID
JOIN Doctor d 
ON t.Doctor_ID = d.Doctor_ID;

-- c) Show prescriptions with medicines only for patients named "Ali Khan".
SELECT pr.Prescription_ID, pr.Doctor_Advice, p.Name AS Patient_Name
FROM Prescription pr
JOIN Patient p 
ON pr.Patient_ID = p.Patient_ID
WHERE p.Name = 'Ali Khan';

-- d) Show prescriptions with doctors where follow-up is required.
SELECT pr.Prescription_ID, pr.Date, pr.Doctor_Advice, d.Name AS Doctor_Name, p.Name AS Patient_Name
FROM Prescription pr
JOIN Doctor d 
ON pr.Doctor_ID = d.Doctor_ID
JOIN Patient p 
ON pr.Patient_ID = p.Patient_ID
WHERE pr.Followup_Required = 'Yes';
