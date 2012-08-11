SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 4/18/2012
-- Description:	update Material
-- Returns 0 on sucess, 1 - failure, some thing gone wrong
-- =============================================
Create PROCEDURE [dbo].[MaterialUpdate]
	@MaterialID INT,
	@MaterialClassID INT,
	@Name VARCHAR(50),
	@UnitCode VARCHAR(50),
	@AreaCode varchar(100) = '',
	@returnStatus int = 0 out
AS
BEGIN
	
	UPDATE tblMaterials SET Name = @Name, MaterialClassID = @MaterialClassID, AreaCode = @AreaCode, 
		UnitCode = @UnitCode
	WHERE MaterialID = @MaterialID
	
	IF @@ERROR <> 0
		Set @returnStatus = 1
END
GO
