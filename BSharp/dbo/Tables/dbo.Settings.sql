CREATE TABLE [dbo].[Settings] (
	[TenantId]		INT,
	[Field]			NVARCHAR (255),
	[Value]			NVARCHAR (1024)		NOT NULL,
	[CreatedAt]		DATETIMEOFFSET(7)	NOT NULL,
	[CreatedBy]		INT					NOT NULL,
	[ModifiedAt]	DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedBy]	INT					NOT NULL,
	CONSTRAINT [PK_Settings] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Field] ASC)
);