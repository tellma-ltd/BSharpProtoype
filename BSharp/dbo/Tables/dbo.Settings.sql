CREATE TABLE [dbo].[Settings] ( -- TODO: Make it wide table, up to 30,0000 columns
	[FunctionalCurrencyId]	INT,
	-- The date before which data is frozen.
	[ArchiveDate]			Date				NOT NULL DEFAULT ('1900.01.01'),
	[TenantLanguage2]		NVARCHAR (255),
	[TenantLanguage3]		NVARCHAR (255),
	[ResourceLookup1Label]	NVARCHAR (50),
	[ResourceLookup1Label2]	NVARCHAR (50),
	[ResourceLookup1Label3]	NVARCHAR (50),
	[ResourceLookup1sLabel]	NVARCHAR (50),
	[ResourceLookup1sLabel2]NVARCHAR (50),
	[ResourceLookup1sLabel3]NVARCHAR (50),

	[ResourceLookup2Label]	NVARCHAR (50),

	[ResourceLookup3Label]	NVARCHAR (50),

	[InstanceLookup1Label]	NVARCHAR (50),
	[InstanceLookup1Label2]	NVARCHAR (50),
	[InstanceLookup1Label3]	NVARCHAR (50),
	[InstanceLookup1sLabel]	NVARCHAR (50),
	[InstanceLookup1sLabel2]NVARCHAR (50),
	[InstanceLookup1sLabel3]NVARCHAR (50),
	[CreatedAt]				DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(),
	[CreatedById]			INT	NOT NULL DEFAULT CONVERT(INT, SESSION_CONTEXT(N'UserId')),
	[ModifiedAt]			DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(),
	[ModifiedById]			INT	NOT NULL DEFAULT CONVERT(INT, SESSION_CONTEXT(N'UserId'))
	CONSTRAINT [FK_Settings__CreatedById] FOREIGN KEY ([CreatedById]) REFERENCES [dbo].[LocalUsers] ([Id]),
	CONSTRAINT [FK_Settings__ModifiedById] FOREIGN KEY ([ModifiedById]) REFERENCES [dbo].[LocalUsers] ([Id])
);