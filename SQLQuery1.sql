CREATE TABLE GemUser (
 [Id] [int] IDENTITY(1,1) NOT NULL,
 firstName [varchar](500) NOT NULL,
  lastName [varchar](500)  NULL,
   email   [varchar](500) NOT NULL,
   password [varchar](500) NOT NULL
 
 )

 use gemDB
 
 select * from GemUser

  INSERT INTO GemUser
  SELECT  'sam' , 'max', 'sam@gmail.com' , '1234' UNION
  SELECT  'jon' , 'max', 'jon@gmail.com' , '1234'
GO

exec SelectUsers @id = -999
 
CREATE PROCEDURE SelectUsers
(   @id INT )
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
			@sErrorMessage		VARCHAR(500)

    BEGIN TRY
		SELECT	*
		FROM	GemUser
		WHERE	id = CASE WHEN @id=-999 THEN id ELSE @id END 
	
	END TRY
	
	BEGIN CATCH

		DECLARE @iErrorNumber INT

		SELECT	@sErrorProcedure=ERROR_PROCEDURE()
		SELECT	@sErrorMessage=ERROR_MESSAGE()
		SELECT	@iErrorNumber=ERROR_NUMBER()

		RAISERROR (@sErrorMessage,16,1)

		RETURN 0
  
    END CATCH  
END