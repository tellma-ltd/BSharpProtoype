CREATE PROCEDURE [dbo].[api_Operations__Save]
	@Operations [OperationList] READONLY
AS
BEGIN
	DECLARE @IdMappings IdMappingList;
	BEGIN TRANSACTION
		BEGIN TRY

			DELETE FROM dbo.Operations WHERE Id IN (SELECT Id FROM @Operations WHERE Status = N'Deleted');

			INSERT INTO @IdMappings([NewId], [OldId])
			SELECT x.[NewId], x.[OldId]
			FROM
			(
				MERGE INTO dbo.Operations AS t
				USING (
					SELECT [Id], [OperationType], [Name], [Parent]
					FROM @Operations 
					WHERE [Status] IN (N'Inserted', N'Updated')
				) AS s ON t.Id = s.Id
				WHEN MATCHED THEN
					UPDATE SET 
						t.[OperationType] = s.[OperationType],
						t.[Name] = s.[Name],
						t.[Parent] = s.[Parent]
				WHEN NOT MATCHED THEN
					INSERT ([OperationType], [Name])
					VALUES (s.[OperationType], s.[Name])
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
		END TRY

		BEGIN CATCH
			SELECT   /*
			ERROR_NUMBER() AS ErrorNumber  
			,ERROR_SEVERITY() AS ErrorSeverity  
			,ERROR_STATE() AS ErrorState  
			, */ERROR_PROCEDURE() AS ErrorProcedure  
			,ERROR_LINE() AS ErrorLine  
			,ERROR_MESSAGE() AS ErrorMessage; 

			IF @@TRANCOUNT > 0 
			ROLLBACK TRANSACTION;
		END CATCH

	IF @@TRANCOUNT > 0  
    COMMIT TRANSACTION;
	
	SELECT O.[Id], O.[OperationType], O.[Name], O.[Parent], N'Unchanged' As [Status], M.[OldId] As [TemporaryId]
	FROM dbo.Operations O
	LEFT JOIN @IdMappings M ON O.[Id] = M.[NewId]
	WHERE O.[Id] IN (
		SELECT M.[NewId] FROM @Operations A JOIN @IdMappings M ON A.Id = M.OldId WHERE [Status] = N'Inserted'
		UNION ALL
		SELECT Id FROM @Operations WHERE [Status] = N'Updated'
		);
END