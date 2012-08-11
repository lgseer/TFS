SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 4/19/2012
-- Description:	Update Resource Photo
-- =============================================
ALTER PROCEDURE [dbo].[ResourcePhotoUpdate]
	@ResourceType INT,
	@ResourceID INT,
	@PhotoData varchar(MAX),
	@Type int = 0,
	@PhotoId int = 0 out,
	@returnParam int = 0 out
AS
BEGIN
	
	Declare @PhotoKey VARCHAR(50) = NULL
	Declare @NEWID INT  = 99 --HACK VARCHAR(50) =  newID()
	
	IF(@ResourceType = 1)
	BEGIN
		SELECT @PhotoKey = isnull(PhotoId, 0) FROM tblUsers WHERE UserID = @ResourceID
		
		IF (@PhotoKey IS NOT NULL)
		BEGIN
			IF(@PhotoKey = 0)
			BEGIN
				UPDATE tblUsers SET PhotoId = @NEWID WHERE UserID = @ResourceID
				SET @PhotoKey = @NEWID 
			END
		END
		ELSE
			SET @returnParam = 1
	END
	ELSE IF(@ResourceType = 2)
	BEGIN
		SELECT @PhotoKey = isnull(PhotoId, 0) FROM tblEquipments WHERE EquipmentID = @ResourceID
		
		IF (@PhotoKey IS NOT NULL)
		BEGIN
			IF(@PhotoKey = 0)
			BEGIN
				UPDATE tblEquipments SET PhotoId = @NEWID WHERE EquipmentID = @ResourceID
				SET @PhotoKey = @NEWID 
			END
		END
		ELSE
			SET @returnParam = 1
	END
	ELSE IF(@ResourceType = 3)
	BEGIN
		SELECT @PhotoKey = isnull(PhotoId, 0) FROM tblMaterials WHERE MaterialID = @ResourceID
		
		IF (@PhotoKey IS NOT NULL)
		BEGIN
			IF(@PhotoKey = 0)
			BEGIN
				UPDATE tblMaterials SET PhotoId = @NEWID WHERE MaterialID = @ResourceID
				SET @PhotoKey = @NEWID 
			END
		END
		ELSE
			SET @returnParam = 1
	END
	
	INSERT INTO tblPhotos ([Type], PhotoKey, Photo)
	VALUES (@Type, @PhotoKey, @PhotoData)
	
	SET @PhotoId = @@IDENTITY
END
GO