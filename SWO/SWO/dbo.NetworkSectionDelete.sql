SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 4/17/2012
-- Description:	User delete
-- Returns 0 on sucess, 1 - failure,   Network Section not available
-- =============================================
create PROCEDURE [dbo].[NetworkSectionDelete]
	@NetworkSectionID INT,
	@returnStatus int = 0 out
AS
BEGIN
	
	IF Exists(SELECT NetworkSectionID from tblNetworkSections where NetworkSectionID = @NetworkSectionID)
	BEGIN
		DELETE tblNetworkSections where NetworkSectionID = @NetworkSectionID
	END
	ELSE
	BEGIN
		Set @returnStatus = 1
	END
END
GO
