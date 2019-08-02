CREATE TABLE [dbo].[TemplateLines] (
	[Id]					UNIQUEIDENTIFIER PRIMARY KEY,
	[DocumentId]			UNIQUEIDENTIFIER	NOT NULL,
	[TemplateLineType]		NVARCHAR (255)		NOT NULL,
	[ValidFrom]				DATETIME2(7)		NOT NULL DEFAULT (CONVERT (date, SYSDATETIME())),
	-- for sales/purchase price lists
	[ResourceId]			UNIQUEIDENTIFIER,
	[Quantity]				MONEY				DEFAULT 1,
	[Price]					MONEY,
	[Currency]				UNIQUEIDENTIFIER,
	[VAT]					MONEY,
	[TOT]					MONEY,
	-- for employee agreement
	[AgentId]				UNIQUEIDENTIFIER,
	[MonthlyBasicSalary]	MONEY,
	[HourlyOvertimeRate]	MONEY,
	[DailyPerDiem]			MONEY,

	[CreatedAt]				DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(),
	[CreatedById]			UNIQUEIDENTIFIER	NOT NULL DEFAULT CONVERT(UNIQUEIDENTIFIER, SESSION_CONTEXT(N'UserId')),
	[ModifiedAt]			DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(),
	[ModifiedById]			UNIQUEIDENTIFIER	NOT NULL DEFAULT CONVERT(UNIQUEIDENTIFIER, SESSION_CONTEXT(N'UserId')),
)
GO
CREATE INDEX [IX_TemplateLines__DocumentId] ON [dbo].[TemplateLines]([DocumentId]);
GO