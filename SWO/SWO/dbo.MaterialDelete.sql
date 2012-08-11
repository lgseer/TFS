SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 4/18/2012
-- Description:	Material delete
-- Returns 0 on sucess, 1 - failure, No Active User Available
-- =============================================
CREATE PROCEDURE [dbo].[MaterialDelete]
	@MaterialID INT,
	@returnStatus int = 0 out
AS
BEGIN
	
	IF Exists(SELECT MaterialID from tblMaterials where MaterialID = @MaterialID and IsActive = 1)
		UPDATE tblMaterials SET IsActive = 0 where MaterialID = @MaterialID
	ELSE
		Set @returnStatus = 1
END
GO