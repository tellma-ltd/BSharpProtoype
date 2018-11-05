
CREATE PROCEDURE [dbo].[sbs_Individual__Insert] 
-- DECLARE @MohamadAkra int; EXEC  [dbo].[sbs_Individual__Insert] @LegalName = N'Mohamad Akra', @NickName = N'Mohamad Akra', @DateOfBirth = '1966.02.19', @Email = N'mohamad.akra@banan-it.com, m_akra@yahoo.com, makra1966@gmail.com', @Title = N'Dr.',  @Gender = 'M', @Individual = @MohamadAkra OUTPUT
	@LongName nvarchar(255),
	@ShortName nvarchar(50),
	@BirthDateTime datetimeoffset(7) = NULL,
	@DeathDateTime datetimeoffset(7) = NULL,
	@TaxIdentificationNumber nvarchar(50) = NULL,
	@UserId nvarchar(450) = NULL,
	@RegisteredAddress nvarchar(255) = NULL,
	@Gender char(1),
	@Title nvarchar(50) = NULL,
	@Individual int OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRANSACTION

	BEGIN TRY
		DECLARE @Type nvarchar(50)
		SET @Type = N'Individual'

		INSERT INTO dbo.Custodies(CustodyType, [Name])
		VALUES(@Type, @ShortName);

		SET @Individual = SCOPE_IDENTITY();

		INSERT INTO dbo.Agents(Id, AgentType, LongName, ShortName, BirthDateTime, DeathDateTime, TaxIdentificationNumber, UserId, RegisteredAddress, Title, Gender)
		VALUES(@Individual, @Type, @LongName, @ShortName, @BirthDateTime, @DeathDateTime, @TaxIdentificationNumber, @UserId, @RegisteredAddress, @Title, @Gender)

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
