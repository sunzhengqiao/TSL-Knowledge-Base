#Version 8
#BeginDescription
Creates glue lines in 10 zones for walls and floors, and attaches information for export.

#Versions:
Version 1.5 18.07.2025 HSB-23589: Add support for trusses , Author: Marsel Nakuci
Modified by: Alberto Jena (aj@hsb-cad.com)
Date: 03.02.2018 - version 1.4



#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 5
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
*#Versions:
// 1.5 18.07.2025 HSB-23589: Add support for trusses , Author: Marsel Nakuci
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 02.04.2009
* version 1.8: Release Version for UK Content
*
*
*/

//Units
	Unit(1,"mm");

	_ThisInst.setSequenceNumber(50);

//Props and basics
	String sArNY[] = {T("No"), T("Yes")};
	int arNNY[]={FALSE, TRUE};

	
	int nValidZones[]={1,2,3,4,5,6,7,8,9,10};
	int nRealZones[]={1,2,3,4,5,-1,-2,-3,-4,-5};
	
	PropString sDimLayout(20,_DimStyles,T("Dim Style"));sDimLayout.setCategory(T("Standard Properties"));
	PropString sDispRep(21, "", T("Show in Disp Rep"));sDispRep.setCategory(T("Standard Properties"));
	PropDouble dMinimumGlueLineLength(10, 0, T("Minimum length of glue line.")); dMinimumGlueLineLength.setCategory(T("Standard Properties"));
	
	PropString sJoinSheet(22, sArNY, T("Merge sheeting to glue?")); sJoinSheet.setCategory(T("Standard Properties"));
	sJoinSheet.setDescription(T("If this is value is set to yes then first of the sheets are join in a big shape and then the interference with the beams is calculated."));
	
	//Zone1
	PropString nNailYN1(0, sArNY, "   "+T("Do you want to glue Zone 1?")); nNailYN1.setCategory(T("Zone 1"));
	
	int nZonesR1[]={0};
	int nZonesR1Real[]={0};
	PropInt nRefZ1 (18, nZonesR1, T("Gluing Reference Zone")+"     ", 0); nRefZ1.setCategory(T("Zone 1"));
	
	PropInt nToolingIndex1(0, 1, "   "+T("Glue Tool index")); nToolingIndex1.setCategory(T("Zone 1"));
	
	PropDouble dDistEdge1 (0, U(20),"   "+T("Edge Offset"));dDistEdge1.setCategory(T("Zone 1"));
	dDistEdge1.setDescription("This value is the distance between the end of the glue line to the end of the beam");

	PropString strMaterialZone1 (1,"","   "+T("Zone Material to be Glued"));strMaterialZone1.setCategory(T("Zone 1"));
	strMaterialZone1.setDescription(T("If any Material name is set here then only that material is going to be use to apply the gluing"));

	//Zone2
	PropString nNailYN2(2, sArNY, "   "+T("Do you want to glue Zone 2?"));nNailYN2.setCategory(T("Zone 2"));
	
	int nZonesR2[]={0,1};
	int nZonesR2Real[]={0,1};
	PropInt nRefZ2 (10, nZonesR2, T("Gluing Reference Zone"), 0);nRefZ2.setCategory(T("Zone 2"));
	
	PropInt nToolingIndex2(1, 1, "   "+T("Gluing Tool index")+" ");nToolingIndex2.setCategory(T("Zone 2"));
	
	PropDouble dDistEdge2 (1, U(20),"   "+T("Edge Offset")+" ");dDistEdge2.setCategory(T("Zone 2"));
	dDistEdge2.setDescription("This value is the distance between the end of the glue line to the end of the beam");

	PropString strMaterialZone2 (3,"","   "+T("Zone Material to be Glued")+" ");strMaterialZone2.setCategory(T("Zone 2"));
	strMaterialZone2.setDescription(T("If any Material name is set here then only that material is going to be use to apply the gluing"));

	//Zone3
	PropString nNailYN3(4, sArNY, "   "+T("Do you want to glue Zone 3?"));nNailYN3.setCategory(T("Zone 3"));
	
	int nZonesR3[]={0,1,2};
	int nZonesR3Real[]={0,1,2};
	PropInt nRefZ3 (11, nZonesR3, T("Gluing Reference Zone")+" ", 0);nRefZ3.setCategory(T("Zone 3"));
	
	PropInt nToolingIndex3(2, 1, "   "+T("Gluing Tool index")+"  ");nToolingIndex3.setCategory(T("Zone 3"));
	PropDouble dDistEdge3 (2, U(20),"   "+T("Edge Offset")+"  ");dDistEdge3.setCategory(T("Zone 3"));
	dDistEdge3.setDescription("This value is the distance between the end of the nail line to the end of the beam");

	PropString strMaterialZone3 (5,"","   "+T("Zone Material to be Nailed")+"  ");strMaterialZone3.setCategory(T("Zone 3"));
	strMaterialZone3.setDescription(T("If any Material name is set here then only that material is going to be use to apply the nailing"));

	//Zone4
	PropString nNailYN4(6, sArNY, "     "+T("Do you want to nail Zone 4?"));nNailYN4.setCategory(T("Zone 4"));

	int nZonesR4[]={0,1,2,3};
	int nZonesR4Real[]={0,1,2,3};
	PropInt nRefZ4 (12, nZonesR4, T("Gluing Reference Zone")+"  ", 0);nRefZ4.setCategory(T("Zone 4"));
	
	PropInt nToolingIndex4(3, 1, "   "+T("Gluing Tool index")+"   ");nToolingIndex4.setCategory(T("Zone 4"));
	PropDouble dDistEdge4 (3, U(20),"   "+T("Edge Offset")+"   ");dDistEdge4.setCategory(T("Zone 4"));
	dDistEdge4.setDescription("This value is the distance between the end of the nail line to the end of the beam");

	PropString strMaterialZone4 (7,"","   "+T("Zone Material to be Nailed")+"   ");strMaterialZone4.setCategory(T("Zone 4"));
	strMaterialZone4.setDescription(T("If any Material name is set here then only that material is going to be use to apply the gluing"));

	//Zone5

	PropString nNailYN5(8, sArNY, "   "+T("Do you want to nail Zone 5?"));nNailYN5.setCategory(T("Zone 5"));
	
	int nZonesR5[]={0,1,2,3,4};
	int nZonesR5Real[]={0,1,2,3,4};
	PropInt nRefZ5 (13, nZonesR5, T("Gluing Reference Zone")+"   ", 0);nRefZ5.setCategory(T("Zone 5"));
	
	PropInt nToolingIndex5(4, 1, "   "+T("Gluing Tool index")+"    ");nToolingIndex5.setCategory(T("Zone 5"));
	
	PropDouble dDistEdge5 (4, U(20),"   "+T("Edge Offset")+"    ");dDistEdge5.setCategory(T("Zone 5"));
	dDistEdge5.setDescription("This value is the distance between the end of the nail line to the end of the beam");

	PropString strMaterialZone5 (9,"","   "+T("Zone Material to be Nailed")+"    ");strMaterialZone5.setCategory(T("Zone 5"));
	strMaterialZone5.setDescription(T("If any Material name is set here then only that material is going to be use to apply the gluing"));
	
	//Zone6
	PropString nNailYN6(10, sArNY, "   "+T("Do you want to nail Zone 6?"));nNailYN6.setCategory(T("Zone 6"));

	int nZonesR6[]={0};
	int nZonesR6Real[]={0};
	PropInt nRefZ6 (19, nZonesR6, T("Gluing Reference Zone")+"      ", 0);nRefZ6.setCategory(T("Zone 6"));

	PropInt nToolingIndex6(5, 1, "   "+T("Gluing Tool index")+"     ");nToolingIndex6.setCategory(T("Zone 6"));
	
	PropDouble dDistEdge6 (5, U(20),"   "+T("Edge Offset")+"     ");dDistEdge6.setCategory(T("Zone 6"));
	dDistEdge6.setDescription("This value is the distance between the end of the nail line to the end of the beam");

	PropString strMaterialZone6 (11,"","   "+T("Zone Material to be Nailed")+"     ");strMaterialZone6.setCategory(T("Zone 6"));
	strMaterialZone6.setDescription(T("If any Material name is set here then only that material is going to be use to apply the gluing"));

	//Zone7
	PropString nNailYN7(12, sArNY, "   "+T("Do you want to nail Zone 7?"));nNailYN7.setCategory(T("Zone 7"));

	int nZonesR7[]={0,6};
	int nZonesR7Real[]={0,-1};
	PropInt nRefZ7 (14, nZonesR7, T("Gluing Reference Zone")+"    ", 0);nRefZ7.setCategory(T("Zone 7"));
	
	PropInt nToolingIndex7(6, 1, "   "+T("Gluing Tool index")+"      ");nToolingIndex7.setCategory(T("Zone 7"));
	
	PropDouble dDistEdge7 (6, U(20),"   "+T("Edge Offset")+"      ");dDistEdge7.setCategory(T("Zone 7"));
	dDistEdge7.setDescription("This value is the distance between the end of the nail line to the end of the beam");

	PropString strMaterialZone7 (13,"","   "+T("Zone Material to be Nailed")+"      ");strMaterialZone7.setCategory(T("Zone 7"));
	strMaterialZone7.setDescription(T("If any Material name is set here then only that material is going to be use to apply the gluing"));

	//Zone8
	PropString nNailYN8(14, sArNY, "   "+T("Do you want to nail Zone 8?")+"       ");nNailYN8.setCategory(T("Zone 8"));

	int nZonesR8[]={0,6,7};
	int nZonesR8Real[]={0,-1,-2};
	PropInt nRefZ8 (15, nZonesR8, T("Gluing Reference Zone")+"     ", 0);nRefZ8.setCategory(T("Zone 8"));
	
	PropInt nToolingIndex8(7, 1, "   "+T("Gluing Tool index")+"       ");nToolingIndex8.setCategory(T("Zone 8"));
	
	PropDouble dDistEdge8 (7, U(20),"   "+T("Edge Offset")+"       ");dDistEdge8.setCategory(T("Zone 8"));
	dDistEdge8.setDescription("This value is the distance between the end of the nail line to the end of the beam");

	PropString strMaterialZone8 (15,"","   "+T("Zone Material to be Nailed")+"       ");strMaterialZone8.setCategory(T("Zone 8"));
	strMaterialZone8.setDescription(T("If any Material name is set here then only that material is going to be use to apply the gluing"));

	//Zone9
	PropString nNailYN9(16, sArNY, "   "+T("Do you want to nail Zone 9?"));nNailYN9.setCategory(T("Zone 9"));

	int nZonesR9[]={0,6,7,8};
	int nZonesR9Real[]={0,-1,-2,-3};
	PropInt nRefZ9 (16, nZonesR9, T("Gluing Reference Zone")+"     ", 0);nRefZ9.setCategory(T("Zone 9"));
		
	PropInt nToolingIndex9(8, 1, "   "+T("Gluing Tool index")+"        ");nToolingIndex9.setCategory(T("Zone 9"));
	
	PropDouble dDistEdge9 (8, U(20),"   "+T("Edge Offset")+"        ");dDistEdge9.setCategory(T("Zone 9"));
	dDistEdge9.setDescription("This value is the distance between the end of the nail line to the end of the beam");

	PropString strMaterialZone9 (17,"","   "+T("Zone Material to be Nailed")+"        ");strMaterialZone9.setCategory(T("Zone 9"));
	strMaterialZone9.setDescription(T("If any Material name is set here then only that material is going to be use to apply the gluing"));

	//Zone10
	PropString nNailYN10(18, sArNY, "   "+T("Do you want to nail Zone 10?"));nNailYN10.setCategory(T("Zone 10"));

	int nZonesR10[]={0,6,7,8,9};
	int nZonesR10Real[]={0,-1,-2,-3,-4};
	PropInt nRefZ10 (17, nZonesR10, T("Gluing Reference Zone")+"      ", 0);nRefZ10.setCategory(T("Zone 10"));
	
	PropInt nToolingIndex10(9, 1, "   "+T("Gluing Tool index")+"         ");nToolingIndex10.setCategory(T("Zone 10"));
	
	PropDouble dDistEdge10 (9, U(20),"   "+T("Edge Offset")+"         ");dDistEdge10.setCategory(T("Zone 10"));
	dDistEdge10.setDescription("This value is the distance between the end of the nail line to the end of the beam");

	PropString strMaterialZone10 (19,"","   "+T("Zone Material to be Nailed")+"         ");strMaterialZone10.setCategory(T("Zone 10"));
	strMaterialZone10.setDescription(T("If any Material name is set here then only that material is going to be use to apply the gluing"));

	double dMinValidArea=U(12);
	double dDistCloseToEdge=U(25);

if (_bOnDbCreated || _bOnInsert) setPropValuesFromCatalog(_kExecuteKey);

if( _bOnInsert )
{
	
	if (insertCycleCount()>1) { eraseInstance(); return; }
	if (_kExecuteKey=="")
		showDialog();

	PrEntity ssE(T("Select one or More Elements"), Element());
	if( ssE.go() ){
		_Element.append(ssE.elementSet());
	}
	
	//Insert the TSL again for each Element
	TslInst tsl;
	String sScriptName = scriptName(); // name of the script
	Vector3d vecUcsX = _XW;
	Vector3d vecUcsY = _YW;
	Entity lstEnts[0];
	Beam lstBeams[0];
	Point3d lstPoints[0];
	int lstPropInt[0];
	lstPropInt.append(nToolingIndex1);
	lstPropInt.append(nToolingIndex2);
	lstPropInt.append(nToolingIndex3);
	lstPropInt.append(nToolingIndex4);
	lstPropInt.append(nToolingIndex5);
	lstPropInt.append(nToolingIndex6);
	lstPropInt.append(nToolingIndex7);
	lstPropInt.append(nToolingIndex8);
	lstPropInt.append(nToolingIndex9);
	lstPropInt.append(nToolingIndex10);
	lstPropInt.append(nRefZ2);
	lstPropInt.append(nRefZ3);
	lstPropInt.append(nRefZ4);
	lstPropInt.append(nRefZ5);
	lstPropInt.append(nRefZ7);
	lstPropInt.append(nRefZ8);
	lstPropInt.append(nRefZ9);
	lstPropInt.append(nRefZ10);
	lstPropInt.append(nRefZ1);
	lstPropInt.append(nRefZ6);
	
	double lstPropDouble[0];
	lstPropDouble.append(dDistEdge1);
	lstPropDouble.append(dDistEdge2);
	lstPropDouble.append(dDistEdge3);
	lstPropDouble.append(dDistEdge4);
	lstPropDouble.append(dDistEdge5);
	lstPropDouble.append(dDistEdge6);
	lstPropDouble.append(dDistEdge7);
	lstPropDouble.append(dDistEdge8);
	lstPropDouble.append(dDistEdge9);
	lstPropDouble.append(dDistEdge10);
	lstPropDouble.append(dMinimumGlueLineLength);
	
	String lstPropString[0];
	lstPropString.append(nNailYN1);
	lstPropString.append(strMaterialZone1);
	lstPropString.append(nNailYN2);
	lstPropString.append(strMaterialZone2);
	lstPropString.append(nNailYN3);
	lstPropString.append(strMaterialZone3);
	lstPropString.append(nNailYN4);
	lstPropString.append(strMaterialZone4);
	lstPropString.append(nNailYN5);
	lstPropString.append(strMaterialZone5);
	lstPropString.append(nNailYN6);
	lstPropString.append(strMaterialZone6);
	lstPropString.append(nNailYN7);
	lstPropString.append(strMaterialZone7);
	lstPropString.append(nNailYN8);
	lstPropString.append(strMaterialZone8);
	lstPropString.append(nNailYN9);
	lstPropString.append(strMaterialZone9);
	lstPropString.append(nNailYN10);
	lstPropString.append(strMaterialZone10);
	lstPropString.append(sDimLayout);
	lstPropString.append(sDispRep);
	lstPropString.append(sJoinSheet);

	Map mpToClone;
	mpToClone.setInt("ExecutionMode",0);

	for (int i=0; i<_Element.length(); i++)
	{
		lstEnts.setLength(0);
		lstEnts.append(_Element[i]);
		tsl.dbCreate(sScriptName, vecUcsX, vecUcsY, lstBeams, lstEnts, lstPoints, lstPropInt, lstPropDouble, lstPropString, TRUE, mpToClone);
	}

	//_Element.append(getElement(T("Select an element")));
	_Map.setInt("ExecutionMode",0);
	eraseInstance();
	return;
}

if (_bOnDbCreated) setPropValuesFromCatalog(_kExecuteKey);

int nZoneIndex[0];
int nRefZone[0];
int bNailYN[0];
int nToolingIndex[0];
//double dSpacingEdge[0];
//double dSpacingCenter[0];
double dDistEdge[0];
String strMaterialZone[0];
//String strNailType[0];
//int bTiltTool[0];
double dMinDist[0];
double dOffsetNailing[0];
//int nToolingIndexLeft[0];
//int nToolingIndexRight[0];
int nJoin = arNNY[sArNY.find(sJoinSheet,0)];

//Zone1
if (arNNY[sArNY.find(nNailYN1,0)]==TRUE)
{
	//reportNotice("zone1");
	nZoneIndex.append(nRealZones[nValidZones.find(1, 0)]);
	nRefZone.append(0);
	bNailYN.append(arNNY[sArNY.find(nNailYN1,0)]);
	nToolingIndex.append(nToolingIndex1);
	dDistEdge.append(dDistEdge1);
	strMaterialZone.append(strMaterialZone1);
}
//Zone2
if (arNNY[sArNY.find(nNailYN2,0)]==TRUE)
{
	//reportNotice("zone2");
	nZoneIndex.append(nRealZones[nValidZones.find(2, 0)]);
	nRefZone.append(nZonesR2Real[nZonesR2.find(nRefZ2, 0)]);
	bNailYN.append(arNNY[sArNY.find(nNailYN2,0)]);
	nToolingIndex.append(nToolingIndex2);
	dDistEdge.append(dDistEdge2);
	strMaterialZone.append(strMaterialZone2);
}
//Zone3
if (arNNY[sArNY.find(nNailYN3,0)]==TRUE)
{
	//reportNotice("zone3");
	nZoneIndex.append(nRealZones[nValidZones.find(3, 0)]);	
	nRefZone.append(nZonesR3Real[nZonesR3.find(nRefZ3, 0)]);
	bNailYN.append(arNNY[sArNY.find(nNailYN3,0)]);
	nToolingIndex.append(nToolingIndex3);
	dDistEdge.append(dDistEdge3);
	strMaterialZone.append(strMaterialZone3);
}
//Zone4
if (arNNY[sArNY.find(nNailYN4,0)]==TRUE)
{
	//reportNotice("zone4");
	nZoneIndex.append(nRealZones[nValidZones.find(4, 0)]);	
	nRefZone.append(nZonesR4Real[nZonesR4.find(nRefZ4, 0)]);
	bNailYN.append(arNNY[sArNY.find(nNailYN4,0)]);
	nToolingIndex.append(nToolingIndex4);
	dDistEdge.append(dDistEdge4);
	strMaterialZone.append(strMaterialZone4);
}
//Zone5
if (arNNY[sArNY.find(nNailYN5,0)]==TRUE)
{
	nZoneIndex.append(nRealZones[nValidZones.find(5, 0)]);
	nRefZone.append(nZonesR5Real[nZonesR5.find(nRefZ5, 0)]);
	bNailYN.append(arNNY[sArNY.find(nNailYN5,0)]);
	nToolingIndex.append(nToolingIndex5);
	dDistEdge.append(dDistEdge5);
	strMaterialZone.append(strMaterialZone5);
}
//Zone6
if (arNNY[sArNY.find(nNailYN6,0)]==TRUE)
{
	nZoneIndex.append(nRealZones[nValidZones.find(6, 0)]);
	nRefZone.append(0);
	bNailYN.append(arNNY[sArNY.find(nNailYN6,0)]);
	nToolingIndex.append(nToolingIndex6);
	dDistEdge.append(dDistEdge6);
	strMaterialZone.append(strMaterialZone6);
}
//Zone7
if (arNNY[sArNY.find(nNailYN7,0)]==TRUE)
{
	nZoneIndex.append(nRealZones[nValidZones.find(7, 0)]);
	nRefZone.append(nZonesR7Real[nZonesR7.find(nRefZ7, 0)]);
	bNailYN.append(arNNY[sArNY.find(nNailYN7,0)]);
	nToolingIndex.append(nToolingIndex7);
	dDistEdge.append(dDistEdge7);
	strMaterialZone.append(strMaterialZone7);
}
//Zone8
if (arNNY[sArNY.find(nNailYN8,0)]==TRUE)
{
	nZoneIndex.append(nRealZones[nValidZones.find(8, 0)]);
	nRefZone.append(nZonesR8Real[nZonesR8.find(nRefZ8, 0)]);
	bNailYN.append(arNNY[sArNY.find(nNailYN8,0)]);
	nToolingIndex.append(nToolingIndex8);
	dDistEdge.append(dDistEdge8);
	strMaterialZone.append(strMaterialZone8);
}
//Zone9
if (arNNY[sArNY.find(nNailYN9,0)]==TRUE)
{
	nZoneIndex.append(nRealZones[nValidZones.find(9, 0)]);
	nRefZone.append(nZonesR9Real[nZonesR9.find(nRefZ9, 0)]);
	bNailYN.append(arNNY[sArNY.find(nNailYN9,0)]);
	nToolingIndex.append(nToolingIndex9);
	dDistEdge.append(dDistEdge9);
	strMaterialZone.append(strMaterialZone9);
}
//Zone10
if (arNNY[sArNY.find(nNailYN10,0)]==TRUE)
{
	nZoneIndex.append(nRealZones[nValidZones.find(10, 0)]);
	nRefZone.append(nZonesR10Real[nZonesR10.find(nRefZ10, 0)]);
	bNailYN.append(arNNY[sArNY.find(nNailYN10,0)]);
	nToolingIndex.append(nToolingIndex10);
	dDistEdge.append(dDistEdge10);
	strMaterialZone.append(strMaterialZone10);
}

int nBmType[0];

nBmType.append(_kSFAngledTPLeft);
nBmType.append(_kSFAngledTPRight);
nBmType.append(_kSFStudLeft);
nBmType.append(_kSFStudRight);
nBmType.append(_kSFTopPlate);	
nBmType.append(_kSFBottomPlate);

if( _Element.length() == 0 ){eraseInstance(); return;}

_Pt0=_Element[0].ptOrg();

String strChangeEntity = T("Reapply Glue Lines");
addRecalcTrigger(_kContext, strChangeEntity );
if (_bOnRecalc && _kExecuteKey==strChangeEntity) {
	_Map.setInt("ExecutionMode",0);
}

if (_bOnElementConstructed)
{
	_Map.setInt("ExecutionMode",0);
}

int nExecutionMode = 1;
if (_Map.hasInt("ExecutionMode"))
{
	nExecutionMode = _Map.getInt("ExecutionMode");
}

//Add any type of beam that you dont want to be nail
int nBmTypeToAvoid[0];
//nBmTypeToAvoid.append(_kHeader);
//nBmTypeToAvoid.append(_kSFSupportingBeam);

int nBmTypeToAvoidOnFraiming[0];
nBmTypeToAvoidOnFraiming.append(_kSFAngledTPLeft);
nBmTypeToAvoidOnFraiming.append(_kSFAngledTPRight);
nBmTypeToAvoidOnFraiming.append(_kSFTopPlate);	
nBmTypeToAvoidOnFraiming.append(_kSFBottomPlate);

Element el = (Element) _Element[0];
if (!el.bIsValid())
{
	eraseInstance();
	return;
}

CoordSys csEl =el.coordSys();
Vector3d vx = csEl.vecX();
Vector3d vy = csEl.vecY();
Vector3d vz = csEl.vecZ();
_Pt0 = csEl.ptOrg();

Plane plnZ(el.ptOrg(), vz);

String sElNumber=el.number();

String sNailThisZone[0];
String sMaterial[0];
double dQty[0];
int nZone[0];

double dQtyFrame=0;
if (nExecutionMode==0)
{
	Beam bmAllTemp[]=el.beam();
	Beam bmAll[0];
	
	for (int i=0; i<bmAllTemp.length(); i++)
	{
		if (bmAllTemp[i].myZoneIndex()==0)
			bmAll.append(bmAllTemp[i]);
	}
	
	int nBeamTypeToAnalize[0];
	int nNailOption[0];
	nBeamTypeToAnalize.append(_kKingStud);				nNailOption.append(true);
	nBeamTypeToAnalize.append(_kSFSupportingBeam);	nNailOption.append(true);
	nBeamTypeToAnalize.append(_kDummyBeam);			nNailOption.append(false);
	
	//Recreate the BeamCodeString
	for (int i=0; i<bmAll.length(); i++)
	{
		Beam bm=bmAll[i];
		int nBeamType=bmAll[i].type();

		String sBeamCode=bm.beamCode();
		String sNewBeamCode;
		for (int i=0; i<13; i++)
		{
			String sToken;
			sToken=sBeamCode.token(i);
			sToken.trimLeft();
			sToken.trimRight();
			if (sToken!="")
			{
				sNewBeamCode+=sToken;
			}
			else
			{
				if (i==1)
				{
					String sValue=bm.material();
					sValue.trimLeft();
					sValue.trimRight();
					sValue.makeUpper();
					sNewBeamCode+=sValue;
				}
				if (i==8)
				{
					int nLoc=nBeamTypeToAnalize.find(nBeamType,-1);
					if (nLoc!=-1)
					{
						if (nNailOption[nLoc])
							sNewBeamCode+="YES";
						else
							sNewBeamCode+="NO";
					}
					else
					{
						sNewBeamCode+="YES";
					}

				}
				if (i==9)
				{
					String sValue=bm.grade();
					sValue.trimLeft();
					sValue.trimRight();
					sValue.makeUpper();
					sNewBeamCode+=sValue;
				}
				if (i==10)
				{
					String sValue=bm.information();
					sValue.trimLeft();
					sValue.trimRight();
					sValue.makeUpper();
					sNewBeamCode+=sValue;
				}
				if (i==11)
				{
					String sValue=bm.name();
					sValue.trimLeft();
					sValue.trimRight();
					sValue.makeUpper();
					sNewBeamCode+=sValue;
				}
			}
			sNewBeamCode+=";";
		}
		bm.setBeamCode(sNewBeamCode);
	}
	
	PlaneProfile ppOp(plnZ);
	Opening opAll[]=el.opening();
	
	for (int i=0; i<opAll.length(); i++)
	{
		OpeningSF op= (OpeningSF) opAll[i];
		if (!op.bIsValid()) continue;
		
		PLine plThisOp=opAll[i].plShape();
		PlaneProfile ppThisOp(plnZ);
		ppThisOp.joinRing(plThisOp, false);
		LineSeg ls=ppThisOp.extentInDir(vx);
		LineSeg lsNew(ls.ptStart()-vx*op.dGapSide(),  ls.ptEnd()+vy*U(3000)+vx*op.dGapSide());
		
		PLine plNew(vz);
		plNew.createRectangle(lsNew, vx, vy);
		
		ppOp.joinRing(plNew, false);
	}
	
	//ppOp.vis();
//	Beam arBm[] = NailLine().removeGenBeamsWithNoNailingBeamCode(bmAll);
	Beam arBm[0];
	for(int b = 0; b  < bmAll.length(); b++)
	{
		Beam bm = bmAll[b];
		
		//Exclude any beam that has the Tag "NoGluing"
		Map mpTags = bm.subMapX("Hsb_Tag");

		int nIgnoreSheet = FALSE;
		for (int i=0; i<mpTags.length(); i++)
		{
			if (mpTags.keyAt(i)=="TAG")
			{
				String sThisKey=mpTags.getString(i);
				
				if (sThisKey.makeUpper() == "NOGLUING")
				{
					nIgnoreSheet = TRUE;
					break;
				}
			}
		}
		
		if(nIgnoreSheet) continue;
		arBm.append(bm);
	}
	
	// HSB-23589: include trusses
	//TrussData
	TrussEntity entTruss[0];
	Beam bmToErase[0];
	//Check if there are any space joists
	Group grpElement = el.elementGroup();
	Entity entElement[] = grpElement.collectEntities(false, TrussEntity(), _kModelSpace);
	for (int i = 0; i < entElement.length(); i++)
	{
		//Get the truss entity
		TrussEntity truss = (TrussEntity) entElement[i];
		if ( ! truss.bIsValid()) continue;
		entTruss.append(truss);
	}
	//Get the truss definition data
	String sTrussDefinitions[0];
	double dTrussWidth[0];
	double dTrussHeight[0];
	double dTrussLength[0];
	Point3d ptLocation[0];
	Body bdTrusses[0];
	
	for (int i = 0; i < entTruss.length(); i++)
	{
		TrussEntity truss = entTruss[i];
		String sDefinition = truss.definition();
		CoordSys csTruss = truss.coordSys();
		
		//Get all the beams in the definition
		TrussDefinition trussDef(sDefinition);
		Beam bmTruss[] = trussDef.beam();
		Body bdTruss;
		for (int b = 0; b < bmTruss.length(); b++)
		{
			Beam bm = bmTruss[b];
			if ( ! bm.bIsValid()) continue;
			
			Body bd = bm.envelopeBody();
			bdTruss.combine(bd);
		}
		
		sTrussDefinitions.append(sDefinition);
		
		//Add in the locations for the beams
		//Rotate the point to the truss position as the definition is at 0,0,0
		CoordSys csTransform;
		Point3d pt(0, 0, 0);
		csTransform.setToAlignCoordSys(pt, _XW, _YW, _ZW, csTruss.ptOrg(), csTruss.vecX(), csTruss.vecY(), csTruss.vecZ());
		Point3d ptTrussCen = bdTruss.ptCen();
		ptTrussCen.transformBy(csTransform);
		bdTruss.transformBy(csTransform);
		ptTrussCen.vis();
		bdTruss.vis(2);
		bdTrusses.append(bdTruss);
		ptLocation.append(ptTrussCen);
	}
	for (int i = 0; i < sTrussDefinitions.length(); i++)
	{ 
		Beam bmNew;
		bmNew.dbCreate(bdTrusses[i],true,true);
		bmNew.setType(_kJoist);
		bmNew.setColor(1);
		arBm.append(bmNew);
		bmToErase.append(bmNew);
	}
	
	//Beam arBm[0];
	//arBm.append(bmAll);
	Beam bmValid[0];
	
	Beam bmHeaders[0];
	//Remove the Beams that are not needed	
	for (int i=0; i<arBm.length(); i++)
	{
		int nBeamType=arBm[i].type();
		if (nBmTypeToAvoid.find(nBeamType, -1) == -1)
		{
			bmValid.append(arBm[i]);
		}
		if (nBeamType==_kHeader)
		{
			bmHeaders.append(arBm[i]);
		}
	}
	
	Beam bmHor[0];
	Beam bmVer[0];
	Beam bmOther[0];
	
	for (int i=0; i<bmValid.length(); i++)
	{
		Beam bm=bmValid[i];
		//No nail beams that are thinner than 20mm
		if (bm.dW()<U(20))
			continue;
			
		if (abs(bm.vecX().dotProduct(vx))>0.999)
			bmHor.append(bm);
		else if (abs(bm.vecX().dotProduct(vy))>0.999)
			bmVer.append(bm);
		else if (abs(bm.vecX().dotProduct(vy))<0.999 || abs(bm.vecX().dotProduct(vx))<0.999)
			bmOther.append(bm);
	}
	bmVer=vx.filterBeamsPerpendicularSort(bmVer);
	bmHor=vy.filterBeamsPerpendicularSort(bmHor);
	
	bmValid.setLength(0);
	bmValid.append(bmVer);
	bmValid.append(bmHor);
	bmValid.append(bmOther);
	
	TslInst tslAll[]=el.tslInstAttached();
	for (int i=0; i<tslAll.length(); i++)
	{
		if ( tslAll[i].scriptName() == scriptName() && tslAll[i].handle() != _ThisInst.handle() )
		{
			tslAll[i].dbErase();
		}
	}

	//loop Zones
	
	int nExpZone[0];
	double dExpCenter[0];
	double dExpEdge[0];
	
	//Insert the TSL again for each Area
	TslInst tsl;
	String sScriptName = "hsb_GlueArea"; // name of the script
	Vector3d vecUcsX = _XW;
	Vector3d vecUcsY = _YW;
	Entity lstEnts[0];
	Beam lstBeams[0];
	Point3d lstPoints[0];
	int lstPropInt[0];
	//lstPropInt.append(nZones1);
	//lstPropInt.append(nToolingIndex1);
	
	double lstPropDouble[0];
	lstPropDouble.append(U(5));

	String lstPropString[0];
	Map mpToClone;
	mpToClone.setInt("ExecutionMode",0);

	lstEnts.setLength(0);
	lstEnts.append(el);
	
	for (int z = 0; z < nZoneIndex.length(); z++)
	{
		
		int nRef = nRefZone[z];
		
		double dQtyNailsThisZone = 0;
		//NailLine nlOld[] = el.nailLine(nZoneIndex[z]);
		//for (int n=0; n<nlOld.length(); n++) {
		//	NailLine nl = nlOld[n];
		//	if (nl.color()==nZoneIndex[z]) nl.dbErase();
		//}
		
		/*
		int nValidZones[]={1,2,3,4,5,6,7,8,9,10};
		int nRealZones[]={1,2,3,4,5,-1,-2,-3,-4,-5};
		//Next int nInt available=50;
		//Next int nString available=56;
		//Next int nDouble=50;
		
		PropInt nZones (0, nValidZones, T("Zone to be glued"));
		
		
		
			int nValidZones[]={1,2,3,4,5,6,7,8,9,10};
	i		nt nRealZones[]={1,2,3,4,5,-1,-2,-3,-4,-5};
		*/
		
		
		
		
		tslAll = el.tslInstAttached();
		for (int i = 0; i< tslAll.length() ; i++)
		{
			if ( tslAll[i].scriptName().makeUpper() == "HSB_GLUEAREA")
			{
				//int a = tslAll[i].propInt(0);
				//int b = nValidZones[nRealZones.find(nZoneIndex[z])];
				//int c = nZoneIndex[z];
				//reportNotice("\n" + a + " - " + b);
				//reportNotice("\n" + a + " - " + b+ " - " + c);
				if (tslAll[i].propInt(0) == nValidZones[nRealZones.find(nZoneIndex[z])])
				{
					tslAll[i].dbErase();
				}
			}
		}
		
		ElemZone elzone = el.zone(nZoneIndex[z]);
		
		CoordSys cs = elzone.coordSys();
		
		String sMaterialZone = elzone.material();
		
		GenBeam arSh[] = el.genBeam(nZoneIndex[z]);
		arSh = NailLine().removeGenBeamsWithNoNailingBeamCode(arSh);
		
		GenBeam gbZ[] = el.genBeam(nRef);
		// HSB-23589
		if(bmToErase.length()>0 && nRef==0)
		{ 
			for (int b=0;b<bmToErase.length();b++) 
			{ 
				gbZ.append(bmToErase[b]);
			}//next b
		}
		
		if (nRef != 0)
		{
			if (gbZ.length() == 0)
				continue;
		}
		
		if (arSh.length() <= 0)
		{
			continue;
		}
		
		LineSeg lsEl = el.segmentMinMax();
		Vector3d vDirNail = lsEl.ptStart() - lsEl.ptEnd();
		vDirNail.normalize();
		
		double dZone0W = el.zone(0).dH();
		if (dZone0W < 1)
			dZone0W = U(89);
		Point3d ptFacePlane = el.ptOrg();
		if (nZoneIndex[z] < 0)
		{
			ptFacePlane = ptFacePlane - vz * (dZone0W);
		}
		
		if (nRef != 0)
		{
			ptFacePlane = elzone.ptOrg();
		}
		
		Plane plnEl (ptFacePlane, vz);
		
		PlaneProfile ppHeader(plnEl);
		
		if (nRef == 0)
		{
			for (int i = 0; i < bmHeaders.length(); i++)
			{
				PlaneProfile ppBm = bmHeaders[i].realBody().extractContactFaceInPlane(plnEl, U(2));
				ppBm.shrink(-U(2));
				//ppBm.vis(i);
				if (ppBm.area() > U(1) * U(1))
				{
					ppHeader.unionWith(ppBm);
					//ppHeader.vis(1);
				}
			}
		}
		
		PlaneProfile ppAllAreas[0];
		
		if (nJoin == true)
		{
			PlaneProfile ppSh (plnEl);
			
			for (int i = 0; i < arSh.length(); i++)
			{
				String strZMaterial = arSh[i].material();
				
				if ( ! (strZMaterial == strMaterialZone[z] || strMaterialZone[z] == "") )
				{
					continue;
					//ppSh.joinRing (arSh[i].plEnvelope(), FALSE);
				}
				
				ppSh.unionWith(arSh[i].realBody().shadowProfile(plnEl));
				
				
			}
			ppSh.vis();
			ppAllAreas.append(ppSh);
		} 
		else
		{
			PlaneProfile ppSh (plnEl);
			
			for (int i = 0; i < arSh.length(); i++)
			{
				String strZMaterial = arSh[i].material();
				
				if ( ! (strZMaterial == strMaterialZone[z] || strMaterialZone[z] == "") )
				{
					continue;
					//ppSh.joinRing (arSh[i].plEnvelope(), FALSE);
				}
				ppAllAreas.append(arSh[i].realBody().shadowProfile(plnEl));
			}
		}
		
		for (int p = 0; p < ppAllAreas.length(); p++)
		{
			PlaneProfile ppSh (plnEl);
			ppSh = ppAllAreas[p];
			
			
			PlaneProfile ppNoValidArea(plnEl);
			
			int nVer = FALSE;
			int nFlag = - 1;
			
			//Find all the beams that are in contact with that face
			Beam bmContactThisSide[0];
			
			if (nRef == 0)
			{
				for (int j = 0; j < bmValid.length(); j++)
				{
					PlaneProfile ppThisBeam = bmValid[j].realBody().extractContactFaceInPlane(plnEl, U(2));
					if (ppThisBeam.area() > U(1) * U(1))
						bmContactThisSide.append(bmValid[j]);
				}
				
				for (int j = 0; j < bmContactThisSide.length(); j++)
				{
					int nPerimeterBeam = FALSE;
					Beam bm = bmContactThisSide[j];
					int nBeamType = bm.type();
					int nLocation = nBmType.find(nBeamType, - 1);
					if (nLocation != -1)
					{
						nPerimeterBeam = TRUE;
					}
					
					if (abs(bm.vecX().dotProduct(vy)) > 0.99)
					{
						nVer = TRUE;
						nFlag = nFlag *- 1;
					}
					
					int nTransom = false;
					
					//Remove the header in case there is no jacks above or below
					if (nBeamType == _kHeader)
					{
						Beam bmAux[] = bm.filterBeamsCapsuleIntersect(bmValid);
						int nJacks = FALSE;
						for (int b = 0; b < bmAux.length(); b++)
						{
							int nBmAuxType = bmAux[b].type();
							
							if (nBmAuxType == _kSFJackOverOpening || nBmAuxType == _kSFJackUnderOpening)
							{
								nJacks = true;
								//break;
							}
							if (nBmAuxType == _kSFTransom)
							{
								nTransom = true;
							}
						}
						
						//It will skip this beam because the nailing is going to be done by the jacks
						if (nJacks)
							continue;
					}
					
					Vector3d vxBm = bm.vecX();
					if (vxBm.dotProduct(vDirNail) < 0)
						vxBm = - vxBm;
					
					Vector3d vyBm = vxBm.crossProduct(vz);
					vyBm.normalize();
					
					if (nVer)
						vxBm = vxBm * nFlag;
					
					double dBmWidth = bm.dD(vyBm);
					dDistCloseToEdge = (dBmWidth / 2) + U(1);
					Body bdBm = bm.realBody(); //bdBm .vis(j);
					
					double dAux = el.zone(nZoneIndex[z]).dH();
					if (dAux < U(1))
					{
						dAux = U(18);
					}
					
					PlaneProfile ppBm(plnEl);
					PlaneProfile ppBmHeaderHor(plnEl);
					//if (dAux<1) dAux=U(20);
					
					if (nBeamType == _kSFJackOverOpening || nBeamType == _kSFSupportingBeam)//
					{
						ppBm = bdBm.extractContactFaceInPlane(plnEl, dAux);
						ppBm.shrink(-U(2));
						
						Body bdJack(bm.ptCen(), bm.vecX(), bm.vecY(), bm.vecZ(), U(9000), bm.dD(bm.vecY()), bm.dD(bm.vecZ()));
						PlaneProfile ppAuxBody = bdJack.extractContactFaceInPlane(plnEl, U(2));
						ppAuxBody.shrink(-U(2));
						ppAuxBody.intersectWith(ppHeader);
						ppBm.unionWith(ppAuxBody);
						ppBm.shrink(U(3));
						PlaneProfile ppTemp = ppBm;
						if ( ppTemp.intersectWith(ppNoValidArea) )
							if (ppTemp.area() > U(1) * U(1))
							{
								ppBm.subtractProfile(ppNoValidArea);
							}
						
						PlaneProfile ppBmBigger = ppBm;
						ppBmBigger.shrink(-U(4));
						if (ppBmBigger.area() > U(2) * U(2))
						{
							ppNoValidArea.unionWith(ppBmBigger);
							//ppNoValidArea.vis(3);
						}
					}
					else if (nBeamType == _kHeader)
					{
						PlaneProfile ppHeader = bdBm.extractContactFaceInPlane(plnEl, dAux);
						ppHeader.intersectWith(ppOp);
						
						LineSeg lsHeaderHor = ppHeader.extentInDir(vx);
						Point3d ptHLeft = lsHeaderHor.ptStart();
						Point3d ptHRight = lsHeaderHor.ptEnd();
						
						LineSeg lsHeaderVer = ppHeader.extentInDir(vy);
						Point3d ptHBottom = lsHeaderVer.ptStart();
						Point3d ptHTop = lsHeaderVer.ptEnd();
						Point3d ptBL = Line(ptHBottom, vxBm).closestPointTo(ptHLeft);
						Point3d ptTL = Line(ptHTop, vxBm).closestPointTo(ptHLeft);
						
						Point3d ptBR = Line(ptHBottom, vxBm).closestPointTo(ptHRight);
						Point3d ptTR = Line(ptHTop, vxBm).closestPointTo(ptHRight);
						
						int nHeaderHorizontal = false;
						
						if (nTransom)
						{
							//Only verticals left and right
							//ppOp
							
							LineSeg lsL (ptBL + vy * dDistEdge[z], ptTL + vx * U(38) - vy * dDistEdge[z]);
							PLine plLeft(vz);
							plLeft.createRectangle(lsL, vx, vy);
							
							LineSeg lsR (ptBR + vy * dDistEdge[z], ptTR - vx * U(38) - vy * dDistEdge[z]);
							PLine plRight(vz);
							plRight.createRectangle(lsR, vx, vy);
							
							ppBm.joinRing(plLeft, false);
							ppBm.joinRing(plRight, false);
							
						}
						else
						{
							//Verticals left, right and a horizontal at the bottom
							LineSeg lsL (ptBL + vy * dDistEdge[z], ptTL + vx * U(38) - vy * dDistEdge[z]);
							PLine plLeft(vz);
							plLeft.createRectangle(lsL, vx, vy);
							
							LineSeg lsR (ptBR + vy * dDistEdge[z], ptTR - vx * U(38) - vy * dDistEdge[z]);
							PLine plRight(vz);
							plRight.createRectangle(lsR, vx, vy);
							
							LineSeg lsB (ptBL + vx * U(40), ptBR - vx * U(40) + vy * U(38));
							PLine plBot(vz);
							plBot.createRectangle(lsB, vx, vy);
							
							ppBm.joinRing(plLeft, false);
							ppBm.joinRing(plRight, false);
							ppBmHeaderHor.joinRing(plBot, false);
							nHeaderHorizontal = true;
							
						}
						
						if (nHeaderHorizontal)
						{
							PlaneProfile ppAux = ppSh;
							ppAux.intersectWith(ppBmHeaderHor);
							ppAux.shrink(-U(1));
							if (ppAux.area() < U(1) * U(1))
								continue;
							
							int nTool = nToolingIndex[z];
							
							PLine plBm [] = ppAux.allRings();
							
							for (int k = 0; k < plBm.length(); k++)
							{
								PLine plAux = plBm[k];
								//plAux.vis(j);
								
								PlaneProfile ppValidArea(cs);
								ppValidArea.joinRing (plAux, FALSE);
								//ppValidArea.vis(j);
								
								LineSeg lnSegX = ppValidArea.extentInDir(vx);
								Point3d ptCent = lnSegX.ptMid();
								Point3d p1 = lnSegX.ptStart();
								//p1.vis(j);
								Point3d p2 = lnSegX.ptEnd();
								
								
								double dQtyNails = 0;
								
								double dWidth = abs(vyBm.dotProduct(lnSegX.ptStart() - lnSegX.ptEnd()));
								double dLengthNl = abs(vx.dotProduct(lnSegX.ptStart() - lnSegX.ptEnd()));
								if (dWidth < dMinValidArea)
									continue;
								
								int nDisplacement = 0;
								
								//								if (nStagger)
								//								{
								//									nDisplacement=abs(U(8)*nZoneIndex[z]);
								//								}
								
								Point3d ptStart = ptCent - vx * ((dLengthNl * .5)) + vx * nDisplacement;
								Point3d ptEnd = ptCent + vx * ((dLengthNl * .5)) - vx * nDisplacement;
								if ((ptEnd - ptStart).length() < dMinimumGlueLineLength) continue;
								
								//								if (arNNY[sArNY.find(sNailYNCNC,0)]==TRUE)
								{
									//								ElemNail enl(nZoneIndex[z], ptStart, ptEnd, dSpacing, nTool);
									//								// add the nailing line to the database
									//								NailLine nl; nl.dbCreate(el, enl);
									//								nl.setColor(nZoneIndex[z]); // set color of Nailing line
									lstPropString.setLength(0);
									lstPropString.append(_LineTypes[0]);
									lstPropString.append("Line");
									
									lstPropInt.setLength(0);
									lstPropInt.append(nValidZones[nRealZones.find(nZoneIndex[z])]);
									lstPropInt.append(nTool);
									
									lstPoints.setLength(0);
									lstPoints.append(ptStart);
									lstPoints.append(ptEnd);
									tsl.dbCreate(sScriptName, vecUcsX, vecUcsY, lstBeams, lstEnts, lstPoints, lstPropInt, lstPropDouble, lstPropString, TRUE, mpToClone);
									
								}
							}
						}
						
						PlaneProfile ppAux = ppSh;
						ppAux.intersectWith(ppBm);
						ppAux.shrink(-U(1));
						if (ppAux.area() < U(1) * U(1))
							continue;
						
						int nTool = nToolingIndex[z];
						
						PLine plBm [] = ppAux.allRings();
						
						for (int k = 0; k < plBm.length(); k++)
						{
							PLine plAux = plBm[k];
							//plAux.vis(j);
							
							PlaneProfile ppValidArea(cs);
							ppValidArea.joinRing (plAux, FALSE);
							//ppValidArea.vis(j);
							
							LineSeg lnSegX = ppValidArea.extentInDir(vy);
							Point3d ptCent = lnSegX.ptMid();
							Point3d p1 = lnSegX.ptStart();
							//p1.vis(j);
							Point3d p2 = lnSegX.ptEnd();
							
							
							double dQtyNails = 0;
							
							double dWidth = abs(vx.dotProduct(lnSegX.ptStart() - lnSegX.ptEnd()));
							double dLengthNl = abs(vy.dotProduct(lnSegX.ptStart() - lnSegX.ptEnd()));
							if (dWidth < dMinValidArea)
								continue;
							
							int nDisplacement = 0;
							
							Point3d ptStart = ptCent - vy * ((dLengthNl * .5)) + vy * nDisplacement;
							Point3d ptEnd = ptCent + vy * ((dLengthNl * .5)) - vy * nDisplacement;
							if ((ptEnd - ptStart).length() < dMinimumGlueLineLength) continue;
							
							//							if (arNNY[sArNY.find(sNailYNCNC,0)]==TRUE)
							{
								//								ElemNail enl(nZoneIndex[z], ptStart, ptEnd, dSpacing, nTool);
								//								// add the nailing line to the database
								//								NailLine nl; nl.dbCreate(el, enl);
								//								nl.setColor(nZoneIndex[z]); // set color of Nailing line
								lstPropString.setLength(0);
								lstPropString.append(_LineTypes[0]);
								lstPropString.append("Line");
								
								lstPropInt.setLength(0);
								lstPropInt.append(nValidZones[nRealZones.find(nZoneIndex[z])]);
								lstPropInt.append(nTool);
								
								lstPoints.setLength(0);
								lstPoints.append(ptStart);
								lstPoints.append(ptEnd);
								tsl.dbCreate(sScriptName, vecUcsX, vecUcsY, lstBeams, lstEnts, lstPoints, lstPropInt, lstPropDouble, lstPropString, TRUE, mpToClone);
								
							}
						}
						
						continue;
						
					}
					else
					{
						ppBm = bdBm.extractContactFaceInPlane(plnEl, dAux);
						Entity tslThisBeam[] = bm.eToolsConnected();
						for (int i = 0; i < tslThisBeam.length(); i++)
						{
							TslInst tsl = (TslInst) tslThisBeam[i];
							if ( ! tsl.bIsValid()) continue;
							if (tsl.scriptName() == "hsb_SplitBeamsWithScarfJoint")
							{
								Point3d ptCenter = tsl.ptOrg();
								Vector3d vDirection = ptCenter - bm.ptCen();
								vDirection.normalize();
								PlaneProfile ppThisTool(cs);
								PLine plThisTool(cs.vecZ());
								LineSeg lsThisTool(ptCenter - vy * U(100), ptCenter + vDirection * U(300) + vy * U(100));
								plThisTool.createRectangle(lsThisTool, cs.vecX(), cs.vecY());
								ppThisTool.joinRing(plThisTool, false);
								plThisTool.vis(1);
								ppBm.subtractProfile(ppThisTool);
							}
						}
						ppBm.shrink(U(1));
					}
					ppBm.vis(j);
					
					//ppBm.vis(j);
					PlaneProfile ppAux = ppSh;
					ppAux.intersectWith(ppBm);
					ppAux.shrink(-U(1));
					if (ppAux.area() < U(1) * U(1))
						continue;
					
					//ppAux.vis(1);
					
					//Mark the beams that could be remove from the nailing
					int nPosibleRemove = FALSE;
					if ((j > 0 && j < bmContactThisSide.length() - 1) && nVer)
					{
						Beam bmPrev = bmContactThisSide[j - 1];
						Beam bmNext = bmContactThisSide[j + 1];
						int bPrev = FALSE;
						int bNext = FALSE;
						
						if (abs(bmPrev.vecX().dotProduct(vy)) > 0.99)
						{
							if ( abs(vx.dotProduct(bm.ptCen() - bmPrev.ptCen())) <= (dBmWidth + U(1)) )
							{
								if (bmPrev.type() != _kSFJackUnderOpening && bmPrev.type() != _kSFJackOverOpening)
								{
									bPrev = TRUE;
									
									if (bmPrev.type() == _kSFStudLeft)
									{
										nPosibleRemove = TRUE;
									}
								}
							}
						}
						if (abs(bmNext.vecX().dotProduct(vy)) > 0.99)
						{
							if ( abs(vx.dotProduct(bm.ptCen() - bmNext.ptCen())) <= (dBmWidth + U(1)) )
							{
								//if (bmNext.type()!= _kKingStud)
								if (bmNext.type() != _kSFJackUnderOpening && bmNext.type() != _kSFJackOverOpening)
								{
									bNext = TRUE;
									if (bmNext.type() == _kSFStudRight)
									{
										nPosibleRemove = TRUE;
									}
								}
							}
						}
						if (bPrev && bNext)
						{
							if ( abs(vx.dotProduct(bm.ptCen() - bmPrev.ptCen())) <= (dBmWidth + U(1)) && abs(vx.dotProduct(bm.ptCen() - bmNext.ptCen())) <= (dBmWidth + U(1)) )
							{
								nPosibleRemove = TRUE;
							}
						}
					}
					
					
					PLine plBm [] = ppAux.allRings();
					
					for (int k = 0; k < plBm.length(); k++)
					{
						PLine plAux = plBm[k];
						//plAux.vis(j);
						
						PlaneProfile ppValidArea(cs);
						ppValidArea.joinRing (plAux, FALSE);
						//ppValidArea.vis(j);
						
						LineSeg lnSegX = ppValidArea.extentInDir(vxBm);
						Point3d ptCent = lnSegX.ptMid();
						Point3d p1 = lnSegX.ptStart();
						//p1.vis(j);
						Point3d p2 = lnSegX.ptEnd();
						//p2.vis(j);
						double dWidth = abs(vyBm.dotProduct(lnSegX.ptStart() - lnSegX.ptEnd()));
						double dLengthNl = abs(vxBm.dotProduct(lnSegX.ptStart() - lnSegX.ptEnd()));
						if (dWidth < dMinValidArea)
							continue;
						
						//Find the Distance to the edge of the NailLine
						double dDistToEdge = (abs(abs(vyBm.dotProduct(ptCent - bm.ptCen())) * 2 - dBmWidth)) * 0.5;
						
						//Set the Right tool Index acording to the side of the beam
						int nTool = nToolingIndex[z];
						
						//						if (bTiltTool[z])
						//						{
						//							if (dDistToEdge<dMinDist[z])
						//								if (vyBm.dotProduct(ptCent-bm.ptCen())>0)
						//								{
						//									nTool=nToolingIndexLeft[z];
						//									ptCent=ptCent - vyBm*dOffsetNailing[z];
						//								}
						//								else
						//								{
						//									nTool=nToolingIndexRight[z];
						//									ptCent=ptCent + vyBm*dOffsetNailing[z];
						//								}
						//						}
						
						if ( (dLengthNl - (dDistEdge[z] * 2)) > 0 )
						{
							double dQtyNails = 0;
							
							int nDisplacement = 0;
							
							Point3d ptStart = ptCent - vxBm * ((dLengthNl * .5) - (dDistEdge[z] + nDisplacement));
							Point3d ptEnd = ptCent + vxBm * ((dLengthNl * .5) - (dDistEdge[z] + nDisplacement));
							if ((ptStart - ptEnd).length() < U(2) || (ptEnd - ptStart).length() < dMinimumGlueLineLength)
								continue;
							
							//vxBm.vis(ptEnd, 1);
							LineSeg lsNL(ptStart, ptEnd);
							Point3d ptCloseToEdge = ppSh.closestPointTo(lsNL.ptMid());
							double dAux = abs((ptCloseToEdge - lsNL.ptMid()).length());
							if ((abs((ptCloseToEdge - lsNL.ptMid()).length()) < dDistCloseToEdge) || nPerimeterBeam)
							{
								if ((abs((ptCloseToEdge - lsNL.ptMid()).length()) > dDistCloseToEdge + dMinValidArea) && nPosibleRemove)
								{
									if (nBeamType == _kSFStudRight || nBeamType == _kSFStudLeft)
									{
										continue;
									}
								}
							}
							else
							{
								//reportNotice("\n"+abs((ptCloseToEdge-lsNL.ptMid()).length()));
								if (nPosibleRemove) // nBeamType == _kKingStud AJ
								{
									if (abs((ptCloseToEdge - lsNL.ptMid()).length()) > (dDistCloseToEdge + dMinValidArea))
									{
										continue;
									}
								}
							}
							
							//							if (arNNY[sArNY.find(sNailYNCNC,0)]==TRUE)
							{
								//								ElemNail enl(nZoneIndex[z], ptStart, ptEnd, dSpacing, nTool);
								//								// add the nailing line to the database
								//								NailLine nl; nl.dbCreate(el, enl);
								//								nl.setColor(nZoneIndex[z]); // set color of Nailing line
								lstPropString.setLength(0);
								lstPropString.append(_LineTypes[0]);
								lstPropString.append("Line");
								
								lstPropInt.setLength(0);
								lstPropInt.append(nValidZones[nRealZones.find(nZoneIndex[z])]);
								lstPropInt.append(nTool);
								
								lstPoints.setLength(0);
								lstPoints.append(ptStart);
								lstPoints.append(ptEnd);
								tsl.dbCreate(sScriptName, vecUcsX, vecUcsY, lstBeams, lstEnts, lstPoints, lstPropInt, lstPropDouble, lstPropString, TRUE, mpToClone);
								
							}
							
						}
					}
				}
			}
			else
			{
				for (int j = 0; j < gbZ.length(); j++)
				{
					GenBeam gbm = gbZ[j];
					Vector3d vxBm = gbm.vecX();
					Vector3d vyBm = gbm.vecY();
					
					if (gbm.bIsKindOf(Beam()))
					{
						vyBm = gbm.vecD(vxBm.crossProduct(vz));
					}
					
					Body bdBm = gbm.realBody(); //bdBm .vis(j);
					
					double dAux = abs(vz.dotProduct(el.zone(nZoneIndex[z]).coordSys().ptOrg() - el.zone(nRef).coordSys().ptOrg()));
					//el.zone(nZoneIndex[z]).dH();
					
					
					PlaneProfile ppBm(plnEl);
					
					ppBm = bdBm.extractContactFaceInPlane(plnEl, dAux);
					ppBm.shrink(U(1));
					ppBm.vis(j);
					
					LineSeg lsGb = ppBm.extentInDir(vxBm);
					if (abs(vxBm.dotProduct(lsGb.ptStart() - lsGb.ptEnd())) < abs(vyBm.dotProduct(lsGb.ptStart() - lsGb.ptEnd())))
					{
						vxBm = vyBm;
						vyBm = gbm.vecX();
					}
					
					double dBmWidth = abs(vyBm.dotProduct(lsGb.ptStart() - lsGb.ptEnd()));
					
					if (vxBm.dotProduct(vDirNail) < 0)
						vxBm = - vxBm;
					
					PlaneProfile ppAux = ppSh;
					ppAux.intersectWith(ppBm);
					ppAux.shrink(-U(1));
					if (ppAux.area() < U(1) * U(1))
						continue;
					
					ppAux.vis(1);
					
					PLine plBm [] = ppAux.allRings();
					
					for (int k = 0; k < plBm.length(); k++)
					{
						PLine plAux = plBm[k];
						//plAux.vis(j);
						
						PlaneProfile ppValidArea(plnEl);
						ppValidArea.joinRing (plAux, FALSE);
						ppValidArea.vis(j);
						
						LineSeg lnSegX = ppValidArea.extentInDir(vxBm);
						Point3d ptCent = lnSegX.ptMid();
						Point3d p1 = lnSegX.ptStart();
						p1.vis(j);
						Point3d p2 = lnSegX.ptEnd();
						p2.vis(j);
						double dWidth = abs(vyBm.dotProduct(lnSegX.ptStart() - lnSegX.ptEnd()));
						double dLengthNl = abs(vxBm.dotProduct(lnSegX.ptStart() - lnSegX.ptEnd()));
						if (dWidth < dMinValidArea)
							continue;
						
						//Find the Distance to the edge of the NailLine
						double dDistToEdge = (abs(abs(vyBm.dotProduct(ptCent - gbm.ptCen())) * 2 - dBmWidth)) * 0.5;
						
						//Set the Right tool Index acording to the side of the beam
						int nTool = nToolingIndex[z];
						
						//						if (bTiltTool[z])
						//						{
						//							if (dDistToEdge<dMinDist[z])
						//								if (vyBm.dotProduct(ptCent-gbm.ptCen())>0)
						//								{
						//									nTool=nToolingIndexLeft[z];
						//									ptCent=ptCent - vyBm*dOffsetNailing[z];
						//								}
						//								else
						//								{
						//									nTool=nToolingIndexRight[z];
						//									ptCent=ptCent + vyBm*dOffsetNailing[z];
						//								}
						//						}
						
						if ( (dLengthNl - (dDistEdge[z] * 2)) > 0 )
						{
							
							int nDisplacement = 0;
							
							Point3d ptStart = ptCent - vxBm * ((dLengthNl * .5) - (dDistEdge[z] + nDisplacement));
							Point3d ptEnd = ptCent + vxBm * ((dLengthNl * .5) - (dDistEdge[z] + nDisplacement));
							if ((ptStart - ptEnd).length() < U(2) || (ptEnd - ptStart).length() < dMinimumGlueLineLength)
								continue;
							
							vxBm.vis(ptEnd, 1);
							LineSeg lsNL(ptStart, ptEnd);
							Point3d ptCloseToEdge = ppSh.closestPointTo(lsNL.ptMid());
							
							ptCloseToEdge.vis(3);
							Point3d ptaasd = lsNL.ptMid();ptaasd.vis(2);
							
							double dAux = abs((ptCloseToEdge - lsNL.ptMid()).length());
							//							if ((abs((ptCloseToEdge-lsNL.ptMid()).length())<dDistCloseToEdge))
							//							{
							//								dSpacing=dEdgeSpacing;
							//							}
							//							else
							//							{
							//								dSpacing=dCenterSpacing;
							//							}
							
							
							//							if (arNNY[sArNY.find(sNailYNCNC,0)]==TRUE)
							{
								//									ElemNail enl(nZoneIndex[z], ptStart, ptEnd, dSpacing, nTool);
								//									// add the nailing line to the database
								//									NailLine nl; nl.dbCreate(el, enl);
								//									nl.setColor(nZoneIndex[z]); // set color of Nailing line
								
								lstPropString.setLength(0);
								lstPropString.append(_LineTypes[0]);
								lstPropString.append("Line");
								
								lstPropInt.setLength(0);
								lstPropInt.append(nValidZones[nRealZones.find(nZoneIndex[z])]);
								lstPropInt.append(nTool);
								
								lstPoints.setLength(0);
								lstPoints.append(ptStart);
								lstPoints.append(ptEnd);
								tsl.dbCreate(sScriptName, vecUcsX, vecUcsY, lstBeams, lstEnts, lstPoints, lstPropInt, lstPropDouble, lstPropString, TRUE, mpToClone);
							}
						}
					}
					
				}
			}
		}
	
		
		if (dQtyNailsThisZone>0)
		{
			nZone.append(nZoneIndex[z]);
//			sNailThisZone.append(strNailType[z]);
			sMaterial.append(sMaterialZone);
			dQty.append(dQtyNailsThisZone);
			
			nExpZone.append(nZoneIndex[z]);
//			dExpCenter.append(dCenterSpacing);
//			dExpEdge.append(dEdgeSpacing);
			
		}

		/*
		NailLine arNl[] = el.nailLine(nZoneIndex[z]); // all nailing lines nailing on zone 1
		// filter all nailing lines closer then 100mm to a sheeting edge
		NailLine arNlClose[] = NailLine().filterNailLinesCloseToSheetingEdge(arNl,arSh,dDistCloseToEdge);
		// change the spacing of these filtered NailLines
		for (int i=0; i<arNlClose.length(); i++)
		{
			arNlClose[i].setSpacing(dSpacingEdge[z]);
		}*/
	}//End Loop for Nail Multiple Zones
	
	// HSB-23589
	for (int b=bmToErase.length()-1; b>=0 ; b--) 
	{ 
		bmToErase[b].dbErase(); 
	}//next b
	
	
//	Map mpNailingInfo;
//	
//	for (int i=0; i<nExpZone.length(); i++)
//	{
//		Map mpThisZone;
//
//		mpThisZone.setInt("ZoneIndex", nExpZone[i]);
//		mpThisZone.setDouble("Perimeter", dExpEdge[i]);
//		mpThisZone.setDouble("Intermediate", dExpCenter[i]);
//		mpNailingInfo.appendMap("NailingInfo", mpThisZone);
//	}
//	
//	Map mpThisEl=el.subMapX("HSB_ElementData");
//
//	if (mpThisEl.hasMap("NailingInfo[]"))
//	{
//		mpThisEl.removeAt("NailingInfo[]", true);
//	}
//	
//	if (mpNailingInfo.length()>0)
//	{
//		mpThisEl.setMap("NailingInfo[]", mpNailingInfo);
//
//		el.setSubMapX("HSB_ElementData", mpThisEl);
//	}
//	
//	
//	for (int i=0; i<sMaterial.length(); i++)
//	{
//		Map itemMap1= Map();
//		itemMap1.setString("MATERIAL", sMaterial[i]);
//		itemMap1.setString("QUANTITY",dQty[i]);
//		itemMap1.setString("LABEL",sElNumber);
//		itemMap1.setString("DESCRIPTION",sNailThisZone[i]);
//
//		itemMap1.setInt("ZONE", nZone[i]);
//		_Map.appendMap("SHEETNAILING", itemMap1);
//		
//		//Export to DXA
//		int nReference=(i+1);
//		dxaout("U_ZONE"+nReference,"Zone"+nReference);
//		dxaout("U_DESCRIPTION"+nReference, sNailThisZone[i]);
//		dxaout("U_QUANTITY"+nReference, dQty[i]);		
//	}
}

//for (int i=0; i<_Map.length(); i++)
//{
//	if (_Map.keyAt(i)=="SHEETNAILING")
//	{
//		Map mpOut= _Map.getMap(i);
//		mpOut.setMapKey("");
//		int nZoneOut=mpOut.getInt("ZONE");
//		mpOut.removeAt("ZONE", TRUE);
//		ElemItem item1(nZoneOut, T("SHEETNAILING"), el.ptOrg(), el.vecZ(), mpOut);
//		item1.setShow(_kNo);
//		el.addTool(item1);
//	}
//}
//
//if (_Map.hasMap("FRAMENAILING"))
//{
//	Map mpOut=_Map.getMap("FRAMENAILING");
//	mpOut.setMapKey("");
//	ElemItem item1(0, T("FRAMENAILING"), el.ptOrg(), el.vecZ(), mpOut);
//	item1.setShow(_kNo);
//	el.addTool(item1);
//}
//
//Map mpNailInfo;
//if (arNNY[sArNY.find(nNailYN1,0)]==TRUE)
//{
//	mpNailInfo.setInt("nZone1", 1);
//}
//
//if (arNNY[sArNY.find(nNailYN2,0)]==TRUE)
//{
//	mpNailInfo.setInt("nZone2", 2);
//}
//
//if (arNNY[sArNY.find(nNailYN3,0)]==TRUE)
//{
//	mpNailInfo.setInt("nZone3", 3);
//}
//
//if (arNNY[sArNY.find(nNailYN4,0)]==TRUE)
//{
//	mpNailInfo.setInt("nZone4", 4);
//}
//
//if (arNNY[sArNY.find(nNailYN5,0)]==TRUE)
//{
//	mpNailInfo.setInt("nZone5", 5);
//}
//
//if (arNNY[sArNY.find(nNailYN6,0)]==TRUE)
//{
//	mpNailInfo.setInt("nZone6", 6);
//}
//
//if (arNNY[sArNY.find(nNailYN7,0)]==TRUE)
//{
//	mpNailInfo.setInt("nZone7", 7);
//}
//
//if (arNNY[sArNY.find(nNailYN8,0)]==TRUE)
//{
//	mpNailInfo.setInt("nZone8", 8);
//}
//
//if (arNNY[sArNY.find(nNailYN9,0)]==TRUE)
//{
//	mpNailInfo.setInt("nZone9", 9);
//}
//
//if (arNNY[sArNY.find(nNailYN10,0)]==TRUE)
//{
//	mpNailInfo.setInt("nZone10", 10);
//}
//
//if (mpNailInfo.length()>1)
//{
//	_Map.setMap("NailingInfo", mpNailInfo);
//}

Point3d ptDraw = _Pt0;
Display dspl (-1);
dspl.dimStyle(sDimLayout);

if (sDispRep!="")
	dspl.showInDispRep(sDispRep);

PLine pl1(_XW);
PLine pl2(_YW);
PLine pl3(_ZW);
pl1.addVertex(ptDraw+_ZW*U(1));
pl1.addVertex(ptDraw-_ZW*U(1));
pl2.addVertex(ptDraw-_XW*U(1));
pl2.addVertex(ptDraw+_XW*U(1));
pl3.addVertex(ptDraw-_YW*U(1));
pl3.addVertex(ptDraw+_YW*U(1));

dspl.draw(pl1);
dspl.draw(pl2);
dspl.draw(pl3);

_Map.setInt("ExecutionMode",1);


assignToElementGroup(_Element[0], TRUE, 0, 'E');



#End
#BeginThumbnail






#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="486" />
        <int nm="BreakPoint" vl="779" />
        <int nm="BreakPoint" vl="844" />
        <int nm="BreakPoint" vl="932" />
        <int nm="BreakPoint" vl="946" />
        <int nm="BreakPoint" vl="958" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23589: Add support for trusses" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="7/18/2025 1:14:20 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End