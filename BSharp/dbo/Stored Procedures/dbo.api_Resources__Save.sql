CREATE PROCEDURE [dbo].[api_Resources__Save]
	@Entities [dbo].[ResourceForSaveList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT,
	@ReturnEntities bit = 1,
	@EntitiesResultJson NVARCHAR(MAX) OUTPUT
AS
BEGIN
SET NOCOUNT ON;
DECLARE @IndexedIdsJson NVARCHAR(MAX), @Ids [dbo].[IntegerList];
-- Validate
	EXEC [dbo].[bll_Resources__Validate]
		@Entities = @Entities,
		@ValidationErrorsJson = @ValidationErrorsJson OUTPUT;

	IF @ValidationErrorsJson IS NOT NULL
		RETURN;

	EXEC [dbo].[dal_Resources__Save]
		@Resources = @Entities,
		@IndexedIdsJson = @IndexedIdsJson OUTPUT;

	IF (@ReturnEntities = 1)
	BEGIN
		INSERT INTO @Ids([Id])
		SELECT [Id] 
		FROM OpenJson(@IndexedIdsJson)
		WITH ([Index] INT '$.Index', [Id] INT '$.Id');

		EXEC [dbo].[dal_Resources__Select] 
			@Ids = @Ids, @EntitiesResultJson = @EntitiesResultJson OUTPUT;
	END
END