#Version 8
#BeginDescription
Sets the beam name from B1 to B20

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 09.03.2011  -  version 1.0
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
* -------------------------
*
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 27.05.2008
* version 1.0: Release Version
*
*/

Unit(1,"mm"); // script uses mm

String sBmNames[]={"B1", "B2", "B3", "B4", "B5", "B6", "B7", "B8", "B9", "B10", "B11", "B12", "B13", "B14", "B15", "B16", "B17", "B18", "B19", "B20"};

PropString sName(0, sBmNames, T("Beam Names"));

if(_bOnInsert)
{
	showDialogOnce();
	if (insertCycleCount()>1) { eraseInstance(); return; }
	
	PrEntity ssE(T("Please select beams"), Beam());
 	if (ssE.go())
	{
 		Beam ents[0];
 		ents = ssE.beamSet();
 		for (int i = 0; i < ents.length(); i++ )
		 {
 			Beam bm = (Beam) ents[i];
 			_Beam.append(bm);
 		 }
 	}
	return;
}

if (_Beam.length()==0)
{
	eraseInstance();
	return;
}

for (int e=0; e<_Beam.length(); e++)
{
	Beam bm=_Beam[e];
	bm.setName(sName);
}

eraseInstance();
return;
#End
#BeginThumbnail

#End
