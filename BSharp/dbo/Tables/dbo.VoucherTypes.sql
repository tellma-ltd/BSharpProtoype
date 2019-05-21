CREATE TABLE [dbo].[VoucherTypes] (
	[TenantId]		INT,
	[Id]			INT					IDENTITY,
	[Name]			NVARCHAR (255)		NOT NULL,
	[Name2]			NVARCHAR (255),
	[Name3]			NVARCHAR (255),
	[Description]	NVARCHAR (255),
	[Description2]	NVARCHAR (255),
	[Description3]	NVARCHAR (255),
	[IsActive]		BIT					NOT NULL DEFAULT (1),
	[Code]			NVARCHAR (255),
	[CreatedAt]		DATETIMEOFFSET(7)	NOT NULL,
	[CreatedById]	INT					NOT NULL,
	[ModifiedAt]	DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedById]	INT					NOT NULL,
	CONSTRAINT [PK_VoucherTypes] PRIMARY KEY ([TenantId], [Id]),
);
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_VoucherTypes__Name]
  ON [dbo].[VoucherTypes]([TenantId] ASC, [Name] ASC);
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_VoucherTypes__Name2]
  ON [dbo].[VoucherTypes]([TenantId] ASC, [Name2] ASC) WHERE [Name2] IS NOT NULL;
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_VoucherTypes__Name3]
  ON [dbo].[VoucherTypes]([TenantId] ASC, [Name3] ASC) WHERE [Name3] IS NOT NULL;
GO
--CREATE UNIQUE NONCLUSTERED INDEX [IX_VoucherTypes__Code]
--  ON [dbo].[VoucherTypes]([TenantId] ASC, [Code] ASC) WHERE [Code] IS NOT NULL;
--GO
ALTER TABLE [dbo].[VoucherTypes] ADD CONSTRAINT [DF_VoucherTypes__TenantId]  DEFAULT (CONVERT(INT, SESSION_CONTEXT(N'TenantId'))) FOR [TenantId];
GO
ALTER TABLE [dbo].[VoucherTypes] ADD CONSTRAINT [DF_VoucherTypes__CreatedAt]  DEFAULT (SYSDATETIMEOFFSET()) FOR [CreatedAt];
GO
ALTER TABLE [dbo].[VoucherTypes] ADD CONSTRAINT [DF_VoucherTypes__CreatedById]  DEFAULT (CONVERT(INT, SESSION_CONTEXT(N'UserId'))) FOR [CreatedById]
GO
ALTER TABLE [dbo].[VoucherTypes] ADD CONSTRAINT [DF_VoucherTypes__ModifiedAt]  DEFAULT (SYSDATETIMEOFFSET()) FOR [ModifiedAt];
GO
ALTER TABLE [dbo].[VoucherTypes] ADD CONSTRAINT [DF_VoucherTypes__ModifiedById]  DEFAULT (CONVERT(INT, SESSION_CONTEXT(N'UserId'))) FOR [ModifiedById]
GO