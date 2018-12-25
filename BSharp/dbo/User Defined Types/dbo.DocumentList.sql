CREATE TYPE [dbo].[DocumentList] AS TABLE (
	[Id]					INT,
	[State]					NVARCHAR (255)		NOT NULL,
	[TransactionType]		NVARCHAR (255)		NOT NULL,
	[Frequency]				NVARCHAR (255)		NOT NULL,
	[Duration]				INT					NOT NULL,
	[StartDateTime]			DATETIMEOFFSET (7)	NOT NULL,
	[EndDateTime]			DATETIMEOFFSET (7)	NOT NULL,
	[Mode]					NVARCHAR (255)		NOT NULL,
	[SerialNumber]			INT,
	[ResponsibleAgentId]	INT,
	[ForwardedToAgentId]	INT,
	[FolderId]				INT,
	[LinesMemo]				NVARCHAR (255),
	[LinesCustody1]			INT,
	[LinesCustody2]			INT,
	[LinesCustody3]			INT,
	[LinesReference1]		NVARCHAR(255),
	[LinesReference2]		NVARCHAR(255),
	[LinesReference3]		NVARCHAR(255),
	[CreatedAt]				DATETIMEOFFSET(7)	NOT NULL,
	[CreatedBy]				NVARCHAR(450)		NOT NULL,
	[ModifiedAt]			DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedBy]			NVARCHAR(450)		NOT NULL,
	[EntityState]			NVARCHAR(255)		NOT NULL,
	PRIMARY KEY CLUSTERED ([Id] ASC),
	CHECK ([State]	IN (N'Plan', N'Inquiry', N'Template', N'Demand', N'Voucher')),
	CHECK ([Frequency] IN (N'OneTime', N'Daily', N'Weekly', N'Monthly', N'Quarterly', N'Yearly')),
	CHECK (
		[EndDateTime] =
			CASE 
				WHEN [Frequency] = N'OneTime' THEN [StartDateTime]
				WHEN [Frequency] = N'Daily' THEN DATEADD(DAY, [Duration], [StartDateTime])
				WHEN [Frequency] = N'Weekly' THEN DATEADD(WEEK, [Duration], [StartDateTime])
				WHEN [Frequency] = N'Monthly' THEN DATEADD(MONTH, [Duration], [StartDateTime])
				WHEN [Frequency] = N'Quarterly' THEN DATEADD(QUARTER, [Duration], [StartDateTime])
				WHEN [Frequency] = N'Yearly' THEN DATEADD(YEAR, [Duration], [StartDateTime])
			END),
	CHECK ([Mode]	IN (N'Void', N'Draft', N'Submitted', N'Posted')),
	CHECK ([EntityState] IN (N'Unchanged', N'Inserted', N'Updated', N'Deleted')),
	CHECK ([EntityState] <> N'Inserted' OR [Id] IS NULL)
);