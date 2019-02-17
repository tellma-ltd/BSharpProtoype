CREATE PROCEDURE [dbo].[dal_Resources__Save]
	@Resources [dbo].[ResourceList] READONLY,
	@IndexedIdsJson NVARCHAR(MAX) OUTPUT
AS
SET NOCOUNT ON;
	DECLARE @IndexedIds [dbo].[IndexedIdList];
	DECLARE @TenantId int = CONVERT(INT, SESSION_CONTEXT(N'TenantId'));
	DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();
	DECLARE @UserId INT = CONVERT(INT, SESSION_CONTEXT(N'UserId'));

-- Deletions
	DELETE FROM [dbo].Resources
	WHERE [Id] IN (SELECT [Id] FROM @Resources WHERE [EntityState] = N'Deleted');

	INSERT INTO @IndexedIds([Index], [Id])
	SELECT x.[Index], x.[Id]
	FROM
	(
		MERGE INTO [dbo].[Resources] AS t
		USING (
			SELECT [Index], [Id], [MeasurementUnitId], [ResourceType], [Name], [Name2], [Code], [SystemCode], [Memo], [Lookup1], [Lookup2], [Lookup3], [Lookup4], 
					[PartOfId], [InstanceOfId], [ServiceOfId]
			FROM @Resources 
			WHERE [EntityState] IN (N'Inserted', N'Updated')
		) AS s ON (t.Id = s.Id)
		WHEN MATCHED 
		THEN
			UPDATE SET 
				t.[ResourceType]			= s.[ResourceType],     
				t.[Name]					= s.[Name],
				t.[Name2]					= s.[Name2],
				t.[Code]					= s.[Code],
				t.[MassUnitId]		= s.[MeasurementUnitId],
				t.[Memo]					= s.[Memo],       
				t.[Lookup1]					= s.[Lookup1],
				t.[Lookup2]					= s.[Lookup2],
				t.[Lookup3]					= s.[Lookup3],
				t.[Lookup4]					= s.[Lookup4],
				t.[PartOfId]				= s.[PartOfId],
				t.[InstanceOfId]			= s.[InstanceOfId],
				t.[ServiceOfId]				= s.[ServiceOfId],
				t.[ModifiedAt]				= @Now,
				t.[ModifiedById]			= @UserId
		WHEN NOT MATCHED THEN
			INSERT ([TenantId], [MassUnitId], [ResourceType],	[Name],	[Name2], [Code],		[SystemCode],	 [Memo],	[Lookup1],	[Lookup2],	[Lookup3],	[Lookup4],	[PartOfId],		[InstanceOfId], [ServiceOfId],	[CreatedAt], [CreatedById], [ModifiedAt], [ModifiedById])
			VALUES (@TenantId, s.[MeasurementUnitId], s.[ResourceType], s.[Name], s.[Name2], s.[Code], s.[SystemCode], s.[Memo], s.[Lookup1], s.[Lookup2], s.[Lookup3], s.[Lookup4], s.[PartOfId], s.[InstanceOfId], s.[ServiceOfId], @Now, @UserId, @Now, @UserId)
			OUTPUT s.[Index], inserted.[Id] 
	) As x;

	UPDATE BE
	SET BE.[PartOfId]= T.[PartOfId]
	FROM [dbo].[Resources] BE
	JOIN (
		SELECT II.[Id], IIParent.[Id] As [PartOfId]
		FROM @Resources R
		JOIN @IndexedIds IIParent ON IIParent.[Index] = R.[PartOfIndex]
		JOIN @IndexedIds II ON II.[Index] = R.[Index]
	) T ON BE.Id = T.[Id];

	UPDATE BE
	SET BE.[InstanceOfId]= T.[InstanceOfId]
	FROM [dbo].[Resources] BE
	JOIN (
		SELECT II.[Id], IIParent.[Id] As [InstanceOfId]
		FROM @Resources R
		JOIN @IndexedIds IIParent ON IIParent.[Index] = R.[InstanceOfIndex]
		JOIN @IndexedIds II ON II.[Index] = R.[Index]
	) T ON BE.Id = T.[Id];

	UPDATE BE
	SET BE.[ServiceOfId]= T.[ServiceOfId]
	FROM [dbo].[Resources] BE
	JOIN (
		SELECT II.[Id], IIParent.[Id] As [ServiceOfId]
		FROM @Resources R
		JOIN @IndexedIds IIParent ON IIParent.[Index] = R.[ServiceOfIndex]
		JOIN @IndexedIds II ON II.[Index] = R.[Index]
	) T ON BE.Id = T.[Id];

	SELECT @IndexedIdsJson = (SELECT * FROM @IndexedIds FOR JSON PATH);