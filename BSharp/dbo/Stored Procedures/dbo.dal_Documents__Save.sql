CREATE PROCEDURE [dbo].[dal_Documents__Save]
	@Documents [dbo].[DocumentList] READONLY, 
	@Lines [dbo].[LineList] READONLY, 
	@Entries [dbo].[EntryList] READONLY,
	@IndexedIdsJson NVARCHAR(MAX) OUTPUT
AS
BEGIN
	DECLARE @IndexedIds [dbo].[IndexedIdList], @LinesIndexedIds [dbo].[IndexedIdList];

	DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();
	DECLARE @UserId INT = CONVERT(INT, SESSION_CONTEXT(N'UserId'));

	-- Delete only if the last one of its type, (WARNING: WE NEED TO do it for the given transaction type)
	--DELETE FROM [dbo].[Documents]
	--WHERE [Id] IN (SELECT [Id] FROM @Documents WHERE [EntityState] = N'Deleted')
	--AND [Id] > (SELECT MAX([Id]) FROM dbo.Documents WHERE Mode <> N'Void')

	---- Otherwise, mark as void
	--UPDATE [dbo].[Documents]
	--SET Mode = N'Void'
	--WHERE [Id] IN (SELECT [Id] FROM @Documents WHERE [EntityState] = N'Deleted');

	--DELETE FROM [dbo].Lines
	--WHERE [Id] IN (SELECT [Id] FROM @Lines WHERE [EntityState] = N'Deleted');

	DELETE FROM [dbo].[TransactionEntries]
	WHERE [Id] IN (SELECT [Id] FROM @Entries WHERE [EntityState] = N'Deleted');

	INSERT INTO @IndexedIds([Index], [Id])
	SELECT x.[Index], x.[Id]
	FROM
	(
		MERGE INTO [dbo].[Documents] AS t
		USING (
			SELECT 
				[Index], [Id], [State], [DocumentType], [Frequency], [Duration], [StartDateTime], [EndDateTime], 
				ROW_Number() OVER (PARTITION BY [EntityState] ORDER BY [Index]) + 
				-- and max(Id) per transaction type.
					(SELECT ISNULL(MAX([Id]), 0) FROM dbo.Documents) As [SerialNumber]
			FROM @Documents 
			WHERE [EntityState] IN (N'Inserted', N'Updated')
		) AS s ON (t.Id = s.Id)
		WHEN MATCHED
		THEN
			UPDATE SET
				t.[DocumentType]				= s.[State],
				t.[Frequency]			= s.[Frequency],
				t.[Repetitions]			= s.[Duration],
				t.[DocumentDate]		= s.[StartDateTime],
				t.[EndDate]			= s.[EndDateTime],
				t.[ModifiedAt]			= @Now,
				t.[ModifiedById]		= @UserId
		WHEN NOT MATCHED THEN
			INSERT (
				[DocumentType], [TransactionType], [Frequency], [Repetitions], [DocumentDate], [EndDate], [SerialNumber]
			)
			VALUES (
				s.[State], s.[DocumentType], s.[Frequency], s.[Duration], s.[StartDateTime], s.[EndDateTime], s.[SerialNumber]
			)
			OUTPUT s.[Index], inserted.[Id] 
	) As x;
	-- Assign the new ones to self
	INSERT INTO dbo.DocumentAssignments(DocumentId, AssigneeId)
	SELECT Id, @UserId
	FROM @IndexedIds


	--MERGE INTO [dbo].[Lines] AS t
	--USING (
	--	SELECT L.[Index], L.[Id], II.[Id] AS [DocumentId], [BaseLineId], [ScalingFactor], [Memo]
	--	FROM @Lines L
	--	JOIN @IndexedIds II ON L.DocumentIndex = II.[Index]
	--	WHERE L.[EntityState] IN (N'Inserted', N'Updated')
	--) AS s ON t.Id = s.Id
	--WHEN MATCHED THEN
	--	UPDATE SET 
	--		t.[BaseLineId]		= s.[BaseLineId], 
	--		t.[ScalingFactor]	= s.[ScalingFactor],
	--		t.[Memo]			= s.[Memo],
	--		t.[ModifiedAt]		= @Now,
	--		t.[ModifiedById]		= @UserId
	--WHEN NOT MATCHED THEN
	--	INSERT ([TenantId], [DocumentId], [BaseLineId], [ScalingFactor], [Memo], [CreatedAt], [CreatedById], [ModifiedAt], [ModifiedById])
	--	VALUES (@TenantId, s.[DocumentId], s.[BaseLineId], s.[ScalingFactor], s.[Memo], @Now, @UserId, @Now, @UserId);

	MERGE INTO [dbo].[TransactionEntries] AS t
	USING (
		SELECT
			E.[Id], II.[Id] AS [DocumentId], E.[LineType], E.[ResponsibilityCenterId], E.[Reference],
			E.[AccountId], E.[AgentAccountId], E.[ResourceId], E.[Direction], E.[MoneyAmount], E.[Value], E.[NoteId],
			E.[RelatedReference], E.[RelatedAgentAccountId], E.[RelatedResourceId], E.[RelatedMoneyAmount]
		FROM @Entries E
		JOIN @IndexedIds II ON E.DocumentIndex = II.[Index]
		WHERE E.[EntityState] IN (N'Inserted', N'Updated')
	) AS s ON t.Id = s.Id
	WHEN MATCHED THEN
		UPDATE SET 
			t.[ResponsibilityCenterId]	= s.[ResponsibilityCenterId],
			t.[Reference]				= s.[Reference],
			t.[AccountId]				= s.[AccountId],
			t.[AgentAccountId]			= s.[AgentAccountId],
			t.[ResourceId]				= s.[ResourceId],
			t.[Direction]				= s.[Direction],
			t.[MoneyAmount]				= s.[MoneyAmount],
			t.[Value]					= s.[Value],
			t.[IFRSNoteId]					= s.[NoteId],
			t.[RelatedReference]		= s.[RelatedReference],
			t.[RelatedAgentAccountId]	= s.[RelatedAgentAccountId],
			t.[RelatedResourceId]		= s.[RelatedResourceId],
			t.[RelatedMoneyAmount]		= s.[RelatedMoneyAmount],
			t.[ModifiedAt]				= @Now,
			t.[ModifiedById]			= @UserId
	WHEN NOT MATCHED THEN
		INSERT ([DocumentId], [IsSystem], [ResponsibilityCenterId], [Reference],
				[AccountId], [AgentAccountId], [ResourceId], [Direction], [MoneyAmount], [Value], [IFRSNoteId],
				[RelatedReference], [RelatedAgentAccountId], [RelatedResourceId], [RelatedMoneyAmount])
		VALUES (s.[DocumentId], s.[LineType], s.[ResponsibilityCenterId], s.[Reference],
				s.[AccountId], s.[AgentAccountId], s.[ResourceId], s.[Direction], s.[MoneyAmount], s.[Value], s.[NoteId],
				s.[RelatedReference], s.[RelatedAgentAccountId], s.[RelatedResourceId], s.[RelatedMoneyAmount]);

	SELECT @IndexedIdsJson = (SELECT * FROM @IndexedIds FOR JSON PATH);
END;