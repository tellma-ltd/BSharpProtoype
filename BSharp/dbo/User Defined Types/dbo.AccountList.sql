CREATE TYPE [dbo].[AccountList] AS TABLE (
	[Index]						INT				IDENTITY(0, 1),
	[Id]						INT					NOT NULL,
	[Node]						HIERARCHYID,

	[ParentIndex]				INT,
	[ParentId]					INT, 

	[IFRSAccountId]				NVARCHAR (255)		NOT NULL, -- IFRS Concept
	[IsAggregate]				BIT					NOT NULL,
	[IsActive]					BIT					NOT NULL DEFAULT (1),
	[Name]						NVARCHAR (255)		NOT NULL,
	[Name2]						NVARCHAR (255),
	[Name3]						NVARCHAR (255),
	[Code]						NVARCHAR (255),

	[IFRSNoteId]				NVARCHAR (255),		-- includes Expense by function
	[ResponsibilityCenterId]	INT,
	[AgentAccountId]			INT,
	[ResourceId]				INT,
	[ExpectedSettlingDate]		DATETIME2(7),
	[RelatedResourceId]			INT,
	[RelatedAgentAccountId]		INT,

	[EntityState]		NVARCHAR(255)	NOT NULL DEFAULT(N'Inserted'),
	PRIMARY KEY ([Index] ASC),
	INDEX IX_AccountList__Code ([Code]),
	CHECK ([EntityState] IN (N'Unchanged', N'Inserted', N'Updated', N'Deleted')),
	CHECK ([EntityState] <> N'Inserted' OR [Id] IS NULL)
);

