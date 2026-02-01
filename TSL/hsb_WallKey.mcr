#Version 8
#BeginDescription
Displays a Key in layout or shop drawing for the position of an element within a house group

Last modified by: Chirag Sawjani (csawjani@itw-industry.com)
29.03.2017  -  version 1.2









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
* -------------------------
*
* Created by: Chirag Sawjani (csawjani@itw-industry.com)
* date: 07.02.2013
* version 1.0: Release Version
*
* Created by: Chirag Sawjani (csawjani@itw-industry.com)
* date: 27.11.2014
* version 1.1: Change planeprofile to pline as union/joinring failed
*/

String sPaperSpace = T("|paper space|");
String sShopdrawSpace = T("|shopdraw multipage|");
String sArSpace[] = { sPaperSpace , sShopdrawSpace };
PropString sSpace(1, sArSpace, T("|Drawing space|"));

String sArHouseFloor[] = {T("House"), T("Floor")};
PropString sDrawElementInGroup(0, sArHouseFloor, T("|Draw elements in group|"),0);
int nDrawElementInGroup=sArHouseFloor.find(sDrawElementInGroup);


if (_bOnInsert)
{
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	
	showDialog();
	
	if (sSpace == sPaperSpace)
	{	//Paper Space
  		Viewport vp = getViewport(T("Select the viewport from which the element is taken")); // select viewport
		_Viewport.append(vp);
	}
	else if (sSpace == sShopdrawSpace)
	{	//Shopdraw Space
		Entity ent = getShopDrawView(T("|Select the view entity from which the module is taken|")); // select ShopDrawView
		_Entity.append(ent);
	}

	_Pt0=getPoint("Pick Bottom Left Point of Key");
	_PtG.append(getPoint("Pick Top RIght Point of the Key"));
	
	return;
}

//Make the second grip point in line with _Pt0
if(_PtG.length()!=1)
{
	eraseInstance();
	return;

}

_Pt0.vis();
_PtG[0].vis();


Display dp(-1); // use color of entity for frame

// determine the space type depending on the contents of _Entity[0] and _Viewport[0]
if (_Viewport.length()>0)
	sSpace.set(sPaperSpace);
else if (_Entity.length()>0 && _Entity[0].bIsKindOf(ShopDrawView()))
	sSpace.set(sShopdrawSpace);

sSpace.setReadOnly(TRUE);
	
/////////////////////////

Element el;
CoordSys csVp;

//paperspace
if ( sSpace == sPaperSpace ){
	Viewport vp;
	if (_Viewport.length()==0) return; // _Viewport array has some elements
	vp = _Viewport[_Viewport.length()-1]; // take last element of array
	_Viewport[0] = vp; // make sure the connection to the first one is lost
	
	// check if the viewport has hsb data
	if (!vp.element().bIsValid()) return;
	
	csVp = vp.coordSys();
	el = vp.element();
}

//shopdrawspace	
if (sSpace == sShopdrawSpace )
{
	if (_Entity.length()==0) return; // _Entity array has some elements
	ShopDrawView sv = (ShopDrawView)_Entity[0];
	if (!sv.bIsValid()) return;
	
	// interprete the list of ViewData in my _Map
	ViewData arViewData[] = ViewData().convertFromSubMap( _Map, _kOnGenerateShopDrawing + "\\" + _kViewDataSets,0); // 2 means verbose
	int nIndFound = ViewData().findDataForViewport(arViewData, sv);// find the viewData for my view
	if (nIndFound<0) return; // no viewData found
	
	ViewData vwData = arViewData[nIndFound];
	Entity arEnt[] = vwData.showSetEntities();
	
	csVp = vwData.coordSys();
	
	for (int i = 0; i < arEnt.length(); i++)
	{
		Entity ent = arEnt[i];
		if (arEnt[i].bIsKindOf(Element()))
		{
			el=(Element) ent;
		}
	}
}

CoordSys cs = el.coordSys();
Vector3d  vx = cs.vecX();
Vector3d  vy = cs.vecY();
Vector3d  vz = cs.vecZ();
Point3d pX = cs.ptOrg();

//Get the parent folder and find all the elements within
Group grpElementFloor=el.elementGroup();
Group grpHouse;
if(nDrawElementInGroup==0)
{
	grpHouse=Group(grpElementFloor.namePart(0));
}
else
{
	grpHouse=Group(grpElementFloor.namePart(0)+"\\"+grpElementFloor.namePart(1));
}

Entity entWalls[]=grpHouse.collectEntities(true, ElementWall(),_kModelSpace);

Plane pn(_Pt0, _ZU);

//Segregate Walls
ElementWall eWalls[0];
for (int i=0; i<entWalls.length(); i++) {
	ElementWall ewTemp=(ElementWall) entWalls[i];
	if (ewTemp.bIsValid()) {
		eWalls.append(ewTemp);
	} 
}

CoordSys ms2ps;
double dScaleFactor;

if (eWalls.length()>0)
{
	Point3d ptVertices[0];

	Vector3d vecTranslate;
	int nTranslate=false;

	PLine plAllWalls[0];
	Point3d ptAllVertices[0];
	
	for (int i=0; i<eWalls.length(); i++)
	{
		ElementWall el=eWalls[i];
		CoordSys cs=el.coordSys();
		Vector3d vx=cs.vecX();
		Vector3d vy=cs.vecY();
		Vector3d vz=cs.vecZ();

		Plane plnY(cs.ptOrg(), vy);
		PLine plOutWall=eWalls[i].plOutlineWall();
		ptVertices.append(plOutWall.vertexPoints(1));
		ptAllVertices.append(plOutWall.vertexPoints(1));

		plAllWalls.append(plOutWall);
	}
	
	
	Line lnXW(_PtW,_XW);
	Line lnYW(_PtW,_YW);
	Point3d ptVertexYOrd[]=lnYW.orderPoints(ptAllVertices);
	Point3d ptVertexXOrd[]=lnXW.orderPoints(ptVertexYOrd);
	if(ptAllVertices.length()>0)
	{
		Point3d ptBL(ptVertexXOrd[0].X(),ptVertexYOrd[0].Y(),ptVertexYOrd[0].Z());
		Point3d ptBR(ptVertexXOrd[ptVertexXOrd.length()-1].X(),ptVertexYOrd[0].Y(),ptVertexYOrd[0].Z());
		Point3d ptTR(ptVertexXOrd[ptVertexXOrd.length()-1].X(),ptVertexYOrd[ptVertexYOrd.length()-1].Y(),ptVertexYOrd[0].Z());
		double dHorizontal=(ptBR-ptBL).length();
		double dVertical=(ptTR-ptBR).length();
		double dHorizontalGrip=_XW.dotProduct(_PtG[0]-_Pt0);
		double dVerticalGrip=_YW.dotProduct(_PtG[0]-_Pt0);
		
		//Check what the horizontal scale factor is
		double dHorizontalScaled=dHorizontal/dHorizontalGrip;
		
		//Check if the vertically scaled dimension fits within the vertical grip point or not, if not then scale it horizontally
		if((dVertical/dHorizontalScaled)>dVerticalGrip)
		{
			dScaleFactor=	dVertical/dVerticalGrip;
		}
		else 
		{
			dScaleFactor=dHorizontal/dHorizontalGrip;
		}
		
		ms2ps.setToAlignCoordSys(ptBL,_XW,_YW,_ZW,_Pt0,_XW/dScaleFactor,_YW/dScaleFactor,_ZW);
	
		for(int p=0;p<plAllWalls.length();p++)
		{
			PLine wall=plAllWalls[p];
			wall.transformBy(ms2ps);
			dp.draw(wall);
		}
	}
}

//Draw arrow for the position of an element
Point3d pOl[] = el.plOutlineWall().vertexPoints(TRUE);
if (pOl.length() <= 0) return;
double  dElLength = (pOl[0] - pOl[1]).length();
	PLine plA(_ZW);
	
pX = pX + vx * 0.5 * dElLength;
plA.addVertex(pX + vx * U(400) + vz  *U(600));
plA.addVertex(pX);
plA.addVertex(pX - vx * U(400) + vz * U(600));
plA.addVertex(pX - vx * U(60) + vz * U(600));
plA.addVertex(pX - vx * U(60)+ vz * U(1400));
plA.addVertex(pX + vx * U(60)+ vz * U(1400));
plA.addVertex(pX + vx * U(60)+ vz * U(600));
plA.addVertex(pX + vx * U(400)+ vz* U(600) );
Hatch hatch("Solid", 1);
plA.transformBy(ms2ps);
PlaneProfile ppArrow(plA);
dp.draw(ppArrow,hatch);

#End
#BeginThumbnail



#End