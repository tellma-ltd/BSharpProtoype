
CREATE Procedure [dbo].[bdb_Document_Values__Update]
@WideLines WideLineList READONLY,
@Entries EntryList READONLY
AS
DECLARE @EntryNumber tinyint, @EntriesCount tinyint, @ValueCalculation nvarchar(255), @TransactionType nvarchar(50), @AccountId nvarchar(255), @Direction smallint,
	@LineOffset int, @EntriesCopy EntryList;
SET NOCOUNT ON

INSERT INTO @EntriesCopy 
SELECT * FROM @Entries;

SELECT @TransactionType = MIN(TransactionType) FROM @WideLines
WHILE @TransactionType IS NOT NULL
BEGIN
	SELECT @EntryNumber = 1, @EntriesCount = COUNT(*) FROM  dbo.LineTemplatesCalculationView WHERE [TransactionType] = @TransactionType;
	WHILE @EntryNumber <= @EntriesCount
	BEGIN
		-- Determine value of resource issue or receipt from an available invoice (event) or contract (order)
		SELECT	@ValueCalculation = [Value] FROM dbo.LineTemplatesCalculationView WHERE [TransactionType] = @TransactionType AND EntryNumber = @EntryNumber
		IF LEFT(@ValueCalculation, 6) = N'@BULK:'
		BEGIN
			SET @ValueCalculation = REPLACE(@ValueCalculation, N'@Bulk:', N'SELECT ');
			EXEC [dbo].sp_executesql @statement = @ValueCalculation, @params = N'@AccountId nvarchar(255) OUTPUT, @Direction smallint OUTPUT', @AccountId = @AccountId OUTPUT, @Direction = @Direction OUTPUT
		--	@AccountId = N'GoodsAndServicesReceivedFromSupplierButNotBilled', @Direction = 1;
		--	@AccountId  = N'ShorttermEmployeeBenefitsAccruals', @Direction = 1; 
		--	@AccountId  = N'RentAccruedIncome', @Direction = 1; 
		--	@AccountId  = N'GoodsAndServicesDeliveredToCustomerButNotBilled', @Direction = -1;
		--	@AccountId  = N'RentAccrualClassifiedAsCurrent', @Direction = -1; 
			UPDATE E1
			SET E1.Value = E1.Amount * E2.Rate
			FROM @EntriesCopy E1
			JOIN (
				SELECT E.ResourceId, E.CustodyId, CAST(SUM(E.Value) AS float)/SUM(E.Amount) AS Rate
				FROM dbo.Entries E 
				JOIn dbo.Lines L ON L.DocumentId = E.DocumentId AND L.LineNumber = E.LineNumber
				JOIN dbo.Documents D ON D.Id = L.DocumentId
				WHERE E.AccountId = @AccountId AND E.Direction = @Direction
				AND D.Mode = N'Posted'
				GROUP BY E.ResourceId, E.CustodyId
			) E2 -- db data.
				ON E1.CustodyId = E2.CustodyId
				AND E1.ResourceId = E2.ResourceId
			WHERE E1.AccountId = @AccountId AND E1.Direction = -@Direction
		END
		SET @EntryNumber = @EntryNumber + 1;
	END
	SET @TransactionType = (SELECT MIN(TransactionType) FROM @WideLines WHERE TransactionType > @TransactionType);
END
SELECT * FROM @EntriesCopy;
