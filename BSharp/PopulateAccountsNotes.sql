DECLARE @AccountsNotes AS TABLE (
	[AccountId]		NVARCHAR (255)		NOT NULL,
	[NoteId]		NVARCHAR (255)		NOT NULL,
	[Direction]		SMALLINT			NOT NULL,
  PRIMARY KEY ([AccountId] ASC, [NoteId] ASC, [Direction] ASC)
);
INSERT INTO @AccountsNotes([AccountId], [NoteId], [Direction])
SELECT A.[Id] As AccountId, N.[Id] AS [NoteId], N.Direction
FROM (
	SELECT [Code], [Id]
	FROM dbo.[Accounts]
	WHERE IsExtensible = 1
) A	CROSS JOIN (
	SELECT [Code], [Id], [Direction] FROM dbo.[Notes]
	WHERE Direction <> 0 AND IsExtensible = 1
	UNION
	SELECT [Code], [Id], 1 FROM dbo.[Notes]
	WHERE Direction = 0 AND IsExtensible = 1
	UNION
	SELECT [Code], [Id], -1 FROM dbo.[Notes]
	WHERE Direction = 0 AND IsExtensible = 1
) N
WHERE (
	(A.Code LIKE dbo.fn_Account__Code(N'PropertyPlantAndEquipment') +'%' AND N.Code LIKE dbo.fn_Note__Code(N'PropertyPlantAndEquipment') + '%') OR
	(A.Code LIKE dbo.fn_Account__Code(N'InvestmentProperty') +'%' AND N.Code LIKE dbo.fn_Note__Code(N'InvestmentProperty') + '%') OR
	(A.Code LIKE dbo.fn_Account__Code(N'Goodwill') +'%' AND N.Code LIKE dbo.fn_Note__Code(N'Goodwill') + '%') OR
	(A.Code LIKE dbo.fn_Account__Code(N'IntangibleAssetsOtherThanGoodwill') +'%' AND N.Code LIKE dbo.fn_Note__Code(N'IntangibleAssetsOtherThanGoodwill') + '%') OR
	(A.Code LIKE dbo.fn_Account__Code(N'NoncurrentBiologicalAssets') +'%' AND N.Code LIKE dbo.fn_Note__Code(N'BiologicalAssets') + '%') OR
	(A.Code LIKE dbo.fn_Account__Code(N'CurrentBiologicalAssets') +'%' AND N.Code LIKE dbo.fn_Note__Code(N'BiologicalAssets') + '%') OR
	(A.Code LIKE dbo.fn_Account__Code(N'CashAndCashEquivalents') +'%' AND N.Code LIKE dbo.fn_Note__Code(N'CashAndCashEquivalents') + '%') OR
	(A.Code LIKE dbo.fn_Account__Code(N'Equity') +'%' AND N.Code LIKE dbo.fn_Note__Code(N'Equity') + '%') OR
	(A.Code LIKE dbo.fn_Account__Code(N'OtherLongtermProvisions') +'%' AND N.Code LIKE dbo.fn_Note__Code(N'OtherLongtermProvisions') + '%') OR
	(A.Code LIKE dbo.fn_Account__Code(N'CostOfSales') +'%' AND N.Code LIKE dbo.fn_Note__Code(N'ExpenseByNature') + '%') OR
	(A.Code LIKE dbo.fn_Account__Code(N'DistributionCosts') +'%' AND N.Code LIKE dbo.fn_Note__Code(N'ExpenseByNature') + '%') OR
	(A.Code LIKE dbo.fn_Account__Code(N'AdministrativeExpense') +'%' AND N.Code LIKE dbo.fn_Note__Code(N'ExpenseByNature') + '%') OR
	(A.Code LIKE dbo.fn_Account__Code(N'OtherExpenseByFunction') +'%' AND N.Code LIKE dbo.fn_Note__Code(N'ExpenseByNature') + '%')
);
MERGE [dbo].AccountsNotes AS t
USING @AccountsNotes AS s
ON (s.[AccountId] = t.[AccountId] AND s.[NoteId] = s.[NoteId] AND s.[Direction] = s.[Direction])
WHEN NOT MATCHED BY SOURCE THEN
    DELETE
WHEN NOT MATCHED BY TARGET THEN
    INSERT ([TenantId],	[AccountId], [NoteId], [Direction])
    VALUES (@TenantId, s.[AccountId], s.[NoteId], s.[Direction]);