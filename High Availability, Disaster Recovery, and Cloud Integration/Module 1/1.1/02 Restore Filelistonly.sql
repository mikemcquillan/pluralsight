USE master;

/************

This script will show the files contained within the Reporting and StockSystem database backups.

************/

-- Ensure you change this path to where you have stored the backup from the course files
RESTORE FILELISTONLY FROM DISK = '\\dc01\databasebackups\reporting.bak'

-- Ensure you change this path to where you have stored the backup from the course files
RESTORE FILELISTONLY FROM DISK = '\\dc01\databasebackups\stocksystem.bak'