CREATE TYPE [dbo].[IdMappingList] AS TABLE
(
	[OldId] INT,
	[NewId] INT
    PRIMARY KEY CLUSTERED ([OldId] ASC, [NewId] ASC)
);

