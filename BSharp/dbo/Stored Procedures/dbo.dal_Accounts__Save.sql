CREATE PROCEDURE [dbo].[dal_Accounts__Save]
	@Entities [AccountList] READONLY,
	@IndexedIdsJson NVARCHAR(MAX) OUTPUT
AS
SET NOCOUNT ON;
	DECLARE @IndexedIds [dbo].[IndexedIdList];
	DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();
	DECLARE @UserId INT = CONVERT(INT, SESSION_CONTEXT(N'UserId'));

-- Deletions, if already user, we should deactivate instead
	DELETE FROM [dbo].Accounts
	WHERE [Id] IN (SELECT [Id] FROM @Entities WHERE [EntityState] = N'Deleted');

	INSERT INTO @IndexedIds([Index], [Id])
	SELECT x.[Index], x.[Id]
	FROM
	(
		MERGE INTO [dbo].Accounts AS t
		USING (
			SELECT
				[Index], [Id], [Node], [IFRSAccountId], [IsAggregate],
				[Name], [Name2], [Name3], [Code], [IFRSNoteId], [ResponsibilityCenterIsFixed],
				[ResponsibilityCenterId], [AgentAccountIsFixed], [AgentAccountId],
				[ResourceIsFixed], [ResourceId], [ExpectedSettlingDateIsFixed], [ExpectedSettlingDate]
			FROM @Entities 
			WHERE [EntityState] IN (N'Inserted', N'Updated')
		) AS s ON (t.Id = s.Id)
		WHEN MATCHED 
		THEN
			UPDATE SET
				t.[Node]						= s.[Node], 
				t.[IFRSAccountId]				= s.[IFRSAccountId],
				t.[IsAggregate]					= s.[IsAggregate],
				t.[Name]						= s.[Name],
				t.[Name2]						= s.[Name2],
				t.[Name3]						= s.[Name3],
				t.[Code]						= s.[Code],
				t.[IFRSNoteId]					= s.[IFRSNoteId],
				t.[ResponsibilityCenterIsFixed] = s.[ResponsibilityCenterIsFixed],
				t.[ResponsibilityCenterId]		= s.[ResponsibilityCenterId],
				t.[AgentAccountIsFixed]			= s.[AgentAccountIsFixed],
				t.[AgentAccountId]				= s.[AgentAccountId],
				t.[ResourceIsFixed]				= s.[ResourceIsFixed],
				t.[ResourceId]					= s.[ResourceId],
				t.[ExpectedSettlingDateIsFixed] = s.[ExpectedSettlingDateIsFixed],
				t.[ExpectedSettlingDate]		= s.[ExpectedSettlingDate],

				t.[ModifiedAt]		= @Now,
				t.[ModifiedById]	= @UserId
		WHEN NOT MATCHED THEN
			INSERT ([Node], [IFRSAccountId], [IsAggregate],
				[Name], [Name2], [Name3], [Code], [IFRSNoteId], [ResponsibilityCenterIsFixed],
				[ResponsibilityCenterId], [AgentAccountIsFixed], [AgentAccountId],
				[ResourceIsFixed], [ResourceId], [ExpectedSettlingDateIsFixed], [ExpectedSettlingDate])
			VALUES (s.[Node], s.[IFRSAccountId], s.[IsAggregate],
				s.[Name], s.[Name2], s.[Name3], s.[Code], s.[IFRSNoteId], s.[ResponsibilityCenterIsFixed],
				s.[ResponsibilityCenterId], s.[AgentAccountIsFixed], s.[AgentAccountId],
				s.[ResourceIsFixed], s.[ResourceId], s.[ExpectedSettlingDateIsFixed], s.[ExpectedSettlingDate])
			OUTPUT s.[Index], inserted.[Id] 
	) As x

	SELECT @IndexedIdsJson = (SELECT * FROM @IndexedIds FOR JSON PATH);