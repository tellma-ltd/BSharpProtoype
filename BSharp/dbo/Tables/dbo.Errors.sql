CREATE TABLE [dbo].[Errors]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	[ErrorLine] int,
	[ErrorMessage] nvarchar(4000),
	[ErrorNumber] int,
	[ErrorProcedure] nvarchar(128),
	[ErrorSeverity] int,
	[ErrorState] int
)
