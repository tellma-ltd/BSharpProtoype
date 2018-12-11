CREATE PROCEDURE [dbo].[dal_Resources__Save]
	@Resources [ResourceForSaveList] READONLY,
	@IndexedIdsJson  NVARCHAR(MAX) OUTPUT
AS
SET NOCOUNT ON;
	DECLARE @IndexedIds [dbo].[IndexedIdList];
	DECLARE @TenantId int = CONVERT(INT, SESSION_CONTEXT(N'TenantId'));
	DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();
	DECLARE @UserId NVARCHAR(450) = CONVERT(NVARCHAR(450), SESSION_CONTEXT(N'UserId'));

-- Deletions
	DELETE FROM [dbo].Resources
	WHERE [Id] IN (SELECT [Id] FROM @Resources WHERE [EntityState] = N'Deleted');

	INSERT INTO @IndexedIds([Index], [Id])
	SELECT x.[Index], x.[Id]
	FROM
	(
		MERGE INTO [dbo].Resources AS t
		USING (
			SELECT [Index], [Id], [MeasurementUnitId], [ResourceType], [Name], [Code], [Memo], [Lookup1], [Lookup2], [Lookup3], [Lookup4], [PartOf], [FungibleParentId]
			FROM @Resources 
			WHERE [EntityState] IN (N'Inserted', N'Updated')
		) AS s ON (t.Id = s.Id)
		WHEN MATCHED 
		THEN
			UPDATE SET 
				t.[ResourceType]			= s.[ResourceType],         
				t.[Name]					= s.[Name],                   
				t.[Code]					= s.[Code],
				t.[MeasurementUnitId]		= s.[MeasurementUnitId],
				t.[Memo]					= s.[Memo],             
				t.[Lookup1]					= s.[Lookup1],
				t.[Lookup2]					= s.[Lookup2],
				t.[Lookup3]					= s.[Lookup3],
				t.[Lookup4]					= s.[Lookup4],
				t.[PartOf]					= s.[PartOf],
				t.[FungibleParentId]		= s.[FungibleParentId],
				t.[ModifiedAt]				= @Now,
				t.[ModifiedBy]				= @UserId
		WHEN NOT MATCHED THEN
				INSERT ([TenantId], [MeasurementUnitId], [ResourceType],	[Name],	[Code], 	 [Memo],	[Lookup1],	[Lookup2],	[Lookup3],		[Lookup4], [PartOf], [FungibleParentId], [CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy])
				VALUES (@TenantId, s.[MeasurementUnitId], s.[ResourceType], s.[Name], s.[Code],  s.[Memo], s.[Lookup1], s.[Lookup2], s.[Lookup3], s.[Lookup4], s.[PartOf], s.[FungibleParentId], @Now, @UserId, @Now, @UserId)
			OUTPUT s.[Index], inserted.[Id] 
	) As x

	UPDATE BE
	SET BE.[FungibleParentId]= T.[FungibleParentId]
	FROM [dbo].Resources BE
	JOIN (
		SELECT II.[Id], IIParent.[Id] As [FungibleParentId]
		FROM @Resources R
		JOIN @IndexedIds IIParent ON IIParent.[Index] = R.[FungibleParentIndex]
		JOIN @IndexedIds II ON II.[Index] = R.[Index]
	) T ON BE.Id = T.[Id]

	SELECT @IndexedIdsJson =
	(
		SELECT [Index], [Id] FROM @IndexedIds
		FOR JSON PATH
	);