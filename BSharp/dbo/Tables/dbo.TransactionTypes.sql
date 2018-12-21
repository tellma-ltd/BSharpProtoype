CREATE TABLE [dbo].[TransactionTypes] (
	[Id]			NVARCHAR (255) NOT NULL,
	[IsInstant]		BIT      NOT NULL,
	[Description]	NVARCHAR (255),
	CONSTRAINT [PK_TransactionTypes] PRIMARY KEY CLUSTERED ([Id] ASC),
);