SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 4/18/2012
-- Description:	update Material Class
-- 
-- =============================================
Create PROCEDURE [dbo].[MaterialClassUpdate]
	@MaterialID INT,
	@MaterialClassID int,
	@returnParam int = 0 out
AS
BEGIN
	IF Exists (Select * from tblMaterialClasses where MaterialClassID = @MaterialClassID)
		UPDATE tblMaterials SET MaterialClassID = @MaterialClassID
			WHERE MaterialID = @MaterialID
	ELSE
		SET @returnParam = 1
END
GO