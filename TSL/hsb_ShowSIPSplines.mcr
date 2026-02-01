#Version 8
#BeginDescription
Displays "Spline" for beams with the name Spline, and "Timber" for all other beams on a SIP Element Layout

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 31.08.2009  -  version 1.0

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 12
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
* --------------------------------
*
*
* Modified by: Alberto Jena (aj@hsb-cad.com)
* date: 31.08.2008
* version 1.0: First Release.
*/


//Units
U(1,"mm");

PropString sDimStyle(0,_DimStyles,T("Dim Style"));

//String strYesNo[]={T("Yes"),T("No")};

//String strYesNoDiag[]={T("Yes"),T("No"), T("As Text on Top")};
//PropString strYesNoSheet (4,strYesNo,T("Show Diagonal for Sheets"), 1);
//int nYesNoSheet=strYesNo.find(strYesNoSheet );

PropDouble dOffsetFromEl (0, U(50), T("Offset From Element"));

if(_bOnInsert)
{
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

Beam bmAll [] = el.beam();
if (bmAll.length()<1)
	return;
		
Beam bmVer[] = vx.filterBeamsPerpendicularSort(bmAll);

//Body bdBottom (ptOrgEl, vx, vy, vz, U(10000), U(50), U(50), 1, 0, 0);
LineSeg ls (ptOrgEl, ptOrgEl+vx*U(10000)+vy*U(50));
PLine plBottomEl (vz);
plBottomEl.createRectangle(ls, vx, vy);
PlaneProfile ppBottomEl (csEl);
ppBottomEl.joinRing(plBottomEl, FALSE);

Line ln (ptOrgEl, vx);

Plane plnZ(ptOrgEl, vz);

Point3d ptLocation[0];
String sText[0];

for (int i=0; i<bmVer.length(); i++)
{
	Beam bm=bmVer[i];
	PlaneProfile ppShadow(csEl);
	ppShadow=bm.realBody().shadowProfile(plnZ);
	ppShadow.intersectWith(ppBottomEl);
	if (ppShadow.area()>U(2)*U(2))
	{
		String sBeamName=bm.name();
		sBeamName.makeUpper();

		if (sBeamName=="SPLINE")
		{
			sText.append("Spline");
		}
		else
		{
			sText.append("Timber");
		}
		ptLocation.append(ln.closestPointTo(bm.ptCen()));
	}
}

Display dp(-1);
dp.dimStyle(sDimStyle);

for (int i=0; i<ptLocation.length(); i++)
{
	Point3d ptToDisplay=ptLocation[i];
	ptToDisplay=ptToDisplay-vy*(dOffsetFromEl);
	ptToDisplay.transformBy(ms2ps);
	dp.draw(sText[i], ptToDisplay, _YW, -_XW, -1, 0);
}




#End
#BeginThumbnail


#End
