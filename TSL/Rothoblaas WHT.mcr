#Version 8
#BeginDescription
#Versions
2.6 17.04.2024 HSB-21887: Apply nonail area only inside sheet area; allow one entry at oversize nonail area 
2.5 07.11.2022 HSB-16852: Support selection of a washer
Version 2.4   21.12.2021   HSB-14106 display published for hsbMake and hsbShare
Version 2.3   24.11.2021   HSB-13451: add height as a property
Version 2.2   08.10.2021   HSB-13448, HSB-13449 double anchor tooling in special mode fixed, HSB-13450 double anchor refused if beam too small
Version 2.1   22.09.2021   HSB-13213 new property element view format, custom commands to edit fixtures
Version 2.0   20.09.2021   HSB-13213 CNC contour published for hsbCNC, new property 'Interdistance' to create a double anchor

This TSL inserts a Rothoblaas WHT anchor at StickFrame Walls, panels or beams


Test if cut out intersect sheet 
minor bugfix erase instance
assignment changed to Z0 layer (to be visible when plotting)
catalog insertion fixed, plan symbol added







#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 6
#KeyWords Anchor;Rothoblaas;Wall;Element
#BeginContents
/// <summary Lang=en>
/// This TSL inserts a Rothoblaas WHT anchor at StickFrame Walls, panels or beams
/// </summary>

/// <insert Lang=en>
/// 
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>
// #Versions
// 2.6 17.04.2024 HSB-21887: Apply nonail area only inside sheet area; allow one entry at oversize nonail area Author: Marsel Nakuci
// 2.5 07.11.2022 HSB-16852: Support selection of a washer Author: Marsel Nakuci
// 2.4 21.12.2021 HSB-14106 display published for hsbMake and hsbShare , Author Thorsten Huck
// 2.3 24.11.2021 HSB-13451: add height as a property Author: Marsel Nakuci
// 2.2 08.10.2021 HSB-13448, HSB-13449 double anchor tooling in special mode fixed, HSB-13450 double anchor refused if beam too small , Author Thorsten Huck
// 2.1 22.09.2021 HSB-13213 new property element view format, custom commands to edit fixtures , Author Thorsten Huck
// 2.0 20.09.2021 HSB-13213 CNC contour published for hsbCNC, new property 'Interdistance' to create a double anchor , Author Thorsten Huck
///<version value="1.9" date="09jul19" author="thorsten.huck@hsbcad.com"> Alignment property added to submapX </version>
///<version value="1.8" date="06aug18" author="nils.gregor@hsbcad.com"> Test if cut out intersect sheet </version>
///<version value="1.7" date="07May18" author="nils.gregor@hsbcad.com"> preversion for testing</version>
///<version value="1.5" date="12mar18" author="nils.gregor@hsbcad.com"> anchor can be placed inside SFWall, can drill plates, hight according to lowest plate, size of NoNailAreas can be adjusted per zone,companyspecific behavior, works with Num1</version>
///<version value="1.4" date="14sep17" author="florian.wuermseer@hsbcad.com"> minor bugfix display nailing holes</version>
///<version value="1.3" date="11sep17" author="florian.wuermseer@hsbcad.com"> minor bugfix erase instance</version>
///<version value="1.2" date="21july17" author="florian.wuermseer@hsbcad.com"> assignment changed to Z0 layer (to be visible when plotting)</version> 
///<version value="1.1" date="21july17" author="florian.wuermseer@hsbcad.com"> catalog insertion fixed, plan symbol added</version> 
///<version value="1.0" date="13sep16" author="florian.wuermseer@hsbcad.com"> initial version</version> 


//region Constants 
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	// read a potential mapObject defined by hsbDebugController
	{ 
		MapObject mo("hsbTSLDev" ,"hsbTSLDebugController");
		if (mo.bIsValid()){Map m = mo.map(); for (int i=0;i<m.length();i++) if (m.getString(i)==scriptName()){bDebug = true;	break;}}
		if(bDebug)reportMessage("\n"+ scriptName() + " starting " + _ThisInst.handle());		
	}
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};

	String sSpecials[] = {"BAUFRITZ", "RUB"}; // declare a list of supported specials. specials might change behaviour and available properties
	int nSpecial = sSpecials.find(projectSpecial().makeUpper());

//end Constants//endregion

//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sPathGeneral = _kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\";	
	String sFileName ="FixtureDefinition";
	Map mapSetting;

// compose settings file location
	String sFolders[]=getFoldersInFolder(sPath); 
	int bPathFound = _bOnInsert ? sFolders.find(sFolder) >- 1 ? true : makeFolder(sPath + "\\" + sFolder) : false;
	String sFullPath = sPath+"\\"+sFolder+"\\"+sFileName+".xml";

// read a potential mapObject
	MapObject mo(sDictionary ,sFileName);
	if (mo.bIsValid())
	{
		mapSetting=mo.map();
		setDependencyOnDictObject(mo);
	}
	// create a mapObject to make the settings persistent	
	else if ((_bOnInsert || _bOnDebug) && !mo.bIsValid() )
	{
		String sFile=findFile(sFullPath); 
	// if no settings file could be found in company try to find it in the installation path
		if (sFile.length()<1) sFile=findFile(sPathGeneral+sFileName+".xml");	
		if (sFile.length()>0)
		{ 
			mapSetting.readFromXmlFile(sFile);
			mo.dbCreate(mapSetting);			
		}
	}
	// validate version when creating a new instance
	if(_bOnDbCreated)
	{ 
		int nVersion = mapSetting.getInt("GeneralMapObject\\Version");
		String sFile = findFile(sPathGeneral + sFileName + ".xml");		// set default xml path
		if (sFile.length()<1) sFile=findFile(sFullPath);				// set custom xml path if no default found
		Map mapSettingInstall; mapSettingInstall.readFromXmlFile(sFile);	// read the xml from installation directory
		int nVersionInstall = mapSettingInstall.getMap("GeneralMapObject").getInt("Version");		
		if(sFile.length()>0 && nVersion!=nVersionInstall)
			reportNotice(TN("|A different Version of the settings has been found for|") + scriptName()+
			TN("|Current Version| ")+nVersion + "	" + _kPathDwg + TN("|Other Version| ") +nVersionInstall + "	" + sFile);
	}
//End Settings//endregion	

//region Read Settings
	Map mapFixings;
	String sFixings[0], sAllFixings[0];
{
	String k;
	mapFixings = mapSetting.getMap("Fixture[]");
	
	for (int i = 0; i < mapFixings.length(); i++)
	{
		Map m = mapFixings.getMap(i);
		Map mapApps = m.getMap("Application[]");
		
	// get the list where this fixture is applicable to	
		String apps[0];
		for (int i=0;i<mapApps.length();i++)
		{
			String app = mapApps.getString(i);
			if (app.length()>-1 && apps.findNoCase(app,-1)<0)
				apps.append(app);
		}	
		String script = bDebug?"Rothoblaas WHT":scriptName();
		int bAllowed = apps.findNoCase(script ,- 1) >- 1;
		
		String name = m.getMapName();
		if (name.length() > 0 && sFixings.findNoCase(name ,- 1) < 0)
		{
			if (bAllowed)
				sFixings.append(name);
			sAllFixings.append(name);	
		}
	}//next i
}
// Fall back to defaults if no fixing settings could be found
	int bUseDefaultFixing = sFixings.length() < 1;
	
//End Read Settings//endregion 


//region DialogMode
	int nDialogMode = _Map.getInt("DialogMode");
	if (nDialogMode>0)
	{ 
	// add/edit entry	
		if (nDialogMode == 1) //specify index when triggered to get different dialogs
		{
			setOPMKey("EditFixing");

			String sArticleName=T("|Article|");	
			PropString sArticle(nStringIndex++, "", sArticleName);	
			sArticle.setDescription(T("|Defines the Article|"));
			sArticle.setCategory(category);
			
			String sManufacturerName=T("|Manufacturer|");	
			PropString sManufacturer(nStringIndex++, "", sManufacturerName);	
			sManufacturer.setDescription(T("|Defines the Manufacturer|"));
			sManufacturer.setCategory(category);
			
			String sDescriptionName=T("|Description|");	
			PropString sDescription(nStringIndex++, "", sDescriptionName);	
			sDescription.setDescription(T("|Defines the Description|"));
			sDescription.setCategory(category);
			
			String sCategoryName=T("|Category|");	
			PropString sCategory(nStringIndex++, "", sCategoryName);	
			sCategory.setDescription(T("|Defines the Category|"));
			sCategory.setCategory(category);
			
			String sModelName=T("|Model|");	
			PropString sModel(nStringIndex++, "", sModelName);	
			sModel.setDescription(T("|Defines the Model|"));
			sModel.setCategory(category);

		category = T("|Geometry|");
			String sScaleXName=T("|Scale X|");	
			PropDouble dScaleX(nDoubleIndex++, U(0), sScaleXName);	
			dScaleX.setDescription(T("|Defines the Scale X|"));
			dScaleX.setCategory(category);
			
			String sScaleYName=T("|Scale Y|");	
			PropDouble dScaleY(nDoubleIndex++, U(0), sScaleYName);	
			dScaleY.setDescription(T("|Defines the Scale Y|"));
			dScaleY.setCategory(category);
			
			String sScaleZName=T("|Scale Z|");	
			PropDouble dScaleZ(nDoubleIndex++, U(0), sScaleZName);	
			dScaleZ.setDescription(T("|Defines the Scale Z|"));
			dScaleZ.setCategory(category);
	
		}
	// delete entry	
		else if (nDialogMode == 2) //specify index when triggered to get different dialogs
		{
			setOPMKey("RemoveFixing");

			String sArticleName=T("|Article|");	
			PropString sArticle(nStringIndex++, sFixings, sArticleName);	
			sArticle.setDescription(T("|Select article to be removed|"));
			sArticle.setCategory(category);
		}
		
		// tag entry to this script
		else if (nDialogMode == 3) //specify index when triggered to get different dialogs
		{
			setOPMKey("TagFixture");

			String sArticleName=T("|Article|");	
			PropString sArticle(nStringIndex++, sAllFixings, sArticleName);	
			sArticle.setDescription(T("|Select article to be tagged|"));
			sArticle.setCategory(category);

		}		
		
		return;		
	}
//End DialogMode//endregion


//region Collect anchor sizes and properties
	// name and descriptions
	String sArticleNames[] = {"WHT340", "WHT440", "WHT540", "WHT620", "WHT740"};
	String sArticleNumbers[] = {"WHT340", "WHT440", "WHT540", "WHT620", "WHT740"};
	
	// geometry
	double dHeights[] = {U(340), U(440), U(540), U(620), U(740)};
	double dWidths[] = {U(60), U(60), U(60), U(80), U(140)};
	double dDepths[] = {U(63), U(63), U(63), U(83), U(83)};
	double dThicknesses[] = {U(3), U(3), U(3), U(3), U(3)};
	double dHoleDiaTops[] = {U(5), U(5), U(5), U(5), U(5)};
	double dHoleOffsetTops[] = {U(190), U(210), U(190), U(190), U(150)};
	double dHoleDiaBottoms[] = {U(17), U(17), U(22), U(26), U(29)};
	double dHoleOffsetBottoms[] = {U(35), U(35), U(35), U(38), U(38)};
	
	// hardware
	int nQuantNailsFulls[] = {20, 30, 45, 55, 75};
	int nQuantNailsPartials[] = {14, 20, 27, 33, 45};
	String sNailTypes[] = {T("|Anchor Nail|") + " LBA 4x40", T("|Anchor Nail|") + " LBA 4x60", T("|Round head screw|") + " LBS 5x40", T("|Round head screw|") + " LBS 5x50"};
	String sNailNames[] = {"LBA440", "LBA440", "LBS540", "LBS560"};
	String sNailArticles[] = {"PF601440", "PF601460", "PF603540", "PF603560"};
	double dNailDias[] = {U(4), U(4), U(5), U(5)};
	double dNailLengths[] = {U(40), U(60), U(40), U(50)};
	String sMainScrews[] = {"VINYLPRO", "EPOPLUS"};
	double dMainScrewDias[] = {U(16), U(16), U(20), U(24), U(27)};
	
	if (!bUseDefaultFixing)
		sMainScrews	= sFixings;
	
// reinforcement washer
//	String sNameReinfWashers[] = {"---", "WHTBS50", "WHTBS50L", "WHTBS70L", "WHTBS130"};
//	String sArticleReinfWashers[] = {"---", "ULS505610", "ULS505610L", "ULS707720L", "ULS1307740"};
	
//	double dWasherWidths[] = {U(0), U(50), U(50), U(70), U(130)};
//	double dWasherDepths[] = {U(0), U(56), U(56), U(77), U(77)};
//	double dWasherThicknesses[] = {U(0), U(10), U(10), U(20), U(40)};
//	double dWasherDias[] = {U(0), U(18), U(22), U(26), U(29)};
	// HSB-16852
	String sNameReinfWashers[] ={ "WHTW50","WHTW50L","WHTW70","WHTW70L","WHTW130"};
	String sArticleReinfWashers[] ={ "WHTW50","WHTW50L","WHTW70","WHTW70L","WHTW130"};
	double dWasherWidths[] = {U(50), U(50), U(70),U(70), U(130)};
	double dWasherDepths[] = {U(56), U(56), U(77), U(77),U(77)};
	double dWasherThicknesses[] = {U(10), U(10), U(20),U(20), U(40)};
	double dWasherDias[] = {U(18), U(22),U(22), U(26), U(29)};
	
	int nWashers[]={ 0,0,0,1,2,3,4};// washer 0 has article 0,1,2
	int nArticles[]={0,1,2,2,3,3,4};// article 2 has washer 0 and 1
//endregion 


//region Properties
// Anchor model
category = T("|Type|");
	String sArticleNameName = T("|Type|");
	PropString sArticleName (nStringIndex++, sArticleNames, sArticleNameName);
	sArticleName.setCategory(category);
	sArticleName.setDescription(T("|Defines the anchor model|"));
	int nArticle = sArticleNames.find(sArticleName);
	
	String sInterdistanceName=T("|Interdistance|");
	PropDouble dInterdistance(3, U(0), sInterdistanceName);
	dInterdistance.setDescription(T("|Defines the Interdistance between two anchors.|"));
	dInterdistance.setCategory(category);
	
	String sWasherName = T("|Reinforcement Washer|");
	String sWashers[0];
	sWashers.append(sNameReinfWashers);
	PropString sWasher (nStringIndex++, sWashers, sWasherName);
	sWasher.setCategory(category);
	sWasher .setDescription(T("|Add a reinforcement washer to the anchor|"));
//	int nWasher = sNoYes.find(sWasher);
	int nWasher = sWashers.find(sWasher);
	
// Mounting properties
category =  T("|Mounting|");
	String sNailTypeName = T("|Mounting type|");
	PropString sNailType (nStringIndex++, sNailTypes, sNailTypeName);
	sNailType.setCategory(category);
	sNailType.setDescription(T("|Defines, if the anchor will be fixed with screws or nails|"));
	int nNailType = sNailTypes.find(sNailType);
	
	String sNailingName = T("|Nailing|");
	String sNailings[] = {T("|Full Nailing|"), T("|Partial Nailing|") + " - " + T("|Pattern|") + " 1", T("|PartinWasheral Nailing|") + " - " + T("|Pattern|") + " 2"};
	PropString sNailing (nStringIndex++, sNailings, sNailingName);
	sNailing.setCategory(category);
	sNailing.setDescription(T("|Defines, if anchor will be nailed completely or only partial|"));
	int nNailing = sNailings.find(sNailing);
	
	String sMainScrewName = T("|Anchoring to the ground|");
	PropString sMainScrew (nStringIndex++, sMainScrews, sMainScrewName);
	sMainScrew.setCategory(category);
	sMainScrew.setDescription(T("|Sets how the anchor will be fixed on the ground|"));
	int nMainScrew = sMainScrews.find(sMainScrew);	
	// height HSB-13451
	String sHeightPropName=T("|Height|");
	PropDouble dHeightProp(4, U(0), sHeightPropName);
	dHeightProp.setDescription(T("|Defines the HeightProp of the part with respect to the Wall base|"));
	dHeightProp.setCategory(category);
	
// tooling properties
category = T("|Tooling|");
	
	String sMillDepthName = T("|Mill depth|");
	PropDouble dMillDepth (0, U(0), sMillDepthName);
	dMillDepth.setCategory(category);
	dMillDepth.setDescription(T("|Defines the depth of the milling, the anchor sits in|"));
	
	String sMillOversizeName = T("|Oversize milling|");
	PropDouble dMillOversize (1, U(5), sMillOversizeName);
	dMillOversize.setCategory(category);
	dMillOversize.setDescription(T("|Defines the oversize of the milling, the anchor sits in|"));
	
	String sNoNailName = T("|No nail areas|");
	PropString sNoNail (nStringIndex++, sNoYes, sNoNailName);
	sNoNail.setCategory(category);
	sNoNail.setDescription(T("|Defines, if no nail areas will be added to StickFrame walls|") + "\n(" +	T("|You need hsbCAM module for this|") + ")");
	int nNoNail = sNoYes.find(sNoNail);
	
// Display
category = T("|Display|");
	
	String sDisplaySymbolName=T("|Plan view Symbol|");	
	PropString sDisplaySymbol(nStringIndex++, sNoYes, sDisplaySymbolName, 1);	
	sDisplaySymbol.setDescription(T("|Defines if there is a plan symbol displayed|"));
	sDisplaySymbol.setCategory(category);
	int nDisplaySymbol = sNoYes.find(sDisplaySymbol);

	String sSymbolColorName=T("|Color|");	
	PropInt nSymbolColor(nIntIndex++, 7, sSymbolColorName);	
	nSymbolColor.setDescription(T("|Defines the color of the plan symbol|"));
	nSymbolColor.setCategory(category);
	
// additional tooling properties ( added in version 1.5 )
category = T("|Additional Tooling|");
	
	String sNoNailZoneName = T("|Oversize No nail areas per zone|");
	PropString sNoNailZone (nStringIndex++,"", sNoNailZoneName);
	sNoNailZone.setCategory(category);
	sNoNailZone.setDescription(T("|Defines, the oversize of the no nail areas. Start from inside and seperate the volues by a| ; ") + "\n(" +	T("|You need hsbCAM module for this|") + ")");
	
	
	String sPlateDrillName = T("|Drilling plate|");
	PropString sPlateDrill (nStringIndex++, sNoYes, sPlateDrillName);
	sPlateDrill.setCategory(category);
	sPlateDrill.setDescription(T("|Defines, if the plate will be drilled automatically|") + "\n(" +	T("|You need hsbCAM module for this|") + ")");
	int nPlateDrill = sNoYes.find(sPlateDrill);
	
	String sDiaAddDrillName = T("|Oversize drill|");	
	PropDouble dDiaAddDrill (2, U(1), sDiaAddDrillName);
	dDiaAddDrill.setCategory(category);
	dDiaAddDrill.setDescription(T("|Defines the oversize of the plate drilling|"));	

category = T("|Display|");
	String sFormatName=T("|Elementview Format|");	
	PropString sFormat(nStringIndex++, "", sFormatName);	
	sFormat.setDescription(T("|Defines the Format|"));
	sFormat.setCategory(category);
//endregion 


// select properties from selected Article
	String sArticleNumber = sArticleNumbers[nArticle];
	// HSB-16852: valid washers for this article
	int nWashersValid[0];
	for (int i=0;i<nArticles.length();i++) 
	{ 
		if(nArticles[i]==nArticle)
		{ 
			nWashersValid.append(nWashers[i]);
		}
		else if(nArticles[i]>nArticle)
		{
			break;
		}
	}//next i
	if(nWasher>=0 && nWashersValid.find(nWasher)<0)
	{ 
		sWasher.set(sWashers[nWashersValid[0]]);
	}
	nWasher = sWashers.find(sWasher);
	
	// geometry
	double dHeight = dHeights[nArticle];
	double dWidth = dWidths[nArticle];
	double dDepth = dDepths[nArticle];
	double dThickness = dThicknesses[nArticle];
	double dHoleDiaTop = dHoleDiaTops[nArticle];
	double dHoleOffsetTop = dHoleOffsetTops[nArticle];
	double dHoleDiaBottom = dHoleDiaBottoms[nArticle];
	double dHoleOffsetBottom = dHoleOffsetBottoms[nArticle];
	
	// hardware
	int nQuantNailsFull = nQuantNailsFulls[nArticle];
	int nQuantNailsPartial = nQuantNailsPartials[nArticle];
	String sNailName = sNailNames[nNailType];
	String sNailArticle = sNailArticles[nNailType];
	double dNailDia = dNailDias[nNailType];
	double dNailLength = dNailLengths[nNailType];
	double dMainScrewDia = dMainScrewDias[nArticle];
	
	
	// reinforcement washer
//	String sNameReinfWasher = sNameReinfWashers[nArticle];
//	String sArticleReinfWasher = sArticleReinfWashers[nArticle];
//	
//	double dWasherWidth = dWasherWidths[nArticle];
//	double dWasherDepth = dWasherDepths[nArticle];
//	double dWasherThickness = dWasherThicknesses[nArticle];
//	double dWasherDia = dWasherDias[nArticle];
	
	String sNameReinfWasher = sNameReinfWashers[nWasher];
	String sArticleReinfWasher = sArticleReinfWashers[nWasher];
	
	double dWasherWidth = dWasherWidths[nWasher];
	double dWasherDepth = dWasherDepths[nWasher];
	double dWasherThickness = dWasherThicknesses[nWasher];
	double dWasherDia = dWasherDias[nWasher];

//region bOnInsert
// bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
	// silent/dialog
		String sKey = _kExecuteKey;
		sKey.makeUpper();

		if (sKey.length()>0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
			for(int i=0;i<sEntries.length();i++)
				sEntries[i] = sEntries[i].makeUpper();	
			if (sEntries.find(sKey)>-1)
				setPropValuesFromCatalog(sKey);
			else
				setPropValuesFromCatalog(T("|_LastInserted|"));					
		}
		else
			showDialog();
		

	// prepare TSL cloning
		TslInst tslNew;
		Vector3d vecXTsl= _XE;
		Vector3d vecYTsl= _YE;
		GenBeam gbsTsl[0];
		Entity entsTsl[0];
		Point3d ptsTsl[0];
		int nProps[]={nSymbolColor};
		double dProps[]={dMillDepth, dMillOversize, dDiaAddDrill, dInterdistance, dHeightProp};
		String sProps[]={sArticleName, sWasher, sNailType, sNailing, sMainScrew, sNoNail, sDisplaySymbol, sNoNailZone, sPlateDrill };
		Map mapTsl;	
		String sScriptname = scriptName();	
		
	// prompt for one or more beams or panels
		Entity entRefs[0];
		Entity entRefSips[0];
		Beam bmRefs[0];
		Sip sipRefs[0];
		TslInst tslTemp;
		
	// prompt for reference objects (beams)
		PrEntity ssRef(T("|Select beam(s) or panel(s)|"), Beam());
		ssRef.addAllowedClass(Sip());
	  	if (ssRef.go())
			entRefs.append(ssRef.set());
				
	// not vertical beams will be sorted out, directly
		int nRemove;
		for (int i=entRefs.length()-1; i>=0; i--)
		{
			if (entRefs[i].bIsKindOf(Beam()) == TRUE)
			{
				Beam bm = (Beam) entRefs[i];
				if (!bm.vecX().isParallelTo(_ZW))
					nRemove++;
				else
					bmRefs.append(bm);
			}
			
			if (entRefs[i].bIsKindOf(Sip()) == TRUE)
				sipRefs.append((Sip) entRefs[i]);
		}
		if (nRemove > 0)
			reportMessage("\n" + nRemove + " " + T("|not vertical beams were filtered out|"));
		
	// prompt for insert side, if Beam array > 0
		Point3d ptInsertSide;
		if (bmRefs.length() > 0)
		{
			mapTsl.setInt("Highlight", 1);
			
			tslTemp.dbCreate(scriptName(), vecXTsl, vecYTsl, bmRefs, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
			
			ptInsertSide = getPoint(T("|Pick point on desired insert side|"));
			
		// delete highlight 
			tslTemp.dbErase();
		}
		
	// TSL for each beam
		for (int i=0; i<bmRefs.length(); i++)
		{	
			Beam bmThis = bmRefs[i];
			Element elBeam = bmThis.element();
			Vector3d vecBeamInsertSide;
			double dBeamInsert;
			Point3d ptInsert;
			
	// Changed in version 1.5 so the fastener can be placed inside the SFWall		
			
//			if (elBeam.bIsValid() == TRUE)
//			{
//				Point3d ptElBeamCen = elBeam.ptOrg() - elBeam.vecZ()*.5*elBeam.dBeamWidth();
//				
//				int nSide = elBeam.vecZ().dotProduct(ptInsertSide - ptElBeamCen) / abs(elBeam.vecZ().dotProduct(ptInsertSide - ptElBeamCen));
//				vecBeamInsertSide = bmThis.vecD(elBeam.vecZ()*nSide);
//				dBeamInsert = .5*bmThis.dD(vecBeamInsertSide);
//				
//				ptInsert = bmThis.ptCen() + vecBeamInsertSide*dBeamInsert;
//				ptInsert.transformBy(-elBeam.vecY()*elBeam.vecY().dotProduct(ptInsert - elBeam.ptOrg()));
//			}
//			
//			else
//			{			
				vecBeamInsertSide = bmThis.vecD(ptInsertSide - bmRefs[i].ptCen());
				dBeamInsert = .5*bmThis.dD(vecBeamInsertSide);
				Plane pnBottom (bmThis.ptCen()-_ZW*.5*bmThis.dL(), bmThis.vecX());
				ptInsert = bmThis.ptCen() + vecBeamInsertSide*dBeamInsert;
				ptInsert = pnBottom.closestPointTo(ptInsert);
//			}
			
			mapTsl.setInt("Highlight", 0);
			
			mapTsl.setVector3d("vecAlign", _ZW);
			
			gbsTsl.setLength(0);
			gbsTsl.append(bmRefs[i]);
			
			ptsTsl.setLength(0);
			ptsTsl.append(ptInsert);
			
			tslNew.dbCreate(scriptName(), vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
					nProps, dProps, sProps,_kModelSpace, mapTsl);	
		}
		
		
		for (int i=0; i<sipRefs.length(); i++)
		{	
			Sip sipThis = sipRefs[i];
			Element elSip = sipThis.element();
			Vector3d vecAlign;
			Vector3d vecInsertSide;
			Point3d ptInsert;
			Quader qdSip (sipThis.ptCen(), sipThis.vecX(), sipThis.vecY(), sipThis.vecZ(), sipThis.dL(), sipThis.dW(), sipThis.dH());
			
		// create a highlight TSL
			Sip sp[] = {sipThis};
			ptsTsl.setLength(0);
			mapTsl.setInt("Highlight", 1);
			tslTemp.dbCreate(scriptName(), vecXTsl ,vecYTsl,sp, entsTsl, ptsTsl, 
						nProps, dProps, sProps,_kModelSpace, mapTsl);	

		// prompt for anchor alignment
			if (elSip.bIsValid() == TRUE && elSip.bIsKindOf(ElementWall()))
				vecAlign = elSip.vecY();
				
			else if (sipThis.vecZ().isPerpendicularTo(_ZU) == TRUE)
			{
				reportMessage("\n" + T("|Panel is vertical aligned in the current coordinate system|") + " --> " + T("|The suggested anchor alignment is in negative Z direction (downwards)|"));
				//String sChange = getString(T("|Do you want to flip the suggested direction?|") + " " + T("|Press <Enter> for keep suggested direction or any other string to flip it"));
				//if (sChange.length() == 0)
					vecAlign = _ZU;
				//else
					//vecAlign = -_ZU;
			}
			
			else
			{
				Point3d ptAlign;
				PrPoint ssAlignPoint("\n"+ T("|Set the anchor alignment|"), sipThis.ptCen()); 
				if (ssAlignPoint.go()==_kOk)
					ptAlign = ssAlignPoint.value();
				Plane pnAlign (sipThis.ptCen(), sipThis.vecZ());
				ptAlign = pnAlign.closestPointTo(ptAlign);
				vecAlign = (sipThis.ptCen()-ptAlign);
			}
			
			PrPoint ssP("\n"+ T("|Select insert point|") + " " + T("|or|") + " " + T("|<Enter> to continue|")); 
			while (ssP.go()==_kOk)
			{			
				Point3d pt = ssP.value();
				Vector3d vecInsertSide (pt - sipThis.ptCen());
				int nSipSide = 1;
				if (sipThis.vecZ().dotProduct(vecInsertSide) != 0)
					nSipSide = sipThis.vecZ().dotProduct(vecInsertSide) / abs(sipThis.vecZ().dotProduct(vecInsertSide));
				Plane pnInsert (sipThis.ptCen()+sipThis.vecZ()*nSipSide*.5*sipThis.dH(), sipThis.vecZ());
				pt = pnInsert.closestPointTo(pt);
				
			// when sip is part of an element, project insert points to the wall bottom edge
				if (elSip.bIsValid() == TRUE && elSip.bIsKindOf(ElementWall()))
				{
					Plane pnBottom (sipThis.ptCen()-elSip.vecY()*qdSip.dD(elSip.vecY()), elSip.vecY());
					pt = pnBottom.closestPointTo(pt);
//					reportMessage("\n" + sipThis.dD(elSip.vecY()));
				}
			
			// when sip is vertically aligned in current UCS, project insert points to the bottom edge
				else if (sipThis.vecZ().isPerpendicularTo(_ZU) == TRUE)
				{
					Plane pnBottom (sipThis.ptCen()-_ZU*qdSip.dD(_ZU), _ZU);
					pt = pnBottom.closestPointTo(pt);
				}
				
				
				
				mapTsl.setInt("Highlight", 0);
				
				mapTsl.setVector3d("vecAlign", vecAlign);
								
				gbsTsl.setLength(0);
				gbsTsl.append(sipThis);
				
				ptsTsl.setLength(0);
				ptsTsl.append(pt);
				
				tslNew.dbCreate(scriptName(), vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
						nProps, dProps, sProps,_kModelSpace, mapTsl);			
			}// do while point
			
		// delete highlight 
			tslTemp.dbErase();
		}
		
		
		eraseInstance();			
		return;
	}	
// end on insert ____________________________________________________________________________________________________________________________________________________________
// end on insert	__________________//endregion

// Highlight mode
if (_Map.hasInt("Highlight"))
{
	int nHighlight = _Map.getInt("Highlight");
	if (nHighlight == 1)
	{
	
		if (_bOnRecalc && _kExecuteKey == sDoubleClick)
		{
			eraseInstance();
			return;
		}
	
	
		for (int i=0; i<_GenBeam.length(); i++)
		{
			Body bd = _GenBeam[i].envelopeBody();
			PlaneProfile pp = bd.getSlice(Plane (_GenBeam[i].ptCen(), _GenBeam[i].vecZ()));
			
			Hatch ha ("ANSI37", 10);
			Display dp (6);
			dp.draw(pp, ha);
			setOPMKey("Highlight");
		}
		return;
	}
}
	
		

// Normal mode ____________________________________________________________________________________________________________________________________________________________
// validate reference objects

	if (_Beam.length() < 1 && _Sip.length() < 1 || (_Beam.length() >= 1 && _Sip.length() >= 1))
	{	
		reportMessage("\n" + T("|No reference objects found|") + " ---> " + T("|Tool will be deleted|"));
		if (!bDebug) eraseInstance();
		return;
	}
	
	if (_Map.hasVector3d("vecAlign") == 0) // highlight mode
	{	
		reportMessage("\n" + T("|No alignment definition found|") + " ---> " + T("|Tool will be deleted|"));
		if (!bDebug) eraseInstance();
		return;
	}
	
// declare standards	
	Beam bm = _Beam0;
	Sip sip = _Sip0;
	Element el = _GenBeam[0].element();
	Beam bmToMill[0];
	GenBeam gbToMill[] = {_GenBeam[0]};
	int bHasElement;
	
	int nQty = dInterdistance>0 && dInterdistance>=dWidth?2:1;
	
// check width 	HSB-13451
	if (nQty>1 && bm.dD(el.vecX())<dWidth+dInterdistance)
	{ 
		dInterdistance.set(0);
		reportMessage(TN("|Stud not wide enough to place two anchors, interdistance has been reset|"));
		nQty = 1;
		
	}
	

// Set sNoNail to YES if  an oversize for the no nail areas is given
	if(sNoNailZone != "")
		sNoNail.set(T("|Yes|"));

// determine, if reference GenBeam is part of an Element	
	if (el.bIsValid())
	{
		bHasElement = 1;
		if (bm.bIsValid())
		{
			bmToMill = el.beam();
			for (int i=0; i<bmToMill.length(); i++)
			{
				gbToMill.append(bmToMill[i]);
			}
		}
	}
	
// assignment
	if (bHasElement)
		assignToElementGroup(el, true, 0, 'E');
	else
		assignToGroups(_GenBeam[0], 'Z');
	
// erase and copy with beams
	setEraseAndCopyWithBeams(_kBeam0);

// detrmine if Beam or Panel mode	
	int nMode; // 0 = Sip-Mode, 1 = Beam-Mode	
	if (bm.bIsValid() == TRUE)
	{
		nMode = 1;
		if (bDebug) reportMessage("\n" + "Beam Mode");
	}
	else
		if (bDebug) reportMessage("\n" + "Panel Mode");
	
	Vector3d vecX, vecY, vecZ;
	Vector3d vecInsertSide, vecInsertPerp;
	int nSide;
	double dInsert;

// set position and alignment for beam mode	
	if (nMode == 1) // beam mode
	{
		if (!bm.vecX().isParallelTo(_ZW))
		{
			reportMessage("\n" + T("|The reference beam is not vertical|") + " ---> " + T("|Tool will be deleted|"));
			if (!bDebug) eraseInstance();
			return;
		}
			
			
		Plane pnBottom (bm.ptCen()-_ZW*.5*bm.dL(), bm.vecX());
		Body bdBeam = bm.envelopeBody();
		PlaneProfile ppBeam = bdBeam.shadowProfile(pnBottom);
		Point3d ptBottom = pnBottom.closestPointTo(bm.ptCen());
		ptBottom.vis(2);
		
	// Change in Version 1.5 Part was set inaktiv, so that the Fastener can sit inside a SFWall
	// -----------------------------------------------------------------------------------------
	
	// for element beams fix point to one wall side at the bottom end of the wall element
//		if (bHasElement == 1)
//		{
//			Point3d ptElementCen = el.ptOrg() - el.vecZ()*.5*el.dBeamWidth(); ptElementCen.vis(2);
//			nSide = el.vecZ().dotProduct(_Pt0 - ptElementCen) / abs(el.vecZ().dotProduct(_Pt0 - ptElementCen));
//			vecInsertSide = bm.vecD(el.vecZ()*nSide);
//			double dInsert = .5*bm.dD(vecInsertSide);
//			vecInsertPerp = vecInsertSide.crossProduct(bm.vecX());
//			vecInsertPerp.normalize();
//
//			PLine pl (ptBottom + nSide*el.vecZ()*dInsert + vecInsertPerp*.5*(bm.dD(vecInsertPerp)-dWidth), ptBottom + nSide*el.vecZ()*dInsert - vecInsertPerp*.5*(bm.dD(vecInsertPerp)-dWidth));
//			pl.vis(4);
//			
//			_Pt0 = pl.closestPointTo(_Pt0);
//			_Pt0.transformBy(-el.vecY()*el.vecY().dotProduct(_Pt0 - el.ptOrg()));
//		}
//	
//	// for free beams fix point to one side at the bottom end of the beam
//		else
//		{
//			vecInsertSide = bm.vecD(_Pt0 - ptBottom);
//			vecInsertSide.vis(_Pt0, 2);
//			double dInsert = .5*bm.dD(vecInsertSide);
//			vecInsertPerp = vecInsertSide.crossProduct(bm.vecX());
//			vecInsertPerp.normalize();
//			vecInsertPerp.vis(_Pt0, 30);
//
//			PLine pl (ptBottom + vecInsertSide*dInsert + vecInsertPerp*.5*(bm.dD(vecInsertPerp)-dWidth), ptBottom + vecInsertSide*dInsert - vecInsertPerp*.5*(bm.dD(vecInsertPerp)-dWidth));
//			
//			ppBeam.vis(5);
//
//			_Pt0 = pl.closestPointTo(_Pt0);
//			_Pt0 = pnBottom.closestPointTo(_Pt0);
//		}
//		
//	// declare the vectors
//		vecY = bm.vecD(_Pt0 - bm.ptCen());
//		vecZ = (bm.vecX().dotProduct(_Pt0-bm.ptCen()) / abs(bm.vecX().dotProduct(_Pt0-bm.ptCen()))) * -bm.vecX();
//		vecX = vecY.crossProduct(vecZ);

// New Part added in Version 1.5
	// Find closest point to Beam and set Fastener direction
	
		_Pt0 = ppBeam.closestPointTo(_Pt0);
		PlaneProfile ppBeam1 = ppBeam;
		ppBeam1.shrink(U(-10));
		Point3d ptP0 = ppBeam1.closestPointTo(_Pt0);
		vecY = (ptP0 - _Pt0);
		vecY.normalize();
		vecX = vecY.crossProduct(_ZW);
		vecZ = vecX.crossProduct(vecY);
		
	// declaring nSide
		
		if(vecY.isParallelTo(el.vecZ()))
			nSide = -1;
		if(vecY.isCodirectionalTo(el.vecZ()))
			nSide = 1;
			
	// Adjusting position if fasterner is overlaping the beam
	
		double dXpos = vecX.dotProduct(_Pt0 - bm.ptCen());
		if(dXpos + dWidth*0.5 - bm.dD(vecX)*0.5 > 0)
			_Pt0 = _Pt0 - vecX * (dXpos + dWidth * 0.5 - bm.dD(vecX) * 0.5);
		if(dXpos - dWidth*0.5 + bm.dD(vecX)*0.5 < 0)
			_Pt0 = _Pt0 + vecX * -1* (dXpos - dWidth * 0.5 + bm.dD(vecX) * 0.5);
	}
	
	
// set position and alignment for panel mode			
	else // sip mode
	{
	// determine insert side
		nSide = 1;
		vecInsertSide = _Pt0 - sip.ptCen();
		if (sip.vecZ().dotProduct(vecInsertSide) != 0)
		nSide = sip.vecZ().dotProduct(vecInsertSide) / abs(sip.vecZ().dotProduct(vecInsertSide));
		
	// fix point to outer edges of the panel
		PlaneProfile ppSip (sip.plShadowCnc());
		_Pt0 = ppSip.closestPointTo(_Pt0);
		Plane pnInsert (sip.ptCen()+sip.vecZ()*nSide*.5*sip.dH(), sip.vecZ());
		_Pt0 = pnInsert.closestPointTo(_Pt0);
		
	// 
		PLine plSipEdge (sip.vecZ());
		PlaneProfile ppSipSide = sip.realBody().extractContactFaceInPlane(pnInsert, U(10));
		PLine plSipEdges[] = ppSipSide.allRings();
		int nIsOpenings[] = ppSipSide.ringIsOpening();
		
		if (plSipEdges.length() > 0)
			plSipEdge = plSipEdges[0];
		
		
		ppSipSide.shrink(-.5*dWidth-dMillOversize);
		ppSipSide.shrink(.5*dWidth+dMillOversize);
		ppSipSide.vis(6);
	
	// declare the vectors
		vecZ = _Map.getVector3d("vecAlign");
		vecY = nSide*sip.vecZ();
		vecX = vecY.crossProduct(vecZ);
	}
		
	
	vecX.normalize();
	vecY.normalize();
	vecZ.normalize();
	
	vecX.vis(_Pt0, 1);
	vecY.vis(_Pt0, 3);
	vecZ.vis(_Pt0, 5);
	
// create recalc trigger to flip vecZ alignment (only in Panel mode)
	String sTriggerFlipZ = T("|Flip Z alignment|");
	if (nMode == 0)
		addRecalcTrigger(_kContext, sTriggerFlipZ);

	if (nMode == 0 && _bOnRecalc && (_kExecuteKey == sDoubleClick || _kExecuteKey == sTriggerFlipZ))
	{
		reportMessage("\n" + "Z flip triggered");
		vecZ = -vecZ;
		_Map.setVector3d("vecAlign", vecZ);
		setExecutionLoops(2);
	}
	
// create recalc trigger to align vecZ (only in Panel mode)
	String sSetVecZ = T("|Set Z alignment|");
	if (nMode == 0)
		addRecalcTrigger(_kContext, sSetVecZ);

	if (nMode == 0 && _bOnRecalc && _kExecuteKey == sSetVecZ)
	{
		Point3d ptZs[0];
		Point3d ptZ = _Pt0 + vecZ*U(100);
		reportMessage("\n" + "set Z alignment triggered");
		PrPoint ssPtZ (T("|select Z direction|"), _Pt0);
			if (ssPtZ.go()==_kOk)
			{
				ptZs.append(ssPtZ.value());
				ptZ = ptZs[0];
				vecZ = ptZ - _Pt0;
				vecZ = vecZ.crossProduct(sip.vecZ()).crossProduct(-sip.vecZ());
			}
					
		_Map.setVector3d("vecAlign", vecZ);
		setExecutionLoops(2);
	}
	
	
// tooling _____________________________________________________________________________________________________________________________________________________________

//Version 1.5 changing the height of _Pt0 if Beam is part of a wall
	
	if (bHasElement == 1 && el.bIsKindOf(ElementWallSF()))
	{
		int nJC=0;
		double dPlate;
		Beam bmPlate[] = bm.filterBeamsHalfLineIntersectSort(bmToMill, _Pt0 + vecZ*(dHeight - dEps) + vecY*dEps ,- _ZW);
		if (bmPlate.length() == 0 )
		{
			Beam bmPlate1[] = bm.filterBeamsHalfLineIntersectSort(bmToMill, bm.ptCen() ,- _ZW);
			for(int i=0; i < bmPlate1.length(); i++)
			{
				if(bmPlate1[i] == bm)
					bmPlate1.removeAt(i);
			}
		
			if (_ZW.dotProduct(el.ptOrg() - bmPlate1[bmPlate1.length() - 1].ptCen()) + 0.5 * bmPlate1[bmPlate1.length() - 1].dD(_ZW) > 0)
				_Pt0 = _Pt0 - _ZW * (_ZW.dotProduct(_Pt0 - bmPlate1[bmPlate1.length()-1].ptCen()) + 0.5  * bmPlate1[bmPlate1.length()-1].dD(_ZW));
			else
				_Pt0 = _Pt0 - _ZW * _ZW.dotProduct(_Pt0 - el.ptOrg());
		}
			
		else
		{
			_Pt0 = _Pt0 - _ZW * (_ZW.dotProduct(_Pt0 - bmPlate[0].ptCen()) - 0.5  * bmPlate[0].dD(_ZW));
			for (int i = 0; i < bmPlate.length(); i++)
				dPlate = dPlate + bmPlate[i].dD(-_ZW);
			nJC = 1;
			
			if(nPlateDrill == 1)	
			{
				Drill drPlate(_Pt0 + vecY * (dHoleOffsetBottom+dThickness - dMillDepth), _Pt0 + vecY * (dHoleOffsetBottom+dThickness - dMillDepth) - _ZW * (dPlate+dEps), (dHoleDiaBottom + dDiaAddDrill) * 0.5);
				drPlate.addMeToGenBeamsIntersect(bmPlate);
			}			
		}
		_Map.setInt("nJC",nJC);
	}
		
// Let the customer change the height
	String sSetHeight(T("|Select Fastener Height|"));
	double dHPt = 0;
	// HSB-13451 remove custom command for modifying height
//	if(_Map.hasDouble("dHPt"))
//		dHPt = _Map.getDouble("dHPT");
//	addRecalcTrigger(_kContext, sSetHeight);
//	if(_bOnRecalc && _kExecuteKey== sSetHeight)
//	{
//		 double dHilf = getDouble(T("|Select Fastener Height|"));
//		 dHPt = dHPt + dHilf;
//		_Map.setDouble("dHPt", dHPt );
//	}

	// for existing TSLs cleanup dHPt
	if(_Map.hasDouble("dHPt"))
	{ 
		dHPt = _Map.getDouble("dHPT");
		dHeightProp.set(dHPt);
		_Map.removeAt("dHPt", true);
	}

	dHPt = dHeightProp;

	_Pt0 = _Pt0 + vecZ * dHPt;
	
	
	if (dMillDepth > 0)
	{
		BeamCut bcAnchor (_Pt0, vecX, vecY, vecZ, dWidth+2*dMillOversize+dInterdistance, dMillDepth, dHeight+dMillOversize, 0,-1,1);
		//bcAnchor.cuttingBody().vis(2);
		bcAnchor.addMeToGenBeamsIntersect(gbToMill);		 
	}
	
	//Added in Version 1.5 
	// get the oversize of the nonailareas fot each zone
	
//	if (nSide !=0 && nNoNail == 1 && bHasElement == 1 && el.bIsKindOf(ElementWallSF())&& nSpecial!=1)// special not RUB
//	{
//	//	PLine plNoNail(_Pt0 - vecX*(.5*dWidth+dMillOversize), _Pt0 - vecX*(.5*dWidth+dMillOversize) + vecZ*(dHeight+dMillOversize), _Pt0 + vecX*(.5*dWidth+dMillOversize) + vecZ*(dHeight+dMillOversize), _Pt0 + vecX*(.5*dWidth+dMillOversize));
//	//	plNoNail.close();
//		
//		for (int i=1; i<6; i++)
//		{	
//			String sToken = sNoNailZone.token(i - 1, ";");
//			sToken.trimLeft();
//			sToken.trimRight();
//			double dToken = sToken.atof();
//			
//			double dX = .5 * dWidth + dMillOversize + dToken + .5 * dInterdistance;
//			if (el.zone(nSide*i).dH() > 0)
//			{
//				PLine plNoNail(_Pt0 - vecX*dX,
//					_Pt0 - vecX*dX+ vecZ*(dHeight+dMillOversize+dToken),
//					_Pt0 + vecX*dX + vecZ*(dHeight+dMillOversize+dToken),
//					_Pt0 + vecX*dX);
//				plNoNail.close();
//				ElemNoNail enn (nSide*i, plNoNail);
//				el.addTool(enn);
//			}
//		}
//	}
	
	
	if (nSide !=0 && bHasElement && el.bIsKindOf(ElementWallSF()) && nSpecial!=1)// special not RUB
	{ 
		PLine plCNCs[5]; // polylines zone 1-5	
		for (int i=0; i<5; i++)
		{	
			String sToken = sNoNailZone.token(i - 1, ";");
			sToken.trimLeft();
			sToken.trimRight();
			double dToken = sToken.atof();
			
			double dX = .5 * dWidth + dMillOversize + dToken + .5 * dInterdistance;
			
			PLine pl(_Pt0 - vecX*dX,
					_Pt0 - vecX*dX+ vecZ*(dHeight+dMillOversize+dToken),
					_Pt0 + vecX*dX + vecZ*(dHeight+dMillOversize+dToken),
					_Pt0 + vecX*dX);
			pl.close();		
			plCNCs[i]=pl;
			
			if (nNoNail == 1 && el.zone(nSide*i).dH() > 0)
			{ 
				ElemNoNail enn (nSide*i, pl);
				el.addTool(enn);
			}
		}	
		
	// publish CNC definition for zone 1 or -1
		if (plCNCs[0].area()>pow(dEps,2))
		{ 
			PLine pl = plCNCs[0];
//			if (pl.coordSys().vecZ().isCodirectionalTo(el.vecZ()*nSide))
//				pl.flipNormal();
			_Map.setPLine("plCNC", pl);
		}
		else
			_Map.removeAt("plCNC", true);
		
	}
	
	
// draw body, that represents the anchor
	_ThisInst.setHyperlink("http://www.rothoblaas.com/products/fastening/brackets-and-plates/tensile-angle-brackets-and-plates-for-buildings/wht");

// Displays
	if (_bOnDbCreated)_ThisInst.setColor(nSpecial == 0 ? 5 : 9);
	Display dp (_ThisInst.color()), dpElement(_ThisInst.color()), dpSpecial(_ThisInst.color());
	dp.showInDxa(true);
	dpElement.showInDxa(true);
	dpSpecial.showInDxa(true);
	
	double dTxtH = U(75);
	dpElement.addViewDirection(el.vecZ());
	dpElement.addViewDirection(-el.vecZ());
	if(nSpecial==0) 
	{
		
		dpElement.dimStyle("BF 0.2");
		dpElement.textHeight(dTxtH);
	// make it visible on layer J5
		dpSpecial.elemZone(el, 5, 'J');	
	}



	Point3d ptRef = _Pt0 - vecY*dMillDepth;
	Plane pnNail (ptRef + vecY*(dThickness+U(.1)), vecY);
	PlaneProfile ppNails[0];
	PlaneProfile ppNotNailed[0];
	
	Body bdBottomPlate (ptRef, vecX, vecY, vecZ, dWidth, dDepth, 3*dThickness, 0,1,1);
	Body bdBottomDrill (ptRef + vecZ*U(100), ptRef - vecZ*U(100), .5*dHoleDiaBottom);
	bdBottomDrill.transformBy(vecY*(dHoleOffsetBottom+dThickness));
	bdBottomPlate = bdBottomPlate - bdBottomDrill;
	
	Body bdTopPlate (ptRef, vecX, vecY, vecZ, dWidth, dThickness, dHeight, 0,1,1);
	int nQuantDouble = (dHeight-dHoleOffsetTop)/U(40)+1;
	int nQuantTriple = (dHeight-dHoleOffsetTop-U(20))/U(40)+1;
	
	PLine plDrill;
	plDrill.createCircle(ptRef + vecY * (dThickness+dEps) + vecZ*dHoleOffsetTop, vecY, .5*dHoleDiaTop);
	
	Vector3d vecXInter = nQty==2?vecX * .5 * dInterdistance:Vector3d(0,0,0);
	for (int i=0; i< nQuantDouble; i++)
	{
		PlaneProfile ppNail(plDrill);
		ppNail.transformBy(vecZ*i*U(40) + vecX*U(10));
		ppNail.transformBy(-vecXInter);
		
		
		for (int j=0;j<nQty;j++) 
		{ 
			//ppNail.vis(i);
			if (nNailing == 2)
				ppNotNailed.append(ppNail);
			else
				ppNails.append(ppNail);
			
			ppNail.transformBy(-vecX*U(20));
			if (nNailing == 2)
				ppNotNailed.append(ppNail);
			else
				ppNails.append(ppNail);			
			
			ppNail.transformBy(2*vecXInter+ vecX*U(20)); 
		}//next j

	}
		
	plDrill.transformBy(vecZ*U(20));
	for (int i=0; i< nQuantTriple; i++)
	{
		PlaneProfile ppNail(plDrill);
		ppNail.transformBy(vecZ*i*U(40));
		ppNail.transformBy(-vecXInter);
		
		for (int j = 0; j < nQty; j++)
		{
			ppNails.append(ppNail);
			
			ppNail.transformBy(vecX*U(20));
			if (nNailing == 0 || nNailing == 2) 
				ppNails.append(ppNail);
			else
				ppNotNailed.append(ppNail);
				
			ppNail.transformBy(-vecX*U(40));
			if (nNailing == 0 || nNailing == 2) 
				ppNails.append(ppNail);
			else
				ppNotNailed.append(ppNail);	
				
			ppNail.transformBy(2*vecXInter);
			ppNail.transformBy(vecX*U(20));
		}

	}
	
	Body bdAnchor = bdBottomPlate + bdTopPlate;
	
	PLine plBody(ptRef, ptRef + vecZ*U(150), ptRef + vecY*(dDepth-dThickness));
	plBody.close();
	Body bdSide (plBody, vecX*dThickness, 0);
	bdSide.transformBy (vecZ*3*dThickness + vecY*dThickness);
	bdSide.transformBy (vecX*.5*(dWidth - dThickness));
	
	bdAnchor = bdAnchor + bdSide;
	bdSide.transformBy (-vecX*(dWidth - dThickness));
	bdAnchor = bdAnchor + bdSide;
	
	bdAnchor.transformBy(-vecXInter);
	for (int j = 0; j < nQty; j++)
	{
		dp.draw(bdAnchor);
		if (nSpecial == 0)dpSpecial.draw(bdAnchor);
		bdAnchor.transformBy(2*vecXInter); 	
	}
	
//	if (nWasher == 1 && nArticle != 0)
	if (nWasher >=0)
	{
		Body bdWasher (ptRef+vecZ*3*dThickness+vecY*dThickness, vecX, vecY, vecZ, dWasherWidth, dWasherDepth, dWasherThickness, 0,1,1);
		Body bdWasherDrill (ptRef + vecZ*U(100), ptRef - vecZ*U(100), .5*dWasherDia);
		bdWasherDrill.transformBy(vecY*(dHoleOffsetBottom+dThickness));
		bdWasher = bdWasher - bdWasherDrill;
		
		if (nQty==1)
			dp.draw(bdWasher);
		else
		{ 
			bdWasher.transformBy(-vecXInter);
			dp.draw(bdWasher);
			bdWasher.transformBy(2*vecXInter);
			dp.draw(bdWasher);			
		}
	}
	
	for (int i=0; i<ppNotNailed.length(); i++)
	{
		dp.draw(ppNotNailed[i]);
	}
	
	if (nNailing==0)
		dp.color(1);
	else if (nNailing==1)
		dp.color(4);
	else if (nNailing==2)
		dp.color(6);	

				
	for (int i=0; i<ppNails.length(); i++)
	{
		dp.draw(ppNails[i], _kDrawFilled);
	}
	
	
// symbol in plan view
	if (nDisplaySymbol == 1)
	{
		Display dpSymbol (nSymbolColor);
		dpSymbol.addViewDirection(vecZ);
		dpSymbol.showInDxa(true);
		
		PLine plCircle0, plCircle1;
		plCircle0.createCircle(_Pt0 + vecZ*(dHeight + U(100)), vecZ, U(56));
		plCircle1.createCircle(_Pt0 + vecZ*(dHeight + U(100)), vecZ, U(53));
		PlaneProfile ppCircle (plCircle0);
		ppCircle.joinRing(plCircle1, 1);
		
		PLine plTriangle (vecZ);
		Vector3d vecTriangle = -vecY;
		plTriangle.addVertex(_Pt0 + vecZ*(dHeight + U(100)) + vecTriangle*U(53));
		vecTriangle = vecTriangle.rotateBy(U(120), vecZ);
		plTriangle.addVertex(_Pt0 + vecZ*(dHeight + U(100)) + vecTriangle*U(53));
		vecTriangle = vecTriangle.rotateBy(U(120), vecZ);
		plTriangle.addVertex(_Pt0 + vecZ*(dHeight + U(100)) + vecTriangle*U(53));
		plTriangle.close();
		PlaneProfile ppTriangle (plTriangle);
		
		
		ppCircle.transformBy(-vecXInter);
		ppTriangle.transformBy(-vecXInter);
		dpSymbol.draw(ppCircle, _kDrawFilled);
		dpSymbol.draw(ppTriangle, _kDrawFilled);
		
		if (nQty==2)
		{ 
			ppCircle.transformBy(2*vecXInter);
			ppTriangle.transformBy(2*vecXInter);
			dpSymbol.draw(ppCircle, _kDrawFilled);
			dpSymbol.draw(ppTriangle, _kDrawFilled);			
		}
	}


// Hardware//region
	Map mapAdditionals;
// collect existing hardware
	HardWrComp hwcs[] = _ThisInst.hardWrComps();
	
// remove any tsl repType: the assumption is that any hardware component of type _kRTTsl has been attached by this instance
	for (int i=hwcs.length()-1; i>=0 ; i--) 
		if (hwcs[i].repType() == _kRTTsl)
			hwcs.removeAt(i); 

// declare the groupname of the hardware components
	String sHWGroupName;
	// set group name
	{ 
		if (el.bIsValid()) 	sHWGroupName=el.elementGroup().name();
	// loose
		else
		{
			Group groups[] = _ThisInst.groups();
			if (groups.length()>0)	sHWGroupName=groups[0].name();
		}		
	}
	
// add anchor
	String sHWNotes;
	//Added in Version 1.5 if anchor is inside the SFWall setNotes is set to company
		if (_Map.hasInt("nJC"))
		{
			int nJC = _Map.getInt("nJC");
			if (nJC != 0 )
				sHWNotes=T("|company|");
			if (nJC == 0 )
				sHWNotes=T("|jobside|");
		}

	{ 
		String sDescription = T("|Tensile anchor|") + " - " + T("|Type|") + " " + sArticleName;

		HardWrComp hwc(sMainScrew, nQty); // the articleNumber and the quantity is mandatory
		
		hwc.setManufacturer("Rothoblaas");
		
		hwc.setModel(sArticleName);
		hwc.setName(sArticleName);
		hwc.setDescription(sDescription);
		hwc.setMaterial(T("|Steel|"));
		hwc.setNotes(sHWNotes);
		hwc.setGroup(sHWGroupName);
		hwc.setCategory(T("|Anchor|"));
		hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
		
		hwc.setDScaleX(dHeight);
		hwc.setDScaleY(dWidth);
		hwc.setDScaleZ(dDepth);
		
	// apppend component to the list of components
		hwcs.append(hwc);
	}


// add nails
	{
		HardWrComp hwc(sNailArticle, ppNails.length()); // the articleNumber and the quantity is mandatory
		
		hwc.setManufacturer("Rothoblaas");
		
		hwc.setModel(sNailName);
		hwc.setName(sNailName);
		hwc.setDescription(sNailType);
		hwc.setMaterial(T("|Steel|"));
		hwc.setNotes(sHWNotes);		
		hwc.setGroup(sHWGroupName);
		hwc.setCategory(T("|Anchor|"));
		hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
		
		hwc.setDScaleX(dNailLength);
		hwc.setDScaleY(dNailDia);
		hwc.setDScaleZ(0);

		hwcs.append(hwc);
	}

// Default fixing to the ground	
	{
		HardWrComp hwc(sMainScrew, nQty);// the articleNumber and the quantity is mandatory
		hwc.setRepType(_kRTTsl); 
		int nFixing = sFixings.find(sMainScrew);
		
		if (bUseDefaultFixing)
		{ 
			hwc.setManufacturer("Rothoblaas");
			
			hwc.setModel("M" + dMainScrewDia);
			hwc.setName(sMainScrew);
			hwc.setDescription(sMainScrew + " M" + dMainScrewDia);
			hwc.setMaterial(T("|Steel|"));
			hwc.setNotes(sHWNotes);		
			hwc.setGroup(sHWGroupName);
			hwc.setCategory(T("|Anchor|"));
			hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
			
			hwc.setDScaleX(0);
			hwc.setDScaleY(dMainScrewDia);
			hwc.setDScaleZ(0);			
		}
		else if (nFixing>-1)
		{ 
			String _article = sMainScrew; _article.makeLower();
			for (int i=0;i<mapFixings.length();i++) 
			{ 
				Map m = mapFixings.getMap(i);
				String name = m.getMapName().makeLower();
				if (name == _article)
				{
					hwc.setManufacturer(m.getString("Manufacturer"));
					hwc.setDescription(m.getString("Description"));
					hwc.setCategory(m.getString("Category"));
					hwc.setModel(m.getString("Model"));
					hwc.setNotes(sHWNotes);	
					hwc.setNotes(sHWGroupName);	
					
					hwc.setMaterial(m.getString("Material"));
					hwc.setDScaleX(m.getDouble("ScaleX"));
					hwc.setDScaleY(m.getDouble("ScaleY"));
					hwc.setDScaleZ(m.getDouble("ScaleZ"));
					
					break;
				}
			}//next i			
		}			
		mapAdditionals.setString("ArticleNumber", hwc.articleNumber());
		mapAdditionals.setString("Manufacturer", hwc.manufacturer());
		mapAdditionals.setString("Description", hwc.description());
		mapAdditionals.setString("Category", hwc.category());

		hwcs.append(hwc);
	}


// reinforcement washer
//	if (nWasher == 1 && nArticle != 0)
	if (nWasher >=0)
	{
		HardWrComp hwc(sArticleReinfWasher, nQty);// the articleNumber and the quantity is mandatory
		
		hwc.setManufacturer("Rothoblaas");
		
		hwc.setModel(sNameReinfWasher + " d" + dWasherDia);
		hwc.setName(sNameReinfWasher);
		hwc.setDescription(T("|Washer|") + " " + sNameReinfWasher);
		hwc.setMaterial(T("|Steel|"));
		hwc.setNotes(sHWNotes);		
		hwc.setGroup(sHWGroupName);	
		hwc.setCategory(T("|Anchor|"));
		hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
		
		hwc.setDScaleX(dWasherWidth);
		hwc.setDScaleY(dWasherDepth);
		hwc.setDScaleZ(dWasherThickness);

		hwcs.append(hwc);
	}


// make sure the hardware is updated
	if (_bOnDbCreated)	setExecutionLoops(2);				
	_ThisInst.setHardWrComps(hwcs);	
	//endregion

//	 Individual toolset. Added in version 1.5
//	This will create an ElementSawLine around the NoNailAreas and cut out the sheet in zone 1 if zone 2 exists
	
//	remove cut out in sheet of zone 1/-1
	BeamCut bcSh;

	if(_Map.hasInt("nSide1"))	
	{
		int nSide1 = _Map.getInt("nSide1");
		Sheet shHilf[]= el.sheet(nSide1);
		for(int i=0; i < shHilf.length(); i++)
			shHilf[i].removeToolStatic(bcSh);
	}
	

	if(nSpecial==1) // Special RUB	
	{
		
		if (nSide !=0 && nNoNail == 1 && bHasElement == 1 && el.bIsKindOf(ElementWallSF()) )
		{		
			PLine plNoNailNum[0];
			
// checking the inside/outside zone for beeing valid and get oversize for NoNail and ElemSaw	

			for (int i=1; i<6; i++)
			{	
				String sTokens[]=sNoNailZone.tokenize(";");
				double dToken;
				// HSB-21887
				if(sTokens.length()==5)
				{ 
					String sToken = sNoNailZone.token(i - 1, ";");
					sToken.trimLeft();
					sToken.trimRight();
					dToken = sToken.atof();
				}
				else if(sTokens.length()>0)
				{ 
					// HSB-21887
					double dInc=sTokens[0].atof();
					dToken=dInc*(i-1);
				}
				if (el.zone(nSide*i).dH() > 0)
				{

				// HSB-13448
					double dX = .5 * dWidth + dMillOversize + dToken + .5 * dInterdistance;
					PLine plNoNail(_Pt0 - vecX*dX,
							_Pt0 - vecX*dX+ vecZ*(dHeight+dMillOversize+dToken),
							_Pt0 + vecX*dX + vecZ*(dHeight+dMillOversize+dToken),
							_Pt0 + vecX*dX);	

					//PLine plNoNail(_Pt0 - vecX*(.5*dWidth+dMillOversize+dToken), _Pt0 - vecX*(.5*dWidth+dMillOversize+dToken) + vecZ*(dHeight+dMillOversize+dToken), _Pt0 + vecX*(.5*dWidth+dMillOversize+dToken) + vecZ*(dHeight+dMillOversize+dToken), _Pt0 + vecX*(.5*dWidth+dMillOversize+dToken));
					plNoNail.close();
					
					
					// HSB-21887: get only the intersecting part with the sheet
					PlaneProfile ppSheets;
					{ 
						PlaneProfile ppNoNail(plNoNail);
						ppSheets=PlaneProfile (ppNoNail.coordSys());
						Sheet sheetsZone[]=el.sheet(nSide*i);
						for (int s=0;s<sheetsZone.length();s++) 
						{ 
							ppSheets.joinRing(sheetsZone[s].plEnvelope(),_kAdd); 
							 
						}//next s
						ppSheets.shrink(-U(2));
						ppSheets.shrink(U(2));
						ppSheets.shrink(U(2));
						ppSheets.shrink(-U(2));
						
						ppNoNail.intersectWith(ppSheets);
						ppNoNail.vis(1);
						
						PLine plsNoNail[]=ppNoNail.allRings(true,false);
						if(plsNoNail.length()>0)
						{ 
							plNoNail=plsNoNail[0];
						}
						else 
						{ 
							// no sheeting of this zone intersects
							continue;
						}
					}
					
					ElemNoNail elNN(nSide*i, plNoNail);
					el.addTool(elNN);
					int nTrue = 0;
					
//	cut out in sheet zone 1/-1, adding nSide1 to the _Map, so it can be removed if needed		
		
						if(i==1  && el.zone(nSide*(i+1)).dH() > 0 && dMillDepth ==0)	
						{
							BeamCut bcSh1(_Pt0, vecX, vecZ, vecY, dWidth+2*(dMillOversize+dToken)+dInterdistance, dHeight+dMillOversize+dToken, el.zone(nSide*i).dH(),0,1,1);
							bcSh=bcSh1;
							_Map.setInt("nSide1", nSide);
							nTrue =1;
						}
						
// get the PLine for ElemSaw, so that the sawline is not at the edge of a sheet
						PLine plElSaw;
						PlaneProfile ppElSaw(plNoNail);
						ppElSaw.shrink(U(-0.1));
						PlaneProfile ppElSaw1 = ppElSaw;
						PLine plElSaw2[] = ppElSaw.allRings();
						PlaneProfile ppElZ = el.profNetto(i*nSide);
						ppElSaw.intersectWith(ppElZ);
						PLine plElSaw1[]= ppElSaw.allRings();
						if(plElSaw2.length() < 1)
							continue;
						Point3d ptElSaw[] = plElSaw2[0].vertexPoints(TRUE);
						if(plElSaw1.length() < 1)
							continue;
						Point3d ptElSaw1[] = plElSaw1[0].vertexPoints(TRUE);
						Point3d ptElSaw01[0];
						Point3d ptElSaw11[0];
						
						for(int k=0; k<2;k++)
						{
							for(int j=1; j< ptElSaw.length(); j++)	
							{					
								if(el.vecX().dotProduct(ptElSaw[0] - ptElSaw[j]) <= dEps)	
								{
									if(el.vecY().dotProduct(ptElSaw[0] - ptElSaw[j]) >= -dEps)
										ptElSaw.swap(0,j);					
									else
										ptElSaw.swap(1,j);							
								}
								else
								{
									if(el.vecY().dotProduct(ptElSaw[3] - ptElSaw[j]) < -dEps)
										ptElSaw.swap(2,j);							
									else
										ptElSaw.swap(3,j);
								}
							}
						}
						
				
						for(int k=0; k<2;k++)
						{
							for(int j=1; j< ptElSaw1.length(); j++)	
							{					
								if(el.vecX().dotProduct(ptElSaw1[0] - ptElSaw1[j]) <= dEps)	
								{
									if(el.vecY().dotProduct(ptElSaw1[0] - ptElSaw1[j]) >= -dEps)
										ptElSaw1.swap(0,j);								
									else
										ptElSaw1.swap(1,j);		
								}
								else
								{
									if(el.vecY().dotProduct(ptElSaw1[3] - ptElSaw1[j]) < -dEps)	
										ptElSaw1.swap(2,j);				
									else
										ptElSaw1.swap(3,j);	
								}
							}
						}
						
						double dEps1;
						double dEps2;
						if(el.vecX().dotProduct(ptElSaw[0] - ptElSaw1[0]) < dEps && el.vecX().dotProduct(ptElSaw[0] - ptElSaw1[0]) > -dEps)
						{
							plElSaw.addVertex(ptElSaw1[0] - el.vecX()*dEps);
							dEps1 = U(0.1);
						}
						plElSaw.addVertex(ptElSaw1[1] - el.vecX()*dEps1 - el.vecY()*dEps);
						
						if(el.vecX().dotProduct(ptElSaw[3] - ptElSaw1[3]) < dEps && el.vecX().dotProduct(ptElSaw[3] - ptElSaw1[3]) > -dEps)
							dEps2 =U(0.1);
					
						plElSaw.addVertex(ptElSaw1[2] + el.vecX()*dEps2 - el.vecY()*dEps);
						
						if(dEps2 == U(0.1))
							plElSaw.addVertex(ptElSaw1[3] + el.vecX()*dEps2);
			
							
							
// use the reverse polyline if the cut out is at teh outside
						if(nSide < 0)
							plElSaw.reverse();
						
						// HSB-21887
						// keep only the legs that are inside the ppSheets
						// remove legs on the sheet edge
						{ 
							PlaneProfile ppSheetsShrink=ppSheets;
							ppSheetsShrink.shrink(U(1));
							
							PLine plElSawNew;
							Point3d ptsPl[]=plElSaw.vertexPoints(true);
							int bPreviousPoint;
							for (int p=0;p<ptsPl.length()-1;p++) 
							{ 
								Point3d pt1=ptsPl[p];
								Point3d pt2=ptsPl[p+1];
								Point3d ptM=.5*(pt1+pt2);
								if(ppSheetsShrink.pointInProfile(ptM)==_kPointOutsideProfile)
								{ 
									if(bPreviousPoint)
									{ 
										plElSawNew.addVertex(pt1);
										bPreviousPoint=false;
									}
									continue;
								}
								else
								{ 
									pt1.vis(2);
									bPreviousPoint=true;
									plElSawNew.addVertex(pt1);
									if(p==ptsPl.length()-2)
										plElSawNew.addVertex(pt2);
								}
							}//next p
							plElSaw=plElSawNew;
							
						}
						
						ElemSaw elSaw( nSide*i, plElSaw, el.zone(nSide*i).dH(), 1,1,1,0 );
						el.addTool(elSaw);
				}	
			}
// Adding cut out to sheets of zone 1/-1
			
			if(_Map.hasInt("nSide1"))	
			{
				Sheet shHilf[] = el.sheet(nSide);
				for(int i=0; i < shHilf.length(); i++)
					shHilf[i].addTool(bcSh);
			}
		}
	}	


//region Publish Alignment Property
	Map mapX;
	mapX.setInt("InsideFrame", vecY.isParallelTo(el.vecX()));
	_ThisInst.setSubMapX("ElementAlignment", mapX);
//End Publish Alignment Property//endregion 




	if(el.bIsValid())
	{
		String text = _ThisInst.formatObject(sFormat, mapAdditionals);
		dpElement.draw(text, _Pt0,el.vecX(), el.vecY(), 0, -2, _kDevice);
	}	


//region Dialog Trigger
{
	
	// create TSL
	TslInst tslDialog;			Map mapTsl;
	GenBeam gbsTsl[] = { };		Entity entsTsl[] = { };			Point3d ptsTsl[] = { _Pt0};
	int nProps[] ={ };			double dProps[] ={ };			String sProps[] ={ };
	
	
//region Trigger AddFixing
	String sTriggerAddFixing = T("|Edit Fixing|");
	addRecalcTrigger(_kContext, sTriggerAddFixing );
	if (_bOnRecalc && _kExecuteKey==sTriggerAddFixing)
	{
	
		mapTsl.setInt("DialogMode",1);
		String article = sMainScrew;
		sProps.append(article);

		int nFixing = sFixings.find(article);
		if (nFixing>-1)
		{ 
			String _article = article; _article.makeLower();
			for (int i=0;i<mapFixings.length();i++) 
			{ 
				Map m = mapFixings.getMap(i);
				String name = m.getMapName().makeLower();
				if (name == _article)
				{
					sProps.append(m.getString("Manufacturer"));
					sProps.append(m.getString("Description"));
					sProps.append(m.getString("Category"));
					sProps.append(m.getString("Model"));
					
					dProps.append(m.getDouble("ScaleX"));
					dProps.append(m.getDouble("ScaleY"));
					dProps.append(m.getDouble("ScaleZ"));
					
					break;
				}
			}//next i			
		}
		
		tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);						

		if (tslDialog.bIsValid())
		{ 
			int bOk = tslDialog.showDialog();
			if (bOk)
			{	
				article = tslDialog.propString(0);
				String manufacturer = tslDialog.propString(1);
				String description = tslDialog.propString(2);
				String cat = tslDialog.propString(3);
				String model = tslDialog.propString(4);
				
				double dX = tslDialog.propDouble(0);
				double dY = tslDialog.propDouble(1);
				double dZ = tslDialog.propDouble(2);

			// rewrite settings
				if (article.length()>0)
				{ 
					String _article = article; _article.makeLower();
					Map mapNew, mapApps;			
					for (int i=0;i<mapFixings.length();i++) 
					{ 
						Map m = mapFixings.getMap(i);
						String name = m.getMapName().makeLower();
						if (name == _article)
						{
							mapApps = m.getMap("Application[]"); // a list of tsls where this could be selected
							continue;
						}
						else
							mapNew.appendMap("Fixture", m);
					}//next i
					
				// get the list where this fixture is applicable to	
					String apps[0];
					for (int i=0;i<mapApps.length();i++)
					{
						String app = mapApps.getString(i);
						if (app.length()>-1 && apps.findNoCase(app,-1)<0)
							apps.append(app);
					}
					if (apps.findNoCase(scriptName(),-1)<0)
						mapApps.appendString("Application", scriptName());
					
					
					Map m;
					m.setString("Article",article);
					m.setString("Manufacturer", manufacturer);
					m.setString("Description", description);
					m.setString("Category", cat);
					m.setString("Model", model);
					
					m.setDouble("ScaleX", dX);
					m.setDouble("ScaleY", dY);
					m.setDouble("ScaleZ", dZ);
					
					m.setMap("Application[]", mapApps);
					
					m.setMapName(article);
					mapNew.appendMap("Fixture", m);
					
					mapSetting.setMap("Fixture[]", mapNew);
					if (mo.bIsValid())
						mo.setMap(mapSetting);
					else
					{ 
						mo.dbCreate(mapSetting);
					}
				}



			}
			tslDialog.dbErase();
		}
		setExecutionLoops(2);
		return;		
	}//endregion

//region Trigger TagFixing
	if (sAllFixings.length()>0 && sAllFixings.length()!=sFixings.length())
	{ 
		String sTriggerTagFixture = T("|Add Fixture to| ") + scriptName();
		addRecalcTrigger(_kContext, sTriggerTagFixture );
		if (_bOnRecalc && _kExecuteKey==sTriggerTagFixture)
		{
			mapTsl.setInt("DialogMode",3);		
			sProps.append(sAllFixings.first());	
			tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);						

			if (tslDialog.bIsValid())
			{
				int bOk = tslDialog.showDialog();
				if (bOk)
				{ 
					String article = tslDialog.propString(0).makeLower();
					
					Map mapNew;
					for (int i = 0; i < mapFixings.length(); i++)
					{
						Map m = mapFixings.getMap(i);
						String name = m.getMapName().makeLower();
						if (name == article)
						{
							Map mapApps = m.getMap("Application[]"); //a list of tsls where this could be selected
							
							// get the list where this fixture is applicable to
							String apps[0];
							for (int i = 0; i < mapApps.length(); i++)
							{
								String app = mapApps.getString(i);
								if (app.length() >- 1 && apps.findNoCase(app ,- 1) < 0)
									apps.append(app);
							}
							
							int n = apps.findNoCase(scriptName() ,- 1);
							if (n < 0)
							{
								apps.append(scriptName());
								mapApps.appendString("Application", scriptName());
							}
							
							m.setMap("Application[]", mapApps);
							
							reportMessage("\n" + article + T(" |is now available for these scripts|: ") + apps);
							
						}
						
						mapNew.appendMap("Fixture", m);
						
						mapSetting.setMap("Fixture[]", mapNew);
						if (mo.bIsValid())
							mo.setMap(mapSetting);
						else
							mo.dbCreate(mapSetting);
					}
				}
				tslDialog.dbErase();
			}
			setExecutionLoops(2);
			return;
		}		
	}
	//endregion


//region Trigger DeleteFixing
	if (sFixings.length()>0)
	{ 
		String sTriggerDeleteFixing = T("|Delete Fixing|");
		addRecalcTrigger(_kContext, sTriggerDeleteFixing );
		if (_bOnRecalc && _kExecuteKey==sTriggerDeleteFixing)
		{
			mapTsl.setInt("DialogMode",2);
			String article = sMainScrew;
			sProps.append(article);	

			tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);						

			if (tslDialog.bIsValid())
			{
				int bOk = tslDialog.showDialog();
				if (bOk)
				{
					String _article = article; _article.makeLower();
					Map mapNew;
					for (int i=0;i<mapFixings.length();i++) 
					{ 
						Map m = mapFixings.getMap(i);
						String name = m.getMapName().makeLower();
						if (name == _article)
						{
							continue;
						}
						else
							mapNew.appendMap("Fixture", m);
					}//next i					
				
					if (mapNew.length()<1 & mo.bIsValid())
						mo.dbErase();
					else
					{ 
						mapSetting.setMap("Fixture[]", mapNew);
						if (mo.bIsValid())
							mo.setMap(mapSetting);
						else
						{ 
							mo.dbCreate(mapSetting);
						}						
					}
				}
				tslDialog.dbErase();
			}
			setExecutionLoops(2);
			return;
		}//endregion		
	}	
	
// Trigger ExportSettings
	if (mapSetting.length() > 0)
	{
		String sTriggerExportSettings = T("|Export Settings|");
		addRecalcTrigger(_kContext, sTriggerExportSettings );
		if (_bOnRecalc && _kExecuteKey == sTriggerExportSettings)
		{
			int bWrite;
			if (findFile(sFullPath).length()>0)
			{ 
				String sInput = getString(T("|Are you sure to overwrite existing settings?|") + " [" + T("|No|") +"/"+T("|Yes|")+"]").left(1);
				bWrite = sInput.makeUpper() == T("|Yes|").makeUpper().left(1);
			}
			else
				bWrite = true;
				
			if (bWrite && mapSetting.length() > 0)
			{ 
				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);
				
			// make sure the path exists	//HSB-10750
				int bPathFound= sFolders.find(sFolder)>-1?true:makeFolder(sPath+"\\"+sFolder);	
				
			// write file	
				mapSetting.writeToXmlFile(sFullPath);
				
			// report rsult of writing	
				if (findFile(sFullPath).length()>0)
					reportMessage(TN("|Settings successfully exported to| ") + sFullPath);
				else
					reportMessage(TN("|Failed to write to| ") + sFullPath);
				
			}
			
			setExecutionLoops(2);
			return;
		}
	}	
	
}
	









#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0$`8`!@``#_VP!#``@&!@<&!0@'!P<)"0@*#!0-#`L+
M#!D2$P\4'1H?'AT:'!P@)"XG("(L(QP<*#<I+#`Q-#0T'R<Y/3@R/"XS-#+_
MVP!#`0D)"0P+#!@-#1@R(1PA,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R
M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1"`$L`9`#`2(``A$!`Q$!_\0`
M'P```04!`0$!`0$```````````$"`P0%!@<("0H+_\0`M1```@$#`P($`P4%
M!`0```%]`0(#``01!1(A,4$&$U%A!R)Q%#*!D:$((T*QP152T?`D,V)R@@D*
M%A<8&1HE)B<H*2HT-38W.#DZ0T1%1D=(24I35%565UA96F-D969G:&EJ<W1U
M=G=X>7J#A(6&AXB)BI*3E)66EYB9FJ*CI*6FIZBIJK*SM+6VM[BYNL+#Q,7&
MQ\C)RM+3U-76U]C9VN'BX^3EYN?HZ>KQ\O/T]?;W^/GZ_\0`'P$``P$!`0$!
M`0$!`0````````$"`P0%!@<("0H+_\0`M1$``@$"!`0#!`<%!`0``0)W``$"
M`Q$$!2$Q!A)!40=A<1,B,H$(%$*1H;'!"2,S4O`58G+1"A8D-.$E\1<8&1HF
M)R@I*C4V-S@Y.D-$149'2$E*4U155E=865IC9&5F9VAI:G-T=79W>'EZ@H.$
MA8:'B(F*DI.4E9:7F)F:HJ.DI::GJ*FJLK.TM;:WN+FZPL/$Q<;'R,G*TM/4
MU=;7V-G:XN/DY>;GZ.GJ\O/T]?;W^/GZ_]H`#`,!``(1`Q$`/P#W^BBL;Q!X
MJT3PM##+K=^EG'.Q6,LC-N(Z_=!]:`-FBN(_X6_X!_Z&.#_OS+_\352[^*-I
MJK+8>";=]=U*0=0C)!`/[TC,!Q[#K0!VFJ:SINB6OVG5+Z"TA)VAYG"@GT'K
M5J"XANH$GMY4EA<;D>-@RL/4$5P>D^!;:ZU0WOC#4(M;UQH]WV=R/)MT/&$C
M].V2*K6OAR^T&^>\\`ZG;W&G^?LN](N)=T2-G#;&Y*,/3_\`50!Z312+G:-P
MP<<BEH`****`"BBB@`HHHH`****`"BBB@`HHHH`***YW3?'7AO6/$5SX?L=1
M\W5+8N)K<P2+MV'#<LH!P?0T=;!TN=%116=KFN:;X<TF;5-6NA;64.T/(59L
M9(`X4$GDCH*+AN:-%<9_PM?P4%L&.LD#4/\`CU)M)_WGSE/[G'S`CG'2NHU/
M4[/1M,N-2OYO)M+9#)+)M+;5'4X`)/X"AZ*[#K8MT5RL?Q'\)R^&9?$::KG2
M8IA`]Q]GEX?CC;MW=QSC%9/_``NWX>?]##_Y)7'_`,;H`]`HKD-#^*'@[Q)J
MT6EZ3K'VB]E#%(_LTR9P"3RR`=`>]=?18+A1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`5YO>?&CP3%!=O/)<.UI-Y)B-OEV;G.T$
M\@8Y/':O2*\!^">BV5[XR\6W-]8Q320S!8C-&&"AG?.,^N!0!Z+XF^(O@_PH
M+9-0!>YN(Q(EM;VX>3:>A(Z#\34WA[XC^%M>TF^O]*>0?8HS)<6WD;9E`_V1
MU_`FO,=?E3P5\?\`_A(-=MY?[*GC_<7"Q%U3Y`O`'IC'XU8^&22:_P#&;7O$
M^F6\L.BNLBB1D*"0L5QQZG!-`&3\+/&%NOQ4URXNS>S'4Y?+@)C9BN7.-W]T
M8J'POXSTWP5\4O&-]JLLXMVFE5(85W-(_F'H,@=,\DBK7P\UJ#PS\9?$%IJ4
M,\<FH7+00D1DC=YAQGVYZU>^&=C#<?&SQ<US:I(%:;:9$R!F3G&:`/4/"?Q'
M\/\`C#2KS4+&:6WCLQFY2[4(T2XSN."1C@\Y[5@?\+X\$?;_`+/Y][Y6_9]J
M^S'ROY[L?A7E'@71K_4O#?Q&T_3HG%Q)'%Y:*,%@LC$J/J`13?\`A*M'_P"%
M(CP?]CG_`+>\_'D_9SG=YF=^<=<<>O-`'8?%_P`2&P\;>#[^WU*9--8)/(;>
M0[9(_,R3@?>XKL/#_P`8]#USQ*FARV&HZ;<S?\>YO(PHE].^02.E>0^)K*]\
M.GX=+J=K+-+:0))+"%W,%$N[;CU`XQ6WXAUJU^)/Q;\,'PW!.Z6+(\\[1%-H
M5]Q!R.@''U-`&K\-]>EM_B)XYGU/4)S8V9>0B21F6-0[=!]/2MUOCMI2P_;_
M`/A'->.C^9Y?]H?9U\O/YX_7-<'X<OK_`$7Q%\2M0L;3S[F%6:-'3<#^]()Q
MWP"3^%8.LZV^N_#EIKWQ1?W>IO("VDP6XBAA&[JP5<'M^)H`]^\2?$O0O#FD
M:;?L+F].IJ&LX+6/<\H.,'!Q@<BJ?AOXJZ=KGB-?#]YI.IZ/JCKNCAOH@N\8
MSQSG..>17F>N>*M7T?PUX!TZVG73;"?3H3/J/V82O&>A`R#C``/'/-4]%D@F
M^/FA3VNKW^KP8(^VW8(WGRW^[P,+GB@#TF]^-6E1W][;Z7H>L:M#8$_:KFT@
M!CC`ZGKTX/)Q7;>&O$>G^*]#@U?3&<V\V1B1=K*1P01ZBOG?4'\/Z?J^O7&F
M:OKGA+58F8FS=2\=PW/RC;VSZYZU[%\(-5UK6?`<-WKB'[09G6.0QA#)&,88
M@`=\C\*`.]HHHH`****`"OG[4U/A3]J"SN2VRWU4H>G!\U#&1_WV,U]`UXA^
MT-ID]O!H/BFS&V>QN/*:0#D9^=#]`5/_`'U2NHSC)_TF.W-%Q./^,NN7MW\3
M7O=/#M!X<$"-*G2.0MOZ_P"\<?\``:ZCX]^*8KWP-H%M:2?)JQ6\*@\F,*",
M_BX_*I/`_A&X\2_"'Q-J%XH;4_$DDMRK$=2A)3KVWAOP->3>$X[[QMXT\,:)
M>LTD%H5@`QRL",TC`_AD?@*<87M2?=/[]7^(.6]5>:^[;\+G0_$'3HO"]_X!
MM9OW:VNG0R3G&<-YI9SQ[DUZ5X[^+7@?6?`NM:;8:WYUW<VK1Q1_9)EW,>@R
M4`'XFN7^.\:2_$SPQ'(BO&T4:LK#((,QR"/2O0OB)X.\,67P[UZZM/#FD6]Q
M%:.T<L5C$CH?4$+D&ID^:DV]KR"*M426]HF%\!M.L=5^%]U:ZC96]Y;MJ+DP
MW$2R(2%3!PP(KDOV@]"T?19?#XTK2K&P$HG\S[+;I%OQLQG:!G&3^==M^SO_
M`,DZN/\`L(2?^@)7,_M+?Z[PW]+C_P!IUI4_B1^7Y"H[/Y_F>R:-X6\.Z<MK
M>V.@Z7:W2QC$\%G&CC*\_,!GFMVH++_CQM_^N2_RJ>B6[)A\*"BBBI*"BBB@
M`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"HHK>"%F:*&.,M]XH
MH&?K4M%`$5Q;6]W'Y=S!%-'UVR(&'Y&EA@BMXA%!$D4:]$10H'X"I**`(&L[
M5YQ.]M"TPZ2&,%A^-.2V@BD:2.&-)&^\RH`3]34M%`$45M!`6,,,<9;[Q1`,
M_7%1_P!GV7VG[3]CM_M'_/7REW?GC-6:*`(Y+>&5U>2&-W7[K,H)'TID%C:6
MKN]O:P0M(<NT<84M]<=:GHH`B2V@C=W2"-6?[Q5`"WUJ&/3-/A$@BL;9!)]\
M+"HW?7CFK=%`%>:PL[B!8)K2"2%?NQO&"H_`TJV=JK(RVT(,8PA$8^4>WI4]
M%`%6XTVPNY1+<V-M-(O1I(E8C\2*L@!5"J``.`!VI:*`"BBB@`HHHH`*K7^G
M6.JVK6NHV5O>6[$$PW$2R(2.APP(JS10!%;6MO96L=M:0106\2[8XHD"H@]`
M!P!5"S\-:#IU\;ZQT33;6[.<SP6B)(<]?F`SS6I11YAY&=?:!HVJ745UJ&D6
M%W<0@"*6XMDD=,'(P2"1SSQ5RZM;>]M9+6[@BN+>5=LD4J!T<>A!X(J6BCR`
MJ:=I6G:/;&VTRPM;*`MO,5M"L:EO7"@#/`J+4]!T?6C&=5TFQOS%GR_M5NDN
MS/7&X'&<#\JT**`$4!5"J`%`P`!TI:**`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`H
MHHH`**A6?=<2Q;<>6`<YZYJ8'(R*`"BC(/2C.>E`!1110`4444`%%%%`!111
M0`4444`%%%%`!114`N`'N/,PJ1$98^F`:`)Z*:SJB[F8`9`R??I0SJFW<P&X
MX&>YH`=1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`%.,9U"Z7U1?Y5/!"MO`L*Y*J,<FH8O^0E<
M?[JU+(LQN(F1@(AG>/7TH`+:W6VB\M22,D\^]$%NMN)`K$[W+G/J:)EG,L1B
M954-\^>XJ:@`HHHH`****`"BBB@`HHHH`****`"BBB@`JHD:2W%[&ZAD8J&!
MZ$;15NJT/_'Y=?5?Y4`2LL4RF)@K!2"5ZX(Y%!6*;&=K;&R/8_Y-*L:)(\H&
M&?`)SZ=*1(HXF=E&#(V3SU.,?R%`$E%%%`!1110`4444`%%%%`!1110`4444
M`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`4T.-2N#Z1J:
MGMYC/;K*4*;OX3U%0)_R%9AZQBK+2HDB1DX9\[1ZT`,MIC/#O:,H<D8-%O,\
MRN7C*;7*C/<>M+)-'"R*YP7.U?K4M`!1110`4444`%%%%`!1110`4444`%%%
M%`!5+REGN+Z%\[9$4'!YP015VJL7_(1N?]Q/_9J`)9H4GB$;YP"&X/H01_*E
MEA28QEL_(VX8/?!']:%A"322ACEP`1V&*(H5B:1E))D;<<GV`_I0!)1110`4
M444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!11
M10`4444`%%%%`%1?^0M)_P!<A_.K#1H[J[*"R_=)'2JC$+JKY.,P_P!:FME2
M"!8@[-M_B;J:`)BB.59E!*]"1TI00PR"#]*BMXXX(O+1B1DGD^M+##'`K+'G
MYF+')SR:`):***`"BBB@`HHHH`****`"BBB@`HHHH`*SY!NO;N,2,A>%`&7J
MOWN16A6->2^7JTHSUB3^;4`:4H6:()O9<%3D=>"#3I$25HV+']VVX8/4X(_K
M60LY$C,7)!``7/`J2.;87.XG<<\]N*`-BBFQG,2GU`IU`!1110`4444`%%%%
M`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`
M9%[)LU4?]<?ZTPSOYD95@%&=P]>*@UE]FK1@G`,7]:IQW&[!.5H`UGF=GC*R
M;0IRP]?:KEO-YDH&>U<^ERV,MD'/Z5?TB9Y+DA\=#CGM0!N4444`%%%%`!11
M10`4444`%%%%`!1110`5S&MRE-8=0<$VZX/IR]=/7&^)GV:X/>W3_P!":@!/
M/++C<1DCD?6G&?<5Y^ZV?T(_K64)SGK@`8Q^)Y_7]*=Y^223U_PQ0!Z!;G-M
M$?\`8'\JDJ&T_P"/.'_<'\JFH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@#E/$C[-6A]X3_.LP38&2
M1R<8[U=\6DC5;;'>(C]:PQ(=^.<YQB@#1\_@'/).,5K:!)NOR/\`9-<WYA#;
M#P<X(/K6WX8?=J3C.<(1P<B@#KZ***`"BBB@`HHHH`****`"BBB@`HHHH`*X
M?Q?((];C)&<VPZ_5J[BN"\<'&L6Y_P"F`_\`0FH`Q5GQGID^O/>G^=QC/&<_
MS_QJEYN0O`&!CCOR3G]?TI6F+$L>N`./88_I0!ZS9_\`'E!_US'\JGJ"S_X\
MH/\`KFO\JGH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`
M****`"BBB@`HHHH`****`"BBB@#BO&CF/4;5@<'RS@_C7,^:=V<G).<YKH_'
M?%W9G_8/\ZY43-Y>S/RYR0/6@"TK':3@X!ZUT/A!\ZFX_P"F=<J)#MVYXSG'
MO72^"SG5I?\`KG0!WE%%%`!1110`4444`%%%%`!1110`4444`%<%XZ81ZK:N
M5#?N>AZ=37>UY_\`$+B^L_>(_P`Z`.6CD*YZ<C'(IWF,$*9P#R1[]OYU!YA8
M(N`-HP,#W)Y_.G-(S'+')P!SZ`8H`]FL_P#CR@_W!_*IJBMABUA_W!_*I:`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`**
M**`"BBB@`HHHH`XCQYA;BR9AD`'(]>:XT2#SBRJ%&<A>H'M78?$'@V9^M<6K
M)Y1!4F0MPV>,4`3F4F3?@`YSP,`5U'@EVDUB=F8L3'DD_6N3$@\HKM4DG.['
M-=3X#.=5N/\`KE_6@#T&BBB@`HHHH`****`"BBB@`HHHH`****`"O/OB)_Q^
MV7_7-OYUZ#7GWQ&XN[`^J,/U%`'&*>:<3@5&I-2(&E=8U&68@`>]`'MT`Q;Q
MC_9%24V,8B0>BBG4`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110!PWQ#.$L_J:X7=S7=?$7_`%5D?]HU
MP6?2@"7<>E==X`YU6Y/_`$R'\ZY"NO\`A]_R%+O_`*XC^=`'H=%%%`!1110`
M4444`%%%%`!1110`4444`%<1X^C26,94>9%%YJGOC>%(_P#'A^5=O7(^+;<S
MWL*@9WVTL>/4D<?KB@#S12<5-`^V6-B<88'/XU64\5*IR<&@#W"SF%Q903#I
M)&&_,5/6+X6E,FA0J?O1DH?SX_3%;5`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`<1\15)M;0@$X8Y
MKSX>WY5Z?XP_>1QVW_/6)P/J!D5Y:IR:`)LD5V_P\B7S[R8O\X4+M]NN:X8'
MG\*Z_P``W*QZI)$3@R+C\J`/2****`"BBB@`HHHH`****`"BBB@`HHHH`*YW
MQ&=EW:2#^'G\B*Z*N<\3G$EO[@_TH`\MNX!:ZA<P#I'*RCZ`T6O-U#_OK_.K
M6OKC5V<#B1%;],']0:IV[8N(B.SB@#U'PG/\MQ;GL0P_S^%=-7GOAF_,>NQH
MQ&V12OXUZ%0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`',>*D)N]/<=%<@_CQ7E]Q'Y%Y/#_<<C]:]
M7\3C*6Y'4$UYKK\7E:Y,W:0"0?B*`*`.*W?#,OD:M#,.BR#-8-;6B'9&[@<A
M@:`/8.U%06<HGLX9!_$HS4]`!1110`4444`%%%%`!1110`4444`%<SXLW;K4
M#T;^E=-7&>/+PVOV+`^\'_I0!QGB&/'V:3V9"?QS_4UE1';*A_VA5NYNC>6D
M@;K&RN/IR#_,5GY;@@=.>*`->SU$6NIV\I)!60<_C7L\;AXU=3D,,BOG>YN#
MGJ<U[KX;O/M_AVQN,Y+1`'\.*`-6BBB@`HHHH`****`"BBB@`HHHH`****`"
MBBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`P?$O\`JH/]XUY[XG3]
MY:S=RA0GZ'BO0?%#!8("?[Q_E7!:\/-TT-WCD!_/B@#`'US6QI,BI;R;O[U8
MBGO6A9R;86^M`'JGABZ%QI*@'_5G;6U7#^!;LF6XMR>OS`5W%`!1110`4444
M`%%%%`!1110`4444`%>>_$]9Q'I\L499%$@8CM]W']:]"J&ZM(+VW:"XC$D;
M#!!%`'@FBW(DU6.*5<QR@H0?S_F*T[G:EW)$L9`5@,XX.:T?$GA"?0[]+VTR
M]J)`V1VYZ'W_`)U1DD>_G_T2"65B?X5/6@"*70OM\1>#`F';LU=_\.I9%T.2
MRF4K+;2D%3V!Z5AZ=X:\0S*,*MHA[N?FKLO#VA/HL<YEN3/),06)&.10!MT4
M44`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!111
M0`4444`%%%%`'/>+`/LMN3_?/\JXJ_*2Z?<1`Y8KD#Z5TWQ`F>&PM"AQF0C]
M*\\@O'-T@=LJQP?QH`I+TJ>.3;$W..:B,;J[*`>#CI4<JR)'NQQ0!T?@S4C!
MXFAC9OED!4UZ_7SQIMZ;;6+:;^Y(":^@X)!+!'(.=R@T`24444`%%%%`!111
M0`4444`%%%%`!1110`R2-)HVCD171A@JPR#38;6WMUVPP1QC_84"I:*`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`.)^)4,\FDVKPH6"2DM^5>2&YD60'!RIKZ-G@BN86BF0/
M&PP58<&O+?%_@E[)FO+$;H3U]5^OM[T`4;^7_B703QQ[BX&0!^=585#N59>,
MXY[TMK=(NE1Q3-LE3*E34<$DDDVV")Y6[!5)/Y4`)?>'9`GVJS4L%^8H.H^E
M>M^&+K[7X>M)#]X+M;ZBN)L]&\2WR`+']EC/=CM_^O7=:#ILFDZ5':2R)(ZD
MDLJXSG^M`&G1110`4444`%%%%`!1110`5!=WEM8P&:ZF2&('!9S@5)+*D,32
MRL%1!EF/0"O&_%_B9]>ORD19;.(XC7/WO]HUR8O%1P\+]>AWY?@98NIR[16[
M/1YO&WA^'K?HW^X":T]*U6TUFP2]L9/,@8D!L8Y%?-^LSS6I%N49&==V2,<&
MO1O@QJ^^UOM(=N8R)HQ['@_TK#"8NI5E[Z2N>AC\II4*#J4VVT=WXM\36WA+
M0)M5N8WE5"%5$ZLQX%8OPT\67OC#2+W4;U43%R4CC0<*N.GO6?\`&W_DGDW_
M`%WC_P#0JY#X3^-=`\,>$[J/5;Y8I6N"RQ@%F(P.<"O74;PNMSYF4[5+-Z'N
MM%<3I?Q7\(ZM>+:PZ@T<KG"^?&4!/U-=?=7EO96DEU<S)%!&NYI'.`!6;36Y
MLI)ZID]%>>W?QH\'VTQB6YGFP<%HX25_`]ZTM!^)OACQ%>QV5E>.+F0X2.6,
MJ6/M3Y)=B54BW:YSWQ`^*,F@:S'H.F09O&9/-GD'RH">P[FO3T),:D]2!7S/
M\5&"?%61F.%4Q$D]A7KMS\7O!UE,+=M0>5EX+11,R_F*N4-%9&<*GO2YF=[1
M65H?B32?$EJ;C2KR.X1?O`'YE^H[5H3W$-M&9)I%11W)K*UC9-/5$M%8[>)=
M.5L!W/N%-7K34+>^B>6!B53[V1C%`RU16._B6P4X4R/CT6IK77;&ZD$:R%7/
M0.,4`:5%(S*BEF("CJ369)XATZ-RIF+8[JI(H`;K&IRV4EO#$HS*>6/89K6K
MD]9OK>^O+)K>3<`>?;D5UE`!1110`4444`%%%%`!1110`4444`%%%%`!1110
M`4C*KJ58`J1@@]Z6B@#GCX*T1KMKAK=FR<A"WRC\/2MBUL+2R0);6\<2C^ZH
M%6:*`"BBB@`HHHH`****`"BBB@`HHHH`\I^(WC6..[DT.&1T$1_?D#[QQG'T
MK,^'NCP>)K^:>9&^R6I&X'^-CT%0_%+P[<CQ2VHK"_V2:)2TH'&X<$?EBN8L
MM2O-(A;[%=2P+U(1N":\+$."Q'-55_(^SPM+FP*AAW9M;^?4]!^,'AY)+&SU
M6V15>$^2X'&5/3\JXCX>SW>F^-+%TB=ED;RG`'\+<'\J&\9ZWKFG_P!E7THN
M(]P96*_/GL..M>J^`?"`T>T&H7B`WLPRH(_U:GM]:W3E5Q'[M:=3GF_J>!=.
MN[MW2*'QM_Y)Y-_UWC_]"K@/A1\.=)\4Z=<:GJK2R+%+Y:PH=H/&<DUW_P`;
M?^2>3?\`7>/_`-"JA\!O^1/O/^OH_P`A7N)M4]#XN44ZUF<!\7/!>F>$K[3Y
M=)5XXKE6W(S9VL,<BM[QUJ5_>?!+P[.7<B9E6X;U"@@9_$"IOV@OO:+])/Z5
MU7A_^P_^%,Z6OB'RQISPA)&DZ`ER`?;FJYO=BV3R^_**T//?`T?PT_X1Z-M?
M=#J18^:)B0!Z8QVKN_#/AKX>WFNV^I>'+Q/M=JV\11RY'XJ:QT^&GPXN@9;?
M7#Y9Y&+I>*\VLTBT'XH00Z#>-<PPWBI#*I^^#C(]^XI_%>S8KN%KI&E\6(A-
M\49XF.`_E*<>]>J)\%/"?]G^5Y=R963_`%IEY!]:\M^*KK'\5)78X53$23V%
M>ZR^//#%MIINFUFU9$3.%?)/'0"IDY**L5!1<I<QX7X#FN?"?Q9CTM928VN3
M:2#LX)P"1^1KW"[4ZKXD%I(Q\F+L#Z#)KP[P4DWBKXOQ:C%&?+%TUTQQ]U`<
MC/Z5[C,XTWQ49I>(I>_U&*57<K#_``LZ&.PM(D"+;Q8'JH-2)!#"K!(U0-][
M`QFGJRNH92"#T(K/UN1TTB<Q'YL8)!Z"L3H(7O\`1K5O+_<Y'4*F:QM<N-.N
M(XY;,J)@W.T8XK0T&PL9=/65XTDE).XMVJKXCAL8((Q;I&LQ;D+UQ3`DUJYE
MDLK"V#$&=06/KTK8MM)L[:%4$",0.689)K#UA&2TTVZ`^5%`/Z5TL$\=S"LL
M3!E89XI`<UKMI!;:A9F&)4WGYMO?FNJKF_$A'V^Q'O\`U%=)0`4444`%%%%`
M!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%
M%%%`#)(HYHS'*BNC=589!KBM<^%^D:JQ:VDDL68_,(QE3^!Z5W%%1.E"I\2N
M;4<15H.].5C@O#GPLT[0=46^DNY+QD'R)(@`!]:[VBBB%.,%:*"MB*M>7-4=
MV8'C'PM%XPT%]*FN7MT9U?>B@G@Y[U!X)\'0^"M)EL(+N2Y627S"[J%(XZ<5
MTU%:<SM8Y^57YNIQOCKX?6_CDV9GOY;7[-NQL0-NSCU^E3OX$L;CP'#X4N;B
M:2VB4`2KA6)#;@?SKJZ*?,[6#DC=ON>-2_L_6)DS%KEP%]&A!Q^M=-X2^$NB
M>%K]+_S9;V\C_P!6\H`"'U`'>N_HINI)JUR52@G=(X#Q7\)](\5:O)J<]W<P
M7$B@-LP1Q[&N=7]G_2PX+:W=LOIY2BO8:*%4DM+@Z4&[M'/^%O!NC^$+1H=,
M@(>3_63.<N_X^E:U[86]_%LG3..C#J*M45+;9:22LC`_X1HKQ'?SJOI6A9:6
MEI;2PO(TZR?>WU?HI#,)O#$(<F&ZFB4_PBGGPS9F!D+.9&_Y:$Y(K:HH`KFS
MB>R%K*-\84+S63_PC8C8^1>S1J?X16]10!B1>&H5F62:YEE93D9K;HHH`__9
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
      <lst nm="BREAKPOINTS">
        <int nm="BREAKPOINT" vl="1502" />
        <int nm="BREAKPOINT" vl="1518" />
        <int nm="BREAKPOINT" vl="1637" />
        <int nm="BREAKPOINT" vl="1656" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-21887: Apply nonail area only inside sheet area; allow one entry at oversize nonail area" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="6" />
      <str nm="DATE" vl="4/17/2024 9:24:42 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-16852: Support selection of a washer" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="5" />
      <str nm="DATE" vl="11/7/2022 3:38:02 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-14106 display published for hsbMake and hsbShare" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="4" />
      <str nm="DATE" vl="12/21/2021 8:31:16 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-13451: add height as a property" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="3" />
      <str nm="DATE" vl="11/24/2021 3:56:00 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-13448, HSB-13449 double anchor tooling in special mode fixed, HSB-13450 double anchor refused if beam too small" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="2" />
      <str nm="DATE" vl="10/8/2021 1:58:17 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-13213 new property element view format, custom commands to edit fixtures" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="9/22/2021 9:43:37 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-13213 CNC contour published for hsbCNC, new property 'Interdistance' to create a double anchor" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="9/20/2021 4:07:07 PM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End