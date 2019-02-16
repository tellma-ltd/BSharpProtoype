CREATE TABLE [dbo].[AccountSpecifications] (
	[TenantId]						INT,
	[AccountId]						NVARCHAR (255),
	-- For all directions
	[CustodyLabel]					NVARCHAR (255),	-- displayed when hovering over the custody column, or when used in line specs. Null means not visible.
	[CustodyValidation]				NVARCHAR (1024), -- e.g., not null to make it required.
	[CustodyFilter]					NVARCHAR (255), -- JS code, affecting the picker.
	[ResourceLabel]					NVARCHAR (255),
	[ResourceValidation]			NVARCHAR (1024),
	[ResourceFilter]				NVARCHAR (255),
	[RelatedAgentFilter]			NVARCHAR (255),
	[RelatedResourceFilter]			NVARCHAR (255),
	-- Applies to the specific direction
	[Direction]						SMALLINT,	
	[AmountLabel]					NVARCHAR (255),
	[AmountValidation]				NVARCHAR (1024),
	[ReferenceLabel]				NVARCHAR (255),
	[ReferenceValidation]			NVARCHAR (1024),
	[RelatedReferenceLabel]			NVARCHAR (255),
	[RelatedReferenceValidation]	NVARCHAR (1024),
	[RelatedAgentLabel]				NVARCHAR (255),
	[RelatedAgentValidation]		NVARCHAR (1024),
	[RelatedResourceLabel]			NVARCHAR (255),
	[RelatedResourceValidation]		NVARCHAR (1024),
	[RelatedAmountLabel]			NVARCHAR (255),
	[RelatedAmountValidation]		NVARCHAR (1024)
	CONSTRAINT [PK_AccountSpecifications] PRIMARY KEY NONCLUSTERED ([TenantId] ASC, [AccountId] ASC, [Direction] ASC),
--	CONSTRAINT [FK_AccountSpecifications_Accounts] FOREIGN KEY ([TenantId], [AccountId]) REFERENCES [dbo].[IFRSConcepts] ([TenantId], [Id]) ON DELETE CASCADE,
	CONSTRAINT [CK_Accountpecifications_Direction] CHECK ([Direction] IN (-1, 0,  +1)),
);