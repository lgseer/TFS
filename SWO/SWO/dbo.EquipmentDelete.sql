SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 4/18/2012
-- Description:	User delete
-- Returns 0 on sucess, 1 - failure, No Active User Available
-- =============================================
CREATE PROCEDURE [dbo].[EquipmentDelete]
	@EquipmentID INT,
	@returnStatus int = 0 out
AS
BEGIN
	
	IF Exists(SELECT EquipmentID from tblEquipments where EquipmentID = @EquipmentID and IsActive = 1)
		UPDATE tblEquipments SET IsActive = 0 where EquipmentID = @EquipmentID
	ELSE
		Set @returnStatus = 1
END
GO