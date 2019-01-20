CREATE TABLE [dbo].[Notifications] (
	[TenantId]			INT,
	[Id]				INT					IDENTITY (1, 1),
	[RecipientId]		INT					NOT NULL, -- An agent ... Even those without AVATAR can be notified.
	[ContactChannel]	NVARCHAR(255)		NOT NULL,
	[ContactAddress]	NVARCHAR(255)		NOT NULL,
	[Message]			NVARCHAR (1024),
	[CreatedAt]			DATETIMEOFFSET (7)	NOT NULL,
	[CreatedBy]			NVARCHAR(450)		NOT NULL,
	CONSTRAINT [PK_Notifications] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [CK_Notifications_Channel] CHECK ([ContactChannel] IN (N'Sms', N'Email', N'Messenger', N'WhatsApp')),
	CONSTRAINT [FK_Notifications_RecipientId] FOREIGN KEY ([TenantId], [RecipientId]) REFERENCES [dbo].[Custodies] ([TenantId], [Id])
);
GO
CREATE INDEX [IX_Notifications__RecipientId] ON [dbo].[Notifications]([TenantId] ASC, [RecipientId] ASC);
GO