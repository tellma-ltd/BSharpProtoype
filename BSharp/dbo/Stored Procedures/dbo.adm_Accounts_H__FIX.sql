
CREATE PROCEDURE [dbo].[adm_Accounts_H__FIX]
-- With Encryption
AS
Set NoCount On
	Truncate Table [dbo].Accounts_H
	
	Declare @Id nvarchar(255)
	Set @Id = N''

	While Exists(Select * From [dbo].Accounts Where Id > @Id)
	Begin
	-- Go over the records of Accounts one by one to fill Accounts_H properly
		Select @Id = min(Id) From [dbo].Accounts Where Id > @Id
		
		Update [dbo].Accounts
		Set ParentId = ParentId
		Where Id = @Id
	End 
