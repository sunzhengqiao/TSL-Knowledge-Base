#Version 8
#BeginDescription
Last modified by: Alberto Jena (aj@hsb-cad.com)
05.04.2011  -  version 1.6





#End
#Type T
#NumBeamsReq 2
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 6
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

* date: 16.03.2009
* version 1.3: Add support for more connections
*
* date: 29.10.2010
* version 1.5: Add the plate and the TSL to the group of the Beam
*
* date: 05.04.2011
* version 1.6: Bugfix with vectors in the front connection
*/

Unit (1, "mm");
//_Pt0.vis();

String sArNY[] = {T("No"), T("Yes")};

PropDouble dDepthTopCut (0, U(20), T("Top Cut Depth"));
PropDouble dBackTopCut (1, U(20), T("Top Back Cut"));

PropDouble dDepthBottomCut (2, U(20), T("Bottom Cut Depth"));
PropDouble dBackBottomCut (3, U(20), T("Bottom Back Cut"));

PropDouble dDepthLeftCut (4, U(20), T("Left Cut Depth"));
PropDouble dBackLeftCut (5, U(20), T("Left Back Cut"));

PropDouble dDepthRightCut (6, U(20), T("Right Cut Depth"));
PropDouble dBackRightCut (7, U(20), T("Right Back Cut"));

//PropDouble dGapWithFemale (8, U(20), T("Gap With Female"));

PropString ps1(0, "--------------", "Plate Details");
ps1.setReadOnly(TRUE);

PropDouble dPlateWidthM (8, U(80), T("Plate Width Male"));
PropDouble dPlateHeightM (9, U(150), T("Plate Height Male"));
PropDouble dPlateThicknessM (10, U(15), T("Plate Thickness Male"));
PropString sSizeM(1, sArNY, T("Automatic Size Male Plate"));

PropDouble dPlateWidthF (11, U(80), T("Plate Width Female"));
PropDouble dPlateHeightF (12, U(150), T("Plate Height Female"));
PropDouble dPlateThicknessF (13, U(15), T("Plate Thickness Female"));
PropString sSizeF(2, sArNY, T("Automatic Size Female Plate"));

PropString sCutPlate(3, sArNY, T("Cut Plate To Follow Male Beam Orientation"));

String sLocation[] = {T("Front"), T("Side")};
PropString sPlateLocation(4, sLocation, T("Location"), 1);

PropString sFlipSide(5, sArNY, T("Flip Side"));


int nHolesNumber[]={0, 1, 2};
PropInt nQty(0, nHolesNumber, T("Holes per Side"), 0);

PropDouble dDrillTopOffset (14, U(32), T("Drill Top Offset"));
PropDouble dDrillSideOffset  (15, U(32), T("Drill Side Offset"));

PropDouble dDrillDiam (16, U(16), T("Drill Diameter"));

PropString sName (6, "Plate", T("Plate Model"));
PropInt nColor (1, -1, T("Color"));


if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

//int bLocation= sLocation.find(sPlateLocation,0);
int bFlipSide= sArNY.find(sFlipSide,0);
int bSizeM= sArNY.find(sSizeM,0);
int bSizeF= sArNY.find(sSizeF,0);
int bCutPlate= sArNY.find(sCutPlate,0);

if (_bOnInsert)
{
	if (_kExecuteKey=="")
		showDialogOnce();
	_Beam.append(getBeam(T("Select Male Beam")));

	if (_Beam.length()>0)
	{
		
		if (_Beam[0].bIsValid())
		{
			if (_Beam[0].type()==_kPost)
			{
				PrEntity ssE(TN("Select Female Beam"),Beam());
				while (ssE.go() && (ssE.set().length()>0) ) { // let the prompt class do its job, only one run
					Beam ents[0]; // the PrEntity will return a list of entities, and not elements
					ents = ssE.beamSet();
					for (int i=0; i<ents.length(); i++) {
						Beam bm = (Beam) ents[i]; // cast the entity to a element 
						_Beam.append(bm);
					}
					break;
				}
				if (_Beam.length()==1)
				{
					_Pt0=getPoint(T("Please select a point on the side of the beam where you need the Plate"));
				}
				_Map.setInt("sTypePost", TRUE);
			}
			else
			{
				_Beam.append(getBeam(T("Select Female Beam")));
			}
		}
	}
	return;
}


Display dp(nColor);

_Z1.vis(_Pt0, 1);

int bPost=FALSE;

for (int i=0; i<_Map.length(); i++)
{
	if (_Map.keyAt(i)=="bm")
	{
		Entity ent=_Map.getEntity(i);
		ent.dbErase();
	}
}



double dWidth=_Beam0.dW();
double dHeight=_Beam0.dH();

Vector3d vx=_Beam0.vecX();

if (_X0.dotProduct(vx)<0)
{
	vx=-vx;
}

Vector3d vy=_Beam0.vecY();
Vector3d vz=_Beam0.vecZ();

Vector3d vNormal;
Vector3d vXBody;
Vector3d vYBody;

Plane plnFace (_Pt0, _Z1);

Line lnBm0 (_Pt0, vx);

Point3d ptInteriorProfile;
double dIntThick;

int bFrontAngle=FALSE;

Vector3d vA=_ZW.crossProduct(_Beam0.vecX());vA.normalize();vA.vis(_Beam0.ptCen());
Vector3d vB=_ZW.crossProduct(_Beam1.vecX());vB.normalize();vB.vis(_Beam1.ptCen());

double a=vA.dotProduct(vB);
if (abs(vA.dotProduct(vB))>0.98)
{
	if(_Beam1.type()!=_kPost && _Beam0.type()!=_kPost)
		bFrontAngle=TRUE;
}

if (_Map.hasInt("sTypePost") || bFrontAngle)
{
	bPost=TRUE;
	sPlateLocation.set("Front");
	sPlateLocation.setReadOnly(TRUE);
}

int bLocation= sLocation.find(sPlateLocation, 0);

Point3d ptUp;
Point3d ptDown;
Point3d ptLeft;
Point3d ptRight;

if (bFrontAngle)
{	
	_Pt0=_L0.closestPointTo(_L1);
	vz=_ZW;
	Vector3d vxAux=vz.crossProduct(vA);
	
	
	
	//Vector3d vxAux=_Beam0.vecX()+_Beam1.vecX();
	vxAux.normalize();
	
	
	if (vxAux.dotProduct(vx)<0)
		vxAux=-vxAux;
	vxAux.vis(_Pt0);
	vx=vxAux;
	vy=vz.crossProduct(vx);
	vy.normalize();
	ptInteriorProfile=_Pt0;
	vNormal=vxAux;
	
	Cut ct1(ptInteriorProfile-vxAux*U(dPlateThicknessM), vxAux);
	_Beam0.addTool(ct1, _kStretchOnToolChange);
	
	Cut ct2(ptInteriorProfile+vxAux*U(dPlateThicknessF), -vxAux);
	_Beam1.addTool(ct2, _kStretchOnToolChange);
	
	vXBody=vz;
	vYBody=vy;
}
else
{		
	Body bdBmFem=_Beam1.realBody();
	
	Point3d ptIntersect[]=bdBmFem.intersectPoints(lnBm0);
	
	if (ptIntersect.length()<1)
	{
		eraseInstance();
		return;
	}
	
	dIntThick=abs(_Z1.dotProduct(ptIntersect[0]-ptIntersect[ptIntersect.length()-1]));
	
	ptInteriorProfile=ptIntersect[0];
	ptInteriorProfile.vis(2);
	
	vNormal=_Z1;
	vXBody=_X1;
	vYBody=_Y1;
	
	Cut ct(ptInteriorProfile-_Z1*U(dPlateThicknessM), _Z1);
	_Beam0.addTool(ct, _kStretchOnToolChange);
	
	ptUp=_Pt0+vz*(dHeight*0.5);
	ptUp=Line(ptUp, vx).intersect(plnFace, 0);
	ptUp.vis();
	
	ptDown=_Pt0-vz*(dHeight*0.5);
	ptDown=Line(ptDown, vx).intersect(plnFace, 0);
	ptDown.vis();
	
	ptLeft=_Pt0+vy*(dWidth*0.5);
	ptLeft=Line(ptLeft, vx).intersect(plnFace, 0);
	//ptLeft.vis();
	
	ptRight=_Pt0-vy*(dWidth*0.5);
	ptRight=Line(ptRight, vx).intersect(plnFace, 0);
	//ptRight.vis();
	
	Point3d ptUpFemale=_Pt0+vz*(dHeight*0.5);
	Point3d ptDownFemale=_Pt0-vz*(dHeight*0.5);
	
	if (dDepthTopCut>0)
	{
		Vector3d vzAux=_Beam1.vecD(vz);
		BeamCut bc (ptUp-vzAux*dDepthTopCut - _Z1*dBackTopCut, _Z1, vzAux, _Z1.crossProduct(vzAux), U(800), dWidth*3, dWidth*3, 1, 1, 0);
		//bc.cuttingBody().vis();
		_Beam0.addTool(bc);
	}
	
	if (dDepthBottomCut>0)
	{
		Vector3d vzAux=_Beam1.vecD(vz);
		BeamCut bc (ptDown+vzAux*dDepthBottomCut - _X0*dBackBottomCut, _Z1, -vzAux, _Z1.crossProduct(-vzAux), U(800), dWidth*3, dWidth*3, 1, 1, 0);
		//bc.cuttingBody().vis();
		_Beam0.addTool(bc);
	}
	
	if (dDepthLeftCut>0)
	{
		BeamCut bc (ptLeft-vy*dDepthLeftCut-_Z1*dBackLeftCut, _Z1, -vz, vy, U(800), dWidth*3, dWidth*3, 1, 0, 1);
		//bc.cuttingBody().vis();
		_Beam0.addTool(bc);
	}
	
	if (dDepthRightCut>0)
	{
		BeamCut bc (ptRight+vy*dDepthRightCut-_Z1*dBackRightCut, _Z1, -vz, vy, U(800), dWidth*3, dWidth*3, 1, 0, -1);
		//bc.cuttingBody().vis();
		_Beam0.addTool(bc);
	}
}

Body bd;
Body bd2;
Vector3d vecXBd;
Vector3d vecYBd;
Vector3d vecZBd;
Point3d ptPlate;

if (bSizeM)
{
	Plane plnCut(ptInteriorProfile, vNormal);
	PlaneProfile ppFace=_Beam0.realBody().extractContactFaceInPlane(plnCut, U(50));
	ppFace.vis(2);
	
	LineSeg ls=ppFace.extentInDir(vXBody);
	dPlateWidthM.set(abs(vXBody.dotProduct(ls.ptStart()-ls.ptEnd())));
	dPlateHeightM.set(abs(vYBody.dotProduct(ls.ptStart()-ls.ptEnd())));
}

if (bSizeF)
{
	Plane plnCut(ptInteriorProfile, vNormal);
	PlaneProfile ppFace=_Beam1.realBody().extractContactFaceInPlane(plnCut, U(50));
	ppFace.vis(3);
	
	LineSeg ls=ppFace.extentInDir(vXBody);
	dPlateWidthF.set(abs(vXBody.dotProduct(ls.ptStart()-ls.ptEnd())));
	dPlateHeightF.set(abs(vYBody.dotProduct(ls.ptStart()-ls.ptEnd())));
}


int bCutBm=FALSE;
if (bLocation) // SIDE
{
	Vector3d vecYPlate=vx.crossProduct(vz);
	ptPlate=ptInteriorProfile-vx*dPlateWidthM+vecYPlate*(dIntThick*0.5);
	
	if (bFlipSide)
	{
		vecYPlate=-vecYPlate;
		ptPlate=ptInteriorProfile-vx*dPlateWidthM+vecYPlate*(dIntThick*0.5);
	}
	
	bd=Body (ptPlate, vx, vz, vecYPlate, dPlateWidthM+U(20), dPlateHeightM, dPlateThicknessM, 1, 0, 1);
	//bd.vis();
	
	vecXBd=vx;
	vecYBd=vz;
	vecZBd=vecYPlate;
	
	Cut ctPlate (ptInteriorProfile, _Z1);
	bd.addTool(ctPlate);
	
}
else // FRONT
{
	Plane plnPlate (ptInteriorProfile-vx*U(dPlateThicknessM), vx);
	ptPlate=_L0.intersect(plnPlate, 0);
	ptPlate.vis();
	if (bFrontAngle)
	{
		bd=Body (ptPlate,  vz, vy, vx,  dPlateWidthM, dPlateHeightM,dPlateThicknessM,  0, 0, 1);
		bd2=Body (ptPlate+vx*U(dPlateThicknessF+dPlateThicknessM), vz, vy, vx,  dPlateWidthF, dPlateHeightF,dPlateThicknessF,  0, 0, -1);

		vecXBd=vz;
		vecYBd=vy;
		vecZBd=vx;
	}
	else
	{
		Plane plnPlate (ptInteriorProfile-_Z1*U(dPlateThicknessM), _Z1);
		ptPlate=_L0.intersect(plnPlate, 0);

		Vector3d vecYPlate=_X1.crossProduct(_Z1);
		
		bd=Body (ptPlate, _X1, vecYPlate, _Z1, dPlateWidthM, dPlateHeightM, dPlateThicknessM, 0, 0, 1);
		vecXBd=_X1;
		vecYBd=vecYPlate;
		vecZBd=_Z1;
		
		bCutBm= TRUE;
	}
	bd.vis();
	bd2.vis();
}



vecXBd.vis(_Pt0);
vecYBd.vis(_Pt0);
vecZBd.vis(_Pt0);

Beam bmPlate;
bmPlate.dbCreate(bd);
bmPlate.setColor(nColor);
bmPlate.setSubLabel2(_Beam1.subLabel2());
if (bCutBm && bCutPlate)
{
	//Vector3d vCut=_Beam0.vecD(vecXBd);
	Cut ct1 (ptUp, vz);
	bmPlate.addTool(ct1, _kStretchOnToolChange);
	Cut ct2 (ptDown, -vz);
	bmPlate.addTool(ct2, _kStretchOnToolChange);
}
if (bLocation==0)//FRONT
{
	bmPlate.setSubLabel2(_Beam0.subLabel2());
}
bmPlate.setName(sName);

_Map.appendEntity("bm", bmPlate);

Beam bmPlate2;

if (bFrontAngle)
{
	
	bmPlate2.dbCreate(bd2);
	bmPlate2.setColor(nColor);
	bmPlate2.setSubLabel2(_Beam0.subLabel2());
	bmPlate2.setName(sName);
	_Map.appendEntity("bm", bmPlate2);
}


if (bLocation) // SIDE
{
	Group gpAll0[]=_Beam0.groups();
	if (gpAll0.length()>0)
	{
		Group gp0=gpAll0[0];
		gp0.addEntity(bmPlate, TRUE);
		gp0.addEntity(_ThisInst, TRUE);
	}
}
else //FRONT
{
	Group gpAll1[]=_Beam1.groups();
	if (gpAll1.length()>0)
	{
		Group gp1=gpAll1[0];
		gp1.addEntity(bmPlate, TRUE);
		gp1.addEntity(_ThisInst, TRUE);
		if (bmPlate2.bIsValid())
		{
			gp1.addEntity(bmPlate2, TRUE);
		}
	}
}


if (nQty>0)
{
	ptPlate=bd.ptCen();

//////////////////////////////////////////////////////////////////////////////
// drills
//////////////////////////////////////////////////////////////////////////////
	Point3d ptDrillAr[0];
	Point3d ptDrill1=ptPlate-vecXBd*(dPlateWidthM*0.5)+vecXBd*(dDrillSideOffset)+vecYBd*(dPlateHeightM*0.5)-vecYBd*(dDrillTopOffset);
	Point3d ptDrill2=ptPlate-vecXBd*(dPlateWidthM*0.5)+vecXBd*(dDrillSideOffset)-vecYBd*(dPlateHeightM*0.5)+vecYBd*(dDrillTopOffset);
	ptDrillAr.append(ptDrill1);
	ptDrillAr.append(ptDrill2);
	
	if (nQty==2)
	{
		Point3d ptDrill1=ptPlate+vecXBd*(dPlateWidthM*0.5)-vecXBd*(dDrillSideOffset)+vecYBd*(dPlateHeightM*0.5)-vecYBd*(dDrillTopOffset);
		Point3d ptDrill2=ptPlate+vecXBd*(dPlateWidthM*0.5)-vecXBd*(dDrillSideOffset)-vecYBd*(dPlateHeightM*0.5)+vecYBd*(dDrillTopOffset);
		ptDrillAr.append(ptDrill1);
		ptDrillAr.append(ptDrill2);
	}
	
	for (int i=0; i<ptDrillAr.length(); i++)
	{
		Drill drl1(ptDrillAr[i]+vecZBd*U(60), -vecZBd, U(120), dDrillDiam*0.5);
		drl1.cuttingBody().vis();
		bd.addTool(drl1);
		bmPlate.addTool(drl1);
		if (bFrontAngle)
		{
			bmPlate2.addTool(drl1);
			continue;
		}
		if (bPost)
		{
			_Beam1.addTool(drl1);
		}
		else
		{
			if (bLocation==0)
			{
				_Beam1.addTool(drl1);
			}
			else
			{
				_Beam0.addTool(drl1);
			}
		}
	}
}

//dp.draw(bd);

//Display dp(-1);
//Display something
double dSize = Unit(12, "mm");
//Display dspl (-1);
PLine pl1(_ZW);
PLine pl2(_ZW);
PLine pl3(_ZW);
Point3d ptDraw=_Pt0;
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
Beam bm0 = _Beam1;
if (bLocation==0)//FRONT
{
	bm0 = _Beam0;
}


Beam bm=_Beam1;
if (bLocation==0)
{
	bm=_Beam0;
}

//Subassembly
TslInst tslSubAssembly = bm.subAssembly();
if( !tslSubAssembly.bIsValid() ){
	String strScriptName = "hsb-SubAssembly"; // name of the script
	Vector3d vecUcsX=bm.vecX();
	Vector3d vecUcsY=bm.vecZ();
	Beam lstBeams[1];
	lstBeams[0] = bm;
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

if (bFrontAngle)
{
	Beam bm=_Beam1;
	
	//Subassembly
	TslInst tslSubAssembly = bm.subAssembly();
	if( !tslSubAssembly.bIsValid() ){
		String strScriptName = "hsb-SubAssembly"; // name of the script
		Vector3d vecUcsX=bm.vecX();
		Vector3d vecUcsY=bm.vecZ();
		Beam lstBeams[1];
		lstBeams[0] = bm;
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

}


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
