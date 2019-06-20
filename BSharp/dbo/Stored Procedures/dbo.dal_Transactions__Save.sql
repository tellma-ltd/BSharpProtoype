CREATE PROCEDURE [dbo].[dal_Transactions__Save]
	@TransactionType NVARCHAR(255),
	@Transactions [dbo].[TransactionList] READONLY,
	@Lines [dbo].[TransactionLineList] READONLY, 
	@Entries [dbo].[TransactionEntryList] READONLY,
	@IndexedIdsJson NVARCHAR(MAX) OUTPUT
AS
BEGIN
	DECLARE @IndexedIds [dbo].[IndexedIdList], @LinesIndexedIds [dbo].[IndexedIdList];

	DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();
	DECLARE @UserId INT = CONVERT(INT, SESSION_CONTEXT(N'UserId'));

	-- Delete only if the last one of its type
	DELETE FROM [dbo].[Documents]
	WHERE [Id] IN (SELECT [Id] FROM @Transactions WHERE [EntityState] = N'Deleted')
	AND [Id] > (
		SELECT MAX([Id]) FROM dbo.Documents 
		WHERE [DocumentType] = @TransactionType 
		AND [DocumentState] <> N'Void'
		);

	-- Otherwise, mark as void
	UPDATE [dbo].[Documents]
	SET [DocumentState] = N'Void'
	WHERE [Id] IN (SELECT [Id] FROM @Transactions WHERE [EntityState] = N'Deleted');

	--DELETE FROM [dbo].[TransactionLines]
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
				[Index], [Id], [DocumentDate], [VoucherReference], [Memo], [Frequency], [Repetitions],
				ROW_Number() OVER (PARTITION BY [EntityState] ORDER BY [Index]) + (
					-- max(Id) per transaction type.
					SELECT ISNULL(MAX([Id]), 0) FROM dbo.Documents WHERE [DocumentType] = @TransactionType
				) As [SerialNumber]
			FROM @Transactions 
			WHERE [EntityState] IN (N'Inserted', N'Updated')
		) AS s ON (t.Id = s.Id)
		WHEN MATCHED
		THEN
			UPDATE SET
				t.[DocumentDate]	= s.[DocumentDate],
				t.[VoucherReference]= s.[VoucherReference],
				t.[Memo]			= s.[Memo],
				t.[Frequency]		= s.[Frequency],
				t.[Repetitions]		= s.[Repetitions],

				t.[ModifiedAt]		= @Now,
				t.[ModifiedById]	= @UserId
		WHEN NOT MATCHED THEN
			INSERT (
				[DocumentDate], [VoucherReference],[Memo],[Frequency],[Repetitions]
			)
			VALUES (
				s.[DocumentDate], s.[VoucherReference], s.[Memo], s.[Frequency], s.[Repetitions]
			)
			OUTPUT s.[Index], inserted.[Id] 
	) As x;
	-- Assign the new ones to self
	INSERT INTO dbo.DocumentAssignments(DocumentId, AssigneeId)
	SELECT Id, @UserId
	FROM @IndexedIds


	--MERGE INTO [dbo].[TransactionLines] AS t
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
	--	INSERT ([DocumentId], [BaseLineId], [ScalingFactor], [Memo], [CreatedAt], [CreatedById], [ModifiedAt], [ModifiedById])
	--	VALUES (s.[DocumentId], s.[BaseLineId], s.[ScalingFactor], s.[Memo], @Now, @UserId, @Now, @UserId);

	MERGE INTO [dbo].[TransactionEntries] AS t
	USING (
		SELECT
			E.[Id], II.[Id] AS [DocumentId], E.[Direction], E.[AccountId], E.[IfrsNoteId], E.[ResponsibilityCenterId],
				E.[ResourceId], E.[InstanceId], E.[BatchCode], E.[DueDate], E.[Quantity],
				E.[MoneyAmount], E.[Mass], E.[Volume], E.[Area], E.[Length], E.[Time], E.[Count], E.[Value], E.[Memo],
				E.[ExternalReference], E.[AdditionalReference], 
				E.[RelatedResourceId], E.[RelatedAgentId], E.[RelatedMoneyAmount]
		FROM @Entries E
		JOIN @IndexedIds II ON E.[TransactionLineIndex] = II.[Index]
		WHERE E.[EntityState] IN (N'Inserted', N'Updated')
	) AS s ON t.Id = s.Id
	WHEN MATCHED THEN
		UPDATE SET
			t.[Direction]				= s.[Direction],	
			t.[AccountId]				= s.[AccountId],
			t.[IfrsNoteId]				= s.[IfrsNoteId],
			t.[ResponsibilityCenterId]	= s.[ResponsibilityCenterId],
			t.[ResourceId]				= s.[ResourceId],
			t.[InstanceId]				= s.[InstanceId],
			t.[BatchCode]				= s.[BatchCode],
			t.[Quantity]				= s.[Quantity],
			t.[MoneyAmount]				= s.[MoneyAmount],
			t.[Mass]					= s.[Mass],
			t.[Volume]					= s.[Volume],
			t.[Area]					= s.[Area],
			t.[Length]					= s.[Length],
			t.[Time]					= s.[Time],
			t.[Count]					= s.[Count],
			t.[Value]					= s.[Value],
			t.[Memo]					= s.[Memo],
			t.[ExternalReference]		= s.[ExternalReference],
			t.[AdditionalReference]		= s.[AdditionalReference],
			t.[RelatedResourceId]		= s.[RelatedResourceId],
			t.[RelatedAgentId]			= s.[RelatedAgentId],
			t.[RelatedMoneyAmount]		= s.[RelatedMoneyAmount],
			t.[ModifiedAt]				= @Now,
			t.[ModifiedById]			= @UserId
	WHEN NOT MATCHED THEN
		INSERT ([TransactionLineId], [Direction], [AccountId], [IfrsNoteId], [ResponsibilityCenterId],
				[ResourceId], [InstanceId], [BatchCode], [Quantity],
				[MoneyAmount], [Mass], [Volume], [Area], [Length], [Time], [Count],  [Value], [Memo],
				[ExternalReference], [AdditionalReference], [RelatedResourceId], [RelatedAgentId], [RelatedMoneyAmount])
		VALUES (s.[DocumentId], s.[Direction], s.[AccountId], s.[IfrsNoteId], s.[ResponsibilityCenterId],
				s.[ResourceId], s.[InstanceId], s.[BatchCode], s.[Quantity],
				s.[MoneyAmount], s.[Mass], s.[Volume], s.[Area], s.[Length], s.[Time], s.[Count], s.[Value], s.[Memo],
				s.[ExternalReference], s.[AdditionalReference], s.[RelatedResourceId], s.[RelatedAgentId], s.[RelatedMoneyAmount])
		;
	SELECT @IndexedIdsJson = (SELECT * FROM @IndexedIds FOR JSON PATH);
END;