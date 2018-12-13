CREATE TYPE [dbo].[OperationForSaveList] AS TABLE
(
	[Index]				INT					IDENTITY(0, 1),
  [Id]				INT	,
  [OperationType]		NVARCHAR (255)		NOT NULL,
  [Name]				NVARCHAR (255)		NOT NULL,
	[Code]				NVARCHAR (255),
	[ParentIndex]		INT,
  [ParentId]			INT,  
	[EntityState]		NVARCHAR(255)	NOT NULL DEFAULT(N'Inserted'),
  PRIMARY KEY CLUSTERED ([Index] ASC),
	CHECK ([OperationType] IN (N'BusinessEntity', N'Investment', N'OperatingSegment')),
	CHECK ([EntityState] IN (N'Unchanged', N'Inserted', N'Updated', N'Deleted')),
	CHECK ([EntityState] <> N'Inserted' OR [Id] IS NULL)
);

  


	
