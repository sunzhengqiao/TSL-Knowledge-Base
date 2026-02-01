#Version 8
#BeginDescription
Convert the beams with a beam code into profiles.

Created by: Alberto Jena (aj@hsb-cad.com)
Date: 09.06.2014 - version 1.0








#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2009 by
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
* date: 09.03.2011
* version 1.0: Release Version
*
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 14.04.2011
* version 1.1: Added Property for Zones
*
* date: 22.11.2012
* version 1.2: Add the option to select a zone and will convert all the beams of that zone into sheets
*
* date: 23.01.2014
* version 1.3: Control the color of the new sheet
*/

_ThisInst.setSequenceNumber(-100);

Unit(1,"mm"); // script uses mm

PropString sFilterBeams(0, "", T("|Convert Beams with Code|"));
sFilterBeams.setDescription(T("|Separate multiple entries by|") +" ';'");

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

if(_bOnInsert)
{
	//_Map.setInt("nExecutionMode", 1);
	//showDialogOnce();
	if (insertCycleCount()>1) { eraseInstance(); return; }
	
	if (_kExecuteKey=="")
		showDialogOnce();
	
	PrEntity ssE("\n"+T("Select a set of elements"),Element());
	
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}
	return;
}


if (_Element.length()==0)
{
	eraseInstance();
	return;
}

// transform filter tsl property into array
String sBeamFilter[0];
String sList = sFilterBeams;

while (sList.length()>0 || sList.find(";",0)>-1)
{
	String sToken = sList.token(0);	
	sToken.trimLeft();
	sToken.trimRight();		
	sToken.makeUpper();
	sBeamFilter.append(sToken);
	//double dToken = sToken.atof();
	//int nToken = sToken.atoi();
	int x = sList.find(";",0);
	sList.delete(0,x+1);
	sList.trimLeft();	
	if (x==-1)
		sList = "";
}

int nErase=FALSE;

for (int e=0; e<_Element.length(); e++)
{
	Element el=_Element[e];
	
	CoordSys csEl = el.coordSys();
	Vector3d vx = csEl.vecX();
	Vector3d vy = csEl.vecY();
	Vector3d vz = csEl.vecZ();
	_Pt0=csEl.ptOrg();

	Beam bmAll[]=el.beam();
	Beam bmToRemove[0];
	Beam bmToConvert[0];
	
	if (bmAll.length()==0) return;
	
	for (int i=0; i<bmAll.length(); i++)
	{
		Beam bm=bmAll[i];
		if (sBeamFilter.find(bm.beamCode().token(0), -1) != -1 )
		{
			bmToConvert.append(bm);
		}
	}
	
	int nCurrentColor=-1;
	String sProfile;
	for (int i=0; i<bmAll.length(); i++)
	{
		Beam bm=bmAll[i];
		if (bm.type()== _kDakCenterJoist)
		{
			sProfile=bm.extrProfile();
			break;
		}
		
	}
	
	for (int i=0; i<bmToConvert.length(); i++)
	{
		Beam bm=bmToConvert[i];
		bm.setExtrProfile(sProfile);
		
	}
	nErase=true;
}


if (_bOnElementConstructed || nErase)
{
	eraseInstance();
	return;
}









#End
#BeginThumbnail



#End