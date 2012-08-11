SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 4/14/2012
-- Description:	update user Area 
-- Returns 0 on sucess, 1 - failure, Invalid Area code
-- =============================================
Alter PROCEDURE [dbo].[UserAreaUpdate]
	@UserID INT,
	@AreaCode varchar(100) = '',
	@returnStatus int = 0 out
AS
BEGIN
	
	IF Exists(SELECT AreaCode from tblAreaCodes where AreaCode = @AreaCode and IsActive = 1)
		UPDATE tblUsers SET AreaCode = @AreaCode where UserID = @UserID
	ELSE
		Set @returnStatus = 1
END
GO
