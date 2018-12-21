CREATE PROCEDURE [dbo].[api_Documents__Submit]
	@Documents [dbo].IndexedIdList READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT,
	@ReturnEntities bit = 1,
	@DocumentsResultJson NVARCHAR(MAX) OUTPUT,
	@LinesResultJson NVARCHAR(MAX) OUTPUT,
	@EntriesResultJson NVARCHAR(MAX) OUTPUT
AS
BEGIN
	DECLARE @Ids [dbo].[IntegerList];
	-- if all documents are already submitted, return
	IF NOT EXISTS(SELECT * FROM [dbo].[Documents] 
		WHERE [Id] IN (SELECT [Id] FROM @Documents) AND Mode <> N'Submitted')
		RETURN;

	-- Validate
	EXEC [dbo].[bll_Documents_Submit__Validate]
		@Documents = @Documents,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT;
			
	IF @ValidationErrorsJson IS NOT NULL
		RETURN;

	EXEC [dbo].[dal_Documents_Mode__Update]	@Documents = @Documents, @Mode = N'Submitted';

	IF (@ReturnEntities = 1)
	BEGIN
		INSERT INTO @Ids([Id])
		SELECT [Id] 
		FROM @Documents;

		EXEC [dbo].[dal_Documents_Lines__Select] 
			@Ids = @Ids, 
			@DocumentsResultJson = @DocumentsResultJson OUTPUT,
			@LinesResultJson = @LinesResultJson OUTPUT,
			@EntriesResultJson = @EntriesResultJson OUTPUT
	END
END;
	
	/*
	-- If resource = functional currency, then amount = value
	DECLARE @InconsistentEntry int, @Amount money, @Value money;
	SELECT @InconsistentEntry = E.Id, @Amount = E.Amount, @Value = E.Value
	FROM [dbo].Entries E
	JOIN [dbo].[Lines] L ON E.DocumentId = L.DocumentId AND E.LineNumber = L.LineNumber
	JOIN [dbo].[Resources] R ON E.ResourceId = R.Id
	WHERE L.DocumentId = @DocumentId
	AND R.ResourceType = N'Cash' 
	AND R.UnitOfMeasure = [dbo].fn_Settings(N'FunctionalCurrency')
	AND E.Amount <> E.Value		
	IF @InconsistentEntry IS NOT NULL
	BEGIN
		DECLARE @errMessage nvarchar(255) = N'Cash Entry # ' + CAST(@InconsistentEntry AS NVARCHAR(255)) + N' has amount = ' + CAST(@Amount AS NVARCHAR(255)) + N' and value = ' + CAST(@Value as NVARCHAR(255))
		RAISERROR(@errMessage, 16, 1)
	END
	*/
