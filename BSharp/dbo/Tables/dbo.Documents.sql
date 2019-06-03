CREATE TABLE [dbo].[Documents] (
--	This table for all business documents that are routed for authorization, execution, and journalizing.
--	Its scope is 
	[TenantId]								INT,
	[Id]									INT				IDENTITY,
	-- Common to all document types
	[DocumentType]							NVARCHAR (255),	
	[DocumentDate]							DATETIME2 (7)	NOT NULL DEFAULT (CONVERT (date, SYSDATETIME())),
	[DocumentState]							NVARCHAR (255)	NOT NULL DEFAULT (N'Draft'), -- N'Void', N'InProcess', N'Completed' {Voucher: Posted, Request:Authorized, Inquiry:Resolved, Plan:Approved, Template:Accepted}
	[SerialNumber]							INT,				-- auto generated, copied to paper if needed.
	-- for authenticiy when the original source document is not this record itself, but rather a paper
	-- voucher or a record in another system such as a cash register. By writing the unique voucher
	-- reference in the system, we can determine if any source document is missing or duplicated.
	[VoucherReference]						NVARCHAR (255),
	[RelatedReference]						NVARCHAR (255),
	[Memo]									NVARCHAR (255),
	-- To simplify data entry
	[CustomerAccountId]						INT,
	[CustomerAccountIsCommon]				BIT				DEFAULT (1),
	[SupplierAccountId]						INT, 
	[SupplierAccountIsCommon]				BIT				DEFAULT (1),
	[EmployeeAccountId]						INT, 
	[EmployeeAccountIsCommon]				BIT				DEFAULT (1),
	[CurrencyId]							INT, 
	[CurrencyIsCommon]						BIT				DEFAULT (1),
	[SourceCustodianAccountId]				INT, 
	[SourceCustodianAccountIsCommon]		BIT				DEFAULT (1),
	[DestinationCustodianAccountId]			INT, 
	[DestinationCustodianAccountIsCommon]	BIT				DEFAULT (1),
	[InvoiceReference]						NVARCHAR (255),
	[InvoiceReferenceIsCommon]				BIT				DEFAULT (1),
	-- Transaction specific, to record the acquisition or loss of goods and services
	-- Orders that are not negotiables, are assumed to happen, and hence are journalized, even we are verifying it later.
	
	[Frequency]								NVARCHAR (255)	NOT NULL DEFAULT (N'OneTime'), -- an easy way to define a recurrent document
	[Repetitions]							INT				NOT NULL DEFAULT (0), -- time unit is function of frequency
	[EndDate] AS (
					CASE 
						WHEN [Frequency] = N'OneTime' THEN [DocumentDate]
						WHEN [Frequency] = N'Daily' THEN DATEADD(DAY, [Repetitions], [DocumentDate])
						WHEN [Frequency] = N'Weekly' THEN DATEADD(WEEK, [Repetitions], [DocumentDate])
						WHEN [Frequency] = N'Monthly' THEN DATEADD(MONTH, [Repetitions], [DocumentDate])
						WHEN [Frequency] = N'Quarterly' THEN DATEADD(QUARTER, [Repetitions], [DocumentDate])
						WHEN [Frequency] = N'Yearly' THEN DATEADD(YEAR, [Repetitions], [DocumentDate])
					END
	) PERSISTED,
	-- Request specific, to acquire goods or services that require pre-authorization
	-- purchase requisition, payment requesition, production request, maintenance request
	[RequestType]							NVARCHAR (255),	-- N'payment-requests', N'purchase-requests', 'production-requests'
	[NeededBy]								DATETIME2 (7),
	-- Inquiry specific, to acquire information
	-- request for purchase quotation, request for sales-quotation, customer inquiry
	[InquiryType]							NVARCHAR (255),	-- N'sales-quotations', N'purchase-quotation', N'employment-offers'
	[AgentId]								INT,			-- person inquiring, person inquired, 
	[ValidTill]								DATETIME2 (7),
	-- Plan specific, for acquiring or dispensing goods and services
	-- sales forecast, production plan, materials budget, expenses budget, capex budgets, 
	[PlanType]								NVARCHAR (255),
	-- Template specific, for modeling business transactions
	-- employment agreement, sales price list, purchase price list, bill of material
	[TemplateType]							NVARCHAR (255),

	[CreatedAt]								DATETIMEOFFSET(7)	NOT NULL,
	[CreatedById]							INT					NOT NULL,
	[ModifiedAt]							DATETIMEOFFSET(7)	NOT NULL, 
	[ModifiedById]							INT					NOT NULL,
	CONSTRAINT [PK_Documents] PRIMARY KEY CLUSTERED ([TenantId], [Id]), -- Voucher/Request/Definition-Model-Template/Commitment, Free(text)/Hierarchichal(xml)/Structured(grid)/Transactional
	-- If the company is in Alofi, and the server is hosted in Apia, the server time will be one day behind
	-- So, the user will not be able to enter transactions unless DocumentDate is allowed 1d future 
	CONSTRAINT [CK_Documents_DocumentDate] CHECK ([DocumentDate] < DATEADD(DAY, 1, GETDATE())) ,
	CONSTRAINT [CK_Documents_Duration] CHECK ([Frequency] IN (N'OneTime', N'Daily', N'Weekly', N'Monthly', N'Quarterly', N'Yearly')),
	CONSTRAINT [FK_Documents_DocumentType] FOREIGN KEY ([TenantId], [DocumentType]) REFERENCES [dbo].[DocumentTypes] ([TenantId], [Id]) ON UPDATE CASCADE, 
	CONSTRAINT [CK_Documents_DocumentState] CHECK ([DocumentState] IN (N'Void', N'Draft', N'Posted')),
	CONSTRAINT [FK_Documents_CreatedById] FOREIGN KEY ([TenantId], [CreatedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id]),
	CONSTRAINT [FK_Documents_ModifiedById] FOREIGN KEY ([TenantId], [ModifiedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id])
 );
GO
ALTER TABLE [dbo].[Documents] ADD CONSTRAINT [DF_Documents__TenantId]  DEFAULT (CONVERT(INT, SESSION_CONTEXT(N'TenantId'))) FOR [TenantId];
GO
ALTER TABLE [dbo].[Documents] ADD CONSTRAINT [DF_Documents__CreatedAt]  DEFAULT (SYSDATETIMEOFFSET()) FOR [CreatedAt];
GO
ALTER TABLE [dbo].[Documents] ADD CONSTRAINT [DF_Documents__CreatedById]  DEFAULT (CONVERT(INT, SESSION_CONTEXT(N'UserId'))) FOR [CreatedById]
GO
ALTER TABLE [dbo].[Documents] ADD CONSTRAINT [DF_Documents__ModifiedAt]  DEFAULT (SYSDATETIMEOFFSET()) FOR [ModifiedAt];
GO
ALTER TABLE [dbo].[Documents] ADD CONSTRAINT [DF_Documents__ModifiedById]  DEFAULT (CONVERT(INT, SESSION_CONTEXT(N'UserId'))) FOR [ModifiedById]
GO