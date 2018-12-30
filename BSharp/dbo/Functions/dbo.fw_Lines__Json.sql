CREATE FUNCTION [dbo].[fw_Lines__Json] (
	@Json NVARCHAR(MAX)
)
RETURNS TABLE
AS
RETURN
	SELECT *
	FROM OpenJson(@Json)
	WITH (
		[Index]					INT '$.Index',
		[DocumentIndex]			INT '$.DocumentIndex',
		[Id]					INT '$.Id',
		[DocumentId]			INT '$.DocumentId',
		[LineType]				NVARCHAR (255) '$.LineType',
		[BaseLineId]			INT '$.BaseLineId',
		[ScalingFactor]			FLOAT '$.ScalingFactor',
		[Memo]					NVARCHAR (255) '$.Memo',
-- Common for all entries of all lines
		[OperationId]		INT,
		[AccountId]			NVARCHAR (255),
		[CustodyId]			INT,
		[ResourceId]		INT,
		[Direction]			SMALLINT,
		[Amount]			MONEY,
		[Value]				VTYPE,
		[NoteId]			NVARCHAR (255),
		[Reference]			NVARCHAR (255),
		[RelatedReference]	NVARCHAR (255),
		[RelatedAgentId]	INT,
		[RelatedResourceId]	INT,
		[RelatedAmount]		MONEY,
		[EntityState]			NVARCHAR(255) '$.EntityState'
	);