INSERT INTO @Translations([Key], [Language], [Country], [Singular], [Plural]) VALUES
(N'NullTenantID',		N'EN', N'', N'Tenant Id is NULL!', NULL),
(N'NullTenantID',		N'AR', N'', N'لم يتم تحديد رقم الاشتراك', NULL),
(N'AccountIsNotLeaf',	N'EN', N'', N'This is a summary account, and cannot be used in entries', NULL),
(N'AccountIsNotLeaf',	N'AR', N'', N'حساب إجمالي يمنع إجراء القيود عليه', NULL),
(N'LineIsNotBalanced',	N'EN', N'', N'Total debit is Off by %s From total credit', NULL),
(N'LineIsNotBalanced',	N'AR', N'', N'يوجد فارق يمقدار %s بين مجموع المدين ومجموع الدائن', NULL);