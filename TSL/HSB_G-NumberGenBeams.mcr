#Version 8
#BeginDescription
Last modified by: Robert Pol (support.nl@hsbcad.com)
14.08.2020  -  version 1.00

This tsl numbers all genbeams








#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl numbers all genBeams
/// </summary>

/// <insert>
/// Select a set of elements
/// </insert>

/// <remark Lang=en>
/// </remark>

/// <version  value="1.00" date="14.08.2020"></version>

/// <history>
/// RP - 1.00 - 14.08.2020 	- Pilot version
/// </history>


if (_bOnInsert) 
{
	if (insertCycleCount() > 1) 
	{
		eraseInstance();
		return;
	}
	PrEntity ssGenBeams(T("|Select one or more genbeams|") + T(", <|ENTER|>") + T(" |to select all genbeams|"), GenBeam());
	if (ssGenBeams.go())
	{
		Entity selectedGenBeams[] = ssGenBeams.set();
		if (selectedGenBeams.length() == 0)
		{
			_Entity.append(Group().collectEntities(true, GenBeam(), _kModelSpace));
		}
		else
		{
			_Entity.append(selectedGenBeams);
		}
	}
	return;
}

int allGenBeamsLabeled;
int infiniteLoopCount;
while (allGenBeamsLabeled < 1 || infiniteLoopCount > 50)
{
	for (int g = 0; g < _Entity.length(); g++) {
		
		GenBeam gBm = (GenBeam)_Entity[g];
		if ( ! gBm.bIsValid()) continue;
		gBm.assignPosnum(0);
	}
	allGenBeamsLabeled = true;
	for (int g = 0; g < _Entity.length(); g++) {
		
		GenBeam gBm = (GenBeam)_Entity[g];
		if ( ! gBm.bIsValid()) continue;
		
		int posnum = gBm.posnum();
		if (posnum > -1) continue;
		allGenBeamsLabeled = false;
	}
	infiniteLoopCount ++;
}
eraseInstance();
return;


#End
#BeginThumbnail

















#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End