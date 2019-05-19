CREATE TYPE [dbo].[TransactionList] AS TABLE (
	[Index]				INT,
	[Id]				INT,
	[DocumentDate]		DATETIME2 (7)		NOT NULL DEFAULT (CONVERT (date, SYSDATETIME())),
	[DocumentState]		NVARCHAR (255)		NOT NULL DEFAULT (N'Draft'), -- N'Void', N'InProcess', N'Completed' {Voucher: Posted, Request:Authorized, Inquiry:Resolved, Plan:Approved, Template:Accepted}
	[SerialNumber]		INT,				-- auto generated, copied to paper if needed.
	[Reference]			NVARCHAR (255),		-- Overridden by the one in entries. Useful when operating in paper-first mode.
	[Memo]				NVARCHAR (255),	

	[TransactionType]	NVARCHAR (255)		NOT NULL DEFAULT (N'manual-journalsl'),
	[Frequency]			NVARCHAR (255)		NOT NULL DEFAULT (N'OneTime'), -- an easy way to define a recurrent document
	[Repetitions]		INT					NOT NULL DEFAULT (0), -- time unit is function of frequency
	[EndDate]			DATETIME2 (7)		NOT NULL DEFAULT (CONVERT (date, SYSDATETIME())), -- computed column	

	[EntityState]		NVARCHAR (255)		NOT NULL DEFAULT(N'Inserted'),
	PRIMARY KEY ([Index] ASC),
	CHECK ([DocumentState] IN (N'Void', N'Draft', N'Posted')),
	CHECK ([Frequency] IN (N'OneTime', N'Daily', N'Weekly', N'Monthly', N'Quarterly', N'Yearly')),
	CHECK ([EntityState] IN (N'Unchanged', N'Inserted', N'Updated', N'Deleted')),
	CHECK ([EntityState] <> N'Inserted' OR [Id] IS NULL)
);