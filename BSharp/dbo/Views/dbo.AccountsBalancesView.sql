CREATE VIEW [dbo].[AccountsBalancesView]
WITH SCHEMABINDING  
AS
	SELECT
		D.[TenantId], E.[AccountId], E.[ResponsibilityCenterId], E.[AgentAccountId],
		E.[ResourceId], E.[InstanceCode], E.[BatchCode], E.[ExpectedSettlingDate], 
		SUM(E.[Direction] * E.[Quantity]) AS [Quantity],
		SUM(E.[Direction] * E.[MoneyAmount]) AS [MoneyAmount],
		SUM(E.[Direction] * E.[Mass]) AS [Mass],
		SUM(E.[Direction] * E.[Volume]) AS [Volume],
		SUM(E.[Direction] * E.[Count]) AS [Count],
		SUM(E.[Direction] * E.[Time]) AS [Time],
		SUM(E.[Direction] * E.[Value]) AS [Value]
	FROM dbo.[TransactionEntries] E
	JOIN dbo.[Documents] D ON E.[DocumentId] = D.[Id]
	JOIN dbo.[DocumentTypes] DT ON D.[DocumentType] = DT.[Id]
	WHERE DT.[DocumentCategory] = N'Transaction' AND D.[DocumentState] = N'Posted'
	GROUP BY
		D.[TenantId], E.[AccountId], E.[ResponsibilityCenterId], E.[AgentAccountId],
		E.[ResourceId], E.[InstanceCode], E.[BatchCode], E.[ExpectedSettlingDate]
	HAVING
		SUM(E.[Direction] * E.[Quantity]) <> 0 OR
		SUM(E.[Direction] * E.[MoneyAmount]) <> 0 OR
		SUM(E.[Direction] * E.[Mass]) <> 0 OR 
		SUM(E.[Direction] * E.[Volume]) <> 0 OR
		SUM(E.[Direction] * E.[Count]) <> 0 OR
		SUM(E.[Direction] * E.[Time]) <> 0 OR
		SUM(E.[Direction] * E.[Value]) <> 0;
GO;
CREATE CLUSTERED INDEX IX_AccountsBalancesView__AccountId
	ON [dbo].[AccountsBalancesView]([TenantId], [AccountId]);
GO;
CREATE INDEX IX_AccountsBalancesView__ExpectedSettlingDate
	ON [dbo].[AccountsBalancesView]([TenantId], [ExpectedSettlingDate]);