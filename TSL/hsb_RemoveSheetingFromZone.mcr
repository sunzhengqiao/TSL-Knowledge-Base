#Version 8
#BeginDescription
Removes alls sheets from a selected zone

Modified by: Chirag Sawjani (csawjani@itw-industry.com)
Date: 01.03.2012  -  version 1.0




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
* date: 01.03.2012
* version 1.0: Release
*/

_ThisInst.setSequenceNumber(80);

//Units
U(1,"mm");

String sValidZones[]={"1","2","3","4","5","6","7","8","9","10"};
int nRealZones[]={1,2,3,4,5,-1,-2,-3,-4,-5};
PropString sZones (0, sValidZones, T("Sheet Zone"), 9);

int nLocZone=sValidZones.find(sZones, 0);
int nZone=nRealZones[nLocZone];


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

int nErase=FALSE;

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
		sh.dbErase();
	}
	
	
}

if (_bOnElementConstructed || nErase)
{
	eraseInstance();
	return;
}







#End
#BeginThumbnail

#End
