CREATE PROCEDURE [dbo].[ral_Documents_Lines_Entries__Insert]
@Documents DocumentList READONLY,
@Lines LineList READONLY,
@Entries EntryList READONLY
AS
BEGIN
BEGIN TRY
	DECLARE @IdMappings IdMappingList, @TenantId int;
	SELECT @TenantId = dbo.fn_TenantId();
	IF @TenantId IS NULL
		THROW 50001, N'Tenant Id is NULL', 1;

	BEGIN TRANSACTION
		DELETE FROM dbo.Documents
		WHERE TenantId = @TenantId AND Id IN (SELECT Id FROM @Documents WHERE Status = N'Deleted');

		INSERT INTO @IdMappings([NewId], [OldId])
		SELECT x.[NewId], x.[OldId]
		FROM
		(
			MERGE INTO dbo.Documents AS t
			USING (
				SELECT @TenantId As [TenantId], [Id], [State], [TransactionType], [Mode], [FolderId], [LinesMemo], [LinesResponsibleAgentId],
									[LinesStartDateTime], [LinesEndDateTime], [LinesCustody1], [LinesCustody2], [LinesCustody3], 
									[LinesReference1], [LinesReference2], [LinesReference3], [ForwardedToUserId]
				FROM @Documents 
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
			--WHEN NOT MATCHED BY SOURCE THEN 
			--	DELETE
			OUTPUT inserted.[Id] As [NewId], s.[Id] As [OldId]
		) AS x;

		-- Assign Serial Numbers, I wish we could do it asynchronously...
		-- For each state/transaction type, get the last serial number, and add one


		/*
		DELETE FROM L
		FROM dbo.Lines L JOIN @Lines LL
		ON L.DocumentId = LL.DocumentId AND L.LineNumber = LL.LineNumber
		WHERE LL.Status = N'Deleted';

		UPDATE L
		SET 
			L.ResponsibleAgentId = 1,
			L.StartDateTime = LL.StartDateTime,
			L.EndDateTime = LL.EndDateTime
		FROM dbo.Lines L
		JOIN @Lines LL ON L.DocumentId = LL.DocumentId and L.LineNumber = LL.LineNumber
		WHERE L.DocumentId IN (SELECT Id FROM @Documents WHERE SerialNumber IS NOT NULL);

		INSERT INTO  dbo.Lines(DocumentId, LineNumber, ResponsibleAgentId, [StartDateTime], [EndDateTime], [Memo]) 
		SELECT DocumentId + @DocumentOffset, LineNumber, ResponsibleAgentId, [StartDateTime], [EndDateTime], [Memo] 
		FROM @Lines
		WHERE Status = N'Inserted';

		DELETE FROM E
		FROM dbo.Entries E 
		JOIN @Entries EL ON E.DocumentId = EL.DocumentId AND E.LineNumber = EL.LineNumber AND E.EntryNumber = EL.EntryNumber
		WHERE EL.Status = N'Deleted';

		INSERT INTO dbo.Entries(DocumentId, LineNumber,	[EntryNumber], [DocumentId], [Reference], [AccountId], [CustodyId], [ResourceId], 
				[Direction], [Amount], [Value], [NoteId], [RelatedReference], [RelatedAgentId], [RelatedResourceId], [RelatedAmount]	)
		SELECT	DocumentId + @DocumentOffset, LineNumber, [EntryNumber], [DocumentId], [Reference], [AccountId], [CustodyId], [ResourceId],
				[Direction], [Amount], [Value], [NoteId], [RelatedReference], [RelatedAgentId], [RelatedResourceId], [RelatedAmount]	
		FROM @Entries;
		*/
	COMMIT TRANSACTION;
END TRY

BEGIN CATCH
	EXEC dbo.Error__Log;
	THROW;
END CATCH

SELECT D.[Id], D.[State], D.[TransactionType], D.[SerialNumber], D.[Mode], D.[FolderId], 
		D.[LinesMemo], D.[LinesResponsibleAgentId],	D.[LinesStartDateTime], D.[LinesEndDateTime], 
		D.[LinesCustody1], D.[LinesCustody2], D.[LinesCustody3], D.[LinesReference1], D.[LinesReference2], D.[LinesReference3], 
		D.[ForwardedToUserId],
		N'Unchanged' As [Status], M.[OldId] As [TemporaryId]
FROM dbo.Documents D
LEFT JOIN @IdMappings M ON D.[Id] = M.[NewId]
WHERE D.[TenantId] = @TenantId
AND D.[Id] IN (
	SELECT M.[NewId] FROM @Documents D JOIN @IdMappings M ON D.Id = M.OldId WHERE [Status] = N'Inserted'
	UNION ALL
	SELECT Id FROM @Documents WHERE [Status] = N'Updated'
	);
END