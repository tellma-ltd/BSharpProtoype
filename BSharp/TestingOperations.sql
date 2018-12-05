BEGIN -- Cleanup & Declarations
	DECLARE @Operations OperationList, @OperationsResult OperationList;
	DECLARE @BusinessEntity int, @Existing int, @Expansion int;
END
BEGIN -- Inserting
	INSERT INTO @Operations
		([Id], [TemporaryId], [OperationType], [Name], [ParentId]) Values
		(-100, -100,		 N'BusinessEntity', N'Walia Steel Industry', NULL),
		(-99, -99,			N'Investment', N'Existin', -100),
		(-98, -98,			N'OperatingSegment', N'Fake', -100),
		(-78, -78,			N'Investment', N'Expansion', -100);

	DELETE FROM @OperationsResult; INSERT INTO @OperationsResult([Id], [OperationType], [Name], [ParentId], [EntityState], [TemporaryId])
	EXEC  [dbo].[api_Operations__Save]  @Operations = @Operations; DELETE FROM @Operations WHERE [EntityState] IN (N'Inserted', N'Updated', 'Deleted'); INSERT INTO @Operations SELECT * FROM @OperationsResult;
END
BEGIN -- Updating
	UPDATE @Operations 
	SET 
		[Name] = N'Existing',
		[EntityState] = N'Updated'
	WHERE [Name] = N'Existin';

	DELETE FROM @OperationsResult; INSERT INTO @OperationsResult([Id], [OperationType], [Name], [ParentId], [EntityState], [TemporaryId])
	EXEC  [dbo].[api_Operations__Save]  @Operations = @Operations; DELETE FROM @Operations WHERE [EntityState] IN (N'Inserted', N'Updated', 'Deleted'); INSERT INTO @Operations SELECT * FROM @OperationsResult;
END

BEGIN -- Deleting
	UPDATE @Operations 
	SET 
		[EntityState] = N'Deleted'
	WHERE TemporaryId = -98;

	DELETE FROM @OperationsResult; INSERT INTO @OperationsResult([Id], [OperationType], [Name], [ParentId], [EntityState], [TemporaryId])
	EXEC  [dbo].[api_Operations__Save]  @Operations = @Operations; DELETE FROM @Operations WHERE [EntityState] IN (N'Inserted', N'Updated', 'Deleted'); INSERT INTO @Operations SELECT * FROM @OperationsResult;
END	

--SELECT * FROM @Operations;
SELECT 
		@BusinessEntity = (SELECT [Id] FROM @Operations WHERE [Name] = N'Walia Steel Industry'), 
		@Existing = (SELECT [Id] FROM @Operations WHERE [Name] = N'Existing'),
		@Expansion = (SELECT [Id] FROM @Operations WHERE [Name] = N'Expansion');
	