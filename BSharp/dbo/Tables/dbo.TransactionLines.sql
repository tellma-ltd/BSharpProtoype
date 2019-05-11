CREATE TABLE [dbo].[TransactionLines] (
	[TenantId]				INT,
	[Id]					INT IDENTITY,
	[DocumentId]			INT					NOT NULL,
	[TransactionLineType]	NVARCHAR(255)		NOT NULL,
	[TemplateLineId]		INT, -- depending on the line type, the user may/may not be allowed to edit
	[ScalingFactor]			FLOAT, -- Qty sold for Price list, Qty produced for BOM
	[Memo]					NVARCHAR(255),

	[Direction1]			SMALLINT,
	[OperationId1]			INT,
	[AccountId1]			INT,
	[AgentId1]				INT,
	[ResourceId1]			INT,
	[Amount1]				MONEY,
	[Value1]				VTYPE,
	[NoteId1]				NVARCHAR (255),
	[Reference1]			NVARCHAR (255),
	[RelatedReference1]		NVARCHAR (255),
	[RelatedAgentId1]		INT,
	[RelatedResourceId1]	INT,
	[RelatedAmount1]		MONEY,

	[Direction2]			SMALLINT,
	[OperationId2]			INT,
	[AccountId2]			INT,
	[AgentId2]				INT,
	[ResourceId2]			INT,
	[Amount2]				MONEY,
	[Value2]				VTYPE,
	[NoteId2]				NVARCHAR (255),
	[Reference2]			NVARCHAR (255),
	[RelatedReference2]		NVARCHAR (255),
	[RelatedAgentId2]		INT,
	[RelatedResourceId2]	INT,
	[RelatedAmount2]		MONEY,

	[Direction3]			SMALLINT,
	[OperationId3]			INT,
	[AccountId3]			INT,
	[AgentId3]				INT,
	[ResourceId3]			INT,
	[Amount3]				MONEY,
	[Value3]				VTYPE,
	[NoteId3]				NVARCHAR (255),
	[Reference3]			NVARCHAR (255),
	[RelatedReference3]		NVARCHAR (255),
	[RelatedAgentId3]		INT,
	[RelatedResourceId3]	INT,
	[RelatedAmount3]		MONEY,

	[Direction4]			SMALLINT,
	[OperationId4]			INT,
	[AccountId4]			INT,
	[AgentId4]				INT,
	[ResourceId4]			INT,
	[Amount4]				MONEY,
	[Value4]				VTYPE,
	[NoteId4]				NVARCHAR (255),
	[Reference4]			NVARCHAR (255),
	[RelatedReference4]		NVARCHAR (255),
	[RelatedAgentId4]		INT,
	[RelatedResourceId4]	INT,
	[RelatedAmount4]		MONEY,

	[CreatedAt]				DATETIMEOFFSET(7)	NOT NULL,
	[CreatedById]			INT					NOT NULL,
	[ModifiedAt]			DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedById]			INT					NOT NULL,
	CONSTRAINT [PK_TransactionLines] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [FK_TransactionLines__Documents] FOREIGN KEY ([TenantId], [DocumentId]) REFERENCES [dbo].[Documents] ([TenantId], [Id]) ON DELETE CASCADE,
	CONSTRAINT [FK_TransactionLines__TransactionLineTypes] FOREIGN KEY ([TenantId], [TransactionLineType]) REFERENCES [dbo].[LineTypes] ([TenantId], [Id]) ON DELETE CASCADE,
	CONSTRAINT [FK_TransactionLines__TemplateLines] FOREIGN KEY ([TenantId], [TemplateLineId]) REFERENCES [dbo].[TemplateLines] ([TenantId], [Id]),
	CONSTRAINT [FK_TransactionLines__CreatedById] FOREIGN KEY ([TenantId], [CreatedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id]),
	CONSTRAINT [FK_TransactionLines__ModifiedById] FOREIGN KEY ([TenantId], [ModifiedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id])
);
GO
CREATE INDEX [IX_TransactionLines__DocumentId] ON [dbo].[TransactionLines]([TenantId] ASC, [DocumentId] ASC);
GO
ALTER TABLE [dbo].[TransactionLines] ADD CONSTRAINT [DF_TransactionLines__TenantId]  DEFAULT (CONVERT(INT, SESSION_CONTEXT(N'TenantId'))) FOR [TenantId];
GO
ALTER TABLE [dbo].[TransactionLines] ADD CONSTRAINT [DF_TransactionLines__CreatedAt]  DEFAULT (SYSDATETIMEOFFSET()) FOR [CreatedAt];
GO
ALTER TABLE [dbo].[TransactionLines] ADD CONSTRAINT [DF_TransactionLines__CreatedById]  DEFAULT (CONVERT(INT,SESSION_CONTEXT(N'UserId'))) FOR [CreatedById]
GO
ALTER TABLE [dbo].[TransactionLines] ADD CONSTRAINT [DF_TransactionLines__ModifiedAt]  DEFAULT (SYSDATETIMEOFFSET()) FOR [ModifiedAt];
GO
ALTER TABLE [dbo].[TransactionLines] ADD CONSTRAINT [DF_TransactionLines__ModifiedById]  DEFAULT (CONVERT(INT,SESSION_CONTEXT(N'UserId'))) FOR [ModifiedById]
GO