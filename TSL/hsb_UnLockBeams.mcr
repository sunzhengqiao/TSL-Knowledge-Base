#Version 8
#BeginDescription
Unlocks the beams which have already been locked to an element 

Last modified by: Alberto Jena (aj@hsb-cad.com)
Date: 07.10.2010  -  version 1.1

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
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
	PrEntity ssE("\n"+T("Select Beams"),Beam());
	
	if( ssE.go() ){
		_Beam.append(ssE.beamSet());
	}
	return;
}

for (int i=0; i<_Beam.length(); i++)
{
	Entity ent;
	_Beam[i].setPanhand(ent);
	_Beam[i].setColor(32);
}

eraseInstance();
return;

#End
#BeginThumbnail


#End
