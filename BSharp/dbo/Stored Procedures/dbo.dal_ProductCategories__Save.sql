CREATE PROCEDURE [dbo].[dal_ProductCategories__Save]
	@Entities [ProductCategoryList] READONLY,
	@IndexedIdsJson NVARCHAR(MAX) OUTPUT
AS
SET NOCOUNT ON;
	DECLARE @IndexedIds [dbo].[IndexedIdList];
	DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();
	DECLARE @UserId INT = CONVERT(INT, SESSION_CONTEXT(N'UserId'));

	-- Deletions, if already used, we should deactivate instead
	DELETE FROM [dbo].[ProductCategories]
	WHERE [Id] IN (SELECT [Id] FROM @Entities WHERE [EntityState] = N'Deleted');

	INSERT INTO @IndexedIds([Index], [Id])
	SELECT x.[Index], x.[Id]
	FROM
	(
		MERGE INTO [dbo].[ProductCategories] AS t
		USING (
			SELECT [Index], [Id], [Node], [Name], [Name2], [Name3], [Code], [EntityState]
			FROM @Entities 
			WHERE [EntityState] IN (N'Inserted', N'Updated')
		) AS s ON (t.Id = s.Id)
		WHEN MATCHED 
		THEN
			UPDATE SET
				t.[Node]			= s.[Node],
				t.[Name]			= s.[Name],
				t.[Name2]			= s.[Name2],
				t.[Name3]			= s.[Name3],
				t.[Code]			= s.[Code],
				t.[ModifiedAt]		= @Now,
				t.[ModifiedById]	= @UserId
		WHEN NOT MATCHED THEN
			INSERT ([Node],		[Name],	[Name2],	[Name3], [Code])
			VALUES (s.[Node], s.[Name], s.[Name2], s.[Name3], s.[Code])
		OUTPUT s.[Index], inserted.[Id]
	) As x

	SELECT @IndexedIdsJson = (SELECT * FROM @IndexedIds FOR JSON PATH);