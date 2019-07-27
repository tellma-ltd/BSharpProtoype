CREATE PROCEDURE [dbo].[dal_Documents__Sign]
-- @Entites contain only the documents where Actor and Role are compatible with current state
	@Entities [dbo].[IndexedIdList] READONLY,
	@State NVARCHAR(255),
	@ReasonId INT,
	@ReasonDetails	NVARCHAR(1024),
	@ActorId INT,
	@RoleId INT,
	@SignedAt DATETIMEOFFSET(7)
AS
BEGIN
	DECLARE @Now DATETIMEOFFSET(7) = SYSDATETIMEOFFSET();
	DECLARE @UserId INT = CONVERT(INT, SESSION_CONTEXT(N'UserId'));

	INSERT INTO dbo.[DocumentSignatures] (
		[DocumentId], [State], [ReasonId], [ReasonDetails], [ActorId], [RoleId], [SignedAt]
	)
	SELECT
		[Id],		@State,		@ReasonId, @ReasonDetails,	@ActorId,	@RoleId, @SignedAt
	FROM @Entities
END;