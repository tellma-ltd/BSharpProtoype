CREATE PROCEDURE [dbo].[rpt_BankAccount__Statement]
-- EXEC [dbo].[rpt_BankAccount__Statement](104, '01.01.2015', '01.01.2020')
	@AccountId INT,
	@fromDate Datetime = '01.01.2000', 
	@toDate Datetime = '01.01.2100'
AS
BEGIN
	SELECT 	
		[Id],
		[TransactionLineId],
		[DocumentDate],
		[DocumentType],
		[SerialNumber],
		[Direction],
		[IfrsNoteId],
		[ResponsibilityCenterId],
		[MoneyAmount],
		[Value],
		[VoucherReference] As [CPV_CRV_Ref],
		[Memo],
		[ExternalReference] As [CheckRef],
		[RelatedResourceId] As [OtherPartyCurrency],
		[RelatedAgentId] As [OtherParty],
		[RelatedMoneyAmount] As [OtherPartyAmount]
	FROM [dbo].[fi_JournalDetails](@fromDate, @toDate)
	WHERE [AccountId] = @AccountId;
END;
GO;