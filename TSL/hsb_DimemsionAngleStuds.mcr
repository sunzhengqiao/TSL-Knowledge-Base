#Version 8
#BeginDescription
Create angle dimensions on the layout for the left and right stud.

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 03.02.2010 - version 1.0

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
* date: 03.02.2010
* version 1.0: Release Version.
*
*/


//Units
U(1,"mm");

PropString sDimStyle(0, _DimStyles, T("Dimension Style"));
PropInt nColor(0, 5, T("Color"));

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

Beam bmVer[]=vx.filterBeamsPerpendicularSort(bmAll);

if (bmVer.length()<1)
	return;

Beam bmLeft;
if (bmVer[0].vecD(vz).dotProduct(vz)<0.98)
	bmLeft=bmVer[0];

Beam bmRight;
if ((bmVer[bmVer.length()-1].vecD(vz)).dotProduct(vz)<0.98)
	bmRight=bmVer[bmVer.length()-1];
	
Display dp(nColor);
dp.dimStyle(sDimStyle);

if (bmLeft.bIsValid())
{
	Vector3d vxBm=bmLeft.vecX();
	if (vxBm.dotProduct(vy)<0)
		vxBm=-vxBm;
	
	Vector3d vWidthBm=bmLeft.vecD(vz);
	Vector3d vHeightBm=bmLeft.vecD(vx);
	
	Vector3d vzBm;
	
	if (bmLeft.dD(vWidthBm)>bmLeft.dD(vHeightBm))
	{
		vzBm=vWidthBm;
	}
	else
	{
		vzBm=vHeightBm;
	}
	
	if (vzBm.dotProduct(vz)>0)
		vzBm=-vzBm;
		
	Vector3d vyBm=vxBm.crossProduct(vzBm);
	vyBm.normalize();
	
	//Change if it's on the left or on the right of the panel
	if (vyBm.dotProduct(vx)>0)
		vyBm=-vyBm;
	
	int nDimBack=FALSE;
	int nSide=1;
	
	if (vzBm.dotProduct(vx)<0)
	{
		nDimBack=TRUE;
		nSide=-1;
	}
	
	Point3d ptPlane=el.ptOrg();
	if (nDimBack)
		ptPlane=ptPlane-vz*(abs(el.dPosZOutlineBack()));
		
	Plane plFace (ptPlane, vz);
	
	Line lnBeam (bmLeft.ptCen()+vyBm*(bmLeft.dD(vyBm)*0.5), vzBm);
	
	Point3d ptBase=lnBeam.intersect(plFace, 0);
	
	Point3d ptLeftUp=ptBase+vz*(-nSide*U(200));
	Point3d ptLeftAngle=ptBase+vzBm*(nSide*U(240));
	
	LineSeg ls (ptBase, ptLeftUp);
	LineSeg ls2 (ptBase, ptLeftAngle);
	
	LineSeg ls3 (ptLeftUp, ptLeftAngle);
	
	double dAngleBm=(vz*-nSide).angleTo(vzBm*nSide);
	
	String strAngle;
	strAngle.formatUnit(dAngleBm, sDimStyle);
	strAngle=strAngle+"°";
	
	Point3d ptToDraw=ls3.ptMid();
	
	LineSeg lsSmLeft (ptLeftUp+vz*U(5)-vx*U(5), ptLeftUp-vz*U(5)+vx*U(5));
	LineSeg lsSmLeft2 (ptLeftAngle-vz*U(5)-vx*U(5), ptLeftAngle+vz*U(5)+vx*U(5));
	
	//Transform the objects to display
	ls.transformBy(ms2ps);
	ls2.transformBy(ms2ps);
	ptToDraw.transformBy(ms2ps);
	lsSmLeft.transformBy(ms2ps);
	lsSmLeft2.transformBy(ms2ps);

	//Display Objects
	dp.draw(ls);
	dp.draw(ls2);
	dp.draw(strAngle, ptToDraw, _XW, _YW, 0, 0);
	dp.draw(lsSmLeft);
	dp.draw(lsSmLeft2);
}


if (bmRight.bIsValid())
{
	Vector3d vxBm=bmRight.vecX();
	if (vxBm.dotProduct(vy)<0)
		vxBm=-vxBm;
	
	Vector3d vWidthBm=bmRight.vecD(vz);
	Vector3d vHeightBm=bmRight.vecD(vx);
	
	Vector3d vzBm;
	
	if (bmRight.dD(vWidthBm)>bmRight.dD(vHeightBm))
	{
		vzBm=vWidthBm;
	}
	else
	{
		vzBm=vHeightBm;
	}
	
	if (vzBm.dotProduct(vz)>0)
		vzBm=-vzBm;
		
	Vector3d vyBm=vxBm.crossProduct(vzBm);
	vyBm.normalize();
	
	//Change if it's on the left or on the right of the panel
	if (vyBm.dotProduct(vx)<0)
		vyBm=-vyBm;
	
	int nDimBack=TRUE;
	int nSide=-1;
	
	if (vzBm.dotProduct(vx)<0)
	{
		nDimBack=FALSE;
		nSide=1;
	}
	
	Point3d ptPlane=el.ptOrg();
	if (nDimBack)
		ptPlane=ptPlane-vz*(abs(el.dPosZOutlineBack()));
		
	Plane plFace (ptPlane, vz);
	
	Line lnBeam (bmRight.ptCen()+vyBm*(bmRight.dD(vyBm)*0.5), vzBm);
	
	Point3d ptBase=lnBeam.intersect(plFace, 0);
	
	Point3d ptLeftUp=ptBase+vz*(-nSide*U(200));
	Point3d ptLeftAngle=ptBase+vzBm*(nSide*U(240));
	
	LineSeg ls (ptBase, ptLeftUp);
	LineSeg ls2 (ptBase, ptLeftAngle);
	
	LineSeg ls3 (ptLeftUp, ptLeftAngle);
	
	double dAngleBm=(vz*-nSide).angleTo(vzBm*nSide);
	
	String strAngle;
	strAngle.formatUnit(dAngleBm, sDimStyle);
	strAngle=strAngle+"°";
	
	Point3d ptToDraw=ls3.ptMid();
	
	LineSeg lsSmLeft (ptLeftUp+vz*U(5)-vx*U(5), ptLeftUp-vz*U(5)+vx*U(5));
	LineSeg lsSmLeft2 (ptLeftAngle-vz*U(5)-vx*U(5), ptLeftAngle+vz*U(5)+vx*U(5));
	
	//Transform the objects to display
	ls.transformBy(ms2ps);
	ls2.transformBy(ms2ps);
	ptToDraw.transformBy(ms2ps);
	lsSmLeft.transformBy(ms2ps);
	lsSmLeft2.transformBy(ms2ps);

	//Display Objects
	dp.draw(ls);
	dp.draw(ls2);
	dp.draw(strAngle, ptToDraw, _XW, _YW, 0, 0);
	dp.draw(lsSmLeft);
	dp.draw(lsSmLeft2);
}




#End
#BeginThumbnail

#End
