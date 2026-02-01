#Version 8
#BeginDescription

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

if (_bOnInsert)
{
	PrEntity ssE(T("|Select entities|"), GenBeam());
	if (ssE.go())
	{
		Entity selectedEntities[] = ssE.set();
		for (int e=0;e<selectedEntities.length();e++)
		{
			GenBeam gBm = (GenBeam)selectedEntities[e];
			if (!gBm.bIsValid())
				continue;
			gBm.setModule("");
		}
	}
	
	eraseInstance();
	return;
}
#End
#BeginThumbnail

#End