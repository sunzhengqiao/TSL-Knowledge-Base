#Version 8
#BeginDescription
Create dimension in model of the headbinder.

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 30.07.2010 - version 1.0

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
* date: 29.07.2010
* version 1.0: Add the Gap around the openings when they have.
*
*/


//Units
//U(1,"mm");

String sArYesNo[] = {T("No"), T("Yes")};

PropString sDimLayout(0,_DimStyles,T("Dim Style"));

PropDouble dOffset (0, U(150, 6), T("Offset"));

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

int nBmTypeValidForConvex[0];
nBmTypeValidForConvex.append(_kSFStudRight);
nBmTypeValidForConvex.append(_kSFStudLeft);	
nBmTypeValidForConvex.append(_kSFAngledTPLeft);
nBmTypeValidForConvex.append(_kSFAngledTPRight);	
nBmTypeValidForConvex.append(_kKingStud);
nBmTypeValidForConvex.append(_kSFTopPlate);
nBmTypeValidForConvex.append(_kSFBottomPlate);

Viewport vp = _Viewport[0];

CoordSys ms2ps = vp.coordSys();

CoordSys ps2ms = ms2ps; ps2ms.invert();

Element el = vp.element();
if( !el.bIsValid() )return;

_Pt0=ms2ps.ptOrg();

//Element vectors
CoordSys csEl=el.coordSys();
Vector3d vx = csEl.vecX();
Vector3d vy = csEl.vecY();
Vector3d vz = csEl.vecZ();

vx.normalize();
vy.normalize();
vz.normalize();

Point3d ptOrgEl=csEl.ptOrg();

CoordSys coordvp = vp.coordSys();
Vector3d VecX = coordvp.vecX();
Vector3d VecY = coordvp.vecY();
Vector3d VecZ = coordvp.vecZ();


//Check if the panel haven been reverse on the viewport
int nReverseX=FALSE;
Vector3d vAuxX=vx;
vAuxX.transformBy(ms2ps);
if (vAuxX.dotProduct(_XW)<0)
{
	nReverseX=TRUE;
	vx=-vx;
	//vz=-vz;
}
Vector3d vAuxZ=vz;
vAuxZ.transformBy(ms2ps);
if (vAuxZ.dotProduct(_YW)<0)
{
	//vx=-vx;
	vz=-vz;
}



Beam bmAll [] = el.beam();
if (bmAll.length()<1)
	return;
	
Beam bmTopPlate[0];
Point3d ptBeamVerticesForConvex[0];
Point3d ptBeamVertices[0];

for (int i=0; i<bmAll.length(); i++)
{
	Beam bm=bmAll[i];
	int nBeamType=bm.type();
	if (nBeamType==_kTopPlate)
	{
		bmTopPlate.append(bm);
		Body bd=bm.realBody();
		ptBeamVertices.append(bd.allVertices());
	}
	else if (nBmTypeValidForConvex.find(nBeamType, -1) != -1)
	{
		Body bd=bm.realBody();
		Point3d ptBeamVertices[]=bd.allVertices();
		ptBeamVerticesForConvex.append(ptBeamVertices);
	}
}

//Extract the plane in contact with the face of the element
Plane plnZ(el.ptOrg(), vz);

//Project all vertex points to the plane and create the convex hull encompassing all the vertices
ptBeamVerticesForConvex= plnZ.projectPoints(ptBeamVerticesForConvex);

PLine plConvexHull;
plConvexHull.createConvexHull(plnZ, ptBeamVerticesForConvex);

PLine plOutlineElement(vz);

Point3d arPtAll[] = plConvexHull.vertexPoints(FALSE);

if( arPtAll.length() > 2 )
{
	plOutlineElement.addVertex(arPtAll[0]);
	for (int i=1; i<arPtAll.length()-1; i++)
	{
		//Analyze initial point with last point and next point
		Vector3d v1(arPtAll[i-1] - arPtAll[i]);
		v1.normalize();
		Vector3d v2(arPtAll[i] - arPtAll[i+1]);
		v2.normalize();
	
		if( abs(v1.dotProduct(v2)) <0.99 ) 
		{
			plOutlineElement.addVertex(arPtAll[i]);
		}
	}
}

plOutlineElement.close();
plOutlineElement.vis();
Point3d ptAllVertex[]=plOutlineElement.vertexPoints(TRUE);

Point3d ptCenterPanel;
ptCenterPanel.setToAverage(ptAllVertex);

//Collect the extreme point to dimension top, bottom, left and right
Point3d ptMostLeft=ptCenterPanel;
Point3d ptMostRight=ptCenterPanel;
Point3d ptMostUp=ptCenterPanel;
Point3d ptMostDown=ptCenterPanel;

for (int i=0; i<ptAllVertex.length(); i++)
{
	Point3d pt=ptAllVertex[i];
	if (vx.dotProduct(ptMostLeft-pt)>0)
		ptMostLeft=pt;
	if (vx.dotProduct(ptMostRight-pt)<0)
		ptMostRight=pt;
	if (vy.dotProduct(ptMostUp-pt)<0)
		ptMostUp=pt;
	if (vy.dotProduct(ptMostDown-pt)>0)
		ptMostDown=pt;
}

Line lnBase(ptMostDown, vx);
ptMostLeft=lnBase.closestPointTo(ptMostLeft);
ptMostRight=lnBase.closestPointTo(ptMostRight);

ptMostLeft.vis();
ptMostRight.vis();
ptMostUp.vis();
ptMostDown.vis();

ptOrgEl=ptMostLeft;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Store the viewport scale
Display dp(-1);
dp.dimStyle(sDimLayout, ps2ms.scale());
//dp.dimStyle(sDimLayout);


//Element Height
Line lnElOrg (ptOrgEl, vy);
Line lnX (ptOrgEl, vx);
Point3d ptAllVertices[0];

//Find the Start of the element base on the beams
Point3d ptStartEl=Line(ptMostDown, vx).closestPointTo(ptMostLeft);

//Find the End of the element base on the beams
Point3d ptEndEl=Line(ptMostDown, vx).closestPointTo(ptMostRight);

ptBeamVertices= lnX.projectPoints(ptBeamVertices);
ptBeamVertices= lnX.orderPoints(ptBeamVertices);

for (int i=0; i<ptBeamVertices.length(); i++)
{
	ptBeamVertices[i].vis(1);
}

if (ptBeamVertices.length()>1)
{
	Point3d ptStartBm=ptBeamVertices[0];
	Point3d ptEndBm=ptBeamVertices[ptBeamVertices.length()-1];
	
	DimLine dimLnPlate(ptOrgEl+vz*dOffset, vx, vz);
	
	int nDimType=_kDimDelta;
	//int nDimType=_kDimBoth;
	
	Dim dimPlate(dimLnPlate, ptBeamVertices,"<>","<>", nDimType); // def in MS
	dimPlate.transformBy(ms2ps); // transfrom the dim from MS to PS
	dp.draw(dimPlate);

	//Create dimension on the left
	if (abs(vx.dotProduct(ptStartBm-ptStartEl))>U(5, 0.2))
	{
		//Dimension left overhand
		Point3d ptToDimLeft[0];
		ptToDimLeft.append(ptStartBm);
		ptToDimLeft.append(ptStartEl);
		DimLine dimLnLeft(ptOrgEl-vz*(dOffset+U(150, 6)), vx, vz);
		
		Dim dimLeft(dimLnLeft, ptToDimLeft,"<>","<>", _kDimDelta); // def in MS
		dimLeft.setDeltaOnTop(FALSE);
		dimLeft.transformBy(ms2ps); // transfrom the dim from MS to PS
		dp.draw(dimLeft);
	
	}

	//Create dimension on the right
	if (abs(vx.dotProduct(ptEndBm-ptEndEl))>U(5, 0.2))
	{
		//Dimension right overhand
		Point3d ptToDimRight[0];
		ptToDimRight.append(ptEndBm);
		ptToDimRight.append(ptEndEl);
		DimLine dimLnRight(ptOrgEl-vz*(dOffset+U(150, 6)), vx, vz);
		
		Dim dimRight(dimLnRight, ptToDimRight,"<>","<>", _kDimDelta); // def in MS
		dimRight.setDeltaOnTop(FALSE);
		dimRight.transformBy(ms2ps); // transfrom the dim from MS to PS
		dp.draw(dimRight);
	
	}

}
#End
#BeginThumbnail

#End
