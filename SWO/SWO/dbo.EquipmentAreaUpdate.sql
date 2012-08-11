SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 4/18/2012
-- Description:	update Equipment Area 
-- Returns 0 on sucess, 1 - failure, Area Code not valid
-- =============================================
Alter PROCEDURE [dbo].[EquipmentAreaUpdate]
	@EquipmentID INT,
	@AreaCode varchar(100) = '',
	@returnStatus int = 0 out
AS
BEGIN
	
	IF Exists(SELECT AreaCode from tblAreaCodes where AreaCode = @AreaCode and IsActive = 1)
		UPDATE tblEquipments SET AreaCode = @AreaCode where EquipmentID = @EquipmentID
	ELSE
		Set @returnStatus = 1
END
GO
