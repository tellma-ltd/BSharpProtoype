
CREATE PROCEDURE [dbo].[sbs_Warehouse__Insert] 
--	DECLARE @SparePartsWarehouse int; EXEC [dbo].[sbs_Warehouse__Insert] @@Name = N'Spare Parts Warehouse', @ShortName = N'Spare Parts Warehouse', @Warehouse = @SparePartsWarehouse OUTPUT
	@Name nvarchar(50),
	@Address nvarchar(255) = NULL,
	@Warehouse int OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRANSACTION

	BEGIN TRY
		DECLARE @Type nvarchar(50);
		SET @Type = N'Warehouse'

		INSERT INTO dbo.Custodies(CustodyType, [Name])
		VALUES(@Type, @Name);

		SET @Warehouse = SCOPE_IDENTITY();

		INSERT INTO dbo.Locations(Id, LocationType, [Address])
		VALUES(@Warehouse, @Type, @Address)
	END TRY

	BEGIN CATCH
	    SELECT   /*
        ERROR_NUMBER() AS ErrorNumber  
        ,ERROR_SEVERITY() AS ErrorSeverity  
        ,ERROR_STATE() AS ErrorState  
        , */ERROR_PROCEDURE() AS ErrorProcedure  
        ,ERROR_LINE() AS ErrorLine  
        ,ERROR_MESSAGE() AS ErrorMessage; 

		IF @@TRANCOUNT > 0 
        ROLLBACK TRANSACTION;
	END CATCH

	IF @@TRANCOUNT > 0  
    COMMIT TRANSACTION; 
END
