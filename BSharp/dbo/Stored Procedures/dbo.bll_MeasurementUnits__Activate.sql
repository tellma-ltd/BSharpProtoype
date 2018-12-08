CREATE PROCEDURE [dbo].[bll_MeasurementUnits__Activate]
	@ActivationList [ActivationList] READONLY,
	@IndexedIdsJson  NVARCHAR(MAX) OUTPUT
AS
	DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();
	DECLARE @UserId NVARCHAR(450) = CONVERT(NVARCHAR(450), SESSION_CONTEXT(N'UserId'));

	MERGE INTO [dbo].MeasurementUnits AS t
		USING (
			SELECT [Index], [Id], [IsActive]
			FROM @ActivationList 
		) AS s ON (t.Id = s.Id)
		WHEN MATCHED AND (t.IsActive <> s.IsActive)
		THEN
			UPDATE SET 
				t.[IsActive]	= s.[IsActive],
				t.[ModifiedAt]	= @Now,
				t.[ModifiedBy]	= @UserId;

	SELECT @IndexedIdsJson =
	(
		SELECT [Index], [Id] FROM @ActivationList
		FOR JSON PATH
	);