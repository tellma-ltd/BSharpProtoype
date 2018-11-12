CREATE TABLE [dbo].[Custodies] (
	[TenantId]				 INT				NOT NULL,
    [Id]            INT                IDENTITY (1, 1) NOT NULL,
    [CustodyType]   NVARCHAR (50)      NOT NULL,
    [Name]          NVARCHAR (50)      NOT NULL,
    [IsActive]   BIT NOT NULL DEFAULT 1,
    CONSTRAINT [PK_Custodies] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
    CONSTRAINT [FK_Custodies_CustodyTypes] FOREIGN KEY ([CustodyType]) REFERENCES [dbo].[CustodyTypes] ([Id])
);
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Custodies__Id_CustodyType]
    ON [dbo].[Custodies]([TenantId] ASC, [Id] ASC, [CustodyType] ASC);

