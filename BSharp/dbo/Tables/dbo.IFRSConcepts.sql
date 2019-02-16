CREATE TABLE [dbo].[IFRSConcepts] (
	[TenantId]					INT,
	[IFRSConceptNode]			HIERARCHYID,
	[Level]						AS [IFRSConceptNode].GetLevel(),
	[ParentNode]				AS [IFRSConceptNode].GetAncestor(1),
	[IFRSConceptType]			NVARCHAR (255)	NOT NULL, -- N'Correction', N'Extension', N'Regulatory'
	[IFRSConceptId]				NVARCHAR (255)  NOT NULL,
	[Label]						NVARCHAR (1024) NOT NULL,
	[Label2]					NVARCHAR (1024),
	[Documentation]				NVARCHAR (1024),
	[Documentation2]			NVARCHAR (1024),

	[IsActive]					BIT				NOT NULL,
	[IsExtensible]				BIT				NOT NULL	DEFAULT (1),
	
	[NoteFilter]				NVARCHAR (1024),

	[CustodyFilter]				NVARCHAR (1024),
	[CustodyLabel]				NVARCHAR (255),

	[ReferenceLabel]			NVARCHAR (255),
	
	[ResourceFilter]			NVARCHAR (1024),
	[ResourceLabel]				NVARCHAR (255),

	[DebitAmountLabel]			NVARCHAR (255),
	[CreditAmountLabel]			NVARCHAR (255),

	[RelatedResourceFilter]		NVARCHAR (1024),
	[RelatedResourceLabel]		NVARCHAR (255),
	
	[RelatedCustodyFilter]		NVARCHAR (1024),
	[RelatedCustodyLabel]		NVARCHAR (255),

	[CreatedAt]					DATETIMEOFFSET(7)	NOT NULL,
	[CreatedById]				INT					NOT NULL,
	[ModifiedAt]				DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedById]				INT					NOT NULL,

	CONSTRAINT [PK_IFRSConcepts] PRIMARY KEY ([TenantId] ASC, [IFRSConceptNode] ASC),
	CONSTRAINT [CK_IFRSConcepts_ConceptType] CHECK ([IFRSConceptType] IN (N'Correction', N'Extension', N'Regulatory')),
	CONSTRAINT [IX_IFRSConcepts_ConceptId] UNIQUE ([TenantId] ASC, [IFRSConceptId] ASC),
	CONSTRAINT [FK_IFRSConcepts_CreatedById] FOREIGN KEY ([TenantId], [CreatedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id]),
	CONSTRAINT [FK_IFRSConcepts_ModifiedById] FOREIGN KEY ([TenantId], [ModifiedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id])
	);
GO;
CREATE UNIQUE INDEX IFRSConcepts__Code_Level   
ON [dbo].[IFRSConcepts]([TenantId], [IFRSConceptNode], [Level]) ;  
GO  
/* -- trigger can be avoided by using HierarchyId
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
*/