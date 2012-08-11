SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 4/18/2012
-- Description:	Get Photos
-- =============================================
ALTER PROCEDURE [dbo].[PhotoList]
	@Type int = 0,
	@PhotoId int = 0,
	@PhotoKey varchar(50) = ''
AS
BEGIN
	
	Declare @qryText Varchar(max) 
	= 'Select PhotoID, Type, PhotoKey, Photo from tblPhotos '
	
	Declare @qryWhereText varchar(max) =  ' where 1 = 1'
	
	IF(@PhotoId != 0)	
		SET @qryWhereText  += ' and PhotoID = ' + cast(@PhotoId as varchar(10)) +' '
	BEGIN
		IF(@Type != 0)	
			SET @qryWhereText  += ' and Type = ' + cast(@Type as varchar(10)) +' '
			
		IF(@PhotoKey != '') 
			SET @qryWhereText  += ' and PhotoKey = ''' + ltrim(rtrim(@PhotoKey)) + ''''
	END
	
	SET @qryText += @qryWhereText
	--print @qryText
	Execute (@qryText)
	
END
GO
