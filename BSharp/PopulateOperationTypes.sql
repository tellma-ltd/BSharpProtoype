DECLARE @OperationTypes TABLE ([Id] nvarchar(50) Primary Key);
INSERT @OperationTypes ([Id]) VALUES
	(N'BusinessEntity'),
	(N'Investment'),
	(N'OperatingSegment');
INSERT INTO @Translations([Key], [Language], [Country], [Singular], [Plural]) VALUES
(N'BusinessEntity', N'EN', N'', N'BusinessEntity', NULL),
(N'BusinessEntity', N'AR', N'', N'الشركة', NULL),
(N'Investment', N'EN', N'', N'Investment', N'Investments'),
(N'Investment', N'AR', N'', N'استثمار', N'استثمارات'),
(N'OperatingSegment', N'EN', N'', N'Operating Segment', N'Operating Segments'),
(N'OperatingSegment', N'AR', N'', N'نشاط', N'أنشطة');

MERGE dbo.[OperationTypes] AS t
USING @OperationTypes AS s
ON s.Id = t.Id --AND s.tenantId = t.tenantId
WHEN NOT MATCHED BY SOURCE THEN
        DELETE
WHEN NOT MATCHED BY TARGET THEN
        INSERT ([Id])
        VALUES (s.[Id]);
