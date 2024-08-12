CREATE DATABASE IF NOT EXISTS HR;

USE DATABASE HR;

CREATE OR REPLACE SCHEMA EMPLOYEEDATA;

CREATE OR REPLACE TABLE EMPLOYEEDATA.EMPLOYEE
(
 EmployeeId     INT,
 EmployeeName   VARCHAR(60),
 Gender         VARCHAR(10),
 DateOfBirth    DATE,
 Age            INT,
 MaritalStatus  VARCHAR(15),
 Nationality    VARCHAR(20),
 City           VARCHAR(20),
 State          VARCHAR(20),
 Country        VARCHAR(20),
 JobTitle       VARCHAR(50),
 Department     VARCHAR(30),
 BusinessUnit   VARCHAR(30),
 Division       VARCHAR(30),
 CONSTRAINT pk_Employee PRIMARY KEY (EmployeeId)
);

CREATE OR REPLACE TABLE EMPLOYEEDATA.COURSE
(
 CourseId       INT,
 CourseName     VARCHAR(70),
 CONSTRAINT pk_Course PRIMARY KEY (CourseId)
);

CREATE OR REPLACE TABLE EMPLOYEEDATA.EMPLOYEECOURSE
(
 EmployeeId         INT,
 CourseId           INT,
 CompletionStatus   VARCHAR(10),
 CompletionDate     DATE,
 CONSTRAINT pk_EmployeeCourse PRIMARY KEY (EmployeeId, CourseId)
);
