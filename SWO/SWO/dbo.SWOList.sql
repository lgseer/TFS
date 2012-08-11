USE [TFSPlanDev];
GO
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
-- =============================================
-- Create date: 4/15/2012
-- Updated: 4/16/2012 pararmeter ordering, Location filter update, date convert format change and filters formatting
-- Description:	SWO Listing
--
-- =============================================
ALTER PROCEDURE [dbo].[SWOList]
	@SWOID INT = 0,
	@SWONum Varchar(50) = '',
	@Status smallint = 0,
	@dateFrom DateTime = '',
	@dateTo DateTime = '',
	@Priority smallint = 0, 
	@AreaCode varchar(100) = '',
	@NetworkSectionID INT = 0,
	@Location int = 0 --Applied only when @NetworkSectionID is given
AS
BEGIN
	Declare @DefaultDate datetime = '1/1/1900'
	
	Declare @qryText Varchar(max) 
	= 'Select SWOID, SWONUM, [Description], [Status],  PlannedStartDate, ActualStartDate, Priority, 
	   S.NetworkSectionID, N.Code NetworkCode, S.AreaCode, A.AreaName, S.LocationStart, S.LocationEnd, S.Activities, S.Resources,
	   F.StartDate, F.EndDate,
		 Case When SA.ActivityCount > 0 Then 1 Else 0 End as isPlanned,
		 Case When ActualStartDate IS NULL Then 0 Else 1 End as isScheduled,
		 SA.ActivityCount as NumOfActivities,
		 RE.NumOfPersonnel,
		 RE.NumOfEquipments
		 from tblSWO S
		 cross Apply udfGetSWODates(S.SWOID) F 
		 inner join tblNetworkSections N on N.NetworkSectionID = S.NetworkSectionID 
     OUTER Apply (Select COUNT(SWOActivityID) ActivityCount From tblSWOActivities where SWOID = S.SWOID) as SA
     OUTER Apply udf_SWOResourceCount(S.SWOID) RE
     Left join  tblAreaCodes A on A.AreaCode = S.AreaCode '
	
	Declare @qryWhereText varchar(max) =  ' where S.IsActive = 1'

	IF(@SWOID != 0)	
		SET @qryWhereText  += ' and S.SWOID = ' + cast(@SWOID as varchar(10)) +' '
	ELSE IF (@SWONum != '')
		SET @qryWhereText  += ' and S.SWONUM = ''' + @SWONum +''''
	ELSE
	BEGIN
		If(@Status != 0) 
			SET @qryWhereText += ' and S.[Status] = ' + cast(@Status as varchar(10)) +' '
			
		IF(@dateFrom != @DefaultDate) 
			SET @qryWhereText += ' and ISNULL(S.ActualStartDate, S.PlannedStartDate) >= ''' 
				+ convert(varchar(50),@dateFrom, 113) + ''''
				
		IF(@dateTo != @DefaultDate) 
			SET @qryWhereText += ' and ISNULL(S.ActualStartDate, S.PlannedStartDate) <= ''' 
				+ Convert(varchar(50), @dateTo, 113) + ''''
		
		IF(@Priority != 0) 
			SET @qryWhereText += ' and S.Priority = ' + cast(@Priority as varchar(10)) + ' '
			
		IF(@AreaCode !='') 
			SET @qryWhereText  += ' and S.AreaCode = ''' + @AreaCode + ''''
			
		IF(@NetworkSectionID != 0) 
		BEGIN
			SET @qryWhereText += ' and S.NetworkSectionID = ' + cast(@NetworkSectionID as varchar(10)) + ' '
			
			IF(@Location != 0) 
				SET @qryWhereText  += ' and ' + cast(@Location as varchar(10)) 
					+ ' between S.LocationStart AND S.LocationEnd '
		END
	END
	
	SET @qryText += @qryWhereText
	print @qryText
	Execute (@qryText)
END

GO