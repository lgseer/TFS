SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 4/17/2012
-- Description:	update Network Sections
-- Returns 0 on sucess, 1 - failure, Netwrok section not available
-- =============================================
CREATE PROCEDURE [dbo].[NetworkSectionUpdate]
	@NetworkSectionID INT,
	@AreaCode varchar(50),
	@Lookup1 varchar(50),
	@Lookup2 varchar(50), 
	@LocationStart int,
	@LocationEnd int,
	@returnStatus int = 0 out
AS
BEGIN
	
	IF Exists(SELECT NetworkSectionID from tblNetworkSections where NetworkSectionID = @NetworkSectionID)
	BEGIN
		UPDATE tblNetworkSections SET AreaCode = @AreaCode, Lookup1 = @Lookup1,
			Lookup2 = @Lookup2, LocationStart = @LocationStart, LocationEnd = @LocationEnd
		where NetworkSectionID = @NetworkSectionID
	END
	ELSE
	BEGIN
		Set @returnStatus = 1
	END
END
GO
