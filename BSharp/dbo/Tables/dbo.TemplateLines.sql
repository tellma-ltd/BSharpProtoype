CREATE TABLE [dbo].[TemplateLines] (
	[TenantId]				INT,
	[Id]					INT IDENTITY,
	[DocumentId]			INT					NOT NULL,
	[TemplateLineType]		NVARCHAR(255)		NOT NULL,
	[ValidFrom]				DATETIME2(7)		NOT NULL DEFAULT (CONVERT (date, SYSDATETIME())),
	-- for sales/purchase price lists
	[ResourceId]			INT,
	[Quantity]				MONEY				DEFAULT (1),
	[Price]					MONEY,
	[Currency]				INT,
	[VAT]					MONEY,
	[TOT]					MONEY,
	-- for employee agreement
	[AgentAccountId]		INT,
	[MonthlyBasicSalary]	MONEY,
	[HourlyOvertimeRate]	MONEY,
	[DailyPerDiem]			MONEY,

	[CreatedAt]				DATETIMEOFFSET(7)	NOT NULL,
	[CreatedById]			INT					NOT NULL,
	[ModifiedAt]			DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedById]			INT					NOT NULL,
	CONSTRAINT [PK_TemplateLines] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),

)
GO
CREATE INDEX [IX_TemplateLines__DocumentId] ON [dbo].[TemplateLines]([TenantId] ASC, [DocumentId] ASC);
GO
ALTER TABLE [dbo].[TemplateLines] ADD CONSTRAINT [DF_TemplateLines__TenantId]  DEFAULT (CONVERT(INT, SESSION_CONTEXT(N'TenantId'))) FOR [TenantId];
GO
ALTER TABLE [dbo].[TemplateLines] ADD CONSTRAINT [DF_TemplateLines__CreatedAt]  DEFAULT (SYSDATETIMEOFFSET()) FOR [CreatedAt];
GO
ALTER TABLE [dbo].[TemplateLines] ADD CONSTRAINT [DF_TemplateLines__CreatedById]  DEFAULT (CONVERT(INT,SESSION_CONTEXT(N'UserId'))) FOR [CreatedById]
GO
ALTER TABLE [dbo].[TemplateLines] ADD CONSTRAINT [DF_TemplateLines__ModifiedAt]  DEFAULT (SYSDATETIMEOFFSET()) FOR [ModifiedAt];
GO
ALTER TABLE [dbo].[TemplateLines] ADD CONSTRAINT [DF_TemplateLines__ModifiedById]  DEFAULT (CONVERT(INT,SESSION_CONTEXT(N'UserId'))) FOR [ModifiedById]
GO
