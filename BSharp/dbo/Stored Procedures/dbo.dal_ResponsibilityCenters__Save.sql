CREATE PROCEDURE [dbo].[dal_ResponsibilityCenters__Save]
	@Entities [ResponsibilityCenterList] READONLY,
	@IndexedIdsJson NVARCHAR(MAX) OUTPUT
AS
SET NOCOUNT ON;
	DECLARE @IndexedIds [dbo].[IndexedIdList];
	DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();
	DECLARE @UserId INT = CONVERT(INT, SESSION_CONTEXT(N'UserId'));

-- Deletions, if already user, we should deactivate instead
	DELETE FROM [dbo].[ResponsibilityCenters]
	WHERE [Id] IN (SELECT [Id] FROM @Entities WHERE [EntityState] = N'Deleted');

	INSERT INTO @IndexedIds([Index], [Id])
	SELECT x.[Index], x.[Id]
	FROM
	(
		MERGE INTO [dbo].[ResponsibilityCenters] AS t
		USING (
			SELECT [Index], [Id], [ResponsibilityDomain], [Name], [Name2], [Name3], [ParentId], [Code],
			[OperationId], [ProductCategoryId], [GeographicRegionId], [CustomerSegmentId], [TaxSegmentId]
			FROM @Entities 
			WHERE [EntityState] IN (N'Inserted', N'Updated')
		) AS s ON (t.Id = s.Id)
		WHEN MATCHED 
		THEN
			UPDATE SET
				t.[ResponsibilityDomain]= s.[ResponsibilityDomain],
				t.[Name]				= s.[Name],
				t.[Name2]				= s.[Name2],
				t.[Name3]				= s.[Name3],
				t.[ParentId]			= s.[ParentId],
				t.[Code]				= s.[Code],
				t.[OperationId]			= s.[OperationId],
				t.[ProductCategoryId]	= s.[ProductCategoryId],
				t.[GeographicRegionId]	= s.[GeographicRegionId],
				t.[CustomerSegmentId]	= s.[CustomerSegmentId],
				t.[TaxSegmentId]		= s.[TaxSegmentId],
				t.[ModifiedAt]			= @Now,
				t.[ModifiedById]		= @UserId
		WHEN NOT MATCHED THEN
			INSERT ([ResponsibilityDomain], [Name],	[Name2], [Name3], [Code], 
					[OperationId], [ProductCategoryId], [GeographicRegionId], [CustomerSegmentId], [TaxSegmentId])
			VALUES (s.[ResponsibilityDomain], s.[Name], s.[Name2], s.[Name3], s.[Code], 
					s.[OperationId], s.[ProductCategoryId], s.[GeographicRegionId], s.[CustomerSegmentId], s.[TaxSegmentId])
			OUTPUT s.[Index], inserted.[Id] 
	) As x

	UPDATE BE
	SET BE.[ParentId]= T.[ParentId]
	FROM [dbo].[ResponsibilityCenters] BE
	JOIN (
		SELECT II.[Id], IIParent.[Id] As ParentId
		FROM @Entities O
		JOIN @IndexedIds IIParent ON IIParent.[Index] = O.ParentIndex
		JOIN @IndexedIds II ON II.[Index] = O.[Index]
	) T ON BE.Id = T.[Id]

	SELECT @IndexedIdsJson = (SELECT * FROM @IndexedIds FOR JSON PATH);