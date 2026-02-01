#Version 8
#BeginDescription
Last modified by: Alberto Jena (ajena@itw-industry.com)
31.10.2013  -  version 1.21






#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 21
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
* date: 19.12.2010
* version 1.0: Release Version
*
* date: 28.02.2010
* version 1.2: Cut blocking with the angle of the top plates
*
* date: 30.03.2011
* version 1.3: Full change setting the space stud as a subassembly tsl
*
* date: 10.05.2011
* version 1.5: Add gaps on the cripples
*
* date: 07.06.2011
* version 1.6: 	Add property to Exclude Beams by Code
*				Add property to Exclude Beams by Length
*
* date: 08.06.2011
* version 1.7: 	Fix issue with minimum length
*
* date: 03.08.2011
* version 1.8: 	Support for wall 181mm
*
* date: 03.08.2011
* version 1.9: 	BugFix
*
* date: 03.08.2011
* version 1.9: 	BugFix
*
* date: 20.09.2011
* version 1.10: Add a property for single plate
*
* date: 21.09.2011
* version 1.14: Add the option to only add clips to beams less than minimum length
*
* date: 01.02.2012
* version 1.16: Add property to avoid all the beams that are part of an opening
*
* date: 19.12.2012
* version 1.18: Added 206mm studs
*
* date: 16.01.2013
* version 1.19: Add a property to exclude/include Packers as space stud
*
* date: 01.02.2013
* version 1.20: Add support for space studs with diferent size of beams in the front and back.
*
* date: 31.10.2013
* version 1.21: Add support for size 233
*/

//-----------------------------------------------------------------------------------------------------------------------------------
//                                                                      Properties

_ThisInst.setSequenceNumber(120);

//String arSCodeExternalWalls[] = { "A", "B", "H", "I"}; //Add more External Walls codes as you request

String sArNY[] = {T("No"), T("Yes")};

PropString psExtType(0, "M;",  T("Code SpaceStud Wall"));

PropString sMes(1, "----------", T("Beams NOT to plate"));
sMes.setReadOnly(true);

PropString sJacks(2, sArNY, T("Jacks Above/Below Opening"));
sJacks.setDescription("");

PropString sBlocking(3, sArNY, T("Blocking"));
sBlocking.setDescription("");

PropString sPlateTopPlate(13, sArNY, T("Top Plate"));
sPlateTopPlate.setDescription("");

PropString sPlateBottomPlate(14, sArNY, T("Bottom Plate"));
sPlateBottomPlate.setDescription("");

PropString sPlateTransom(15, sArNY, T("Transom"));
sPlateTransom.setDescription("");



PropString sMes2(4, "----------", T("Beams to Ignore"));
sMes2.setReadOnly(true);

PropString sAllOpBeams(16, sArNY, T("Ignore all opening beams"));
sAllOpBeams.setDescription("This will ignore cripples, king studs, sill, transom, jacks");

PropString sTopPlate(5, sArNY, T("Top Plate "));
sTopPlate.setDescription("");

PropString sBottomPlate(6, sArNY, T("Bottom Plate "));
sBottomPlate.setDescription("");

PropString sCripple(7, sArNY, T("First Cripple"));
sCripple.setDescription("");

PropString sAllCripples(17, sArNY, T("All Cripples"));
sAllCripples.setDescription("");

PropString sKingStud(18, sArNY, T("King Studs"));
sKingStud.setDescription("");

PropString sIgnoreJacks(19, sArNY, T("Jacks Above/Below Opening "));
sIgnoreJacks.setDescription("");

PropString sStuds(8, sArNY, T("Left/Right Studs"));
sStuds.setDescription("");

PropString sOpBeams(9, sArNY, T("Sill/Transom"));
sOpBeams.setDescription("");

PropString sPacker(20, sArNY, T("Packer"));
sPacker.setDescription("");

PropString sClip(11, sArNY, T("Apply only one clip"));
sClip.setDescription("");

PropString sbmCode (10,"",T("Exclude Beams with Code"));
sbmCode.setDescription(T("Please fill the codes that you dont need to be convert, use ';' if you want to filter more that 1 code"));

PropDouble dMinLength(0, U(600), T("Minimum length for space stud"));
dMinLength.setDescription(T("If 0 is set then it wont use this filter"));

PropString sOnlyClip(12, sArNY, T("Only clip beams smaller than minimum length"));
sOnlyClip.setDescription("");


//PropDouble dSizeFloor (1, U(0), T("Offset for Floor"));


//PropDouble dOffsetCenters (2, U(1200), T("Centers Spacing"));

//PropDouble dOSBTh (3, U(12), T("OSB Thickness"));

double dOffsetBottom=U(70);
double dOffsetTop=U(70);
double dOffsetCenters=U(600);
//double dOSBTh=U(15);

//double dSizeFloor=U(0);

//PropString sShowNailPlate(12, sArNY, T("Insert Nail Plates"));
//sShowNailPlate.setDescription("");
//int bShowNailPlate = sArNY.find(sShowNailPlate,0);

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey); 

int bJacks = sArNY.find(sJacks,0);
int bBlocking = sArNY.find(sBlocking,0);
int bPlateTopPlate = sArNY.find(sPlateTopPlate,0);
int bPlateBottomPlate = sArNY.find(sPlateBottomPlate,0);
int bPlateTransom = sArNY.find(sPlateTransom,0);


int bTopPlate = sArNY.find(sTopPlate,0);
int bBottomPlate = sArNY.find(sBottomPlate,0);
int bCripple = sArNY.find(sCripple,0);
int bStuds = sArNY.find(sStuds,0);
int bOpBeams = sArNY.find(sOpBeams,0);
int bPacker = sArNY.find(sPacker,0);
int bAllOpBeams = sArNY.find(sAllOpBeams,0);

int bAllCripples= sArNY.find(sAllCripples,0);
int bKingStud= sArNY.find(sKingStud,0);
int bIgnoreJacks= sArNY.find(sIgnoreJacks,0);


int bSingleClip = sArNY.find(sClip, 0);
int bOnlyClip = sArNY.find(sOnlyClip, 0);

//-----------------------------------------------------------------------------------------------------------------------------------
//                                                                           Insert

if(_bOnInsert){
	if( insertCycleCount()>1 ){
		eraseInstance();
		return;
	}
	if (_kExecuteKey=="")
		showDialogOnce();
	PrEntity ssE("\n"+T("Select a set of elements"),Element());
	
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}
	
	return;
}


String sAllBmCodes[0];
String sBeamType=sbmCode;
sBeamType.trimLeft();
sBeamType.trimRight();
sBeamType=sBeamType+";";
for (int i=0; i<sBeamType.length(); i++)
{
	String str=sBeamType.token(i);
	str.trimLeft();
	str.trimRight();
	str.makeUpper();
	if (str.length()>0)
		sAllBmCodes.append(str);
}


if( _Element.length()==0 ){
	eraseInstance();
	return;
}

//Fill and array with the code of the firewalls

String sArrExtCode[0];
String sExtType=psExtType;
sExtType.trimLeft();
sExtType.trimRight();
sExtType=sExtType+";";
for (int i=0; i<sExtType.length(); i++)
{
	String str=sExtType.token(i);
	str.trimLeft();
	str.trimRight();
	if (str.length()>0)
		sArrExtCode.append(str);
}

//-----------------------------------------------------------------------------------------------------------------------------------
//          Loop over all elements.

ElementWallSF elWall[0];

for( int e=0; e<_Element.length(); e++ )
{
	ElementWallSF el = (ElementWallSF) _Element[e];
	if (el.bIsValid())
	{
		String sCode = el.code();
		if( sArrExtCode.find(sCode) != -1 )
		{
			elWall.append(el);
		}
	}
}

int nBmTypeNoPlate[0];

if (bPlateTopPlate)
	nBmTypeNoPlate.append(_kSFTopPlate);

if (bPlateBottomPlate)
	nBmTypeNoPlate.append(_kSFBottomPlate);

if (bPlateTransom)
	nBmTypeNoPlate.append(_kSFTransom);

if (bBlocking)
	nBmTypeNoPlate.append(_kSFBlocking);

if (bJacks)
{
	nBmTypeNoPlate.append(_kSFJackOverOpening);
	nBmTypeNoPlate.append(_kSFJackUnderOpening);
}

int nBmTypeToAvoid[0];
if (bTopPlate)
{
	nBmTypeToAvoid.append(_kSFTopPlate);
	nBmTypeToAvoid.append(_kSFAngledTPLeft);
	nBmTypeToAvoid.append(_kSFAngledTPRight);
}

if (bBottomPlate)
	nBmTypeToAvoid.append(_kSFBottomPlate);

if (bOpBeams)
{
	nBmTypeToAvoid.append(_kHeader);
	nBmTypeToAvoid.append(_kSill);
	nBmTypeToAvoid.append(_kSFTransom);
	//
}

if (bPacker)
{
	nBmTypeToAvoid.append(_kSFPacker);
}

if (bAllCripples)
{
	nBmTypeToAvoid.append(_kSFSupportingBeam);
}

if (bKingStud)
{
	nBmTypeToAvoid.append(_kKingStud);
}

if (bIgnoreJacks)
{
	nBmTypeToAvoid.append(_kSFJackOverOpening);
	nBmTypeToAvoid.append(_kSFJackUnderOpening);
}

if(bAllOpBeams)
{
	nBmTypeToAvoid.append(_kHeader);
	nBmTypeToAvoid.append(_kSill);
	nBmTypeToAvoid.append(_kSFTransom);
	nBmTypeToAvoid.append(_kSFPacker);
	nBmTypeToAvoid.append(_kSFJackOverOpening);
	nBmTypeToAvoid.append(_kSFJackUnderOpening);
	nBmTypeToAvoid.append(_kSFSupportingBeam);
	nBmTypeToAvoid.append(_kKingStud);

}

//nBmTypeToAvoid.append(_kSFStudLeft);
//nBmTypeToAvoid.append(_kSFStudRight);

double dClipTh[]={U(1), U(1), U(1), U(1), U(1), U(1), U(1)};
double dClipWi[]={U(38), U(38), U(38), U(38), U(38), U(38), U(38)};
double dClipLe[]={U(148), U(121), U(148), U(148), U(148), U(148), U(121)};
String sClipName[]={"SpaceStud 80mm", "SpaceStud 55mm", "SpaceStud 80mm", "SpaceStud 80mm", "SpaceStud 55mm", "SpaceStud 80mm", "SpaceStud 55mm"};

double dNPTh[]={U(1), U(1), U(1), U(1), U(1), U(1), U(1)};
double dNPWi[]={U(89), U(89), U(89), U(89), U(89), U(89), U(89)};
double dNPLe[]={U(43), U(43), U(43), U(43), U(43), U(43), U(43)};
String sNPName[]={"A9 Nail Plate", "A9 Nail Plate", "A9 Nail Plate", "A9 Nail Plate", "A9 Nail Plate", "A9 Nail Plate", "A9 Nail Plate"};

double dSSWidth[]={U(38), U(38), U(38), U(38), U(38), U(38), U(38)};
double dSSHeight[]={U(258), U(181), U(260), U(206), U(207), U(232), U(233)};
double dSSNewWidthFront[]={U(38), U(38), U(38), U(38), U(38), U(38), U(38)};
double dSSNewHeightFront[]={U(89), U(63), U(90), U(63), U(63), U(63), U(89)};

double dSSNewWidthBack[]={U(38), U(38), U(38), U(38), U(38), U(38), U(38)};
double dSSNewHeightBack[]={U(89), U(63), U(90), U(63), U(89), U(89), U(89)};

double dSSDistToMoveFront[]={U(84.5), U(59), U(85), U(71.5), U(72), U(84.5), U(72)};
double dSSDistToMoveBack[]={U(84.5), U(59), U(85), U(71.5), U(59), U(71.5), U(72)};

double dSSBlockLength[]={U(80), U(55), U(80), U(80), U(55), U(80), U(55)};
double dSSBlockHeight[]={U(140), U(140), U(140), U(140), U(140), U(140), U(140)};


//Clonning TSL 
TslInst tsl;
String sScriptNameNailPlate = "hsb_NailPlate"; //name of the script of the Metal Part
Vector3d vecUcsX = _XW;
Vector3d vecUcsY = _YW;
Entity lstEnts[0];
Beam lstBeams[0];
Point3d lstPoints[0];
int lstPropInt[0];
double lstPropDouble[0];
String lstPropString[0];

int nErase=false;

for( int e=0; e<elWall.length(); e++ )
{
	ElementWallSF el=elWall[e];
	CoordSys csEl=el.coordSys();
	Vector3d vx=csEl.vecX();
	Vector3d vy=csEl.vecY();
	Vector3d vz=csEl.vecZ();
	Point3d ptOrgEl=csEl.ptOrg();
	_Pt0=ptOrgEl;
	
	Plane pln (ptOrgEl, vz);
	
	//Remove old Metal Part TSL
	TslInst tslIns[]=el.tslInstAttached();
	for (int i=0; i<tslIns.length(); i++)
	{
		if (tslIns[i].scriptName()==sScriptNameNailPlate)
			tslIns[i].dbErase();
	}
	
	PLine plEnvEl=el.plEnvelope();
	Point3d ptVertexEl[]=plEnvEl.vertexPoints(FALSE);
	
	//Some values and point needed after
	Point3d ptFront=el.zone(1).coordSys().ptOrg(); ptFront.vis(1);
	Point3d ptBack=el.zone(-1).coordSys().ptOrg(); ptBack.vis(1);
	
	double dWallThickness=abs(vz.dotProduct(ptFront-ptBack));
	
	Beam bmAll[]=el.beam();
	Beam bmAllVer[]=vx.filterBeamsPerpendicularSort(bmAll);
	
	String sHandleToAvoid[0];
	if(bmAllVer.length()>1 && bStuds)
	{
		sHandleToAvoid.append(bmAllVer[0].handle());
		sHandleToAvoid.append(bmAllVer[bmAllVer.length()-1].handle());
	}
	
	String sModuleNames[0];
	Point3d ptCenterModules[0];
	
	if (bCripple)
	{
		Beam bmCripples[0];
		for (int i=0; i<bmAllVer.length(); i++)
		{
			if (bmAllVer[i].type() == _kSFSupportingBeam)
				bmCripples.append(bmAllVer[i]);
		}
		Opening opAll[]=el.opening();
		for (int i=0; i<opAll.length(); i++)
		{
			PLine plOp=opAll[i].plShape();
			Point3d ptAll[]=plOp.vertexPoints(false);
			Point3d ptCenterOp;
			ptCenterOp.setToAverage(ptAll);
			
			PlaneProfile ppOp(csEl);
			ppOp.joinRing(plOp, false);
			ppOp.shrink(-U(150));
			Beam bmValidIntersection[0];
			for (int j=0; j<bmCripples.length(); j++)
			{
				PlaneProfile ppBm(csEl);
				ppBm=bmCripples[j].envelopeBody().extractContactFaceInPlane(pln, U(20));
				if (ppBm.intersectWith(ppOp))
				{
					bmValidIntersection.append(bmCripples[j]);
					String sModule=bmCripples[j].module();
					if (sModuleNames.find(sModule, -1) == -1)
					{
						sModuleNames.append(sModule);
						ptCenterModules.append(ptCenterOp);
					}
				}
			}
			bmValidIntersection=vx.filterBeamsPerpendicularSort(bmValidIntersection);
			for (int j=0; j<bmValidIntersection.length(); j++)
			{
				if (vx.dotProduct(bmValidIntersection[j].ptCen()-ptCenterOp)>0)
				{
					if (j>0)
					{
						sHandleToAvoid.append(bmValidIntersection[j-1].handle());
						sHandleToAvoid.append(bmValidIntersection[j].handle());
						break;
					}
				}
			}
		}
	}
	
	double dElBmHeight=el.dBeamHeight();
	if (dElBmHeight<el.dBeamWidth())
		dElBmHeight=el.dBeamWidth();

	int nLocation=-1;
	
	for (int i=0; i<dSSHeight.length(); i++)
	{
		if (abs(dSSHeight[i]-dElBmHeight)<U(1))
			nLocation=i;
	}
	
	if (nLocation==-1)
	{
		nErase=true;
		continue;
	}
		
	
	//Some Properties for the Clip Plates
	double dThSClip=dClipTh[nLocation];
	double dWiSClip=dClipWi[nLocation];
	double dLeSClip=dClipLe[nLocation];
	String sNameClip=sClipName[nLocation];
	
	//Some Properties for the NailPlates
	double dTh=dNPTh[nLocation];
	double dWi=dNPWi[nLocation];
	double dLe=dNPLe[nLocation];
	String sNameNP=sNPName[nLocation];
	
	String sDispRep="";

	Beam bmToSplit[0];
	//Size of the Space Stud
	double dValidWidth=dSSWidth[nLocation];
	double dValidHeight=dSSHeight[nLocation];
	double dNewWidthFront=dSSNewWidthFront[nLocation];
	double dNewHeightFront=dSSNewHeightFront[nLocation];

	double dNewWidthBack=dSSNewWidthBack[nLocation];
	double dNewHeightBack=dSSNewHeightBack[nLocation];	

	double dBlockLength=dSSBlockLength[nLocation];
	double dBlockHeight=dSSBlockHeight[nLocation];
	
	double dDistToMoveFront=dSSDistToMoveFront[nLocation];
	double dDistToMoveBack=dSSDistToMoveBack[nLocation];
	
	double dDiference=dDistToMoveBack-dDistToMoveFront;
	
	Beam bmAngle[0];
	
	Beam bmToAdjust[0];

	
	for (int i=0; i<bmAll.length(); i++)
	{
		Beam bm=bmAll[i];
		int nType=bm.type();
		String sCode=bm.beamCode().token(0);
		sCode.makeUpper();
		String sHandle=bm.handle();
		String sProfile=bm.extrProfile();
		sProfile.makeUpper();
		
		if (sProfile != "RECTANGULAR")
			continue;
		
		if (abs(bm.dW()-dValidWidth)<U(1) && abs(bm.dH()-dValidHeight)<U(1))
		{
			if ((nBmTypeToAvoid.find(nType, -1) == -1 && sHandleToAvoid.find(sHandle, -1) == -1) && sAllBmCodes.find(sCode, -1) == -1)
			{
				double dBmLen=bm.solidLength();
				if (dMinLength!=0 && dBmLen<dMinLength)
				{
					if (!bOnlyClip)
						continue;
				}
				
				bmToSplit.append(bm);
				if (nBmTypeNoPlate.find(nType, -1) == -1)
				{
					bmToAdjust.append(bm);
				}
			}
		}
	}
	
	//Put the right offset between the beams that are plate
	bmToAdjust=vx.filterBeamsPerpendicularSort(bmToAdjust);
	Beam bmOpenings[0];
	for (int b=0; b<bmToAdjust.length(); b++)
	{
		String sModule=bmToAdjust[b].module();
		if (sModuleNames.find(sModule, -1) != -1)
		{
			bmOpenings.append(bmToAdjust[b]);
		}
	}
	
	vx.filterBeamsPerpendicularSort(bmOpenings);
	
	for (int m=0; m<sModuleNames.length(); m++)
	{
		String sThisModule=sModuleNames[m];
		
		Point3d ptCenterMod=ptCenterModules[m];
		Beam bmThisModule[0];
		for (int b=0; b<bmOpenings.length(); b++)
		{
			if (bmOpenings[b].module()==sThisModule)
			{
				bmThisModule.append(bmOpenings[b]);
			}
		}
		if (bmThisModule.length()<1) continue;
		
		Beam bmLeft[0];
		Beam bmRight[0];
		for (int b=0; b<bmThisModule.length(); b++)
		{
			Beam bm=bmThisModule[b];
			if (vx.dotProduct(bm.ptCen()-ptCenterMod)<0)
				bmLeft.append(bm);
			else if (vx.dotProduct(bm.ptCen()-ptCenterMod)>0)
				bmRight.append(bm);
		}
		Vector3d vAux=-vx;
		bmLeft=vAux.filterBeamsPerpendicularSort(bmLeft);
		for (int b=0; b<bmLeft.length(); b++)
		{
			Beam bm=bmLeft[b];
			bm.transformBy(vAux*(U(1)*(b+1)));
		}
		bmRight=vx.filterBeamsPerpendicularSort(bmRight);
		for (int b=0; b<bmRight.length(); b++)
		{
			Beam bm=bmRight[b];
			bm.transformBy(vx*(U(1)*(b+1)));
		}
	}
	
	for (int b=0; b<bmToSplit.length(); b++)
	{
		Entity entThisStud[0];
		Beam bm=bmToSplit[b];
		bm.realBody().vis();
		//Plane plnFront (ptFront, vz);
		
		Vector3d vxBm=bm.vecX();
		if (vxBm.dotProduct(_ZW)<0)
			vxBm=-vxBm;
		
		Vector3d vyTemp=bm.vecY();
		Vector3d vzTemp=bm.vecZ();

		Vector3d vyBm;

		if (bm.dD(vyTemp)<bm.dD(vzTemp))
		{
			vyBm=vyTemp;
		}
		else
		{
			vyBm=vzTemp;
		}
		
		Vector3d vzBm=vxBm.crossProduct(vyBm);
		vxBm.vis(bm.ptCen(),1);
		vyBm.vis(bm.ptCen(),3);
		vzBm.vis(bm.ptCen(),150);

		Plane plnFront (bm.ptCen(), vzBm);

		int nFlat=false;
		if (bm.dD(vz)<bm.dD(vx))
			nFlat=true;
		
		int nAngle=false;
		int nType=bm.type();
		if (nType==_kSFAngledTPLeft || nType==_kSFAngledTPRight)
			nAngle=true;
		
		int nPlate=true;
		if (nBmTypeNoPlate.find(nType, -1) != -1)
			nPlate=false;
		
		//Beam Size
		double dBmW=bm.dW();
		
		//Map to Clone the Metal Part TSL
		Map mp;
		mp.setVector3d("vx", vzBm);
		mp.setVector3d("vy", vxBm);	
		mp.setVector3d("vz", vyBm);
		mp.setString("Group", "SpaceStud");
		
		Beam bmNewFront=bm.dbCopy();
		bmNewFront.setD(vzBm, dNewHeightBack);
		bmNewFront.transformBy(-vzBm*dDistToMoveBack);
		
		Beam bmNewBack=bm.dbCopy();
		bmNewBack.setD(vzBm, dNewHeightFront);
		bmNewBack.transformBy(vzBm*dDistToMoveFront);
		
		AnalysedTool allTools[]=bm.analysedTools();
		AnalysedTool allSingleCuts[] = AnalysedTool().filterToolsOfToolType(allTools, "AnalysedCut", _kACSimpleAngled);
		
		for (int i=0; i<allSingleCuts.length(); i++)
		{
			AnalysedCut at=(AnalysedCut) allSingleCuts[i];
			Cut ct (at.ptOrg(), at.normal());
			bmNewFront.addToolStatic(ct, _kStretchOnToolChange);
			bmNewBack.addToolStatic(ct, _kStretchOnToolChange);
		}
		
		PlaneProfile ppBm=bm.realBody().shadowProfile(plnFront);
		LineSeg ls=ppBm.extentInDir(vxBm);
		Line lnBm (bm.ptCen()-vzBm*dDiference, vxBm);
		Point3d ptBaseBm=ls.ptStart();
		Point3d ptStartDist=ls.ptStart();
		Point3d ptEndDist=ls.ptEnd();
		ptStartDist=lnBm.closestPointTo(ptStartDist);
		ptEndDist=lnBm.closestPointTo(ptEndDist);
		ptBaseBm=lnBm.closestPointTo(ptBaseBm);
		LineSeg lsNew(ptStartDist, ptEndDist);
		
		//Create the Metal Plates
		if (nPlate)
		{
			Point3d ptToCreatePlate[0];
		
			double dBmLength=abs(vxBm.dotProduct(ptStartDist-ptEndDist));
			
			double dNewOffsetTop=dOffsetTop;
			double dNewOffsetBottom=dOffsetBottom;
			if (bOnlyClip && dBmLength<dMinLength)
			{
				dNewOffsetTop=U(35);
				dNewOffsetBottom=U(35);
			}
		
			if (dBmLength>U(100)  && dBmLength<=U(600))
			{
				ptToCreatePlate.append(lsNew.ptStart()+vxBm*dNewOffsetBottom);
				ptToCreatePlate.append(lsNew.ptEnd()-vxBm*dNewOffsetTop);
			}
			else if (dBmLength>U(600) && dBmLength<=U(1200))
			{
				ptToCreatePlate.append(lsNew.ptStart()+vxBm*dNewOffsetBottom);
				ptToCreatePlate.append(lsNew.ptEnd()-vxBm*dNewOffsetTop);
				ptToCreatePlate.append(lsNew.ptMid());
			}
			else if (dBmLength>U(1200))
			{
				double dQtyPlates=dBmLength/dOffsetCenters;
				int nQtyPlates=dQtyPlates;
				
				if ((dQtyPlates-nQtyPlates)>0)
					nQtyPlates+=1;
				
				double dNewCenters=(dBmLength/nQtyPlates);
				
				Point3d ptBottom=lsNew.ptStart()+vxBm*dNewOffsetBottom;
				Point3d ptTop=lsNew.ptEnd()-vxBm*dNewOffsetTop;
				
				ptToCreatePlate.append(ptBottom);
				ptToCreatePlate.append(ptTop);
				
				ptBaseBm=ptBaseBm+vxBm*dNewCenters;
				
				while(ppBm.pointInProfile(ptBaseBm)==_kPointInProfile )
				{
					if ((ptBaseBm-ptBottom).length()>U(100) && (ptBaseBm-ptTop).length()>U(100))
					{
						if (bSingleClip)
						{
							LineSeg lsAux(ptBottom, ptTop);
							ptToCreatePlate.append(lsAux.ptMid());
							break;
						}
						ptToCreatePlate.append(ptBaseBm);
						
					}
		
					//Move the Point the offset needed
					ptBaseBm=ptBaseBm+vxBm*dNewCenters;
				}
			}
			
			lstBeams.setLength(0);
			lstBeams.append(bmNewFront);
			lstBeams.append(bmNewBack);
	
			for (int x=0; x<ptToCreatePlate.length(); x++)
			{
				lstPoints.setLength(0);
				ptToCreatePlate[x]=lnBm.closestPointTo(ptToCreatePlate[x]);
				
				int nType=0;
				if (bOnlyClip && dBmLength<dMinLength)
				{
					nType=1;
				}
				else if (x<2)
				{
					nType=0;
				}
				else
				{
					nType=1;
				}
				
				if (nType==0)
				{	
					//Create Beam
					Body bd(ptToCreatePlate[x], vzBm, vyBm, vxBm, dBlockLength, dBmW, dBlockHeight);
					int nMove=false;
					for (int i=0; i<allSingleCuts.length(); i++)
					{
						AnalysedCut at=(AnalysedCut) allSingleCuts[i];
						
						Cut ct (at.ptOrg(), at.normal());
						
						if ((ptToCreatePlate[x]-at.ptOrg()).length()<U(200))
						{
							bd.addTool(ct);
							nMove=true;
						}
					}
					
					if (nMove)
					{
						Point3d ptAllVertex[0];
						if (x==0)//Always the bottom block
						{
							ptAllVertex=bd.extremeVertices(vxBm);
							ptAllVertex[0]=ptAllVertex[0]+vxBm*dNewOffsetBottom;
						}
						if (x==1)//Allways the top block
						{
							ptAllVertex=bd.extremeVertices(-vxBm);
							ptAllVertex[0]=ptAllVertex[0]-vxBm*dNewOffsetTop;
						}
						ptToCreatePlate[x]=ptAllVertex[0];
						ptToCreatePlate[x]=lnBm.closestPointTo(ptToCreatePlate[x]);
					}
					
					Beam bmBlock;
					bmBlock.dbCreate(ptToCreatePlate[x], vzBm, vyBm, vxBm, dBlockLength, dBmW, dBlockHeight);
					bmBlock.setName("BLOCKING");
					bmBlock.setMaterial(bm.material());
					bmBlock.setGrade(bm.grade());
					bmBlock.setColor(bm.color());
					bmBlock.setType(_kBlocking);
					bmBlock.assignToElementGroup(el, TRUE, 0, 'Z');
					entThisStud.append(bmBlock);
					
					for (int i=0; i<allSingleCuts.length(); i++)
					{
						AnalysedCut at=(AnalysedCut) allSingleCuts[i];
						Cut ct (at.ptOrg(), at.normal());
						
						if ((ptToCreatePlate[x]-at.ptOrg()).length()<U(200))
						{
							bmBlock.addToolStatic(ct);
						}
						ptToCreatePlate[x].vis(2);
						Body bdBlock=bmBlock.realBody();
						PlaneProfile ppBlockBeamLeft=bdBlock.extractContactFaceInPlane(Plane(ptToCreatePlate[x]-vyBm*(dBmW*0.5), vyBm), 2);
						PlaneProfile ppBlockBeamRight=bdBlock.extractContactFaceInPlane(Plane(ptToCreatePlate[x]+vyBm*(dBmW*0.5), vyBm), 2);
						PlaneProfile ppBlockBeamFront=bdBlock.extractContactFaceInPlane(Plane(ptToCreatePlate[x]-vzBm*(dBlockLength*0.5), vzBm), 2);
						PlaneProfile ppBlockBeamBack=bdBlock.extractContactFaceInPlane(Plane(ptToCreatePlate[x]+vzBm*(dBlockLength*0.5), vzBm), 2);
						LineSeg lsLeft=ppBlockBeamLeft.extentInDir(vxBm);
						LineSeg lsRight=ppBlockBeamRight.extentInDir(vxBm);
						LineSeg lsFront=ppBlockBeamFront.extentInDir(vxBm);
						LineSeg lsBack=ppBlockBeamBack.extentInDir(vxBm);
						
						Point3d ptNewCreatePlate;
						
						double dLSeg=(lsLeft.ptStart()-lsLeft.ptEnd()).length();
						ptNewCreatePlate=lsLeft.ptMid();

						if (dLSeg>(lsRight.ptStart()-lsRight.ptEnd()).length())
						{
							dLSeg=(lsRight.ptStart()-lsRight.ptEnd()).length();
							ptNewCreatePlate=lsRight.ptMid();
						}
						if (dLSeg>(lsFront.ptStart()-lsFront.ptEnd()).length())
						{
							dLSeg=(lsFront.ptStart()-lsFront.ptEnd()).length();
							ptNewCreatePlate=lsFront.ptMid();
						}
						if (dLSeg>(lsBack.ptStart()-lsBack.ptEnd()).length())
						{
							dLSeg=(lsBack.ptStart()-lsBack.ptEnd()).length();
							ptNewCreatePlate=lsBack.ptMid();
						}

						ptNewCreatePlate.vis();
						ptNewCreatePlate=lnBm.closestPointTo(ptNewCreatePlate);
						ptToCreatePlate[x]=ptNewCreatePlate;
					}
					
					//Create Nail Plate
					lstPropDouble.setLength(0);
					lstPropString.setLength(0);
					lstPropDouble.append(dTh);
					lstPropDouble.append(dWi);
					lstPropDouble.append(dLe);
					lstPropString.append("");
					lstPropString.append("Other Model Type");
					lstPropString.append(sNameNP);
					
					mp.setVector3d("vz", vyBm);
					lstPoints.setLength(0);
					Point3d pt=ptToCreatePlate[x];
					pt=pt+vzBm*(dBlockLength*0.5)+vyBm*(dBmW*0.5);
					lstPoints.append(pt);
	
					tsl.dbCreate(sScriptNameNailPlate, vecUcsX, vecUcsY, lstBeams, lstEnts, lstPoints, lstPropInt, lstPropDouble, lstPropString, TRUE, mp);
					entThisStud.append(tsl);
					
					//Create Nail Plate
					lstPoints.setLength(0);
					pt=ptToCreatePlate[x];
					pt=pt-vzBm*(dBlockLength*0.5)+vyBm*(dBmW*0.5);
					lstPoints.append(pt);
					
					tsl.dbCreate(sScriptNameNailPlate, vecUcsX, vecUcsY, lstBeams, lstEnts, lstPoints, lstPropInt, lstPropDouble, lstPropString, TRUE, mp);
					entThisStud.append(tsl);
					
					mp.setVector3d("vz", -vyBm);
					//Create Nail Plate
					lstPoints.setLength(0);
					pt=ptToCreatePlate[x];
					pt=pt+vzBm*(dBlockLength*0.5)-vyBm*(dBmW*0.5);
					lstPoints.append(pt);
	
					tsl.dbCreate(sScriptNameNailPlate, vecUcsX, vecUcsY, lstBeams, lstEnts, lstPoints, lstPropInt, lstPropDouble, lstPropString, TRUE, mp);
					entThisStud.append(tsl);
					
					//Create Nail Plate
					lstPoints.setLength(0);
					pt=ptToCreatePlate[x];
					pt=pt-vzBm*(dBlockLength*0.5)-vyBm*(dBmW*0.5);
					lstPoints.append(pt);
					tsl.dbCreate(sScriptNameNailPlate, vecUcsX, vecUcsY, lstBeams, lstEnts, lstPoints, lstPropInt, lstPropDouble, lstPropString, TRUE, mp);
					entThisStud.append(tsl);
				}
				else
				{
					//Create Clip
					lstPropDouble.setLength(0);
					lstPropString.setLength(0);
					lstPropDouble.append(dThSClip);
					lstPropDouble.append(dWiSClip);
					lstPropDouble.append(dLeSClip);
					lstPropString.append("");
					lstPropString.append("Other Model Type");
					lstPropString.append(sNameClip);
					
					Point3d pt=ptToCreatePlate[x];
					
					mp.setVector3d("vz", vyBm);
					//Create Nail Plate
					lstPoints.setLength(0);
					pt=ptToCreatePlate[x];
					pt=pt+vyBm*(dBmW*0.5);
					lstPoints.append(pt);
					tsl.dbCreate(sScriptNameNailPlate, vecUcsX, vecUcsY, lstBeams, lstEnts, lstPoints, lstPropInt, lstPropDouble, lstPropString, TRUE, mp);
					entThisStud.append(tsl);
					
					mp.setVector3d("vz", -vyBm);
					
					//Create Nail Plate
					lstPoints.setLength(0);
					pt=ptToCreatePlate[x];
					pt=pt-vyBm*(dBmW*0.5);
					lstPoints.append(pt);
					tsl.dbCreate(sScriptNameNailPlate, vecUcsX, vecUcsY, lstBeams, lstEnts, lstPoints, lstPropInt, lstPropDouble, lstPropString, TRUE, mp);
					entThisStud.append(tsl);
					
				}
			}
			
			TslInst NewTSL;
			String strScriptName = "hsb_SpaceStudAssembly"; // name of the script
			Vector3d vecUcsX=bm.vecX();
			Vector3d vecUcsY=bm.vecZ();
			Beam lstBeams[0];
			lstBeams.append(bmNewFront);
			lstBeams.append(bmNewBack);
			Element lstElements[0];
			
			Point3d lstPoints[0];
			lstPoints.append(bm.ptCen());
			int lstPropInt[0];
			double lstPropDouble[0];
			String lstPropString[0];
			
			//Add those plates to the sub assembly tsl
			Map mapSubAssembly;;
			for (int i=0; i<entThisStud.length(); i++)
			{
				mapSubAssembly.appendEntity("Entity", entThisStud[i]);
			}
			
			mapSubAssembly.setDouble("Width", bm.dW());
			mapSubAssembly.setDouble("Height", bm.dH());
			mapSubAssembly.setDouble("Length", bm.solidLength());
			mapSubAssembly.setString("Type", "Stud");
			
			NewTSL.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstElements, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModel, mapSubAssembly );
		}
		else
		{
			//The beam is split but wasnt plate
			TslInst NewTSL;
			String strScriptName = "hsb_SpaceStudAssembly"; // name of the script
			Vector3d vecUcsX=bm.vecX();
			Vector3d vecUcsY=bm.vecZ();
			Beam lstBeams[0];
			lstBeams.append(bmNewFront);
			lstBeams.append(bmNewBack);
			Element lstElements[0];
			
			Point3d lstPoints[0];
			lstPoints.append(bm.ptCen());
			int lstPropInt[0];
			double lstPropDouble[0];
			String lstPropString[0];
			
			//Add those plates to the sub assembly tsl
			Map mapSubAssembly;;
			for (int i=0; i<entThisStud.length(); i++)
			{
				mapSubAssembly.appendEntity("Entity", entThisStud[i]);
			}
			
			mapSubAssembly.setDouble("Width", bm.dW());
			mapSubAssembly.setDouble("Height", bm.dH());
			mapSubAssembly.setDouble("Length", bm.solidLength());
			mapSubAssembly.setString("Type", "Group");
			NewTSL.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstElements, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModel, mapSubAssembly );

			
		}
		bm.dbErase();
		nErase=true;
	}
}

//-----------------------------------------------------------------------------------------------------------------------------------
//                                                                 Erase instance

if (_bOnElementConstructed || nErase)
{
	eraseInstance();
	return;
}

















#End
#BeginThumbnail




















#End
