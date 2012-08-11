CREATE PROCEDURE SWOActivityXMLUpdate
  @SWOID INT
AS 
BEGIN
  Declare @Activities XML
  SET @Activities = ISNULL(
    (
      SELECT * from 
        (
          select 1 as Tag,
            NULL as Parent,
            NULL as [actvts!1],
            NULL as [acvt!2!aid],
            NULL as [acvt!2!oid],
            NULL as [acvt!2!C!ELEMENT],
            NULL as [acvt!2!D!ELEMENT],
            NULL as [acvt!2!EW!ELEMENT],
            NULL as [acvt!2!ED!ELEMENT],
            NULL as [acvt!2!EH!ELEMENT],
            NULL as [acvt!2!ES!ELEMENT],
            NULL as [acvt!2!FB!ELEMENT],
            NULL as [res!3!rtype],
            NULL as [res!3!eid],
            NULL as [res!3!ctgry!ELEMENT],
            NULL as [res!3!ctgryName!ELEMENT],
            NULL as [res!3!engtype!ELEMENT],
            NULL as [res!3!rid!ELEMENT],
            NULL as [res!3!il!ELEMENT],
            NULL as [res!3!mqt!ELEMENT],
            NULL as [res!3!mpr!ELEMENT]
          UNION ALL 
          select 2 as Tag,
            1 as Parent,
            NULL as [actvts!1],
            SA.SWOActivityID as [acvt!2!aid],
            SA.OrderID as [acvt!2!oid],
            SA.Code as [acvt!2!C!ELEMENT],
            SA.[Description] as [acvt!2!D!ELEMENT],
            SA.Est_weeks as [acvt!2!EW!ELEMENT],
            SA.Est_Days as [acvt!2!ED!ELEMENT],
            SA.Est_Hours as [acvt!2!EH!ELEMENT],
            Convert(varchar(100), SA.EstimatedStart, 113) as [acvt!2!ES!ELEMENT],
            SA.Feedback as [acvt!2!FB!ELEMENT],
            NULL as [res!3!rtype],
            NULL as [res!3!eid],
            NULL as [res!3!ctgry!ELEMENT],
            NULL as [res!3!ctgryName!ELEMENT],
            NULL as [res!3!engtype!ELEMENT],
            NULL as [res!3!rid!ELEMENT],
            NULL as [res!3!il!ELEMENT],
            NULL as [res!3!mqt!ELEMENT],
            NULL as [res!3!mpr!ELEMENT]
          FROM tblSWOActivities SA
          WHERE SA.swoid = @SWOID
          UNION ALL
          select 3 as Tag,
            2 as Parent,
            NULL as [actvts!1],
            RE.ActivityID as [acvt!2!aid],
            SA.OrderID as [acvt!2!oid],
            NULL as [acvt!2!C!ELEMENT],
            NULL as [acvt!2!D!ELEMENT],
            NULL as [acvt!2!EW!ELEMENT],
            NULL as [acvt!2!ED!ELEMENT],
            NULL as [acvt!2!EH!ELEMENT],
            NULL as [acvt!2!ES!ELEMENT],
            NULL as [acvt!2!FB!ELEMENT],
            RE.ResourceType as [res!3!rtype],
            RE.EngagementID as [res!3!eid],
            RE.ResourceCategory as [res!3!ctgry!ELEMENT],
            CASE WHEN RE.ResourceType = 1 THEN R.RoleName
              WHEN RE.ResourceType = 2 THEN EC.ClassName
              ELSE NULL END
              as [res!3!ctgryName!ELEMENT],
            RE.EngagementType as [res!3!engtype!ELEMENT],
            RE.ResourceID as [res!3!rid!ELEMENT],
            RE.Personnel_IsLead as [res!3!il!ELEMENT],
            RE.Material_AllocQty as [res!3!mqt!ELEMENT],
            RE.Material_UnitPrice as [res!3!mpr!ELEMENT]
          FROM tblSWOActivities SA
            INNER JOIN tblREsourceEngagement RE ON SA.SWOActivityID = RE.ActivityID
            LEFT JOIN tblRoles R ON RE.ResourceType= 1 
              and R.RoleId = RE.ResourceCategory
            LEFT JOIN tblEquipmentClasses EC ON RE.ResourceType= 2
              and EC.equipmentClassID = RE.ResourceCategory
          WHERE SA.swoid = @SWOID
        ) Sub
      order by [acvt!2!oid], [res!3!eid]
      FOR XML EXPLICIT, TYPE
    ), '')

    UPDATE tblSWO SET Activities = @Activities  
    WHERE SWOID = @SWOID  

END