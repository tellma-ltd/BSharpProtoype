CREATE TYPE [dbo].[EmployeeList] AS TABLE (
--	Potentially applies to all agents
	[Index]						INT				IDENTITY(0, 1),
	[Id]						INT,
	[Name]						NVARCHAR (255)	NOT NULL,
	[Name2]						NVARCHAR (255),
	[Code]						NVARCHAR (255),
	[SystemCode]				NVARCHAR (255), -- employee-anonymous is auto added.
	[TaxIdentificationNumber]	NVARCHAR (255),
	[IsRelated]					BIT				NOT NULL DEFAULT (0),
	[IsLocal]					BIT,
	[Citizenship]				NCHAR(2),
	[Facebook]					NVARCHAR (255),				
	[Instagram]					NVARCHAR (255),				
	[Twitter]					NVARCHAR (255),
	[PreferredContactChannel1]	INT,			-- Mobile, Email, 
	[PreferredContactAddress1]	NVARCHAR(255),
	[PreferredContactChannel2]	INT,
	[PreferredContactAddress2]	NVARCHAR(255),
--	Potentially apply to Individuals only PersonType = N'Individual'
	[BirthDateTime]				DATETIMEOFFSET (7),
	[MaritalStatus]				NCHAR (1),		-- S=Single, D=Divorced, M=Married, W=Widowed
	[Religion]					NCHAR (1),		-- I=Islam, C=Christianity, X=Others -- , J=Judaism, H=Hinduism, B=Buddhism
	[Race]						NCHAR (1),		-- W=White, B=Black, A=Asian, H=Hispanic
	[Gender]					NCHAR (1),		-- M=Male, F=Female
	[TribeId]					INT,
	[RegionId]					INT,
	[ResidentialAddress]		NVARCHAR (1024),
	[Title]						NVARCHAR (255),
--	Potentially apply to Employees
	[JobTitle]					NVARCHAR (255),
	[EmployeeSince]				DATETIMEOFFSET (7),				
/*	[BasicSalary]				MONEY,
	[TransporationAllowance]	MONEY,
	[OvertimeRate]				MONEY, */
	[EducationLevel]			NVARCHAR (255),					
	[EducationSublevel]			NVARCHAR (255),					
	[BankId]					INT,
	[BankAccountNumber]			NVARCHAR (255),					
	[NumberOfChildren]			TINYINT,
--	In case he/she owns shares
	[OwnershipPercent]			DECIMAL	DEFAULT(0),

	[EntityState]				NVARCHAR(255)	NOT NULL DEFAULT(N'Inserted'),
	PRIMARY KEY ([Index] ASC),
	INDEX IX_AgentList__Code ([Code]),
	CHECK ([EntityState] IN (N'Unchanged', N'Inserted', N'Updated', N'Deleted')),
	CHECK ([EntityState] <> N'Inserted' OR [Id] IS NULL)
);