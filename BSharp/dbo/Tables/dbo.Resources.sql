CREATE TABLE [dbo].[Resources] (
	[TenantId]					INT,
	[Id]						INT					IDENTITY,
	[MeasurementUnitId]			INT					NOT NULL,
	[ResourceType]				NVARCHAR (255)		NOT NULL,
	[Name]						NVARCHAR (255)		NOT NULL,
	[Name2]						NVARCHAR (255),
	[IsActive]					BIT					NOT NULL CONSTRAINT [DF_Resources_IsActive] DEFAULT (1),
	[Source]					NVARCHAR (255), -- Lease In/Acquisition/Production
	[Purpose]					NVARCHAR (255), -- Lease out/Sale/Production/SG&A
	[Code]						NVARCHAR (255),
	[SystemCode]				NVARCHAR (255),
	[Memo]						NVARCHAR (2048),
	[Reference]					NVARCHAR (255),
	[RelatedReference]			NVARCHAR (255),
	[RelatedAgentId]			INT,
	[RelatedResourceId]			INT,
	[RelatedMeasurementUnitId]	INT,
	[RelatedAmount]				INT,
	[RelatedDateTime]			DATETIMEOFFSET (7),
	[Lookup1]					NVARCHAR (255),
	[Lookup2]					NVARCHAR (255),
	[Lookup3]					NVARCHAR (255),
	[Lookup4]					NVARCHAR (255),
	[PartOfId]					INT, -- for compound assets
	[InstanceOfId]				INT, -- to allow contracts at higher level.
	[ServiceOfId]				INT, -- to relate services to their assets.
	[CreatedAt]					DATETIMEOFFSET(7)	NOT NULL,
	[CreatedById]				INT		NOT NULL,
	[ModifiedAt]				DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedById]				INT		NOT NULL,
	CONSTRAINT [PK_Resources] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [CK_Resources_Source] CHECK ([Source] IN (N'LeaseIn', N'Acquisition', N'Production')),
	CONSTRAINT [CK_Resources_Purpose] CHECK ([Purpose] IN (N'LeaseOut', N'Sale', N'Production', N'Selling', N'GeneralAndAdministrative')),
	CONSTRAINT [FK_Resources_MeasurementUnit] FOREIGN KEY ([TenantId], [MeasurementUnitId]) REFERENCES [dbo].[MeasurementUnits] ([TenantId], [Id]) ON UPDATE CASCADE,
	CONSTRAINT [FK_Resources_Resources_PartOfId] FOREIGN KEY ([TenantId], [PartOfId]) REFERENCES [dbo].[Resources] ([TenantId], [Id]) ON DELETE NO ACTION,
	CONSTRAINT [FK_Resources_Resources_InstanceOfId] FOREIGN KEY ([TenantId], [InstanceOfId]) REFERENCES [dbo].[Resources] ([TenantId], [Id]) ON DELETE NO ACTION,
	CONSTRAINT [FK_Resources_Resources_ServiceOfId] FOREIGN KEY ([TenantId], [ServiceOfId]) REFERENCES [dbo].[Resources] ([TenantId], [Id]) ON DELETE NO ACTION,
);
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Resources__Name]
  ON [dbo].[Resources]([TenantId] ASC, [Name] ASC);
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Resources__Name2]
  ON [dbo].[Resources]([TenantId] ASC, [Name2] ASC) WHERE [Name2] IS NOT NULL;
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Resources__Code]
  ON [dbo].[Resources]([TenantId] ASC, [Code] ASC) WHERE [Code] IS NOT NULL;
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Resources__SystemCode]
  ON [dbo].[Resources]([TenantId] ASC, [SystemCode] ASC) WHERE [SystemCode] IS NOT NULL;
GO