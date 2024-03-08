USE StockSystem;

GO

CREATE TABLE dbo.Customer
(
 CustomerId				INT IDENTITY(1,1)	NOT NULL,
 FirstName				VARCHAR(100)		NOT NULL,
 LastName				VARCHAR(100)		NOT NULL,
 CustomerName			AS FirstName + ' ' + LastName,
 IsActive				BIT					NOT NULL,
 CreatedDate			DATETIME			NOT NULL CONSTRAINT df_Customer_CreatedDate DEFAULT (GETDATE()),
 CONSTRAINT pk_Customer PRIMARY KEY CLUSTERED (CustomerId)
);

GO

