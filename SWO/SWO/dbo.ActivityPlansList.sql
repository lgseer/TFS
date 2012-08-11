-- =============================================
-- Create date: 4/15/2012
-- Description:	Activity Plans Listing
-- 
-- =============================================
ALTER PROCEDURE [dbo].[ActivityPlansList] 
	@Code Varchar(50) = ''
AS
BEGIN
	Declare @qryText Varchar(max) 
	= 'Select ActivityPlanID, Code, Activities 
		from dbo.tblActivityPlans '
	
	Declare @qryWhereText varchar(max) =  ' where IsActive = 1 '
	
	IF(@Code != '')	SET @qryWhereText  += ' and Code = ''' + @Code +''''
	
	SET @qryText += @qryWhereText
	print @qryText
	Execute (@qryText)
END