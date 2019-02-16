CREATE TABLE [dbo].[Notifications] (
	[TenantId]			INT,
	[Id]				INT					IDENTITY,
	[RecipientId]		INT					NOT NULL, -- An agent ... Even those without AVATAR can be notified.
	[ContactChannel]	NVARCHAR(255)		NOT NULL,
	[ContactAddress]	NVARCHAR(255)		NOT NULL,
	[Message]			NVARCHAR (1024),
	[CreatedAt]			DATETIMEOFFSET (7)	NOT NULL,
	[CreatedById]			INT		NOT NULL,
	CONSTRAINT [PK_Notifications] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [CK_Notifications_Channel] CHECK ([ContactChannel] IN (N'Sms', N'Email', N'Messenger', N'WhatsApp')),
	CONSTRAINT [FK_Notifications_RecipientId] FOREIGN KEY ([TenantId], [RecipientId]) REFERENCES [dbo].[Agents] ([TenantId], [Id])
);
GO
CREATE INDEX [IX_Notifications__RecipientId] ON [dbo].[Notifications]([TenantId] ASC, [RecipientId] ASC);
GO