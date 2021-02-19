

EXEC GUserLogin @email='ruwan@gmail.com' , @password = '1234'


CREATE procedure GUserLogin
(
		@email	varchar(500),
		@password	varchar(500)
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
  
    DECLARE @sErrorProcedure	VARCHAR(200),
			@sLog				VARCHAR(500),
			@sErrorMessage		VARCHAR(500),
			@HaveValidation		BIT=0,
			@dbPassword			varchar(500)
 
    BEGIN TRY

	IF NOT EXISTS(SELECT password FROM [dbo].[GemUser] where email= @email) 	
		BEGIN
  				SET @HaveValidation = 1
				RAISERROR('Email Not Exists',16,1)
				RETURN 0
		END
	
	SELECT @dbPassword	= password FROM [dbo].[GemUser] where email= @email

	IF (@password <> @dbPassword)
		BEGIN
				SET @HaveValidation = 1
				RAISERROR('Incorrect Password',16,1)
				RETURN 0
		END

	END TRY
	
	
	BEGIN CATCH

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