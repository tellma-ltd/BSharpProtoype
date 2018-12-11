CREATE PROCEDURE [dbo].[dal_Custodies__Activate]
	@IndexedIds dbo.[IndexedIdList] READONLY,
	@IsActive bit
AS
	DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();
	DECLARE @UserId NVARCHAR(450) = CONVERT(NVARCHAR(450), SESSION_CONTEXT(N'UserId'));

	MERGE INTO [dbo].Custodies AS t
		USING (
			SELECT [Index], [Id]
			FROM @IndexedIds 
		) AS s ON (t.Id = s.Id)
		WHEN MATCHED AND (t.IsActive <> @IsActive)
		THEN
			UPDATE SET 
				t.[IsActive]	= @IsActive,
				t.[ModifiedAt]	= @Now,
				t.[ModifiedBy]	= @UserId;