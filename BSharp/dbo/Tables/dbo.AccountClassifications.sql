CREATE TABLE [dbo].[AccountClassifications]
(
	[TenantId]					INT,
	[AccountClassificationNode]	HIERARCHYID,
	[Level]						AS [AccountClassificationNode].GetLevel(),
	[ParentNode]				AS [AccountClassificationNode].GetAncestor(1),
	[Id]						INT					NOT NULL IDENTITY(1,1),
	[Code]						NVARCHAR (255),
	-- Next one should be IsLeaf or HasData instead.
	[HasEntries]				BIT					NOT NULL,
	[IsActive]					BIT					NOT NULL DEFAULT (1),
	[Name]						NVARCHAR (255)		NOT NULL,
	[Name2]						NVARCHAR (255),
	-- For the following columns, see the corresponding columns in table Entries for documentation
	[CreatedAt]					DATETIMEOFFSET(7)	NOT NULL,
	[CreatedById]				INT					NOT NULL,
	[ModifiedAt]				DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedById]				INT					NOT NULL,
);