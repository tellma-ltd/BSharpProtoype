BEGIN -- Cleanup & Declarations
	DECLARE @ProductCategoriesDTO [dbo].ProductCategoryList;
	/*
		[Index]				INT,				--IDENTITY(1, 1),
	[Id]				INT,
	[Node]				HIERARCHYID, -- filled on the server
	[ParentNode]		HIERARCHYID, -- filled on the server
	[Name]				NVARCHAR (255)	NOT NULL,
	[ParentIndex]		INT,
	[ParentId]			INT,
	[Code]				NVARCHAR (255),*/
END
BEGIN -- Inserting
	INSERT INTO @ProductCategoriesDTO (
	[Index], [Name],					[ParentIndex], [Code]) VALUES
	(1, N'Hollow Section Product',		NULL,			N'1'),
	(2, N'Circular Hollow Section',		1,				N'11'),
	(3, N'Rectangular Hollow Section',	1,				N'12'),
	(4, N'Square Hollow Section',		1,				N'13'),
	(6, N'LTZ Products',				NULL,			N'2'),
	(7, N'L Bars',						6,				N'21'),
	(8, N'T Bars',						6,				N'22'),
	(9, N'Z Bars',						6,				N'23'),
	(10, N'Sheet Metals',				NULL,			N'3')
	;

	EXEC [dbo].[api_ProductCategories__Save]
		@Entities = @ProductCategoriesDTO,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
		@ResultsJson = @ResultsJson OUTPUT

	IF @ValidationErrorsJson IS NOT NULL 
	BEGIN
		Print 'ProductCategories: Place 1'
		GOTO Err_Label;
	END

	select *, [Node].ToString() As NodePath, [ParentNode].ToString() As ParentNodePath from ProductCategories;
	DECLARE @Entities [IndexedIdList];
	INSERT INTO @Entities([Index], [Id]) VALUES
	(2,2);

	WITH DeletedSet AS
	(
		SELECT E.[Index], T.[Node], T.[ParentNode]
		FROM dbo.ProductCategories T 
		JOIN @Entities E ON T.[Id] = E.[Id]
	)
--	INSERT INTO @ValidationErrors([Key], [ErrorName], [Argument1])
    SELECT DISTINCT '[' + CAST(S.[Index] AS NVARCHAR (255)) + '].Id' As [Key], N'Error_CannotDeleteNodeWithCHildren' As [ErrorName], NULL As [Argument1]
	FROM [dbo].[ProductCategories] T -- get me every node in the table
	JOIN DeletedSet S ON T.[ParentNode] = S.[Node] -- whose parent is to be deleted
	WHERE T.[Node] NOT IN (SELECT [Node] FROM DeletedSet) -- but it is not going to be deleted;

	--IF @DebugProductCategories = 1
	--	SELECT * FROM dbo.[fr_ProductCategories__Json](@ResultsJson);
END
/*
-- Display units whose code starts with m
DELETE FROM @ProductCategoriesDTO;
INSERT INTO @ProductCategoriesDTO ([Id], [Code], [UnitType], [Name], [Description], [UnitAmount], [BaseAmount], [EntityState])
SELECT [Id], [Code], [UnitType], [Name], [Description], [UnitAmount], [BaseAmount], N'Unchanged'
FROM [dbo].ProductCategories
WHERE [Name] Like 'm%';

-- Inserting
DECLARE @TestingValidation bit = 0
IF (@TestingValidation = 1)
INSERT INTO @ProductCategoriesDTO
	([Name], [UnitType], [Description], [UnitAmount], [BaseAmount], [Code]) Values
	(N'AED', N'Money', N'AE Dirhams', 3.67, 1, N'AED'),
	(N'c', N'Time', N'Century', 1, 3110400000, NULL),
	(N'dozen', N'Count', N'Dazzina', 1, 12, NULL);
-- Updating
UPDATE @ProductCategoriesDTO 
SET 
--	[Name] = N'pcs',
	[Description] = N'Metric Ton',
	[EntityState] = N'Updated'
WHERE [Name] = N'mt';

-- Deleting
UPDATE @ProductCategoriesDTO 
SET 
	[EntityState] = N'Deleted'
WHERE [Name] = N'min';-- Deleting the minute

-- Calling Save API
EXEC [dbo].[api_ProductCategories__Save]
	@Entities = @ProductCategoriesDTO,
	@ValidationErrorsJson = @ValidationErrorsJson OUTPUT,
	@ResultsJson = @ResultsJson OUTPUT

IF @ValidationErrorsJson IS NOT NULL
BEGIN
	Print 'ProductCategories: Place 2'
	GOTO Err_Label;
END

IF @DebugProductCategories = 1
	SELECT * FROM dbo.[fr_ProductCategories__Json](@ResultsJson);

IF @DebugProductCategories = 1
	SELECT * FROM [dbo].ProductCategories;

SELECT
	@ETBUnit = (SELECT [Id] FROM [dbo].ProductCategories	WHERE [Name] = N'ETB'),
	@USDUnit = (SELECT [Id] FROM [dbo].ProductCategories	WHERE [Name] = N'USD'),
	@KgUnit = (SELECT [Id] FROM [dbo].ProductCategories	WHERE [Name] = N'Kg'),
	@pcsUnit = (SELECT [Id] FROM [dbo].ProductCategories	WHERE [Name] = N'pcs'),
	@eaUnit = (SELECT [Id] FROM [dbo].ProductCategories	WHERE [Name] = N'ea'),
	@shareUnit = (SELECT [Id] FROM [dbo].ProductCategories WHERE [Name] = N'share'),
	@wmoUnit = (SELECT [Id] FROM [dbo].ProductCategories	WHERE [Name] = N'wmo'),
	@hrUnit = (SELECT [Id] FROM [dbo].ProductCategories	WHERE [Name] = N'hr'),
	@yrUnit = (SELECT [Id] FROM [dbo].ProductCategories	WHERE [Name] = N'yr'),
	@dayUnit = (SELECT [Id] FROM [dbo].ProductCategories	WHERE [Name] = N'd'),
	@moUnit = (SELECT [Id] FROM [dbo].ProductCategories	WHERE [Name] = N'mo');
*/