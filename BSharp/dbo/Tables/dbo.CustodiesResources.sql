CREATE TABLE [dbo].[CustodiesResources]
(
	[TenantId]			INT,
	[Id]				INT					IDENTITY (1, 1),
	[CustodyId]			INT					NOT NULL,
	[ResourceId]		INT					NOT NULL,
	[CreatedAt]			DATETIMEOFFSET(7)	NOT NULL,
	[CreatedBy]			NVARCHAR(450)		NOT NULL,
	[ModifiedAt]		DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedBy]		NVARCHAR(450)		NOT NULL,
	CONSTRAINT [PK_CustodiesResources] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [FK_CustodiesResources_Custodies] FOREIGN KEY ([TenantId], [CustodyId]) REFERENCES [dbo].[Custodies] ([TenantId], [Id])ON DELETE CASCADE,
	CONSTRAINT [FK_CustodiesResources_Resources] FOREIGN KEY ([TenantId], [ResourceId]) REFERENCES [dbo].[Resources] ([TenantId], [Id])ON DELETE CASCADE
);
GO
CREATE NONCLUSTERED INDEX [IX_CustodiesResources__CustodyId]
  ON [dbo].[CustodiesResources]([TenantId] ASC, [CustodyId] ASC);
GO
CREATE NONCLUSTERED INDEX [IX_CustodiesResources__ResourceId]
  ON [dbo].[CustodiesResources]([TenantId] ASC, [ResourceId] ASC);