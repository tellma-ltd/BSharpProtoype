CREATE TABLE [dbo].[Documents] (
	[TenantId]					INT,
	[Id]						INT					IDENTITY,
	[State]						NVARCHAR (255)		NOT NULL DEFAULT (N'Voucher'), -- N'Plan', N'Inquiry', N'Template', N'Demand', N'Voucher'
	[DocumentType]				NVARCHAR (255)		NOT NULL DEFAULT (N'manual-journals'), -- limits the allowable line types
	[Frequency]					NVARCHAR (255)		NOT NULL DEFAULT (N'OneTime'), -- an easy way to define a recurrent document
	[Repetitions]					INT					NOT NULL DEFAULT (0), -- time unit is function of frequency
	[StartDateTime]				DATETIME2 (7)		NOT NULL DEFAULT (CONVERT (date, SYSDATETIME())),
	[EndDateTime]				DATETIME2 (7)		NOT NULL DEFAULT (CONVERT (date, SYSDATETIME())), -- computed column
	[Mode]						NVARCHAR (255)		NOT NULL DEFAULT (N'Draft'), -- N'Void', N'Draft', N'Posted'
	[SerialNumber]				INT,				-- auto generated, copied to paper if needed.
	[Reference]					NVARCHAR (255),		-- Overridden by the one in entries. Useful when operating in paper-first mode.
	[AssigneeId]				INT,				-- auto set to Null when document is posted or void.
	[CreatedAt]					DATETIMEOFFSET(7)	NOT NULL,
	[CreatedById]				INT					NOT NULL,
	[ModifiedAt]				DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedById]				INT					NOT NULL,
	CONSTRAINT [PK_Documents] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC), -- Data/Demand/Definition-Model-Template/Commitment, Free(text)/Hierarchichal(xml)/Structured(grid)/Transactional
	CONSTRAINT [CK_Documents_State] CHECK ([State] IN (N'Plan', N'Template', N'Demand', N'Voucher')),
	CONSTRAINT [CK_Documents_Frequency] CHECK (
		[EndDateTime] =
			CASE 
				WHEN [Frequency] = N'OneTime' THEN [StartDateTime]
				WHEN [Frequency] = N'Daily' THEN DATEADD(DAY, [Repetitions], [StartDateTime])
				WHEN [Frequency] = N'Weekly' THEN DATEADD(WEEK, [Repetitions], [StartDateTime])
				WHEN [Frequency] = N'Monthly' THEN DATEADD(MONTH, [Repetitions], [StartDateTime])
				WHEN [Frequency] = N'Quarterly' THEN DATEADD(QUARTER, [Repetitions], [StartDateTime])
				WHEN [Frequency] = N'Yearly' THEN DATEADD(YEAR, [Repetitions], [StartDateTime])
			END),
	CONSTRAINT [CK_Documents_Duration] CHECK ([Frequency] IN (N'OneTime', N'Daily', N'Weekly', N'Monthly', N'Quarterly', N'Yearly')),
	CONSTRAINT [FK_Documents_DocumentTypes] FOREIGN KEY ([TenantId], [DocumentType]) REFERENCES [dbo].[DocumentTypeSpecifications] ([TenantId], [Id]) ON UPDATE CASCADE, 
	CONSTRAINT [CK_Documents_Mode] CHECK ([Mode] IN (N'Void', N'Draft', N'Posted')),
	CONSTRAINT [FK_Documents_AssigneeId] FOREIGN KEY ([TenantId], [AssigneeId]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id]),
	CONSTRAINT [FK_Documents_CreatedById] FOREIGN KEY ([TenantId], [CreatedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id]),
	CONSTRAINT [FK_Documents_ModifiedById] FOREIGN KEY ([TenantId], [ModifiedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id])
 );
GO