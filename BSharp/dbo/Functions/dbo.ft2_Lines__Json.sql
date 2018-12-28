CREATE FUNCTION [dbo].[ft2_Lines__Json] (
	@LinesResultJson NVARCHAR(MAX)
)
RETURNS TABLE
AS
RETURN
	SELECT *
	FROM OpenJson(@LinesResultJson)
	WITH (
		[Index]					INT '$.Index',
		[DocumentIndex]			INT '$.DocumentIndex',
		[Id]					INT '$.Id',
		[DocumentId]			INT '$.DocumentId',
		[LineType]				NVARCHAR (255) '$.LineType',
		[BaseLineId]			INT '$.BaseLineId',
		[ScalingFactor]			FLOAT '$.ScalingFactor',
		[Memo]					NVARCHAR (255) '$.Memo',
		[EntriesOperationId]	INT '$.EntriesOperationId',
		[EntityState]			NVARCHAR(255) '$.EntityState'
	);