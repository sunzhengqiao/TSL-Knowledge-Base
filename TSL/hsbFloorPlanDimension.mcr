#Version 8
#BeginDescription
version value="1.8" date="08dec2020" author="thorsten.huck@hsbcad.com"
HSB-10023 bugfix log wall detection

HSB-9969 wall split references fixed
HSB-10023 log wall support added 

This tsl creates a floor plan dimensioning

#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 8
#KeyWords Floorplan;Dimensioning;Grundriss;
#BeginContents
//region Part #1
/// <History>//region
/// <version value="1.8" date="08dec2020" author="thorsten.huck@hsbcad.com"> HSB-10023 bugfix log wall detection </version>
/// <version value="1.7" date="07dec2020" author="thorsten.huck@hsbcad.com"> HSB-9969 wall split references fixed </version>
/// <version value="1.6" date="07dec2020" author="thorsten.huck@hsbcad.com"> HSB-10023 log wall support added </version>
/// <version value="1.5" date="20nov2020" author="thorsten.huck@hsbcad.com"> HSB-9952 new strategies for inner and outer extreme wall connections </version>
/// <version value="1.4" date="20nov2020" author="thorsten.huck@hsbcad.com"> HSB-9664 strictly painter based, painter strategy stored in subMapX of painter </version>
/// <version value="1.3" date="16nov2020" author="thorsten.huck@hsbcad.com"> HSB-9664 group insertion support </version>
/// <version value="1.2" date="13nov2020" author="thorsten.huck@hsbcad.com"> HSB-9664 full painter support </version>
/// <version value="1.1" date="12nov2020" author="thorsten.huck@hsbcad.com"> HSB-9664 painter based definitions extended, new grouping of parallel connected walls </version>
/// <version value="1.0" date="11nov2020" author="thorsten.huck@hsbcad.com"> HSB-9664 initial </version>
/// </History>

/// <insert Lang=en>
/// Select individula walls for setup, select all walls to create dimensions when configuration is available
/// </insert>

/// <summary Lang=en>
/// This tsl creates a floor plan dimensioning
/// </summary>

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbFloorPlanDimension")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Set Reference Point|") (_TM "|Select floor dimension line|"))) TSLCONTENT
//endregion

//region Constants 
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;

	{ 
		MapObject mo("hsbTSLDev" ,"hsbTSLDebugController");
		if (mo.bIsValid()){Map m = mo.map(); for (int i=0;i<m.length();i++) if (m.getString(i)==scriptName()){bDebug = true;	break;}}
		if(bDebug)reportMessage("\n"+ scriptName() + " starting " + _ThisInst.handle());		
	}
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	
	int nMode = _Map.getInt("mode"); // 0 = floor detection, 1=element mode
	String sAssociations[] ={ T("|Interior Walls|"),T("|Exterior Walls|"),  T("|Exterior and Interior Walls|") };
	String sScript = bDebug?"hsbFloorPlanDimension":scriptName();
	
	String sDefaultStrategies[] ={ "Frame","Openings","Wall Connections Exterior","Wall Connections Interior", "Wall Splits", "Outer Wall Extremes", "Inner Wall Extremes"};
	String sDefaultTypes[] ={  "Beam","Opening", "Sheet", "Sheet", "ElementWall", "Sheet", "Sheet"};
	String sDefaultLogTypes[] ={  "Beam","Opening", "Beam", "Beam", "ElementWall", "Beam", "Beam"};
	String sDefaultFilters[] ={ "(Equals(ZoneIndex,0))and(Equals(IsDummy,'false'))","", "(Equals(IsDummy,'false'))","(Equals(IsDummy,'false'))",
		"", "(Equals(IsDummy,'false'))","(Equals(IsDummy,'false'))"};		
	String sNone = T("<|None|>");
	
//end Constants//endregion

//region bOnJig
	String sJigAction = "JigAction";
	if (_bOnJig && _kExecuteKey==sJigAction) 
	{
	
	    Point3d ptBase = _Map.getPoint3d("_PtBase"); // set by second argument in PrPoint
	    Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point
	    
	    //_ThisInst.setDebug(TRUE); // sets the debug state on the jig only, if you want to see the effect of vis methods
	    //ptJig.vis(1);    
	    double radius = U(100);

		Display dpJ(1);
		dpJ.textHeight(U(100));
		for (int i=0;i<_Map.length();i++) 
		{ 
			if (_Map.hasVector3d(i))
			{ 
				String key = _Map.keyAt(i);
				dpJ.color((key=="ref")?40:1);// show grips red, reference orange 
				Point3d pt = _PtW + _Map.getVector3d(i);
				PLine plCir; 
		   		plCir.createCircle(pt, _ZU, radius);
		   		
		    	Point3d ptJigX = ptJig;
		    	ptJigX.setZ(pt.Z());
		    	if (Vector3d(ptJigX-pt).length()<dEps)
		    	{
		    		dpJ.color(3);
		    		dpJ.draw(PlaneProfile(plCir),_kDrawFilled, 80);
		    	}
		    	dpJ.draw(plCir);
			}    
		}//next i
	    return;
	}		
//End bOnJig//endregion 

//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sPathGeneral = _kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\";	
	String sFileName ="hsbFloorPlanDimension";
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
	int bHasGroupDefinition;
	String sConfigurations[0];	
	Map mapConfigs= mapSetting.getMap("Configuration[]");
	{
		for (int i=0;i<mapConfigs.length();i++) 
		{ 
			String sConfiguration= mapConfigs.getMap(i).getMapName();  
			if (sConfiguration.length()>0 && sConfigurations.findNoCase(sConfiguration,-1)<0)
				sConfigurations.append(sConfiguration);		 
		}//next i
		bHasGroupDefinition = sConfigurations.length() > 0;
	}
//End Read Settings//endregion 

//region DialogMode
	int nDialogMode = _Map.getInt("DialogMode");
	if (nDialogMode>0)
	{ 
		String sConfigurationsDialog[0];
		sConfigurationsDialog = sConfigurations;
		if (sConfigurationsDialog.length() < 1)sConfigurationsDialog.append(T("|Default|"));
		String sConfigurationName=T("|Configuration|");	
		if (nDialogMode==1)// Add Set
		{ 
			setOPMKey("SaveConfiguration");
			
			String sConfigurationName=T("|Configuration|");	
			PropString sConfiguration(nStringIndex++, sConfigurationsDialog, sConfigurationName);	
			sConfiguration.setDescription(T("|Defines the name of a configuration|"));
			
			String sAssociationName=T("|Association|");	
			PropString sAssociation(nStringIndex++, sAssociations, sAssociationName);	
			sAssociation.setDescription(T("|Defines the name of a configuration|"));	
		}
		else if (nDialogMode==2)
		{ 
			setOPMKey("SetStrategy");
			String sStrategies[0]; sStrategies = sDefaultStrategies;
			sStrategies.insertAt(0, sNone);
			String sStrategyName=T("|Strategy|");	
			PropString sStrategy(nStringIndex++,sStrategies, sStrategyName);	
			sStrategy.setDescription(T("|Defines the Strategy|"));
			sStrategy.setCategory(category);

		}	
//		else if (nDialogMode==3)
//		{ 
//			String sConfigurationName=T("|Configuration|");	
//			PropString sConfiguration(nStringIndex++,sConfigurations, sConfigurationName);
//			sConfiguration.setDescription(T("|Defines the name of a configuration|"));
//	
//			String sRuleNameName=T("|Rule Name|");	
//			PropString sRuleName(nStringIndex++, T("|Rule Name|"), sRuleNameName);	
//			sRuleName.setDescription(T("|Defines the nameof he rule|"));
//			sRuleName.setCategory(category);	
//		}
		
		return;
	}
//End DialogMode//endregion 

//region Painter Definitions
	// some default painter definitions are expected. If not existant they will be created automatically
	// the strategy on how the filtered accepted painter entities contributes to the dimension is stored in subMapX
	String sAllPainters[] = PainterDefinition().getAllEntryNames();
	String sPainterCollection = "PlanDimension";


	// replace filters for log wall dwgs
	int bPainterCollectionFound;
	for (int i=0;i<sAllPainters.length();i++) 
	{ 
		if (sAllPainters.findNoCase(sPainterCollection,-1)==0)
		{ 
			bPainterCollectionFound = true;
			break;
		}
	}
	if (!bPainterCollectionFound)
	{ 
		Entity ents[] = Group().collectEntities(true, ElementLog(), _kModelSpace);
		if (ents.length()>0 && ents.first().bIsKindOf(ElementLog()))
		{ 
			sDefaultTypes = sDefaultLogTypes;
		}
	}

// validate/create painter definitions and set there type in subMapX
	
	for (int i=0;i<sDefaultStrategies.length();i++) 
	{ 
		String strategy = sDefaultStrategies[i];
		String painter = sPainterCollection + "\\" + T("|"+strategy+"|");
		if (sAllPainters.findNoCase(painter,-1)<0)
		{ 
			PainterDefinition p(painter);		p.dbCreate();			p.setType(sDefaultTypes[i]);		p.setFilter(sDefaultFilters[i]);
			Map m;		m.setString("Strategy",strategy);				p.setSubMapX(sScript,m);
			sAllPainters.append(painter);
			
			//reportMessage("\npainter " + painter + "keys: "+ p.subMapXKeys());
		}	
	}//next i

	// get painters of collection
	String sPainters[0];
	for (int i = 0; i < sAllPainters.length(); i++)
	{
		String s = sAllPainters[i];
		if (s.find(sPainterCollection ,0,false) < 0)continue; // ignore non collection painters
		s = s.right(s.length() - sPainterCollection.length() - 1);
		if (sPainters.findNoCase(s ,- 1) < 0)sPainters.append(s);
	}	
//End Painters//endregion 

//region Test dim group insert bOnInsert
	int bIsGroupInsert;
	Map mapRules;
	if(bHasGroupDefinition && _bOnInsert)  // this approach does not work until HSB-9763 is solved
	{ 
	// prompt for elements
		PrEntity ssE(T("|Select elements|")+ T(", |<Enter> to insert a single dimline|"), ElementWall());
		//ssE.addAllowedClass(ElementRoof());
	  	if (ssE.go())
			_Element.append(ssE.elementSet());
			
			
		if (_Element.length()>0)
		{
		// TSL prerequisites
			TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
			GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
			int nProps[]={};			double dProps[]={};				String sProps[]={};
			Map mapTsl;				
			for (int i=0;i<_Element.length();i++) 
				entsTsl.append(_Element[i]);

		// show group dialog if more then one config was found
			if (sConfigurations.length()>0)
			{ 
				setOPMKey("Group");
				String sConfigName=T("|Dimension Group|");	
				PropString sConfig(nStringIndex++, sConfigurations, sConfigName);	
				sConfig.setDescription(T("|Defines the configuration of dimension groups|"));
				sConfig.setCategory(category);
			
			// silent/dialog
				if (_kExecuteKey.length()>0)
				{
					String sEntries[] = TslInst().getListOfCatalogNames(scriptName());	
					if (sEntries.findNoCase(_kExecuteKey,-1)>-1)
						setPropValuesFromCatalog(_kExecuteKey);
					else
						setPropValuesFromCatalog(sLastInserted);					
				}	
			// standard dialog	
				else if (sConfigurations.length()>1)	
					showDialog();
				bIsGroupInsert = true;
				
			
			// assign dimension group map
				for (int i=0;i<mapConfigs.length();i++) 
				{ 
					//reportMessage("\nsConfig "+ sConfig+ " map name " +mapConfigs.getMapName() + " map: "+mapConfigs.getMap(i));
					
					if (sConfig == mapConfigs.getMap(i).getMapName())
					{ 
						mapRules = mapConfigs.getMap(i).getMap("Rule[]");
						if (mapRules.length()<1)continue;
						
					// loop rules
						for (int j=0;j<mapRules.length();j++) 
						{ 
							mapTsl.setMap("Rule", mapRules.getMap(j));
							tslNew.dbCreate("hsbFloorPlanDimension" , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);									
						}//next j
						break;
					}	 
				}//next i	
				eraseInstance();
				return;
			}	
		}
	}//endregion

//region Properties		
	category = T("|Strategy|");
	String sStrategyName=T("|Dimensioning|");	
	PropString sStrategy(nStringIndex++, sPainters.sorted(), sStrategyName);	
	sStrategy.setDescription(T("|Defines the Strategy|"));
	sStrategy.setCategory(category);

	String sReferenceName=T("|Reference|"), sDisabled = T("<|Disabled|>");	
	String sReferences[0];sReferences = sPainters.sorted();
	sReferences.insertAt(0, sDisabled);
	PropString sReference(nStringIndex++, sReferences, sReferenceName);	
	sReference.setDescription(T("|Defines the strategy of the references|"));
	sReference.setCategory(category);

	String sSectionHeightName=T("|Section Height|");	
	PropDouble dSectionHeight(nDoubleIndex++, U(0), sSectionHeightName);	
	dSectionHeight.setDescription(T("|Defines the section height relative to the wall outline to the collect dimpoints|"));
	dSectionHeight.setCategory(category);

	category = T("|Display|");
	String sDimStyleName=T("|Dimstyle|");	
	PropString sDimStyle(nStringIndex++, _DimStyles.sorted(), sDimStyleName);	
	sDimStyle.setDescription(T("|Defines the Dimstyle|"));
	sDimStyle.setCategory(category);	

	String sDisplayModeName=T("|Delta/Chain Mode|");
	String sSingleDisplayModes[] = { T("|Parallel|"), T("|Perpendicular|"), T("|Disabled|")};
	int nSingleDisplayModes[] ={ _kDimPar, _kDimPerp, _kDimNone};
	String sDisplayModes[0];
	int nDeltaModes[0],nPerpModes[0];
	for (int i=0;i<sSingleDisplayModes.length();i++) 
		for (int j=0;j<sSingleDisplayModes.length();j++) 
		{ 
			if (i == 2 && j == 2)continue;
			sDisplayModes.append(sSingleDisplayModes[i] + " / " + sSingleDisplayModes[j]);
			nDeltaModes.append(nSingleDisplayModes[i]);
			nPerpModes.append(nSingleDisplayModes[j]);			
		}

	PropString sDisplayMode(nStringIndex++, sDisplayModes, sDisplayModeName,0);	
	sDisplayMode.setDescription(T("|Defines the display mode|"));
	sDisplayMode.setCategory(category);
	int nDisplayMode = sDisplayModes.find(sDisplayMode);
	if (nDisplayMode<0){ nDisplayMode=0; sDisplayMode.set(sDisplayModes[0]);}
	int nDeltaMode = nDeltaModes[nDisplayMode];
	int nChainMode = nPerpModes[nDisplayMode];

	String sFormatName=T("|Format|");	
	PropString sFormat(nStringIndex++, "", sFormatName);	
	sFormat.setDescription(T("|Defines the format of an optional description|") + T(" |One can also use format expressions like @(Strategy)|"));
	sFormat.setCategory(category);


		
//End Properties//endregion 

//region bOnInsert
	if(_bOnInsert && !bIsGroupInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
	// silent/dialog
		if (_kExecuteKey.length()>0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());	
			if (sEntries.findNoCase(_kExecuteKey,-1)>-1)
				setPropValuesFromCatalog(_kExecuteKey);
			else
				setPropValuesFromCatalog(sLastInserted);					
		}	
	// standard dialog	
		else	
			showDialog();
		
	// prompt for elements
		PrEntity ssE(T("|Select elements|"), ElementWall());
		//ssE.addAllowedClass(ElementRoof());
	  	if (ssE.go())
			_Element.append(ssE.elementSet());
		return;
	}	
// end on insert	__________________//endregion

	
//region General
// filter elements which have an intersection at elevation height		
	Plane pnZ(_Pt0, _ZW);
	
//region Validate and declare element variables
	if (_Element.length()<1)
	{
		reportMessage(TN("|Element reference not found.|"));
		eraseInstance();
		return;	
	}
	Element el = _Element[0];
	CoordSys cs = el.coordSys();
	Vector3d vecX = cs.vecX();
	Vector3d vecY = cs.vecY();
	Vector3d vecZ = cs.vecZ();
	Point3d ptOrg = cs.ptOrg();
	Line lnX(ptOrg, vecX);
	LineSeg segMinMax = el.segmentMinMax();
	Point3d ptMidMain = segMinMax.ptMid();
	assignToElementGroup(el,true, 0,'D');// assign to element tool sublayer	
	
	GenBeam genBeams[] = el.genBeam();
	int bExposed;
	int bIsWall = el.bIsKindOf(ElementWall());
	Plane pnSection(ptOrg + vecY * dSectionHeight, vecY);
	Vector3d vecPerp = vecZ;
	//End Element//endregion 	
	
// Display	
	Display dp(-1);
	dp.dimStyle(sDimStyle);
	double dTextHeight = dp.textHeightForStyle("O", sDimStyle);
	CoordSys csPlan(_Pt0, vecX, - vecZ, vecY);
	
// Strategy and mapping painter
	int nStrategies[0],nStrategy; // 0 = Frame (Default), 1=Openings, 2 = Connection Exterior, 3=Connection Interior, 4=Wall Splits, 5=Wall Extremes, 6=Inner Wall Extremnes 
	String sPainterType,sPainterFilter;
	Map mapPainter;
	PainterDefinition painters[0],painter(sPainterCollection + "\\" + sStrategy);
	int bIsGenbeamPainter,bIsOpeningPainter, bIsElementWallPainter,bIsBeamPainter,bIsSheetPainter,bIsPanelPainter;
	if (painter.bIsValid())
	{ 
		
		setDependencyOnDictObject(painter);
		sPainterType= painter.type();
		sPainterFilter= painter.filter();

		mapPainter = painter.subMapX(sScript);
		// get strategy from subMapX
		if (mapPainter.hasString("Strategy")) 
		{
			int n = sDefaultStrategies.findNoCase(mapPainter.getString("Strategy") ,- 1);
			if (n >- 1)nStrategy = n;
		}
		bIsOpeningPainter = sPainterType.find("Opening", 0, false) >- 1;
		bIsElementWallPainter = sPainterType.find("ElementWall", 0, false) >- 1;
		bIsGenbeamPainter = sPainterType.find("GenBeam", 0, false) >- 1;
		bIsBeamPainter = sPainterType.find("Beam", 0, false) ==0;
		bIsSheetPainter = sPainterType.find("Sheet", 0, false) >- 1;
		bIsPanelPainter = sPainterType.find("Sip", 0, false) >- 1 || sPainterType.find("Panel", 0, false) >- 1;
		
		painters.append(painter);
		nStrategies.append(nStrategy);
	}
	else
	{ 
//		Display dp(1);
//		dp.draw(sStrategy, _Pt0, _XW, _YW, 1, 0);
		reportMessage(TN("|Unexpected Error|, ") + T("|Painter not found.|"));
		eraseInstance();
		return;
	}	
	
	//region Reference painter
	int nReferenceStrategy=sReferences.find(sReference,0);// 0=Disabled
	
	PainterDefinition painterRef;
	String sRefType,sRefFilter;
	int bIsGenbeamRef,bIsOpeningRef, bIsElementWallRef,bIsBeamRef,bIsSheetRef,bIsPanelRef;
	if (nReferenceStrategy>0)
		painterRef = PainterDefinition(sPainterCollection + "\\" + sReference);
	if (painterRef.bIsValid())
	{ 
		setDependencyOnDictObject(painterRef);
		sRefType= painterRef.type();
		sRefFilter= painterRef.filter();

		Map m= painterRef.subMapX(sScript);
		// get strategy from subMapX
		if (m.hasString("Strategy")) 
		{
			int n = sDefaultStrategies.findNoCase(m.getString("Strategy") ,- 1);
			if (n >- 1)nReferenceStrategy = n;
		}
		bIsOpeningRef = sRefType.find("Opening", 0, false) >- 1;
		bIsElementWallRef = sRefType.find("ElementWall", 0, false) >- 1;
		bIsGenbeamPainter = sRefType.find("GenBeam", 0, false) >- 1;
		bIsBeamRef = sRefType.find("Beam", 0, false) ==0;
		bIsSheetRef = sRefType.find("Sheet", 0, false) >- 1;
		bIsPanelRef = sRefType.find("Sip", 0, false) >- 1 || sRefType.find("Panel", 0, false) >- 1;
		
		painters.append(painterRef);
		nStrategies.append(nReferenceStrategy);	
		
	}			
	//End reference painter//endregion 
	

//endregion

//region Floor detection mode
	// The floor detection will analyse all selected elements and creates individual
	// instances. 
	// - Any parallel connected set of walls will be hold by one instance
	// - Other walls will have a one to one relation between wall and tsl
	if (nMode == 0)
	{
	// prepare TSL cloning
		TslInst tslNew;				Map mapTsl;
		int bForceModelSpace = true;	
		String sExecuteKey,sCatalogName = sLastInserted;
		String sEvent="OnDbCreated"; // "OnElementConstructed", "OnRecalc", "OnMapIO"...
		GenBeam gbsTsl[] = { };		Entity entsTsl[] ={ };			Point3d ptsTsl[] ={ };		

	// Get potential group request map
		Map mapRule = _Map.getMap("Rule");
		int nRuleExposure= mapRule.hasInt("Exposed")?mapRule.getInt("Exposed"):2;
		Map mapRequests = mapRule.getMap("Request[]");
		
	//region Create Wall Dimension Instances
		if (bIsWall)
		{ 	
		//region Get floor plan
			PlaneProfile ppFloor(CoordSys(ptOrg, vecX, - vecZ, vecY));
			Group gr = el.elementGroup();
			Group grFloor(gr.namePart(0) + "\\" + gr.namePart(1));
			Entity ents[] = grFloor.collectEntities(true, ElementWall(), _kModelSpace);
			ElementWall walls[0];
			for (int i=0;i<ents.length();i++) 
			{ 
				ElementWall wall = (ElementWall)ents[i]; 
				if (!wall.bIsValid())continue;
				ppFloor.joinRing(wall.plOutlineWall(), _kAdd);
				
			// add to walls and remove from _Element
				int n = _Element.find(wall);
				if (n >- 1)
				{
					walls.append(wall);
					if (!bDebug)_Element.removeAt(n);
				}
			}//next i
			ppFloor.shrink(-U(5));ppFloor.shrink(U(5));	
			ppFloor.removeAllOpeningRings();		ppFloor.transformBy(_ZW*U(-100));ppFloor.vis(40);				
		//End Get floor plan//endregion 
	
		//region Create grouped instances for parallel connected walls
			// iterate through all walls and find all walls which connect parallel to this wall and its collected childs
			ElementWall wallRemovals[0]; // a list to remove walls from the one to one creation
			for (int i=0;i<walls.length(); i++) 
			{
				ElementWall wall = walls[i];
				if (wallRemovals.find(wall) >- 1)continue;
								
			// test rule exposure association: do not create instance if the exposed state does not match the state set in the rule
				if (nRuleExposure < 2 && nRuleExposure != wall.exposed())continue;
				
				Point3d ptOrgA = wall.ptOrg();
				Vector3d vecXA = wall.vecX();
				
				PlaneProfile ppMain(csPlan);
				ppMain.joinRing(wall.plOutlineWall(), _kAdd);
				PlaneProfile ppAll = ppMain;
				PlaneProfile pps[0];
				
				ElementWall wallsC[0];
				for (int j=0;j<walls.length(); j++) 
				{ 
					ElementWall wallB  = walls[j];
					Vector3d vecXB = wallB.vecX();
					if (i == j || !vecXA.isParallelTo(vecXB))continue;
					
					PlaneProfile pp(csPlan);
					pp.joinRing(wallB.plOutlineWall(), _kAdd);
					pps.append(pp);
					wallsC.append(wallB);
					ppAll.unionWith(pp);
				}

				ppAll.shrink(-dEps);ppAll.shrink(dEps);
//				ppAll.transformBy(_ZW * U(2));
//				ppAll.vis(5+i);

			//region Accept only elements which join into the main ring
				PLine rings[] = ppAll.allRings(true, false);
				for (int r=0;r<rings.length();r++) 
				{ 
					PlaneProfile pp(csPlan);
					pp.joinRing(rings[r], _kAdd);
					pp.intersectWith(ppMain);
					if (pp.area()>pow(dEps,2))
					{ 
						ppMain.joinRing(rings[r], _kAdd);
						break;
					}
				}//next r	

				for (int j=pps.length()-1; j>=0 ; j--) 
				{ 
					PlaneProfile pp=pps[j];
					pp.intersectWith(ppMain);
					if (pp.area()<pow(dEps,2))
					{ 
						pps.removeAt(j);
						wallsC.removeAt(j);
					}
//					else if (bDebug)
//					{
//						pps[i].transformBy(_ZW * U(2));
//						pps[i].vis(3);
//					}
				}						
			//End Accept only elements which join into the main ring//endregion 
			
			//region Create an instance for a group of parallel connected walls
				if(wallsC.length()>0)
				{ 
					// set location to outside
					Point3d ptIns = ptOrgA;
					Vector3d vecZW = wall.vecZ();
					Point3d ptOrgW = wall.ptOrg();
					Point3d ptMid = wall.segmentMinMax().ptMid();
					ptMid += vecZW * vecZW.dotProduct(ptOrgW - ptMid);
					ptMid.setZ(ptIns.Z());ptMid.vis(3);
					int nSide = (wall.exposed() && ppFloor.pointInProfile(ptMid) == _kPointInProfile) ?- 1 : 1;
					vecZW *= nSide;
					Line lnZ(ptIns, vecZW);
					Point3d ptsOutline[] = lnZ.orderPoints(wall.plOutlineWall().vertexPoints(true));
					ptIns += vecZW * vecZW.dotProduct(ptsOutline.last() - ptIns);	
	
					entsTsl.setLength(0);
					ptsTsl.setLength(0);
					entsTsl.append(wall); 

					ptsTsl.append(ptIns);	
					mapTsl.setInt("mode", 1);
					mapTsl.setPlaneProfile("ppFloor", ppFloor);
					
					wallRemovals.append(wall);
					for(int j=0;j<wallsC.length();j++)
					{
						entsTsl.append(wallsC[j]);
						wallRemovals.append(wallsC[j]);
					}
					
					if (mapRequests.length() > 0)
					{
						Point3d ptLast = ptIns;
						for (int j = 0; j < mapRequests.length(); j++)
						{
							Map m = mapRequests.getMap(j);
							_ThisInst.setPropValuesFromMap(m.getMap("PropertyMap"));
							setCatalogFromPropValues(sLastInserted);

							if (j == 0)ptIns+= vecZW * m.getDouble("baseOffset");
							else ptIns+=vecZW*dTextHeight;
							ptsTsl[0] = ptIns;
							if (bDebug)
							{
								PLine(ptIns,_Pt0).vis(i);
								dp.draw(sStrategy, ptIns, wall.vecX(), - wall.vecZ() ,- 1, 0);
							}
							
							if (!bDebug)tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, sCatalogName, bForceModelSpace, mapTsl, sExecuteKey, sEvent); 
						
							if (tslNew.bIsValid())
								entsTsl.append(tslNew);		
						}
					}
					else if (!bDebug)tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, sCatalogName, bForceModelSpace, mapTsl, sExecuteKey, sEvent); 
			
					//ppMain.transformBy(_ZW * U(2));			ppMain.vis(i+1);
				}					
			//End Create an instance for a group of parallel connected walls//endregion 	

			}//next i
			
		// finally remove all grouped parallel walls from the list of individual walls	
			for (int i=0;i<wallRemovals.length();i++) 
			{ 
				int n = walls.find(wallRemovals[i]);
				if (n >- 1)walls.removeAt(n);			 
			}//next i	
		//End Create grouped instances for parallel connected walls//endregion 

		//region Create instances per wall
			for (int i=0;i<walls.length();i++) 
			{ 
				ElementWall wall  = walls[i];
			
			// test rule exposure association: do not create instance if the exposed state does not match the state set in the rule
				if (nRuleExposure < 2 && nRuleExposure != wall.exposed())continue;
				
				Vector3d vecZW = wall.vecZ();
				Point3d ptIns = wall.ptOrg();
				Point3d ptMid = wall.segmentMinMax().ptMid();
				ptMid += vecZW * vecZW.dotProduct(ptIns - ptMid);
				ptMid.setZ(ptIns.Z());
				
				// set location to outside
				int nSide = 1;
				if (wall.exposed() && ppFloor.pointInProfile(ptMid) == _kPointInProfile) nSide=-1;
				if (!wall.exposed()) nSide=-1;
				
				
				vecZW *= nSide;
				Line lnZ(ptIns, vecZW);
				Point3d ptsOutline[] = lnZ.orderPoints(wall.plOutlineWall().vertexPoints(true));			
				ptIns += vecZW * vecZW.dotProduct(ptsOutline.last() - ptIns);	//ptIns.vis(3);
				
				entsTsl.setLength(0);
				ptsTsl.setLength(0);
				entsTsl.append(wall); 
				ptsTsl.append(ptIns);
				mapTsl.setInt("mode", 1);
				mapTsl.setPlaneProfile("ppFloor", ppFloor);				
				
				if (mapRequests.length()>0)
				{ 
					for (int j=0;j<mapRequests.length();j++) 
					{ 
						Map m = mapRequests.getMap(j);
						_ThisInst.setPropValuesFromMap(m.getMap("PropertyMap"));
						setCatalogFromPropValues(sLastInserted); 
						if (j == 0)ptIns += vecZW * m.getDouble("baseOffset");
						
					// painter	
						PainterDefinition _painter(sStrategy);
						{ 		
							mapPainter = _painter.subMapX(sScript);
							// get strategy from subMapX
							if (mapPainter.hasString("Strategy")) 
							{
								int n = sDefaultStrategies.findNoCase(mapPainter.getString("Strategy") ,- 1);
								if (n >- 1)nStrategy = n;
							}					
						}	

					// verification	of creation by strategy
						if (nStrategy == 1)// opening
						{
							Opening openings[] = wall.opening();
							if(_painter.type().find("Opening", 0, false) >- 1)
								openings = _painter.filterAcceptedEntities(openings);
							if (openings.length()<1)continue; 
						}
						else if (nStrategy == 3)continue; // wall splits

						ptsTsl[0] = ptIns;
						if(bDebug)
						{ 
							PLine(ptIns,_Pt0).vis(i);
							dp.draw(sStrategy, ptIns, wall.vecX(), - wall.vecZ() ,- 1, 0);		
						}
						else
							tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, sCatalogName, bForceModelSpace, mapTsl, sExecuteKey, sEvent);
						if (tslNew.bIsValid())
							entsTsl.append(tslNew);// add as parent
						
						ptIns += vecZW * dTextHeight;
					}//next j	
				}
				else if (nStrategy!=3 && !bDebug)
					tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, sCatalogName, bForceModelSpace, mapTsl, sExecuteKey, sEvent); 
			}//next i
				
		//End Create instances per wall//endregion 

		}
	//End Wall Dimension//endregion 	
		
	//region ElementRoof
		//TODO 	
	//End ElementRoof//endregion 	
		
	//region Create a new mode 0 instance if any elements of another floor are left over
		// this will iterate through multiple storeys
		if (_Element.length()>0)
		{ 
			entsTsl.setLength(0);
			ptsTsl.setLength(0);
			mapTsl.setInt("mode", 0); // call distribution / floor detection again
			for (int i=0;i<_Element.length();i++) 
				entsTsl.append( _Element[i]); 
			ptsTsl.append( _Element.first().ptOrg());
			if (!bDebug)tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, sCatalogName, bForceModelSpace, mapTsl, sExecuteKey, sEvent); 		
		}
	//End Create a new instance if any elements of another floor are left over//endregion 	
		
	// cleanup the creator	
		if (!bDebug)eraseInstance();
		else dp.draw(scriptName(), _Pt0, _XW, _YW, 1, 0);
		return;
	}
// end Floor detection  mode //endregion

		
//End Part #1//endregion 


//region Dimension mode
	else if (nMode==1)
	{ 
	//region Basics for Dimension mode
		Map mapCustom = _Map.getMap("Custom");
		int bDisableDeltaWallConnection = mapCustom.getInt("DisableDeltaWallConnection"); // flag if delta text of connecting walls to be displayed or not	

		PainterDefinition pdInner, pdOuter, pdFree;

	//region Collect parent instances for baseline offset
		TslInst tslParents[0];
		Point3d ptParents[0];
		PlaneProfile ppParent(csPlan);
		for (int i=0;i<_Entity.length();i++) 
		{ 
			TslInst t= (TslInst)_Entity[i]; 
			if (t.bIsValid() && (t.scriptName() == scriptName() || (bDebug && t.scriptName().makeLower()=="hsbfloorplandimension")) )
			{
				setDependencyOnEntity(_Entity[i]);
				tslParents.append(t);
				ptParents.append(t.ptOrg());
				ppParent.unionWith(t.map().getPlaneProfile("ppText"));
			}
		}//next i
		//ppParent.vis(2);
		//End Collect parent instances for baseline offset//endregion 		
		
	//region Maintain grip point locations
		Map mapLocs = _Map.getMap("Loc[]");
		if (_kNameLastChangedProp=="_Pt0" || _Map.getInt("update"))
		{ 
			for (int i=0;i<mapLocs.length();i++) 
				if (mapLocs.hasVector3d(i) && _PtG.length()>i)
					_PtG[i] = _PtW + mapLocs.getVector3d(i);
			_Map.removeAt("update",true);		
		}
		for (int i=0;i<_PtG.length();i++) 
		{ 
			if (_kNameLastChangedProp=="_PtG"+i && mapLocs.hasVector3d(i))
			{	
				Map m;
				for (int ii=0;ii<mapLocs.length();ii++) 
				{ 
					Vector3d vec =(i==ii)? _PtG[i] - _PtW: mapLocs.getVector3d(ii);
					m.appendVector3d(mapLocs.keyAt(ii), vec);
					 
				}//next i
				_Map.setMap("Loc[]", m);
				setExecutionLoops(2);
				return;
			}
		}//next i			
	//End Maintain grip point locations//endregion 

	//region Dimension Variables, strategy
		Point3d ptsDims[0], ptsOpenings[0], ptsExtremes[0], ptsWallConnections[0], ptsWallSplits[0], ptsRefs[0];
		Vector3d vecDir = vecX;
		vecPerp = vecZ*(vecZ.dotProduct(_Pt0-segMinMax.ptMid())<0?-1:1);

	// collect walls
		ElementWall walls[] ={};
		Body bdWallCombo;
		for (int i=0;i<_Element.length();i++) 
		{ 
			ElementWall wall = (ElementWall)_Element[i]; 
			if (wall.bIsValid())
				walls.append(wall);
		}//next i		

	//End Dimension Variables, strategy//endregion 

	//region Get floor group and connected walls
		Group gr = el.elementGroup();
		Group grFloor(gr.namePart(0) + "\\" + gr.namePart(1));
		Entity entFloorWalls[0];
		if (walls.length()>0 && walls.first().bIsKindOf(ElementLog()))
			entFloorWalls= Group().collectEntities(true, ElementWall(), _kModelSpace);		
		else
			entFloorWalls= grFloor.collectEntities(true, ElementWall(), _kModelSpace);
		PlaneProfile ppFloor(CoordSys(_Pt0, _XW, _YW, _ZW));

	// collect connected walls
		Element wallsC[0];
		for (int j=0;j<walls.length();j++) 
		{ 
			ElementWall& wall = walls[j]; 
			PlaneProfile pp1(wall.plEnvelope());
			Point3d ptOrg = wall.ptOrg();
			ppFloor.joinRing(wall.plOutlineWall(), _kAdd);
			LineSeg segWall = wall.segmentMinMax();

		// append any connected wall if parent is parallel to main
			if (wall.vecX().isParallelTo(vecX))
			{ 
				Element elements[] = wall.getConnectedElements();
				for (int i=0;i<elements.length();i++) 
				{ 
					Element w = elements[i]; 
					if (w.bIsValid() && wallsC.find(w)<0)
					{
						wallsC.append(w); 
						ppFloor.joinRing(w.plOutlineWall(), _kAdd);
					}		
				}

			}

			Body bdWall;
			{
				Vector3d vec = wall.vecZ();
				LineSeg seg = segWall;
				double dD = abs(vec.dotProduct(seg.ptEnd() - seg.ptStart()));
				bdWall=Body(wall.plEnvelope(), vec * dD, -1);
				bdWall.transformBy(vec * vec.dotProduct(seg.ptEnd() - wall.ptOrg()));
			}
			//if (bDebug)bdWall.vis(7);
				
			for (int i=0;i<entFloorWalls.length();i++) 
			{ 
				Element w = (ElementWall)entFloorWalls[i]; 

				if (!w.bIsValid()){ continue;}
				if (walls.find(w)>-1 || wallsC.find(w)>-1){w.segmentMinMax().vis(3); continue;}
				ppFloor.joinRing(w.plOutlineWall(), _kAdd);

				Body bdWall2;
				LineSeg seg = w.segmentMinMax();
				{
					Vector3d vec = w.vecZ();				
					double dD = abs(vec.dotProduct(seg.ptEnd() - seg.ptStart()));
					bdWall2=Body(w.plEnvelope(), vec * dD, -1);
					bdWall2.transformBy(vec * vec.dotProduct(seg.ptEnd() - w.ptOrg()));
				}

			// contact dir
				Vector3d vecDir = w.vecX();
				Point3d ptX;
				int bOk=Line(w.ptOrg(), vecDir).hasIntersection(Plane(ptOrg, wall.vecZ()),ptX);
				if (bOk && vecDir.dotProduct(ptX - seg.ptMid()) < 0)vecDir *= -1;

			// add interscting wall
				if (bdWall2.hasIntersection(bdWall))
				{
					bdWall2.vis(3);
					wallsC.append(w);
					continue;
				}
				
			// test contact
				Point3d pts[] ={ segWall.ptStart(), segWall.ptEnd()};
				pts = Line(_Pt0, vecDir).orderPoints(pts);
				if (pts.length()>0)
				{ 
					Vector3d vec = wall.vecZ();
					if (vec.dotProduct(vecDir) < 0)vec *= -1;
					Plane pn(pts.first(), vec);//pn.vis(2);
					bdWall2.vis(i);
					PlaneProfile pp2 = bdWall2.extractContactFaceInPlane(pn, U(1));
					pp2.intersectWith(pp1);	pp2.vis(2);
					if (pp2.area()>pow(dEps,2))
					{ 
						bdWall2.vis(40);
						wallsC.append(w);
						continue;
					}	
				}
				else if (bDebug)
					bdWall2.vis(1);
			}//next i	 
		}//next j
	
		ppFloor.vis(2);	
	//End Get floor group and connected walls//endregion 


	//region Snap to last parent if any
		ptParents = Line(_Pt0, - vecPerp).orderPoints(ptParents, dEps);
		if (ptParents.length()>0)
		{ 
			String events[] ={ sDisplayModeName, sDimStyle, sStrategy};
			double d = vecPerp.dotProduct(ptParents.first() - _Pt0)+dTextHeight;
			if (d>dEps || events.find(_kNameLastChangedProp)>-1)
				_Pt0 += vecPerp * d;
		}
		vecPerp.vis(_Pt0, 3);
		Line lnBase(_Pt0-vecPerp*dTextHeight, vecX);			
	//End Snap to last parent if any//endregion 
	
	//End Basics for Dimension mode
	//endregion
	
	//region WALL Dimension		
		if (bIsWall && walls.length()>0)
		{
			ElementWall wallMain = walls.first();
			Vector3d vecXMain = wallMain.vecX();
			Vector3d vecYMain = wallMain.vecY();
			Vector3d vecZMain = wallMain.vecZ();
			Point3d ptOrgMain = wallMain.ptOrg();
			PlaneProfile ppXMain;
			ppXMain.createRectangle(wallMain.segmentMinMax() ,-vecZMain, vecYMain);
			double dZMain = wallMain.dPosZOutlineFront() - wallMain.dPosZOutlineBack();
			bExposed = wallMain.exposed();
			PLine plOutlineWall = wallMain.plOutlineWall();
			Point3d ptsMain[] = plOutlineWall.vertexPoints(true);
			
		// add outline if no construction found
			if (genBeams.length()<1)
			{ 
				DimLine dl(_Pt0, vecX, vecY);
				ptsDims.append(dl.collectDimPoints(plOutlineWall,_kLeftAndRight));	
			}

		//region Collect openings of all parallel walls
			Opening openings[0];
			for (int p = 0; p < painters.length(); p++)
			{
				PainterDefinition pd = painters[p];
				int strategy = nStrategies[p];
				String type = pd.type();
				if (type.find("Opening", 0, false) <0)continue;
								
				for (int i=0;i<walls.length();i++) 
					if (walls[i].vecX().isParallelTo(vecX))
						openings.append(walls[i].opening());
				
				openings= pd.filterAcceptedEntities(openings);
					
				for (int i=0;i<openings.length();i++) 
				{ 
					PlaneProfile pp(cs);
					pp.joinRing(openings[i].plShape(),_kAdd);
					LineSeg seg = pp.extentInDir(vecX);seg.vis(i);
					ptsOpenings.append(seg.ptStart());
					ptsOpenings.append(seg.ptEnd());	 
				}//next i					
			}
			if (nStrategy == 1 && openings.length()<1)
			{ 
				reportMessage("\n" + scriptName() + T(" |Could not find any opening.|"));
				eraseInstance();
				return;
			}
		//End Collect openings of all parallel walls//endregion 

		//region Collect all connected elements of any wall being parallel with the main wall
			PlaneProfile ppMainY(CoordSys(ptOrgMain, vecXMain, -vecZMain, vecYMain));
			for (int i=0;i<walls.length();i++) 
			{ 
				ElementWall wall = walls[i];
				Vector3d vecXW = wall.vecX();
				PlaneProfile ppXW;
				ppXW.createRectangle(wall.segmentMinMax() ,-wall.vecZ(), wall.vecY());
				ppXW.intersectWith(ppXMain);
			// wall needs to be parallel and within range	
				if (vecXW.isParallelTo(vecXMain) && ppXW.area()>pow(dEps,2))
				{
					ppMainY.joinRing(wall.plOutlineWall(),_kAdd); // get overall outline on multiconnected walls
				}		 
			}//next i

			ppMainY.transformBy(_ZW * U(100));
			ppMainY.vis(2);
		//End Collect all connected elements of any wall being parallel with the main wall
		//endregion 
		
		//region CollectInnerOuterExtremes
		// from all connected walls get the contact location with main and order by vecXMain
			int nInnerOrOuterAsRef; // a flag which of the painters is used as ref (0 =none, 1=inner, 2=outer)
			for (int i=0;i<painters.length();i++) 
			{ 
				Map map =painters[i].subMapX(sScript);
				String strategy = map.getString("Strategy");
				if (strategy==sDefaultStrategies[5])// outer wall extremes
				{
					pdOuter = painters[i];
					nInnerOrOuterAsRef = (nStrategy!=5?2:nInnerOrOuterAsRef);
				}
	 			else if (strategy==sDefaultStrategies[6])// inner wall extremes
				{
					pdInner = painters[i];
					nInnerOrOuterAsRef = (nStrategy!=6?1:nInnerOrOuterAsRef);					
				}
	 			else if (strategy=="")// inner wall extremes
				{
					pdFree = painters[i];					
				}				
				
				
				
			}//next i
			if (pdInner.bIsValid() || pdOuter.bIsValid())
			{ 
				PlaneProfile pp = ppMainY;
				pp.shrink(-U(1));
				Point3d pts[wallsC.length()];
				for (int i=0;i<wallsC.length();i++) 
				{ 
					PlaneProfile pp2(wallsC[i].plOutlineWall());
					pp2.intersectWith(pp);
					pts[i] = pp2.extentInDir(vecXMain).ptMid();
					pts[i].vis(6); 
				}//next i
			
			// order by X-location
				for (int i=0;i<pts.length();i++) 
					for (int j=0;j<pts.length()-1;j++) 
					{ 
						double d1 = vecXMain.dotProduct(pts[j] - ptOrgMain);
						double d2 = vecXMain.dotProduct(pts[j+1] - ptOrgMain);
						if (d1>d2)
						{
							wallsC.swap(j, j + 1);
							pts.swap(j, j + 1);
						}
					}
				
				
				if (wallsC.length()>1)
				{ 
					Element els[] ={ wallsC.first(), wallsC.last() };
					
					
				// collect points of extreme zone
					Vector3d vecDir = -vecXMain;
					for (int i=0;i<els.length();i++) 
					{ 
						Vector3d vecZE = els[i].vecZ();
						if (vecDir.dotProduct(vecZE) < 0)vecZE *= -1;
						
						GenBeam genBeams[] = els[i].genBeam();

					// inner
						if (pdInner.bIsValid())
						{ 
							String sType = pdInner.type();
							GenBeam gbs[] = pdInner.filterAcceptedEntities(genBeams);
							Point3d pts[0];
							for (int j=0;j<gbs.length();j++) 
							{ 
								GenBeam& gb = gbs[j];
								if (gb.bIsKindOf(Beam()) && (sType == "Sheet" || sType == "Sip")){continue;}
								else if (gb.bIsKindOf(Sheet()) && (sType == "Beam" || sType == "Sip")){continue;}
								else if (gb.bIsKindOf(Sip()) && (sType == "Sheet" || sType == "Beam")){continue;}
								//gb.realBody().vis(gb.myZoneIndex()); 
								pts.append(gb.envelopeBody().extremeVertices(vecZE));	 
							}//next j					
							
							pts = Line(_Pt0, vecZE).orderPoints(pts, dEps);
							if (pts.length()>0)
							{ 
								Point3d pt;
								if(Line(pts.first(), els[i].vecX()).hasIntersection(Plane(ptOrgMain, vecZMain), pt))
								{
									//PLine (pt, wallMain.segmentMinMax().ptMid(), els[i].segmentMinMax().ptMid()).vis(150);
									if (nInnerOrOuterAsRef==1)
										ptsRefs.append(pt);
									else 
										ptsDims.append(pt);										
								}
							}	
						}
					// outer
						if (pdOuter.bIsValid())
						{ 
							String sType = pdOuter.type();
							GenBeam gbs[] = pdOuter.filterAcceptedEntities(genBeams);
							Point3d pts[0];
							for (int j=0;j<gbs.length();j++) 
							{ 
								GenBeam& gb = gbs[j];
								if (gb.bIsKindOf(Beam()) && (sType == "Sheet" || sType == "Sip")){continue;}
								else if (gb.bIsKindOf(Sheet()) && (sType == "Beam" || sType == "Sip")){continue;}
								else if (gb.bIsKindOf(Sip()) && (sType == "Sheet" || sType == "Beam")){continue;}
								//gb.realBody().vis(gb.myZoneIndex()); 
								pts.append(gb.envelopeBody().extremeVertices(vecZE));	 
							}//next j					
							
							pts = Line(_Pt0, -vecZE).orderPoints(pts, dEps);
							if (pts.length()>0)
							{ 
								Point3d pt;
								if(Line(pts.first(), els[i].vecX()).hasIntersection(Plane(ptOrgMain, vecZMain), pt))
								{
									//PLine (pt, wallMain.segmentMinMax().ptMid(), els[i].segmentMinMax().ptMid()).vis(150);
									if (nInnerOrOuterAsRef==2)
										ptsRefs.append(pt);
									else 
										ptsDims.append(pt);	
								}
							}	
						}						
						vecDir*=-1; 
					}//next i
					
//					els.first().plOutlineWall().vis(1);
//					els.last().plOutlineWall().vis(2);
					
				}
			}				
		//End CollectInnerExtremes//endregion 

		//region Determine Wall Connections at start and end
			int nCTypes[] ={ -1 ,- 1};
			Element elCTypes[2];
		// -1 = unknown, 0 = corner male , 1= corner female, 2 = T male,3 = T female, 4 = mitre, 5= parallel, 
		// 6 = T male incomplete,7 = T female incomplete, 8= open mitre, 9=Sip-T, 10= Sip sloped, 11= corner male sip, 12= corner female sip
		{
			Element elements[0]; elements = wallsC;
			if (painter.bIsValid() && bIsElementWallPainter)
				elements= painter.filterAcceptedEntities(elements);

			for (int i=0;i<elements.length();i++) 
			{ 
				Element wallOther = (ElementWall)elements[i];
				Vector3d vecXOther = wallOther.vecX();
				Vector3d vecZOther = wallOther.vecZ();
				
				PLine plOther = wallOther.plOutlineWall();//plOther.vis(2);
				Point3d ptsOther[] = plOther.vertexPoints(true); 
				
				// points on the contours
				int nOnThis,nOnOther;
				Point3d ptsOnThis[0],ptsOnOther[0];
				for (int p= 0;p<ptsOther.length();p++)
				{
					double d = (ptsOther[p]-plOutlineWall.closestPointTo(ptsOther[p])).length();
					if(d<dEps)
					{
						ptsOnThis.append(ptsOther[p]);
						nOnThis++;
					}
				}	
				for (int p= 0;p<ptsMain.length();p++)
				{
					double d = (ptsMain[p]-plOther.closestPointTo(ptsMain[p])).length();
					if(d<dEps)//if(plOther.isOn(ptsMain[p]))				
					{
						ptsOnOther.append(ptsMain[p]);			
						nOnOther++;
					}
				}	
				
			// start/end
				Point3d ptX; ptX.setToAverage(ptsOnThis.length()<1?ptsOnOther:ptsOnThis);
				int bIsEnd = vecX.dotProduct(ptMidMain - ptX) < 0;
		
			// parallel
				if (vecXOther.isParallelTo(vecX))		nCTypes[bIsEnd] = 5;
			// male corner
				else if (nOnThis==1 && nOnOther==2)		nCTypes[bIsEnd] = 0;
			// female corner
				else if (nOnThis==2 && nOnOther==1)		nCTypes[bIsEnd] = 1;
			// T-Connection
				else if (nOnThis==0 && nOnOther==2)		nCTypes[bIsEnd] = 2;
			// Mitre
				else if (nOnThis==2 && nOnOther==2)		nCTypes[bIsEnd] = 4;
				
				
				if (nCTypes[bIsEnd] >- 1)
				{
					elCTypes[bIsEnd] = wallOther;
					
//				// append connected parallel walls
//					if (nCTypes[bIsEnd]==5 && _Element.find(wallOther)<0)
//						_Element.append(wallOther);
//					
				}
			}//next i			
		}
		//End Determine Wall Connections at start and end//endregion 

		//region Get extents of walls with no connection
			if ((nCTypes[0]<0 || nCTypes[1]<0) && nStrategy!=0)// || (_Element.length()==1 && (nCTypes[0]==5 || nCTypes[1]==5)) )
			{ 
				DimLine dl(ptOrg, vecX ,- vecZ);
				Point3d pts[]= Line(_Pt0,vecX).orderPoints(dl.collectDimPoints(genBeams,_kLeftAndRight),dEps);
				if (pts.length()>0)
				{ 
					if (nCTypes[0] < 0)
						ptsDims.append(pts.first());
					if (nCTypes[1] < 0) 
						ptsDims.append(pts.last());
//					if(_Element.length()==1 && (nCTypes[0]==5 || nCTypes[1]==5))//  
//					{ 
//						ptsDims.append(pts.first());
//						ptsDims.append(pts.last());
//					}	
				}
			}			
		//End Get extents of walls with no connection//endregion 	

		// Loop walls of selection set by painter
			for (int p=0;p<painters.length();p++) 
			{ 
				PainterDefinition pd = painters[p];
				int strategy = nStrategies[p];
				if (strategy == 5 || strategy == 6 || strategy==0) { continue;} // skip if inner or outer wall extreme strategy
				String type = pd.type();

				//for (int x=0;x<walls.length();x++) 
				//{ 
				//	ElementWall& wallX = walls[x]; 
				
				//region Get Connected walls
					Element elements[0]; elements = wallsC;
					if (pd.bIsValid() && type=="ElementWall")
						elements = pd.filterAcceptedEntities(elements);
					
					for (int i=0;i<elements.length();i++) 
					{ 
						
						ElementWall elC = (ElementWall)elements[i];
						if (!elC.bIsValid())continue;
						Vector3d vecXC = elC.vecX();
						Vector3d vecYC = elC.vecY();
						Vector3d vecZC = elC.vecZ();
						int bExposedC = elC.exposed();						
						//if (bDebug)PLine(elC.segmentMinMax().ptMid(), _Pt0).vis(i);
						
					// ignore any parallel connected
						if (vecXC.isParallelTo(vecX))continue;
						
						
						DimLine dl(_Pt0, vecX, -vecZ);
						Point3d pts[0];						
						
						GenBeam gbs[0];
						Sheet sheets[0];
						if ((strategy==2 || strategy==3) && type=="Sheet")
						{
							sheets= elC.sheet();
						}
						else if (type=="GenBeam")
						{
							gbs = pd.filterAcceptedEntities(elC.genBeam());
						}
						else if (type=="Beam")
						{
							Beam _gbs[]=pd.filterAcceptedEntities(elC.beam());
							for (int i = 0; i < _gbs.length(); i++) gbs.append(_gbs[i]);
						}
						else if (type=="Sheet")
						{
							Sheet _gbs[]=pd.filterAcceptedEntities(elC.sheet());
							for (int i = 0; i < _gbs.length(); i++) gbs.append(_gbs[i]);	
						}
						else if (type=="Panel")
						{
							Sip _gbs[]=pd.filterAcceptedEntities(elC.sip());
							for (int i = 0; i < _gbs.length(); i++) gbs.append(_gbs[i]); 
						}
					// filter by section if specified	
						if (dSectionHeight>0)
						{
							for (int j=gbs.length()-1; j>=0 ; j--)
								if (gbs[j].envelopeBody().getSlice(pnSection).area()<pow(dEps,2))
									gbs.removeAt(j); 	
						}
						pts.append(lnX.orderPoints(dl.collectDimPoints(gbs, _kLeftAndRight), dEps));						

//					// extremes
//						if (strategy==5 && pts.length()>0)
//						{ 
//							ptsExtremes.append(pts.first());//PLine(_PtW,pts.first(),pts.last()).vis(i);
//							ptsExtremes.append(pts.last());									
//						}
						
						int bGetConnection = 
							bExposed  && strategy == 2 ||					// Wall Connections exterior/any
							!bExposed && strategy!=5 && strategy!=6 ||									// Wall Connections interior/exterior and interior/interior && strategy == 2
							(bExposed && bExposedC && strategy == 1) ||
							(bExposed && bExposedC && strategy==4);
//						if (bExposed && bExposedC)
//							bGetConnection = true;
		
					//region Get Wall Connections by GenBeams
						if (bGetConnection)
						{ 
							//int bByPainter = bIsGenbeamPainter|| bIsBeamPainter || bIsSheetPainter|| bIsPanelPainter ;
						// get dimpoints from sheets
							if (sheets.length() > 0)
							{
								// collect outmost sheets
								Sheet inner, outer;
								for (int j = 5; j > 0; j--)
								{
									for (int ii = 0; ii < sheets.length(); ii++)
									{
										if ( ! sheets[ii].coordSys().vecZ().isParallelTo(vecZC))continue; //ignore head sheets
										int n = sheets[ii].myZoneIndex();
										if ( ! inner.bIsValid() && n == -j)
											inner = sheets[ii];
										else if ( ! outer.bIsValid() && n == j)
											outer = sheets[ii];
										if (inner.bIsValid() && outer.bIsValid())break;
									}//next ii
								}//next j
								
								// inner
								if (inner.bIsValid())
								{
									Point3d pt = inner.ptCen() - vecZC * .5 * inner.dH();
									Line(pt, vecXC).hasIntersection(Plane(ptOrg, vecZ), pt);
									pts.append(pt);//	pt.vis(1);
								}
								// outer
								if (outer.bIsValid())
								{
									Point3d pt = outer.ptCen() + vecZC * .5 * outer.dH();
									Line(pt, vecXC).hasIntersection(Plane(ptOrg, vecZ), pt);
									pts.append(pt);//	pt.vis(2);
								}
							}
						// TODO get dimpoints from wall outline	
							else if(pts.length()<1)
							{ 
								PLine pl = elC.plOutlineWall();
								pl.vis(252);
							}
							else
							{ 
								if (pts.length()>2)
								{ 
									pts.swap(1, pts.length() - 1);
									pts.setLength(2);
								}
								for (int ii = 0; ii < pts.length(); ii++)
									Line(pts[ii], vecXC).hasIntersection(Plane(ptOrg, vecZ), pts[ii]);	
							}
													
						// determine how connected wall will be dimensioned
							//int bAddAll = (bExposed || pts.length() < 2);//|| !bExposedC)
							int bAddOne = !bExposed && 
								((elCTypes[0].bIsValid() && elCTypes[0]==elC && nCTypes[0]==2) ||
								(elCTypes[1].bIsValid() && elCTypes[1]==elC && nCTypes[1])==2);
						
						// interior main connecting to exterior
							if (pts.length() < 1)continue;
							if(bAddOne || bExposedC)
							{ 
								double d1 = abs(vecX.dotProduct(pts.first()-plOutlineWall.closestPointTo(pts.first())));
								double d2 = abs(vecX.dotProduct(pts.last()-plOutlineWall.closestPointTo(pts.last())));
								ptsDims.append(d1<d2?pts.first():pts.last());
							}
						// exterior main or connecting to interior walls
							else	
								ptsWallConnections.append(pts);
						}
					//End Wall Connections Strategy//endregion 	 
					
					}//next i					
				//End Get connected walls//endregion 
				//}//next x
				
			//region Get Wall Splits
				if (strategy==4)
				{ 
					if (_Element.length()<2)
					{ 
						eraseInstance();
						return;
					}
					PlaneProfile ppMain(csPlan);
					ppMain.joinRing(plOutlineWall, _kAdd);
					PlaneProfile ppAll = ppMain;
					PlaneProfile pps[0];
					
					ElementWall wallSplits[0];
					for (int i=0;i<_Element.length();i++) 
					{ 	
						ElementWall wallSplit = (ElementWall)_Element[i];
						if (wallSplit == wallMain)continue;
						Vector3d vecX2 = wallSplit.vecX();
						if (vecX2.isPerpendicularTo(vecX))continue; // no perpendicular walls
						
						PlaneProfile pp(csPlan);
						pp.joinRing(wallSplit.plOutlineWall(), _kAdd);
	
						pps.append(pp);
						wallSplits.append(wallSplit);
						ppAll.unionWith(pp);
					}	
					ppAll.shrink(-dEps);ppAll.shrink(dEps);
					//ppAll.transformBy(_ZW * U(2));
					//ppAll.vis(2);
				
				// accept only elements which join into the main ring
					PLine rings[] = ppAll.allRings(true, false);
					for (int r=0;r<rings.length();r++) 
					{ 
						PlaneProfile pp(csPlan);
						pp.joinRing(rings[r], _kAdd);
						pp.intersectWith(ppMain);
						if (pp.area()>pow(dEps,2))
						{ 
							ppMain.joinRing(rings[r], _kAdd);
							break;
						}
					}//next r		
					for (int i=pps.length()-1; i>=0 ; i--) 
					{ 
						PlaneProfile pp=pps[i];
						pp.intersectWith(ppMain);
						if (pp.area()<pow(dEps,2))
						{ 
							pps.removeAt(i);
							wallSplits.removeAt(i);
						}
						else if (bDebug)
						{
							pps[i].transformBy(_ZW * U(2));
							pps[i].vis(3);
						}
					}
					
				// collect points of element outlines,
					LineSeg segMain = ppMain.extentInDir(vecX);segMain.vis(6);
					Point3d extremes[] = { segMain.ptStart(), segMain.ptEnd()};
					if (!painterRef.bIsValid()) // HSB-9969
						ptsExtremes = extremes;
					for (int i=0;i<pps.length();i++) 
					{ 
						LineSeg seg = pps[i].extentInDir(vecX);
						Point3d pts[] ={ seg.ptStart(), seg.ptEnd()};
						auto g[] = wallSplits[i].genBeam();
					// wall has no construction
						if (g.length()<1)
						{
							ptsWallSplits.append(pts);
						}
					// but not the extremes	
						else
						{ 							
							double dStart = abs(vecX.dotProduct(pts.first() - extremes.first()));
							if (dStart>dEps)
								ptsWallSplits.append(pts.first());
							
							double dEnd = abs(vecX.dotProduct(pts.last() - extremes.last()));
							if (dEnd>dEps)
								ptsWallSplits.append(pts.last());							
						}
					}//next i
				}
			//End Get Wall Splits//endregion 				

			}//next p of painters	
		}
		//End Wall Dimension//endregion	
	
	//region Set and draw Dimension	
		Vector3d vecXRead = vecDir;
		if ( vecXRead.isCodirectionalTo(-_YW) ||(!vecXRead.isParallelTo(_YW) && vecXRead.dotProduct(_XW)<0))vecXRead*=-1;
		Vector3d vecYRead = vecXRead.crossProduct(-_ZW);	
		DimLine dl(_Pt0, vecXRead, vecYRead);


	//region Collect dimpoints of painters with any unknown strategy
		GenBeam gbsAll[0];
		for (int p=0;p<painters.length();p++) 
		{ 
			if (gbsAll.length()<1)
			{ 
				for (int i=0;i<walls.length();i++) 
				{ 
					gbsAll.append(walls[i].genBeam()); 				 
				}//next i		
			}
			PainterDefinition pd = painters[p]; 
			int strategy = nStrategies[p];
			String type = pd.type();		
			String name = pd.name();
			if (pd.bIsValid() && strategy==0)//
			{ 
				GenBeam gbs[0];
				gbs = pd.filterAcceptedEntities(gbsAll);				
				for (int j=0;j<gbs.length();j++) // make usre type matches, can be removed when HSB-9734 is resolved
				{ 
					GenBeam& gb = gbs[j];
					if (gb.bIsKindOf(Beam()) && (type == "Sheet" || type == "Sip")){continue;}
					else if (gb.bIsKindOf(Sheet()) && (type == "Beam" || type == "Sip")){continue;}
					else if (gb.bIsKindOf(Sip()) && (type == "Sheet" || type == "Beam")){continue;}
					gb.realBody().vis(j);//gb.myZoneIndex());  
				}//next j	

			// filter by section if specified	
				if (dSectionHeight>0)
				{
					for (int j=gbs.length()-1; j>=0 ; j--)
						if (gbs[j].envelopeBody().getSlice(pnSection).area()<pow(dEps,2))
							gbs.removeAt(j); 					
				}
					
				Point3d pts[]= lnBase.orderPoints(dl.collectDimPoints(gbs, _kLeftAndRight), dEps);
				ptsDims.append(pts); 
			}
			 
		}//next p
		
			
	//End Collect dimpoints of painters with any known strategy//endregion 

	//region Collect all dimpoints
		//Append custom points
		for (int i=0;i<mapLocs.length();i++) 
		{ 
			if (mapLocs.hasVector3d(i) && mapLocs.keyAt(i)=="grip")
			{ 
				Point3d pt = _PtW + mapLocs.getVector3d(i);
				ptsDims.append(pt);
			}		 
		}//next i	

		Point3d ptsAll[0],ptsLine[0];
		ptsAll.append(ptsRefs);		
		ptsAll.append(ptsExtremes);
		ptsAll.append(ptsOpenings);
		ptsAll.append(ptsWallConnections);	
		ptsAll.append(ptsWallSplits);
		ptsAll.append(ptsDims);
		ptsAll = lnBase.orderPoints(ptsAll, dEps);		
	//End Collect all dimpoints//endregion 

	//region DIM
		Dim dim;
		{Point3d pts[0];dim = Dim(dl, pts,"<>", "<>", nDeltaMode,nChainMode); }
		String txtMiddle = "<>"; 
		String txtEnd = "<>"; 
		
		//region Reference points
		ptsRefs = lnBase.projectPoints(lnBase.orderPoints(ptsRefs, dEps));	
		// custom reference point
		if (mapLocs.hasVector3d("ref"))
		{
			Point3d ptDimRef = _PtW + mapLocs.getVector3d("ref");
			if (ptsRefs.length()>0)		ptsRefs[0] = ptDimRef;
			else						ptsRefs.append(ptDimRef); 
		}
		// append points	
		for (int j=0;j<ptsRefs.length();j++)
		{ 
			Point3d& pt = ptsRefs[j];
		// suppress 0 if it's first point of all	
			txtEnd =(j==0 && abs(vecXRead.dotProduct(ptsAll.first()-pt))<dEps)?" ":"<>";
			dim.append(pt, txtMiddle,  txtEnd);
			ptsLine.append(pt);
		}				
		//End Reference points//endregion 

		//region Extreme points
		ptsExtremes = lnBase.projectPoints(lnBase.orderPoints(ptsExtremes, dEps));		
		for (int j=0;j<ptsExtremes.length();j++)
		{ 
			Point3d& pt = ptsExtremes[j];
			int bOk=true;
			for (int p=0;p<ptsLine.length();p++) 
			{ 
				if(abs(vecXRead.dotProduct(pt-ptsLine[p]))<dEps)
				{ 
					bOk = false;
					break;
				}	 
			}//next p
			
			if (bOk)
			{ 
			// suppress 0 if it's first point of all	
				txtEnd =(j==0 && ptsLine.length()<1 && abs(vecXRead.dotProduct(ptsAll.first()-pt))<dEps)?" ":"<>";
				dim.append(pt, txtMiddle,  txtEnd);
				ptsLine.append(pt); // collect every point to make sure it is not duplicated				
			}
		}				
		//End Extreme points//endregion 

		//region Opening points
		ptsOpenings = lnBase.projectPoints(lnBase.orderPoints(ptsOpenings, dEps));		
		for (int j=0;j<ptsOpenings.length();j++)
		{ 
			Point3d& pt = ptsOpenings[j];
			int bOk=true;
			for (int p=0;p<ptsLine.length();p++) 
			{ 
				if(abs(vecXRead.dotProduct(pt-ptsLine[p]))<dEps)
				{ 
					bOk = false;
					break;
				}	 
			}//next p
			
			if (bOk)
			{ 
			// suppress 0 if it's first point of all	
				txtEnd =(j==0 && ptsLine.length()<1 && abs(vecXRead.dotProduct(ptsAll.first()-pt))<dEps)?" ":"<>";
				dim.append(pt, txtMiddle,  txtEnd);
				ptsLine.append(pt); // collect every point to make sure it is not duplicated				
			}
		}				
		//End Opening points//endregion 

		//region Wall Split points
		ptsWallSplits = lnBase.projectPoints(lnBase.orderPoints(ptsWallSplits, dEps));		
		for (int j=0;j<ptsWallSplits.length();j++)
		{ 
			Point3d& pt = ptsWallSplits[j];
			int bOk=true;
			for (int p=0;p<ptsLine.length();p++) 
			{ 
				if(abs(vecXRead.dotProduct(pt-ptsLine[p]))<dEps)
				{ 
					bOk = false;
					break;
				}	 
			}//next p
			
			if (bOk)
			{ 
			// suppress 0 if it's first point of all	
				txtEnd =(j==0 && ptsLine.length()<1 && abs(vecXRead.dotProduct(ptsAll.first()-pt))<dEps)?" ":"<>";
				dim.append(pt, txtMiddle,  txtEnd);
				ptsLine.append(pt); // collect every point to make sure it is not duplicated				
			}
		}				
		//End Wall Split points//endregion
	
		//region Wall Connection points
		ptsWallConnections = lnBase.projectPoints(lnBase.orderPoints(ptsWallConnections, dEps));		
		for (int j=0;j<ptsWallConnections.length();j++)
		{ 
			Point3d& pt = ptsWallConnections[j];
			int bOk=true;
			for (int p=0;p<ptsLine.length();p++) 
			{ 
				if(abs(vecXRead.dotProduct(pt-ptsLine[p]))<dEps)
				{ 
					bOk = false;
					break;
				}	 
			}//next p
			
			if (bOk)
			{ 				
			// suppress delta text if toggled	
				txtMiddle = (bDisableDeltaWallConnection && j%2==0)?" ":"<>";
pt.vis(3);
			// suppress 0 if it's first point of all	
				txtEnd =(j==0 && ptsLine.length()<1 && abs(vecXRead.dotProduct(ptsAll.first()-pt))<dEps)?" ":"<>";
				dim.append(pt, txtMiddle,  txtEnd);
				ptsLine.append(pt); // collect every point to make sure it is not duplicated				
			}
		}				
		//End Wall Connection points//endregion

		//region All other dim points
		ptsDims = lnBase.projectPoints(lnBase.orderPoints(ptsDims, dEps));		
		for (int j=0;j<ptsDims.length();j++)
		{ 
			Point3d& pt = ptsDims[j];
			int bOk=true;
			for (int p=0;p<ptsLine.length();p++) 
			{ 
				if(abs(vecXRead.dotProduct(pt-ptsLine[p]))<dEps)
				{ 
					bOk = false;
					break;
				}	 
			}//next p
			
			if (bOk)
			{ 
			// suppress 0 if it's first point of all	
				txtEnd =(j==0 && ptsLine.length()<1 && abs(vecXRead.dotProduct(ptsAll.first()-pt))<dEps)?" ":"<>";
				dim.append(pt, txtMiddle,  txtEnd);
				ptsLine.append(pt); // collect every point to make sure it is not duplicated				
			}
		}				
		//All other dim points//endregion		
		
		
		dim.setReadDirection(vecXRead + vecYRead);
		dp.draw(dim);			
	//End DIM//endregion 

		
	// Description
		PLine plDescriptionBox;
		if (sFormat.length()>0)
		 {
		 // snap description text outside of dimine	
		 	Point3d pts[0];
		 	pts = lnBase.orderPoints(ptsLine);
		 	Point3d pt; pt.setToAverage(pts);
		 	int nDir = vecXRead.dotProduct(_Pt0 - pt) < 0 ?- 1 : 1;
		 	pt = _Pt0;
		 	Vector3d vec=nDir*vecXRead; 
		 	pts = Line(_Pt0, vec).projectPoints(pts);
		 	vec.vis(pts.first(), 2);
		 	
		 	if (pts.length()>0 && vec.dotProduct(pts.first()-_Pt0)>0)
		 		pt = pts.first()+vec*dTextHeight;
		 		
		 // draw description		
			Map mapAdditionalVariables; // TODO
			String text = el.formatObject(sFormat, mapAdditionalVariables);
			if (text.find("@(",0,false)>-10)text = _ThisInst.formatObject(text, mapAdditionalVariables);
			dp.draw(text, pt, vecXRead, vecYRead, nDir, 0);

			auto x = nDir*vecXRead*dp.textLengthForStyle(text, sDimStyle, dTextHeight);
			auto y = vecYRead*(dp.textHeightForStyle(text, sDimStyle, dTextHeight)+dTextHeight);
			plDescriptionBox.createRectangle(LineSeg(pt-.5*y, pt+x+.5*y), vecXRead, vecYRead);
			plDescriptionBox.vis(2);
		}
			
	// publish dim text areas
		PLine plines[]=dim.getTextAreas(dp);
		if (plDescriptionBox.area()>pow(dEps,2))plines.append(plDescriptionBox);
		PlaneProfile ppText(csPlan);
		for (int i=0;i<plines.length();i++) 
			ppText.joinRing(plines[i],_kAdd); 
		ppText.shrink(-.25*dTextHeight);	
		// add area on line
		if (ptsDims.length()>0)
		{ 
			Point3d pt1 = ptsAll.first();			Point3d pt2 = ptsAll.last();			Point3d ptMid = (pt1 + pt2) * .5;
			ptMid += vecPerp * vecPerp.dotProduct(_Pt0 - ptMid);
			auto x = vecDir*abs(vecDir.dotProduct(pt2 - pt1))*.5;
			auto y = vecPerp*.5 *dTextHeight;
			PLine pl; pl.createRectangle(LineSeg(ptMid -x-y,ptMid+x+y), vecDir, vecPerp);
			ppText.joinRing(pl,_kAdd);
		}
		ppText.removeAllOpeningRings();
		_Map.setPlaneProfile("ppText", ppText);//ppText.vis(_ThisInst.color());
	//End Dimension//endregion 

	//region Relocate collsion free
		if (tslParents.length()>0)
		{ 
			Point3d pt=_Pt0;
			int n;
			PlaneProfile pp = ppParent;
			pp.intersectWith(ppText);
			while (pp.area()>pow(.1*dTextHeight,2) && n<20)
			{ 
				pt.transformBy(vecPerp * .25 * dTextHeight);
				ppText.transformBy(vecPerp * .25 * dTextHeight);	ppText.vis(n);
				pp = ppParent;
				pp.intersectWith(ppText);
				n++;
			}
			
			double d = vecPerp.dotProduct(pt - _Pt0);
			if (!bDebug && d>dEps)
			{ 
				_Pt0 += vecPerp * d;
				setExecutionLoops(2);
			}
		}			
	//End Relocate collsion free//endregion 

	//region TRIGGER
	//region Trigger SetRefPoint
		String sTriggerSetRefPoint = T("|Set Reference Point|");
		addRecalcTrigger(_kContextRoot, sTriggerSetRefPoint );
		if (_bOnRecalc && _kExecuteKey==sTriggerSetRefPoint)
		{
			Point3d pt = getPoint(T("|Select Reference Point|"));		
			if (!mapLocs.hasVector3d("ref"))
				_PtG.append(pt);
			else
				_Map.setInt("update", true);
			mapLocs.setVector3d("ref", pt - _PtW);
			_Map.setMap("Loc[]", mapLocs);
			setExecutionLoops(2);
			return;
		}//endregion	
		
	//region Trigger AddPoints
		String sTriggerAddPoint = T("|Add Points|");
		addRecalcTrigger(_kContextRoot, sTriggerAddPoint );
		if (_bOnRecalc && _kExecuteKey==sTriggerAddPoint)
		{
			PrPoint ssP(TN("|Select point|")); 
			while(1)
			{ 
				if (ssP.go()==_kOk) 
				{
					Point3d pt = ssP.value();
					mapLocs.appendVector3d("grip", pt - _PtW);
					_PtG.append(pt); // append the selected points to the list of grippoints _PtG
				}
				else
					break;
					
			}
			_Map.setMap("Loc[]", mapLocs);
			setExecutionLoops(2);
			return;
		}//endregion
		
	//region Trigger RemovePoint
		String sTriggerRemovePoint = T("|Remove Point|");
		addRecalcTrigger(_kContextRoot, sTriggerRemovePoint );
		if (_bOnRecalc && _kExecuteKey==sTriggerRemovePoint)
		{
			Point3d ptLast = _Pt0;
			PrPoint ssP(T("|Select point|"), ptLast); // second argument will set _PtBase in map
		    int nGoJig = -1;
		    while (nGoJig != _kOk && nGoJig != _kNone)
		    {
		        nGoJig = ssP.goJig("JigAction", mapLocs); 
		        if (nGoJig == _kOk)
		        {
		            ptLast = ssP.value(); //retrieve the selected point		            
		        	for (int i=0;i<mapLocs.length();i++) 
					{ 
						if (mapLocs.hasVector3d(i))
						{ 
							Point3d pt = _PtW + mapLocs.getVector3d(i);
							if (_PtG.length()>i && abs(vecX.dotProduct(_PtG[i]-pt))<dEps)
							{
								_PtG.removeAt(i);
								mapLocs.removeAt(i,true);
								break;
							}
						}
	
					}//next i 
					if (mapLocs.length()>0)
						_Map.setMap("Loc[]", mapLocs);
					else
						_Map.removeAt("Loc[]", true);
					setExecutionLoops(2);
		        }
		        else if (nGoJig == _kCancel)
		        { 	        	
		            return; 
		        }
		    }			
		}//endregion	
	
	//region Trigger AddParentDimension
		String sTriggerSetParentDim = T("|Set Parent Dimline|");
		addRecalcTrigger(_kContext, sTriggerSetParentDim );
		if (_bOnRecalc && _kExecuteKey==sTriggerSetParentDim)
		{
		// prompt for tsls
			Entity ents[0];
			PrEntity ssE(T("|Select parent dimlines|"), TslInst());
		  	if (ssE.go())
				ents.append(ssE.set());
			
		// loop tsls
			for (int i=ents.length()-1; i>=0 ; i--) 
			{ 
				TslInst t=(TslInst)ents[i];
				if (t.bIsValid() && t.scriptName()==scriptName() && t!=_ThisInst)
				{ 
					_Entity.append(t);
				}
			}			
			setExecutionLoops(2);
			return;
		}//endregion
		
	//region Trigger RemoveParentDimension
		if (tslParents.length()>0)
		{ 
			String sTriggerRemoveParentDim = T("|Remove Parent Dimline|");
			addRecalcTrigger(_kContext, sTriggerRemoveParentDim );
			if (_bOnRecalc && _kExecuteKey==sTriggerRemoveParentDim)
			{
			// prompt for tsls
				Entity ents[0];
				PrEntity ssE(T("|Select dimlines to remove as parent|"), TslInst());
			  	if (ssE.go())
					ents.append(ssE.set());
				
			// loop tsls
				for (int i=ents.length()-1; i>=0 ; i--) 
				{ 
					int n = _Entity.find(ents[i]);
					if (n>-1)
					{ 
						_Entity.removeAt(n);
					}
				}			
				setExecutionLoops(2);
				return;
			}		
		}//endregion
	
	//region Trigger Wall
		if (bIsWall)
		{ 
		//region Trigger AddWalls
			String sTriggerAddWall = T("|Add Walls|");
			addRecalcTrigger(_kContextRoot, sTriggerAddWall );
			if (_bOnRecalc && _kExecuteKey==sTriggerAddWall)
			{
			// prompt for elements
				PrEntity ssE(T("|Select elements|"), ElementWall());
				Element elements[0];
			  	if (ssE.go())
					elements.append(ssE.elementSet());
				
				for (int i=0;i<elements.length();i++) 
					if (_Element.find(elements[i])<0)
						_Element.append(elements[i]); 
	
				setExecutionLoops(2);
				return;
			}//endregion
			
		//region Trigger RemoveWalls
			if (_Element.length()>1)
			{ 
				String sTriggerRemoveWalls = T("|Remove Walls|");
				addRecalcTrigger(_kContextRoot, sTriggerRemoveWalls );
				if (_bOnRecalc && _kExecuteKey==sTriggerRemoveWalls)
				{
				// prompt for elements
					PrEntity ssE(T("|Select elements|"), ElementWall());
					Element elements[0];
				  	if (ssE.go())
						elements.append(ssE.elementSet());
						
					for (int i=0;i<elements.length();i++) 
					{
						int n = _Element.find(elements[i]);
						if (n>-1 && _Element.length()>1)
							_Element.removeAt(n);
					}
							
							
					setExecutionLoops(2);
					return;
				}				
			}//endregion	

		//region DisableDeltaWallConnection
			if (nStrategy==2 || nStrategy==3)
			{ 
				String sTriggerDisableDeltaWallConnection =bDisableDeltaWallConnection?T("|Show Connection Delta Text|"):T("|Hide Connection Delta Text|");
				addRecalcTrigger(_kContextRoot, sTriggerDisableDeltaWallConnection);
				if (_bOnRecalc && _kExecuteKey==sTriggerDisableDeltaWallConnection)
				{
					bDisableDeltaWallConnection = bDisableDeltaWallConnection ? false : true;
					mapCustom.setInt("DisableDeltaWallConnection", bDisableDeltaWallConnection);	
					_Map.setMap("Custom", mapCustom);
					setExecutionLoops(2);
					return;
				}				
			}
			else if (bDisableDeltaWallConnection)
			{ 
				mapCustom.removeAt("DisableDeltaWallConnection", true);
				_Map.setMap("Custom", mapCustom);
				setExecutionLoops(2);
				return;				
			}
				
		//End DisableDeltaWallConnection//endregion 

		//region Trigger SetupDimensionGroup
		// Setup Dimension Group Dialog TSL
			TslInst tslDialog;			Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
			GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {};
			int nProps[]={};			double dProps[]={};				String sProps[]={};
			Map mapTsl;		
		
			String sTriggerSetupDimensionGroup = T("|Setup Dimension Group|");
			addRecalcTrigger(_kContext, sTriggerSetupDimensionGroup );
			if (_bOnRecalc && _kExecuteKey==sTriggerSetupDimensionGroup)
			{
			// prompt for tsls
				Entity ents[0];
				PrEntity ssE(T("|Select additional floorplan dimensions|"), TslInst());
			  	if (ssE.go())
					ents.append(ssE.set());
				
			// Collect dimline tsls
				TslInst tsls[] ={ _ThisInst};
				for (int i=ents.length()-1; i>=0 ; i--) 
				{ 
					TslInst tsl=(TslInst)ents[i];
					if (tsl.bIsValid() && tsl.scriptName()==scriptName()  && tsls.find(tsl)<0)//&& tsl.entity().find(el)>-1
					{ 
						tsls.append(tsl);
					}
				}
				
			// order by baseline
				for (int i=0;i<tsls.length();i++) 
					for (int j=0;j<tsls.length()-1;j++) 
					{
						double d1 = vecPerp.dotProduct(tsls[j].ptOrg() - ptOrg);
						double d2 = vecPerp.dotProduct(tsls[j+1].ptOrg() - ptOrg);
						if (d2<d1)
							tsls.swap(j, j + 1);
					}
	
				mapTsl.setInt("DialogMode",1);
				sProps.append(sConfigurations.length()>0?sConfigurations.first():T("|Default|"));
				sProps.append(bExposed?sAssociations[1]:sAssociations[0]);	
	
				tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
	
				if (tslDialog.bIsValid())
				{
					int bOk = tslDialog.showDialog();
					if (bOk)
					{
						// build dimgroup map
						Map mapRequests;
						for (int i = 0; i < tsls.length(); i++)
						{
							TslInst& t = tsls[i];
							Point3d pt = t.ptOrg();
							double baseOffset;
							PLine pl;
							if (i == 0)
							{
								baseOffset = vecPerp.dotProduct(pt - el.plOutlineWall().closestPointTo(pt));
							}
							else 
							{
								baseOffset = vecPerp.dotProduct(pt - tsls[i - 1].ptOrg());
							}
	
							Map mapRequest;
							mapRequest.setDouble("baseOffset", baseOffset);
							mapRequest.setString("scriptName", t.scriptName());
							mapRequest.setMap("PropertyMap", t.mapWithPropValues());
							mapRequest.setMap("Custom", t.map().getMap("Custom"));
							mapRequests.appendMap("Request", mapRequest);
						}//next i
						
						
						String sConfiguration = tslDialog.propString(0);
						String sAssociation= tslDialog.propString(1);
						
					// get current configuration	
					 	Map mapAllConfigs,mapConfig;
						for (int i = 0; i < mapConfigs.length(); i++)
						{
							Map m = mapConfigs.getMap(i);
							String name = m.getMapName();
							if (name.length()>0 && name==sConfiguration)
							{
								mapConfig = m;
							}
							else if(m.length()>0)
								mapAllConfigs.appendMap("Configuration",m);
						}	
						
					// get current rule
					 	Map mapRules=mapConfig.getMap("Rule[]"), _mapRules,mapRule;
						for (int i=0; i<mapRules.length(); i++)
						{
							Map m = mapRules.getMap(i);
							String name = m.getMapName();
							if (name.length()>0 && name==sAssociation)
								mapRule = m;
							else if(m.length()>0)
								_mapRules.appendMap("Rule",m);
						}
						mapRules = _mapRules;	
					
					// Overwrite existing rule
						int bAdd=true;
						if (mapRule.length()>0)
						{ 
							String sInput = getString(T("|Overwrite existing rule?|") + " [" + T("|No|") +"/"+T("|Yes|")+"]");
							if (sInput.makeUpper()!=T("|Yes|").makeUpper().left(1))
							{	
								reportMessage("\n" + scriptName() + " " + T("|canceled|")+ ".");
								bAdd = false;
							}
						}	
					
					// add current rule
						if (bAdd)
						{ 
							mapRule.setMap("Request[]",mapRequests);
							mapRule.setInt("Exposed",sAssociations.find(sAssociation));
							mapRule.setMapName(sAssociation);		
							mapRules.appendMap("Rule",mapRule);
							
							mapConfig.setMap("Rule[]", mapRules);
							mapConfig.setMapName(sConfiguration);
							mapAllConfigs.appendMap("Configuration",mapConfig);
							mapSetting.setMap("Configuration[]", mapAllConfigs);
							if (mo.bIsValid())mo.setMap(mapSetting);	
							else mo.dbCreate(mapSetting);
						}	
						
					}		
					tslDialog.dbErase();
				}
	
				
				setExecutionLoops(2);
				return;
			}	
			
			
			String sTriggerSetStrategy = T("|Set Strategy of Painter| " + sStrategy);
			addRecalcTrigger(_kContext, sTriggerSetStrategy );
			if (_bOnRecalc && _kExecuteKey==sTriggerSetStrategy)			
			{ 
				mapTsl.setInt("DialogMode",2);
				sProps.append(nStrategy <0 ? sNone: sDefaultStrategies[nStrategy]);
				tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
	
				if (tslDialog.bIsValid())
				{
					int bOk = tslDialog.showDialog();
					if (bOk)
					{
						String strategy = tslDialog.propString(0);
						
						Map m;		
						if (strategy==sNone)
							m.removeAt("Strategy", true);
						else 
							m.setString("Strategy",strategy);				
						painter.setSubMapX(sScript,m);
					}
					tslDialog.dbErase();
				}
	
				setExecutionLoops(2);
				return;				
			}//endregion
			
			
		}		
		//End Trigger Wall//endregion 	

	//End TRIGGER//endregion 


	}
//End Dimension mode//endregion 


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
        <int nm="BreakPoint" vl="1809" />
        <int nm="BreakPoint" vl="1619" />
        <int nm="BreakPoint" vl="1307" />
        <int nm="BreakPoint" vl="1305" />
        <int nm="BreakPoint" vl="1599" />
        <int nm="BreakPoint" vl="1750" />
        <int nm="BreakPoint" vl="1464" />
      </lst>
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End