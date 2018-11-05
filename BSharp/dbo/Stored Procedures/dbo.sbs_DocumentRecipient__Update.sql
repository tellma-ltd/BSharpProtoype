
CREATE PROCEDURE [dbo].[sbs_DocumentRecipient__Update] 
	@Id int,
	@ForwardedTo nvarchar(450),
	@Comment nvarchar(255)
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE dbo.Documents
	SET ForwardedToUserId = @ForwardedTo
	WHERE Id = @Id
END

