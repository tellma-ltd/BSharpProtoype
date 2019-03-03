CREATE TABLE [dbo].[IFRSNotes] (
	[TenantId]		INT,
	[Id]			NVARCHAR (255),
	[Name]			NVARCHAR (1024) NOT NULL,
	[Code]			NVARCHAR (255)  NOT NULL,
	[Direction]		SMALLINT		NOT NULL,
	[IFRSType]		NVARCHAR (255)  DEFAULT (N'Custom') NOT NULL,
	[IFRSConcept]	NVARCHAR (255)  NOT NULL,
	[IsActive]		BIT				NOT NULL,
	[IsExtensible]	BIT				DEFAULT (0) NOT NULL,
	[ParentId]		NVARCHAR (255),
	CONSTRAINT [PK_IFRSNotes] PRIMARY KEY NONCLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [IX_IFRSNotes_Code] UNIQUE CLUSTERED ([TenantId] ASC, [Code] ASC),
	CONSTRAINT [FK_IFRSNotes_IFRSNotes] FOREIGN KEY ([TenantId], [ParentId]) REFERENCES [dbo].[IFRSNotes] ([TenantId], [Id]),
	CONSTRAINT [CK_IFRSNotes_IFRSNoteType] CHECK ([IFRSType] IN (N'Correction', N'Custom', N'Extension', N'Regulatory')),
	CONSTRAINT [CK_IFRSNotes_Direction] CHECK ([Direction] IN (-1, 0, 1))
);
GO
CREATE UNIQUE INDEX [IX_IFRSNotes_IFRSConcept]
ON [dbo].[IFRSNotes]([TenantId], [IFRSConcept]);
GO

CREATE TRIGGER [dbo].[trD_Notes]
ON [dbo].[IFRSNotes]
FOR DELETE 
AS
SET NOCOUNT ON
	Delete Notes_H
	WHERE	(C IN (SELECT [Id] FROM Deleted))
	OR		(P IN (SELECT [Id] FROM Deleted));
GO;

CREATE TRIGGER [dbo].[trIU_Notes]
ON [dbo].[IFRSNotes]
FOR INSERT, UPDATE
AS
SET NOCOUNT ON
IF UPDATE(Code)
BEGIN
	DECLARE @TenantId int = CONVERT(int, SESSION_CONTEXT(N'Tenantid'));
	Delete Notes_H
	WHERE	(C IN (SELECT [Id] FROM Deleted))
	OR		(P IN (SELECT [Id] FROM Deleted));

	MERGE INTO Notes_H As t -- insert x y where x = A or below and y = parentid and above
	USING (
		SELECT T1.C, T2.P FROM (
			SELECT [Code], [Id] As C FROM Inserted
			UNION 
			SELECT [Code], [Id] FROM [IFRSNotes]
		) T1 Join (
			SELECT [Code], [Id] As P FROM Inserted
			UNION 
			SELECT [Code], [Id] FROM [IFRSNotes]
		) T2 ON (T1.Code Like T2.Code + '%' AND T1.Code <> T2.Code)
	) AS s ON (t.C = s.C AND t.P = s.P)
	WHEN NOT MATCHED THEN
	INSERT ([TenantId], C, P)
	VALUES(@TenantId, s.C, s.P);
END;
GO;