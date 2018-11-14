CREATE PROCEDURE [dbo].[ral_Documents_Lines_Entries__Insert]
@Documents DocumentList READONLY,
@Lines LineList READONLY,
@Entries EntryList READONLY
AS
BEGIN
	DECLARE @TenantId int, @msg nvarchar(2048);
	DECLARE @DocumentIdMappings IdMappingList, @LineIdMappings IdMappingList, @EntryIdMappings IdMappingList;
	DECLARE @DocumentsLocal DocumentList, @LinesLocal LineList, @EntriesLocal EntryList;
	
	SELECT @TenantId = dbo.fn_TenantId();
	IF @TenantId IS NULL
	BEGIN
		SELECT @msg = FORMATMESSAGE(dbo.fn_Translate('NullTenantId')); 
		THROW 50001, @msg, 1;
	END

	INSERT INTO @DocumentsLocal([Id], [State], [TransactionType], [FolderId], [LinesMemo], [LinesResponsibleAgentId],
								[LinesStartDateTime], [LinesEndDateTime], [LinesCustody1], [LinesCustody2], [LinesCustody3], 
								[LinesReference1], [LinesReference2], [LinesReference3], [ForwardedToUserId], [Status], [TemporaryId])
	SELECT [Id], [State], [TransactionType], [FolderId], [LinesMemo], [LinesResponsibleAgentId],
								[LinesStartDateTime], [LinesEndDateTime], [LinesCustody1], [LinesCustody2], [LinesCustody3], 
								[LinesReference1], [LinesReference2], [LinesReference3], [ForwardedToUserId], [Status], [Id]
	FROM @Documents;

	DELETE FROM dbo.Documents
	WHERE TenantId = @TenantId AND Id IN (SELECT Id FROM @Documents WHERE Status = N'Deleted');
	DELETE FROM @DocumentsLocal WHERE Status = N'Deleted';

	INSERT INTO @DocumentIdMappings([NewId], [OldId])
	SELECT x.[NewId], x.[OldId]
	FROM
	(
		MERGE INTO dbo.Documents AS t
		USING (
			SELECT @TenantId As [TenantId], [Id], [State], [TransactionType], [Mode], [FolderId], [LinesMemo], [LinesResponsibleAgentId],
								[LinesStartDateTime], [LinesEndDateTime], [LinesCustody1], [LinesCustody2], [LinesCustody3], 
								[LinesReference1], [LinesReference2], [LinesReference3], [ForwardedToUserId]
			FROM @DocumentsLocal 
			WHERE [Status] IN (N'Inserted', N'Updated')
		) AS s ON t.[TenantId] = s.[TenantId] AND t.Id = s.Id
		WHEN MATCHED THEN
			UPDATE SET 
				t.FolderId = s.FolderId,
				t.LinesMemo = s.LinesMemo,
				t.LinesResponsibleAgentId = s.LinesResponsibleAgentId,
				t.LinesStartDateTime = s.LinesStartDateTime,
				t.LinesEndDateTime = s.LinesEndDateTime,
				t.LinesCustody1 = s.LinesCustody1,
				t.LinesCustody2 = s.LinesCustody2,
				t.LinesCustody3 = s.LinesCustody3,
				t.LinesReference1 = s.LinesReference1,
				t.LinesReference2 = s.LinesReference2,
				t.LinesReference3 = s.LinesReference3,
				t.ForwardedToUserId = s.ForwardedToUserId
		WHEN NOT MATCHED THEN
			INSERT ([TenantId], [State], [TransactionType], [FolderId], [LinesMemo], [LinesResponsibleAgentId],
								[LinesStartDateTime], [LinesEndDateTime], [LinesCustody1], [LinesCustody2], [LinesCustody3], 
								[LinesReference1], [LinesReference2], [LinesReference3], [ForwardedToUserId])
			VALUES (@TenantId, s.[State], s.[TransactionType], s.[FolderId], s.[LinesMemo], s.[LinesResponsibleAgentId],
								s.[LinesStartDateTime], s.[LinesEndDateTime], s.[LinesCustody1], s.[LinesCustody2], s.[LinesCustody3], 
								s.[LinesReference1], s.[LinesReference2], s.[LinesReference3], s.[ForwardedToUserId])
		OUTPUT inserted.[Id] As [NewId], s.[Id] As [OldId]
	) AS x;

	UPDATE D 
	SET D.[Id] = M.[NewId]
	FROM @DocumentsLocal D
	JOIN @DocumentIdMappings M ON D.TemporaryId = M.OldId;

	-- Assign Serial Numbers, I wish we could do it asynchronously...
	-- For each state/transaction type, get the last serial number, and add one

	INSERT INTO @LinesLocal([Id], [DocumentId], [ResponsibleAgentId], [StartDateTime], [EndDateTime], [Memo], [Status], [TemporaryId])
	SELECT [Id], [DocumentId], [ResponsibleAgentId], [StartDateTime], [EndDateTime], [Memo], [Status], [Id]
	FROM @Lines
	
	UPDATE L 
	SET [DocumentId] = [NewId]
	FROM @LinesLocal L
	JOIN @DocumentIdMappings M ON L.DocumentId = M.OldId

	DELETE FROM dbo.Lines
	WHERE TenantId = @TenantId AND Id IN (SELECT Id FROM @LinesLocal WHERE Status = N'Deleted');
	DELETE FROM @LinesLocal WHERE Status = N'Deleted';

	INSERT INTO @LineIdMappings([NewId], [OldId])
	SELECT y.[NewId], y.[OldId]
	FROM
	(
		MERGE INTO dbo.Lines AS t
		USING (
			SELECT @TenantId As [TenantId], [Id], [DocumentId], [ResponsibleAgentId], [StartDateTime], [EndDateTime], [Memo]
			FROM @LinesLocal 
			WHERE [Status] IN (N'Inserted', N'Updated')
		) AS s ON t.[TenantId] = s.[TenantId] AND t.Id = s.Id
		WHEN MATCHED THEN
			UPDATE SET 
				t.[ResponsibleAgentId] = s.[ResponsibleAgentId],
				t.[StartDateTime] = s.[StartDateTime],
				t.[EndDateTime] = s.[EndDateTime],
				t.[Memo] = s.[Memo]
		WHEN NOT MATCHED THEN
			INSERT ([TenantId], [DocumentId], [ResponsibleAgentId], [StartDateTime], [EndDateTime], [Memo])
			VALUES (@TenantId, s.[DocumentId], s.[ResponsibleAgentId], s.[StartDateTime], s.[EndDateTime], s.[Memo])
		OUTPUT inserted.[Id] As [NewId], s.[Id] As [OldId]
	) AS y;

	UPDATE L 
	SET L.[Id] = M.[NewId]
	FROM @LinesLocal L
	JOIN @LineIdMappings M ON L.TemporaryId = M.OldId;
	
	INSERT INTO @EntriesLocal([Id], [LineId], [EntryNumber], [OperationId], [Reference],
					[AccountId], [CustodyId], [ResourceId], [Direction], [Amount], [Value], [NoteId],
					[RelatedReference], [RelatedAgentId], [RelatedResourceId], [RelatedAmount], [Status], [TemporaryId])
	SELECT [Id], [LineId], [EntryNumber], [OperationId], [Reference],
					[AccountId], [CustodyId], [ResourceId], [Direction], [Amount], [Value], [NoteId],
					[RelatedReference], [RelatedAgentId], [RelatedResourceId], [RelatedAmount], [Status], [Id]
	FROM @Entries;

	DELETE FROM dbo.Entries
	WHERE TenantId = @TenantId AND Id IN (SELECT Id FROM @EntriesLocal WHERE [Status] = N'Deleted');
	DELETE FROM @EntriesLocal WHERE [Status] = N'Deleted';

	UPDATE E
	SET E.[LineId] = M.[NewId]
	FROM @EntriesLocal E
	JOIN @LineIdMappings M ON E.LineId = M.OldId

	INSERT INTO @EntryIdMappings([NewId], [OldId])
	SELECT z.[NewId], z.[OldId]
	FROM
	(
		MERGE INTO dbo.Entries AS t
		USING (
			SELECT @TenantId As [TenantId], [Id], [LineId], [EntryNumber], [OperationId], [Reference],
					[AccountId], [CustodyId], [ResourceId], [Direction], [Amount], [Value], [NoteId],
					[RelatedReference], [RelatedAgentId], [RelatedResourceId], [RelatedAmount]
			FROM @EntriesLocal 
			WHERE [Status] IN (N'Inserted', N'Updated')
		) AS s ON t.[TenantId] = s.[TenantId] AND t.Id = s.Id
		WHEN MATCHED THEN
			UPDATE SET 
				t.[EntryNumber] = s.[EntryNumber],
				t.[OperationId] = s.[OperationId],
				t.[Reference] = s.[Reference],
				t.[AccountId] = s.[AccountId],
				t.[CustodyId] = s.[CustodyId],
				t.[ResourceId] = s.[ResourceId],
				t.[Direction] = s.[Direction],
				t.[Amount] = s.[Amount],
				t.[Value] = s.[Value],
				t.[NoteId] = s.[NoteId],
				t.[RelatedReference] = s.[RelatedReference],
				t.[RelatedAgentId] = s.[RelatedAgentId],
				t.[RelatedResourceId] = s.[RelatedResourceId],
				t.[RelatedAmount] = s.[RelatedAmount]
		WHEN NOT MATCHED THEN
			INSERT ([TenantId], [LineId], [EntryNumber], [OperationId], [Reference],
					[AccountId], [CustodyId], [ResourceId], [Direction], [Amount], [Value], [NoteId],
					[RelatedReference], [RelatedAgentId], [RelatedResourceId], [RelatedAmount])
			VALUES (@TenantId, s.[LineId], s.[EntryNumber], s.[OperationId], s.[Reference],
					s.[AccountId], s.[CustodyId], s.[ResourceId], s.[Direction], s.[Amount], s.[Value], s.[NoteId],
					s.[RelatedReference], s.[RelatedAgentId], s.[RelatedResourceId], s.[RelatedAmount])
		OUTPUT inserted.[Id] As [NewId], s.[Id] As [OldId]
	) AS z;

	UPDATE E 
	SET E.[Id] = M.[NewId]
	FROM @EntriesLocal E
	JOIN @EntryIdMappings M ON E.TemporaryId = M.OldId;

	UPDATE @DocumentsLocal SET [Status] = N'Unchanged';
	UPDATE @LinesLocal SET [Status] = N'Unchanged';
	UPDATE @EntriesLocal SET [Status] = N'Unchanged';

	SELECT [Id], [State], [TransactionType], [SerialNumber], [Mode], [FolderId], 
			[LinesMemo], [LinesResponsibleAgentId],	[LinesStartDateTime], [LinesEndDateTime], 
			[LinesCustody1], [LinesCustody2], [LinesCustody3], [LinesReference1], [LinesReference2], [LinesReference3], 
			[ForwardedToUserId], [Status], [TemporaryId]
	FROM @DocumentsLocal;
END;