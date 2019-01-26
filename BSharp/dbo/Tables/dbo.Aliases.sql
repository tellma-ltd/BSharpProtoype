﻿CREATE TABLE [dbo].[Aliases] (
	[TenantId]			INT,
	[Id]				NVARCHAR (255),
	[Name]				NVARCHAR (255)		NOT NULL,
	[AccountId]			NVARCHAR (255)		NOT NULL,
	[OperationId]		INT					NOT NULL,
	[CustodyId]			INT					NOT NULL,
	[ResourceId]		INT					NOT NULL,
	[AmountBalance]		MONEY				NOT NULL DEFAULT(0),
	[ValueBalance]		MONEY				NOT NULL DEFAULT(0),
	[Reference]			NVARCHAR (255),
	[RelatedReference]	NVARCHAR (255),
	[RelatedAgentId]	INT,
	[RelatedResourceId]	INT,
	[RelatedAmount]		MONEY,
	[CreatedAt]			DATETIMEOFFSET(7)	NOT NULL,
	[CreatedById]			INT					NOT NULL,
	[ModifiedAt]		DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedById]		INT					NOT NULL,
	CONSTRAINT [PK_Aliases] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [FK_Aliases_Accounts] FOREIGN KEY ([TenantId], [AccountId]) REFERENCES [dbo].[Accounts] ([TenantId], [Id]) ON UPDATE CASCADE,
);