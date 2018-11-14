CREATE PROCEDURE [dbo].[api_Documents__Post]
	@Documents DocumentList READONLY
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @ValidationErrors ValidationErrorList;

	-- if all documents are already posted, return
	IF NOT EXISTS(SELECT * FROM dbo.Documents 
		WHERE TenantId = dbo.fn_TenantId() 
		AND Id IN (SELECT Id FROM @Documents) AND Mode <> N'Posted')
		RETURN;

	-- if some documents do not have entries, error
	IF EXISTS(
		SELECT * FROM @Documents 
		WHERE [Id] NOT IN (
			SELECT L.DocumentId 
			FROM dbo.Lines L
			JOIN dbo.Entries E ON L.TenantId = E.TenantId AND L.Id = E.LineId
			WHERE L.TenantId = dbo.fn_TenantId()
		)
	)
	BEGIN
		INSERT INTO @ValidationErrors([Path], ErrorMessage)
		SELECT 	N'Documents['+ CONVERT(nvarchar(50), Id) + ']',
			FORMATMESSAGE(dbo.fn_Translate(N'DocumentHasNoEntries'))
		FROM @Documents 
		WHERE [Id] NOT IN (
			SELECT L.DocumentId 
			FROM dbo.Lines L
			JOIN dbo.Entries E ON L.TenantId = E.TenantId AND L.Id = E.LineId
			WHERE L.TenantId = dbo.fn_TenantId())
	END;

	-- Only leaf accounts are allowed
	IF EXISTS(
		SELECT *
		FROM dbo.Entries E
		JOIN dbo.Lines L ON E.TenantId = L.TenantId AND E.LineId = L.Id
		JOIN dbo.Accounts A
		ON E.AccountId = A.Id 
		WHERE E.TenantId = dbo.fn_TenantId() AND L.DocumentId IN (SELECT Id FROM @Documents) 
		AND A.IsExtensible = 0 -- non leaf is found
	)
	BEGIN
		INSERT INTO @ValidationErrors([Path], ErrorMessage)
		SELECT 
			N'Documents[' + CONVERT(nvarchar(50), L.DocumentId) + '].Lines[' + CONVERT(nvarchar(50), L.Id) + '].Entries[' + CONVERT(nvarchar(50), E.Id) + '].Account',
			FORMATMESSAGE(dbo.fn_Translate(N'AccountIsNotLeaf'))
		FROM dbo.Entries E
		JOIN dbo.Lines L ON E.TenantId = L.TenantId AND E.LineId = L.Id
		JOIN dbo.Accounts A
		ON E.AccountId = A.Id 
		WHERE E.TenantId = dbo.fn_TenantId() AND L.DocumentId IN (SELECT Id FROM @Documents) 
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
		JOIN dbo.Lines L ON E.TenantId = L.TenantId AND E.LineId = L.Id
		WHERE E.TenantId = dbo.fn_TenantId() AND L.DocumentId IN (SELECT Id FROM @Documents)
		GROUP BY L.Id
		HAVING SUM(E.Value * E.Direction) <> 0
	)
	BEGIN
		INSERT INTO @ValidationErrors([Path], ErrorMessage)
		SELECT
				N'Documents[' + CONVERT(nvarchar(50), L.DocumentId) + '].Lines[' + CONVERT(nvarchar(50), L.Id) + ']',
				FORMATMESSAGE(dbo.fn_Translate('LineIsNotBalanced'), CONVERT(nvarchar(50), SUM(E.[Value] * E.[Direction])))
				--CAST(SUM(E.Value * E.Direction) AS varchar(50)), N'هناك فارق بين جملة المدين وجملة الدائن'
		FROM dbo.Entries E
		JOIN dbo.Lines L ON E.TenantId = L.TenantId AND E.LineId = L.Id
		WHERE E.TenantId = dbo.fn_TenantId() AND L.DocumentId IN (SELECT Id FROM @Documents)
		GROUP BY L.DocumentId, L.Id
		HAVING SUM(E.[Value] * E.[Direction]) <> 0;
	END;
	IF EXISTS(SELECT * FROM @ValidationErrors)
	BEGIN
		DECLARE @errorMessage nvarchar(2048);
		SELECT @errorMessage = STRING_AGG([Path] + N', ' + ErrorMessage, ';') From @ValidationErrors;
		THROW 99999, @errorMessage, 1
	END
	ELSE
		UPDATE dbo.Documents
		SET Mode = N'Posted'
		WHERE Id IN (SELECT Id FROM @Documents);
END;
