CREATE TABLE [dbo].[TemplateLines] (
	[TenantId]				INT					DEFAULT CONVERT(INT, SESSION_CONTEXT(N'TenantId')),
	[Id]					INT IDENTITY,
	[DocumentId]			INT					NOT NULL,
	[TemplateLineType]		NVARCHAR (255)		NOT NULL,
	[ValidFrom]				DATETIME2(7)		NOT NULL DEFAULT (CONVERT (date, SYSDATETIME())),
	-- for sales/purchase price lists
	[ResourceId]			INT,
	[Quantity]				MONEY				DEFAULT 1,
	[Price]					MONEY,
	[Currency]				INT,
	[VAT]					MONEY,
	[TOT]					MONEY,
	-- for employee agreement
	[AgentAccountId]		INT,
	[MonthlyBasicSalary]	MONEY,
	[HourlyOvertimeRate]	MONEY,
	[DailyPerDiem]			MONEY,

	[CreatedAt]				DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(),
	[CreatedById]			INT					NOT NULL DEFAULT CONVERT(INT, SESSION_CONTEXT(N'UserId')),
	[ModifiedAt]			DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(),
	[ModifiedById]			INT					NOT NULL DEFAULT CONVERT(INT, SESSION_CONTEXT(N'UserId')),
	CONSTRAINT [PK_TemplateLines] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC)
)
GO
CREATE INDEX [IX_TemplateLines__DocumentId] ON [dbo].[TemplateLines]([TenantId] ASC, [DocumentId] ASC);
GO