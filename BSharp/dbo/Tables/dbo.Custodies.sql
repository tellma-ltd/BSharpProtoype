CREATE TABLE [dbo].[Custodies] (
    [Id]            INT                IDENTITY (1, 1) NOT NULL,
    [CustodyType]   NVARCHAR (50)      NOT NULL,
    [Name]          NVARCHAR (50)      NOT NULL,
    [AvailableFrom] DATETIMEOFFSET (7) NULL,
    [AvailableTo]   DATETIMEOFFSET (7) NULL,
    CONSTRAINT [PK_Custodies] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Custodies_CustodyTypes] FOREIGN KEY ([CustodyType]) REFERENCES [dbo].[CustodyTypes] ([Id])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Custodies__Id_CustodyType]
    ON [dbo].[Custodies]([Id] ASC, [CustodyType] ASC);

