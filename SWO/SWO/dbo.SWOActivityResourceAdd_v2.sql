USE [TFSPlanTest];
GO
SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
-- =============================================
-- Create date: 4/15/2012
-- Description:	SWO update for Activity/resource management
-- Returns 0 on sucess, 1 - failure, User Name duplicate
/* Test Script  
DECLARE @updatedByUserID int = 3  
Declare @SWOID int = 12  
Declare @Message VARCHAR(MAX)  
Declare @Activities XML   
Set @Activities ='  
<actvts>   
 <acvt oid="2" aid="2">  
  <C>XYZ</C><D>Description</D>   
  <EW>4</EW><ED>4</ED><EH>4</EH>  
  <FB>Feed Back Text</FB>  
  <ES>1/5/2012</ES>  
  <res rtype="1" eid="209">  
   <ctgry>1</ctgry>  
   <EngType>1</EngType>  
   <il>0</il>  
  </res>  
  <res rtype="2" eid="210">  
   <ctgry>1</ctgry>  
   <EngType>1</EngType>  
  </res>  
  <res rtype="3" eid="211">  
      <rid>3</rid>  
   <EngType>1</EngType>  
   <mqt>100</mqt>  
   <mpr>0</mpr>  
  </res>  
 </acvt>  
 <acvt oid="1" aid="1">  
    <C>ABC</C><D>Description ABC</D>   
  <EW>4</EW><ED>4</ED><EH>4</EH>  
  <FB>Feed Back Text</FB>  
  <ES>1/5/2012</ES>  
  <res rtype="1" eid="206">  
      <rid>1</rid>  
   <ctgry>1</ctgry>  
   <EngType>1</EngType>  
   <il>0</il>  
  </res>  
  <res rtype="2" eid="207">  
   <rid>5</rid>  
      <ctgry>1</ctgry>  
   <EngType>1</EngType>  
  </res>  
  <res rtype="3" eid="208">  
      <rid>3</rid>  
   <EngType>1</EngType>  
   <mqt>100</mqt>  
   <mpr>0</mpr>  
  </res>  
 </acvt>  
</actvts>'  
exec [SWOActivityResourceAdd] @SWOID, @Activities,@updatedByUserID,'',  
 @Message out  
print @Message  
*/  
-- =============================================  
ALTER PROCEDURE [dbo].[SWOActivityResourceAdd]  
 @SWOID INT,  
 @Activities XML,   
 @updatedByUserID INT,  
  @SWOPlannedStartDate datetime ='',  
  @Message VARCHAR(MAX) output  
AS  
BEGIN  
  Declare @DefaultDate datetime = '1/1/1900'  
 IF(CAST(@Activities AS VARCHAR(MAX)) <> '')   
 BEGIN  
    DECLARE @Comments varchar(MAX) = ''  
    DEClARE @tempCount int = 0  
    BEGIN Transaction  
  
    BEGIN TRY  
      
      IF(@SWOPlannedStartDate != @DefaultDate)  
        UPDATE tblSWO SET plannedStartDate = @SWOPlannedStartDate   
          WHERE SWOID = @SWOID  
      ELSE  
      BEGIN  
        SELECT @SWOPlannedStartDate = PlannedStartDate  
        FROM tblSWO   
        WHERE SWOID = @SWOID  
      END  
      --Delete resorces for deleted activities  
      DELETE RE  
      FROM tblSWOActivities SA  
        INNER JOIN tblResourceEngagement RE ON RE.ActivityID = SA.SWOActivityID  
        LEFT JOIN @Activities.nodes('/actvts/acvt') T(c)   
          ON SA.SWOActivityID = T.c.value('./@aid', 'int')   
      WHERE SA.SWOID = @SWOID AND T.c.value('./@aid', 'int') IS NULL  
        
      SET @tempCount = @@ROWCOUNT  
      IF(@tempCount > 0)  
        SET @Comments += '|>' + cast(@tempCount as VARCHAR(10)) + ': Deleted resorces from deleted activities '  
      --Delete deleted activities  
    DELETE SA  
      FROM tblSWOActivities SA  
        LEFT JOIN @Activities.nodes('/actvts/acvt') T(c)   
          ON SA.SWOActivityID = T.c.value('./@aid', 'int')   
      WHERE SA.SWOID = @SWOID AND T.c.value('./@aid', 'int') IS NULL  
  
      SET @tempCount = @@ROWCOUNT  
      IF(@tempCount > 0)  
        SET @Comments += '|>' + cast(@tempCount as VARCHAR(10)) + ': Deleted activities '  
        
      --Update activities  
      UPDATE SA  
        SET SA.Code = T.c.query('C').value('.', 'varchar(50)'),  
     SA.[Description] =  T.c.query('D').value('.', 'varchar(1000)'),  
        SA.Est_Weeks = T.c.query('EW').value('.', 'int'),  
     SA.Est_Days = T.c.query('ED').value('.', 'int'),  
     SA.Est_Hours = T.c.query('EH').value('.', 'decimal(12,2)'),  
     SA.Feedback = T.c.query('FB').value('.', 'varchar(100)'),  
     SA.EstimatedStart = T.c.query('ES').value('.', 'datetime'),  
        SA.OrderID  = T.c.value('./@oid', 'int')  
      FROM tblSWOActivities SA  
        INNER JOIN @Activities.nodes('/actvts/acvt') T(c)   
          ON SA.SWOActivityID = T.c.value('./@aid', 'int')   
      WHERE SA.SWOID = @SWOID   
        
      SET @tempCount = @@ROWCOUNT  
      IF(@tempCount > 0)  
        SET @Comments += '|>' + cast(@tempCount as VARCHAR(10)) + ': activities updated '  
  
      --Insert new activities  
    INSERT INTO tblSWOActivities(Code, [Description], SWOID, Est_weeks, Est_Days, Est_Hours,  
    Feedback, EstimatedStart, OrderID )  
    SELECT T.c.query('C').value('.', 'varchar(50)') as Code,  
     T.c.query('D').value('.', 'varchar(1000)') as [Description],  
     @SWOID as SWOID,  
     T.c.query('EW').value('.', 'int') as EstWeeks,  
     T.c.query('ED').value('.', 'int') as EstDays,  
     T.c.query('EH').value('.', 'decimal(12,2)') as EstHours,  
     T.c.query('FB').value('.', 'varchar(100)') as Feedback,  
     T.c.query('ES').value('.', 'datetime') as EstimatedStart,  
        T.c.value('./@oid', 'int') as OrderID  
    FROM @Activities.nodes('/actvts/acvt') T(c)  
      WHERE T.c.value('./@aid', 'int') is null  
      ORDER BY T.c.value('./@oid', 'int')   
  
      SET @tempCount = @@ROWCOUNT  
      IF(@tempCount > 0)  
        SET @Comments += '|>' + cast(@tempCount as VARCHAR(10)) + ': activities Inserted'  
  
      --update Activity calculated fields  
    --select A.SWOActivityID, B.SWOActivityID, dateadd(hh, A.DurationEstimated, A.EstimatedStart)   
     update A Set A.PreAcvtID = B.SWOActivityID,   
     A.EstimatedEnd = dateadd(WW, isnull(A.Est_weeks, 0),   
          dateadd(DD, isnull(A.Est_Days, 0),   
           dateadd(HH, isnull(A.Est_Hours,0),   
            A.EstimatedStart)))  
     from tblSWOActivities  A  
          inner join @Activities.nodes('/actvts/acvt') T(c)   
            ON T.c.query('C').value('.', 'varchar(50)') = A.Code  
          left join @Activities.nodes('/actvts/acvt') U(c)   
            ON U.c.value('./@oid', 'int')+1 = T.c.value('./@oid', 'int')  
          left join tblSWOActivities  B on B.SWOID = A.SWOID  
            AND B.Code = U.c.query('C').value('.', 'varchar(50)')  
     where A.SWOID = @SWOID  
        
      --Delete resorces removed from updated activities     
      DELETE RE  
      FROM tblResourceEngagement RE   
        INNER JOIN tblSWOActivities SA  
          ON SA.SWOActivityID = RE.ActivityID   
        LEFT JOIN @Activities.nodes('/actvts/acvt/res') T(c)    
          ON RE.ActivityID  = T.c.value('../@aid', 'int')  
            AND RE.EngagementID = T.c.value('./@eid', 'int')  
      WHERE SA.SWOID = @SWOID and T.c.value('./@eid', 'int') is null  
  
      SET @tempCount = @@ROWCOUNT  
      IF(@tempCount > 0)  
        SET @Comments += '|>' + cast(@tempCount as VARCHAR(10)) + ': Deleted resorces for existing activities '  
  
      --update resources from updated activities  
      UPDATE RE SET  
        RE.ResourceID = case WHEN ISNull(T.c.query('rid').value('.', 'int'), 0) = 0 THEN NULL  
      ELSE T.c.query('rid').value('.', 'int') END,  
        RE.ResourceType = T.c.value('./@rtype', 'tinyint'),  
        RE.EngagementType = T.c.query('engtype').value('.', 'tinyint'),  
        RE.Personnel_isLead = case WHEN T.c.value('./@rtype', 'tinyint') = 1 THEN  
      T.c.query('il').value('.', 'bit')  
     ELSE NULL END,  
        RE.Material_AllocQty = case WHEN T.c.value('./@rtype', 'tinyint') = 3 THEN  
       CAST(NullIf(RTrim(T.c.query('mqt').value('.', 'varchar(12)')), '') AS decimal(10,2))
     ELSE NULL END,  
     RE.Material_UnitPrice =   
     CASE WHEN T.c.value('./@rtype', 'tinyint') = 3 THEN  
       CAST(NullIf(RTrim(T.c.query('mpr').value('.', 'varchar(12)')), '') AS decimal(10,2))
      ELSE NULL END,  
     RE.ResourceCategory = case WHEN T.c.query('ctgry').value('.', 'tinyint') = 0 THEN NULL  
      ELSE T.c.query('ctgry').value('.', 'tinyint') END  
      FROM tblResourceEngagement RE  
        INNER JOIN tblSWOActivities SA  
          ON SA.SWOActivityID = RE.ActivityID   
        INNER JOIN @Activities.nodes('/actvts/acvt/res') T(c)    
          ON RE.ActivityID  = T.c.value('../@aid', 'int')  
            AND RE.EngagementID = T.c.value('./@eid', 'int')  
      WHERE SA.SWOID = @SWOID  
  
      SET @tempCount = @@ROWCOUNT  
      IF(@tempCount > 0)  
        SET @Comments += '|>' + cast(@tempCount as VARCHAR(10)) + ': Updated resorces for existing activities '  
  
      --insert resources for updated and new activities   
      INSERT INTO tblResourceEngagement(ResourceID, ActivityID, ResourceType, EngagementType,   
     Personnel_IsLead, Material_AllocQty, Material_UnitPrice, ResourceCategory)  
      SELECT   
     case WHEN ISNULL(T.c.query('rid').value('.', 'int'), 0) = 0 THEN NULL  
      ELSE T.c.query('rid').value('.', 'int') END as ResourceID,  
     SA.SWOActivityID,  
       
     T.c.value('./@rtype', 'tinyint') as ResourceType,  
       
     T.c.query('engtype').value('.', 'tinyint') as EngagementType,  
       
     case WHEN T.c.value('./@rtype', 'tinyint') = 1 THEN  
      ISNULL(T.c.query('il').value('.', 'bit'), NULL)
     ELSE NULL END as IsLead,  
       
     case WHEN T.c.value('./@rtype', 'tinyint') = 3 THEN  
     CAST(NullIf(RTrim(T.c.query('mqt').value('.', 'varchar(12)')), '') AS decimal(10,2))
     ELSE NULL END as Material_AllocQty,  
       
     CASE WHEN T.c.value('./@rtype', 'tinyint') = 3 THEN  
       CAST(NullIf(RTrim(T.c.query('mpr').value('.', 'varchar(12)')), '') AS decimal(10,2))
      ELSE NULL END as Material_UnitPrice,  
        
     case WHEN T.c.query('ctgry').value('.', 'tinyint') = 0 THEN NULL  
      ELSE T.c.query('ctgry').value('.', 'tinyint') END  as [ResourceCategory]  
      FROM tblSWOActivities SA  
        LEFT JOIN @Activities.nodes('/actvts/acvt/res') T(c)    
          ON SA.Code  = T.c.query('../C').value('.', 'varchar(50)')  
      WHERE SA.SWOID = @SWOID AND T.c.value('./@eid', 'int') is NULL  
    ORDER BY T.c.value('../@aid', 'int')  
          
          
      SET @tempCount = @@ROWCOUNT  
      IF(@tempCount > 0)  
        SET @Comments += '|>' + cast(@tempCount as VARCHAR(10)) + ': inserted resorces for new and existing activities '  
      
      EXEC SWOActivityXMLUpdate @SWOID
      
      INSERT INTO tblSWOUpdates(SWOID, UpdatedBy, Status, Priority, UpdatedDate, Comments)  
      SELECT SWOID, @updatedByUserID, Status, Priority, getdate(), @Comments   
        FROM tblSWO S  
        WHERE SWOID = @SWOID  
      COMMIT TRANSACTION  
    END TRY  
    BEGIN CATCH  
      --SET @Message = 'Error: ' + @Comments  
	  SET @Message = 'Error Number: ' +  cast(ERROR_NUMBER() as varchar(15)) + ' |> Message: ' + cast(ERROR_MESSAGE() as varchar(500)) + ' |> Error Line: ' + cast(ERROR_LINE() as varchar(250))
	  print @Message
	  print @Comments
      --SELECT ERROR_NUMBER(), ERROR_MESSAGE(), ERROR_LINE()  
      ROLLBACK TRANSACTION  
    END CATCH  
  END  
END