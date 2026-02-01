#Version 8
#BeginDescription
Displays the amount of overhang or underhang for sheeting on floor cassettes as a piece of text with a defined suffix e.g "32mm Overhang"

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 31.03.2016  -  version 1.7








#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 7
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
* date: 02.02.2011
* version 1.0: Release Version
*
* date: 16.02.2011
* version 1.1: Bugfix with plane profile on sheets
*
* date: 05.04.2011
* version 1.2: Add properties so the customer can change the display of the setback and overhang
*
* date: 12.03.2012
* version 1.3: Altered display so that it works for cassettes looked at from underneath
*
* date: 18.05.2012
* version 1.4: Bugfix, return when no sheets found.
*
* date: 22.11.2012
* version 1.5: Bugfix on vector directions for vz and re-oriented text
*
* date: 14.09.2015
* version 1.5: Improved calculation of shy/oversail as it was using closest point to and was failing by finding an edge which is in line with the segment
*
* date: 31.03.2016
* version 1.7: Changed capsule intersect line segment to start go across the sheet segment, rather than start from the sheet segment
*/


Unit(1,"mm"); // script uses mm

int arZone[]={-5,-4,-3,-2,-1,1,2,3,4,5};
PropInt nZone(0,arZone,"Zone index",5); // index 5 is default

//Used to set the dimensioning layout.
PropString sDimStyle(0, _DimStyles, T("Dimension Style"));

//Used to set the side of the text.
String sArDeltaOnTop[]={T("Above"),T("Below")};
int nArDeltaOnTop[]={TRUE,FALSE};
PropString sDeltaOnTop(1,sArDeltaOnTop,T("Side of delta dimensioning"),0);
int nDeltaOnTop = nArDeltaOnTop[sArDeltaOnTop.find(sDeltaOnTop,0)];

PropDouble dOffsetFromEl (0, U(150, 8), T("Offset From Element"));

String arTextDir[]={"None","Parallel","Perpendicular"};
int arITextDir[]={_kDimNone,_kDimPar, _kDimPerp};

PropString strTextDirD(2,arTextDir,"Delta text direction");
int nTextDirD = arITextDir[arTextDir.find(strTextDirD,0)];

PropString sSetBack (3, "Setback", "Setback sufix");
PropString sOverhang (4, "Overhang", "Overhang sufix");

PropInt nDimColor(1,1,T("Color"));
if (nDimColor < 0 || nDimColor > 255) nDimColor.set(0);


if (_bOnInsert)
{
	showDialogOnce();  
  	Viewport vp = getViewport(T("Select the viewport from which the element is taken")); // select viewport
	_Viewport.append(vp);
	return;
}

// set the diameter of the 3 circles, shown during dragging
setMarbleDiameter(U(4));

Display dp(nDimColor); // use color red
dp.dimStyle(sDimStyle); // dimstyle was adjusted for display in paper space, sets textHeight

Viewport vp;
if (_Viewport.length()==0) return; // _Viewport array has some elements
vp = _Viewport[_Viewport.length()-1]; // take last element of array
_Viewport[0] = vp; // make sure the connection to the first one is lost

// check if the viewport has hsb data
if (!vp.element().bIsValid()) return;

CoordSys ms2ps = vp.coordSys();
CoordSys ps2ms = ms2ps;
ps2ms.invert();
Element el = vp.element();
Opening openings[]=el.opening();
int nZoneIndex = vp.activeZoneIndex();

//Element el = vp.element();
if( !el.bIsValid() )return;

//Element vectors
CoordSys csEl=el.coordSys();
Vector3d vx = csEl.vecX();
Vector3d vy = csEl.vecY();
Vector3d vz = csEl.vecZ();
csEl.vis();
vx.normalize();
vy.normalize();
vz.normalize();

Point3d ptOrgEl=csEl.ptOrg();

Vector3d VecX = ms2ps.vecX();
Vector3d VecY = ms2ps.vecY();
Vector3d VecZ = ms2ps.vecZ();

Plane plnZ(ptOrgEl, vz);

Beam bmAll[]=el.beam();
Sheet shAll[]=el.sheet(nZone);

if(shAll.length()==0){return;}
if(bmAll.length()==0){return;}

PlaneProfile ppSheets(plnZ);
Body bdAllSheets;

for(int n=0; n<shAll.length(); n++)
{
	Sheet sh=shAll[n];
	Body bdSheet=sh.realBody();
	bdAllSheets.combine(bdSheet);
}

ppSheets=bdAllSheets.shadowProfile(plnZ);

ppSheets.shrink(-U(150, 0.2));
ppSheets.shrink(U(150, 0.2));
ppSheets.vis(2);

PlaneProfile ppBeams(plnZ);
Body bdAllBeam;

for(int n=0; n<bmAll.length(); n++)
{
	Beam bm=bmAll[n];
	Body bdBeam=bm.envelopeBody(false, true);

	bdAllBeam.combine(bdBeam);
}

PlaneProfile ppOpenings(plnZ);
for(int o=0;o<openings.length();o++)
{
	//Increase the size of the opening slightly
	Opening op=openings[o];
	PLine pl=op.plShape();
	PlaneProfile pp(plnZ);
	pp.joinRing(pl,false);
	pp.shrink(U(-10));
	ppOpenings.unionWith(pp);
}


ppBeams=bdAllBeam.shadowProfile(plnZ);
ppBeams.shrink(-U(20, 0.2));

//bdAllBeam.vis();

/*
for(int n=0; n<bmAll.length(); n++)
{
	Beam bm=bmAll[n];
	PlaneProfile ppBm(plnZ);
	ppBm=bm.realBody().shadowProfile(plnZ);
	ppBm .transformBy(U(0.01)*vy.rotateBy(n*123.456,vz));
	ppBm.shrink(-U(10, 0.2));
	//ppBm.vis(n);
	int a=ppBeams.unionWith(ppBm);
}*/


ppBeams.shrink(U(20, 0.2));
double dArea=0;
int nIndexAreaBm=-1;

//ppBeams.vis(1);

PLine plAllRingsBm[]=ppBeams.allRings();

for (int i=0; i<plAllRingsBm.length(); i++)
{
	if (plAllRingsBm[i].area()>dArea)
	{
		dArea=plAllRingsBm[i].area();
		nIndexAreaBm=i;
	}
}

PlaneProfile ppBmOutline(plnZ);
ppBmOutline.joinRing(plAllRingsBm[nIndexAreaBm], false);
//ppBmOutline.vis();
dArea=0;
int nIndexAreaSh=-1;

PLine plAllRingsSh[]=ppSheets.allRings();

for (int i=0; i<plAllRingsSh.length(); i++)
{
	if (plAllRingsSh[i].area()>dArea)
	{
		dArea=plAllRingsSh[i].area();
		nIndexAreaSh=i;
	}
}

if (nIndexAreaSh==-1)
	return;

PlaneProfile ppShOutline(plnZ);
ppShOutline.joinRing(plAllRingsSh[nIndexAreaSh], false);

Point3d ptAllBmVertexGrip[] = ppBmOutline.getGripVertexPoints();
Point3d ptAllBmVertex[0];
ptAllBmVertex.append(ptAllBmVertexGrip);
ptAllBmVertex.append(ppBmOutline.getGripEdgeMidPoints());
Point3d ptAllShVertex[]=plAllRingsSh[nIndexAreaSh].vertexPoints(false);

Point3d ptCenSh;
ptCenSh.setToAverage(ptAllShVertex);

//Point3d ptAllShMidPoints[]=ppShOutline.getGripEdgeMidPoints();

LineSeg lsAllBmEdges[0];
for(int i=0;i<=ptAllBmVertexGrip.length();i++)
{
	LineSeg edge;
	if(ptAllBmVertexGrip.length()==i)
	{
		edge=LineSeg(ptAllBmVertex[ptAllBmVertexGrip.length()-1], ptAllBmVertex[0]);
	}
	else
	{
		edge=LineSeg(ptAllBmVertex[i], ptAllBmVertex[i+1]);
	}
	edge.vis(i+1);
	lsAllBmEdges.append(edge);
	
}

for (int i=0; i<ptAllShVertex.length()-1; i++)
{
	LineSeg ls(ptAllShVertex[i], ptAllShVertex[i+1]);
	
	Point3d ptEdge=ls.ptMid();
	ptEdge.vis();
//	Vector3d vRef(ls.ptMid()-ptCenSh);
	
	Vector3d vSegment (ls.ptEnd()-ls.ptStart());
	vSegment.normalize();
	vSegment.vis(ptEdge);
	vz.vis(ptEdge);
	Vector3d vNormal=vSegment.crossProduct(vz);
	vNormal.normalize();
	
	//Determine vRef by checking which point is in the profile
	Vector3d vRef;
	Point3d ptPositive=ptEdge+vNormal*U(5);
	Point3d ptNegative=ptEdge-vNormal*U(5);
	if(ppShOutline.pointInProfile(ptPositive)==_kPointInProfile)
	{
		vRef=Vector3d(ls.ptMid()-ptPositive);
	}
	else
	{
		vRef=Vector3d(ls.ptMid()-ptNegative);
	}
	vRef.normalize();
	vRef.vis(ptEdge);
	
	if (vNormal.dotProduct(vRef)<0)
		vNormal=-vNormal;


	//if the mid point is within the zone of the oepnings we can ignore it
	//Move the point out a slight bit
	if(ppOpenings.pointInProfile(ptEdge+vNormal*U(5))==_kPointInProfile) 
	{
		continue;
	}
	
	//Get a line segment that goes outwards towards the ppBmOutline
	LineSeg lsEdgePerpendicular(ptEdge - vRef * U(10000), ptEdge + vRef * U(10000));

	//Check if any of the outer line segments intersect with this one
	LineSeg lsAux[]={lsEdgePerpendicular};
	lsAux.append(lsAllBmEdges);
	int results[]=LineSeg().findCapsuleIntersections(lsAux, U(1));
	
	int intersectingLineSegments[0];
	
	for(int r=0;r<results.length()-1;r++)
	{
		int firstSegmentIndex = results[r];
		int secondSegmentIndex = results[r+1];
		if(firstSegmentIndex!=0)
		{
			continue; //Intersection not found with lsEdgePerpendicular
		}
		if(firstSegmentIndex==0)
		{
			intersectingLineSegments.append(secondSegmentIndex);
		}
	}
	
	//Find closest segment and get point to dim
	if(intersectingLineSegments.length()==0) { continue; }
	
	double closestDistance = 99999;
	LineSeg closestBoundingSegment;
	for(int n=0;n<intersectingLineSegments.length();n++)
	{
		LineSeg lsCurr = lsAllBmEdges[intersectingLineSegments[n]-1];
		Point3d ptCurrMid = lsCurr.ptMid();
		double distance = abs((ptCurrMid - ptEdge).dotProduct(vRef));
		if(distance < closestDistance)
		{
			closestDistance = distance;
			closestBoundingSegment = lsCurr;	
		}
	}
	
	Point3d ptToDim=closestBoundingSegment.closestPointTo(ptEdge);
	ptEdge.vis();
	ptToDim.vis();
	String sMessage;
	
	double dDist=0;
	Vector3d vDirection(ptEdge-ptToDim);
	//vDirection.vis(ptToDim);
	vNormal.vis(ptToDim);
	dDist=abs(vNormal.dotProduct(vDirection));
	vDirection.normalize();
	if (dDist>U(1))
	{
		sMessage.formatUnit(dDist, 2, 0);
		sMessage=sMessage+"mm ";
		if (vDirection.dotProduct(vNormal)>0)
			sMessage+=sOverhang;
		else
			sMessage+=sSetBack;
	}
	

	csEl.vis();

	Vector3d vXDisp=vNormal.crossProduct(vz);
	vXDisp.normalize();
	Vector3d vecZTranformed=vz;
	vecZTranformed.transformBy(ms2ps);
	vecZTranformed.normalize();
	vecZTranformed.vis(vp.ptCenPS());

	if(_ZW.dotProduct(vecZTranformed)<0)
	{
		vXDisp=-vXDisp;
	}

	
	//Segment Vector
	Vector3d vecSegment;
	Vector3d vecTextX;
	Vector3d vecTextY;
	
	//Assignment
	vecSegment=vSegment;
	vecSegment.transformBy(ms2ps);
	
	//Case A - Text is Horizontal
	if(vecSegment.dotProduct(_YW)==0)
	{
		vecTextX=_XW;
	}

	//Case B - Text is Vertical
	if(vecSegment.dotProduct(_XW)==0)
	{
		vecTextX=_YW;
	}
	
	//Case C - Text is in first quandrant
	if(vecSegment.dotProduct(_XW)>0 && vecSegment.dotProduct(_YW)>0)
	{
		vecTextX=vecSegment;
	}
	if(vecSegment.dotProduct(_XW)<0 && vecSegment.dotProduct(_YW)<0)
	{
		vecTextX=-vecSegment;
	}

	//Case C - Text is in fourth quandrant
	if(vecSegment.dotProduct(_XW)>0 && vecSegment.dotProduct(_YW)<0)
	{
		vecTextX=vecSegment;
	}
	if(vecSegment.dotProduct(_XW)<0 && vecSegment.dotProduct(_YW)>0)
	{
		vecTextX=-vecSegment;
	}

	vecTextX.normalize();
	vecTextY=_ZW.crossProduct(vecTextX);	
	vecTextY.normalize();

	vNormal.normalize();	
	Point3d ptDispPS=ptEdge+vNormal*dOffsetFromEl;
	ptDispPS.transformBy(ms2ps);

	Vector3d vxDispPS=vecTextX;
	Vector3d vyDispPS=vecTextY;
//	vxDispPS.vis(ptDispPS);
//	vyDispPS.vis(ptDispPS);

	dp.draw(sMessage, ptDispPS, vxDispPS, vyDispPS, 0, 0);
	
}









#End
#BeginThumbnail











#End