#Version 8
#BeginDescription
Sets beams property <SubLabel> ("Interior","Exterior") from parent wall status
v1.0: 22.apr.2014: David Rueda (dr@hsb-cad.com)
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
/*
 REVISION HISTORY
 -------------------------
 v1.0: 22.apr.2014: David Rueda (dr@hsb-cad.com)
	Release
*/

String sExposureTypes[]={T("|Interior|"),T("|Exterior|")};
if(_bOnInsert)
{
	if( insertCycleCount()>1 )
	{
		eraseInstance();
		return;
	}
	
	PrEntity ssE("\n"+T("|Select element(s)|"),Element());	
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}

	for(int e=0;e< _Element.length();e++)
	{
		if(!_Element[e].bIsValid())
			continue;

		ElementWall el = (ElementWall) _Element[e];
		String sExposure=sExposureTypes[el.exposed()];
	
		if (!el.bIsValid())
			continue;
		
		Beam bmAll [] = el.beam();
		
		for(int b=0;b<bmAll.length();b++)
		{
			Beam bm= bmAll[b];
			bm.setSubLabel(sExposure);
		}
	}
	eraseInstance();
	return;
}

if(_bOnElementConstructed)
{
	if( _Element.length()==0){
		eraseInstance();
		return;
	}
	
	ElementWall el = (ElementWall) _Element[0];
	
	if (!el.bIsValid())
	{
		eraseInstance();
		return;
	}
	
	String sExposure=sExposureTypes[el.exposed()];
	Beam bmAll [] = el.beam();
	
	for(int b=0;b<bmAll.length();b++)
	{
		Beam bm= bmAll[b];
		bm.setSubLabel(sExposure);
	}

	eraseInstance();
	return;
}
#End
#BeginThumbnail

#End
