CREATE TYPE [dbo].[AccountList] AS TABLE (
	[Index]						INT				IDENTITY(0, 1),
	[Id]						INT					NOT NULL,
	[Node]						HIERARCHYID,

	[ParentIndex]				INT,
	[ParentId]					INT, 

	[IfrsAccountId]				NVARCHAR (255)		NOT NULL, -- Ifrs Concept
	[IsAggregate]				BIT					NOT NULL,
	[IsActive]					BIT					NOT NULL DEFAULT (1),
	[Name]						NVARCHAR (255)		NOT NULL,
	[Name2]						NVARCHAR (255),
	[Name3]						NVARCHAR (255),
	[Code]						NVARCHAR (255),

	[IfrsNoteId]				NVARCHAR (255),		-- includes Expense by function

	[ResponsibilityCenterIsFixed]BIT				NOT NULL DEFAULT (1),
	[ResponsibilityCenterId]	INT,
	[AgentAccountIsFixed]		BIT					NOT NULL DEFAULT (1),
	[AgentAccountId]			INT,
	[ResourceIsFixed]			BIT					NOT NULL DEFAULT (1),
	[ResourceId]				INT,
	[ExpectedSettlingDateIsFixed]BIT				NOT NULL DEFAULT (0),
	[ExpectedSettlingDate]		DATETIME2(7),

	[EntityState]				NVARCHAR (255)	NOT NULL DEFAULT(N'Inserted'),
	PRIMARY KEY ([Index] ASC),
	INDEX IX_AccountList__Code ([Code]),
	CHECK ([EntityState] IN (N'Unchanged', N'Inserted', N'Updated', N'Deleted')),
	CHECK ([EntityState] <> N'Inserted' OR [Id] IS NULL)
);