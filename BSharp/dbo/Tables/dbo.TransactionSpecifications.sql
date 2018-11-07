CREATE TABLE [dbo].[TransactionSpecifications] (
    [TransactionType]         NVARCHAR (50)  NOT NULL,
    [EntryNumber]      TINYINT        NOT NULL,
    [Definition]       NVARCHAR (50)  NOT NULL,
    [Operation]        NVARCHAR (255) NULL,
    [Account]          NVARCHAR (255) NULL,
    [Custody]          NVARCHAR (255) NULL,
    [Resource]         NVARCHAR (255) NULL,
    [Direction]        NVARCHAR (255) NULL,
    [Amount]           NVARCHAR (255) NULL,
    [Value]            NVARCHAR (255) NULL,
    [Note]             NVARCHAR (255) NULL,
    [RelatedReference] NVARCHAR (255) NULL,
    [RelatedAgent]     NVARCHAR (255) NULL,
    [RelatedResource]  NVARCHAR (255) NULL,
    [RelatedAmount]    NVARCHAR (255) NULL,
    [RelatedUDLMember] NVARCHAR (255) NULL,
    CONSTRAINT [PK_TransactionTemplates] PRIMARY KEY CLUSTERED ([TransactionType] ASC, [EntryNumber] ASC, [Definition] ASC),
    CONSTRAINT [FK_TransactionTemplates_TransactionTypes] FOREIGN KEY ([TransactionType]) REFERENCES [dbo].[TransactionTypes] ([Id]) ON DELETE CASCADE ON UPDATE CASCADE
);

