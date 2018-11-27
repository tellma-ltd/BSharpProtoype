IF NOT Exists(SELECT * FROM [dbo].[UnitsOfMeasure] WHERE TenantId = dbo.fn_TenantId())
BEGIN
	DECLARE @UnitsOfMeasure UnitOfMeasureList;
	INSERT INTO @UnitsOfMeasure ([Id], [UnitType], [Name], [UnitAmount], [BaseAmount], [IsActive], [AsOfDateTime]) VALUES
		(N'AED', N'Money', N'AE Dirhams', 3.67, 1, 0, CAST(N'01.01.2000' AS DateTimeOffset)),
		(N'd', N'Time', N'Day', 1, 86400, 1, CAST(N'01.01.2000' AS DateTimeOffset)),
		(N'dozen', N'count', N'Dozen', 1, 12, 1, CAST(N'01.01.2000' AS DateTimeOffset)),
		(N'ea', N'Pure', N'Each', 1, 1, 1, CAST(N'01.01.2000' AS DateTimeOffset)),
		(N'ETB', N'Money', N'ET Birr', 27.8, 1, 1, CAST(N'01.01.2000' AS DateTimeOffset)),
		(N'g', N'Mass', N'Gram', 1, 1, 0, CAST(N'01.01.2000' AS DateTimeOffset)),
		(N'hr', N'Time', N'Hour', 1, 3600, 1, CAST(N'01.01.2000' AS DateTimeOffset)),
		(N'in', N'Distance', N'inch', 1, 2.541, 0, CAST(N'01.01.2000' AS DateTimeOffset)),
		(N'kg', N'Mass', N'Kilogram', 1, 1000, 1, CAST(N'01.01.2000' AS DateTimeOffset)),
		(N'ltr', N'volume', N'Liter', 1, 1, 1, CAST(N'01.01.2000' AS DateTimeOffset)),
		(N'm', N'Distance', N'meter', 1, 1, 1, CAST(N'01.01.2000' AS DateTimeOffset)),
		(N'min', N'Time', N'minute', 1, 60, 0, CAST(N'01.01.2000' AS DateTimeOffset)),
		(N'mo', N'Time', N'Month', 1, 2592000, 1, CAST(N'01.01.2000' AS DateTimeOffset)),
		(N'mt', N'Mass', N'Metric ton', 1, 1000000, 1, CAST(N'01.01.2000' AS DateTimeOffset)),
		(N'pcs', N'count', N'Pieces', 1, 1, 1, CAST(N'01.01.2000' AS DateTimeOffset)),
		(N's', N'Time', N'second', 1, 1, 0, CAST(N'01.01.2000' AS DateTimeOffset)),
		(N'share', N'Pure', N'Shares', 1, 1, 1, CAST(N'01.01.2000' AS DateTimeOffset)),
		(N'USD', N'Money', N'US Dollars', 1, 1, 1, CAST(N'01.01.2000' AS DateTimeOffset)),
		(N'usg', N'Volume', N'US Gallon', 1, 3.785411784, 0, CAST(N'01.01.2000' AS DateTimeOffset)),
		(N'wd', N'Time', N'work day', 1, 8, 1, CAST(N'01.01.2000' AS DateTimeOffset)),
		(N'wk', N'Time', N'week', 1, 604800, 0, CAST(N'01.01.2000' AS DateTimeOffset)),
		(N'wmo', N'Time', N'work month', 1, 1248, 1, CAST(N'01.01.2000' AS DateTimeOffset)),
		(N'wwk', N'Time', N'work week', 1, 48, 1, CAST(N'01.01.2000' AS DateTimeOffset)),
		(N'wyr', N'Time', N'work year', 1, 14976, 1, CAST(N'01.01.2000' AS DateTimeOffset)),
		(N'yr', N'Time', N'Year', 1, 31104000, 0, CAST(N'01.01.2000' AS DateTimeOffset));

	INSERT INTO dbo.UnitsOfMeasure([TenantId], [Id], [UnitType], [Name], [UnitAmount], [BaseAmount], [IsActive], [AsOfDateTime])
	SELECT dbo.fn_TenantId(), [Id], [UnitType], [Name], [UnitAmount], [BaseAmount], [IsActive], [AsOfDateTime]
	FROM @UnitsOfMeasure
END