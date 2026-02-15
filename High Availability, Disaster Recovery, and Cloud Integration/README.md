SQL Server High Availability, Disaster Recovery, and Cloud Integration Course README

Pre-requisites:

- 3 x SQL Server instances, running SQL Server 2022 Developer Edition or Higher
- SSMS 20 or higher

If you plan to follow along with this course, it's assumed you have three SQL Servers, all running Developer Edition.
These are referred to in the course as:

SQL01
SQL02
SQLLISTENER

Ensure the servers are running as follows:

- SQL Agent should be running on all servers
- The SQL Agent service should be set in SQL Server Configuration Manager to run automatically

If you are using SSMS 21 or later, install SSIS using the Visual Studio Installer.
This is necessary if you wish to create maintenance plans.

The database backups are located in the Module 1\1.1\Database Backups folder.

Use the scripts in the Initial Setup folder to create your test environment, run them in numeric sequence.
PLEASE CHECK THE TODOS IN THE SCRIPT FIRST, OTHERWISE THEY WILL NOT RUN.

- Script 01 should be run against SQL01 and SQL02
- Script 02 should only be run against SQL01 (can only be run once the stock system database has been restored)

Ensure neither the stocksystem nor reporting databases are present on SQL01 or SQL02 before starting the course.

AZURE RESOURCES

To back up to Azure, you need to create an Azure storage account. To save costs, configure as follows:

- Storage type: Azure Blob Storage or Azure Data Lake Storage Gen 2
- Performance: Standard
- Redundancy: Locally-redundant storage (LRS)
- Access tier: Cool
- Networking - do not change default options
- Soft delete options - disable all options
- Leave all other options as defaults
- Install Azure Storage Explorer so you can follow along

If you wish to follow along with the Azure SQL Database clips, you will need to create two Azure SQL Database instances.
Scripts can be found in the course files to create these.

LOG SHIPPING

Log shipping has a lot of pre-requisites! Follow these steps to prepare your SQL Servers for log shipping.
Assumptions:

SQL01 - primary
SQL02 - secondary
SQLLISTENER - monitor
DC01 - domain controller with shared folder for log backups

1. On SQL01 and SQL02, run the 01 sp_configure.sql script found in Module 2\2.2. This enables extended stored procedures.
2. Log on to SQL02 via a remote session, and create a folder called C:\backups.
   This is the folder log backups will be copied to for application to SQL02.
3. Create a network share on a server, and make it accessible by Everyone.
   This is the folder the primary server will save log backups to.
   For instance, \\DC01\databasebackups
4. Set up Database Mail on SQLLISTENER. You may need a SMTP server - sendgrid.net offer a free 60-day demo.
5. Set up an operator, with an e-mail address.
6. Give the account SQL Agent uses on the SQL Servers full access to the folders created in steps 2 and 3.
7. Disable any maintenance plan or other backup jobs you have running.
8. Run the 02 Create Order Samples.sql script found in Module 2\2.2. This limits the numbers of orders created for every execution to 1.