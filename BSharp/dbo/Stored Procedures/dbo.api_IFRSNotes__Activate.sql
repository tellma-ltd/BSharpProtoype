﻿CREATE PROCEDURE [dbo].[api_IFRSNotes__Activate]
	@Ids [dbo].[StringList] READONLY,
	@ValidationErrorsJson NVARCHAR(MAX) = NULL OUTPUT,
	@ReturnEntities bit = 1,
	@ResultsJson NVARCHAR(MAX) OUTPUT
AS
SET NOCOUNT ON;
	EXEC [dbo].[dal_IFRSNotes__Activate] @Ids = @Ids, @IsActive = 1;

	IF (@ReturnEntities = 1)
		EXEC [dbo].[dal_IFRSNotes__Select] 
			@Ids = @Ids,
			@ResultsJson = @ResultsJson OUTPUT;