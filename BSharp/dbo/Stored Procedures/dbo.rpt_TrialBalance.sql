CREATE PROCEDURE [dbo].[rpt_TrialBalance] 
/* 
EXEC [dbo].[rpt_TrialBalance] @fromDate = '01.01.2015', @toDate = '01.01.2020', @ByAgent = 1, @ByResource = 1, @ByNote = 1, @PrintQuery = 1
*/	
	@fromDate Datetime = '01.01.2000', 
	@toDate Datetime = '01.01.2020',
	@ByOperation bit = 1,
	@ByAgent bit = 1,
	@ByResource bit = 1,
	@ByNote bit = 1,
	@PrintQuery bit = 0
AS
BEGIN
	DECLARE @Query nvarchar(max);
	SET @Query = 
	N'
		SET NOCOUNT ON;
		SELECT
			A.[Code], A.[Name] As Account,'
	IF (@ByOperation = 1)
		SET @Query = @Query + N'
			O.[Name] As Operation,'
	IF (@ByAgent = 1)
		SET @Query = @Query + N'
			C.[Name] As Agent,'
	IF (@ByResource = 1)
		SET @Query = @Query + N'
			R.[Name] As Resource,
			T.[Amount], MU.[Name] As UOM,'
	IF (@ByNote = 1)
		SET @Query = @Query + N'
			T.NoteId As Note,'
	SET @Query = @Query + N'
			Mass, Volume, Count, Usage,
			(CASE WHEN T.Net > 0 THEN Net ELSE 0 END) As Debit,
			(CASE WHEN T.Net < 0 THEN -Net ELSE 0 END) As Credit

		FROM 
		(
			SELECT AccountId, '
	IF (@ByOperation = 1) SET @Query = @Query + N'OperationId, '
	IF (@ByAgent = 1) SET @Query = @Query + N'AgentId, '
	IF (@ByResource = 1) SET @Query = @Query + N'ResourceId, '
	IF (@ByNote = 1) SET @Query = @Query + N'NoteId, '
	SET @Query = @Query + N'
			CAST(SUM([Direction] * [Mass]) AS money) AS Mass,	
			CAST(SUM([Direction] * [Volume]) AS money) AS Volume,	
			CAST(SUM([Direction] * [Count]) AS money) AS Count,	
			CAST(SUM([Direction] * [Usage]) AS money) AS Usage,	
			CAST(SUM([Direction] * [Value]) AS money) AS NET
			FROM [dbo].[fi_Journal](@fromDate, @toDate) E
			GROUP BY AccountId'
	IF (@ByOperation = 1) SET @Query = @Query + N', OperationId'
	IF (@ByAgent = 1) SET @Query = @Query + N', AgentId'
	IF (@ByResource = 1) SET @Query = @Query + N', ResourceId'
	IF (@ByNote = 1) SET @Query = @Query + N', NoteId'
	SET @Query = @Query + N'		
			HAVING 
				SUM([Direction] * [Mass]) OR
				SUM([Direction] * [Volume]) OR
				SUM([Direction] * [Count]) OR
				SUM([Direction] * [Usage]) OR
				SUM([Direction] * [Value]) <> 0
			OR 
		) T 
		JOIN [dbo].Accounts A ON T.AccountId = A.Id'
	IF (@ByOperation = 1) SET @Query = @Query + N'
		JOIN [dbo].[Operations] O ON T.OperationId = O.Id'
	IF (@ByAgent = 1) SET @Query = @Query + N'
		JOIN [dbo].[Agents] C ON T.AgentId = C.Id'
	IF (@ByResource = 1) SET @Query = @Query + N'
		JOIN [dbo].[Resources] R ON T.ResourceId = R.Id
		JOIN [dbo].[MeasurementUnits] MU ON R.MeasurementUnitId = MU.Id
		'
	SET @Query = @Query + N'
		ORDER BY A.[Code]'

	IF (@PrintQuery = 1)
		Print @Query
	ELSE BEGIN
		DECLARE @ParmDefinition nvarchar(500);
		SET @ParmDefinition = N'@fromDate Datetime, @toDate Datetime';
		EXEC sp_executesql @Query, @ParmDefinition, @fromDate = @fromDate, @toDate = @toDate
	END
END