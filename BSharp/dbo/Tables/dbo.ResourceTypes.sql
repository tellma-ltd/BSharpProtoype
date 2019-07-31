CREATE TABLE [dbo].[ResourceTypes] (
-- table managed by Banan
-- Note that, in steel production: CTS, HSP, and SM are considered 3 different document types.
	[TenantId]					INT				DEFAULT CONVERT(INT, SESSION_CONTEXT(N'TenantId')),
	[Id]						NVARCHAR (255),
-- The choice of booleans should form a connected tree. For example, in Cut to Size, and
-- assuming that the B# document is not a source document, the true values are: 
-- (starting) (Draft), IsPosted, IsDeclined.
-- The list of possible states can be also deduced from the workflow (ToState).
/*
	[IsRequestedOrVoid]			BIT				DEFAULT (1),
	[IsAuthorizedOrRejected]	BIT				DEFAULT (1),
	[IsCompletedOrFailed]		BIT				DEFAULT (1),
	[IsPostedOrInvalid]			BIT				DEFAULT (1),
*/
	[IsSourceDocument]			BIT				DEFAULT (1), -- <=> IsVoucherReferenceRequired
	[Code]						NVARCHAR (255)	NOT NULL,
	[Description]				NVARCHAR (255)	NOT NULL,
	[Description2]				NVARCHAR (255),
	[Description3]				NVARCHAR (255),
	-- UI Specs
	[DefaultVoucherTypeId]		NVARCHAR (255),

	[FromCustodyAccountLabel]	NVARCHAR (255),
	[ToCustodyAccountLabel]		NVARCHAR (255),
	CONSTRAINT [PK_DResourceTypes] PRIMARY KEY CLUSTERED ([TenantId], [Id])
);
GO;