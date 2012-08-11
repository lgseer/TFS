SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 4/19/2012
-- Description:	Resource Photo Delete
-- =============================================
Create PROCEDURE [dbo].[ResourcePhotoDelete]
	@ReSourceType INT,
	@ResourceID INT
AS
BEGIN

	IF(@ReSourceType = 1)
		update tblUsers SET PhotoId  = NULL WHERE UserID = @ResourceID 
		
	ELSE IF(@ReSourceType = 2)
		update tblEquipments SET PhotoId  = NULL WHERE EquipmentID  = @ResourceID 
		
	ELSE IF(@ReSourceType = 3)
		update tblMaterials SET PhotoID = NULL WHERE MaterialID = @ResourceID
	
END
GO
