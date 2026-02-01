#Version 8
#BeginDescription
This tsl reads excel files to import angle bracket data


#Versions:
Version 1.3 11.11.2025 HSB-24891: Fix when running hsbExcelToMap , Author: Marsel Nakuci
V1.2 3/16/2023 Added findFile(sLastPath) safety  cc
1.1 07.10.2022 HSB-15990: Support family description Author: Marsel Nakuci
1.0 08.09.2022 HSB-15990: Initial Author: Marsel Nakuci







#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
#KeyWords Angle, Bracket,GA, Excel,Import,XML
#BeginContents
//region <History>
/*
// #Versions
// 1.3 11.11.2025 HSB-24891: Fix when running hsbExcelToMap , Author: Marsel Nakuci
// 1.2 3/16/2023 Added findFile(sLastPath) safety  cc
// 1.1 07.10.2022 HSB-15990: Support family description Author: Marsel Nakuci
// 1.0 08.09.2022 HSB-15990: Initial Author: Marsel Nakuci

/// <insert Lang=en>
/// Select xlsx file
/// </insert>

// <summary Lang=en>
// This tsl reads excel files to import angle bracket data 
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "GenericAngleExcelImporter")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|RecalcKey|") (_TM "|UserPrompt|"))) TSLCONTENT
*/
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
	
	//region Function GetHsbVersionNumber
	// returns the main version number 27,28, 29..., 0 if it fails
	int GetHsbVersionNumber()
	{ 		
		String oeVersion = hsbOEVersion().makeUpper();
	
		int hsbVersion;
		
		int n1 = oeVersion.find("(",0, false)+1;
		int n2 = oeVersion.find(")", n1+1, false)-1;
		String mid = oeVersion.mid(n1, n2 - n1+1);
		mid.replace("BUILD ", "");
		String tokens[] = mid.tokenize(",");
		if (tokens.length()>0)
			hsbVersion = tokens.first().atoi();
	
		return hsbVersion;
	}//endregion
	
	int nVersionNumber = GetHsbVersionNumber();
	String strAssemblyPath = _kPathHsbInstall + "\\Utilities\\hsbExcelToMap\\hsbExcelToMap"+ (nVersionNumber>=28?".dll":".exe");
	String strType = "hsbCad.hsbExcelToMap.HsbCadIO";
	String strFunction = "ExcelToMap";
	Map mapIn;	
	
	// map keys
	String kProduct= "Product",kProducts= "Product[]"; 
	String kFamily = "Family", kFamilies = "Family[]";
	String kFamilyDescription="FamilyDescription";
//	String kMinWidthJoist = "Joist\\MinWidth", kMaxWidthJoist="Joist\\MaxWidth", kMinHeightJoist="Joist\\MinHeight", kMaxHeightJoist="Joist\\MaxHeight";
//	String kMinAlpha= "MinAlpha", kMaxAlpha="MaxAlpha", kAlpha = "Alpha";
//	String kAdjustableHeight = "Adjustable Height Strap";
	
//	String kBlock = "Block", kBlocks = "Block[]",kFixture = "Fixture", kFixtures = "Fixture[]", kNumHeaderFull="Header", kNumJoistFull="Joist", kNumHeaderPartial="Header Partial", kNumJoistPartial="Joist Partial";
	String kEmpty = "Empty";
	String kGeneric = "GenericAngle_";
	String kAll = T("<|All Sheets|>");
	
	String kArticle = "ArticleNumber", kManufacturer = "Manufacturer";
	
	// hardware keys
	String kName = "Name", kScaleX = "ScaleX", kScaleY = "ScaleY", kScaleZ = "ScaleZ", kQuantity = "Quantity", kNotes = "Notes", kCategory = "Category",
		kMaterial = "Material", kGroup = "Group", kModel = "Model", kDescription = "Description", kHardWrComp = "HardWrComp",kHardWrComps = "HardWrComp[]";
//end Constants//endregion
	
	
//region Properties
	String sLastPathName=T("|Path|");	
	PropString sLastPath(nStringIndex++, "", sLastPathName);	
	sLastPath.setDescription(T("|Defines the last used path|"));
	sLastPath.setCategory(category);	
	sLastPath.setReadOnly(_kHidden);
	
	String sImportName=T("|Sheet Import|");
	String sImports[0];
	PropString sImport(nStringIndex++, sImports, sImportName);	
	sImport.setDescription(T("|Defines the Import|"));
	sImport.setCategory(category);
	
	String sImportModes[] = { T("|Drawing|"),  T("|Drawing + Company XML|")};
	String sImportModeName=T("|Import Mode|");	
	PropString sImportMode(nStringIndex++, sImportModes, sImportModeName);	
	sImportMode.setDescription(T("|Defines the ImportMode|"));
	sImportMode.setCategory(category);
//End Properties//endregion 
	
//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sPathGeneral = _kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\";	
	String sPathCompany = sPath+"\\"+sFolder+"\\";
	String sFileName ="GA";
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
	
//region get preselected manufacturers from the mapSetting
	String sManufacturers[0];
	Map mapManufacturers = mapSetting.getMap("Manufacturer[]");
	{ 
		// get the models of this family and populate the property list		
		for (int i = 0; i < mapManufacturers.length(); i++)
		{
			if (mapManufacturers.keyAt(i).makeLower() != "manufacturer"){ continue;}
			String name = mapManufacturers.getMap(i).getMapName();
			if (name.length()>0 && sManufacturers.findNoCase(name,-1) < 0)
				sManufacturers.append(name);
		}
	}
//End get sManufacturers from the mapSetting//endregion
//End Settings//endregion

//region bOnInsert
	if (_bOnInsert)
	{
		if (insertCycleCount() > 1) { eraseInstance(); return; }
		
		setPropValuesFromCatalog(sLastInserted);
		
 		//__if file does not exist, blank string is passed in mimiccing first run
 		//__if file exists then the path is set to mapIn
		mapIn.setString("LastAccessedFilePath", findFile(sLastPath));

		

		_Map = callDotNetFunction2( strAssemblyPath, strType, strFunction , mapIn);
		String filepath = _Map.getString("LastAccessedFilePath");
		if (filepath != "")
		{
			sLastPath.set(filepath);
			setCatalogFromPropValues(sLastInserted);
		}
	}
//endregion	

//region Get Sheets	
	Map mapSheets = _Map.getMap("Sheets");
//	Map mapSheetFixtures = mapSheets.getMap(kFixture);
	
	for (int i=0;i<mapSheets.length();i++) 
	{ 
	// exclude tagged sheet names	
		String name = mapSheets.keyAt(i);
		if (name.find(kEmpty,0,false)>-1 && kEmpty.length()==name.length())
		{ 
			continue;
		}
//		else if (name.find(kFixture,0,false)>-1 && kFixture.length()==name.length())
//		{ 
//			continue;
//		}
		
	// verify content
		Map mapSheet = mapSheets.getMap(i);
		Map row= mapSheet.getMap(0);
		if (row.length()<1) { continue;}
		
		if (!row.hasString(kManufacturer) || !row.hasString(kFamily) || !row.hasString(kArticle))
		{ 
			continue;
		}			
		
		sImports.append(name);
		 
	}//next i
	sImports = sImports.sorted();
	
	if (sImports.length()<1)
	{ 
		reportNotice("\n*** " + scriptName() + " ***\n" + T("|Could not find any data in|\n") + sLastPathName);
		eraseInstance();
		return;
	}	
	sImports.insertAt(0, kAll);
	sImport = PropString(1, sImports, sImportName);	

//endregion

//region bOnInsert
	if (_bOnInsert)
	{ 
		showDialog();
		return;
	}	
// end on insert	__________________//endregion

// declare new 
	int nImportMode = sImportModes.find(sImportMode);
	if (nImportMode<0){ sImportMode.set(sImportModes[0]); nImportMode=0;}
//	Map mapFamilies;

// get common data sheet
	
	String k;

// collect fixture data
	
	String fixtureArticles[0];
	Map mapFixtures;
//	for (int j=0;j<mapSheetFixtures.length();j++) 
//	{ 
//		Map row= mapSheetFixtures.getMap(j);
//		Map m = row;
//		
//		String manufacturer;	if (m.hasString(kManufacturer))	manufacturer = m.getString(kManufacturer);
//		String articleNumber;	
//		if (m.hasString(kArticle)) 		
//			articleNumber = m.getString(kArticle);
//		else if (m.hasDouble(kArticle)) 		
//			articleNumber = m.getDouble(kArticle);			
//		if (manufacturer.length()<1 || articleNumber.length()<1){ continue;}
//
//		m.setMapName(articleNumber);
//		
//		// remove empty entries
//		for (int j=m.length()-1; j>=0 ; j--) 
//		{ 
//			if (m.hasString(j) && m.getString(j).length()<1)
//				m.removeAt(j, true); 
//			
//		}//next j
//
//		if (fixtureArticles.findNoCase(articleNumber,-1)<0)
//		{ 
//			mapFixtures.appendMap(kFixture, m);
//			fixtureArticles.append(articleNumber);
//		}
//	}//next j
	
// find manufacturer sheets
	int bUpdate;
	String sUpdateEntries[0];
	int numFamily, numProduct;
	
	for (int f=0;f<mapSheets.length();f++) 
	{ 
		Map mapSheet = mapSheets.getMap(f);
		Map m = mapSheet;
		
		String sheetName = mapSheets.keyAt(f);
//		if (sheetName.find(kFixture,0, false)>-1 && sheetName.length()==kFixture.length()){ continue;}
		if (sheetName.find(kEmpty,0, false)>-1 && sheetName.length()==kEmpty.length()){ continue;}
		if (sImport!=kAll && sheetName!= sImport){ continue;}
		
		String manufacturer, material, url;
	// collect product data
		for (int j=0;j<mapSheet.length();j++) 
		{ 
			Map row= mapSheet.getMap(j);
			String familyName; 		  k =kFamily;		if (row.hasString(k))familyName = row.getString(k);
			String familyDescription; k =kFamilyDescription;		if (row.hasString(k))familyDescription = row.getString(k);
			String articleNumber; 	  k =kArticle;	if (row.hasString(k))articleNumber = row.getString(k);			
			String err;
			if (familyName.length()<1)
			{ 
				err +=T(" |Required family name missing.|");
			}
			if (articleNumber.length()<1)
			{ 
				err +=T(" |Required articlenumber missing.|");
			}
			if (err.length()>0)
			{ 
				reportNotice(TN("|Import of sheet| ") +sheetName + T(" |was not successful in row| ") + (j+1) + err);
				continue;
			}
			
			String _manufacturer; 	k =kManufacturer;  if (row.hasString(k))_manufacturer = row.getString(k);
			String _url; 			k ="URL"; 		 	if (row.hasString(k))url = m.getString(k);
			String _material;		k =kMaterial;		if (row.hasString(k))material = m.getString(k);

		// Manufacturer, url, material : accept one definition per group	
			if (_manufacturer.length()>0)
				manufacturer = _manufacturer;
			if (manufacturer.length()<0) { continue;}
			if (_url.length()>0)		url = _url;
			if (_material.length()>0)	material = _material;

			
		// Manufacturer	
//			Map mapIn, mapManufacturer;			
			Map mapManufacturer;
			mapIn = Map();
			//String entries[] = MapObject().getAllEntryNames(sDictionary);
			String entryName = kGeneric + sheetName;
			MapObject mob(sDictionary, entryName);
		
			if (mob.bIsValid())
			{
				mapIn = mob.map();
				mapManufacturer=mapIn.getMap(kManufacturer);
			}
			
		// family	
			Map mapFamily,mapFamilies = mapManufacturer.getMap("Family[]");
			for (int i=0;i<mapFamilies.length();i++) 
			{ 
				Map m = mapFamilies.getMap(i);
				String _familyName = m.getMapName(); 
				if (familyName.find(_familyName,0, false)>-1 && familyName.length()==_familyName.length())
				{ 
					mapFamily = m;
					mapFamilies.removeAt(i, true);
					break;
				}
			}//next i
			
		// Product		
			Map mapProduct,mapProducts = mapFamily.getMap(kProducts);
			for (int i=0;i<mapProducts.length();i++) 
			{ 
				Map m = mapProducts.getMap(i);
				String _productName = m.getMapName(); 
				if (articleNumber.find(_productName,0, false)>-1 && articleNumber.length()==_productName.length())
				{ 
					//mapProduct = m;
					mapProducts.removeAt(i, true);
					break;
				}
			}//next i			

//
			mapProduct.setMapName(articleNumber);
			
			k ="A";  if (row.hasDouble(k))mapProduct.setDouble(k,row.getDouble(k));
			k ="B";  if (row.hasDouble(k))mapProduct.setDouble(k,row.getDouble(k));
			k ="C";  if (row.hasDouble(k))mapProduct.setDouble(k,row.getDouble(k));
			k ="D";  if (row.hasDouble(k))mapProduct.setDouble(k,row.getDouble(k));
			k ="E";  if (row.hasDouble(k))mapProduct.setDouble(k,row.getDouble(k));
			k ="F";  if (row.hasDouble(k))mapProduct.setDouble(k,row.getDouble(k));
			k ="G";  if (row.hasDouble(k))mapProduct.setDouble(k,row.getDouble(k));
			k ="H";  if (row.hasDouble(k))mapProduct.setDouble(k,row.getDouble(k));
			k ="I";  if (row.hasDouble(k))mapProduct.setDouble(k,row.getDouble(k));
			k ="J";  if (row.hasDouble(k))mapProduct.setDouble(k,row.getDouble(k));
			k ="K";  if (row.hasDouble(k))mapProduct.setDouble(k,row.getDouble(k));
			k ="L";  if (row.hasDouble(k))mapProduct.setDouble(k,row.getDouble(k));
			k ="M";  if (row.hasDouble(k))mapProduct.setDouble(k,row.getDouble(k));
			k ="N";  if (row.hasDouble(k))mapProduct.setDouble(k,row.getDouble(k));
			k ="O";  if (row.hasDouble(k))mapProduct.setDouble(k,row.getDouble(k));
			k ="P";  if (row.hasDouble(k))mapProduct.setDouble(k,row.getDouble(k));
			
			k ="t";  if (row.hasDouble(k))mapProduct.setDouble(k,row.getDouble(k));
			
			//
			Map mapNails,mapNail, mapDiameters,mapDiameter;
			mapNails.setMapKey("Nail[]");
			mapNail.setMapKey("Nail");
			if(row.hasString("Nail1") && row.getString("Nail1")!="")
			{ 
				k ="Nail1";  if (row.hasString(k))mapNail.setString("Name",row.getString(k));
				mapNails.appendMap("Nail",mapNail);
				mapNail = Map();mapNail.setMapKey("Nail");
			}
			
			if(row.hasString("Nail2") && row.getString("Nail2")!="")
			{ 
				k ="Nail2";  if (row.hasString(k))mapNail.setString("Name",row.getString(k));
				mapNails.appendMap("Nail",mapNail);
				mapNail = Map();mapNail.setMapKey("Nail");
			}
			if(row.hasString("Nail3") && row.getString("Nail3")!="")
			{ 
				k ="Nail3";  if (row.hasString(k))mapNail.setString("Name",row.getString(k));
				mapNails.appendMap("Nail",mapNail);
				mapNail = Map();mapNail.setMapKey("Nail");
			}
			if(row.hasString("Nail4") && row.getString("Nail4")!="")
			{ 
				k ="Nail4";  if (row.hasString(k))mapNail.setString("Name",row.getString(k));
				mapNails.appendMap("Nail",mapNail);
				mapNail = Map();mapNail.setMapKey("Nail");
			}
			if(mapNails.length()>0)
				mapFamily.setMap("Nail[]",mapNails);
			// diameters
			mapDiameters.setMapKey("DiamType[]");
			mapDiameter.setMapKey("DiamType");
			if(row.hasDouble("Diameter1") && row.hasDouble("Number1") 
			&& row.getDouble("Diameter1")!=0 && row.getDouble("Number1")!=0)
			{ 
				k ="Diameter1";  if (row.hasDouble(k))mapDiameter.setDouble("Diameter",row.getDouble(k));
				k ="Number1";  if (row.hasDouble(k))mapDiameter.setInt("Number",int(row.getDouble(k)));
				mapDiameters.appendMap("DiamType",mapDiameter);
				mapDiameter = Map();mapDiameter.setMapKey("DiamType");
			}
			if(row.hasDouble("Diameter2") && row.hasDouble("Number2")
			&& row.getDouble("Diameter2")!=0 && row.getDouble("Number2")!=0)
			{ 
				k ="Diameter2";  if (row.hasDouble(k))mapDiameter.setDouble("Diameter",row.getDouble(k));
				k ="Number2";  if (row.hasDouble(k))mapDiameter.setInt("Number",int(row.getDouble(k)));
				mapDiameters.appendMap("DiamType",mapDiameter);
				mapDiameter = Map();mapDiameter.setMapKey("DiamType");
			}
			if(row.hasDouble("Diameter3") && row.hasDouble("Number3")
			&& row.getDouble("Diameter3")!=0 && row.getDouble("Number3")!=0)
			{ 
				k ="Diameter3";  if (row.hasDouble(k))mapDiameter.setDouble("Diameter",row.getDouble(k));
				k ="Number3";  if (row.hasDouble(k))mapDiameter.setInt("Number",int(row.getDouble(k)));
				mapDiameters.appendMap("DiamType",mapDiameter);
				mapDiameter = Map();mapDiameter.setMapKey("DiamType");
			}
			if(row.hasDouble("Diameter4") && row.hasDouble("Number4")
			&& row.getDouble("Diameter4")!=0 && row.getDouble("Number4")!=0)
			{ 
				k ="Diameter4";  if (row.hasDouble(k))mapDiameter.setDouble("Diameter",row.getDouble(k));
				k ="Number4";  if (row.hasDouble(k))mapDiameter.setInt("Number",int(row.getDouble(k)));
				mapDiameters.appendMap("DiamType",mapDiameter);
				mapDiameter = Map();mapDiameter.setMapKey("DiamType");
			}
			if(mapDiameters.length()>0)
				mapProduct.setMap("DiamType[]",mapDiameters);
			
//			k ="TopFlush";  		if (row.getDouble(k)>0)	mapProduct.setInt(k,1);
//			k =kAdjustableHeight; 	if (row.getDouble(k)>0)	mapProduct.setInt(k,true);
			
			
//			k ="MinWidth";	if (row.hasDouble(k))	mapProduct.setDouble(kMinWidthJoist,row.getDouble(k));
//			k ="MaxWidth";	if (row.hasDouble(k))	mapProduct.setDouble(kMaxWidthJoist,row.getDouble(k));
//			k ="MinHeight";	if (row.hasDouble(k))	mapProduct.setDouble(kMinHeightJoist,row.getDouble(k));
//			k ="MaxHeight";	if (row.hasDouble(k))	mapProduct.setDouble(kMaxHeightJoist,row.getDouble(k));
			
//			k =kAlpha;		
//			if (row.hasString(k))	
//				mapProduct.setString(k,row.getString(k));
//			else if (row.hasDouble(k))	// if single value given in xlsx it is collected as double
//				mapProduct.setString(k,row.getDouble(k));
			
		// collect potential block overrides and its offsets, i.e. StrongTie SDE: two diffenert blocks for display
//			Map mapBlocks, mapBlock;
//			for (int i=0;i<10;i++) 
//			{
//				k =kBlock+(i+1);
//				String blockName;
//				if (row.hasString(k))blockName=row.getString(k);
//				
//				k =kBlock+"Offset"+(i+1);
//				if (row.hasDouble(k) && blockName.length()>0)
//				{
//					mapBlock.setString(kName, blockName);
//					mapBlock.setDouble("dX", row.getDouble(k));
//					mapBlocks.appendMap(kBlock, mapBlock);	
//				}
//			}	
//			if (mapBlocks.length()>0)
//				mapProduct.setMap(kBlocks, mapBlocks);	
		
		// collect up to 10 predefined fixtures
//			Map mapFixture, mapFixtureArticles;
//			for (int i=0;i<10;i++) 
//			{
//				k =kFixture+(i+1);
//				String fixture;
//				if (row.hasString(k))fixture=row.getString(k);
//				else if (row.hasDouble(k))fixture=row.getDouble(k);
//				if (fixture.length()<1){ continue;}				
//				if (fixtureArticles.findNoCase(fixture,-1)>-1)
//				{
//					mapFixtureArticles.appendString(kArticle,fixture); 
//				}
//				else 
//					reportNotice("\nkey " + k + " " + fixture + " not found in " + fixtureArticles);
//			}
//			mapFixture.setMap(kArticle+"[]", mapFixtureArticles);
//			k = kNumHeaderFull;		if (row.hasDouble(k)) { int n = row.getDouble(k); mapFixture.setInt(k, n);}
//			k = kNumJoistFull;		if (row.hasDouble(k)) { int n = row.getDouble(k); mapFixture.setInt(k, n);}
//			k = kNumHeaderPartial;	if (row.hasDouble(k)) { int n = row.getDouble(k); mapFixture.setInt(k, n);};
//			k = kNumJoistPartial;	if (row.hasDouble(k)) { int n = row.getDouble(k); mapFixture.setInt(k, n);}
//			mapProduct.setMap(kFixture, mapFixture);

			mapProducts.appendMap(kProduct, mapProduct);
			if (mapProducts.length()<1){ continue;}
			
			mapFamily.setMapName(familyName);
			mapFamily.setString(kName, familyName);// TODO get familyname column
			mapFamily.setString(kFamilyDescription, familyDescription);
			k ="url";  if (row.hasString(k))url = row.getString(k);
			if (url.length()>0)mapFamily.setString("url", url);
//			if (material.length()>0)mapFamily.setString(kMaterial, material);
			if (material.length()>0)mapManufacturer.setString(kMaterial, material);
			
			mapFamily.setMap(kProducts, mapProducts);
			mapFamilies.appendMap(kFamily, mapFamily);
	
			mapManufacturer.setMap("Family[]", mapFamilies);
//			mapManufacturer.setMap(kFixtures, mapFixtures);
			mapManufacturer.setMapName(sheetName);
			
			numProduct++;
			
			mapIn.setMap(kManufacturer, mapManufacturer);
			if (mob.bIsValid())
			{ 	
				mob.setMap(mapIn);
			}
			else
			{ 
				mob.dbCreate(mapIn);
			}
			
			if (sUpdateEntries.findNoCase(entryName,-1)<0)
				sUpdateEntries.append(entryName);
			
			//mapManufacturers.appendMap(kManufacturer, mapManufacturer);		
			//bUpdate = true;
		}// next row
	}//next sheet


//region Update settings
	reportNotice("\n\n" + scriptName() + T(" |articles imported: | ") + numProduct);
	for (int i=0;i<sUpdateEntries.length();i++) 
	{ 
		String entryName= sUpdateEntries[i]; 
		reportNotice("\n" + entryName + T("| has been updated|") );	
		String path = sPathCompany + entryName + ".xml";
		MapObject mob(sDictionary, entryName);
		Map map = mob.map();
		if (nImportMode>0 && map.length()>0 && map.hasMap(kManufacturer) && !bDebug)
		{
			map.writeToXmlFile(path);
			reportNotice(T(", |exported to| ")+ path);	
		}
		
		String manufacturer = entryName;
		if (manufacturer.find(kGeneric, 0, false) >- 1)manufacturer = manufacturer.right(manufacturer.length() - kGeneric.length());
		if (sManufacturers.findNoCase(manufacturer,-1)<0)
		{ 
			Map m;
			m.setMapName(manufacturer);
			m.setString("URL", "");
			reportNotice("\n" +manufacturer + T("| has been appended to default manufacturers|"));
			mapManufacturers.appendMap(kManufacturer, m);
		}
	}//next i

	if (bUpdate && !bDebug)
	{ 
		mapSetting.setMap("Manufacturer[]", mapManufacturers);
		mapSetting.writeToXmlFile(sFullPath);
		
		if (mo.bIsValid())
		{ 
			mo.setMap(mapSetting);
		}
	}
	
	if (!bDebug)
	{ 
		eraseInstance();
		return;
	}	
//endregion 



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
        <int nm="BreakPoint" vl="520" />
        <int nm="BreakPoint" vl="521" />
        <int nm="BreakPoint" vl="540" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-24891: Fix when running hsbExcelToMap" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="3" />
      <str nm="DATE" vl="11/11/2025 4:12:20 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="Added findFile(sLastPath) safety " />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="2" />
      <str nm="DATE" vl="3/16/2023 3:41:45 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-15990: Support family description" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="10/7/2022 9:34:10 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-15990: Initial" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="9/8/2022 1:49:49 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End