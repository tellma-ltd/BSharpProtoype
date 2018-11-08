
CREATE PROCEDURE [dbo].[sbs_Resource__Insert] 
	@ResourceType	nvarchar(50),
	@Name	nvarchar(50),
	@Code nvarchar(50) = NULL,
	@UnitOfMeasure nvarchar(5) = NULL,
	@Memo nvarchar(max) = NULL,
	@Lookup1 nvarchar(50) = NULL,
	@Lookup2 nvarchar(50) = NULL,
	@Lookup3 nvarchar(50) = NULL,
	@Lookup4 nvarchar(50) = NULL,
	@GoodForServiceParent int = NULL,
	@FungibleParent int = NULL,
	@Resource int = 0 OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		INSERT INTO dbo.Resources(ResourceType, [Name], Code, UnitOfMeasure, Memo, Lookup1, Lookup2, Lookup3, Lookup4, GoodForServiceParentId, FungibleParentId)
		VALUES(@ResourceType, @Name, @Code, @UnitOfMeasure, @Memo, @Lookup1, @Lookup2, @Lookup3, @Lookup4, @GoodForServiceParent, @FungibleParent)

		SET @Resource = SCOPE_IDENTITY()
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
