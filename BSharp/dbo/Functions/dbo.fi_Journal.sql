CREATE FUNCTION [dbo].[fi_Journal] (-- SELECT * FROM [dbo].[fi_Journal]('01.01.2015','01.01.2020')
	@fromDate Datetime = '2000.01.01', 
	@toDate Datetime = '2100.01.01'
) RETURNS TABLE
AS
RETURN
	WITH
	IntegerList AS ( -- can be defined recursively, or simply read from a table
		SELECT 0 As I UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION
		SELECT 5 As I UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9
	)
	SELECT
		[DocumentId],
		[DocumentType],
		[SerialNumber],
		[AssigneeId],
		CONVERT(NVARCHAR(255), [StartDateTime], 102) AS DocumentDateTime,
		[EntryId],
		[LineType],
		[Direction],
		[AccountId],
		[IFRSAccountId],
		[ResponsibilityCenterId],
		[OperationId],
		[ProductCategoryId],
		[GeographicRegionId],
		[CustomerSegmentId],
		[TaxSegmentId],
		[AgentAccountId],
		[ResourceId],
		[MoneyAmount],
		[Mass], [NormalizedMass],
		[Volume], [NormalizedVolume],
		[Count],
		[Time],
		[Value],
		[IFRSNoteId],
		[Reference],
		[Memo],
		[ExpectedSettlingDate],
		[RelatedResourceId],
		[RelatedReference],
		[RelatedAgentAccountId],
		[RelatedMoneyAmount]
	FROM dbo.[NormalizedVouchersView]
	WHERE Frequency		= N'OneTime'
	AND (@fromDate IS NULL OR StartDateTime >= @fromDate)
	AND (@toDate IS NULL OR StartDateTime < @toDate)

	UNION ALL
	SELECT 
		[DocumentId],
		[DocumentType],
		[SerialNumber],
		[AssigneeId],
		CONVERT(NVARCHAR(255), [StartDateTime], 102) AS DocumentDateTime,
		[EntryId],
		[LineType],
		[Direction],
		[AccountId],
		[IFRSAccountId],
		[ResponsibilityCenterId],
		[OperationId],
		[ProductCategoryId],
		[GeographicRegionId],
		[CustomerSegmentId],
		[TaxSegmentId],
		[AgentAccountId],
		[ResourceId],
		[MoneyAmount],
		[Mass], [NormalizedMass],
		[Volume], [NormalizedVolume],
		[Count],
		[Time],
		[Value],
		[IFRSNoteId],
		[Reference],
		[Memo],
		[ExpectedSettlingDate],
		[RelatedResourceId],
		[RelatedReference],
		[RelatedAgentAccountId],
		[RelatedMoneyAmount]
	FROM dbo.[NormalizedVouchersView] 
	CROSS JOIN IntegerList IL
	WHERE Frequency		= N'Daily'
	AND (@fromDate IS NULL OR StartDateTime >= @fromDate)
	AND (@toDate IS NULL OR DATEADD(DAY, IL.I, [StartDateTime]) < @toDate)
	AND ([EndDateTime] IS NULL OR DATEADD(DAY, IL.I, [StartDateTime]) < [EndDateTime])
	
	UNION ALL
	SELECT 
		[DocumentId],
		[DocumentType],
		[SerialNumber],
		[AssigneeId],
		CONVERT(NVARCHAR(255), [StartDateTime], 102) AS DocumentDateTime,
		[EntryId],
		[LineType],
		[Direction],
		[AccountId],
		[IFRSAccountId],
		[ResponsibilityCenterId],
		[OperationId],
		[ProductCategoryId],
		[GeographicRegionId],
		[CustomerSegmentId],
		[TaxSegmentId],
		[AgentAccountId],
		[ResourceId],
		[MoneyAmount],
		[Mass], [NormalizedMass],
		[Volume], [NormalizedVolume],
		[Count],
		[Time],
		[Value],
		[IFRSNoteId],
		[Reference],
		[Memo],
		[ExpectedSettlingDate],
		[RelatedResourceId],
		[RelatedReference],
		[RelatedAgentAccountId],
		[RelatedMoneyAmount]
	FROM dbo.[NormalizedVouchersView] 
	CROSS JOIN IntegerList IL
	WHERE Frequency		= N'Weekly'
	AND (@fromDate IS NULL OR StartDateTime >= @fromDate)
	AND (@toDate IS NULL OR DATEADD(WEEK, IL.I, [StartDateTime]) < @toDate)
	AND ([EndDateTime] IS NULL OR DATEADD(WEEK, IL.I, [StartDateTime]) < [EndDateTime])

	UNION ALL
	SELECT 
		[DocumentId],
		[DocumentType],
		[SerialNumber],
		[AssigneeId],
		CONVERT(NVARCHAR(255), [StartDateTime], 102) AS DocumentDateTime,
		[EntryId],
		[LineType],
		[Direction],
		[AccountId],
		[IFRSAccountId],
		[ResponsibilityCenterId],
		[OperationId],
		[ProductCategoryId],
		[GeographicRegionId],
		[CustomerSegmentId],
		[TaxSegmentId],
		[AgentAccountId],
		[ResourceId],
		[MoneyAmount],
		[Mass], [NormalizedMass],
		[Volume], [NormalizedVolume],
		[Count],
		[Time],
		[Value],
		[IFRSNoteId],
		[Reference],
		[Memo],
		[ExpectedSettlingDate],
		[RelatedResourceId],
		[RelatedReference],
		[RelatedAgentAccountId],
		[RelatedMoneyAmount]
	FROM dbo.[NormalizedVouchersView] 
	CROSS JOIN IntegerList IL
	WHERE Frequency		= N'Monthly'
	AND (@fromDate IS NULL OR StartDateTime >= @fromDate)
	AND (@toDate IS NULL OR DATEADD(MONTH, IL.I, [StartDateTime]) < @toDate)
	AND ([EndDateTime] IS NULL OR DATEADD(MONTH, IL.I, [StartDateTime]) < [EndDateTime])
	
	UNION ALL
	SELECT 
		[DocumentId],
		[DocumentType],
		[SerialNumber],
		[AssigneeId],
		CONVERT(NVARCHAR(255), [StartDateTime], 102) AS DocumentDateTime,
		[EntryId],
		[LineType],
		[Direction],
		[AccountId],
		[IFRSAccountId],
		[ResponsibilityCenterId],
		[OperationId],
		[ProductCategoryId],
		[GeographicRegionId],
		[CustomerSegmentId],
		[TaxSegmentId],
		[AgentAccountId],
		[ResourceId],
		[MoneyAmount],
		[Mass], [NormalizedMass],
		[Volume], [NormalizedVolume],
		[Count],
		[Time],
		[Value],
		[IFRSNoteId],
		[Reference],
		[Memo],
		[ExpectedSettlingDate],
		[RelatedResourceId],
		[RelatedReference],
		[RelatedAgentAccountId],
		[RelatedMoneyAmount]
	FROM dbo.[NormalizedVouchersView] 
	CROSS JOIN IntegerList IL
	WHERE Frequency		= N'Quarterly'
	AND (@fromDate IS NULL OR StartDateTime >= @fromDate)
	AND (@toDate IS NULL OR DATEADD(QUARTER, IL.I, [StartDateTime]) < @toDate)
	AND ([EndDateTime] IS NULL OR DATEADD(QUARTER, IL.I, [StartDateTime]) < [EndDateTime])

	UNION ALL
	SELECT 
		[DocumentId],
		[DocumentType],
		[SerialNumber],
		[AssigneeId],
		CONVERT(NVARCHAR(255), [StartDateTime], 102) AS DocumentDateTime,
		[EntryId],
		[LineType],
		[Direction],
		[AccountId],
		[IFRSAccountId],
		[ResponsibilityCenterId],
		[OperationId],
		[ProductCategoryId],
		[GeographicRegionId],
		[CustomerSegmentId],
		[TaxSegmentId],
		[AgentAccountId],
		[ResourceId],
		[MoneyAmount],
		[Mass], [NormalizedMass],
		[Volume], [NormalizedVolume],
		[Count],
		[Time],
		[Value],
		[IFRSNoteId],
		[Reference],
		[Memo],
		[ExpectedSettlingDate],
		[RelatedResourceId],
		[RelatedReference],
		[RelatedAgentAccountId],
		[RelatedMoneyAmount]
	FROM dbo.[NormalizedVouchersView] 
	CROSS JOIN IntegerList IL
	WHERE Frequency		= N'Yearly'
	AND (@fromDate IS NULL OR StartDateTime >= @fromDate)
	AND (@toDate IS NULL OR DATEADD(YEAR, IL.I, [StartDateTime]) < @toDate)
	AND ([EndDateTime] IS NULL OR DATEADD(YEAR, IL.I, [StartDateTime]) < [EndDateTime])
	;