
CREATE PROCEDURE [dbo].[sbs_Document__Update] 
-- Does not handle delete event lines from an event group yet. It assumes only insertion/update.
	@Document int,
	@LLinesReference1 nvarchar(50) = NULL,
	@Custody int = NULL, 
	@Location int = NULL,
	@Resource int = NULL,
	@String1 nvarchar(255) = NULL
	/*
	@Reason	nvarchar(50) = NULL,
	@StateDateTime	datetimeoffset(7),
	@Actor	int,
	@InvestmentCenter int = NULL,
	@ResponsibilityAgent int = NULL, 
	@ResponsibilityLocation int = NULL,
	@ReminderDateTime datetimeoffset(7) = Null,
	*/
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		IF (SELECT Mode FROM dbo.Documents WHERE Id = @Document) = N'Committed'
			RAISERROR( N'The document is committed. Set it in draft mode before editing it.', 16, 1)
		
		UPDATE dbo.Documents
		SET LinesReference1 = @LLinesReference1

		WHERE Id = @Document		
	END TRY

	BEGIN CATCH
	    SELECT   /*
        ERROR_NUMBER() AS ErrorNumber  
        ,ERROR_SEVERITY() AS ErrorSeverity  
        ,ERROR_STATE() AS ErrorState  
        , */ERROR_PROCEDURE() AS ErrorProcedure  
        ,ERROR_LINE() AS ErrorLine  
        ,ERROR_MESSAGE() AS ErrorMessage; 
	END CATCH
END
