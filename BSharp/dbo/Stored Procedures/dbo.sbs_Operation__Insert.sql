
CREATE PROCEDURE [dbo].[sbs_Operation__Insert] 
/*
	DECLARE @Sesay int; EXEC [dbo].[sbs_Operation__Insert] @OperationType = N'BusinessEntity', @Name = N'Sesay Tesfay', @Operation = @Sesay OUTPUT;
	DECLARE @Plastic int; EXEC  [dbo].[sbs_Operation__Insert] @OperationType = N'OperatingSegment', @Name = N'Best Plastic', @Parent = @Sesay, @Operation = @Plastic OUTPUT;
	DECLARE @Paint int; EXEC  [dbo].[sbs_Operation__Insert] @OperationType = N'OperatingSegment', @Name = N'Best Paint', @Parent = @Sesay, @Operation = @Plastic OUTPUT;
	SELECT * FROM dbo.Operations;
	*/
	@OperationType nvarchar(50),
	@Name nvarchar(50),
	@Parent int = NULL,
	@Operation int OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		INSERT INTO dbo.Operations(OperationType, Name,Parent)
		VALUES(@OperationType, @Name, @Parent)

		SET @Operation = SCOPE_IDENTITY();
	END TRY

	BEGIN CATCH
	    SELECT   /*
        ERROR_NUMBER() AS ErrorNumber  
        ,ERROR_SEVERITY() AS ErrorSeverity  
        ,ERROR_STATE() AS ErrorState  
        , */ERROR_PROCEDURE() AS ErrorProcedure  
        ,ERROR_LINE() AS ErrorLine  
        ,ERROR_MESSAGE() AS ErrorMessage; 
	END CATCH
END
