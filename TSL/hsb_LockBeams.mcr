#Version 8
#BeginDescription
This TSL can block beams, sheets and panels to an element, stoping them from been remove if the elements are frame.

Last modified by: Alberto Jena (aj@hsb-cad.com)
31.01.2014  -  version 1.2


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 2
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
	
	Entity ent[0];
	PrEntity ssE(T("|Select a set of entities|"), Entity());
	if (ssE.go()) 
	{
		ent = ssE.set();
	}
	
	for (int i=0; i<ent.length(); i++)
	{
		GenBeam gbm=(GenBeam) ent[i];
		if (gbm.bIsValid())
		{
			_GenBeam.append(gbm);
		}
	}
	
	return;
}

for (int i=0; i<_GenBeam.length(); i++)
{
	Element el=_GenBeam[i].element();
	_GenBeam[i].setPanhand(el);
	_GenBeam[i].setColor(233);
}

eraseInstance();
return;


#End
#BeginThumbnail



#End
