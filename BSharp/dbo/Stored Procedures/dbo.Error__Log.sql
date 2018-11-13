CREATE PROCEDURE [dbo].[Error__Log]
AS
INSERT INTO dbo.Errors([ErrorLine], [ErrorMessage], [ErrorNumber], [ErrorProcedure],	[ErrorSeverity], [ErrorState])
SELECT ERROR_LINE(), ERROR_MESSAGE(), ERROR_NUMBER(), ERROR_PROCEDURE(),ERROR_SEVERITY(),  ERROR_STATE()
