SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 4/16/2012
-- Description:	To Check Duplicate Codes
-- Returns 0 on sucess, 1 - failure, User Name duplicate
/*  ==== Code Types ====

        Area
        ActivityPlan
        UnitCode
        Role
	SWO
	NetworkSection
	MaterialClass
	Material
        EquipmentClass
        Equipment
        User
        
        
        
       
*/
-- =============================================
ALTER PROCEDURE [dbo].[CheckDuplicateCode]
	@Code Varchar(50), 
	@CodeType varchar(50), 
	@retVal bit = 0 out
AS
BEGIN
	Declare @CodeCount as int
	
	if (@CodeType = 'Area')
	BEGIN
	    Select @CodeCount = count(AreaCode) from tblAreaCodes where AreaCode = @Code
	END
	Else if(@CodeType = 'UnitCode')
	BEGIN
		Select @CodeCount = count(Code) from tblUnitCodes where Code = @Code
	END
	Else if(@CodeType ='ActivityPlan')
	BEGIN
		Select @CodeCount = count(Code) from tblActivityPlans where Code = @Code
	END
	Else if(@CodeType ='Role')
	BEGIN
		Select @CodeCount = count(RoleCode) from tblRoles where RoleCode = @Code
	END
	Else if(@CodeType ='SWO')
	BEGIN
		Select @CodeCount = count(SWONUM) from tblSWO where SWONUM = @Code
	END
	Else if(@CodeType ='NetworkSection')
	BEGIN
		Select @CodeCount = count(Code) from tblNetworkSections where Code = @Code
	END
	Else if(@CodeType ='MaterialClass')
	BEGIN
		Select @CodeCount = count(Code) from tblMaterialClasses where Code = @Code
	END
	Else if(@CodeType ='Material')
	BEGIN
		Select @CodeCount = count(Code) from tblMaterials where Code = @Code
	END
	Else if(@CodeType ='EquipmentClass')
	BEGIN
		Select @CodeCount = count(Code) from tblEquipmentClasses where Code = @Code
	END
	Else if(@CodeType ='Equipment')
	BEGIN
		Select @CodeCount = count(Code) from tblEquipments where Code = @Code
	END
	Else if(@CodeType ='User')
	BEGIN
		Select @CodeCount = count(UserName) from tblUsers where UserName = @Code
	END

	if(@CodeCount > 0)
	BEGIN
	 set @retVal = 1
	END
	
	print @retVal
END
