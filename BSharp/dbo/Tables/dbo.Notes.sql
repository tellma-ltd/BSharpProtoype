CREATE TABLE [dbo].[Notes] (
    [Id]           NVARCHAR (255)  NOT NULL,
    [Name]         NVARCHAR (1024) NOT NULL,
    [Code]         NVARCHAR (10)   NOT NULL,
    [IsActive]     BIT             NOT NULL,
    [ParentId]     NVARCHAR (255)  NULL,
    [NoteType]     NVARCHAR (50)   CONSTRAINT [DF_Notes_NoteType] DEFAULT (N'Custom') NOT NULL,
    [IsExtensible] BIT             CONSTRAINT [DF_Notes_IsExtensible] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Notes] PRIMARY KEY NONCLUSTERED ([Id] ASC)
);


GO
CREATE CLUSTERED INDEX [IX_Notes_Code]
    ON [dbo].[Notes]([Code] ASC);

