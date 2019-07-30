CREATE TABLE [dbo].[ResourceLookup1s] (
	[TenantId]			INT					DEFAULT CONVERT(INT, SESSION_CONTEXT(N'TenantId')),
	[Id]				INT					IDENTITY,
	[Name]				NVARCHAR (255)			NOT NULL, -- appears in select lists
	[Name2]				NVARCHAR (255),
	[Name3]				NVARCHAR (255),
	[IsActive]			BIT					NOT NULL DEFAULT 1,
	[Code]				NVARCHAR(255),	-- Sort code for reporting purposes
	[CreatedAt]			DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(),
	[CreatedById]		INT					NOT NULL DEFAULT CONVERT(INT, SESSION_CONTEXT(N'UserId')),
	[ModifiedAt]		DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(), 
	[ModifiedById]		INT					NOT NULL DEFAULT CONVERT(INT, SESSION_CONTEXT(N'UserId')),
	CONSTRAINT [PK_ResourceLookup1s] PRIMARY KEY CLUSTERED ([TenantId], [Id]),
	CONSTRAINT [FK_ResourceLookup1s__CreatedById] FOREIGN KEY ([TenantId], [CreatedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id]),
	CONSTRAINT [FK_ResourceLookup1s__ModifiedById] FOREIGN KEY ([TenantId], [ModifiedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id])
);
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_ResourceLookup1s__Name]
  ON [dbo].[ResourceLookup1s]([TenantId], [Name]);
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_ResourceLookup1s__Name2]
  ON [dbo].[ResourceLookup1s]([TenantId], [Name2]) WHERE [Name2] IS NOT NULL;
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_ResourceLookup1s__Name3]
  ON [dbo].[ResourceLookup1s]([TenantId], [Name3]) WHERE [Name3] IS NOT NULL;