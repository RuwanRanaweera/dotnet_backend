


CREATE procedure InsertGem (
      @Name  VARCHAR(500),
      @description   VARCHAR(500),
	  @price  VARCHAR(500)
)
AS
BEGIN
	SET NOCOUNT ON;
	SET XACT_ABORT,
	QUOTED_IDENTIFIER,
	ARITHABORT,
	ANSI_NULLS,
	ANSI_PADDING,
	ANSI_WARNINGS,
	CONCAT_NULL_YIELDS_NULL ON;
    SET NUMERIC_ROUNDABORT OFF;

	DECLARE
			@sErrorProcedure	VARCHAR(200),
			@sLog				VARCHAR(500),
			@sErrorMessage		VARCHAR(500),
			@HaveValidation		BIT=0
							
	BEGIN TRY
		BEGIN TRANSACTION InsertGUserTran	

		IF EXISTS(SELECT email FROM [dbo].[gems] where email= @email)
			BEGIN
				SET @HaveValidation = 1
				RAISERROR('Email Already Exists!',16,1)
				RETURN 0
			END

		INSERT INTO [dbo].[gems] (gemID, gemName, price)
		VALUES (@gemID, @gemName, @price)

		IF @@TRANCOUNT>0
			COMMIT TRANSACTION InsertGUserTran
	END TRY
	BEGIN CATCH

		IF @@TRANCOUNT>0
			ROLLBACK TRANSACTION InsertGUserTran

		DECLARE @iErrorNumber INT

		SELECT	@sErrorProcedure=ERROR_PROCEDURE()
		SELECT	@sErrorMessage=ERROR_MESSAGE()
		SELECT	@iErrorNumber=ERROR_NUMBER()

		IF(@HaveValidation = 1)
			BEGIN
				EXEC sp_addmessage @msgnum = 50005, @severity = 1, @msgtext = @sErrorMessage,@replace = 'REPLACE';
				RAISERROR (50005,11,1)
			END
			ELSE
				RAISERROR (@sErrorMessage,16,1)
			RETURN 0
	END CATCH 
END 
