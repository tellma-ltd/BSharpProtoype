CREATE TABLE [dbo].[Documents] (
	[TenantId]					INT,
	[Id]						INT					IDENTITY (1, 1),
	[State]						NVARCHAR (255)		NOT NULL, -- N'Plan', N'Inquiry', N'Template', N'Demand', N'Voucher'
	[TransactionType]			NVARCHAR (255)		NOT NULL, -- Cash Issue to Supplier, Sales invoice, Investment from shareholder
	[Frequency]					NVARCHAR (255)		NOT NULL DEFAULT (N'OneTime'),
	[Duration]					INT					NOT NULL DEFAULT (0),
	[StartDateTime]				DATETIMEOFFSET (7)	NOT NULL,
	[EndDateTime]				DATETIMEOFFSET (7)	NOT NULL,
	[Mode]						NVARCHAR (255)		NOT NULL DEFAULT (N'Draft'), -- N'Void', N'Draft', N'Submitted', N'Posted'
	[SerialNumber]				INT,				-- auto generated
	[ResponsibleAgentId]		INT,				-- for requests only
	[ForwardedToAgentId]		INT,				-- for all, to appear in notification.	
	[FolderId]					INT,
	-- Line properties
	[LinesMemo]					NVARCHAR (255),
	[LinesCustody1]				INT,
	[LinesCustody2]				INT,
	[LinesCustody3]				INT,
	[LinesReference1]			NVARCHAR(255),
	[LinesReference2]			NVARCHAR(255),
	[LinesReference3]			NVARCHAR(255),
	[CreatedAt]					DATETIMEOFFSET(7)	NOT NULL,
	[CreatedBy]					NVARCHAR(450)		NOT NULL,
	[ModifiedAt]				DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedBy]				NVARCHAR(450)		NOT NULL,
	CONSTRAINT [PK_Documents] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC), -- Data/Demand/Definition-Model-Template/Commitment, Free(text)/Hierarchichal(xml)/Structured(grid)/Transactional
	CONSTRAINT [CK_Documents_State] CHECK ([State] IN (N'Plan', N'Inquiry', N'Template', N'Demand', N'Voucher')),
	CONSTRAINT [CK_Documents_Frequency] CHECK (
		[EndDateTime] =
			CASE 
				WHEN [Frequency] = N'OneTime' THEN [StartDateTime]
				WHEN [Frequency] = N'Daily' THEN DATEADD(DAY, [Duration], [StartDateTime])
				WHEN [Frequency] = N'Weekly' THEN DATEADD(WEEK, [Duration], [StartDateTime])
				WHEN [Frequency] = N'Monthly' THEN DATEADD(MONTH, [Duration], [StartDateTime])
				WHEN [Frequency] = N'Quarterly' THEN DATEADD(QUARTER, [Duration], [StartDateTime])
				WHEN [Frequency] = N'Yearly' THEN DATEADD(YEAR, [Duration], [StartDateTime])
			END),
	CONSTRAINT [CK_Documents_Duration] CHECK ([Frequency] IN (N'OneTime', N'Daily', N'Weekly', N'Monthly', N'Quarterly', N'Yearly')),
	CONSTRAINT [FK_Documents_TransactionTypes] FOREIGN KEY ([TransactionType]) REFERENCES [dbo].[TransactionTypes] ([Id]) ON UPDATE CASCADE, 
	CONSTRAINT [CK_Documents_Mode] CHECK ([Mode] IN (N'Void', N'Draft', N'Submitted', N'Posted'))
 );
GO