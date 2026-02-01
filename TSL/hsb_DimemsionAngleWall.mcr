#Version 8
#BeginDescription
Create angle dimensions when it finds an angle top plate.

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 18.03.2009 - version 1.0

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
* Modified by: Alberto Jena (aj@hsb-cad.com)
* date: 18.03.2009
* version 1.0: Release Version.
*
*/


//Units
U(1,"mm");

PropString sDimStyle(0, _DimStyles, T("Dimension Style"));
PropInt nColor(0, 5, T("Color"));
PropDouble dOffset (0, U(100), T("Offset DimLine"));

if(_bOnInsert)
{
	_Viewport.append(getViewport(T("Select a viewport")));
	
	showDialog();
	
	return;

}//end bOnInsert

setMarbleDiameter(U(0.1));

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

Beam bmAll[]=el.beam();

Beam bmAngleLeft[0];
Beam bmAngleRight[0];

for (int i=0; i<bmAll.length(); i++)
{
	if (bmAll[i].type()==_kSFAngledTPLeft)
	{
		bmAngleLeft.append(bmAll[i]);
	}
	else if (bmAll[i].type()==_kSFAngledTPRight)
	{
		bmAngleRight.append(bmAll[i]);
	}
}

Beam bmLeft;
Beam bmRight;

if (bmAngleLeft.length()>0)
{
	for (int i=0; i<bmAngleLeft.length()-1; i++)
	{
		for (int j=i+1; j<bmAngleLeft.length(); j++)
		{
			if (vx.dotProduct(bmAngleLeft[i].ptCen()-bmAngleLeft[j].ptCen())>0)
			{
				bmAngleLeft.swap(i, j);
			}
		}
	}
	bmLeft=bmAngleLeft[0];
}


if (bmAngleRight.length()>0)
{
	for (int i=0; i<bmAngleRight.length()-1; i++)
	{
		for (int j=i+1; j<bmAngleRight.length(); j++)
		{
			if (vx.dotProduct(bmAngleRight[i].ptCen()-bmAngleRight[j].ptCen())<0)
			{
				bmAngleRight.swap(i, j);
			}
		}
	}
	bmRight=bmAngleRight[0];
}

Display dp(nColor);
dp.dimStyle(sDimStyle);

if (bmLeft.bIsValid())
{
	Vector3d vxBm=bmLeft.vecX();
	if (vxBm.dotProduct(vy)<0)
		vxBm=-vxBm;
	
	Plane plTopBm (bmLeft.ptCen()+bmLeft.vecD(vy)*bmLeft.dD(vy), bmLeft.vecD(vy));
	Point3d ptVertex[]=bmLeft.realBody().extremeVertices(vxBm);
	Point3d ptLeft=ptVertex[0];
	Line lnLeft (ptLeft, vy);
	ptLeft=lnLeft.intersect(plTopBm, 0);
	
	Point3d ptLeftUp=ptLeft+vy*dOffset;
	Point3d ptLeftAngle=ptLeft+vxBm*dOffset;
	
	LineSeg ls (ptLeft+vy*U(5), ptLeftUp);
	LineSeg ls2 (ptLeft+vxBm*U(5), ptLeftAngle);
	
	LineSeg ls3 (ptLeftUp, ptLeftAngle);
	
	double dAngleBm=vy.angleTo(vxBm);
	
	String strAngle;
	strAngle.formatUnit(dAngleBm, sDimStyle);
	strAngle=strAngle+"°";
	
	Point3d ptToDraw=ls3.ptMid();
	
	PLine plArc(vz);
	plArc.addVertex(ptLeftUp);
	plArc.addVertex(ptLeftAngle, dOffset, TRUE);
	
	LineSeg lsSmLeft (ptLeftUp+vy*U(5)-vx*U(5), ptLeftUp-vy*U(5)+vx*U(5));
	LineSeg lsSmLeft2 (ptLeftAngle-vy*U(5)-vx*U(5), ptLeftAngle+vy*U(5)+vx*U(5));
	
	//Transform the objects to display
	ls.transformBy(ms2ps);
	ls2.transformBy(ms2ps);
	ptToDraw.transformBy(ms2ps);
	plArc.transformBy(ms2ps);
	lsSmLeft.transformBy(ms2ps);
	lsSmLeft2.transformBy(ms2ps);

	//Display Objects
	dp.draw(ls);
	dp.draw(ls2);
	dp.draw(strAngle, ptToDraw, _XW, _YW, 0, -1);
	dp.draw(plArc);
	dp.draw(lsSmLeft);
	dp.draw(lsSmLeft2);
}


if (bmRight.bIsValid())
{
	Vector3d vxBm=bmRight.vecX();
	if (vxBm.dotProduct(vy)<0)
		vxBm=-vxBm;
	
	Plane plTopBm (bmRight.ptCen()+bmRight.vecD(vy)*bmRight.dD(vy), bmRight.vecD(vy));
	Point3d ptVertex[]=bmRight.realBody().extremeVertices(vxBm);
	Point3d ptRight=ptVertex[0];
	Line lnRight (ptRight, vy);
	ptRight=lnRight.intersect(plTopBm, 0);
	
	Point3d ptRightUp=ptRight+vy*dOffset;
	Point3d ptRightAngle=ptRight+vxBm*dOffset;
	
	LineSeg ls (ptRight+vy*U(5), ptRightUp);
	LineSeg ls2 (ptRight+vxBm*U(5), ptRightAngle);
	
	LineSeg ls3 (ptRightUp, ptRightAngle);
	
	double dAngleBm=vy.angleTo(vxBm);
	
	String strAngle;
	strAngle.formatUnit(dAngleBm, sDimStyle);
	strAngle=strAngle+"°";
	
	Point3d ptToDraw=ls3.ptMid();
	
	PLine plArc(vz);
	plArc.addVertex(ptRightAngle);
	plArc.addVertex(ptRightUp, dOffset, TRUE);
	
	LineSeg lsSmRight (ptRightUp+vy*U(5)-vx*U(5), ptRightUp-vy*U(5)+vx*U(5));
	LineSeg lsSmRight2 (ptRightAngle-vy*U(5)+vx*U(5), ptRightAngle+vy*U(5)-vx*U(5));
	
	//Transform the objects to display
	ls.transformBy(ms2ps);
	ls2.transformBy(ms2ps);
	ptToDraw.transformBy(ms2ps);
	plArc.transformBy(ms2ps);
	lsSmRight.transformBy(ms2ps);
	lsSmRight2.transformBy(ms2ps);

	//Display Objects
	dp.draw(ls);
	dp.draw(ls2);
	dp.draw(strAngle, ptToDraw, _XW, _YW, 0, -1);
	dp.draw(plArc);
	dp.draw(lsSmRight);
	dp.draw(lsSmRight2);
}


#End
#BeginThumbnail


#End
