﻿CREATE TYPE [dbo].[DocumentList] AS TABLE (
    [Id]						INT,
    [State]						NVARCHAR (255)		NOT NULL,
    [TransactionType]			NVARCHAR (255)		NOT NULL,
	[Mode]						NVARCHAR (255)		NOT NULL DEFAULT(N'Draft'),
    [SerialNumber]				INT,
    [ResponsibleAgentId]		INT,
    [ForwardedToAgentId]		INT,
	[FolderId]					INT,
	[LinesMemo]					NVARCHAR (255),
    [LinesStartDateTime]		DATETIMEOFFSET (7),
    [LinesEndDateTime]			DATETIMEOFFSET (7),
	[LinesCustody1]				INT,
	[LinesCustody2]				INT,
	[LinesCustody3]				INT,
	[LinesReference1]			NVARCHAR(255),
	[LinesReference2]			NVARCHAR(255),
	[LinesReference3]			NVARCHAR(255),
	[Status]					NVARCHAR(255)		NOT NULL DEFAULT(N'Inserted'), -- Unchanged, Inserted, Updated, Deleted.
	[TemporaryId]				INT					NOT NULL,
	PRIMARY KEY CLUSTERED ([Id] ASC),
	CHECK ([State]	IN (N'Plan', N'Inquiry', N'Template', N'Demand', N'Voucher')),
	CHECK ([Mode]	IN (N'Void', N'Draft', N'Submitted', N'Posted')),
	CHECK ([Status] IN (N'Unchanged', N'Inserted', N'Updated', N'Deleted'))
	);