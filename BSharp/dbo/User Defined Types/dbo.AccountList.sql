CREATE TYPE [dbo].[AccountList] AS TABLE (
	[Index]						INT					IDENTITY(0, 1),
	[Id]						UNIQUEIDENTIFIER NOT NULL DEFAULT NEWSEQUENTIALID(),
	[EntityState]				NVARCHAR (255)		NOT NULL DEFAULT N'Inserted',
	[CustomClassificationId]	UNIQUEIDENTIFIER,
	[IfrsAccountId]				NVARCHAR (255)		NOT NULL,
	[Name]						NVARCHAR (255)		NOT NULL,
	[Name2]						NVARCHAR (255),
	[Name3]						NVARCHAR (255),
	[Code]						NVARCHAR (255),
	[PartyReference]			NVARCHAR (255),
	[AgentId]					UNIQUEIDENTIFIER,
	[IfrsNoteIsFixed]			BIT					NOT NULL DEFAULT 0,
	[IfrsNoteId]				NVARCHAR (255),		-- includes Expense by function
	[ResponsibilityCenterId]	UNIQUEIDENTIFIER,
	[ResourceIsFixed]			BIT					NOT NULL DEFAULT 1,
	[ResourceId]				UNIQUEIDENTIFIER,
	[IsActive]					BIT					NOT NULL DEFAULT 1,
	PRIMARY KEY ([Index]),
	INDEX IX_AccountList__Code ([Code]),
	CHECK ([EntityState] IN (N'Unchanged', N'Inserted', N'Updated', N'Deleted'))
);