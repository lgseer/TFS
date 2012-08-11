SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 4/19/2012
-- Description:	Add Resource Photo
-- =============================================
Create PROCEDURE [dbo].[ResourcePhotoAdd]
	@ResourceType INT,
	@ResourceID INT,
	@PhotoData varchar(MAX),
	@Type int = 0,
	@PhotoId int = 0 out,
	@returnParam int = 0 out
AS
BEGIN
	
	Declare @PhotoKey  INT  = 99 --HACK VARCHAR(50) =  newID()
	
	IF(@ResourceType = 1)
		IF EXISTS (SELECT UserID FROM tblUsers WHERE UserID = @ResourceID)
			UPDATE tblUsers SET PhotoId = @PhotoKey WHERE UserID = @ResourceID
		ELSE
			SET @returnParam = 1
	ELSE IF(@ResourceType = 2)
		IF EXISTS (SELECT EquipmentID FROM tblEquipments  WHERE EquipmentID = @ResourceID)
			UPDATE tblEquipments SET PhotoId = @PhotoKey WHERE EquipmentID = @ResourceID
		ELSE
			SET @returnParam = 1
	ELSE IF(@ResourceType = 3)
		IF EXISTS(SELECT MaterialID FROM tblMaterials WHERE MaterialID = @ResourceID)
			UPDATE tblMaterials SET PhotoId = @PhotoKey WHERE MaterialID = @ResourceID
		ELSE
			SET @returnParam = 1
	IF (@returnParam != 1) 
	BEGIN
		INSERT INTO tblPhotos ([Type], PhotoKey, Photo)
		VALUES (@Type, cast(@PhotoKey as varchar(50)), @PhotoData) -- temp Hack

		SET @PhotoId = @@IDENTITY
	END
END
GO