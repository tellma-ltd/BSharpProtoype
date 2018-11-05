﻿CREATE TABLE [dbo].[Users] (
    [Id]           NVARCHAR (450)  NOT NULL,
    [FriendlyName] NVARCHAR (50)   NOT NULL,
    [ProfilePhoto] VARBINARY (MAX) NULL,
    CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED ([Id] ASC)
);
