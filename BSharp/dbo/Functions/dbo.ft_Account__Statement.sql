CREATE FUNCTION [dbo].[ft_Account__Statement] (-- SELECT * FROM [dbo].[ft_Account__Statement](N'CashOnHand', '01.01.2015', '01.01.2020')
	@Account nvarchar(255),
	@CustodyId int = 0,
	@ResourceId int = 0,
	@fromDate Datetime = '01.01.2000', 
	@toDate Datetime = '01.01.2100'
) RETURNS TABLE
AS
	RETURN
	SELECT 	
		Id,
		[DocumentType],
		SerialNumber As [Serial Number],
		--ResponsibleAgentId,
		--ForwardedToAgentId,
		StartDateTime,
		EndDateTime,
		Memo,
		OperationId,
		Reference,
		CustodyId,
		ResourceId,
		Direction,
		Amount,
		(CASE WHEN Direction > 0 THEN [Value] ELSE 0 END) AS Debit,
		(CASE WHEN Direction < 0 THEN [Value] ELSE 0 END) AS Credit,
		NoteId AS Note,
		RelatedReference,
		RelatedAgentId,
		RelatedResourceId,
		RelatedAmount
	FROM [dbo].ft_Journal(@fromDate, @toDate)
	WHERE AccountId = @Account
	AND (@CustodyId = 0 OR CustodyId = @CustodyId)
	AND (@ResourceId = 0 OR ResourceId = @ResourceId);