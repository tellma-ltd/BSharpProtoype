CREATE PROCEDURE [dbo].[api_Operation__SetOperatingSegment]
	@OperationId INT,
	@ValidationErrorsJson NVARCHAR(MAX) OUTPUT,
	@ReturnEntities bit = 1,
	@EntitiesResultJson NVARCHAR(MAX) OUTPUT
AS
BEGIN
SET NOCOUNT ON;
DECLARE @Id int, @Ids [dbo].[IntegerList];
-- Validate
	--EXEC [dbo].[bll_Operation_SetOperatingSegment__Validate]
	--	@Entity = @OperationId,
	--	@ValidationErrorsJson = @ValidationErrorsJson OUTPUT;

	--IF @ValidationErrorsJson IS NOT NULL
	--	RETURN;

	SET @Id = dbo.fn_Operation__FirstSibling(@OperationId)

	-- run it recusrivsely
	EXEC [dbo].[dal_Operation__SetOperatingSegment]
			@OperationId = @Id;

	IF (@ReturnEntities = 1)
	BEGIN
		INSERT INTO @Ids([Id])
		SELECT [Id] FROM dbo.Operations;

		EXEC [dbo].[dal_Operations__Select] 
			@EntitiesResultJson = @EntitiesResultJson OUTPUT;
	END
END;	