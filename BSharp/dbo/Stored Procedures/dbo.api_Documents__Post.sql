
CREATE PROCEDURE [dbo].[api_Documents__Post]
	@Documents DocumentList READONLY
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @ValidationErrors ValidationErrorList;

	-- if all documents are already posted, return
	IF NOT EXISTS(SELECT * FROM dbo.Documents WHERE Id IN (SELECT Id FROM @Documents) AND Mode <> N'Posted')
		RETURN;

	BEGIN TRY
		-- Only leaf accounts are allowed
		IF EXISTS(
			SELECT *
			FROM dbo.Entries E
			JOIN dbo.Lines L ON E.DocumentId = L.DocumentId AND E.LineNumber = L.LineNumber
			JOIN dbo.Accounts A
			ON E.AccountId = A.Id 
			WHERE L.DocumentId IN (SELECT Id FROM @Documents) 
			AND A.IsExtensible = 0 -- non leaf is found
		)
		BEGIN
			INSERT INTO @ValidationErrors(DocumentId, LineNumber, EntryNumber, PropertyName, Message1, Message2)
			SELECT L.DocumentId, L.LineNumber, E.EntryNumber, N'AccountId', A.Name + N'is not a leaf account', N'هذا حساب إجمالي لا ينفع للقيود'
			FROM dbo.Entries E
			JOIN dbo.Lines L ON E.DocumentId = L.DocumentId AND E.LineNumber = L.LineNumber
			JOIN dbo.Accounts A
			ON E.AccountId = A.Id 
			WHERE L.DocumentId IN (SELECT Id FROM @Documents) 
			AND A.IsExtensible = 0;
		END
		/*
		-- If resource = functional currency, then amount = value
		DECLARE @InconsistentEntry int, @Amount money, @Value money;
		SELECT @InconsistentEntry = E.Id, @Amount = E.Amount, @Value = E.Value
		FROM dbo.Entries E
		JOIN dbo.Lines L ON E.DocumentId = L.DocumentId AND E.LineNumber = L.LineNumber
		JOIN dbo.Resources R ON E.ResourceId = R.Id
		WHERE L.DocumentId = @DocumentId
		AND R.ResourceType = N'Cash' 
		AND R.UnitOfMeasure = dbo.fn_Settings(N'FunctionalCurrency')
		AND E.Amount <> E.Value		
		IF @InconsistentEntry IS NOT NULL
		BEGIN
			DECLARE @errMessage nvarchar(255) = N'Cash Entry # ' + CAST(@InconsistentEntry AS nvarchar(10)) + N' has amount = ' + CAST(@Amount AS nvarchar(10)) + N' and value = ' + CAST(@Value as nvarchar(10))
			RAISERROR(@errMessage, 16, 1)
		END
		*/

		-- Total debit must be total credit for each line
		IF EXISTS(
			SELECT *
			FROM dbo.Entries E
			JOIN dbo.Lines L ON E.DocumentId = L.DocumentId AND E.LineNumber = L.LineNumber
			WHERE L.DocumentId IN (SELECT Id FROM @Documents)
			GROUP BY L.DocumentId, L.LineNumber
			HAVING SUM(E.Value * E.Direction) <> 0
		)
		BEGIN
			INSERT INTO @ValidationErrors(DocumentId, LineNumber, EntryNumber, PropertyName, Message1, Message2)
			SELECT						L.DocumentId, L.LineNumber, NULL,		NULL,
				 N'Line ' + CAST(L.LineNumber AS Nvarchar(50)) + N' Total Credit and Total Debit are off by ' + 
					CAST(SUM(E.Value * E.Direction) AS varchar(50)), N'هناك فارق بين جملة المدين وجملة الدائن'
			FROM dbo.Entries E
			JOIN dbo.Lines L ON E.DocumentId = L.DocumentId AND E.LineNumber = L.LineNumber
			WHERE L.DocumentId IN (SELECT Id FROM @Documents)
			GROUP BY L.DocumentId, L.LineNumber
			HAVING SUM(E.Value * E.Direction) <> 0
		END
		IF EXISTS(SELECT * FROM @ValidationErrors)
		BEGIN
			DECLARE @Massage nvarchar(max) = dbo.ft_ValidationErrors(@ValidationErrors);
			RAISERROR(@Massage, 16, 1)
		END
		ELSE
			UPDATE dbo.Documents
			SET Mode = N'Posted'
			WHERE Id IN (SELECT Id FROM @Documents);
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
