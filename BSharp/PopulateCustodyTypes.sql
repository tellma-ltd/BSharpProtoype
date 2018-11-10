DECLARE @AgentTypes TABLE ([Id] nvarchar(50) Primary Key);
DECLARE @LocationTypes TABLE ([Id] nvarchar(50) Primary Key);
-- Agents
INSERT @AgentTypes ([Id]) VALUES 
	(N'Individual'),
	(N'Organization'),
	(N'OrganizationUnit');
INSERT INTO @Translations([Key], [Language], [Country], [Singular], [Plural]) VALUES
(N'Individual', N'EN', N'', N'Individual', N'Individuals'),
(N'Individual', N'AR', N'', N'فرد', N'أفراد'),
(N'Organization', N'EN', N'', N'Organization', N'Organizations'),
(N'Organization', N'AR', N'', N'مؤسسة', N'مؤسسات'),
(N'OrganizationUnit', N'EN', N'', N'Organization Unit', N'Organization Units'),
(N'OrganizationUnit', N'AR', N'', N'وحدة إدارية', N'وحدات إدارية');
MERGE dbo.[AgentTypes] AS t
USING @AgentTypes AS s
ON s.Id = t.Id --AND s.tenantId = t.tenantId
WHEN NOT MATCHED BY SOURCE THEN
        DELETE
WHEN NOT MATCHED BY TARGET THEN
        INSERT ([Id])
        VALUES (s.[Id]);
-- Location
INSERT @LocationTypes ([Id]) VALUES
	(N'Address'),
	(N'BankAccount'),
	(N'Farm'),
	(N'ProductionPoint'),
	(N'Warehouse');
INSERT INTO @Translations([Key], [Language], [Country], [Singular], [Plural]) VALUES
(N'Address', N'EN', N'', N'Address', N'Addresses'),
(N'Address', N'AR', N'', N'عنوان', N'عناوين'),
(N'BankAccount', N'EN', N'', N'Bank Account', N'Bank Accounts'),
(N'BankAccount', N'AR', N'', N'حساب مصرفي', N'حسابات مصرفية'),
(N'Farm', N'EN', N'', N'Farm', N'Farms'),
(N'Farm', N'AR', N'', N'مزرعة', N'مزارع'),
(N'ProductionPoint', N'EN', N'', N'Production Point', N'Production Points'),
(N'ProductionPoint', N'AR', N'', N'نقطة إنتاج', N'نقاط إنتاج'),
(N'Warehouse', N'EN', N'', N'Warehouse', N'Warehouses'),
(N'Warehouse', N'AR', N'', N'مخزن', N'مخازن');
MERGE dbo.[LocationTypes] AS t
USING @LocationTypes AS s
ON s.Id = t.Id --AND s.tenantId = t.tenantId
WHEN NOT MATCHED BY SOURCE THEN
        DELETE
WHEN NOT MATCHED BY TARGET THEN
        INSERT ([Id])
        VALUES (s.[Id]);
-- Custodies
MERGE dbo.[CustodyTypes] AS t
USING (
	SELECT [Id] FROM @AgentTypes
	UNION ALL
	SELECT [Id] FROM @LocationTypes
) AS s
ON s.Id = t.Id --AND s.tenantId = t.tenantId
WHEN NOT MATCHED BY SOURCE THEN
        DELETE
WHEN NOT MATCHED BY TARGET THEN
        INSERT ([Id])
        VALUES (s.[Id]);