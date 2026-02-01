#Version 8
#BeginDescription
Shows wall description, section size & panel weight based on density selected in the properties

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 21.01.2010  -  version 1.0

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

* Modified by: Alberto Jena (aj@hsb-cad.com)
* date: 21.01.2010
* version 1.0: Release version
*
*/


//Units
U(1,"mm");


PropString sDimLayout(0,_DimStyles,T("Dim Style"));
PropDouble dFactor (3, U(450), T("Timber density (kg/m3)"));
dFactor.setDescription("Please fill this information so you can get the weight of the frame");

if(_bOnInsert)
{
	_Pt0=getPoint(T("Pick a point where the the information is going to be shown"));
	_Viewport.append(getViewport(T("Select a viewport")));
	
	showDialog();
	
	return;

}//end bOnInsert

setMarbleDiameter(U(0.1));

if( _Viewport.length() == 0 ){
	eraseInstance();
	return;
}

Viewport vp = _Viewport[0];

CoordSys ms2ps = vp.coordSys();

CoordSys ps2ms = ms2ps; ps2ms.invert();

Element el = vp.element();
if( !el.bIsValid() )return;

//Element vectors
CoordSys csEl=el.coordSys();
Vector3d vx = csEl.vecX();
Vector3d vy = csEl.vecY();
Vector3d vz = csEl.vecZ();

Point3d ptOrgEl=csEl.ptOrg();

CoordSys coordvp = vp.coordSys();
Vector3d VecX = coordvp.vecX();
Vector3d VecY = coordvp.vecY();
Vector3d VecZ = coordvp.vecZ();

Beam bmAll [] = el.beam();
if (bmAll.length()<1)
	return;

//Wall Volume
double dElVol;
for(int i = 0; i<bmAll.length(); i++)
{
	dElVol += bmAll[i].volume();
}

Display dp(-1);
dp.dimStyle(sDimLayout, ps2ms.scale());


String strWallDes = el.definition();
Point3d ptDefi = _Pt0;

int nBmW = el.dBeamHeight();
int nElW = el.dBeamWidth();
int nElWeight = dFactor * dElVol /1000000000;

String strWallDetail=strWallDes + " " + nBmW + "x" + nElW;

if (nElWeight>0)
strWallDetail=strWallDetail+" (Frame weight: " + nElWeight + " kg)";

//ptDefi.transformBy(ms2ps);
dp.draw(strWallDetail, ptDefi,  _XW,_YW, 1,1);

#End
#BeginThumbnail

#End
