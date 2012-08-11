SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 4/14/2012
-- Description:	User Listing
-- 
-- =============================================
Alter PROCEDURE [dbo].[UserList]
	@UserName Varchar(100) = '',
	@FullName varchar(100) = '',
	@RoleID int = 0,
	@AreaCode varchar(100) = ''
AS
BEGIN

	--Following query creates duplicate records when user multiple role is implemented
	Declare @qryText Varchar(max) 
	= 'Select U.UserID, UserName, FullName, U.UserPassWord, UR.RoleID, R.RoleName, U.AreaCode, A.AreaName, U.PhotoId, P.PhotoKey 
		from tblUsers U 
			inner join UserRoles UR on UR.UserId = U.UserID
			inner join tblRoles R on UR.RoleId = R.RoleId 
			left join tblAreaCodes A on A.AreaCode = U.AreaCode 
			left Join tblPhotos P on P.PhotoId = U.PhotoID '
	
	Declare @qryWhereText varchar(max) =  ' where U.isActive = 1'
	
	IF(@UserName != '')	
		SET @qryWhereText  += ' and U.UserName = ''' + @UserName +''''
	IF(@FullName != '') 
		SET @qryWhereText += ' and U.FullName like ''' + @FullName + '%'''
	IF(@RoleID != 0) 
		SET @qryWhereText += ' and UR.RoleId = ' + cast(@RoleID as varchar(10)) + ' '
	IF(@AreaCode !='') 
		SET @qryWhereText  += ' and U.AreaCode = ''' + @AreaCode + ''''
	
	SET @qryText += @qryWhereText
	--print @qryText
	Execute (@qryText)
END
GO
