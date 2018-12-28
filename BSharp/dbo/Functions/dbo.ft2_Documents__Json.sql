CREATE FUNCTION [dbo].[ft2_Documents__Json] (
	@DocumentsResultJson NVARCHAR(MAX)
)
RETURNS TABLE
AS
RETURN
SELECT *
	FROM OpenJson(@DocumentsResultJson)
	WITH (
		[Index]				INT '$.Index',
		[Id]				INT '$.Id',
		[State]				NVARCHAR (255) '$.State',
		[DocumentType]		NVARCHAR (255) '$.DocumentType',
		[Frequency]			NVARCHAR (255) '$.Frequency',
		[Duration]			INT '$.Duration',
		[StartDateTime]		DATETIMEOFFSET (7) '$.StartDateTime',
		[EndDateTime]		DATETIMEOFFSET (7) '$.EndDateTime',
	--- Common for all lines, regardless of line type.
		[BaseLineId]		INT '$.BaseLineId',
		[ScalingFactor]		FLOAT '$.ScalingFactor',
		[Memo]				NVARCHAR (255) '$.Memo',
	-- Common for all entries of all lines
		[OperationId]		INT '$.OperationId',
		[AccountId]			NVARCHAR (255) '$.AccountId',
		[CustodyId]			INT '$.CustodyId',
		[ResourceId]		INT '$.ResourceId',
		[Direction]			SMALLINT '$.Direction',
		[Amount]			MONEY '$.Amount',
		[Value]				VTYPE '$.Value',
		[NoteId]			NVARCHAR (255) '$.NoteId',
		[Reference]			NVARCHAR (255) '$.Reference',
		[RelatedReference]	NVARCHAR (255) '$.RelatedReference',
		[RelatedAgentId]	INT '$.RelatedAgentId',
		[RelatedResourceId]	INT '$.RelatedResourceId',
		[RelatedAmount]		MONEY '$.RelatedAmount',

		[EntityState]			NVARCHAR(255) '$.EntityState'
	);