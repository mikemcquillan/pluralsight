USE StockSystem;

GO

DECLARE @CreatedDate	DATE = '2023-10-20',
		@LaterDate		DATE = '2024-01-29';

INSERT INTO dbo.Customer (FirstName, LastName, AllowContactByPhone, CreatedDate)
VALUES
('Stephen', 'Gerrard', 1, @CreatedDate),
('Dennis', 'Potter', 0, @CreatedDate),
('Richard', 'Adams', 0, @CreatedDate),
('Bertie', 'McQuillan', 1, @CreatedDate),
('Walt', 'Disney', 1, @CreatedDate),
('Barbara', 'Gordon', 0, @CreatedDate),
('Josephine', 'Bailey', 1, @CreatedDate),
('Linda', 'Canoglu', 1, @CreatedDate),
('Grace', 'McQuillan', 0, @CreatedDate),
('Vera', 'Black', 0, @CreatedDate),
('Angelica', 'Jones', 1, @CreatedDate),
('Steve', 'Davis', 1, @CreatedDate),
('Allison', 'Fisher', 1, @CreatedDate),
('Julius', 'Marx', 0, @CreatedDate),
('George', 'Formby', 1, @CreatedDate),
('Alan', 'Partridge', 0, @CreatedDate),
('Harper', 'Lee', 1, @CreatedDate),
('Robert', 'Burns', 0, @CreatedDate),
('Michael', 'Parkinson', 0, @CreatedDate),
('Roald', 'Dahl', 1, @CreatedDate),
('Dennis', 'Potter', 0, @LaterDate),
('Richard', 'Adams', 0, @LaterDate),
('George', 'Formby', 1, @LaterDate),
('Alan', 'Partridge', 0, @LaterDate);

GO