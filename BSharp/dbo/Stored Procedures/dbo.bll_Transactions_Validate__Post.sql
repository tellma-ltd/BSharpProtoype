CREATE PROCEDURE [dbo].[bll_Transactions_Validate__Post]
	@Entities [dbo].[IndexedIdList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT
AS
SET NOCOUNT ON;
	DECLARE @ValidationErrors [dbo].[ValidationErrorList];

	-- Cannot post unless in draft mode
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument0], [Argument1])
	SELECT
		'[' + CAST(FE.[Index] AS NVARCHAR (255)) + '].[DocumentState]',
		N'Error_TheTransaction0IsIn1State',
		BE.[SerialNumber],
		BE.[DocumentState]
	FROM @Entities FE
	JOIN [dbo].[Documents] BE ON FE.[Id] = BE.[Id]
	WHERE (BE.[DocumentState] <> N'Draft');

	-- Cannot post with no lines
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument0])
	SELECT
		'[' + CAST(FE.[Index] AS NVARCHAR (255)) + ']',
		N'Error_TheTransaction0HasNoEntries',
		D.[SerialNumber]
	FROM @Entities FE 
	JOIN dbo.Documents D ON FE.[Id] = D.[Id]
	LEFT JOIN dbo.[TransactionEntries] E ON D.[Id] = E.[DocumentId]
	WHERE (E.DocumentId IS NULL);

	-- Cannot post a non-balanced transaction
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument0], [Argument1])
	SELECT
		'[' + ISNULL(CAST(FE.[Index] AS NVARCHAR (255)),'') + ']', 
		N'Error_Transaction0HasDebitCreditDifference1',
		D.[SerialNumber],
		SUM(E.[Direction] * E.[Value])
	FROM @Entities FE
	JOIN dbo.Documents D ON FE.[Id] = D.[Id]
	JOIN dbo.[TransactionEntries] E ON D.[Id] = E.[DocumentId]
	GROUP BY FE.[Index], D.[SerialNumber]
	HAVING SUM(E.[Direction] * E.[Value]) <> 0;

	-- No inactive account
	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument0])
	SELECT
		'[' + CAST(FE.[Index] AS NVARCHAR (255)) + '].Entries[' +
		CAST(E.[Id] AS NVARCHAR (255)) + '].AccountId',
		N'Error_TheAccountId1IsInactive',
		E.[AccountId]
	FROM @Entities FE
	JOIN dbo.[TransactionEntries] E ON FE.[Id] = E.[DocumentId]
	JOIN dbo.[Accounts] A ON E.AccountId = A.Id
	WHERE (A.IsActive = 0);

	-- No inactive Responsibility Center, AgentAccount, Resource, Related resource, Related Agent Account, Related Responsibility Center
	-- No 

	SELECT @ValidationErrorsJson = (SELECT * FROM @ValidationErrors	FOR JSON PATH);