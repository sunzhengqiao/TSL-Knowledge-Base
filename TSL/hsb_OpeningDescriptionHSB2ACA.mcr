#Version 8
#BeginDescription
Last modified by: Alberto Jena (aj@hsb-cad.com)
28.02.2013  -  version 1.0
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

* REVISION HISTORY
* -------------------------
*
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 28.02.2013
* version 1.0: Release Version
*
*/

if (_bOnInsert)
{
	if( insertCycleCount() > 1 )
	{
		eraseInstance();
		return;
	}
	
	PrEntity ssOpening(T("Select openings"), OpeningSF());
	if( ssOpening.go() ){
		_Entity.append(ssOpening.set());
	}
	
	return;
}

if( _Entity.length() == 0 ){eraseInstance(); return;}


for (int o=0; o<_Entity.length(); o++)
{
	OpeningSF opSF=(OpeningSF) _Entity[o];
	if (!opSF.bIsValid()) continue;
		
	opSF.setDescription(opSF.openingDescr());
}

eraseInstance();
return;







#End
#BeginThumbnail

#End
