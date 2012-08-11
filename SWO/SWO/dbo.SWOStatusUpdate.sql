DECLARE @SWOID int = 12
DECLARE @valMessages table(id int, Message varchar(100))

select SA.SWOID, SA.SWOActivityID, sa.code, SA.Description,
from tblSWO S
  left join tblswoActivities  SA on SA.SWOID = S.SWOID
  left join tblResourceEngagement RE on RE.ActivityID = SA.SWOActivityID
where S.SWOID = @SWOID