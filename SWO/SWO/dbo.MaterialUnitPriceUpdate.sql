SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 4/18/2012
-- Description:	update Material Unit Price
-- 
-- =============================================
Alter PROCEDURE [dbo].[MaterialUnitPriceUpdate]
	@MaterialID INT,
	@UnitPrice Decimal(10,2)
AS
BEGIN
	
	UPDATE tblMaterials SET UnitPrice = @UnitPrice
	WHERE MaterialID = @MaterialID
	
END
GO
