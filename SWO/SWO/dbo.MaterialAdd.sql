SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 4/16/2012
-- Description:	New Material Addition
-- Returns 0 on sucess, 1 - failure, User Name duplicate
-- =============================================
Create PROCEDURE [dbo].[MaterialAdd]
	@Code Varchar(50),
	@MaterialClassID INT,
	@Name Varchar(50),
	@UnitCode Varchar(50),
	@StockQuantity decimal(10,2),
	@UnitPrice  decimal(10,2),
	@AreaCode varchar(50),
	@PhotoId int,
	@returnStatus int = 0 out
AS
BEGIN
-- Check User Name unique
	IF Exists( Select Code from tblMaterials where Code = @Code and IsActive = 1)
		SET @returnStatus = 1
	ELSE
		INSERT INTO tblMaterials(Code, MaterialClassID, Name, UnitCode, StockQuantity, 
			UnitPrice, AreaCode, PhotoID)
		values (@Code, @MaterialClassID, @Name, @UnitCode, @StockQuantity, @UnitPrice, @AreaCode, @PhotoId)
END
GO
