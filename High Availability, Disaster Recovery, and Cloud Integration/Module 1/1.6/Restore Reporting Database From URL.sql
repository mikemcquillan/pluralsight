SELECT * FROM Reporting.dbo.HourlyOrderData;

-- Change your URL before running this!
RESTORE DATABASE Reporting
FROM URL = N'https://bertietest.blob.core.windows.net/sqlbackups/reporting_backup_2025_10_24_105749.bak';