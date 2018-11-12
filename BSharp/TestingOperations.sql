BEGIN -- Cleanup & Declarations
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
	WHERE TemporaryId = -99;

	DELETE FROM @OperationsResult; INSERT INTO @OperationsResult([Id], [OperationType], [Name], [Parent], [Status], [TemporaryId])
	EXEC  [dbo].[api_Operations__Save]  @Operations = @Operations; DELETE FROM @Operations WHERE Status IN (N'Inserted', N'Updated', 'Deleted'); INSERT INTO @Operations SELECT * FROM @OperationsResult;
END

BEGIN -- Deleting
	UPDATE @Operations 
	SET 
		Status = N'Deleted'
	WHERE TemporaryId = -98;

	DELETE FROM @OperationsResult; INSERT INTO @OperationsResult([Id], [OperationType], [Name], [Parent], [Status], [TemporaryId])
	EXEC  [dbo].[api_Operations__Save]  @Operations = @Operations; DELETE FROM @Operations WHERE Status IN (N'Inserted', N'Updated', 'Deleted'); INSERT INTO @Operations SELECT * FROM @OperationsResult;
END	

SELECT * FROM @Operations;
SELECT 
		@BusinessEntity = (SELECT [Id] FROM @Operations WHERE [TemporaryId] = -100), 
		@Existing = (SELECT [Id] FROM @Operations WHERE [TemporaryId] = -99),
		@Expansion = (SELECT [Id] FROM @Operations WHERE [TemporaryId] = -78);
	