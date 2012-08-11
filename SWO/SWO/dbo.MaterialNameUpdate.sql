SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 4/18/2012
-- Description:	update Material Stock Quantity
-- 
-- =============================================
Create PROCEDURE [dbo].[MaterialNameUpdate]
	@MaterialID INT,
	@MaterialName VARCHAR(50)
AS
BEGIN
	
	UPDATE tblMaterials SET Name = @MaterialName
	WHERE MaterialID = @MaterialID
	
END
GO