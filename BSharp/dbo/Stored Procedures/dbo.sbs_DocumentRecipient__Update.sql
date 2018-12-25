CREATE PROCEDURE [dbo].[sbs_DocumentRecipient__Update] 
	@Id int,
	@ForwardedTo int,
	@Comment nvarchar(255)
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE [dbo].[Documents]
	SET [ForwardedToAgentId] = @ForwardedTo
	WHERE [Id]= @Id
END