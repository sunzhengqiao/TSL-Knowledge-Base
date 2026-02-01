#Version 8
#BeginDescription
Sets hsbIDs to beams based on the value in the property.

Created by: Alberto Jena (aj@hsb-cad.com)
Date: 17.04.2009 version 1.0

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
*  hsbSOFT IRELAND
*
*  The program may be used and/or copied only with the written
*  permission from hsbSOFT, or in accordance with
*  the terms and conditions stipulated in the agreement/contract
*  under which the program has been supplied.
*
*  All rights reserved.
*
* REVISION HISTORY
* -------------------------
*
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 17.04.2009
* version 1.0: First version
*
*/

Unit (1, "mm");

PropString sId (0, "999", T("ID to set in the Beam"));

if (insertCycleCount()>1) { eraseInstance(); return; }

if( _bOnInsert ){
	if (insertCycleCount()>1) { eraseInstance(); return; }
	if (_kExecuteKey=="")
		showDialogOnce();
	PrEntity ssE(T("|Select a set of beams|"), Beam());
	if (ssE.go()) {
		_Beam.append(ssE.beamSet());
	}
	
	return;
}

String strId=sId;
strId.trimLeft();
strId.trimRight();

for (int i=0; i<_Beam.length(); i++)
{
	
	_Beam[i].setHsbId(strId);
}

eraseInstance();
return;

#End
#BeginThumbnail


#End
