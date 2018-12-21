﻿CREATE TABLE [dbo].[Operations] (
	[TenantId]				INT,
	[Id]					INT					IDENTITY (1, 1),
	[Name]					NVARCHAR (255)		NOT NULL,
	[IsOperatingSegment]	BIT					NOT NULL CONSTRAINT [DF_Operations_IsOperatingSegment] DEFAULT (0),
	[IsActive]				BIT					NOT NULL CONSTRAINT [DF_Operations_IsActive] DEFAULT (1),
	[ParentId]				INT,
	[Code]					NVARCHAR (255),
	[CreatedAt]				DATETIMEOFFSET(7)	NOT NULL,
	[CreatedBy]				NVARCHAR(450)		NOT NULL,
	[ModifiedAt]			DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedBy]			NVARCHAR(450)		NOT NULL,
	CONSTRAINT [PK_Operations] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
	CONSTRAINT [FK_Operations_Operations] FOREIGN KEY ([TenantId], [ParentId]) REFERENCES [dbo].[Operations] ([TenantId], [Id])
);
GO
CREATE UNIQUE INDEX [IX_Operations__Code] ON [dbo].[Operations]([TenantId] ASC, [Code] ASC) WHERE [Code] IS NOT NULL;
