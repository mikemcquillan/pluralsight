USE master;

-- Make sure you change the paths!

BACKUP DATABASE StockSystem
TO DISK = 'C:\backups\stocksystem_scriptbackup.bak'
WITH COMPRESSION;

BACKUP DATABASE Reporting
TO DISK = 'C:\backups\reporting_scriptbackup.bak'
WITH COMPRESSION;

BACKUP DATABASE StockSystem
TO DISK = 'C:\backups\stocksystem_scriptbackup_diff.bak'
WITH DIFFERENTIAL, COMPRESSION;

BACKUP DATABASE Reporting
TO DISK = 'C:\backups\reporting_scriptbackup_diff.bak'
WITH DIFFERENTIAL, COMPRESSION; 

BACKUP LOG StockSystem
TO DISK = 'C:\backups\stocksystem_scriptbackup_log.trn'
WITH COMPRESSION;

BACKUP LOG Reporting
TO DISK = 'C:\backups\reporting_scriptbackup_log.trn'
WITH COMPRESSION;
