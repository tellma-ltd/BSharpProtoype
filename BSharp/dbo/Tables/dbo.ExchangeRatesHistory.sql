CREATE TABLE [dbo].[ExchangeRatesHistory] (
    [Id]           NVARCHAR (50)      NOT NULL,
    [AsOfDateTime] DATETIMEOFFSET (7) NOT NULL,
    [UnitAmount]   FLOAT (53)         NOT NULL,
    [BaseAmount]   FLOAT (53)         NOT NULL,
    CONSTRAINT [PK_ExchangeRatesHistory] PRIMARY KEY CLUSTERED ([Id] ASC, [AsOfDateTime] ASC)
);

