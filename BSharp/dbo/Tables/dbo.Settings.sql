CREATE TABLE [dbo].[Settings] (
	[TenantId]				 INT				NOT NULL,
    [Field] NVARCHAR (255)  NOT NULL,
    [Value] NVARCHAR (1024) NOT NULL,
    CONSTRAINT [PK_Settings] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Field] ASC)
);

