CREATE TYPE [dbo].[ResourceList] AS TABLE
(
	[Index]				INT,
  [Id]				INT,
  [MeasurementUnitId]	INT					NOT NULL, 
  [ResourceType]		NVARCHAR (255)		NOT NULL,
  [Name]				NVARCHAR (255)		NOT NULL,
	[IsActive]			BIT					NOT NULL DEFAULT (1),
	[Source]			NVARCHAR (255), -- Lease In/Acquisition/Production
	[Purpose]			NVARCHAR (255), -- Lease out/Sale/Production/SG&A
	[Code]				NVARCHAR (255),
  [Memo]				NVARCHAR (2048),
  [Lookup1]			NVARCHAR (255),
  [Lookup2]			NVARCHAR (255),
  [Lookup3]			NVARCHAR (255),
  [Lookup4]			NVARCHAR (255),
	[PartOf]			INT, -- for compound assets
  [FungibleParentId]	INT,
  [CreatedAt]			DATETIMEOFFSET(7)	NOT NULL,
  [CreatedBy]			NVARCHAR(450)		NOT NULL,
  [ModifiedAt]		DATETIMEOFFSET(7)	NOT NULL, 
  [ModifiedBy]		NVARCHAR(450)		NOT NULL,
	[EntityState]		NVARCHAR(255)		NOT NULL DEFAULT(N'Inserted'),
  PRIMARY KEY CLUSTERED ([Index] ASC),
	CHECK ([Source] IN (N'LeaseIn', N'Acquisition', N'Production')),
	CHECK ([Purpose] IN (N'LeaseOut', N'Sale', N'Production', N'Selling', N'GeneralAndAdministrative')),
	CHECK ([EntityState] IN (N'Unchanged', N'Inserted', N'Updated', N'Deleted')),
	CHECK ([EntityState] <> N'Inserted' OR [Id] IS NULL)
);