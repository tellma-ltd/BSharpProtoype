CREATE TABLE [dbo].[Accounts] (
	[TenantId]				INT,
	[Id]					NVARCHAR (255),
	[Name]					NVARCHAR (1024) NOT NULL,
	[Code]					NVARCHAR (255)  NOT NULL,
	[IsActive]				BIT				NOT NULL,
	[AccountType]			NVARCHAR (255)	NOT NULL CONSTRAINT [DF_Accounts_AccountType] DEFAULT (N'Custom'),
--  [AccountSpecification]	NVARCHAR (50)	NOT NULL CONSTRAINT [DF_Accounts_Accountspecifications] DEFAULT (N'Basic'),
	[IsExtensible]			BIT				NOT NULL CONSTRAINT [DF_Accounts_IsExtensible] DEFAULT (1),
	[ParentId]				NVARCHAR (255),
	CONSTRAINT [PK_Accounts] PRIMARY KEY NONCLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [IX_Accounts_Code] UNIQUE CLUSTERED ([TenantId] ASC, [Code] ASC),
	CONSTRAINT [FK_Accounts_Accounts] FOREIGN KEY ([TenantId], [ParentId]) REFERENCES [dbo].[Accounts] ([TenantId], [Id]), 
	CONSTRAINT [CK_Accounts_AccountType] CHECK ([AccountType] IN (N'Correction', N'Custom', N'Extension', N'Regulatory')),
--	CONSTRAINT [CK_Accounts_Accountspecification] CHECK ([AccountSpecification] IN (N'Agent', N'Basic', N'Capital', N'Forex', N'Inventory', N'PPE'))
	);
GO;
CREATE TRIGGER [dbo].[trD_Accounts]
ON [dbo].[Accounts]
FOR DELETE 
AS
SET NOCOUNT ON
	Delete [Accounts_H]
	WHERE	(C IN (SELECT [Id] FROM Deleted))
	OR		(P IN (SELECT [Id] FROM Deleted));
GO;

CREATE TRIGGER [dbo].[trIU_Accounts]
ON [dbo].[Accounts]
FOR INSERT, UPDATE
AS
SET NOCOUNT ON
IF UPDATE(Code)
BEGIN
	DECLARE @TenantId int = CONVERT(int, SESSION_CONTEXT(N'Tenantid'));
	Delete [Accounts_H]
	WHERE	(C IN (SELECT [Id] FROM Deleted))
	OR		(P IN (SELECT [Id] FROM Deleted));

	MERGE INTO [Accounts_H] As t -- insert x y where x = A or below and y = parentid and above
	USING (
		SELECT T1.C, T2.P FROM (
			SELECT [Code], [Id] As C FROM Inserted
			UNION 
			SELECT [Code], [Id] FROM [Accounts]
		) T1 Join (
			SELECT [Code], [Id] As P FROM Inserted
			UNION 
			SELECT [Code], [Id] FROM [Accounts]
		) T2 ON (T1.Code Like T2.Code + '%' AND T1.Code <> T2.Code)
	) AS s ON (t.C = s.C AND t.P = s.P)
	WHEN NOT MATCHED THEN
	INSERT ([TenantId], C, P)
	VALUES(@TenantId, s.C, s.P);
END;
GO;