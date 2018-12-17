﻿CREATE TYPE [dbo].[DocumentForSaveNoIdentityList] AS TABLE (
	[Index]					INT,
	[Id]					INT,
	[State]					NVARCHAR (255)		NOT NULL,
	[TransactionType]		NVARCHAR (255)		NOT NULL,
	[ResponsibleAgentId]	INT,
	[FolderId]				INT,
	[LinesMemo]				NVARCHAR (255),
	[LinesStartDateTime]	DATETIMEOFFSET (7),
	[LinesEndDateTime]		DATETIMEOFFSET (7),
	[LinesCustody1]			INT,
	[LinesCustody2]			INT,
	[LinesCustody3]			INT,
	[LinesReference1]		NVARCHAR(255),
	[LinesReference2]		NVARCHAR(255),
	[LinesReference3]		NVARCHAR(255),
	[EntityState]			NVARCHAR(255)		NOT NULL DEFAULT(N'Inserted'),
	PRIMARY KEY CLUSTERED ([Index] ASC),
	CHECK ([State] IN (N'Plan', N'Inquiry', N'Template', N'Demand', N'Voucher')),
	CHECK ([EntityState] IN (N'Unchanged', N'Inserted', N'Updated', N'Deleted')),
	CHECK ([EntityState] <> N'Inserted' OR [Id] IS NULL)
);

