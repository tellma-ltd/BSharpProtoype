CREATE TABLE [dbo].[Resources] (
    [Id]                     INT            IDENTITY (1, 1) NOT NULL,
    [ResourceType]           NVARCHAR (50)  NOT NULL,
    [Name]                   NVARCHAR (50)  NOT NULL,
    [Code]                   NVARCHAR (50)  NULL,
    [UnitOfMeasure]          NVARCHAR (5)   NOT NULL,
    [Memo]                   NVARCHAR (MAX) NULL,
    [Lookup1]                NVARCHAR (50)  NULL,
    [Lookup2]                NVARCHAR (50)  NULL,
    [Lookup3]                NVARCHAR (50)  NULL,
    [Lookup4]                NVARCHAR (50)  NULL,
    [GoodForServiceParentId] INT            NULL,
    [FungibleParentId]       INT            NULL,
    CONSTRAINT [PK_Resources_1] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Resources_UnitsOfMeasure] FOREIGN KEY ([UnitOfMeasure]) REFERENCES [dbo].[UnitsOfMeasure] ([Id]) ON UPDATE CASCADE
);

