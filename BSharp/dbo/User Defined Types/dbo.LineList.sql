CREATE TYPE [dbo].[LineList] AS TABLE (
    [DocumentId]         INT                NOT NULL,
    [LineNumber]         INT                NOT NULL,
    [LineType]           NVARCHAR (50)      NULL,
    [ResponsibleAgentId] INT                NULL,
    [StartDateTime]      DATETIMEOFFSET (7) NULL,
    [EndDateTime]        DATETIMEOFFSET (7) NULL,
    PRIMARY KEY CLUSTERED ([DocumentId] ASC, [LineNumber] ASC));

