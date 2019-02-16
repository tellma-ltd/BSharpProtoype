CREATE TABLE [dbo].[Operations] (
	[TenantId]				INT,
	[Id]					INT					IDENTITY,
	[Name]					NVARCHAR (255)		NOT NULL,
	[Name2]					NVARCHAR (255),
	[IsOperatingSegment]	BIT					NOT NULL DEFAULT (0),
	[IsActive]				BIT					NOT NULL DEFAULT (1),
	[ParentId]				INT,
	[Code]					NVARCHAR (255),
-- Lookup lists used for reporting
	[ProductCategoryId]		INT,		-- e.g., sales, services
	[GeographicRegionId]	INT,		-- e.g., Riyadh, Jeddah
	[CustomerSegmentId]		INT,		-- e.g., Corporate, Individual or M, F or Adult youth, etc...
	[FunctionId]			INT,		-- e.g., HQ, Branch, Accommodation
	[CreatedAt]				DATETIMEOFFSET(7)	NOT NULL,
	[CreatedById]			INT		NOT NULL,
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