USE master;

DROP DATABASE StockSystem;

RESTORE DATABASE StockSystem
FROM DISK = 'c:\backups\StockSystem_backup_2025_10_23_225433_5115474.bak'
WITH NORECOVERY;

RESTORE DATABASE StockSystem
FROM DISK = 'c:\backups\StockSystem_backup_2025_10_23_231145_0473792.bak'
WITH NORECOVERY;

RESTORE LOG StockSystem
FROM DISK = 'C:\backups\StockSystem_backup_2025_10_23_232146_7503759.trn'
WITH NORECOVERY,
STOPAT = '2025-10-23 23:38:11';

RESTORE LOG StockSystem
FROM DISK = 'c:\backups\StockSystem_backup_2025_10_23_234404_2817487.trn'
WITH NORECOVERY,
STOPAT = '2025-10-23 23:38:11';

RESTORE DATABASE StockSystem WITH RECOVERY;

SELECT TOP 50 * 
FROM StockSystem.dbo.OrderHeader
ORDER BY OrderHeaderId DESC;
