#Version 8
#BeginDescription
Displays the position number on beams in the modelspace

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 11.12.2014  -  version 1.4


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 4
#KeyWords 
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2011 by
*  ITW Industry UK
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
* Modified by: Alberto Jena (aj@hsb-cad.com)
* date: 11.04.2011
* version 1.0: Release Version.
*
* Modified by: Chirag Sawjani (cs@itw-industry.com)
* date: 13.04.2011
* version 1.1: Bugfix on sending text height to clone TSLs
*
* Modified by: Chirag Sawjani (cs@itw-industry.com)
* date: 22.12.2011
* version 1.2: Bugfix offset of TSL and projection to plane on centre of beam 
*
* Modified by: Alberto Jena (aj@hsb-cad.com)
* date: 22.12.2011
* version 1.3: Attach the posnum to Info layer if the beam is part of an element.
*/

Unit (1, "mm");

PropString sDimStyle(0,_DimStyles,T("Dimstyle"));
PropInt nColor (0,130,T("Color"));
PropInt nHeight(1, 80, T("Enter Text Height"));
PropDouble nOffset (0,U(250),T("Offset from Beam"));
PropDouble nOffsetX (1,U(150),T("Offset btw Lines"));
PropDouble dRotation (2,0,T("Set Rotation"));

PropString sDispRepHead(1,"",T("Disp Rep Header"));


if (_bOnInsert || _bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);
if(_bOnInsert)
{
	if (insertCycleCount()>1) { eraseInstance(); return; }

	if (_kExecuteKey=="")
		showDialogOnce();

	PrEntity ssE(T("Please select entities that have position numbers"),Entity());
 	if (ssE.go())
	{
 		Entity ents[0];
 		ents = ssE.set();
 		for (int i = 0; i < ents.length(); i++ )
		 {
 			GenBeam bm1 = (GenBeam) ents[i];
			if(bm1.bIsValid())
			{
	 			_Entity.append(bm1);
				continue;
			}
			
			MassGroup massGroup=(MassGroup) ents[i];
			if(massGroup.bIsValid())
			{
				_Entity.append(massGroup);
				continue;
			}
 		 }
 	}

	//Clonning TSL 
	TslInst tsl;
	String sScriptName = scriptName(); // name of the script
	Vector3d vecUcsX = _XW;
	Vector3d vecUcsY = _YW;
	Entity lstEnts[0];
	Beam lstBeams[0];
	Point3d lstPoints[0];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
		
	lstPropString.append(sDimStyle);
	lstPropString.append(sDispRepHead);

	lstPropInt.append(nColor);
	lstPropInt.append(nHeight);
	lstPropDouble.append(nOffset);
	lstPropDouble.append(nOffsetX);
	lstPropDouble.append(dRotation);
		
	for (int e=0; e<_Entity.length(); e++)
	{
		TslInst tslIns[]=_Entity[e].tslInstAttached();
		for (int i=0; i<tslIns.length(); i++)
		{
			if (tslIns[i].scriptName()==scriptName() && tslIns[i].handle()!=_ThisInst.handle())
				tslIns[i].dbErase();
		}

		lstEnts.setLength(0);
		lstEnts.append(_Entity[e]);
		tsl.dbCreate(sScriptName, vecUcsX,vecUcsY,lstBeams, lstEnts,lstPoints,	lstPropInt, lstPropDouble,lstPropString);
	}

	eraseInstance();
	return;
}

Entity ent=_Entity[0];
GenBeam bm = (GenBeam) _Entity[0];
MassGroup massGroup=(MassGroup)_Entity[0];

setDependencyOnEntity(ent);

CoordSys coordSysEntity=ent.coordSys();
Vector3d vX=coordSysEntity.vecX();
Vector3d vZ=coordSysEntity.vecZ();

Point3d ptDraw;
String strDesc;
Plane pln;
int bAssingedToElement=false;

if (bm.bIsValid())
{
	ptDraw=bm.ptCen();
	strDesc=bm.posnum();
	pln=Plane(bm.ptCen(), bm.vecD(_ZW));

	Element el=bm.element();

	if (el.bIsValid())
	{
		_ThisInst.assignToElementGroup(el, true, bm.myZoneIndex(), 'I');
		bAssingedToElement=true;
	}
}
else if(massGroup.bIsValid())
{
	ptDraw=coordSysEntity.ptOrg();
	strDesc=massGroup.posnum();
	pln=Plane(ptDraw, _ZW);
}
else
{
	eraseInstance();
	return;
}

CoordSys cs3;
cs3.setToRotation(dRotation, _ZW, ptDraw);
	
Vector3d vecTextX=vX;
vecTextX.transformBy(cs3);
Vector3d vecTextZ=_ZW.crossProduct(vecTextX);
vecTextZ.normalize();

Display dp(nColor);
dp.dimStyle(sDimStyle);
dp.textHeight(nHeight);

int strLength=strDesc.length();
String strModel=strDesc.token(0, "|");


if (!_Map.hasInt("nSetOrg"))
{
	_Pt0=ptDraw+vecTextZ*(nOffset);
	_PtG.append(_Pt0+vecTextX*U(100));
}

_Map.setInt("nSetOrg", TRUE);


vecTextX=_PtG[0]-_Pt0;
vecTextX.normalize();

_Pt0=pln.closestPointTo(_Pt0);
_PtG[0]=pln.closestPointTo(_PtG[0]);
ptDraw=_Pt0;

String test[]=_ThisInst.dispRepNames();

if (sDispRepHead!="")
	dp.showInDispRep(sDispRepHead);

dp.draw(strModel, ptDraw, vecTextX, -vecTextZ, 1, 0, _kDevice);

if(!bAssingedToElement)
{
	_ThisInst.assignToGroups(bm);
}
#End
#BeginThumbnail









#End