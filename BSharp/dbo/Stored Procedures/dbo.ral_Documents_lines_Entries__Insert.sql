
CREATE PROCEDURE [dbo].[ral_Documents_Lines_Entries__Insert]
@Documents DocumentList READONLY,
@Lines LineList READONLY,
@Entries EntryList READONLY,
@DocumentOffset int = 0 OUTPUT
AS
BEGIN TRY
	--SELECT * FROM @Documents;
	--SELECT * FROM @Lines;
	--SELECT * FROM @Entries;

	BEGIN TRANSACTION
		DELETE FROM dbo.Documents
		WHERE Id IN (SELECT Id FROM @Documents WHERE Status = N'Deleted');

		UPDATE D
		SET 
			D.FolderId = DL.FolderId,
			D.LinesMemo = DL.LinesMemo,
			D.LinesResponsibleAgentId = DL.LinesResponsibleAgentId,
			D.LinesStartDateTime = DL.LinesStartDateTime,
			D.LinesEndDateTime = DL.LinesEndDateTime,
			D.LinesCustody1 = DL.LinesCustody1,
			D.LinesCustody2 = DL.LinesCustody2,
			D.LinesCustody3 = DL.LinesCustody3,
			D.LinesReference1 = DL.LinesReference1,
			D.LinesReference2 = DL.LinesReference2,
			D.LinesReference3 = DL.LinesReference3,
			D.ForwardedToUserId = DL.ForwardedToUserId
		FROM dbo.Documents D 
		JOIN @Documents DL ON D.Id = DL.Id
		WHERE DL.Status = N'Updated'

		SELECT @DocumentOffset = ISNULL(MAX(Id), 0) FROM dbo.Documents;
		INSERT INTO dbo.Documents([Id], [State], [TransactionType], [SerialNumber], [Mode], [FolderId], [LinesMemo], [LinesResponsibleAgentId],
									[LinesStartDateTime], [LinesEndDateTime], [LinesCustody1], [LinesCustody2], [LinesCustody3], 
									[LinesReference1], [LinesReference2], [LinesReference3], [ForwardedToUserId])
		SELECT Id + @DocumentOffset, [State], [TransactionType], [SerialNumber], [Mode], [FolderId], [LinesMemo], [LinesResponsibleAgentId],
									[LinesStartDateTime], [LinesEndDateTime], [LinesCustody1], [LinesCustody2], [LinesCustody3], 
									[LinesReference1], [LinesReference2], [LinesReference3], [ForwardedToUserId]
		FROM @Documents
		WHERE Status = N'Inserted';

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

		INSERT INTO dbo.Entries(DocumentId, LineNumber,	[EntryNumber], [OperationId], [Reference], [AccountId], [CustodyId], [ResourceId], 
				[Direction], [Amount], [Value], [NoteId], [RelatedReference], [RelatedAgentId], [RelatedResourceId], [RelatedAmount]	)
		SELECT	DocumentId + @DocumentOffset, LineNumber, [EntryNumber], [OperationId], [Reference], [AccountId], [CustodyId], [ResourceId],
				[Direction], [Amount], [Value], [NoteId], [RelatedReference], [RelatedAgentId], [RelatedResourceId], [RelatedAmount]	
		FROM @Entries;
END TRY

BEGIN CATCH
	SELECT   /*
    ERROR_NUMBER() AS ErrorNumber  
    ,ERROR_SEVERITY() AS ErrorSeverity  
    ,ERROR_STATE() AS ErrorState  
    , */ERROR_PROCEDURE() AS ErrorProcedure  
    ,ERROR_LINE() AS ErrorLine  
    ,ERROR_MESSAGE() AS ErrorMessage; 

	IF @@TRANCOUNT > 0 
    ROLLBACK TRANSACTION;
END CATCH

IF @@TRANCOUNT > 0  
COMMIT TRANSACTION; 
