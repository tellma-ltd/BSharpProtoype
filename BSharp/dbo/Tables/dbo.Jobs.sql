CREATE TABLE [dbo].[Jobs] (
    [JobId]    INT           NOT NULL,
    [Name]     NVARCHAR (50) NULL,
    [ParentId] INT           NULL,
    PRIMARY KEY CLUSTERED ([JobId] ASC)
);


GO
CREATE TRIGGER [dbo].[trD_Jobs]
ON [dbo].[Jobs]
FOR DELETE 
AS
Set NoCount On
-- When deleting A, ParentID
-- Delete all C, P where C = A or below, and P = ParentID or above
	Delete Jobs_H
	Where (C IN (Select JobID From Deleted) 
		Or C IN (Select C From Jobs_H 
			Where P IN (Select JobID From Deleted)))
	And (P IN (Select ParentID From Deleted) 
		Or P IN (Select P From Jobs_H 
			Where C IN (Select ParentID From Deleted)))

GO
CREATE TRIGGER [dbo].[trI_Jobs]
ON [dbo].[Jobs]
FOR INSERT -- when inserting a child to a parent, add it to table Jobs_H, add also the grandparents
AS
Set NoCount On
	Insert Into Jobs_H -- insert x y where x = A or below and y = parentid and above
	Select T1.C, T2.P From
	(Select JobID As C From Inserted 
	Union 
	Select C From Jobs_H Where C IN (Select JobID From Inserted) 
				OR P IN (Select JobID From Inserted)
	) T1 cross Join	
	(Select ParentID As P From Inserted Where ParentID is Not Null
	Union 
	Select P From Jobs_H Where P IN (Select ParentID From Inserted) 
				OR C IN (Select ParentID From inserted)
	) T2

GO
CREATE TRIGGER [dbo].[trU_Jobs]
ON [dbo].[Jobs]
FOR UPDATE
AS
IF Update(JobID) Or Update(ParentID)
Begin
Set NoCount On
	Delete Jobs_H
	Where (C IN (Select JobID From Deleted) 
		Or C IN (Select C From Jobs_H 
			Where P IN (Select JobID From Deleted)))
	And (P IN (Select ParentID From Deleted) 
		Or P IN (Select P From Jobs_H 
			Where C IN (Select ParentID From Deleted)))

	Insert Into Jobs_H -- insert x y where x = A or below and y = parentid and above
	Select T1.C, T2.P From
	(Select JobID As C From Inserted 
	Union 
	Select C From Jobs_H Where C IN (Select JobID From Inserted) 
				OR P IN (Select JobID From Inserted)
	) T1 cross Join	
	(Select ParentID As P From Inserted Where ParentID is Not Null
	Union 
	Select P From Jobs_H Where P IN (Select ParentID From Inserted) 
				OR C IN (Select ParentID From inserted)
	) T2
Set NoCount Off
End
