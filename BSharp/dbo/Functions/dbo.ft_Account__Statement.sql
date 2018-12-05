
CREATE FUNCTION [dbo].[ft_Account__Statement] (-- SELECT * FROM [dbo].[ft_Account__Statement](N'CashOnHand', '01.01.2015', '01.01.2020')
	@Account nvarchar(255),
	@fromDate Datetime = '01.01.2000', 
	@toDate Datetime = '01.01.2100'
) RETURNS TABLE AS
RETURN
(
	SELECT 	
		Id,
		[TransactionType],
		SerialNumber As [Serial Number],
		ResponsibleAgentId,
		StartDateTime,
		EndDateTime,
		Memo,
		CoveringRatio,
		OperationId,
		Reference,
		CustodyId,
		ResourceId,
		Direction,
		[CoveringRatio] * Amount AS Amount,
		(CASE WHEN Direction > 0 THEN [CoveringRatio] * [Value] ELSE 0 END) AS Debit,
		(CASE WHEN Direction < 0 THEN [CoveringRatio] * [Value] ELSE 0 END) AS Credit,
		NoteId AS Note,
		RelatedReference,
		RelatedAgentId,
		RelatedResourceId,
		RelatedAmount
	FROM [dbo].ft_Journal(@fromDate, @toDate)
	WHERE AccountId = @Account
)
