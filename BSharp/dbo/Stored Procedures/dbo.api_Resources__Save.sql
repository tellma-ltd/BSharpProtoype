CREATE PROCEDURE [dbo].[api_Resources__Save]
	@Entities [dbo].[ResourceList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT,
	@ReturnEntities bit = 1,
	@ResultsJson NVARCHAR(MAX) OUTPUT
AS
BEGIN
SET NOCOUNT ON;
DECLARE @IndexedIdsJson NVARCHAR(MAX), @Ids [dbo].[IdList];
-- Validate
	EXEC [dbo].[bll_Resources_Validate__Save]
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
		FROM OpenJson(@IndexedIdsJson) WITH ([Index] INT, [Id] INT);

		EXEC [dbo].[dal_Resources__Select] 
			@Ids = @Ids, @ResultsJson = @ResultsJson OUTPUT;
	END
END;