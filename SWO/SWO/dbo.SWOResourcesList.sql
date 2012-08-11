SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 4/16/2012
-- Description:	SWO Resources Listing
-- updated ON : 4/17/2012,4/18/2012, 4/20/2012
/*
exec SWOResourcesList @NetworkSectionID = 7, @Location = 1560
declare @tempfrom datetime = dateadd(dd, -6, getdate())
declare @tempTo datetime = dateadd(dd, -2, getdate())
exec SWOResourcesList  @dateFrom = @tempfrom, @dateTo = @tempTo
*/
-- =============================================
Alter PROCEDURE [dbo].[SWOResourcesList]
	@EngagementID INT = 0,
	@ResourceType TINYINT = 0,
	@ResourceID INT = 0, -- Applied only when @ResourceType is given
	@EngagementType TINYINT =0, 
	@SWOID int = 0,
	@dateFrom DateTime = '', -- Filtered if in range of Alllocation Start amd End 
	@dateTo DateTime = '', -- Filtered if in range of Alllocation Start amd End 
	@IsLead BIT = 0, -- 0 Returns All, Applied only when @ResourceType is 1(Personnel)
	@AreaCode VARCHAR(50)='',	-- Applies to Resource Area when @ResourceType is given
								-- Appplies to SWO when @EngagementType is given as 1
	@NetworkSectionID INT = 0,
	@Location INT =0 --Applied only when @NetworkSectionID is given
AS
BEGIN
	Declare @DefaultDate datetime = '1/1/1900'
	
	Declare @qryText Varchar(max) 
	= 'Select RE.EngagementID, RE.ResourceID, RE.ResourceType,
		 CASE WHEN RE.ResourceType = 1 THEN U.FullName 
			WHEN RE.ResourceType = 2 THEN E.ModelCode
			WHEN RE.ResourceType = 3 THEN M.Name END ResourceName,
		 CASE WHEN RE.ResourceType = 1 THEN U.UserName 
			WHEN RE.ResourceType = 2 THEN E.Code
			WHEN RE.ResourceType = 3 THEN M.Code END ResourceCode,
		 CASE WHEN RE.ResourceType = 1 THEN U.PhotoId
			WHEN RE.ResourceType = 2 THEN E.PhotoID
			WHEN RE.ResourceType = 3 THEN M.PhotoID END ResourcePhotoID,
		 CASE WHEN RE.ResourceType = 1 THEN U.AreaCode
			WHEN RE.ResourceType = 2 THEN E.AreaCode
			WHEN RE.ResourceType = 3 THEN M.AreaCode END ResourceAreaCode,			
		 RE.EngagementType, RE.SWOID, RE.AllocationStart, RE.AllocationEnd, 
		 RE.Personnel_IsLead, RE.Material_AllocQty, RE.Material_UnitPrice, S.[Description], S.AreaCode,
		 S.NetworkSectionID, NS.Code NetworkSectionCode, NS.Lookup1, NS.Lookup2,  S.LocationStart SWOLocationStart, 
		 S.LocationEnd SWOLocationEnd
	 from tblResourceEngagement RE
		left join  tblSWO S on RE.SWOID = S.SWOID
		left join tblNetworkSections NS on S.NetworkSectionID = NS.NetworkSectionID
		left join tblUsers U on RE.ResourceType = 1 and RE.ResourceID = U.UserID
		left join tblEquipments E on RE.ResourceType = 2 and RE.ResourceID = E.EquipmentID
		left join tblMaterials M on RE.ResourceType = 3 and RE.ResourceID = M.MaterialID '
	
	Declare @qryWhereText varchar(max) =  ' where RE.IsActive = 1 '
	
	IF(@EngagementID != 0)	
		SET @qryWhereText  += ' and RE.EngagementID = ' + cast(@EngagementID as varchar(10)) +' '
	ELSE
	BEGIN
		If(@ResourceType != 0) 
		BEGIN
			SET @qryWhereText += ' and RE.ResourceType = ' + CAST(@ResourceType as varchar(3)) + ' '
			
			If(@ResourceID != 0) 
				SET @qryWhereText += ' and RE.ResourceID = ' + CAST(@ResourceID as varchar(10)) + ' '
			Else IF(@ResourceType = 1 and @IsLead = 1)
				SET @qryWhereText += ' and RE.Personnel_IsLead = 1 '

			IF(@AreaCode != '') 
			BEGIN
				Declare @TablePrefix Varchar(10) = 'U'
				SET @TablePrefix = CASE WHEN @ResourceType = 1 THEN 'U' 
					WHEN @ResourceType = 2 THEN 'E' 
					WHEN @ResourceType = 3 THEN 'M' END
				
				SET @qryWhereText  +=  ' and ' + @TablePrefix + '.AreaCode = ''' + @AreaCode + ''''
			END
		END 

		If(@EngagementType != 0) 
		BEGIN
			SET @qryWhereText += ' and RE.EngagementType = ' + CAST(@EngagementType as varchar(3)) + ' '
			IF(@EngagementType = 1 )
				BEGIN
					IF (@SWOID  != 0)
						SET @qryWhereText += ' and S.SWOID = ' + cast(@SWOID as varchar(10)) +' '
					ELSE IF(@AreaCode != '') 
						SET @qryWhereText  += ' and S.AreaCode = ''' + @AreaCode + ''''
				END
		END
		
		IF(@dateFrom != @DefaultDate AND @dateTo != @DefaultDate) 
		BEGIN
			Declare @dateFromString VARCHAR(100) = convert(varchar(100), @dateFrom, 113)
			Declare @dateToString VARCHAR(100) = convert(varchar(100), @dateTo, 113)
			
			--/* Modified by Ravi Kiran please replace old code if its not proper way */
			SET @qryWhereText += ' and ( (RE.AllocationStart >= ''' + @dateFromString 
								+ ''' and RE.AllocationEnd <= ''' + @dateToString + ''') OR '
								+ ' (''' + @dateFromString + ''' between RE.AllocationStart and RE.AllocationEnd ) OR ' 
								+ ' ( ''' + @dateToString + ''' between RE.AllocationStart and RE.AllocationEnd ) )'
			END
		ELSE IF(@dateFrom != @DefaultDate)
			SET @qryWhereText += ' and ''' + convert(varchar(100), @dateFrom, 113) 
							+ ''' between RE.AllocationStart AND RE.AllocationEnd '
		ELSE IF(@dateTo != @DefaultDate)
			SET @qryWhereText += ' and ''' + convert(varchar(100), @dateTo, 113) 
							+ ''' between RE.AllocationStart AND RE.AllocationEnd '

		IF(@NetworkSectionID != 0)
		BEGIN
			SET @qryWhereText += ' and S.NetworkSectionID = ' + cast(@NetworkSectionID as varchar(10)) +' '
			IF(@Location != 0) 
				SET @qryWhereText  += ' and ' + cast(@Location as varchar(10)) 
										+ ' between S.LocationStart AND S.LocationEnd '
		END
	END
	
	SET @qryText += @qryWhereText
	--print @qryText
	Execute (@qryText)
END
GO



