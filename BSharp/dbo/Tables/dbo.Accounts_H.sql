CREATE TABLE [dbo].[Accounts_H] (
	[TenantId]	INT,
  [C]			NVARCHAR (255),
  [P]			NVARCHAR (255),
  CONSTRAINT [PK_Accounts_H] PRIMARY KEY NONCLUSTERED ([TenantId] ASC, [C] ASC, [P] ASC)
);

