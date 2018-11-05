CREATE TYPE [dbo].[DocumentList] AS TABLE (
    [Id]                       INT                NOT NULL,
    [State]                    NVARCHAR (10)      NULL,
    [TransactionType]          NVARCHAR (50)      NOT NULL,
    [SerialNumber]             INT                NULL,
    [Mode]                     NVARCHAR (10)      NOT NULL,
    [RecordedByUserId]         NVARCHAR (255)     NOT NULL,
    [RecordedOnDateTime]       DATETIMEOFFSET (7) NOT NULL,
    [Reference]                NVARCHAR (50)      NULL,
    [ForwardedToUserId]        NVARCHAR (255)     NULL,
    [CommonResponsibleAgentId] INT                NULL,
    [CommonStartDateTime]      DATETIMEOFFSET (7) NULL,
    [CommonEndDateTime]        DATETIMEOFFSET (7) NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC));

