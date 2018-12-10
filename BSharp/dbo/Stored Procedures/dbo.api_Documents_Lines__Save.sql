CREATE PROCEDURE [dbo].[api_Documents_Lines__Save]
	@Documents dbo.DocumentForSaveList READONLY, 
	@Lines dbo.LineForSaveList READONLY, 
	@Entries dbo.EntryForSaveList READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT,
	@ReturnEntities bit = 1,
	@DocumentsResultJson  NVARCHAR(MAX) OUTPUT,
	@LinesResultJson  NVARCHAR(MAX) OUTPUT,
	@EntriesResultJson  NVARCHAR(MAX) OUTPUT
AS
BEGIN
DECLARE @IndexedIdsJson NVARCHAR(MAX);

-- Validate
EXEC [dbo].[bll_Documents_Save__Validate]
	@Documents = @Documents,
	@Lines = @Lines,
	@Entries = @Entries,
	@ValidationErrorsJson = @ValidationErrorsJson OUTPUT

IF @ValidationErrorsJson IS NOT NULL
	RETURN;

EXEC dbo.[bll_Documents_Lines__Fill]
	@Documents = @Documents, @Lines = @Lines, @Entries = @Entries,
	@DocumentsResultJson = @DocumentsResultJson OUTPUT,
	@LinesResultJson = @LinesResultJson OUTPUT,
	@EntriesResultJson = @EntriesResultJson OUTPUT

DECLARE 	
	@FilledDocuments dbo.DocumentForSaveNoIdentityList , 
	@FilledLines dbo.LineForSaveNoIdentityList, 
	@FilledEntries dbo.EntryForSaveNoIdentityList;

	INSERT INTO @FilledDocuments
	--(
	--	[Index], [Id], [State], [TransactionType], [FolderId], [ResponsibleAgentId],	
	--	[LinesMemo], [LinesStartDateTime], [LinesEndDateTime], 
	--	[LinesCustody1], [LinesCustody2], [LinesCustody3], [LinesReference1], [LinesReference2], [LinesReference3], 
	--	[EntityState]
	--)
	SELECT *
		--[Index], [Id], [State], [TransactionType], [FolderId], [ResponsibleAgentId],
		--[LinesMemo], [LinesStartDateTime], [LinesEndDateTime], 
		--[LinesCustody1], [LinesCustody2], [LinesCustody3], [LinesReference1], [LinesReference2], [LinesReference3], 
		--[EntityState]
	FROM OpenJson(@DocumentsResultJson)
	WITH (
		[Index]					INT '$.Index',
		[Id]					INT '$.Id',
		[State]					NVARCHAR (255) '$.State',
		[TransactionType]		NVARCHAR (255) '$.TransactionType',
		[FolderId]				INT '$.FolderId',
		[ResponsibleAgentId]	INT '$.ResponsibleAgentId',
		[LinesMemo]				NVARCHAR (255) '$.LinesMemo',
		[LinesStartDateTime]	DATETIMEOFFSET (7) '$.LinesStartDateTime',
		[LinesEndDateTime]		DATETIMEOFFSET (7) '$.LinesEndDateTime',
		[LinesCustody1]			INT '$.LinesCustody1',
		[LinesCustody2]			INT '$.LinesCustody2',
		[LinesCustody3]			INT '$.LinesCustody3',
		[LinesReference1]		NVARCHAR(255) '$.LinesReference1',
		[LinesReference2]		NVARCHAR(255) '$.LinesReference2',
		[LinesReference3]		NVARCHAR(255) '$.LinesReference3',
		[EntityState]			NVARCHAR(255) '$.EntityState'
	)

	INSERT INTO @FilledLines(
		[Index], [Id], [DocumentIndex], [DocumentId], [StartDateTime], [EndDateTime], [BaseLineId], [ScalingFactor], [Memo], [EntityState]
	)
	SELECT
		[Index], [Id], [DocumentIndex], [DocumentId], [StartDateTime], [EndDateTime], [BaseLineId], [ScalingFactor], [Memo], [EntityState]
	FROM OpenJson(@LinesResultJson)
	WITH (
		[Index]					int '$.Index',
		[Id]					int '$.Id',
		[DocumentIndex]			int '$.DocumentIndex',
		[DocumentId]			int '$.DocumentId',
		[StartDateTime]			datetimeoffset (7) '$.StartDateTime',
		[EndDateTime]			datetimeoffset (7) '$.EndDateTime',
		[BaseLineId]			int '$.BaseLineId',
		[ScalingFactor]			float '$.ScalingFactor',
		[Memo]					nvarchar (255) '$.Memo',
		[EntityState]			nvarchar(255) '$.EntityState'
	)

	INSERT INTO @FilledEntries(
		[Index], [Id], [LineIndex], [LineId], [EntryNumber], [OperationId], [Reference], [AccountId],
		[CustodyId], [ResourceId], [Direction], [Amount], [Value], [NoteId], [RelatedReference], [RelatedAgentId],
		[RelatedResourceId], [RelatedAmount], [EntityState]
	)
	SELECT
		[Index], [Id], [LineIndex], [LineId], [EntryNumber], [OperationId], [Reference], [AccountId],
		[CustodyId], [ResourceId], [Direction], [Amount], [Value], [NoteId], [RelatedReference], [RelatedAgentId],
		[RelatedResourceId], [RelatedAmount], [EntityState]
	FROM OpenJson(@EntriesResultJson)
	WITH (
		[Index]					INT '$.Index',
		[Id]					INT '$.Id',
		[LineIndex]				INT '$.LineIndex',
		[LineId]				INT '$.LineId',
		[EntryNumber]			INT '$.EntryNumber',
		[OperationId]			INT '$.OperationId',
		[Reference]				NVARCHAR (255) '$.Reference',
		[AccountId]				NVARCHAR (255) '$.AccountId',
		[CustodyId]				INT '$.CustodyId',
		[ResourceId]			INT '$.ResourceId',
		[Direction]				SMALLINT '$.Direction',
		[Amount]				MONEY '$.Amount',
		[Value]					MONEY '$.Value',
		[NoteId]				NVARCHAR (255) '$.NoteId',
		[RelatedReference]		NVARCHAR (255) '$.RelatedReference',
		[RelatedAgentId]		INT '$.RelatedAgentId',
		[RelatedResourceId]		INT '$.RelatedResourceId',
		[RelatedAmount]			MONEY '$.RelatedAmount',
		[EntityState]			NVARCHAR(255) '$.EntityState'
	)

EXEC [dbo].[dal_Documents__Save]
	@Documents = @FilledDocuments,
	@Lines = @FilledLines,
	@Entries = @FilledEntries,
	@IndexedIdsJson = @IndexedIdsJson OUTPUT

IF (@ReturnEntities = 1)
	EXEC [dbo].[dal_Documents_Lines__Select] 
		@IndexedIdsJson = @IndexedIdsJson, 
		@DocumentsResultJson = @DocumentsResultJson OUTPUT,
		@LinesResultJson  = @LinesResultJson OUTPUT,
		@EntriesResultJson  = @EntriesResultJson OUTPUT
END;