CREATE TYPE [dbo].[ActivationList] AS TABLE
(
	[Index]		INT		IDENTITY(0, 1),
	[Id]		INT,
	[IsActive]	BIT	NOT NULL
	PRIMARY KEY CLUSTERED ([Index] ASC)
);