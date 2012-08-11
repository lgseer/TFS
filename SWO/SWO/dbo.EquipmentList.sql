SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 4/14/2012
-- Updated: 4/16/2012 convert added in filters
-- Updated: 4/17/2012 @qryWhereText issue handled, Convert Date style set to 113
-- Description:	Equipment Listing
-- 
-- =============================================
Alter PROCEDURE [dbo].[EquipmentList]
	@EquipmentID int = 0,
	@Code Varchar(50) = '',
	@ModelCode varchar(50) = '',
	@TypeCategoryID int = 0,
	@AreaCode varchar(100) = '',
	@Purchasedfrom dateTime = '',
	@PurchasedTo datetime = ''
AS
BEGIN
	Declare @DefaultDate datetime = '1/1/1900'
	
	Declare @qryText Varchar(max) 
	= 'Select EquipmentID, E.Code, E.ModelCode, E.TypeCategoryID, C.ClassName,
			E.AreaCode, A.AreaName, E.PurchaseDate, E.[Description], E.PhotoID, P.PhotoKey
		from tblEquipments E
			inner join tblEquipmentClasses C on E.TypeCategoryID = C.EquipmentClassID
			inner join tblAreaCodes A on A.AreaCode = E.AreaCode 
			Left Join tblPhotos P on P.PhotoId = E.PhotoID	'
	
	Declare @qryWhereText varchar(max) =  ' where E.isActive = 1'
	
	IF(@EquipmentID != 0) 
		SET @qryWhereText += ' and E.EquipmentID = ' + cast(@EquipmentID as varchar(10)) + ' '
	ELSE IF(@Code != '')	
		SET @qryWhereText  += ' and E.Code = ''' + @Code +''''
	ELSE
	BEGIN
		If(@ModelCode != '') 
			SET @qryWhereText += ' and E.ModelCode = ''' + @ModelCode + ''''
		IF(@TypeCategoryID != 0) 
			SET @qryWhereText += ' and E.TypeCategoryId = ' + cast(@TypeCategoryID as varchar(10)) + ' '
		IF(@AreaCode !='') 
			SET @qryWhereText  += ' and E.AreaCode = ''' + @AreaCode + ''''
		IF(@Purchasedfrom != @DefaultDate) 
			SET @qryWhereText  += ' and E.PurchaseDate >= ''' + convert(varchar(100), @Purchasedfrom, 113)  + ''''
		If(@PurchasedTo != @DefaultDate) 
			SET @qryWhereText  += ' and E.PurchaseDate <= ''' + convert(varchar(100), @Purchasedfrom, 113)  + ''''
	END

	SET @qryText += @qryWhereText
	--print @qryText
	Execute (@qryText)
END
GO