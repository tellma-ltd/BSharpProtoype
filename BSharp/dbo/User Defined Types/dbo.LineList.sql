CREATE TYPE [dbo].[LineList] AS TABLE (
    [DocumentId]         INT                NOT NULL,
    [LineNumber]         INT                NOT NULL,
    [ResponsibleAgentId] INT                NULL,
    [StartDateTime]      DATETIMEOFFSET (7) NULL,
    [EndDateTime]        DATETIMEOFFSET (7) NULL,
	[Memo]		        NVARCHAR (255)      NULL,
	[Status]			NVARCHAR(10) NOT NULL DEFAULT(N'Inserted'), -- Unchanged, Inserted, Updated, Deleted.
	[TemporaryId]		INT	NULL,
    PRIMARY KEY CLUSTERED ([DocumentId] ASC, [LineNumber] ASC));