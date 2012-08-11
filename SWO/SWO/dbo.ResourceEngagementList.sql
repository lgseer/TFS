SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 4/16/2012
-- Description:	SWO Resources Listing
-- updated ON : 4/17/2012,4/18/2012
/*
Declare @Resources XML = ' <resources>
	<res>
		<rid>19</rid>
		<rtype>1</rtype>
		<ast>Apr 14 2012  6:50AM</ast>
		<aend>Apr 18 2012  6:50AM</aend>
	</res>
	<res>
		<rid>17</rid>
		<rtype>1</rtype>
		<ast>Apr 14 2012  6:50AM</ast>
		<aend>Apr 18 2012  6:50AM</aend>
	</res>
	<res>
		<rid>9</rid>
		<rtype>1</rtype>
		<ast>Apr 14 2012  6:50AM</ast>
		<aend>Apr 18 2012  6:50AM</aend>
	</res>
</resources>'
exec ResourceEngagementList  @Resources
*/
-- =============================================
Alter PROCEDURE [dbo].[ResourceEngagementList]
	@Resources XML 
AS
BEGIN
	Declare @RsourceEngagements table( 
		EngagementID int, ResourceID int, ResourceType tinyint, ResourceName varchar(250),
		ResourceCode varchar(50), ResourcePhotoID int,  ResourceAreaCode varchar(50),			
		EngagementType tinyint, SWOID INT, AllocationStart datetime, AllocationEnd datetime, Personnel_IsLead bit, 
		Material_AllocQty decimal(12,2), Material_UnitPrice decimal(12,2), [Description] Varchar(500), SWOAreaCode varchar(50),
		NetworkSectionID int, NetworkSectionCode varchar(50), NSLookup1 VARCHAR(100), NSLookup2 VARCHAR(100),  
		SWOLocationStart int, SWOLocationEnd int)

	Declare @ResID INT
	Declare @ResType tinyINT
	Declare @AllocStart datetime
	Declare @AllocEnd datetime

	Declare Resources Cursor for
		Select T.c.query('rid').value('.', 'int') as ResourceID,
			T.c.query('rtype').value('.', 'tinyint') as ResourceType,
			T.c.query('ast').value('.', 'datetime') as AllocationStart,
			T.c.query('aend').value('.', 'datetime') as AllocationEnd
		from @Resources.nodes('/resources/res') T(c)

	OPEN Resources 
	FETCH NEXT FROM Resources INTO @ResID, @ResType, @AllocStart, @AllocEnd

	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO @RsourceEngagements
		EXEC SWOResourcesList @ResourceType = @ResType, @ResourceID = @ResID, @dateFrom = @AllocStart, @dateTo = @AllocEnd
		
		FETCH NEXT FROM Resources INTO @ResID, @ResType, @AllocStart, @AllocEnd
	END
	Close Resources
	DeALLOCATE Resources

	Select EngagementID, ResourceID, ResourceType, ResourceName, ResourceCode, ResourcePhotoID, P.PhotoKey, ResourceAreaCode,			
		EngagementType, SWOID, AllocationStart, AllocationEnd, Personnel_IsLead, Material_AllocQty, Material_UnitPrice, 
		[Description], SWOAreaCode, NetworkSectionID, NetworkSectionCode, NSLookup1, NSLookup2, SWOLocationStart, SWOLocationEnd
	from @RsourceEngagements RE
		left join tblPhotos P on RE.ResourcePhotoID = P.PhotoID
END