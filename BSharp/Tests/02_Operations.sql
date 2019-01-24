BEGIN -- Cleanup & Declarations
	DECLARE @OperationsDTO dbo.[OperationList];
	DECLARE @Unspecified int, @Existing int, @Expansion int;

END
BEGIN -- Inserting
	INSERT INTO @OperationsDTO
		([Name],				[ParentIndex]) Values
		(N'Walia Steel Industry', NULL),
		(N'Existin',			0),
		(N'Fake',				0),
		(N'Expansion',			0),
		(N'Unspecified',		0);

	EXEC [dbo].[api_Operations__Save]
		@Entities = @OperationsDTO,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
		@ResultsJson = @ResultsJson OUTPUT

	IF @ValidationErrorsJson IS NOT NULL 
	BEGIN
		Print 'Place: Operations 1'
		GOTO Err_Label;
	END

	IF @DebugOperations = 1
		SELECT * FROM [dbo].[fr_Operations__Json](@ResultsJson)
END
BEGIN
	DELETE FROM @OperationsDTO;
	INSERT INTO @OperationsDTO (
		[Id], [Name], [Code], [ParentId], [EntityState]
	)
	SELECT
		[Id], [Name], [Code], [ParentId], N'Unchanged'
	FROM [dbo].Operations
	WHERE [Name] IN (N'Existin', N'Fake');

	UPDATE @OperationsDTO 
	SET 
		[Name] = N'Existing',
		[EntityState] = N'Updated'
	WHERE [Name] = N'Existin';

	UPDATE @OperationsDTO 
	SET 
		[EntityState] = N'Deleted'
	WHERE [Name] = N'Fake';

	EXEC [dbo].[api_Operations__Save]
		@Entities = @OperationsDTO,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
		@ResultsJson = @ResultsJson OUTPUT;

	IF @ValidationErrorsJson IS NOT NULL 
	BEGIN
		Print 'Place: Operations 2'
		GOTO Err_Label;
	END
	IF @DebugOperations = 1
		SELECT * FROM [dbo].[fr_Operations__Json](@ResultsJson);
END
	--SELECT * FROM [dbo].[Operations];
EXEC api_Operation__SetOperatingSegment
	@OperationId = 2,
	@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
	@ResultsJson = @ResultsJson OUTPUT;
	IF @DebugOperations = 1
		SELECT * FROM [dbo].[fr_Operations__Json](@ResultsJson);
	--SELECT * FROM [dbo].[Operations];
EXEC api_Operation__SetOperatingSegment
	@OperationId = 1,
	@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
	@ResultsJson = @ResultsJson OUTPUT;
	IF @DebugOperations = 1
		SELECT * FROM [dbo].[fr_Operations__Json](@ResultsJson);
	--SELECT * FROM [dbo].[Operations];
EXEC api_Operation__SetOperatingSegment
	@OperationId = 2,
	@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
	@ResultsJson = @ResultsJson OUTPUT;
	IF @DebugOperations = 1
		SELECT * FROM [dbo].[fr_Operations__Json](@ResultsJson);
	--SELECT * FROM [dbo].[Operations];
IF @DebugOperations = 1
	SELECT * FROM [dbo].[Operations];

SELECT 
	@Unspecified = (SELECT [Id] FROM [dbo].[Operations] WHERE [Name] = N'Unspecified'), 
	@Existing = (SELECT [Id] FROM [dbo].[Operations] WHERE [Name] = N'Existing'),
	@Expansion = (SELECT [Id] FROM [dbo].[Operations] WHERE [Name] = N'Expansion');