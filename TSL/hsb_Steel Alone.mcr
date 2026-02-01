#Version 8
#BeginDescription
Last modified by: Alberto Jena (aj@hsb-cad.com)
29.10.2010  -  version 1.3




#End
#Type E
#NumBeamsReq 1
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
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
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 03.07.2008
* version 1.0: Release Version
*
* date: 09.03.2009
* version 1.2: Remove the display of the body.
*
* date: 29.10.2010
* version 1.3: Add the plate and the TSL to the group of the Beam
*/

Unit (1, "mm");

PropDouble dPlateWidth (0, U(80), T("Plate Width"));
PropDouble dPlateHeight (1, U(150), T("Plate Height"));
PropDouble dPlateThickness (2, U(15), T("Plate Thickness"));

//String sArNY[] = {T("No"), T("Yes")};
//PropString sFlipSide(1, sArNY, T("Flip Side"), 1);
//int bFlipSide= sArNY.find(sFlipSide,0);

String sAllShape[] = {T("Straight"), T("L Shape")};
PropString sShape(0, sAllShape, T("Location Top"), 1);
int bShape= sAllShape.find(sShape,0);

int nHolesNumber[]={0, 1, 2};
PropInt nQty(0, nHolesNumber, T("Holes per Side"), 1);

PropDouble dDrillTopOffset (3, U(32), T("Drill Top Offset"));
PropDouble dDrillSideOffset  (4, U(32), T("Drill Side Offset"));

PropDouble dDrillDiam (5, U(16), T("Drill Diameter"));

PropString sName (1, "Plate", T("Plate Model"));
PropInt nColor (1, -1, T("Color"));

/*
String arYesNo[] = { T("Yes"), T("No") };

PropString pTop(2,arYesNo,T("Show in Top"));
PropString pBottom(3,arYesNo,T("Show in Bottom"));
PropString pFront(4,arYesNo,T("Show in Front"));
PropString pBack(5,arYesNo,T("Show in Back"));
PropString pLeft(6,arYesNo,T("Show in Left"));
PropString pRight(7,arYesNo,T("Show in Right"));
PropString pIso(8,arYesNo,T("Show in Isometric"));

PropString pDim(9,arYesNo,T("Turn on dimensioning"),1);
int nDim = FALSE;
if (pDim==T("Yes")) nDim = TRUE;

PropString pTurnOff(10,arYesNo,T("Turn off Export"),1);
*/


if (_bOnInsert)
{
	if (_kExecuteKey=="")
		showDialogOnce();

	_Beam.append(getBeam(T("Select Male Beam")));

	_Pt0=getPoint(T("Please select a point on the side of the beam where you need the Plate"));
	
	return;
}

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

if (_Map.hasEntity("bm"))
{
	Entity ent=_Map.getEntity("bm");
	ent.dbErase();
}

Display dp(nColor);

_Z1.vis(_Pt0, 1);

int bCut=TRUE;


//_Beam0.vecX();

Line lnBm0 (_Beam0.ptCen(), _X0);
_Pt0=lnBm0.closestPointTo(_Pt0);


//Body bdBmFem=_Beam1.realBody();
//bdBmFem.vis(2);

Point3d ptIntersect=_Pt0;

//ptInteriorProfile.vis(2);
Vector3d vx=_Beam0.vecX();
Vector3d vy=_Y0;
Vector3d vz=_Z0;
if (vx.dotProduct(_X0)<1)
	vx=-vx;
	
//if (bCut || _kNameLastChangedProp=="Plate Thickness")
//{
	Cut ct(_Pt0-_X0*U(dPlateThickness), vx);
	_Beam0.addTool(ct, 1);
//}

double dWidth=_Beam0.dW();
double dHeight=_Beam0.dH();

/*
Point3d ptUp=_Pt0+vz*(dHeight*0.5);
Point3d ptDown=_Pt0-vz*(dHeight*0.5);

Point3d ptUpFemale=_Pt0+vz*(dHeight*0.5);
Point3d ptDownFemale=_Pt0-vz*(dHeight*0.5);
*/

Body bd;

Vector3d vecXBd;
Vector3d vecYBd;
Vector3d vecZBd;
Point3d ptPlate;

double dWBm=_Beam0.dD(vy);
double dHBm=_Beam0.dD(vz);

ptPlate=_Pt0;
//ptPlate.vis();

if (bShape==0) // Straight
{
	bd=Body (ptPlate, vy, vz, _X0, dPlateWidth, dPlateHeight, dPlateThickness, 0, 0, -1);
	//bd.vis();
}
else
{
	ptPlate=ptPlate-vy*(dWBm*0.5);
	ptPlate=ptPlate-vz*(dHBm*0.5);
	ptPlate.vis();
	bd=Body (ptPlate, vy, vz, _X0, dPlateWidth, dPlateHeight, dPlateThickness, 1, 1, -1);
	Body bd2 (ptPlate, vy, vz, _X0, dPlateHeight, dPlateWidth, dPlateThickness, 1, 1, -1);
	bd.addPart(bd2);
}	
		
vecXBd=vy;
vecYBd=vz;
vecZBd=_X0;

vecXBd.vis(_Pt0);
vecYBd.vis(_Pt0);
vecZBd.vis(_Pt0);

Beam bmPlate;
bmPlate.dbCreate(bd);
bmPlate.setColor(nColor);
bmPlate.setName(sName);
bmPlate.setSubLabel2(_Beam0.subLabel2());
_Map.setEntity("bm", bmPlate);


Group gpAll[]=_Beam0.groups();
if (gpAll.length()>0)
{
	Group gp=gpAll[0];
	gp.addEntity(bmPlate, TRUE);
	gp.addEntity(_ThisInst, TRUE);
}


if (nQty>0)
{
	if (bShape!=1)
		ptPlate=bd.ptCen();

//////////////////////////////////////////////////////////////////////////////
// drills
//////////////////////////////////////////////////////////////////////////////
	Point3d ptDrillAr[0];
	ptPlate.vis();
	if (bShape==1)
	{
		//Point3d ptDrill1=ptPlate+vecXBd*(dPlateWidth)-vecXBd*(dDrillTopOffset)+vecYBd*(dPlateHeight)-vecYBd*(dDrillTopOffset);
		Point3d ptDrill1=ptPlate+vecXBd*(dPlateHeight)-vecXBd*(dDrillTopOffset)+vecYBd*(dDrillSideOffset);
		Point3d ptDrill2=ptPlate+vecYBd*(dPlateHeight)-vecYBd*(dDrillTopOffset)+vecXBd*(dDrillSideOffset);
		ptDrillAr.append(ptDrill1);
		ptDrillAr.append(ptDrill2);
	}
	else
	{
		Point3d ptDrill1=ptPlate+vecXBd*(dPlateWidth*0.5)-vecXBd*(dDrillSideOffset)+vecYBd*(dPlateHeight*0.5)-vecYBd*(dDrillTopOffset);//Width 250 //Height 150
		Point3d ptDrill2=ptPlate+vecXBd*(dPlateWidth*0.5)-vecXBd*(dDrillSideOffset)-vecYBd*(dPlateHeight*0.5)+vecYBd*(dDrillTopOffset);
		ptDrillAr.append(ptDrill1);
		ptDrillAr.append(ptDrill2);
	}
	
	if (nQty==2)
	{
		if (bShape==1)
		{
			Point3d ptDrill1=ptPlate+vecXBd*(dPlateHeight)-vecXBd*(dDrillTopOffset)+vecYBd*(dPlateWidth)-vecYBd*(dDrillSideOffset);
			Point3d ptDrill2=ptPlate+vecYBd*(dPlateHeight)-vecYBd*(dDrillTopOffset)+vecXBd*(dPlateWidth)-vecXBd*(dDrillSideOffset);
			ptDrillAr.append(ptDrill1);
			ptDrillAr.append(ptDrill2);
		}
		else
		{
			Point3d ptDrill1=ptPlate-vecXBd*(dPlateWidth*0.5)+vecXBd*(dDrillSideOffset)+vecYBd*(dPlateHeight*0.5)-vecYBd*(dDrillTopOffset);
			Point3d ptDrill2=ptPlate-vecXBd*(dPlateWidth*0.5)+vecXBd*(dDrillSideOffset)-vecYBd*(dPlateHeight*0.5)+vecYBd*(dDrillTopOffset);
			ptDrillAr.append(ptDrill1);
			ptDrillAr.append(ptDrill2);
		}
	}
	//ptDrill1.vis();
	//ptDrill2.vis();
	
	for (int i=0; i<ptDrillAr.length(); i++)
	{
		Drill drl1(ptDrillAr[i]+vecZBd*U(60), -vecZBd, U(120), dDrillDiam*0.5);
		drl1.cuttingBody().vis();
		bmPlate.addTool(drl1);
		bd.addTool(drl1);
	}
}

//Display the Body
//dp.draw(bd);


//Display dp(-1);
//Display something
double dSize = Unit(12, "mm");
//Display dspl (-1);
PLine pl1(_ZW);
PLine pl2(_ZW);
PLine pl3(_ZW);
Point3d ptDraw=bd.ptCen();;
pl1.addVertex(ptDraw+vx*dSize);
pl1.addVertex(ptDraw-vx*dSize);
pl2.addVertex(ptDraw-vy*dSize);
pl2.addVertex(ptDraw+vy*dSize);
pl3.addVertex(ptDraw-vz*dSize);
pl3.addVertex(ptDraw+vz*dSize);
	
dp.draw(pl1);
dp.draw(pl2);
dp.draw(pl3);


////////////////////////////////////////////////////
//Link the new beam to the female for the shopdraw

Beam bm0 = _Beam0;
Vector3d X0 = bm0.vecX();

/*
// collecting the view directions from the properties
Vector3d arVecView[0]; // used view directions
int arShowDim[0]; // allowdimensioning in this view
if (pTop==T("Yes")) { arVecView.append(bm0.vecZ()); arShowDim.append(TRUE); }
if (pBottom==T("Yes")) { arVecView.append(-bm0.vecZ()); arShowDim.append(TRUE); }
if (pFront==T("Yes")) { arVecView.append(-bm0.vecY()); arShowDim.append(TRUE); }
if (pBack==T("Yes")) { arVecView.append(bm0.vecY()); arShowDim.append(TRUE); }
if (pLeft==T("Yes")) { arVecView.append(-bm0.vecX()); arShowDim.append(FALSE); }
if (pRight==T("Yes")) { arVecView.append(bm0.vecX()); arShowDim.append(FALSE); }
if (pIso==T("Yes")) {
  arVecView.append(bm0.vecZ()-bm0.vecX()-bm0.vecY());
  arShowDim.append(FALSE);
}


// define some special dimensioning points and information to be shown in the dimensioning
//DimTool dt(_Pt0,bm0.vecY()); // construct the tool with at least one point and one view direction
//bm0.addTool(dt); // add the tool as a normal tool to the beam


// define my representation in model space

// if TSL is turned off, do nothing further
if (pTurnOff==T("Yes")) {
  return; // end execution here
}

// loop over all viewdirections, and display for shopdrawing
for (int v=0; v<arVecView.length(); v++) {

  Vector3d vecView = arVecView[v];
  int nShowDim = arShowDim[v];

  vecView.vis(_Pt0);

  Display dp1(nColor);
  dp1.showInTslInst(FALSE); // do not show in normal model
  dp1.showInShopDraw(bm0); // do show in shopdraw of beam bm0
  dp1.addViewDirection(vecView); // appear for a particular view
  dp1.draw(bd);
  // loop over additional beams
   
    if (nDim && nShowDim) {
      Point3d pnts[] = bd.extremeVertices(X0);
      for (int p=0; p<pnts.length(); p++) {
        DimTool dt(pnts[p],vecView);
        bm0.addTool(dt);
      }
    }
}

*/

//Subassembly
TslInst tslSubAssembly = bm0.subAssembly();
if( !tslSubAssembly.bIsValid() ){
	String strScriptName = "hsb-SubAssembly"; // name of the script
	Vector3d vecUcsX=bm0.vecX();
	Vector3d vecUcsY=bm0.vecZ();
	Beam lstBeams[1];
	lstBeams[0] = bm0;
	Element lstElements[0];
	
	Point3d lstPoints[1];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
	
	tslSubAssembly.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstElements, lstPoints, lstPropInt, lstPropDouble, lstPropString);
}

//Add those plates to the sub assembly tsl
Map mapSubAssembly = tslSubAssembly.map();
mapSubAssembly.appendEntity("Plate", bmPlate);
//for( int i=0;i<arShPlate.length();i++ ){
	//mapSubAssembly.appendEntity("Plate", arShPlate[i]);
//}
tslSubAssembly.setMap(mapSubAssembly);
tslSubAssembly.transformBy(_XW*0);




/*
String sCompareKey = (String) sName;
setCompareKey(sCompareKey);
	
exportToDxi(TRUE);
dxaout("U_MODEL", sName);
dxaout("U_QUANTITY", 1);
		
		
	

Map mp;
mp.setString("Name", sName);
mp.setInt("Qty", 1);

_Map.setMap("TSLBOM", mp);
*/




#End
#BeginThumbnail





#End
