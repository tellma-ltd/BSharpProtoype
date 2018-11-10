/*
CREATE TABLE [dbo].[DocumentTypes] (
    [TransactionType] NVARCHAR (50) NOT NULL,
    [State]    NVARCHAR (10) NOT NULL,
    [NameKey]     NVARCHAR (50) NULL,
    CONSTRAINT [PK_DocumentTypes] PRIMARY KEY CLUSTERED ([TransactionType] ASC, [State] ASC),
    CONSTRAINT [FK_DocumentTypes_TransactionTypes] FOREIGN KEY ([TransactionType]) REFERENCES [dbo].[TransactionTypes] ([Id]) ON UPDATE CASCADE,
	CONSTRAINT [CK_DocumentTypes_State] CHECK ([State] IN (N'Event', N'Order', N'Plan', N'Request', N'Template'))
);
*/

