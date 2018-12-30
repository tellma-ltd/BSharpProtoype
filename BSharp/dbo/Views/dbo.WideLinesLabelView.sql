CREATE VIEW [dbo].[WideLinesLabelView]  
AS
SELECT [LineType], 
	MAX(CASE WHEN EntryNumber = 1 THEN [OperationExpression] ELSE NULL END) AS Operation1,
	MAX(CASE WHEN EntryNumber = 1 THEN [AccountExpression] ELSE NULL END) AS Account1,
	MAX(CASE WHEN EntryNumber = 1 THEN [CustodyExpression] ELSE NULL END) AS Custody1,
	MAX(CASE WHEN EntryNumber = 1 THEN [ResourceExpression] ELSE NULL END) AS Resource1,
	MAX(CASE WHEN EntryNumber = 1 THEN [DirectionExpression] ELSE NULL END) AS Direction1,
	MAX(CASE WHEN EntryNumber = 1 THEN [AmountExpression] ELSE NULL END) AS Amount1,
	MAX(CASE WHEN EntryNumber = 1 THEN [ValueExpression] ELSE NULL END) AS Value1,
	MAX(CASE WHEN EntryNumber = 1 THEN [NoteExpression] ELSE NULL END) AS Note1,
	MAX(CASE WHEN EntryNumber = 1 THEN [RelatedReferenceExpression] ELSE NULL END) AS RelatedReference1,
	MAX(CASE WHEN EntryNumber = 1 THEN [RelatedAgentExpression] ELSE NULL END) AS RelatedAgent1,
	MAX(CASE WHEN EntryNumber = 1 THEN [RelatedResourceExpression] ELSE NULL END) AS RelatedResource1,
	MAX(CASE WHEN EntryNumber = 1 THEN [RelatedAmountExpression] ELSE NULL END) AS RelatedAmount1,

	MAX(CASE WHEN EntryNumber = 2 THEN [OperationExpression] ELSE NULL END) AS Operation2,
	MAX(CASE WHEN EntryNumber = 2 THEN [AccountExpression] ELSE NULL END) AS Account2,
	MAX(CASE WHEN EntryNumber = 2 THEN [CustodyExpression] ELSE NULL END) AS Custody2,
	MAX(CASE WHEN EntryNumber = 2 THEN [ResourceExpression] ELSE NULL END) AS Resource2,
	MAX(CASE WHEN EntryNumber = 2 THEN [DirectionExpression] ELSE NULL END) AS Direction2,
	MAX(CASE WHEN EntryNumber = 2 THEN [AmountExpression] ELSE NULL END) AS Amount2,
	MAX(CASE WHEN EntryNumber = 2 THEN [ValueExpression] ELSE NULL END) AS Value2,
	MAX(CASE WHEN EntryNumber = 2 THEN [NoteExpression] ELSE NULL END) AS Note2,
	MAX(CASE WHEN EntryNumber = 2 THEN [RelatedReferenceExpression] ELSE NULL END) AS RelatedReference2,
	MAX(CASE WHEN EntryNumber = 2 THEN [RelatedAgentExpression] ELSE NULL END) AS RelatedAgent2,
	MAX(CASE WHEN EntryNumber = 2 THEN [RelatedResourceExpression] ELSE NULL END) AS RelatedResource2,
	MAX(CASE WHEN EntryNumber = 2 THEN [RelatedAmountExpression] ELSE NULL END) AS RelatedAmount2,

	MAX(CASE WHEN EntryNumber = 3 THEN [OperationExpression] ELSE NULL END) AS Operation3,
	MAX(CASE WHEN EntryNumber = 3 THEN [AccountExpression] ELSE NULL END) AS Account3,
	MAX(CASE WHEN EntryNumber = 3 THEN [CustodyExpression] ELSE NULL END) AS Custody3,
	MAX(CASE WHEN EntryNumber = 3 THEN [ResourceExpression] ELSE NULL END) AS Resource3,
	MAX(CASE WHEN EntryNumber = 3 THEN [DirectionExpression] ELSE NULL END) AS Direction3,
	MAX(CASE WHEN EntryNumber = 3 THEN [AmountExpression] ELSE NULL END) AS Amount3,
	MAX(CASE WHEN EntryNumber = 3 THEN [ValueExpression] ELSE NULL END) AS Value3,
	MAX(CASE WHEN EntryNumber = 3 THEN [NoteExpression] ELSE NULL END) AS Note3,
	MAX(CASE WHEN EntryNumber = 3 THEN [RelatedReferenceExpression] ELSE NULL END) AS RelatedReference3,
	MAX(CASE WHEN EntryNumber = 3 THEN [RelatedAgentExpression] ELSE NULL END) AS RelatedAgent3,
	MAX(CASE WHEN EntryNumber = 3 THEN [RelatedResourceExpression] ELSE NULL END) AS RelatedResource3,
	MAX(CASE WHEN EntryNumber = 3 THEN [RelatedAmountExpression] ELSE NULL END) AS RelatedAmount3
FROM [dbo].[LineTypeSpecifications] 
WHERE Definition = N'Label'
GROUP BY [LineType];
