CREATE TABLE [dbo].[ExchangeRatesHistory] (
	[Date]				DATE,
	[BaseCurrency]		CHAR (3),
	[TargetCurrency]	CHAR (3),
	[ExchangeRate]		FLOAT (53)     NOT NULL, -- Multiply base amount by CRate to get target amount
	CONSTRAINT [PK_ExchangeRatesHistory] PRIMARY KEY CLUSTERED ([Date] ASC, [BaseCurrency] ASC, [TargetCurrency] ASC)
);

