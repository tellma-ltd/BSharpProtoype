CREATE TABLE [dbo].[Settings] (
    [Field] NVARCHAR (255)  NOT NULL,
    [Value] NVARCHAR (1024) NOT NULL,
    CONSTRAINT [PK_Settings] PRIMARY KEY CLUSTERED ([Field] ASC)
);

