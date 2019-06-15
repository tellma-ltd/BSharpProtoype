CREATE PROCEDURE [dbo].[rpt_Account__Statement]
-- EXEC [dbo].[rpt_Account__Statement](104, '01.01.2015', '01.01.2020')
	@AccountId INT,
	@fromDate Datetime = '01.01.2000', 
	@toDate Datetime = '01.01.2100'
AS
BEGIN
	SELECT 	
		[Id],
		[DocumentId],
		[DocumentDate],
		[DocumentType],
		[SerialNumber],
		[IsSystem],
		[Direction],
		[IfrsNoteId],
		[ResponsibilityCenterId],
		-- [OperationId],
		-- [ProductCategoryId],
		-- [GeographicRegionId],
		-- [CustomerSegmentId],
		-- [TaxSegmentId],
		[ResourceId],
		[Quantity],
		[MoneyAmount],
		[Mass],
		-- NormalizedMass,
		[Volume], 
		-- NormalizedVolume,
		[Count],
		-- NormalizedCount,
		[Time],
		[Value],
		[Memo],
		[ExternalReference],
		[AdditionalReference]
	FROM [dbo].[fi_Journal](@fromDate, @toDate)
	WHERE [AccountId] = @AccountId;
END;
GO