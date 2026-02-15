-- Add a database called Reporting to AAG on the primary replica
ALTER AVAILABILITY GROUP [SQLAAG] ADD DATABASE [Reporting];

-- Add a database called Reporting to AAG on a secondary replica
ALTER DATABASE [Reporting] SET HADR AVAILABILITY GROUP = [SQLAAG];