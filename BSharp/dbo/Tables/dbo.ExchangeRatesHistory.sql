CREATE TABLE [dbo].[ExchangeRatesHistory] (
	[TenantId]		INT,
    [Id]			NVARCHAR (50),
    [AsOfDateTime]	DATETIMEOFFSET (7),
    [UnitAmount]	FLOAT (53)         NOT NULL,
    [BaseAmount]	FLOAT (53)         NOT NULL,
    CONSTRAINT [PK_ExchangeRatesHistory] PRIMARY KEY CLUSTERED ([TenantId] ASC, [Id] ASC, [AsOfDateTime] ASC)
);

