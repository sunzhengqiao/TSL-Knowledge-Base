#Version 8
#BeginDescription
Last modified by: Alberto Jena (aj@hsb-cad.com)
21.10.2013  -  version 1.0
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
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2008 by
*  hsbSOFT
*  IRELAND
*
*  The program may be used and/or copied only with the written
*  permission from hsbSOFT, or in accordance with
*  the terms and conditions stipulated in the agreement/contract
*  under which the program has been supplied.
*
*  All rights reserved.
*
* REVISION HISTORY
* --------------------------------
*
*/

if (_bOnInsert)
{
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	PrEntity ssE("\n"+T("Select beams"), Beam());
	
	if( ssE.go() ){
		_Beam.append(ssE.beamSet());
	}
	return;
}

for (int i=0; i<_Beam.length(); i++)
{
	Beam bm=_Beam[i];
	String sAllKeys=bm.subMapXKeys();
	if (sAllKeys.find("NoErase", -1) == -1)
	{
		bm.dbErase();
	}
	
	//_Beam[i].setColor(233);
}

eraseInstance();
return;


#End
#BeginThumbnail

#End
