CREATE View [dbo].[DocumentsView]
AS
	SELECT D.Id, 
	D.[State], D.[TransactionType], 
	RIGHT(N'00000' + CAST(D.SerialNumber AS nvarchar(50)), 3) As [Serial Number], 
	D.Mode,
	U.FriendlyName As [Forwarded To]
	FROM dbo.Documents D
	LEFT JOIN dbo.Users U ON D.ForwardedToUserId = U.Id


