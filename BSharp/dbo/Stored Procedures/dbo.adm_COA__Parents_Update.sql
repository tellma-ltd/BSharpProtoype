
CREATE PROCEDURE [dbo].[adm_COA__Parents_Update]
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE dbo.Accounts Set ParentId = NULL WHERE ParentId IS NOT NULL -- And Tenant = 0;
	
	DECLARE @i INT = 1
	WHILE @i < 15
	BEGIN
		UPDATE AC
		SET AC.ParentId = AP.Id
		FROM dbo.Accounts AC JOIN dbo.Accounts AP
		ON AC.Code LIKE AP.Code + '%' AND AC.Code <> AP.Code
		WHERE LEN(AP.Code) = @i
		SET @i = @i + 1
	END

	UPDATE dbo.Notes Set ParentId = NULL WHERE ParentId IS NOT NULL -- And Tenant = 0;
	
	--DECLARE @i int = 1
	SET @i = 1
	WHILE @i < 15
	BEGIN
		UPDATE NC
		SET NC.ParentId = NP.Id
		FROM dbo.Notes NC JOIN dbo.Notes NP
		ON NC.Code LIKE NP.Code + '%' AND NC.Code <> NP.Code
		WHERE LEN(NP.Code) = @i
		SET @i = @i + 1
	END

	DECLARE @Code nvarchar(255)
	SELECT @Code = min(Code) FROM dbo.Accounts
	WHILE @Code IS NOT NULL
	BEGIN
		IF (SELECT AccountType FROM dbo.Accounts WHERE Code = @Code) IN (N'Custom', N'Extension')
			UPDATE dbo.Accounts SET IsExtensible = 1 WHERE Code = @Code
		ELSE -- Regulatory and/or fix

		IF EXISTS(SELECT * FROM dbo.Accounts WHERE Code Like @Code + '%' AND Code <> @Code AND AccountType NOT IN  (N'Custom', N'Extension'))
			UPDATE dbo.Accounts SET IsExtensible = 0 WHERE Code = @Code
		ELSE
			UPDATE dbo.Accounts SET IsExtensible = 1 WHERE Code = @Code

		SELECT @Code = min(Code) FROM dbo.Accounts WHERE Code > @Code
	END

	--DECLARE @Code nvarchar(255)
	SELECT @Code = min(Code) FROM dbo.Notes
	WHILE @Code IS NOT NULL
	BEGIN
		IF (SELECT NoteType FROM dbo.Notes WHERE Code = @Code) IN (N'Custom', N'Extension')
			UPDATE dbo.Notes SET IsExtensible = 1 WHERE Code = @Code
		ELSE -- Regulatory and/or fix

		IF EXISTS(SELECT * FROM dbo.Notes WHERE Code Like @Code + '%' AND Code <> @Code AND NoteType NOT IN  (N'Custom', N'Extension'))
			UPDATE dbo.Notes SET IsExtensible = 0 WHERE Code = @Code
		ELSE
			UPDATE dbo.Notes SET IsExtensible = 1 WHERE Code = @Code

		SELECT @Code = min(Code) FROM dbo.Notes WHERE Code > @Code
	END

	UPDATE dbo.Accounts -- Agent/Location
	SET [AccountSpecification] = N'PropertyPlantAndEquipment'
	WHERE Code Like '1101%' AND IsExtensible = 1

	UPDATE dbo.Accounts -- Location
	SET [AccountSpecification] = N'InvestmentProperty'
	WHERE Code Like '1102%' AND IsExtensible = 1

	UPDATE dbo.Accounts -- Agent
	SET [AccountSpecification] = N'IntangibleAssetsOtherThanGoodwill'
	WHERE Code Like '1104%' AND IsExtensible = 1

	UPDATE dbo.Accounts -- Agent
	SET [AccountSpecification] = N'Investments'
	WHERE Code Like '1106%' AND IsExtensible = 1

	UPDATE dbo.Accounts
	SET [AccountSpecification] = N'BiologicalAssets'
	WHERE (Code Like '1107%' OR Code Like '1214%') AND IsExtensible = 1

	UPDATE dbo.Accounts
	SET [AccountSpecification] = N'Agents' -- Agent
	WHERE (Code Like '1108%' OR Code Like '1212%' OR Code Like '312%' OR Code Like '3212%') AND IsExtensible = 1
	
	UPDATE dbo.Accounts
	SET [AccountSpecification] = N'Inventories' -- location
	WHERE (Code Like '1109%' OR Code Like '1211%') AND IsExtensible = 1

	UPDATE dbo.Accounts
	SET [AccountSpecification] = N'Cash' -- location
	WHERE (Code Like '1217') AND IsExtensible = 1

	UPDATE dbo.Accounts
	SET [AccountSpecification] = N'Capital' -- location
	WHERE (Code Like '211%') AND IsExtensible = 1

	UPDATE dbo.Accounts
	SET [AccountSpecification] = N'Basic' -- location
	WHERE [AccountSpecification] IS NULL
END
