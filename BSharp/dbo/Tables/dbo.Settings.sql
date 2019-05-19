CREATE TABLE [dbo].[Settings] ( -- TODO: Make it wide table, up to 30,0000 columns
	[TenantId]				INT,
	[FunctionalCurrencyId]	INT,
	-- The date before which data is frozen.
	[ArchiveDate]			Date		NOT NULL DEFAULT ('1900.01.01'),
	[TenantLanguage2]		NVARCHAR (255),
	[TenantLanguage3]		NVARCHAR (255),
	[CreatedAt]				DATETIMEOFFSET(7)	NOT NULL,
	[CreatedById]			INT					NOT NULL,
	[ModifiedAt]			DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedById]			INT					NOT NULL,
	CONSTRAINT [PK_Settings] PRIMARY KEY CLUSTERED ([TenantId])
);