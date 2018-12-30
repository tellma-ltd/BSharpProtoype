CREATE TYPE [dbo].[IndexedIdList2] AS TABLE (
	[Index]		INT		IDENTITY(0, 1),
	[Id]		INT
	PRIMARY KEY CLUSTERED ([Id] ASC)
);