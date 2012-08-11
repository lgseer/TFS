SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 4/18/2012
-- Description:	update Material Stock Quantity
-- 
-- =============================================
Create PROCEDURE [dbo].[MaterialStockQuantityUpdate]
	@MaterialID INT,
	@MaterialStockQuantity Decimal(10,2)
AS
BEGIN
	
	UPDATE tblMaterials SET StockQuantity = @MaterialStockQuantity
	WHERE MaterialID = @MaterialID
	
END
GO