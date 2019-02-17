CREATE FUNCTION [dbo].[fw_Documents__Json] (
	@Json NVARCHAR(MAX)
)
RETURNS TABLE
AS
RETURN
SELECT *
	FROM OpenJson(@Json)
	WITH (
		[Index]				INT,
		[Id]				INT,
		[State]				NVARCHAR (255),
		[DocumentType]		NVARCHAR (255),
		[Frequency]			NVARCHAR (255),
		[Duration]			INT,
		[StartDateTime]		DATETIMEOFFSET (7),
		[EndDateTime]		DATETIMEOFFSET (7),
	--- Common for all lines, regardless of line type.
		[BaseLineId]		INT,
		[ScalingFactor]		FLOAT,
		[Memo]				NVARCHAR (255),
	-- Common for all entries of all lines

		[AccountId]			INT,
		[OperationId]		INT,
		[AgentId]			INT,
		[ResourceId]		INT,
		[Amount]			MONEY,
		[Value]				VTYPE,
		[NoteId]			NVARCHAR (255),
		[Reference]			NVARCHAR (255),
		[RelatedReference]	NVARCHAR (255),
		[RelatedAgentId]	INT,
		[RelatedResourceId]	INT,
		[RelatedAmount]		MONEY,

		[EntityState]			NVARCHAR(255)
	);