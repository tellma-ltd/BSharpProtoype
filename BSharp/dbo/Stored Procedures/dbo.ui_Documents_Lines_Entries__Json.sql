CREATE PROCEDURE [dbo].[ui_Documents_Lines_Entries__Json]
	@DocumentsResultJson NVARCHAR(MAX),
	@LinesResultJson NVARCHAR(MAX),
	@EntriesResultJson NVARCHAR(MAX)
AS
SELECT *
FROM OpenJson(@DocumentsResultJson)
WITH (
	[Id]					INT '$.Id',
	[State]					NVARCHAR (255) '$.State',
	[DocumentType]			NVARCHAR (255) '$.DocumentType',
	[Frequency]				NVARCHAR (255) '$.Frequency',
	[Duration]				INT '$.Duration',
	[StartDateTime]			DATETIMEOFFSET (7) '$.StartDateTime',
	[EndDateTime]			DATETIMEOFFSET (7) '$.EndDateTime',
	[Mode]					NVARCHAR (255) '$.Mode',
	[SerialNumber]			INT '$.SerialNumber',
	[CreatedAt]				DATETIMEOFFSET(7) '$.CreatedAt',
	[CreatedBy]				NVARCHAR(450) '$.CreatedBy',
	[ModifiedAt]			DATETIMEOFFSET(7) '$.ModifiedAt',
	[ModifiedBy]			NVARCHAR(450) '$.ModifiedBy',
	[EntityState]			NVARCHAR(255) '$.EntityState'
);

SELECT *
FROM OpenJson(@LinesResultJson)
WITH (
	[Id]					INT '$.Id',
	[DocumentId]			INT '$.DocumentId',
	[Assertion]				SMALLINT '$.Assertion',
	[LineType]				NVARCHAR (255) '$.LineType',
	[BaseLineId]			INT '$.BaseLineId',
	[ScalingFactor]			FLOAT '$.ScalingFactor',
	[Memo]					NVARCHAR (255) '$.Memo',
	[CreatedAt]				DATETIMEOFFSET(7) '$.CreatedAt',
	[CreatedBy]				NVARCHAR(450) '$.CreatedBy',
	[ModifiedAt]			DATETIMEOFFSET(7) '$.ModifiedAt',
	[ModifiedBy]			NVARCHAR(450) '$.ModifiedBy',
	[EntityState]			NVARCHAR(255) '$.EntityState'
)

RETURN 0;