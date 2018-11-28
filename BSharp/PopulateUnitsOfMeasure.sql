IF NOT Exists(SELECT * FROM [dbo].[MeasurementUnits] WHERE TenantId = dbo.fn_TenantId())
BEGIN
	DECLARE @MeasurementUnits MeasurementUnitList;
	INSERT INTO @MeasurementUnits ([Id], [Code], [UnitType], [Name], [UnitAmount], [BaseAmount], [IsActive]) VALUES
		(1, N'AED', N'Money', N'AE Dirhams', 3.67, 1, 0),
		(2, N'd', N'Time', N'Day', 1, 86400, 1),
		(3, N'dozen', N'Count', N'Dozen', 1, 12, 1),
		(4, N'ea', N'Pure', N'Each', 1, 1, 1),
		(5, N'ETB', N'Money', N'ET Birr', 27.8, 1, 1),
		(6, N'g', N'Mass', N'Gram', 1, 1, 0),
		(7, N'hr', N'Time', N'Hour', 1, 3600, 1),
		(8, N'in', N'Distance', N'inch', 1, 2.541, 0),
		(9, N'kg', N'Mass', N'Kilogram', 1, 1000, 1),
		(10, N'ltr', N'Volume', N'Liter', 1, 1, 1),
		(11, N'm', N'Distance', N'meter', 1, 1, 1),
		(12, N'min', N'Time', N'minute', 1, 60, 0),
		(13, N'mo', N'Time', N'Month', 1, 2592000, 1),
		(14, N'mt', N'Mass', N'Metric ton', 1, 1000000, 1),
		(15, N'pcs', N'Count', N'Pieces', 1, 1, 1),
		(16, N's', N'Time', N'second', 1, 1, 0),
		(17, N'share', N'Pure', N'Shares', 1, 1, 1),
		(18, N'USD', N'Money', N'US Dollars', 1, 1, 1),
		(19, N'usg', N'Volume', N'US Gallon', 1, 3.785411784, 0),
		(20, N'wd', N'Time', N'work day', 1, 8, 1),
		(21, N'wk', N'Time', N'week', 1, 604800, 0),
		(22, N'wmo', N'Time', N'work month', 1, 1248, 1),
		(23, N'wwk', N'Time', N'work week', 1, 48, 1),
		(24, N'wyr', N'Time', N'work year', 1, 14976, 1),
		(25, N'yr', N'Time', N'Year', 1, 31104000, 0);

	INSERT INTO dbo.[MeasurementUnits]([TenantId], [Code], [UnitType], [Name], [UnitAmount], [BaseAmount], [IsActive])
	SELECT dbo.fn_TenantId(), [Code], [UnitType], [Name], [UnitAmount], [BaseAmount], [IsActive]
	FROM @MeasurementUnits
END