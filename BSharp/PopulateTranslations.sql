DECLARE @Translations TABLE
(
	[Name]			nvarchar(255),
    [Culture]		nvarchar(50),
	[Value]			nvarchar(2048) NOT NULL,
    PRIMARY KEY NONCLUSTERED ([Name] ASC, [Culture] ASC)
);
-- Modes
INSERT INTO @Translations([Name], [Culture], [Value]) VALUES
(N'Void', N'EN', N'Void'),
(N'Void', N'AR', N'ملغى'),
(N'Draft', N'EN', N'Draft'),
(N'Draft', N'AR', N'قيد الإعداد'),
(N'Posted', N'EN', N'Posted'),
(N'Posted', N'AR', N'معتمد'),
(N'Submitted', N'EN', N'Submitted'),
(N'Submitted', N'AR', N'مكتمل');

-- Error Messages
INSERT INTO @Translations([Name], [Culture], [Value]) VALUES
(N'NullTenantID',		N'EN', N'Tenant Id is NULL!'),
(N'NullTenantID',		N'AR', N'لم يتم تحديد رقم الاشتراك'),
(N'AccountIsNotLeaf',	N'EN', N'This is a summary account, and cannot be used in entries'),
(N'AccountIsNotLeaf',	N'AR', N'حساب إجمالي يمنع إجراء القيود عليه'),
(N'LineIsNotBalanced',	N'EN', N'Total debit is Off by %s From total credit'),
(N'LineIsNotBalanced',	N'AR', N'يوجد فارق يمقدار %s بين مجموع المدين ومجموع الدائن');

-- Operation types
INSERT INTO @Translations([Name], [Culture], [Value]) VALUES
(N'BusinessEntity', N'EN', N'BusinessEntity'),
(N'BusinessEntity', N'AR', N'الشركة'),
(N'Investment', N'EN', N'Investment'),
(N'Investment', N'AR', N'استثمار'),
(N'OperatingSegment', N'EN', N'Operating Segment'),
(N'OperatingSegment', N'AR', N'نشاط');

-- Agent types
INSERT INTO @Translations([Name], [Culture], [Value]) VALUES
(N'Individual', N'EN', N'Individual'),
(N'Individual', N'AR', N'فرد'),
(N'Organization', N'EN', N'Organization'),
(N'Organization', N'AR', N'مؤسسة'),
(N'OrganizationUnit', N'EN', N'Organization Unit'),
(N'OrganizationUnit', N'AR', N'وحدة إدارية');

-- Location types
INSERT INTO @Translations([Name], [Culture], [Value]) VALUES
(N'Address', N'EN', N'Address'),
(N'Address', N'AR', N'عنوان'),
(N'CashSafe', N'EN', N'Cash Safe'),
(N'CashSafe', N'AR', N'خزنة نقدية'),
(N'BankAccount', N'EN', N'Bank Account'),
(N'BankAccount', N'AR', N'حساب مصرفي'),
(N'Farm', N'EN', N'Farm'),
(N'Farm', N'AR', N'مزرعة'),
(N'ProductionPoint', N'EN', N'Production Point'),
(N'ProductionPoint', N'AR', N'نقطة إنتاج'),
(N'Warehouse', N'EN', N'Warehouse'),
(N'Warehouse', N'AR', N'مخزن');

-- Transaction types
INSERT INTO @Translations([Name], [Culture], [Value]) VALUES
(N'PaymentIssueToSupplierEvent', N'EN', N'Payment to Supplier'),
(N'PaymentIssueToSupplierEvent', N'AR', N'دفعبة لمورد'),
(N'PaymentReceiptFromCustomerEvent', N'EN', N'Payment from Customer'),
(N'PaymentReceiptFromCustomerEvent', N'AR', N'دفعبة من زبون');

MERGE dbo.Translations AS t
USING @Translations AS s
ON s.[Name] = t.[Name] AND s.[Culture] = t.[Culture]
WHEN MATCHED AND
(
    t.[Value]	<>	s.[Value]			
) THEN
UPDATE SET
    t.[Value]	=	s.[Value]
WHEN NOT MATCHED BY SOURCE THEN
        DELETE
WHEN NOT MATCHED BY TARGET THEN
        INSERT ([Name], [Culture], [Value])
        VALUES (s.[Name], s.[Culture], s.[Value]);
--OUTPUT deleted.*, $action, inserted.*; -- Does not work with triggers