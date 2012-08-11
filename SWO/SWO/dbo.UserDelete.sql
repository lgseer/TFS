USE [TFSPlanTest]
GO
/****** Object:  StoredProcedure [dbo].[UserDelete]    Script Date: 06/15/2012 18:49:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 4/17/2012
-- Description:	User delete
-- Returns 0 on sucess, 1 - failure, No Active User Available
-- =============================================
ALTER PROCEDURE [dbo].[UserDelete]
	@UserID INT,
	@returnStatus INT = 0 OUT
AS
BEGIN
	
	IF EXISTS(SELECT AreaCode FROM tblUsers WHERE UserID = @UserID and IsActive = 1)
	BEGIN
		UPDATE tblUsers SET IsActive = 0 WHERE UserID = @UserID
		UPDate UserRoles Set isActive = 0 WHERE UserID = @UserID
	END
	ELSE
		Set @returnStatus = 1
END
