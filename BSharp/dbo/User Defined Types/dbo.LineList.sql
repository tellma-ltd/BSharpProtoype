CREATE TYPE [dbo].[LineList] AS TABLE (
    [DocumentId]         INT                NOT NULL,
    [LineNumber]         INT                NOT NULL,
    [ResponsibleAgentId] INT                NULL,
    [StartDateTime]      DATETIMEOFFSET (7) NULL,
    [EndDateTime]        DATETIMEOFFSET (7) NULL,
	[Memo]           NVARCHAR (255)      NULL,
	[Status]					NVARCHAR(50)	NULL,
    PRIMARY KEY CLUSTERED ([DocumentId] ASC, [LineNumber] ASC));