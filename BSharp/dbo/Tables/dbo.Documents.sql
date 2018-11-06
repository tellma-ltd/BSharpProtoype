CREATE TABLE [dbo].[Documents] (
    [Id]                       INT                NOT NULL,
    [State]                    NVARCHAR (10)      NOT NULL,
    [TransactionType]          NVARCHAR (50)      NOT NULL,
    [SerialNumber]             INT                NULL,
    [Mode]                     NVARCHAR (10)      CONSTRAINT [DF_Documents_Mode] DEFAULT (N'Draft') NOT NULL,
    [RecordedByUserId]         NVARCHAR (255)     CONSTRAINT [DF_Documents_RecordedByUserId] DEFAULT (suser_sname()) NOT NULL,
    [RecordedOnDateTime]       DATETIMEOFFSET (7) CONSTRAINT [DF_Documents_RecordingOnAt] DEFAULT (getdate()) NOT NULL,
    [Memo]                     NVARCHAR (255)     NULL,
    [Reference]                NVARCHAR (50)      NULL,
    [ForwardedToUserId]        NVARCHAR (255)     NULL,
    [CommonResponsibleAgentId] INT                NULL,
    [CommonStartDateTime]      DATETIMEOFFSET (7) NULL,
    [CommonEndDateTime]        DATETIMEOFFSET (7) NULL,
    CONSTRAINT [PK_Documents] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Documents_Modes] FOREIGN KEY ([Mode]) REFERENCES [dbo].[Modes] ([Id]) ON UPDATE CASCADE,
    CONSTRAINT [FK_Documents_States] FOREIGN KEY ([State]) REFERENCES [dbo].[States] ([Id]),
    CONSTRAINT [FK_Documents_TransactionTypes] FOREIGN KEY ([TransactionType]) REFERENCES [dbo].[TransactionTypes] ([Id]) ON UPDATE CASCADE
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Plan/Request/Order/Event', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Documents', @level2type = N'COLUMN', @level2name = N'State';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Limits the line types that can fit inside a document', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Documents', @level2type = N'COLUMN', @level2name = 'TransactionType';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'a convenient alias to the document that simplifies documentation and referral', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Documents', @level2type = N'COLUMN', @level2name = N'SerialNumber';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Void >> New >> Draft: Working on Data Entry >> Submitted: Completed Data Entry >> Posted: Validated Data Correctness and Conformity to rule', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Documents', @level2type = N'COLUMN', @level2name = N'Mode';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'brief description of content', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Documents', @level2type = N'COLUMN', @level2name = N'Memo';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The document might have been copied from another manual or computerized system', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Documents', @level2type = N'COLUMN', @level2name = N'Reference';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Inheritable: for events, the one who executed. for orders, the one who approved. for requestes, the one who requested.', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Documents', @level2type = N'COLUMN', @level2name = N'CommonResponsibleAgentId';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Inheritable', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Documents', @level2type = N'COLUMN', @level2name = N'CommonStartDateTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'An inheritable concept', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Documents', @level2type = N'COLUMN', @level2name = N'CommonEndDateTime';

