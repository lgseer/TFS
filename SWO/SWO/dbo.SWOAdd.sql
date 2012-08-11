USE [TFSPlanTest];
GO
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
-- =============================================
-- Create date: 4/15/2012
-- updated: 6/4/2012
-- Description:	New SWO Addition
-- Returns 0 on sucess, 1 - failure, User Name duplicate
/* Test Script
Declare	@SWONUM Varchar(50) = 'TEMP0003'
Declare	@Description varchar(500)  = 'Test Description 3'
Declare	@PlannedStartDate datetime = '5/1/2012'
Declare	@Priority tinyint = 1
Declare	@NetworkSectionID int = 5 
Declare	@AreaCode Varchar(50) = 'AUK'
Declare	@LocationStart int = 3585
Declare	@LocationEnd int = 3590
Declare	@updatedByUserID INT = 7
Declare @outparam int
exec [SWOAdd] @SWONUM, @Description, @PlannedStartDate, @Priority, @NetworkSectionID,
	@AreaCode, @LocationStart, @LocationEnd, @Activities,@Resources, @updatedByUserID,
	@outparam out
print @outparam
*/
-- =============================================
ALTER PROCEDURE [dbo].[SWOAdd]
	@SWONUM Varchar(50), 
	@Description varchar(500), 
	@PlannedStartDate datetime,
	@Priority tinyint,
	@NetworkSectionID int, 
	@AreaCode Varchar(50),
	@LocationStart int, 
	@LocationEnd int,
	@Status int =0, 
	@updatedByUserID INT,
	@returnStatus int = 0 out
AS
BEGIN
	Declare @SWOID INT
-- Check unique
	IF Exists( Select SWOID from tblSWO where SWONUM = @SWONUM)
	BEGIN
		SET @returnStatus = 1
		RETURN
	END

	INSERT INTO tblSWO(SWONUM, [Description], PlannedStartDate, Priority, 
		NetworkSectionID, AreaCode, LocationStart, LocationEnd,   [Status])
	values (@SWONUM, @Description, @PlannedStartDate, @Priority, 
		@NetworkSectionID, @AreaCode, @LocationStart, @LocationEnd, @Status)
		
	SET @SWOID = @@IDENTITY
	
	INSERT INTO tblSWOUpdates(SWOID, UpdatedBy, Priority, updatedDate)
	Values(@SWOID, @updatedByUserID, @Priority, GETDATE())

END
GO