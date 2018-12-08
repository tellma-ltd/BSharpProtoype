﻿CREATE TYPE [dbo].[SettingList] AS TABLE
(
    [Field]			NVARCHAR (255)		NOT NULL,
    [Value]			NVARCHAR (1024)		NOT NULL,
    [CreatedAt]		DATETIMEOFFSET(7)	NOT NULL,
    [CreatedBy]		NVARCHAR(450)		NOT NULL,
    [ModifiedAt]	DATETIMEOFFSET(7)	NOT NULL, 
    [ModifiedBy]	NVARCHAR(450)		NOT NULL,
	[EntityState]	NVARCHAR(255) NOT NULL DEFAULT(N'Inserted'),
	PRIMARY KEY CLUSTERED ([Field] ASC)
);
