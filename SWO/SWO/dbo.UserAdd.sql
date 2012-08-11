USE [TFSPlanTest]
GO
/****** Object:  StoredProcedure [dbo].[UserAdd]    Script Date: 06/15/2012 18:31:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 4/14/2012
-- Description:	New user Addition
-- Returns 0 on sucess, 1 - failure, User Name duplicate
-- =============================================
ALTER PROCEDURE [dbo].[UserAdd]
	@UserName Varchar(100),
	@UserPassword varchar(200),
	@FullName varchar(100),
	@RoleID int,
	@AreaCode varchar(50),
	@PhotoId int,
	@returnStatus int = 0 out
AS
BEGIN
-- Check User Name unique
	IF Exists( Select Userid from tblUsers where UserName = @UserName and IsActive = 1)
		SET @returnStatus = 1
	ELSE
		INSERT INTO tblUsers(UserName, UserPassword, FullName, AreaCode, PhotoId)
		values (@UserName, @UserPassword, @FullName, @AreaCode, @PhotoId)
		
		INSERT INTO UserRoles(UserID, RoleID) VALUES(@@IDENTITY, @RoleID)
		
END
