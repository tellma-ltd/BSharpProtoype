CREATE TYPE [dbo].[OperationList] AS TABLE
(
	[Index]			INT,
  [Id]			INT,
  [OperationType] NVARCHAR (255)		NOT NULL,
  [Name]			NVARCHAR (255)		NOT NULL,
  [IsActive]		BIT					NOT NULL,	
	[Code]			NVARCHAR (255),
  [ParentId]		INT,
  [CreatedAt]		DATETIMEOFFSET(7)	NOT NULL,
  [CreatedBy]		NVARCHAR(450)		NOT NULL,
  [ModifiedAt]	DATETIMEOFFSET(7)	NOT NULL, 
  [ModifiedBy]	NVARCHAR(450)		NOT NULL,
	[EntityState]	NVARCHAR(255)	NOT NULL DEFAULT(N'Inserted'),
  PRIMARY KEY CLUSTERED ([Index] ASC),
	CHECK ([OperationType] IN (N'BusinessEntity', N'Investment', N'OperatingSegment')),
	CHECK ([EntityState] IN (N'Unchanged', N'Inserted', N'Updated', N'Deleted')),
	CHECK ([EntityState] <> N'Inserted' OR [Id] IS NULL)
);
