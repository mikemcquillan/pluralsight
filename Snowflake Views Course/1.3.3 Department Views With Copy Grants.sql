USE DATABASE HR;

CREATE OR REPLACE VIEW EMPLOYEEDATA.DEPARTMENTTRAINING_IT
COPY GRANTS
AS
SELECT *
    FROM EMPLOYEEDATA.DEPARTMENTTRAINING_ALL
WHERE DEPARTMENT = 'IT';

SELECT *
    FROM EMPLOYEEDATA.DEPARTMENTTRAINING_IT;

CREATE OR REPLACE VIEW EMPLOYEEDATA.DEPARTMENTTRAINING_FINANCE
COPY GRANTS
AS
SELECT *
    FROM EMPLOYEEDATA.DEPARTMENTTRAINING_ALL
WHERE DEPARTMENT = 'Finance';

SELECT *
    FROM EMPLOYEEDATA.DEPARTMENTTRAINING_FINANCE;

CREATE OR REPLACE VIEW EMPLOYEEDATA.DEPARTMENTTRAINING_MARKETING
COPY GRANTS
AS
SELECT *
    FROM EMPLOYEEDATA.DEPARTMENTTRAINING_ALL
WHERE DEPARTMENT = 'Marketing';

CREATE OR REPLACE VIEW EMPLOYEEDATA.DEPARTMENTTRAINING_SALES
COPY GRANTS
AS
SELECT *
    FROM EMPLOYEEDATA.DEPARTMENTTRAINING_ALL
WHERE DEPARTMENT = 'Sales';

CREATE OR REPLACE VIEW EMPLOYEEDATA.DEPARTMENTTRAINING_TECHNOLOGY
COPY GRANTS
AS
SELECT *
    FROM EMPLOYEEDATA.DEPARTMENTTRAINING_ALL
WHERE DEPARTMENT = 'Technology';

CREATE OR REPLACE VIEW EMPLOYEEDATA.DEPARTMENTTRAINING_HUMANRESOURCES
COPY GRANTS
AS
SELECT *
    FROM EMPLOYEEDATA.DEPARTMENTTRAINING_ALL
WHERE DEPARTMENT = 'Human Resources';

CREATE OR REPLACE VIEW EMPLOYEEDATA.DEPARTMENTTRAINING_OPERATIONS
COPY GRANTS
AS
SELECT *
    FROM EMPLOYEEDATA.DEPARTMENTTRAINING_ALL
WHERE DEPARTMENT = 'Operations';

CREATE OR REPLACE VIEW EMPLOYEEDATA.DEPARTMENTTRAINING_CUSTOMERSERVICE
COPY GRANTS
AS
SELECT *
    FROM EMPLOYEEDATA.DEPARTMENTTRAINING_ALL
WHERE DEPARTMENT = 'Customer Service';

CREATE OR REPLACE VIEW EMPLOYEEDATA.DEPARTMENTTRAINING_PRODUCTMANAGEMENT
COPY GRANTS
AS
SELECT *
    FROM EMPLOYEEDATA.DEPARTMENTTRAINING_ALL
WHERE DEPARTMENT = 'Product Management';

CREATE OR REPLACE VIEW EMPLOYEEDATA.DEPARTMENTTRAINING_ADMINISTRATION
COPY GRANTS
AS
SELECT *
    FROM EMPLOYEEDATA.DEPARTMENTTRAINING_ALL
WHERE DEPARTMENT = 'Administration';
