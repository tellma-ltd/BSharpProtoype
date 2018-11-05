
CREATE PROCEDURE [dbo].[sbs_Account__IsActive] --  [dbo].[sbs_Account__IsActive] @Account = N'CashOnHand', @IsActive = 0
	@Account nvarchar(255),
	@IsActive bit
AS
BEGIN
	SET NOCOUNT ON;

	-- If the state is already as desired, ignore
	IF @IsActive = (SELECT IsActive FROM dbo.Accounts WHERE Id = @Account)
		RETURN;

	BEGIN TRANSACTION
	BEGIN TRY
		-- Not sure about this business rule: all related leaves should have zero balance
		IF @IsActive = 0
		BEGIN
			-- deactivate all active descendants
			UPDATE dbo.Accounts
			SET IsActive = @IsActive
			WHERE Code Like (SELECT Code FROM dbo.Accounts WHERE ID = @Account) + N'%' AND IsActive = 1
		END

		IF @IsActive = 1 -- activate all inactive acendants
			UPDATE dbo.Accounts
			SET IsActive = @IsActive
			WHERE Code + '%' Like (SELECT Code FROM dbo.Accounts WHERE ID = @Account)
			AND IsActive = 0
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

