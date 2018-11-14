CREATE TYPE [dbo].[ValidationErrorList] AS TABLE (
	[Path]			NVARCHAR (255)  NULL,
    [ErrorMessage]	NVARCHAR (2048) NULL
);
