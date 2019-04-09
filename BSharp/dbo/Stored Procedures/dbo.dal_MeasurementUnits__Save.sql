CREATE PROCEDURE [dbo].[dal_MeasurementUnits__Save]
	@Entities [MeasurementUnitList] READONLY,
	@IndexedIdsJson NVARCHAR(MAX) OUTPUT
AS
SET NOCOUNT ON;
	DECLARE @IndexedIds [dbo].[IndexedIdList];

-- Deletions
	DELETE FROM [dbo].MeasurementUnits
	WHERE [Id] IN (SELECT [Id] FROM @Entities WHERE [EntityState] = N'Deleted');

	INSERT INTO @IndexedIds([Index], [Id])
	SELECT x.[Index], x.[Id]
	FROM
	(
		MERGE INTO [dbo].MeasurementUnits AS t
		USING (
			SELECT [Index], [Id], [Code], [UnitType], [Name], [Name2], [Description], [UnitAmount], [BaseAmount]
			FROM @Entities 
			WHERE [EntityState] IN (N'Inserted', N'Updated')
		) AS s ON (t.Id = s.Id)
		WHEN MATCHED 
		THEN
			UPDATE SET 
				t.[UnitType]		= s.[UnitType],
				t.[Name]			= s.[Name],
				t.[Name2]			= s.[Name2],
				t.[Name3]			= s.[Name3],
				t.[Description]		= s.[Description],
				t.[Description2]	= s.[Description2],
				t.[Description3]	= s.[Description3],
				t.[UnitAmount]		= s.[UnitAmount],
				t.[BaseAmount]		= s.[BaseAmount],
				t.[Code]			= s.[Code],
				t.[ModifiedAt]		= SYSDATETIMEOFFSET(),
				t.[ModifiedById]	= CONVERT(INT, SESSION_CONTEXT(N'UserId'))
		WHEN NOT MATCHED THEN
			INSERT ([UnitType], [Name], [Name2], [Name3], [Description], [Description2], [Description3], [UnitAmount], [BaseAmount], [Code])
			VALUES (s.[UnitType], s.[Name], s.[Name2], s.[Name3], s.[Description], s.[Description2], s.[Description3], s.[UnitAmount], s.[BaseAmount], s.[Code])
		OUTPUT s.[Index], inserted.[Id] 
	) As x

	SELECT @IndexedIdsJson = (SELECT * FROM @IndexedIds FOR JSON PATH);
