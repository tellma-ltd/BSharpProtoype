﻿CREATE PROCEDURE [dbo].[dal_MeasurementUnits__Save]
	@Entities [MeasurementUnitList] READONLY,
	@IndexedIdsJson NVARCHAR(MAX) OUTPUT
AS
SET NOCOUNT ON;
	DECLARE @IndexedIds [dbo].[IndexedIdList];
	DECLARE @TenantId int = CONVERT(INT, SESSION_CONTEXT(N'TenantId'));
	DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();
	DECLARE @UserId INT = CONVERT(INT, SESSION_CONTEXT(N'UserId'));

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
				t.[UnitType]	= s.[UnitType],
				t.[Name]		= s.[Name],
				t.[Name2]		= s.[Name2],
				t.[Description]	= s.[Description],
				t.[UnitAmount]	= s.[UnitAmount],
				t.[BaseAmount]	= s.[BaseAmount],
				t.[Code]		= s.[Code],
				t.[ModifiedAt]	= @Now,
				t.[ModifiedById]	= @UserId
		WHEN NOT MATCHED THEN
			INSERT ([TenantId], [UnitType], [Name], [Name2], [Description], [UnitAmount], [BaseAmount], [Code], [CreatedAt], [CreatedById], [ModifiedAt], [ModifiedById])
			VALUES (@TenantId, s.[UnitType], s.[Name], s.[Name2], s.[Description], s.[UnitAmount], s.[BaseAmount], s.[Code], @Now, @UserId, @Now, @UserId)
		OUTPUT s.[Index], inserted.[Id] 
	) As x

	SELECT @IndexedIdsJson = (SELECT * FROM @IndexedIds FOR JSON PATH);
