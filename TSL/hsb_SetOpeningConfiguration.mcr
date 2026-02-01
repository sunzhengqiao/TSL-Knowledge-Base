#Version 8
#BeginDescription
Sets the support/non support beam configuration for a set of openings in the stickframe.

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 27.05.2008  -  version 1.0
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

* REVISION HISTORY
* -------------------------
*
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 27.05.2008
* version 1.0: Release Version
*
*/

Unit(1,"mm"); // script uses mm

PropInt nSupBmLeft (0, 1, T("Number Support Beams Left"));
PropInt nNoSupBmLeft (1, 1, T("Number No Support Beams Left"));
PropInt nSupBmRight (2, 1, T("Number Support Beams Right"));
PropInt nNoSupBmRight (3, 1, T("Number No Support Beams Right"));

/*
PropString sDispRep(0, "", T("Show in Disp Rep"));
PropString sLineType(1, _LineTypes, T("Line Type"));
String sModes[]={"Walls", "Beams", "Floors"};
PropString sMode(2, sModes, "Enter the required mode");
String sDimStyleList[]={"Default"};
for (int i=0; i<_DimStyles.length(); i++) {
	sDimStyleList.append(_DimStyles[i]);
}
PropString sDimStyle(3, sDimStyleList, "Override Dimstyle");

PropInt nColor(0, 10, T("Enter colour of line"));
*/


if(_bOnInsert) {
	 if (_kExecuteKey=="") {
		showDialogOnce();
	}
	
	if( insertCycleCount() > 1 ){
		eraseInstance();
		return;
	}
	
	PrEntity ssE (T("Please select Openings"),Opening());
	if (ssE.go())
	{
		Entity ents[0];
		ents = ssE.set();
		for (int i = 0; i < ents.length(); i++ )
		{
 			Opening op = (Opening) ents[i];
			if (op.bIsValid())
			{
 				_Entity.append(op);
			}
 		}
	}
	return;
}

if (_bOnDbCreated || _bOnInsert) {
	setPropValuesFromCatalog(_kExecuteKey);
}

OpeningSF opAll[0];

for (int i = 0; i < _Entity.length(); i++ )
{
	OpeningSF op = (OpeningSF) _Entity[i];
	if (op.bIsValid())
	{
		opAll.append(op);
	}
}

if (opAll.length()<=0)
{
	eraseInstance();
	return;
}

for (int i = 0; i < opAll.length(); i++ )
{
	OpeningSF op=opAll[i];

	op.setNumBeamsSupport(nSupBmLeft); 
	op.setNumBeamsNoSupport(nNoSupBmLeft); 
	op.setNumBeamsSupportRight(nSupBmRight); 
	op.setNumBeamsNoSupportRight(nNoSupBmRight); 

	Element elToUse = op.element();
	if (elToUse.bIsValid())
	{
		//String strContext1 = T("GenerateConstruction");
		//addRecalcTrigger(_kContext, strContext1);
		//if (_bOnRecalc && _kExecuteKey==strContext1) {
		Group grp = elToUse.elementGroup();
		String strName = grp.name();
		pushCommandOnCommandStack("-Hsb_GenerateConstruction "+strName);
	}
}




eraseInstance();
return;
#End
#BeginThumbnail

#End
