IF NOT Exists(SELECT * FROM [dbo].[MeasurementUnits] WHERE TenantId = dbo.fn_TenantId())
BEGIN
	DECLARE @MeasurementUnits MeasurementUnitList;
	INSERT INTO @MeasurementUnits ([Code], [UnitType], [Name], [UnitAmount], [BaseAmount], [IsActive]) VALUES
		('AED', N'Money', N'AE Dirhams', 3.67, 1, 0),
		(N'd', N'Time', N'Day', 1, 86400, 1),
		(N'dozen', N'Count', N'Dozen', 1, 12, 1),
		(N'ea', N'Pure', N'Each', 1, 1, 1),
		(N'ETB', N'Money', N'ET Birr', 27.8, 1, 1),
		(N'g', N'Mass', N'Gram', 1, 1, 0),
		(N'hr', N'Time', N'Hour', 1, 3600, 1),
		(N'in', N'Distance', N'inch', 1, 2.541, 0),
		(N'kg', N'Mass', N'Kilogram', 1, 1000, 1),
		(N'ltr', N'Volume', N'Liter', 1, 1, 1),
		(N'm', N'Distance', N'meter', 1, 1, 1),
		(N'min', N'Time', N'minute', 1, 60, 0),
		(N'mo', N'Time', N'Month', 1, 2592000, 1),
		(N'mt', N'Mass', N'Metric ton', 1, 1000000, 1),
		(N'pcs', N'Count', N'Pieces', 1, 1, 1),
		(N's', N'Time', N'second', 1, 1, 0),
		(N'share', N'Pure', N'Shares', 1, 1, 1),
		(N'USD', N'Money', N'US Dollars', 1, 1, 1),
		(N'usg', N'Volume', N'US Gallon', 1, 3.785411784, 0),
		(N'wd', N'Time', N'work day', 1, 8, 1),
		(N'wk', N'Time', N'week', 1, 604800, 0),
		(N'wmo', N'Time', N'work month', 1, 1248, 1),
		(N'wwk', N'Time', N'work week', 1, 48, 1),
		(N'wyr', N'Time', N'work year', 1, 14976, 1),
		(N'yr', N'Time', N'Year', 1, 31104000, 0);

	EXEC api_MeasurementUnits__Save @MeasurementUnits;
END