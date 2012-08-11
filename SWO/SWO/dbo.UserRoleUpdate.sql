SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 4/14/2012
-- Description:	New user Addition
-- Returns 0 on sucess, 1 - failure, User Name duplicate
-- =============================================
ALTER PROCEDURE [dbo].[UserRoleUpdate]
	@UserID INT,
	@RoleID INT,
	@isActive BIT = 1,
	@returnStatus INT = 0 OUT,
	@returnStatusMessage VARCHAR = '' OUT
AS
BEGIN
	SET @returnStatusMessage = ''
	
	IF NOT Exists(SELECT RoleID FROM tblRoles WHERE RoleId  = @RoleID and IsActive = 1)
		SET @returnStatusMessage = 'Role is not valid'
	
	IF (@returnStatusMessage != '')
	BEGIN
		--UPDATE tblUsers SET RoleId = @RoleID where UserID = @UserID
		IF NOT EXISTS(SELECT RoleID FROM UserRoles WHERE UserID = @UserID and RoleId  = @RoleID)
			INSERT INTO UserRoles(UserID, RoleID, isActive ) VALUES( @UserID, @RoleID, @isActive)
		ELSE
			UPDATE UserRoles SET isActive = @isActive WHERE UserID = @UserID and RoleId  = @RoleID
	END
	ELSE
	BEGIN
		SET @returnStatus = 1
	END
END
GO
