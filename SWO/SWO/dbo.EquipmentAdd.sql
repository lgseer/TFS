SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 4/14/2012
-- Description:	New Equipment Addition
-- Updated : Areacode Param datatype
-- Returns 0 on sucess, 1 - failure, User Name duplicate
-- =============================================
ALTER PROCEDURE [dbo].[EquipmentAdd]
	@Code Varchar(50),
	@ModelCode Varchar(50),
	@TypeCategory INT,
	@AreaCode varchar(50),
	@PurchaseDate dateTime,
	@Description varchar(2000),
	@PhotoId int,
	@returnStatus int = 0 out
AS
BEGIN
-- Check User Name unique
	IF Exists( Select Code from tblEquipments where Code = @Code and IsActive = 1)
		SET @returnStatus = 1
	ELSE
		INSERT INTO tblEquipments(Code, ModelCode, TypeCategoryID, AreaCode, PurchaseDate,
		[Description], PhotoId)
		values (@Code, @ModelCode, @TypeCategory, @AreaCode, @PurchaseDate, @Description, @PhotoId)
END
