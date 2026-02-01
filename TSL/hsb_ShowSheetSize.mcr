#Version 8
#BeginDescription
Last modified by: Alberto Jena (aj@hsb-cad.com)
15.01.2013  -  version 1.2

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
*  Copyright (C) 2012 by
*  hsbSOFT
*  UK
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
* date: 14.09.2012
* version 1.0: Release Version.
*
* date: 15.01.2013
* version 1.1: Add property to hide posnum.
*
* date: 15.01.2013
* version 1.2: Add property to hide dimention.
*/


//Units
U(1,"mm");

PropString sDimStyle(0, _DimStyles, T("Dimension Style"));
PropInt nColor(0, -1, T("Color"));

String sNoYes[]={"No", "Yes"};

PropString sShowPosnum(1, sNoYes, T("Show Posnum"), 0);
PropString sShowDimention(2, sNoYes, T("Show Dimention"), 0);
//PropDouble dOffset (0, U(100), T("Offset DimLine"));

if(_bOnInsert)
{
	_Viewport.append(getViewport(T("Select a viewport")));
	
	showDialogOnce();
	
	return;

}//end bOnInsert

setMarbleDiameter(U(0.1));

int nPosnum=sNoYes.find(sShowPosnum, 0);
int nDimention=sNoYes.find(sShowDimention, 0);

// coordSys
CoordSys ms2ps, ps2ms;	
	
// paperspace 
Viewport vp;
if (_Viewport.length()==0) return; // _Viewport array has some elements
vp = _Viewport[_Viewport.length()-1]; // take last element of array
_Viewport[0] = vp; // make sure the connection to the first one is lost

// check if the viewport has hsb data
if (!vp.element().bIsValid()) return;

ms2ps = vp.coordSys();
ps2ms = ms2ps;
ps2ms.invert();
Element el = vp.element();
int nZoneIndex = vp.activeZoneIndex();

//Element vectors
CoordSys csEl=el.coordSys();
Vector3d vx = csEl.vecX();
Vector3d vy = csEl.vecY();
Vector3d vz = csEl.vecZ();
Point3d ptOrgEl=csEl.ptOrg();

ptOrgEl.transformBy(ms2ps);
_Pt0=ptOrgEl;

Display dp(nColor);
dp.dimStyle(sDimStyle);

Sheet shAll[]=el.sheet(nZoneIndex);

for (int i = 0; i < shAll.length(); i++)
{
	Sheet sh;
	sh = shAll[i];

	String sTxt;
	String sDisplayText;
	
	String sPosnum=sh.posnum();
	
	sTxt.formatUnit(sh.solidLength(), 2, 0);
	sDisplayText = sTxt;
	
	sTxt.formatUnit(sh.solidWidth(), 2, 0);		
	sDisplayText = sDisplayText + "x" + sTxt;
	
	Point3d ptPosNum=sh.ptCen();
	ptPosNum.transformBy(ms2ps);
	
	String sOutput;
	if (nPosnum)
	{
		sOutput=sPosnum;
		if (nDimention)
			sOutput=sOutput+" "+sDisplayText;
	}
	else
	{
		if (nDimention)
			sOutput=sDisplayText;
	}
	
	dp.draw(sOutput, ptPosNum, _XW, _YW, 0,0);		
}	


#End
#BeginThumbnail


#End
