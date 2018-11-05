
CREATE PROCEDURE [dbo].[sbs_OrganizationUnit__Insert] 
--	DECLARE @SWDepartment int; EXEC [dbo].[sbs_OrganizationUnit__Insert] @LongName = N'Software Design and Development Department', @ShortName = N'Development', @BirthDateTime = '2017.08.09',  @OrganizationUnit = @SWDepartment OUTPUT
	@LongName nvarchar(255),
	@ShortName nvarchar(50),
	@BirthDateTime datetimeoffset(7) = NULL,
	@DeathDateTime datetimeoffset(7) = NULL,
	@OrganizationUnit int OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRANSACTION

	BEGIN TRY
		DECLARE @Type nvarchar(50)
		SET @Type = N'OrganizationUnit'

		INSERT INTO dbo.Custodies(CustodyType, [Name])
		VALUES(@Type, @ShortName);

		SET @OrganizationUnit = SCOPE_IDENTITY();

		INSERT INTO dbo.Agents(Id, AgentType, LongName, ShortName, BirthDateTime, DeathDateTime)
		VALUES(@OrganizationUnit, @Type, @LongName, @ShortName, @BirthDateTime, @DeathDateTime)

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
