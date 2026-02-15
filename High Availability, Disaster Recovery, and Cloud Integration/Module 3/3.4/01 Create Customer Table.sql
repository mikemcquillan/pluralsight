CREATE TABLE dbo.Customer
(
 CustomerId		INT IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
 FirstName		VARCHAR(100) NOT NULL,
 LastName		VARCHAR(100) NOT NULL,
 CustomerName   AS (FirstName + ' ' + LastName),
 IsActive		BIT NOT NULL,
 CreatedDate	DATETIME NOT NULL,
 CONSTRAINT pk_Customer PRIMARY KEY CLUSTERED (CustomerId)
);

GO

ALTER TABLE dbo.Customer ADD CONSTRAINT df_Customer_CreatedDate DEFAULT (GETDATE()) FOR CreatedDate;

GO