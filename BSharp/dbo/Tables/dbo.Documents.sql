CREATE TABLE [dbo].[Documents] (
    [Id]                       INT                NOT NULL,
    [State]                    NVARCHAR (10)      NOT NULL,
    [TransactionType]          NVARCHAR (50)      NOT NULL,
    [SerialNumber]             INT                NULL,
    [Mode]                     NVARCHAR (10)      CONSTRAINT [DF_Documents_Mode] DEFAULT (N'Draft') NOT NULL,
	[FolderId]				   INT                NULL,
	-- Common properties
	[LinesMemo]                     NVARCHAR (255)     NULL,
    [LinesResponsibleAgentId]	   INT                NULL,
    [LinesStartDateTime]      DATETIMEOFFSET (7) NULL,
    [LinesEndDateTime]        DATETIMEOFFSET (7) NULL,
	[LinesCustody1]				INT NULL,
	[LinesCustody2]				INT NULL,
	[LinesCustody3]				INT NULL,
	[LinesReference1]			NVARCHAR(50)	 NULL,
	[LinesReference2]			NVARCHAR(50)	 NULL,
	[LinesReference3]			NVARCHAR(50)	 NULL,
    [ForwardedToUserId]        NVARCHAR (255)     NULL,
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