
CREATE PROCEDURE [dbo].[sbs_OrganizationUnit__Insert] 
--	DECLARE @SWDepartment int; EXEC [dbo].[sbs_OrganizationUnit__Insert] @LongName = N'Software Design and Development Department', @ShortName = N'Development', @BirthDateTime = '2017.08.09',  @OrganizationUnit = @SWDepartment OUTPUT
	@Name nvarchar(50),
	@BirthDateTime datetimeoffset(7) = NULL,
	@IsActive bit = 1,
	@OrganizationUnit int OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRANSACTION

	BEGIN TRY
		DECLARE @Type nvarchar(50)
		SET @Type = N'OrganizationUnit'

		INSERT INTO dbo.Custodies(CustodyType, [Name], IsActive)
		VALUES(@Type, @Name, @IsActive);

		SET @OrganizationUnit = SCOPE_IDENTITY();

		INSERT INTO dbo.Agents(Id, AgentType, BirthDateTime)
		VALUES(@OrganizationUnit, @Type, @BirthDateTime)

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
