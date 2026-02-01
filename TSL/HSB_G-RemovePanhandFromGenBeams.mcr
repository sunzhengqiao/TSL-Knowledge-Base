#Version 8
#BeginDescription
Last modified by: David Rueda (david.rueda@hsbcad.com)
05.06.2018 - version 1.00
Removes panhand from selected beams
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 0
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
//region History and versioning
/// <summary Lang=en>
///
/// </summary>

/// <insert>
/// Select beams(s)
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <history>
/// DR - 1.00 - 05.06.2018	- Release
/// </history>
//endregion

if (_bOnInsert)
{
	if ( insertCycleCount() > 1 )
	{
		eraseInstance();
		return;
	}
	
	PrEntity ssE("select genBeams");
	ssE.addAllowedClass(GenBeam());
	if (ssE.go())
	{
		Entity ssEntities[] = ssE.set();
		for (int b = 0; b < ssEntities.length(); b++)
			_Entity.append(ssEntities[b]);
	}
	
	if (_Entity.length() == 0)
	{
		eraseInstance();
		return;
	}
	return;
}

if (_Entity.length() == 0)
{
	eraseInstance();
	return;
}

int nGenBeams;
for (int e = 0; e < _Entity.length(); e++)
{
	GenBeam genBeam = (GenBeam)_Entity[e];
	if ( ! genBeam.bIsValid())
		continue;
	
	genBeam.setPanhand(_ThisInst);
	nGenBeams++;
	
}

reportNotice("\n" + nGenBeams+ " " + "genBeams affected");
eraseInstance();
#End
#BeginThumbnail



#End
#BeginMapX

#End