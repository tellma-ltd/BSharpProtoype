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
			SELECT 	
				[Index], [Id], [ResourceType], [Name], [Name2], [Name3], [ValueMeasure], [UnitId],
				[CurrencyId], [MassUnitId], [MassRate], [VolumeUnitId], [VolumeRate], [LengthUnitId],
				[CountUnitId], [TimeUnitId], [Code], [SystemCode], [Memo], [Reference] , [RelatedReference],
				[RelatedAgentId], [RelatedResourceId],[RelatedMeasurementUnitId], [RelatedAmount],
				[RelatedDateTime], [Lookup1Id], [Lookup2Id], [Lookup3Id], [Lookup4Id],
				[PartOfId],[InstanceOfId]
			FROM @Resources 
			WHERE [EntityState] IN (N'Inserted', N'Updated')
		) AS s ON (t.Id = s.Id)
		WHEN MATCHED 
		THEN
			UPDATE SET 
				t.[ResourceType]			= s.[ResourceType],     
				t.[Name]					= s.[Name],
				t.[Name2]					= s.[Name2],
				t.[Name3]					= s.[Name3],
				t.[ValueMeasure]			= s.[ValueMeasure],
				t.[UnitId]					= s.[UnitId],
				t.[CurrencyId]				= s.[CurrencyId],
				t.[MassUnitId]				= s.[MassUnitId],
				t.[MassRate]				= s.[MassRate],
				t.[VolumeUnitId]			= s.[VolumeUnitId],
				t.[VolumeRate]				= s.[VolumeRate],
				t.[LengthUnitId]			= s.[LengthUnitId],
				t.[CountUnitId]				= s.[CountUnitId],
				t.[TimeUnitId]				= s.[TimeUnitId],
				t.[Code]					= s.[Code],
				t.[SystemCode]				= s.[SystemCode],
				t.[Memo]					= s.[Memo],      
				
				t.[Reference]				= s.[Reference],
				t.[RelatedReference]		= s.[RelatedReference],
				t.[RelatedAgentId]			= s.[RelatedAgentId],
				t.[RelatedResourceId]		= s.[RelatedResourceId],
				t.[RelatedMeasurementUnitId]= s.[RelatedMeasurementUnitId],
				t.[RelatedAmount]			= s.[RelatedAmount],
				t.[RelatedDateTime]			= s.[RelatedDateTime],

				t.[Lookup1Id]				= s.[Lookup1Id],
				t.[Lookup2Id]				= s.[Lookup2Id],
				t.[Lookup3Id]				= s.[Lookup3Id],
				t.[Lookup4Id]				= s.[Lookup4Id],
				t.[PartOfId]				= s.[PartOfId],
				t.[InstanceOfId]			= s.[InstanceOfId],
				t.[ModifiedAt]				= @Now,
				t.[ModifiedById]			= @UserId
		WHEN NOT MATCHED THEN
			INSERT ([ResourceType], [Name], [Name2], [Name3], [ValueMeasure], [UnitId],
				[CurrencyId], [MassUnitId], [MassRate], [VolumeUnitId], [VolumeRate], [LengthUnitId],
				[CountUnitId], [TimeUnitId], [Code], [SystemCode], [Memo], [Reference] , [RelatedReference],
				[RelatedAgentId], [RelatedResourceId],[RelatedMeasurementUnitId], [RelatedAmount],
				[RelatedDateTime], [Lookup1Id], [Lookup2Id], [Lookup3Id], [Lookup4Id],
				[PartOfId],[InstanceOfId])
			VALUES (s.[ResourceType], s.[Name], s.[Name2], s.[Name3], s.[ValueMeasure], s.[UnitId],
				s.[CurrencyId], s.[MassUnitId], s.[MassRate], s.[VolumeUnitId], s.[VolumeRate], s.[LengthUnitId],
				s.[CountUnitId], s.[TimeUnitId], s.[Code], s.[SystemCode], s.[Memo], s.[Reference] , s.[RelatedReference],
				s.[RelatedAgentId], s.[RelatedResourceId], s.[RelatedMeasurementUnitId], s.[RelatedAmount],
				s.[RelatedDateTime], s.[Lookup1Id], s.[Lookup2Id], s.[Lookup3Id], s.[Lookup4Id],
				s.[PartOfId],s.[InstanceOfId])
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

	SELECT @IndexedIdsJson = (SELECT * FROM @IndexedIds FOR JSON PATH);