CREATE TABLE [dbo].[Lines] (
	[TenantId]		INT,
    [Id]			INT IDENTITY (1, 1),
    [DocumentId]	INT					NOT NULL,
	[Assertion]		SMALLINT DEFAULT(1)	NOT NULL, -- (-1) for negation.
    [StartDateTime]	DATETIMEOFFSET (7)	NOT NULL, -- in future for demands and in past for vouchers, validity period for template and plan. Meaningless for inquiries.
    [EndDateTime]	DATETIMEOFFSET (7)	NOT NULL, -- if we make start and period, then period will have meaning for templates
	[BaseLineId]	INT, -- If invoice/voucher line is based on template or order line.
    [Memo]			NVARCHAR(255), 
    CONSTRAINT [PK_Lines] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
    CONSTRAINT [FK_Lines_Documents] FOREIGN KEY ([TenantId], [DocumentId]) REFERENCES [dbo].[Documents] ([TenantId], [Id]) ON DELETE CASCADE,
	CONSTRAINT [FK_Lines_Lines] FOREIGN KEY ([TenantId], [BaseLineId]) REFERENCES [dbo].[Lines] ([TenantId], [Id])
);
GO