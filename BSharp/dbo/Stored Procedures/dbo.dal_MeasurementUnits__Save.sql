CREATE PROCEDURE [dbo].[dal_MeasurementUnits__Save]
	@Entities [MeasurementUnitList] READONLY
AS
SET NOCOUNT ON;
	DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();
	DECLARE @UserId UNIQUEIDENTIFIER = CONVERT(UNIQUEIDENTIFIER, SESSION_CONTEXT(N'UserId'));

	MERGE INTO [dbo].MeasurementUnits AS t
	USING (
		SELECT [Id], [Code], [UnitType], [Name], [Name2], [Name3], [Description], [Description2], [Description3], [UnitAmount], [BaseAmount]
		FROM @Entities 
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
			t.[ModifiedAt]		= @Now,
			t.[ModifiedById]	= @UserId
	WHEN NOT MATCHED THEN
		INSERT ([Id], [UnitType], [Name], [Name2], [Name3], [Description], [Description2], [Description3], [UnitAmount], [BaseAmount], [Code])
		VALUES (s.[Id], s.[UnitType], s.[Name], s.[Name2], s.[Name3], s.[Description], s.[Description2], s.[Description3], s.[UnitAmount], s.[BaseAmount], s.[Code])
	OPTION (RECOMPILE);