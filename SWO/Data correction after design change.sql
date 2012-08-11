INSERT INTO tblResourceEngagement (ResourceID, ResourceType, RoleID, EngagementType, ActivityID, Personnel_IsLead,
	Material_AllocQty, Material_UnitPrice, IsActive )

select --S.SWOID, count(distinct sa.SWOActivityID), COUNT(*)
	 ResourceID, ResourceType,  U.RoleId, EngagementType, sa.SWOActivityID, 
	 Personnel_IsLead, Material_AllocQty, Material_UnitPrice, RE.IsActive
 from TFSPlan.dbo.tblResourceEngagement RE
	inner join  TFSPlan.dbo.tblSWO S on RE.SWOID = S.SWOID 
	inner join  TFSPlan.dbo.tblSWOActivities SA on SA.SWOID = S.SWOID
	left join TFSPlan.dbo.tblUsers U on RE.ResourceType = 1 and RE.ResourceID = U.UserID 

select * from tblResourceEngagement

--select *
--update SA SET SA.EstimatedStart = R.Start
from tblSWOActivities SA
inner join (
select S.SWOID, S.SWOActivityID, max(RE.AllocationEnd) Start
--	MIN(S.EstimatedStart) , max(S.EstimatedEnd), min(RE.AllocationStart), max(RE.AllocationEnd)
	from tblSWOActivities S
		inner join TFSPlan.dbo.tblResourceEngagement RE on S.SWOID = RE.SWOID
	where S.EstimatedEnd = '1900-01-01 00:00:00.000'
group by S.SWOID, S.SWOActivityID) r
	on r.SWOID = SA.SWOID and r.SWOActivityID = SA.SWOActivityID

select *
update SA SET SA.EstimatedEnd = R.endDa
from tblSWOActivities SA
inner join (
select S.SWOID, S.SWOActivityID,  max(RE.AllocationEnd) endDa
	--MIN(S.EstimatedStart) , max(S.EstimatedEnd), min(RE.AllocationStart), max(RE.AllocationEnd)
	from tblSWOActivities S
		inner join TFSPlan.dbo.tblResourceEngagement RE on S.SWOID = RE.SWOID
--	where S.EstimatedEnd = '1900-01-01 00:00:00.000'
group by S.SWOID, S.SWOActivityID
having  max(S.EstimatedEnd) <  max(RE.AllocationEnd)) r
	on r.SWOID = SA.SWOID and r.SWOActivityID = SA.SWOActivityID

select * from tblSWOActivities where EstimatedStart > EstimatedEnd 

