CREATE FUNCTION [dbo].[fr_Resources__Json] (
	@RJson NVARCHAR(MAX)
)
RETURNS TABLE
AS
	RETURN
	SELECT *
	FROM OpenJson(@RJson)
	WITH (
		[Id] INT '$.Id',
		[ResourceType] NVARCHAR (255) '$.ResourceType',
		[Name] NVARCHAR (255) '$.Name',
		[Name2] NVARCHAR (255) '$.Name2',
		[Name3] NVARCHAR (255) '$.Name3',
		[IsActive] BIT '$.IsActive',
		[ValueMeasure] NVARCHAR (255) '$.ValueMeasure',

		[CurrencyId] INT '$.CurrencyId',
		[MassUnitId] INT '$.MassUnitId',
		[MassRate] DECIMAL '$.MassRate',
		[VolumeUnitId] INT '$.VolumeUnitId',
		[VolumeRate] DECIMAL '$.VolumeRate',
		[LengthUnitId] INT '$.LengthUnitId',
		[CountUnitId] INT '$.CountUnitId',
		[TimeUnitId] INT '$.TimeUnitId',

		[Code] NVARCHAR (255) '$.Code',
		[SystemCode] NVARCHAR (255) '$.SystemCode',
		[Memo] NVARCHAR (2048) '$.Memo',
		[Reference] NVARCHAR (255) '$.Reference',
		[RelatedReference] NVARCHAR (255) '$.RelatedReference',
		[RelatedAgentId] INT '$.RelatedAgentId',
		[RelatedResourceId] INT '$.[RelatedResourceId',
		[RelatedMeasurementUnitId] INT '$.RelatedMeasurementUnitId',
		[RelatedAmount] INT '$.RelatedAmount',
		[RelatedDateTime] DATETIMEOFFSET (7) '$.RelatedDateTime',
	-- The following properties are user-defined, used for reporting
		[Lookup1Id] INT '$.Lookup1Id',
		[Lookup2Id] INT '$.Lookup2Id',
		[Lookup3Id] INT '$.Lookup3Id',
		[Lookup4Id] INT '$.Lookup4Id', 
		[PartOfId] INT '$.PartOfId',
		[InstanceOfId] INT '$.InstanceOfId',

		[CreatedAt] DATETIMEOFFSET(7) '$.CreatedAt',
		[CreatedById] INT '$.CreatedById',
		[ModifiedAt] DATETIMEOFFSET(7) '$.ModifiedAt',
		[ModifiedById] INT '$.ModifiedById',
		[EntityState] NVARCHAR(255) '$.EntityState'
	);

