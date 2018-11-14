﻿CREATE TABLE [dbo].[Entries] (
	[TenantId]			INT            NOT NULL,
    [Id]				 INT IDENTITY (1, 1) NOT NULL,
    [LineId]			INT            NOT NULL,
    [EntryNumber]       INT            NOT NULL,
    [OperationId]       INT            NOT NULL,
    [Reference]         NVARCHAR (50)  NULL,
    [AccountId]         NVARCHAR (255) NOT NULL,
    [CustodyId]         INT            NOT NULL,
    [ResourceId]        INT            NOT NULL,
    [Direction]         SMALLINT       NOT NULL,
    [Amount]            MONEY          NOT NULL,
    [Value]             MONEY          NOT NULL,
    [NoteId]            NVARCHAR (255) NULL,
    [RelatedReference]  NVARCHAR (50)  NULL,
    [RelatedAgentId]    INT            NULL,
    [RelatedResourceId] INT            NULL,
    [RelatedAmount]     MONEY          NULL,
    CONSTRAINT [PK_Entries] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
    CONSTRAINT [CK_Entries_Direction] CHECK ([Direction]=(1) OR [Direction]=(-1)),
    CONSTRAINT [FK_Entries_Accounts] FOREIGN KEY ([AccountId]) REFERENCES [dbo].[Accounts] ([Id]) ON UPDATE CASCADE,
    CONSTRAINT [FK_Entries_Custodies] FOREIGN KEY ([TenantId], [CustodyId]) REFERENCES [dbo].[Custodies] ([TenantId], [Id]),
    CONSTRAINT [FK_Entries_Lines] FOREIGN KEY ([TenantId], [LineId]) REFERENCES [dbo].[Lines] ([TenantId], [Id]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_Entries_Notes] FOREIGN KEY ([NoteId]) REFERENCES [dbo].[Notes] ([Id]) ON UPDATE CASCADE,
    CONSTRAINT [FK_Entries_Operations] FOREIGN KEY ([TenantId], [OperationId]) REFERENCES [dbo].[Operations] ([TenantId], [Id]),
    CONSTRAINT [FK_Entries_Resources] FOREIGN KEY ([TenantId], [ResourceId]) REFERENCES [dbo].[Resources] ([TenantId], [Id])
);
GO

CREATE UNIQUE INDEX [IX_Entries] ON [dbo].[Entries] ([TenantId], [LineId], [EntryNumber])
