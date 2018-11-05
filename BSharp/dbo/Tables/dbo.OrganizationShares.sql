CREATE TABLE [dbo].[OrganizationShares] (
    [Organization] INT        NOT NULL,
    [Agent]        INT        NOT NULL,
    [Shares]       SMALLMONEY NOT NULL,
    CONSTRAINT [PK_OrganizationShares] PRIMARY KEY CLUSTERED ([Organization] ASC, [Agent] ASC)
);

