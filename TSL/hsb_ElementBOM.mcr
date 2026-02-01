#Version 8
#BeginDescription
#Versions:
1.47 29.09.2024 HSB-20904: Add property to define the title name for the "space studs" table Author: Marsel Nakuci
1.46 22/08/2023 Bugfix with sheeting been excluded incorrectly. AJ
1.45 25/07/2023 Bugfix AJ
1.44 21/07/2023 Add support to the Assembly Definition TSL AJ
1.43 28.11.2022 HSB-16774: show subassemblies for "GC-SpaceStudAssembly"
1.42 28.11.2022 HSB-16774: Add property/column name; show beams part of subassembly "S" TSLs
Date: 03.02.2022  -  version 1.41


Creates a bill of materials in the Layout for Walls or Floors







#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 47
#KeyWords BOM
#BeginContents
/*
*  COPYRIGHT
*  ---------------
*  Copyright (C) 2009 by
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
* #Versions:
// 1.47 29.09.2024 HSB-20904: Add property to define the title name for the "space studs" table Author: Marsel Nakuci
//1.46 22/08/2023 Bugfix with sheeting been excluded incorrectly. AJ
//1.45 25/07/2023 Bugfix AJ
//1.44 21/07/2023 Add support to the Assembly Definition TSL AJ
// 1.43 28.11.2022 HSB-16774: show subassemblies for "GC-SpaceStudAssembly" Author: Marsel Nakuci
// 1.42 28.11.2022 HSB-16774: Add property/column name; show beams part of subassembly "S" TSLs Author: Marsel Nakuci
* Created by: Alberto Jena (aj@hsb-cad.com)
* date: 15.03.2012
* version 1.0: base on hsb_WallBOM
*
* date: 21.03.2012
* version 1.1: fix issue with the angle
*
* date: 23.04.2012
* version 1.2: add the option to show metalparts
*
* date: 02.05.2012
* version 1.3: add extra beam type for floors
*
* date: 03.05.2012
* version 1.4: Bugfix with generic beams in floors and set the right name for sheetin
*
* date: 03.05.2012
* version 1.5: Add the option to show the material or grade
*
* date: 23.05.2012
* version 1.6: Fix issue with metalparts quantity
*
* date: 12.06.2012
* version 1.7: Add Sip Panels
*
* date: 26.06.2012
* version 1.8: Added Length to properties for displaying instead of posnum
*
* date: 02.07.2012
* version 1.10: Text orientation bugfix
*
* date: 12.07.2012
* version 1.11: Fix Posnum orientation and improve the display
*
* date: 13.07.2012
* version 1.12: Added beam name levels for SIP walls
*
* date: 13.07.2012
* version 1.13: Added truss entities
*
* date: 15.08.2012
* version 1.14: Fix issue when there are diferent pos in the same location
*
* date: 11.10.2012
* version 1.15: Add the option to show the Table in 2 columns
*
* date: 23.10.2012
* version 1.16: Changed precision for nominal value
*
* date: 18.11.2012
* version 1.17: Added code for SIP roofs
*
* date: 19.02.2013
* version 1.18: Add VeryTopPlate
*
* date: 04.03.2013
* version 1.19: Bugfix SIP roof timber names not being allocated to group
*
* date: 11.03.2013: David Rueda 
* version 1.20: 
*	- Prop. "Show Angle Column" (yes/no) added
*	- Bugfix when displaying real sizes instead of nominal for US market
*
* date: 20.05.2013: AJ
* version 1.21: Add sorting for SIP panels base on the label
*
* date: 29.09.2013: AJ
* version 1.25: Add sorting for SIP panels base on the label
*
* date: 10.10.2015: CS
* version 1.28: Added kRisingBeam as Furring piece
*/

_ThisInst.setSequenceNumber(100);

int nLunit = 2; // architectural (only used for beam length, others depend on hsb_settings)
int nPrec = 1; // precision (only used for beam length, others depend on hsb_settings)

double dTolerance = U(0.01, 0.01);

String sArNY[] = {T("No"), T("Yes")};
String sGroupings[] = { T("|Posnum & dimension|"), T("|Posnum|")};

String sPaperSpace = T("|paper space|");
String sShopdrawSpace = T("|shopdraw multipage|");
String sArSpace[] = { sPaperSpace , sShopdrawSpace };
PropString sSpace(2,sArSpace,T("|Drawing space|"));

PropString sDimStyle(0,_DimStyles, "Dim Style");
//PropString propHeader(1,"Text can be changed in the OPM","Table header");
PropInt nColor(0,3,"Color");

PropString strBmName (17,"",T("Beam names to exclude from the BOM"));
strBmName.setDescription(T("Please fill the beam names that you dont need to be list on the BOM, use ';' if you want to filter more than 1 name"));

PropString sFilterByZone(19, "", T("|Exclude zones from BOM|"));
sFilterByZone.setDescription(T("|Separate multiple entries by|") +" ';'");

PropString strMaterial (1,"",T("Materials to exclude from the BOM"));
strMaterial.setDescription(T("Please fill the materials that you dont need to be list on the BOM, use ';' if you want to filter more than 1 material"));

PropString strGrouping(21, sGroupings, T("|Group by|"), 0);
strGrouping.setDescription(T("|Groups by PosNum or Posnum & dimension of entity|"));
int nGrouping = sGroupings.find(strGrouping, 0);

PropString sCompAngle(5, sArNY, T("|Switch to Complementary Angle|"), 0);
int nCompAngle= sArNY.find(sCompAngle,0);

PropString sDoSheets(6, sArNY, T("|Show Sheets in the BOM|"), 1);
int nDoSheets= sArNY.find(sDoSheets,0);

PropString sDoBeams(7, sArNY, T("|Show Beams in the BOM|"), 1);
int nDoBeams= sArNY.find(sDoBeams,0);

PropString sDoSIPs(13, sArNY, T("|Show SIPs in the BOM|"), 1);
int nDoSIPs= sArNY.find(sDoSIPs,0);

PropString sDoMetalparts(10, sArNY, T("|Show Metalparts in the BOM|"), 1);
int nDoMetalparts= sArNY.find(sDoMetalparts,0);

PropString sDoTrusses(14, sArNY, T("|Show Trusses in the BOM|"), 1);
int nDoTrusses= sArNY.find(sDoTrusses,0);

PropString sDimStylePosnum(3,_DimStyles, "Dim Style Posnum");
PropInt nColorPosnum(1,3,"Color Posnum");

PropString sShowJoistReferences (9, "", T("Joist Reference Catalogue"));
sShowJoistReferences .setDescription("If using Joist References in Exporter, Enter the catalogue name");

int bShowJoistReferences=FALSE;
if(sShowJoistReferences!="")
{
	bShowJoistReferences=TRUE;
}

String sBmRef[]={"None","Posnum","Length"};
PropString sShowBmPosnum (4, sBmRef, T("Show Beam Reference"));
sShowBmPosnum.setDescription("Shows selected reference on each beam");
int bShowBmPosnum = sBmRef.find(sShowBmPosnum, 0);

String sAOrientation[]={"Horizontal","Allign To Beam Axis"};
PropString sOrientation(18, sAOrientation, T("Beam Reference Orientation"));
sShowBmPosnum.setDescription("Define the orientation of the posnum, length or reference on top of the beam");
int nOrientation = sAOrientation.find(sOrientation, 0);


int nValidZones[]={0,1,2,3,4,5,6,7,8,9,10};
int nRealZones[]={0,1,2,3,4,5,-1,-2,-3,-4,-5};
PropInt nZones (2, nValidZones, T("Show Posnum Zone, 0=none"), 0);
int nZone=nRealZones[nValidZones.find(nZones, 0)];

PropString strShowLabel(8,sArNY,T("Show Label Column"),1);
int bShowLabel = sArNY.find(strShowLabel, 0);
// HSB-16774
PropString strShowName(22,sArNY,T("Show Name Column"),1);
int bShowName = sArNY.find(strShowName, 0);

PropString strShowShortLength(20,sArNY,T("Show Short Length"),0);
int bShowShortLength = sArNY.find(strShowShortLength, 1);

PropString strShowAngle(16,sArNY,T("Show Angle Column"),1);
int bShowAngle = sArNY.find(strShowAngle, 1);

PropString strShowMaterial(11,sArNY,T("Show Material Column"),1);
int bShowMaterial = sArNY.find(strShowMaterial, 0);

PropString strShowGrade(12,sArNY,T("Show Grade Column"),1);
int bShowGrade = sArNY.find(strShowGrade, 0);

PropString sTwoColumns(15, sArNY, T("Show table in two columns"), 0);
int bTwoColumns = sArNY.find(sTwoColumns, 0);
// HSB-20904
PropString sSpaceStudHeaderName(23, "Space stud", T("Space studs table title"));
sSpaceStudHeaderName.setDescription(T("|It defines the table title for the group of space studs|"));

int bShowShPosnum=false;
if (nZone!=0)
	bShowShPosnum=true;

String sArrMaterials[0];
String sExtType=strMaterial;
sExtType.trimLeft();
sExtType.trimRight();
sExtType=sExtType+";";
for (int i=0; i<sExtType.length(); i++)
{
	String str=sExtType.token(i);
	str.trimLeft();
	str.trimRight();
	str.makeUpper();
	if (str.length()>0)
		sArrMaterials.append(str);
}

String sArrNames[0];
String sExtName=strBmName;
sExtName.trimLeft();
sExtName.trimRight();
sExtName=sExtName+";";
for (int i=0; i<sExtName.length(); i++)
{
	String str=sExtName.token(i);
	str.trimLeft();
	str.trimRight();
	str.makeUpper();
	if (str.length()>0)
		sArrNames.append(str);
}

// transform zones into arrays
int nZoneFilter[0];
int nRealZoneFilter[0];
String sZoneFilterList = sFilterByZone;
sZoneFilterList.trimLeft();
sZoneFilterList.trimRight();
sZoneFilterList =sZoneFilterList +";";

for (int i=0; i<sZoneFilterList.length(); i++)
{
	String str=sZoneFilterList .token(i);
	str.trimLeft();
	str.trimRight();
	str.makeUpper();
	if (str.length()>0)
	{
		nZoneFilter.append(str.atoi());
	}
}

for (int i = 0; i < nZoneFilter.length(); i++)
{
	int realZoneIndex = nValidZones.find(nZoneFilter[i], - 1);
	if (realZoneIndex == -1) continue;
	nRealZoneFilter.append(nRealZones[realZoneIndex]);
}


//End OPM
if (_bOnInsert)
{
	showDialog();
	//int nSpace = sArSpace.find(sSpace);
	
	_Pt0=getPoint(T("Pick a point to show the table"));
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

	return;
}//end bOnInsert

setMarbleDiameter(U(5, 0.2));

Display dp(nColor); // use color of entity for frame
dp.dimStyle(sDimStyle); // dimstyle was adjusted for display in paper space, sets textHeight

double dOffset = dp.textLengthForStyle("XX", sDimStyle);
//double dOffset = U(3, 1.5);

Element el;
int nZoneIndex;
Entity entAll[0];	

//coordSys
CoordSys ms2ps, ps2ms;	

//paperspace
if ( sSpace == sPaperSpace ){
	Viewport vp;
	if (_Viewport.length()==0) 
	{
		eraseInstance();
		return; // _Viewport array has some elements
	}
		
	vp = _Viewport[_Viewport.length()-1]; // take last element of array
	_Viewport[0] = vp; // make sure the connection to the first one is lost

	// check if the viewport has hsb data
	if (!vp.element().bIsValid()) 
		return;

	ms2ps = vp.coordSys();
	ps2ms = ms2ps;
	ps2ms.invert();
	el = vp.element();
	nZoneIndex = vp.activeZoneIndex();
}

//shopdrawspace
else if (sSpace == sShopdrawSpace ) {
	
	if (_Entity.length()==0)
	{
		eraseInstance();
		return; // _Entity array has some elements
	}
	
	ShopDrawView sv = (ShopDrawView)_Entity[0];
	
	if (!sv.bIsValid()) 
		return;
	
	// interprete the list of ViewData in my _Map
	ViewData arViewData[] = ViewData().convertFromSubMap( _Map, _kOnGenerateShopDrawing + "\\" + _kViewDataSets,0); // 2 means verbose
	int nIndFound = ViewData().findDataForViewport(arViewData, sv);// find the viewData for my view
	if (nIndFound<0) 
		return; // no viewData found
	
	ViewData vwData = arViewData[nIndFound];
	Entity arEnt[] = vwData.showSetEntities();
	
	ms2ps = vwData.coordSys();
	ps2ms = ms2ps;
	ps2ms.invert();
	
	for (int i = 0; i < arEnt.length(); i++)
	{
		Entity ent = arEnt[i];
		if (arEnt[i].bIsKindOf(Element()))
		{
			el=(Element) ent;
			break;
		}
	}
}
sSpace.setReadOnly(1);
if( !el.bIsValid() )return;

//////////////////////////////////
int nBeamType[0];
int nLevel[0];

int nBeamTypeToAvoid[0];
//nBeamTypeToAvoid.append(_kBlocking);

int nVisible[0];
String sLevelName[0];

int nFloor=false;
int nWall=false;
int nSip=false;
int nSipRoof=false;

ElementRoof elRoof = (ElementRoof) el;
	
if (elRoof.bIsValid())
{
	nFloor=true;
}
else
{
	ElementWallSF elWall = (ElementWallSF) el;
	ElementWall elWallSip = (ElementWall) el;
	if (elWall.bIsValid())
	{
		nWall=true;
	}
	else
	if(elWallSip.bIsValid())
	{
		nSip=true;
	}
	else
	{
		nSipRoof=true;
	}
}


String sSheetingGroupName="Wallboard";
String sTrussGroupName="Trusses";

if (nWall)
{
	nBeamType.append(_kSFJackOverOpening);			nLevel.append(4);
	nBeamType.append(_kSFJackUnderOpening);			nLevel.append(4);
	nBeamType.append(_kCrippleStud);						nLevel.append(4);
	nBeamType.append(_kSFTransom);						nLevel.append(6);
	nBeamType.append(_kKingStud);							nLevel.append(4);
	nBeamType.append(_kSill);								nLevel.append(6);
	nBeamType.append(_kBrace);							nLevel.append(6);
	nBeamType.append(_kSFAngledTPLeft);					nLevel.append(3);
	nBeamType.append(_kSFAngledTPRight);				nLevel.append(3);
	nBeamType.append(_kSFBlocking);						nLevel.append(8);
	nBeamType.append(_kBlocking);							nLevel.append(8);
	nBeamType.append(_kSFSupportingBeam);				nLevel.append(5);
	nBeamType.append(_kStud);								nLevel.append(4);
	nBeamType.append(_kSFStudLeft);						nLevel.append(4);
	nBeamType.append(_kSFStudRight);						nLevel.append(4);
	nBeamType.append(_kSFTopPlate);						nLevel.append(3);
	nBeamType.append(_kSFVeryTopPlate);					nLevel.append(3);
	nBeamType.append(_kTopPlate);							nLevel.append(3);
	nBeamType.append(_kSFBottomPlate);					nLevel.append(2);
	nBeamType.append(_kHeader);							nLevel.append(7);
	nBeamType.append(_kLocatingPlate);					nLevel.append(1);
	nBeamType.append(_kSFVent);							nLevel.append(9);
	nBeamType.append(_kTypeNotSet);						nLevel.append(8);
	nBeamType.append(_kLog);								nLevel.append(8);
	nBeamType.append(_kLath);								nLevel.append(10);
	nBeamType.append(_kDakFrontEdge);					nLevel.append(11);
	nBeamType.append(_kDakCenterJoist);					nLevel.append(12);
	nBeamType.append(_kTRWedge);						nLevel.append(13);
	nBeamType.append(_kBatten);							nLevel.append(10);
	// HSB-20904
	sLevelName.append(sSpaceStudHeaderName); /*0*/				nVisible.append(true);	
	sLevelName.append("Locating Plate"); /*1*/			nVisible.append(true);	
	sLevelName.append("Bottom Plate"); /*2*/			nVisible.append(true);
	sLevelName.append("Top Plate"); /*3*/				nVisible.append(true);
	sLevelName.append("Stud"); /*4*/					nVisible.append(true);
	sLevelName.append("Cripple"); /*5*/					nVisible.append(true);
	sLevelName.append("Transom"); /*6*/				nVisible.append(true);
	sLevelName.append("Lintel"); /*7*/					nVisible.append(true);
	sLevelName.append("Blocking"); /*8*/				nVisible.append(true);
	sLevelName.append("Vent"); /*9*/					nVisible.append(true);
	sLevelName.append("Service Battens"); /*10*/		nVisible.append(true);
	sLevelName.append("Battens"); /*11*/				nVisible.append(true);
	sLevelName.append("Connectors"); /*12*/			nVisible.append(true);
	sLevelName.append("Fillet"); /*13*/					nVisible.append(true);
	sLevelName.append("Generic");						nVisible.append(true);	//Generic should be always the last one in this array

	sSheetingGroupName="Wallboard";
}
else if(nFloor)
{
	nBeamType.append(_kDakCenterJoist);					nLevel.append(0);
	nBeamType.append(_kDakBackEdge);					nLevel.append(1);  
	nBeamType.append(_kDakFrontEdge);					nLevel.append(1); 
	nBeamType.append(_kDakLeftEdge);						nLevel.append(1); 
	nBeamType.append(_kDakRightEdge);					nLevel.append(1);
	nBeamType.append(_kSupportingCrossBeam);			nLevel.append(2);
	nBeamType.append(_kRimBeam);						nLevel.append(1);
	nBeamType.append(_kRimJoist);							nLevel.append(0);
	nBeamType.append(_kBlocking);							nLevel.append(4);
	nBeamType.append(_kLath);								nLevel.append(5);
	nBeamType.append(_kCantileverBlock);					nLevel.append(8);
	nBeamType.append(_kFloorBeam);						nLevel.append(7);
	nBeamType.append(_kJoist);								nLevel.append(0);
	nBeamType.append(_kLedger);							nLevel.append(6);
	nBeamType.append(_kTypeNotSet);						nLevel.append(8);
	nBeamType.append(_kExtraBlock);						nLevel.append(3); 
	nBeamType.append(_kRisingBeam );					nLevel.append(8); 
	
	sLevelName.append("Joist"); /*0*/						nVisible.append(true);	
	sLevelName.append("Rimboard"); /*1*/					nVisible.append(true);
	sLevelName.append("Supporting Beam"); /*2*/			nVisible.append(true);
	sLevelName.append("Packer"); /*3*/						nVisible.append(true);
	sLevelName.append("Blocking"); /*4*/					nVisible.append(true);
	sLevelName.append("Batten"); /*5*/						nVisible.append(true);
	sLevelName.append("Ledger"); /*6*/						nVisible.append(true);
	sLevelName.append("Trimmer"); /*7*/					nVisible.append(true);
	sLevelName.append("Furring"); 	/*8*/					nVisible.append(true);
	sLevelName.append("Generic");							nVisible.append(true);
	
	//Generic should be always the last one in this array
	sSheetingGroupName="Sheathing";
	sTrussGroupName="Metal Web Joists";

}
else if(nSip || nSipRoof)
{
	//Loop through all beams getting the names
	Beam bmSips[]=el.beam();

	for(int b=0;b<bmSips.length();b++)
	{
		Beam bm=bmSips[b];
		String sName=bm.name();
		sName.trimLeft();
		sName.trimRight();
		sName.makeUpper();
	
		//generic if no name
		if(sName=="") continue;
		//check if the name exists in the array
		if(sLevelName.find(sName)==-1)
		{
			nBeamType.append(sLevelName.length());
			nLevel.append(sLevelName.length());
			sLevelName.append(sName);
			nVisible.append(true);
		}

	}
	sLevelName.append("Generic");							
	nVisible.append(true);
}
else
{
	return;
}
//////////////////////////////////

//Beam bmToStart[]=el.beam();
GenBeam gb[]=el.genBeam();

GenBeam gbAll[]=GenBeam().filterGenBeamsNotInSubAssembly(gb);
// HSB-16774
GenBeam gbAllSubAssembly[0];
for (int i=0;i<gb.length();i++)
{ 
	if(gbAll.find(gb[i])<0)
	{ 
		gbAllSubAssembly.append(gb[i]);
	}
}//next igb

Beam bmAll[0];
Beam bmAllSubAssembly[0];

for (int i=0; i<gbAll.length(); i++)
{
	Beam bm=(Beam) gbAll[i];
	if (bm.bIsValid())
	{
		if(!bm.bIsDummy())
		{
			
			String sBmName=bm.name();
			sBmName.trimLeft();
			sBmName.trimRight();
			sBmName.makeUpper();
			int nLocation=sArrNames.find(sBmName, -1);
			if (sArrNames.find(sBmName, -1)==-1)//Filter the material Names
			{
				bmAll.append(bm);
			}
		}
	}
}
// HSB-16774
for (int i=0;i<gbAllSubAssembly.length();i++) 
{ 
	Beam bm=(Beam) gbAllSubAssembly[i];
	if(bm.bIsValid())
	{ 
		if(!bm.bIsDummy())
		{ 
			if(bmAllSubAssembly.find(bm)<0)
			{ 
				String sBmName=bm.name();
				sBmName.trimLeft();
				sBmName.trimRight();
				sBmName.makeUpper();
				int nLocation=sArrNames.find(sBmName, -1);
				if (sArrNames.find(sBmName, -1)==-1)//Filter the material Names
				{
					bmAllSubAssembly.append(bm);
				}
			}
		}
	}
}//next i
bmAll.append(bmAllSubAssembly);

//If Joist references are in use get the data from the Exporter DLL
String sJoistHandles[0];
int nJoistReferences[0];

if(bShowJoistReferences)
{
	//Check whether the dll exists else switch back to posnum
	String strAssemblyPath=_kPathHsbInstall+"\\Export\\Interfaces\\hsbSoft.Cad.IO.SiteStream.dll";
//	String strAssemblyPath="C:\\Users\\csawjani\\Documents\\Visual Studio 2010\\Projects\\SiteStream\\hsbSoft.Cad.IO.SiteStream\\bin\\Debug\\hsbSoft.Cad.IO.SiteStream.dll";
	String strType = "hsbSoft.Cad.IO.SiteStream.SiteStreamTSLUtils";
	String strFunction = "GetBoqBeamTypes";
	
	String sResult=findFile(strAssemblyPath);
	if(sResult!="")
	{
		// set some export flags
		ModelMapComposeSettings mmFlags;
		mmFlags.addSolidInfo(true); // default FALSE
		mmFlags.addAnalysedToolInfo(false); // default FALSE
		mmFlags.addElemToolInfo(false); // default FALSE
		mmFlags.addConstructionToolInfo(false); // default FALSE
		mmFlags.addHardwareInfo(false); // default FALSE
		mmFlags.addRoofplanesAboveWallsAndRoofSectionsForRoofs(false); // default FALSE
		mmFlags.addCollectionDefinitions(false); // default FALSE

		//Create Map of beams
		ModelMap mmBeams;
		Entity entBeams[0];
		for(int b=0;b<bmAll.length();b++)
		{
			entBeams.append(bmAll[b]);
		}
		entBeams.append(el);
		mmBeams.setEntities(entBeams);
		mmBeams.dbComposeMap(mmFlags);
		
		Map mpBeams;
		mpBeams=mmBeams.map();
		//mpBeams.writeToDxxFile(_kPathDwg+"\\mpBeams.dxx");			
		Map mapIn;
		mapIn.setMap("Beams",mpBeams);
		mapIn.setString("Company", _kPathHsbCompany);
		mapIn.setString("Catalogue",sShowJoistReferences);
		
		//mpOut.writeToDxxFile(_kPathDwg+"\\JoistRef.dxx");
		//Call method
		Map mapOut= callDotNetFunction2(strAssemblyPath, strType, strFunction, mapIn);
		
		//Populate array
		if(mapOut.hasMap("BeamType[]"))
		{
			Map mpBeamTypes=mapOut.getMap("BeamType[]");
			for(int m=0;m<mpBeamTypes.length();m++)
			{
				if(mpBeamTypes.keyAt(m)=="BeamType")
				{
					Map mpBeamType=mpBeamTypes.getMap(m);
					String sHandle=mpBeamType.getString("HANDLE");
					int nCode=mpBeamType.getInt("CODE");
					sJoistHandles.append(sHandle);
					nJoistReferences.append(nCode);
				}
				
			}
		}
		else if (mapOut.hasMap("Errors"))
		{
			Map mpError=mapOut.getMap("Errors");
			String sErrorMessage = T("|Error at| ") +scriptName() + "\n" + T("|Please contact support.|") + "\n" + T("|Posnum will be used as beam reference.|") + "\n" +mpError.getString("Message");
			reportNotice(sErrorMessage);
		}
		
		//In case there is no catalogue found
		if(nJoistReferences.length()==0) bShowJoistReferences=FALSE;
	}
	else
	{
		bShowJoistReferences=FALSE;
	}
}

String strAllKeys[0];
int nQtyThisSA[0];
Beam bmMainSA[0];
String sPosNumSA[0];
double dWidthSA[0];
double dHeightSA[0];
double dLengthSA[0];
Vector3d vecBmX[0];

Point3d ptLocation[0];
String sPosNumToShow[0];
Vector3d vMove[0];

TslInst tslAll[]=el.tslInst();

String sHandlesToIgnore[0];

for (int i = 0; i < tslAll.length(); i++)
{
	TslInst tsl = tslAll[i];
	if (tsl.scriptName() == "hsb_SpaceStudAssembly" || tsl.scriptName() == "GC-SpaceStudAssembly")
	{
		Map mp = tsl.map();
		if (mp.hasString("SpaceStudAssembly"))
		{
			GenBeam gbmThisTSL[] = tsl.genBeam();
			String sThisKey = mp.getString("SpaceStudAssembly");
			int nLoc = strAllKeys.find(sThisKey, - 1);
			if (nLoc != -1)
			{
				nQtyThisSA[nLoc]++;
				if (bShowBmPosnum == 1)
				{
					ptLocation.append(tsl.ptOrg());
					sPosNumToShow.append(tsl.posnum());
					vecBmX.append(_YW);
					vMove.append(_XW);
				}
			}
			else
			{
				strAllKeys.append(sThisKey);
				nQtyThisSA.append(1);
				Beam bmThisTSL[] = tsl.beam();
				bmMainSA.append(bmThisTSL[0]);
				
				sPosNumSA.append(tsl.posnum());
				dWidthSA.append(mp.getDouble("Width"));
				dHeightSA.append(mp.getDouble("Height"));
				dLengthSA.append(mp.getDouble("Length"));
				if (bShowBmPosnum == 1)
				{
					ptLocation.append(tsl.ptOrg());
					sPosNumToShow.append(tsl.posnum());
					vecBmX.append(_YW);
					Vector3d vec = bmThisTSL[0].vecX();
					vec.transformBy(ms2ps);
					vec.normalize();
					vMove.append(vec);
					//Tag the Beams that doesnt need to be shown
					
				}
			}
			for (int b = 0; b < gbmThisTSL.length(); b++)
			{
				sHandlesToIgnore.append(gbmThisTSL[b].handle());
			}
		}
	}
	//Add support to the AssemblyDefinition TSL
	if (tsl.scriptName() == "AssemblyDefinition")
	{
		Map mp = tsl.map();
		if (mp.hasString("compareKey"))
		{
			Entity entThisAssembly[] = tsl.entity();
			String sThisKey = mp.getString("compareKey");
			int nLoc = strAllKeys.find(sThisKey, - 1);
			if (nLoc != -1)
			{
				nQtyThisSA[nLoc]++;
				if (bShowBmPosnum == 1)
				{
					ptLocation.append(tsl.ptOrg());
					sPosNumToShow.append(tsl.posnum());
					vecBmX.append(_YW);
					vMove.append(_XW);
				}
			}
			else
			{
				strAllKeys.append(sThisKey);
				nQtyThisSA.append(1);
				for (int b = 0; b < entThisAssembly.length(); b++)
				{
					if (entThisAssembly[b].bIsKindOf(Beam()) )
					{
						Beam bmThisTSL = (Beam) entThisAssembly[b];
						bmMainSA.append(bmThisTSL);
						break;
					}
				}
				
				//sPosNumSA.append(tsl.posnum());
				sPosNumSA.append(mp.getString("Name"));
				dWidthSA.append(mp.getDouble("Width"));
				dHeightSA.append(mp.getDouble("Height"));
				dLengthSA.append(mp.getDouble("Length"));
				if (bShowBmPosnum == 1)
				{
					ptLocation.append(tsl.ptOrg());
					sPosNumToShow.append(tsl.posnum());
					vecBmX.append(_YW);
					Vector3d vec = tsl.coordSys().vecX();
					vec.transformBy(ms2ps);
					vec.normalize();
					vMove.append(vec);
					//Tag the Beams that doesnt need to be shown
					
				}
			}
			for (int b = 0; b < entThisAssembly.length(); b++)
			{
				sHandlesToIgnore.append(entThisAssembly[b].handle());
			}
		}
	}
}

Point3d ptDraw=_Pt0;
double dFirstColumnTableWidth=0;

String sTitle="Prefabricated Cuts";
double dTxtH=dp.textHeightForStyle(sTitle, sDimStyle);

Map mpBeams;
if (nDoBeams) //zone 0
{
	for (int i=0; i<bmAll.length(); i++)
	{
		Beam bm=bmAll[i];
		int nBmType;
		if(nSip || nSipRoof)
		{
			String sName=bm.name();
			sName.trimLeft();
			sName.trimRight();
			sName.makeUpper();
			int nFound=sLevelName.find(sName);
			if(nFound!=-1)
			{
				nBmType=nBeamType[nFound];
			}
			else
			{
				nBmType=9999;
			}
		}
		else
		{
			nBmType=bm.type();
		}
		
		int nAvoid=nBeamTypeToAvoid.find(nBmType, -1);
		if (nAvoid!=-1)
			continue;
		
		if (sHandlesToIgnore.find(bm.handle(), -1) != -1)
			continue;
		
		int nThisZone=bm.myZoneIndex();
		if (nRealZoneFilter.find(nThisZone, 99)!=99)//Exclude all the sheets that are in the array of zones to exclude.
			continue;
		
		int nLocation=nBeamType.find(nBmType, -1);
		if (nLocation!=-1)
		{
			//It's one of the groups from above
			int nLevelValue=nLevel[nLocation];
			if (nVisible[nLevelValue])
			{
				String sBeamCategory=sLevelName[nLevelValue];
				mpBeams.appendEntity(sBeamCategory, bm);
			}
		}
		else
		{
			//Generic Beam
			mpBeams.appendEntity("Generic", bm);
		}
	}
	
	if (sLevelName.length()>0)
	{
		dp.draw(sTitle,ptDraw,_XW,_YW,1,-1);
		ptDraw=ptDraw-_YW*(dTxtH*1.5);
	}
	
	//Create temporary arrays that can be sorted so that it displays the posnums for the smallest timbers first
	double dLengthForPosnum[0];
	String sDisplayForPosnum[0];
	Point3d ptForPosnum[0];
	Vector3d vecForPosnum[0];
	Vector3d vecMoveForPosnum[0];
	
	for (int t=0; t<sLevelName.length(); t++)
	{
		String sGroupName=sLevelName[t];
		Beam arBeam[0];
		
		// build lists of items to display
		int nNum = 0; // number of different items; make sure nNum is always the size of the arrays
		int arCount[0]; // counter of equal
		
		String arPos[0]; // posnum
		String arW[0]; // width
		String arH[0]; // height
		String arL[0]; // length or height
		String arWToShow[0];
		String arHToShow[0];
		double arDLength[0];
		String arShortLength[0];
		String arProfileName[0];
		String arCN[0];
		String arCP[0];
		String arMaterial[0];
		String arGrade[0];
		String arLabel[0];
		String arName[0];
		
		double dTxtLCount=0;
		double dTxtLPos=0;
		double dTxtLW=0;
		double dTxtLL=0;
		double dTxtLCN=0;
		double dTxtLShortLength=0;
		double dTxtLMaterial=0;
		double dTxtLGrade=0;
		double dTxtLLabel=0;
		double dTxtLName=0;
		
		//ptLocation
		//sPosNumToShow
		for (int m=0; m<mpBeams.length(); m++)
		{
			if (mpBeams.keyAt(m)==sGroupName)
			{
				Entity ent=mpBeams.getEntity(m);
				Beam bmFromMp=(Beam) ent;
				if (bmFromMp.bIsValid())
					arBeam.append(bmFromMp);
			}
		}// End Map Beams Loop
		
		//Add the information from the space stud instead of from the beams
		
		//String strAllKeys[0];
		//int nQtyThisSA[0];
		//Beam bmMainSA[0];
		//String sPosNumSA[0];
		//double dWidthSA[0];
		//double dHeightSA[0];
		//double dLengthSA[0];
		
		int nStud=false;
		// HSB-20904
		if (sGroupName==sSpaceStudHeaderName)
		{
			for (int i=0; i<strAllKeys.length(); i++)
			{
				// a new item for the list is found
				String strPos = String(sPosNumSA[i]);
				String sSubLabel2 = bmMainSA[i].information();
				sSubLabel2.trimLeft(); sSubLabel2.trimRight();
				sSubLabel2.makeUpper();
				if (strPos=="-1") strPos = "";
				
				double dLength1=dLengthSA[i];
				String strLength; strLength.formatUnit(dLength1, sDimStyle);
				String strShortLength; strShortLength.formatUnit(dLength1, sDimStyle);
				
				String strWidth; strWidth.formatUnit(dWidthSA[i], sDimStyle);
				if (sSubLabel2!="EWP")
					arWToShow.append(strWidth.formatUnit(ceil(dWidthSA[i]-dTolerance), 2,0));
				else
					arWToShow.append(strWidth);
				
				String strHeight; strHeight.formatUnit(dHeightSA[i], sDimStyle);
				if (sSubLabel2!="EWP")
					arHToShow.append(strHeight.formatUnit(ceil(dHeightSA[i]-dTolerance), 2,0));
				else
					arHToShow.append(strHeight);
				
				arCount.append(nQtyThisSA[i]);
				arW.append(strWidth);
				arL.append(strLength);
				arDLength.append(dLength1);
				arProfileName.append(_kExtrProfRectangular);
				arShortLength.append(strShortLength);
				
				arPos.append(strPos);
				arH.append(strHeight);
				//arCN.append(bmMainSA[i].strCutN());
				//arCP.append(bmMainSA[i].strCutP());
				
				// AJ 27.04.2011				
				String sCutN=bmMainSA[i].strCutN(); 
				
				String sCutP=bmMainSA[i].strCutP(); 			
				String sCutNC=bmMainSA[i].strCutNC(); 			
				String sCutPC=bmMainSA[i].strCutPC(); 			
				String sNewCutN=sCutN; 			
				String sNewCutP=sCutP; 			
				String sNewCutNC=sCutNC; 			
				String sNewCutPC=sCutPC;
				
				//CutN 
				double dValueN;
				String sValueN;
				String sNewValueN;
				
				sValueN=sCutN.token(0, ">"); 
				dValueN=sValueN.atof(); 	
				sNewValueN.formatUnit(dValueN, 2, 0);
				sNewCutN=sNewValueN; 
				sNewCutN+=">"; 
				sValueN=sCutN.token(1, ">"); 
				dValueN=sValueN.atof();
				sNewValueN.formatUnit(dValueN, 2, 0);
				sNewCutN+=sNewValueN;
				
				//CutP
				double dValueP;
				String sValueP;
				String sNewValueP;
				
				sValueP=sCutP.token(0, ">"); 
				dValueP=sValueP.atof(); 	
				sNewValueP.formatUnit(dValueP, 2, 0);
				sNewCutP=sNewValueP; 
				sNewCutP+=">"; 
				sValueP=sCutN.token(1, ">"); 
				dValueP=sValueP.atof();
				sNewValueP.formatUnit(dValueP, 2, 0);
				sNewCutP+=sNewValueP;	
				
				if (nCompAngle) 			
				{   				
					//CutN 
					double dValue;
					String sValue;
					String sNewValue; 
					
					sValue=sCutN.token(0, ">"); 
					dValue=sValue.atof(); 	
					if (dValue<0) 
						dValue=-90-dValue; 
					else 
						dValue=90-dValue; 
					sNewValue.formatUnit(dValue, 2, 0);
					sNewCutN=sNewValue; 
					sNewCutN+=">"; 
					sValue=sCutN.token(1, ">"); 
					dValue=sValue.atof(); 
					if (dValue<0) 
						dValue=-90-dValue; 
					else 
						dValue=90-dValue; 
					sNewValue.formatUnit(dValue, 2, 0);
					sNewCutN+=sNewValue; 
					
					//CutP
					sValue=sCutP.token(0, ">"); 
					dValue=sValue.atof(); 	
					if (dValue<0) 
						dValue=-90-dValue; 
					else 
						dValue=90-dValue; 
					sNewValue.formatUnit(dValue, 2, 0);
					sNewCutP=sNewValue; 
					sNewCutP+=">"; 
					sValue=sCutP.token(1, ">"); 
					dValue=sValue.atof(); 
					if (dValue<0) 
						dValue=-90-dValue; 
					else 
						dValue=90-dValue; 
					sNewValue.formatUnit(dValue, 2, 0);
					sNewCutP+=sNewValue; 
	
					//CutNC
					sValue=sCutNC.token(0, ">"); 
					dValue=sValue.atof(); 	
					if (dValue<0) 
						dValue=-90-dValue; 
					else 
						dValue=90-dValue; 
					sNewValue.formatUnit(dValue, 2, 0);
					sNewCutNC=sNewValue; 
					sNewCutNC+=">"; 
					sValue=sCutNC.token(1, ">"); 
					dValue=sValue.atof(); 
					if (dValue<0) 
						dValue=-90-dValue; 
					else 
						dValue=90-dValue; 
					sNewValue.formatUnit(dValue, 2, 0);
					sNewCutNC+=sNewValue; 
					
					//CutPC
					sValue=sCutPC.token(0, ">"); 
					dValue=sValue.atof(); 	
					if (dValue<0) 
						dValue=-90-dValue; 
					else 
						dValue=90-dValue; 
					sNewValue.formatUnit(dValue, 2, 0);
					sNewCutPC=sNewValue; 
					sNewCutPC+=">"; 
					sValue=sCutPC.token(1, ">"); 
					dValue=sValue.atof(); 
					if (dValue<0) 
						dValue=-90-dValue; 
					else 
						dValue=90-dValue; 
					sNewValue.formatUnit(dValue, 2, 0);
					sNewCutPC+=sNewValue; 
				} 
	
				arCN.append(sNewCutN);
				arCP.append(sNewCutP);
				
				arMaterial.append(bmMainSA[i].material());
				arGrade.append(bmMainSA[i].grade());
				arLabel.append(bmMainSA[i].label());
				arName.append(bmMainSA[i].name());
		
				//Check the space needed for the table
				double dAux=dp.textLengthForStyle("Amount", sDimStyle);
				if (dTxtLCount < dAux)
					dTxtLCount = dAux;
					
				dAux=dp.textLengthForStyle(strPos, sDimStyle);
				if (dTxtLPos < dAux)
					dTxtLPos= dAux;
		
				dAux=dp.textLengthForStyle(arWToShow[arWToShow.length()-1]+ " x " +arHToShow[arHToShow.length()-1], sDimStyle);
				if (dTxtLW < dAux)
					dTxtLW= dAux;
		
				dAux=dp.textLengthForStyle(strLength, sDimStyle);
				if (dTxtLL< dAux)
					dTxtLL= dAux;
					
	//			dAux=dp.textLengthForStyle(bmMainSA[i].strCutN()+" - "+bmMainSA[i].strCutP(), sDimStyle);
				dAux=dp.textLengthForStyle(sNewCutN+" - "+sNewCutP, sDimStyle);			
				if (dTxtLCN< dAux)
					dTxtLCN= dAux;
				
				dAux=dp.textLengthForStyle(strShortLength, sDimStyle);			
				if (dTxtLShortLength< dAux)
					dTxtLShortLength= dAux;
				
				dAux=dp.textLengthForStyle(bmMainSA[i].material(), sDimStyle);
				if (dTxtLMaterial < dAux)
					dTxtLMaterial= dAux;	
				
				dAux=dp.textLengthForStyle(bmMainSA[i].grade(), sDimStyle);
				if (dTxtLGrade < dAux)
					dTxtLGrade= dAux;
		
				dAux=dp.textLengthForStyle(bmMainSA[i].label(), sDimStyle);
				if (dTxtLLabel < dAux)
					dTxtLLabel= dAux;
					
				dAux=dp.textLengthForStyle(bmMainSA[i].name(), sDimStyle);
				if (dTxtLName < dAux)
					dTxtLName= dAux;
				
				nStud=true;
			}
			
		}
		
		//reportNotice("\n"+sGroupName+" "+arBeam.length());
		
		for (int i=0; i<arBeam.length(); i++)
		{
			// loop over list items
			int bNew = TRUE;
			Beam bm = arBeam[i];
			int nThisZone = bm.myZoneIndex();
			if (nThisZone != 0)
			{
				if (bShowShPosnum)
				{
					if (nThisZone == nZone)
					{
						//						ptLocation.append(bm.ptCenSolid() + bm.vecX() * (bm.dL() * 0.25));//sh.ptCen() + sh.dL() / 4 * sh.vecX()
						//						sPosNumToShow.append(String(bm.posnum()));
						//						vecBmX.append(_XW);
						//						vMove.append(_XW);
						dLengthForPosnum.append(bm.solidLength());
						sDisplayForPosnum.append(String(bm.posnum()));
						ptForPosnum.append(bm.ptCen());
						if (nOrientation == 0)
						{
							vecForPosnum.append(_XW);
							Vector3d vec = bm.vecX();
							vec.transformBy(ms2ps);
							vec.normalize();
							vecMoveForPosnum.append(vec);
						}
						else
						{
							Vector3d vec = bm.vecX();
							vec.transformBy(ms2ps);
							vec.normalize();
							vecMoveForPosnum.append(vec);
							Vector3d vtempdir = _XW + _YW;
							vtempdir.normalize();
							if (vec.dotProduct(vtempdir) < 0)
							{
								vec = - vec;
							}
							vecForPosnum.append(vec);
						}
					}
				}
			}
			else
			{
				if (bShowBmPosnum == 1)
				{
					dLengthForPosnum.append(bm.solidLength());
					sDisplayForPosnum.append(String(bm.posnum()));
					ptForPosnum.append(bm.ptCen());
					if (nOrientation == 0)
					{
						vecForPosnum.append(_XW);
						Vector3d vec = bm.vecX();
						vec.transformBy(ms2ps);
						vec.normalize();
						vecMoveForPosnum.append(vec);
					}
					else
					{
						Vector3d vec = bm.vecX();
						vec.transformBy(ms2ps);
						vec.normalize();
						vecMoveForPosnum.append(vec);
						Vector3d vtempdir = _XW + _YW;
						vtempdir.normalize();
						if (vec.dotProduct(vtempdir) < 0)
						{
							vec = -vec;
						}
						vecForPosnum.append(vec);
					}
				}
				else if (bShowBmPosnum == 2) //Show Length
				{
					double dSolidLength = bm.solidLength();
					String sSolidLength;
					sSolidLength.formatUnit(dSolidLength, 2, 0);
					
					dLengthForPosnum.append(bm.solidLength());
					sDisplayForPosnum.append(sSolidLength);
					ptForPosnum.append(bm.ptCen());
					
					/* Replace in version 1.23 for requirements of ATD with the code below
					if(abs(bm.vecX().dotProduct(el.vecY()))>0.98)
					{
					Vector3d vecAux=el.vecY();
					vecAux.transformBy(ms2ps);
					vecAux.normalize();
					
					vecForPosnum.append(vecAux);
					Vector3d vec=bm.vecX();
					vec.transformBy(ms2ps);	
					vec.normalize();				
					vecMoveForPosnum.append(vec);
					
					}
					else
					{
					vecForPosnum.append(_XW);
					Vector3d vec=bm.vecX();
					vec.transformBy(ms2ps);	
					vec.normalize();									
					vecMoveForPosnum.append(vec);
					}
					*/
					
					if (nOrientation == 0)
					{
						vecForPosnum.append(_XW);
						Vector3d vec = bm.vecX();
						vec.transformBy(ms2ps);
						vec.normalize();
						vecMoveForPosnum.append(vec);
					}
					else
					{
						Vector3d vec = bm.vecX();
						vec.transformBy(ms2ps);
						vec.normalize();
						vecMoveForPosnum.append(vec);
						Vector3d vtempdir = _XW + _YW;
						vtempdir.normalize();
						if (vec.dotProduct(vtempdir) < 0)
						{
							vec = -vec;
						}
						vecForPosnum.append(vec);
					}
					
				}
			}
			
			for (int l=0; l<nNum; l++)
			{
				String strPos;
				if(bShowJoistReferences)
				{
					String sHandle=bm.handle();
	
					int nFoundCode=sJoistHandles.find(sHandle);
	
					if(nFoundCode!=-1)
					{
						String sJoistReference=nJoistReferences[nFoundCode];
						strPos=sJoistReference;
					}
					else
					{
						strPos="-1";
					}
				}
				else
				{
					strPos = String(bm.posnum());
				}
				if (strPos=="-1") strPos = "";
	
				//String strLength; strLength.formatUnit(bm.solidLength(), nLunit, nPrec);
				String strLength; strLength.formatUnit(bm.solidLength(), sDimStyle);
				String strWidth; strWidth.formatUnit(bm.dW(),sDimStyle);
				String strHeight; strHeight.formatUnit(bm.dH(),sDimStyle);
				String strSubLabel2 = bm.information();
				strSubLabel2.trimLeft();
				strSubLabel2.trimRight();
				strSubLabel2.makeUpper();
				if (strSubLabel2 != "EWP")
				{
					strWidth.formatUnit(ceil(bm.dW()-dTolerance), 2, 0);
					strHeight.formatUnit(ceil(bm.dH()-dTolerance), 2, 0);
				}
				
				
				if(nGrouping==1)
				{ 
					if ( (strPos == arPos[l]))
					{
						bNew = FALSE;
						arCount[l]++;
						break; //out of inner for loop, we have found the equal one
					}
				}
				else
				{
					if ( (strHeight == arH[l]) && (strPos == arPos[l]) && (strWidth == arW[l]) && (strLength == arL[l]))
					{
						bNew = FALSE;
						arCount[l]++;
						break; //out of inner for loop, we have found the equal one
					}
				}
			}
			
			if (bNew)
			{ // a new item for the list is found
				String strPos = String(bm.posnum());
				String sSubLabel2 = bm.information();
				sSubLabel2.trimLeft(); sSubLabel2.trimRight();
				sSubLabel2.makeUpper();
				if (strPos=="-1") strPos = "";
	
				double dLength1=bm.solidLength();
				//String strLength; strLength.formatUnit(dLength1, nLunit, nPrec);
				String strLength; strLength.formatUnit(dLength1, sDimStyle);
				String strShortLength; strShortLength.formatUnit(dLength1, sDimStyle);
				String sProfileName = ExtrProfile(bm.extrProfile()).timberName(); ////HERE
				if (sProfileName=="")
					sProfileName = _kExtrProfRectangular;
				String strWidth; strWidth.formatUnit(bm.dW(), sDimStyle);
				if (sSubLabel2!="EWP")
					arWToShow.append(strWidth.formatUnit(ceil(bm.dW()-dTolerance), 2,0));
				else
					arWToShow.append(strWidth);
				
				String strHeight; strHeight.formatUnit(bm.dH(), sDimStyle);
				if (sSubLabel2!="EWP")
				{
					arHToShow.append(strHeight.formatUnit(ceil(bm.dH()-dTolerance), 2,0));
				}
				else
				{
					arHToShow.append(strHeight);
				}
				//Calculate the shortest Length
				String sShortestLengthNew="12345";
				int nIsFillet=false;
				int nFilletAngle=0;
				
				AnalysedTool allTools[0];
				allTools.append(bm.analysedTools());
				for (int t=0; t<allTools.length(); t++)
				{
					if (allTools[t].toolType()=="AnalysedCut")
					{
						AnalysedCut ct = (AnalysedCut) allTools[t];
						Vector3d ctNormal = ct.normal();
						Vector3d bmVecX = bm.vecX();
						Vector3d bmVecY = bm.vecY();
						Vector3d bmVecZ = bm.vecZ();

						if (
							abs(ctNormal.dotProduct(bmVecX))<0.01 &&
							!(abs(ctNormal.dotProduct(bmVecY))>0.99 || abs(ctNormal.dotProduct(-bmVecY))>0.99) &&
							!(abs(ctNormal.dotProduct(bmVecZ))>0.99 || abs(ctNormal.dotProduct(-bmVecZ))>0.99)								
						   )
						{
							if (bm.type()==_kTRWedge)
							{
								nIsFillet=true;
								Vector3d vecAux=bm.vecD(ct.normal());
								double angle = vecAux.angleTo(ct.normal());
								nFilletAngle= round(angle);
								continue;
							}
						}
					}
				}

				if (bShowShortLength)
				{
					sShortestLengthNew="";

					Point3d ptUp[0];
					Point3d ptDown[0];
					for (int t=0; t<allTools.length(); t++)
					{
						if (allTools[t].toolType()=="AnalysedCut")
						{
							AnalysedCut ct = (AnalysedCut) allTools[t];
					
							Plane plnThisCut (ct.ptOrg(), ct.normal());
							PlaneProfile ppThisCut=bm.envelopeBody(false, false).getSlice(plnThisCut);
							
							Point3d ptIntersection[]=ppThisCut.getGripVertexPoints();
							Vector3d ctNormal = ct.normal();
							Vector3d bmVecX = bm.vecX();
							if (abs(ctNormal.dotProduct(bmVecX))<0.01)
							{
								continue;
							}
							
							if (bmVecX.dotProduct(ctNormal)>0)
							{
								ptUp.append(ptIntersection);
							}
							else
							{
								ptDown.append(ptIntersection);
							}
						}
					}
					double dAuxShortest=U(100000);
					for (int k=0; k<ptUp.length()-1; k++)
						for (int l=k+1; l<ptDown.length(); l++)
						{
							if (abs(bm.vecX().dotProduct(ptUp[k]-ptDown[l]))<dAuxShortest)
								dAuxShortest=abs(bm.vecX().dotProduct(ptUp[k]-ptDown[l]));
						}
					sShortestLengthNew.formatUnit(dAuxShortest, sDimStyle);
				}
				
				arCount.append(1);
				arW.append(strWidth);
				arL.append(strLength);
				arDLength.append(dLength1);
				arShortLength.append(sShortestLengthNew);
				arProfileName.append(sProfileName);
				
				//Check if we need to use Joist References from the exportoer
				if(bShowJoistReferences)
				{
					String sHandle=bm.handle();
	
					int nFoundCode=sJoistHandles.find(sHandle);
	
					if(nFoundCode!=-1)
					{
						String sJoistReference=nJoistReferences[nFoundCode];
						arPos.append(sJoistReference);
					}
					else
					{
						arPos.append("-1");
					}
					
				}
				else
				{
					arPos.append(strPos);
				}
				arH.append(strHeight);
				//arCN.append(bm.strCutN());
				//arCP.append(bm.strCutP());
				
				// AJ 27.04.2011				
				String sCutN=bm.strCutN(); 			
				String sCutP=bm.strCutP(); 			
				String sCutNC=bm.strCutNC(); 			
				String sCutPC=bm.strCutPC(); 			
				String sNewCutN=sCutN; 			
				String sNewCutP=sCutP; 			
				String sNewCutNC=sCutNC; 			
				String sNewCutPC=sCutPC; 
				
				//CutN
				double dValueN;
				String sValueN;
				String sNewValueN;
				
				sValueN=sCutN.token(0, ">"); 
				dValueN=sValueN.atof(); 	
				sNewValueN.formatUnit(dValueN, 2, 0);
				sNewCutN=sNewValueN; 
				sNewCutN+=">"; 
				sValueN=sCutN.token(1, ">"); 
				dValueN=sValueN.atof();
				sNewValueN.formatUnit(dValueN, 2, 0);
				sNewCutN+=sNewValueN;
				
				//CutP
				double dValueP;
				String sValueP;
				String sNewValueP;
				
				sValueP=sCutP.token(0, ">"); 
				dValueP=sValueP.atof(); 	
				sNewValueP.formatUnit(dValueP, 2, 0);
				sNewCutP=sNewValueP; 
				sNewCutP+=">"; 
				sValueP=sCutP.token(1, ">"); 
				dValueP=sValueP.atof(); 
				sNewValueP.formatUnit(dValueP, 2, 0);
				sNewCutP+=sNewValueP;	
										
				if (nCompAngle) 			
				{   				
					//CutN 
					double dValue;
					String sValue;
					String sNewValue; 
					
					sValue=sCutN.token(0, ">"); 
					dValue=sValue.atof(); 	
					if (dValue<0) 
						dValue=-90-dValue; 
					else 
						dValue=90-dValue; 
					sNewValue.formatUnit(dValue, 2, 0);
					sNewCutN=sNewValue; 
					sNewCutN+=">"; 
					sValue=sCutN.token(1, ">"); 
					dValue=sValue.atof(); 
					if (dValue<0) 
						dValue=-90-dValue; 
					else 
						dValue=90-dValue; 
					sNewValue.formatUnit(dValue, 2, 0);
					sNewCutN+=sNewValue; 
					
					//CutP
					sValue=sCutP.token(0, ">"); 
					dValue=sValue.atof(); 	
					if (dValue<0) 
						dValue=-90-dValue; 
					else 
						dValue=90-dValue; 
					sNewValue.formatUnit(dValue, 2, 0);
					sNewCutP=sNewValue; 
					sNewCutP+=">"; 
					sValue=sCutP.token(1, ">"); 
					dValue=sValue.atof(); 
					if (dValue<0) 
						dValue=-90-dValue; 
					else 
						dValue=90-dValue; 
					sNewValue.formatUnit(dValue, 2, 0);
					sNewCutP+=sNewValue; 
	
					//CutNC
					sValue=sCutNC.token(0, ">"); 
					dValue=sValue.atof(); 	
					if (dValue<0) 
						dValue=-90-dValue; 
					else 
						dValue=90-dValue; 
					sNewValue.formatUnit(dValue, 2, 0);
					sNewCutNC=sNewValue; 
					sNewCutNC+=">"; 
					sValue=sCutNC.token(1, ">"); 
					dValue=sValue.atof(); 
					if (dValue<0) 
						dValue=-90-dValue; 
					else 
						dValue=90-dValue; 
					sNewValue.formatUnit(dValue, 2, 0);
					sNewCutNC+=sNewValue; 
					
					//CutPC
					sValue=sCutPC.token(0, ">"); 
					dValue=sValue.atof(); 	
					if (dValue<0) 
						dValue=-90-dValue; 
					else 
						dValue=90-dValue; 
					sNewValue.formatUnit(dValue, 2, 0);
					sNewCutPC=sNewValue; 
					sNewCutPC+=">"; 
					sValue=sCutPC.token(1, ">"); 
					dValue=sValue.atof(); 
					if (dValue<0) 
						dValue=-90-dValue; 
					else 
						dValue=90-dValue; 
					sNewValue.formatUnit(dValue, 2, 0);
					sNewCutPC+=sNewValue; 
	
				} 
				
				if (nIsFillet)
				{
					arCN.append(nFilletAngle);
					arCP.append("");
					sNewCutN=nFilletAngle;
					sNewCutP="";
				}
				else
				{
					arCN.append(sNewCutN);
					arCP.append(sNewCutP);
				}
				
				arMaterial.append(bm.material());
				arGrade.append(bm.grade());
				arLabel.append(bm.label());
				arName.append(bm.name());
	
				//Check the space needed for the table
				double dAux=dp.textLengthForStyle("Amount", sDimStyle);
				if (dTxtLCount < dAux)
					dTxtLCount = dAux;
					
				dAux=dp.textLengthForStyle(strPos, sDimStyle);
				if (dTxtLPos < dAux)
					dTxtLPos= dAux;
	
				dAux=dp.textLengthForStyle(arWToShow[arWToShow.length()-1]+ " x " +arHToShow[arHToShow.length()-1], sDimStyle);
				if (dTxtLW < dAux)
					dTxtLW= dAux;
				
				dAux=dp.textLengthForStyle(sProfileName, sDimStyle);
				if (sProfileName != _kExtrProfRectangular &&  dTxtLW < dAux)
					dTxtLW= dAux;
				
				dAux=dp.textLengthForStyle(strLength, sDimStyle);
				if (dTxtLL< dAux)
					dTxtLL= dAux;
				
				dAux=dp.textLengthForStyle(strShortLength, sDimStyle);
				if (dTxtLShortLength< dAux)
					dTxtLShortLength= dAux;	
				
				//	dAux=dp.textLengthForStyle(bm.strCutN()+" - "+bm.strCutP(), sDimStyle);
				dAux=dp.textLengthForStyle(sNewCutN+" - "+sNewCutP, sDimStyle);			
				if (dTxtLCN< dAux)
					dTxtLCN= dAux;
				
				dAux=dp.textLengthForStyle(bm.material(), sDimStyle);
				if (dTxtLMaterial < dAux)
					dTxtLMaterial= dAux;	
				
				dAux=dp.textLengthForStyle(bm.grade(), sDimStyle);
				if (dTxtLGrade < dAux)
					dTxtLGrade= dAux;
	
				dAux=dp.textLengthForStyle(bm.label(), sDimStyle);
				if (dTxtLLabel < dAux)
					dTxtLLabel= dAux;
					
				dAux=dp.textLengthForStyle(bm.name(), sDimStyle);
				if (dTxtLName < dAux)
					dTxtLName= dAux;
	
				nNum++;
			}
		}	
		
		if (arBeam.length()>0 || nStud)
		{
			//The information of that Group is ready to display
			//Display the Title of the Group
			sGroupName.makeLower();
			String sAux1=sGroupName.left(1);
			String sAux2=sGroupName.delete(0,1);
			sAux1.makeUpper();
			sGroupName=sAux1+sAux2;
			dp.draw(sGroupName,ptDraw,_XW,_YW,1,-1);
			ptDraw=ptDraw-_YW*(dTxtH*1.5);
			Point3d ptBaseLine=ptDraw;
			//Check if the title is not bigger than the text on the columns
			double dAux;
			if(bShowJoistReferences)
			{		
				dAux=dp.textLengthForStyle("Joist Ref", sDimStyle);
			}
			else
			{
				dAux=dp.textLengthForStyle("Nr.", sDimStyle);
			}
			if (dTxtLPos < dAux)
				dTxtLPos= dAux;
			
			dAux=dp.textLengthForStyle("Dimension", sDimStyle);
			if ( (dTxtLW) < dAux)
				dTxtLW= dAux;
	
			dAux=dp.textLengthForStyle("Length", sDimStyle);
			if (dTxtLL< dAux)
				dTxtLL= dAux;
			
			dAux=dp.textLengthForStyle("Short L.", sDimStyle);
			if (dTxtLShortLength< dAux)
				dTxtLShortLength= dAux;
				
			dAux=dp.textLengthForStyle("Angle", sDimStyle);
			if (dTxtLCN< dAux)
				dTxtLCN= dAux;
			
			dAux=dp.textLengthForStyle("Material", sDimStyle);
			if (dTxtLMaterial< dAux)
				dTxtLMaterial= dAux;
			
			dAux=dp.textLengthForStyle("Grade", sDimStyle);
			if (dTxtLGrade< dAux)
				dTxtLGrade= dAux;
				
			dAux=dp.textLengthForStyle("Label", sDimStyle);
			if (dTxtLLabel< dAux)
				dTxtLLabel= dAux;
				
			dAux=dp.textLengthForStyle("Name", sDimStyle);
			if (dTxtLName< dAux)
				dTxtLName= dAux;
	
			//Display the Title of each column
			if(bShowJoistReferences)
			{
				dp.draw("Joist Ref",ptBaseLine,_XW,_YW,1,-1);						
			}
			else
			{
				dp.draw("Nr.",ptBaseLine,_XW,_YW,1,-1);			
			}
	
			ptBaseLine=ptBaseLine+_XW*(dTxtLPos+dOffset);
			
			if(bShowLabel)
			{
				dp.draw("Label",ptBaseLine,_XW,_YW,1,-1);
				ptBaseLine=ptBaseLine+_XW*(dTxtLLabel+dOffset);
			}
			
			if(bShowName)
			{
				dp.draw("Name",ptBaseLine,_XW,_YW,1,-1);
				ptBaseLine=ptBaseLine+_XW*(dTxtLName+dOffset);
			}
			
			dp.draw("Dimension",ptBaseLine,_XW,_YW,1,-1);
			ptBaseLine=ptBaseLine+_XW*(dTxtLW+dOffset);
	
			dp.draw("Length",ptBaseLine,_XW,_YW,1,-1);
			ptBaseLine=ptBaseLine+_XW*(dTxtLL+dOffset);
			
			if(bShowShortLength)
			{
				dp.draw("Short L.", ptBaseLine,_XW,_YW,1,-1);
				ptBaseLine=ptBaseLine+_XW*(dTxtLShortLength+dOffset);
			}
			
			if(bShowAngle)
			{
				dp.draw("Angle", ptBaseLine+_XW*(dTxtLCN*0.3),_XW,_YW,1,-1);
				ptBaseLine=ptBaseLine+_XW*(dTxtLCN+dOffset);
			}

			dp.draw("Amount",ptBaseLine,_XW,_YW,1,-1);
			ptBaseLine=ptBaseLine+_XW*(dTxtLCount+dOffset);
			
			if(bShowMaterial)
			{
				dp.draw("Material",ptBaseLine,_XW,_YW,1,-1);
				ptBaseLine=ptBaseLine+_XW*(dTxtLMaterial+dOffset);
			}
			if(bShowGrade)
			{
				dp.draw("Grade",ptBaseLine,_XW,_YW,1,-1);
				ptBaseLine=ptBaseLine+_XW*(dTxtLGrade+dOffset);
			}
			
			dFirstColumnTableWidth=abs(_XW.dotProduct(ptBaseLine-ptDraw));
			
			ptDraw=ptDraw-_YW*(dTxtH*1.5);
			
			
			//Replace the width and height with their nominal values
			//reportNotice("\n"+);
					
			//Sort the Arrays to Display
			
			int nNrOfRows=arPos.length();
			int bAscending=TRUE;
			
			for(int s1=1; s1<nNrOfRows; s1++)
			{
				int s11 = s1;
				for(int s2=s1-1; s2>=0; s2--)
				{
					int bSort = arDLength[s11] > arDLength[s2];
					if( bAscending )
					{
						bSort = arDLength[s11] < arDLength[s2];
					}
					if( bSort )
					{
						arPos.swap(s2, s11);
						arLabel.swap(s2, s11);
						arName.swap(s2, s11);
						arW.swap(s2, s11);
						arH.swap(s2, s11);
						arL.swap(s2, s11);
						arDLength.swap(s2, s11);
						arShortLength.swap(s2, s11);
						arProfileName.swap(s2, s11);
						arCN.swap(s2, s11);
						arCP.swap(s2, s11);
						arCount.swap(s2, s11);
						arMaterial.swap(s2, s11);
						arGrade.swap(s2, s11);
						arWToShow.swap(s2, s11);
						arHToShow.swap(s2, s11);
						
			
						s11=s2;
					}
				}
			}
			
			
			for(int s1=1; s1<nNrOfRows; s1++)
			{
				int s11 = s1;
				for(int s2=s1-1; s2>=0; s2--)
				{
					int bSort = arH[s11] < arH[s2];
					if( bAscending )
					{
						bSort = arH[s11] > arH[s2];
					}
					if( bSort )
					{
						arPos.swap(s2, s11);
						arLabel.swap(s2, s11);
						arName.swap(s2, s11);
						arW.swap(s2, s11);
						arH.swap(s2, s11);
						arL.swap(s2, s11);
						arDLength.swap(s2, s11);
						arShortLength.swap(s2, s11);
						arProfileName.swap(s2, s11);
						arCN.swap(s2, s11);
						arCP.swap(s2, s11);
						arCount.swap(s2, s11);
						arMaterial.swap(s2, s11);
						arGrade.swap(s2, s11);
						arWToShow.swap(s2, s11);
						arHToShow.swap(s2, s11);
	
						s11=s2;
					}
				}
			}
			//End of the sorting

			for (int d=0; d<arPos.length(); d++)
			{
				//reportNotice("\n"+arW[d]);
	
				ptBaseLine=ptDraw;
	
				//Display the Values of each row
				dp.draw(arPos[d],ptBaseLine,_XW,_YW,1,-1);//+_XW*(dTxtLPos*.3)
				ptBaseLine=ptBaseLine+_XW*(dTxtLPos+dOffset);
	
				if(bShowLabel)
				{	
					dp.draw(arLabel[d],ptBaseLine,_XW,_YW,1,-1);//+_XW*(dTxtLGrade*.45)
					ptBaseLine=ptBaseLine+_XW*(dTxtLLabel+dOffset);
				}
				
				if(bShowName)
				{	
					dp.draw(arName[d],ptBaseLine,_XW,_YW,1,-1);//+_XW*(dTxtLGrade*.45)
					ptBaseLine=ptBaseLine+_XW*(dTxtLName+dOffset);
				}
				
				if (arProfileName[d] != _kExtrProfRectangular)
				{ 
					dp.draw(arProfileName[d], ptBaseLine, _XW, _YW, 1 ,- 1);
					ptBaseLine = ptBaseLine + _XW * (dTxtLW + dOffset);
				}
				else
				{
					dp.draw(arWToShow[d] + " x " + arHToShow[d], ptBaseLine, _XW, _YW, 1 ,- 1);
					ptBaseLine = ptBaseLine + _XW * (dTxtLW + dOffset);
				}

		
				dp.draw(arL[d],ptBaseLine,_XW,_YW,1,-1);
				ptBaseLine=ptBaseLine+_XW*(dTxtLL+dOffset);
				
				if(bShowShortLength)
				{		
					dp.draw(arShortLength[d],ptBaseLine,_XW,_YW,1,-1);
					ptBaseLine=ptBaseLine+_XW*(dTxtLShortLength+dOffset);
				}
				
				if(bShowAngle)
				{	
					dp.draw(arCN[d]+" - "+arCP[d],ptBaseLine,_XW,_YW,1,-1);
					ptBaseLine=ptBaseLine+_XW*(dTxtLCN+dOffset);
				}

				dp.draw(arCount[d],ptBaseLine+_XW*(dTxtLCount*.45),_XW,_YW,1,-1);
				ptBaseLine=ptBaseLine+_XW*(dTxtLCount+dOffset);
		
				if(bShowMaterial)
				{	
					dp.draw(arMaterial[d],ptBaseLine,_XW,_YW,1,-1);//+_XW*(dTxtLGrade*.45)
					ptBaseLine=ptBaseLine+_XW*(dTxtLMaterial+dOffset);
				}
		
				if(bShowGrade)
				{	
					dp.draw(arGrade[d],ptBaseLine,_XW,_YW,1,-1);//+_XW*(dTxtLGrade*.45)
					ptBaseLine=ptBaseLine+_XW*(dTxtLGrade+dOffset);
				}
				ptDraw=ptDraw-_YW*(dTxtH*1.5);
	
			}
			ptDraw=ptDraw-_YW*(dTxtH*0.5);
		}
	}//End loop throw all levels
	
	//Sort beams by length from the temporary array
	double dDisplay;
	String sDisplay;
	Point3d ptDisplay;
	Vector3d vecDisplay;
	Vector3d vecMoveDisplay;
	for (int b1=1; b1<dLengthForPosnum.length(); b1++) 
	{
		int lb1 = b1;
		for (int b2 = b1-1; b2>=0; b2--) 
		{
			if (dLengthForPosnum[lb1]<dLengthForPosnum[b2]) 
			{
				dDisplay= dLengthForPosnum[b2]; dLengthForPosnum[b2] = dLengthForPosnum[lb1];  dLengthForPosnum[lb1] = dDisplay;
				sDisplay= sDisplayForPosnum[b2]; sDisplayForPosnum[b2] = sDisplayForPosnum[lb1];  sDisplayForPosnum[lb1] = sDisplay;
				ptDisplay= ptForPosnum[b2]; ptForPosnum[b2] = ptForPosnum[lb1];  ptForPosnum[lb1] = ptDisplay;
				vecDisplay= vecForPosnum[b2]; vecForPosnum[b2] = vecForPosnum[lb1];  vecForPosnum[lb1] = vecDisplay;									
				vecMoveDisplay= vecMoveForPosnum[b2]; vecMoveForPosnum[b2] = vecMoveForPosnum[lb1];  vecMoveForPosnum[lb1] = vecMoveDisplay;													
			      lb1=b2;
		    }
	  	}
	}
	
	//Add points etc for the posnum to the main array
	for(int d=0;d<dLengthForPosnum.length();d++)
	{
		ptLocation.append(ptForPosnum[d]);
		sPosNumToShow.append(sDisplayForPosnum[d]);
		vecBmX.append(vecForPosnum[d]);
		vMove.append(vecMoveForPosnum[d]);
	}		
}//End Beams	


if (nDoSIPs)
{
	Sip spAll[]=el.sip();
	
	Map mpSip;
	
	String strSipStyle[0];
	for (int i=0; i<spAll.length(); i++)
	{
		Sip sp=spAll[i];
		String sStyle=sp.style();
		sStyle.makeUpper();
		int nLocation=strSipStyle.find(sStyle, -1);
		if (nLocation==-1)
		{
			strSipStyle.append(sStyle);
		}
	}
	
	if (strSipStyle.length()>0)
	{
		sTitle="Sip Panels";
		dp.draw(sTitle,ptDraw,_XW,_YW,1,-1);
		ptDraw=ptDraw-_YW*(dTxtH*1.5);
	}
	
	
	for (int t=0; t<strSipStyle.length(); t++)
	{
		String sGroupName=strSipStyle[t];
		Sip arSip[0];
	
		// build lists of items to display
		String arLabel[0]; // label
		String arName[0]; // label
		String arW[0]; // width
		String arH[0]; // length or height
		String arT[0]; // thickness				
		
		double dTxtLLabel=0;
		double dTxtLW=0;
		double dTxtLH=0;
		double dTxtLT=0;
	
		//reportNotice("\n"+sGroupName+" "+arSheet.length());
		
		for (int i=0; i<spAll.length(); i++)
		{
			// loop over list items
			Sip sp = spAll[i];
			String sThisStyle=sp.style();
			sThisStyle.makeUpper();
			
			if (sGroupName!=sThisStyle)
				continue;
			
			PLine plSipShadow = sp.plShadowCnc();
			PlaneProfile ppSipShadow(plSipShadow);
			LineSeg extent = ppSipShadow.extentInDir(sp.vecY());
			double sipWidth = abs((extent.ptEnd() - extent.ptStart()).dotProduct(sp.vecY()));
			double sipHeight = abs((extent.ptEnd() - extent.ptStart()).dotProduct(sp.vecX()));
			if(sipWidth > sipHeight)
			{ 
				double temp = sipHeight;
				sipHeight = sipWidth;
				sipWidth = temp;
			}

			
			//String strLength; strLength.formatUnit(sh.dL(), nLunit, nPrec);
			String sSipLabel=sp.label()+sp.subLabel();
			String sSipName=sp.name();
			
			String strLength; strLength.formatUnit(sipHeight, sDimStyle);
			String strWidth; strWidth.formatUnit(sipWidth, sDimStyle);
			String strThick; strThick.formatUnit(sp.dH(), sDimStyle);
			
			arSip.append(sp);
			
			arLabel.append(sSipLabel);
			arName.append(sSipName);
			arW.append(strWidth);
			arH.append(strLength);
			arT.append(strThick);

			//Check the space needed for the table
			double dAux=dp.textLengthForStyle(sSipLabel, sDimStyle);
			if (dTxtLLabel < dAux)
				dTxtLLabel = dAux;
			dAux=dp.textLengthForStyle(strLength, sDimStyle);
			if (dTxtLH < dAux)
				dTxtLH= dAux;
			dAux=dp.textLengthForStyle(strWidth, sDimStyle);
			if (dTxtLW < dAux)
				dTxtLW= dAux;
			dAux=dp.textLengthForStyle(strThick, sDimStyle);
			if (dTxtLT< dAux)
				dTxtLT= dAux;
		}	
		
		if (arSip.length()>0)
		{
			//The information of that Group is ready to display
			//Display the Title of the Group
			dp.draw(sGroupName,ptDraw,_XW,_YW,1,-1);
			ptDraw=ptDraw-_YW*(dTxtH*1.5);
			Point3d ptBaseLine=ptDraw;
			//Check if the title is not bigger than the text on the columns
			
			double dAux=dp.textLengthForStyle("Label", sDimStyle);
			if (dTxtLLabel  < dAux)
				dTxtLLabel = dAux;
			
			dAux=dp.textLengthForStyle("Width", sDimStyle);
			if ( (dTxtLW) < dAux)
				dTxtLW= dAux;

			dAux=dp.textLengthForStyle("Length", sDimStyle);
			if ( (dTxtLH) < dAux)
				dTxtLH= dAux;

			dAux=dp.textLengthForStyle("Thickness", sDimStyle);
			if (dTxtLT< dAux)
				dTxtLT= dAux;
			
	
			//Display the Title of each column
			dp.draw("Label",ptBaseLine,_XW,_YW,1,-1);
			ptBaseLine=ptBaseLine+_XW*(dTxtLLabel+dOffset);
	
			dp.draw("Width",ptBaseLine,_XW,_YW,1,-1);
			ptBaseLine=ptBaseLine+_XW*(dTxtLW+dOffset);
	
			dp.draw("Length",ptBaseLine,_XW,_YW,1,-1);
			ptBaseLine=ptBaseLine+_XW*(dTxtLH+dOffset);
	
			dp.draw("Thickness",ptBaseLine,_XW,_YW,1,-1);
			ptBaseLine=ptBaseLine+_XW*(dTxtLT+dOffset);
			
			//dp.draw("Amount",ptBaseLine,_XW,_YW,1,-1);
			//ptBaseLine=ptBaseLine+_XW*(dTxtLCount+dOffset);
	
			ptDraw=ptDraw-_YW*(dTxtH*1.5);
			
			//Sort the Arrays to Display
			
			int nNrOfRows=arLabel.length();
			int bAscending=TRUE;
			
			for(int s1=1; s1<nNrOfRows; s1++)
			{
				int s11 = s1;
				for(int s2=s1-1; s2>=0; s2--)
				{
					int bSort = arLabel[s11] > arLabel[s2];
					if( bAscending )
					{
						bSort = arLabel[s11] < arLabel[s2];
					}
					if( bSort )
					{
						arLabel.swap(s2, s11);
						arW.swap(s2, s11);
						arH.swap(s2, s11);
						arT.swap(s2, s11);
			
						s11=s2;
					}
				}
			}
			
			//End of the sorting
			for (int d=0; d<arLabel.length(); d++)
			{
				ptBaseLine=ptDraw;
	
				//Display the Values of each row
				dp.draw(arLabel[d],ptBaseLine,_XW,_YW,1,-1);//+_XW*(dTxtLPos*.3)
				ptBaseLine=ptBaseLine+_XW*(dTxtLLabel+dOffset);
		
				dp.draw(arW[d],ptBaseLine+_XW*(dTxtLW*.5),_XW,_YW,0,-1);
				ptBaseLine=ptBaseLine+_XW*(dTxtLW+dOffset);

				dp.draw(arH[d],ptBaseLine+_XW*(dTxtLH*.5),_XW,_YW,0,-1);
				ptBaseLine=ptBaseLine+_XW*(dTxtLH+dOffset);
		
				dp.draw(arT[d],ptBaseLine+_XW*(dTxtLT*.5),_XW,_YW,0,-1);
				ptBaseLine=ptBaseLine+_XW*(dTxtLT+dOffset);
				
				ptDraw=ptDraw-_YW*(dTxtH*1.5);
	
			}
			ptDraw=ptDraw-_YW*(dTxtH*0.5);
		}
	}//End loop throw all levels
}

if (bTwoColumns &&(nDoBeams && nDoSIPs))
{
	ptDraw=_Pt0+_XW*(dFirstColumnTableWidth+(dOffset*3));
}

if (nDoSheets)
{
	//BOM for Sheetings
	Sheet shAll[]=el.sheet();
	Sheet shValidSheets[0];
	Map mpSheet;
	
	String strSheetNames[0];
	for (int i=0; i<shAll.length(); i++)
	{
		Sheet sh=shAll[i];
		//String sName=sh.name();
		String sMaterial=sh.material();
		sMaterial.makeUpper();
		sMaterial.trimLeft();
		sMaterial.trimRight();
		
		int nThisZone=sh.myZoneIndex();
		if (nRealZoneFilter.find(nThisZone, 99)!=99)//Exclude all the sheets that are in the array of zones to exclude.
			continue;
		
		if (sHandlesToIgnore.find(sh.handle(), -1) != -1)
			continue;
		
		int nLocation=strSheetNames.find(sMaterial, -1);
		if (sArrMaterials.find(sMaterial, -1)==-1)//Filter the material Names
		{
			if (nLocation==-1)
			{
				strSheetNames.append(sMaterial);
			}
		}
		
		shValidSheets.append(sh);
		
		if (bShowShPosnum)
		{
			if (nThisZone==nZone)
			{
				ptLocation.append(sh.ptCenSolid()+ sh.vecX()* (sh.dL()*0.25));//sh.ptCen() + sh.dL()/4 * sh.vecX()
				sPosNumToShow.append(String(sh.posnum()));
				vecBmX.append(_XW);
				vMove.append(_XW);
			}
		}
	}
	
	if (strSheetNames.length()>0)
	{
		sTitle=sSheetingGroupName;
		dp.draw(sTitle,ptDraw,_XW,_YW,1,-1);
		ptDraw=ptDraw-_YW*(dTxtH*1.5);
	}
	
	
	for (int t=0; t<strSheetNames.length(); t++)
	{
		String sGroupName=strSheetNames[t];
		Sheet arSheet[0];
	
		// build lists of items to display
		int nNum = 0; // number of different items; make sure nNum is always the size of the arrays
		int arCount[0]; // counter of equal
	
		String arPos[0]; // posnum
		String arW[0]; // width
		String arT[0]; // thickness
		String arL[0]; // length or height
		
		double dTxtLCount=0;
		double dTxtLPos=0;
		double dTxtLW=0;
		double dTxtLT=0;
	
		for (int m=0; m<shValidSheets.length(); m++)
		{
			String sThisMaterial=shValidSheets[m].material();
			sThisMaterial.makeUpper();
			sThisMaterial.trimLeft();
			sThisMaterial.trimRight();
			if (sThisMaterial==sGroupName)
			{
				arSheet.append(shValidSheets[m]);
			}
		}// End Map Beams Loop
		
		//reportNotice("\n"+sGroupName+" "+arSheet.length());
		
		for (int i=0; i<arSheet.length(); i++)
		{
			// loop over list items
			int bNew = TRUE;
			Sheet sh = arSheet[i];
			for (int l=0; l<nNum; l++)
			{
				String strPos = String(sh.posnum());
				if (strPos=="-1") strPos = "";
	
				//String strLength; strLength.formatUnit(sh.dL(), nLunit, nPrec);
				String strLength; strLength.formatUnit(sh.solidLength(), sDimStyle);
				String strWidth; strWidth.formatUnit(sh.solidWidth(),sDimStyle);
				String strThick; strThick.formatUnit(sh.solidHeight(),sDimStyle);
				if (nGrouping == 1)
				{
					if ( strPos == arPos[l])
					{
						bNew = FALSE;
						arCount[l]++;
						break; //out of inner for loop, we have found the equal one
					}
				}
				else
				{
					if ( (strThick == arT[l]) && (strPos == arPos[l]) && (strWidth == arW[l]) && (strLength == arL[l]))
					{
						bNew = FALSE;
						arCount[l]++;
						break; //out of inner for loop, we have found the equal one
					}
				}
			}
			if (bNew)
			{ // a new item for the list is found
				String strPos = String(sh.posnum());
				strPos.trimLeft();
				strPos.trimRight();
				if (strPos=="-1") strPos = "";
				
				//String strLength; strLength.formatUnit(sh.dL(), nLunit, nPrec);
				String strLength; strLength.formatUnit(sh.solidLength(), sDimStyle);
				String strWidth; strWidth.formatUnit(sh.solidWidth(), sDimStyle);
				String strThick; strThick.formatUnit(sh.solidHeight(), sDimStyle);
				arCount.append(1);
				arW.append(strWidth);
				arL.append(strLength);
				arPos.append(strPos);
				arT.append(strThick);
	
				//Check the space needed for the table
				double dAux=dp.textLengthForStyle("Amount", sDimStyle);
				if (dTxtLCount < dAux)
					dTxtLCount = dAux;
				dAux=dp.textLengthForStyle(strPos, sDimStyle);
				if (dTxtLPos < dAux)
					dTxtLPos= dAux;
				dAux=dp.textLengthForStyle(strWidth+ " x " +strLength, sDimStyle);
				if (dTxtLW < dAux)
					dTxtLW= dAux;
	
				dAux=dp.textLengthForStyle(strThick, sDimStyle);
				if (dTxtLT< dAux)
					dTxtLT= dAux;
	
				nNum++;
			}
		}	
		
		if (arSheet.length()>0)
		{
			//The information of that Group is ready to display
			//Display the Title of the Group
			dp.draw(sGroupName,ptDraw,_XW,_YW,1,-1);
			ptDraw=ptDraw-_YW*(dTxtH*1.5);
			Point3d ptBaseLine=ptDraw;
			//Check if the title is not bigger than the text on the columns
			
			double dAux=dp.textLengthForStyle("Nr.", sDimStyle);
			if (dTxtLPos < dAux)
				dTxtLPos= dAux;
			
			dAux=dp.textLengthForStyle("Dimension", sDimStyle);
			if ( (dTxtLW) < dAux)
				dTxtLW= dAux;
	
			dAux=dp.textLengthForStyle("Thickness", sDimStyle);
			if (dTxtLT< dAux)
				dTxtLT= dAux;
			
	
			//Display the Title of each column
			dp.draw("Nr.",ptBaseLine,_XW,_YW,1,-1);
			ptBaseLine=ptBaseLine+_XW*(dTxtLPos+dOffset);
	
			dp.draw("Dimension",ptBaseLine,_XW,_YW,1,-1);
			ptBaseLine=ptBaseLine+_XW*(dTxtLW+dOffset);
	
			dp.draw("Thickness",ptBaseLine,_XW,_YW,1,-1);
			ptBaseLine=ptBaseLine+_XW*(dTxtLT+dOffset);
			
	
			dp.draw("Amount",ptBaseLine,_XW,_YW,1,-1);
			ptBaseLine=ptBaseLine+_XW*(dTxtLCount+dOffset);
	
			ptDraw=ptDraw-_YW*(dTxtH*1.5);
					
			for (int d=0; d<arPos.length(); d++)
			{
				ptBaseLine=ptDraw;
	
				//Display the Values of each row
				dp.draw(arPos[d],ptBaseLine,_XW,_YW,1,-1);//+_XW*(dTxtLPos*.3)
				ptBaseLine=ptBaseLine+_XW*(dTxtLPos+dOffset);
		
				dp.draw(arW[d]+" x "+arL[d],ptBaseLine,_XW,_YW,1,-1);
				ptBaseLine=ptBaseLine+_XW*(dTxtLW+dOffset);
		
				dp.draw(arT[d],ptBaseLine+_XW*(dTxtLT*.45),_XW,_YW,1,-1);
				ptBaseLine=ptBaseLine+_XW*(dTxtLT+dOffset);
				
		
				dp.draw(arCount[d],ptBaseLine+_XW*(dTxtLCount*.45),_XW,_YW,1,-1);
				ptBaseLine=ptBaseLine+_XW*(dTxtLCount+dOffset);
		
				ptDraw=ptDraw-_YW*(dTxtH*1.5);
	
			}
			ptDraw=ptDraw-_YW*(dTxtH*0.5);
			
		}
	}//End loop throw all levels
}

//Do Metalparts
if (nDoMetalparts)
{
	//BOM for Metalparts
	TslInst tslAll[] = el.tslInst();
	
	String strTSLNames[0];
	int nQuantity[0];
	for (int i = 0; i < tslAll.length(); i++)
	{
		TslInst tsl = tslAll[i];
		
		Map mp = tsl.map();
		String sNew = tsl.scriptName();
		if (mp.hasMap("TSLBOM"))
		{
			Map mpThisTSL = mp.getMap("TSLBOM");
			String sName = mpThisTSL.getString("Name");
			int nQty = mpThisTSL.getInt("Qty");		if (nQty <=0) nQty = 1;
			String sType = mpThisTSL.getString("Type");
			String sManufacturer = "";
			if (mpThisTSL.hasString("Manufacturer")) sManufacturer = mpThisTSL.getString("Manufacturer");
			sName.trimLeft();
			sName.trimRight();
			sName.makeUpper();
			sType.trimLeft();
			sType.trimRight();
			sType.makeUpper();
			sManufacturer.trimLeft();
			sManufacturer.trimRight();
			sManufacturer.makeUpper();
			String sThisName = sType + " " + sManufacturer;
			sThisName.trimLeft();
			sThisName.trimRight();
			int nLocation = strTSLNames.find(sThisName, - 1);
			if (strTSLNames.find(sThisName, - 1) == -1)//Filter the material Names
			{
				if (nLocation == -1)
				{
					strTSLNames.append(sThisName);
					nQuantity.append(nQty);
				}
			}
			else
			{
				nQuantity[nLocation] += nQty;
			}
		}
		
		if (mp.hasMap("TSLBOM[]"))
		{
			Map mapArray = mp.getMap("TSLBOM[]");
			for (int m = 0; m < mapArray.length(); m++)
			{
				if (mapArray.keyAt(m) != "TSLBOM") continue;
				
				Map mpThisTSL = mapArray.getMap(m);
				String sName = mpThisTSL.getString("Name");
				int nQty = mpThisTSL.getInt("Qty");		if (nQty <=0) nQty = 1;
				String sType = mpThisTSL.getString("Type");
				String sManufacturer = "";
				if (mpThisTSL.hasString("Manufacturer")) sManufacturer = mpThisTSL.getString("Manufacturer");
				sName.trimLeft();
				sName.trimRight();
				sName.makeUpper();
				sType.trimLeft();
				sType.trimRight();
				sType.makeUpper();
				sManufacturer.trimLeft();
				sManufacturer.trimRight();
				sManufacturer.makeUpper();
				String sThisName = sType + " " + sManufacturer;
				sThisName.trimLeft();
				sThisName.trimRight();
				int nLocation = strTSLNames.find(sThisName, - 1);
				if (strTSLNames.find(sThisName, - 1) == -1)//Filter the material Names
				{
					if (nLocation == -1)
					{
						strTSLNames.append(sThisName);
						nQuantity.append(nQty);
					}
				}
				else
				{
					nQuantity[nLocation] += nQty;
				}
			}
		}
	}
	
	if (strTSLNames.length() > 0)
	{
		sTitle = "Metalparts";
		dp.draw(sTitle, ptDraw, _XW, _YW, 1 ,- 1);
		ptDraw = ptDraw - _YW * (dTxtH * 1.5);
	}
	
	for (int t = 0; t < strTSLNames.length(); t++)
	{
		String sGroupName = strTSLNames[t];
		TslInst arTSL[0];
		
		// build lists of items to display
		int nNum = 0; //number of different items; make sure nNum is always the size of the arrays
		
		String arPos[0]; //posnum
		String arName[0]; //name
		String arType[0]; //type
		int arCount[0]; //counter of equal
		
		double dTxtLPos = 0;
		double dTxtLName = 0;
		double dTxtLType = 0;
		double dTxtLCount = 0;
		
		for (int m = 0; m < tslAll.length(); m++)
		{
			TslInst tsl = tslAll[m];
			Map mp = tsl.map();
			if (mp.hasMap("TSLBOM"))
			{
				Map mpThisTSL = mp.getMap("TSLBOM");
				String sName = mpThisTSL.getString("Name");
				String sType = mpThisTSL.getString("Type");
				String sManufacturer = "";
				if (mpThisTSL.hasString("Manufacturer")) sManufacturer = mpThisTSL.getString("Manufacturer");
				sName.trimLeft();
				sName.trimRight();
				sName.makeUpper();
				sType.trimLeft();
				sType.trimRight();
				sType.makeUpper();
				sManufacturer.trimLeft();
				sManufacturer.trimRight();
				sManufacturer.makeUpper();
				//String sThisName=sName+" "+sType;
				String sThisName = sType + " " + sManufacturer;
				sThisName.trimLeft();
				sThisName.trimRight();
				if (sThisName == sGroupName)
				{
					arTSL.append(tsl);
				}
			}
			if (mp.hasMap("TSLBOM[]"))
			{
				Map mapArray = mp.getMap("TSLBOM[]");
				for (int m = 0; m < mapArray.length(); m++)
				{
					if (mapArray.keyAt(m) != "TSLBOM") continue;
					
					Map mpThisTSL = mapArray.getMap(m);
					String sName = mpThisTSL.getString("Name");
					int nQty = mpThisTSL.getInt("Qty");		if (nQty <=0) nQty = 1;
					String sType = mpThisTSL.getString("Type");
					String sManufacturer = "";
					if (mpThisTSL.hasString("Manufacturer")) sManufacturer = mpThisTSL.getString("Manufacturer");
					sName.trimLeft();
					sName.trimRight();
					sName.makeUpper();
					sType.trimLeft();
					sType.trimRight();
					sType.makeUpper();
					sManufacturer.trimLeft();
					sManufacturer.trimRight();
					sManufacturer.makeUpper();
					String sThisName = sType + " " + sManufacturer;
					sThisName.trimLeft();
					sThisName.trimRight();
					if (sThisName == sGroupName)
					{
						arTSL.append(tsl);
					}
				}
			}
		}//End Map Beams Loop
		
		//reportNotice("\n"+sGroupName+" "+arSheet.length());
		
		for (int i = 0; i < arTSL.length(); i++)
		{
			// loop over list items
			int bNew = TRUE;
			TslInst tsl = arTSL[i];
			for (int l = 0; l < nNum; l++)
			{
				String strPos = String(tsl.posnum());
				if (strPos == "-1") strPos = "";
				
				if (strPos == arPos[l])
				{
					bNew = FALSE;
					Map mp = tsl.map();
					if (mp.hasMap("TSLBOM"))
					{
						Map mpThisTSL = mp.getMap("TSLBOM");
						int nQty = mpThisTSL.getInt("Qty");		if (nQty <= 0) nQty = 1;
						arCount[l]+=nQty;
					}
					else
					{
						arCount[l]++; // This will cause a problem when the TSL support multiple entries but can not get away from it at the moment TODO: 
					}
					
					break; //out of inner for loop, we have found the equal one
				}
			}
			if (bNew)
			 { //a new item for the list is found
				
				//TslInst tsl=tslAll[i];
				Map mp = tsl.map();
				if (mp.hasMap("TSLBOM"))
				{
					Map mpThisTSL = mp.getMap("TSLBOM");
					String sName = mpThisTSL.getString("Name");
					int nQty = mpThisTSL.getInt("Qty");		if (nQty <=0) nQty = 1;
					String sType = mpThisTSL.getString("Type");
					String sManufacturer = "";
					if (mpThisTSL.hasString("Manufacturer")) sManufacturer = mpThisTSL.getString("Manufacturer");
					sName.trimLeft();
					sName.trimRight();
					sName.makeUpper();
					sType.trimLeft();
					sType.trimRight();
					sType.makeUpper();
					sManufacturer.trimLeft();
					sManufacturer.trimRight();
					sManufacturer.makeUpper();
					String sThisName = sType + " " + sManufacturer;
					sThisName.trimLeft();
					sThisName.trimRight();
					
					String strPos = String(tsl.posnum());
					strPos.trimLeft();
					strPos.trimRight();
					if (strPos == "-1") strPos = "";
					
					arPos.append(strPos);
					arName.append(sName);
					arType.append(sType);
					arCount.append(nQty);
					
					//Check the space needed for the table
					double dAux = dp.textLengthForStyle("Amount", sDimStyle);
					if (dTxtLCount < dAux)
						dTxtLCount = dAux;
					dAux = dp.textLengthForStyle(strPos, sDimStyle);
					if (dTxtLPos < dAux)
						dTxtLPos = dAux;
					dAux = dp.textLengthForStyle(sName, sDimStyle);
					if (dTxtLName < dAux)
						dTxtLName = dAux;
					dAux = dp.textLengthForStyle(sType, sDimStyle);
					if (dTxtLType < dAux)
						dTxtLType = dAux;
					
					nNum++;
				}
				
				if (mp.hasMap("TSLBOM[]"))
				{
					Map mapArray = mp.getMap("TSLBOM[]");
					for (int m = 0; m < mapArray.length(); m++)
					{
						if (mapArray.keyAt(m) != "TSLBOM") continue;
						
						Map mpThisTSL = mapArray.getMap(m);
						
						String sName = mpThisTSL.getString("Name");
						int nQty = mpThisTSL.getInt("Qty");		if (nQty <=0) nQty = 1;
						String sType = mpThisTSL.getString("Type");
						String sManufacturer = "";
						if (mpThisTSL.hasString("Manufacturer")) sManufacturer = mpThisTSL.getString("Manufacturer");
						sName.trimLeft();
						sName.trimRight();
						sName.makeUpper();
						sType.trimLeft();
						sType.trimRight();
						sType.makeUpper();
						sManufacturer.trimLeft();
						sManufacturer.trimRight();
						sManufacturer.makeUpper();
						String sThisName = sType + " " + sManufacturer;
						sThisName.trimLeft();
						sThisName.trimRight();
						
						String strPos = String(tsl.posnum());
						strPos.trimLeft();
						strPos.trimRight();
						if (strPos == "-1") strPos = "";
						
						arPos.append(strPos);
						arName.append(sName);
						arType.append(sType);
						arCount.append(nQty);
						
						//Check the space needed for the table
						double dAux = dp.textLengthForStyle("Amount", sDimStyle);
						if (dTxtLCount < dAux)
							dTxtLCount = dAux;
						dAux = dp.textLengthForStyle(strPos, sDimStyle);
						if (dTxtLPos < dAux)
							dTxtLPos = dAux;
						dAux = dp.textLengthForStyle(sName, sDimStyle);
						if (dTxtLName < dAux)
							dTxtLName = dAux;
						dAux = dp.textLengthForStyle(sType, sDimStyle);
						if (dTxtLType < dAux)
							dTxtLType = dAux;
						
						nNum++;
						
					}
				}
			}
		}
		
		if (arTSL.length() > 0)
		{
			//The information of that Group is ready to display
			//Display the Title of the Group
			dp.draw(sGroupName, ptDraw, _XW, _YW, 1 ,- 1);
			ptDraw = ptDraw - _YW * (dTxtH * 1.5);
			Point3d ptBaseLine = ptDraw;
			//Check if the title is not bigger than the text on the columns
			
			double dAux = dp.textLengthForStyle("Nr.", sDimStyle);
			if (dTxtLPos < dAux)
				dTxtLPos = dAux;
			
			dAux = dp.textLengthForStyle("Name/Model", sDimStyle);
			if ( (dTxtLName) < dAux)
				dTxtLName = dAux;
			
			dAux = dp.textLengthForStyle("Type", sDimStyle);
			if (dTxtLType < dAux)
				dTxtLType = dAux;
			
			
			//Display the Title of each column
			dp.draw("Nr.", ptBaseLine, _XW, _YW, 1 ,- 1);
			ptBaseLine = ptBaseLine + _XW * (dTxtLPos + dOffset);
			
			dp.draw("Name/Model", ptBaseLine, _XW, _YW, 1 ,- 1);
			ptBaseLine = ptBaseLine + _XW * (dTxtLName + dOffset);
			
			//			dp.draw("Type", ptBaseLine, _XW, _YW, 1 ,- 1);
			//			ptBaseLine = ptBaseLine + _XW * (dTxtLType + dOffset);
			
			
			dp.draw("Amount", ptBaseLine, _XW, _YW, 1 ,- 1);
			ptBaseLine = ptBaseLine + _XW * (dTxtLCount + dOffset);
			
			ptDraw = ptDraw - _YW * (dTxtH * 1.5);
			
			for (int d = 0; d < arPos.length(); d++)
			{
				ptBaseLine = ptDraw;
				
				//Display the Values of each row
				dp.draw(arPos[d], ptBaseLine, _XW, _YW, 1 ,- 1);//+_XW * (dTxtLPos * .3)
				ptBaseLine = ptBaseLine + _XW * (dTxtLPos + dOffset);
				
				dp.draw(arName[d], ptBaseLine, _XW, _YW, 1 ,- 1);
				ptBaseLine = ptBaseLine + _XW * (dTxtLName + dOffset);
				
				//				dp.draw(arType[d], ptBaseLine, _XW, _YW, 1 ,- 1);
				//				ptBaseLine = ptBaseLine + _XW * (dTxtLType + dOffset);
				
				dp.draw(arCount[d], ptBaseLine + _XW * (dTxtLCount * .45), _XW, _YW, 1 ,- 1);
				ptBaseLine = ptBaseLine + _XW * (dTxtLCount + dOffset);
				
				ptDraw = ptDraw - _YW * (dTxtH * 1.5);
				
			}
			ptDraw = ptDraw - _YW * (dTxtH * 0.5);
			
		}
	}//End loop throw all levels
}//End Do Metalparts

if(nDoTrusses)
{
	//BOM for Trusses
	TrussEntity entTruss[0];
	//Check if there are any space joists
	Group grpElement=el.elementGroup();
	Entity entElement[]=grpElement.collectEntities(false,TrussEntity(),_kModelSpace);
	for(int e=0;e<entElement.length();e++)
	{
		//Get the truss entity
		TrussEntity truss=(TrussEntity)entElement[e];
		if(!truss.bIsValid()) continue;
		entTruss.append(truss);
	}
	
	
	Map mpTrusses;
	
	String strTrussNames[0];
	strTrussNames.append(sTrussGroupName);
	for (int i=0; i<entTruss.length(); i++)
	{
		TrussEntity truss=entTruss[i];
		CoordSys csTruss=truss.coordSys();
		
		//Definition
		String sDefinition=truss.definition();
		TrussDefinition trussDef(sDefinition);
		int nLocation=strTrussNames.find(sDefinition, -1);
		
	}
	
	//Sort trusses by definition
	for (int b1=1; b1<entTruss.length(); b1++) 
	{
		int lb1 = b1;
		for (int b2 = b1-1; b2>=0; b2--) 
		{
			if (entTruss[lb1].definition()<entTruss[b2].definition()) 
			{
				entTruss.swap(b2,lb1);
				lb1=b2;
			}
		}
	}	
	//End of the sorting	
	
	//Get the truss definition data
	String sTrussDefinitions[0];
	double dTrussWidth[0];
	double dTrussHeight[0];
	double dTrussLength[0];

	
	for(int i=0;i<entTruss.length();i++)
	{
		TrussEntity truss=entTruss[i];
		String sDefinition=truss.definition();
		CoordSys csTruss=truss.coordSys();

		//Get all the beams in the definition
		TrussDefinition trussDef(sDefinition);
		Beam bmTruss[]=trussDef.beam();
		Body bdTruss;
		for(int b=0;b<bmTruss.length();b++)
		{
			Beam bm=bmTruss[b];
			if(!bm.bIsValid()) continue;
			
			Body bd=bm.realBody();
			bdTruss.combine(bd);
		}
		
		if(sTrussDefinitions.find(sDefinition)==-1)
		{
			//New Truss definition found
			sTrussDefinitions.append(sDefinition);

			//Get parameters of Truss
			dTrussLength.append(bdTruss.lengthInDirection(_XW));
			dTrussHeight.append(bdTruss.lengthInDirection(_YW));
			dTrussWidth.append(bdTruss.lengthInDirection(_ZW));
		}
		
		//Add in the locations for posnums
		if (bShowBmPosnum>0)
		{
			//Rotate the point to the truss position as the definition is at 0,0,0
			CoordSys csTransform;
			Point3d pt(0,0,0);
			csTransform.setToAlignCoordSys(pt,_XW,_YW,_ZW, csTruss.ptOrg(),csTruss.vecX(),csTruss.vecY(),csTruss.vecZ());
			Point3d ptTrussCen=bdTruss.ptCen();
			ptTrussCen.transformBy(csTransform);
			ptTrussCen.vis();
			ptLocation.append(ptTrussCen);
			sPosNumToShow.append(String(sDefinition));
			vecBmX.append(_XW);
			vMove.append(_XW);
		}
	}	
/*	
	if (strTrussNames.length()>0)
	{
		sTitle=sTrussGroupName;
		dp.draw(sTitle,ptDraw,_XW,_YW,1,-1);
		ptDraw=ptDraw-_YW*(dTxtH*1.5);
	}
*/
	for (int t=0; t<strTrussNames.length(); t++)
	{
		String sGroupName=strTrussNames[t];
		TrussEntity arTrusses[0];
	
		// build lists of items to display
		int nNum = 0; // number of different items; make sure nNum is always the size of the arrays
		int arCount[0]; // counter of equal
	
		String arPos[0]; // posnum
		String arW[0]; // width
		String arT[0]; // thickness
		String arL[0]; // length or height
		
		double dTxtLCount=0;
		double dTxtLPos=0;
		double dTxtLW=0;
		double dTxtLT=0;
	
		for (int m=0; m<entTruss.length(); m++)
		{
			arTrusses.append(entTruss[m]);
		}// End Map Beams Loop
		
		//reportNotice("\n"+sGroupName+" "+arSheet.length());
		
		for (int i=0; i<arTrusses.length(); i++)
		{
			// loop over list items
			int bNew = TRUE;
			TrussEntity truss = arTrusses[i];
			for (int l=0; l<nNum; l++)
			{
				String strPos = String(truss.definition());
				
				String strLength; 
				String strWidth; 
				String strThick; 

				//Find the definition and its data
				int nTrussDefPosition=sTrussDefinitions.find(strPos);
				
				if(nTrussDefPosition!=-1)
				{
					double dThisTrussWidth=dTrussWidth[nTrussDefPosition];
					double dThisTrussHeight=dTrussHeight[nTrussDefPosition];
					if(dThisTrussWidth>dThisTrussHeight) //Swap
					{
						dThisTrussWidth=dTrussHeight[nTrussDefPosition];
						dThisTrussHeight=dTrussWidth[nTrussDefPosition];
					}

					strThick.formatUnit(dTrussLength[nTrussDefPosition], sDimStyle); 
					strWidth.formatUnit(dThisTrussWidth,sDimStyle); 
					strLength.formatUnit(dThisTrussHeight,sDimStyle); 
				}
				if ( strPos==arPos[l])
				{
					bNew = FALSE;
					arCount[l]++;
					break; // out of inner for loop, we have found the equal one
				}
			}
			if (bNew)
			{ // a new item for the list is found
				String strPos = String(truss.definition());
				strPos.trimLeft();
				strPos.trimRight();
				
				String strLength; 
				String strWidth; 
				String strThick; 

				//Find the definition and its data
				int nTrussDefPosition=sTrussDefinitions.find(strPos);
				
				if(nTrussDefPosition!=-1)
				{
					double dThisTrussWidth=dTrussWidth[nTrussDefPosition];
					double dThisTrussHeight=dTrussHeight[nTrussDefPosition];
					if(dThisTrussWidth>dThisTrussHeight) //Swap
					{
						dThisTrussWidth=dTrussHeight[nTrussDefPosition];
						dThisTrussHeight=dTrussWidth[nTrussDefPosition];
					}

					strThick.formatUnit(dTrussLength[nTrussDefPosition], sDimStyle); 
					strWidth.formatUnit(dThisTrussWidth,sDimStyle); 
					strLength.formatUnit(dThisTrussHeight,sDimStyle); 
				}
				arCount.append(1);
				arW.append(strWidth);
				arL.append(strLength);
				arPos.append(strPos);
				arT.append(strThick);
	
				//Check the space needed for the table
				double dAux=dp.textLengthForStyle("Amount", sDimStyle);
				if (dTxtLCount < dAux)
					dTxtLCount = dAux;
				dAux=dp.textLengthForStyle(strPos, sDimStyle);
				if (dTxtLPos < dAux)
					dTxtLPos= dAux;
				dAux=dp.textLengthForStyle(strWidth+ " x " +strLength, sDimStyle);
				if (dTxtLW < dAux)
					dTxtLW= dAux;
	
				dAux=dp.textLengthForStyle(strThick, sDimStyle);
				if (dTxtLT< dAux)
					dTxtLT= dAux;
	
				nNum++;
			}
		}	
		
		if (arTrusses.length()>0)
		{
			//The information of that Group is ready to display
			//Display the Title of the Group
			dp.draw(sGroupName,ptDraw,_XW,_YW,1,-1);
			ptDraw=ptDraw-_YW*(dTxtH*1.5);
			Point3d ptBaseLine=ptDraw;
			//Check if the title is not bigger than the text on the columns
			
			double dAux=dp.textLengthForStyle("Nr.", sDimStyle);
			if (dTxtLPos < dAux)
				dTxtLPos= dAux;
			
			dAux=dp.textLengthForStyle("Dimension", sDimStyle);
			if ( (dTxtLW) < dAux)
				dTxtLW= dAux;
	
			dAux=dp.textLengthForStyle("Length", sDimStyle);
			if (dTxtLT< dAux)
				dTxtLT= dAux;
			
	
			//Display the Title of each column
			dp.draw("Nr.",ptBaseLine,_XW,_YW,1,-1);
			ptBaseLine=ptBaseLine+_XW*(dTxtLPos+dOffset);
	
			dp.draw("Dimension",ptBaseLine,_XW,_YW,1,-1);
			ptBaseLine=ptBaseLine+_XW*(dTxtLW+dOffset);
	
			dp.draw("Length",ptBaseLine,_XW,_YW,1,-1);
			ptBaseLine=ptBaseLine+_XW*(dTxtLT+dOffset);
			
	
			dp.draw("Amount",ptBaseLine,_XW,_YW,1,-1);
			ptBaseLine=ptBaseLine+_XW*(dTxtLCount+dOffset);
	
			ptDraw=ptDraw-_YW*(dTxtH*1.5);
					
			for (int d=0; d<arPos.length(); d++)
			{
				ptBaseLine=ptDraw;
	
				//Display the Values of each row
				dp.draw(arPos[d],ptBaseLine,_XW,_YW,1,-1);//+_XW*(dTxtLPos*.3)
				ptBaseLine=ptBaseLine+_XW*(dTxtLPos+dOffset);
		
				dp.draw(arW[d]+" x "+arL[d],ptBaseLine,_XW,_YW,1,-1);
				ptBaseLine=ptBaseLine+_XW*(dTxtLW+dOffset);
		
				dp.draw(arT[d],ptBaseLine+_XW*(dTxtLT*.45),_XW,_YW,1,-1);
				ptBaseLine=ptBaseLine+_XW*(dTxtLT+dOffset);
				
		
				dp.draw(arCount[d],ptBaseLine+_XW*(dTxtLCount*.45),_XW,_YW,1,-1);
				ptBaseLine=ptBaseLine+_XW*(dTxtLCount+dOffset);
		
				ptDraw=ptDraw-_YW*(dTxtH*1.5);
	
			}
			ptDraw=ptDraw-_YW*(dTxtH*0.5);
			
		}
	}//End loop throw all levels
}


//Display the Posnum
//ptLocation
//sPosNumToShow

CoordSys csEl = el.coordSys();
Vector3d vx = csEl.vecX();
Vector3d vy = csEl.vecY();
Vector3d vz = csEl.vecZ();
Point3d ptEl = csEl.ptOrg();

Vector3d vXTxt = vx; vXTxt.transformBy(ms2ps);
Vector3d vYTxt = vy; vYTxt.transformBy(ms2ps);


Display dpPos(nColorPosnum);
dpPos.dimStyle(sDimStylePosnum);

//Display dpBox(nColor2);
Vector3d vOffset=vz;
if (nZone<0)
	vOffset=-vOffset;

PlaneProfile ppAllPosNum;
//Vector3d vMove=_XW;
//vMove.transformBy(ps2ms);
//vMove.normalize();

//double dTxtLengthStyle =  dpPos.textLengthForStyle(sDpTxt ,sDimStylePosNum);
//double dTxtHeightStyle =  dpPos.textHeightForStyle(sDpTxt ,sDimStylePosNum);	

//Remove any duplicates which are in the same location and have the same posnum
/*
for (int i=0;i<ptLocation.length()-1; i++)
{
	Point3d ptCurr=ptLocation[i];
	String sPos=sPosNumToShow[i];
	for(int p=0;ptLocation.length
}
*/

ptLocation=Plane(el.ptOrg(), vz).projectPoints(ptLocation);

for (int c=0; c<ptLocation.length()-1; c++)
{
	for (int d=c+1; d<ptLocation.length(); d++)
	{
		if ((ptLocation[d]-ptLocation[c]).length()<U(2))
		{
			if (sPosNumToShow[c]==sPosNumToShow[d])
			{
				ptLocation.removeAt(c);
				sPosNumToShow.removeAt(c);
				vecBmX.removeAt(c);
				vMove.removeAt(c);
				d--;
			}
		}
	}
}



for (int i = 0; i < ptLocation.length(); i++)
{
	String sPos = sPosNumToShow[i];
	Point3d ptPosNum = ptLocation[i];
	Vector3d vecBmXCurr = vecBmX[i];
	Vector3d vMoveDirection = vMove[i];
	//vecBmXCurr.transformBy(ms2ps);
	vecBmXCurr.normalize();
	Vector3d vyCurr = vecBmXCurr.crossProduct(-_ZW);
	vyCurr.normalize();
	
	//ptPosNum=ptPosNum+vOffset*(dTextHeight);
	ptPosNum.transformBy(ms2ps);
	double dTxtLengthStyle = dp.textLengthForStyle(sPos, sDimStylePosnum);
	double dTxtHeightStyle = dp.textHeightForStyle(sPos, sDimStylePosnum);
	
	dp.textHeight(0.9 * dTxtHeightStyle);
	
	// createposnum mask
	PLine plPosNum(_ZW);
	plPosNum.addVertex(ptPosNum - 0.6 * (vecBmXCurr * dTxtLengthStyle + vyCurr * dTxtHeightStyle));
	plPosNum.addVertex(ptPosNum - 0.6 * (vecBmXCurr * dTxtLengthStyle - vyCurr * dTxtHeightStyle));
	plPosNum.addVertex(ptPosNum + 0.6 * (vecBmXCurr * dTxtLengthStyle + vyCurr * dTxtHeightStyle));
	plPosNum.addVertex(ptPosNum + 0.6 * (vecBmXCurr * dTxtLengthStyle - vyCurr * dTxtHeightStyle));
	plPosNum.close();
	PlaneProfile ppPosNum(plPosNum);
	ppPosNum.shrink(-.1 * dTxtHeightStyle);
	ppPosNum.vis(3);
	
	// ensure posnums do not intersect
	int m, d;
	d = 1;
	PlaneProfile pp0 = PlaneProfile(plPosNum);
	
	pp0.intersectWith(ppAllPosNum);
	
	while (m < 30 && pp0.area() > 0)
	{
		ptPosNum.transformBy(vMoveDirection * d * dTxtHeightStyle * 1);
		plPosNum.transformBy(vMoveDirection * d * dTxtHeightStyle * 1);
		m++;
		if (d < 0)
			d = m + 1;
		else
			d = - m - 1;
		
		pp0 = PlaneProfile(plPosNum);
		pp0.shrink(-.01 * dTxtHeightStyle);
		pp0.intersectWith(ppAllPosNum);
	}
	ppAllPosNum.joinRing(plPosNum, _kAdd);
	ppPosNum.shrink(-.1 * dTxtHeightStyle);
	
	
	dpPos.draw(sPos, ptPosNum - vMoveDirection * 0.05 * dTxtHeightStyle, vecBmXCurr, vyCurr, 0, 0);
	
	//dp.draw (sPos, , _XW, _YW, 0, 0);
	//dpBox.draw(plPosNum);//, nDrawFilled
}



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
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20904: Add property to define the title name for the &quot;space studs&quot; table" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="47" />
      <str nm="Date" vl="9/29/2024 4:20:11 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Bugfix with sheeting been excluded incorrectly." />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="46" />
      <str nm="Date" vl="8/22/2023 8:28:01 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Bugfix" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="45" />
      <str nm="Date" vl="7/25/2023 4:57:47 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="Add support to the Assembly Definition TSL" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="44" />
      <str nm="Date" vl="7/21/2023 10:51:56 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16774: show subassemblies for &quot;GC-SpaceStudAssembly&quot;" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="43" />
      <str nm="Date" vl="11/28/2022 1:14:31 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16774: Add property/column name; show beams part of subassembly &quot;S&quot; TSLs" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="42" />
      <str nm="Date" vl="11/28/2022 8:44:50 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End