BEGIN -- Cleanup & Declarations
	DECLARE @O1Save OperationForSaveList, @O2Save OperationForSaveList;
	DECLARE @O1Result [dbo].OperationList, @O2Result [dbo].OperationList;
	DECLARE @O1ResultJson NVARCHAR(MAX), @O2ResultJson NVARCHAR(MAX), @O3ResultJson NVARCHAR(MAX);
	DECLARE @OperationActivationList [dbo].ActivationList;

END
BEGIN -- Inserting
	INSERT INTO @O1Save
		([OperationType], [Name], [ParentIndex]) Values
		(N'BusinessEntity', N'Walia Steel Industry', NULL),
		(N'Investment', N'Existin', 0),
		(N'OperatingSegment', N'Fake', 0),
		(N'Investment', N'Expansion', 0);

	EXEC [dbo].[api_Operations__Save]
		@Operations = @O1Save,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
		@OperationsResultJson = @O1ResultJson OUTPUT

	IF @ValidationErrorsJson IS NOT NULL 
	BEGIN
		Print 'Location: Operations 1'
		GOTO Err_Label;
	END

	INSERT INTO @O1Result(
		[Index], [Id], [OperationType], [Name], [IsActive], [Code], [ParentId],
		[CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy], [EntityState]
	)
	SELECT 
		[Index], [Id], [OperationType], [Name], [IsActive], [Code], [ParentId],
		[CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy], [EntityState]
	FROM OpenJson(@O1ResultJson)
	WITH (
		[Index] INT '$.Index',
		[Id] INT '$.Id',
		[OperationType] NVARCHAR (255) '$.OperationType',
		[Name] NVARCHAR (255) '$.Name',
		[IsActive] BIT '$.IsActive',
		[Code] NVARCHAR (255) '$.Code',
		[ParentId] INT '$.ParentId',
		[CreatedAt] DATETIMEOFFSET(7) '$.CreatedAt',
		[CreatedBy] NVARCHAR(450) '$.CreatedBy',
		[ModifiedAt] DATETIMEOFFSET(7) '$.ModifiedAt',
		[ModifiedBy] NVARCHAR(450) '$.ModifiedBy',
		[EntityState] NVARCHAR(255) '$.EntityState'
	);
END
BEGIN
	INSERT INTO @O2Save (
		[Id], [OperationType], [Name], [Code], [ParentId], [EntityState]
	)
	SELECT
		[Id], [OperationType], [Name], [Code], [ParentId], N'Unchanged'
	FROM [dbo].Operations
	WHERE [Name] IN (N'Existin', N'Fake')

	UPDATE @O2Save 
	SET 
		[Name] = N'Existing',
		[EntityState] = N'Updated'
	WHERE [Name] = N'Existin';

	UPDATE @O2Save 
	SET 
		[EntityState] = N'Deleted'
	WHERE [Name] = N'Fake';

	EXEC [dbo].[api_Operations__Save]
		@Operations = @O2Save,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
		@OperationsResultJson = @O2ResultJson OUTPUT

	IF @ValidationErrorsJson IS NOT NULL 
	BEGIN
		Print 'Location: Operations 2'
		GOTO Err_Label;
	END

	INSERT INTO @O2Result(
		[Index], [Id], [OperationType], [Name], [IsActive], [Code], [ParentId],
		[CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy], [EntityState]
	)
	SELECT 
		[Index], [Id], [OperationType], [Name], [IsActive], [Code], [ParentId],
		[CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy], [EntityState]
	FROM OpenJson(@O2ResultJson)
	WITH (
		[Index] INT '$.Index',
		[Id] INT '$.Id',
		[OperationType] NVARCHAR (255) '$.OperationType',
		[Name] NVARCHAR (255) '$.Name',
		[IsActive] BIT '$.IsActive',
		[Code] NVARCHAR (255) '$.Code',
		[ParentId] INT '$.ParentId',
		[CreatedAt] DATETIMEOFFSET(7) '$.CreatedAt',
		[CreatedBy] NVARCHAR(450) '$.CreatedBy',
		[ModifiedAt] DATETIMEOFFSET(7) '$.ModifiedAt',
		[ModifiedBy] NVARCHAR(450) '$.ModifiedBy',
		[EntityState] NVARCHAR(255) '$.EntityState'
	);
END
IF @LookupsSelect = 1
	SELECT * FROM [dbo].[Operations];

SELECT 
		@BusinessEntity = (SELECT [Id] FROM @O1Result WHERE [Name] = N'Walia Steel Industry'), 
		@Existing = (SELECT [Id] FROM @O1Result WHERE [Name] = N'Existing'),
		@Expansion = (SELECT [Id] FROM @O1Result WHERE [Name] = N'Expansion');
	