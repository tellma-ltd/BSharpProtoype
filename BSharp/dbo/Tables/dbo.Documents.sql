CREATE TABLE [dbo].[Documents] (
--	This table for all business documents that are routed for authorization, execution, and journalizing.
--	Its scope is 
	[TenantId]								INT				DEFAULT CONVERT(INT, SESSION_CONTEXT(N'TenantId')),
	[Id]									INT				IDENTITY,
	-- Common to all document types
	[DocumentType]							NVARCHAR (255)	NOT NULL,	
	[SerialNumber]							INT				NOT NULL,	-- auto generated, copied to paper if needed.
	[DocumentDate]							DATETIME2 (7)	NOT NULL DEFAULT CONVERT (DATE, SYSDATETIME()),
	[DocumentState]							NVARCHAR (255)	NOT NULL DEFAULT N'Draft', -- N'Void', N'InProcess', N'Completed' {Voucher: Posted, Request:Authorized, Inquiry:Resolved, Plan:Approved, Template:Accepted}
	
	-- for authenticiy when the original source document is not this record itself, but rather a paper
	-- voucher or a record in another system such as a cash register. By writing the unique voucher
	-- reference in the system, we can determine if any source document is missing or duplicated.
	-- In case of multiple candidate voucher references, we use the one whose checksum is easier to compute
	-- If both are required, we concatenate with a special character ':'
	[VoucherReference]						NVARCHAR (255),
	[Memo]									NVARCHAR (255),
	-- Dynamic properties defined by document type specification
	[Lookup1Id]								INT, -- e.g., cash machine serial in the case of a sale
	[Lookup2Id]								INT,
	[String1]								NVARCHAR (255),
	[String2]								NVARCHAR (255),
	-- Additional properties to simplify data entry. No report should be based on them!!!
	[CustomerAccountId]						INT,
	[CustomerAccountIsCommon]				BIT				DEFAULT 1,
	[SupplierAccountId]						INT, 
	[SupplierAccountIsCommon]				BIT				DEFAULT 1,
	[EmployeeAccountId]						INT, 
	[EmployeeAccountIsCommon]				BIT				DEFAULT 1,
	[CurrencyId]							INT, 
	[CurrencyIsCommon]						BIT				DEFAULT 1,
	[SourceCustodianAccountId]				INT, 
	[SourceCustodianAccountIsCommon]		BIT				DEFAULT 1,
	[DestinationCustodianAccountId]			INT, 
	[DestinationCustodianAccountIsCommon]	BIT				DEFAULT 1,
	[InvoiceReference]						NVARCHAR (255),
	[InvoiceReferenceIsCommon]				BIT				DEFAULT 1,
	-- Transaction specific, to record the acquisition or loss of goods and services
	-- Orders that are not negotiables, are assumed to happen, and hence are journalized, even we are verifying it later.
	
	[Frequency]								NVARCHAR (255)	NOT NULL DEFAULT (N'OneTime'), -- an easy way to define a recurrent document
	[Repetitions]							INT				NOT NULL DEFAULT 0, -- time unit is function of frequency
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
	[NeededBy]								DATETIME2 (7),
	-- Inquiry specific, to acquire information
	-- request for purchase quotation, request for sales-quotation, customer inquiry
	[AgentId]								INT,			-- person inquiring, person inquired, 
	[ValidTill]								DATETIME2 (7),
	-- Plan specific, for acquiring or dispensing goods and services
	-- sales forecast, production plan, materials budget, expenses budget, capex budgets, 
	--??

	-- Template specific, for modeling business transactions
	-- employment agreement, sales price list, purchase price list, bill of material
	-- ??
	[CreatedAt]								DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(),
	[CreatedById]							INT					NOT NULL DEFAULT CONVERT(INT, SESSION_CONTEXT(N'UserId')),
	[ModifiedAt]							DATETIMEOFFSET(7)	NOT NULL DEFAULT SYSDATETIMEOFFSET(), 
	[ModifiedById]							INT					NOT NULL DEFAULT CONVERT(INT, SESSION_CONTEXT(N'UserId')),
	CONSTRAINT [PK_Documents] PRIMARY KEY CLUSTERED ([TenantId], [Id]), -- Voucher/Request/Definition-Model-Template/Commitment, Free(text)/Hierarchichal(xml)/Structured(grid)/Transactional
	-- If the company is in Alofi, and the server is hosted in Apia, the server time will be one day behind
	-- So, the user will not be able to enter transactions unless DocumentDate is allowed 1d future 
	
	CONSTRAINT [CK_Documents_Duration] CHECK ([Frequency] IN (N'OneTime', N'Daily', N'Weekly', N'Monthly', N'Quarterly', N'Yearly')),
	CONSTRAINT [FK_Documents_DocumentType] FOREIGN KEY ([TenantId], [DocumentType]) REFERENCES [dbo].[DocumentTypes] ([TenantId], [Id]) ON UPDATE CASCADE, 
	CONSTRAINT [CK_Documents_DocumentDate] CHECK ([DocumentDate] < DATEADD(DAY, 1, GETDATE())) ,
	CONSTRAINT [CK_Documents_DocumentState] CHECK ([DocumentState] IN (N'Void', N'Draft', N'Posted')),
	CONSTRAINT [FK_Documents_CreatedById] FOREIGN KEY ([TenantId], [CreatedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id]),
	CONSTRAINT [FK_Documents_ModifiedById] FOREIGN KEY ([TenantId], [ModifiedById]) REFERENCES [dbo].[LocalUsers] ([TenantId], [Id])
 );
GO