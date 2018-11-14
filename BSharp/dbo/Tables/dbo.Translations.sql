CREATE TABLE [dbo].[Translations]
(
	[Key]			nvarchar(255) NOT NULL,
    [Language]		nchar (2) NOT NULL,
    [Country]       nchar(2)  NOT NULL DEFAULT N'',
	[Singular]		nvarchar(2048) NOT NULL,
	[Plural]		nvarchar(2048) NULL,
    CONSTRAINT [PK_Translations] PRIMARY KEY NONCLUSTERED ([Key] ASC, [Language] ASC, [Country] ASC)
);
GO