SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 4/17/2012
-- Description:	Network Section Listing
-- [NetworkSectionsList] @Location = 24565
-- =============================================
Alter PROCEDURE [dbo].[NetworkSectionList]
	@NetworkSectionID INT = 0,
	@Code Varchar(50) = '',
	@AreaCode varchar(50) = '',
	@Lookup1 varchar(50) = '',
	@Lookup2 varchar(50) = '', --Appllied only when Lookup1 is provided
	@Location int = 0
--	@LocationStart int = 0,
--	@LocationEnd int = 0
AS
BEGIN

	Declare @qryText Varchar(max) 
	= 'Select NetworkSectionID, Code, AreaCode, Lookup1, Lookup2, 
			LocationStart, LocationEnd, Comment	
		from tblNetworkSections '
	
	Declare @qryWhereText varchar(max) =  ' where 1 = 1 '
	
	IF(@NetworkSectionID != 0)	
		SET @qryWhereText  += ' and NetworkSectionID = ' + cast(@NetworkSectionID as varchar(10)) + ' '
	ELSE IF (@Code != '') 
		SET @qryWhereText += ' and Code = ''' + @Code + ''''
	ELSE
	BEGIN
		IF(@AreaCode !='') 
			SET @qryWhereText  += ' and AreaCode = ''' + @AreaCode + ''''

		If(@Lookup1 != '')
		BEGIN
			SET @qryWhereText += ' and LookUp1 = ''' + @Lookup1 + ''''
			IF(@Lookup2 != '')
				SET @qryWhereText += ' and LookUp2 = ''' + @Lookup2 + ''''
		END

		IF(@Location != 0) 
			SET @qryWhereText  += ' and ' + cast(@Location as varchar(10)) 
				+ ' between LocationStart AND LocationEnd '

	END
	
	SET @qryText += @qryWhereText
	--print @qryText
	Execute (@qryText)
END
GO
