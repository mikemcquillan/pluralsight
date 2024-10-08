USE DATABASE HR;

CREATE OR REPLACE VIEW EMPLOYEEDATA.DEPARTMENTTRAINING_COURSECOMPLETIONTOTAL
AS
SELECT  C.COURSEID,
        C.COURSENAME,
        (SELECT COUNT(*) FROM EMPLOYEEDATA.EMPLOYEE) AS EXPECTEDCOURSECOMPLETIONTOTAL,
        COUNT(EC.*) AS ACTUALCOURSECOMPLETIONTOTAL
    FROM EMPLOYEEDATA.COURSE C
        INNER JOIN EMPLOYEEDATA.EMPLOYEECOURSE EC
            ON C.COURSEID = EC.COURSEID
GROUP BY C.COURSEID,
         C.COURSENAME;

SELECT * FROM EMPLOYEEDATA.DEPARTMENTTRAINING_COURSECOMPLETIONTOTAL;