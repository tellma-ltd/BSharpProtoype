CREATE TABLE [dbo].[Documents] (
--	This table for all business documents that are routed for authorization, execution, and journalizing.
--	Its scope is 
	[TenantId]					INT,
	[Id]						INT					IDENTITY,
	-- Common to all document types
	[DocumentType]				NVARCHAR (255)		NOT NULL DEFAULT (N'Transaction'), -- N'Transaction', N'Request', N'Inquiry', N'Plan', N'Template'.
	[DocumentDate]				DATETIME2 (7)		NOT NULL DEFAULT (CONVERT (date, SYSDATETIME())),
	[DocumentState]				NVARCHAR (255)		NOT NULL DEFAULT (N'Draft'), -- N'Void', N'InProcess', N'Completed' {Voucher: Posted, Request:Authorized, Inquiry:Resolved, Plan:Approved, Template:Accepted}
	[SerialNumber]				INT,				-- auto generated, copied to paper if needed.
	[Reference]					NVARCHAR (255),		-- Overridden by the one in entries. Useful when operating in paper-first mode.
	[Memo]						NVARCHAR (255),	
	-- Transaction specific, to record the acquisition or loss of goods and services
	-- Orders that are not negotiables, are assumed to happen, and hence are journalized, even we are verifying it later.
	-- The list includes the following transaction types, and their variant flavours depending on country and industry:
	-- cash purchase w/invoice, purchase agreement (w/invoice, w/payment, w/receipt), cash deposit, cash payment (w/invoice), G/S receipt (w/invoice),  purchase invoice
	-- lease-in agreement, lease-in receipt, lease-in invoice
	-- cash sale w/invoice, sales agreement (w/invoice, w/collection, w/issue), cash collection (w/invoice), G/S issue (w/invoice), sales invoice
	-- lease-out agreement, lease out issue, lease-out invoice
	-- Inventory transfer, stock issue to consumption, inventory adjustment 
	-- production, maintenance
	-- payroll, paysheet (w/loan deduction), loan issue, penalty, overtime, paid leave, unpaid leave
	-- manual journal, depreciation, 
	[TransactionType]			NVARCHAR (255),		-- N'manual-journals', 
	[Frequency]					NVARCHAR (255)		NOT NULL DEFAULT (N'OneTime'), -- an easy way to define a recurrent document
	[Repetitions]				INT					NOT NULL DEFAULT (0), -- time unit is function of frequency
	[EndDate]					DATETIME2 (7)		NOT NULL DEFAULT (CONVERT (date, SYSDATETIME())), -- computed column	
	-- Request specific, to acquire goods or services that require pre-authorization
	-- purchase requisition, payment requesition, production request, maintenance request
	[RequestType]				NVARCHAR (255),		-- N'payment-requests', N'purchase-requests', 'production-requests'
	[NeededBy]					DATETIME2 (7),
	-- Inquiry specific, to acquire information
	-- request for purchase quotation, request for sales-quotation, customer inquiry
	[InquiryType]				NVARCHAR (255),		-- N'sales-quotations', N'purchase-quotation', N'employment-offers'
	[AgentId]					INT,				-- person inquiring, person inquired, 
	[ValidTill]					DATETIMEOFFSET(7),
	-- Plan specific, for acquiring or dispensing goods and services
	-- sales forecast, production plan, materials budget, expenses budget, capex budgets, 
	[PlanType]					NVARCHAR (255),
	-- Template specific, for modeling business transactions
	-- employment agreement, sales price list, purchase price list, bill of material
	[TemplateType]				NVARCHAR (255),
	[AgentAccountId]			INT, -- customer (for specific deals), supplier (specific deals), employee, production unit

	[CreatedAt]					DATETIMEOFFSET(7)	NOT NULL,
	[CreatedById]				INT					NOT NULL,
	[ModifiedAt]				DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedById]				INT					NOT NULL,
	CONSTRAINT [PK_Documents] PRIMARY KEY CLUSTERED ([TenantId], [Id]), -- Voucher/Request/Definition-Model-Template/Commitment, Free(text)/Hierarchichal(xml)/Structured(grid)/Transactional
	CONSTRAINT [CK_Documents_DocumentType] CHECK ([DocumentType] IN (N'Transaction', N'Request', N'Inquiry', N'Plan', N'Template')),
	CONSTRAINT [CK_Documents_Frequency] CHECK (
		[EndDate] =
			CASE 
				WHEN [Frequency] = N'OneTime' THEN [DocumentDate]
				WHEN [Frequency] = N'Daily' THEN DATEADD(DAY, [Repetitions], [DocumentDate])
				WHEN [Frequency] = N'Weekly' THEN DATEADD(WEEK, [Repetitions], [DocumentDate])
				WHEN [Frequency] = N'Monthly' THEN DATEADD(MONTH, [Repetitions], [DocumentDate])
				WHEN [Frequency] = N'Quarterly' THEN DATEADD(QUARTER, [Repetitions], [DocumentDate])
				WHEN [Frequency] = N'Yearly' THEN DATEADD(YEAR, [Repetitions], [DocumentDate])
			END),
	CONSTRAINT [CK_Documents_Duration] CHECK ([Frequency] IN (N'OneTime', N'Daily', N'Weekly', N'Monthly', N'Quarterly', N'Yearly')),
	CONSTRAINT [FK_Documents_TransactionType] FOREIGN KEY ([TenantId], [TransactionType]) REFERENCES [dbo].[DocumentTypeSpecifications] ([TenantId], [Id]) ON UPDATE CASCADE, 
	CONSTRAINT [CK_Documents_DocumentState] CHECK ([DocumentState] IN (N'Void', N'Draft', N'Posted')),
	CONSTRAINT [FK_Documents_CreatedById] FOREIGN KEY ([TenantId], [CreatedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id]),
	CONSTRAINT [FK_Documents_ModifiedById] FOREIGN KEY ([TenantId], [ModifiedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id])
 );
GO
ALTER TABLE [dbo].[Documents] ADD CONSTRAINT [DF_Documents__TenantId]  DEFAULT (CONVERT(INT, SESSION_CONTEXT(N'TenantId'))) FOR [TenantId];
GO
ALTER TABLE [dbo].[Documents] ADD CONSTRAINT [DF_Documents__CreatedAt]  DEFAULT (SYSDATETIMEOFFSET()) FOR [CreatedAt];
GO
ALTER TABLE [dbo].[Documents] ADD CONSTRAINT [DF_Documents__CreatedById]  DEFAULT (CONVERT(INT,SESSION_CONTEXT(N'UserId'))) FOR [CreatedById]
GO
ALTER TABLE [dbo].[Documents] ADD CONSTRAINT [DF_Documents__ModifiedAt]  DEFAULT (SYSDATETIMEOFFSET()) FOR [ModifiedAt];
GO
ALTER TABLE [dbo].[Documents] ADD CONSTRAINT [DF_Documents__ModifiedById]  DEFAULT (CONVERT(INT,SESSION_CONTEXT(N'UserId'))) FOR [ModifiedById]
GO