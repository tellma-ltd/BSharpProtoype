﻿DECLARE @Notes AS TABLE (
    [Id]              NVARCHAR (255)  NOT NULL,
    [Name]            NVARCHAR (1024) NOT NULL,
    [Code]            NVARCHAR (10)   NOT NULL,
    [IsActive]        BIT             NOT NULL,
    [ParentId]        NVARCHAR (255),
    [NoteType]		NVARCHAR (10)   DEFAULT (N'Custom') NOT NULL,
    [IsExtensible]    BIT            DEFAULT ((1)) NOT NULL,
    PRIMARY KEY NONCLUSTERED ([Id] ASC)
);
INSERT INTO @Notes(NoteType, IsActive, Code, Id, [Name]) VALUES
(N'Extension', 1, N'11', N'PropertyPlantAndEquipment', N'Property, plant and equipment')
,(N'Regulatory', 1, N'1101', N'AdditionsOtherThanThroughBusinessCombinationsPropertyPlantAndEquipment', N'Additions other than through business combinations, property, plant and equipment')
,(N'Regulatory', 1, N'1102', N'AcquisitionsThroughBusinessCombinationsPropertyPlantAndEquipment', N'Acquisitions through business combinations, property, plant and equipment')
,(N'Regulatory', 1, N'1103', N'IncreaseDecreaseThroughNetExchangeDifferencesPropertyPlantAndEquipment', N'Increase (decrease) through net exchange differences, property, plant and equipment')
,(N'Regulatory', 1, N'1104', N'DepreciationPropertyPlantAndEquipment', N'Depreciation, property, plant and equipment')
,(N'Regulatory', 1, N'1105', N'ImpairmentLossRecognisedInProfitOrLossPropertyPlantAndEquipment', N'Impairment loss recognised in profit or loss, property, plant and equipment')
,(N'Regulatory', 1, N'1106', N'ReversalOfImpairmentLossRecognisedInProfitOrLossPropertyPlantAndEquipment', N'Reversal of impairment loss recognised in profit or loss, property, plant and equipment')
,(N'Regulatory', 1, N'1107', N'RevaluationIncreaseDecreasePropertyPlantAndEquipment', N'Revaluation increase (decrease), property, plant and equipment')
,(N'Regulatory', 1, N'1108', N'ImpairmentLossRecognisedInOtherComprehensiveIncomePropertyPlantAndEquipment', N'Impairment loss recognised in other comprehensive income, property, plant and equipment')
,(N'Regulatory', 1, N'1109', N'ReversalOfImpairmentLossRecognisedInOtherComprehensiveIncomePropertyPlantAndEquipment', N'Reversal of impairment loss recognised in other comprehensive income, property, plant and equipment')
,(N'Regulatory', 1, N'1110', N'IncreaseDecreaseThroughTransfersAndOtherChangesPropertyPlantAndEquipmentAbstract', N'Increase (decrease) through transfers and other changes, property, plant and equipment [abstract]')
,(N'Regulatory', 1, N'11101', N'IncreaseDecreaseThroughTransfersPropertyPlantAndEquipment', N'Increase (decrease) through transfers, property, plant and equipment')
,(N'Regulatory', 1, N'11102', N'IncreaseDecreaseThroughOtherChangesPropertyPlantAndEquipment', N'Increase (decrease) through other changes, property, plant and equipment')
,(N'Regulatory', 1, N'1111', N'DisposalsAndRetirementsPropertyPlantAndEquipment', N'Disposals and retirements, property, plant and equipment')
,(N'Regulatory', 1, N'11111', N'DisposalsPropertyPlantAndEquipment', N'Disposals, property, plant and equipment')
,(N'Regulatory', 1, N'11112', N'RetirementsPropertyPlantAndEquipment', N'Retirements, property, plant and equipment')
,(N'Regulatory', 1, N'1112', N'DecreaseThroughClassifiedAsHeldForSalePropertyPlantAndEquipment', N'Decrease through classified as held for sale, property, plant and equipment')
,(N'Regulatory', 1, N'1113', N'DecreaseThroughLossOfControlOfSubsidiaryPropertyPlantAndEquipment', N'Decrease through loss of control of subsidiary, property, plant and equipment')

,(N'Extension', 1, N'12', N'InvestmentProperty', N'Investment property')
,(N'Regulatory', 1, N'1201', N'AdditionsOtherThanThroughBusinessCombinationsInvestmentProperty', N'Additions other than through business combinations, investment property')
,(N'Regulatory', 1, N'12011', N'AdditionsFromSubsequentExpenditureRecognisedAsAssetInvestmentProperty', N'Additions from subsequent expenditure recognised as asset, investment property')
,(N'Regulatory', 1, N'12012', N'AdditionsFromAcquisitionsInvestmentProperty', N'Additions from acquisitions, investment property')
,(N'Regulatory', 1, N'1202', N'AcquisitionsThroughBusinessCombinationsInvestmentProperty', N'Acquisitions through business combinations, investment property')
,(N'Regulatory', 1, N'1203', N'IncreaseDecreaseThroughNetExchangeDifferencesInvestmentProperty', N'Increase (decrease) through net exchange differences, investment property')
,(N'Regulatory', 1, N'1204', N'DepreciationInvestmentProperty', N'Depreciation, investment property')
,(N'Regulatory', 1, N'1205', N'ImpairmentLossRecognisedInProfitOrLossInvestmentProperty', N'Impairment loss recognised in profit or loss, investment property')
,(N'Regulatory', 1, N'1206', N'ReversalOfImpairmentLossRecognisedInProfitOrLossInvestmentProperty', N'Reversal of impairment loss recognised in profit or loss, investment property')
,(N'Regulatory', 1, N'1207', N'GainsLossesOnFairValueAdjustmentInvestmentProperty', N'Gains (losses) on fair value adjustment, investment property')
,(N'Regulatory', 1, N'1208', N'TransferFromToInventoriesAndOwnerOccupiedPropertyInvestmentProperty', N'Transfer from (to) inventories and owner-occupied property, investment property')
,(N'Regulatory', 1, N'1209', N'TransferFromInvestmentPropertyUnderConstructionOrDevelopmentInvestmentProperty', N'Transfer from investment property under construction or development, investment property')
,(N'Regulatory', 1, N'1210', N'DisposalsInvestmentProperty', N'Disposals, investment property')
,(N'Regulatory', 1, N'1211', N'DecreaseThroughClassifiedAsHeldForSaleInvestmentProperty', N'Decrease through classified as held for sale, investment property')
,(N'Regulatory', 1, N'1212', N'IncreaseDecreaseThroughOtherChangesInvestmentProperty', N'Increase (decrease) through other changes, investment property')

,(N'Extension', 1, N'13', N'Goodwill', N'Goodwill')
,(N'Regulatory', 1, N'131', N'AdditionalRecognitionGoodwill', N'Additional recognition, goodwill')
,(N'Regulatory', 1, N'132', N'SubsequentRecognitionOfDeferredTaxAssetsGoodwill', N'Subsequent recognition of deferred tax assets, goodwill')
,(N'Regulatory', 1, N'133', N'DecreaseThroughClassifiedAsHeldForSaleGoodwill', N'Decrease through classified as held for sale, goodwill')
,(N'Regulatory', 1, N'134', N'GoodwillDerecognisedWithoutHavingPreviouslyBeenIncludedInDisposalGroupClassifiedAsHeldForSale', N'Goodwill derecognised without having previously been included in disposal group classified as held for sale')
,(N'Regulatory', 1, N'135', N'ImpairmentLossRecognisedInProfitOrLossGoodwill', N'Impairment loss recognised in profit or loss, goodwill')
,(N'Regulatory', 1, N'136', N'IncreaseDecreaseThroughNetExchangeDifferencesGoodwill', N'Increase (decrease) through net exchange differences, goodwill')
,(N'Regulatory', 1, N'137', N'IncreaseDecreaseThroughTransfersAndOtherChangesGoodwill', N'Increase (decrease) through other changes, goodwill')

,(N'Extension', 1, N'14', N'IntangibleAssetsOtherThanGoodwill', N'Intangible assets other than goodwill')
,(N'Regulatory', 1, N'1401', N'AdditionsOtherThanThroughBusinessCombinationsIntangibleAssetsOtherThanGoodwill', N'Additions other than through business combinations, intangible assets other than goodwill')
,(N'Regulatory', 1, N'1402', N'AcquisitionsThroughBusinessCombinationsIntangibleAssetsOtherThanGoodwill', N'Acquisitions through business combinations, intangible assets other than goodwill')
,(N'Regulatory', 1, N'1403', N'IncreaseDecreaseThroughNetExchangeDifferencesIntangibleAssetsOtherThanGoodwill', N'Increase (decrease) through net exchange differences, intangible assets other than goodwill')
,(N'Regulatory', 1, N'1404', N'AmortisationIntangibleAssetsOtherThanGoodwill', N'Amortisation, intangible assets other than goodwill')
,(N'Regulatory', 1, N'1405', N'ImpairmentLossRecognisedInProfitOrLossIntangibleAssetsOtherThanGoodwill', N'Impairment loss recognised in profit or loss, intangible assets other than goodwill')
,(N'Regulatory', 1, N'1406', N'ReversalOfImpairmentLossRecognisedInProfitOrLossIntangibleAssetsOtherThanGoodwill', N'Reversal of impairment loss recognised in profit or loss, intangible assets other than goodwill')
,(N'Regulatory', 1, N'1407', N'RevaluationIncreaseDecreaseIntangibleAssetsOtherThanGoodwill', N'Revaluation increase (decrease), intangible assets other than goodwill')
,(N'Regulatory', 1, N'1408', N'ImpairmentLossRecognisedInOtherComprehensiveIncomeIntangibleAssetsOtherThanGoodwill', N'Impairment loss recognised in other comprehensive income, intangible assets other than goodwill')
,(N'Regulatory', 1, N'1409', N'ReversalOfImpairmentLossRecognisedInOtherComprehensiveIncomeIntangibleAssetsOtherThanGoodwill', N'Reversal of impairment loss recognised in other comprehensive income, intangible assets other than goodwill')
,(N'Regulatory', 1, N'1410', N'DecreaseThroughClassifiedAsHeldForSaleIntangibleAssetsOtherThanGoodwill', N'Decrease through classified as held for sale, intangible assets other than goodwill')
,(N'Regulatory', 1, N'1411', N'DecreaseThroughLossOfControlOfSubsidiaryIntangibleAssetsOtherThanGoodwill', N'Decrease through loss of control of subsidiary, intangible assets other than goodwill')
,(N'Regulatory', 1, N'1412', N'DisposalsAndRetirementsIntangibleAssetsOtherThanGoodwill', N'Disposals and retirements, intangible assets other than goodwill')
,(N'Regulatory', 1, N'14121', N'DisposalsIntangibleAssetsOtherThanGoodwill', N'Disposals, intangible assets other than goodwill')
,(N'Regulatory', 1, N'14122', N'RetirementsIntangibleAssetsOtherThanGoodwill', N'Retirements, intangible assets other than goodwill')
,(N'Regulatory', 1, N'1413', N'IncreaseDecreaseThroughTransfersAndOtherChangesIntangibleAssetsOtherThanGoodwill', N'Increase (decrease) through transfers and other changes, intangible assets other than goodwill')
,(N'Regulatory', 1, N'14131', N'IncreaseDecreaseThroughTransfersIntangibleAssetsOtherThanGoodwill', N'Increase (decrease) through transfers, intangible assets other than goodwill')
,(N'Regulatory', 1, N'14132', N'IncreaseDecreaseThroughOtherChangesIntangibleAssetsOtherThanGoodwill', N'Increase (decrease) through other changes, intangible assets other than goodwill')

,(N'Extension', 1, N'15', N'BiologicalAssets', N'Biological assets')
,(N'Regulatory', 1, N'1501', N'AdditionsOtherThanThroughBusinessCombinationsBiologicalAssets', N'Additions other than through business combinations, biological assets')
,(N'Regulatory', 1, N'15011', N'AdditionsFromSubsequentExpenditureRecognisedAsAssetBiologicalAssets', N'Additions from subsequent expenditure recognised as asset, biological assets')
,(N'Regulatory', 1, N'15012', N'AdditionsFromPurchasesBiologicalAssets', N'Additions from purchases, biological assets')
,(N'Regulatory', 1, N'1502', N'AcquisitionsThroughBusinessCombinationsBiologicalAssets', N'Acquisitions through business combinations, biological assets')
,(N'Regulatory', 1, N'1503', N'IncreaseDecreaseThroughNetExchangeDifferencesBiologicalAssets', N'Increase (decrease) through net exchange differences, biological assets')
,(N'Regulatory', 1, N'1504', N'DepreciationBiologicalAssets', N'Depreciation, biological assets')
,(N'Regulatory', 1, N'1505', N'ImpairmentLossRecognisedInProfitOrLossBiologicalAssets', N'Impairment loss recognised in profit or loss, biological assets')
,(N'Regulatory', 1, N'1506', N'ReversalOfImpairmentLossRecognisedInProfitOrLossBiologicalAssets', N'Reversal of impairment loss recognised in profit or loss, biological assets')
,(N'Regulatory', 1, N'1507', N'GainsLossesOnFairValueAdjustmentBiologicalAssets', N'Gains (losses) on fair value adjustment, biological assets')
,(N'Regulatory', 1, N'15071', N'GainsLossesOnFairValueAdjustmentAttributableToPhysicalChangesBiologicalAssets', N'Gains (losses) on fair value adjustment attributable to physical changes, biological assets')
,(N'Regulatory', 1, N'15072', N'GainsLossesOnFairValueAdjustmentAttributableToPriceChangesBiologicalAssets', N'Gains (losses) on fair value adjustment attributable to price changes, biological assets')
,(N'Regulatory', 1, N'1508', N'IncreaseDecreaseThroughTransfersAndOtherChangesBiologicalAssets', N'Increase (decrease) through other changes, biological assets')
,(N'Regulatory', 1, N'1509', N'DisposalsBiologicalAssets', N'Disposals, biological assets')
,(N'Regulatory', 1, N'1510', N'DecreaseDueToHarvestBiologicalAssets', N'Decrease due to harvest, biological assets')
,(N'Regulatory', 1, N'1511', N'DecreaseThroughClassifiedAsHeldForSaleBiologicalAssets', N'Decrease through classified as held for sale, biological assets')

,(N'Extension', 1, N'16', N'CashAndCashEquivalents', N'Cash and cash equivalents')
,(N'Regulatory', 1, N'161', N'IncreaseDecreaseInCashAndCashEquivalentsBeforeEffectOfExchangeRateChanges', N'Increase (decrease) in cash and cash equivalents before effect of exchange rate changes')
,(N'Regulatory', 1, N'1611', N'CashFlowsFromUsedInOperatingActivities', N'Cash flows from (used in) operating activities')
,(N'Regulatory', 1, N'16111', N'CashFlowsFromUsedInOperations', N'Cash flows from (used in) operations')
,(N'Regulatory', 1, N'1611101', N'ReceiptsFromSalesOfGoodsAndRenderingOfServices', N'Receipts from sales of goods and rendering of services')
,(N'Regulatory', 1, N'1611102', N'ReceiptsFromRoyaltiesFeesCommissionsAndOtherRevenue', N'Receipts from royalties, fees, commissions and other revenue')
,(N'Regulatory', 1, N'1611103', N'ReceiptsFromContractsHeldForDealingOrTradingPurpose', N'Receipts from contracts held for dealing or trading purposes')
,(N'Regulatory', 1, N'1611104', N'ReceiptsFromPremiumsAndClaimsAnnuitiesAndOtherPolicyBenefits', N'Receipts from premiums and claims, annuities and other policy benefits')
,(N'Regulatory', 1, N'1611105', N'ReceiptsFromRentsAndSubsequentSalesOfSuchAssets', N'Receipts from rents and subsequent sales of assets held for rental to others and subsequently held for sale')
,(N'Regulatory', 1, N'1611106', N'OtherCashReceiptsFromOperatingActivities', N'Other cash receipts from operating activities')
,(N'Regulatory', 1, N'1611107', N'PaymentsToSuppliersForGoodsAndServices', N'Payments to suppliers for goods and services')
,(N'Regulatory', 1, N'1611108', N'PaymentsFromContractsHeldForDealingOrTradingPurpose', N'Payments from contracts held for dealing or trading purpose')
,(N'Regulatory', 1, N'1611109', N'PaymentsToAndOnBehalfOfEmployees', N'Payments to and on behalf of employees')
,(N'Regulatory', 1, N'1611110', N'PaymentsForPremiumsAndClaimsAnnuitiesAndOtherPolicyBenefits', N'Payments for premiums and claims, annuities and other policy benefits')
,(N'Regulatory', 1, N'1611111', N'PaymentsToManufactureOrAcquireAssetsHeldForRentalToOthersAndSubsequentlyHeldForSale', N'Payments to manufacture or acquire assets held for rental to others and subsequently held for sale')
,(N'Regulatory', 1, N'1611112', N'OtherCashPaymentsFromOperatingActivities', N'Other cash payments from operating activities')
,(N'Regulatory', 1, N'16112', N'DividendsPaidClassifiedAsOperatingActivities', N'Dividends paid, classified as operating activities')
,(N'Regulatory', 1, N'16113', N'DividendsReceivedClassifiedAsOperatingActivities', N'Dividends received, classified as operating activities')
,(N'Regulatory', 1, N'16114', N'InterestPaidClassifiedAsOperatingActivities', N'Interest paid, classified as operating activities')
,(N'Regulatory', 1, N'16115', N'InterestReceivedClassifiedAsOperatingActivities', N'Interest received, classified as operating activities')
,(N'Regulatory', 1, N'16116', N'IncomeTaxesPaidRefundClassifiedAsOperatingActivities', N'Income taxes paid (refund), classified as operating activities')
,(N'Regulatory', 1, N'16117', N'OtherInflowsOutflowsOfCashClassifiedAsOperatingActivities', N'Other inflows (outflows) of cash, classified as operating activities')
,(N'Regulatory', 1, N'1612', N'CashFlowsFromUsedInInvestingActivities', N'Cash flows from (used in) investing activities')
,(N'Regulatory', 1, N'161201', N'CashFlowsFromLosingControlOfSubsidiariesOrOtherBusinessesClassifiedAsInvestingActivities', N'Cash flows from losing control of subsidiaries or other businesses, classified as investing activities')
,(N'Regulatory', 1, N'161202', N'CashFlowsUsedInObtainingControlOfSubsidiariesOrOtherBusinessesClassifiedAsInvestingActivities', N'Cash flows used in obtaining control of subsidiaries or other businesses, classified as investing activities')
,(N'Regulatory', 1, N'161203', N'OtherCashReceiptsFromSalesOfEquityOrDebtInstrumentsOfOtherEntitiesClassifiedAsInvestingActivities', N'Other cash receipts from sales of equity or debt instruments of other entities, classified as investing activities')
,(N'Regulatory', 1, N'161204', N'OtherCashPaymentsToAcquireEquityOrDebtInstrumentsOfOtherEntitiesClassifiedAsInvestingActivities', N'Other cash payments to acquire equity or debt instruments of other entities, classified as investing activities')
,(N'Regulatory', 1, N'161205', N'OtherCashReceiptsFromSalesOfInterestsInJointVenturesClassifiedAsInvestingActivities', N'Other cash receipts from sales of interests in joint ventures, classified as investing activities')
,(N'Regulatory', 1, N'161206', N'OtherCashPaymentsToAcquireInterestsInJointVenturesClassifiedAsInvestingActivities', N'Other cash payments to acquire interests in joint ventures, classified as investing activities')
,(N'Regulatory', 1, N'161207', N'ProceedsFromSalesOfPropertyPlantAndEquipmentClassifiedAsInvestingActivities', N'Proceeds from sales of property, plant and equipment, classified as investing activities')
,(N'Regulatory', 1, N'161208', N'PurchaseOfPropertyPlantAndEquipmentClassifiedAsInvestingActivities', N'Purchase of property, plant and equipment, classified as investing activities')
,(N'Regulatory', 1, N'161209', N'ProceedsFromSalesOfIntangibleAssetsClassifiedAsInvestingActivities', N'Proceeds from sales of intangible assets, classified as investing activities')
,(N'Regulatory', 1, N'161210', N'PurchaseOfIntangibleAssetsClassifiedAsInvestingActivities', N'Purchase of intangible assets, classified as investing activities')
,(N'Regulatory', 1, N'161211', N'ProceedsFromOtherLongtermAssetsClassifiedAsInvestingActivities', N'Proceeds from sales of other long-term assets, classified as investing activities')
,(N'Regulatory', 1, N'161212', N'PurchaseOfOtherLongtermAssetsClassifiedAsInvestingActivities', N'Purchase of other long-term assets, classified as investing activities')
,(N'Regulatory', 1, N'161213', N'ProceedsFromGovernmentGrantsClassifiedAsInvestingActivities', N'Proceeds from government grants, classified as investing activities')
,(N'Regulatory', 1, N'161214', N'CashAdvancesAndLoansMadeToOtherPartiesClassifiedAsInvestingActivities', N'Cash advances and loans made to other parties, classified as investing activities')
,(N'Regulatory', 1, N'161215', N'CashReceiptsFromRepaymentOfAdvancesAndLoansMadeToOtherPartiesClassifiedAsInvestingActivities', N'Cash receipts from repayment of advances and loans made to other parties, classified as investing activities')
,(N'Regulatory', 1, N'161216', N'CashPaymentsForFutureContractsForwardContractsOptionContractsAndSwapContractsClassifiedAsInvestingActivities', N'Cash payments for futures contracts, forward contracts, option contracts and swap contracts, classified as investing activities')
,(N'Regulatory', 1, N'161217', N'CashReceiptsFromFutureContractsForwardContractsOptionContractsAndSwapContractsClassifiedAsInvestingActivities', N'Cash receipts from futures contracts, forward contracts, option contracts and swap contracts, classified as investing activities')
,(N'Regulatory', 1, N'161218', N'DividendsReceivedClassifiedAsInvestingActivities', N'Dividends received, classified as investing activities')
,(N'Regulatory', 1, N'161219', N'InterestPaidClassifiedAsInvestingActivities', N'Interest paid, classified as investing activities')
,(N'Regulatory', 1, N'161220', N'InterestReceivedClassifiedAsInvestingActivities', N'Interest received, classified as investing activities')
,(N'Regulatory', 1, N'161221', N'IncomeTaxesPaidRefundClassifiedAsInvestingActivities', N'Income taxes paid (refund), classified as investing activities')
,(N'Regulatory', 1, N'161222', N'OtherInflowsOutflowsOfCashClassifiedAsInvestingActivities', N'Other inflows (outflows) of cash, classified as investing activities')
,(N'Regulatory', 1, N'1613', N'CashFlowsFromUsedInFinancingActivities', N'Cash flows from (used in) financing activities')
,(N'Regulatory', 1, N'161301', N'ProceedsFromChangesInOwnershipInterestsInSubsidiaries', N'Proceeds from changes in ownership interests in subsidiaries that do not result in loss of control')
,(N'Regulatory', 1, N'161302', N'PaymentsFromChangesInOwnershipInterestsInSubsidiaries', N'Payments from changes in ownership interests in subsidiaries that do not result in loss of control')
,(N'Regulatory', 1, N'161303', N'ProceedsFromIssuingShares', N'Proceeds from issuing shares')
,(N'Regulatory', 1, N'161304', N'ProceedsFromIssuingOtherEquityInstruments', N'Proceeds from issuing other equity instruments')
,(N'Regulatory', 1, N'161305', N'PaymentsToAcquireOrRedeemEntitysShares', N'Payments to acquire or redeem entity''s shares')
,(N'Regulatory', 1, N'161306', N'PaymentsOfOtherEquityInstruments', N'Payments of other equity instruments')
,(N'Regulatory', 1, N'161307', N'ProceedsFromBorrowingsClassifiedAsFinancingActivities', N'Proceeds from borrowings, classified as financing activities')
,(N'Regulatory', 1, N'161308', N'RepaymentsOfBorrowingsClassifiedAsFinancingActivities', N'Repayments of borrowings, classified as financing activities')
,(N'Regulatory', 1, N'161309', N'PaymentsOfLeaseLiabilitiesClassifiedAsFinancingActivities', N'Payments of lease liabilities, classified as financing activities')
,(N'Regulatory', 1, N'161310', N'ProceedsFromGovernmentGrantsClassifiedAsFinancingActivities', N'Proceeds from government grants, classified as financing activities')
,(N'Regulatory', 1, N'161311', N'DividendsPaidClassifiedAsFinancingActivities', N'Dividends paid, classified as financing activities')
,(N'Regulatory', 1, N'161312', N'InterestPaidClassifiedAsFinancingActivities', N'Interest paid, classified as financing activities')
,(N'Regulatory', 1, N'161313', N'IncomeTaxesPaidRefundClassifiedAsFinancingActivities', N'Income taxes paid (refund), classified as financing activities')
,(N'Regulatory', 1, N'161314', N'OtherInflowsOutflowsOfCashClassifiedAsFinancingActivities', N'Other inflows (outflows) of cash, classified as financing activities')
,(N'Extension', 1, N'1614', N'InternalCashTransfer', N'Internal cash transfer')
,(N'Regulatory', 1, N'162', N'EffectOfExchangeRateChangesOnCashAndCashEquivalents', N'Effect of exchange rate changes on cash and cash equivalents')

,(N'Extension', 1, N'2', N'Equity', N'Equity')
,(N'Regulatory', 1, N'201', N'ComprehensiveIncome', N'Comprehensive income')
,(N'Regulatory', 1, N'2011', N'ProfitLoss', N'Profit (loss)')
,(N'Regulatory', 1, N'2012', N'OtherComprehensiveIncome', N'Other comprehensive income')
,(N'Regulatory', 1, N'202', N'IssueOfEquity', N'Issue of equity')
,(N'Regulatory', 1, N'203', N'DividendsPaid', N'Dividends recognised as distributions to owners')
,(N'Regulatory', 1, N'204', N'IncreaseDecreaseThroughOtherContributionsByOwners', N'Increase through other contributions by owners, equity')
,(N'Regulatory', 1, N'205', N'IncreaseDecreaseThroughOtherDistributionsToOwners', N'Decrease through other distributions to owners, equity')
,(N'Regulatory', 1, N'206', N'IncreaseDecreaseThroughTransfersAndOtherChangesEquity', N'Increase (decrease) through other changes, equity')
,(N'Regulatory', 1, N'207', N'IncreaseDecreaseThroughTreasuryShareTransactions', N'Increase (decrease) through treasury share transactions, equity')
,(N'Regulatory', 1, N'208', N'IncreaseDecreaseThroughChangesInOwnershipInterestsInSubsidiariesThatDoNotResultInLossOfControl', N'Increase (decrease) through changes in ownership interests in subsidiaries that do not result in loss of control, equity')
,(N'Regulatory', 1, N'209', N'IncreaseDecreaseThroughSharebasedPaymentTransactions', N'Increase (decrease) through share-based payment transactions, equity')
,(N'Regulatory', 1, N'210', N'AmountRemovedFromReserveOfCashFlowHedgesAndIncludedInInitialCostOrOtherCarryingAmountOfNonfinancialAssetLiabilityOrFirmCommitmentForWhichFairValueHedgeAccountingIsApplied', N'Amount removed from reserve of cash flow hedges and included in initial cost or other carrying amount of non-financial asset (liability) or firm commitment for which fair value hedge accounting is applied')
,(N'Regulatory', 1, N'211', N'AmountRemovedFromReserveOfChangeInValueOfTimeValueOfOptionsAndIncludedInInitialCostOrOtherCarryingAmountOfNonfinancialAssetLiabilityOrFirmCommitmentForWhichFairValueHedgeAccountingIsApplied', N'Amount removed from reserve of change in value of time value of options and included in initial cost or other carrying amount of non-financial asset (liability) or firm commitment for which fair value hedge accounting is applied')
,(N'Regulatory', 1, N'212', N'AmountRemovedFromReserveOfChangeInValueOfForwardElementsOfForwardContractsAndIncludedInInitialCostOrOtherCarryingAmountOfNonfinancialAssetLiabilityOrFirmCommitmentForWhichFairValueHedgeAccountingIsApplied', N'Amount removed from reserve of change in value of forward elements of forward contracts and included in initial cost or other carrying amount of non-financial asset (liability) or firm commitment for which fair value hedge accounting is applied')
,(N'Regulatory', 1, N'213', N'AmountRemovedFromReserveOfChangeInValueOfForeignCurrencyBasisSpreadsAndIncludedInInitialCostOrOtherCarryingAmountOfNonfinancialAssetLiabilityOrFirmCommitmentForWhichFairValueHedgeAccountingIsApplied', N'Amount removed from reserve of change in value of foreign currency basis spreads and included in initial cost or other carrying amount of non-financial asset (liability) or firm commitment for which fair value hedge accounting is applied')

,(N'Extension', 1, N'3', N'OtherLongtermProvisions', N'Other non-current provisions')
,(N'Regulatory', 1, N'31', N'AdditionalProvisionsOtherProvisions', N'Additional provisions, other provisions')
,(N'Regulatory', 1, N'311', N'NewProvisionsOtherProvisions', N'New provisions, other provisions')
,(N'Regulatory', 1, N'312', N'IncreaseDecreaseInExistingProvisionsOtherProvisions', N'Increase in existing provisions, other provisions')
,(N'Regulatory', 1, N'32', N'AcquisitionsThroughBusinessCombinationsOtherProvisions', N'Acquisitions through business combinations, other provisions')
,(N'Regulatory', 1, N'33', N'ProvisionUsedOtherProvisions', N'Provision used, other provisions')
,(N'Regulatory', 1, N'34', N'UnusedProvisionReversedOtherProvisions', N'Unused provision reversed, other provisions')
,(N'Regulatory', 1, N'35', N'IncreaseDecreaseThroughTimeValueOfMoneyAdjustmentOtherProvisions', N'Increase through adjustments arising from passage of time, other provisions')
,(N'Regulatory', 1, N'36', N'IncreaseDecreaseThroughChangeInDiscountRateOtherProvisions', N'Increase (decrease) through change in discount rate, other provisions')
,(N'Regulatory', 1, N'37', N'IncreaseDecreaseThroughNetExchangeDifferencesOtherProvisions', N'Increase (decrease) through net exchange differences, other provisions')
,(N'Regulatory', 1, N'38', N'DecreaseThroughLossOfControlOfSubsidiaryOtherProvisions', N'Decrease through loss of control of subsidiary, other provisions')
,(N'Regulatory', 1, N'39', N'IncreaseDecreaseThroughTransfersAndOtherChangesOtherProvisions', N'Increase (decrease) through transfers and other changes, other provisions')

,(N'Extension', 1, N'4', N'ExpenseByNature', N'Expenses, by nature')
,(N'Regulatory', 1, N'41', N'RawMaterialsAndConsumablesUsed', N'Raw materials and consumables used')
,(N'Regulatory', 1, N'42', N'CostOfMerchandiseSold', N'Cost of merchandise sold')
,(N'Regulatory', 1, N'43', N'ServicesExpense', N'Services expense')
,(N'Regulatory', 1, N'4301', N'InsuranceExpense', N'Insurance expense')
,(N'Regulatory', 1, N'4302', N'ProfessionalFeesExpense', N'Professional fees expense')
,(N'Regulatory', 1, N'4303', N'TransportationExpense', N'Transportation expense')
,(N'Regulatory', 1, N'4304', N'BankAndSimilarCharges', N'Bank and similar charges')
,(N'Regulatory', 1, N'4305', N'EnergyTransmissionCharges', N'Energy transmission charges')
,(N'Regulatory', 1, N'4306', N'TravelExpense', N'Travel expense')
,(N'Regulatory', 1, N'4307', N'CommunicationExpense', N'Communication expense')
,(N'Regulatory', 1, N'4308', N'UtilitiesExpense', N'Utilities expense')
,(N'Regulatory', 1, N'4309', N'AdvertisingExpense', N'Advertising expense')
,(N'Regulatory', 1, N'4310', N'OfficeSpaceExpense', N'Office space expense')
,(N'Regulatory', 1, N'44', N'EmployeeBenefitsExpense', N'Employee benefits expense')
,(N'Regulatory', 1, N'441', N'ShorttermEmployeeBenefitsExpense', N'Short-term employee benefits expense')
,(N'Regulatory', 1, N'4411', N'WagesAndSalaries', N'Wages and salaries')
,(N'Regulatory', 1, N'4412', N'SocialSecurityContributions', N'Social security contributions')
,(N'Regulatory', 1, N'4413', N'OtherShorttermEmployeeBenefits', N'Other short-term employee benefits')
,(N'Regulatory', 1, N'442', N'PostemploymentBenefitExpenseDefinedContributionPlans', N'Post-employment benefit expense, defined contribution plans')
,(N'Regulatory', 1, N'443', N'PostemploymentBenefitExpenseDefinedBenefitPlans', N'Post-employment benefit expense, defined benefit plans')
,(N'Regulatory', 1, N'444', N'TerminationBenefitsExpense', N'Termination benefits expense')
,(N'Regulatory', 1, N'445', N'OtherLongtermBenefits', N'Other long-term employee benefits')
,(N'Regulatory', 1, N'446', N'OtherEmployeeExpense', N'Other employee expense')
,(N'Regulatory', 1, N'45', N'DepreciationAmortisationAndImpairmentLossReversalOfImpairmentLossRecognisedInProfitOrLoss', N'Depreciation, amortisation and impairment loss (reversal of impairment loss) recognised in profit or loss')
,(N'Regulatory', 1, N'451', N'DepreciationAndAmortisationExpense', N'Depreciation and amortisation expense')
,(N'Regulatory', 1, N'4511', N'DepreciationExpense', N'Depreciation expense')
,(N'Regulatory', 1, N'4512', N'AmortisationExpense', N'Amortisation expense')
,(N'Regulatory', 1, N'452', N'ImpairmentLossReversalOfImpairmentLossRecognisedInProfitOrLoss', N'Impairment loss (reversal of impairment loss) recognised in profit or loss')
,(N'Regulatory', 1, N'4521', N'WritedownsReversalsOfInventories', N'Write-downs (reversals of write-downs) of inventories')
,(N'Regulatory', 1, N'45211', N'InventoryWritedown2011', N'Inventory write-down')
,(N'Regulatory', 1, N'45212', N'ReversalOfInventoryWritedown', N'Reversal of inventory write-down')
,(N'Regulatory', 1, N'4522', N'WritedownsReversalsOfPropertyPlantAndEquipment', N'Write-downs (reversals of write-downs) of property, plant and equipment')

,(N'Regulatory', 1, N'4523', N'ImpairmentLossReversalOfImpairmentLossRecognisedInProfitOrLossTradeReceivables', N'Impairment loss (reversal of impairment loss) recognised in profit or loss, trade receivables')
,(N'Regulatory', 1, N'45231', N'ImpairmentLossRecognisedInProfitOrLossTradeReceivables', N'Impairment loss recognised in profit or loss, trade receivables')
,(N'Regulatory', 1, N'45232', N'ReversalOfImpairmentLossRecognisedInProfitOrLossTradeReceivables', N'Reversal of impairment loss recognised in profit or loss, trade receivables')
,(N'Regulatory', 1, N'4524', N'ImpairmentLossReversalOfImpairmentLossRecognisedInProfitOrLossLoansAndAdvances', N'Impairment loss (reversal of impairment loss) recognised in profit or loss, loans and advances')
,(N'Regulatory', 1, N'45241', N'ImpairmentLossRecognisedInProfitOrLossLoansAndAdvances', N'Impairment loss recognised in profit or loss, loans and advances')
,(N'Regulatory', 1, N'45242', N'ReversalOfImpairmentLossRecognisedInProfitOrLossLoansAndAdvances', N'Reversal of impairment loss recognised in profit or loss, loans and advances')
,(N'Regulatory', 1, N'46', N'TaxExpenseOtherThanIncomeTaxExpense', N'Tax expense other than income tax expense')
,(N'Regulatory', 1, N'47', N'OtherExpenseByNature', N'Other expenses, by nature');
MERGE dbo.Notes AS t
USING @Notes AS s
ON s.Code = t.Code AND t.tenantId = dbo.fn_TenantId()
WHEN MATCHED AND
(
    t.[Name]			<>	s.[Name]			OR
    t.[Code]			<>	s.[Code]			OR
    t.[IsActive]		<>	s.[IsActive]		OR
    t.[NoteType]		<>	s.[NoteType]		OR
    t.[IsExtensible]	<>	s.[IsExtensible]
) THEN
UPDATE SET
    t.[Name]			=	s.[Name],  
    t.[Code]			=	s.[Code],
    t.[IsActive]		=	s.[IsActive],
    t.[NoteType]		=	s.[NoteType], 
    t.[IsExtensible]	=	s.[IsExtensible]
WHEN NOT MATCHED BY SOURCE THEN
        DELETE
WHEN NOT MATCHED BY TARGET THEN
        INSERT ([TenantId],			[Id], [Name], [Code], [IsActive], [NoteType], [IsExtensible])
        VALUES (dbo.fn_TenantId(), s.[Id], s.[Name], s.[Code], s.[IsActive], s.[NoteType], s.[IsExtensible]);
--OUTPUT deleted.*, $action, inserted.*; -- Does not work with triggers