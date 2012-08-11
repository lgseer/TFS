Declare	@SWOID int = 12
Declare	@Activities XML 
Set @Activities ='
<actvts>	
	<acvt oid="2" aid="2">
		<C>XYZ</C><D>Description</D>	
		<EW>4</EW><ED>4</ED><EH>4</EH>
		<FB>Feed Back Text</FB>
		<ES>03 Jul 2012 12:30</ES>
		<res rtype="1">
			<rid>10</rid>
			<ctgry>1</ctgry>
			<EngType>1</EngType>
			<il>0</il>
			<mqt>0</mqt>
			<mpr>0</mpr>
		</res>
		<res rtype="1" eid="211">
			<rid>3</rid>
			<ctgry>1</ctgry>
			<EngType>1</EngType>
			<il>false</il>
			<mqt>0</mqt>
			<mpr>0</mpr>
		</res>
	</acvt>
	<acvt oid="1" aid="1">
    <C>ABC</C><D>Description ABC</D>	
		<EW>4</EW><ED>4</ED><EH>4</EH>
		<FB>Feed Back Text</FB>
		<ES>1/5/2012</ES>
		<res rtype="1">
			<rid>10</rid>
			<ctgry>1</ctgry>
			<EngType>1</EngType>
			<il>0</il>
			<mqt>0</mqt>
			<mpr>0</mpr>
		</res>
		<res rtype="1">
			<rid>3</rid>
			<ctgry>1</ctgry>
			<EngType>1</EngType>
			<il>0</il>
			<mqt>0</mqt>
			<mpr>0</mpr>
		</res>
	</acvt>
	<acvt oid="3" >
		<C>NAC</C><D>Description</D>	
		<EW>4</EW><ED>4</ED><EH>4</EH>
		<FB>Feed Back Text</FB>
		<ES>1/5/2012</ES>
		<res rtype="1">
			<rid>10</rid>
			<ctgry>1</ctgry>
			<EngType>1</EngType>
			<il>0</il>
			<mqt>0</mqt>
			<mpr>0</mpr>
		</res>
		<res rtype="1">
			<rid>3</rid>
			<ctgry>1</ctgry>
			<EngType>1</EngType>
			<il>0</il>
			<mqt>0</mqt>
			<mpr>0</mpr>
		</res>
	</acvt>
</actvts>'
/*
    DELETE RE
    FROM tblSWOActivities SA
      INNER JOIN tblResourceEngagement RE ON RE.ActivityID = SA.SWOActivityID
      LEFT JOIN @Activities.nodes('/actvts/acvt') T(c) 
        ON SA.SWOActivityID = T.c.value('./@aid', 'int') 
    WHERE SA.SWOID = @SWOID AND T.c.value('./@aid', 'int') IS NULL
    
		DELETE SA
    FROM tblSWOActivities SA
      LEFT JOIN @Activities.nodes('/actvts/acvt') T(c) 
        ON SA.SWOActivityID = T.c.value('./@aid', 'int') 
    WHERE SA.SWOID = @SWOID AND T.c.value('./@aid', 'int') IS NULL

    UPDATE SA
      SET SA.Code = T.c.query('C').value('.', 'varchar(50)'),
			SA.[Description] =  T.c.query('D').value('.', 'varchar(1000)'),
      SA.Est_Weeks = T.c.query('EW').value('.', 'int'),
			SA.Est_Days = T.c.query('ED').value('.', 'int'),
			SA.Est_Hours = T.c.query('EH').value('.', 'decimal(12,2)'),
			SA.Feedback = T.c.query('FB').value('.', 'varchar(100)'),
			SA.EstimatedStart = T.c.query('ES').value('.', 'datetime')
    FROM tblSWOActivities SA
      INNER JOIN @Activities.nodes('/actvts/acvt') T(c) 
        ON SA.SWOActivityID = T.c.value('./@aid', 'int') 
    WHERE SA.SWOID = @SWOID 
*/
/*
  SELECT SA.Code, RE.*
  --DELETE RE
    FROM tblResourceEngagement RE 
      INNER JOIN tblSWOActivities SA
        ON SA.SWOActivityID = RE.ActivityID 
      LEFT JOIN @Activities.nodes('/actvts/acvt/res') T(c)  
        ON RE.ActivityID  = T.c.value('../@aid', 'int')
          AND RE.EngagementID = T.c.value('./@eid', 'int')
    WHERE SA.SWOID = @SWOID and T.c.value('./@eid', 'int') is null
*/
/*  
    UPDATE RE SET
      RE.ResourceID = case WHEN T.c.query('rid').value('.', 'int') = 0 THEN NULL
				ELSE T.c.query('rid').value('.', 'int') END,
      RE.ResourceType = T.c.value('./@rtype', 'tinyint'),
      RE.EngagementType = T.c.query('EngType').value('.', 'tinyint'),
      RE.Personnel_isLead = case WHEN T.c.value('./@rtype', 'tinyint') = 1 THEN
				T.c.query('il').value('.', 'bit')
			ELSE NULL END,
      RE.Material_AllocQty = case WHEN T.c.value('./@rtype', 'tinyint') = 3 THEN
				T.c.query('mqt').value('.', 'decimal(12,2)')
			ELSE NULL END,
			RE.Material_UnitPrice = 
			CASE WHEN T.c.value('./@rtype', 'tinyint') = 3 THEN
				T.c.query('mpr').value('.', 'decimal(12,2)') 
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
		INSERT INTO tblSWOActivities(Code, [Description], SWOID, Est_weeks, Est_Days, Est_Hours,
		Feedback, EstimatedStart)
		SELECT T.c.query('C').value('.', 'varchar(50)') as Code,
			T.c.query('D').value('.', 'varchar(1000)') as [Description],
			@SWOID as SWOID,
			T.c.query('EW').value('.', 'int') as EstWeeks,
			T.c.query('ED').value('.', 'int') as EstDays,
			T.c.query('EH').value('.', 'decimal(12,2)') as EstHours,
			T.c.query('FB').value('.', 'varchar(100)') as Feedback,
			T.c.query('ES').value('.', 'datetime') as EstimatedStart
		FROM @Activities.nodes('/actvts/acvt') T(c)
    WHERE T.c.value('./@aid', 'int') is null
    ORDER BY T.c.value('./@oid', 'int') 
*/
      SELECT 
  			case WHEN T.c.query('rid').value('.', 'int') = 0 THEN NULL
  				ELSE T.c.query('rid').value('.', 'int') END as ResourceID,
  			SA.SWOActivityID,
  			
  			T.c.value('./@rtype', 'tinyint') as ResourceType,
  			
  			T.c.query('EngType').value('.', 'tinyint') as EngagementType,
  			
  			case WHEN T.c.value('./@rtype', 'tinyint') = 1 THEN
  				T.c.query('il').value('.', 'bit')
  			ELSE NULL END as IsLead,
  			
  			case WHEN T.c.value('./@rtype', 'tinyint') = 3 THEN
  				T.c.query('mqt').value('.', 'decimal(12,2)')
  			ELSE NULL END as Material_AllocQty,
  			
  			CASE WHEN T.c.value('./@rtype', 'tinyint') = 3 THEN
  				T.c.query('mpr').value('.', 'decimal(12,2)') 
  			 ELSE NULL END as Material_UnitPrice,
  			 
  			case WHEN T.c.query('ctgry').value('.', 'tinyint') = 0 THEN NULL
  				ELSE T.c.query('ctgry').value('.', 'tinyint') END  as [ResourceCategory]
      FROM tblSWOActivities SA
        LEFT JOIN @Activities.nodes('/actvts/acvt/res') T(c)  
          ON SA.Code  = T.c.query('../C').value('.', 'varchar(50)')
      WHERE SA.SWOID = @SWOID AND T.c.value('./@eid', 'int') is NULL
  		ORDER BY T.c.value('../@aid', 'int')
    
--select * from tblswoupdates where SWOID = 12
--select * from tblswoActivities where SWOID = 12
