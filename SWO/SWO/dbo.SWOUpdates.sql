--exec SWOUpdates  @dateTo = '21/4/2012', @UserID = 7
ALTER PROCEDURE SWOUpdates
	@SWOID INT = 0,
	@SWOStatus VARCHAR(100) = '',
	@UserID INT = 0,
	@dateFrom DATETIME = '', 
	@dateTo DATETIME = ''
AS
BEGIN	

	DECLARE @DefaultDate DATETIME = '1/1/1900'
	
	DECLARE @qryText VARCHAR(MAX) 
		= 'SELECT SU.SWOUpdateID, SU.SWOID, SU.[Status] SWOStatusID, SU.Priority, 
			SU.UpdatedDate, SU.Comments,
			U.FullName, U.UserID, U.PhotoId, R.RoleName
		FROM dbo.tblSWOUpdates SU
			INNER JOIN tblSWO S ON SU.SWOID = S.SWOID
			INNER JOIN UserRoles UR ON UR.UserRoleID = SU.UpdatedBy
			INNER JOIN tblUsers U ON U.UserID = UR.UserID
			INNER JOIN tblRoles R ON R.RoleId = UR.RoleID '
	
	DECLARE @qryWhereText VARCHAR(MAX) =  ' WHERE 1 = 1 '
	
	If(@SWOID != 0) 
	BEGIN
		SET @qryWhereText += ' AND S.SWOID = ' + CAST(@SWOID AS VARCHAR(10)) + ' '
	END
	ELSE
	BEGIN
		If(@SWOStatus != '') 
			SET @qryWhereText += ' AND SU.[Status] IN (' + @SWOStatus + ') '

		IF(@dateFrom != @DefaultDate AND @dateTo != @DefaultDate) 
			SET @qryWhereText += ' AND SU.UpdatedDate between ''' + CONVERT(VARCHAR(100), @dateFrom, 113) 
							+ ''' AND ''' + CONVERT(VARCHAR(100), dateadd(dd, 1, @dateTo), 113) + ''' '

		ELSE IF(@dateFrom != @DefaultDate)
			SET @qryWhereText += ' AND SU.UpdatedDate >= ''' + convert(varchar(100), @dateFrom, 113) + ''''
			
		ELSE IF(@dateTo != @DefaultDate)
			SET @qryWhereText += ' AND SU.UpdatedDate < ''' + convert(varchar(100), dateadd(dd, 1, @dateTo), 113) + ''''
	END

	IF(@UserID != 0)
		SET @qryWhereText += ' and U.UserID = ' + cast(@UserID as varchar(10)) +' '

	SET @qryText += @qryWhereText
	--print @qryText
	Execute (@qryText)
END