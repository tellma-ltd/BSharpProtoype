CREATE TYPE [dbo].[LineList] AS TABLE (
    [Id]				 INT				NOT NULL,
    [DocumentId]         INT                NOT NULL,
    [ResponsibleAgentId] INT                NOT NULL,
    [StartDateTime]      DATETIMEOFFSET (7) NOT NULL,
    [EndDateTime]        DATETIMEOFFSET (7) NOT NULL,
    [Memo]				NVARCHAR(50) NULL, 
	[Status]			NVARCHAR(10) NOT NULL DEFAULT(N'Inserted'), -- Unchanged, Inserted, Updated, Deleted.
	[TemporaryId]		INT	NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC));