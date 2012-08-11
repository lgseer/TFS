SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 4/15/2012
-- updated: 4/16/2012 convert date format updated
-- updated 4/17/2012 @qryWhereText issue handled
-- update 6/5/2012 Est Duration fields updated
-- Description:	SWO Actvities Listing
-- [SWOActivtiesList] @dateTo = '4/4/2012'
-- =============================================
ALTER PROCEDURE [dbo].[SWOActivtiesList]
	@SWOActivityID INT = 0,
	@AcvtCode Varchar(50) = '',
	@SWOID int = 0,
	@PreAcvtID int = 0,
	@dateFrom DateTime = '',
	@dateTo DateTime = ''
AS
BEGIN
	Declare @DefaultDate datetime = '1/1/1900'
	
	Declare @qryText Varchar(max) 
	= 'Select SA.SWOActivityID, SA.Code acvtCode, SA.[Description], SA.SWOID, SA.PreAcvtID, 
			SA.Est_weeks, SA.Est_Days, SA.Est_Hours, SA.DurationActual,
			SA.Feedback, SA.EstimatedStart, SA.ActualStart, SA.EstimatedEnd, SA.ActualEnd
		 from tblSWOActivities SA 
			inner join  tblSWO S on SA.SWOID = S.SWOID '
	
	Declare @qryWhereText varchar(max) =  ' where 1 = 1'
	
	IF(@SWOActivityID != 0)	
		SET @qryWhereText  += ' and SA.SWOActivityID = ' + cast(@SWOActivityID as varchar(10)) +' '
	ELSE IF(@PreAcvtID != 0)
		SET @qryWhereText  += ' and SA.PreAcvtID = ' + cast(@PreAcvtID as varchar(10)) +' '
	ELSE
	BEGIN
		If(@SWOID  != 0) 
			SET @qryWhereText += ' and SA.SWOID = ' + cast(@SWOID as varchar(10)) +' '
		IF(@AcvtCode != '') 
			SET @qryWhereText  += ' and SA.Code = ''' + @AcvtCode + ''''
		IF(@dateFrom != @DefaultDate) 
			SET @qryWhereText += ' and ISNULL(SA.ActualStart, SA.EstimatedStart) >= ''' + convert(varchar(100), @dateFrom, 113) + ''''
		IF(@dateTo != @DefaultDate) 
			SET @qryWhereText += ' and ISNULL(SA.ActualStart, SA.EstimatedStart) <= ''' + convert(varchar(100), @dateTo, 113) + ''''

	END
	
	SET @qryText += @qryWhereText
	--print @qryText
	Execute (@qryText)
END