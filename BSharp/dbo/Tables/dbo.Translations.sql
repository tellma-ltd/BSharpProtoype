CREATE TABLE [dbo].[Translations]
(
	[Name]			nvarchar(255),
    [Culture]		nvarchar (50),
	[Value]			nvarchar(2048) NOT NULL,
    CONSTRAINT [PK_Translations] PRIMARY KEY NONCLUSTERED ([Name] ASC, [Culture] ASC)
);
GO