#Version 8
#BeginDescription
Last modified by: David Rueda (david.rueda@hsbcad.com)
12.06.2017  -  version 1.00
Shows entity's handle for debbuging
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
//region History and versioning
/// <summary Lang=en>
/// Shows entity's handle for debbuging
/// </summary>

/// <insert>
/// Select entity
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <history>
/// DR - 1.00 - 12.06.2017	- Pilot version
/// </history>
//endregion

if(_bOnInsert)
{
	while(true)
	{ 
		Entity ent= getEntity(T("|Select Entity|"));
		if(!ent.bIsValid())
			break;
		reportMessage(TN("|Handle|: ")+ent.handle());
	}
	
	eraseInstance();
	return;	
}
#End
#BeginThumbnail

#End