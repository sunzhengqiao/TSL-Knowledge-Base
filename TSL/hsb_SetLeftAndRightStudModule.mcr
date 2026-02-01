#Version 8
#BeginDescription
Last modified by: Alberto Jena (aj@hsb-cad.com)
02.11.2011  -  version 1.2

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 2
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
* date: 02.11.2011
* version 1.0: Release Version
*
*/

_ThisInst.setSequenceNumber(-50);

Unit(1,"mm"); // script uses mm

PropInt nColor (0, 32, T("Module Color"));

int nBmType[0];
String sBmName[0];

if(_bOnInsert)
{
	if( insertCycleCount()>1 )
	{
		eraseInstance();
		return;
	}

	if (_kExecuteKey=="")
		showDialogOnce();

	PrEntity ssE(T("Select one or More Elements"), ElementWall());
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}
	
	return;
}

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

if (_Element.length()==0)
{
	eraseInstance();
	return;
}

String sModule=_ThisInst.handle();
int nID=0;

int nErase=false;

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
	
	Plane plnZ (csEl.ptOrg(), vz);
	//String sModules[0];
	Beam bmAll[]=el.beam();
	Beam bmVer[]=vx.filterBeamsPerpendicularSort(bmAll);

	if (bmVer.length()>1)
	{
		Beam bmLeft=bmVer[0];
		if (bmLeft.module()=="")
		{
			String sID=nID;
			bmLeft.setModule(sModule+sID);
			bmLeft.setColor(nColor);
			nID++;
		}
		
		Beam bmRight=bmVer[bmVer.length()-1];
		if (bmRight.module()=="")
		{
			String sID=nID;
			bmRight.setModule(sModule+sID);
			bmRight.setColor(nColor);
			nID++;
		}
		nErase=true;
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
