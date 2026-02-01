#Version 8
#BeginDescription
Creates Bill Of Materials (BOM) in Layout for Walls or Floors
v1.23: 13.ene.2014: David Rueda (dr@hsb-cad.com)


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 23
#KeyWords 
#BeginContents
/*
  COPYRIGHT
  ---------------
  Copyright (C) 2011 by
  hsbSOFT 

  The program may be used and/or copied only with the written
  permission from hsbSOFT, or in accordance with
  the terms and conditions stipulated in the agreement/contract
  under which the program has been supplied.

  All rights reserved.

 REVISION HISTORY
 -------------------------

* v1.0: 11.mar.2013: David Rueda (dr@hsb-cad.com)
	- Copied from hsb_ElementBOM, to keep US content folder naming standards
* v1.19: 11.mar.2013: David Rueda (dr@hsb-cad.com)
	- Version control from 1.0 to 1.19, to keep updated with hsb_ElementBOM
* v1.20: 14.mar.2013: David Rueda (dr@hsb-cad.com)
	- Prop. "Show Angle Column" (yes/no) added
	- Bugfix when displaying real sizes instead of nominal for US market
* v1.21: 07.apr.2013: David Rueda (dr@hsb-cad.com)
	- Prop. "Using Defaults Editor" (yes/no) added
	- If "Using Defaults editor" beam material and grade will be taken from 1st. and 2nd. token from grade prop on beam
* v1.22: 20.may.2013: David Rueda (dr@hsb-cad.com)
	- All strings are to be translated (all except those for map use)
* v1.23: 13.ene.2014: David Rueda (dr@hsb-cad.com)
	- Classification groups added:
		- Sill
		- Very Top Plate
		- Jacks
		- Header (renamed from lintel)
*/

int nLunit = 2; // architectural (only used for beam length, others depend on hsb_settings)
int nPrec = 1; // precision (only used for beam length, others depend on hsb_settings)

double dOffset=U(3, 0.15);

String sArNY[] = {T("|No|"), T("|Yes|")};

String sPaperSpace = T("|paper space|");
String sShopdrawSpace = T("|shopdraw multipage|");
String sArSpace[] = { sPaperSpace , sShopdrawSpace };
PropString sSpace(2,sArSpace,T("|Drawing space|"));

PropString sUsingDefaultsEditor(17, sArNY, T("|Using Defaults Editor|"), 0);
int bUsingDefaultsEditor= sArNY.find(sUsingDefaultsEditor,0);

PropString sDimStyle(0,_DimStyles, T("|Dim Style|"));
PropInt nColor(0,3,T("|Color|"));

PropString strMaterial (1,"",T("|Materials to exclude from the BOM|"));
strMaterial.setDescription(T("|Please fill the materials that you don't need to list on the BOM, use|")+" ';' "+T("|as separator if you want to filter more that 1 material|"));

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

PropString sDimStylePosnum(3,_DimStyles, T("|Dim Style|")+T("|Posnum|"));
PropInt nColorPosnum(1,3,T("|Color Posnum|"));

PropString sShowJoistReferences (9, "", T("|Joist Reference Catalogue|"));
sShowJoistReferences .setDescription(T("|If using Joist References in Exporter, Enter the catalogue name|"));

int bShowJoistReferences=FALSE;
if(sShowJoistReferences!="")
{
	bShowJoistReferences=TRUE;
}

String sBmRef[]={T("|None|"),T("|Posnum|"),T("|Length|")};
PropString sShowBmPosnum (4, sBmRef, T("|Show Beam Reference|"));
sShowBmPosnum.setDescription(T("|Shows selected reference on each beam|"));
int bShowBmPosnum = sBmRef.find(sShowBmPosnum, 0);

int nValidZones[]={0,1,2,3,4,5,6,7,8,9,10};
int nRealZones[]={0,1,2,3,4,5,-1,-2,-3,-4,-5};
PropInt nZones (2, nValidZones, T("|Show Posnum Zone|")+", 0="+T("|none|"), 0);
int nZone=nRealZones[nValidZones.find(nZones, 0)];

PropString strShowLabel(8,sArNY,T("|Show Label Column|"),1);
int bShowLabel = sArNY.find(strShowLabel, 0);

PropString strShowAngle(16,sArNY,T("|Show Angle Column|"),1);
int bShowAngle = sArNY.find(strShowAngle, 1);

PropString strShowMaterial(11,sArNY,T("|Show Material Column|"),1);
int bShowMaterial = sArNY.find(strShowMaterial, 0);

PropString strShowGrade(12,sArNY,T("|Show Grade Column|"),1);
int bShowGrade = sArNY.find(strShowGrade, 0);

PropString sTwoColumns(15, sArNY, T("|Show table in two columns|"), 0);
int bTwoColumns = sArNY.find(sTwoColumns, 0);

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
}//End OPM

if (_bOnInsert)
{
	showDialog();
	//int nSpace = sArSpace.find(sSpace);
	
	_Pt0=getPoint(T("|Pick a point to show the table|"));
	if (sSpace == sPaperSpace)
	{	//Paper Space
  		Viewport vp = getViewport(T("|Select the viewport from which the element is taken|")); // select viewport
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

String sSheetingGroupName=T("|Wallboard|");
String sTrussGroupName=T("|Trusses|");

if (nWall)
{
	nBeamType.append(_kSFJackOverOpening);			nLevel.append(5);
	nBeamType.append(_kSFJackUnderOpening);			nLevel.append(5);
	nBeamType.append(_kCrippleStud);						nLevel.append(14);
	nBeamType.append(_kSFTransom);						nLevel.append(6);
	nBeamType.append(_kKingStud);							nLevel.append(13);
	nBeamType.append(_kSill);								nLevel.append(6);
	nBeamType.append(_kBrace);							nLevel.append(6);
	nBeamType.append(_kSFAngledTPLeft);					nLevel.append(3);
	nBeamType.append(_kSFAngledTPRight);				nLevel.append(3);
	nBeamType.append(_kSFBlocking);						nLevel.append(8);
	nBeamType.append(_kBlocking);							nLevel.append(8);
	nBeamType.append(_kSFSupportingBeam);				nLevel.append(14);
	nBeamType.append(_kStud);								nLevel.append(13);
	nBeamType.append(_kSFStudLeft);						nLevel.append(13);
	nBeamType.append(_kSFStudRight);						nLevel.append(13);
	nBeamType.append(_kSFTopPlate);						nLevel.append(3);
	nBeamType.append(_kSFVeryTopPlate);					nLevel.append(4);
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
	
	sLevelName.append(T("|Space Stud|")); /*0*/				nVisible.append(true);	
	sLevelName.append(T("|Locating Plate|")); /*1*/			nVisible.append(true);	
	sLevelName.append(T("|Bottom Plate|")); /*2*/			nVisible.append(true);
	sLevelName.append(T("|Top Plate|")); /*3*/				nVisible.append(true);
	sLevelName.append(T("|Very Top Plate|")); /*4*/			nVisible.append(true);
	sLevelName.append(T("|Cripple|")); /*5*/					nVisible.append(true);
	sLevelName.append(T("|Sill|")); /*6*/						nVisible.append(true);
	sLevelName.append(T("|Header|")); /*7*/					nVisible.append(true);
	sLevelName.append(T("|Blocking|")); /*8*/				nVisible.append(true);
	sLevelName.append(T("|Vent|")); /*9*/					nVisible.append(true);
	sLevelName.append(T("|Service Battens|")); /*10*/		nVisible.append(true);
	sLevelName.append(T("|Battens|")); /*11*/				nVisible.append(true);
	sLevelName.append(T("|Connectors|")); /*12*/			nVisible.append(true);
	sLevelName.append(T("|Stud|")); /*13*/					nVisible.append(true);
	sLevelName.append(T("|Jacks|")); /*14*/					nVisible.append(true);
	sLevelName.append(T("|Generic|"));						nVisible.append(true);	//Generic should be always the last one in this array

	sSheetingGroupName=T("|Wallboard|");
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
	
	sLevelName.append(T("|Joist|")); /*0*/						nVisible.append(true);	
	sLevelName.append(T("|Rimboard|")); /*1*/					nVisible.append(true);
	sLevelName.append(T("|Supporting Beam|")); /*2*/			nVisible.append(true);
	sLevelName.append(T("|Packer|")); /*3*/						nVisible.append(true);
	sLevelName.append(T("|Blocking|")); /*4*/					nVisible.append(true);
	sLevelName.append(T("|Batten|")); /*5*/						nVisible.append(true);
	sLevelName.append(T("|Ledger|")); /*6*/						nVisible.append(true);
	sLevelName.append(T("|Trimmer|")); /*7*/					nVisible.append(true);
	sLevelName.append(T("|Generic|"));							nVisible.append(true);
	
	//Generic should be always the last one in this array
	sSheetingGroupName=T("|Sheathing|");
	sTrussGroupName=T("|Metal Web Joists|");

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
	sLevelName.append(T("|Generic|"));							
	nVisible.append(true);

}
else
{
	return;
}

String sActualValue[0];				String sNominal[0];		

String sAux; 
//sAux.formatUnit(0.75, 2,2); // Fixed, DR, 11-mar-2012 (all following lines)
sAux.formatUnit(0.75, sDimStyle);
sActualValue.append(sAux);			sNominal.append("1");
sAux.formatUnit(1.5, sDimStyle);
sActualValue.append(sAux);			sNominal.append("2");
sAux.formatUnit(2.5, sDimStyle);
sActualValue.append(sAux);			sNominal.append("3");
sAux.formatUnit(3.5, sDimStyle);
sActualValue.append(sAux);			sNominal.append("4");
sAux.formatUnit(5.5, sDimStyle);
sActualValue.append(sAux);			sNominal.append("6");
sAux.formatUnit(7.25, sDimStyle);
sActualValue.append(sAux);			sNominal.append("8");
sAux.formatUnit(9.25, sDimStyle);
sActualValue.append(sAux);			sNominal.append("10");
sAux.formatUnit(11.25, sDimStyle);
sActualValue.append(sAux);			sNominal.append("12");
sAux.formatUnit(13.25, sDimStyle);
sActualValue.append(sAux);			sNominal.append("14");
sAux.formatUnit(15.25, sDimStyle);
sActualValue.append(sAux);			sNominal.append("16");

//////////////////////////////////

//Beam bmToStart[]=el.beam();
GenBeam gb[]=el.genBeam();

GenBeam gbAll[]=GenBeam().filterGenBeamsNotInSubAssembly(gb);

Beam bmAll[0];

for (int i=0; i<gbAll.length(); i++)
{
	Beam bm=(Beam) gbAll[i];
	if (bm.bIsValid())
	{
		if(!bm.bIsDummy())
			bmAll.append(bm);
	}
}



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

for (int i=0; i<tslAll.length(); i++)
{
	TslInst tsl=tslAll[i];
	if (tsl.scriptName()=="hsb_SpaceStudAssembly")
	{
		Map mp=tsl.map();
		if (mp.hasString("SpaceStudAssembly"))
		{
			String sThisKey=mp.getString("SpaceStudAssembly");
			int nLoc=strAllKeys.find(sThisKey, -1);
			if (nLoc != -1)
			{
				nQtyThisSA[nLoc]++;
				if (bShowBmPosnum==1)
				{
					ptLocation.append(tsl.ptOrg());
					sPosNumToShow.append(tsl.posnum());
					vecBmX.append(_XW);
					vMove.append(_XW);
				}
			}
			else
			{
				strAllKeys.append(sThisKey);
				nQtyThisSA.append(1);
				Beam bmThisTSL[]=tsl.beam();
				bmMainSA.append(bmThisTSL[0]);
				sPosNumSA.append(tsl.posnum());
				dWidthSA.append(mp.getDouble("Width"));
				dHeightSA.append(mp.getDouble("Height"));
				dLengthSA.append(mp.getDouble("Length"));
				if (bShowBmPosnum==1)
				{
					ptLocation.append(tsl.ptOrg());
					sPosNumToShow.append(tsl.posnum());
					vecBmX.append(_XW);
					Vector3d vec=bmThisTSL[0].vecX();
					vec.transformBy(ms2ps);
					vec.normalize();
					vMove.append(vec);
				}
			}
		}
	}
}

Point3d ptDraw=_Pt0;
double dFirstColumnTableWidth=0;

String sTitle=T("|Prefabricated Cuts|");
double dTxtH=dp.textHeightForStyle(sTitle, sDimStyle);

Map mpBeams;
if (nDoBeams)
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
		String arCN[0];
		String arCP[0];
		String arMaterial[0];
		String arGrade[0];
		String arLabel[0];
		
		double dTxtLCount=0;
		double dTxtLPos=0;
		double dTxtLW=0;
		double dTxtLL=0;
		double dTxtLCN=0;
		double dTxtLMaterial=0;
		double dTxtLGrade=0;
		double dTxtLLabel=0;
	
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
		if (sGroupName=="Space Stud")
		{
			for (int i=0; i<strAllKeys.length(); i++)
			{
				// a new item for the list is found
				String strPos = String(sPosNumSA[i]);
				String sSubLabel2 = bmMainSA[i].subLabel2();
				sSubLabel2.trimLeft(); sSubLabel2.trimRight();
				sSubLabel2.makeUpper();
				if (strPos=="-1") strPos = "";
		
				double dLength1=dLengthSA[i];
				String strLength; strLength.formatUnit(dLength1, sDimStyle);
				strLength.trimLeft().trimRight();
				String strWidth; strWidth.formatUnit(dWidthSA[i], sDimStyle);
				int nLocation=sActualValue.find(strWidth, -1);
				if (nLocation!=-1 && sSubLabel2!="EWP")
					arWToShow.append(sNominal[nLocation]);
				else
					arWToShow.append(strWidth);
				
				String strHeight; strHeight.formatUnit(dHeightSA[i], sDimStyle);
				nLocation=sActualValue.find(strHeight, -1);
				if (nLocation!=-1&& sSubLabel2!="EWP")
					arHToShow.append(sNominal[nLocation]);
				else
					arHToShow.append(strHeight);
		
				arCount.append(nQtyThisSA[i]);
				arW.append(strWidth);
				arL.append(strLength);
				arDLength.append(dLength1);
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
		
				//Check the space needed for the table
				double dAux=dp.textLengthForStyle(T("|Amount|"), sDimStyle);
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
				
				dAux=dp.textLengthForStyle(bmMainSA[i].material(), sDimStyle);
				if (dTxtLMaterial < dAux)
					dTxtLMaterial= dAux;	
				
				dAux=dp.textLengthForStyle(bmMainSA[i].grade(), sDimStyle);
				if (dTxtLGrade < dAux)
					dTxtLGrade= dAux;
		
				dAux=dp.textLengthForStyle(bmMainSA[i].label(), sDimStyle);
				if (dTxtLLabel < dAux)
					dTxtLLabel= dAux;
				
				nStud=true;
			}
			
		}
		
		for (int i=0; i<arBeam.length(); i++)
		{
			// loop over list items
			int bNew = TRUE;
			Beam bm = arBeam[i];
			if (bShowBmPosnum==1)
			{
				
				dLengthForPosnum.append(bm.solidLength());
				sDisplayForPosnum.append(String(bm.posnum()));
				ptForPosnum.append(bm.ptCen());
				vecForPosnum.append(_XW);
				Vector3d vec=bm.vecX();
				vec.transformBy(ms2ps);
				vec.normalize();
				vecMoveForPosnum.append(vec);
			
			}
			else if(bShowBmPosnum==2)
			{
				double dSolidLength=bm.solidLength();
				String sSolidLength;
				sSolidLength.formatUnit(dSolidLength,2,0);

				dLengthForPosnum.append(bm.solidLength());
				sDisplayForPosnum.append(sSolidLength);
				ptForPosnum.append(bm.ptCen());

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
				if ( (strHeight==arH[l]) && (strPos==arPos[l]) && (strWidth==arW[l]) && (strLength==arL[l]))
				{
					bNew = FALSE;
					arCount[l]++;
					break; // out of inner for loop, we have found the equal one
				}
			}
			if (bNew)
			{ // a new item for the list is found
				String strPos = String(bm.posnum());
				String sSubLabel2 = bm.subLabel2();
				sSubLabel2.trimLeft(); sSubLabel2.trimRight();
				sSubLabel2.makeUpper();
				if (strPos=="-1") strPos = "";
	
				double dLength1=bm.solidLength();
				//String strLength; strLength.formatUnit(dLength1, nLunit, nPrec);
				String strLength; strLength.formatUnit(dLength1, sDimStyle);
				String strWidth; strWidth.formatUnit(bm.dW(), sDimStyle);
				String sWidthToShow;
				int nLocation=sActualValue.find(strWidth, -1);
				if (nLocation!=-1 && sSubLabel2!="EWP")
					sWidthToShow=sNominal[nLocation];
				else
					sWidthToShow=strWidth;

				arWToShow.append(sWidthToShow);
				
				String strHeight; strHeight.formatUnit(bm.dH(), sDimStyle);
				String sHeightToShow;
				nLocation=sActualValue.find(strHeight, -1);
				
				if (nLocation!=-1&& sSubLabel2!="EWP")
					sHeightToShow=sNominal[nLocation];
				else
					sHeightToShow=strHeight;
				arHToShow.append(sHeightToShow);

				arCount.append(1);
				arW.append(strWidth);
				arH.append(strHeight);
				arL.append(strLength);
				arDLength.append(dLength1);
				
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
//				arH.append(strHeight);
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
				
				arCN.append(sNewCutN);
				arCP.append(sNewCutP);
				
				String sMaterialToDisplay;
				if(bUsingDefaultsEditor)
				{
					String sCompleteStringsFromDefaults=bm.grade();
					sMaterialToDisplay=sCompleteStringsFromDefaults.token(0,"!",1).trimRight().trimLeft();
					arGrade.append(sCompleteStringsFromDefaults.token(1,"!",1).trimRight().trimLeft());
				}
				else
				{
					sMaterialToDisplay=bm.material();
					arGrade.append(bm.grade());
				}
				arMaterial.append(sMaterialToDisplay);

				arLabel.append(bm.label());
	
				//Check the space needed for the table
				double dAux=dp.textLengthForStyle(T("|Amount|"), sDimStyle);
				if (dTxtLCount < dAux)
					dTxtLCount = dAux;
					
				dAux=dp.textLengthForStyle(strPos, sDimStyle);
				if (dTxtLPos < dAux)
					dTxtLPos= dAux;

				dAux=dp.textLengthForStyle(sWidthToShow+ " x " +sHeightToShow, sDimStyle);
				if (dTxtLW < dAux)
					dTxtLW= dAux;
	
				dAux=dp.textLengthForStyle(strLength, sDimStyle);
				if (dTxtLL< dAux)
					dTxtLL= dAux; // todo: check this value, makes columns unaligned
					
	//			dAux=dp.textLengthForStyle(bm.strCutN()+" - "+bm.strCutP(), sDimStyle);
				dAux=dp.textLengthForStyle(sNewCutN+" - "+sNewCutP, sDimStyle);			
				if (dTxtLCN< dAux)
					dTxtLCN= dAux;
				
				dAux=dp.textLengthForStyle(sMaterialToDisplay, sDimStyle);
				if (dTxtLMaterial < dAux)
					dTxtLMaterial= dAux;	
				
				dAux=dp.textLengthForStyle(bm.grade(), sDimStyle);
				if (dTxtLGrade < dAux)
					dTxtLGrade= dAux;
	
				dAux=dp.textLengthForStyle(bm.label(), sDimStyle);
				if (dTxtLLabel < dAux)
					dTxtLLabel= dAux;
	
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
				dAux=dp.textLengthForStyle(T("|Joist Ref|"), sDimStyle);
			}
			else
			{
				dAux=dp.textLengthForStyle(T("|Nr.|"), sDimStyle);
			}
			if (dTxtLPos < dAux)
				dTxtLPos= dAux;
			
			dAux=dp.textLengthForStyle(T("|Dimension|"), sDimStyle);
			if ( (dTxtLW) < dAux)
				dTxtLW= dAux;
	
			dAux=dp.textLengthForStyle(T("|Length|"), sDimStyle);
			if (dTxtLL< dAux)
				dTxtLL= dAux;
			
			dAux=dp.textLengthForStyle(T("|Angle|"), sDimStyle);
			if (dTxtLCN< dAux)
				dTxtLCN= dAux;
			
			dAux=dp.textLengthForStyle(T("|Material|"), sDimStyle);
			if (dTxtLMaterial< dAux)
				dTxtLMaterial= dAux;
			
			dAux=dp.textLengthForStyle(T("|Grade|"), sDimStyle);
			if (dTxtLGrade< dAux)
				dTxtLGrade= dAux;
				
			dAux=dp.textLengthForStyle(T("|Label|"), sDimStyle);
			if (dTxtLLabel< dAux)
				dTxtLLabel= dAux;
	
			//Display the Title of each column
			if(bShowJoistReferences)
			{
				dp.draw(T("|Joist Ref|"),ptBaseLine,_XW,_YW,1,-1);						
			}
			else
			{
				dp.draw(T("|Nr.|"),ptBaseLine,_XW,_YW,1,-1);			
			}
	
			ptBaseLine=ptBaseLine+_XW*(dTxtLPos+dOffset);
			
			if(bShowLabel)
			{
				dp.draw(T("|Label|"),ptBaseLine,_XW,_YW,1,-1);
				ptBaseLine=ptBaseLine+_XW*(dTxtLLabel+dOffset);
			}
	
			dp.draw(T("|Dimension|"),ptBaseLine,_XW,_YW,1,-1);
			ptBaseLine=ptBaseLine+_XW*(dTxtLW+dOffset);
	
			dp.draw(T("|Length|"),ptBaseLine,_XW,_YW,1,-1);
			ptBaseLine=ptBaseLine+_XW*(dTxtLL+dOffset);
			
			if(bShowAngle)
			{
				dp.draw(T("|Angle|"),ptBaseLine+_XW*(dTxtLCN*0.3),_XW,_YW,1,-1);
				ptBaseLine=ptBaseLine+_XW*(dTxtLCN+dOffset);
			}
	
			dp.draw(T("|Amount|"),ptBaseLine,_XW,_YW,1,-1);
			ptBaseLine=ptBaseLine+_XW*(dTxtLCount+dOffset);
			
			if(bShowMaterial)
			{
				dp.draw(T("|Material|"),ptBaseLine,_XW,_YW,1,-1);
				ptBaseLine=ptBaseLine+_XW*(dTxtLMaterial+dOffset);
			}
			if(bShowGrade)
			{
				dp.draw(T("|Grade|"),ptBaseLine,_XW,_YW,1,-1);
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
						arW.swap(s2, s11);
						arH.swap(s2, s11);
						arL.swap(s2, s11);
						arDLength.swap(s2, s11);
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
						arW.swap(s2, s11);
						arH.swap(s2, s11);
						arL.swap(s2, s11);
						arDLength.swap(s2, s11);
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
				
				dp.draw(arWToShow[d]+" x "+arHToShow[d],ptBaseLine,_XW,_YW,1,-1);
				ptBaseLine=ptBaseLine+_XW*(dTxtLW+dOffset);
		
				dp.draw(arL[d],ptBaseLine,_XW,_YW,1,-1);//todo
				ptBaseLine=ptBaseLine+_XW*(dTxtLL+dOffset);

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
		sTitle=T("|Sip Panels|");
		dp.draw(sTitle,ptDraw,_XW,_YW,1,-1);
		ptDraw=ptDraw-_YW*(dTxtH*1.5);
	}
	
	
	for (int t=0; t<strSipStyle.length(); t++)
	{
		String sGroupName=strSipStyle[t];
		Sip arSip[0];
	
		// build lists of items to display
		String arLabel[0]; // label
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

			//String strLength; strLength.formatUnit(sh.dL(), nLunit, nPrec);
			String sSipLabel=sp.label()+sp.subLabel();
			
			String strLength; strLength.formatUnit(sp.dL(), sDimStyle);
			String strWidth; strWidth.formatUnit(sp.dW(), sDimStyle);
			String strThick; strThick.formatUnit(sp.dH(), sDimStyle);
			
			arSip.append(sp);
			
			arLabel.append(sSipLabel);
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
			
			double dAux=dp.textLengthForStyle(T("|Label|"), sDimStyle);
			if (dTxtLLabel  < dAux)
				dTxtLLabel = dAux;
			
			dAux=dp.textLengthForStyle(T("|Width|"), sDimStyle);
			if ( (dTxtLW) < dAux)
				dTxtLW= dAux;

			dAux=dp.textLengthForStyle(T("|Length|"), sDimStyle);
			if ( (dTxtLH) < dAux)
				dTxtLH= dAux;

			dAux=dp.textLengthForStyle(T("|Thickness|"), sDimStyle);
			if (dTxtLT< dAux)
				dTxtLT= dAux;
			
	
			//Display the Title of each column
			dp.draw(T("|Label|"),ptBaseLine,_XW,_YW,1,-1);
			ptBaseLine=ptBaseLine+_XW*(dTxtLLabel+dOffset);
	
			dp.draw(T("|Width|"),ptBaseLine,_XW,_YW,1,-1);
			ptBaseLine=ptBaseLine+_XW*(dTxtLW+dOffset);
	
			dp.draw(T("|Length|"),ptBaseLine,_XW,_YW,1,-1);
			ptBaseLine=ptBaseLine+_XW*(dTxtLH+dOffset);
	
			dp.draw(T("|Thickness|"),ptBaseLine,_XW,_YW,1,-1);
			ptBaseLine=ptBaseLine+_XW*(dTxtLT+dOffset);
			
			//dp.draw("Amount",ptBaseLine,_XW,_YW,1,-1);
			//ptBaseLine=ptBaseLine+_XW*(dTxtLCount+dOffset);
	
			ptDraw=ptDraw-_YW*(dTxtH*1.5);
					
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
	
	Map mpSheet;
	
	String strSheetNames[0];
	for (int i=0; i<shAll.length(); i++)
	{
		Sheet sh=shAll[i];
		String sName=sh.material();
		String sMaterial=sh.material();
		sMaterial.makeUpper();
		int nLocation=strSheetNames.find(sName, -1);
		if (sArrMaterials.find(sMaterial, -1)==-1)//Filter the material Names
		{
			if (nLocation==-1)
			{
				strSheetNames.append(sName);
			}
		}
		if (bShowShPosnum)
		{
			int nThisZone=sh.myZoneIndex();
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
	
		for (int m=0; m<shAll.length(); m++)
		{
			if (shAll[m].material()==sGroupName)
			{
				arSheet.append(shAll[m]);
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
				String strLength; strLength.formatUnit(sh.dL(), sDimStyle);
				String strWidth; strWidth.formatUnit(sh.dW(),sDimStyle);
				String strThick; strThick.formatUnit(sh.dH(),sDimStyle);
				if ( (strThick==arT[l]) && (strPos==arPos[l]) && (strWidth==arW[l]) && (strLength==arL[l]))
				{
					bNew = FALSE;
					arCount[l]++;
					break; // out of inner for loop, we have found the equal one
				}
			}
			if (bNew)
			{ // a new item for the list is found
				String strPos = String(sh.posnum());
				strPos.trimLeft();
				strPos.trimRight();
				if (strPos=="-1") strPos = "";
				
				//String strLength; strLength.formatUnit(sh.dL(), nLunit, nPrec);
				String strLength; strLength.formatUnit(sh.dL(), sDimStyle);
				String strWidth; strWidth.formatUnit(sh.dW(), sDimStyle);
				String strThick; strThick.formatUnit(sh.dH(), sDimStyle);
				arCount.append(1);
				arW.append(strWidth);
				arL.append(strLength);
				arPos.append(strPos);
				arT.append(strThick);
	
				//Check the space needed for the table
				double dAux=dp.textLengthForStyle(T("|Amount|"), sDimStyle);
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
			
			double dAux=dp.textLengthForStyle(T("|Nr.|"), sDimStyle);
			if (dTxtLPos < dAux)
				dTxtLPos= dAux;
			
			dAux=dp.textLengthForStyle(T("|Dimension|"), sDimStyle);
			if ( (dTxtLW) < dAux)
				dTxtLW= dAux;
	
			dAux=dp.textLengthForStyle(T("|Thickness|"), sDimStyle);
			if (dTxtLT< dAux)
				dTxtLT= dAux;
			
	
			//Display the Title of each column
			dp.draw(T("|Nr.|"),ptBaseLine,_XW,_YW,1,-1);
			ptBaseLine=ptBaseLine+_XW*(dTxtLPos+dOffset);
	
			dp.draw(T("|Dimension|"),ptBaseLine,_XW,_YW,1,-1);
			ptBaseLine=ptBaseLine+_XW*(dTxtLW+dOffset);
	
			dp.draw(T("|Thickness|"),ptBaseLine,_XW,_YW,1,-1);
			ptBaseLine=ptBaseLine+_XW*(dTxtLT+dOffset);
			
	
			dp.draw(T("|Amount|"),ptBaseLine,_XW,_YW,1,-1);
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
	TslInst tslAll[]=el.tslInst();
	
	String strTSLNames[0];
	for (int i=0; i<tslAll.length(); i++)
	{
		TslInst tsl=tslAll[i];
		
		Map mp=tsl.map();
		
		if (mp.hasMap("TSLBOM"))
		{
			Map mpThisTSL=mp.getMap("TSLBOM");
			String sName=mpThisTSL.getString("Name");
			String sType=mpThisTSL.getString("Type");
			sName.trimLeft();
			sName.trimRight();
			sName.makeUpper();
			sType.trimLeft();
			sType.trimRight();
			sType.makeUpper();
			String sThisName=sName;
			int nLocation=strTSLNames.find(sThisName, -1);
			if (strTSLNames.find(sThisName, -1)==-1)//Filter the material Names
			{
				if (nLocation==-1)
				{
					strTSLNames.append(sName);
				}
			}
		}
	}
	
	if (strTSLNames.length()>0)
	{
		sTitle=T("|Metalparts|");
		dp.draw(sTitle, ptDraw, _XW,_YW,1,-1);
		ptDraw=ptDraw-_YW*(dTxtH*1.5);
	}
	
	for (int t=0; t<strTSLNames.length(); t++)
	{
		String sGroupName=strTSLNames[t];
		TslInst arTSL[0];
	
		// build lists of items to display
		int nNum = 0; // number of different items; make sure nNum is always the size of the arrays

		String arPos[0]; // posnum
		String arName[0]; // name
		String arType[0]; // type
		int arCount[0]; // counter of equal

		double dTxtLPos=0;
		double dTxtLName=0;
		double dTxtLType=0;
		double dTxtLCount=0;
		
		for (int m=0; m<tslAll.length(); m++)
		{
			TslInst tsl=tslAll[m];
			Map mp=tsl.map();
			if (mp.hasMap("TSLBOM"))
			{
				Map mpThisTSL=mp.getMap("TSLBOM");
				String sName=mpThisTSL.getString("Name");
				String sType=mpThisTSL.getString("Type");
				sName.trimLeft();
				sName.trimRight();
				sName.makeUpper();
				sType.trimLeft();
				sType.trimRight();
				sType.makeUpper();
				//String sThisName=sName+" "+sType;
				String sThisName=sName;
				
				if (sThisName==sGroupName)
				{
					arTSL.append(tsl);
				}
			}
		}// End Map Beams Loop
		
		//reportNotice("\n"+sGroupName+" "+arSheet.length());
		
		for (int i=0; i<arTSL.length(); i++)
		{
			// loop over list items
			int bNew = TRUE;
			TslInst tsl = arTSL[i];
			for (int l=0; l<nNum; l++)
			{
				String strPos = String(tsl.posnum());
				if (strPos=="-1") strPos = "";

				if (strPos==arPos[l])
				{
					bNew = FALSE;
					arCount[l]++;
					break; // out of inner for loop, we have found the equal one
				}
			}
			if (bNew)
			{ // a new item for the list is found
			
				//TslInst tsl=tslAll[i];
				Map mp=tsl.map();
				if (mp.hasMap("TSLBOM"))
				{
					Map mpThisTSL=mp.getMap("TSLBOM");
					String sName=mpThisTSL.getString("Name");
					String sType=mpThisTSL.getString("Type");
					sName.trimLeft();
					sName.trimRight();
					sName.makeUpper();
					sType.trimLeft();
					sType.trimRight();
					sType.makeUpper();
					String sThisName=sName;
					
					String strPos = String(tsl.posnum());
					strPos.trimLeft();
					strPos.trimRight();
					if (strPos=="-1") strPos = "";
					
					arPos.append(strPos);
					arName.append(sName);
					arType.append(sType);
					arCount.append(1);

					//Check the space needed for the table
					double dAux=dp.textLengthForStyle(T("|Amount|"), sDimStyle);
					if (dTxtLCount < dAux)
						dTxtLCount = dAux;
					dAux=dp.textLengthForStyle(strPos, sDimStyle);
					if (dTxtLPos < dAux)
						dTxtLPos= dAux;
					dAux=dp.textLengthForStyle(sName, sDimStyle);
					if (dTxtLName < dAux)
						dTxtLName= dAux;
					dAux=dp.textLengthForStyle(sType, sDimStyle);
					if (dTxtLType< dAux)
						dTxtLType= dAux;

					nNum++;
				}
			}
		}	
		
		if (arTSL.length()>0)
		{
			//The information of that Group is ready to display
			//Display the Title of the Group
			dp.draw(sGroupName, ptDraw,_XW,_YW,1,-1);
			ptDraw=ptDraw-_YW*(dTxtH*1.5);
			Point3d ptBaseLine=ptDraw;
			//Check if the title is not bigger than the text on the columns
			
			double dAux=dp.textLengthForStyle(T("|Nr.|"), sDimStyle);
			if (dTxtLPos < dAux)
				dTxtLPos= dAux;
			
			dAux=dp.textLengthForStyle(T("|Name|"), sDimStyle);
			if ( (dTxtLName) < dAux)
				dTxtLName= dAux;
	
			dAux=dp.textLengthForStyle(T("|Type|"), sDimStyle);
			if (dTxtLType< dAux)
				dTxtLType= dAux;
			
	
			//Display the Title of each column
			dp.draw(T("|Nr.|"),ptBaseLine,_XW,_YW,1,-1);
			ptBaseLine=ptBaseLine+_XW*(dTxtLPos+dOffset);
	
			dp.draw(T("|Name|"),ptBaseLine,_XW,_YW,1,-1);
			ptBaseLine=ptBaseLine+_XW*(dTxtLName+dOffset);
	
			dp.draw(T("|Type|"),ptBaseLine,_XW,_YW,1,-1);
			ptBaseLine=ptBaseLine+_XW*(dTxtLType+dOffset);
			
	
			dp.draw(T("|Amount|"),ptBaseLine,_XW,_YW,1,-1);
			ptBaseLine=ptBaseLine+_XW*(dTxtLCount+dOffset);
	
			ptDraw=ptDraw-_YW*(dTxtH*1.5);
					
			for (int d=0; d<arPos.length(); d++)
			{
				ptBaseLine=ptDraw;
	
				//Display the Values of each row
				dp.draw(arPos[d], ptBaseLine,_XW,_YW,1,-1);//+_XW*(dTxtLPos*.3)
				ptBaseLine=ptBaseLine+_XW*(dTxtLPos+dOffset);

				dp.draw(arName[d], ptBaseLine,_XW,_YW,1,-1);
				ptBaseLine=ptBaseLine+_XW*(dTxtLName+dOffset);

				dp.draw(arType[d], ptBaseLine+_XW*(dTxtLType*.45),_XW,_YW,1,-1);
				ptBaseLine=ptBaseLine+_XW*(dTxtLType+dOffset);

				dp.draw(arCount[d], ptBaseLine+_XW*(dTxtLCount*.45),_XW,_YW,1,-1);
				ptBaseLine=ptBaseLine+_XW*(dTxtLCount+dOffset);
		
				ptDraw=ptDraw-_YW*(dTxtH*1.5);
	
			}
			ptDraw=ptDraw-_YW*(dTxtH*0.5);
			
		}
	}//End loop throw all levels
}
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
				double dAux=dp.textLengthForStyle(T("|Amount|"), sDimStyle);
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
			
			double dAux=dp.textLengthForStyle(T("|Nr.|"), sDimStyle);
			if (dTxtLPos < dAux)
				dTxtLPos= dAux;
			
			dAux=dp.textLengthForStyle(T("|Dimension|"), sDimStyle);
			if ( (dTxtLW) < dAux)
				dTxtLW= dAux;
	
			dAux=dp.textLengthForStyle(T("|Length|"), sDimStyle);
			if (dTxtLT< dAux)
				dTxtLT= dAux;
			
	
			//Display the Title of each column
			dp.draw(T("|Nr.|"),ptBaseLine,_XW,_YW,1,-1);
			ptBaseLine=ptBaseLine+_XW*(dTxtLPos+dOffset);
	
			dp.draw(T("|Dimension|"),ptBaseLine,_XW,_YW,1,-1);
			ptBaseLine=ptBaseLine+_XW*(dTxtLW+dOffset);
	
			dp.draw(T("|Length|"),ptBaseLine,_XW,_YW,1,-1);
			ptBaseLine=ptBaseLine+_XW*(dTxtLT+dOffset);
			
	
			dp.draw(T("|Amount|"),ptBaseLine,_XW,_YW,1,-1);
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



for (int i=0;i<ptLocation.length(); i++)
{
	String sPos=sPosNumToShow[i];
	Point3d ptPosNum=ptLocation[i];
	Vector3d vecBmXCurr=vecBmX[i];
	Vector3d vMoveDirection=vMove[i];
	//vecBmXCurr.transformBy(ms2ps);
	vecBmXCurr.normalize();
	Vector3d vyCurr=vecBmXCurr.crossProduct(-_ZW);
	vyCurr.normalize();
	
	//ptPosNum=ptPosNum+vOffset*(dTextHeight);
	ptPosNum.transformBy(ms2ps);
	double dTxtLengthStyle = dp.textLengthForStyle(sPos, sDimStylePosnum);
	double dTxtHeightStyle =  dp.textHeightForStyle(sPos, sDimStylePosnum);

	dp.textHeight(0.9 * dTxtHeightStyle);

	// createposnum mask
	PLine plPosNum(_ZW);
	plPosNum.addVertex(ptPosNum- 0.6 *(vecBmXCurr * dTxtLengthStyle + vyCurr * dTxtHeightStyle)); 	
	plPosNum.addVertex(ptPosNum- 0.6 *(vecBmXCurr * dTxtLengthStyle -  vyCurr* dTxtHeightStyle));
	plPosNum.addVertex(ptPosNum+ 0.6 *(vecBmXCurr * dTxtLengthStyle +  vyCurr * dTxtHeightStyle));
	plPosNum.addVertex(ptPosNum+ 0.6 *(vecBmXCurr * dTxtLengthStyle - vyCurr * dTxtHeightStyle));	
	plPosNum.close();	
	PlaneProfile ppPosNum(plPosNum);
	ppPosNum.shrink(-.1 * dTxtHeightStyle);
	ppPosNum.vis(3);
	
	// ensure posnums do not intersect
	int m,d;
	d = 1;
	PlaneProfile pp0 = PlaneProfile(plPosNum);
	
	pp0.intersectWith(ppAllPosNum);

	while (m < 20 && pp0.area() > 0)
	{	
		ptPosNum.transformBy(vMoveDirection * d * dTxtHeightStyle * 1);
		plPosNum.transformBy(vMoveDirection * d * dTxtHeightStyle * 1);
		m++;
		if (d<0)
			d = m+1;
		else
			d = -m-1;
		
		pp0 = PlaneProfile(plPosNum);
		pp0.shrink(-.01 * dTxtHeightStyle);	
		pp0.intersectWith(ppAllPosNum);
	}
	ppAllPosNum.joinRing(plPosNum,_kAdd);
	ppPosNum.shrink(-.1 * dTxtHeightStyle);


	dpPos.draw(sPos, ptPosNum - vMoveDirection * 0.05 * dTxtHeightStyle, vecBmXCurr, vyCurr, 0,0);		

	//dp.draw (sPos, , _XW, _YW, 0, 0);
	//dpBox.draw(plPosNum);//, nDrawFilled
}




#End
#BeginThumbnail
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
K%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`'__V44`
`







#End