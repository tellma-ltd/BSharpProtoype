CREATE TYPE [dbo].[LineList] AS TABLE (
    [Id]					INT,
    [DocumentId]			INT				NOT NULL,
    [StartDateTime]			DATETIMEOFFSET (7) ,
    [EndDateTime]			DATETIMEOFFSET (7) ,
	[BaseLineId]			INT,			-- If invoice/voucher line is based on template or order line.	
    [Memo]					NVARCHAR(255), 
	[Status]				NVARCHAR(10)	NOT NULL DEFAULT(N'Inserted'), -- Unchanged, Inserted, Updated, Deleted.
	[TemporaryId]			INT				NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
	CHECK ([Status] IN (N'Unchanged', N'Inserted', N'Updated', N'Deleted'))
	);