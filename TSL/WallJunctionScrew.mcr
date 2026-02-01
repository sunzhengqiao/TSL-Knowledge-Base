#Version 8
#BeginDescription
#Versions
Version 1.1 01.12.2021 HSB-12680 bugfix detecting potential connections , Author Thorsten Huck
Version 1.0 19.08.2021 HSB-12680 initial version , Author Thorsten Huck

This tsl creates wall junction screws using the ScrewCatalog definitions



#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords Screw;Nail;Connection;Junction;Connection;Fixture;Metal
#BeginContents
//region Part #1

//region <History>
// #Versions
// 1.1 01.12.2021 HSB-12680 bugfix detecting potential connections , Author Thorsten Huck
// 1.0 19.08.2021 HSB-12680 initial version , Author Thorsten Huck

/// <insert Lang=en>
/// Select elements or specify plugIn tsl of element
/// </insert>

// <summary Lang=en>
// This tsl creates wall junction screws using the ScrewCatalog definitions 
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "WallJunctionScrew")) TSLCONTENT
// If a catalog entry Inforce4 is defined for the manufacturer 'Spax':
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "WallJunctionScrew" "Spax?Inforce4")) TSLCONTENT

// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Set Rule|") (_TM "|Select tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Delete Rule|") (_TM "|Select tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Flip Face|") (_TM "|Select tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Export Settings|") (_TM "|Select tool|"))) TSLCONTENT
//endregion



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
	String sAuto =T("|<Automatic>|");

	String anyManufacturer = T("|Any Manufacturer|");
	String anyFamily= T("|Any Family|");
	String anyProduct= T("|Any Product|");
//end Constants//endregion

//region DialogMode
	int nDialogMode = _Map.getInt("DialogMode");
	if (nDialogMode ==1)
	{
		setOPMKey("RuleDefinition");
		
		String manufacturer = _Map.getString("manufacturer");
		String family = _Map.getString("family");
		String product = _Map.getString("product");
		
		String sManufacturers[] = { anyManufacturer,manufacturer};	
		String sManufacturerName=T("|Manufacturer|");	
		PropString sManufacturer(nStringIndex++, sManufacturers, sManufacturerName);	
		sManufacturer.setDescription(T("|Defines if this rule applies to a single manufacturer|"));
		sManufacturer.setCategory(category);
	
		String sFamilies[] = { anyFamily,family};	
		String sFamilyName=T("|Family|");	
		PropString sFamily(nStringIndex++, sFamilies, sFamilyName);	
		sFamily.setDescription(T("|Defines if this rule applies to a single family|"));
		sFamily.setCategory(category);	

		String sProducts[] = { anyProduct,product};	
		String sProductName=T("|Product|");	
		PropString sProduct(nStringIndex++, sProducts, sProductName);	
		sProduct.setDescription(T("|Defines if this rule applies to a single product|"));
		sProduct.setCategory(category);

		return;
	}		
		
//endregion

//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sPathGeneral = _kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\";	
	String sFileName ="ScrewCatalog";
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
			reportNotice(TN("|A different Version of the settings has been found for|") + sFileName+
			TN("|Current Version| ")+nVersion + "	" + _kPathDwg + TN("|Other Version| ") +nVersionInstall + "	" + sFile);
	}


	String sManufacturers[0];
	Map mapManufacturers;
	{ 
		// get the models of this family and populate the property list	
		Map _mapManufacturers = mapSetting.getMap("Manufacturer[]");
		for (int i = 0; i < _mapManufacturers.length(); i++)
		{
			Map m = _mapManufacturers.getMap(i);
			if (m.hasString("Name") && _mapManufacturers.keyAt(i).makeLower() == "manufacturer")
			{
				String name = m.getString("Name");
				if (sManufacturers.findNoCase(name,-1) < 0)
				{
					sManufacturers.append(name);
					m.setMapName(name);
					mapManufacturers.appendMap("Manufacturer", m);
				}
			}
		}
	}
	
	if (sManufacturers.length()<1)
	{ 
		reportMessage("\n"+ scriptName() + ": "+ T("|Could not find manufacturer data.| ")+ T("|Tool will be deleted.|"));
		eraseInstance();
		return;	
	}



// WallJunctionRuleSettings
	String sFileName2 ="WallJunctionScrew";
	Map mapSetting2;
	String sFullPath2 = sPath+"\\"+sFolder+"\\"+sFileName2+".xml";

// read a potential mapObject
	MapObject mo2(sDictionary ,sFileName2);
	if (mo2.bIsValid())
	{
		mapSetting2=mo2.map();
		setDependencyOnDictObject(mo2);
	}
	// create a mapObject to make the settings persistent	
	else if ((_bOnInsert || _bOnDebug) && !mo2.bIsValid() )
	{
		String sFile=findFile(sFullPath2); 
	// if no settings file could be found in company try to find it in the installation path
		if (sFile.length()<1) sFile=findFile(sPathGeneral+sFileName2+".xml");	
		if (sFile.length()>0)
		{ 
			mapSetting2.readFromXmlFile(sFile);
			mo2.dbCreate(mapSetting2);			
		}
	}
	// validate version when creating a new instance
	if(_bOnDbCreated)
	{ 
		int nVersion = mapSetting2.getInt("GeneralMapObject\\Version");
		String sFile = findFile(sPathGeneral + sFileName2 + ".xml");		// set default xml path
		if (sFile.length()<1) sFile=findFile(sFullPath2);				// set custom xml path if no default found
		Map mapSettingInstall; mapSettingInstall.readFromXmlFile(sFile);	// read the xml from installation directory
		int nVersionInstall = mapSettingInstall.getMap("GeneralMapObject").getInt("Version");		
		if(sFile.length()>0 && nVersion!=nVersionInstall)
			reportNotice(TN("|A different Version of the settings has been found for|") + sFileName2+
			TN("|Current Version| ")+nVersion + "	" + _kPathDwg + TN("|Other Version| ") +nVersionInstall + "	" + sFile);
	}
//End Settings//endregion	

//region Read WallJunctionScrew Rules
	Map mapRules = mapSetting2.getMap("Rule[]");
	int bHasRule = mapRules.length() > 0;
//endregion 

//region declare references	
	Beam males[0], females[0];
	Entity entMales[0],entFemales[0];
	ElementWallSF elMale, elFemale;
	
	String sElementOrderFormat = "@(ElementNumber)";
	
// get mode
	int nMode = _Map.getInt("mode"); // 0= element distribution, 1 = connection distribution, 2 = single male, 3 = single female	
//End references//endregion

//region Properties
category = T("|Component|");
	// Manufacturer
	String sManufacturerName=T("|Manufacturer|");	
	PropString sManufacturer(nStringIndex++, sManufacturers, sManufacturerName);
	sManufacturer.setDescription(T("|Defines the Manufacturer|"));
	sManufacturer.setCategory(category);
	int nManufacturer = sManufacturers.find(sManufacturer);
	if (nManufacturer<0){ sManufacturer.set(sManufacturers.first()); nManufacturer=0;}
		
	// Family
	String sFamilys[0];
	Map mapFamilies;
	{ 
		// get the models of this family and populate the property list	
		Map _mapFamilies = mapManufacturers.getMap(nManufacturer).getMap("Family[]");
		for (int i = 0; i < _mapFamilies.length(); i++)
		{
			Map m = _mapFamilies.getMap(i);
			if (m.hasString("Name") && _mapFamilies.keyAt(i).makeLower() == "family")
			{
				String name = m.getString("Name");
				if (sFamilys.findNoCase(name,-1) < 0)
				{
					sFamilys.append(name);
					m.setMapName(name);
					mapFamilies.appendMap("Family", m);
				}
			}
		}
	}	
	if (sFamilys.length()<1)
	{ 
		reportMessage("\n"+ scriptName() + ": "+ T("|Could not find family data.| ")+ T("|Tool will be deleted.|"));
		eraseInstance();
		return;	
	}
	String sFamilyName=T("|Family|");	
	PropString sFamily(nStringIndex++, sFamilys, sFamilyName);	
	sFamily.setDescription(T("|Defines the Family|"));
	sFamily.setCategory(category);
	int nFamily = sFamilys.find(sFamily);
	if (nFamily<0){ sFamily.set(sFamilys.first()); nFamily=0;}

// Product
	String sProducts[0];
	Map mapProducts;
	
	double dDiameterThread, dDiameterHead, dLengthHead,dLengthThread;
	String url, material, articleNumber;
	{ 
		// get the models of this family and populate the property list	
		Map mapFamily = mapFamilies.getMap(nFamily);
		dDiameterThread = mapFamily.getDouble("Diameter Thread");
		dDiameterHead = mapFamily.getDouble("Diameter Head");
		dLengthHead= mapFamily.getDouble("Length Head");
		url = mapFamily.getString("url");
		material = mapFamily.getString("material");
		
		Map _mapProducts = mapFamily.getMap("Product[]");
		for (int i = 0; i < _mapProducts.length(); i++)
		{
			Map m = _mapProducts.getMap(i);
			if (m.hasString("ArticleNumber") && m.hasDouble("Length"))
			{
				String name = dDiameterThread+"x"+m.getDouble("Length") ;
				if (sProducts.findNoCase(name,-1) < 0)
				{
					sProducts.append(name);
					m.setMapName(name);
					mapProducts.appendMap("Product", m);
				}
			}
		}
	}	
	if (sProducts.length()<1)
	{ 
		reportMessage("\n"+ scriptName() + ": "+ T("|Could not find product data of family| ") + sFamily+ T(". |Tool will be deleted.|"));
		eraseInstance();
		return;	
	}
	sProducts.insertAt(0, sAuto);

	String sProductName=T("|Product|");
	PropString sProduct(nStringIndex++, sProducts, sProductName);
	sProduct.setDescription(T("|Defines the product, <automatic> will select the best fit|"));
	sProduct.setCategory(category);
	int nProduct = sProducts.find(sProduct);
	if (nProduct<0){ sProduct.set(sProducts.first()); nProduct=0;}

category = T("|Mode|");
	String sModeName=T("|Insert Mode|");	
	String sModes[] = { T("|byProperty|"), T("|byRule|")};
	PropString sMode(nStringIndex++, sModes, sModeName);	
	sMode.setDescription(T("|Defines the Mode|"));
	sMode.setCategory(category);

category = T("|Alignment|");
	String sAxisOffsetName=T("|Axis Offset|");	
	PropDouble dAxisOffset(nDoubleIndex++, U(0), sAxisOffsetName);	
	dAxisOffset.setDescription(T("|Defines the Axis Offset|"));
	dAxisOffset.setCategory(category);

	String sAngleName=T("|Angle|");	
	PropDouble dAngle(nDoubleIndex++, 0, sAngleName,_kAngle);	
	dAngle.setDescription(T("|Defines the Angle|"));
	dAngle.setCategory(category);

	String sSideName=T("|Side|");	
	String sSides[] ={ T("|Male Side|"), T("|Female Side|")};
	PropString sSide(nStringIndex++, sSides, sSideName);	
	sSide.setDescription(T("|Defines the Side|"));
	sSide.setCategory(category);
	int nSide = sSides.find(sSide);
	if (nSide < 0)nSide = 0; // default

category = T("|Distribution|");
	String sDistributionName=T("|Rule|");
	String sDistributions[] = { T("|Fixed Distribution|"), T("|Even Distribution|")};
	PropString sDistribution(nStringIndex++, sDistributions, sDistributionName);	
	sDistribution.setDescription(T("|Defines the Distribution|"));
	sDistribution.setCategory(category);	

	String sOffsetBottomName = T("|Bottom Offset|");
	PropDouble dOffsetBottom(nDoubleIndex++, U(350), sOffsetBottomName);	
	dOffsetBottom.setDescription(T("|Defines the bottom offset|"));
	dOffsetBottom.setCategory(category);
	
	String sOffsetTopName = T("|Top Offset|");
	PropDouble dOffsetTop(nDoubleIndex++, U(350), sOffsetTopName);	
	dOffsetTop.setDescription(T("|Defines the top offset|"));
	dOffsetTop.setCategory(category);	
	
	String sOffsetBetweenName = T("|Interdistance|");
	PropDouble dOffsetBetween(nDoubleIndex++, U(1000), sOffsetBetweenName);	
	dOffsetBetween.setDescription(T("|Defines the drill interdistance|"));
	dOffsetBetween.setCategory(category);
	
category = T("|Drill|");
	String sDiameterName=T("|Diameter|");	
	PropDouble dDiameter(nDoubleIndex++, U(0), sDiameterName);	
	dDiameter.setDescription(T("|Defines the diameter of the drill|") + T(", |0 = byProduct|")+ T(", |<0 = additional diameter|"));
	dDiameter.setCategory(category);
	
	String sDepthName=T("|Depth|");	
	PropDouble dDepth(nDoubleIndex++, U(0), sDepthName);	
	dDepth.setDescription(T("|Defines the depth of the drill, 0 = no drill|")+ T(", |<0 = reduction to product length|"));
	dDepth.setCategory(category);

//End Properties//endregion 

//End Part #1 //endregion

//region Part #2
//region bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		
	// the script can be inserted with a special executeKey: "ManufacturerName?CatalogName" 	
		String sTokens[] = _kExecuteKey.tokenize("?");
		
		nManufacturer = -1;
		int bOk;
		if (sTokens.length()>1)
		{
			nManufacturer = sManufacturers.findNoCase(sTokens.first().trimLeft().trimRight(),-1);
			sManufacturer.set(sManufacturers[nManufacturer]);
			//setOPMKey(sManufacturer);
			
		// get existing catalog entries
			String entries[] = _ThisInst.getListOfCatalogNames(scriptName());//+ "-" + sManufacturer);
			
			int n = entries.findNoCase(sTokens[1], - 1);
			if (n>-1)
			{ 
				bOk = true;
				setPropValuesFromCatalog(entries[n]);
			}
		}
		
	// hide properties if rule exist
		if (!bHasRule)
		{
			sMode.set(sModes[0]);
			sMode.setReadOnly(_kHidden);
		}
		if (!bOk && bHasRule)
		{
			int bReadMode = sMode == sModes[1]?_kHidden:false;
			dAxisOffset.setReadOnly(bReadMode);
			dAngle.setReadOnly(bReadMode);
			sSide.setReadOnly(bReadMode);
			sDistribution.setReadOnly(bReadMode);
			dOffsetBottom.setReadOnly(bReadMode);
			dOffsetTop.setReadOnly(bReadMode);
			dOffsetBetween.setReadOnly(bReadMode);
			dDiameter.setReadOnly(bReadMode);
			dDepth.setReadOnly(bReadMode);				
		}		
		
		

	// show manufacturer dialog
		if (!bOk || nManufacturer<0)
		{ 
			sFamily.setReadOnly(_kHidden);
			sProduct.set(sAuto);
			sProduct.setReadOnly(_kHidden);
			showDialog("---");

			nManufacturer = sManufacturers.find(sManufacturer);
			//setOPMKey(sManufacturer);
			
			if (bHasRule)
			{
				int bReadMode = sMode == sModes[1]?_kHidden:false;
				dAxisOffset.setReadOnly(bReadMode);
				dAngle.setReadOnly(bReadMode);
				sSide.setReadOnly(bReadMode);
				sDistribution.setReadOnly(bReadMode);
				dOffsetBottom.setReadOnly(bReadMode);
				dOffsetTop.setReadOnly(bReadMode);
				dOffsetBetween.setReadOnly(bReadMode);
				dDiameter.setReadOnly(bReadMode);
				dDepth.setReadOnly(bReadMode);				
			}
			
		}
		
	// show family dialog
		if (!bOk)
		{ 
			sManufacturer.setReadOnly(true);
			sFamily.setReadOnly(false);
			
		// get the models of this family and populate the property list
			sFamilys.setLength(0);
			mapFamilies = Map();
			Map _mapFamilies = mapManufacturers.getMap(nManufacturer).getMap("Family[]");
			for (int i = 0; i < _mapFamilies.length(); i++)
			{
				Map m = _mapFamilies.getMap(i);
				if (m.hasString("Name") && _mapFamilies.keyAt(i).makeLower() == "family")
				{
					String name = m.getString("Name");
					if (sFamilys.findNoCase(name,-1) < 0)
					{
						sFamilys.append(name);
						m.setMapName(name);
						mapFamilies.appendMap("Family", m);
					}
				}
			}			
			sFamily = PropString(1, sFamilys, sFamilyName);

			if (bHasRule)
			{
				int bReadMode = sMode == sModes[1]?_kHidden:false;
				dAxisOffset.setReadOnly(bReadMode);
				dAngle.setReadOnly(bReadMode);
				sSide.setReadOnly(bReadMode);
				sDistribution.setReadOnly(bReadMode);
				dOffsetBottom.setReadOnly(bReadMode);
				dOffsetTop.setReadOnly(bReadMode);
				dOffsetBetween.setReadOnly(bReadMode);
				dDiameter.setReadOnly(bReadMode);
				dDepth.setReadOnly(bReadMode);				
			}


			if (sFamilys.length()>1)
			{
				showDialog("---");
				sFamily.setReadOnly(true);
			}
			nFamily = sFamilys.find(sFamily);
		}		

	// show product dialog
		if (!bOk)
		{ 	
			sProduct.setReadOnly(false);
			sProducts.setLength(0);
			
		// get the models of this family and populate the property list	
			Map mapFamily = mapFamilies.getMap(nFamily);
			dDiameterThread = mapFamily.getDouble("Diameter Thread");
			dDiameterHead = mapFamily.getDouble("Diameter Head");
			dLengthHead= mapFamily.getDouble("Length Head");
			url = mapFamily.getString("url");
			material = mapFamily.getString("material");
			
			Map _mapProducts = mapFamily.getMap("Product[]");
			for (int i = 0; i < _mapProducts.length(); i++)
			{
				Map m = _mapProducts.getMap(i);
				if (m.hasString("ArticleNumber") && m.hasDouble("Length"))
				{
					String name = dDiameterThread+"x"+m.getDouble("Length") ;
					if (sProducts.findNoCase(name,-1) < 0)
					{
						sProducts.append(name);
						m.setMapName(name);
						mapProducts.appendMap("Product", m);
					}
				}
			}			

			sProduct = PropString(2, sProducts, sProductName);	
			
			if (bHasRule)
			{
				int bReadMode = sMode == sModes[1]?_kHidden:false;
				dAxisOffset.setReadOnly(bReadMode);
				dAngle.setReadOnly(bReadMode);
				sSide.setReadOnly(bReadMode);
				sDistribution.setReadOnly(bReadMode);
				dOffsetBottom.setReadOnly(bReadMode);
				dOffsetTop.setReadOnly(bReadMode);
				dOffsetBetween.setReadOnly(bReadMode);
				dDiameter.setReadOnly(bReadMode);
				dDepth.setReadOnly(bReadMode);				
			}			
			
			if(sProducts.length()>1)
				showDialog("---");

		}


		
	// validate angle
		if (abs(dAngle) > 89)
		{
			reportMessage(TN("|Angle must be in range -89°< angle < 89°.|") + T(" |The angle has been reset to 0°.|"));
			dAngle.set(0);
		}
		

	// prompt for elements
		PrEntity ssE(T("|Select elements|") + T(", |<Enter> to select individual studs|"), ElementWallSF());
	  	if (ssE.go())
			_Element.append(ssE.elementSet());


		return;
	}	
// end on insert	__________________//endregion

//region mapIO: support property dialog input via map on element creation
	{
		int bHasPropertyMap = _Map.hasMap("PROPSTRING[]")  && _Map.hasMap("PROPDOUBLE[]");
		if (_bOnMapIO)
		{ 
			if (bHasPropertyMap)
				setPropValuesFromMap(_Map);	
			
			
		// show manufacturer dialog
			{ 
				sFamily.setReadOnly(_kHidden);
				sProduct.set(sAuto);
				sProduct.setReadOnly(_kHidden);
				showDialog();
				nManufacturer = sManufacturers.find(sManufacturer);
				//setOPMKey(sManufacturer);
				
			}
			
		// show family dialog
			{ 
				sManufacturer.setReadOnly(true);
				sFamily.setReadOnly(false);
				
			// get the models of this family and populate the property list
				sFamilys.setLength(0);
				mapFamilies = Map();
				Map _mapFamilies = mapManufacturers.getMap(nManufacturer).getMap("Family[]");
				for (int i = 0; i < _mapFamilies.length(); i++)
				{
					Map m = _mapFamilies.getMap(i);
					if (m.hasString("Name") && _mapFamilies.keyAt(i).makeLower() == "family")
					{
						String name = m.getString("Name");
						if (sFamilys.findNoCase(name,-1) < 0)
						{
							sFamilys.append(name);
							m.setMapName(name);
							mapFamilies.appendMap("Family", m);
						}
					}
				}			
				sFamily = PropString(1, sFamilys, sFamilyName);
	
				if (sFamilys.length()>1)
				{
					showDialog();
					sFamily.setReadOnly(true);
				}
				nFamily = sFamilys.find(sFamily);
			}		
	
		// show product dialog
			{ 	
				sProduct.setReadOnly(false);
				sProducts.setLength(0);
				
			// get the models of this family and populate the property list	
				Map mapFamily = mapFamilies.getMap(nFamily);
				dDiameterThread = mapFamily.getDouble("Diameter Thread");
				dDiameterHead = mapFamily.getDouble("Diameter Head");
				dLengthHead= mapFamily.getDouble("Length Head");
				url = mapFamily.getString("url");
				material = mapFamily.getString("material");
				
				Map _mapProducts = mapFamily.getMap("Product[]");
				for (int i = 0; i < _mapProducts.length(); i++)
				{
					Map m = _mapProducts.getMap(i);
					if (m.hasString("ArticleNumber") && m.hasDouble("Length"))
					{
						String name = dDiameterThread+"x"+m.getDouble("Length") ;
						if (sProducts.findNoCase(name,-1) < 0)
						{
							sProducts.append(name);
							m.setMapName(name);
							mapProducts.appendMap("Product", m);
						}
					}
				}			
	
				sProduct = PropString(2, sProducts, sProductName);	
				if(sProducts.length()>1)
					showDialog();
	
			}

			
			_Map = mapWithPropValues();
			return;
		}
		if (_bOnElementDeleted)
		{
			eraseInstance();
			return;
		}
		else if (_bOnElementConstructed && bHasPropertyMap)
		{ 
			setPropValuesFromMap(_Map);
			_Map = Map();
		}	
	}		
//End mapIO: support property dialog input via map on element creation//endregion 

// validate angle
	if (abs(dAngle) > 89)
	{
		reportMessage(TN("|Angle must be in range -89°< angle < 89°.|")+ T(" |The angle has been reset to 0°.|"));
		dAngle.set(0);
	}

	
//region Mode 0 element distribution
	if (nMode==0)
	{ 	
		//bDebug = true;
		
		int bByRule = bHasRule && sMode == sModes[1]; // only connections matching a rule will be created
			
	// find couples
		ElementWallSF elMales[0],elFemales[0]; // must be of same length, expresses a list of couples 
		Map mapProperties[0];// must be of same length as elMales
		
		Element elOthers[0];elOthers = _Element;
		
	// get connected when creating by plugIn TSL
		int bIsPlugin = _Element.length() == 1;
		if (bIsPlugin)
		{ 
			ElementWall wall = (ElementWall)_Element[0];
			if (wall.bIsValid())
				elOthers.append(wall.getConnectedElements());
		}

		for (int i=0;i<_Element.length();i++) 
		{ 
			ElementWallSF el0=(ElementWallSF) _Element[i]; 
			if(!el0.bIsValid())continue; 

			LineSeg seg0 = el0.segmentMinMax();
			PLine plOutlineWall0 = el0.plOutlineWall();
			PLine plEnvelope0 = el0.plEnvelope();
			Point3d pts0[] = Line(_Pt0, el0.vecY()).orderPoints(plEnvelope0.vertexPoints(true));			
			CoordSys cs0 = el0.coordSys();
			Point3d ptOrg0 = el0.ptOrg();
			Vector3d vecX0 = cs0.vecX(), vecY0 = cs0.vecY(), vecZ0 = cs0.vecZ();
			seg0.vis(4);


		// loop next elements
			for (int j = 0; j < elOthers.length(); j++)
			{
				ElementWallSF el1 = (ElementWallSF) elOthers[j];
				if (!el1.bIsValid() || el0==el1) { continue; }
				CoordSys cs1 = el1.coordSys();	Vector3d vecX1 = cs1.vecX(), vecY1 = cs1.vecY(), vecZ1 = cs1.vecZ();
				Point3d ptOrg1 = cs1.ptOrg();
				LineSeg seg1 = el1.segmentMinMax();
				PLine plOutlineWall1 = el1.plOutlineWall();
				PLine plEnvelope1 = el1.plEnvelope();
				Point3d pts1[] = Line(_Pt0, vecY0).orderPoints(plEnvelope1.vertexPoints(true));
				
				//if (bDebug)reportMessage("\nchecking " + el0.number() + " vs " + el1.number());
				
			// test Z-Elevation
				double dA0B1 = vecY0.dotProduct(pts0.first()-pts1.last());
				double dB0A1 = vecY0.dotProduct(pts1.first()-pts0.last());
				
			// out of range below or above	
				if (dA0B1 >= 0|| dB0A1>=0)
				{
					//if (bDebug)reportMessage("\nrefusing " + el0.number() + " & " + el1.number());
					continue;
				}
					
			// get other outline
				plOutlineWall1.projectPointsToPlane(Plane(ptOrg0, vecY0), vecY0);
				Point3d ptsWall0[]=plOutlineWall0.vertexPoints(true);	
				Point3d ptsWall1[]=plOutlineWall1.vertexPoints(true);	

			// points on the contours
				int nOn0,nOn1;
				Point3d ptsOn0[0],ptsOn1[0];
				for (int p= 0;p<ptsWall1.length();p++)
				{
					double d = (ptsWall1[p]-plOutlineWall0.closestPointTo(ptsWall1[p])).length();//ptsWall1[p].vis(3);
					if(d<6*dEps) {ptsOn0.append(ptsWall1[p]);	nOn0++;}
				}
				for (int p= 0;p<ptsWall0.length();p++)
				{	
					double d = (ptsWall0[p]-plOutlineWall1.closestPointTo(ptsWall0[p])).length();//ptsWall0[p].vis(4);
					if(d<6*dEps) {ptsOn1.append(ptsWall0[p]);	nOn1++;}
				}
				
			// not a valid connection
				if (nOn1 < 1 && nOn0 < 1){continue;}
				
			// get connection type
				int bIsTConnection = (nOn1 == 2 && nOn0 == 0) || (nOn1 == 0 && nOn0 == 2);
				int bIsLConnection = (nOn1 == 2 && nOn0 == 1) || (nOn1 == 1 && nOn0 == 2);
				//int bIsMitreConnection = (nOn1 == 2 && nOn0 == 2 && !vecX0.isParallelTo(vecX1));// || (nOn0>0 || nOn1>0 &&(!vecX0.isParallelTo(vecX1) && !vecX0.isPerpendicularTo(vecX1)));
				int bIsParallelConnection = nOn1 >0 && nOn0 >0 && vecX0.isParallelTo(vecX1);				
				int bIsMitreConnection = !bIsParallelConnection && (nOn1 == 2 && nOn0 == 2 && !vecX0.isParallelTo(vecX1)) || 
					(nOn0>0 || nOn1>0 && (!vecX0.isParallelTo(vecX1) && !vecX0.isPerpendicularTo(vecX1)));

			// first element supposed to be the male element
				int bSwapElement = (nOn1 == 0 && nOn0 == 2) || (nOn1 == 1 && nOn0 == 2);
			
			// refuse mitred connections #special
//				if (bIsMitreConnection)
//				{
//					reportMessage("\n" + T("|Mitred connection refused between| ") + el0.number() + " & " + el1.number() +"\n"+T("|Select beams to insert a connection.|") );
//					continue;
//				}
//				else 
				if (!bIsTConnection && !bIsLConnection && !bIsMitreConnection && !bIsParallelConnection)
				{ 
					reportMessage("\n" + T("|The connection type could not be detected between element| ") + el0.number() + " & " + el1.number() +"\n"+T("|Please adjust wall corner cleanup.|") );
					continue;					
				}
			
			//region Set elements
				ElementWallSF elements[] ={ el0, el1};
				Point3d ptRefOther = ptsWall1[0];
				if (bSwapElement)
				{ 
					elements.swap(0, 1); // make sure first element is male	
					LineSeg seg = seg1;		seg1 = seg0;	seg0 = seg;
					vecX0 = elements[0].vecX();vecY0 = elements[0].vecY();vecZ0 = elements[0].vecZ();
					vecX1 = elements[1].vecX(); vecY1 = elements[1].vecY();vecZ1 = elements[1].vecZ();
					ptRefOther = ptsWall0[0];					
				}
				
			// get convex state
				Point3d ptAxis;
				if (!Line(seg0.ptMid(), vecX0).hasIntersection(Plane(seg1.ptMid(), vecZ1), ptAxis))
					ptAxis = (seg0.ptMid() + seg1.ptMid()) * .5; // parallel connections
				Vector3d vecC0 = vecX0;
				if (vecC0.dotProduct(ptAxis - seg0.ptMid()) < 0)vecC0 *= -1; //vecC0.vis(ptAxis, 1);
				Vector3d vecC1 = vecX1;
				if (vecC1.dotProduct(ptAxis - seg1.ptMid()) < 0)vecC1 *= -1; //vecC1.vis(ptAxis, 2);
				
				Vector3d vecM = vecC0 + vecC1; vecM.normalize();
				vecM.vis(ptAxis, 4);
				int bIsConvex = bIsLConnection && vecM.dotProduct(vecZ0) > 0;	
				
				if (bDebug)
				{ 
					String text;
					text += elements[0].number()+ " vs " +elements[1].number();
					text += "\nbIsTConnection: " + bIsTConnection;
					text += "\nbIsLConnection: " + bIsLConnection;
					text += "\nbIsParallelConnection: " + bIsParallelConnection;
					text += "\nbIsMitreConnection: " + bIsMitreConnection;
					text += "\nbIsConvex: " + bIsConvex;		
					text += "\nMale exposed: " + elements[0].exposed();
					text += "\nFemale exposed: " + elements[1].exposed();				
					reportNotice("\n" + text);
				}


			// get connection coordSys
				Vector3d vecZC = bIsParallelConnection?vecX0:vecZ1;
				if (vecZC.dotProduct(ptRefOther - seg0.ptMid()) < 0) vecZC *= -1;
				Vector3d vecYC = vecY0;
				Vector3d vecXC = vecYC.crossProduct(vecZC);	
				//vecZC.vis(seg0.ptMid(), 1);
				int bOk = true;
			//End elements //endregion
			
			//region
			// get potential male beams
				entMales.setLength(0);
				Beam males[] = vecX0.filterBeamsPerpendicularSort(elements[0].beam());
				for (int k=males.length()-1; k>=0 ; k--) 
				{ 
					Beam& b =males[k];
					//b.realBody().vis(1);
					entMales.append(b);
				}//next b

				entFemales.setLength(0);
				Beam females[] = vecX1.filterBeamsPerpendicularSort(elements[1].beam());
				// remove any female not intersecting large male test body
				{ 
//					Body bdTest;
					double dX = vecX0.dotProduct(seg0.ptEnd() - seg0.ptStart())*2;
					double dY = vecY0.dotProduct(seg0.ptEnd() - seg0.ptStart());
					double dZ = vecZ0.dotProduct(seg0.ptEnd() - seg0.ptStart());
					Body bdTest(seg0.ptMid(), vecX0, vecY0, vecZ0, dX, dY, dZ,0, 0, 0);
					//bdTest.vis(3);
					females = bdTest.filterGenBeamsIntersect(females);
				}					
				for (int k=females.length()-1; k>=0 ; k--) 
				{ 
					Beam& b =females[k]; 
					//b.realBody().vis(2);
					entFemales.append(b);
				}//next b
				
				if (!bDebug)bOk = males.length() > 0 && females.length() > 0;
			//endregion  

			//region Rule based insertion
				Map mapProperty;
				if (bByRule)
				{
					String k;
					int bMatch;
					for (int a=0;a<mapRules.length();a++) 
					{ 
						Map m= mapRules.getMap(a);
						k = "byManufacturer"; 
						if (m.hasInt(k))
						{ 
							int n = m.getInt(k);
							bMatch = !n || (n && m.getString("Manufacturer") == sManufacturer);
							if (bDebug)reportNotice("\nmanufact match " + bMatch);
							if (!bMatch)continue;
						}
						k = "byFamily"; 
						if (m.hasInt(k))
						{ 
							int n = m.getInt(k);
							bMatch = !n || (n && m.getString("Family") == sFamily);
							if (bDebug)reportNotice("\nfamily match " + bMatch);
							if (!bMatch)continue;
						}						
						k = "byProduct"; 
						if (m.hasInt(k))
						{ 
							int n = m.getInt(k);
							bMatch = !n || (n && m.getString("Product") == sProduct);
							if (bDebug)reportNotice("\nproduct match " + bMatch);
							if (!bMatch)continue;
						}
						 
						k = "isTConnection"; 		if (m.hasInt(k) && m.getInt(k) != bIsTConnection)		{if (bDebug)reportNotice("\n" + k + " failed");continue;}
						k = "isLConnection"; 		if (m.hasInt(k) && m.getInt(k) != bIsLConnection)		{if (bDebug)reportNotice("\n" + k + " failed");continue;}
						k = "isParallelConnection"; if (m.hasInt(k) && m.getInt(k) != bIsParallelConnection){if (bDebug)reportNotice("\n" + k + " failed");continue;}
						k = "isMitreConnection"; 	if (m.hasInt(k) && m.getInt(k) != bIsMitreConnection)	{if (bDebug)reportNotice("\n" + k + " failed");continue;}
						k = "isConvex"; 			if (m.hasInt(k) && m.getInt(k) != bIsConvex)			{if (bDebug)reportNotice("\n" + k + " failed");continue;}
						k = "isMaleExposed"; 		if (m.hasInt(k) && m.getInt(k) != elements[0].exposed()){if (bDebug)reportNotice("\n" + k + " failed");continue;}
						k = "isFemaleExposed"; 		if (m.hasInt(k) && m.getInt(k) != elements[1].exposed()){if (bDebug)reportNotice("\n" + k + " failed");continue;}
						
						mapProperty = m.getMap("Property[]");
						break;  
					}//next a
					
					if (bDebug)reportNotice("\nrule properties " + mapProperty);
					
				}
			//endregion 

			// set couple, only accepted if both have their construction build
				if (bOk)
				{ 
					elMales.append(elements[0]);
					elFemales.append(elements[1]);
					mapProperties.append(mapProperty);
				}
				else if (bDebug)
					reportMessage("\n" + T("|No beam construction found in at least one element|: ") + el0.number() + ", " + el1.number());

			}// next j of _Element
		}// next i of _Element
		
	// order couples by mounting sequence. A triple or fourfold connection might require different properties in a subsequent set
		for (int i=0;i<elMales.length();i++) 
			for (int j=0;j<elMales.length()-1;j++) 
			{
				String key0 = elMales[j].formatObject(sElementOrderFormat) + "_" + elFemales[j].formatObject(sElementOrderFormat);
				String key1 = elMales[j+1].formatObject(sElementOrderFormat) + "_" + elFemales[j + 1].formatObject(sElementOrderFormat);			
				if (key0>key1)
				{
					elMales.swap(j, j + 1);
					elFemales.swap(j, j + 1);
					mapProperties.swap(j, j + 1);
				}
			}
			
	// create connection distribution instances
		//reportMessage("\nmales found " +elMales.length());
		for (int i=0;i<elMales.length();i++) 
		{ 
			CoordSys cs0 = elMales[i].coordSys();
			CoordSys cs1 = elFemales[i].coordSys();
			Map mapProperty = mapProperties[i];
			if (bByRule)
			{
				if (mapProperty.length()<1)
				{ 
					if (bDebug)reportNotice("\nno rule properties found");
					continue;
				}
				setPropValuesFromMap(mapProperty);
			}
			
			
		// get attached instances
			TslInst tsls[] = elMales[i].tslInstAttached();
			int bHasInstance;
			for (int j=0;j<tsls.length();j++) 
			{ 
				TslInst t= tsls[j]; 
				if (t == _ThisInst || t.scriptName()!=scriptName())continue; // HSB-12680
				Entity ents[] = t.entity();
				
				if (ents.find(elMales[i])>-1 && ents.find(elFemales[i])>-1)
				{ 
					bHasInstance = true;
					reportMessage("\n" + T("|Elements| ") + elMales[i].number() + " + " + elFemales[i].number() + T(" |already connected|"));
					break;
				}
			}//next j
			if (bHasInstance)continue;
		
//			elMales[i].plOutlineWall().vis(i);
//			elFemales[i].plOutlineWall().vis(i);
	
			PLine pl;
			pl.createRectangle(LineSeg(cs1.ptOrg() - cs1.vecX() * U(10e4), cs1.ptOrg() + cs1.vecX() * U(10e4) - cs1.vecZ() * elFemales[i].dBeamWidth()), cs1.vecX(), cs1.vecZ());
			//pl.vis(3);
			Plane pnn(cs0.ptOrg() - cs0.vecZ() * .5 * elMales[i].dBeamWidth(), cs0.vecZ());
			pnn.vis(5);
			Point3d pts[] = pl.intersectPoints(Plane(cs0.ptOrg() - cs0.vecZ() * .5 * elMales[i].dBeamWidth(),cs0.vecZ()));
			if(pts.length()==0)
			{ 
				// HSB-6635 can happen at parallel connection of 2 walls with different widths
				reportMessage("\n"+ T("|Unexpected error parallel connection|"));
				continue;
			}
			
			Vector3d vecZC = cs0.vecX();
			if (vecZC.dotProduct((pts.first()+pts.last())/2 - elMales[i].segmentMinMax().ptMid()) < 0) vecZC *= -1;
			pts = Line(_Pt0, vecZC).orderPoints(pts);
			if (pts.length() > 0)_Pt0 = pts.first();

		// create TSL
			TslInst tslNew;
			GenBeam gbsTsl[] = {};		Entity entsTsl[] = {elMales[i],elFemales[i]};			
			Point3d ptsTsl[] = {_Pt0};
			int nProps[]={};			double dProps[]={dAxisOffset,dAngle, dOffsetBottom,dOffsetTop,dOffsetBetween, dDiameter, dDepth};				String sProps[]={sManufacturer,sFamily,sProduct,sMode,sDistribution, sSide};
			Map mapTsl;	
			mapTsl.setInt("mode", 1);					
			if (bDebug)
			{			
				PLine (elMales[i].ptArrow(), elFemales[i].ptArrow()).vis(i);	
			}
			else
			{
				//reportMessage("\ncreating connection " +entsTsl);
				tslNew.dbCreate(scriptName() , elMales[i].vecX() ,-elMales[i].vecZ(),gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);	
			}
		}
		
		if (!bDebug)
			eraseInstance();
		return;
	}//End Mode 0 element distribution//endregion 

//End Part #2 //endregion



//region Part #3
// All other modes
//	sMode.set(sModes[0]);
//	sMode.setReadOnly(_kHidden);

	if (_Element.length()<2)
	{ 
		reportMessage("\n"+ scriptName() + ": "+T("|Requires at least two elements.| ") + T("|Tool will be deleted.|"));
		eraseInstance();
		return;	
	}
	elMale=(ElementWallSF)_Element[0];
	elFemale=(ElementWallSF)_Element[1];

	//region get coordSys and plines of of elements
	CoordSys cs0 = elMale.coordSys();	Vector3d vecX0 = cs0.vecX(),vecY0 = cs0.vecY(),vecZ0 = cs0.vecZ();
	Point3d ptOrg0 = cs0.ptOrg();
	LineSeg seg0 = elMale.segmentMinMax();
	PLine plOutlineWall0 = elMale.plOutlineWall();
	PLine plEnvelope0 = elMale.plEnvelope();
	Point3d pts0[] = Line(_Pt0, vecY0).orderPoints(plEnvelope0.vertexPoints(true));	
	int bExposed0 = elMale.exposed();
	
	CoordSys cs1 = elFemale.coordSys();	Vector3d vecX1 = cs1.vecX(), vecY1 = cs1.vecY(), vecZ1 = cs1.vecZ();
	Point3d ptOrg1 = cs1.ptOrg();
	LineSeg seg1 = elFemale.segmentMinMax();
	PLine plOutlineWall1 = elFemale.plOutlineWall();
	PLine plEnvelope1 = elFemale.plEnvelope();
	Point3d pts1[] = Line(_Pt0, vecY0).orderPoints(plEnvelope1.vertexPoints(true));
	int bExposed1 = elFemale.exposed(); 
	Plane pnRef;
	
// get outline vertices on reference plane
	plOutlineWall1.projectPointsToPlane(Plane(ptOrg0, vecY0), vecY0);
	Point3d ptsWall0[]=plOutlineWall0.vertexPoints(true);	
	Point3d ptsWall1[]=plOutlineWall1.vertexPoints(true);			
	//End get coordSys and plines of of elements//endregion 

//region Get Type of connection and connection choordSys
// points on the contours
	int nOn0,nOn1;
	Point3d ptsOn0[0],ptsOn1[0];
	for (int p= 0;p<ptsWall1.length();p++)
	{
		double d = (ptsWall1[p]-plOutlineWall0.closestPointTo(ptsWall1[p])).length();//ptsWall1[p].vis(3);
		if(d<6*dEps) {ptsOn0.append(ptsWall1[p]);	nOn0++;}
	}
	for (int p= 0;p<ptsWall0.length();p++)
	{	
		double d = (ptsWall0[p]-plOutlineWall1.closestPointTo(ptsWall0[p])).length();//ptsWall0[p].vis(4);
		if(d<6*dEps) {ptsOn1.append(ptsWall0[p]);	nOn1++;}
	}
	
// not a valid connection
	if (nOn1 < 1 && nOn0 < 1)
	{
		reportMessage("\n"+ scriptName() + ": "+T("|Elements do not connect.| ")+ T("|Tool will be deleted.|"));
		eraseInstance();
		return;	
	}
	
// get connection type
	int bIsTConnection = (nOn1 == 2 && nOn0 == 0) || (nOn1 == 0 && nOn0 == 2);
	int bIsLConnection = (nOn1 == 2 && nOn0 == 1) || (nOn1 == 1 && nOn0 == 2);
	int bIsParallelConnection = nOn1 >0 && nOn0 >0 && vecX0.isParallelTo(vecX1);
	int bIsMitreConnection = !bIsParallelConnection && (nOn1 == 2 && nOn0 == 2 && !vecX0.isParallelTo(vecX1)) || 
		(nOn0>0 || nOn1>0 && (!vecX0.isParallelTo(vecX1) && !vecX0.isPerpendicularTo(vecX1)));
				

	Point3d ptOnRef = _Pt0;
	if (bIsParallelConnection)
	{ 
		if (nOn0 == 1 && nOn1 == 1)ptOnRef = (ptsOn0.first() + ptsOn1.first()) * .5;
		else if (nOn0 == 2)ptOnRef.setToAverage(ptsOn0);
		else if (nOn1 == 2)ptOnRef.setToAverage(ptsOn1);
		ptOnRef.vis(1);
	}
	

// first element supposed to be the male element
	int bSwapElement = (nOn1 == 0 && nOn0 == 2) || (nOn1 == 1 && nOn0 == 2);
	if (bSwapElement && _bOnDbCreated)
	{ 
		_Element.swap(0, 1);
		setExecutionLoops(2);
		return;
	}

// get connection coordSys
	Vector3d vecZC = bIsParallelConnection?vecX0:vecZ1;
	if (vecZC.dotProduct(ptsWall1.first() - seg0.ptMid()) < 0) vecZC *= -1;
	Vector3d vecYC = vecY0;
	Vector3d vecXC = vecYC.crossProduct(vecZC);	
	//vecZC.vis(seg0.ptMid(), 1);			
//End Get Type of connection//endregion 	

//region Get male and female beams
	Entity entMalesMap[]=_Map.getEntityArray("males", "", "");
	Entity entFemalesMap[]=_Map.getEntityArray("females", "", "");
	if(entMalesMap.length()!=0 || entFemalesMap.length()!=0)
	{ 
		males.setLength(0);
		females.setLength(0);
		for (int i=0;i<entMalesMap.length();i++) 
		{ 
			Beam bmI = (Beam)entMalesMap[i];
			if(bmI.bIsValid()&& males.find(bmI)<0)
			{ 
				males.append(bmI);
			}
		}//next i
		for (int i=0;i<entFemalesMap.length();i++) 
		{ 
			Beam bmI = (Beam)entFemalesMap[i];
			if(bmI.bIsValid()&& females.find(bmI)<0)
			{ 
				females.append(bmI);
			}
		}//next i
	}
	else if(_Beam.length()>0)
	{ 
		for (int i=0;i<_Beam.length();i++) 
		{ 
			Element e = _Beam[i].element();
			if (!e.bIsValid())continue;
			if (e == elMale)
				males.append(_Beam[i]);
			else if (e == elFemale)
				females.append(_Beam[i]);
		}//next i

	}
	else
	{ 
		males = elMale.beam();
		females = elFemale.beam();	
	}

// remove any female not intersecting large male test body
	{ 
		Body bdTest;
		double dX = vecX0.dotProduct(seg0.ptEnd() - seg0.ptStart())*2;
		double dY = vecY0.dotProduct(seg0.ptEnd() - seg0.ptStart());
		double dZ = vecZ0.dotProduct(seg0.ptEnd() - seg0.ptStart());
		if (bIsParallelConnection)
			bdTest = Body(ptOnRef, vecX0, vecY0, vecZ0, elFemale.dBeamHeight()*2, dY, dZ,0, 1, 0);
		else
			bdTest = Body(seg0.ptMid(), vecX0, vecY0, vecZ0, dX, dY, dZ,0, 0, 0);
		//bdTest.vis(3);
		females = bdTest.filterGenBeamsIntersect(females);
	}	
	
// filter males not within corner range
	{ 
		Body bdTest;
		Point3d pt = _Pt0;
		Line(ptOrg0, vecX0).hasIntersection(Plane(_Pt0, vecZC), pt);
		if (bIsParallelConnection)
			bdTest = Body(ptOnRef, vecX0, vecY0, vecZ0, elMale.dBeamHeight()*2, U(10e3), elMale.dBeamWidth(),0, 1, 0);
		else		
			bdTest=Body(pt, vecX0, vecY0, vecZ0, 6 * elMale.dBeamHeight(), U(10e3),elMale.dBeamWidth(), 0, 0, -1 );
		//bdTest.vis(4);		
		males = bdTest.filterGenBeamsIntersect(males);	
	}
	
//End Get male and female beams//endregion 

// get reference location on female beams
//	if (nMode==1)
//	{ 
//		PLine pl(vecY0);
//		pl.createRectangle(LineSeg(ptOrg1 - vecX1 * U(10e3), ptOrg1 + vecX1 * U(10e3) - vecZ1 * elFemale.dBeamWidth()), vecX1, vecZ1);
//		Point3d pts[] = pl.intersectPoints(Plane(ptOrg0 - vecZ0 * .5 * elMale.dBeamWidth(),vecZ0));
//		pts = Line(_Pt0, vecZC).orderPoints(pts);
//		if (pts.length() > 0)_Pt0 = pts.first();
//		pl.vis(3);
//	}

	Point3d ptRef = _Pt0;
	{ 
		Point3d pts[0];
		for (int i=0;i<females.length();i++) 
			pts.append(females[i].ptCen()-vecZC*.5*females[i].dD(vecZC)); 
		pts = Line(_Pt0, vecZC).orderPoints(pts);
		if (pts.length() > 0)ptRef = pts.first();	
	}
//	ptRef.vis(2);
	ptRef += vecY0 * vecY0.dotProduct(ptOrg0 - ptRef);
	ptRef.vis(2);
	
	//_Pt0 = ptRef;
	CoordSys csC(ptRef, vecXC, vecYC, vecZC);
	pnRef =Plane(ptRef, vecZC);
	//pnRef.vis(2);	

	Point3d ptAxis = ptRef;
	Line(seg0.ptMid(), vecX0).hasIntersection(pnRef, ptAxis); //ptAxis.vis(2);

	CoordSys csPlan(ptAxis, vecZC, vecXC, vecYC);


//region get common range
	PlaneProfile ppFemale(csC);
	PlaneProfile ppFemalePlan(csPlan);
	for (int i=0;i<females.length();i++) 
	{ 
		Body bd = females[i].envelopeBody(false, true);
		PlaneProfile pp = bd.extractContactFaceInPlane(pnRef, dEps);
		if (ppFemale.area()<pow(dEps,2))	ppFemale = pp;
		else								ppFemale.unionWith(pp);
		
		pp = PlaneProfile(csPlan);
		pp.unionWith(bd.shadowProfile(Plane(_Pt0, vecY0)));
		pp.shrink(-dEps);//pp.vis(i);
		if (ppFemalePlan.area()<pow(dEps,2))	ppFemalePlan = pp;
		else									ppFemalePlan.unionWith(pp);	
	}//next i
	ppFemalePlan.shrink(dEps);
	//ppFemalePlan.vis(1);
	
	//if (bDebug){ppFemale.transformBy(vecZ1 * U(10));	ppFemale.vis(2);	ppFemale.transformBy(-vecZ1 * U(10));}

	PlaneProfile ppMale(csC);
	PlaneProfile ppMalePlan(csPlan);
	
	Beam maleStuds[] = (-vecZC).filterBeamsPerpendicularSort(males);
	
	
	for (int i=0;i<maleStuds.length();i++) 
	{ 
		Body bd = maleStuds[i].envelopeBody(false, true);
		PlaneProfile pp = bd.extractContactFaceInPlane(pnRef, U(200));
		if (ppMale.area()<pow(dEps,2))		ppMale = pp;
		else								ppMale.unionWith(pp);
		
		if (nSide == 0 && i > 0 && abs(dAngle)>0)continue; // consider only the first stud when angled male connection
		pp = PlaneProfile(csPlan);
		pp.unionWith(bd.shadowProfile(Plane(_Pt0, vecY0)));
		pp.shrink(-dEps);//pp.vis(i);
		if (ppMalePlan.area()<pow(dEps,2))	ppMalePlan = pp;
		else								ppMalePlan.unionWith(pp);		
		
	}//next i
	ppMalePlan.shrink(dEps);
	//ppMalePlan.vis(32);
	
	//if (bDebug) { ppMale.transformBy(vecZ1 * U(10)); 	ppMale.vis(1); 	ppMale.transformBy(-vecZ1 * U(10)); }
	
	PlaneProfile ppCommon = ppMale;
	ppCommon.intersectWith(ppFemale);
	ppCommon.shrink(U(5));
	ppCommon.shrink(-U(5));
	ppCommon.vis(3);	

	LineSeg segCommon = ppCommon.extentInDir(vecXC);
	segCommon.vis(3);
	ptRef += vecXC * vecXC.dotProduct(segCommon.ptMid() - ptRef);
	if (ppCommon.area()>pow(dEps,2))
		_Pt0 = ptRef + vecYC * vecYC.dotProduct(_Pt0 - ptRef);
	Line lnRef(_Pt0+vecXC*dAxisOffset, vecZC);	//lnRef.vis(6);
	vecXC.vis(ptRef, 1);	vecYC.vis(ptRef, 3);	vecZC.vis(ptRef, 150);
	
// get weatherline/inner side
	Vector3d vecC0 = vecX0;
	if (vecC0.dotProduct(ptAxis - seg0.ptMid()) < 0)vecC0 *= -1; //vecC0.vis(ptAxis, 1);
	Vector3d vecC1 = vecX1;
	if (vecC1.dotProduct(ptAxis - seg1.ptMid()) < 0)vecC1 *= -1; //vecC1.vis(ptAxis, 2);
	
	Vector3d vecM = vecC0 + vecC1; vecM.normalize();
	vecM.vis(ptAxis, 4);
	int bIsConvex = bIsLConnection && vecM.dotProduct(vecZ0) > 0;
	
	
	
	Vector3d vecInner = -vecZ0;
	if (vecC1.dotProduct(vecInner) > 0)vecInner *= -1;
	if (dAngle<0)vecInner *= -1;

//End get common range//endregion 



//End Part #3 //endregion

//region Mode 1 blocking/default connection distribution
	if (nMode == 1)
	{
		if (males.length()<1 ||females.length()<1)
		{ 
			Display dp(1);
			dp.textHeight(U(30));
			dp.draw(scriptName() + T("\\P|waiting for beam construction|"), ptAxis, vecZC, vecXC,-1,0, _kDevice);
			return;
		}
		
		
		
		
		// 10 = Blocking, 26 = BlockingSF
		// if blocking types are foud create an instance with a subset for each
		
		Beam maleBlockings[0];
		Beam femaleBlockings[0];
		
		for (int i=0;i<males.length();i++) 
		{ 
			Beam& b = males[i];
			if (!b.vecX().isParallelTo(vecY0))continue;
			int n = b.type();
			if (n==10 || n == 26)maleBlockings.append(b);
			//b.realBody().vis(b.type());			 
		}//next i		
		
		for (int i=0;i<females.length();i++) 
		{ 
			Beam& b = females[i];
			if (!b.vecX().isParallelTo(vecY0))continue;
			int n = b.type();
			if (n==10 || n == 26)femaleBlockings.append(b);
			//b.realBody().vis(b.type());			 
		}//next i	
		
		
		Beam blockings[0]; blockings=femaleBlockings.length() > 0 ? femaleBlockings : maleBlockings;
		if (blockings.length()>0)
		{ 
		// create TSL
			TslInst tslNew;
			Entity entsTsl[] = {};		Point3d ptsTsl[1];		
			int nProps[]={};			double dProps[]={dAxisOffset,dAngle, dOffsetBottom,dOffsetTop,dOffsetBetween, dDiameter, dDepth};				String sProps[]={sManufacturer,sFamily,sProduct,sMode,sDistribution, sSide};
			Map mapTsl;	
			mapTsl.setInt("mode", 2);
			
			entsTsl.append(elMale);
			entsTsl.append(elFemale);
			
			
		// loop blockings
			for (int i=blockings.length()-1; i>=0 ; i--) 
			{ 	
				if (i > blockings.length() - 1)continue;
				Beam& b = blockings[i];
				
				GenBeam gbsTsl[0];
				mapTsl.setEntity("blocking", b);
				
			// collect any beam within blocking range
				Body bdTest(b.ptCen(), b.vecX(), b.vecY(), b.vecZ(), b.solidLength(), U(10e2), U(10e2), 0, 0, 0);
				bdTest.vis(4);

				Beam beams[0];
				beams = bdTest.filterGenBeamsIntersect(males);
				for (int j=0;j<beams.length();j++) 
					gbsTsl.append(beams[j]); 		
				beams = bdTest.filterGenBeamsIntersect(females);
				for (int j=0;j<beams.length();j++) 
					gbsTsl.append(beams[j]); 
					
				ptsTsl[0] = _Pt0;
				ptsTsl[0] += vecY0 * vecY0.dotProduct(blockings[i].ptCen() - ptsTsl[0]);

			// remove any blocking found in gbsTsl
				for (int j=0;j<gbsTsl.length();j++) 
				{ 
					int n = blockings.find(gbsTsl[j]);
					if (n>-1)
						blockings.removeAt(n);
					 
				}//next j

			// create new instance
				if (gbsTsl.length()>1)
					tslNew.dbCreate(scriptName() , vecXC ,vecYC,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl); 
			}//next i

			if (bDebug)reportMessage("\nerasing blocking mode");
			eraseInstance();
			return;
		}
	// no blockings found: distribute over entire common range	
		else
		{
			nMode = 2;
			_Map.setInt("mode", nMode);
		}

	}
//End Mode 1 //endregion

//region Mode 2 connection distribution
	if (nMode == 2)
	{



	// Trigger FlipFace//region
		String sTriggerFlipFace = T("|Flip Face|");
		if (abs(dAngle)>0)addRecalcTrigger(_kContextRoot, sTriggerFlipFace );
		if (_bOnRecalc && (_kExecuteKey==sTriggerFlipFace || _kExecuteKey==sDoubleClick))
		{
			dAngle.set(dAngle *- 1);
			setExecutionLoops(2);
			return;
		}//endregion	
	
		//setOPMKey(sManufacturer);
		assignToElementGroup(_Element[nSide], true, 0, 'E');
		setCompareKey((String)sManufacturer+sFamily+sProduct);
		if(url!="")_ThisInst.setHyperlink(url);

	// check if a valid blocking reference can be found
		Entity entBlocking = _Map.getEntity("blocking");
		if (entBlocking.bIsValid())
		{
			int n = _Beam.find(entBlocking);
			if (n>-1)
			{ 
				PlaneProfile pp(CoordSys(ptRef, vecXC, vecYC, vecZC));
				pp.unionWith(_Beam[n].envelopeBody(false, true).shadowProfile(pnRef));
				LineSeg seg = pp.extentInDir(vecXC);
				seg = LineSeg(seg.ptStart() - vecXC * U(10e3), seg.ptEnd() + vecXC * U(10e3));
				pp.createRectangle(seg, vecXC, vecYC);//pp.vis(4);
				ppCommon.intersectWith(pp);
				ppCommon.vis(6);
			}
		}
		LineSeg segCommon = ppCommon.extentInDir(vecY0);
		ptAxis += vecY0 * vecY0.dotProduct(segCommon.ptMid() - ptAxis);ptAxis.vis(2);
		
		_Pt0 = ptAxis;
		
		
		
		Point3d ptStart = ptAxis + vecXC * dAxisOffset;
		Point3d ptEnd = ptAxis + vecXC * dAxisOffset;
		Vector3d vecDir = (nSide == 0?1:-1)*vecZC;
		
		PlaneProfile ppPlanStart(CoordSys(ptAxis, vecZC, vecXC, vecYC));
		ppPlanStart.unionWith(nSide==0?ppMalePlan : ppFemalePlan);		//ppPlanStart.vis(1);
		PlaneProfile ppPlanEnd(CoordSys(ptAxis, vecZC, vecXC, vecYC));
		ppPlanEnd.unionWith(ppMalePlan);
		ppPlanEnd.unionWith(ppFemalePlan); 								//ppPlanEnd.vis(2);

		if (abs(dAngle)>dEps)
		{ 
			double dX = ppPlanStart.dX();
			double dZ = ppPlanStart.dY();
			ptStart = ppPlanStart.ptMid()+ vecInner * .5 * dZ;
			ptStart += -vecDir * .5 * dX;
			if (nSide==0)ptStart += -vecDir * dAxisOffset;
			
			CoordSys csRot;
			double angle = dAngle *(nSide==0?1:-1);			
			if (vecC1.dotProduct(vecXC) < 0)
				angle *= -1;
			
			csRot.setToRotation(angle, vecY0, ptStart);
			vecDir.transformBy(csRot);			
			//vecDir.vis(ptStart, 2);
	
		}
		else
		{ 
			Point3d pts[] = ppPlanStart.intersectPoints(Plane(ptStart, vecDir.crossProduct(vecY0)), true, false);
			pts = Line(ptStart, vecDir).orderPoints(pts, dEps);
			if (pts.length()>0)	ptStart = pts.first();
		}
		
		Point3d pts[] = ppPlanEnd.intersectPoints(Plane(ptStart, vecDir.crossProduct(vecY0)), true, false);
		pts = Line(ptStart, vecDir).orderPoints(pts, dEps);
		if (pts.length()>0)	ptEnd = pts.last();
		vecDir.vis(ptStart, 2);
//		ptStart.vis(4);
//		ptEnd.vis(4);
	
	// get product
		double dMaxLength = Vector3d(ptEnd - ptStart).length();
		int bSunken = dLengthHead > 0 && dDiameterHead > 0 && dDiameterHead / dDiameterThread < 1.5;

		int nThisProduct = -1;
		if (nProduct<1) // best fit
		{ 
			for (int i = 0; i < mapProducts.length(); i++)
			{
				Map m = mapProducts.getMap(i);
				double length = m.getDouble("Length");

				if (dLengthThread<=0 || dMaxLength>= length +(bSunken?dLengthHead:0))
				{ 
					dLengthThread = length;
					nThisProduct = i;
				}
			}			
		}
		else
		{ 
			nThisProduct = nProduct-1;
			
		}

		Map m = mapProducts.getMap(nThisProduct);
		
		dLengthThread = m.getDouble("Length");
		articleNumber= m.getString("ArticleNumber");
		String description = m.getString("Description");
		int nc = m.hasInt("Color")?m.getInt("Color"):254;
	
		
	
	// Distribute
		double dYRange = abs(vecY0.dotProduct(segCommon.ptEnd() - segCommon.ptStart()));
		double dYCommon = dYRange-dOffsetBottom - dOffsetTop;
		
		int nDistribution = sDistributions.find(sDistribution, 0); // 0 = fixed, 1 = even
		double dInterdistance = dOffsetBetween;
		int nNumDrill = 1;
		if (dYCommon>dEps)
		{ 
			if (nDistribution==0 & dInterdistance>0)
				nNumDrill = dYCommon / dInterdistance;
			else if (dInterdistance>0)
			{
				nNumDrill = (dYCommon / dInterdistance)+.99;
				dInterdistance = dYCommon / nNumDrill;
			}
			nNumDrill++;
		}
		
		Point3d ptX = ptStart;
	// Distribute	
		if (nNumDrill == 1)
			dInterdistance = 0;
		else
			ptX-= vecY0 * (.5 * dYRange  -dOffsetBottom);
		
	// build body, if head is fairly small consider head to be sunken in
		double dThisLength = dLengthThread + (bSunken?dLengthHead:0);
		Body bd(ptX, ptX + vecDir * dLengthThread, dDiameterThread * .5);
		if (dLengthHead>0 && dDiameterHead>0)
		{ 
			Body bdHead(ptX, ptX - vecDir * dLengthHead, dDiameterHead * .5);
			bd.combine(bdHead);
		}
		if (bSunken)bd.transformBy(vecDir * dLengthHead);
		
		Display dpModel(dMaxLength<dThisLength?(nc==1?6:1):nc);
		dpModel.elemZone(_Element[nSide], 0, 'I');
		
	// Drill
		double radius = (dDiameter==0?dDiameterThread:dDiameter)*.5;
		if (dDiameter < 0)radius = (dDiameterThread + abs(dDiameter))*.5;
		double dDrillDepth = dDepth;
		if (dDepth < 0)dDrillDepth = dThisLength + dDepth;
		Drill drill(ptX - vecDir * dDiameterThread, ptX + vecDir * dDrillDepth,radius );			
				
		for (int i=0;i<nNumDrill;i++) 
		{ 
			dpModel.draw(bd);
			ptX.vis(i);
			ptX += vecY0 * dInterdistance;
			bd.transformBy(vecY0 * dInterdistance);
			
			if (radius)
			{ 
				drill.addMeToGenBeamsIntersect(_Beam);
				drill.transformBy(vecY0 * dInterdistance);
			}
			
		}//next i

	// Hardware//region
	// collect existing hardware
		HardWrComp hwcs[] = _ThisInst.hardWrComps();
		
	// remove any tsl repType: the assumption is that any hardware component of type _kRTTsl has been attached by this instance
		for (int i=hwcs.length()-1; i>=0 ; i--) 
			if (hwcs[i].repType() == _kRTTsl)
				hwcs.removeAt(i); 

		
	// add componnents
		{ 
			HardWrComp hwc(articleNumber, nNumDrill); // the articleNumber and the quantity is mandatory
			
			hwc.setManufacturer(sManufacturer);
			
			hwc.setModel(sFamily);
			hwc.setName(description);
			hwc.setDescription(description);
			hwc.setMaterial(material);
			hwc.setNotes(_ThisInst.notes());
			
			hwc.setGroup(_Element[nSide].elementGroup().name());
			hwc.setCategory(T("|Fixture|"));
			hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
			
			hwc.setDScaleX(dLengthThread);
			hwc.setDScaleY(dDiameterThread);
			hwc.setDScaleZ(0);
			
		// apppend component to the list of components
			hwcs.append(hwc);
		}
	
	
	
	// make sure the hardware is updated
		if (_bOnDbCreated)	setExecutionLoops(2);				
		_ThisInst.setHardWrComps(hwcs);	
	//endregion

	}
//End Mode 2 //endregion

//region Part #4 Triggers
{
	// declare for TSL cloning
	TslInst tslDialog;			Map mapTsl;
	GenBeam gbsTsl[] = { };		Entity entsTsl[] = { };			Point3d ptsTsl[] = { _Pt0};
	int nProps[] ={ };			double dProps[] ={ };			String sProps[] ={ };
	
	
// check if matching rule has been set
	int nIsRuleMatch=-1; // returns the map index of the rule
	{ 
		String k;
		int bMatch;
		for (int a=0;a<mapRules.length();a++) 
		{ 
			Map m= mapRules.getMap(a);
			if (m.length() < 1)continue;
			k = "byManufacturer"; 
			if (m.hasInt(k))
			{ 
				int n = m.getInt(k);
				bMatch = !n || (n && m.getString("Manufacturer") == sManufacturer);
				if (bDebug)reportNotice("\nmanufact match " + bMatch);
				if (!bMatch)continue;
			}
			k = "byFamily"; 
			if (m.hasInt(k))
			{ 
				int n = m.getInt(k);
				bMatch = !n || (n && m.getString("Family") == sFamily);
				if (bDebug)reportNotice("\nfamily match " + bMatch);
				if (!bMatch)continue;
			}						
			k = "byProduct"; 
			if (m.hasInt(k))
			{ 
				int n = m.getInt(k);
				bMatch = !n || (n && m.getString("Product") == sProduct);
				if (bDebug)reportNotice("\nproduct match " + bMatch);
				if (!bMatch)continue;
			}
			 
			k = "isTConnection"; 		if (m.hasInt(k) && m.getInt(k) != bIsTConnection)		{if (bDebug)reportNotice("\n" + k + " failed");continue;}
			k = "isLConnection"; 		if (m.hasInt(k) && m.getInt(k) != bIsLConnection)		{if (bDebug)reportNotice("\n" + k + " failed");continue;}
			k = "isParallelConnection"; if (m.hasInt(k) && m.getInt(k) != bIsParallelConnection){if (bDebug)reportNotice("\n" + k + " failed");continue;}
			k = "isMitreConnection"; 	if (m.hasInt(k) && m.getInt(k) != bIsMitreConnection)	{if (bDebug)reportNotice("\n" + k + " failed");continue;}
			k = "isConvex"; 			if (m.hasInt(k) && m.getInt(k) != bIsConvex)			{if (bDebug)reportNotice("\n" + k + " failed");continue;}
			k = "isMaleExposed"; 		if (m.hasInt(k) && m.getInt(k) != bExposed0)			{if (bDebug)reportNotice("\n" + k + " failed");continue;}
			k = "isFemaleExposed"; 		if (m.hasInt(k) && m.getInt(k) != bExposed1)			{if (bDebug)reportNotice("\n" + k + " failed");continue;}
			
			nIsRuleMatch = a;
			break;  
		}//next a
	}

	
	
//region Trigger SetRule
	String sTriggerSetRule = T("|Set Rule|");
	addRecalcTrigger(_kContextRoot, sTriggerSetRule );
	if (_bOnRecalc && _kExecuteKey==sTriggerSetRule)
	{
	// prepare dialog instance
		mapTsl.setInt("DialogMode", 1);
		mapTsl.setString("manufacturer", sManufacturer);
		mapTsl.setString("family", sFamily);
		mapTsl.setString("product", sProduct);
		tslDialog.dbCreate(scriptName() , _XW, _YW, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);		
		if (tslDialog.bIsValid())
		{
			int bOk = tslDialog.showDialog();			
			if (bOk)
			{	
				int bByManufacturer = tslDialog.propString(0) == sManufacturer;
				int bByFamily = tslDialog.propString(1) == sFamily;
				int bByProduct = tslDialog.propString(2) == sProduct;
				
				Map m;
				m.setInt("byManufacturer", bByManufacturer);
				if  (bByManufacturer)m.setString("Manufacturer", sManufacturer);
				m.setInt("byFamily", bByFamily);
				if  (bByFamily)m.setString("Family", sFamily);
				m.setInt("byProduct", bByProduct);
				if  (bByProduct)m.setString("Product", sProduct);
				m.setInt("isTConnection", bIsTConnection);
				m.setInt("isLConnection", bIsLConnection);
				m.setInt("isParallelConnection", bIsParallelConnection);
				m.setInt("isMitreConnection", bIsMitreConnection);
				m.setInt("isConvex", bIsConvex);
				m.setInt("isMaleExposed", bExposed0);
				m.setInt("isFemaleExposed", bExposed1);
				m.setMap("Property[]", _ThisInst.mapWithPropValues());
				
				
				Map mapTemp;
				for (int i=0;i<mapRules.length();i++) 
				{ 
					Map m = mapRules.getMap(i);
					if (i!=nIsRuleMatch && m.length()>0)
						mapTemp.appendMap("Rule", m);
				}
				mapTemp.appendMap("Rule", m);
				mapRules = mapTemp;

				mapSetting2.setMap("Rule[]", mapRules);
				if (mo2.bIsValid())mo2.setMap(mapSetting2);
				else mo2.dbCreate(mapSetting2);
			}
			tslDialog.dbErase();
		}

		setExecutionLoops(2);
		return;
	}
//endregion	

//region Trigger DeleteRule
	String sTriggerDeleteRule = T("|Delete Rule|");
	if (nIsRuleMatch>-1)addRecalcTrigger(_kContextRoot, sTriggerDeleteRule );
	if (_bOnRecalc && _kExecuteKey==sTriggerDeleteRule)
	{
		Map mapTemp;
		for (int i=0;i<mapRules.length();i++) 
		{ 
			Map m = mapRules.getMap(i);
			if (i!=nIsRuleMatch && m.length()>0)
				mapTemp.appendMap("Rule", m);
		}
		mapRules = mapTemp;
		mapSetting2.setMap("Rule[]", mapRules);
		if (mo2.bIsValid())mo2.setMap(mapSetting2);
		else mo2.dbCreate(mapSetting2);
		setExecutionLoops(2);
		return;
	}//endregion	




//region Trigger ExportSettings
	if (mapSetting2.length() > 0)
	{
		String sTriggerExportSettings = T("|Export Settings|");
		addRecalcTrigger(_kContext, sTriggerExportSettings );
		if (_bOnRecalc && _kExecuteKey == sTriggerExportSettings)
		{
			int bWrite;
			if (findFile(sFullPath2).length()>0)
			{ 
				String sInput = getString(T("|Are you sure to overwrite existing settings?|") + " [" + T("|No|") +"/"+T("|Yes|")+"]").left(1);
				bWrite = sInput.makeUpper() == T("|Yes|").makeUpper().left(1);
			}
			else
				bWrite = true;
				
			if (bWrite && mapSetting2.length() > 0)
			{ 
				if (mo2.bIsValid())mo2.setMap(mapSetting2);
				else mo2.dbCreate(mapSetting2);
				
			// make sure the path exists	//HSB-10750
				int bPathFound= sFolders.find(sFolder)>-1?true:makeFolder(sPath+"\\"+sFolder);	
				
			// write file	
				mapSetting2.writeToXmlFile(sFullPath2);
				
			// report rsult of writing	
				if (findFile(sFullPath2).length()>0)
					reportMessage(TN("|Settings successfully exported to| ") + sFullPath2);
				else
					reportMessage(TN("|Failed to write to| ") + sFullPath2);
				
			}
			
			setExecutionLoops(2);
			return;
		}
	}

//endregion 

	
}
//endregion 

	if (0)
	{ 
		Display dp(nMode);
		dp.textHeight(U(20));
		String text;
		text += scriptName();
		text += "\\P bIsTConnection: " + bIsTConnection;
		text += "\\P bIsLConnection: " + bIsLConnection;
		text += "\\P bIsParallelConnection: " + bIsParallelConnection;
		text += "\\P bIsMitreConnection: " + bIsMitreConnection;
		text += "\\P bIsConvex: " + bIsConvex;		
		text += "\\P Male exposed: " + bExposed0;
		text += "\\P Female exposed: " + bExposed1;
		text += "\\P Side: " + nSide;
		
		
		dp.draw(text, _Pt0+vecXC * U(200), vecXC, vecZC, 1, 0,_kDevice);
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
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="1356" />
        <int nm="BreakPoint" vl="1370" />
        <int nm="BreakPoint" vl="1372" />
        <int nm="BreakPoint" vl="986" />
        <int nm="BreakPoint" vl="1704" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12680 bugfix detecting potential connections" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="12/1/2021 12:31:56 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12680 initial version" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="8/19/2021 3:54:24 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End