USE master;

/************

This script will restore the Reporting and StockSystem databases to your SQL Server.
Restore these databases if you wish to follow along with the course as it progresses.
The script assumes both backup files are stored in the same location.

************/

-- Reporting database restore
IF EXISTS(SELECT 1 FROM sys.databases WHERE [name] = 'Reporting')
 BEGIN;
	PRINT 'Reporting database already exists - either delete or rename the database before restoring.';
 END;
ELSE
 BEGIN;
	-- Ensure you change this path to where you have stored the backup from the course files
	RESTORE DATABASE Reporting
		FROM DISK = '\\dc01\databasebackups\reporting.bak'
	WITH 
		MOVE 'Reporting' TO 'C:\databases\data\reporting.mdf',
		MOVE 'Reporting_log' TO 'C:\databases\logs\reporting_log.ldf';
 END;

-- Stock System database restore
IF EXISTS(SELECT 1 FROM sys.databases WHERE [name] = 'StockSystem')
 BEGIN;
	PRINT 'StockSystem database already exists - either delete or rename the database before restoring.';
 END;
ELSE
 BEGIN;
	-- Ensure you change this path to where you have stored the backup from the course files
	RESTORE DATABASE StockSystem
		FROM DISK = '\\dc01\databasebackups\stocksystem.bak'
	WITH 
		MOVE 'StockSystem' TO 'C:\databases\data\stocksystem.mdf',
		MOVE 'StockSystem_log' TO 'C:\databases\logs\stocksystem_log.ldf';
 END;