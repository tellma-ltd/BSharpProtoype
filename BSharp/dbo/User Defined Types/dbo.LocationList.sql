CREATE TYPE [dbo].[LocationList] AS TABLE
(
    [Id]			INT	,
    [LocationType]	NVARCHAR (255)	NOT NULL,
    [Name]			NVARCHAR (255)		NOT NULL,
	[IsActive]		BIT				NOT NULL DEFAULT (1),
    [Address]		NVARCHAR (255),
    [ParentId]		INT,
    [CustodianId]	INT,
	[Status]		NVARCHAR(255)	NOT NULL DEFAULT(N'Inserted'), -- Unchanged, Inserted, Updated, Deleted.
	[TemporaryId]	INT				NOT NULL,
	PRIMARY KEY CLUSTERED ([Id] ASC),
	CHECK ([LocationType] IN (N'CashSafe', N'BankAccount', N'Warehouse', N'Farm', N'ProductionPoint', N'Address'))

);