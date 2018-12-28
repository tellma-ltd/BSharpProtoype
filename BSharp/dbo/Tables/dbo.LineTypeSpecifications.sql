CREATE TABLE [dbo].[LineTypeSpecifications] (
	[TenantId]					INT,
	[LineType]					NVARCHAR (255)	NOT NULL,
	[EntryNumber]				TINYINT			NOT NULL,
	[Definition]				NVARCHAR (255)	NOT NULL,
	[Operation]					NVARCHAR (255),
	[Account]					NVARCHAR (255),
	[Custody]					NVARCHAR (255),
	[ResourceCalculationBase]	NVARCHAR (255),
	[ResourceExpression]		NVARCHAR (MAX),
	[Direction]					NVARCHAR (255),
	[Amount]					NVARCHAR (255),
	[Value]						NVARCHAR (255),
	[Note]						NVARCHAR (255),
	[RelatedReference]			NVARCHAR (255),
	[RelatedAgent]				NVARCHAR (255),
	[RelatedResource]			NVARCHAR (255),
	[RelatedAmount]				NVARCHAR (255),
	CONSTRAINT [PK_LineTypeSpecifications] PRIMARY KEY CLUSTERED ([TenantId] ASC, [LineType] ASC, [EntryNumber] ASC, [Definition] ASC),
--	CONSTRAINT [FK_LineTypeSpecifications_LineTypes] FOREIGN KEY ([TenantId], [LineType]) REFERENCES [dbo].[LineTypes] ([TenantId], [Id]) ON DELETE CASCADE ON UPDATE CASCADE
);

