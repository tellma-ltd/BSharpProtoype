CREATE TABLE [dbo].[Operations] (
	[TenantId]		INT,
    [Id]            INT           IDENTITY (1, 1),
    [OperationType] NVARCHAR (255) NOT NULL,
    [Name]          NVARCHAR (255) NOT NULL,
    [ParentId]        INT,
    CONSTRAINT [PK_Operations] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC),
    CONSTRAINT [FK_Operations_Operations] FOREIGN KEY ([TenantId], [ParentId]) REFERENCES [dbo].[Operations] ([TenantId], [Id]),
	CONSTRAINT [CK_Operations_OperationType] CHECK ([OperationType] IN (N'BusinessEntity', N'Investment', N'OperatingSegment'))

);