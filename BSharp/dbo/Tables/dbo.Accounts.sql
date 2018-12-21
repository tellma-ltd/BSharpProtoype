CREATE TABLE [dbo].[Accounts] (
	[TenantId]				INT,
	[Id]					NVARCHAR (255),
	[Name]					NVARCHAR (1024) NOT NULL,
	[Code]					NVARCHAR (255)  NOT NULL,
	[IsActive]				BIT				NOT NULL,
	[AccountType]			NVARCHAR (255)	NOT NULL CONSTRAINT [DF_Accounts_AccountType] DEFAULT (N'Custom'),
--  [AccountSpecification]	NVARCHAR (50)	NOT NULL CONSTRAINT [DF_Accounts_AccountSpecifications] DEFAULT (N'Basic'),
	[IsExtensible]			BIT				NOT NULL CONSTRAINT [DF_Accounts_IsExtensible] DEFAULT (1),
	[ParentId]				NVARCHAR (255),
	CONSTRAINT [PK_Accounts] PRIMARY KEY NONCLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [FK_Accounts_Accounts] FOREIGN KEY ([TenantId], [ParentId]) REFERENCES [dbo].[Accounts] ([TenantId], [Id]), 
	CONSTRAINT [CK_Accounts_AccountType] CHECK ([AccountType] IN (N'Correction', N'Custom', N'Extension', N'Regulatory')),
--	CONSTRAINT [CK_Accounts_AccountSpecification] CHECK ([AccountSpecification] IN (N'Agent', N'Basic', N'Capital', N'Forex', N'Inventory', N'PPE'))
	);
GO

CREATE UNIQUE CLUSTERED INDEX [IX_Accounts__Code] ON [dbo].[Accounts]([TenantId] ASC, [Code] ASC);
GO

CREATE TRIGGER [dbo].[trD_Accounts]
ON [dbo].[Accounts]
FOR DELETE 
AS
SET NOCOUNT ON
-- When deleting A, ParentID
-- Delete all C, P where C = A or below, and P = ParentID or above
	DELETE Accounts_H 
	WHERE (
		C IN (SELECT [Id] FROM Deleted) OR
		C IN (
			SELECT C FROM Accounts_H  
			WHERE P IN (SELECT [Id] FROM Deleted)
		)
	)
	And (
		P IN (SELECT ParentId FROM Deleted) OR
		P IN (
			SELECT P FROM Accounts_H 
			WHERE C IN (SELECT ParentId FROM Deleted)
		)
	);
GO

CREATE TRIGGER [dbo].[trI_Accounts]
ON [dbo].[Accounts]
FOR INSERT -- when inserting a child to a parent, add it to table Accounts_H, add also the grandparents
AS
SET NOCOUNT ON
	DECLARE @TenantId int = CONVERT(int, SESSION_CONTEXT(N'Tenantid'));

	INSERT INTO Accounts_H([TenantId], [C], [P]) -- insert x y where x = A or below and y = parentid and above
	SELECT @TenantId, T1.C, T2.P 
	FROM (
		SELECT [Id] As C FROM Inserted
		UNION 
		SELECT C FROM Accounts_H
		WHERE (
			C IN (SELECT [Id] FROM Inserted) OR
			P IN (SELECT [Id] FROM Inserted)
		)
	) T1 CROSS JOIN (
		SELECT ParentId As P FROM Inserted WHERE ParentId IS Not Null
		UNION 
		SELECT P FROM Accounts_H
		WHERE (
			P IN (SELECT ParentId FROM Inserted) OR
			C IN (SELECT ParentId FROM inserted )
		)
	) T2;
GO
CREATE TRIGGER [dbo].[trU_Accounts]
ON [dbo].[Accounts]
FOR UPDATE
AS
SET NOCOUNT ON
IF Update(Id) Or Update(ParentId)
BEGIN
	DECLARE @TenantId int = CONVERT(int, SESSION_CONTEXT(N'Tenantid'));
	Delete Accounts_H
	WHERE (
		C IN (SELECT [Id] FROM Deleted) OR
		C IN (
			SELECT C FROM Accounts_H
			WHERE P IN (SELECT [Id] FROM Deleted)
		)
	)
	AND (
		P IN (SELECT ParentId FROM Deleted) OR
		P IN (
			SELECT P FROM Accounts_H 
			WHERE C IN (SELECT ParentId FROM Deleted)
		)
	);

	INSERT INTO Accounts_H([TenantId], [C], [P]) -- insert x y where x = A or below and y = parentid and above
	SELECT @TenantId, T1.C, T2.P FROM (
		SELECT [Id] As C FROM Inserted
		UNION 
		SELECT C FROM Accounts_H
		WHERE (
			C IN (SELECT [Id] FROM Inserted) OR
			P IN (SELECT [Id] FROM Inserted)
		)
	) T1 cross Join	(
		SELECT ParentId As P FROM Inserted WHERE ParentId is Not Null
		UNION 
		SELECT P FROM Accounts_H
		WHERE (
			P IN (SELECT ParentId FROM Inserted) OR
			C IN (SELECT ParentId FROM inserted )
		)
	) T2;
END;
GO