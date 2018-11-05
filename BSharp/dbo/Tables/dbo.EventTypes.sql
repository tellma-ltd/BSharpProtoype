CREATE TABLE [dbo].[EventTypes] (
    [LineType] NVARCHAR (50) NOT NULL,
    [State]    NVARCHAR (10) NOT NULL,
    [Name]     NVARCHAR (50) NULL,
    CONSTRAINT [PK_EventTypes] PRIMARY KEY CLUSTERED ([LineType] ASC, [State] ASC),
    CONSTRAINT [FK_EventTypes_LineTypes] FOREIGN KEY ([LineType]) REFERENCES [dbo].[LineTypes] ([Id]) ON UPDATE CASCADE,
    CONSTRAINT [FK_EventTypes_States] FOREIGN KEY ([State]) REFERENCES [dbo].[States] ([Id])
);

