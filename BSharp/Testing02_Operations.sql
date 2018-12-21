BEGIN -- Cleanup & Declarations
	DECLARE @O1Save OperationForSaveList, @O2Save OperationForSaveList;
	DECLARE @O1Result [dbo].OperationList, @O2Result [dbo].OperationList;
	DECLARE @O1ResultJson NVARCHAR(MAX), @O2ResultJson NVARCHAR(MAX), @O3ResultJson NVARCHAR(MAX);
	DECLARE @OperationActivationList [dbo].ActivationList;
	DECLARE @Common int, @Existing int, @Expansion int, @ExecutiveOffice int;
END
BEGIN -- Inserting
	INSERT INTO @O1Save
		([Name],				[ParentIndex]) Values
		(N'Walia Steel Industry', NULL),
		(N'Existin',			0),
		(N'Fake',				0),
		(N'Expansion',			0),
		(N'WSI Common',			0),
		(N'Executive Office',	4),
		(N'HR Department',		4),
		(N'MIS Department',		4);

	EXEC [dbo].[api_Operations__Save]
		@Entities = @O1Save,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
		@EntitiesResultJson = @O1ResultJson OUTPUT

	IF @ValidationErrorsJson IS NOT NULL 
	BEGIN
		Print 'Location: Operations 1'
		GOTO Err_Label;
	END

	INSERT INTO @O1Result(
		[Id], [Name], [IsOperatingSegment], [IsActive], [Code], [ParentId],
		[CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy], [EntityState]
	)
	SELECT 
		[Id], [Name], [IsOperatingSegment], [IsActive], [Code], [ParentId],
		[CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy], [EntityState]
	FROM OpenJson(@O1ResultJson)
	WITH (
		[Id] INT '$.Id',
		[Name] NVARCHAR (255) '$.Name',
		[IsOperatingSegment] BIT '$.IsOperatingSegment',
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
		[Id], [Name], [Code], [ParentId], [EntityState]
	)
	SELECT
		[Id], [Name], [Code], [ParentId], N'Unchanged'
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
		@Entities = @O2Save,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
		@EntitiesResultJson = @O2ResultJson OUTPUT

	IF @ValidationErrorsJson IS NOT NULL 
	BEGIN
		Print 'Location: Operations 2'
		GOTO Err_Label;
	END

	INSERT INTO @O2Result(
		[Id], [Name], [IsOperatingSegment], [IsActive], [Code], [ParentId],
		[CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy], [EntityState]
	)
	SELECT 
		[Id], [Name], [IsOperatingSegment], [IsActive], [Code], [ParentId],
		[CreatedAt], [CreatedBy], [ModifiedAt], [ModifiedBy], [EntityState]
	FROM OpenJson(@O2ResultJson)
	WITH (
		[Id] INT '$.Id',
		[Name] NVARCHAR (255) '$.Name',
		[IsOperatingSegment] BIT '$.IsOperatingSegment',
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
EXEC api_Operation__SetOperatingSegment
	@OperationId = 2,
	@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
	@EntitiesResultJson = @O2ResultJson OUTPUT

EXEC api_Operation__SetOperatingSegment
	@OperationId = 1,
	@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
	@EntitiesResultJson = @O2ResultJson OUTPUT

EXEC api_Operation__SetOperatingSegment
	@OperationId = 2,
	@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
	@EntitiesResultJson = @O2ResultJson OUTPUT

IF @LookupsSelect = 1
	SELECT * FROM [dbo].[Operations];

SELECT 
		@Common = (SELECT [Id] FROM @O1Result WHERE [Name] = N'WSI Common'), 
		@Existing = (SELECT [Id] FROM @O1Result WHERE [Name] = N'Existing'),
		@Expansion = (SELECT [Id] FROM @O1Result WHERE [Name] = N'Expansion'),
		@ExecutiveOffice = (SELECT [Id] FROM @O1Result WHERE [Name] = N'Expansion');
	