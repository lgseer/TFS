SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 4/16/2012
-- Description:	Material Listing
-- 
-- =============================================
Alter PROCEDURE [dbo].[MaterialList]
	@Code Varchar(50) = '',
	@MaterialClassID int = 0,
	@Name varchar(50) = ''
AS
BEGIN
	
	Declare @qryText Varchar(max) 
	= 'select MaterialID, M.Code, M.MaterialClassID, MC.Code MCCode, MC.ClassName, 
			Name, UnitCode, StockQuantity, UnitPrice, AreaCode, PhotoID 
		from tblMaterials M
		inner join tblMaterialClasses MC on MC.MaterialClassID = M.MaterialClassID'

	Declare @qryWhereText varchar(max) =  ' where M.isActive = 1'
	
	IF(@Code != '')	
		SET @qryWhereText  += ' and M.Code = ''' + @Code +''''
	IF(@MaterialClassID != 0) 
		SET @qryWhereText += ' and M.MaterialClassID = ' + cast(@MaterialClassID as varchar(10)) + ' '
	If(@Name != '') 
		SET @qryWhereText += ' and M.Name like ''' + @Name + '%'''
	
	SET @qryText += @qryWhereText
	--print @qryText
	Execute (@qryText)
END
GO
