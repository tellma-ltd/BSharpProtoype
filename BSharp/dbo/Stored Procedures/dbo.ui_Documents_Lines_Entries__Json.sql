CREATE PROCEDURE [dbo].[ui_Documents_Lines_Entries__Json]
	@Json NVARCHAR(MAX)
AS
	SELECT * FROM [dbo].[fw_Documents__Json] (@Json)
	SELECT * FROM [dbo].[fw_Lines__Json] (@Json)
	SELECT * FROM [dbo].[fw_Entries__Json] (@Json)
RETURN 0;