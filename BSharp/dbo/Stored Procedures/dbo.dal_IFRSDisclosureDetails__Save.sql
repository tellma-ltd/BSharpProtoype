CREATE PROCEDURE [dbo].[dal_IfrsDisclosureDetails__Save]
	@Entities [IfrsDisclosureDetailList] READONLY
AS
SET NOCOUNT ON;
	DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();
	DECLARE @UserId UNIQUEIDENTIFIER = CONVERT(UNIQUEIDENTIFIER, SESSION_CONTEXT(N'UserId'));

	MERGE INTO [dbo].[IfrsDisclosureDetails] AS t
	USING (
		SELECT [Id], [IfrsDisclosureId], [Value], [ValidSince]
		FROM @Entities 
	) AS s 
	ON (t.[Id] = s.[Id])
	WHEN MATCHED 
	THEN
		UPDATE SET
			t.[IfrsDisclosureId]= s.[IfrsDisclosureId],
			t.[Value]			= s.[Value],
			t.[ValidSince]		= s.[ValidSince],
			t.[ModifiedAt]		= @Now,
			t.[ModifiedById]	= @UserId
	WHEN NOT MATCHED THEN
		INSERT ([Id], [IfrsDisclosureId], [Value], [ValidSince])
		VALUES (s.[Id], s.[IfrsDisclosureId], s.[Value], s.[ValidSince]);