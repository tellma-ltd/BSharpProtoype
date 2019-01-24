CREATE FUNCTION [dbo].[fw_Entries__Json] (
	@Json NVARCHAR(MAX)
)
RETURNS TABLE
AS
RETURN
	SELECT c.*
	FROM OPENJSON (@json) p
		CROSS APPLY OpenJson(p.value, N'$.Entries') 
		WITH (
			[Index]					INT,
			[DocumentIndex]			INT,
			[Id]					INT,
			[DocumentId]			INT,
			[LineType]				NVARCHAR (255),
			[OperationId]			INT,
			[AccountId]				NVARCHAR (255),
			[CustodyId]				INT,
			[ResourceId]			INT,
			[Direction]				SMALLINT,
			[Amount]				MONEY,
			[Value]					VTYPE,
			[NoteId]				NVARCHAR (255),
			[Memo]					NVARCHAR (255),
			[Reference]				NVARCHAR (255),
			[RelatedReference]		NVARCHAR (255),
			[RelatedAgentId]		INT,
			[RelatedResourceId]		INT,
			[RelatedAmount]			MONEY,
			[EntityState]			NVARCHAR(255)
		) c;