DECLARE @AccountSpecifications AS TABLE (
	[AccountId]				NVARCHAR (255),
	[Direction]				SMALLINT,
	[CustodyLabel]			NVARCHAR (255), -- Needed when hovering over the column.
	[CustodyFilter]			NVARCHAR (255), -- JS code, affecting the 
	[ResourceLabel]			NVARCHAR (255),
	[ResourceFilter]		NVARCHAR (255),
	[AmountLabel]			NVARCHAR (255),
	[ReferenceLabel]		NVARCHAR (255),
	[RelatedReferenceLabel]	NVARCHAR (255),
	[RelatedAgentLabel]		NVARCHAR (255),
	[RelatedAgentFilter]	NVARCHAR (255),
	[RelatedResourceLabel]	NVARCHAR (255),
	[RelatedResourceFilter]	NVARCHAR (255),
	[RelatedAmountLabel]	NVARCHAR (255)
	PRIMARY KEY NONCLUSTERED ([AccountId], [Direction])
);
INSERT INTO @AccountSpecifications(
[AccountId],				[Direction], [CustodyLabel], [CustodyFilter],				[ResourceLabel], [ResourceFilter],				[AmountLabel], [ReferenceLabel], [RelatedReferenceLabel], [RelatedAgentLabel], [RelatedAgentFilter], [RelatedResourceLabel], [RelatedResourceFilter], [RelatedAmountLabel]) VALUES
(N'BalancesWithBanks',			+1,		N'BankAccount',	N'CustodyType = N''BankAccount''', N'Currency',	N'ResourceType = N''Currency''', N'Deposit',	N'DepositSlipReference', N'CheckReference', N'Depositer',		NULL,					NULL,					NULL,					NULL),
(N'CurrentWithholdingTaxPayable', -1,		NULL,		N'SystemCode = N''TaxAgent''',	N'Currency',	N'SystemCode = N''Functional''', N'AmountWithheld',	N'WT Form #',	NULL,					N'Withholdee',		NULL,					NULL,					NULL,			N'Invoice Amount'),
(N'CurrentValueAddedTaxReceivables',+1,		NULL,		N'SystemCode = N''TaxAgent''',		NULL,		N'SystemCode = N''Functional''',	NULL,		N'Invoice #',		NULL,					N'Customer',		NULL,					NULL,					NULL,			N'Invoice Amount');

MERGE [dbo].[IFRSAccountSpecifications] AS t
USING @AccountSpecifications AS s
ON s.[AccountId] = t.[AccountId] AND s.[Direction] = t.[Direction]
WHEN MATCHED 
AND
(
	t.[CustodyLabel]			<> s.[CustodyLabel] OR
	t.[CustodyFilter]			<> s.[CustodyFilter] OR
	t.[ResourceLabel]			<> s.[ResourceLabel] OR
	t.[ResourceFilter]			<> s.[ResourceFilter] OR
	t.[AmountLabel]				<> s.[AmountLabel] OR
	t.[ReferenceLabel]			<> s.[ReferenceLabel] OR
	t.[RelatedReferenceLabel]	<> s.[RelatedReferenceLabel] OR
	t.[RelatedAgentLabel]		<> s.[RelatedAgentLabel] OR
	t.[RelatedAgentFilter]		<> s.[RelatedAgentFilter] OR
	t.[RelatedResourceLabel]	<> s.[RelatedResourceLabel] OR
	t.[RelatedResourceFilter]	<> s.[RelatedResourceFilter] OR
	t.[RelatedAmountLabel]		<> s.[RelatedAmountLabel]
) 
THEN
UPDATE SET
	t.[AgentAccountLabel]			= s.[CustodyLabel],
	t.[AgentAccountFilter]			= s.[CustodyFilter],
	t.[ResourceLabel]			= s.[ResourceLabel],
	t.[ResourceFilter]			= s.[ResourceFilter],
	t.[MoneyAmountLabel]				= s.[AmountLabel],
	t.[ReferenceLabel]			= s.[ReferenceLabel],
	t.[RelatedReferenceLabel]	= s.[RelatedReferenceLabel],
	t.[RelatedAgentLabel]		= s.[RelatedAgentLabel],
	t.[RelatedAgentAccountFilter]		= s.[RelatedAgentFilter],
	t.[RelatedResourceLabel]	= s.[RelatedResourceLabel],
	t.[RelatedResourceFilter]	= s.[RelatedResourceFilter],
	t.[RelatedAmountLabel]		= s.[RelatedAmountLabel]
WHEN NOT MATCHED BY SOURCE THEN
    DELETE
WHEN NOT MATCHED BY TARGET THEN
    INSERT ([TenantId],	[IFRSAccountConcept], [Direction], [AgentAccountLabel], [AgentAccountFilter], [ResourceLabel], [ResourceFilter], [MoneyAmountLabel], [ReferenceLabel], [RelatedReferenceLabel], [RelatedAgentLabel], [RelatedAgentAccountFilter], [RelatedResourceLabel], [RelatedResourceFilter], [RelatedAmountLabel])
    VALUES (@TenantId, s.[AccountId], s.[Direction], s.[CustodyLabel], s.[CustodyFilter], s.[ResourceLabel], s.[ResourceFilter], s.[AmountLabel], s.[ReferenceLabel], s.[RelatedReferenceLabel], s.[RelatedAgentLabel], s.[RelatedAgentFilter], s.[RelatedResourceLabel], s.[RelatedResourceFilter], s.[RelatedAmountLabel]);