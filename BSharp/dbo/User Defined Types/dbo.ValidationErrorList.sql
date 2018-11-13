CREATE TYPE [dbo].[ValidationErrorList] AS TABLE (
    [DocumentId]   INT            NULL,
    [LineId]   INT            NULL,
    [EntryId]  INT            NULL,
    [PropertyName] NVARCHAR (50)  NULL,
    [Message1]     NVARCHAR (255) NULL,
    [Message2]     NVARCHAR (255) NULL);

