#Version 8
#BeginDescription
Sets the wall height of stickframe walls

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 06.07.2010  -  version 1.0

















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
* date: 21.07.2009
* version 1.01: Release Version
*
* date: 30.06.2010
* version 1.2: Allow it to run from the wall details on generation
*
* date: 01.07.2010
* version 1.3: Assign _KLog to set BeamType Name
*/

Unit(1,"mm"); // script uses mm

PropDouble dBaseHeight(0, 0, T("Base Height"));
dBaseHeight.setDescription(T("Set the base height of the selected elements"));

//PropString sRoofCode(0, "A", T("Roof Code"));
//sRoofCode.setDescription(T("Roof Code that the walls are going to be stretch to"));

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

if(_bOnInsert)
{
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}

	if (_kExecuteKey=="")
		showDialogOnce();

	PrEntity ssE(T("Please select Elements"),ElementWall());
 	if (ssE.go())
	{
 		Entity ents[0];
 		ents = ssE.set();
 		for (int i = 0; i < ents.length(); i++ )
		 {
 			ElementWall el = (ElementWall) ents[i];
 			_Element.append(el);
 		 }
 	}
}

if (_Element.length()==0)
{
	eraseInstance();
	return;
}

for (int e=0; e<_Element.length(); e++)
{
	ElementWall el=(ElementWall) _Element[e];
	
	if (!el.bIsValid()) continue;
	
	Wall wl=(Wall) el;
	if (wl.bIsValid())
	{
		wl.setBaseHeight(dBaseHeight);
	}
	
	//el.setRoofNumber(sRoofCode);
}

eraseInstance();
return;

















#End
#BeginThumbnail







#End
