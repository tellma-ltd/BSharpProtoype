CREATE TABLE [dbo].[IFRSConcepts] (
	[TenantId]					INT,
	[Id]						NVARCHAR (255), -- IFRS Concept
/*
	- Regulatory: Proposed by regulatory entity. We may have different flavors for different countries
	- Amendment: Added for consistency, must be amended in the iXBRL tool. Mainly for members vs non members issue
	- Extension: Added for business logic in B#. Is ignored by the iXBRL tool 
*/
	[IFRSType]					NVARCHAR (255)	DEFAULT (N'Regulatory') NOT NULL, -- N'Amendment', N'Extension', N'Regulatory'
	[IsActive]					BIT					NOT NULL DEFAULT (1),
	[Label]						NVARCHAR (1024)		NOT NULL,
	[Label2]					NVARCHAR (1024),
	[Label3]					NVARCHAR (1024),
	[Documentation]				NVARCHAR (1024),
	[Documentation2]			NVARCHAR (1024),
	[Documentation3]			NVARCHAR (1024),
	[EffectiveDate]				DATETIME2(7)		NOT NULL DEFAULT('0001-01-01 00:00:00'),
	[ExpiryDate]				DATETIME2(7)		NOT NULL DEFAULT('9999-12-31 23:59:59'),
--	
	[CreatedAt]					DATETIMEOFFSET(7)	NOT NULL,
	[CreatedById]				INT					NOT NULL,
	[ModifiedAt]				DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedById]				INT					NOT NULL,

	CONSTRAINT [PK_IFRSConcepts] PRIMARY KEY NONCLUSTERED ([TenantId] ASC, [Id]),
	CONSTRAINT [CK_IFRSConcepts__IFRSType] CHECK ([IFRSType] IN (N'Amendment', N'Extension', N'Regulatory')),
	CONSTRAINT [FK_IFRSConcepts__CreatedById] FOREIGN KEY ([TenantId], [CreatedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id]),
	CONSTRAINT [FK_IFRSConcepts__ModifiedById] FOREIGN KEY ([TenantId], [ModifiedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id])
	);
GO
ALTER TABLE [dbo].[IFRSConcepts] ADD CONSTRAINT [DF_IFRSConcepts__TenantId]  DEFAULT (CONVERT(INT, SESSION_CONTEXT(N'TenantId'))) FOR [TenantId];
GO
ALTER TABLE [dbo].[IFRSConcepts] ADD CONSTRAINT [DF_IFRSConcepts__CreatedAt]  DEFAULT (SYSDATETIMEOFFSET()) FOR [CreatedAt];
GO
ALTER TABLE [dbo].[IFRSConcepts] ADD CONSTRAINT [DF_IFRSConcepts__CreatedById]  DEFAULT (CONVERT(INT, SESSION_CONTEXT(N'UserId'))) FOR [CreatedById]
GO
ALTER TABLE [dbo].[IFRSConcepts] ADD CONSTRAINT [DF_IFRSConcepts__ModifiedAt]  DEFAULT (SYSDATETIMEOFFSET()) FOR [ModifiedAt];
GO
ALTER TABLE [dbo].[IFRSConcepts] ADD CONSTRAINT [DF_IFRSConcepts__ModifiedById]  DEFAULT (CONVERT(INT, SESSION_CONTEXT(N'UserId'))) FOR [ModifiedById]
GO