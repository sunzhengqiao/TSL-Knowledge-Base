#Version 8
#BeginDescription
Remove the soleplate and headbinder of the SIP panels

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 24.01.2011 - version 1.0

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2011 by
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
* date: 24.01.2011
* version 1.0: Release Version
*
*/

_ThisInst.setSequenceNumber(-120);

Unit(1,"mm"); // script uses mm

PropString sFilterBeams(0, "D", T("|Exclude Beams with Code|"));
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
int bBmFilter;

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
	Beam bmToErase[0];
	
	for(int i=0;i<bmAll.length();i++)
	{
		Beam bm=bmAll[i];
		if(bm.type()==_kPanelPressureTreatedPlate || bm.type() == _kPanelCapStrip) 
		{
			bmToErase.append(bm);
		}
	}
	
	for(int i=0;i<bmToErase.length();i++)
	{
		Beam bm=bmToErase[i];
		String sBeamCode=bm.beamCode();
		if (sBeamFilter.find(sBeamCode.token(0))==-1)
		{
			
			bm.dbErase();
		}
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
