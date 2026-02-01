#Version 8
#BeginDescription
Dimension the studs that intersect the bottom plate.

Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 06.04.2010 - version 1.2

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
* date: 19.01.2010
* version 1.0: 	Release Version
*
* date: 06.04.2010
* version 1.1: 	Add Offset for the dimension
*
* date: 06.04.2010
* version 1.2: 	Add Property to have the dimensions as a running dimension.
*/


//Units
U(1,"mm");

String sArMode[] = {T("Line and Text"), T("Dimension Line")};
PropString sMode(3, sArMode, T("Show as"),0);
int nMode= sArMode.find(sMode, 0);

PropString sDimLayout(0,_DimStyles,T("Dim Style"));

String strStartEndBot []={T("Start"),T("End"), T("Center"), T("None")};
PropString strShowDimBot (1,strStartEndBot,T("Show Bottom Dimension"));
int nStartEndBot=strStartEndBot.find(strShowDimBot);

PropDouble dOffset (0, U(100), T("Offset from element"));
dOffset.setDescription(T("Offset between the element and the dimension line"));

PropString sFilterBMC(2,"",T("Include Beam With BeamCode"));
sFilterBMC.setDescription(T("Set the code of the extra beams that you want to show int the beam dimension at the bottom of the panel. To add more than 1 use ';' after each code"));

String arType[]={"Parallel","Perpendicular"};
int arIType[]={_kDimPar,_kDimPerp};
PropString strType(4,arType,"Dimension Orientation",0);
int nType = arIType[arType.find(strType,0)];


if(_bOnInsert)
{
	//_Pt0=getPoint(T("Pick a point where the the information is going to be shown"));
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

int nBmTypeToAvoid[0];
//nBmTypeToAvoid.append(_kLocatingPlate);
nBmTypeToAvoid.append(_kTypeNotSet);

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


//Check if the panel haven been reverse on the viewport
int nReverseX=FALSE;
Vector3d vAuxX=vx;
vAuxX.transformBy(ms2ps);
if (vAuxX.dotProduct(_XW)<0)
{
	nReverseX=TRUE;
	vx=-vx;
	vz=-vz;
}

Beam bmAll [] = el.beam();
if (bmAll.length()<1)
	return;

Beam bmHor[] = vy.filterBeamsPerpendicularSort(bmAll);
Beam bmAux[] = vy.filterBeamsParallel(bmAll);
Beam bmVer[] = vx.filterBeamsPerpendicularSort(bmAux);


// filter sheet with material//////////////////////
String sFBMC = sFilterBMC + ";";
String arBMCode[0];
int nIndexBMC = 0; 
int sIndexBMC = 0;

while(sIndexBMC < sFBMC.length()-1)
{
	String sTokenBMC = sFBMC.token(nIndexBMC);
	nIndexBMC++;
	if(sTokenBMC.length()==0)
	{
		sIndexBMC++;
		continue;
	}
	sIndexBMC = sFBMC.find(sTokenBMC,0);
	sTokenBMC.trimLeft();
	sTokenBMC.trimRight();
	sTokenBMC.makeUpper();
	arBMCode.append(sTokenBMC);
}
////////////////////////////////////////////////////////////


//Removing the turned beams
for(int i = 0; i<bmVer.length(); i++)
{
	if(bmVer[i].dD(vz) < bmVer[i].dD(vx))
	{
		String sBMCode=bmVer[i].beamCode().token(0);
		sBMCode.makeUpper();
		if (arBMCode.find(sBMCode,-1)==-1)
		{
			bmVer.removeAt(i);
			i--;
		}
	}
}


Beam bmBottomPlate[0];
Point3d ptBeamVerticesForConvex[0];
	
Beam bmFemale[0];
int nLeft=FALSE;
int nRight=FALSE;

for (int i=0; i<bmAll.length(); i++)
{
	Beam bm=bmAll[i];
	int nBeamType=bm.type();
	if (nBeamType==_kSFBottomPlate)
	{
		bmBottomPlate.append(bm);
		Body bd=bm.realBody();
		Point3d ptBeamVertices[]=bd.allVertices();
		ptBeamVerticesForConvex.append(ptBeamVertices);
	}else if (nBmTypeValidForConvex.find(nBeamType, -1) != -1)
	{
		Body bd=bm.realBody();
		Point3d ptBeamVertices[]=bd.allVertices();
		ptBeamVerticesForConvex.append(ptBeamVertices);
	}
	
	if (nBeamType==_kSFAngledTPLeft)
	{
		nLeft=TRUE;
		bmFemale.append(bm);
	}
	else if (nBeamType==_kSFAngledTPRight)
	{
		nRight=TRUE;
		bmFemale.append(bm);
	}
}


Beam bmToDimBottom[0];
for (int i=0; i<bmBottomPlate.length(); i++)
{
	Beam bmTemp[]=bmBottomPlate[i].filterBeamsCapsuleIntersect(bmVer);
	bmToDimBottom.append(bmTemp);
}

for (int i=0; i<bmToDimBottom.length()-1; i++)
	for (int j=i+1; j<bmToDimBottom.length(); j++)
		if (bmToDimBottom[i]==bmToDimBottom[j])
		{
			bmToDimBottom.removeAt(j);
			j--;
		}
		
Point3d ptCenOFStuds[0];

//The point that is going to be dimension of all the studs that intersect with the bottom plates
for (int i=0; i<bmToDimBottom.length(); i++)
{
	ptCenOFStuds.append(bmToDimBottom[i].ptCen());
}

//Extract the plane in contact with the face of the element
Plane plnZ(el.ptOrg(), vz);
//Project all vertex points to the plane and create the convex hull encompassing all the vertices
ptBeamVerticesForConvex= plnZ.projectPoints(ptBeamVerticesForConvex);

PLine plConvexHull;
plConvexHull.createConvexHull(plnZ, ptBeamVerticesForConvex);
//plConvexHull.vis();

PLine plOutlineElement(vz);
//plOutlineElement=plConvexHull;

//Point3d ptAllVertex[]=plConvexHull.vertexPoints(FALSE);

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
	
ptOrgEl=ptMostLeft;

//Store the viewport scale
Display dp(-1);
dp.dimStyle(sDimLayout, ps2ms.scale());
//dp.dimStyle(sDimLayout);

//DimLine
DimLine dml (ptOrgEl, vx, vy);

//Element Height
Line lnElOrg (ptOrgEl, vy);
Line lnX (ptOrgEl, vx);
Point3d ptAllVertices [0];

//Wall Volume
double dElVol;
for(int i = 0; i<bmAll.length(); i++)
{
	dElVol += bmAll[i].volume();
}

//Find the Start of the element base on the beams
Point3d ptStartEl=Line(ptMostDown, vx).closestPointTo(ptMostLeft);

Point3d ptToHeight = Line(ptMostUp, vx).closestPointTo(ptMostLeft);

double dElHeigth = abs(vy.dotProduct(ptMostUp - ptMostDown));//Element Height



//Beams location of last point-------------------------------------

Beam arBmaux[0];
//Point3d ptVerBot [0];
Beam bmToDim[0];
for(int i =0; i<bmToDimBottom.length()-1; i++)
{
	if(arBmaux.length()==0)
	{
	arBmaux.append(bmToDimBottom[i]);
	}
      	
	if(abs(vx.dotProduct(bmToDimBottom[i].ptCen() - bmToDimBottom[i+1].ptCen())) <= bmToDimBottom[i].dD(vx)*.5 +  bmToDimBottom[i+1].dD(vx)*.5 +U(1) && i < bmToDimBottom.length()-2)
	{
		arBmaux.append(bmToDimBottom[i+1]);
	
		if( abs(vx.dotProduct(bmToDimBottom[i+1].ptCen() - bmToDimBottom[i+2].ptCen())) <= bmToDimBottom[i+1].dD(vx) + U(1,"mm") && i == bmToDimBottom.length()-3)
		arBmaux.append(bmToDimBottom[i+2]);
	
		continue;
	}
	else 
	{
		if(arBmaux.length() >=2)
			bmToDim.append(arBmaux[0]);
				
		else
			bmToDim.append(bmToDimBottom[i]);
		
		
		if(i == bmToDimBottom.length()-2)
			bmToDim.append(bmToDimBottom[bmToDimBottom.length()-1]);

		arBmaux.setLength(0);
		continue;
	
	}
}

//Type of dim 
int nTypeBot = _kLeft;

if(nStartEndBot == 1)
	nTypeBot = _kRight;
if(nStartEndBot == 2)
	nTypeBot = _kCenter;

if(nStartEndBot != 3)
{	
	DimLine dlBot (ptOrgEl, vx, vy);
	Point3d ptVerBot[] = dlBot.collectDimPoints(bmToDim, nTypeBot);

	int nLast=0;
	if (nMode==0) //Line and Text
	{
		for(int i = 0; i<ptVerBot.length(); i ++)
		{
			PLine plDimBmLast;//line of dimension
			Point3d ptPs = ptVerBot[i];//point to display the dimension
			ptPs.transformBy(ms2ps);
			
			//Displaying the value
			nLast = abs(vx.dotProduct(ptStartEl - ptVerBot[i]));
			dp.draw(nLast, ptPs- _YW*(U(15)+dOffset),  _YW, -_XW, 1,1.4 );
				
			//Displaying the polyline
			plDimBmLast.addVertex(ptPs- _YW*(U(15)+dOffset));
			plDimBmLast.addVertex(ptPs- _YW*(U(5)+dOffset));//-_YW*dOffset
			dp.draw(plDimBmLast);
	
		}//next i
	}
	else if 	(nMode==1) //Line and Text
	{
		if (ptVerBot.length()>1)
		{
			ptVerBot.append(ptStartEl);
			
			
			Point3d ptPs = ptVerBot[0];//point to display the dimension
			ptPs.transformBy(ms2ps);
			ptPs=ptPs- _YW*(dOffset);
			ptPs.transformBy(ps2ms);
			
			DimLine dl (ptPs, vx, vy);
			
			Line ln (ptPs, vx);
			ptVerBot=ln.projectPoints(ptVerBot);
			ptVerBot=ln.orderPoints(ptVerBot);
			
			Dim dim(dl, ptVerBot,"<>","<>", _kDimNone, nType);
			dim.transformBy(ms2ps);
			dp.draw(dim); 
		}
	}
}





#End
#BeginThumbnail



#End
