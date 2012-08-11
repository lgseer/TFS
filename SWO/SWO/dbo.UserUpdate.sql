USE [TFSPlanTest]
GO
/****** Object:  StoredProcedure [dbo].[UserAreaUpdate]    Script Date: 06/15/2012 17:26:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 6/15/2012
-- Description:	update user 
-- Returns 0 on sucess, 1 - failure
-- =============================================
ALTER PROCEDURE [dbo].[UserUpdate]
	@UserID INT,
	@FullName VARCHAR(100),
	@RoleID INT,
	@AreaCode VARCHAR(100),
	@returnStatus INT = 0 OUT,
	@returnStatusMessage VARCHAR = '' OUT
AS
BEGIN
	SET @returnStatusMessage = ''
	SET @returnStatus  = 0
	
	IF(@FullName = '' )	
		SET @returnStatusMessage += 'Name can not be Empty '

	IF(@RoleID = '' )
		SET @returnStatusMessage += 'Role is required '
		
	IF(@AreaCode = '' )
		SET @returnStatusMessage += 'Area code is required '
		
	IF NOT Exists(SELECT AreaCode FROM tblAreaCodes WHERE AreaCode = @AreaCode and IsActive = 1)
		SET @returnStatusMessage += 'Area code is not valid'
	
	IF NOT Exists(SELECT RoleID from tblRoles where RoleId  = @RoleID and IsActive = 1)
		SET @returnStatusMessage += 'Role is not valid'

	IF (@returnStatusMessage != '')
		SET @returnStatus = 1
	ELSE	
		UPDATE tblUsers SET FullName = @FullName, AreaCode = @AreaCode
			WHERE UserID = @UserID

		--Need to remove the when a user can have multiple roles
		UPDATE UserRoles SET isActive = 0 WHERE UserID = @UserID and RoleID != @RoleID

		IF Exists(SELECT * FROM UserRoles WHERE UserID = @UserID AND RoleID = @RoleID)
			UPDATE UserRoles SET isActive = 1 WHERE UserID = @UserID and RoleID = @RoleID
		ELSE
			INSERT INTO UserRoles (UserID, RoleID) VALUES(@UserID, @RoleID)
END
