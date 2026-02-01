#Version 8
#BeginDescription
Removes sheeting which has the material set as "Insulation" from a selected zone.

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 19.03.2012  -  version 1.2

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
*  Copyright (C) 2010 by
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
* Modified by: Chirag Sawjani (csawjani@itw-industry.com)
* date: 17.02.2011
* version 1.0: Release
*
* Modified by: Chirag Sawjani (csawjani@itw-industry.com)
* date: 08.08.2011
* version 1.1: Added Properties to select zone and deletion will only occur if material is called Insulation
*
* date: 08.08.2011
* version 1.2: Bugfix with the zone
*/

//Units
U(1,"mm");

int nValidZones[]={1,2,3,4,5,6,7,8,9,10};
int nRealZones[]={1,2,3,4,5,-1,-2,-3,-4,-5};
PropInt nZones(1, nValidZones, T("Sheet Zone"), 9);

int nZone=nRealZones[nValidZones.find(nZones, 0)];

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

if(_bOnInsert)
{
	if( insertCycleCount()>1 )
	{
		eraseInstance();
		return;
	}
	showDialogOnce();
	PrEntity ssE(T("Select one or More Elements"), ElementWallSF());
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

for( int e=0; e<_Element.length(); e++)
{
	Element el=_Element[e];
	if (!el.bIsValid())
		continue;

	CoordSys csEl = el.coordSys();
	Vector3d vx = csEl.vecX();
	Vector3d vy = csEl.vecY();
	Vector3d vz = csEl.vecZ();
	_Pt0=csEl.ptOrg();
	
	Sheet shAll[]=el.sheet(nZone);
	
	for(int i=0;i<shAll.length();i++)
	{
		Sheet sh=shAll[i];
		if(sh.material()=="Insulation")
		{
			sh.dbErase();
		}
	}
	
	TslInst tslAll[]=el.tslInst();
	for(int i=0;i<tslAll.length();i++)
	{
		TslInst tsl=tslAll[i];
		String sName=tsl.scriptName();
		
		if(sName=="TH_Insulation" || sName=="hsb_Insulation")
		{
			tsl.dbErase();
		}
	}
}

eraseInstance();
return;









#End
#BeginThumbnail





#End
