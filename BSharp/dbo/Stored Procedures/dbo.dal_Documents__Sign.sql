CREATE PROCEDURE [dbo].[dal_Documents__Sign]
-- @Entites contain only the documents where Actor and Role are compatible with current state
	@Entities [dbo].[UuidList] READONLY,
	@State NVARCHAR(255),
	@ReasonId UNIQUEIDENTIFIER,
	@ReasonDetails	NVARCHAR(1024),
	@AgentId UNIQUEIDENTIFIER,
	@RoleId UNIQUEIDENTIFIER,
	@SignedAt DATETIMEOFFSET(7)
AS
BEGIN
	DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();
	DECLARE @UserId UNIQUEIDENTIFIER = CONVERT(UNIQUEIDENTIFIER, SESSION_CONTEXT(N'UserId'));

	INSERT INTO dbo.[DocumentSignatures] (
		[DocumentId], [State], [ReasonId], [ReasonDetails], [AgentId], [RoleId], [SignedAt]
	)
	SELECT
		[Id],		@State,		@ReasonId, @ReasonDetails,	@AgentId,	@RoleId, @SignedAt
	FROM @Entities
END;