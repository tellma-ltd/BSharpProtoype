CREATE TABLE [dbo].[Notes] (
	[TenantId]		INT,
	[Id]			NVARCHAR (255),
	[Name]			NVARCHAR (1024) NOT NULL,
	[Code]			NVARCHAR (255)  NOT NULL,
	[IsActive]		BIT       NOT NULL,
	[NoteType]		NVARCHAR (255)  CONSTRAINT [DF_Notes_NoteType] DEFAULT (N'Custom') NOT NULL,
	[IsExtensible]	BIT       CONSTRAINT [DF_Notes_IsExtensible] DEFAULT ((0)) NOT NULL,
	[ParentId]		NVARCHAR (255),
	CONSTRAINT [PK_Notes] PRIMARY KEY NONCLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [FK_Notes_Notes] FOREIGN KEY ([TenantId], [ParentId]) REFERENCES [dbo].[Notes] ([TenantId], [Id])
);
GO
CREATE CLUSTERED INDEX [IX_Notes_Code]
  ON [dbo].[Notes]([Code] ASC);

