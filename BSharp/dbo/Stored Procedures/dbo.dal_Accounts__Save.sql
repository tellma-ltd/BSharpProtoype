CREATE PROCEDURE [dbo].[dal_Accounts__Save]
	@Entities [AccountList] READONLY,
	@IndexedIdsJson NVARCHAR(MAX) OUTPUT
AS
SET NOCOUNT ON;
	DECLARE @IndexedIds [dbo].[IndexedIdList];
	DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();
	DECLARE @UserId INT = CONVERT(INT, SESSION_CONTEXT(N'UserId'));

-- Deletions, if already user, we should deactivate instead
	INSERT INTO @IndexedIds([Index], [Id])
	SELECT x.[Index], x.[Id]
	FROM
	(
		MERGE INTO [dbo].Accounts AS t
		USING (
			SELECT
				[Index], [Id], [CustomClassificationId], [IfrsAccountId],
				[Name], [Name2], [Name3], [Code],
				[IfrsNoteIsFixed], [IfrsNoteId],
				[ResponsibilityCenterIsFixed], [ResponsibilityCenterId],
				[AgentAccountIsFixed], [AgentAccountId],
				[ResourceIsFixed], [ResourceId]
			FROM @Entities 
			WHERE [EntityState] IN (N'Inserted', N'Updated')
		) AS s ON (t.Id = s.Id)
		WHEN MATCHED 
		THEN
			UPDATE SET
				t.[CustomClassificationId]		= s.[CustomClassificationId], 
				t.[IfrsAccountId]				= s.[IfrsAccountId],
				t.[Name]						= s.[Name],
				t.[Name2]						= s.[Name2],
				t.[Name3]						= s.[Name3],
				t.[Code]						= s.[Code],
				t.[IfrsNoteIsFixed]				= s.[IfrsNoteIsFixed],
				t.[IfrsNoteId]					= s.[IfrsNoteId],
				t.[ResponsibilityCenterIsFixed] = s.[ResponsibilityCenterIsFixed],
				t.[ResponsibilityCenterId]		= s.[ResponsibilityCenterId],
				t.[AgentAccountIsFixed]			= s.[AgentAccountIsFixed],
				t.[AgentAccountId]				= s.[AgentAccountId],
				t.[ResourceIsFixed]				= s.[ResourceIsFixed],
				t.[ResourceId]					= s.[ResourceId],
				t.[ModifiedAt]					= @Now,
				t.[ModifiedById]				= @UserId
		WHEN NOT MATCHED THEN
			INSERT ([CustomClassificationId], [IfrsAccountId],
				[Name], [Name2], [Name3], [Code], [IfrsNoteIsFixed], [IfrsNoteId],
				[ResponsibilityCenterIsFixed], [ResponsibilityCenterId],
				[AgentAccountIsFixed], [AgentAccountId],
				[ResourceIsFixed], [ResourceId])
			VALUES (s.[CustomClassificationId], s.[IfrsAccountId],
				s.[Name], s.[Name2], s.[Name3], s.[Code],s.[IfrsNoteIsFixed], s.[IfrsNoteId],
				s.[ResponsibilityCenterIsFixed], s.[ResponsibilityCenterId], 
				s.[AgentAccountIsFixed], s.[AgentAccountId],
				s.[ResourceIsFixed], s.[ResourceId])
			OUTPUT s.[Index], inserted.[Id] 
	) As x

	SELECT @IndexedIdsJson = (SELECT * FROM @IndexedIds FOR JSON PATH);