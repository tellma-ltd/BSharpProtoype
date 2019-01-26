CREATE TABLE [dbo].[Operations] (
	[TenantId]				INT,
	[Id]					INT					IDENTITY (1, 1),
	[Name]					NVARCHAR (255)		NOT NULL,
	[Name2]					NVARCHAR (255),
	[IsOperatingSegment]	BIT					NOT NULL CONSTRAINT [DF_Operations_IsOperatingSegment] DEFAULT (0),
	[IsActive]				BIT					NOT NULL CONSTRAINT [DF_Operations_IsActive] DEFAULT (1),
	[ParentId]				INT,
	[Code]					NVARCHAR (255),
	[CreatedAt]				DATETIMEOFFSET(7)	NOT NULL,
	[CreatedById]				INT		NOT NULL,
	[ModifiedAt]			DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedById]			INT		NOT NULL,
	CONSTRAINT [PK_Operations] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [FK_Operations_Operations] FOREIGN KEY ([TenantId], [ParentId]) REFERENCES [dbo].[Operations] ([TenantId], [Id]),
	CONSTRAINT [FK_Operations_CreatedById] FOREIGN KEY ([TenantId], [CreatedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id]),
	CONSTRAINT [FK_Operations_ModifiedById] FOREIGN KEY ([TenantId], [ModifiedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id])
);
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Operations__Name]
  ON [dbo].[Operations]([TenantId] ASC, [Name] ASC);
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Operations__Name2]
  ON [dbo].[Operations]([TenantId] ASC, [Name2] ASC) WHERE [Name2] IS NOT NULL;
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Operations__Code]
  ON [dbo].[Operations]([TenantId] ASC, [Code] ASC) WHERE [Code] IS NOT NULL;
GO