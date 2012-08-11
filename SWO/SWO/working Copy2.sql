Declare	@SWOID int = 12
Declare @SWOPlannedStartDate datetime = getdate()
Declare	@Activities XML 
Set @Activities ='
<actvts>	
	<acvt oid="2" aid="2">
		<C>XYZ</C><D>Description</D>	
		<EW>4</EW><ED>4</ED><EH>4</EH>
		<FB>Feed Back Text</FB>
		<ES>1/5/2012</ES>
		<resources> 
			<res oid="1" rtype="1">
				<rid>10</rid>
				<ctgry>1</ctgry>
				<EngType>1</EngType>
				<il>0</il>
				<mqt>0</mqt>
				<mpr>0</mpr>
			</res>
			<res oid="2" rtype="1">
				<rid>3</rid>
				<ctgry>1</ctgry>
				<EngType>1</EngType>
				<il>0</il>
				<mqt>0</mqt>
				<mpr>0</mpr>
			</res>
		</resources>
	</acvt>
	<acvt oid="1" aid="1">
    <C>ABC</C><D>Description ABC</D>	
		<EW>4</EW><ED>4</ED><EH>4</EH>
		<FB>Feed Back Text</FB>
		<ES>1/5/2012</ES>
		<resources> 
			<res oid="1" rtype="1">
				<rid>10</rid>
				<ctgry>1</ctgry>
				<EngType>1</EngType>
				<il>0</il>
				<mqt>0</mqt>
				<mpr>0</mpr>
			</res>
			<res oid="2" rtype="1">
				<rid>3</rid>
				<ctgry>1</ctgry>
				<EngType>1</EngType>
				<il>0</il>
				<mqt>0</mqt>
				<mpr>0</mpr>
			</res>
		</resources>		
	</acvt>
	<acvt oid="3" >
		<C>NAC</C><D>Description</D>	
		<EW>4</EW><ED>4</ED><EH>4</EH>
		<FB>Feed Back Text</FB>
		<ES>1/5/2012</ES>
		<resources> 
			<res oid="1" rtype="1">
				<rid>10</rid>
				<ctgry>1</ctgry>
				<EngType>1</EngType>
				<il>0</il>
				<mqt>0</mqt>
				<mpr>0</mpr>
			</res>
			<res oid="2" rtype="1">
				<rid>3</rid>
				<ctgry>1</ctgry>
				<EngType>1</EngType>
				<il>0</il>
				<mqt>0</mqt>
				<mpr>0</mpr>
			</res>
		</resources>
	</acvt>
</actvts>';

WIth SActvts As
(
  SELECT A.SWOID, A.SWOActivityID, A.Code, T.c.value('./@oid', 'int') OID,
    NULL PrevActvityID
  from tblSWOActivities  A
  inner join @Activities.nodes('/actvts/acvt') T(c) 
    ON T.c.query('C').value('.', 'varchar(50)') = A.Code
  where A.SWOID = @SWOID and T.c.value('./@oid', 'int') = 1
  union all
  SELECT A.SWOID, A.SWOActivityID, A.Code, T.c.value('./@oid', 'int') OID,
    ac.SWOActivityID
  from tblSWOActivities A 
  inner join @Activities.nodes('/actvts/acvt') T(c) 
    ON T.c.query('C').value('.', 'varchar(50)') = A.Code
  inner join SActvts ac on A.SWOID = ac.SWOID 
    AND A.Code != ac.code
    AND T.c.value('./@oid', 'int') = ac.OID + 1
)
SELECT * from SActvts;