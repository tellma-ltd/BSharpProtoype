
CREATE PROCEDURE [dbo].[sbs_Document__Forward] 
	@FromDocument int,
	@ToDocument int = 0 OUTPUT,
	@ToState	nvarchar(10),
	@ToDocumentDateTime	datetimeoffset(7),
	@Actor	int,
	@Reason nvarchar(50) = NULL,
	@Reference nvarchar(50) = NULL,
	@String1 nvarchar(50) = NULL,
	@ReminderDateTime datetimeoffset(7) = NULL,
	@SerialNumber int = 0 OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

		IF (SELECT Mode FROM dbo.Documents WHERE Id = @FromDocument) <> N'Committed'
			RAISERROR (N'Please commit the Document before moving to next stage', 16,1) 
/*
		IF EXISTS (
			SELECT *
			FROM @Entries EL
			JOIN (
				SELECT E.AccountId, SUM(Amount) As Amount 
				FROM dbo.Entries E 
				JOIN dbo.Lines L ON E.LineId = L.Id
				WHERE L.DocumentId = @FromDocument
				Group By E.AccountId
				HAVING SUM(Amount) <> 0
			) ET ON EL.AccountId = ET.AccountId -- EL is the same 
			WHERE EL.Amount > ET.Amount
		)
			RAISERROR (N'Some events have less amount than you are trying to forward', 16,1)

		DECLARE @TransactionType nvarchar(50), @OperatingSegment int, @FromDocumentDateTime datetimeoffset(7), @Agent int, @Location int, @Resource int

		SELECT @TransactionType = TransactionType, @OperatingSegment = OperatingSegmentId, @FromDocumentDateTime = DocumentDateTime, 
			@Agent = AgentId, @Location = LocationId, @Resource = ResourceId
		FROM dbo.Documents 
		WHERE Id = @FromDocument

		IF @ToDocumentDateTime < @FromDocumentDateTime
			RAISERROR (N'You cannot have the destination document at date earlier than the source document', 16,1)

		SELECT @SerialNumber = 
			isNull(MAX(SerialNumber) ,0) + 1
			FROM dbo.Documents
			WHERE TransactionType = @TransactionType AND State = @ToState

		INSERT INTO dbo.Documents(State, TransactionType, OperatingSegmentId, SerialNumber, DocumentDateTime, ActorId, Reason, Reference, AgentId, LocationId, ResourceId,  ReminderDateTime)
		VALUES(@ToState, @TransactionType, @OperatingSegment, @SerialNumber, @ToDocumentDateTime, @Actor, @Reason, @Reference, @Agent, @Location, @Resource, @ReminderDateTime )
		
		SET @ToDocument = SCOPE_IDENTITY() */
END;

