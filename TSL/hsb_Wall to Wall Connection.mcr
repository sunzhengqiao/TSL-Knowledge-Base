#Version 8
#BeginDescription
* Modify by: Alberto Jena
* date: 18.04.2021 - version 1.13

















#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 13
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
* date: 25.05.2008
* version 1.0: Release Version
*
* date: 24.02.2009
* version 1.1: Fully T Connections Support
*
* date: 25.02.2009
* version 1.2: T and Corner Connections Support
*
* date: 02.06.2009
* version 1.3: Bug fix with the definition of Male and Female elements and add a property to center the studs on a L connection
*
* date: 02.06.2009
* version 1.4: 	Allow the TSL to be insert from the Palette
*				The conecctions stay available after generation
*				Add a custom command to regenerate the connection
*				Add a Display
*
* date: 31.07.2009
* version 1.5: 	Add double stud option
*				Fix the Corner connections
*
* date: 09.03.2010
* version 1.6: 	Fix issue on invert corner connection
*				Remove Itself if it's insert multiple times in the same connection
*
* date: 16.03.2012
* version 1.7: 	Fix issue when stretching to an angled top plate
*
* date: 12.04.2012
* version 1.9: 	Fix issue with the orientation of the multiple studs
*
* date: 18.04.2012
* version 1.10: Changed module of created beams to Handle of TSLInst
*
* date: 21.11.2012
* version 1.11: Add a check so it wont delete Beams that are part of a module in case they overlap the connection
*
*/

//-----------------------------------------------------------------------------------------------------------------------------------
//                                                                      Properties

//String arSCodeExternalWalls[]={"A", "B", "H", "I"}; //Add more External Walls codes as you request

double d2mm = U(2, 0.07874);
double d5mm = U(5, 0.19685);
double d10mm = U(10, 0.393701);
double d20mm = U(20, 0.787402);
double d40mm = U(40, 1.5748);
double d80mm = U(80, 3.1496);
double d200mm = U(200, 7.87402);

String sArNY[] = {T("No"), T("Yes")};

String sArType[] = {T("|L Backer|"), T("|L Backet Reverse|"), T("|U Shape|"), T("Multiple Studs")};
PropString sType (0, sArType, T("|Type|"));
sType.setDescription("");

int nQty[]={1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20};
PropInt nStuds (0, nQty, T("|Studs Qty|"));
nStuds.setDescription(T("Only valid when Multiple Studs are selected above"));

PropDouble dBackerBmHeight(0, 89, T("Backer Beam Height"));
PropDouble dBackerBmWidth(1, 38, T("Backer Beam Width"));

PropString sLocation(1, sArNY, T("Center Stud to Wall Edge"));
sLocation.setDescription("Valid on L Backer Connections");

PropString sDoubleStud(2, sArNY, T("Double Stud On L Backer"));
sDoubleStud.setDescription("Valid on L Backer Connections");

PropString sModule(3, sArNY, T("Create Beams as a Module"));
sModule.setDescription("");

PropInt nColorModule (1, 2, T("|Module Color|"));

PropString sStud(4,"-----------","Stud Details"); sStud.setCategory("Stud Beam Properties");
sStud.setReadOnly(TRUE);

PropString sNameS(5, "STUD", "Stud Name"); sNameS.setCategory("Stud Beam Properties");
sNameS.setDescription("");

PropString sMaterialS(6,"","Stud Material"); sMaterialS.setCategory("Stud Beam Properties");
sMaterialS.setDescription("");

PropString sGradeS(7,"","Stud Grade"); sGradeS.setCategory("Stud Beam Properties");
sGradeS.setDescription("");

PropString sInformationS(8,"","Stud Information"); sInformationS.setCategory("Stud Beam Properties");
sInformationS.setDescription("");

//PropString sLabel(4,"","Label");
PropString sSublabelS(9,"","Stud Sublabel"); sSublabelS.setCategory("Stud Beam Properties");
sSublabelS.setDescription("");

PropString sSublabel2S(10,"","Stud Sublabel 2"); sSublabel2S.setCategory("Stud Beam Properties");
sSublabel2S.setDescription("");

PropString sBackerB(11,"----------","Backer Details"); sBackerB.setCategory("Backer Beam Properties");
sBackerB.setReadOnly(TRUE);

PropString sNameB(12,"BACKER","Backer Name"); sNameB.setCategory("Backer Beam Properties");
sNameB.setDescription("");

PropString sMaterialB(13,"","Backer Material"); sMaterialB.setCategory("Backer Beam Properties");
sMaterialB.setDescription("");

PropString sGradeB(14,"","Backer Grade"); sGradeB.setCategory("Backer Beam Properties");
sGradeB.setDescription("");

PropString sInformationB(15,"","Backer Information"); sInformationB.setCategory("Backer Beam Properties");
sInformationB.setDescription("");

//PropString sLabel(4,"","Label");
PropString sSublabelB(16,"","Backer Sublabel"); sSublabelB.setCategory("Backer Beam Properties");
sSublabelB.setDescription("");

PropString sSublabel2B(17,"","Backer Sublabel 2"); sSublabel2B.setCategory("Backer Beam Properties");
sSublabel2B.setDescription("");

PropInt nColorDisp(2, 12, T("Color"));

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

int nType = sArType.find(sType);
int nStudsQty = nQty.find(nStuds);
int bLocation = sArNY.find(sLocation, 0);
int bModule = sArNY.find(sModule, 0);
int nDoubleStud = sArNY.find(sDoubleStud, 0);

//-----------------------------------------------------------------------------------------------------------------------------------
//                                                                           Insert

if(_bOnInsert){
	//if( insertCycleCount()>1 ){
		//eraseInstance();
		//return;
	//}
	if (_kExecuteKey=="")
		showDialogOnce();
		
	PrEntity ssE("\n"+T("Select 2 Walls Connected"),Element());
	
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}
	
	if (_Element.length()!=2)
	{
		eraseInstance();
		return;
	}
	
	//ExecutionMode set to Insert
	_Map.setInt("ExecutionMode",0);
	
	return;
}

if (_bOnElementConstructed)
{
	_Map.setInt("ExecutionMode",0);
}

if( _Element.length()!=2 ){
	eraseInstance();
	return;
}

String strChangeEntity = T("Reapply Wall Connection");
addRecalcTrigger(_kContext, strChangeEntity );
if (_bOnRecalc && _kExecuteKey==strChangeEntity)
{
	_Map.setInt("ExecutionMode", 0);
}

//Execution modes:
	//0 = Insert
	//1 = Recalc (default)
	//2 = Edit
	//3 = Delete
	//4 = ...
int nExecutionMode = 1;
if( _Map.hasInt("ExecutionMode") )
{
	nExecutionMode = _Map.getInt("ExecutionMode");
}

_Map.setInt("ExecutionMode", 1);

//-----------------------------------------------------------------------------------------------------------------------------------
//                                      Loop over all elements.

int nColor=32;
if (bModule)
	nColor=nColorModule;

ElementWall elWall[0];
String strWallNames[0];

for( int e=0; e<_Element.length(); e++ )
{
	ElementWall el = (ElementWall) _Element[e];
	if (el.bIsValid())
	{
		elWall.append(el);
	}
}

//
ElementWall elM;
ElementWall elF;
for (int j=0; j<elWall.length(); j++)
{
	ElementWall el=elWall[j];
	Element elCon[] = el.getConnectedElements();
	String strNameThis=el.code()+el.number();
	
	int nNext=j+1;
	if (elWall.length()==nNext)
	{
		nNext=0;
	}
	ElementWall elNext=elWall[nNext];

	String strName=elNext.code()+elNext.number();
	for (int i=0; i<elCon.length(); i++)
	{
		//Element elC=elCon[i];//dPosZOutlineFront
		ElementWall elC = (ElementWall) elCon[i];
		if (elC.bIsValid())
		{
			String strNameCon=elC.code()+elC.number();
			if (strNameCon==strName)
			{
				PLine plOutline=elC.plOutlineWall();
				Line lnEl(el.ptOrg()-el.vecZ()*d5mm,el.vecX());
				//Point3d ptArr[]=el.plOutlineWall().vertexPoints(TRUE);
				//int nIntersection=FALSE;
				
				Point3d ptInter[] = plOutline.intersectPoints(lnEl);
				if (ptInter.length()>0)
				{
					elF=elC;
					elM=el;
				}
				else
				{
					elM=elC;
					elF=el;
				}
				//for (int k=0; k<ptArr.length(); k++)
				//{
				//	if (plOutline.isOn(ptArr[k]))
				//		nIntersection=TRUE;
				//}
				
				//if (nIntersection)
				//{
				//	elM=el;
				//	elF=elC;
				//}
			}
		}
	}
}

if (!elM.bIsValid() ||  !elF.bIsValid())
{
	reportMessage(T("The selected wall connection is not valid, Please check if the 2 outlines match each other!"));
	eraseInstance();
	return;
}
// get the polyline of this element
PLine plEl = elF.plOutlineWall();


// visualize something
CoordSys csOther = elM.coordSys();
Line ln(csOther.ptOrg(),csOther.vecX());
//ln.vis();
Point3d pnts[] = plEl.intersectPoints(ln);
if (pnts.length()<=0) { // at least one intersection point
	ElementWall elAux=elF;
	elF=elM;
	elM=elAux;
}
if (!elM.bIsValid() || !elF.bIsValid())
{
	reportMessage(T("The selected wall connection is not valid, Please check if the 2 outlines match each other!"));
	eraseInstance();
	return;
}

//Coordinate System of the Female Wall
CoordSys cs=elF.coordSys();
Vector3d vx=cs.vecX();
Vector3d vy=cs.vecY();
Vector3d vz=cs.vecZ();

plEl = elF.plOutlineWall();

Plane plnY(elM.ptOrg(), vy);

LineSeg lsF=elF.segmentMinMax();
double dElFLength=abs(elF.vecX().dotProduct(lsF.ptStart()-lsF.ptEnd()));	//Length of female element
LineSeg lsDiagF (elF.ptOrg(), elF.ptOrg()+elF.vecX()*dElFLength-elF.vecZ()*elF.dBeamWidth());
lsDiagF.vis(1);

//Extreme poits of the Female Wall
Point3d ptStartF=lsDiagF.ptStart();
Point3d ptEndF=lsDiagF.ptEnd();

//Recreate the Pline of the base of the female element that it's only around zone 0
plEl.createRectangle(lsDiagF, elF.vecX(), elF.vecZ());
plEl.projectPointsToPlane(plnY, vy);
plEl.vis(2);

//Find Center point of Female Wall
Point3d ptVertex[]=plEl.vertexPoints(TRUE);
Point3d ptCenFemale;
ptCenFemale.setToAverage(ptVertex);
ptCenFemale.vis(2);

//Find Center Point of Male Wall
PLine plElM = elM.plOutlineWall();
Point3d ptVertexM[]=plElM.vertexPoints(TRUE);
Point3d ptCenMale;
ptCenMale.setToAverage(ptVertexM);
ptCenMale.vis(1);

//Set the vertor that will be pointing always in the direction of the connection
Vector3d vCon=elM.vecX();
if (vCon.dotProduct(ptCenMale-ptCenFemale)>0)
	vCon=-vCon;
	
vCon.vis(ptCenMale, 3);


// Find the intersection points witn the female element ptFront ans ptBack
CoordSys csM = elM.coordSys();
ln=Line(csM.ptOrg()-csM.vecZ()*d2mm,vCon);//-elM.vecZ()*d2mm
ln.vis();
pnts = plEl.intersectPoints(ln);
Point3d ptFront;
if (pnts.length()>0) { // at least one intersection point
	ptFront = pnts[0];
	ptFront.vis();
}
ptFront=ptFront+csM.vecZ()*d2mm;

Line lnBack(csM.ptOrg()-elM.vecZ()*((elM.dBeamWidth()-d2mm)), vCon);
Point3d ptBacks[]=plEl.intersectPoints(lnBack);
Point3d ptBack;
if (ptBacks.length()>0) { // at least one intersection point
	ptBack = ptBacks[0];
	ptBack.vis();
}
ptBack=ptBack-csM.vecZ()*d2mm;


_Pt0=ptFront;

LineSeg ls (ptFront, ptBack);

//collect the size of the female beam
double dWidth=elF.dBeamHeight();
double dHeight=elF.dBeamWidth();

//Check if one of this points are close to the edge of the female element so it will apply a corner connection and set the direction of creation of the beams
int nCorner=FALSE;
Vector3d vDir=ptBack-ptFront;
Point3d ptToCreate=ptFront;

if(nType==1)
	ptToCreate=ptBack;

if (abs(vx.dotProduct(ptFront-ptStartF))<d20mm)
{
	ptToCreate=ptFront;
	vDir=ptBack-ptFront;
	nCorner=TRUE;
}
if (abs(vx.dotProduct(ptBack-ptStartF))<d20mm)
{
	ptToCreate=ptBack;
	vDir=ptFront-ptBack;
	nCorner=TRUE;
}
if (abs(vx.dotProduct(ptFront-ptEndF))<d20mm)
{
	ptToCreate=ptFront;
	vDir=ptBack-ptFront;
	nCorner=TRUE;
}
if (abs(vx.dotProduct(ptBack-ptEndF))<d20mm)
{
	ptToCreate=ptBack;
	vDir=ptFront-ptBack;
	nCorner=TRUE;
}

//reportNotice(nCorner+"\n");

vDir.normalize();
vDir.vis(_Pt0, 2);

if (bLocation && nType<2) //L Backer or L Backer Reverse with the option of center
{
	if (nType==0)
		ptToCreate=ptToCreate+vDir*dWidth*0.5;
	else if (nType==1)
		ptToCreate=ptToCreate-vDir*dWidth*0.5;
}




Body bdBm;
String sConCode=_ThisInst.handle();//elM.number()+elF.number();
Map mpBm;
mpBm.setInt("bErase", TRUE);
_Map.setString("sConCode", sConCode);

TslInst tslAll[]=elM.tslInstAttached();
for (int i=0; i<tslAll.length(); i++)
{
	if ( tslAll[i].scriptName() == scriptName() && tslAll[i].handle() != _ThisInst.handle() )
	{
		Map mpThisInst=tslAll[i].map();
		if (mpThisInst.hasString("sConCode"))
		{
			String sExistingCon=mpThisInst.getString("sConCode");
			if (sExistingCon==sConCode)
			{
				tslAll[i].dbErase();
			}
		}
	}
}


int nBeamsToAvoid[0];
nBeamsToAvoid.append(_kKingStud);
nBeamsToAvoid.append(_kSFSupportingBeam);

//Custom Menu to Generate the construction
if ( _bOnDebug || nExecutionMode == 0)
{
	
	Beam bmAll[] = elF.beam();
	
	if (bmAll.length() < 1)
		return;
	
	Beam bmVer[] = elF.vecX().filterBeamsPerpendicular(bmAll);
	
	Beam bmTop[0];
	Beam bmBottom[0];
	for (int i = 0; i < bmAll.length(); i++)
	{
		
		Beam bm = bmAll[i];
		if (bm.type() == _kSFTopPlate || bm.type() == _kSFAngledTPLeft || bm.type() == _kSFAngledTPRight)
			bmTop.append(bm);
		if (bm.type() == _kSFBottomPlate)
			bmBottom.append(bm);
		Map mpNewBm = bm.subMap(sConCode);
		if (mpNewBm.hasInt("bErase"))
			bm.dbErase();
	}
	
	Beam bmStuds[0];
	Beam bmBrace[0];
	
	if (nType == 0) //L Shape
	{
		Point3d ptCreate = ptToCreate;
		if (nCorner == TRUE)
		{
			if (nDoubleStud)
				ptCreate = ptToCreate + vDir * dWidth * 2;
			else
				ptCreate = ptToCreate + vDir * dWidth;
		}
		ptCreate.vis();
		Beam bm;//Stud
		bm.dbCreate(ptCreate + elF.vecY() * d20mm, vy, vDir, vCon, d80mm, dWidth, dHeight, 0, - 1, 1);//vy.crossProduct(vCon)
		bmStuds.append(bm);
		
		//_Map.appendEntity("beam", bm);
		
		if (nDoubleStud)
		{
			Beam bmD;//Stud
			bmD.dbCreate(ptCreate - vDir * dWidth + elF.vecY() * d20mm, vy, vDir, vCon, d80mm, dWidth, dHeight, 0, - 1, 1);//vy.crossProduct(vCon)
			bmStuds.append(bmD);
		}
		
		
		Beam bm2;//Nailing Beam
		bm2.dbCreate(ptCreate + elF.vecY() * d20mm, vy, vCon, vDir, d80mm, dBackerBmWidth, dBackerBmHeight, 0, 1, 1);//vy.crossProduct(vCon)
		bmBrace.append(bm2);
	}
	
	if (nType == 1 && nCorner == FALSE) //L Shape Reverse
	{
		Point3d ptCreate = ptToCreate;
		if (nCorner == TRUE)
		{
			if (nDoubleStud)
				ptCreate = ptToCreate + vDir * dWidth * 2;
			else
				ptCreate = ptToCreate + vDir * dWidth;
		}
		Beam bm;//Stud
		bm.dbCreate(ptCreate + elF.vecY() * d20mm, vy, vDir, vCon, d80mm, dWidth, dHeight, 0, 1, 1);//vy.crossProduct(vCon)
		bmStuds.append(bm);
		
		if (nDoubleStud)
		{
			Beam bmD;//Stud
			bmD.dbCreate(ptCreate + vDir * dWidth + elF.vecY() * d20mm, vy, vDir, vCon, d80mm, dWidth, dHeight, 0, 1, 1);//vy.crossProduct(vCon)
			bmStuds.append(bmD);
		}
		
		
		Beam bm2;//Nailing Beam
		bm2.dbCreate(ptCreate + elF.vecY() * d20mm, vy, vCon, vDir, d80mm, dBackerBmWidth, dBackerBmHeight, 0, 1, - 1); //vy.crossProduct(vCon)
		bmBrace.append(bm2);
	}
	
	if (nType == 2 )//U Shape 		&& nCorner == FALSE
	{
		Point3d ptCreate = ls.ptMid();
		if (nCorner == TRUE)
		{
			ptCreate = ptCreate + vDir * ((dBackerBmHeight * 0.5 + dWidth) - (ptBack - ptFront).length() * 0.5);
		}
		
		ptCreate.vis();
		
		Beam bm;//Stud Left
		bm.dbCreate(ptCreate + vDir * dBackerBmHeight * .5 + elF.vecY() * d20mm, vy, vCon, vDir, d80mm, dHeight, dWidth, 0, 1, 1);
		bmStuds.append(bm);
		
		Beam bm3;//Stud Right
		bm3.dbCreate(ptCreate - vDir * dBackerBmHeight * .5 + elF.vecY() * d20mm, vy, vCon, vDir, d80mm, dHeight, dWidth, 0, 1, - 1);
		bmStuds.append(bm3);
		
		Beam bm2;//Nailing Beam
		bm2.dbCreate(ptCreate + elF.vecY() * d20mm, vy, vDir, vCon, d80mm, dBackerBmHeight, dBackerBmWidth, 0, 0, 1);
		bmBrace.append(bm2);
		
		//_Map.appendEntity("beam", bm2);
	}
	if (nType == 3)//Multiple Studs
	{
		Point3d ptCreate = ls.ptMid();
		ptCreate = ptCreate - vDir * dWidth * ((nStudsQty - 1) * .5);
		if (nCorner == TRUE)
		{
			ptCreate = ptToCreate + vDir * dWidth; ptCreate.vis(1);
		}
		for (int i = 0; i <= nStudsQty; i++)
		{
			Beam bm;//Stud Left
			bm.dbCreate(ptCreate + elF.vecY() * d20mm, vy, vDir, - vCon, d80mm, dWidth, dHeight, 0, - 1, - 1);
			bmStuds.append(bm);
			
			ptCreate = ptCreate + vDir * dWidth; ptCreate.vis(1);
		}
	}
	
	//Set the name of the beams and stretch the beams
	for (int i = 0; i < bmStuds.length(); i++)
	{
		Beam bm = bmStuds[i];
		
		bm.setColor(nColor);
		bm.setName(sNameS);
		bm.setType(_kStud);
		bm.setMaterial(sMaterialS);
		bm.setGrade(sGradeS);
		bm.setInformation(sInformationS);
		bm.setSubLabel(sSublabelS);
		bm.setSubLabel2(sSublabel2S);
		bm.assignToElementGroup(elF, TRUE, 0, 'Z');
		if (bModule)
			bm.setModule(sConCode);
		bdBm.addPart(bm.realBody());
		bm.setSubMap(sConCode, mpBm);
		
		Beam bmAux[0];
		bmAux = Beam().filterBeamsHalfLineIntersectSort(bmTop, bm.ptCen(), vy);
		if (bmAux.length() > 0)
		{
			bm.stretchDynamicTo(bmAux[0]);
		}
		bmAux.setLength(0);
		bmAux = Beam().filterBeamsHalfLineIntersectSort(bmBottom, bm.ptCen(), - vy);
		if (bmAux.length() > 0)
		{
			bm.stretchDynamicTo(bmAux[0]);
		}
	}
	
	for (int i = 0; i < bmBrace.length(); i++)
	{
		Beam bm = bmBrace[i];
		
		bm.setColor(nColor);
		bm.setName(sNameB);
		bm.setType(_kStud);
		bm.setMaterial(sMaterialB);
		bm.setGrade(sGradeB);
		bm.setInformation(sInformationB);
		bm.setSubLabel(sSublabelB);
		bm.setSubLabel2(sSublabel2B);
		bm.assignToElementGroup(elF, TRUE, 0, 'Z');
		if (bModule)
			bm.setModule(sConCode);
		bdBm.addPart(bm.envelopeBody(true, true));
		bm.setSubMap(sConCode, mpBm);
		
		Beam bmAux[0];
		bmAux = Beam().filterBeamsHalfLineIntersectSort(bmTop, bm.ptCen(), vy);
		if (bmAux.length() > 0)
		{
			bm.stretchDynamicTo(bmAux[0]);
		}
		bmAux.setLength(0);
		bmAux = Beam().filterBeamsHalfLineIntersectSort(bmBottom, bm.ptCen(), - vy);
		if (bmAux.length() > 0)
		{
			bm.stretchDynamicTo(bmAux[0]);
		}
	}
	
	PlaneProfile ppNewConnection(plnY);
	ppNewConnection = bdBm.shadowProfile(plnY);
	ppNewConnection.shrink(U(1));
	
	for (int i = 0; i < bmVer.length(); i++)
	{
		Body bdThisBeam = bmVer[i].envelopeBody(TRUE, TRUE);
		if (bdThisBeam.hasIntersection(bdBm))
		{
			int nBeamType = bmVer[i].type();
			if (nBeamsToAvoid.find(nBeamType, - 1) == -1)
			{
				PlaneProfile ppThisBeam(plnY);
				ppThisBeam = bdThisBeam.shadowProfile(plnY);
				ppThisBeam.shrink(U(1));
				if (ppThisBeam.intersectWith(ppNewConnection))
				{
					bmVer[i].dbErase();
				}
			}
		}
	}
}

assignToElementGroup(elF, TRUE, 0, 'T');
_Map.setInt("nExecutionMode", 1);

Display dp(nColorDisp);
//Display something
double dSize = Unit(25, "mm");
//Display dspl (-1);
PLine pl1(_ZW);
PLine pl2(_ZW);
PLine pl3(_ZW);
PLine pl4(_ZW);
PLine pl5(_ZW);
Point3d ptDraw=ls.ptMid();
ptDraw=ptDraw+vx*d10mm+vy*d10mm-vz*d40mm;
pl1.addVertex(ptDraw+vx*dSize);
pl1.addVertex(ptDraw-vx*dSize);
pl2.addVertex(ptDraw-vy*dSize);
pl2.addVertex(ptDraw+vy*dSize);
pl3.addVertex(ptDraw-vz*dSize);
pl3.addVertex(ptDraw+vz*dSize);
pl4.addVertex(ptDraw+vx*dSize);
pl4.addVertex(ptDraw+vz*dSize);
pl5.addVertex(ptDraw-vx*dSize);
pl5.addVertex(ptDraw-vz*dSize);

dp.draw(pl1);
dp.draw(pl2);
dp.draw(pl3);
dp.draw(pl4);
dp.draw(pl5);





#End
#BeginThumbnail
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
%110!_]GK
`











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