CREATE FUNCTION [dbo].[ft2_Entries__Json] (
	@EntriesResultJson NVARCHAR(MAX)
)
RETURNS TABLE
AS
RETURN
SELECT *
	FROM OpenJson(@EntriesResultJson)
	WITH (
		[Index]					INT '$.Index',
		[LineIndex]				INT '$.LineIndex',
		[Id]					INT '$.Id',
		[LineId]				INT '$.LineId',
		[EntryNumber]			INT '$.EntryNumber',
		[OperationId]			INT '$.OperationId',
		[Reference]				NVARCHAR (255) '$.Reference',
		[AccountId]				NVARCHAR (255) '$.AccountId',

		[CustodyId]				INT '$.CustodyId',
		[ResourceId]			INT '$.ResourceId',
		[Direction]				SMALLINT '$.Direction',
		[Amount]				MONEY '$.Amount',
		[Value]					VTYPE '$.Value',
		[NoteId]				NVARCHAR (255) '$.NoteId',
		[RelatedReference]		NVARCHAR (255) '$.RelatedReference',
		[RelatedAgentId]		INT '$.RelatedAgentId',
		[RelatedResourceId]		INT '$.RelatedResourceId',
		[RelatedAmount]			MONEY '$.RelatedAmount',
		[EntityState]			NVARCHAR(255) '$.EntityState'
	);