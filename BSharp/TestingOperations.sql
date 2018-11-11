BEGIN -- Cleanup & Declarations
	SET NOCOUNT ON;
	DELETE FROM dbo.Operations;
	DBCC CHECKIDENT ('dbo.Operations', RESEED, 0) WITH NO_INFOMSGS;

	DECLARE @Operations OperationList, @OperationsResult OperationList;
	DECLARE @BusinessEntity int, @Existing int, @Expansion int;
END
BEGIN -- Inserting
	INSERT INTO @Operations
		([Id], [OperationType], [Name], [Parent]) Values
		(-100, N'BusinessEntity', N'Walia Steel Industry', NULL),
		(-99, N'Investment', N'Existin', -100),
		(-98, N'OperatingSegment', N'Fake', -100),
		(-78, N'Investment', N'Expansion', -100);

	DELETE FROM @OperationsResult; INSERT INTO @OperationsResult([Id], [OperationType], [Name], [Parent], [Status], [TemporaryId])
	EXEC  [dbo].[api_Operations__Save]  @Operations = @Operations; DELETE FROM @Operations WHERE Status IN (N'Inserted', N'Updated', 'Deleted'); INSERT INTO @Operations SELECT * FROM @OperationsResult;
END
BEGIN -- Updating
	UPDATE @Operations 
	SET 
		[Name] = N'Existing',
		Status = N'Updated'
	WHERE [Name] = N'Existin';

	DELETE FROM @OperationsResult; INSERT INTO @OperationsResult([Id], [OperationType], [Name], [Parent], [Status], [TemporaryId])
	EXEC  [dbo].[api_Operations__Save]  @Operations = @Operations; DELETE FROM @Operations WHERE Status IN (N'Inserted', N'Updated', 'Deleted'); INSERT INTO @Operations SELECT * FROM @OperationsResult;
END

BEGIN -- Deleting
	UPDATE @Operations 
	SET 
		Status = N'Deleted'
	WHERE [Name] = N'Fake';

	DELETE FROM @OperationsResult; INSERT INTO @OperationsResult([Id], [OperationType], [Name], [Parent], [Status], [TemporaryId])
	EXEC  [dbo].[api_Operations__Save]  @Operations = @Operations; DELETE FROM @Operations WHERE Status IN (N'Inserted', N'Updated', 'Deleted'); INSERT INTO @Operations SELECT * FROM @OperationsResult;
END	

SELECT * FROM @Operations;
	