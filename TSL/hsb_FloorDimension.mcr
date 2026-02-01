#Version 8
#BeginDescription
Dimension floors in a layout, the floor can have any shape and the TSL will dimension segment by segment.

Last modified by: Support UK
07.12.2020  -  version 1.7
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
* date: 24.06.2011
* version 1.0: Release Version
*
* date: 26.09.2011
* version 1.1: Add option to dimension the studs on both sides
*
* date: 23.05.2012
* version 1.2: Add beams types for joist and floor beam
*
* date: 08.08.2012
* version 1.3: Changed primary code to use plane profile to accomodate for dimensioning trusses
*
* date: 05.04.2013
* version 1.4: Add the option to dimension joist with delta or cummulative options.
*
* date: 07.04.2018
* version 1.5: Improve so the TSL will look only for beams in zone 0.
*
* date: 07.04.2018
* version 1.7: Add tolerance of 2 for ppBeams plane profile.
*/


Unit(1,"mm"); // script uses mm

String sArYesNo[] = {T("No"), T("Yes")};

String sDimensionType[] = {T("Delta"), T("Cumulative")};

//Used to set the dimensioning layout.
PropString sDimStyle(0, _DimStyles, T("Dimension Style"));

PropDouble dOffsetFromEl (0, U(150, 8), T("Offset From Element"));

PropDouble dOffsetBt (1, U(150, 8), T("Offset Between Lines"));

PropString strYNOverAll (1,sArYesNo,T("Show OverAll Dimension"), 0);
int nYesNoOverAll=sArYesNo.find(strYNOverAll);

PropString strYNShape (2,sArYesNo,T("Show OverAll Shape Dimension"), 0);
int nYesNoShape=sArYesNo.find(strYNShape);

PropString strYNBeam (3,sArYesNo,T("Show Beams Dimension"), 0);
int nYesNoBeam=sArYesNo.find(strYNBeam);

PropString strBeamDimType (5, sDimensionType,T("Beams Dimension Type"), 0);
int nDimType=sDimensionType.find(strBeamDimType);

String strSide []={T("Left"),T("Center"), T("Right"), T("Both")};
int nOrientation[]={1, 0, -1, 2};
PropString sSide (4,strSide,T("Joist Dimension Side"));
int nSide=nOrientation[strSide.find(sSide)];

PropInt nColor(0,1,T("Color"));
if (nColor < 0 || nColor > 255) nColor.set(0);


if (_bOnInsert)
{
	showDialogOnce();  
  	Viewport vp = getViewport(T("Select the viewport from which the element is taken")); // select viewport
	_Viewport.append(vp);
	return;
}

// set the diameter of the 3 circles, shown during dragging
setMarbleDiameter(U(2));

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
int nZoneIndex = vp.activeZoneIndex();

//Element el = vp.element();
if( !el.bIsValid() )return;

Display dp(nColor); // use color red
dp.dimStyle(sDimStyle, ps2ms.scale());


//Element vectors
CoordSys csEl=el.coordSys();
Vector3d vx = csEl.vecX();
Vector3d vy = csEl.vecY();
Vector3d vz = csEl.vecZ();

vx.normalize();
vy.normalize();
vz.normalize();

Point3d ptOrgEl=csEl.ptOrg();

Vector3d vxPs = ms2ps.vecX();
Vector3d vyPs = ms2ps.vecY();
Vector3d vzPs = ms2ps.vecZ();

vxPs.normalize();
vyPs.normalize();
vzPs.normalize();

Vector3d vNormal=vz;

Plane plnZ (ptOrgEl, vz);

Plane plnNormal (ptOrgEl, vNormal);

GenBeam bmAll[]=el.genBeam(0);

PlaneProfile ppBeams (plnNormal);
PlaneProfile ppBeamsFallback (plnNormal);
Body bdAllBeam;

Beam bmDimJoist[0];

Point3d ptBmCenter[0];
Vector3d vBmDir[0];
PlaneProfile ppAllBeams[0];
Vector3d vecAllBeamsX[0];
String sAllHandles[0];

for(int n=0; n<bmAll.length(); n++)
{
	Beam bm;
	Beam bmAux=(Beam) bmAll[n];
	if (bmAux.bIsValid())
	bm = bmAux;
	Body bdBeam=bm.realBody();
	//bdBeam.vis();
	int nType=bm.type();
	
	ptBmCenter.append(bm.ptCen());
	vBmDir.append(bm.vecX());
	
	ptBmCenter.append(bm.ptCen());
	vBmDir.append(bm.vecX());
	
	if (nType==_kDakCenterJoist)
	{
		bmDimJoist.append(bm);
		ppAllBeams.append(bm.envelopeBody(true,false).shadowProfile(plnNormal));
		vecAllBeamsX.append(bm.vecX());
		sAllHandles.append(bm.handle());
	}
	
	if (nType==_kBlocking)
	{
		bmDimJoist.append(bm);
		ppAllBeams.append(bm.envelopeBody(true,false).shadowProfile(plnNormal));		
		vecAllBeamsX.append(bm.vecX());		
		sAllHandles.append(bm.handle());
	}		
		
	if (nType== _kJoist)
	{
		bmDimJoist.append(bm);
		ppAllBeams.append(bm.envelopeBody(true,false).shadowProfile(plnNormal));		
		vecAllBeamsX.append(bm.vecX());		
		sAllHandles.append(bm.handle());		
	}
		
	
	if (nType== _kFloorBeam)
	{
		bmDimJoist.append(bm);
		ppAllBeams.append(bm.envelopeBody(true,false).shadowProfile(plnNormal));		
		vecAllBeamsX.append(bm.vecX());
		sAllHandles.append(bm.handle());		
	}
	
	bdAllBeam.combine(bdBeam);
	ppBeamsFallback.unionWith(bdBeam.shadowProfile(plnNormal));
}

//bdAllBeam.vis();

//Check if there are any space joists
Group grpElement=el.elementGroup();
Entity entElement[]=grpElement.collectEntities(false,TrussEntity(),_kModelSpace);
for(int e=0;e<entElement.length();e++)
{
	//Get the truss entity
	TrussEntity truss=(TrussEntity)entElement[e];
	if(!truss.bIsValid()) continue;
	
	CoordSys csTruss=truss.coordSys();
	csTruss.vis();
	//Definition
	String sDefinition=truss.definition();
	TrussDefinition trussDef(sDefinition);
	Beam bmTruss[]=trussDef.beam();
	Body bdTruss;
	for(int b=0;b<bmTruss.length();b++)
	{
		Beam bm=bmTruss[b];
		if(!bm.bIsValid()) continue;
		
		Body bd=bm.realBody();
		CoordSys csTransform;
		Point3d pt(0,0,0);
		csTransform.setToAlignCoordSys(pt,_XW,_YW,_ZW, csTruss.ptOrg(),csTruss.vecX(),csTruss.vecY(),csTruss.vecZ());
		bd.transformBy(csTransform);
		bdTruss.combine(bd);


		//bdTruss.vis();
		ppAllBeams.append(bd.shadowProfile(plnNormal));		
		vecAllBeamsX.append(csTruss.vecX());
		sAllHandles.append(truss.handle());	
	}
	bdTruss.vis(1);


	bdAllBeam.combine(bdTruss);
	ppBeamsFallback.unionWith(bdTruss.shadowProfile(plnNormal));
	
}

ppBeamsFallback.vis(2);


PlaneProfile ppBodyBeams=bdAllBeam.shadowProfile(plnNormal);
ppBeams = ppBodyBeams.area() > ppBeamsFallback.area() ? ppBodyBeams : ppBeamsFallback;
ppBeams.shrink(-U(2));
ppBeams.shrink(U(2));

ppBeams.vis(1);

PLine plAllRingsBm[]=ppBeams.allRings();
PLine plOutline;

for (int i=0; i<plAllRingsBm.length(); i++)
{
	if (plAllRingsBm[i].area()>plOutline.area())
	{
		plOutline=plAllRingsBm[i];
	}
}

plOutline.vis(3);

PLine plNewOutline(vNormal);
Point3d arPtAll[] = plOutline.vertexPoints(false);

Point3d ptArNoClose[0];

if( arPtAll.length() > 2 )
{
	ptArNoClose.append(arPtAll[0]);
	for (int i=1; i<arPtAll.length(); i++)
	{
		//Analyze initial point with last point and next point
		Point3d pt=arPtAll[i];
		Vector3d v1(arPtAll[i-1] - arPtAll[i]);
		if(v1.length() >U(2)) 
		{
			ptArNoClose.append(arPtAll[i]);
		}
	}
	ptArNoClose.append(ptArNoClose[0]);
}


if( ptArNoClose.length() > 2 )
{
	plNewOutline.addVertex(ptArNoClose[0]);
	for (int i=1; i<ptArNoClose.length()-1; i++)
	{
		//Analyze initial point with last point and next point
		Point3d pt=ptArNoClose[i];
		Vector3d v1(ptArNoClose[i-1] - ptArNoClose[i]);
		v1.normalize();
		Vector3d v2(ptArNoClose[i] - ptArNoClose[i+1]);
		v2.normalize();
		if( abs(v1.dotProduct(v2)) <0.99 ) 
		{
			plNewOutline.addVertex(ptArNoClose[i]);
		}
	}
}

plNewOutline.close();
plNewOutline.vis(1);

Point3d ptAllVertex[]=plNewOutline.vertexPoints(false);

PlaneProfile ppElOutline(plnNormal);
ppElOutline.joinRing(plNewOutline, false);

Vector3d vAllNormals[0];
Point3d ptAllToDim[0];

Vector3d vNormalEdges[0];
LineSeg lsAllEdges[0];

Point3d vExtraDimNormal[0];
Point3d ptExtraDimA[0];
Point3d ptExtraDimB[0];


for (int i=0; i<ptAllVertex.length()-1; i++)
{
	Point3d ptA=ptAllVertex[i];
	//ptA.vis(4);
	Point3d ptB=ptAllVertex[i+1];
	//ptB.vis(3);
	LineSeg ls (ptA, ptB);
	
	Vector3d vSegDir=ptA-ptB;
	vSegDir.normalize();
	Vector3d vSegNormal=vNormal.crossProduct(vSegDir);
	vSegNormal.normalize();
	
	//This point are point on the linesegment but a bit to the inside of them
	Point3d ptA1=ptA-vSegDir*U(2);
	Point3d ptB1=ptB+vSegDir*U(2);
	//ptA1.vis();
	//ptB1.vis();
	
	Line lnA1 (ptA1, vSegNormal);
	Line lnB1 (ptB1, vSegNormal);
	
	LineSeg lsAToFront(ptA+vSegNormal*U(4000), ptA1+vSegNormal*U(0.1));
	LineSeg lsAToBack(ptA-vSegNormal*U(4000), ptA1-vSegNormal*U(0.1));

	LineSeg lsBToFront(ptB+vSegNormal*U(4000), ptB1+vSegNormal*U(0.1));
	LineSeg lsBToBack(ptB-vSegNormal*U(4000), ptB1-vSegNormal*U(0.1));
	
	PLine plAToFront(vNormal);
	plAToFront.createRectangle(lsAToFront, vSegNormal, vSegDir);
	
	PLine plAToBack(vNormal);
	plAToBack.createRectangle(lsAToBack, vSegNormal, vSegDir);
	
	PLine plBToFront(vNormal);
	plBToFront.createRectangle(lsBToFront, vSegNormal, vSegDir);
	
	PLine plBToBack(vNormal);
	plBToBack.createRectangle(lsBToBack, vSegNormal, vSegDir);
	
	PlaneProfile ppAToFront(plAToFront);
	PlaneProfile ppAToBack(plAToBack);
	PlaneProfile ppBToFront(plBToFront);
	PlaneProfile ppBToBack(plBToBack);

	ppAToFront.intersectWith(ppElOutline);
	ppAToBack.intersectWith(ppElOutline);
	ppBToFront.intersectWith(ppElOutline);
	ppBToBack.intersectWith(ppElOutline);
	
	int nIntFront=0;
	int nIntBack=0;
	int nA=0;
	int nB=0;
	if (ppAToFront.area()/U(1)*U(1)>U(0.1)*U(0.1))//Intersect
	{
		nIntFront++;
		nA++;
	}
	if (ppAToBack.area()/U(1)*U(1)>U(0.1)*U(0.1))//Intersect
	{
		nIntBack++;
		nA++;
	}
	if (ppBToFront.area()/U(1)*U(1)>U(0.1)*U(0.1))//Intersect
	{
		nIntFront++;
		nB++;
	}
	if (ppBToBack.area()/U(1)*U(1)>U(0.1)*U(0.1))//Intersect
	{
		nIntBack++;
		nB++;
	}
	if (nIntFront>nIntBack)
	{
		vSegNormal=-vSegNormal;
	}
	if (nA<2)
	{
		ptAllToDim.append(ptA);
		vAllNormals.append(vSegNormal);
	}
	if (nB<2)
	{
		ptAllToDim.append(ptB);
		vAllNormals.append(vSegNormal);
	}
	
	if (nIntFront+nIntBack>2)
	{
		vExtraDimNormal.append(vSegNormal);
		ptExtraDimA.append(ptA);
		ptExtraDimB.append(ptB);
	}
	
	if ((ptA-ptB).length()>U(2))
	{
		vNormalEdges.append(vSegNormal);
		lsAllEdges.append(ls);
	}
}

//Collect all the diferent Normals
Vector3d vNormalGroup[0];
for (int i=0; i<vAllNormals.length(); i++)
{
	int nNew=true;
	for (int j=0; j<vNormalGroup.length(); j++)
	{
		if (vAllNormals[i].dotProduct(vNormalGroup[j])>0.99)
		{
			nNew=false;
			break;
		}
	}
	if (nNew)
		vNormalGroup.append(vAllNormals[i]);
}

Vector3d vViewDir=_XW+_YW;
vViewDir.transformBy(ps2ms);
vViewDir.normalize();

Vector3d vReadView=-_XW+_YW;
vReadView.transformBy(ps2ms);
vReadView.normalize();

String sHandleUsed[0];

Dim dmBeams[0];
Vector3d vDimBmNormal[0];
int nCounter[0];

for (int n=0; n<vNormalGroup.length(); n++)
{
	Vector3d vThisDimNormal=vNormalGroup[n];
	Vector3d vDimDirection=vThisDimNormal.crossProduct(vNormal);
	vDimDirection.normalize();
	
	Vector3d vxText=vDimDirection;
	Vector3d vyText=vThisDimNormal;
	
	int nDeltaTop=false;
	
	if (vViewDir.dotProduct(vxText)<0)
		vxText=-vxText;

	if (vReadView.dotProduct(vyText)<0)
	{
		vyText=-vyText;
		nDeltaTop=true;
	}
	
	//Points of the Contour
	Point3d ptToDim[0];
	Point3d ptAllBaseDim[0];
	for (int j=0; j<vAllNormals.length(); j++)
	{
		if (vAllNormals[j].dotProduct(vThisDimNormal)>0.999)
		{
			ptToDim.append(ptAllToDim[j]);
			ptAllBaseDim.append(ptAllToDim[j]);
		}
	}
	
	//Lineseg on this orientation
	LineSeg lsThisDirection[0];
	for (int j=0; j<vNormalEdges.length(); j++)
	{
		if (vNormalEdges[j].dotProduct(vThisDimNormal)>0.999)
		{
			lsThisDirection.append(lsAllEdges[j]);
			ptAllBaseDim.append(lsAllEdges[j].ptStart());
		}
	}
	
	Point3d ptBaseDim;
	ptAllBaseDim=ptToDim;
	ptAllBaseDim[0].vis();
	Line ln (ptAllBaseDim[0], -vThisDimNormal);
	ptAllBaseDim=ln.orderPoints(ptAllBaseDim);
	ptBaseDim=ptAllBaseDim[0];
	ptBaseDim=ptBaseDim+vThisDimNormal*dOffsetFromEl;
	
	vThisDimNormal.vis(_Pt0);
	
	if (lsThisDirection.length()>0)
	{
		Point3d ptDimJoist[0];
		
		if (ptAllBaseDim.length()>1)
		{
			Line lnExt (ptAllBaseDim[0], vDimDirection);
			ptAllBaseDim=lnExt.orderPoints(ptAllBaseDim);
			ptDimJoist.append(ptAllBaseDim[0]);
			ptDimJoist.append(ptAllBaseDim[ptAllBaseDim.length()-1]);
		}
		
		for (int j=0; j<lsThisDirection.length(); j++)
		{
			//Beam bmToDim[0];
			PlaneProfile ppToDim[0];
			Vector3d vecXToDim[0];
			
			LineSeg ls=lsThisDirection[j];
			Line lnSegment (ls.ptMid(), vDimDirection);
			LineSeg lsThisEdge (ls.ptStart(), ls.ptEnd()-vThisDimNormal*U(150));

			PLine plThisEdge(vNormal);
			plThisEdge.createRectangle(lsThisEdge, vDimDirection, vThisDimNormal);
			PlaneProfile ppThisEdge(plThisEdge);
			ppThisEdge.shrink(-U(2));
			//ppThisEdge.joinRing(plThisEdge, false);
			
			ppThisEdge.vis(2);

			for (int j=0; j<ppAllBeams.length(); j++)
			{
				PlaneProfile pp=ppAllBeams[j];
				Vector3d vecPpX=vecAllBeamsX[j];
				if (abs(vecPpX.dotProduct(vDimDirection))>0.99)
					continue;
				pp.intersectWith(ppThisEdge);
				if (pp.area()/U(1)*U(1)>U(2)*U(2))
				{
					ppToDim.append(ppAllBeams[j]);
					vecXToDim.append(vecAllBeamsX[j]);
					sHandleUsed.append(sAllHandles[j]);
				}
			}
			

			for (int j=0; j<ppToDim.length(); j++)
			{
				PlaneProfile pp=ppToDim[j];
				Vector3d vecPpX=vecXToDim[j];
				
				//Get the side vector and check if it is in the opposite direction to the direction of the dim
				Vector3d vSide=vecPpX.crossProduct(vz);
				vSide.normalize();
				if(vSide.dotProduct(vDimDirection)<0) vSide=-vSide;
				vSide.normalize();
				
				LineSeg lsPp=pp.extentInDir(vSide);
				
				
				Point3d ptDimPosition;
				if(nSide==0) ptDimPosition=lsPp.ptMid(); 
				if(nSide==1) ptDimPosition=lsPp.ptEnd();
//				Point3d ptE=lsPp.ptEnd();
//				ptE.vis(j);
				if(nSide==-1) ptDimPosition=lsPp.ptStart();
//				Point3d ptS=lsPp.ptStart();
//				ptS.vis(j);
												
				if (nSide<2)
				{
					Line lnBm (ptDimPosition, vecPpX);
					Point3d pt=lnBm.closestPointTo(lnSegment);
				
					if (ppThisEdge.pointInProfile(pt) == _kPointInProfile)
					{
						ptDimJoist.append(pt);
						//*pt.vis();
					}
				}
				else
				{
					Line lnBm1 (lsPp.ptEnd(), vecPpX);
					Point3d pt1=lnBm1.closestPointTo(lnSegment);
					if (ppThisEdge.pointInProfile(pt1) == _kPointInProfile)
					{
						ptDimJoist.append(pt1);
						//pt1.vis();
					}
					Line lnBm2 (lsPp.ptStart(), vecPpX);
					Point3d pt2=lnBm2.closestPointTo(lnSegment);
					if (ppThisEdge.pointInProfile(pt2) == _kPointInProfile)
					{
						ptDimJoist.append(pt2);
						//pt2.vis();
					}
				}
				//bmToDim[j].realBody().vis();
			}

		}
		
		if (ptDimJoist.length()>1 && nYesNoBeam)
		{
			int nDisplayModusMiddle=_kDimPar;
			int nDisplayModusEnd=_kDimNone;
			
			int nLocalDeltaTop=nDeltaTop;
			
			if (nDimType)
			{
				nDisplayModusMiddle=_kDimNone;
				nDisplayModusEnd=_kDimPar;
				if (nDeltaTop)
					nLocalDeltaTop=false;
				else
					nLocalDeltaTop=true;
			}
			
			DimLine dLine (ptBaseDim, vxText, vyText);
			Dim dim (dLine, ptDimJoist, "<>",  "<>", nDisplayModusMiddle, nDisplayModusEnd);
			if(nLocalDeltaTop)
			{
				dim.setDeltaOnTop(FALSE);
			} 
			dim.transformBy(ms2ps);
			
			dmBeams.append(dim);
			vDimBmNormal.append(vThisDimNormal);
			nCounter.append(ptDimJoist.length());
			
			//dp.draw(dim);
			ptBaseDim=ptBaseDim+vThisDimNormal*dOffsetBt;
		}
	}
	
	
	if (ptToDim.length()>1)
	{
		
		Line lnX (ptBaseDim, vDimDirection);
		ptToDim=lnX.projectPoints(ptToDim);
		ptToDim=lnX.orderPoints(ptToDim);
		
		if (nYesNoShape)
		{
			DimLine dLine(ptBaseDim, vxText, vyText);
			Dim dim (dLine, ptToDim, "<>",  "<>", _kDimPar, _kDimNone);
			if(nDeltaTop)
			{
				dim.setDeltaOnTop(FALSE);
			} 
			dim.transformBy(ms2ps);
			dp.draw(dim);
		
			ptBaseDim=ptBaseDim+vThisDimNormal*dOffsetBt;
		}
		
		if (nYesNoOverAll)
		{
			if (( ptToDim.length()>2 ) || (!nYesNoShape && ptToDim.length()>1))
			{
				Point3d ptOverAll[0];
				ptOverAll.append(ptToDim[0]);
				ptOverAll.append(ptToDim[ptToDim.length()-1]);
				
				Line lnOverAll(ptBaseDim, vxText);
				ptOverAll=lnOverAll.projectPoints(ptOverAll);
				ptOverAll=lnOverAll.orderPoints(ptOverAll);
				
				DimLine dLineOverAll(ptBaseDim, vxText, vyText);
				Dim dimOverAll (dLineOverAll, ptOverAll, "<>", "<>", _kDimPar, _kDimNone);
				if(nDeltaTop)
				{
					dimOverAll.setDeltaOnTop(FALSE);
				}
				dimOverAll.transformBy(ms2ps);
				dp.draw(dimOverAll);
				
				ptBaseDim=ptBaseDim+vThisDimNormal*dOffsetBt;
			}
		}
	}
}

for (int j=0; j<ppAllBeams.length(); j++)
{
	PlaneProfile pp=ppAllBeams[j];
	String sHandle=sAllHandles[j];
	Vector3d vecPpX=vecAllBeamsX[j];
	LineSeg lsPp=pp.extentInDir(vecPpX);
	//Dont take into account any beam with that has been dimension before
	if (sHandleUsed.find(sHandle, -1) != -1)
		continue;

//	Body bd=bm.realBody();
//	bd.transformBy(ms2ps);
//	bd.vis(2);
	
	Point3d ptIntersect[]=plNewOutline.intersectPoints(Line(lsPp.ptMid(), vecPpX));
	Point3d ptTodim[0];
	Vector3d vBmNormal[0];

	if (ptIntersect.length()>1)
	{
		Point3d ptLeft=ptIntersect[0];
		Point3d ptRight=ptIntersect[ptIntersect.length()-1];
		Point3d ptSide;
		if (abs(vecPpX.dotProduct(ptLeft-lsPp.ptMid())) > abs(vecPpX.dotProduct(ptRight-lsPp.ptMid())))
		{
			ptTodim.append(ptRight);
			ptSide=ptRight;
		}
		else
		{
			ptTodim.append(ptLeft);
			ptSide=ptLeft;
		}
		if (Vector3d(ptSide-lsPp.ptMid()).dotProduct(vecPpX)>0 )
		{
			vBmNormal.append(vecPpX);
		}
		else
		{
			vBmNormal.append(-vecPpX);
		}
	} 
	
	//Deal with any beams which have not been dimensioned by finding the edge which is most aligned to the beam's X vector
	for (int i=0; i<ptTodim.length(); i++)
	{
		Point3d pt=ptTodim[i];
		double dMostAlign=-1;
		int nLocation=-1;
		Plane plDim;

		for (int j=0; j<dmBeams.length(); j++)
		{
			if (vBmNormal[i].dotProduct(vDimBmNormal[j])>dMostAlign)
			{
				dMostAlign=vBmNormal[i].dotProduct(vDimBmNormal[j]);
				plDim=Plane(pt,vDimBmNormal[j]);
				nLocation=j;
			}
		}
		if (nLocation != -1)
		{
			LineSeg lsPpDimNormal=pp.extentInDir(plDim.normal());
			Point3d ptDimPosition;
			if(nSide==0) ptDimPosition=lsPpDimNormal.ptMid(); 
			if(nSide==1) ptDimPosition=lsPpDimNormal.ptStart();
			if(nSide==-1) ptDimPosition=lsPpDimNormal.ptEnd();
				
//			Point3d ptAux=ptTodim[i];
			if (nSide<2)
			{
				ptDimPosition=ptDimPosition.projectPoint(plDim,0);
				ptDimPosition.transformBy(ms2ps);
				ptDimPosition.vis(3);
				dmBeams[nLocation].append(ptDimPosition);
				nCounter[nLocation]++;
			}
			else
			{
				//Left
				Point3d ptLeft;
				ptLeft=lsPpDimNormal.ptEnd().projectPoint(plDim,0);
				ptLeft.transformBy(ms2ps);
				
				Point3d ptRight;
				ptRight=lsPpDimNormal.ptStart().projectPoint(plDim,0);
				ptRight.transformBy(ms2ps);


				ptDimPosition.vis(3);
				dmBeams[nLocation].append(ptLeft);
				dmBeams[nLocation].append(ptRight);
				nCounter[nLocation]++;
			}			

		}
	}
}

for (int j=0; j<dmBeams.length(); j++)
{
	Dim dm=dmBeams[j];
	if (nCounter[j]>2)
		dp.draw(dm);
}







#End
#BeginThumbnail










#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End