CREATE PROCEDURE [dbo].[dal_MeasurementUnits__Save]
	@MeasurementUnits [MeasurementUnitForSaveList] READONLY,
	@IndexedIdsJson  NVARCHAR(MAX) OUTPUT
AS
SET NOCOUNT ON;
	DECLARE @IndexedIds [dbo].[IndexedIdList];
	DECLARE @TenantId int = CONVERT(INT, SESSION_CONTEXT(N'TenantId'));
	DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();
	DECLARE @UserId NVARCHAR(450) = CONVERT(NVARCHAR(450), SESSION_CONTEXT(N'UserId'));

-- Deletions
	DELETE FROM [dbo].MeasurementUnits
	WHERE Id IN (SELECT Id FROM @MeasurementUnits WHERE [EntityState] = N'Deleted');
-- Updates
	MERGE INTO [dbo].MeasurementUnits AS t
	USING (
		SELECT [Id], [Code], [UnitType], [Name], [UnitAmount], [BaseAmount]
		FROM @MeasurementUnits 
		WHERE [EntityState] = N'Updated'
	) AS s ON (t.Id = s.Id)
	WHEN MATCHED 
	AND (
			t.[UnitType]	<> s.[UnitType] OR
			t.[Name]		<> s.[Name] OR
			t.[UnitAmount]	<> s.[UnitAmount] OR
			t.[BaseAmount]	<> s.[BaseAmount] OR
		ISNULL(t.[Code], N'') <> ISNULL(s.[Code], N'')
	)	
	THEN
		UPDATE SET 
			t.[UnitType]	= s.[UnitType],
			t.[Name]		= s.[Name],
			t.[UnitAmount]	= s.[UnitAmount],
			t.[BaseAmount]	= s.[BaseAmount],
			t.[Code]		= s.[Code],
			t.[ModifiedAt]	= @Now,
			t.[ModifiedBy]	= @UserId;

-- Inserts
	INSERT INTO @IndexedIds([Index], [Id])
	SELECT x.[Index], x.[Id]
	FROM
	(
		MERGE INTO [dbo].MeasurementUnits AS t
		USING (
			SELECT [Index], [Id], [UnitType], [Name], [UnitAmount], [BaseAmount], [Code]
			FROM @MeasurementUnits
			WHERE [EntityState] = N'Inserted'
		) AS s ON (t.Id = s.Id)
		WHEN NOT MATCHED THEN
			INSERT ([TenantId], [UnitType], [Name], [UnitAmount], [BaseAmount], [Code], [CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy])
			VALUES (@TenantId, s.[UnitType], s.[Name], s.[UnitAmount], s.[BaseAmount], s.[Code], @Now, @UserId, @Now, @UserId)
		OUTPUT s.[Index], inserted.[Id] 
	) AS x;

	SELECT @IndexedIdsJson =
	(
		SELECT [Index], [Id] FROM @IndexedIds
		FOR JSON PATH
	);
