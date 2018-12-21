CREATE PROCEDURE [dbo].[dal_Operation__SetOperatingSegment]
	@OperationId int
AS
	DECLARE @Id int, @Ids [dbo].[IntegerList], @NextIds [dbo].[IntegerList];
	DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();
	DECLARE @UserId NVARCHAR(450) = CONVERT(NVARCHAR(450), SESSION_CONTEXT(N'UserId'));

	UPDATE dbo.Operations
	SET
		[IsOperatingSegment] = 1,
		[ModifiedAt] = @Now,
		[ModifiedBy] = @UserId
	WHERE [Id] = @OperationId
	AND [IsOperatingSegment] = 0;

-- Reset all ancestors up to the root
	DECLARE @ParentId int
	SELECT @ParentId = ParentId
	FROM dbo.Operations
	WHERE Id = @OperationId

	WHILE @ParentId IS NOT NULL
	BEGIN
		UPDATE dbo.Operations
		SET
			[IsOperatingSegment] = 0,
			[ModifiedAt] = @Now,
			[ModifiedBy] = @UserId
		WHERE [Id] = @ParentId
		AND [IsOperatingSegment] = 1;

		SELECT @ParentId = ParentId
		FROM dbo.Operations
		WHERE Id = @ParentId
	END

-- Reset all children
	INSERT INTO @Ids([Id])
	SELECT [Id] FROM dbo.Operations
	WHERE ParentId = @OperationId;

	WHILE EXISTS (SELECT * FROM @Ids)
	BEGIN
		UPDATE dbo.Operations
		SET 
			[IsOperatingSegment] = 0,
			[ModifiedAt] = @Now,
			[ModifiedBy] = @UserId
		WHERE [IsOperatingSegment] = 1
		AND Id IN (SELECT [Id] FROM @Ids)
	
		DELETE FROM @NextIds;

		INSERT INTO @NextIds([Id])
		SELECT [Id] FROM @Ids;

		DELETE FROM @Ids;

		INSERT INTO @Ids
		SELECT [Id] FROM dbo.Operations
		WHERE [ParentId] IN (SELECT [Id] FROM @NextIds);
	END;

	DELETE FROM @Ids;

	IF (
		SELECT ParentId 
		FROM dbo.Operations 
		WHERE [Id] = @OperationId
	) IS NULL
		INSERT INTO @Ids
		SELECT [Id] FROM dbo.Operations
		WHERE ParentId IS NULL
		AND [Id] > @OperationId
	ELSE
		INSERT INTO @Ids
		SELECT [Id] FROM dbo.Operations
		WHERE ParentId = (
			SELECT ParentId 
			FROM dbo.Operations 
			WHERE [Id] = @OperationId
		)
		AND [Id] > @OperationId;
	
	-- Set all older siblings as operating segments, recursively!
	WHILE EXISTS(SELECT * FROM @Ids)
	BEGIN
		SELECT @Id = MIN([Id]) FROM @Ids;
		EXEC [dbo].[dal_Operation__SetOperatingSegment] @OperationId = @Id;
		DELETE FROM @Ids WHERE [Id] = @Id;
	END