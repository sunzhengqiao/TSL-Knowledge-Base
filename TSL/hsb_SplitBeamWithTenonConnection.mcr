#Version 8
#BeginDescription
Splits any beam that is longer than a property and create a lap joint connection between them.

Modified by: Alberto Jena (alberto.jena@hsbcad.com)
Date: 28.02.2017  -  version 1.2


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

* REVISION HISTORY
* -------------------------
*
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 03.03.2016
* version 1.0: Release Version
*
*/

String sTenon=T("|Tenon|");
String sMortice=T("|Mortice|");
String sDrills=T("|Drill distribution|");

PropDouble dTHeight(0, U(100), T("|Tenon height|"));	dTHeight.setCategory(sTenon);
PropDouble dTWidth(1, U(50), T("|Tenon width|"));		dTWidth.setCategory(sTenon);
PropDouble dOffsetTenon (11, U(0), T("Tenon Offset")); dOffsetTenon.setCategory(sTenon);

PropDouble dMHeight(3, U(100), T("|Mortice height|"));	dMHeight.setCategory(sMortice);
PropDouble dMWidth(2, U(50), T("|Mortice width|"));		dMWidth.setCategory(sMortice);
PropDouble dOffset(4, U(30), T("|Offset|"));				dOffset.setCategory(sMortice);

PropDouble dCutAngle (5, U(10), T("|Angle|"));

PropDouble dPEdgeOffset (7, U(72), T("|Distance from edge|"));								dPEdgeOffset.setCategory(sDrills);
PropDouble dPHorizontalDistance (8, U(36), T("|Horizontal distance between holes|"));	dPHorizontalDistance.setCategory(sDrills);
PropDouble dPVerticalDistance (9, U(36), T("|Vertical distance between holes|"));			dPVerticalDistance.setCategory(sDrills);
PropDouble dPPressingDistance (10, U(1.5), T("|Pressing distance|"));						dPPressingDistance.setCategory(sDrills);

PropDouble dNewDiameter (6, U(16), T("|Diameter|")); 										dNewDiameter.setCategory(sDrills);



String sYesNo[]={T("No"), T("Yes")};
PropString sFlip (0, sYesNo, T("Flip side"));

//String sHardware

if( _bOnInsert )
{
	if( insertCycleCount()>1 )
	{
		eraseInstance();
		return;
	}

	if (_kExecuteKey=="")
		showDialogOnce();
	
	_Beam.append(getBeam(T("Pick a beam")));
	_Pt0 = getPoint(T("Pick a point"));
	return;
}


if (_bOnDbCreated || _bOnInsert) setPropValuesFromCatalog(_kExecuteKey);

if( _Beam.length() == 0 ){
	eraseInstance();
	return;
}

Line lnX (_Beam[0].ptCen(), _Beam[0].vecX());
_Pt0=lnX.closestPointTo(_Pt0);

if (_Beam.length()==1)
{
	Beam bm=_Beam[0].dbSplit(_Pt0, _Pt0);
	if (bm.bIsValid())
		_Beam.append(bm);
}

Beam bmMale=_Beam[0];
Beam bmFemale=_Beam[1];	

int nFlip=false;
if (sFlip=="Yes")
{
	bmMale=_Beam[1];	
	bmFemale=_Beam[0];	
}

double dOffsetMaleCuts=U(2);

Vector3d vx=bmMale.vecX();
if (vx.dotProduct(_Pt0-bmMale.ptCen())<0)
	vx=-vx;
Vector3d vz=bmMale.vecD(_ZW);
Vector3d vy=vz.crossProduct(vx);
vy.normalize();


//Angle Cut
Point3d ptTopBeam=_Pt0+vz*(bmMale.dD(vz)*0.5);
ptTopBeam=ptTopBeam-vy*dOffsetTenon;


Vector3d vAngleCut=vx.rotateBy(dCutAngle, vy);

vAngleCut.vis(_Pt0, 1);

Point3d ptCutEndMale=_Pt0+vx*dTHeight;
ptCutEndMale.vis(1);

Cut ctMale(ptCutEndMale, vx);
Cut ctAngleFemale(ptTopBeam, -vAngleCut);

bmMale.addTool(ctMale, _kStretchOnToolChange);
bmFemale.addTool(ctAngleFemale, _kStretchOnToolChange);

//Female Cuts
BeamCut bcFemale (ptTopBeam, vx, vy, vz, dMHeight*2, dMWidth, (bmMale.dD(vz)-dOffset)*2, 0,0,0);
//bcFemale.cuttingBody().vis();
bmFemale.addTool(bcFemale);

//Cut Male
Vector3d vzCut=vAngleCut.crossProduct(vy);
vzCut.normalize();

BeamCut bmMaleLeft (ptTopBeam+vy*dTWidth*0.5-vzCut*bmMale.dD(vz)*0.5, vAngleCut, vy, vzCut, dTHeight*2, bmMale.dD(vy), bmMale.dD(vz)*2, 1, 1, 0);
//bmMaleLeft.cuttingBody().vis();
bmMale.addTool(bmMaleLeft);

BeamCut bmMaleRight (ptTopBeam-vy*dTWidth*0.5-vzCut*bmMale.dD(vz)*0.5, vAngleCut, vy, vzCut, dTHeight*2, bmMale.dD(vy), bmMale.dD(vz)*2, 1, -1, 0);
//bmMaleRight.cuttingBody().vis();
bmMale.addTool(bmMaleRight);

Line lnZCut(ptTopBeam, vzCut);
Plane pln (_Pt0-vz*bmMale.dD(vz)*0.5+vz*dOffset, vz);

Point3d ptBaseCut=lnZCut.intersect(pln, 0);
BeamCut bcCutBaseMale (ptBaseCut+vx*dOffsetMaleCuts, vx, -vy, -vz, dMHeight*2, dMWidth*2, dOffset*2, 1,0,1);
bcCutBaseMale.cuttingBody().vis();
bmMale.addTool(bcCutBaseMale);

BeamCut bcAngleCutBaseMale (ptBaseCut+vx*dOffsetMaleCuts, vAngleCut, -vy, -vzCut, dMHeight*2, dMWidth*2, dOffset*2, 1,0,1);
bcAngleCutBaseMale.cuttingBody().vis();
bmMale.addTool(bcAngleCutBaseMale);

//Drills
if (dNewDiameter>0)
{

	

	Point3d ptCenterForDrills=ptTopBeam+vx*dTHeight-vz*((bmMale.dD(vz)-dOffset))*0.5-vx*U(dPEdgeOffset);
	ptCenterForDrills.vis(2);
	//Female Beam Drills
	Point3d ptDrill1=ptCenterForDrills+vz*dPVerticalDistance*0.5;
	Point3d ptDrill2=ptCenterForDrills-vz*dPVerticalDistance*0.5-vx*dPHorizontalDistance;

	Drill drl1(ptDrill1+vy*bmMale.dD(vy)*26, ptDrill1-vy*bmMale.dD(vy)*2, dNewDiameter*0.5);
	bmFemale.addTool(drl1);
	
	Drill drl2(ptDrill2+vy*bmMale.dD(vy)*2, ptDrill2-vy*bmMale.dD(vy)*2, dNewDiameter*0.5);
	bmFemale.addTool(drl2);
	
	//HardWrComp allComponent[]=_ThisInst.hardWrComps();
	
	//Male Beam Drills
	Point3d ptDrill1Male=ptDrill1-vx*dPPressingDistance;
	Point3d ptDrill2Male=ptDrill2-vx*dPPressingDistance;
	
	Drill drl1Male(ptDrill1Male+vy*bmMale.dD(vy)*2, ptDrill1Male-vy*bmMale.dD(vy)*2, dNewDiameter*0.5);
	bmMale.addTool(drl1Male);
	
	Drill drl2Male(ptDrill2Male+vy*bmMale.dD(vy)*2, ptDrill2Male-vy*bmMale.dD(vy)*2, dNewDiameter*0.5);
	bmMale.addTool(drl2Male);
	
}

//Display
Display dp(-1);

Point3d ptDraw = _Pt0;

PLine pl1(_XW);
PLine pl2(_YW);
PLine pl3(_ZW);
pl1.addVertex(ptDraw+vz*U(5));
pl1.addVertex(ptDraw-vz*U(5));
pl2.addVertex(ptDraw-vx*U(5));
pl2.addVertex(ptDraw+vx*U(5));
pl3.addVertex(ptDraw-vy*U(5));
pl3.addVertex(ptDraw+vy*U(5));

dp.draw(pl1);
dp.draw(pl2);
dp.draw(pl3);


//{
	//HardWrComp hwc("Oak Peg 18/125mm",2);
		//hwc.setBVisualize(TRUE);
		//hwc.setRepType(_kRTUser);
		//hwc.setName("Wood peg");
		//hwc.setDescription("Peg");
		//hwc.setManufacturer("");
		//hwc.setModel("");
		//hwc.setMaterial("Oak");
		//hwc.setCategory("Pegs");
		//hwc.setGroup("");
		//hwc.setNotes("");
		//hwc.setCountType(_kCTAmount);
		//hwc.setDScaleX(U(125.0));
		//hwc.setDScaleY(U(18.0));
		//hwc.setDScaleZ(U(18.0));
		//hwc.setDOffsetX(U(0.0));
		//hwc.setDOffsetY(U(5.0));
		//hwc.setDOffsetZ(U(0.0));
		//hwc.setDAngleA(0.0);
		//hwc.setDAngleB(0.0);
		//hwc.setDAngleG(0.0);
//}

#End
#BeginThumbnail


#End