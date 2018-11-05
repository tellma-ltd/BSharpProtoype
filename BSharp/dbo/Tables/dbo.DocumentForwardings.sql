CREATE TABLE [dbo].[DocumentForwardings] (
    [Id]                INT                NOT NULL,
    [DocumentId]        INT                NOT NULL,
    [ForwardedToUserId] NVARCHAR (450)     NOT NULL,
    [Comment]           NVARCHAR (1024)    NULL,
    [DeliveryChannel]   NCHAR (10)         NULL,
    [DeliveredOnAt]     DATETIMEOFFSET (7) NULL,
    [ReadOnAt]          DATETIMEOFFSET (7) NULL,
    CONSTRAINT [PK_DocumentForwardings] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_DocumentForwardings_Documents] FOREIGN KEY ([DocumentId]) REFERENCES [dbo].[Documents] ([Id]) ON DELETE CASCADE
);

