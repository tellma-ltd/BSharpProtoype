﻿CREATE TABLE [dbo].[LineTypes] (
	[TenantId]		INT,
	[Id]			NVARCHAR (255) NOT NULL,
	[Description]	NVARCHAR (255),
	CONSTRAINT [PK_LineTypes] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC)
);