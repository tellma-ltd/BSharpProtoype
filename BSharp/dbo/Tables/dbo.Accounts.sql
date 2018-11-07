CREATE TABLE [dbo].[Accounts] (
    [Id]              NVARCHAR (255)  NOT NULL,
    [Name]            NVARCHAR (1024) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [Code]            NVARCHAR (10)   COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
    [IsActive]        BIT             NOT NULL,
    [ParentId]        NVARCHAR (255)  NULL,
    [AccountType]     NVARCHAR (10)   CONSTRAINT [DF_Accounts_AccountType] DEFAULT (N'Custom') NOT NULL,
    [AccountSpecification] NVARCHAR (50)   CONSTRAINT [DF_Accounts_AccountTemplate] DEFAULT (N'Basic') NOT NULL,
    [IsExtensible]    BIT             CONSTRAINT [DF_Accounts_IsExtensible] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_Accounts_1] PRIMARY KEY NONCLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Accounts_Accounts] FOREIGN KEY ([ParentId]) REFERENCES [dbo].[Accounts] ([Id])
);


GO
CREATE UNIQUE CLUSTERED INDEX [IX_Accounts__Code]
    ON [dbo].[Accounts]([Code] ASC);


GO
CREATE TRIGGER [dbo].[trD_Accounts]
ON [dbo].[Accounts]
FOR DELETE 
AS
Set NoCount On
-- When deleting A, ParentID
-- Delete all C, P where C = A or below, and P = ParentID or above
	Delete Accounts_H
	Where (C IN (Select Id From Deleted) 
		Or C IN (Select C From Accounts_H 
			Where P IN (Select Id From Deleted)))
	And (P IN (Select ParentId From Deleted) 
		Or P IN (Select P From Accounts_H 
			Where C IN (Select ParentId From Deleted)))

GO
CREATE TRIGGER [dbo].[trI_Accounts]
ON [dbo].[Accounts]
FOR INSERT -- when inserting a child to a parent, add it to table Accounts_H, add also the grandparents
AS
Set NoCount On
	Insert Into Accounts_H -- insert x y where x = A or below and y = parentid and above
	Select T1.C, T2.P From
	(Select Id As C From Inserted 
	Union 
	Select C From Accounts_H Where C IN (Select Id From Inserted) 
				OR P IN (Select Id From Inserted)
	) T1 cross Join	
	(Select ParentId As P From Inserted Where ParentId is Not Null
	Union 
	Select P From Accounts_H Where P IN (Select ParentId From Inserted) 
				OR C IN (Select ParentId From inserted)
	) T2

GO
CREATE TRIGGER [dbo].[trU_Accounts]
ON [dbo].[Accounts]
FOR UPDATE
AS
IF Update(Id) Or Update(ParentId)
Begin
Set NoCount On
	Delete Accounts_H
	Where (C IN (Select Id From Deleted) 
		Or C IN (Select C From Accounts_H 
			Where P IN (Select Id From Deleted)))
	And (P IN (Select ParentId From Deleted) 
		Or P IN (Select P From Accounts_H 
			Where C IN (Select ParentId From Deleted)))

	Insert Into Accounts_H -- insert x y where x = A or below and y = parentid and above
	Select T1.C, T2.P From
	(Select Id As C From Inserted 
	Union 
	Select C From Accounts_H Where C IN (Select Id From Inserted) 
				OR P IN (Select Id From Inserted)
	) T1 cross Join	
	(Select ParentId As P From Inserted Where ParentId is Not Null
	Union 
	Select P From Accounts_H Where P IN (Select ParentId From Inserted) 
				OR C IN (Select ParentId From inserted)
	) T2
Set NoCount Off
End