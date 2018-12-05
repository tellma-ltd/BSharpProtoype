﻿CREATE TYPE [dbo].[SettingList] AS TABLE
(
    [Field]		NVARCHAR (255)  NOT NULL,
    [Value]		NVARCHAR (1024) NOT NULL,
	[EntityState]	NVARCHAR(255) NOT NULL DEFAULT(N'Inserted'),
	PRIMARY KEY CLUSTERED ([Field] ASC)
);
