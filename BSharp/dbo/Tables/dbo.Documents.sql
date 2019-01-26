﻿CREATE TABLE [dbo].[Documents] (
	[TenantId]					INT,
	[Id]						INT					IDENTITY (1, 1),
	[State]						NVARCHAR (255)		NOT NULL DEFAULT (N'Voucher'), -- N'Plan', N'Inquiry', N'Template', N'Demand', N'Voucher'
	[DocumentType]				NVARCHAR (255)		NOT NULL DEFAULT (N'ManualJournal'),
	[Frequency]					NVARCHAR (255)		NOT NULL DEFAULT (N'OneTime'),
	[Duration]					INT					NOT NULL DEFAULT (0),
	[StartDateTime]				DATETIMEOFFSET (7)	NOT NULL DEFAULT (SYSDATETIMEOFFSET()),
	[EndDateTime]				DATETIMEOFFSET (7)	NOT NULL,
	[Mode]						NVARCHAR (255)		NOT NULL DEFAULT (N'Draft'), -- N'Void', N'Draft', N'Submitted', N'Posted'
	[SerialNumber]				INT,				-- auto generated
	[AssigneeId]				INT,
	[CreatedAt]					DATETIMEOFFSET(7)	NOT NULL,
	[CreatedById]					INT		NOT NULL,
	[ModifiedAt]				DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedById]				INT		NOT NULL,
	CONSTRAINT [PK_Documents] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC), -- Data/Demand/Definition-Model-Template/Commitment, Free(text)/Hierarchichal(xml)/Structured(grid)/Transactional
	CONSTRAINT [CK_Documents_State] CHECK ([State] IN (N'Plan', N'Template', N'Demand', N'Voucher')),
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
	CONSTRAINT [FK_Documents_DocumentTypes] FOREIGN KEY ([TenantId], [DocumentType]) REFERENCES [dbo].[DocumentTypes] ([TenantId], [Id]) ON UPDATE CASCADE, 
	CONSTRAINT [CK_Documents_Mode] CHECK ([Mode] IN (N'Void', N'Draft', N'Posted')),
	CONSTRAINT [FK_Documents_AssigneeId] FOREIGN KEY ([TenantId], [AssigneeId]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id]),
	CONSTRAINT [FK_Documents_CreatedById] FOREIGN KEY ([TenantId], [CreatedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id]),
	CONSTRAINT [FK_Documents_ModifiedById] FOREIGN KEY ([TenantId], [ModifiedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id])
 );
GO