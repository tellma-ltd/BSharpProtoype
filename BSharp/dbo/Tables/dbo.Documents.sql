CREATE TABLE [dbo].[Documents] (
	[TenantId]					INT,
    [Id]						INT					IDENTITY (1, 1),
    [State]						NVARCHAR (255)		NOT NULL, -- N'Plan', N'Inquiry', N'Template', N'Demand', N'Voucher'
    [TransactionType]			NVARCHAR (255)		NOT NULL, -- Cash Issue to Supplier, Sales invoice, Investment from shareholder
    [Mode]						NVARCHAR (255)		NOT NULL DEFAULT (N'Draft'), -- N'Void', N'Draft', N'Submitted', N'Posted'
    [SerialNumber]				INT,				-- auto generated
    [ResponsibleAgentId]		INT,				-- for requests only
    [ForwardedToAgentId]		INT,				-- for all, to appear in notification.	
	[FolderId]					INT,
	-- Line properties
	[LinesMemo]					NVARCHAR (255),
    [LinesStartDateTime]		DATETIMEOFFSET (7),
    [LinesEndDateTime]			DATETIMEOFFSET (7),
	[LinesCustody1]				INT,
	[LinesCustody2]				INT,
	[LinesCustody3]				INT,
	[LinesReference1]			NVARCHAR(255),
	[LinesReference2]			NVARCHAR(255),
	[LinesReference3]			NVARCHAR(255),
    [CreatedAt]					DATETIMEOFFSET(7)	NOT NULL,
    [CreatedBy]					NVARCHAR(450)		NOT NULL,
    [ModifiedAt]				DATETIMEOFFSET(7)	NOT NULL, 
    [ModifiedBy]				NVARCHAR(450)		NOT NULL,
    CONSTRAINT [PK_Documents] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC), -- Data/Demand/Definition-Model-Template/Commitment, Free(text)/Hierarchichal(xml)/Structured(grid)/Transactional
    CONSTRAINT [CK_Documents_State] CHECK ([State] IN (N'Plan', N'Inquiry', N'Template', N'Demand', N'Voucher')),
	CONSTRAINT [FK_Documents_TransactionTypes] FOREIGN KEY ([TransactionType]) REFERENCES [dbo].[TransactionTypes] ([Id]) ON UPDATE CASCADE, 
    CONSTRAINT [CK_Documents_Mode] CHECK ([Mode] IN (N'Void', N'Draft', N'Submitted', N'Posted'))
 );
GO