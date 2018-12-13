CREATE TABLE [dbo].[DocumentForwardings] (
	[TenantId]			 INT,
  [Id]				 INT IDENTITY (1, 1),
  [DocumentId]    INT        NOT NULL,
  [ForwardedToUserId] NVARCHAR (450)   NOT NULL,
  [Comment]      NVARCHAR (1024) ,
  [DeliveryChannel]  NCHAR (10) ,
  [DeliveredOnAt]   DATETIMEOFFSET (7) NULL,
  [ReadOnAt]     DATETIMEOFFSET (7) NULL,
  CONSTRAINT [PK_DocumentForwardings] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
  CONSTRAINT [FK_DocumentForwardings_Documents] FOREIGN KEY ([TenantId], [DocumentId]) REFERENCES [dbo].[Documents] ([TenantId], [Id]) ON DELETE CASCADE
);

