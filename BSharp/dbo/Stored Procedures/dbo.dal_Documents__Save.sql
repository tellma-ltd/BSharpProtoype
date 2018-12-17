CREATE PROCEDURE [dbo].[dal_Documents__Save]
	@Documents [dbo].DocumentForSaveNoIdentityList READONLY, 
	@Lines [dbo].LineForSaveNoIdentityList READONLY, 
	@Entries [dbo].EntryForSaveNoIdentityList READONLY,
	@IndexedIdsJson NVARCHAR(MAX) OUTPUT
AS
BEGIN
	DECLARE @IndexedIds [dbo].[IndexedIdList], @LinesIndexedIds [dbo].[IndexedIdList];
	DECLARE @TenantId int = CONVERT(INT, SESSION_CONTEXT(N'TenantId'));
	DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();
	DECLARE @UserId NVARCHAR(450) = CONVERT(NVARCHAR(450), SESSION_CONTEXT(N'UserId'));

	-- Delete only if the last one of its type, (WARNING: WE NEED TO do it for the given transaction type)
	DELETE FROM [dbo].[Documents]
	WHERE [Id] IN (SELECT [Id] FROM @Documents WHERE [EntityState] = N'Deleted')
	AND [Id] > (SELECT MAX([Id]) FROM dbo.Documents WHERE Mode <> N'Void')

	-- Otherwise, mark as void
	UPDATE [dbo].[Documents]
	SET Mode = N'Void'
	WHERE [Id] IN (SELECT [Id] FROM @Documents WHERE [EntityState] = N'Deleted');

	DELETE FROM [dbo].Lines
	WHERE [Id] IN (SELECT [Id] FROM @Lines WHERE [EntityState] = N'Deleted');

	DELETE FROM [dbo].Entries
	WHERE [Id] IN (SELECT [Id] FROM @Entries WHERE [EntityState] = N'Deleted');

	INSERT INTO @IndexedIds([Index], [Id])
	SELECT x.[Index], x.[Id]
	FROM
	(
		MERGE INTO [dbo].[Documents] AS t
		USING (
			SELECT 
				[Index], [Id], [State], [TransactionType], [ResponsibleAgentId], [FolderId], [LinesMemo],
				[LinesStartDateTime], [LinesEndDateTime], [LinesCustody1], [LinesCustody2], [LinesCustody3],
				[LinesReference1], [LinesReference2], [LinesReference3],
				-- RowNumber should be for inserted only, 
				ROW_Number() OVER (PARTITION BY [EntityState] ORDER BY [Index]) + 
				-- and max(Id) per transaction type.
					(SELECT ISNULL(MAX([Id]), 0) FROM dbo.Documents) As [SerialNumber]
			FROM @Documents 
			WHERE [EntityState] IN (N'Inserted', N'Updated')
		) AS s ON (t.Id = s.Id)
		WHEN MATCHED 
		THEN
			UPDATE SET
				t.[State]				= s.[State],
				t.[ResponsibleAgentId]	= s.[ResponsibleAgentId],
				t.[FolderId]			= s.[FolderId],
				t.[LinesMemo]			= s.[LinesMemo],
				t.[LinesStartDateTime]	= s.[LinesStartDateTime],
				t.[LinesEndDateTime]	= s.[LinesEndDateTime],
				t.[LinesCustody1]		= s.[LinesCustody1],
				t.[LinesCustody2]		= s.[LinesCustody2],
				t.[LinesCustody3]		= s.[LinesCustody3],
				t.[LinesReference1]		= s.[LinesReference1],
				t.[LinesReference2]		= s.[LinesReference2],
				t.[LinesReference3]		= s.[LinesReference3],
				t.[ModifiedAt]			= @Now,
				t.[ModifiedBy]			= @UserId
		WHEN NOT MATCHED THEN
			INSERT (
				[TenantId],[State], [TransactionType], [SerialNumber], [ResponsibleAgentId], [FolderId], [LinesMemo],
				[LinesStartDateTime], [LinesEndDateTime], [LinesCustody1], [LinesCustody2], [LinesCustody3],
				[LinesReference1], [LinesReference2], [LinesReference3], [CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy]
			)
			VALUES (
				@TenantId, s.[State], s.[TransactionType], s.[SerialNumber], s.[ResponsibleAgentId], s.[FolderId], s.[LinesMemo],
				s.[LinesStartDateTime], s.[LinesEndDateTime], s.[LinesCustody1], s.[LinesCustody2], s.[LinesCustody3],
				s.[LinesReference1], s.[LinesReference2], s.[LinesReference3], @Now, @UserId, @Now, @UserId
			)
			OUTPUT s.[Index], inserted.[Id] 
	) As x;

	INSERT INTO @LinesIndexedIds([Index], [Id])
	SELECT x.[Index], x.[Id]
	FROM
	(
		MERGE INTO [dbo].[Lines] AS t
		USING (
			SELECT L.[Index], L.[Id], II.[Id] AS [DocumentId], [StartDateTime], [EndDateTime], [BaseLineId], [ScalingFactor], [Memo]
			FROM @Lines L
			JOIN @IndexedIds II ON L.DocumentIndex = II.[Index]
			WHERE L.[EntityState] IN (N'Inserted', N'Updated')
		) AS s ON t.Id = s.Id
		WHEN MATCHED THEN
			UPDATE SET 
				t.[StartDateTime]	= s.[StartDateTime],
				t.[EndDateTime]		= s.[EndDateTime],
				t.[BaseLineId]		= s.[BaseLineId], 
				t.[ScalingFactor]	= s.[ScalingFactor],
				t.[Memo]			= s.[Memo],
				t.[ModifiedAt]		= @Now,
				t.[ModifiedBy]		= @UserId
		WHEN NOT MATCHED THEN
			INSERT ([TenantId], [DocumentId], [StartDateTime], [EndDateTime], [BaseLineId], [ScalingFactor], [Memo], [CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy])
			VALUES (@TenantId, s.[DocumentId], s.[StartDateTime], s.[EndDateTime], s.[BaseLineId], s.[ScalingFactor], s.[Memo], @Now, @UserId, @Now, @UserId)
		OUTPUT s.[Index], inserted.[Id]
	) As x

	MERGE INTO [dbo].Entries AS t
	USING (
		SELECT
			E.[Id], II.[Id] AS [LineId], [EntryNumber], [OperationId], [Reference],
			[AccountId], [CustodyId], [ResourceId], [Direction], [Amount], [Value], [NoteId],
			[RelatedReference], [RelatedAgentId], [RelatedResourceId], [RelatedAmount]
		FROM @Entries E
		JOIN @LinesIndexedIds II ON E.LineIndex = II.[Index]
		WHERE [EntityState] IN (N'Inserted', N'Updated')
	) AS s ON t.Id = s.Id
	WHEN MATCHED THEN
		UPDATE SET 
			t.[EntryNumber]			= s.[EntryNumber],
			t.[OperationId]			= s.[OperationId],
			t.[Reference]			= s.[Reference],
			t.[AccountId]			= s.[AccountId],
			t.[CustodyId]			= s.[CustodyId],
			t.[ResourceId]			= s.[ResourceId],
			t.[Direction]			= s.[Direction],
			t.[Amount]				= s.[Amount],
			t.[Value]				= s.[Value],
			t.[NoteId]				= s.[NoteId],
			t.[RelatedReference]	= s.[RelatedReference],
			t.[RelatedAgentId]		= s.[RelatedAgentId],
			t.[RelatedResourceId]	= s.[RelatedResourceId],
			t.[RelatedAmount]		= s.[RelatedAmount],
			t.[ModifiedAt]			= @Now,
			t.[ModifiedBy]			= @UserId
	WHEN NOT MATCHED THEN
		INSERT ([TenantId], [LineId], [EntryNumber], [OperationId], [Reference],
				[AccountId], [CustodyId], [ResourceId], [Direction], [Amount], [Value], [NoteId],
				[RelatedReference], [RelatedAgentId], [RelatedResourceId], [RelatedAmount],
				[CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy])
		VALUES (@TenantId, s.[LineId], s.[EntryNumber], s.[OperationId], s.[Reference],
				s.[AccountId], s.[CustodyId], s.[ResourceId], s.[Direction], s.[Amount], s.[Value], s.[NoteId],
				s.[RelatedReference], s.[RelatedAgentId], s.[RelatedResourceId], s.[RelatedAmount],
				@Now, @UserId, @Now, @UserId);

	SELECT @IndexedIdsJson = (SELECT * FROM @IndexedIds FOR JSON PATH);
END;



