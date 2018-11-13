CREATE PROCEDURE [dbo].[api_Operations__Save]
	@Operations [OperationList] READONLY
AS
BEGIN
	BEGIN TRY
		DECLARE @IdMappings IdMappingList, @TenantId int;
		SELECT @TenantId = dbo.fn_TenantId();
		IF @TenantId IS NULL
			THROW 50001, N'Tenant Id is NULL', 1;

		BEGIN TRANSACTION
			DELETE FROM dbo.Operations WHERE TenantId = @TenantId AND Id IN (SELECT Id FROM @Operations WHERE Status = N'Deleted');

			INSERT INTO @IdMappings([NewId], [OldId])
			SELECT x.[NewId], x.[OldId]
			FROM
			(
				MERGE INTO dbo.Operations AS t
				USING (
					SELECT @TenantId As [TenantId], [Id], [OperationType], [Name], [Parent]
					FROM @Operations 
					WHERE [Status] IN (N'Inserted', N'Updated')
				) AS s ON t.[TenantId] = s.[TenantId] AND t.Id = s.Id
				WHEN MATCHED THEN
					UPDATE SET 
						t.[OperationType] = s.[OperationType],
						t.[Name] = s.[Name],
						t.[Parent] = s.[Parent]
				WHEN NOT MATCHED THEN
					INSERT ([TenantId], [OperationType], [Name])
					VALUES (@TenantId, s.[OperationType], s.[Name])
				--WHEN NOT MATCHED BY SOURCE THEN 
				--	DELETE
				OUTPUT inserted.[Id] As [NewId], s.[Id] As [OldId]
			) AS x;
			PRINT N'Parent Id in table Operations is lost. Additional code is needed to fix it. Will be fixed once we agree it is necessary'
			/*
			UPDATE O
			SET O.[Parent] = 
			FROM dbo.Operations O 
			JOIN @Operations OL ON O.Id = OL.Parent
			JOIN @IdMappings M ON OL.Id = M.OldId
			JOIN dbo.Operations O2 ON M.NewId = O2.Id
			*/
		COMMIT TRANSACTION;
	END TRY

	BEGIN CATCH
		EXEC dbo.Error__Log;
		THROW;
	END CATCH
	
	SELECT O.[Id], O.[OperationType], O.[Name], O.[Parent], N'Unchanged' As [Status], M.[OldId] As [TemporaryId]
	FROM dbo.Operations O
	LEFT JOIN @IdMappings M ON O.[Id] = M.[NewId]
	WHERE O.[TenantId] = @TenantId
	AND O.[Id] IN (
		SELECT M.[NewId] FROM @Operations A JOIN @IdMappings M ON A.Id = M.OldId WHERE [Status] = N'Inserted'
		UNION ALL
		SELECT Id FROM @Operations WHERE [Status] = N'Updated'
		);
END