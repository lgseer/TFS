SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 4/18/2012
-- Description:	Add Photo Data
-- =============================================
ALTER PROCEDURE [dbo].[PhotoAdd]
	@PhotoData varchar(MAX),
	@Type int = 0,
	@PhotoId int = 0 out
AS
BEGIN
	
	INSERT INTO tblPhotos ([Type], PhotoKey, Photo)
	VALUES (@Type, NewID(), @PhotoData)
	
	SET @PhotoId = @@Identity
	
	--Print @PhotoId
	
END
GO
