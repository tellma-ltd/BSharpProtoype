CREATE TABLE [dbo].[Settings] ( -- TODO: Make it wide table, up to 30,0000 columns
	[TenantId]				INT					DEFAULT CONVERT(INT, SESSION_CONTEXT(N'TenantId')),
	[FunctionalCurrencyId]	INT,
	-- The date before which data is frozen.
	[ArchiveDate]			Date		NOT NULL DEFAULT ('1900.01.01'),
	[TenantLanguage2]		NVARCHAR (255),
	[TenantLanguage3]		NVARCHAR (255),
	[CreatedAt]				DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(),
	[CreatedById]			INT					NOT NULL DEFAULT CONVERT(INT, SESSION_CONTEXT(N'UserId')),
	[ModifiedAt]			DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(),
	[ModifiedById]			INT					NOT NULL DEFAULT CONVERT(INT, SESSION_CONTEXT(N'UserId')),
	CONSTRAINT [PK_Settings] PRIMARY KEY CLUSTERED ([TenantId])
);