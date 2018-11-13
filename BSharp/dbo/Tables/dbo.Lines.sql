CREATE TABLE [dbo].[Lines] (
	[TenantId]			 INT				NOT NULL,
    [Id]				 INT IDENTITY (1, 1) NOT NULL,
    [DocumentId]         INT                NOT NULL,
    [ResponsibleAgentId] INT                NOT NULL,
    [StartDateTime]      DATETIMEOFFSET (7) NOT NULL,
    [EndDateTime]        DATETIMEOFFSET (7) NOT NULL,
    [Memo]				NVARCHAR(50) NULL, 
    CONSTRAINT [PK_Lines] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
    CONSTRAINT [FK_Lines_Documents] FOREIGN KEY ([TenantId], [DocumentId]) REFERENCES [dbo].[Documents] ([TenantId], [Id]) ON DELETE CASCADE,
);
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'For continuous events, the start time. ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Lines', @level2type = N'COLUMN', @level2name = N'StartDateTime';
GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'The end time', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Lines', @level2type = N'COLUMN', @level2name = N'EndDateTime';