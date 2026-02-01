#Version 8
#BeginDescription
#Versions
Version 3.7 06.02.2025 HSB-23464 update options added if version of delivered products has been updated , Author Thorsten Huck
Version 3.6 06.02.2025 HSB-23464 legacy warning introduced
3.6 05.12.2024 HSB-23003: save graphics in file for render in hsbView and make Author: Marsel Nakuci
Version 3.5 07.10.2024 HSB-20808 fixed translation issue
Version 3.4 09.05.2023 HSB-18983 edit in place is limited to 1 item
Version 3.3 19.12.2022 HSB-17410 dove export corrected
Version 3.2 01.02.2022 HSB-14560 new settings option to auto select a predefined type by component name, new context commands to Import/Export the settings
Version 3.1 17.01.2022 HSB-14400 bugfix dimrequest multiple panels
Version 3.0 20.12.2021 HB-14226 supports tool description format, tool based tool index and exports to hsbMake and hsbShare added.
Version 2.9 29.04.2021 HSB-11426 Faro Laserscanner data added

version value="2.8" date="25nov2020" author="marsel.nakuci@hsbcad.com" 
HSB-9833: trigger convertToStatic available for both modes EditInPlace and notEditInPlace
HSB-9833: add trigger to make entity static

version value="2.6" date="07oct2020" author="thorsten.huck@hsbcad.com"
HSB-9108 properties renamed to fullfil formatVariable convention

HSB-8043 positioning complex shapes fixed, distriburtion by quantity fixed
HSB-7990 bugfix tool placement short segments nearby, performance improved

legacy: type written to model and article number of hardware, additional depth shown in shopdrawing
bugfix basepoint
HSBCAD-417 tool shape individually stored per panel
HSBCAD-540 new property to specify additional depth

This tsl creates a distribution of X-Fix-C Connectors along a common edge of at least two panels









#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 3
#MinorVersion 7
#KeyWords CLT;Greenethic;Dove
#BeginContents
/// <History>//region
// #Versions
// 3.7 06.02.2025 HSB-23464 update options added if version of delivered products has been updated , Author Thorsten Huck
// 3.6 06.02.2025 HSB-23464 legacy warning introduced. , Author Thorsten Huck
//3.5 07.10.2024 HSB-20808 fixed translation issue / calculation of HardWrComp dScaleZ , Author Martin von Kessel
// 3.4 09.05.2023 HSB-18983 edit in place is limited to 1 item , Author Thorsten Huck
// 3.3 19.12.2022 HSB-17410 dove export corrected , Author Thorsten Huck
// 3.2 01.02.2022 HSB-14560 new settings option to auto select a predefined type by component name, new context commands to Import/Export the settings , Author Thorsten Huck
// 3.1 17.01.2022 HSB-14400 bugfix dimrequest multiple panels , Author Thorsten Huck
// 3.0 20.12.2021 HB-14226 supports tool description format, tool based tool index and exports to hsbMake and hsbShare added. , Author Thorsten Huck
// 2.9 29.04.2021 HSB-11426 Faro Laserscanner data added , Author Thorsten Huck
/// <version value="2.8" date="25nov2020" author="marsel.nakuci@hsbcad.com"> HSB-9833: trigger convertToStatic available for both modes EditInPlace and notEditInPlace</version>
/// <version value="2.7" date="24nov2020" author="marsel.nakuci@hsbcad.com"> HSB-9833: add trigger to make entity static</version>
/// <version value="2.6" date="07oct2020" author="thorsten.huck@hsbcad.com"> HSB-9108 properties renamed to fullfil formatVariable convention </version>
/// <version value="2.5" date="23jun2020" author="thorsten.huck@hsbcad.com"> HSB-8043 positioning complex shapes fixed, distriburtion by quantity fixed </version>
/// <version value="2.4" date="22jun2020" author="thorsten.huck@hsbcad.com"> HSB-7990 bugfix tool placement short segments nearby, performance improved </version>
/// <version value="2.3" date="30mar2020" author="thorsten.huck@hsbcad.com"> HSB-6926 bugfix distribution extrusion body </version>
/// <version value="2.2" date="11mar2020" author="thorsten.huck@hsbcad.com"> HSB-6956 context command to flip alignment corrected </version>
/// <version value="2.1" date="11mar2020" author="thorsten.huck@hsbcad.com"> HSB-6926 dimension requests enhanced </version>
/// <version value="2.0" date="10mar2020" author="thorsten.huck@hsbcad.com"> HSB-6926 settings support, new admin function available in 'edit in place' mode if instance color is red (1): one can specify the solid representation as well as the individual tooling contour </version>
/// <version value="1.9" date="03feb2020" author="thorsten.huck@hsbcad.com"> HSB-6540 bugfix flip side on partial edge overlappings with gap </version>
/// <version value="1.8" date="03feb2020" author="thorsten.huck@hsbcad.com"> HSB-6537 hardware quantity fixed on distributions </version>
/// <version value="1.7" date="08mar2019" author="thorsten.huck@hsbcad.com"> openings near an edge will not influence location anymore </version>
/// <version value="1.6" date="21feb2019" author="thorsten.huck@hsbcad.com"> edge offset and distribution corrected </version>
/// <version value="1.5" date="20feb2019" author="thorsten.huck@hsbcad.com"> basepoint fixed to one of the relevant edges </version>
/// <version value="1.4" date="20feb2019" author="thorsten.huck@hsbcad.com"> legacy: type written to model and article number of hardware, additional depth shown in shopdrawing  </version>
/// <version value="1.3" date="20feb2019" author="thorsten.huck@hsbcad.com"> bugfix basepoint </version>
/// <version value="1.2" date="20feb2019" author="thorsten.huck@hsbcad.com"> HSBCAD-417 tool shape individually stored per panel, HSBCAD-540 new property to specify additional depth </version>
/// <version value="1.1" date="25jan2019" author="thorsten.huck@hsbcad.com"> HSBCAD-417 store tool shape for shopdrawing and masterpanel manager display </version>
/// <version value="1.0" date="06mar2018" author="thorsten.huck@hsbcad.com"> initial </version>
/// </History>

/// <insert Lang=en>
/// Select one or multiple panels, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates a distribution of X-Fix-C Connectors along a common edge of at least two panels
/// </summary>//endregion

// List of custom commands for CUIX implementation
//^C^C(defun c:TSL_XFIXC() (hsb_ScriptInsert "hsbCLT-X-Fix-C")) TSL_XFIXC
//^C^C(defun c:TSL_XFIXC() (hsb_RecalcTslWithKey (_TM "|Add Panel(s)|") (_TM "|Select X-Fix(s)'|"))) TSL_XFIXC
//^C^C(defun c:TSL_XFIXC() (hsb_RecalcTslWithKey (_TM "|Remove Panel(s)|") (_TM "|Select X-Fix(s)|"))) TSL_XFIXC
//^C^C(defun c:TSL_XFIXC() (hsb_RecalcTslWithKey (_TM "|Edit in Place|") (_TM "|Select X-Fix(s)|"))) TSL_XFIXC
//^C^C(defun c:TSL_XFIXC() (hsb_RecalcTslWithKey (_TM "|Flip Alignment|") (_TM "|Select X-Fix(s)|"))) TSL_XFIXC
//^C^C(defun c:TSL_XFIXC() (hsb_RecalcTslWithKey (_TM "|Recalc Segments|) (_TM "|Select X-Fix(s)|"))) TSL_XFIXC
//endregion

//region Constants 
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;

	String tDefault =T("|_Default|");
	String tLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};

	String sDialogLibrary = _kPathHsbInstall + "\\Utilities\\DialogService\\TslUtilities.dll";
	String sClass = "TslUtilities.TslDialogService";	
	String listSelectorMethod = "SelectFromList";
	String optionsMethod = "SelectOption";
	String simpleTextMethod = "GetText";
	String askYesNoMethod = "AskYesNo";
	String showNoticeMethod = "ShowNotice";
	String showMultilineNotice = "ShowMultilineNotice";
	String showDynamic = "ShowDynamicDialog";

//region Color and view	
	int bIsDark;{int n = getBackgroundTrueColor();bIsDark = ((rgbR(n) + rgbB(n) + rgbG(n)) / 3 < 127);}
	int grey = bIsDark?rgb(199,200,202):rgb(99,100,102);
	int white = bIsDark?rgb(255,255,255):rgb(0,0,0);	
	
	int lightblue = rgb(204,204,255);
	int blue = rgb(69,84,185);	
	int darkblue = rgb(26,50,137);	
	int yellow = rgb(241,235,31);
	int darkyellow = rgb(254, 204, 102);
	int orange = rgb(242,103,34);
	int red = rgb(205,32,39);
	int purple = rgb(147,39,143);
	int petrol = rgb(16,86,137);
	int green = rgb(19,155,72);	

	Vector3d vecXView = getViewDirection(0);
	Vector3d vecYView = getViewDirection(1);
	Vector3d vecZView = getViewDirection(2);
	double dViewHeight = getViewHeight();	
//endregion 	
	

	String kAutomatic = T("<|Automatic|>");
	int arNCncMode[] = {_kFingerMill, _kUniversalMill, _kVerticalFingerMill };
//end Constants//endregion
	
	
//region Functions
	
//region Function SetItemList
	// returns a map which can be consumed by a comboBox of the dialog service
	// values[]: an array of strings
	Map SetItemList(String values[], String defaultValue)
	{ 
		Map mapOut;
		for (int i=0;i<values.length();i++) 
		{
			String value = values[i];
			mapOut.setString("Item" + (i+1), value);
		}
		if (mapOut.length()<1)
			mapOut.setString("Item1",defaultValue);
		return mapOut;
	}//endregion


//region Function AllowNestedDialog
	// prompts the user to update the settings
	void UpdateSettings(String path, String nameSettings, String prompt, Map& settings, MapObject& moX)
	{ 	
		int bUpdate=true;
		String options[] = { T("|Keep current settings|"), T("|Update to new settings|")};
		Map mapItems = SetItemList(options,"");

		Map mapIn;
		mapIn.setString("Title", T("|Settings Update| ")+nameSettings);
		mapIn.setString("Prompt", prompt);
		mapIn.setString("Alignment", "Right");
		mapIn.setMap("Items[]", mapItems);
		mapIn.setInt("SelectedIndex", bUpdate?1:0);//__when selected index is present, it is used over initial selection set by int in items list

		Map mapOut = callDotNetFunction2(sDialogLibrary, sClass, optionsMethod, mapIn);	

		if (mapOut.hasInt("SelectedIndex"))
			bUpdate = mapOut.getInt("SelectedIndex")==1;		

		if (bUpdate)
		{ 
			settings.readFromXmlFile(path);
			moX.setMap(settings);
			setDependencyOnDictObject(moX);
			reportMessage(TN("|The settings have been updated, please review the model of existing instances.|"));			
		}

		return;
	}//endregion

	
//endregion
	

//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sPathGeneral = _kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\";	
	String sFileName ="hsbCLT-X-Fix-C";
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
	if(_bOnInsert || _bOnDbCreated)
	{ 		
		int nVersion = mapSetting.getInt("GeneralMapObject\\Version");
		String sFile = findFile(sPathGeneral + sFileName + ".xml");		// set default xml path
		//if (sFile.length()<1)
		sFile=findFile(sFullPath);				// set custom xml path if no default found
		Map mapSettingInstall; mapSettingInstall.readFromXmlFile(sFile);	// read the xml from installation directory
		int nVersionInstall = mapSettingInstall.getMap("GeneralMapObject").getInt("Version");	

		if(sFile.length()>0 && nVersion!=nVersionInstall)
		{ 
			String sPrompt = TN("|A different Version of the settings has been found for|") + scriptName()+
				TN("|Current Version| ") + nVersion + "	" + _kPathDwg + TN("|Other Version| ") + nVersionInstall + "	" + sFile;
			
			UpdateSettings(sFile, sFileName, sPrompt, mapSetting, mo);
			
		}

	}
//End Settings//endregion
	
//region Read Settings
	String sTypes[] = {"96/130/45 R15", "96/130/65 R15", "96/130/90 R15", "96/130/130 R15"};
	double dTypeDepths[] = { U(45), U(65), U(90), U(130)};
	PLine plShapes[sTypes.length()];
	PLine plTools[sTypes.length()];
	PLine plShape, plTool; // the tool shape, needs to be transformed to tool location
	int nc = 30, ncText = 5;
	String stereotype = "x-fix";
	
	Map mapTypes,mapComps;
	int bIsTypeByComponentName;
{
	String k;
	Map m= mapSetting;
	
//region Get Display
	Map mapDisplay;
	k="Display";		if (m.hasMap(k))	mapDisplay = m.getMap(k);
	
	k="Color";			if (mapDisplay.hasInt(k))	nc = mapDisplay.getInt(k);
	k="ColorText";		if (mapDisplay.hasInt(k))	ncText = mapDisplay.getInt(k);
	k="Stereotype";		if (mapDisplay.hasString(k))stereotype = mapDisplay.getString(k);
//End Get Display//endregion 


//region Get Types
		
// Get global shape and tool definition	
	k="Type[]";		if (m.hasMap(k))	mapTypes = m.getMap(k);
	k="Shape";		
	if (mapTypes.hasPLine(k))
	{
		plShape = mapTypes.getPLine(k); // the tool shape maybe defined once for all types
		k="Tool";		if (mapTypes.hasPLine(k) && plShape.length()>0)	plTool = mapTypes.getPLine(k); 
	}

// Get types from settings
	
	if (mapTypes.length()>0)
	{ 
		String _types[0];
		double _depths[0];
		PLine _shapes[0];
		PLine _tools[0];
		
		for (int i=0;i<mapTypes.length();i++) 
		{ 
			Map mapType = mapTypes.getMap(i);

			if (mapType.hasMap("ComponentName[]"))bIsTypeByComponentName = true;

			String type = mapType.getString("Type");
			double depth = mapType.getDouble("Depth");
			PLine shape = plShape;
			PLine tool= plTool;
			k = "Shape"; 
			if(mapType.hasPLine(k) && mapType.getPLine(k).length()>dEps)
			{
				shape=mapType.getPLine(k);
				k = "Tool"; if(mapType.hasPLine(k) && mapType.getPLine(k).length()>dEps) tool=mapType.getPLine(k);
			}
			
			if (type.length()>0 && _types.find(type)<0)
			{ 
				_types.append(type);
				_depths.append(depth>0?depth:0);
				_shapes.append(shape);
				_tools.append(tool);
			} 
		}//next i



	// HSB-20808 Collect an array which is sortable by padding zeros to the left
		String sTypeSortings[0];
		for (int i=0;i<_types.length();i++) 
		{ 
			String typeSort = _types[i];
			String tokens[] = typeSort.tokenize("/");
			if (tokens.length()==3)
			{ 
				for (int j=0;j<tokens.length();j++) 
				{ 
					Map m;
					m.setString("valX", tokens[j]);
					tokens[j] = _ThisInst.formatObject("@(valX:PL3;0)", m);
							 
				}//next j
				typeSort = tokens[0] + "/" + tokens[1] + "/" + tokens[2];	
			}
			sTypeSortings.append(typeSort);
		}
	
// HSB-23464 show sequence as defined in xml in order to show newest types first	
//	// order alphabetically by sortable array
//		for (int i=0;i<_types.length();i++) 
//			for (int j=0;j<_types.length()-1;j++)
//				if (sTypeSortings[j]>sTypeSortings[j+1])
//				{
//					sTypeSortings.swap(j, j + 1);
//					_types.swap(j, j + 1);
//					_depths.swap(j, j + 1);
//					_shapes.swap(j, j + 1);
//					_tools.swap(j, j + 1);
//				}

		if (_types.length()>0)
		{ 
			sTypes = _types;
			dTypeDepths = _depths;
			plShapes = _shapes;	
			plTools = _tools;	
		}

		
	// doo not allow selection on insert when set to componentName mode	
		 if (_bOnInsert && bIsTypeByComponentName)
		 {
		 	sTypes.setLength(0);
		 	sTypes.append(kAutomatic);
		 }
		 
	}	
//End Get Types//endregion 
}
//End Read Settings//endregion 


//region Properties
// Category 1: Type
	category = T("|Type|");
	String sTypeName=T("|Type|") ;
	PropString sType (nStringIndex++,sTypes, sTypeName);
	sType.setDescription(T("|Specifies the type of the connector.|") + 
		T("|Please note that all types without the appendinx 'R15' are deprecated and are not produced and traded by the supplier anymore.|"));
	sType.setCategory(category);
	sType.setReadOnly(_bOnInsert && bIsTypeByComponentName);	
	
	String sDepthName=T("|Depth|");	
	PropDouble dPDepth(3, U(0), sDepthName);	
	dPDepth.setDescription(T("|Defines the additional depth in relation to the selected type|"));
	dPDepth.setCategory(category);
	
// Category 2: Distribution	
	category = T("|Distribution|");
	String sOffset1Name=T("|Offset| 1") ;	
	PropDouble dOffset1 (nDoubleIndex++, U(200), sOffset1Name);
	dOffset1.setCategory(category);
	
	String sOffset2Name=T("|Offset| 2") ;	
	PropDouble dOffset2 (nDoubleIndex++, U(200), sOffset2Name);
	dOffset2.setCategory(category);
	
	String sInterdistance=T("|Interdistance/(Qty)|") ;	
	PropDouble dInterdistance (nDoubleIndex++, U(1000), sInterdistance);
	dInterdistance.setCategory(category);
	dInterdistance.setDescription(T("|Defines the interdistance or the quantity of connectors|"));
	double dMinInterdistance = U(110);
	
	String sSideName=T("|Side|");
	String sSides[] = { T("|Reference Side|"), T("|Opposite Side|") };
	PropString sSide(nStringIndex++, sSides, sSideName);	
	sSide.setDescription(T("|Defines the Side|"));
	sSide.setCategory(category);		
	
// varias
	double dTxtH = U(60);
	double dInnerWidth = U(19.3);
	double dOuterWidth =U(54.51);	
	double dDoveDepth = U(65.63);
	
	double dMinOffset = dOuterWidth + U(10);
	
	double dOverlap = dDoveDepth * .5;
	
	int bIODebug = bDebug && _ThisInst.color()==2;// = true; // flag to debug mapIO
//End Properties//endregion 	

//region On insert
	if(_bOnInsert)
	{
		//if (insertCycleCount()>1) { eraseInstance(); return; }
					
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
				setPropValuesFromCatalog(tLastInserted);					
		}	
		else	
			showDialogOnce();
		

	// selection set
		Entity ents[0];
		//PrEntity ssE(T("|Select panels|" + " " + T("|<Enter> to select a wall|")), Sip());
		PrEntity ssE(T("|Select panel(s)|"), Sip());
		if (ssE.go())
				ents= ssE.set();

	// add panels to global sip array
		for(int i = 0;i <ents.length();i++)
		{
			if(ents[i].bIsKindOf(Sip()))	
				_Sip.append((Sip)ents[i]);
		}
		
//	// prompt for an element
//		if (_Sip.length()<1)
//		{
//			_Element.append(getElement());
//			_Pt0 = getPoint();
//			return; // stop insert code here
//		}			
	// split the selected clt	
		if (_Sip.length()==1)
		{
			Point3d pt1 = getPoint(T("|Select first point on split axis|"));
			PrPoint ssP(T("|Select second point on split axis|"),pt1);
			Point3d pt2;
			if (ssP.go()==_kOk) // do the actual query
				pt2 = ssP.value();

			Vector3d vec=pt2-pt1;
			vec.normalize();
			Vector3d vecNormal = vec.crossProduct(_Sip[0].vecZ());
			vecNormal.normalize();
			Plane pnSplit(pt1,vecNormal);
			Sip sips[0];
			sips=_Sip[0].dbSplit(pnSplit,0);
			if (sips.length()>0)
			{
				_Sip.append(sips);
				_Pt0 = (pt1 + pt2) * .5;
				_Map.setVector3d("vecDir", vecNormal);
			}
			else
			{
				reportMessage(TN("|Splitting was not successful.|") + " " + T("|Tool will be deleted.|"));
				eraseInstance();
				return;	
			}		
		}
		else if (_Sip.length()>1)
		{ 
			Vector3d vecZ = _Sip[0].vecZ();
			Map mapIO;
			for (int e=0;e<_Sip.length();e++)
				mapIO.appendEntity("Entity", _Sip[e]);
			TslInst().callMapIO(scriptName(), mapIO);			
			
			Map mapEdges = mapIO.getMap("Edge[]");
			int nNumEdges = mapEdges.length();
			if (nNumEdges > 0)
			{
				Map m = mapEdges.getMap(0);
				Vector3d vecDir = m.getVector3d("vecNormal");
				_Pt0 = m.getPoint3d("ptMid");
				
			// use most aligned
				if (nNumEdges > 1)
				{
					Point3d pt1 = _Sip[0].ptCenSolid();
					PrPoint ssP("\n" + T("|Select second point|"), pt1);
					
					if (ssP.go() == _kOk)
					{
						Point3d pt2	= ssP.value();
						pt2.transformBy(vecZ * vecZ.dotProduct(pt1 - pt2));
						Vector3d vecTestDir = pt2 - pt1;
						vecTestDir.normalize();
						
					// loop edges
						double dP;
						for (int i=0;i<nNumEdges;i++) 
						{ 
							m = mapEdges.getMap(i);
							Vector3d vecNormal= m.getVector3d("vecNormal");
							Point3d ptMid = m.getPoint3d("ptMid");
							//reportMessage("\nvecN1 " + vecNormal);
							double d = abs(vecTestDir.dotProduct(vecNormal));
							if (d>dP)
							{ 
								dP = d;
								vecDir = vecNormal;
								_Pt0 = ptMid;
							}
						}
					}
					else
					{
						reportMessage("\n" + T("|No connection found.|"));
						eraseInstance();
						return;
					}
				}
				
				_Map.setVector3d("vecDir", vecDir);

			}
		}
		if (_Sip.length()==0)
			eraseInstance();
		return;
	}	
// end on insert	__________________		
//End On insert//endregion 

//region Defaults
// default coordSys
	Vector3d vecX, vecY, vecZ;
	Point3d ptOrg;
	Sip sip;
	double dH;
	setEraseAndCopyWithBeams(_kBeam0);
	
	Sip sips[0];
// get panels if on IO
	if (_bOnMapIO)
	{ 
		for (int i=0;i<_Map.length();i++)
		{
			Entity ent = _Map.getEntity(i);
			if (ent.bIsValid() && ent.bIsKindOf(Sip()))
				sips.append((Sip)ent);
		}
		//reportMessage("\n" + sips.length() + " collected on mapIO");
	}
	else
		sips = _Sip;

// add dependencies to potential childs
	for (int i=0;i<_Entity.length();i++)
		setDependencyOnEntity(_Entity[i]);
//End Defaults//endregion 	
 	
//region Trigger AddRemove
	String sTriggers[] ={T("|Add Panel(s)|"),T("|Remove Panel(s)|")};
	for (int t=0;t<sTriggers.length();t++) 
	{ 
		addRecalcTrigger(_kContextRoot, sTriggers[t]);
		if (_bOnRecalc && _kExecuteKey==sTriggers[t])
		{
		// prompt for entities
			Entity ents[0];
			PrEntity ssE(T("|Select panels(s)|"), Sip());
			if (ssE.go())
				ents.append(ssE.set());
			
		// loop selection
			for (int i=0;i<ents.length();i++) 
			{ 
			// add/remove state	
				int n = _Sip.find(ents[i]);
			// remove	
				if (t==1 && n>-1)
					_Sip.removeAt(n);
			// add
				else if (t==0)
				{
					_PtG.setLength(0);
					_Sip.append((Sip)ents[i]);
				}
			}
			setExecutionLoops(2);
			return;
		}
	}
//endregion	
	
// HSB-9833: add trigger to make entity static
	int bIsStatic = _Map.getInt("bIsStatic");

//region Validation and profiles
// the first male specifies the base reference
	String componentName;
	if(sips.length()==0)
	{ 
		reportMessage("\n"+ scriptName() + " Unexpected no sip found");
		eraseInstance();
		return;
	}
	{ 
		sip = sips[0];
		assignToGroups(sip, 'T');
		vecX = sip.vecX();
		vecY = sip.vecY();
		vecZ = sip.vecZ();	
		ptOrg = sip.ptCenSolid();
		//if (_bOnDbCreated && nMode==0)_Pt0 = ptOrg;
		dH = sip.dH();
	
		componentName = SipStyle(sip.style()).sipComponentAt(0).name();

	}

// Get type map
	Map mapType;
	for (int i=0;i<mapTypes.length();i++) 
	{ 
		Map m = mapTypes.getMap(i);
		String type = m.getString("Type"); 
		if (sType == type)
		{ 
			mapType = m;
			break;
		}
	}//next i


//region Validate component name if list of valid names is specified in settings
	int bIsValidType;
	if (bIsTypeByComponentName && componentName.length()>0)
	{ 
		String k="ComponentName[]";		if (mapType.hasMap(k))	mapComps = mapType.getMap(k);
		String names[0];
		for (int i=0;i<mapComps.length();i++) 
		{ 
			String name;
			if (mapComps.hasString(i))
				name = mapComps.getString(i);
			if (name.length()>0 && names.findNoCase(name,-1)<0)
				names.append(name);	 
		}//next i

		if (names.findNoCase(componentName,-1)>-1)
		{ 
			bIsValidType=true;
			sType.setReadOnly(true);
		}
		
	// if component could not be found iterate through all types to set required type
		if (!bIsValidType)
		{ 
			for (int j=0;j<mapTypes.length();j++) 
			{ 
				Map m = mapTypes.getMap(j);
				String type = m.getString("Type"); 
		
				if (m.hasMap(k))
					mapComps = m.getMap(k);
				else
					{ continue;}
				
				String names[0];
				for (int i=0;i<mapComps.length();i++) 
				{ 
					String name;
					if (mapComps.hasString(i))
						name = mapComps.getString(i);
					if (name.length()>0 && names.findNoCase(name,-1)<0)
						names.append(name);	 
				}//next i
				
				if (names.findNoCase(componentName,-1)>-1)
				{ 
					bIsValidType=true;
					sType.set(type);
					sType.setReadOnly(true);
					mapType = m;
					break;
				}			
				
			}//next j			
		}

		if (!bIsValidType)// && (_bOnDbCreated || _kNameLastChangedProp==sTypeName))
		{
			reportNotice("\n"+scriptName() + T(" |is configured to work with component names.| ") + componentName +
				T(" |could not be found in any type configuration.|") + 
				"\n"+T("|Tool will be deleted.|"));
			reportMessage("\n"+T("|Tool will be deleted.|"));
			eraseInstance();
			return;	
		}
	}	


//endregion 


// ints
	int bEditInPlace=_Map.getInt("directEdit");

	int nSide = sSides.find(sSide, 0);
	int nType = sTypes.find(sType,0);
	plShape = nType<plShapes.length()?plShapes[nType]:PLine();
	plTool = nType<plTools.length()?plTools[nType]:PLine();
	int nToolIndex = 10;
	
	int bIsLegacy;
// Read type map values	
	{ 
		String k;
		Map m = mapType;
		k="Color";			if (m.hasInt(k))	nc = m.getInt(k);
		k="ColorText";		if (m.hasInt(k))	ncText = m.getInt(k);
		k="ToolIndex";		if (m.hasInt(k))	nToolIndex = m.getInt(k);
		k="isLegacy";		if (m.hasInt(k))	bIsLegacy = m.getInt(k);
	}
	
	if (bIsLegacy && (_bOnDbCreated || _kNameLastChangedProp == sTypeName))
	{ 
		reportMessage(TN("|You are using a deprecated model of the x-Fix, please review type unless this is as intended.|"));
		
	}
	
	
//	vecZ.vis(_Pt0);
	Vector3d vecFace = (nSide ? 1 :-1) * vecZ;
	Point3d ptFace = ptOrg + vecFace * .5 *dH;
	CoordSys csFace(ptFace, vecX, vecX.crossProduct(-vecFace), vecFace);
	Plane pnFace(ptFace, vecFace);
	Plane pnRef(ptOrg - vecZ * .5 * dH, vecZ);
	double dDepth = dTypeDepths[nType]+dPDepth;


//region Get potential tool formatting
	Map mapX;
	String sMapXKey;
	for (int i=0;i<mapTypes.length();i++) 
	{ 
		Map m = mapTypes.getMap(i);
		String type = m.getString("Type"); 
		if (sType == type)
		{ 
			mapType = m;
			break;
		}
	}//next i
	if (mapType.hasMap("ToolDescriptionFormat"))
	{ 
		String k;
		Map mapFormats, m;
					
		k="ToolDescriptionFormat";		if (mapType.hasMap(k))	m = mapType.getMap(k);
		k="Format[]";					if (m.hasMap(k))		mapFormats = m.getMap(k);
		k="MapName";					if (m.hasString(k))		sMapXKey = m.getString(k);

		for (int i=0;i<mapFormats.length();i++) 
		{ 
			m = mapFormats.getMap(i);
			//m = mapFormats.getMap(i);
			String key, format;
			k="KeyName";	if (m.hasString(k))	key = m.getString(k);
			k="Format";		if (m.hasString(k))	format = m.getString(k);
			if (key.length()>0 && format.length()>0)
				mapX.setString(key, format);
			 
		}//next i
	}
	
// write tool data to mapX
	// keys and formats being defined in the Format[] definition of the settings
	// the value of each format will be replaced by the resolved value of the key
	Map mapAdditional;
	mapAdditional.setString("Type", sType);
	mapAdditional.setInt("ToolIndex", nToolIndex);
	mapAdditional.setDouble("Depth", dDepth);
	mapAdditional.setInt("Color", nc);
	mapAdditional.setInt("ColorText", ncText);
	
	for (int i=0;i<mapX.length();i++) 
	{ 
		String format = mapX.getString(i);
		if (format.length()>0)
			mapX.setString(mapX.keyAt(i), _ThisInst.formatObject(format, mapAdditional));		 
	}//next i		
//endregion 

// collect profiles
	PlaneProfile pps[0], pps2[0], ppAll(csFace);
	for (int i=0;i<sips.length();i++) 
	{  
		PlaneProfile pp(csFace);
		pp.joinRing(sips[i].plShadow(),_kAdd);	
		pps.append(pp);
		ppAll.unionWith(pp);
		pp.shrink(-dOverlap / 3);// HSB-8043 -dOverlap / 2
		pps2.append(pp);
	}
	ppAll.shrink(-dEps);
	ppAll.shrink(dEps);
	
// collect one overall opening planeprofile to filter edegs of openings
	PlaneProfile ppOpening(csFace);
	for (int i=0;i<sips.length();i++) 
	{ 
		PLine plines[]=sips[i].plOpenings();
		for (int j=0;j<plines.length();j++) 
			ppOpening.joinRing(plines[j],_kAdd); 
	}//next i
	//ppOpening.vis(150);		
//End Validation and profiles//endregion 

//region Get connections MapIO
	if (_bOnMapIO || bIODebug)
	{ 
	// find directions
		String sHandles[0];
		Map mapOut;
		//reportMessage("\n" + sips.length() + " tested on mapIO");
		for (int i=0;i<sips.length()-1;i++) 
		{  
			Sip sip1 = sips[i];		
			String sHandle1 = sip1.handle();
			PlaneProfile ppA1 = pps[i];
			PlaneProfile ppA2 = pps2[i];
			SipEdge edges[] = sip1.sipEdges();
			//reportMessage("\ni " + i);

ppA1.vis(1);

		// remove edges of openings
			if (ppOpening.area()>pow(dEps,2))
				for (int e=edges.length()-1; e>=0 ; e--) 
					if (ppOpening.pointInProfile(edges[e].ptMid() + edges[e].vecNormal()* dEps)==_kPointInProfile)
						edges.removeAt(e); 
			
			for (int j=i+1;j<sips.length();j++) 
			{ 
				Sip sip2 = sips[j];	
				String sHandle2 = sip2.handle();
				PlaneProfile ppB = pps2[j];
ppB.vis(2);				
				PlaneProfile ppAB = ppA2;
				ppAB.intersectWith(ppB);
				if (bIODebug)
				{
					//ppA1.vis(2);
					ppAB.vis(3);
					reportMessage("\nj "+j+" "  + sip1.name() + "__"  + sip2.name() + " area " + ppAB.area());
	
				}
	
				int bFound;
				for (int x=0;x<sHandles.length();x++) 
				{ 
					int n1 = sHandles[x].find(sHandle1,0);
					int n2 = sHandles[x].find(sHandle2,0);
					
					if (n1>-1 && n2 > -1)
					{ 
						bFound = true;
						break;
					}	 
				}
				if (bFound)break;	
	
			// find male edges within ppAB
				Map mapEdges;
				for (int k=0;k<edges.length();k++) 
				{ 
					SipEdge& e=edges[k]; 
					Vector3d vecXE = e.ptEnd() - e.ptStart(); vecXE.normalize();
					
				// check length of intersection of edge with common range // HSB-8043
					{ 
						Point3d pts[] = ppAB.intersectPoints(Plane(e.ptMid(), vecXE.crossProduct(-vecZ)), true,false);
						if (pts.length()>1)
						{ 
							double d = abs(vecXE.dotProduct(pts.first() - pts.last()));
							if (d < dOuterWidth)continue;
						}
					}
	
				// mid point of common projected to edge
					Point3d ptMidCommon = ppA1.closestPointTo(ppAB.extentInDir(vecXE).ptMid());
					ptMidCommon+=vecZ*vecZ.dotProduct(ptFace-ptMidCommon);
					
					Point3d pt = e.ptMid();
					pt+=vecZ*vecZ.dotProduct(ptFace-pt);
					pt += vecXE * vecXE.dotProduct(ptMidCommon - pt);

ptMidCommon.vis(3);					
pt.vis(2);
					Vector3d vecN1 = e.vecNormal().crossProduct(vecZ).crossProduct(-vecZ);
					vecN1.normalize();

					Point3d ptNext = ppA1.closestPointTo(ppAB.closestPointTo(pt));
					Vector3d vecNext = ptNext - pt;
					double dNext = vecNext.length();
					vecNext.normalize();
					if (bIODebug)vecNext.vis(ptNext,k+1);
					if (bIODebug)vecN1.vis(ptNext,k+1);
					if (vecNext.dotProduct(vecN1) < 0 && dNext > dOverlap) continue; 
					
					if (ppAB.pointInProfile(ptNext) == _kPointInProfile)
					{ 
						//pt = ppAB.extentInDir(vecN1).ptMid();//version value="1.3" date="20feb2019" author="thorsten.huck@hsbcad.com"> bugfix basepoint
						
						//version value="1.5" date="20feb2019" author="thorsten.huck@hsbcad.com"> bugfix redesigned upon PP request
						Vector3d vecZE = -vecZ.crossProduct(e.vecNormal()).crossProduct(-e.vecNormal());
						vecZE.normalize();//vecZE.vis(pt,k);
						Line (e.ptMid(), vecZE).hasIntersection(pnRef, pt);
						pt += vecZ * vecZ.dotProduct(ptFace - pt);
						
						Map m;
						m.setVector3d("vecNormal", vecN1);
						m.setPoint3d("ptMid", pt);
						m.setPoint3d("pt1", e.ptStart());
						m.setPoint3d("pt2", e.ptEnd());
						m.setPlaneProfile("ppCommon", ppAB);
						mapEdges.appendMap("Edge", m);
						mapOut.appendMap("Edge", m);
						if (bIODebug)vecN1.vis(pt,k);
					}
				}
				
			// set couple collection
				if (mapEdges.length()>0)
				{ 
					sHandles.append(sHandle1 + "__" + sHandle2);
				}	
			}
		}
		
	// debug connections
		if (bIODebug)
			for (int i=0;i<mapOut.length();i++) 
			{ 
				Map m = mapOut.getMap(i);
				Vector3d vecN1 = m.getVector3d("vecNormal");
				Point3d ptMid = m.getPoint3d("ptMid");
				vecN1.vis(ptMid, i);
			}
		_Map=Map();
		_Map.setInt("bIsStatic", bIsStatic);
		_Map.appendMap("Edge[]",mapOut);
		//if (bIODebug)_Map.writeToDxxFile(_kPathDwg + "\\" + dwgName() + "Edges.dxx");
		return;
	}//endregion
	
//region Connection, Edges and common range
// get connection direction
	Vector3d vecDir = _Map.getVector3d("vecDir");
	vecDir.vis(_Pt0, 1);
	
// TriggerFlipOrientation
	String sTriggerFlipOrientation = T("|Flip Alignment|");
	int bFlipAlignment = _Map.getInt("FlipAlignment");
	addRecalcTrigger(_kContextRoot, sTriggerFlipOrientation );
	if (_bOnRecalc && (_kExecuteKey==sTriggerFlipOrientation || _kExecuteKey==sDoubleClick))
	{
		bFlipAlignment = bFlipAlignment==true?false:true;
		_Map.setInt("FlipAlignment", bFlipAlignment);	
		setExecutionLoops(2);
		return;
	}
	
// get potential edges
	Map mapEdges;
	{
		Map mapIO;
		for (int e=0;e<sips.length();e++)
			mapIO.appendEntity("Entity", sips[e]);
		TslInst().callMapIO(scriptName(), mapIO);
		mapEdges = mapIO.getMap("Edge[]");
	}
	
// get relevant edge
	Vector3d vecPerp;
	PlaneProfile ppCommon(csFace);
	Point3d ptRef=_Pt0;
	
	vecZ.vis(_Pt0);
	for (int i=0;i<mapEdges.length();i++) 
	{ 
		Map m = mapEdges.getMap(i);
		Vector3d vec = m.getVector3d("vecNormal");
		Point3d ptMid = m.getPoint3d("ptMid");
		double d = abs(vecDir.dotProduct(ptMid - ptRef));
		//vec.vis(m.getPoint3d("ptMid"),i);
		if (vec.isParallelTo(vecDir) && d<dOverlap)
		{ 
			ptRef= m.getPoint3d("ptMid");
			ppCommon.unionWith(m.getPlaneProfile("ppCommon"));	
			//ppCommon.vis(i);
			vecPerp = vecDir.crossProduct(vecZ);
//			Point3d pt1 = m.getPoint3d("pt1");
//			Point3d pt2 = m.getPoint3d("pt2");
//			if (ppCommon.pointInProfile(pt1)!=_kPointOutsideProfile)ptsEdge.append(pt1);
//			if (ppCommon.pointInProfile(pt2)!=_kPointOutsideProfile)ptsEdge.append(pt2);
		} 
	}
	//ptRef.vis(6);
	ppCommon.vis(252);
	if (vecPerp.bIsZeroLength() && !bIsStatic)
	{ 
		reportMessage("\n" + scriptName() + T(" |could not find a connection in the given direction.|"));
		if (!bDebug)eraseInstance();
		return;
	}
	else if(vecPerp.bIsZeroLength() && bIsStatic)
	{ 
		vecPerp = vecDir.crossProduct(vecZ);
	}
	
// collect all relevant edges	
	Point3d ptsEdge[0];
	for (int i = 0; i < sips.length(); i++)
	{
		SipEdge edges[] = sips[i].sipEdges();
		for (int j = 0; j < edges.length(); j++)
		{
			SipEdge& e = edges[j];
			Point3d pt = e.ptMid();
			
			Vector3d vecN1 = e.vecNormal().crossProduct(vecZ).crossProduct(-vecZ);
			double d = vecN1.dotProduct(vecDir);
			if (!vecN1.isParallelTo(vecDir)){continue;}		
			//if (abs(vecDir.dotProduct(pt - ptRef)) > dOverlap){continue;}

			PLine pl = e.plEdge(); pl.transformBy(vecZ * U(10)); pl.vis(i+1);
			vecN1.normalize();																		//vecN1.vis(pt);
			
			Point3d pt1 = e.ptStart();	//pt1.vis(3);//lnRef.closestPointTo(
			Point3d pt2 = e.ptEnd();	//pt2.vis(4);//lnRef.closestPointTo(
			
			if (ppCommon.pointInProfile(pt1) != _kPointOutsideProfile) 	{ptsEdge.append(pt1); }// }//else pt1.vis(12);
			if (ppCommon.pointInProfile(pt2) != _kPointOutsideProfile)	{ptsEdge.append(pt2);}// pt2.vis(3);else pt2.vis(12);
		}
	}
//End Connection, Edges and common range//endregion 

	if (sips.length()<2 && !bIsStatic)
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|requires at least two panels.|"));
		eraseInstance();
		return;
	}

// trigger to convert to static
	String sTriggerConvertToStatic = T("|Convert To Static|");
	// 
	// trigger only for bEditInPlace
//	if(!bIsStatic && bEditInPlace)
	if(!bIsStatic)
		addRecalcTrigger(_kContextRoot, sTriggerConvertToStatic );

// declare display
	Display dpPlan(ncText), dpModel(nc);
	dpPlan.showInDxa(true);
	dpPlan.addViewDirection(vecFace);
	dpPlan.addViewDirection(-vecFace);
	dpPlan.textHeight(dTxtH);
	dpPlan.showInDxa(true);// HSB-23003								
	
	dpModel.showInDxa(true);

// prepare tsl cloning
	TslInst tslNew;
	Vector3d vecXTsl= _XE;
	Vector3d vecYTsl= _YE;
	GenBeam gbsTsl[] = {};
	Entity entsTsl[] = {};
	Point3d ptsTsl[] = {};
	int nProps[]={};
	double dProps[] ={ dOffset1, dOffset2, dInterdistance, dPDepth};
	String sProps[]={sType,sSide};
	Map mapTsl;	
	mapTsl.setVector3d("vecDir", vecDir);
	String sScriptname = scriptName();


// TriggerEditInPlacePanel
	int bCreate;
	if (!bEditInPlace)
	{
		String sTriggerEditInPlace = T("|Edit in Place|");
		addRecalcTrigger(_kContextRoot, sTriggerEditInPlace );
		if (_bOnRecalc && (_kExecuteKey == sTriggerEditInPlace || _kExecuteKey == sTriggerConvertToStatic))
		{
			bCreate = true;
			mapTsl.setInt("directEdit",bEditInPlace);
			dProps[0] = 0;
			dProps[1] = 0;
			dProps[2] = 1;
			
			for (int i=0;i<_Sip.length();i++) 
				gbsTsl.append(_Sip[i]); 
		}
	}

// get extreme location in vecDir
	ptsEdge = Line(_Pt0,-vecDir).orderPoints(ptsEdge);
	Point3d ptToolRef = ptsEdge.length() > 0 ? ptsEdge.first() : ptRef; // HSB-7990
	//PLine(ptToolRef,_PtW,_Pt0).vis(2);
	
// the reference line
	Line lnRef(ptToolRef, vecPerp);	// HSB-7990
// get common segment
	ptsEdge = pnFace.projectPoints(ptsEdge);
	ptsEdge = lnRef.orderPoints(ptsEdge);
//	for (int i=0;i<ptsEdge.length();i++) ptsEdge[i].vis(1); 
	if (ptsEdge.length()<2 && !bIsStatic)
	{ 
		reportMessage("\nunexpected error 2");
		return;		
	}
	Point3d ptA, ptB;
	if(ptsEdge.length()>0)
		ptA = ptsEdge[0]+vecDir;
	else
		ptA = ptToolRef;
		
	ptA+=vecDir*vecDir.dotProduct(ptToolRef-ptA);						//ptA.vis(1);
	if(ptsEdge.length()>0)
		ptB= ptsEdge[ptsEdge.length() - 1];
	else 
		ptB = ptToolRef;
	ptB+=vecDir*vecDir.dotProduct(ptToolRef-ptA);						//ptB.vis(2);
	ptA.vis(1);
	ptB.vis(2);
	Point3d ptMid = (ptA+ptB) *.5;
	ptMid+=vecDir*vecDir.dotProduct(ptToolRef-ptMid);// HSB-7990

	if (bEditInPlace)
	{ 
		dInterdistance.set(1);
		dInterdistance.setReadOnly(true);
		dOffset1.set(abs(vecPerp.dotProduct(ptA - _Pt0)));
		dOffset2.set(abs(vecPerp.dotProduct(ptB - _Pt0)));
		dOffset1.setReadOnly(true);
		dOffset2.setReadOnly(true);
	}


// get common range
	double dX = vecPerp.dotProduct(ptB-ptA);//-2*dMinOffset;
	LineSeg segCommon(ptMid - vecPerp * (.5 * dX), ptMid + vecPerp * (.5 * dX));

//region segment control for any distribution mode
	if (!bEditInPlace)
	{ 
	// get potential segment index of multi segment locations
		LineSeg segCommons[] = ppAll.splitSegments(segCommon, true);
		int bHasSegIndex = _Map.hasInt("segIndex");
		int nSegIndex =bHasSegIndex?_Map.getInt("segIndex"):-1;
		//nSegIndex = 0;
		//ppAll.vis(3);
		
	// test for multiple distribution segments
		if (segCommons.length()==1)
		{ 
			LineSeg& seg =segCommons[0];
			seg = LineSeg(seg.ptStart() + vecPerp * dMinOffset, seg.ptEnd() - vecPerp * dMinOffset);
			segCommon = seg;
			_Map.removeAt("segIndex", true);
			_Map.removeAt("segLength", true);
			
		}
	// assign the stored index if found	
		else if (nSegIndex>-1 && nSegIndex<segCommons.length())
		{ 
			LineSeg& seg =segCommons[nSegIndex];
			seg = LineSeg(seg.ptStart() + vecPerp * dMinOffset, seg.ptEnd() - vecPerp * dMinOffset);
			//seg.transformBy(vecZ * U(2));
			seg.vis(4);
			segCommon = seg;
			ptMid = segCommon.ptMid();
			
		// reset grips due to changed segment length
			if (abs(_Map.getDouble("segLength")-seg.length())>dEps)
			{ 
				_PtG.setLength(0);
				_Map.setDouble("segLength", seg.length());
			}
		}
		
	// trigger to remove childs if the amount of segments is different to the total number of tsls operating
	// Trigger RecalcSegments
		if (nSegIndex==0 && _Entity.length()+1!=segCommons.length())
		{ 
			String sTriggerRecalcSegments = T("|Recalc Segments|");
			addRecalcTrigger(_kContextRoot, sTriggerRecalcSegments );
			if (_bOnRecalc && _kExecuteKey==sTriggerRecalcSegments)
			{
				_Map.removeAt("segIndex",true);
				bHasSegIndex = false;
				for (int i=_Entity.length()-1; i>=0 ; i--) 
				{ 
					_Entity[i].dbErase(); 
				}
			}				
		}
		
	// create new instances for every additional segment
		if (!bHasSegIndex && segCommons.length()>1)
		{ 	
			for (int i=0;i<segCommons.length();i++) 
			{ 
				LineSeg& seg =segCommons[i];
				seg = LineSeg(seg.ptStart() + vecPerp * dMinOffset, seg.ptEnd() - vecPerp * dMinOffset);
				//seg.transformBy(vecZ * U(2));
				seg.vis(i); 	 
				
				if (i==0)
				{ 
					segCommon = seg;
					_Map.setInt("segIndex", i);
					_Map.setDouble("segLength", seg.length());
					continue;
				}
				
				gbsTsl.setLength(0);
				for (int i=0;i<sips.length();i++) 
					gbsTsl.append(sips[i]); 
				
				mapTsl.setInt("segIndex", i);
				mapTsl.setDouble("segLength", seg.length());
				// trigger the static calculation when each instance is created
				mapTsl.setInt("iApplyStatic", true);
				//
				ptsTsl.setLength(0);
				ptsTsl.append(seg.ptMid());
				ptsTsl.append(seg.ptStart());
				ptsTsl.append(seg.ptEnd());
				//
				tslNew.dbCreate(sScriptname , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
					nProps, dProps, sProps,_kModelSpace, mapTsl);
				// recalc to make sure the convertion to static will happen					
//				tslNew.recalcNow();
//				tslNew.recalc();
			// append the additional segment tsl to the list of entities
				if (tslNew.bIsValid())
					_Entity.append(tslNew);
			}
		}
	}//endregion
	//segCommon.vis(1);
	
	// HSB-9833: add trigger to make entity static
// Trigger ConvertToStatic//region
	if ((_bOnRecalc && (_kExecuteKey==sTriggerConvertToStatic && bEditInPlace)) || (_Map.getInt("iApplyStatic") && sips.length()==2))
	{
		if(sips.length()<2)
		{ 
			reportMessage(TN("|unexpected, static state not possible|"));
			setExecutionLoops(2);
			return;
		}
		if(!bEditInPlace)
		{ 
//			reportMessage("\n"+ scriptName() + " do nothing");
			setExecutionLoops(3);
			return;
		}
		_Map.setInt("bIsStatic", true);
		// set again to false after converting to static
		_Map.setInt("iApplyStatic", false);
		_ThisInst.recalc();
		_Sip.setLength(0);
		_Sip.append(sips[0]);
		// prepare tsl clonning
		TslInst tslNewThis;
		Vector3d vecXTslThis= _XE;
		Vector3d vecYTslThis= _YE;
		GenBeam gbsTslThis[] = {};
		Entity entsTslThis[] = {};
		Point3d ptsTslThis[] = {};
		int nPropsThis[]={};
		double dPropsThis[] ={ dOffset1, dOffset2, dInterdistance, dPDepth};
		String sPropsThis[]={sType,sSide};
		Map mapTslThis;	
		mapTslThis.setVector3d("vecDir", vecDir);
		String sScriptname = scriptName();
		mapTslThis.setInt("directEdit",bEditInPlace);
		mapTslThis.setInt("bIsStatic", true);
		mapTslThis.setInt("iApplyStatic", false);
		gbsTslThis.append(sips[1]);
		ptsTslThis.append(_Pt0);
		// 
		tslNew.dbCreate(sScriptname , vecXTslThis ,vecYTslThis,gbsTslThis, entsTslThis, ptsTslThis, 
					nPropsThis, dPropsThis, sPropsThis,_kModelSpace, mapTslThis);
		setExecutionLoops(2);
		return;
	}//endregion	
	//dX = segCommon.length();

// get qty and distribution interdistance
	int nQty=1;
	double dInter;
	double dL = dX-dOffset1-dOffset2;
	if (abs(dInterdistance)<dMinInterdistance)
	{ 
		nQty = abs((int)dInterdistance);
		if (nQty>1)
		{ 
			nQty = nQty-1;
		}

		if (nQty>1)	
			dInter = dL / (nQty);

	}
	else
	{ 
		if (dL>dMinInterdistance)
		{ 
			nQty =dL / abs(dInterdistance)+.9999;			
		// switch to qty mode: the interdistance can take integers
			if (nQty<2)
			{ 
				dInterdistance.set(2);
				setExecutionLoops(2);
				return;
			}
			
			dInter = dL / (nQty);
		}
	}

//region Set and align grips
// set and align grips
	Point3d ptTool;
	if (nQty>1)
	{ 
		
		Point3d ptStart = ptMid - vecPerp *.5* dX;//segCommon.ptMid()
		Point3d ptEnd = ptMid + vecPerp * .5*dX;
		ptTool = ptStart;
		ptStart.vis(1);
		ptEnd.vis(2);
//		if (bDebug)
//		{
//			dpPlan.draw(PLine(_Pt0, _Pt0 + _XW * U(200)));
//			return;
//		}
	// hide _Pt0
		_ThisInst.setAllowGripAtPt0(false);
		
	// add grips	
		if (_PtG.length()<2)
		{ 
			_PtG.append(ptStart+vecPerp*dOffset1);
			_PtG.append(ptEnd-vecPerp*dOffset2);
		}
		
	// snap to common seg
		for (int p=0;p<_PtG.length();p++) 
			_PtG[p]= segCommon.closestPointTo(_PtG[p]); 

	// adjust offsets if grips have changed
		if (_kNameLastChangedProp.find("_PtG",0)>-1)
		{ 
			int n = _kNameLastChangedProp.find("_PtG1",0)>-1?1:0;
			if (n==0)
				dOffset1.set(vecPerp.dotProduct(_PtG[0] - ptStart));
			else	
				dOffset2.set(vecPerp.dotProduct(ptEnd-_PtG[1]));
			setExecutionLoops(2);
		}
		
	// adjust grip locations by offset value
		if (_PtG.length()>0 && _kNameLastChangedProp==sOffset1Name)
			_PtG[0].transformBy(vecPerp*(vecPerp.dotProduct(ptStart-_PtG[0])+dOffset1));
		if (_PtG.length()>1 && _kNameLastChangedProp==sOffset2Name)
			_PtG[1].transformBy(vecPerp*(vecPerp.dotProduct(ptEnd-_PtG[1])-dOffset2));
			
		ptTool +=vecPerp * dOffset1;
		_Pt0 = ptTool;
	}
	else
	{
		if (_bOnDbCreated)
		{
			_Pt0 += + vecPerp * dOffset1;
		}

		ptTool = segCommon.closestPointTo(_Pt0);
		
	// snap to closest parallel edge if outside of common range
		if (ppCommon.pointInProfile(ptTool)==_kPointOutsideProfile)
		{ 
			SipEdge edge;
			double dMin = U(10e6);
			Point3d ptNewTool = ptTool;
		// collect all relevant edges	
			for (int i = 0; i < sips.length(); i++)
			{
				SipEdge edges[] = sips[i].sipEdges();
				for (int j = 0; j < edges.length(); j++)
				{
					SipEdge& e = edges[j];
					Point3d pts[] = e.plEdge().intersectPoints(Plane(ptTool, vecPerp));
					if (pts.length() < 1)continue;

					Point3d pt = pts[0]+vecZ*vecZ.dotProduct(ptFace-pts[0]);
					Vector3d vecN1 = e.vecNormal().crossProduct(vecZ).crossProduct(-vecZ);
					
					if (!vecN1.isParallelTo(-vecDir))continue;
					vecN1.vis(pt);
					
					double d = abs(vecDir.dotProduct(pt - ptTool));
					if (d<dMin)
					{ 
						PLine(_Pt0, pt).vis(j);
						dMin = d;
						ptNewTool = pt;
					}
				}
			}
			ptTool = ptNewTool;
			ptTool.vis(3);
		}
		
		_Pt0=ptTool;
		_PtG.setLength(0);
		_ThisInst.setAllowGripAtPt0(true);
	}
		
//End TitleComment//endregion 


//region Swap alignment to offseted edge of female panel
	if (bFlipAlignment && _Sip.length()>1)
	{ 
		PLine pl = _Sip.last().plEnvelope();
		Point3d pts[] = Line(ptTool, vecDir).orderPoints(pl.intersectPoints(Plane(ptTool, vecPerp)), dEps);
		if (pts.length()>0)
		{ 
			ptTool.transformBy(vecDir * vecDir.dotProduct(pts.first() - ptTool));
			ptTool.vis(6);
		}	
	}
//End Swap alignment to offseted edge of female panel//endregion 


// purge irrelevant sips if in single mode
	if (bEditInPlace && (_bOnDbCreated || _kNameLastChangedProp=="_Pt0"))
	{ 
		Body bd(ptTool, vecDir, vecPerp, vecFace, 2*(dDepth+dEps),2*(dOuterWidth+dEps), dDoveDepth,0,0,-1);
		//bd.vis(2);
		Sip sipsNew[]= bd.filterGenBeamsIntersect(sips);	
		if (sipsNew.length()>1)
			_Sip = sipsNew;
		setExecutionLoops(2);
		return;
	}
	
// ADMIN Specify tool contour, only available if tool color is red (1)
	if (bEditInPlace && _ThisInst.color()==1)
	{ 
	// Trigger SetToolContour//region
		String sTriggerSetToolContour = T("|Set Tool Contour|");
		addRecalcTrigger(_kContextRoot, sTriggerSetToolContour );
		if (_bOnRecalc && _kExecuteKey==sTriggerSetToolContour)
		{
			EntPLine epl = getEntPLine(T("|Select symmetrical contour polyline.|") + T(" |The midpoint of is used as reference location.|"));
			PLine plContour = epl.getPLine();
			if (!plContour.coordSys().vecZ().isParallelTo(_ZW))
			{ 
				reportMessage("\n" + scriptName() + ": " +T("|The defining polyline must be aligned within the XY-World plane|"));
				setExecutionLoops(2);
				return;
			}
		// transform to world
			Point3d ptMid; ptMid.setToAverage(plContour.vertexPoints(true));
			plContour.transformBy(_PtW - ptMid);
			
			epl = getEntPLine(T("|Select tooling contour polyline.|") + T(" |The alignment must be parallel with World-X.|"));
			PLine plTool= epl.getPLine();
			if (!plTool.coordSys().vecZ().isParallelTo(_ZW))
			{ 
				reportMessage("\n" + scriptName() + ": " +T("|The defining polyline must be aligned within the XY-World plane|"));
				setExecutionLoops(2);
				return;
			}			
			plTool.transformBy(_PtW - ptMid);
			
		// find entry in mapTypes	
			int nEntry = -1;
			Map mapTypes;
			for (int i=0;i<sTypes.length();i++)
			{ 
				PLine pline = plShapes[i];
				Map m;
				m.setString("Type", sTypes[i]);
				m.setDouble("Depth", dTypeDepths[i]);
				m.setPLine("Shape", sType==sTypes[i]?plContour:plShapes[i]);
				m.setPLine("Tool", sType==sTypes[i]?plTool:plTools[i]);
				mapTypes.appendMap("Type", m);
			}
			mapSetting.setMap("Type[]", mapTypes);

			if (mo.bIsValid())
			{
				mo.setMap(mapSetting);
			}
			// create a mapObject to make the settings persistent	
			else
			{
				mo.dbCreate(mapSetting);
			}	

			setExecutionLoops(2);
			return;
		}//endregion	
		
	}


// simplified tool contour for solid subtract	
	PLine plSolid (vecZ);
	int bExtrusion;
	if (plShape.length()>dEps && plTool.length()>dEps)
	{ 
		plSolid = plShape;
		Point3d pt;
		pt.setToAverage(plSolid.vertexPoints(true));
		CoordSys cs2ms;
		cs2ms.setToAlignCoordSys(_PtW, _XW,_YW,_ZW, ptTool, vecDir, vecPerp, vecDir.crossProduct(vecPerp));
		plSolid.transformBy(cs2ms);
		plTool.transformBy(cs2ms);
		plTool.vis(50);
		
		Point3d pts[] = Line(ptTool, vecDir).orderPoints(plTool.vertexPoints(true));
		if (pts.length()>0)
		{
			//pts.last().vis(4);
			dDoveDepth = vecDir.dotProduct(pts.last() - ptTool);
		}

		bExtrusion = true;
	}
	else
	{
		plSolid.addVertex(ptTool - vecPerp * dInnerWidth - vecDir * U(3));
		plSolid.addVertex(ptTool  - vecPerp * dInnerWidth + vecDir * U(4.66));
		plSolid.addVertex(ptTool  - vecPerp * U(54.51) + vecDir * dDoveDepth);
		plSolid.addVertex(ptTool  + vecPerp * U(54.51) + vecDir * dDoveDepth);
		plSolid.addVertex(ptTool  + vecPerp * dInnerWidth + vecDir * U(4.66));
		plSolid.addVertex(ptTool  + vecPerp * dInnerWidth - vecDir * U(3));
		plSolid.addVertex(ptTool  + vecPerp * dInnerWidth - vecDir * U(4.66));
		plSolid.addVertex(ptTool  + vecPerp * U(54.51) - vecDir * dDoveDepth);
		plSolid.addVertex(ptTool  - vecPerp * U(54.51) - vecDir * dDoveDepth);
		plSolid.addVertex(ptTool  - vecPerp * dInnerWidth - vecDir * U(4.66));
		plSolid.close();		
	}
	//plSolid.vis(2);	

// Trigger ShowTooling
	int bShowTooling = _Map.getInt("ShowTooling");
	String sTriggerShowTooling =bShowTooling?T("|Hide Tooling|"):T("|Show Tooling|");
	if (bExtrusion)
	{ 
		addRecalcTrigger(_kContextRoot, sTriggerShowTooling);
		if (_bOnRecalc && _kExecuteKey==sTriggerShowTooling)
		{
			bShowTooling = bShowTooling ? false : true;
			_Map.setInt("ShowTooling", bShowTooling);		
			setExecutionLoops(2);
			return;
		}		
	}
	else
		bShowTooling = false;
	

// declare mapRequests
	Map mapRequests;
	String sDepth;sDepth.formatUnit(dDepth, 2, 0);

// distribute
	for (int i=0;i<=nQty;i++) 
	{ 	
		vecDir.vis(ptTool, 1);
		vecPerp.vis(ptTool, 3);
		vecFace.vis(ptTool, 150);

	// create editInPLace instances
		if (bCreate)
		{ 
			mapTsl.setInt("directEdit", true);
			if(_kExecuteKey == sTriggerConvertToStatic)
				mapTsl.setInt("iApplyStatic", true);
			ptsTsl.setLength(0);
			ptsTsl.append(ptTool);
			tslNew.dbCreate(sScriptname , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
				nProps, dProps, sProps,_kModelSpace, mapTsl);
			ptTool.transformBy(vecPerp * dInter);
			if(_kExecuteKey == sTriggerConvertToStatic)
				tslNew.recalc();
			continue;
		}

	// SolidSubtract
		Body bd;
		if (bShowTooling)
			bd = Body(plSolid, vecFace * dDepth, - 1);
		else
		{ 
			bd = Body(plSolid, vecFace * (dDepth+dEps), - 1);
			bd.transformBy(vecFace * dEps);
		}
//		SolidSubtract sosu(bd, _kSubtract);	

//		int nDir=1; 
//		for (int j=0;j<2;j++) 
//		{ 
//			Dove dv (ptTool, vecPerp, vecFace, nDir*vecDir, U(33.2), dDepth, U(65.6), U(0), _kFemaleSide);
//			BeamCut bc (ptTool, nDir*vecPerp, vecFace, vecDir, U(33.2), dDepth, U(65.6));
//			//bc.cuttingBody().vis(3);
//			dv.setDoSolid(false);	
//			
//			for (int k=0; k<_Sip.length(); k++)
//			{
//			// filter panels of this side
//				Point3d pt = _Sip[k].ptCenSolid();
//				//if (vecZTool.dotProduct(pt-ptToolRef)<0)continue;
//				
//				//if (j==0)_Sip[k].addTool(bc);
//				_Sip[k].addTool(dv);
//				//_Sip[k].addTool(sosu);
//			}
//			nDir *= -1;
//		}

	// add tools
		for (int k=0; k<sips.length(); k++)
		{
			PLine tool = plTool;
			int nDir = 1;
			if (vecDir.dotProduct(sips[k].ptCenSolid()-ptTool) < 0)
			{
				CoordSys csMirr;
				csMirr.setToMirroring(Line(ptTool, vecPerp));
				tool.transformBy(csMirr);
				
				nDir *= -1;
			}
			

			
			
		// old dove export
			if (!bExtrusion)
			{ 
			// HSB-17410 coordSys and location fixed	
				Vector3d vecYD = vecFace;
				Vector3d vecZD = nDir*vecDir;
				Vector3d vecXD = vecYD.crossProduct(vecZD);
				Point3d ptOrgD = ptTool;				
				if (pps.length()>k)
				{ 
					Point3d ptOnEdge = pps[k].closestPointTo(ptOrgD);
					double d = vecZD.dotProduct(ptOnEdge - ptOrgD);
					if (d>dEps)
						ptOrgD += vecZD * d;					
				}
				CoordSys csd (ptOrgD, vecXD, vecYD, vecZD);				//csd.vis(k);

				Dove dv (ptOrgD, vecXD, vecYD, vecZD, U(33.2), dDepth, U(65.6), U(0), _kFemaleSide);
				//Dove dv (ptTool, nDir*vecPerp, vecFace, nDir*vecDir, U(33.2), dDepth, U(65.6), U(0), _kFemaleSide); // HSB-17410 
				dv.setDoSolid(false);			
				sips[k].addTool(dv);				
			}
			else
			{ 
				tool.projectPointsToPlane(Plane(ptFace, vecFace), vecZ);
				if (!tool.coordSys().vecZ().isCodirectionalTo(vecFace))
					tool.flipNormal();
					
				tool.convertToLineApprox(U(15));
				tool.vis(k);
				FreeProfile fp(tool, tool.vertexPoints(true));
				fp.setMachinePathOnly(false);
				fp.setDepth(dDepth);
				fp.setCncMode(nToolIndex);
				fp.setDoSolid(bShowTooling);
				
			//HSB-11426	
				Body bdTool(tool, vecFace*dDepth,-1);	
				Map m;
				m.setBody("ToolSolid", bdTool);//bdTool.vis(6);
				m.setInt("Tolerance", 75);
				fp.setSubMapX("Faro", m);
				
			// HSB-14226
				if (sMapXKey.length()>0 && mapX.length()>0)
					fp.setSubMapX(sMapXKey, mapX);
				
				
				
				//fp.cuttingBody().vis(k);
				sips[k].addTool(fp);
			}

			Point3d pt = ptTool + nDir * vecDir * U(35);				//pt.vis(2);



		// validate request HSB-14400
			PlaneProfile pp = pps[k];
			pp.intersectWith(PlaneProfile(tool));
			if (pp.area()<tool.area()*.5)
			{ 
//				PLine pl = tool;
//				pl.transformBy(vecZ*U(300));
//				pl.vis(k);
				continue;				
			}


		// draw depth if not standard mapRequest
			if (abs(dPDepth)>dEps)
			{ 
				Map mapRequest;
				mapRequest.setPoint3d("ptLocation",pt );
				mapRequest.setVector3d("vecX", vecDir.crossProduct(-vecZ) );
				mapRequest.setVector3d("vecY", vecDir );
				mapRequest.setInt("AlsoReverseDirection", true);
				mapRequest.setString("ParentUID", sips[k].handle());
				mapRequest.setInt("Color", 242);
				mapRequest.setVector3d("AllowedView", vecFace);				
				mapRequest.setString("text", sDepth);	
				mapRequest.setDouble("textHeight", U(50));	
				
				mapRequests.appendMap("DimRequest",mapRequest);					
			}
			
		// publish dimRequestPoint	
			{ 
//				_Sip[k].plEnvelope().vis(k + 2);
				(vecDir).vis(pt, 2);
				Map mapRequest;
				mapRequest.setString("DimRequestPoint", "DimRequestPoint");
				if (i==0)mapRequest.setString("Description", sType);
				
				mapRequest.setString("Stereotype", stereotype);
				mapRequest.setPoint3d("ptRef",pt );
				mapRequest.setVector3d("vecDimLineDir", vecDir.crossProduct(vecZ) );
				mapRequest.setVector3d("vecPerpDimLineDir", -nDir*vecDir);	
				mapRequest.setString("ParentUID", sips[k].handle());
				//mapRequest.setInt("Color", 242);
				mapRequest.setVector3d("AllowedView", vecFace);				
				mapRequest.setInt("AlsoReverseDirection", true);
				
				mapRequests.appendMap("DimRequest",mapRequest);					
			}
			

		}

		
	// split requests into separate pline 	
		PlaneProfile ppt(csFace);
		ppt.joinRing(plSolid, _kAdd);
		
		for (int s=0;s<sips.length();s++) 
		{ 
			PlaneProfile ppx = pps[s];
			ppx.intersectWith(ppt);
			PlaneProfile ppm = ppt;
			ppm.shrink(dEps);
			ppx.subtractProfile(ppm);//ppx.vis(s);
			
			PLine pls[] = ppx.allRings(true, false);
			if (pls.length()>0)
			{ 				
			// mapRequest	
				Map mapRequest;
				mapRequest.setString("ParentUID", sips[s].handle());
				mapRequest.setInt("Color", 242);
				mapRequest.setVector3d("AllowedView", vecFace);				
				mapRequest.setPLine("pline", pls[0]);	
				mapRequest.setDouble("dZ", dDepth);
				mapRequests.appendMap("DimRequest",mapRequest);					
			} 
		}//next s

	// plan display	
		PlaneProfile pp1(csFace), pp2(csFace);
		pp1.joinRing(plSolid, _kAdd);
		pp2 = pp1;
		pp1.shrink(U(3));
//		if (bIsValidType || !bIsTypeByComponentName)
			pp2.subtractProfile(pp1);
//		else
//		{ 
//			dpPlan.color(1);
//			dpModel.color(1);		
//		}
		dpPlan.draw(pp2, _kDrawFilled, 50);
		dpModel.draw(bd);

		ptTool.transformBy(vecPerp * dInter);
		plSolid.transformBy(vecPerp * dInter);
		plTool.transformBy(vecPerp * dInter);
		
	// break distribution if in edit place	
		if (bEditInPlace)break;
	}
	
// draw description
	Point3d ptTxt = bEditInPlace ? _Pt0 : segCommon.ptMid();
	ptTxt.vis(9);
	ptTxt-=vecDir*U(100);//(1.3*dDepth);
	ptTxt.vis(42);
	dpPlan.draw(sType, ptTxt, vecPerp, vecDir, 0,-1,_kDevice);

// Hardware//region
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
	// element
		// try to catch the element from the parent entity
		Element elHW =sip.element(); 
		// check if the parent entity is an element
		if (!elHW.bIsValid())
			elHW = (Element)sip;
		if (elHW.bIsValid()) 
			sHWGroupName=elHW.elementGroup().name();
	// loose
		else
		{
			Group groups[] = _ThisInst.groups();
			if (groups.length()>0)
				sHWGroupName=groups[0].name();
		}		
	}
	
// add main componnent
	{ 
		int _nQty = bEditInPlace?1:nQty+1;
		HardWrComp hwc(sType, _nQty); // the articleNumber and the quantity is mandatory
		
		hwc.setManufacturer("Greenethic");
		hwc.setModel(sType);
		hwc.setName(sType);
		//hwc.setDescription(sHWDescription);
		//hwc.setMaterial(sHWMaterial);
		//hwc.setNotes(sHWNotes);
		
		hwc.setGroup(sHWGroupName);
		hwc.setLinkedEntity(sip);	
		hwc.setCategory(T("|Connector|"));
		hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
		
		hwc.setDScaleX(dDoveDepth);
		hwc.setDScaleY(U(33.2));
		hwc.setDScaleZ(dTypeDepths[nType]); // HSB-20808

	// apppend component to the list of components
		hwcs.append(hwc);
	}



// make sure the hardware is updated
	if (_bOnDbCreated)
		setExecutionLoops(2);
				
	_ThisInst.setHardWrComps(hwcs);	
	//endregion


// publish dim requests	
	_Map.setMap("DimRequest[]", mapRequests);

// erase edit in place parent
	if (bCreate)
	{
		eraseInstance();
		return;
	}


// Dialogs	
{ 
	// create TSL
	TslInst tslDialog;			Map mapTsl;
	GenBeam gbsTsl[] = { };		Entity entsTsl[] = { };			Point3d ptsTsl[] = { _Pt0};
	int nProps[] ={ };			double dProps[] ={ };			String sProps[] ={ };

//region Trigger Import/Export Settings
	if (findFile(sFullPath).length()>0)
	{ 
		String sTriggerImportSettings = T("|Import Settings|");
		addRecalcTrigger(_kContext, sTriggerImportSettings );
		if (_bOnRecalc && _kExecuteKey==sTriggerImportSettings)
		{
			mapSetting.readFromXmlFile(sFullPath);	
			if (mapSetting.length()>0)
			{ 
				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);	
				reportMessage(TN("|Settings successfully imported from| ") + sFullPath);	
			}
			setExecutionLoops(2);
			return;
		}			
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
			else bWrite = true;
				
			if (bWrite && mapSetting.length() > 0)
			{ 
				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);
				
			// make sure the path exists	//HSB-10750
				int bPathFound= sFolders.find(sFolder)>-1?true:makeFolder(sPath+"\\"+sFolder);	
				
			// write file	
				mapSetting.writeToXmlFile(sFullPath);
				
			// report rsult of writing	
				if (findFile(sFullPath).length()>0)		reportMessage(TN("|Settings successfully exported to| ") + sFullPath);
				else									reportMessage(TN("|Failed to write to| ") + sFullPath);		
			}
			
			setExecutionLoops(2);
			return;
		}
	}
	//endregion 

}

//endregion	






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
MU=;7V-G:XN/DY>;GZ.GJ\O/T]?;W^/GZ_]H`#`,!``(1`Q$`/P#WZBBB@`HK
MEM9UU[2ZBTK284NM6N4+1QNV$@C[R2?[.?3[WZU4EBN5OH[&\\=3V^JW"LT=
MI!':Q[OO?ZN.2-Y-OR_WFZ4`=I17(6VMW=CK":/KXC6:Y#"UO+=66&XVG[NU
MBVV3'\.YMW_CJ]?0`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!
M1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%
M%%`!1110`4444`%%%%`'&^&T\[QEXMNI%_?K<PVZY/2-859?_'F:N4U;1K#2
MOC=X3DLH%CDO%O)KF3JTC>6WWFKJ-6M+K0]>;Q)I]L]VMTBQ:A9PC]Y(J_=D
MC_O,OS?+_$I_V:Y'4]&\%:IK3:Q>_$'5;&_C>1HX9-56WDM-WWE6.1?,C_W:
M%NF#5TT==\0]J>&H;E6Q<6^H6LD'][S/.5?E_P"^FKM.]<(+>[\3ZI9RM;WE
MMHMC*LJ_:HVCEO9E^XVUOF6-?O?-]YOX?[W=]ZG_`##J+1115`%%%%`!1110
M`4444`%%%%`!1110`4444`%%%5IKZWMY-DL@5MN[;0!9HJC_`&G9_P#/Q_XZ
MU']IV?\`S\?^.M0!>HJC_:=G_P`_'_CK4?VG9_\`/Q_XZU`%ZBJ/]IV?_/Q_
MXZU9L_BS1+69H9KXK(OWE\EO_B:!-V.@HKCY/B%X:CU"&R-\WF2*S*RP2;5_
M\=J__P`)KX?_`.?_`/\`(,G_`,33LQ<R.AHKG_\`A-O#_P#T$/\`R#)_\35B
MS\1Z5J"O]GNP_E_>PC#%*S*N;%%4?[3L_P#GX_\`'6H_M.S_`.?C_P`=:@"]
M15$:K9'I<?\`CK4?VG9_\_'_`(ZU`%ZBJ/\`:=G_`,_'_CK4?VG9_P#/Q_XZ
MU`%ZBJ/]IV?_`#\?^.M1_:=G_P`_'_CK4`7J*H_VG9_\_'_CK4?VG9_\_'_C
MK4`7J*H_VG9_\_'_`(ZU']IV?_/Q_P".M0!>HJC_`&G9_P#/Q_XZU']IV?\`
MS\?^.M0!>HJK#?6MQ)Y<<VYO[M6J`"BBB@`HHHH`Y)_&=I'XV?PQ]EG,RV_G
M><O*_P"[6]_:5O\`W;C_`,!I/_B:\P_YN'N/^P=_[*M>G5TXNE"ER<O6*;]6
M2FW<?_:EM_T\?^`TG_Q-,_M.(+Q'<-_VQ9?_`$*FR2)#&\DA`1%+,?0`$D_I
M61X=\3Z?XEMYYK02IY,@1HY5PP!`(;Z$&N9:K0;=MS8_M!BOR6ER/]IMO_Q5
M-%Y>$<6L:_[TW_V-/Y`P>O>BE<8WSKYO^6ELO_`6:F@7+C!O&'^ZJK4E'.>O
M'I2NP(3#(_6ZN#])-M'V:/&6DN,?W?M$C5-10!7^RQC[C3+_`+LS+3EAD7_5
MW5PO_`MW_H5344[@0R3W=O&TGGQR*O\`"T>VM:L:_P#^/.3Z5LTP"BBB@`HK
MG+CQ9I45U)`EQ<7<D+[9EL+6:Z\IO[K>2K;6_P!EJL6/B#3M8$J6%ZK7$7^M
MMW5HYHO]Z-AN7_@2T`]#;K+^]J5TW]W;'_X[_P#95J5DQ-^^NF_Z;-_Z"M`$
MU%%%2`5'+-#:V[33R+##&NYI)&VJM25A^,_^1)UK_KRD_P#06H`N6FO:/J%P
MMO9:M874W_/.&X61JT*\9NX9X=)TFZN?!\.C6MO-;R2:M:R1R2*J[?FVK\U>
MS+]U67[M7*"CL1";EN8MVJ_\)AI+;?F6UNMO_?4-;59-W_R-VE_]>MU_Z%#6
MM4]BNH4444AA1110!5LO^/=O^NTG_H35:JK9?\>[?]=I/_0FJU0`4444`%%%
M%`!1110`4444`%%%%`$<`WZ@[=H8]O\`WU\W_LJUJ5FV./L\DW&9)F;_`+Y^
M7_T%:TJH`HHHH`****`/(#_R<3<?]>'_`+*M>GUY@?\`DXFX_P"O#_V5:]/K
MNQ^U/_"C.'7U.1^(>IO:Z#'IUNEQ+<ZA,(A%:IOE,?\`&0OTKGM,UN&T\<V#
MP:1JFEZ?>VXL)?MMOY2%ESY9'N<$5Z+)IMI-J=OJ,D9:ZMU*Q,7.$!ZX'0$]
MSWXINH:79ZM:I;WT1E2.594PY4JZ]"".01[5Q1DDK#E%R9<Y<A\8YR`1T[5G
M:+<RZA82/-C/VJXA&/[J3.B_^.J*EU"6XMK0M;6=Q>.3@I`8@V,=?WC!>P]3
MST[CE_">MZG)I,V?#>HY^VW."DD&`3,['[\B'AB5]/EX/HDALZ2&\FE\17EH
MVWRHK2WE7']YVE#?HBUH5Q%CK6ICQIJ2'PWJ1_T*`'$MONP'E*D_,$YW-T;/
MR=#UKMZ3&@HHHI#"BBB@"O?9^QR8STK8K&O_`/CRD^E;--`%<7XKN+FZO=)T
M"VDDMWU)I6N+B-L/';QK\VW^ZS;E7=_#N-=I7$^)F_LGQ9X=UN50+-3-87$G
M:+SMOEM_WU&J_P#`J.J%T,?QIKVJ>`_#T?\`8&C6<6FVJQ@R3-\BEFV[5C7Y
MO]K<U='XET-M0LEU#3W^SZQ9JTEG<*O1O^>;?],V_B6N0^,EQ?7WAYM`T[1-
M6OKBX:.836MJTD*[6^ZS+_%\M=7_`,)/;Q>#9]>NK2]L%CC95M;R#RIF;.U5
M\O\`VF^[_O4/:_4+6:]#6\/:I'K_`(>L-52,*MU;K)M_N[OO"GVW_+;_`*[2
M?^A53\':;+I'@_1]/N1BXAME$R^C8RW_`(]5JV^[-_UVD_\`0FIO<%L6****
MD851UK3_`.V-#O--\SR?M4+1^9MW;:O44`<-_P`(/JU[;PV&L>*)KS2X]NZU
MCLEA\S;_``LU=RJ[555^ZM%9MSK4-M<-"UGJ+-'_`!1V<C*U4VY$I1B1W?\`
MR-FE_P#7K=?^A0UK5Q5[XH@7QCI,?]GZK_QZ3+N^QM_$R_P_]L__`!ZMW_A(
MK?\`Y\=5_P#`"3_XFCE>@*2N;%%8_P#PD5O_`-`_5?\`P`D_^)JY8:@M\LGE
MV]W#Y?\`S\0M'_Z%2LRHM7.0TG6]5BM8YII/MT;?PM\LB_[K?Y_WJZO3=:L=
M47;!)MF7[T,GRR+_`,!KB=+_`.0;#_G^)JFEMXYMOF*VZ/[K*VUEK@6(E%V>
MI[$\'3FM-&=E%<0VMC)-/,L,:R2;F9MNWYFK%N_%$EQ^[TN'Y?\`GZF5E7_@
M*_Q5B_9=S*US--=-']WSF^[5BB6);TCH32P,(ZSU?X&YX3NKJ>TO/M=PUQ)'
M=,JLVU?X5K>KF?"<BQV.J2,K?+>,WRJS?PK_``U>_P"$FL?^??5?_!1=?_&Z
MZZ5W!'GXBT:LEL;%%8__``DUC_S[ZK_X*+K_`.-U1O\`QQIMC>6-O):ZJS74
MGEK_`,2Z9=O_`'TOS?\``:UY6<_,NYTU%8__``DUC_S[ZK_X*+K_`.-UL*VY
M=R_=_P"^:5F--,****0PILC+'&S?PK3JKW_RZ?<?]<VH`NV"^7I]NIZ^6OYU
M;I%&U0HI:H`HHHH`****`/(#_P`G$W'_`%X?^RK7I]>8'_DXFX_Z\/\`V5:]
M/KNQ^U/_``HSAU]0HHHKSS0/\1_,5D>&?^09-_V$;W_TIDK7_P`1_,5D>&?^
M09-_V$;W_P!*9*8GN):_\CAJ'_8-L_\`T.XK8K'M?^1PU#_L&V?_`*'<5L4`
M@HHHI#"BBB@"M?\`_'E)]*V:Q;[_`(\G^E;5-`%5+RSM]0M);6[ACFMY5VR1
MR+N5EJW13`Y2#0=9TR);?1]>068^Y%J%JUT8E_A5662-MO\`O;F_VJ6+P[-/
MJ$.HZY>MJ-S"P:",1".WMV!^]''\WS?[3,S?W=M;FK-MTB^8=5MY/_0:Q?AY
M(\GP[\/.[,S-8Q99O]VCK<.ECJ*R8/E:X7_ILW_H5:U9,?RW%TO_`$V_]EI,
M":BBBD`4444`%%%%`!1110`4444#6YYOILBQZ3&TC;57^]\NVKUI:WVJ;?L4
M.V'_`)^)OE7_`("O\5;6F^$[&QVM.S7DD?\`J_.^['_P&N@KDAAM;R/0JXU;
M07S.);1M4MX/.@D6^7<RM'\L<GRM_#_#_G[U58[B.1FC^99%^]'(NUEKMK+_
M`(]V_P"NTG_H35'J&DV.I*JW,.Z1?NR+\K+_`,"JIX:+^'05+'26DU<R?!__
M`!ZZE_U^-_Z"M=)6;HNCKH\$T2W$DWG3>9ND^]]VM*MH)QBDSDKS4ZCE'8*Q
M]6_Y#&@_]?4G_I/)6Q6/JW_(8T'_`*^I/_2>2M$8O8V****0PHHHH`*KWO\`
MQZLO^[5BJ]W_`,>__;1?_0JH#8HHJCJ4K1:7=31G#QPLR_\`?-`%ZBN;\%7M
MSJ7@C1;Z[D\VZN+..223Y?F;;724`%%%%`'D'_-Q-Q_V#_\`V5:]/KS#_FXF
MX_[!_P#[*M>GUWX__EW_`(49PZA1117G&@C9VDJ>0,@>I[?K@_A5/2[%K&SD
MMRXRUS/,K?W1)*T@'X;\?A5VB@5D48+)UUR[O\@)/;Q0K'Z>6\AS^(D`_P"`
MU>K+UA9))M-CC:98VNOWWELR_+Y<C?P_[6VG7=G'>;?.DN%V_P#/&XDA_P#0
M66BY:BC2HK.MK2*U1DC>X96_YZ7$DG_H35671[>-E99K_P"7^]?S-_[-1=E<
MJ-JBLV[LX[S;YTEPNW_GC<21_P#H++3K:U6UC:..2X96_P">EQ)(W_CS4KL7
M)I;J37YQ82X4D@?=!K:KC[O38;6W::.:]W+_`,]+V:1?^^6;;78528I))Z!1
M113).4\:^)]+\->'YI-4DDBCNE:WC*QLV9&5N*QOA3XHTS6O!UCI=A+(USIE
MG!%=!HV54;;TW?\``6K0^)VB?\)!X!U:RC7=,D1N(>?XH_F_]EV_\"K%^"&A
M?V-\/+>ZD7;<:E(URV[^[]U?_'5W?\"H`].K+^[J%U_P%O\`QVM2LM_EU63(
M^5H5_P#'6;_[&@"2BBBI`****`"BBB@`HHHH`****`"BBB@"K9?\>[?]=I/_
M`$)JM55LO^/=O^NTG_H35:H`****`"L?5O\`D,:#_P!?4G_I/)6Q6/JW_(8T
M'_KZD_\`2>2FA/8UI&\N-FV_=KAK#QIKU]I\.I1^#IY--;YO,AOEDDV[OX8_
MXJ[>;_CWD_W?_9:X7P9XHT'2?`EBM[JUE#)#&WF1M,OF+\S?P_>IQV;MV)D]
M4KVW.PT?5K76M+AU"R;=#-]W^\NVKU<GX!MYET6ZO'MVMX]0O9+J&%E^[&WW
M:ZRB2L.+NKA5>]^6U;_99?\`QUJL57O_`/D'W&W_`)YU)1L5A^(]1L;#1;S[
M;>06JO#(J^=(J[OE_P!JMP5Y[\9?#XUSX<Z@Z+NGL/\`3(_^`_>_\=W50%OX
M9ZE97?@+1;>"\MY9[>QB6:..56:/Y?XE_AKMZ\B^`.@_8/!,VJR+^^U.;<K?
M],X_E7_Q[=7KM`!1110!Y"?^3B)_^P?_`.RK7IU>8_\`-Q%Q_P!@[_V5:].K
MNQ__`"[_`,*(AU"BBBO/+"BBB@"G>WGV>:QA\O=]JF\G_=_=LV[_`,=_\>IU
M-O;=;B2SD9MK6\WF+_M-Y;+M_P#'J=0:+9!1110,****!%74O^0?)_P'_P!"
MKI*YO4O^0?)_P'_T*NDIHF05#))'#&TDC*L:_,S-_#4U-*JR[6^9:9)S/_"Q
MO!?_`$,^E?\`@2M1Z;XR\&_Z+INFZ[I7\,-O;Q7"_P"ZJJM:?_")^'/^A?TK
M_P``H_\`XFDC\,:#'+'+;Z)IT,B-N5X[6-64_P#?-`&I+(D4;22LJQJ-S,W&
MVLL7$5U-975M,DUO-"VV1&W*WW=K?^A5KLJR*RLNY6K.N(8[>.R2&-4CBE55
M55^ZNUEH`Q;OQMX7L+J2WN]>TZ&XA;;)&UPNY:A_X6%X/_Z&;3/_``(6M*?P
M[HMU.TUSHNG33-]Z22U5F:H?^$5\._\`0OZ5_P"`4=`&I%-#<6\<T$BR0R+N
M5E^ZRTVUO+6\\[[-<1S>3(T,GEMN\ME_AJ2...*-8XU6../Y55?EV[:;';PP
M[O)A6/S&W-M55W-4@9NI>)M#T>X%OJ6J6EI,5W+'-,JLR[MO_H54?^%A>#_^
MAFTS_P`"%K6O='TO4I%DO]-L[J1?E5IH5;;5?_A%?#O_`$+^E?\`@%'0!9TW
M5=.UJV:[TR]MKJ%6V^9#)N7=_EO_`!ZI_M5O]L^Q_:(_M2Q^9Y.[YMO]ZBSL
M;/3[;R;*VAMH5_Y9PQ[5IWV>'[1YWEKYVW;YFU=VV@"KJ6K:?HMJMUJ=];V<
M.[;YDTFWYO\`*M63_P`+"\'_`/0S:9_X$+6Y=V-GJ$/DWMK#<1_>\N:-66L_
M_A%?#O\`T+^E?^`4=4!)I/B;0]<FDATO5K*\DC7<RPS;MM7)[RUM6A2>XCA:
MXD\N/S&V^8W]U?\`XFH[+1]+TV1FL-/M;5F^]Y,*KNJQ)##-Y?G0JWEMN7<O
MW6J0*L5U;V>FS7%S,L-O"TS222-M6-=S5D_\+"\'_P#0S:9_X$+6Q;1QS6<D
M,T:R1M)(K*R[MWS-5/\`X17P[_T+^E?^`4=4!'9^-/#-_=1VEGKUC-<2-MCC
MCN%W,W]VMBYN(;&UDN+F:.WMX5W222-M5=M48/#NBV=Q'<6VCZ=;S1_=DCMU
M5EJ]+#'-#)#-&LD;+M96_BJ0'1LLBJT;;E;[K+]VN-UGQGX:36M+4Z]8JUK=
MR?:/WR_N_P!S(OS?\"KLE55555=J_P!VN7UCP_HK:UI+-I-BS37DGG-]G7]Y
M^YD;YJJ.XGL3?\+`\'M\O_"2:9_X$+5Z#P[H,,D=Q;:+IT<B_-')':QKM_X%
M0OA?PZK+MT'3%9?N_P"A1UK+\J[=NU5HOV#E3W(;:\M;Z'SK2XCN(U9EW1MN
M^9:S=2\6>']'NOLNHZU86MQMW-'-,JLM:T4,=O'Y<,:QK][:J[:IW>AZ3J%Q
MYU[I=E<3?=\R:W5FJ1F3_P`+"\'_`/0S:9_X$+6Q;7UGK&F_:+"ZANK>9659
M(6W*W]ZJ?_"*^'?^A?TK_P``HZTK:UM[.W6WMK>.WAC^['&JJJU0"Z=J%K<?
MN$GB>XCBC:2%9-S1[ON[E_AJ+7-:T/2+/;K=]:VMO<;H_P#2)-JR?WA4VFPP
MK:QRB-5F9=C-M^9MORU)?:78ZE$L=_8V]VJG<HN(5D5?^^J`.8TGQCX%T;2+
M33K/Q+I@@MHEBC#72_=6M[2O$>CZZ)?[*U2VO?)V^9]GD5MN[[M'_")^'/\`
MH7]*_P#`*/\`^)JS8Z5I^G*WV"PM+7?][[/"L>[_`+YH`T****`/(?F_X:'N
M-O\`T#_F_P!W:M>G5YFO_)PUU_V#_P#V5:],KNQVU/\`PHB'4****\\L****
M`,O5D9KS2656;;=LS?[/[F:K51W]Y]GFL8?+W?:IO+_W?W;-_P"R_P#CU24&
MB^%!1110`4444`5=2_Y!\G_`?_0JZ2N;U+_D'R?\!_\`0JZ2FB9!1113)"BB
MB@`JAJ@_T$M_<D5O_'JOU5O8_,LKB-?O-&U`$-%-B;S(8V7^):=4@%%%%`!1
M110`4444`%%%%!2W,?2_$VFZHRQHTD,S?=CF7;N_W?[U;%>;Z?#'-I,,<T:L
MO]UOFK2LM2U32V58I/M5JO\`RQF;YE7_`&6_^*_[ZKECB5>TCOJX'2\'\CK+
M+_CW;_KM)_Z$U%[J%GIL/G7=PL*_P[OXJYEO$%])"T-E;?9?F9O.N%^;[S?=
M6L];=?.^T32--<-_RVD^]53Q,8_#J12P,I:ST.PTG5K?6+>::".:-8Y/+VR+
MMK0KF_!__'KJ7_7XW_H*UTE;0DY139RUH*%1Q6P5CZM_R&-!_P"OJ3_TGDK8
MK'U;_D,:#_U]2?\`I/)5HR>QL4444AA1110`4444`+I;?NIH_P#GG,W_`(]\
MW_LU7ZSK0[;FZ0^J/_X[_P#8UHU0!1110`4444`>1_\`-PUU_P!@W_V5:],K
MS$R>7^T!>/M9MNF+\JKN9ONUZ!_:7_3G>_\`?NN[';4_\*(AU+U%4?[2_P"G
M.]_[]T?VE_TYWO\`W[KSRR]15'^TO^G.]_[]T?VE_P!.=[_W[H`=>VZS26<C
M-M:WF\Q?]IO+9?\`V:G5EZI=-)=:6RV=UMCNF9OW?\/DR+5K[=_TZW'_`'[H
M-;62+5%5?MW_`$ZW'_?NC[=_TZW'_?N@1:HJK]N_Z=;C_OW1]N_Z=;C_`+]T
M`&I?\@^3_@/_`*%725R=[=>99R+]GF7_`&F7Y:ZRFB9!1113)"BBB@`HHHH`
MQ[)=MG''_P`\_P!W_P!\U8J&'Y9+B/\`NS-_\5_[-4U`!1114@%%%%`!1110
M`4444#C\1YSI?_(-A_S_`!-5B6:&W7=-(L:_[WWJ-%TG5+JUCA6W:UC7[TUP
MO_H*UU&G>'[&P;SMOG77\5Q-\S?_`&/^[7GQP\I.[T/8GBZ<%W?D<G'>1M(L
M++)#-_"LRLK-5BNJ6QM=0L9(;N%9H_.D^5O]YJP[OPW>6;,VG2?:H?\`GWF;
MYE_W6_\`BJJIAI+6.HJ6-A-VEH_P)O"\;3:;JT*R-&S73+NC^\O[M:=_PB,G
M_0S>(/\`P*7_`.)I_A&*6*TOFG@FA:2\9E61=O\`"M=#771;4$F>9B;2JR9S
MO_"(R?\`0S>(/_`I?_B:P=9\(SMK.A[?$FKMNNV4;KCYE_=LWR_\!7_QZO0*
MR=6_Y#&@_P#7U)_Z3R5LI.YA*"L4?^$1D_Z&;Q!_X%+_`/$UT4:[8U7=NV_Q
M-_%3J*EML:26P4444AA1110`V#Y=6_ZZ0M_XZW_V5:59?W=0M6_VF7_QW_[&
MM2J`****`"BBB@#R/_FX>Z_[!O\`[*M>F5YF/^3AKK_L&K_Z"M>F5W8[_EW_
M`(8D0ZA1117GEA1110!1O[S[/-8P^7N^U3>3_N_NV;_V6I*;>VJW$EK(S;6M
MYFD7_:_=LO\`[-3J#16LK!1110`4444`5=2_Y!\G_`?_`$*NDKF]2_Y!\G_`
M?_0JZ2FB9!1113)"BBB@`HHHH`R^FHW0_O[6_P#9?_9:DIMP,:GG^]!_Z"W_
M`-E3J3`****0!1110`4444`%%%%`!1110!5LO^/=O^NTG_H35:JK9?\`'NW_
M`%VD_P#0FJU0`4444`%8^K?\AC0?^OJ3_P!)Y*V*Q]6_Y#&@_P#7U)_Z3R4T
M)[&Q137;RXV;;]VN&L/&NO7UC#J4?@Z=M-;YO,AOUDDV_P"S'_%0DV#:6YW=
M%4='U:UUK2X=0LFW0S?=_P!FKU#33LP335T%%%%(9#<_+Y,G]V9?_0JUJQ[_
M`/X\9MO\*[JUU.Y0PIH!:***8!1110!Y!C_C(B;_`&=/_P#95KT^O,/^;B;C
M_L'_`/LJUZ?7=C]J?^&)G#KZA1117GF@4444`9>K*S7FCLJ_*MXS-_WYDJU4
M=_>?9YK&'R]WVJ;R=W]W]VS?^RU)0E8UO=(****!!1110!5U+_D'R?\``?\`
MT*NDKF]2_P"0?)_P'_T*NDIHF04444R0HHHH`****`,V[PNH6KC^[(O_`*#_
M`/$TZEO_`/76G_71O_06I*3`****0!1110`4444`%%%%`!1110!5LO\`CW;_
M`*[2?^A-5JJME_Q[M_UVD_\`0FJU0`4444`%8^K?\AC0?^OJ3_TGDK8K'U;_
M`)#&@_\`7U)_Z3R4T)[&I-_Q[R?[O_LM<+X,\4:#I/@2Q6]U:RADAC;S(_.7
MS%^9OX?O5WVU=NW^&LF+PUH=K-'-!H^GPS1MN61;559:<6K-/R%-.Z:,GP!!
M-'HMU>/;M;QZA>R74,++M98V^[764442=V-*R"BBBI&-D7=&T?\`>J?3V9].
MMV;[QC6HJ-+Q]B7_`&69/^^6:F@-"BBBF`4444`>0?\`-Q-Q_P!@_P#]E6O3
MZ\P_YN)N/^P?_P"RK7I]=V.VI_X49T^OJ%%%%>>:!1110!3O;5;B2SD9MK6\
MS2+_`+7[ME_]FIU4]65FO='VK\JWC,W_`'YDJY0:)>Z@HHHH&%%%%`%74O\`
MD'R?\!_]"KI*YO4O^0?)_P`!_P#0JZ2FB)!1113)"BBB@`HHHH`HZE]ZS_Z[
M_P#LK4VG:E]ZS_Z[_P#LK4VDP"BBBD`4444`%%%%`!1110-!17G>C7FH6=G'
M-;73-N^]#<-N5OF_\=KJK#Q-:W4BV]ROV2Z;[L<GW6_W6_BK.%:+TZG35PE2
M&JU1H67_`![M_P!=I/\`T)JM5EMJEGI=FS7=PL>Z:3:O\3?,W\-8=WKVH:A\
MMLK6-O\`WF^:9O\`XFJG5C'<BEAZE31+3N=A17-^#MWV'4%:223;>-\TC,S?
M=6NDHC+F5R*L/9R<>P5CZM_R&-!_Z^I/_2>2MBL?5O\`D,:#_P!?4G_I/)5H
MR>QL4444AA1110`4444`%)IQ'DRJ?X9V_P#BJ6C3_O7G_7?_`-IK30&A1113
M`****`/(/^;B;C_L'_\`LJUZ?7F'_-Q-Q_V#_P#V5:]/KNQVU/\`PHSI]?4*
M***\\T"BBB@"O=PS36^V"X^SM_>VJU0VEC=0R,US?-<+M^[Y:KMJ]12L4IM*
MQERZ??-,S1ZIY<?\*_9U^6K$MG<-;K'#>>7(OWI/+W;JN4460>TEI_D9]I8W
M4,C-<ZA]H7^[Y:K4<NGWS3,T>J>7'_"OV=?EK4HHLA^TE>_Z&;J%G(VF[?M'
MS+MW-M^]_P#$UT58]_\`\>,E;%4B6[A1113$%%%%`!1110!GW@Q<6:_]-&;_
M`,=;_P"*HHO/FU"!?[L;-_X\M%)@%%%%(`K-GUC[/<-#_9NHR;?XHX=RUEW'
MQ$\)VMXUK+K$/F+\ORJS+_WTORUTR[6565EVU5FM6B>9-V1R\_C+[/KEKIO]
MAZK_`*1&S>9Y/]W_`#_X]6A_;W_4)U7_`,!Z==_\C9I?_7K=?^A0UK4>Z"N8
M_P#;W_4)U7_P'JY87WVY9/\`0[NWV_\`/Q'MW5<HI/E*7-='G.E_\@V'_/\`
M%5J2..1=LBJR_P!UJHV,T=OI=NTC;=WW?EW;OFK8M-%U+4-K2+]AM_[S?ZYO
M_B:\Q4Y2E9'ORJQ@KR=C/@L[>U;=#'M;^\VYJL5:_P"$;F6W:33KEV;<R^3<
M-N5OF_O?P_Y^6L]IFAF6WNX6M9O[LG\7^ZW\5*=*<-PIUX3^%FUX3;R]/U1M
MK-MO6^5?O?=6KW]O?]0G5?\`P'JGX/\`^/74O^OQO_05KI*]"C\"/&Q7\61C
M_P!O?]0G5?\`P'K%UKQ%(NL:#Y>AZJRK=,S?Z/\`=_=LO_LU=E16J:1SM-]3
M'_M[_J$ZK_X#UK*VY?NLO^S_`!+3J*!H****D84444`%%A_Q\7B_]-%;_P`=
M6BBQ_P"/B\_WE_\`0::`T****8!1110!Y!_S<3<?]@__`-E6O3Z\P_YN)N/^
MP?\`^RK7I]=V.VI_X49T^OJ%%%%>>:!1110`4444`%%%%`!1110!7O\`_CQD
MK8K'O_\`CQDK8IH`HHHI@%%%%`!1110!ENV[5)F_YYQJO_H3?_$U)4-M\_G3
M?\])&;_V6IJ3`*YWQW/<0>!]6DM&99/)_A^\J_+NKHJ;+#'-#)#,JM&R[65O
MXJ0&;HFGZ;;^';6UL(8?L+0KM55W+)6HJJJ[5^55KC_^%<V,>Z.SUK7;&U9O
M^/6TOML:UUT:K#&L:_=7Y:MM,B*:5FC+N_\`D;-+_P"O6Z_]"AK6K)N_^1LT
MO_KUNO\`T*&M:I[%=0HHHI#,O3?#^FZ2WF6T/[S_`)Z2?,U:E%%%DMBI2E)W
MD[E6R_X]V_Z[2?\`H35)<VMO>6[6]S"LD;?PLNZH[+_CW;_KM)_Z$U6J!)M:
MHHZ7I-KI-O)#:;O+DD\QMS,U7J**$K:()2<G=A1110(****`"BBB@`HHHH`*
M=IW^LO/^NW_LJTVETQ?W,S?WIF_\=^7_`-EIH"_1113`****`/(/^;B;C_L'
M_P#LJUZ?7F'_`#<3<?\`8/\`_95KT^N[';4_\*,Z?7U"BBBO/-`HHHH`**\O
M\7:E9P>.Y+?5O$FJZ38K8*T:V,S+NDW?[*M78>#A8MH*SV&K7VIV\TC,MQ?2
M,S?W?XJNVER.?WK'04445!84444`5[__`(\9*V*Q[_\`X\9*V*:`****8!11
M10`5#-YGDR>5CS-OR_[U344`8T45W#;QPK:#]VJK_K:EQ??\^?\`Y$6M2B@#
M+Q??\^?_`)$6C%]_SY_^1%K4HH`R\7W_`#Y_^1%K.GOM9AG9(O#TTR+_`!K=
M1JK?]]-72T4`><W-]XA;Q1ITB^%+AH8[:9';[3&=NYE_X"/]7_P*M[^T->_Z
M%FY_\#(?_BJZBBG==B>5]SE_[0U[_H6;C_P,A_\`BJM65QJEPK?:-':U_P"N
MEQ&V[_OFMZBD.QEXOO\`GS_\B+1B^_Y\_P#R(M:E%`S$MEO849/LV[YF;_6?
MWF:I\7W_`#Y_^1%K4HH`R\7W_/G_`.1%HQ??\^?_`)$6M2B@#+Q??\^?_D1:
M,7W_`#Y_^1%K4HH`R\7W_/G_`.1%HQ??\^?_`)$6M2B@#+Q??\^?_D1:,7W_
M`#Y_^1%K4HH`R\7W_/G_`.1%HQ??\^?_`)$6M2B@#+Q??\^?_D1:FL86@M46
M08DRQ8?[S5>HH`****`"BBB@#R#_`)N(N/\`L'_^RK7I]>8#_DXFX_[!_P#[
M*M6_&'C3Q-HOF+9>&9(X5^[=3?O%_P#'?NUWXQ.7LTOY49J2BFWW/1**\?\`
MAYXP\0:UKU\UW]HU+;#\L,;1QK'\U>D?VIJG_0OW?_@1#_\`%5PR@T[#C-25
MT;%%8_\`:FJ?]"[=?^!$/_Q520:AJ$DL<<VAW,,;?>D::/Y?_'JFS*NCG=4A
M\0:;XZDUC2]!_M2WDL%M_P#C\CAVMNW?Q5T6B7VJ7UO(VJ:/_9<BM\L?VI9M
MWR_[-:E0W,DEO;M)#:M<2?PQJRK_`.A47TL+EL[W)J*Q_P"U-4_Z%VZ_\"(?
M_BJ/[4U3_H7;K_P(A_\`BJ+,=T;%%8KZIJGDR?\`%/W:_+_S\0_+_P"/5XSH
M'Q*\76\T=K&S:M_TQDC\QF_[Y^:JC3<EH1*HHL]XO_\`CQDK8KC]-U34-4T>
M234=%FTN3^%9)%;=784K6+3OJ%%%%`PHHHH`****`"BBB@`HHHH`****`"BB
MB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****
M`/(/^;B;C_L'_P#LJUZ?7F'_`#<3<?\`8/\`_95KT^N[';4_\*,X]?4Q=56Q
M\/V.I:]!IL/VJ&W9I-JK&TG_``*LO2_$GB:_:U=O!_DV=QM;[1_:4;;5;^+;
M6AXS_P"1)UK_`*\I/_0:Y?PK#H=JNEW#>-[N2X6-?]`FU=6CW;?N^77%!)IW
M"3::2\ST:BL6#4;U_$LUC+:K#:K#YD+,VZ23:W_CJUM5-M+EWUL%%%%(85S?
MB'Q)?:/JVGZ;IVC_`-I7%XLC*OVI8=JKM_O5TE>>^.8[6;Q?X?6[U:;2H?(N
M/]*AN/)9?N_Q54%>23)FVDVCJM$U#5M06X75M#_LO;_J_P#2EF\S_OFKEAIM
MCI=OY-A9PVL?]V./;7.Z4]K9:;<0Z/XLAU#RV\Z:XU"Z6Z^SKM_V66M[1+RZ
MOM'M;J[C6.:1?F55VTY+L2GW+%__`,>,E;%8]_\`\>,E;%2C0****8!1110`
M4444`%%%%`!1110`4444`1L:AN;NWLH?.N)5CC7^)FJ2618HVD=MJK7C_BWQ
M-)K5\T,+?Z'']W;_`!5R8K%1H1OU>QVX#`RQ53E6B6[/0Y/&.@QKN^WQM_NU
MIZ7JEGK%DMY92>9"W\5?.>M336K?9VC:-F7=\U>@_!W55>UO-+8Y:-O-C^E8
MX7%3J2]]6N>AC<JA0HNI3;=OR.[\5^)K;PMH4VJ7"-(L9VK&O\35C_#?Q7>>
M+])O+^[C6/;<;8XU_A6J'QI_Y)[+_P!?,?\`Z%7(?"SQGH/AKPI=1ZI?+#(U
MPS+'\S,R[:]51O"Z/FY3M.SV/=J*X;3/BIX2U:Y6U@U!HY&X431M'7775Y;V
M5K)=7,RQPQKN:1ONK4--;FRDGLRW17G-U\9/"-O,T:74TVUMNZ.%F6M/0OB5
MX9\07D=G97C+<2?=CDCV[J?)*U[$JI%NQSWCWXG2>']830]+M]UYN7S)I/NK
MNKU!/N*?]FOFGXHLJ_%*1F;:J^6W^[7K5Q\7/!]E-]G:^DD9?XHX69:J4-%9
M&<*GO/F/0**QM$\1Z3XBM?/TN\CN%7[VUN5K4GN(;>/?-(L:^K5G:QLFGL2T
M5CMXDTU6V^8S?\!JY::A;WT+20-\J_>W4#+E%8[>)+%6VKYC?[JU+;:W8W,G
MEK(RM_=9=M`&G13698UW,<+68_B#3HSM\YF_VE6@!-8U&2SDMX8E^:1OO?W:
MUJY+5[VWO;RR:"3=M;_OGYJZV@`HHHH`\A/_`"<)<?\`8._]E6O3JJR>'=*E
MUC^UGLHVO_+\G[1N;=M]*L_8!&G[JXN(_P#MIN_]"KHQ%=5N2RMRI+[B4K7&
M2PPW%NUO/&LD,B[6CD7<K5FQ^%_#\<BR1Z#ID;+]UEM8U9:U387':\;_`(%&
MM'V*[[WB?]^?_LJYU=;#:3W*WV./^TOMVYO,\GR=O\/\-6J06$W>^D_X"JT+
MIHV_O+FX;Z/M_P#0:!BTV2:./_62*O\`O-4G]EVN/GC9_P#?D9JD2QM8O]7:
MPK_NQJ*5@*/VZU^ZLRLW]U?FJG?6.EZHT?V_25O&C^[YUANV_P#?2UTE%,#B
MKGPSID\*QV>G/IVV579K*UC7S-OW=VY?F6MFV^T6MLL,RW]Q(O\`RTD6/<W_
M`'S\M;E%'2PK(P[F9I+>2-;>X5F_A\EJW***!A1110`4444`%%%%`!1110`4
M444`%%%%`'E/Q!\:0PW$FAPR,K1_ZYE_W?NUE^`-.AU[4I+B56^RVO\`>_B:
MH?B;X?NCXH;4%A;[+-&NZ3;_`!?=KE[34+K286^Q74T*_P#3-J\6NX*OS5$V
M?786BIX-1P[LVM7Y]3OOBUH*26-GJEL%5H?W+*O\2M]VN.\!3W6G>,;*2..1
MEF;RY-O]VF-XMUG7+'^S;V1;B/<K;MOS?[M>H^!/"0TJW&H7:_Z9*ORJW_+-
M:U3=2M^[5EU,)R^J81TZ^K=TBI\:O^2?R_\`7Q'7`_"OX?:3XHT^XU+5&DD6
M.3RUA5MJUWWQK_Y)]+_U\1_^A50^!G_(H7?_`%]M_P"@U[2;4-#X]I.K9G`_
M%?P;IOA.[T^325:..X5MT;-NV[:WO'&HW]Y\%?#\WF-F9E6X_P!KY6J?X_\`
MWM%_[:?^RUU&@'0_^%.Z6FO&)=/,"QR&3[OWJ=[138K7E)+0\_\``\?PW_L*
M-M?9/[1W?O/.9J[GPWX;^'UYKD&H>'KI/MEJV[RXYO\`V6LB/X:_#JZ7SH-<
M_=_]?:_+7G-I%'HOQ-MX-"NVN8(KQ5AD7^+_`&:M^]>S8KN-KI&A\5HUF^)T
MT+?*K>6M>I)\%_"?V'R_+N/,9?\`7>9\U>7_`!394^*,C,WRKY>YO[M>YS>.
M_#-M8-=-K%JT:K_"U3)R44."3D[GAW@66Y\*_%B/2Q(WER7+6LG^U7N%VO\`
M:7B%;61OW,=>&^"UF\4?%V/4HHV\M;IKMO\`97=\O_LM>XS,NG>*/.E.(Y14
MU/B-:'PLZ%+&UCCVK!'M_P!VGI;PQAMD:KN^]4BLK+N!^6L_69)(])F:+[VW
M_OFLC4B>^T>U;R_W.[_96L76[C3[B..2T9?.5OX?EK0T*QL9-/6:2-9)/XF:
MJOB*&QMX8U@CC6;=_#0!)K-Q))9V-NK;6N%7=6O;:59V\*JL*MM_B9:Q-85E
MM=-NE^[&J[JZ6"XCN(5DB;<K4`<UK=K#;ZA9^3&L>YOFVUU5<UXA_P"/ZQ7_
M`&O_`&:NEH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@""6..:,QR*K*W\)KB=9^&>EZF^ZWDDM-Q^9
M8_NUWM,S6<J<)[HVHUZM%WIRL<#X>^&6GZ%J2WS74ETR_=615^5J]`Q@44C=
M*%",-D*M7J57S5'=G.^+_#$/BS06TN:XD@C:17W*N[[M5_!O@Z'P7I4UC!>2
MW"22>9ND55VUU?\`!2UKS.UC#E5[G#^-_`5OXX^Q^??2VOV?=_JU5MU6'\$6
M-QX%A\*W4\DEO&J_O%^5MRMNKKZ*.9VL'(KM]SQQ_@%8[OW.N7"K_=:%:Z+P
MG\*=%\,WJW_F27EU'_JY)%V[?^`UZ%13YI6M<GV<$[V///%7PKTGQ1JTFI37
M=Q;W$BJK>7]VL*/X":6KJS:U=LO]WRUKU^EI*;0.G!N[1S?A?P;I'A*U:'3(
M-KM_K)F^9FK8O;&"^CVS+_NM_=JV*6DW?<M)+1&#_P`(WM^6._G5:OV>EI:V
M\D+R-,LGWMU7Z*!F&WAJ'=NBNIHU_NK2_P#"-69MV7=)YC?\M&^]6W10!6^Q
LPM9K:N-T:KMK*_X1SRV_T>\FC7^[6]10!B1>'(5E626XDE9?[U;=%%`'_]FQ
`






















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
        <int nm="BreakPoint" vl="666" />
        <int nm="BreakPoint" vl="1845" />
        <int nm="BreakPoint" vl="302" />
        <int nm="BreakPoint" vl="1578" />
        <int nm="BreakPoint" vl="723" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-23464 update options added if version of delivered products has been updated" />
      <int nm="MAJORVERSION" vl="3" />
      <int nm="MINORVERSION" vl="7" />
      <str nm="DATE" vl="2/6/2025 3:51:04 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-23464 legacy warning introduced." />
      <int nm="MAJORVERSION" vl="3" />
      <int nm="MINORVERSION" vl="6" />
      <str nm="DATE" vl="2/6/2025 2:41:19 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-20808 fixed translation issue" />
      <int nm="MAJORVERSION" vl="3" />
      <int nm="MINORVERSION" vl="5" />
      <str nm="DATE" vl="10/7/2024 2:44:14 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-18983 edit in place is limited to 1 item" />
      <int nm="MAJORVERSION" vl="3" />
      <int nm="MINORVERSION" vl="4" />
      <str nm="DATE" vl="5/9/2023 4:06:58 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-17410 dove export corrected" />
      <int nm="MAJORVERSION" vl="3" />
      <int nm="MINORVERSION" vl="3" />
      <str nm="DATE" vl="12/19/2022 10:08:04 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-14560 new settings option to auto select a predefined type by component name, new context commands to Import/Export the settings" />
      <int nm="MAJORVERSION" vl="3" />
      <int nm="MINORVERSION" vl="2" />
      <str nm="DATE" vl="2/1/2022 4:43:46 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-14400 bugfix dimrequest multiple panels" />
      <int nm="MAJORVERSION" vl="3" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="1/17/2022 10:45:31 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HB-14226 supports tool description format, tool based tool index and exports to hsbMake and hsbShare added." />
      <int nm="MAJORVERSION" vl="3" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="12/20/2021 4:53:32 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-11426 Faro Laserscanner data added" />
      <int nm="MAJORVERSION" vl="2" />
      <int nm="MINORVERSION" vl="9" />
      <str nm="DATE" vl="4/29/2021 2:13:20 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End