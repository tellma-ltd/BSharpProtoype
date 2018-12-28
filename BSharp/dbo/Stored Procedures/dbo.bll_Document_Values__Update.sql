CREATE Procedure [dbo].[bll_Document_Values__Update] -- OBSOLETE?!?!
@WideLines WideLineList READONLY,
@Entries EntryList READONLY
AS
DECLARE @EntryNumber tinyint, @EntriesCount tinyint, @ValueCalculation nvarchar(255), @LineType NVARCHAR(255), @AccountId nvarchar(255), @Direction smallint,
	@LineOffset int, @EntriesCopy EntryList;
SET NOCOUNT ON

INSERT INTO @EntriesCopy 
SELECT * FROM @Entries;

SELECT @LineType = MIN(LineType) FROM @WideLines
WHILE @LineType IS NOT NULL
BEGIN
	SELECT @EntryNumber = 1, @EntriesCount = COUNT(*) FROM [dbo].[LineTypeCalculationsView] WHERE [LineType] = @LineType;
	WHILE @EntryNumber <= @EntriesCount
	BEGIN
		-- Determine value of resource issue or receipt from an available invoice (event) or contract (order)
		SELECT	@ValueCalculation = [Value] FROM [dbo].[LineTypeCalculationsView] WHERE [LineType] = @LineType AND EntryNumber = @EntryNumber
		IF LEFT(@ValueCalculation, 6) = N'@BULK:'
		BEGIN
			SET @ValueCalculation = REPLACE(@ValueCalculation, N'@Bulk:', N'SELECT ');
			EXEC [dbo].sp_executesql @statement = @ValueCalculation, @params = N'@AccountId nvarchar(255) OUTPUT, @Direction smallint OUTPUT', @AccountId = @AccountId OUTPUT, @Direction = @Direction OUTPUT
		--	@AccountId = N'GoodsAndServicesReceivedFromSupplierButNotBilled', @Direction = 1;
		--	@AccountId = N'ShorttermEmployeeBenefitsAccruals', @Direction = 1; 
		--	@AccountId = N'RentAccruedIncome', @Direction = 1; 
		--	@AccountId = N'GoodsAndServicesDeliveredToCustomerButNotBilled', @Direction = -1;
		--	@AccountId = N'RentAccrualClassifiedAsCurrent', @Direction = -1; 
			UPDATE E1
			SET E1.Value = E1.Amount * E2.Rate
			FROM @EntriesCopy E1
			JOIN (
				SELECT E.ResourceId, E.CustodyId, CAST(SUM(E.Value) AS float)/SUM(E.Amount) AS Rate
				FROM [dbo].Entries E 
				JOIN [dbo].[Lines] L ON E.LineId = L.Id
				JOIN [dbo].[Documents] D ON D.Id = L.DocumentId
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
	SET @LineType = (SELECT MIN(LineType) FROM @WideLines WHERE LineType > @LineType);
END
SELECT * FROM @EntriesCopy;
