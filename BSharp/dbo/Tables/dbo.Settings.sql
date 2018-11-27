CREATE TABLE [dbo].[Settings] (
	[TenantId]	INT,
    [Field]		NVARCHAR (255),
    [Value]		NVARCHAR (1024) NOT NULL,
    CONSTRAINT [PK_Settings] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Field] ASC)
);

