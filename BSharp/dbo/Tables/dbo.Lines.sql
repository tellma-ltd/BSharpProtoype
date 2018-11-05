CREATE TABLE [dbo].[Lines] (
    [DocumentId]         INT                NOT NULL,
    [LineNumber]         INT                NOT NULL,
    [LineType]           NVARCHAR (50)      NOT NULL,
    [ResponsibleAgentId] INT                NOT NULL,
    [StartDateTime]      DATETIMEOFFSET (7) NOT NULL,
    [EndDateTime]        DATETIMEOFFSET (7) NOT NULL,
    CONSTRAINT [PK_Lines] PRIMARY KEY CLUSTERED ([DocumentId] ASC, [LineNumber] ASC),
    CONSTRAINT [FK_Lines_Documents] FOREIGN KEY ([DocumentId]) REFERENCES [dbo].[Documents] ([Id]) ON DELETE CASCADE,
    CONSTRAINT [FK_Lines_LineTypes] FOREIGN KEY ([LineType]) REFERENCES [dbo].[LineTypes] ([Id]) ON UPDATE CASCADE
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'For continuous events, the start time. ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Lines', @level2type = N'COLUMN', @level2name = N'StartDateTime';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The end time', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Lines', @level2type = N'COLUMN', @level2name = N'EndDateTime';

