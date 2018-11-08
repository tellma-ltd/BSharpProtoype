﻿CREATE TYPE [dbo].[DocumentList] AS TABLE (
    [Id]						INT                NOT NULL,
    [State]						NVARCHAR (10)      NULL,
    [TransactionType]			NVARCHAR (50)      NOT NULL,
    [SerialNumber]				INT                NULL,
    [Mode]						NVARCHAR (10)      NOT NULL,
	[FolderId]					INT                NULL,
	[LinesMemo]					NVARCHAR (255)     NULL,
    [LinesResponsibleAgentId]	INT                NULL,
    [LinesStartDateTime]      DATETIMEOFFSET (7) NULL,
    [LinesEndDateTime]        DATETIMEOFFSET (7) NULL,
	[LinesCustody1]				INT NULL,
	[LinesCustody2]				INT NULL,
	[LinesCustody3]				INT NULL,
	[LinesReference1]			NVARCHAR(50)	 NULL,
	[LinesReference2]			NVARCHAR(50)	 NULL,
	[LinesReference3]			NVARCHAR(50)	 NULL,
    [ForwardedToUserId]        NVARCHAR (255)     NULL,
	[Status]					NVARCHAR(50)	NULL,
	PRIMARY KEY CLUSTERED ([Id] ASC));