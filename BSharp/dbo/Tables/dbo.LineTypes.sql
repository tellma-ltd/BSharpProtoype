CREATE TABLE [dbo].[LineTypes] (
    [Id]                 NVARCHAR (50)  NOT NULL,
    [Category]           NVARCHAR (50)  NOT NULL,
    [IsInstant]          BIT            NOT NULL,
    CONSTRAINT [PK_LineTypes] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_LineTypes_LineTypeCategories] FOREIGN KEY ([Category]) REFERENCES [dbo].[LineTypeCategories] ([Id]) ON UPDATE CASCADE
);

