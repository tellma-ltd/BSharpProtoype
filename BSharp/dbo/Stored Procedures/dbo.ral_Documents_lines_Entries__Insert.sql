
CREATE PROCEDURE [dbo].[ral_Documents_Lines_Entries__Insert]
@Documents DocumentList READONLY,
@Lines LineList READONLY,
@Entries EntryList READONLY
AS
BEGIN TRY
	--SELECT * FROM @Documents;
	--SELECT * FROM @Lines;
	--SELECT * FROM @Entries;
	DECLARE @DocumentOffset int = 0;
	BEGIN TRANSACTION
		SELECT @DocumentOffset = ISNULL(MAX(Id), 0) FROM dbo.Documents;
		INSERT INTO dbo.Documents(Id, [State], [TransactionType], SerialNumber, Mode, RecordedByUserId, RecordedOnDateTime, Reference)
		SELECT Id + @DocumentOffset, [State], TransactionType, SerialNumber, Mode, RecordedByUserId, RecordedOnDateTime, Reference
		FROM @Documents

		INSERT INTO  dbo.Lines(DocumentId, LineNumber, ResponsibleAgentId, [StartDateTime], [EndDateTime], [Memo]) 
		SELECT DocumentId + @DocumentOffset, LineNumber, ResponsibleAgentId, [StartDateTime], [EndDateTime], [Memo] FROM @Lines;

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
