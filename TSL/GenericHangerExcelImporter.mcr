#Version 8
#BeginDescription
#Versions
Version 1.9 05.02.2025 HSB-23100 version distinction .net8 added , Author Thorsten Huck
Version 1.8 17.03.2022 HSB-14929 multiple block overrides added (i.e. SDE)
Version 1.7 16.03.2022 HSB-14929 numeric fixture article numbers supported
Version 1.6 15.03.2022 HSB-14929 Fixture import added
Version 1.5 25.02.2022 HSB-14805 bugfix writing map key
Version 1.4 25.02.2022 HSB-14805 now supporting individual files for localisation
Version 1.3 21.02.2022 HSB-14639 supporting adjustable straps
Version 1.2 21.02.2022 HSB-14324 bugfix writing new manufacturer
Version 1.1 04.02.2022 HSB-14324 joist and alpha ranges added
Version 1.0 02.02.2022 HSB-14324 initial version









#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 9
#KeyWords 
#BeginContents
//region <History>
// #Versions
// 1.9 05.02.2025 HSB-23100 version distinction .net8 added , Author Thorsten Huck
// 1.8 17.03.2022 HSB-14929 multiple block overrides added (i.e. SDE) , Author Thorsten Huck
// 1.7 16.03.2022 HSB-14929 numeric fixture article numbers supported , Author Thorsten Huck
// 1.6 15.03.2022 HSB-14929 Fixture import added , Author Thorsten Huck
// 1.5 25.02.2022 HSB-14805 bugfix writing map key , Author Thorsten Huck
// 1.4 25.02.2022 HSB-14805 now supporting individual files for localisation , Author Thorsten Huck
// 1.3 21.02.2022 HSB-14639 supporting adjustable straps , Author Thorsten Huck
// 1.2 21.02.2022 HSB-14324 bugfix writing new manufacturer , Author Thorsten Huck
// 1.1 04.02.2022 HSB-14324 joist and alpha ranges added , Author Thorsten Huck
// Version 1.0 02.02.2020 HSB-14324 initial version
/// <insert Lang=en>
/// Select xlsx file
/// </insert>

// <summary Lang=en>
// This tsl reads excel files to import hanger data 
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "GenericHangerExcelImporter")) TSLCONTENT

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
	String kMinWidthJoist = "Joist\\MinWidth", kMaxWidthJoist="Joist\\MaxWidth", kMinHeightJoist="Joist\\MinHeight", kMaxHeightJoist="Joist\\MaxHeight";
	String kMinAlpha= "MinAlpha", kMaxAlpha="MaxAlpha", kAlpha = "Alpha";
	String kAdjustableHeight = "Adjustable Height Strap";

	String kBlock = "Block", kBlocks = "Block[]",kFixture = "Fixture", kFixtures = "Fixture[]", kNumHeaderFull="Header", kNumJoistFull="Joist", kNumHeaderPartial="Header Partial", kNumJoistPartial="Joist Partial";
	String kEmpty = "Empty";
	String kGeneric = "GenericHanger_";
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
	String sFileName ="GenericHanger";
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
		
		mapIn.setString("LastAccessedFilePath", sLastPath);
		_Map = callDotNetFunction2( strAssemblyPath, strType, strFunction , mapIn);
		_Map.writeToXmlFile("c:\\temp\\hsbExcelToMap.xml");
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
	Map mapSheetFixtures = mapSheets.getMap(kFixture);
	
	for (int i=0;i<mapSheets.length();i++) 
	{ 
		
	// exclude tagged sheet names	
		String name = mapSheets.keyAt(i);
		if (name.find(kEmpty,0,false)>-1 && kEmpty.length()==name.length())
		{ 
			continue;
		}
		else if (name.find(kFixture,0,false)>-1 && kFixture.length()==name.length())
		{ 
			continue;
		}
		
		
		
		
	// verify content
		Map mapSheet = mapSheets.getMap(i);
		
		Map row= mapSheet.getMap(0);
		if (row.length()<1) { continue;}
		
//		for (int i=0;i<row.length();i++) 
//		{ 
//			reportNotice("\ni"+ i + row.keyAt(i) + " " + row.getString(i) + " " + row.getDouble(i) +" "+ row.getInt(i));
//			 
//		}//next i
//		
//		
//		
//		reportNotice("\n*** row" + row);
//		reportNotice("\n*** row" + row.getString(kManufacturer));
//		reportNotice("\n*** row" +  row.getString(kFamily));
//		reportNotice("\n*** row" +  row.getString(kArticle));
		
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
	Map mapFamilies;

// get common data sheet
	
	String k;

// collect fixture data
	String fixtureArticles[0];
	Map mapFixtures;
	for (int j=0;j<mapSheetFixtures.length();j++) 
	{ 
		Map row= mapSheetFixtures.getMap(j);
		Map m = row;
		
		String manufacturer;	if (m.hasString(kManufacturer))	manufacturer = m.getString(kManufacturer);
		String articleNumber;	
		if (m.hasString(kArticle)) 		
			articleNumber = m.getString(kArticle);
		else if (m.hasDouble(kArticle)) 		
			articleNumber = m.getDouble(kArticle);			
		if (manufacturer.length()<1 || articleNumber.length()<1){ continue;}

		m.setMapName(articleNumber);
		
		// remove empty entries
		for (int j=m.length()-1; j>=0 ; j--) 
		{ 
			if (m.hasString(j) && m.getString(j).length()<1)
				m.removeAt(j, true); 
			
		}//next j

		if (fixtureArticles.findNoCase(articleNumber,-1)<0)
		{ 
			mapFixtures.appendMap(kFixture, m);
			fixtureArticles.append(articleNumber);
		}
	}//next j
	
// find manufacturer sheets
	int bUpdate;
	String sUpdateEntries[0];
	int numFamily, numProduct;
	
	for (int f=0;f<mapSheets.length();f++) 
	{ 
		Map mapSheet = mapSheets.getMap(f);
		Map m = mapSheet;
		
		String sheetName = mapSheets.keyAt(f);
		if (sheetName.find(kFixture,0, false)>-1 && sheetName.length()==kFixture.length()){ continue;}
		if (sheetName.find(kEmpty,0, false)>-1 && sheetName.length()==kEmpty.length()){ continue;}
		if (sImport!=kAll && sheetName!= sImport){ continue;}
		
		
		String manufacturer, material, url;

	// collect product data
		for (int j=0;j<mapSheet.length();j++) 
		{ 
			Map row= mapSheet.getMap(j);
			String familyName; 		k =kFamily;		if (row.hasString(k))familyName = row.getString(k);
			String articleNumber; 	k =kArticle;	if (row.hasString(k))articleNumber = row.getString(k);			
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
			Map mapIn, mapManufacturer;			
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
			
			k ="TopFlush";  		if (row.getDouble(k)>0)	mapProduct.setInt(k,1);
			k =kAdjustableHeight; 	if (row.getDouble(k)>0)	mapProduct.setInt(k,true);
			
			
			k ="MinWidth";	if (row.hasDouble(k))	mapProduct.setDouble(kMinWidthJoist,row.getDouble(k));
			k ="MaxWidth";	if (row.hasDouble(k))	mapProduct.setDouble(kMaxWidthJoist,row.getDouble(k));
			k ="MinHeight";	if (row.hasDouble(k))	mapProduct.setDouble(kMinHeightJoist,row.getDouble(k));
			k ="MaxHeight";	if (row.hasDouble(k))	mapProduct.setDouble(kMaxHeightJoist,row.getDouble(k));

			k =kAlpha;		
			if (row.hasString(k))	
				mapProduct.setString(k,row.getString(k));
			else if (row.hasDouble(k))	// if single value given in xlsx it is collected as double
				mapProduct.setString(k,row.getDouble(k));
		
		// collect potential block overrides and its offsets, i.e. StrongTie SDE: two diffenert blocks for display
			Map mapBlocks, mapBlock;
			for (int i=0;i<10;i++) 
			{
				k =kBlock+(i+1);
				String blockName;
				if (row.hasString(k))blockName=row.getString(k);
				
				k =kBlock+"Offset"+(i+1);
				if (row.hasDouble(k) && blockName.length()>0)
				{
					mapBlock.setString(kName, blockName);
					mapBlock.setDouble("dX", row.getDouble(k));
					mapBlocks.appendMap(kBlock, mapBlock);	
				}
			}	
			if (mapBlocks.length()>0)
				mapProduct.setMap(kBlocks, mapBlocks);	

		
		// collect up to 10 predefined fixtures
			Map mapFixture, mapFixtureArticles;
			for (int i=0;i<10;i++) 
			{
				k =kFixture+(i+1);
				String fixture;
				if (row.hasString(k))fixture=row.getString(k);
				else if (row.hasDouble(k))fixture=row.getDouble(k);
				if (fixture.length()<1){ continue;}				
				if (fixtureArticles.findNoCase(fixture,-1)>-1)
				{
					mapFixtureArticles.appendString(kArticle,fixture); 
				}
				else 
					reportNotice("\nkey " + k + " " + fixture + " not found in " + fixtureArticles);
			}
			mapFixture.setMap(kArticle+"[]", mapFixtureArticles);
			k = kNumHeaderFull;		if (row.hasDouble(k)) { int n = row.getDouble(k); mapFixture.setInt(k, n);}
			k = kNumJoistFull;		if (row.hasDouble(k)) { int n = row.getDouble(k); mapFixture.setInt(k, n);}
			k = kNumHeaderPartial;	if (row.hasDouble(k)) { int n = row.getDouble(k); mapFixture.setInt(k, n);};
			k = kNumJoistPartial;	if (row.hasDouble(k)) { int n = row.getDouble(k); mapFixture.setInt(k, n);}
			mapProduct.setMap(kFixture, mapFixture);






			mapProducts.appendMap(kProduct, mapProduct);
			if (mapProducts.length()<1){ continue;}
			
			mapFamily.setMapName(familyName);
			mapFamily.setString(kName, familyName);// TODO get familyname column	
			k ="url";  if (row.hasString(k))url = row.getString(k);
			if (url.length()>0)mapFamily.setString("url", url);
			if (material.length()>0)mapFamily.setString(kMaterial, material);
			
			
			mapFamily.setMap(kProducts, mapProducts);
			mapFamilies.appendMap(kFamily, mapFamily);
	
			mapManufacturer.setMap("Family[]", mapFamilies);
			mapManufacturer.setMap(kFixtures, mapFixtures);
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
MB5!.1PT*&@H````-24A$4@```9````$L"`(```!BU7*5````"7!(67,```[$
M```.Q`&5*PX;```@`$E$051XG.R]9XQEYYGG]W_>]SWAYDI=U=4YL+O9:I%L
MBI1$BJ*DD48SF@![TFKA-6R,UX#]83\LUC`,+&RO;6"^K;TV%C`,V`+6&-D3
M5HO5C$<3-1H%!DGD,(ELYF;G7.G&D][@#\^]ITY55S=%L=EU;^O\4*B^=?O<
M\)ZJ\[]/?LDYAY*2DI))0&SW&R@I*2GY:2D%JZ2D9&(H!:NDI&1B*`6KI*1D
M8B@%JZ2D9&(H!:NDI&1B*`6KI*1D8B@%JZ2D9&(H!:NDI&1B*`6KI*1D8B@%
MJZ2D9&(H!:NDI&1B*`6KI*1D8B@%JZ2D9&(H!:NDI&1B*`6KI*1D8B@%JZ2D
M9&(H!:NDI&1B*`6KI*1D8B@%JZ2D9&(H!:NDI&1B*`6KI*1D8B@%JZ2D9&(H
M!:NDI&1B*`6KI*1D8B@%JZ2D9&(H!:NDI&1B*`6KI*1D8B@%JZ2D9&(H!:ND
MI&1B*`6KI*1D8B@%JZ2D9&(H!:NDI&1B*`6KI*1D8B@%JZ2D9&(H!:NDI&1B
M*`6KI*1D8B@%JZ2D9&(H!:NDI&1B*`6KI*1D8B@%JZ2D9&(H!:NDI&1B*`6K
MI*1D8B@%JZ2D9&(H!:NDI&1B*`6KI*1D8B@%JZ2D9&(H!:NDI&1B*`6KI*1D
M8B@%JZ2D9&(H!:NDI&1B*`6KI*1D8B@%JZ2D9&)0=_GU%G[GL1M['-]N7C..
M7'?^;K^'DI\-^[_]>+O?0LG/.W=;+$0K!"*^W5F0=_G52TI*)IJ[[1)J[RZ_
M8$E)R;W#W;:PK'!W^15+2DI^-MY]]^U.I]/M=J]<N;)W[[XGGOCL=K^CNR]8
MUM[E5RPI*7E?+EVZH+7.LJS3Z?1ZO:6EI3B.DR3)LBR.XRM7KD@Y%K'FL7@3
M)24E'QUGSIQ1:GBE)TFBE#IPX`#_^-Y[[V59ZIQQ#@",,5H;YYSO^]8Z(B(B
MYUP0!$J-1<3Y;@L6E1YA2<E=Y.+%BR^]]%*[W0[#L-%HS,[.5BJ5EU]^V?,\
MS_-\WZ]6J\Y9:VV:IFF:6FN$$$$0..><LVF:6FNS+--Z+'RCNV]AT5U_Q9*2
MGU^,,2LK*ZNKJVPK.>>:S>:^??MV[=KE^]Y@T,^RK%JM""$`$)$0PO,\K;40
M@F][GO?S:V&YLE2UI.0NLG___B`(JM5JFJ;7KU]WSJVLK)PZ=<KSO%V[=AT^
M?-_.G0M:9\UF4RDEI03(&*.4JE0J'-5R#L88Y\;".2H%JZ3D7N;BQ0O&:*TS
MYVRM5LVR+,NR6JV:),FY<V?/G'F/B(X?OW_OWKV'#Q]62FF=$9$QIMOMIFFF
MM2:"E-(8L]U+`>Y^'5:GTK_+KUA2\O-,FB9"D.][0I"4I'6FE"1RQAC?]P#G
M^]Z/?_SC,V?.L-M8J]6LM95*)0Q#*8<N(1&-27Z_S!*6W+-<NG3AZM6K5ZY<
M:;?;:9K&<2RE/'GRX965Y0<??'#7KCW;_0;O!D((CEX!L-;5Z_5^OZ^UD5+T
M^WT`4LIZO=YJM9(D65I:FI^?[_5Z1*+1:'0Z7<_S`&19FN<9MY>Q>!,E)3\;
MER]?U%I'4=3K]:(H2M-4:]UN=_K]GI1R,!BTVVV^5HTQ:9K6ZXTT3=Y[[[TW
MWGAC;F[NZ-&C>_?NO;>5BT:P<F']5-2=<P</'GSWW7<!..<6%Q>O7+ERX<*%
MA86%=KO=;K>E'#XP#"NEA552\CY<N'#APH4+G_G,9P!<NG01L$F2QG$\&`RX
MII&#P5IKK;4QAA/P[-?T>CWG7+U>M];&<<S7:JU6Y>BRM?:==]YY\<47Y^?G
MCQ\_OF_?OIT[=]Z3RE54*REE',=<M3`8#*:GI__I/_UG_^)?_'?GSIW36@=!
M<.#`@:>??GI^?AY`M5J]__[C;[_]UMFS9RN581IQVRD%JV1\.7_^_/>^][U6
MJU6I5-(T(8*UUA@CI0R"P/-\P+%(I6G*^@5@,!CT^WUKK1!":VVM]7U_,!CP
M`5KK6JT6Q_'4U%08AI<O7WGOO?=:K=;BXJ[#AP\=/7KT8Q_[^':O^TY2%"PA
M1)JF81@:8Z(HFIF9.7WZG3`,E5*]7B])DH]][..G3IUZ[[WW]N[=.S,S<_#@
MH:6EI3???-,8R[[AME,*5LGX(H28F9GALB`I910-\NBOE)+(L@_(MA4_Q#GG
M>=ZCCS[ZB4\\^N_^W3?>>./UZ>GI;K?+EH40PACK^[[G>>Q"3D]/.=?*LNSR
MY4L7+U[XP0]^L'OWG@<>^/B)$R=V[]Z[K:N_8[!UR9$LW_?[_;XQ9FIJZMJU
M:W_XAW]X[=HUS_.JU6J[W0;0:#2N7KT:QW&SV030:-2;S>;ERY>!L2AK&`LS
M[QZC&<Q/^?-3:F%&+LSX"]O]=B:8+,LX766M):(P##W/DU(*(;@&4@AAK;76
M\IUIFO;[_<7%Q4]\XE$`<W.S4U-3;%BQM95E&1&XX(B?,`B"7J]GC.';1'3A
MPOGGGW]^,!AL]^KO#-9:%G$`>2THGRLAY)4K5X@$6Z.U6@U`O]]?6%A02EV_
M?AW`M6O7LBRKU6IC4M906EAWAJ:M=T2/;W>2Z^O_80#@>/W0GL/[M#3???&I
M[7AWDPH5R`L7\XIM`*Q9',.RUK*TL6D`H-OM]OO](`A8X`K),ENI5.(X;K?;
M411)*=,T95&KU6JKJVL+"PO5:G6[5GW'X1.8W\Y/!1&XI3E-4RY?>.65EZ(H
M.GSX,.<K_NS/_G1Y>=D8\_/<FG/OT$I#`0L(:5Q\?7G:""F\9KVY:V'7H7T'
M#N[=-S<SLW?/GK!2:<U.^ZB\U3M]YH77VUE_U8^W^[U/!OF5-KI!^?7&][,`
M22D!<"O<8#`X??KT0P\]?/GRQ=.G3ROEI6F:'UETCI1201``4$H-!H,HBMC:
MJE1"I522)-NW[CM)+O=\`@MJ1<[!.:>4#(*`A?O*E2O[]^]/DH0ES!C3:K7"
M,(RBZ.>T-6=R:44!`8%047_0F7$`VGZ\IQ/NV+%C1WWZXY\^.M^8VK5KUZY=
M>^;G=C:]:@`E0!999HV!B6'\KNY?6II9G`T07$5[NQ<T,1149OAC?A%R`)X=
MG#B.M=8\9N`/_N#_X5R8,9%2GM8Z-S$`..>JU5H41?P,_7Z_T6CD)E6OUTO3
ME+7L'B!7ZDUV%@"B8<C/.5>I5-;6VK.S<W-SLS=N+,5Q[)RSUFJMDR2QU@6!
MOYW+&%$*UM8TN\HS@@#G'&EKC7%Z`&WW[C\P.W]P]ZY=!_<?.+AGW^+"0K/1
M:J#20D4.`X*"``F2@'*`]2!4!I,`Z,4M+XS:_;0"5+9W?9-!\0+;:&H-VW1]
M/^CUN@"FIJ9:K=;ERY>EE&F:15'$[;M!X/=ZO=P<R_W*)(FS+./(#ON#G__\
MYP>#P5_\Q5^PJ=7M=K=ER7><XGDCVN10`Z`T39USM5K-6C,U-96F:1@&6F=1
M%&59QHHF!%D[%D'WGSO!:M9G.KV537=.44T)"6.7,(Q#>>VT)H)&K3D_/WM@
MSX'#APX<V'M@=KHU59\*E`S]2@CEPQ=P!$%P'B#6.R5)`LJ"+&`!!R6$%E98
MX2`,64OER(J?BJ(?QUX,9P/SJXZ(%A<7CQ\_P<>?/OWN:Z^]FB3Q[.QLK]?K
M=KMQG!2=H-Q,TUH#L-9Q+'EY>?GEEU\1@M(TK5:K7)2T38N^\Q3=9VQP$L%>
MH;5V,!@((;K=7J-1YW/%B0BN%V%3:UL7,>3G0K`:P50W66NA[JS=I%;3`W^U
MFJZY/@QV#2J?WGOTP/[]NZ9V?/KP@]-!?:HYW6HVJ@@!JUVFTZP65`4<0.0L
M;.:<@85UCH+Z2)T`P`$DH(:W8`@&R"02A8&'3EC&L'XJN(N-XTU$R#+#X?,T
M3;D=-PR#7*T`'#Y\7[_?>^NMMZY?O\Y#4=;6UC@J3T1<7BJER+'69%DFA*C7
MZ^^^^PX1S<_/<RSLX,'#V[CPCX*\%(L%2"D5QPG@?#_@DYEE6;/9Y$)<*:7O
M^ZNKJY[GL7OX<SJM85OH)FO3<2BUL9EN9B"':A"V&LUZM7KLXT>GFJW%A87%
MA9USTS.U:E62\#1-BVH(%2CEP1,0`L*10.#[4`00G'46<$)Z0@D'I(`!',"I
M%`(<X`C$1Y.U@!9(E.W4[Y%H[ET@[X-32J5IHK46@K(L.WGR$R^__&*WV_W<
MY[ZPZ2$//GCRM==>JU:KO5XOR[)&H\'=.6PR.&=9JOC2S9_?&%.KU3S/XR()
M(<2Y<V?V[S^X'8N^\^36):]:*<5N(!&Q].<?#&$8LBN=9RJL=5P845:Z?R1,
MB:;-=$=N**)I7K<ULCM:,WL/[MV[=^_>W;MW[UQ<G)MO-!J^\`3@04@("1(0
M"D(I&4(*B#2-TR0"X'DJ"`*/)`!GK='&&",<(!Q)."F$L`+(AA:6<(#=.*K0
MP1EA]5C\TB>&W.^SU@HAV9@Z=>K5YY[[4;5:#<-PRT==NW9M<7&1JXU&V3$4
MTV08A<"`==GB&OJ\X6Y,KL\[`HL1>]-)DN0_AF%`A$JEPOJ5^WUYF5NKU5I=
M7>-2^+*7\`[0%`U)`LZY3+LD@S9KS0XD=ERS<U,S>W8N[MN]9W%Q<;8QO6=N
M=ZO:F&G--"I5CCT)"`40A`0DB.`(9&&<M<YHXPQ`OI!AK38,5UK'G\\D!"DE
MI10@#.<TPL((0(Z,+`(D0,[!.L!)LE3&K3XX-R>V`%AKGWWVV:]^]:NWBHL+
M(9:6EMA8X"["HD=3C&<),;0[I)3%>-F]1WXFV<(*PY"3JOQ?7!>2GR4BXF;#
M-$W3-.$_9*W+PM$/3<=V`<POB1U3,SMWSK7JC<<?^>1,O;%S=GYQ=L=,I15`
M`;!P`KZ`%!"`L;!6:R6$+TA"$"QI!V=@!>#@)$@B4-P&8*UUUH%(B/4Z%!+"
M6:NM==H0$6"5)$E.P'(82P+*"IBAHR@!3\$W4&/Q*36)D'/#"^;Z]>O3T]/]
M?E^I+;K;?O2C9_F"Y-R?<^`H#`VK1H<!>'$3=!-W=X$?%<4B6]:F-$V)*(HB
M(>345&MY>5E*Q196WC.@M6ZUINKUVM+2C7?>>1>`[Y>]A#\KS14Z.KM[9V-Z
M[^Y]AP[N/[#GP,X=L].UJ8I0%00$`T`X0U8HX204#2T>`<!89S,C('VI"`0'
M6`D"((<&$@!"W(O(4^Q6Y*]KK;485;4(DF)X]@@6UI"#$C`0#I`0<!NZKP2;
M7:5@?1!<`2F]%UYX[LJ5*^?/7_CB%[^HM7;.WAQI>OGEEZVUU6K5]_TLR[)L
MC<TI#*VG=9<PC^D4%:IHB-WUY7XD%'*"Y)QC8\KW?6/,PP\__."##_W^[_\^
MKY4UBT](EF7[]^_:NW<_@#-GSCKG/&\LM&(LWL2MF#?-NI8M"A:JK9TS\[MW
M[]F]=\^.Q=W3]<:)'0<E+$$`5D``EMA6@A1\/UE!`K"%?DD!0`J?-I7`;16L
M"&NUF[?+$+<);#@"B!U,`V$!(0%".ACXC5IJ,@.E/,\OF&F-&UYW1W:;Y;?:
MGK3#^/W*].V.O!535X@<'`DCT%TP`!:P<`W7?H:GVA8*4F(!A&%EQX[Y^^\_
MSJ784LJK5Z]**??LV<?'__"'SS0:#=_WN?B3]]3S?3\W,9RSH^C5!B^I>"=&
M;N-VK?K.DH?,BXME9[G9;'[RDY_ZVM?^KS`,-ZTW",)<L@>#@7/6F+'XL!UK
MP?K8H6/_^:__PUD*=H;3LY5&I=(00F8`8*L0R@T+-8O?B6C3/>_S&G?D<]3Q
M"VWXC1I`"D!)"%@G+0!+-M6MMG?RH9.?/_Y8H(4EZPA&P!`<`;!Q').#`,@Y
MZ9`+%H*MO4G^P-SB'1&D0Z")'!Q$*I%(H24\3R;QX/*Y"Z^\\<HI=^E.+/XC
MA(B44D*(-,V<,[R9`E<S<HQ\,!B<.7/F\N7+`*(H2I*DT6C<N''#]_T@"&[<
MN.'[@1##@+IS+LLR[LA)TXQ]'^Z"IM$D`WYF]IBV>_5W!G:-V5=02G$SP,K*
MRO3T]$LOO<3MDUSTG_=%&V.L-9<O7]FS9]\++SROE/(\+\M^EH_,.\Y8"]:)
M^^\_LO>^)D3#*-\).)=EJ29R5I,_3J7BM/[=CG2+A80_MSTI-0Q9!VO)T>,/
M/OR??N;7ZD9@5/W@R%J"`SSDD0++7B0K;H:M0Y[&;G&_$4A9Y1P)!TM"$Q((
M#5@8#^)&Y_IKQT]\_5O??*]]^7HXOF,)<G^0O;F\SG-D'!&[-CQN@85,:UVO
MUT^>/'GLV/%O?./?OO/.V[X?8&0ZY?FO@I,(;/2;\EEWV[?N.\Q&]W:X0*54
MN]W^WO>^SX5I>6IB='Y$M]OY\8]_N+2T!(!W,-RN]U]DK`6KU6BV4`^AR5F;
M9@2HT/>$%!B+^-\&N-X*PZ_\#X2(8"PITBXE!T\JDT2+,PLS"$(GUH\;VN/6
M&@>R;ACR6G_N*MWB-T5;GXH4S@$!_Z62,$`"D0$I(@M]K+G[OD_N7+JQ]+7_
M[P^P=6W`6%",@'-K2/&B`AQ73G$CH3&&B*QUBXN+QXX=!U"IA)5*)8JBHCSE
M3SB*7HG\`N90/=L:AP[=M[UKOX,4`W9Q'`%H-IN#P:!6JV595J_7EY>7BX<Y
MYWS?JU0J@\'`\[P=.W:LKJZ4`_S>GZC;$W`^9*@\7\)9J:W-G-7.;)DAVDZ(
M8^\;BMW7_]/!I%J1")77G8N3*-+0T&KS,\`*3X&KO4AB]&P"T'&T9<">MHJJ
M.6$Y(0I-L``)*>!+(02@;;?7G9KQ#7#_G@,4I?.U^G6O=V=.PD<&!UB<LT1B
MDR&@E&([RSEGC$V2./?F+EZ\.!@,FLWFVMH:-AH:A>0@V#',LBQ)DCS:=<\4
MCA8SGEP:VNUVE5*<.952KJVM%<],7OCF^S[/RS?&1%%<NH3O3]J/!"!!/H0D
M0)`D:2V,,V+<0J*<9QG58>4JPIX+K!.`XM(MH-OI$A3\F[5&&&,=M_((6&+!
M$A*V%E;(;:586\6&"9#"P3DX@@"<@(`20@H$OA!5(T`&)@A#(42C7K^>C*]@
MY<:4<\2>7#%/#]@\6\_>=YJFG4[WF6>>NGSYRHT;-SS/ZW0Z&VVKD5E50$H9
M11&/;0#`@;/M7?B=HECF#H`%*XYC'BG#:V='FT_L,(CA>0!X*"O/1QZ3M.FX
M"%;3"SO9Y@Z[6A!FB#.+-)&>(Q(^I/`]`>&-Q[S6#;B10>0*D2P:[5/B!X$`
MZ21M7L@@10JHD4=8=/\,"6X\S+\L("#L9GMLB!1;AEHL`9(@9<%($S!`DB5>
M&`[26/LTL%G/9NF@BW$-UVR\V%BV\G@3B(A#5]S]Q^FPJ:FIU=75%U^\$D51
MI5*54L1QS'%TM][_O*%&E.]I-!H+"PN\L7L^'OX>@`J3*H@HBF+.2T01%XZ2
M[WO%D\,'<]\E`$Y?1-%@3"RL<?D8$5O%.%N-9@@O%'[@^\KSI5)2<K7`.&(+
MWW/X+\!:JZ"$0YJFH1]4*H&%-K`&UO+72.0D00)<M,HW1C\J0>+F+YL_0^'+
MP*9P*9P3#N1`#G`6SL"1D@21:"WA4^!EBCIR?+>V'66L;)9I(A"!?]1:<QVC
MUKHH0\8,-\AI-!IS<W-A&#CG*I4*:UGQ:?E1;$D1B31-'WKHY`,//-#O]Y52
MO#WR]JW[3L)Y3VX8E%(*0;P-1[5:44KQ>>,.<,XG<D[0F&&7N%**;<\RZ+Z!
MM7C#9=,T%2Q'_7;'AU0`!V38>ADZ.@0:4^':B!*PCH@&Z2!)DD:SV>ZM2`<?
M-)P7YPI?`%(CI8`B9:$!DH@S$WK2=XZ-BIM>8(N38$AVD#BHV.J*]&"PWHA-
MY("@&FK8M7[7#P,@_0B7_^$HIJYXI3P*V1BC]3`M6#0->!,=(M):L\U%1'E/
M29XHS-T]&I9?.<_SEI9N]/L#]HG",*Q4QBD-_2'(3U&>_>39]EQ8J[7A?"B+
M.$;GA\."N<'E^WZYD>KM(`>P<<!&8*%JG!S&4ZL$8$;?-V`M$0DI#9S.,A7X
MU6K5P8`OPN&ZW/`YK(%S$$HY*`%8!%+"`<:"#)P`.9`<!<HL'*W?'GUW9&.=
M")7YJ?,D%'D\7)*LD0*"D%E(`6E!X^=9%W&%IC_>H8O;1WB$L5**8^U\9S&V
M-5*B#4YE,?S,SXJ1`:*4NGSY<K_?;[5::VMK]TS5*`H5&[RH+--!$!ACNMTN
MU]^B4#J;U_W[OM_I=/G$>IY7J6RN+-TNQE2P&+$IO8^-)0-C!@UG^`UO%#MZ
MA!)22@N7Z$Q5O`RZCQ@F7XD0'%1QHE(-!%BAT&_WM=:M>A,!=75DA0$)P!$)
M(A`)P%F;UU&L?S=P554CH!J2RC2TA91DG4<"VD`A,-`"OH4_WH&:0GH+`"J5
M6K6*?K_/?7#.69:;W`@KUEAA8W75)J241#HOR^*(5:U6<\YI;8CHGG$)&5XU
M3VCH]_M)D@1!X/L^UWQH+?*\!,N6M=8YJY1B!]DYE-,:/A1C)UPCNX^P660=
M02AID8((@@S<.^?/]#[V&$?1>1P-(`A$<-?C5>6DR^Q"<S:<KKD,D(AMUO--
M(NRH>-^Y8:.V=0(.CD`;OV.M>U59=U]K%Y0:VG'60BDX`P=E80'IQMW"8CA+
M**4\>/`0@/?>>_?2I4M34U/]?M^-=L$I>(Z;&VLV"I88F6SK382YZA%1%$65
M2EBKU>ZEPM$<YYSG>=S5Y/O^\O*RUIIW=>9T86YJ&6-X@`\+EM99:6'=#G<K
MIV_8PC)^L/",:D=I8^VH`XRS3I#PO=3$/WKMI3??>E,Z:R$<#2=G"2?(B;I?
M-?W$L^(?_.IO?.[!3P>>C'K=OWKFNW_ZTG<'@2$G()R`A'#DA"/K#!Q9OIU_
MEPZAEO?MV/5/_M%_MA`TI"0XV"P3&S<^L>-Y)@L4XR^#P3#*R3TW"PL+@\&@
M6)-5K"K--<O:8H1KN"T8_\A-.3=[E,6M[>\!BJ=("-'O]\,P%$*LKJ[.S\]/
M34V]^^Z[&(6N^%3S>7C@@8<`7+Y\,8HBWFQUFU<"8&P%:_(8;NBR0:KX?C<J
MT8(@"#+6G3Y_ME.]W83LN8OJL2>>B&$%I*P$JVGWJ3=>["Y^L'?TZ)7=7_W-
MWZX&04WXTB(1KJ+(&@@!+:`!+9".MQG!5Q%OC1-%T:E3KYXX\<#9LV>EE/5Z
MO=OM<A-<D7QJ*,]1J53"P6#`/J!2RO,41^+Y?_EV'H-GJRI)DEZO-R8>T(>G
M&)SB!7J>-Q@,>KW>E[[TI>/'C__+?_DO\VQL[CGF(?9=N_:</W\>@-VJ">SN
M,RYE#9OHR%NVGMH\3CT^%&K;Q:8`%O%0&H"$)219IGSO]FK5[%>HZE,H!H@'
MZ`72KS>;5/_`2>7(IZSFKR%K(^L)&WF(@5@B!F*%A&^/Q:?F+6$GA:NBN#C[
MN>=^=.W:M=V[=[-4Y<91[NCQ1$UNUJW5:GEK#@L6QYO9_<EM,=X(VCG'H]\Y
M<'//%(X2D5+#[;*YO9D;;GP_N';MVNKJ*A]EK>7B!@#6VBB*WGOO70#GSIWA
M+0O+`7[OSX8(RW`_&@BWV9?)CRIFR][GF;>ZTVUUP)9WYO\U'-<W=&`WS(<0
MHP=;:P6L@+(PJ<YD(VQ1H^UNN8M4IQ9-#Y0$`D!J1\JF<80/7MJ?"F>5L"`!
M*2$3D_)OFP#'742$=G5\:QI0<`F=<V$8&J/3-#UZ]&B69=UN-_?IBNZ;$*+;
M[;(P#0:#+-.M5HOWG=_D+1;SAIO<QMP]O)>@T40*_K'1J+_]]MM7KU[E\<?Y
MV6#/,4W3&S=NM-MK413SB)XQV49H3`6K10WINJ3-<.R>!`JU#6)8D&0Q5`V1
M:T>>+<.ZQ&%TV/H]8MCY-\1!.#@+<J.H-6D0K*7A!!@`Y"`</#G4(T<PL)K'
MR`"AY/$*PQKWT4&P4>I5PW[:(S_P`B44)3!M]SZUFKZQWB!MP@N(DFZ/,M.I
M?>"DU:`_,&G6#&:ETR$IC_RXW6[6:Y"05AJ15DDU.[+3'(M/SBW)=21W][B,
MB$VD3J=S\T/87#IY\N34U-1SSSVWM+04Q_&F9Z.-K3GY3_D>8D7]FG1X*7E\
MBG?$,<;XOM]NM[O=7KU>ZW:[1>FWUDY/3T=1U.\/HFC`-NR8E/Z/J6`YVE#3
MX$9&`5BML"%-6"Q]RIVS+?_<BL;7+?.,#@"D`#E!!`C!Y0<$B$)8(W^LQ<B\
MRF-5@.5=5`'A>8#5VL"W4DI+[GWWJ6^:BK61,8;@#!`T:GZ]>ON'W,QLUFA6
MJA7E2P"IEKXGI>?7/%@#@AK588E)"-2,S*)ARP@+D-8Z'S63'RF$6%M;>^"!
M!QYYY),`+EZ\R(FPHNKE1VZ0K`+8:'!-.L6EL2A7J]5.I\.5#<88GIB,T7GF
MAW`R,9]$.CZE_Q/IJ%.N"@X$D(,"/$`5OF3A*Q\LM;G@('_"D0$E'*2#9`N.
MM_>B0EBJJ'9N^$+\NK>,JTF"M4(0`*[,?M_5=624*7)5/X7J2Q=#)K4/_+F2
M13%EQL:I@/.DXHJ*T?F:@/Q@3N[$"4'&9$F2BM'6A'EG2?%X#MGP[7:[O;2T
M5*_7BY4-N6-8O(PWB18VSY":;(I+\WV?+2:><E&KU5C%J-!40$3Y%A6Y;34F
M=1X3*5C`34W&#L1:8YUPCJ4';GWOY>%(]4T1\8V(D68)NT&`^'5XV\$-P:V1
M4+Y/Y%H(WI`JCB(BFC7UVQ\^HZ8!84`Q;"=+(Z";?N"-5ZO2;WBAU%:!`C4,
M6R19F@O6J+)^W,E=%:V-,</)XCR[*C\@/]A:6ZE4SIT[!^"%%YY__OGGIZ>G
MTS1#P;S:9$;E#Q>C(7;YB][5=7YD%.TF-J_85@K#D(<Q%)><GPW/\RJ5"@>\
MN*]P3`1K3%W"]\<!3JS?9FBH7)L*(LF!"\-I0X1^:#-1?@P<P8V.$!@&JD92
M-?JN*._^XR'QH_^[]4<R@0PRXMV3LK0X'6$J#@&LC?:"G@WG@LC%L;6)%E"!
M5]6`SCZPYQ9:FO(J/L1P\Q_G0`@JH;.:,!Q<L\G)'4_RC#O@N`7:.5AKN-9A
M4V#%.2>E[/=[7_O:_YFFZ=S<G-C'-3(``"``241!5'-.ZPP`=R!R?QQ/5L&H
M%,M:JY3'K2K3T]-<$I$D]\Y^MQQ6YT[F?K_/C=`\6X:G)_N^S\%!W_=W[=KS
MSCMO)4DR&$1IFKCA'K26FWBVG8D5K"W3>`"L&\:2AG,[K:-\HPIFLU6QKF_#
MH0;#67H62"$R6#.ZKB4`")[<LIX",+GFW>*M.I?J-/-TI5KU/*_CKX\DGKXJ
ME(T!S`B[LE,`,)=6!X/,[QG9UP$$0;:14?+!=*5UW:PN7==R1@]BM`Q!9%G&
MX2S>MR,OOIT4"XN'R4@IB,B8+(JB?$^]HBG$ZI-_YY9#;(Q>T4VC5#@I-C\_
M[_O^]>O7\YW<MV.Y=Y[<:**-&VVX0L<EGZXP#/D#@%N=DR1AC>.<[,S,S/8M
M8IV)_*T,VT_$)K6R`$"671XC>&2+Y=(";Q3&LL"MKU,+XB=!0E8+9!`9K(9@
M45(`00$0--J1Y_9!?@R;D?EJX;&6\'%R]_$%:E0S5&:@K`-@!!()(V"G#"(]
M0^&1J471CYT0TN@C,WM^-?B8:OC<0Y_OQ<1_9S>_IMPA;*SWMN8;?FB3#)[B
M-V#@W!A6L=V640S+YJ-16(E8=V[UL9^'JXIQ*U=HC=X4PXJBZ*&''IJ>GO[Z
MU[_>:K5X$]:[N]"/BJ)+N&GM^3%<YP]`:WW^_%DV/,,P[/?[6FO/\YQS2?*!
MXQ(?!1,I6,.)=$S1S6-_@:PA:,#`6C@#*^$(;I1,Y(X\084GP+!(8AC&-P(Q
M3`)DL"F@82T@(=10LR``/R]IO[T`&`,E?.D+Q%F615&TH]K\XN<^_]6'OM*$
MJ!CK60#6$!(%`X2H9LG`&]CYYBR,Z"=)O5'[I4\^<?SHP;#F^2JP,,8X(4`D
MK=5"J)NG-0"0D,O+UW?-[LP&?4O#:R].$]]75!C:-?Z]A*.+#2Q/K%">YTMI
M>*+QS4'W+6^C4&!5J&(GUOU:K?;JJZ\.!H.YN3DBZG:[/,OA'B"7;&RTMC9E
M&(00@\%`:WWPX&$N%F4/D2<Z!$'@>>4\K)\5#BT!(((`J%!\=6-MN3;53)T5
MY%U-5EO!5`8W<)T%:DH@UK&OO*273-6GC3&>E$F2!;Z79:GOJ\QHK3,_]"ZM
M+3W[YD]TJ*XLKUQ=65+5,,O2:Y>N9KW(K/2_\N0O?/77?H/(TTD<>'[4CVJU
M6\?1E03LH#]`381A$(;A>>J$7M!$I0E1D59)`-8`_E!L5!A46D&HN[%T7CT(
MEM=B!'+&;X;*E_`=C)5L)TDGM("WQ7@9V!C)OMF]#JY:K9*3+HFMV]H<&W_X
M6N/)HD)P27K&(]BQ[C-N0>$9W*8;6)?"X7?>R8(KO,(P5.J>$JPM;Q>^@],:
M'(]WSM5J-:X("8)`2B4$9=E8F)P3*5C86"8J@=$66W9J>O:M2Z>]1BWU7"<9
MG(NN)]9U5U;T:M<-T@-[]C]\^*%Z/4Q=Y@D5]0:->M5:9%GFR,(33LD8^J^>
M_N[_^'_\KUE%]>^K`IA="=(HG:K6LVYT;''_P2/W*?(3D_J!3T(&]9JQ5MZJ
MD\,!0!`&!C9)4OYLMW`I;`HK``T+P`#I,!<9-5#1L#+T361=IJ>FP@Q83;2#
M9P%`NE%ON(-G@)OW8>2<9EMWB?PT-HV@ZOL^2(1>8*%1,$_'M)-\Q"C+[H@@
MA&PV&\>/?_S"A7-7KEQIM]OLN!6KM(OI/XXHYWGZ?.CH)D4;>4PDI0R"($F2
M,`RKU=J8U$E^>&XVK_)\:![#XCA#$`1:ZXL7SQ\X<.CMM]^<GIZ64KSVVJDX
MCL8G"S&1@F4+0Q%0<'`,\,;9M_^7__U?G[UQ"8W@^J`=D\Z$<#J3O<3VXR<_
M]>3_\-_\M[LK"\[:BB2_6AU6/$BAR3@(!W6I?>%/O_]7C;T[!AYD#THIV50D
M7&.J%5D</7;DV+&C%LBRU`_K!H`D#2=O=>43`"BI!+0;;11^ZMVW_G[G_FHF
MP@S"60!:6BUA2+A4URE0:^F)?4?FFC/6HI>9U\^=7LYZ?CW@V;7<#5>\"&]Z
M4>N<I3C]S-%/5&I@_S?5611%]7I5T"WV.!P_.)@BA-`Z(Z+CQS\.8._>_:^^
M^FJCT=C4^9SW%;**<4.)4LI:Q\G[HJCEA5?<9&>,YI((`)U.)TGB@P?OD6V^
M^*\NCZ)R-I#KW7DN*_?<^+Y?K5:%$*^^^NJ>/?NR+#MQX@$`?_W7?^-Y7KU>
M'Y,LQ%B\B0^/P#`L<=^!(P\]^M"/__#E1FUN.>I4=TRO5J)976O-3NMV_W+W
M1E<G!M:3WNI:NZK":C4`(0S#@8M3.`?[]$]>>./B&;MKVGBR@PZ0`)@)JC=6
MEW8U9G[S/_@/ZPA3$[%`&4`[ZTMQRT@6P6EMI"5!/"T;P/>?>?K/GOUK`,T+
MF;36`4:Z[IYA8='\);12[Y_][G_Y#W[EMZ20$.*UTV_^\W_U>Z+E^2K4-G/&
M@1Q!6F@E_)O'RY"STIK=4SO^YW_^/QW;N;>NPM`/?.7Y#<]9332<VHJ;)M"/
M&WGK3-'%>^&%Y[O=[N+B(N](6!R&Q;*5IBE??KQ+E90*&U-C!5ML^!+..?:&
MN$<Z29*+%\_OV;-O^Y9^QZ#1Q!CG'-%PIVNEU.KJZL,//WSLV+%_\V_^[VJU
M:JT;[8F=7KQX/I\0[7G>U-147@V_[4RD8''_,Q6JV%%HT/G48X__Z0^^O>*B
M^NQ4%D@`RVJPC`%FL';V[)_^[9__D]_\QPH5SPNJE8!;`0T<Q^D'2/_VN:<&
MRG:\S>U^-Z;C__B33Y[8>32U@X:L20'.UKWOG&%.G#L,=U("T*'ADZM=T](Y
MWOD9&`ZH$+,UV[9>JZKA$AU!>?ULH';6,>U++[0V<]I!0C@!IY4*+%GA1/&[
ML`A2A+7FW)[%BM\85GWQ`!PW/($\NLN.=Z`FER%.%+[QQFOM=N?--]\\>O3H
M8##@^0WYP7Q%*:784N#-K/+I5_DQ&_W!]8YHAN5OTZ/N`4:A=\N"-=H+)W+.
M$2%)DBQ+*Y6*E++9;/(^0V?.G+YZ]<K,S$RCT;AZ]>J8G(_Q_H.]-7G;#0UK
M.%F_'`&']Q_\]../=[I=60E6Q'#'O::JMG106YAYZL<_ZB.Q<$$0V(PM(,1I
MDL*DL&\MGWGUO;=1:(69JLP"6*D,YJ_(+WWVLPK0W2B`]$FF<2(`[_:_20<A
MI8`P,$F2)$DRK=<;`U=D[X;J+\E^6ZR/TXE)9\(XZ0Q2JU,%*"4ZBZ831C?D
MZIK7:U?Z;;^_&G0[8;2DUE9D9]/WZ_Z:"44,VTVB'B(:_99U%/.Y&O9CCKV%
ME9M";%T-!H/EY>4C1X[4Z_4T3;,LRP,T+#U$-!@,N,4WBF(V&>(XHD*YUB8+
M:U."?]./]P`;0WLBRS(I99;I2J7R]MMO?_WK7V\VF_E^$[Q!SGWW'>4-5KO=
M'O<;:JV-&8L_EHD4+!IU_`UC[W;XQ6TW%?A/?O:SK>FI0;*N`AT]:*LD$?;T
MQ3,O_N1E"R,$L=A9:X6G!.2*7ON;[W]G->YVIM8%:RU:YAN_\J4O'UDX:)'4
M_9"T(6-#Y3EWRP*L(78X64+#`##&*/D^5NU:D.@TDQ8!9$5X*C4F^L`[<?5M
MXGR9.,.E9=886)<4!&M2&`7%G932&.S9LV=Z>IKW1N4]OG!3''TP&&19-CL[
MH[7N]7JY0[0IUEY\B4VO>/.=DTLQ(R'$4+C3-,FRK-ELUFHU`/5ZW5HKA!1"
M[-Z]&\.&9\V=AH/!@..#V[P2`),J6"@4FO//0H#`8]$%Q$,'/O;(_0\JLUE,
M5H+8^-[3+SVO(9(D)0"))0<E/,"[UFW_W8^>M>'F>I.9GG^XU_RM+_]J`%%'
MT*HTKE^].NCW?4]%O;ZV9H//=5.[HC,N,:DQS@L"")%D[Y]M457?>3*#=F25
M[S5:K0]ZBMI^7P:^4-+``8BB"$352F7#>9N$+&%N'1ACE*(D20:#@3&F6JWY
MOG]S^0(/(__\YS__N[_[CX\=.\8[K=)&\J?-[;*BG-'&KKI[@*($\U9#GN?S
M#A3<M9-EF>\'O5[WTJ5+#S_\R'OOO1M%D5(RGW3(T?KM7@<PH8*U;E41C(`6
M2`F&A(/PK!@LKTTA_(]^^;>I;9O]QJ:'=N;M4Z^^\,:-,S)4,!F(R)D860+\
MY=/??4LL=0J/V%&?F4U\U8F_^H5??F3Q:,7`AX`3.W?OKC8:(#0:M9#W@+46
MSL)9CJF-BE$!.))2R5!*SPB1.73\!$`K\UO9+2OQVLC:0O=A(^FZ+EM+!K<Z
M\C;PGUJ2I19V6+(4!.!L/9$'7QL]YI<E%7:($$(H->QZ\WU_;6TU"((\*\])
M0@">Y^W9L^?8L>,H3-':9&$5,OWK]=_YS(9AS/%>L;!02+8",,;4:C7?]WB9
M'.;36H=A<.[<N;-GSP+@B0Y$%,<Q9XJDE%*.A5:,Q9OX6>`_)X(#-+BN'8`0
MEEI!O89@W]SN)Q_Y3*>VQ6#/Z_W.#U]Z'B0R:.B$/*&A8^CG7_W)IB-O]%9H
MD![:L?CX@Y^L0@564MYQO6'@P<@IQ8:Y@/R.C#&9-8G)TC@C(:8P!0`&;>^6
MW:1.2B@9H$)"94:O==L?_`0A[O9TEGE""HA&HP$`:;IIYOR85[HKI3A_-Y(8
MEZ899ZRJU6JWV^7-BKD1FMN;B^/8WW[[;6-,$`2L>CQJF>V%7`0Q2OSS90F`
M1QK<,X+%L_H`2"DY%4BCIBY.B699QIJ^8\>.KWSE*P#X#',&EL]PDB1C4C@Z
ML8*U\<);]\*(JF%(P([6S"]^_A>:5[?8OW>MU?_NL]_OZ&X*G9&QT@FHY]Y]
MX87.6UN\CJ5''WGT_J-'"22V"E@-%8J&7QM=+H!`SDF0)Z5P\)1:PQJ`=GB[
MWG>EG>_(`^H(IE1M_^+>]SL=FYF/ZT*[NA=6I"<`S_-`@*<<O\FQMJO6<1N[
ME',180%B%>/"]+S;V?.\UU]__;GG?O2-;_SQ\O)RL]GB*>^;7$)LC+YS.^%@
M,*A4JEKKE965,1E.\.$91:^&%F1>@"8*FZ<F26J,"<-PSYY]ERY=B..XN$-M
M7N"VW4L!)E6P-ID)Q7$)).#@K%$0#]U_XH'[C@%HT([BHYM1[9US[SW_^BLF
M%"9$+$P,_>___$]N?IUFCW;.['CRL<_2^P;71V]BU)&XCA#"$ZJ*BN_[WJU/
M>#,+6VD(8$=:"XV4L?4@I(,$DK5!ZYH%,.6J33,<K9W?N)F9)+P>]NP@]B$J
M\+7)AD:'%&ZBYF%M]%@IC[!C%)$)PW`PB-KM=KO=)J(HBL(P=,X]_?33IT^?
MWK5KE];9S=M);$P4#J]>GF)NC*Y6JWFEY;U!OD8.1>6#5ODVVY5:&RX23)*$
M*V^S+-,CN+!VN]<!3&@=%K!Y.@(5(O$NT]9`!F*A,OU+G_G<^6]>:8L(!4M+
M5&2_W?ON<S]X\L%'$FD=[*M7WGCZA6>G=C36O`V[]73J[I,//7S\T%%EA2-W
MR_Z;T9O(S:MAYQ#W&=,PHI47$\R(J16[MOGA5]MPP+X@NKA,B>A?78'6GO33
MS%7@F1O]>NJ1;V%,W1@A!)#6;S&MP=AL7U"?G:N+S'@@):2@X<!R'B\S0?.P
M"@R#6?FG/3LL4HK%Q<6YN;EJM?KZZZ>N7[_!#F,8AH/!0$JUY9B!XH!DI52W
MVSUQXD2E4GGYY9?3-*U4*GGEY*231^AX-R`I5;Z?<QY*YY!6EF67+EW@>1A<
MRL!SJ+7666;&I%=I8@4+ZU&D#8DY!P+Y2@J2!GCRD4\]\_R/_F;UN>+CUM!I
M5L3S;[U\/KXZ%TX9T+>^]S=KNU33NE9SNMWAC8\PD_C429[\]&<:J-:%YZP3
MPMOTTNN53!O-JXU3`I#$41H8G6;".`"//_C(YT\\*AUB!<#Z&H%UO@%`SI.*
M/.IE#]]WHJI\&%C0`_<_\'O_]7\OFWZ@?.V,U8:D(`?CK`!ML>\S,.A&-:BY
M1DL"D@0`$D(;[38ZK6-N83'N%G`&\($''CARY!@?>>3(L3_YDW^_M+24IFF2
M)+[OKZRL4*'4.W_.3486&QIY`'XP&(Q)Z]R'IVA>\:3VHEBS8`DAE))<)\@&
M*4M50;9*"^L.0:-B]W6-4`K62D#"'FSM^N(CCY_ZX]=[#=TN[/[0:;G+RS>^
M^\(/O_+$+UZ/EK[SX^\WC>C48G2&QTR;D`;I%S_]V6/[#@L0@:0@:ZP4$EM,
ME!GNWY-_\5T2@'500FOMI!5$5AL`'S]\]'<>^$((#`#`!J,Y]`88P`KX'B`R
MU^M$@B2J_O$C1W?M7PC\0$%:.`<#"`G2L)O&RMCUBG_IH!OPR%E`&*.%\DG*
M<?F@_.G(DWHH9`SS*\<YUV@T<K5B#ATZ=.[<.8XH1U%4K]>EE+PK#&TL<R^&
MM#S/NWCQXO7KURN52JO58@/M[J_WHZ,8PD/!P.09;1R8YW/K>5ZGT^$/@R1)
MN"^ZC&%]*-Q-,:P-/PAATBQ+4YLE%<C''CBY?WH>\>88ZI59^X.7GNTC.[-T
MZ4PX\%L;=J:I.D]$^M=_\5?JJJI`VF0*2FL]G(D^LJPV->39F[7,6@!*2-_S
M*[[/<C%5J55`5<@:J`99`55!%5`(JB)T2`G"&!.$8;7NQYF-C%&0/H0'\B%\
MR`#2@_`AMOSN0733M@`Y&"X2C^/86*.MR<5T>+;&XH_PEG`C&U\P:9H1H=EL
MSLS,**6X:O30H4.;'O+@@R>7EI8`Y//(.<F8#S[D-!E;%JR&G!\D$M/3TY[G
M\54Z4<)^._)<!*_4&%NM5KDUA_.`01!PVC1/LVIMHBC:M6O7$T\\4:E4>9ST
MF)R0B12L(IMW6@9L$LMJQ?=\9,8']L[,__KGOR0'V1QMWBSK[]_\R;G^E>\]
M]PR`)=TK_M?JA6N_]4N_?N+@L2G4!&Q5!CK+@B!8G_G^4T+DLDP(X>"R3"=)
M,A_7^U&40"=.9]`Q?SD=6YTXW4/4R]+$93(,>O%@K1][H?"D[&?I`$D*$R'E
MKQA9C"R!WO++]P,`$C++,J<U[XRBQ(09U'RQ.>>L=4*(F9FYCW_\P1,G'E#*
M8Z/@X,'#-S^*NTGX^F0W!]C0,\@&!T9MGJ/RJ_6`X/@4=G]X\B`[K[U6JV99
MYOM^OI\V3V[(#4]V!*>FIA]ZZ.$]>_99:WB87Q"4`_P^)+0^;708<0=`2(UF
M:]X34@%37O7A8R?N6]SWG+NTZ0ENU.GY-UY^X8W7-MW?[-'\U([//?+X`DUK
M&_E&24^0)V#AQ+H9-73ZL!ZU$KBIK$$)(J$@"*F!4TI=#GLO_.3E8#D.#`8>
M+-E`P[.0%I:0>G(0)W49/O'@IT[L.RJ`CG6OO/OZCUYZ)JP%FT8DFV'T?0M6
MKB_MGU_\I<>>W%%MDA">YQFW;IA.VCPL<LZ$87#PX-">JM6J:VNK_7[_TJ4+
MNW=OJ/EX\<6_YY/#2:Y:K4Z$7J]7=`GY5U0L<0!0M-1O=58G$1Z'C\*\"B&$
MY_E+2TLG3IRX[[[[OO6M;Z%P-IAN=[A)[>G3ISW/"\,P2<:BSF-B!8LV_9OC
MA)(L(4I(JS-?>0_>=_]C#WWBN9<OS=CJBMA0-?[MI[[[3N]&\9ZF#3OU^'<.
M/?[X\4<]D(EMI1):XZ0@8[#I+WFH5.3@B&A#@47Q0"DD(!S@AP&@?_CZ*W_Y
MSC,;7O2J"0S@1&PSJVV3JO2?R`-[#E2%'R6#5]]Z_5_]OU^+/U:9NB[9<!="
M@,A92UM=6KZ!BNW#^X]\ZJ%/S$_-`*2D9S(M`.$@Q[[G.:<8%R^Z))U.)\NR
M:K6Z2:T`O/[ZZ^UV>W9VEG?6$T)R'58Q;L47+]T:;*ZHF&"*Z^*AAHU&H]?K
ML8GZ\,./?/.;W\P%FKU":VV_W__.=[[MG`N"P%IGK>4-UK:=L7@3=X:A5)!?
M'2:DN;@&UE5\[XF3G_J+I__NW?KF+N)3URYNNL=SJG$^_?7_XE=J\`DV(,\C
M`<!EX#'?;G3!BYN*KD3A?X=D!@I&"(*T</`D@#5O@_L)H+-3-@<^`21"WPK;
MM?Y,70G?`8U*384R_E@%P-J\&;T."B-7-]/JA^GU[HU!-ZC7B)2V5I%40N:E
M%?FU./[*E1M929*\_/*+/!2%I_<ZY[[SG6]_Z4M?S@]^ZJGOGSY]^L"!`]9:
MK0W/G(NBB(O=-Y6>\HU-PK1)MNX!-E6*AF'8;G>L-4>.'#ESYLQWOO/MA86%
MRY<OLY9AI%F^[Y\^?1K`S,Q,',?M]EHYP.].L-&<+XJ%=59(X7F>3K.,\/'#
M]W_QTY][]]1?ON]3+LO>+S_Z^,E#)Z)!;ZI:)^7K0:I\GQP7I=[B;7#G,ZW[
M7.RE\C!CYYPC:&O2+&NFM8Z_Q?2%3G5H<K>HF411XK((@SC6P@_H`[:=MFOQ
MWMT+3GBB&B0POH."%*!\3L,$S</*716EI'-N>7DYCQ.G:3H8#+[QC7][WWV'
MF\W6*Z^\?/;LV?GY^3`,5U=7A2#NV^%9-,6<(%#L;5Z7I]P*&Y.,V!VA*,'.
M.>X8Y[T7HRAZYIEG&HU&\0!N"`<P,S/;ZW6Y0=KS_#'9E6,LWL0=P`W5*C69
MADMA,J,MP)M$NDS/>=._\-B3.U=^JL#A/_R-WPF@D&H?RB.OWQF,1L??\M5S
MS1*%F8(`2$E(220<8*SMI_&6:E6D[3IKLYDFX\&KA-50^&']`Z?8(V0#D_72
MN&=B=AO).62:)FH>%N<*N$V$Y_F*T3YZ>6L.$3WUU%-_]$=_>/[\^;FY.<_S
M^OW^8X\]]H4O_,+L["S'SEUAK+L0`J!\$GQ>CRH$^;Y/1!R$WKMW_W:O_DZQ
M[@NSRH=A0$11%.W8L:-6JSOG>&8#YT:=&]:X`PB"(`@";C;T_??9X/SN,+&"
MM3FX/;P/4F1.&V<M#1.Q4JF:'SJ8XP?O>^)3CVWY9(U:,[_]:T<^]XE#)S.3
MM&I-OJ#KE0I2NU7-PDWO9Z/#!0#&`M"P#G!BO8J@-?":T>T,IRS+-+2!7NVN
MME=6;G/DEBSY7:M$9++4&B*I,YY5.)QW..;5##F<P^*=3;D4FR,L2BG?]\,P
M%$)XGMJ_?__QX\<7%A8`I&EZ^/#ASWSFLP\__`GV#3N=3KZ[*C^6;P/@@E(6
M1)8J(N(9Y^?/G]W>M=\I:#1_@N<C<V$'U[M'420$.0?/\[C6*DU3KA3EU*H0
M(@B">KWN^[[695G#SPK=I%9N-"1!0DI2BCPE?:UMFAD02/EI'-=5[9%''MGR
M";O]3G[[J[_YVQ5XGO`"S^]W!R#(:N!,YE)M-_[.""`(.#E,6&Y%PC4L66:@
M/2%#SV_J.H#`5[Y_.W]<P7F@$"I4LEZMO>\YV<1,4FG5&J'O<<-VDFH(@J\<
M"4`XPOJNLF.,VS""?;UQ%QO+W[E>1&O-4<N#!P_RPSE;7ZT.RUD*7L_ZV+_\
MA912O`T/S_^[9V)8G"7<LE4@GZ(S*N\8GMM1RR'EHZ*)2(BQ."$3*5C`*%[E
M`((A9(`9U1DD[7X`!``)E1*MQDD"M*.NA&S.#;?;GIK?>:LG/OW&&P1-5CF'
M6KW*9>/D2PI)^/DP&RM@!00<?RE`L"MH-FIIX`5PJ'H!^YA26XY(75?1DMRB
M^:/I5P`LK,JY>D,BR^)^,_"3]@<>+U-UPG4[+:_2\JI:IY5:M9^9#,B$<D)H
M(5AZU7@':W+5X+?)EU!.?BWQ7A)L-X5A^.:;;_*C3ITZQ9=B[AAN"KH7+]TH
MBM;6UG@DO+OUGM(3!Y_"VR=#G7-L?'%"D(A&C8?#SD//4V,2PYKPH#O!85TC
M>$^*P`O((M,0$$*14X$&_&:]C=ZW_NI;_+BUZU=O]91//_O,;SS^Y8:L=/JV
M517.P,2Q4H!0()9)(48;+`,;:MYSR\\AO^783Q2`!`72BY,4FRM8U^FD$3\G
MNRR^KZ0(IJ=G/^B)23L]4:W:*'+5P&AG*5">(H*F82H3HW[L\6>4*!QJT\U7
M77Z8M;;1:)PY<^:/_N@/>(2#YWE<J%VT+(:_GT+>D"TLS_.R+!-">)YWSY1B
M%34Z7VSQO_@[?P9@9&UQ9R4`:YU2,$:5%M:'HS#.I7@'.02^!PMCM/*&]:06
M\&7U^;=?^:O3/VYFPP!VLS*UY1/_W?*KS[[ZH@/Z:=\0G'"D>/:RA3$?](RM
M_W%@V`6R6HT`-'NW^ZC(G$@-`34K*FUC+B_?--KAMC3[(H!LUNJ^5"$%M;`B
MB(PV6X38QIN\IB&O>"U851L26_F=_7Z_4JFLK:VMK*QPJPT'K;;TB?@AQAC/
M\RY?OGSV[-F9F1F>PKQE#?TD0AMKT-R&@:O#G.G()13.63Y`KB-XTM^8*/C$
M6UCYOYR><W:H*+ZG>$?[)$UBW_20?NOOO@T`VL!#,YSN1*LW/]\.?^9&NO+'
M?_[-7WCPL_6*O]3NS+>:0@:PQF2Q#'W<JO;I%C*0FP"$X373['B[=^]6)A%:
M]#QH:96%=%9:6!*1M2ZS<],UWWK:ZHI0PGI[9G8=[\[%H99"YD,%K+76V2VW
MM/`J\#W7J-?75E>FYJID5>!5JIYT!.LVQ*[L>*M7P7-QHU@,Q,;YQ7Q(;CX(
M(9(D2=.,BQLVS7TORAQ&@BBE7%MKGSQY,@S#5UYY10C1:K4N7#AW;R0*W<:A
M]47-&IV6/"H__+MBP<KO%&*,2O\G6;!H@W"LVP[.P3FAA`,RHZ4O'>SW3_WP
MN3=>F37><CUKV5K%\SM;3$D"!SN>ZKS^O>>?^:U/?7DMB5+`)Y`D,F(4$`#O
MI;S^PK=[DP1N')6PUFJM5>A]^H&'_ZLO_Z,P$[T`J;32@1R$@Q%831-/>'Z*
M_<V%9DI9+VU6_2\<?_21W_O7VEO?"\"-QD)MN36`$3;121;'AZ8/5B`IT3`.
MDJQ!<1+A^+N#>_;L>?WUUSFU)X2PU@@Q'(?"XYR(-D3B\W/B>2[+-&?Q^;3S
M$])HQB;OO9ZW'!)1I5+Q?3^.8ZY+VLYEWU'2-!O)D^59TL88]JQ'Y]#F208>
M+Y.F*9>)<@-YK]=O-!K]_N#\^?/[]FWSYK(3*5BNH!P8J?1[Q0``(`!)1$%4
M.6D"H]IOZZS60OFIL4*2@NSHU3__SM]<J43-G@3@"7FU>XT?>^S(@V^]\Q,`
M<[4=:9PLZ[5I?WHU7?WS[_SUES_UA4JK/G!)FNJZ'XI1'<H'RZZM"]8P0$`D
MCNX_O"N<JI(8^,C(YK6F&ICQ2,$+*Z@",H5R/@1V3[7:B72>Y9&1//F*D_1;
M"E9&;N!E7=F+]4!J)3/(,(2#%*"-N>GQURP,/1=XGDH2(P0E21:&%=_W>[W>
M)A</&P,T1<L"&X/NFYS*6JUZZM2IY>7E'3MV..?:[39'ONX!W/H608Y%2BF5
M)"G/J&`YJU:KG4ZGU6K5:C5>N-;Z^/&/=;N=)$DJE7!Y>;E6JXU#L?OVOX,/
MS_I\9`ZG&NV<`9RV&:07(WWVA1_]Y*W7T$"G;@"D5K/(W;_SR!<_]5D6K#1)
MG"`8K*:K`-Z\</IOG__NKWSRB[%-`[*Q213(4UO5SFWM(HX8S<9D155*95DB
MB0)2D"(@"%B>6".&"4A+L!Z$Y)1G`/20D:[6?*NL%'*]@$+`"BNVBJD)N!3V
M_V?OS:/DNN[[SN_OWON66GOO!AJ]`"``@@2XDZ!(D^(B49(M2SYC61HG<^))
MCI?D)/'QFDGLL3.*D\R9.,XH\<F9,YXX=JPHEF1+UF9;(B41W!=0)$$2!`D"
MQ-+H;J#WVI?WWKV_^>-655<W&B!`$N@N\'U.GT*A^M6K>ZOZ?>MW?_>W9-RT
M"Y%0";*N=8:N&R$(#-%\US9X\C.:-I']?LIDTKZ?`'AJ:JI5I,FJT+G^J997
M?=4"L'5\2[#L&C.93*73:69>6%CP??^JJ8?5[K&RCT11Y#BJ5`J#(+!&J/W:
MV[1ID];ZS)DS@X-#F4QZRY81`(<.O1Y%8:E42J<SP\/#ZS@12P<+%K<UJ&F8
M5P!J=6,,E(!@`V:8,_G91Y]Z8BZSO$M=:.8_WS"Z\\Z=>_Z\DL@EJX5H.12K
M7W9K#P\_]>B^.^Y("I&5J2"H!+6H*Z-`1,T,Z(NZV)N7BH8F(M=U"WXQ5RF>
M+L\E(RHZB"030\`0"TTHZKKC>(-N5R)$EW%!`I)%4ITL3&FGL??<\C5PL^_+
M*K0P)B$]J%J`C.LCBD@H*)*NX*BY:[GAI<K2L@Y2J>3.G;OL@_E\?GY^WO.\
M2J5RCABMMK9:Q>>85_>F;[Y"X[[-3[3Q[K7:6BZ#SJ0E57:]'$61[_MGSIS9
MLF7+SIT['W_\<7M`-ILME4I+2TN[=NUJ+:*GIB8W;]YL@^/7;0)M=*I@\<HE
M8?,#`5R7@BHD-$Q$N@;]UNGC3S[_=+97%KJ7K^WN,)ES*A^[\4.W^#M^_*X/
M?_F5A].IWE*Y$5`^KW/2I!]][O&/OO;``S?<74'-<Y0C5*19-J/5B:B9*7A!
MZ7(<,/N^;Z")J%*I])C$?_GJ%Y_XWO>E0<E%)(QD2&9IR!#(]W6@1:[^RW_W
MYW_REOL<H!SQUW[PG3]Y^,OH4JO*RYRO9I,R<$/>TC7P;W[MMQDD'`>A021A
MF%3C^@\1V%)3[_XSN"*L<I-;K.\I"(*F.IE6N?>6Y75NQY?6D0"W!W/92]'S
M7.OPLBW1KIHXK',_8IOG7"Z7-V_>?-==/_;TT\_8-[/525M*N;"P`.#99Y_N
MZ>E)I5*52F73IO.&+EY).E6PSHM@`RU=-Q>6M>-6$/[E=[_M9!/LKHCHS#F5
MAY+7[]D\[B.Z9\]M7W[EX99:6682)6QS'W[\![?LN2$ILIJ,KUP%Q;JI3K9Z
MNG7ULVT(?[&$$J\MG"JD(IQ[490!H&L>IW)G%U#P(E$S*%#U)6\:->"BO_5W
ME#,^JT*EU-V53I"`4HUUX$8/;E^-%22E5*%0F)@X.3:V]?GGGRT6B^WAG:ML
MJU5KP-9Y6@>V)1(N]U*U;?N"(+#%@J^:)A0M$[5UWQ@3AM&6+5M>>>65*(J4
MDE&DB6A\?-N;;QXNE\N.XV2SV>>>>WI^?G[GSIUGSY[=NG7K77?=O<XS`=#!
M<5BK/-]MR3HLA09*4<A0/SKVRF,O/"53;BZY^GOFD_=\=&=Z2U+SO3?NNS6[
MH_U7O2H!(%OW_GKRP$NOOQ0!]3!:^5X)6K;QS*6&-N55I9"Z4%O*_!"$"Q>.
MI[R,FTAVGS_2]#S,5_*+M5*Q7@UT&+*!1(>%8#6Q\=;&&-=U\_G\CWYT8'%Q
M,9%(V)I-+0.JM5MO5W/,UE/C**6LW=2\8D4SX(BY&7QD6TD3D5(RF4RVTJW7
M>^KO#]8,7PZ%:8@U>GM[`;SUUENM#<$WWSR\?__^S9LW-PNN4G]_?Z52<1SG
M_OL?7.=I-.E@P;*(%9>A"6HE2"J&93^1J$'_Q5]_H[3=J\C5=L5M:NN^Z_;Z
MH#2K`:0_>?_'VG^[&%6S?J;@U0'\S0\>F:O.DR,`5"H5-,-3+RM]2T(1).``
M0(CHDION&D<8*8PC(DE:0!O3V!SH-,UJZ8M=R&BM>WIZ;,:?[:/7[I9J&5E2
M-@ZV<:%-4XMH94OZUG]M<*EU"-H]_@WBLGGOM/OLF-E6J26B*(J&AH:L]"LE
MN[N[7WKII3???/.&&VZ(HJA6JP.P*=`WWWSS>D]BF0X6K!6EW)O))E*IP$0A
M,T,]>OB)`Z^_W!4DVOOE6'[RW@>'NOJC6N"2(V`^>L?=??D5J^-"K='C_KF7
M7GCV1P<\)#1,PV7%S3I^[Y:LOM!RHZLFG-"(>B0X1%A'M6Z*E]QR2G@N)5SR
M7`&7I61!AFWE"*`M*V#CT](:8QI6=!B&:-8@;6T4MJJPVTOQPQ_^\._^[O_1
MW]]?*I62R613@-H]\JN#(=M7E%C+]=.AM'GK1%MQ'K8+:ILQ;K\,4JG4)S_Y
MR5:`>R*14$IMV3(\,K+.L5?M=+!@+=,R',A(SPV-<5RWB/)7O_UU[:N\NSJ@
M9FLQ><^M=Z0]7VCF2)LP&''Z/WGO@P"Z_15U$;K8RV]QO__H#_-<KD?U9"+=
M4*O+"9$D(:5R)7G2\93GJTO?8L\E@H#82#(@AB!))"'4:@MKXVM6R^D.+*M2
MVSX@VCWNS%RI5&ZZZ:9;;[T=P/#P\$K?^?+)F@ZL-<J-MNY?H1E>9MKW%MI8
M$8D615&I5!H<'/S8QSY1K5:UUOW]_<SL.,[NW7O6>P8KN"H$JPT&"U<1Q'>?
M^/ZAM]YT4ZN]/UTY?N"VNT=[-_O2E8ZJ!74'0H$__<`G-E=<KJYP@^>IWK6@
MCQP[LG__#Y=WY%9=Y(1+K=-2D!<*2LQYX9E^79:H`!6(BA`UYQ)+C@(``M8A
M<=3T[S5;4'<D+8GAU:S8"K3KG=;F:;E<CB(MEKNH<IO=1.=>QNU.^JN&MA(7
MC7:JK3(,]I:([/UZO3XY.6$=?Y5*I5`HW'GG7>L]_-5TJF"1:?ZT_L"$8<)<
M,0?IY%#[V\<>@>_,8G7:<+>7OO?V.ST2`E*`C&9%BG1XX^:=NS9OS5.XZG@O
MG2QR^*U''ZZY*"$,Y6H;BP&0``D;VR0A&CN'U$QQ)!",!"0;R1!\<>I&TH#8
MSO)=M9QR-53$"@V'NP"BJ#&J#KHH5XI38^]O9=3HLH\&@!#BV+%C1X\>>?CA
M[[[\\LMC8Z.M)226NWLMG[CU0BV;:\6ZL?,A6J'+S7(QCKUU',?S/-OU*YU.
MCXR,60F;FIKN[^]?[[&O04<*5L.FL3\:,#!L0I@JC,BD%U![]/7G7YEX._#6
MF-U0]^"=-]Z=$,EJI5JOUE-NRI5>:;'@0/[XAQ_*3M7[`J_'>+V!&@C=KIH(
M8!9&U,/1D3_^_M<+X!(%6IIRN5#.Y<"D#1?#*(!@ZU)C0:912SD$`@(KE"ME
M$P;0@:.-,J:_M^=\\\J:ACV8GHBZ'5]!EW*+:2B3+W?G+LW(VE9.)G+U'JUD
M4$%0EXPH8.F``29HT7+Z;73:EH1`,PJTW85L[Y1*I6*Q5*E4;27EKW[UJ\\\
M\TPZG3YSYDPK^[)E81&MN(S;8T>;!UP]3O>1D3$[G98SJV58H;E@M(WIB\7B
MY.2$4FIV=FYH:.#ZZ_>N]]C7H",%:S7$3"8"0G#>5,L(_^POOLR.;+7/L70C
MVYUS?OI3_Y,')2$]Q_62&;C*U(/!G@%B?>>-M]VT<V]]KBBKC')HJO6\;^!Z
M]NE/O_'*`DIE!.6HDLIF4WX"AH4@J=R06]W3EV\-$`$:\-.^<!Q/RH3CNDK.
MSJWH*M:.#<'/GJ645BCI#!*;N_O90`6L\I?@=\_.1/G3LRG(A!$9-^D+A8CK
M];HQR^D!G1*/U5JX6?/*QAS8"\PJEVWS.38VMG?OGJ&A02)A=P_ME9E*I:RN
M-2,5&GHD1,/6L-7IFEF^)1N'E4JEUDS2[%!L=K<M*FU[/B>32;LW:BM_V2I@
MB41B9&1L=G:V4BGOW7O3>H]Z;3HV<%0L^]J9H*GAJ<F(]!,'O__\\\]OWC4>
M1JTH3W2+;,X4]O1LOOOV?1+0B(@$P@".&P2!ZR<=F*V9D8_><]_+KQU,*+<F
MH1T)5'/4:,GUY/1+CQ]\^J=O_D@8!9"`XUBGD`.$S.?+=(F,<05Q&)9,+8A"
MQW5U4+ECT^[=B1%74]EE37"-40;*0!-*44@CHL=);<H.1/7(\Q1'N/':&S]]
MYT="%5%K46--#%K>S#+-MX(88AP)1VWNZM<PD8E,:!S/225](NBVA<[&3R1$
M<P%()**HT:FX7J_7:C5FMC%6X^/C8V-C.W8TLG8>?WS_DT\^&4617>8$0=`J
M14#-NEI-AWU#O&P^W?;MVV^]]=:77GII>GJZ5"J]NV7XQJ1E80%P75=*62J5
M/,]32M5J]4JEXGE>)I,10KSUUIO3T].?_.2GUGO(YZ4C!:M1K<$F#3,,-5:'
M`$6(_ON??6F@IU=!5*OUK)^T9HL?T<"B>O#3'\XBZ4*9J*I4!JQAM'0$P"[<
M,BKWW/:AKVWZJPIT7AN92D"O\(X_NO^)!Z[?-^[WA/7`L;VW&!*P-4_.1=@D
M$B&C*-(F"K6.V)`4=]U\Q[^X_^\E650($8P$"$R@",@C9(@N)!T@Q2"#A(M]
M>V[8O7L;DZ96O5L0@0QLMZ!EGY1IO#^&X$0(^N!+2"-"`*T*MP)HE6S8^'Z:
MID-)V_O5:M4618FBJ%:K#0X./O#`1]J/O^^^!YY]]EG;/-4&29Y[3FJ+,K5K
M(M_WB\7BXN)BM5IU7?>J"7.W<%N(K)32*G@BD2@4"FA*6#*9M`5:K[EF0U<N
M[-0EH;6J-!JWK4#WQY[9__K!5S?U#:`>BGJ4%EZ/3@,X*_*C77T/W76O#NL"
M1@H9!`&DA""E5%BO*\!4Z]=T;;G_EGV%,W/*<:.55M.(''KIX,M///44(((H
M!+.-YQ2M^@FK(@8`-(-]'-_/I#*V"6@^:[K3F23#K8F,%BF()(LDD\_"A>A"
M,H.$`A#J4B&,*BCF-1C=,MTC4EV4ZJ)4-U)9)#-(="'1A607DMU(9I',(MF-
M9#>2:20%H*`:^L6L@\AH&-,!<0RK:+G8PS!BYG0ZG4@DPC"L5JL`K5(K2RJ5
MHF93+Z64[:*ZZIB6S64O8UL<.9?+22E==Z,D^KY?M()C[=HP"$*EE$TG)$(J
ME7(<Q\9_.(ZS>_?UZSW>"]&1@F4=,;S"0&CLS7WO.]^]9G1[4*BB'*JJ*9V9
M6Y*EU*GZX+'ZG;MOOG9@:[?C%PI+KO!*I0((D")BXTA5JY7[$MD$G`?ON,<-
MF.JF&.8`9-Q&/?6TDU0D'OGN=\MAQ4^EX*I`1P"($-97[RVNQI@(F@FACK)5
MIQ(%(0$2==GPS8>$B(R&*:->1<"`Y\BDZTB@)R,5(60$6/Z)0!%$!!&!`E``
MBD!A\T>#"ZC,UN8#A'4.(ZV%$$)BPY2-O#2,,5&DF7E@8.#..^_:M6M7(I%0
MRAD:&ESS>%NFKEZO6X=7>SQ$ZYAVY[J]F)G9FA[MW6*N#JBM;*%]))%(+"XN
M`A@<'+2].PN%0F]OK^V,MY'IR"7A2MBZL^Q'\:O_^)_T;1XZ/CD1.AS`Y,KY
MQ4*Q.YF>/G3DWEOOZH(O036')2B=S=B,92DE"2'J\"`U^*9MNS^R[]ZOO?@$
M,CZ`8K!@7V;^]'2:Y=GIV<<>>_QG'OH4"-)3$`@,!SIRT!8KQ<MF%QMFXB`,
M:F&@P9#"3Z5>??O(=[L.>"%57$22E88M.LJ$,FNC=9;].W?=N$EE*M6:(_TC
M4Z?>SD^&,FKLCK4VX)L^K';[P1"83+H[42^41G</")*.)VWF8QA"R4;OB4XI
M+V-A-D(T.@9NV3)Z].C18K%TOJNK5JO98$@`Y7)%*=GFPUH.6FB/AR`BW_?M
MLLAV)[R:?%AH:A8`*64JE51*S<[.;MVZ=?OV[0<.'$BE4N5R64I9+!;7>Z3O
M0*<*UJJRG[)1ZD7L'KV&(;JW[C7@"*@CB$`N1.KZ'W,A*M6RDT@D7;]4*G:E
M,Y5*)>'[0LHHBA)>HEHJI=*IP73WYS[Q4S?==^^\+LTM+>5R>:UURO5/'#K2
MFTA7SBP^\<03'[WKPUVIC')4!`YU!$?R>1+U[#>VY_L1PT_X1M"LR3WRVI//
M?&^_,*(PNFSS9"<C`(41!6!LPOW\/_G-G_FQCZ>Z_3#"2Z^__'_^C_]<=K4`
M,2UONK,@9K:^<]/VGD@VU7S^NBU;M_WNIMU#VR%$M5I/*%^I3O!:K:05PEZO
MUUM%UNOU>K5:F9]?0U-^]*,#`&QP0S:;M3U!J5G_UW5=:VM8]Y9M(`K`+I2L
M`MIC-KZM<?'8W)JIJ=/<[!H+8&!@H%0JY?/Y;#9+1$$0+"XN;MZ\^?#A0QLS
MH,'2D8)%#")(-#:I@480-P,:Q#`2T(`#N&CLY?F0#N`GL@`@X:<=@DDF?08S
MM!0"0":11L0`?NRF.Z^E:A7<WB-902C`TW"8'*A01Z$41$(ZCFRV1&P?H2`8
M0$C)K,%&"2=?++8VYDI;5K_S5JH`#.IT$;DRU<JHI.!H`:2HX-?SPZ)'IY=D
M8]<R&R4+JK+F^Y.M>5F_QTLEE.\9@`79^IG$,!&3(`%RX%I3XKU\$%<`&V?@
M.$Z]7C]]^N3HZ-;#AP_E<CDB*A:+K[SR\DTWW=)^_)-//KFTM-3;V]NJ34Y$
MU6J-"*TZ8D34:K336OUQ,Q>Z&45Q55E8`+9L&3UQXFT;F];5U77===<=.G3H
MY,F3P\/#2TM+2JE<+C<Z.EHNE]=[I!>B(P5K=55B7GY8`0PA":;9(,9`",!!
M*U9RC3]$NVT$!EB`X0!=TDN3,1#<.$^S\A5'D@@,%D2TW():G*-9[32,((*^
M"'VHRR@_ID(91="A$)HX4&%^6`!HJ16`\ZD5@()?=P/%M,K-=\ZLWWDLZT]_
M?W^Q6+3[7$>.O/7FFT=LE5'K)G_^^>>UUMEL5FM=*!0??_SQA87YP<&AQ<6%
M8K&DE+2%M#ROX4=OQ<>WY_K8%VJEL+0'/5Q-3$]/$I%-<K;J?/WUU]N-5R*R
M=746%Q<]SSMQXNT-V^6L(P5K]597\T\.`)@)(((@@`4(YZ0KB_-I%D`@`6;!
M2,,##$,TA:^QVJH#K3#IYHNS/,_FFT"SR!\:(>87$_J41PV`ECJ"CD"&H"^E
M.J!%"VB":6H64YL\==25>.NMM[[ZZJMS<_..XU0JY5PNETPF,YE,J52R?6X>
M?71_,IF04DY-3263R8&!@9F9F=[>WEMNN?7(D3?/GCV;S6:KU9H0*[H]TUJT
MNH=>3:DY+8:'1R8F3D91M'?OC<>.O66[,;9JZ?B^+Z7,Y7+;MV^WX0X;DXX4
M+&"ED76N"G"K",R:Y=>7-6OY0F8!HN6&/`QP(S>PU>6"`2;)C1#-1A2B?9GE
M6LEMYMX*7[C]N6BKQC1W0@W`ERY8!LO!M.W0RN%U1.SHC3?>>.C0H:FIR5JM
MEDZG:[5:K5:+HL@84ZE4>GJZ"X5"K5;K[^\GHJ6EI3U[]OS<S_U]`-_ZUC<6
M%A:TUG;!A^:Z#VT&U"K!LEVPT*Q[=Y5A+5-K:J52*0">YW5U=<W.SMI9)Q()
MW_<7%A9L<==U'NY:=*1@->1A^3(^9[O^W`N1SKD#+)?1HJ8E1#`,:O==+=>N
M80*4$&;Y]`9HZ9E<<=:F?+6_S"5E'1,+`0*$`.A=U;3AIH5U[I77"3*U@KU[
M]QH3O?'&&U&D:[6:YWEA&!IC/,^SEH+6QH:_!T%P[;77VF?YOB^$J%:K-K*7
M5_:D0%LT5NO6*IHQ:W?WZ'2XV<C2<9Q:K6;OE\OE3"93*I5MV-K\_+R-<ECO
MP:Y-QWXJM/S#Y_RL70YXQ8/M5W$C),<0#,$(:-E83RWG!C8+@DL2BH2$D!`*
MY#!)P\*L(42KWMF+7Q(V!LN28&.GI+QTP6J:@:O5JN,"1UO<>./-NW?O9C:V
M!Y?6VF;`V9(RCJ,`2*D<QYEK9FN^^.*+BXN+J53*?GCMPB2E!):K!MOC$XF$
MM3O2Z52IM*%]S^\.&R\:AN'8V-9=NW;;78AT.DU$B83O^WX8AH5"P77=:G6#
M-@WJ3`L+`!HKIM6_(J*F6#17<F`LZP>A38;:Y(.;EW<C-YA`@"0(;A7G7%:-
MQOFYL=(CLL[Z]Q,R2D(JEL8(J2\]$==J]_LZI'7GIIMN<5WWM==>6UI:\GV_
M7"[;Z"$K.DHI&WOUW'//+2TM+2XN3D]/#PT-%0J%5A12:_5GZT.%X7+Y=L_S
M/,\KE\LVYGM^?FYR<F)#%=M\=[1F,35U>F1D;'IZ<G1T?')RPACC^[YMBVV3
M-&WU4==UZ_5Z%(4G3Q[?NG7[>@]_-1O4PB*&;J8TF^8CMA]HPPXZ_W.Y+1-X
M[8O6NI[L"G"EW=42.ULJWHH?"9!LW*XXQ[+_BR6,7/F[Y?&0,`0#00QU$4ZL
M`=V5/6TD`S;Q2+RK8EBA5%H(%J)1^@;MBT/&VDO%C<]UU^VY^>:;,YE,K5:S
MUUBY7+:K0AM,9(V(EU]^^>3)DY[GV2CVUM-Y!<OZY7G>_/S\*Z^\DLEDDLGD
MF3-G4JE4+I=?QYF^7[1KK@W%FIR<L/]M5;RPP1^M>(XP#'W?GYT];UF1=62#
M6EAY+F8%6$G=LH2:!I'MQ^``:S8];K$<8+2V1*S>.J25#YFV@U:E"K:=3S0+
MRQOH9@LMFV1,#>T+M99"!H`-'>MS,Y69.;C*%2Z:PBH9TC2"W14H[:E`)J-"
M4<")@!JJQ6IITT*RXC;?A';;<*U`*E<C6R.WQ%$^D!FG4BXEDFE="B4(G@)#
M2U-#X'AN)ZX0=^W:[;KNTT\_72@4$HF$-8B"(*C7Z[9RINT`!D`(42J5:K6:
MK1Z#-@NKM0R44G*SA_N9,V>V;=N6R63R^;P08FIJ<N_>&]9KFN\OT].3UJW>
M=-(M%Y6VC]A-#`!VS;AA(]$VJ&!9M+#E^0#`]BM&T^9RW@?/\6J]:S_A1:W!
M5CG5V8`$8%J%$1J9(("$&R$RM:A>+&]*]]V^[X[[[_@QR2`6@@VQ(!AIA(`A
M0TG7+2SEK[MVEPMH!&GR[MQST_\U/E:7:PCTFI&?RL#7,JQ4KQW9(8'`$`#I
M.LT!&[9U#PGOP[NX'FS=NMUQG&>>>79J:I*9;9A5JZ6@C6*WYH-2*IE,AF'8
M\A^TL@BYV6A'*54NEV^[[;;=NW>__?;;UBZ;FYN34IXZ=6I\?'Q=Y_I>F9R<
ML!6OPC!LR5-[O58T.A6&-KW<&%.KU>KU>D]/[X$#S^W;]Z'UGL$*-K1@K=BJ
M:T]T7H_!7(B6MZRU#]"JUD!$`#=5-ZS5LSW9.VZXZ6.[[_8`T7!_D2TO(\`.
M)(&C,)+,4;$2A$$RG?W0R*[;I5PSZ'1-P=)`"%6**@Z$!%)>$FSM/4`!)`R$
M@6"(C@AK6),M6T8_^]G1O_B+KTQ/3T=19$OQ62^R+1=C+U$`6C>2;]"T+YH7
MZG)`EN_[BXN+Q6(QG4X'09!()!S'2:=31XX<Z73!LEL3]7K="I;-#&^5P+>"
M9:VJE>(5^KX?77I_N<O-AKOV+>=KA-5P@5_AT5P,U/)[K?":$9%A4P]J!E'2
M3RBEBL6BCK0$'`@%DA"22;)0AJ06!`$CE/2(E9)N*M4%X8!<%;(7K/'CKO63
MB`A1F!".B2(`OML<D^WSU?P?$\Q&_0.X2#[WN9\='1T-`AOBX-M2Y;9K81`$
M=@.15Y;KX[;6T%:M`-CP*\=Q$HE$.IU.I]/5:C693)\Y<V9])_C>L>IC)<GV
M]0H:A%$415$4AJ$-;;,=9UM]9!<7%QW'>?WUU]9[!BO8T!866E[PMG#'AN6R
M;B,Z#\V1G1NH:3<90T1""%<YN7JM6JU'<()FQ81F53[`MHJ@P"$7GA)P`40<
M$B.IW(N7:08\%D1D&!Y`NKFEZC6\[TR"09VN5I;/?.:SW_G.=PX>/)A()(10
MM5K5YC9;=WNI5!)"&L-:-TH`6:M!"&$,2TD`6V>-;<-GR]%89F=GNKN[#AX\
MN*$ZB5XJUL=7K=:8N5JMG+LDY&8):2M5]HXQ9F%A(9E,VBHT&X>-*UAK^(,9
MQ)`;<[>^J58M1Z7U@C4WH?R0*]:7Z3A.*ITZ7W&J"`"I9A8W`R8*60F$HF'`
M\47<`N#`>*YLI#A:EU7K]3:B@?J>^-2G/N4XSE-//95*I:,H#(+`<9QF?)93
MK59MN2NLM+!L5%:KJT5[0%;+9^^ZSLS,S#I.[;U3K=9L=>EZO6YW4=N[S[8$
MRQAC;Z(HLO&WE4IE86$A#,,-%?6^<07+PFU.=WLK^*)2B*\PK7$V8^<;_Q&"
MPC!4CJ-(,;,!,Y$KE8,H$:WQYAO#KMO8G(P,(DUIUP6@#1L8T59&QMX2\ZI'
M;`*CJ875&A*I!`!$`#7K(K?M)@@T(D6N`C[QB4]DL]E''OF^[_L`U^N!K>$G
MI70<UQB]RH?5+-*PW!_,IN:TVO`PL]8FF?3FY^?7>W+OGM=>>^7MMX\-#`P`
M6%Q<<EW'+@D!V$[:W-;9L=7=PQACVZF>.''BQAMO/'DR%JR+8$5<.*U.T]M0
M\'FB6"VU6LV1)(62KL."JO5:L5#T(!T^9R:$>A"1<FSE!P<PD9'2INB0%1LK
M.*V]R&S>```@`$E$051;!J]Z!(``DAG%E0@`0D1!H!(NS.JP,[M<O6JX^^Z[
ME5+?_.8WB-#;VSL[.QL$83*9,&:YLE5+F]HV*XC:2KRW'F?F>KV62J654B^^
M^.)MM]UVI>?SGIF>GDRE4KMV[9J?G[?5G[76=@>P?55H/58K!8NUCHPQY7)Y
M:6EI0Y4&VRB"U>VG<K7E9(B"K&(0GN]K-/N.-CP](`(!QC3BGMKS+7#^JB!K
M[J9=/AI^-T98"S*93!5:(XJ,#G6DV9`0`+4W_FDIAY=T0,W>IX"74.!6W?J+
MCXL1@D`)!0)<*,]ME62-`DV.9*"B*XXCY[N#[IJ?\S=H'L:ELF_?OB"H[]__
MPXF)T\EDPG6=2J7J>5Z]7D?;W\:JY:%]KVWX>\M#;S?+2J52-IOM+-?[R9/'
M*Y5*K5:S\@1@Y\Z=DY.3)T^>K-5J=H[M/JQ63)9N8I?&01"DT^DWWGCCWGOO
M??31[S_XX$/K/3-@XPA6NUJU*`<U:P08-B(T;$0$#@`-G?(W;E^3=FEL"25!
M:G`M"J7G>FD_0M2^<V`O)5ORN'E5-6X;-1O(7+Q@&=CB$S`0(#`)4,,G*!(R
M5R\(STO)="6L;BIX8?)J<+VWN.>>>S.9]#>_^<VYN;E4*F7C(>V5:9WQJW8)
M[<7)S>I]-H;+ACU(*0N%0G]_?ZE4FIZ>'AX>7N_)-3A]^O3HZ&C[(S:$W9I+
MMBZCZ[K,7"@49F9FIJ:F1D9&;KOMME.G3DU,3(1AHPE%>RB65:I6PT<;UE`N
ME^T9NKJZUFFNJ]DH@K4FU7H]A`D!5R@XBD@Z@!(PV(AY)2V=$FT9BXTO;2(&
MLZ#`:/*\.FL#9KF<7MV:#3>T:_7\U,J25A=&`W71:";4/CZ"`:C`@0,1@)]Z
M_FDCM'*=+"4**QN:=30WW71+)I/YRE>^<OSX\9Z>GEJM)J5B#LOE<CJ=MGVN
M$HF$7>D(0<8L1VG9*]8N#8FH7"[;F(#U+78^.3DIA&@IYBJU`K!E2^.1J:G3
M5G-MZ'\413T]/8N+BX<.'1H;&TNGT]NW;S][]NS,S*SK.LP<AI$0%`2!%72E
ME*W4:FLY&&,<QSESYDPZG=Z__]$''GCPBDY[+3:08&6]9*&^HHJF]!S;F"H"
M2V;69`BA(<`XYVD%N"ZL2NM9SJ^VW^%@&UH`*=B5D<0;$\?>W#GAAVN8-H8-
MSJF.0PS!YN+3:)@0"J$)S=!0:A7,<96JAI5:)7C]U%N//__D;#J"*;W#Z3J0
M[=MW_/9O_\X7OO`'SS[[W/#PL`TXLK6T;%_HEG/='F]-K983QSYH$X/GYN8R
MF<S$Q$2K:LWE9G)RTMX9&1E9=><=L?.RA;ULN+^5GDPF<_;L62)*)I.#@X.^
M[[_QQAO,G,UF:[6:,<9U7:UUH5#06MM8?]NB44JYM+24R^7.UWSS"K.!!&N5
M6@%(9-+&M@LE,@)$`F!!Q/1^UT9XSZQ0&%XA6$1@4(B(E5"^MY"J/?[:BX\=
M>$:NG(+MFM/N@VLIE&`(0Y>T<I/&ICC:=CF"V-I]IEZJ.JXT@F>*\TO]LD=Z
M2[I^J9/M%'[MUWY3J?_TXHLO)I/)=#H]/S]O:VQ::\+NWUL'3FNSK.76,8:-
M,:E4:G9V=G1T]/CQXU=LV!<O3^?2VN)LA:U;X]&6#S/&%`J%I:6E=#I]W777
MG3HUL;"P8*W.8K%H$P:$$+:C*II1\OE\OE`H1I$^<.#`OGW[WJ]IOCLVD&"=
M2R6L6_.*`<T&1AOF"`0R2CKK/;KSPVVWMK448,`L!2D)X&1A\I+/>:E[!FM]
M'6:+KB)R6=1JU5R_["+G*E8KRR__\J_\\1__?R^\\(+C.*E4RL;!VZQ#-%R'
MW"92RS`;:VL4"H5"H3`X./CZZZ_OV;/GO0QF>GH:@%W973ZG6/MVIY321K77
M:C4;!A@$@4UU%D+T]O;XOC<S,U.OUY/)I%+*NNJM_\L:F-8=-C<WV]W=8\>_
MOFQHP7KSS3?G[EZHA62TYY-TA2\<Y4@!R`WGPSJ?Q2>@M894@("@T*RQ0YPE
M%TU%RG/0_JMNK0#DY/N3TE7(!``&17?.5'NDOZ2ODLW!"_,+O_!+75W=^_<_
MRLRMJNTVP;`E4^T!W];];/\IEZN)1.+$B1,WWWSSX<.'+T:P3ITZ98VX51O3
MCN.TIR5>;A>^G9&-F+4:;>W*1")AC+%Y2S8-H+>W5VN3S^<JE8IMMMK2="M8
MV6QV9F;FVFMW'SMV[.VWWU[?7O8;6K`.OO7ZS_WJ+PZZF;'NP?'-H^.CX\-;
MM@P,#:42J9%T?S-UCT0CV@$$,+%8.WUGK7)5:P73+Q]Q:4:-6?$47G:G"V,<
M:1*00FL=A%F3+H@5;J/"2I%JY_V2JG9F30Z`=@@;*+SF\O+9SWZ.V3SRR,-*
M*9M29S<06[85FJ$,*_;[M:E4*MEL=G%QL5*IA&'8'I!U^O1I&SM>K]=+I5)[
M22D`GN?96C>NZ]K$[(M1J.GI:6;>LF5+^R.7)&VMP=N1M/*0',>Q5I6UFP`X
MCA-%NEJM$%$JE>KJZG9=URX,'<=A;KC#[+LD!,W-S97+E5BP+L2,+'2EDDOA
M_`OE:1P[B&,`T%OWD^3<NO7Z39G^T9&1;6/CPYLV=6>Z4L)5(`^*P,2&#!-#
M@B0)(F$XDE(*D&%CPH@8CE)"2.AF-9B6Q#`#'.J('&5KO]D_8EL`NQ;4[;>0
M:/J4#!L8+0D@-F`#`=(2HE&/-#)2"!F&[`B4:DGI3(L-X>0NU*Z>;<&+X7.?
M^]F^OOZWWCI2*!2+Q:+GN7XB8;2.HI"$,-I$46"+^3,,0VL3&3:NZP1!P&R*
MQ4)?7]]33SUU^O1I>T(A&@%<0@C/<XE(*:64LTJYFE6HS,3$A-TR;H^Y7^6N
M8C9;MJQXY%(-L=9+6]FRVJ24<EW7;BS8VL=*R591?&.,%=Q$(NG[?J52*9?+
M6EM14UKK4JF<3*:.'CWZX0_?]\HKKWSL8Q][MQ_"^\"&%BP`>52PTENUZ-46
M49N<?AX`CB![EON[^H8'!T:'MO1V97=OV]F=2`[V#0SU]'9Y&0<PB(PQ*9DV
M`($,:4T&T`SA$9$2,!J&P!I&@!B0D,)QW4;X)[/]D@$@I?1=KWTPUC?+1DO5
ML.#8=D(D0T(L.[.:IMP&VRKX8/&1CWQT?'SKJ5.GBL52=T^V4FE<S+5:I1E^
M98C`;,(P",.Z8=MN1VL=SLR<N>ZZZWW?C:+0&"VE9!922BF%$/:)0@B2DJ04
M4@HAF,@&-@LBVP:1[1V`A:#-FT?/G)F<GIX$,#S<$*E5:O4N:*EA:TE8KP>F
MV=TZ#$.E)(`H:A3SLV&BUI)JK60SF0R`6JT>!($0@MD`DMG,S,PXCK.^V>`;
M7;#>D<(F*F#Q>'$Q>^:D9+/T8M@[R]VIKJ'^OFTC6Z_9-CZR96R@N[?7RZ8<
M/YU,NZ2$0X"(H&LP#API8(1FUD)K(D@8(A)0U(CW,A`LA9""`%.I5&QK8"&$
MLI7!I8!TP=J&-QB`(30@B"`8"A"()*I`S4%E`V\5?!#8L6/'CAT['G]L?ZZP
MF$CXCN.4RR5CV*:M1%&H=<3&&*-;CGC'<8A$/E^H5JN]O7W5:B612+;**[>\
M`&U)/XT>E\QHMI%>QAZ\>?-(Z_;]9=62D)LM8UL/MB=XMS83V^\`,,9D,AG'
M<2J5BK71ZO5Z*I4^>?+D@P\^^.JKK\:"]3Y02#<VO!8':1&%X]7"LT=/X"BZ
M"\J'W)3L'>KN&]LR,CXZMF73YL'!@;[NWK2;\AOQE4S$4@D7BD`"0L%(2`&`
M!$NV?\B.D(ED<@T76-.&(D`V74-L_W!)L.!`<`@$$OG4!\+/O<&Y[_X'GGO^
MJ=G9F7*YHI2TL0Y1%$61UE$41F$KI0[-K?U2J;2PL-#7US<QD4\FDRNKLS34
M09RK3VVIBT0T/#PR/3W9LJ<N!]R6?M3N^&]?*IY[6,N+UU(N&X35W]]?J50*
MA2)@;3$^<N3(Z.CHT:-'=^[<>?EF<0&N'L$Z'[EL!$1G<:;[Z/2+QP\+(3SE
MI!+)KDPVDTKM&-_6T]T],KQE;&1DH'<@@00!#JA>*J6=1,KS'3B&F!6SUA%K
M82!`MLB!L'^.;,L*.@"(A!+-QQO-,\!D"ST37Q7UIZX./G3G/8</OWKL^+%\
MON`XCN=Y6IL@J-L4PBC24=2HQEDNEVW'G>GIZ8&!`>OT(5I1%]"&+UE[NQ6T
MV;Y+V+I_6=6JG9;TG/N@'7AKAZ%55X>;>85VM-5JM5ZO>Y[7T]-=J506%A;3
MZ<S,S,S0T-#KK[\>"];EI5]V.\/06H=!,.M7L\5@J5!)5+T#;QXT6I/AA)\8
MZA\8&QL;&QO;U-U_V\X;NMUTAK()UW7A"$!)!R`-EH"`$&`#1`AUJ$5@,I[3
MJB\C6K6IFI:7/5X9=)>2N?3J^-B8=>'ZZV^\_OH;'WOL!\=/'`_#T'&L?YU;
M)5:,X3!L5+-S'">?SY=*I4PF4ZU6I23F-=M'KV@EW6[7$%W:KO.[P'K$>#4K
MCFEDK:YDE85E'R$BFY-D2TY?<\TU,S.S"PL+A4*AJZOKQ(D3V[9MN]PS.I</
MBF#-ZQP`",`'@$)&%U`%JAA2@.JJ*2/5V;`P\<9+^8D?`>@_;?HS/4,#F[8,
M;]JR:<N6X<W#0\,]V71WIL=7,D$)#TI`$*1VT*C?R<W=1D+;GB,$0S%<0C)$
M.@27_7AAN'&X__Z/=O>\<.C0ZXN+BXE$HJ56W&C'4/4\OU0J.H[#S*52:6!@
MH%PN2\G4W";FMM(TJS;I5AUPN><R/#QRZM0)>[]=0U<N76TEK!6T>[):PVY9
M6T1DC*[7:UU=W=EL5BEUXL2)_O[^6+#6C;P?-?J'-9WB[N;N8L1+BQ,O3QTQ
MM4`0^:Z7<+SK=UW;V]4]LF7+^.C8Z.;A@=Z^I$BEI%,%'`'`,(3M02%%([?&
M$`P9@(B-HXT?003^DAMKUD;AYION2*>Z7GWUE<G)*=OURQ@315H(<EVW5JM:
M`:I4*KE<;NO6K5-34[83C];&][U4*G6N#\MQ'/O?QCXBT>5>#$Y.3O!R[5`=
M1=IN_!G#=C"U6JU4*MGBT;;$NTVQ!.!Y'II+0ON@[?-HSQR&8;5:*Y<KF4R6
MF0\>/+AY\^;[[KOOLD[G?,2"M3;3J@`%^$`&@`N`JDX`\^SQ0[ELA+<!(#-9
M'QH<VK1ITT"ZY_Z;[NY+9OK[^P?ZAK+)K`^'R!",XSB1"0U,`&1[NDP8=672
M\V$9[OK.+V8%.W;LVK%CU^./[W_^N>=!I)2LUP/'459Z2J42,RNEIJ>GMVW;
MELUF[;((;=:3$`(@T0;1\G_?HUH]__SS!PX<R&:S0HAKK[UVS82^D9$Q6V2F
M%:E@X]JC**K5(EMSPA:YEU(F$@EJ]IVUB3AVP$V-,_/S\U;+VI:]HEZO[]BQ
M8_?NW>MB6UEBP;I8\HDZ@&PZV\,&AJ`C,^C/ZN*QQ1P6\<,7GI%:>,KKRG2-
M;AK9.;[MFK&M@SV]UXQM%8Y*^'X(?::T&+JHU<N+V7"]9Q.S!O?=]T`BD7KN
MN>?.GCWK>;X0JEZON*Z;3J>M"I1*I5PN-S8V=NC0H<'!06NV&&-:7O95FX/O
MRZB^^,4O/O;88_OV[:M6J\S\I2]]J5*IWG__&@9.$`36;K*K.?N@Z[K&L%(!
M@"B*;'MZK8WG>5+*:K5:+!9SN5RE4K'%[[NZNC*9S-C8F.MZR62BKZ]O='1T
M>'AX@[2MCP7KTBCH0N.>7)%@7!BRCJO:6=2.Y&=^\.J+>+7QJ]%*[TTW[;UF
MUS65J"(',^7:>E96BKDP^_;M&QD9^>$/?_C&&V\PFV32MS7=4ZF43<&;G)R\
M]MIKN[JZK)_>1I"WC*IV\VJ5?KUK=N_>O7W[]GONN6=B8F)L;.REEUZR@9WG
MLFW;-6B6Q"J7RY6*S.?SU6K5YF];;=5:E\OE^?GYN;DYK75W=[?U1F6SV<'!
MP;Z^OM[>WD0BL7/G%:JE<ZDLEP2Z,HA?O?-*OMRZ,]ZU]53^Y'J/XOW!_,?G
MUWL(5XXGGWSR!S_X0:&0L[T.F=EU75L2[R=^XB>DE+.SL[[OVR('GN<)(1U'
MV<Q!*:4-=``@I6Q5UWLO'#MVS'J:SJW>U^+X\6-+2TMS<W.VRNC"PH*UMJSW
MRJ[U!@>'QL?'1D='-VW:U-W=G<UF4ZG4^S+"*T-L85U>5JE5MJ>KL)1?I['$
M7`+WWGMO;V_OPP]_=WIZ2DHWBK0MB%ZOUZ>FIO;LV3,]/6U7@M8!A(:[AX4@
MFW8*0`AZO[1@QXX=[?\]?7HBBL)JM3H_/W_JU*FIJ:G)R<F9F;-A&#$CD?!M
M$3[/\X:'AZ^YYAJ[K-NQ8]?[,IAU)!:L*TJL5AW$GCU[]NS9\^4O__D++[Q@
MZV=%4>2ZWNSLW,TW.XE$DIF#($@DD@`II7S?MYMK81@E$@E;&F%J:K*5(3@]
M/34\O.6"K[D&IT^?GI^?K]5J<W-SU6IU86'A[-FS\_-S2TM+^7PN"()LMFO3
MIDT]/3V#@T/)9')H:&CKUJUC8V/CXUO?WS=D(Q`+5DS,A?@[?^?O;MHT_-=_
M_1VM=3J=+I?+;[UU]/;;[^CO'R@4"MW=O95*)9%(,1MF:&V4<FSZ(2!&1U>5
M7GAGM9J>GIZ?GS][]NR9,V?FYN:L+WQN;FYI:6EQ<3$,P[Z^ODV;-HV-C>W=
M>V-O;V]75[:GIZ>WMW?7KHZWGBZ&*RU8V9I7\*_R*I<Q5QD//'#_^/C85[_Z
ME>/'3W1W=P,X=NS8'7?<80O=I5*I:K5B75U**2F%S;P#].3DY(7K'4].3BXN
M+DY,3$Q,3$Q/3^?S^5JM9@N$VK![`(E$XOKKK[_OOONV;]_>T]/C^[[G>>TU
MLSY07&G!$D8!L6#%=!C;MV__K=_Z[:]__>O?^M:W,IE,/I^OU^LVRLGJ5&M_
MT'&<-45J:FJJ5"J5R^69F9G3IT]/34TM+BZ>/GV:B#S/\WW?KB@]S^OM[=VZ
M=>N.'3O&Q\<_(';3Q7.E!2N77*/_8$Q,1_"9SWQF9&3D+__R+T^=.G7777<Q
M-X+('<?Q?7_[]D:DTNG3IVT\0;%8G)N;FYZ>7EI:6EI:6EA8L)5+4ZG4X.!@
M;V_O^/BX[_M]?7U#0T,C(R.Q/+TC<5A#S,7R@0IKN``3$Q/?^,8W/,^S$>>M
M).&%A87%Q45K?,W/SUNO4ZU6RV0RO;V]FS=OWK)E2SJ='A@8R&:S?7U]J53J
M`[NR>]?$@A5SL<2"U<[!@P=/G#AQY,B14JD4!$&I5"H4"C;914HY/CZ^>?/F
MT='1T='1GIX>QW%B;7I?B'<)8V+>#3???'-O;V\8AH</'[8=E8>'A\?&QM:Q
M&N<'@5BP8F+>);9ZVGJ/XH-%7`,S)B:F8X@%*R8FIF.(!2LF)J9CB`4K)B:F
M8[C280TQ,3$Q[YK8PHJ)B>D88L&*B8GI&&+!BHF)Z1ABP8J)B>D88L&*B8GI
M&&+!BHF)Z1ABP8J)B>D88L&*B8GI&&+!BHF)Z1ABP8J)B>D88L&*B8GI&&+!
MBHF)Z1ABP8J)B>D88L&*B8GI&&+!BHF)Z1ABP8J)B>D88L&*B8GI&&+!BHF)
MZ1ABP8J)B>D88L&*B8GI&&+!BHF)Z1ABP8J)B>D88L&*B8GI&&+!BHF)Z1AB
MP8J)B>D88L&*B8GI&&+!BHF)Z1ABP8J)B>D88L&*B8GI&&+!BHF)Z1ABP8J)
MB>D88L&*B8GI&&+!BHF)Z1ABP8J)B>D88L&*B8GI&&+!BHF)Z1ABP8J)B>D8
M8L&*B8GI&&+!BHF)Z1ABP8J)B>D88L&*B8GI&&+!BHF)Z1ABP8J)B>D88L&*
MB8GI&&+!BHF)Z1ABP8J)B>D88L&*B8GI&&+!BHF)Z1ABP8J)B>D88L&*N6HY
M<NKTS_[6[Z_W*,[+P4,G?_[??F&]1[%!.7CPU34?CP4KYNKDBW^[_\;/_,*3
M+[ZXW@-9FR]\\5O[_M=?>NOHU'H/9,.1S^=_\.CW3T^L_<ZH*SR:F)C+S<FI
ML[_X>__^L>=>927<C?>5_,;QR<_^YK]^_>W7(!QC]'H/9V/QRBNOG3XU"::R
MR:]Y0"Q8,5<5?_+-1W[]/_YA8:DF&"*$D,YZCV@%__DKW_G=+_Q1OE8!))@D
MT7J/:`,Q-35U^O1I!K$Q@M:6IEBP8C8BNK2`,Q/A[%%]]JC>?'OV[H]?S+-^
M[P__]/-_^B5$FJ5KM&&7=11<[J%>/)_XE7_Y\`\?=Z"DZT21(0AP+%@K,,80
M)$D21JYY0"Q8,>N#*2[IR;=,[HS)34:%G%J:#I;FD%\,%Z>Y,*/+=4>*&@5+
M\XG*R$/[+DZP]A\\3"P$L0%#21ACQ`92A,</O`KAAD*K*$1L6YV#$$I*&86&
MB`2OO9:/!2MF'="EI=SO/,0G#Q-)`Q!S37`4&D@M($DX0@E-HK2@3KXM,//D
M19Y6$@0++21I8SR-@,EL(%W00A,Q:Q@I`<W,AGB]![6!,,9HK8D$,]-Y!'W#
MN21C/@CD_M]_%)U\S<`)31A$=<-5';$CI1+2$9(1&!,5RN;8,45"B7R8>^;9
MBSEMR-!$(M*&F#0#!FLO+-8'8L&LA21C<+X+\H.,E)(@C3$`Q'D^N5BP8JXT
MQ:__N_#IOV$H`^U`>%*1]`&*H$&.!D/+D.GX41"1B30K+.Y_Y&+.K!5)!BDC
MV1`+`1";RSV=B\=`>U#&")`1<,`BEJUVC#$DF(B8#-':TA0+5LP513_VEY7_
M\7G6AB04$"(R$(&.E%(."6&TY@A"''M=ZKH(N.I*ASE\^ZM?NIB3>_4R"VBC
M0,J`V6PHO0)8U(F4,$`DF``!Q(*U3$.^!0,08FUO52Q8,5>0Z:FI__H/C=8.
M03`($0G/(9D1B9HNUK5A;22I8T=D*1`1.(.>(L]I-O7YF=R+[[PJ9.7IJ"B@
M-8PT8$'F/%_4ZX)4!(2:I2M2H<F1".,XK-6P$)`.N8;K:_Y^`WV<,5<]B__N
MLW*I!*(0$0`M7`%IC-8D2$DAC9;R[9/>4M[(2`I--5-6QI-2&F/.?.\[%_4:
M)#4%0@@M"3!JH\4-$#'`;"`2K"$VVO#6%69F:&;&^?<B8L&*N4+D_OW_;"8/
M.P3!0I)@`!P91)J@H:4V!'=^@>=GH-FP-J$B(Z14"1@BHNF_^JN+>15BP`AF
M%FRPP02!F0&08`T-]DCZ.K[^5F#LJC#2YS4\X["&F"M![HO_,GSRVP922$^P
M9F-8,(@$F`F1"20HEQ<G3TH0*9)@5A`,#89#(A1<.7MV[L#3`_M^[!U>2;A@
MK9B8P#:(8"5+Q=+L8DX;84R422?'A_K?Q71>>>O$Y.Q\H9"KUB,6TIBH)Y'-
M=F>&^[KW[AQ_QZ<S,SAB8BE6#&]^J32;7P"(B'HSV:'>KG<QMG9RN5RY7+9"
M:7???#\IA.CO[[WP$Y>6ELKE<JU6BZ(HBB+[7*64XSCI=#J12'5W9]_CV,Z%
MF8TQ)(@`/H^-%0M6S&6G_O+#_,TO1"!'@0T9")+$3!("QH1<E<*K5!)'WR0(
M8@T6#JN`6(.D8`2(%#E!&"W\X&_?4;`86@BE86`B$CXI">#P\5,_>N/HTR^]
M^H,#+YZ8/,M,,"PE:48ZD?VI^V[Y!Y_^R8_<?<L[3N2_??O1K_WPJ4>?>K(:
M:)(.0\-H8F8B`;`A2$$2M^[>]>/W?.C>VV]X:-_*<QJ"(4@`1@':.)H-@->/
M37SU;Q[]DX<?F3H]2VRD=(QA`PSV97_ZXQ_^S(/W?O3.=QY;BT*I.#T]?6;J
M;+5:C:+(+JB-AE1DC`$+(83AB(@V;]Y\^^VWMC_WR)&CT]/3^7R>B+36KN,S
M<RLJBHBL<C&SG_3&Q\=W7[OS(D<U/[\X-S<W.SM;*!1:)P'@.$Y/3T]?7]_`
M0%_KM?A\<@5<Z'<Q,>^=:/)DX9_O"TM%L"3)Q$(P,8PF(Z`8-4#1YFM.8_?4
M-[\G6`@A0A@A6$`9`V:&B`3[1D1N7__'7SEZ@==Z\.=__;$77B?4B(461H(T
M7->10:VF7#^*`B(&P$8(*8W60I*)`D>*$.;!N^[Z\]_[S:'!M0VN1U\\^`\^
M_P<3DV<)S$9",,C(B!A:.!2%I%AJ-I""*10&)*4VX<]^_*$O__[OM$[BW?U3
M0:DDA##0@!&0NW=NO6O/GO_Z5W^C!"*M)3N:"(A(@#DBZ1!#`+?LW?O'_^HW
M;[QF],)O=;%8/GSX\-F9&2(B%B!CF)E90`($`69-+&#WX\BXKOOQCS_4?H;O
M?>^1>KTNA-"1#2\@0<:*B,7*!;-F*`!2TMZ]>[>.7VA@,S-SAP\?+A0*#`@A
MF)D`-C8^E&W@E9!@9L=QM+8^+`+SIS_]D^>>+5Y#QUQ>BK__,V&E`!@B&!V"
MC!:L&3""V)!4VO>[_K<_&_W%?V9(,'3(4$+"",V&I&%(U@1!%(7![-GY%YZY
M\,N1,%".)@$H;>!+<*TFA3;&$)$20@"`8682@H@4^1&(##_YW"L/_M(_7_.<
M_^7;W_N)7_AG9]X^*[6`D20844AA2$1&"Q,R!$72D"LD2`C'0$`+16K-A8V!
M!FL0,_0;QR;^].O?E<*/0D-"D#*@D(00K"1\CAB`9G[QT.&'_MYO_/"EUR\P
M\=.GIYYXXHFS9V8!H4$`&0U!Y"C5%!N08`%A=:=E+K6CC6'`&",5:392"FA!
MD&`!%D:##;$AD"02`(6A?NVUUXX?/WF^4;WQQI'GGW^^6"I)X8@V`ZTAIF0`
MDE)I`Q+*KCVY:7RM2;PDC+F,+/WOGZA/O.:(!+,6.JP)\HRK.0H103`)(45B
MZ/>?$F/7#VS#IH\\N+#_23)D-_N5=D*NN>R'I.LF$$JX6BP\_'#_'7=?Z"59
MPC`9+4FP*R(=0KJ:ZTH(8\#&L"%B9A-`L2:3H(0QDDA$NG3XQ+&___G_\-\^
M_QOMY_ON<Z_^RK_^#W76K@O-@2O205B4KF.TB-B0DH8(7!64-"9RA,,ZD@2M
M0V)>I0A-W6`0.YS20AL-DL?8ZRT``!>S241!5`13AR,!J:,RB11SI!$"``EC
M("&TKN4KQ9_\I[_Q\/_SGSY\\[7G3OK4J5,O'WQ50!(1"<%@,B"B;#;3U]>7
M\%-22H:.3!A5N5JOEJN57&ZQH=XK(:)D(M'=W=W7W^^ZON\HI123,<;4ZV&I
M5)J9.[NPL."I1#T(E%+&F$.'#G5U=?7U]:PZU8$#/YJ9F8%50"'!@J"9N2N;
M3202)%&J5**J"8)`2J5U)`6$$`VM.H]FQ8(5<[G(?_GSYO4GE9`<1EHXQD42
MR26:]82K0E=P&,+I__RWQ-CU]OBM__`?S^]_T@@#`QBI1>C!JSB+4GLNN:Q9
M@^>??/A:_*OSO:)+OL$BV(>0D8"(7)!BBHB]"#G7N!J>(>$($X+).$[D566>
MI&(!J9,:^L_^ZN%?_U\^>^/.L=8Y_^T??;%>,Q#:L).@=#5<A$CH,'!$(H11
MCJL<0I"JZC/@5,#:KI\<<$C&6YE?P@"3`82+;(`E$?H*4@LV()A(D!&R*Z0Y
M@2Z&%L9E(XP("9'G9NOA/,K^/_TW__>K7_NC5;->6%@X^/(AL"!':JUE1$GE
MCUP[</WN/9?ZD=UZRRV;-P]=^)A=NW84%TN/O_1#1(#Q!`1`;[WUUEUWW=E^
MV)$C1V?.SC$)`EPE:V%QH&]PUZY=0T-KG/_LV;/3T].3D].-Y2?;5?,:Q((5
M<UDHOO2=^M?^0'-=&D6.(M8"(N2*!*01DE!G,_@O_KO8<V_K*4/W/)3:M;WT
MQG%&("!(2&8C=$)*:4PH"9IXX=";I9-'TEO7L#(`:!@(%Y$``R1(1#"1@5)&
MF3!YU]UW?/;!N[=L&O(<-3LS]X=?^N:KQTZ"?+`A9F,B""+"WSSQ3+M@_>C@
M:X8C&+`P6D>`ETPF?_]7_M&']^VYX9KMK<-RU=S9A=*)J:D3QZ<???'0M_<_
M+8,PH&C-<3(S2+*0&A$;0]*_=OOXQ^^^?>S_;^_\@^NJKGO_76OM<^Z59%D_
M+-F2+6SC'V!L8\?D`6DP)6D)):2\)J$A24D)TQ]IT[SD)>F\1TI?'AU2DDRG
M29MITO1W20GO)6G2/IK.%$C:TOS&!(,-.#A@;+!ER?HM6=+5/6>OM=X?1\CR
M#TDVB'28N9\_/&/=O=<^1_99]^RUU_JN]HZZI30YD3_\Q--?ON]!($]8%(&B
M@LL`[WMZ_Q>__L"[KK]FMK7''GM,1/(\MQA%T%!7_IFKKWIQ_VH+>JN"QM8E
MK[GTM=_[UBX"$5Q=^_IZ3QGS[(%#(`/8H:K8LF7+A1LWS66PHZ.CHZ-C^?*.
M1QYYA(BB*L]1!%IS6#5>!I[>._&9]R#SA%-S<8M$Y.P>N8P2+&1DK3=_,ESV
M"Z?,N_`#M_[P?;_*8+48R')E$=;H(BDHDEEP/'_WWVW^Z)UG7+900@A(06`S
MA1F+P&[^Q3=\\)TW7+SAI-CPN]]R[?L^_N>?_](_@,RC.YFXN.N]#W[W=W[U
M'<68[^]]JAIS"`-08B>EI.[?_^H/+MMZZLM+<UUS<U?SIJXN7([?>N=;`#SP
M[5U'1X9/OCQ'<=8&@R4L:%[2=/MO_LJ;?O:R=1VG>HI/OO?=;[_MSEU/["/R
MG!P(3*S0N_[I)(?5T]LW.9&9&3.#+(1PZ>67X.6GK:F]JVOUD>>/P,W%'!@:
M&FIMG<Z6.'CP8)[G(&<B)[KPPHT7;-RPH$TB<H"(),P9QJH%W6LL,OGH<,\?
MW>C#8\0&3IQS%,HAN4'4G,RT^6T?+M_PX=/G=K[YAM*21G<A(O-@Q$6HV#Q:
MS,528SGVS7^9:VF#!RE'<F53-G4J2_*%CW_TKS_ZP5.\5<'G;ON-Y>U-8'$2
M,!F!B7;OVS\S8'#D.,@)0LP@,?&+UJXZW5N=D6NNO.R6ZT^5\2('8`XC@:IO
M7=_U_INN/]U;`5B[9N4__-&=::E.M$128DX81L+??O3QV<,.'^YV!Q$3L7"R
M:=/FQL;&L[F\ETYS<S,1B-D5#-)9V9[=W3T2R(W4\L;&Q@LN6-A;`2`B)IH^
M*)R#FL.JL<A,?.J=W',H"(@(EBLQN\$YKZ8#`W+L6#JZ^MJZFSXVU_05;WVK
ML[,)G!,F!Y.;J(+%1`WY\?W/C#VQ[XQSW3WF'@CL4/=`W-[:>-,;Y]L?_9<=
MF]T=3$4^O0-F&!D>GS;(1?Z1D`/FY#@V./@2?C<SUZD`@[TZ;U+1JN7-U^V\
M'$QD!#)W]ZA9'O<^\^S,F/YC?47&)1$(=O[Y"Z>M+A9,:G!U9PI$,MMA#0^-
MFIF(,'-'1\<YF9U?P:+FL&HL)MF]GZX^\6U3GJS0V(AT]R>'#J1[]I5W/9SN
MWFL'GI:CW:E<=>I.<#8;W_<A858&/#<G@A$)<3!/R".`0-S]U;O..-?=$V("
MW)V$(RS*`O_#&TN!07`720P.`!:GLFEAY67-=0```QBN9#0V-O8K=[SXWES3
M215D;@1EF4.Y?(:?>\WEBNB`:2XB05(X#G7WS0Q0RXE=`CET9D>VN(R.C0\.
M#PV/CHR-C<_^N9D!%D(@)W*><28C(V,.-47Q9U/3.;SQ%<D6I]<GS%"+8=58
M3+Y_VYU9->35LJJ*1Q5R94(F[D[.S.76I@TWOGL>"_5=:S?]_"5C>W9+-*7H
M&9S=/*JQNP87*W$R\.P9YQI943S(`C<W\()J"&("M43$U$`.$3/+7SA;?^W6
M+4+%NXT3N<$Y)E_XVOWW_--]ZSHZDC*[B3@BP*`T33K:EFV]H/-=U[]QZ[KS
MYUK1W0$79H/90K6.5UQR$0"X$B17!Y29>P:&BD_[^@888JYJQLRM;:<F%KPX
MCG;W=7=WCXP.34Y-L"9@.$<XPPB`DQE98ZD17*2FFQ.(763Z7J:FIHH<4<!`
MUMG9>9;K%CM!9@8[YM`%JCFL&HO)Q)`"%&6\3(U5SUT)5`41>2*:1$RL>,-;
M%C1BXZ.I5RAA8BUQ25G)6>%``.6A;?G*W_O#,TYTUT"EW":,#2*>Q=)"@EAI
M:`@BI@`9BYB["QF?F'7Q11?N??(9)P4(XB2IQ:DLY_U'CWG,P0Y7(*1(,V1,
MX;[OY']\U]>NONJG_OPC'UK5L>S46\.T!)9[XCZYX*]BU;)E[@3*`C<8G.`.
MC%>F)^9Y%4Z`A,`Q9DE26M#@_`P.#C[^^).C(\>+$#X`@2@4SF;&'(@HU^B(
M6K6J59G9U0S.\)DM89[G[F2(0@GS.0B2,3,1F;NISO7N6=L2UEA,N'U9-!$O
MC_JPDZ7BX@10U2)Q;$!3^0T+GV'Y\7%FAGN3+QV7<26`R5(F-@H-:W__R_5M
M:\\XL2XT5GU"/;HRC$!B9\J-G$T%U0RF;!YX^AO>0A)/'*I_Z%V_@!")B$P"
MZO-\@$B+!XN$`3"52UR?T1C!89D;92;_\N!#K_WE]Q\XTC=[K20$DD`61$N&
M(4!X(4WWUI8EH)B$AF@C3JJ>P?-*-CTK]=*XC2CG<&6B$%[2XSPXV/_P0[M'
M1T=)X!S=**6&,1V.7BWJ!`#$&(.'>FD:TT&#D@L3,<B=9B3W<LV8F3BHJI^;
M7(:910+*TC#7B-H;5HW%I'7');W?N"^QD+B`/7=P$$05@KLWML?QS_[.@7L_
M7]^V-NDX+UE_86G-EO*F5Y]JI7I<(P4N57PRY22A)(]3H4I$H?V]'TVW7CK7
MZC;71N(E<///7WO_0WO^SS]^W;D4*`=*Y#RM(T$`B3OE,'BY2'DT4V)VX/F!
MWIO^QQT_^+^?G3$55<T,<`B!&$X+2B3W#(\*R&,.25USX41-EZ33GV;FP86*
MFCQGU9=4%_SPPX]6LYPHF&=""0E4\Y:E34N6+"TE97=7LQCCU&1U:JH:B,/T
M/IK,C.A$L)Q!KD92"$"?\R7Y:14"LZDYK!J+2=MEK^WYQ@,1P@CL*9%KGA,A
M+=&*%5I.+1\:KP[V3?)#`B&$&.S8T-+VG[YNQ=O>T7'5U861J='A(!9E,D$"
M%R4O(<U9FZY[1^LO?7">U><)UKX4[OG8K=O6K/O,%[_2.SP((BM<%=C-0``<
M4(*[F9.("QF4.('L>O+`=_<^=<6VZ81),X,K2-QS@.DL'N9#1[N%0@:#,3P6
M[YF-]?7%ITFY%#@I^C6X>[5Z9I7.LV'/XWOS3`NGPR`FW[AQXP477##/E!_]
M:/^!9PX69ZQ$)S*GBL-!.,S]13@L(IHS@E5S6#46EX9-6\@H<LX4W'-"(*+F
M9FIM<_((I\!.SH0DN@;$))-L6`_]XY>ZO_;5^M5K-OS6?UMVU54I(U=+K"&B
M0IP@9CEQV'99YVU_,?_J+Y_TR*V_]K9;?^UM=WW]@?_8O7=X>'1L;#RJ&XN[
M.AO#CQX;>^[Y'G)%(`7<HHH3V=?_[3LS#@L`'"1L,0?3V5SPGGU/9Z84$C)W
M<7.#9>VMTY(22<I$XN[%"\[X^/C\UN:A[]B`>0Q2RN.4L%QRR:LZ.U?-/Z5<
M+K]P"S9;@KU4*DUWOF$VM^'AX9:6LSH-<'>BPOG..:;FL&HL)J6-&]ER(BY2
M,3E8QW*J3S,V`HO!B`0@`@<W-:],,6+.$&.=ZGYNS^_^=KFEU-ED)('BE(?`
MYD2,CA5K[[AGP=5?;JVD6ZZ_YI:3RV)F<]N?W?V)S]]-2B`7%M;<P(_M/W&@
M.2TLY<Z`4>*P!2_W6X\^Q0RW0N.!'`KP^M5=Q:<MS4M8Q-W5(C,/#0V]Z%NK
M3$X2431EYN;FY@6]58&ZL;"X8]8^KEPNLQ3U3B#(\>,39^FP@.F.A#Y'(2%J
M0?<:BTOSZO/3QL:(.B`V-/BJKKQ4R@HI$M4,3D)BQ"^H^-G(F#IR9HA)%B.(
M?3PC)P`:P*;!U877?NSOD[:%3\=?IBWA6?+QW_SEKK9F8A-2=>0D!G[^:,_,
M`&:F(A.`G>;H;'P*__J]1V#1W8@(3LR<INF6=2>\26-C8_&0,W.U6GUQ/FMD
M9*0X10`4)$N6+#G+B43DKC."6<4/ERY=.J-@0W1N;O0%(W-N"6L.J\8BDZ[;
M2%+I7%E:OCPF[%*<+KF!4C-S]^#D[G"R4!^S)'KB")D7`E*6I@%$`E$'B-31
M<>MGRQ>=57V<SOW-_).AK;7=G**#&<0L;JHG/7LS?R%:\(00=_S%%P<'AHV8
M6,681&"T\U5;9X\Y?\WZPDL78E+[]\\G<#@G[*;3ZC?S!+Q/056+8IJ"V6(U
M'1T=T_4#0$]/S]PV3H*("CW6>8X6:PZKQB+3=MFV=5UY8SD++L47IKFS$"BG
M!**I.XEQ[EEETF($DT;.R@YWRG/A5,U@GK-CBJ;:WO'^ENMN/LNE[=Q#O`LR
M.#'UH4__U1-S:]3-\,R1GJ>>.\1BX,0M@ZLISTZ;C&[%4^U%8)O!<Y\2_O$7
MOGS[G][E`6S!$06)JYKAQNM>-WO8FK4K$TD8(LQ$-#@X>/CPX7.]Q^:E+<Q"
M5+2D]O'C"R>(`<@S=34`Y#"SV9TC5JQ84=RIP;,\?^31'Y[5=3BC=DI8XR?,
MUCL_5WWC#4__V7O]^8.(92FREES<(*@;BZ.E4!9X2NG0.!.I$=>C-!(FRU8"
M>:HL#`,$:'_5F]H^\,FS7[J!ECAED`!0D9:]H`N;TN-@]PB.1L)0,_(Z.9&!
MJ9G^R5U?^NS?_OW:U:NNVKY]U8:F*R^^9/O:\]O;3ZHXN>>;_WS;I^ZVJHJ+
MD8'%E9(0+ME^HN@Z.)M"G$C*T8?`I5U[]NZX\;W;+]RPMG/YNI4KE]8U#&#P
MV6=Z[OO6PX_N/P`C)Z<02K2DZGV!&]>L7/$;;[W^E%M8O;[ST+.'32FD:995
M]SSV9"E=LGS%N66]JU00@U#B[B-CPP-#_6VM[?.,_\X/_V.P9YB0HKA?M]FN
M][SS5NW=\T06\Q""&1\[.OQ,T_X-Z\XL"C2#0QT*YQ+75^+8&<?4'%:-Q:>T
M\V>V[MS?_\"7)[[RN?&G?NAN!$\<[EJ7E(B%G`E3E2H#2K!JU!("/!<2*9,2
M$@I\_L:N/[GWG-8U,48)"B.`20QAH49:9:HC=1`;$^!"1.3CIC./>X`[,I?D
MX'.'#QX]JG%"PA?)!"'4U]<)LUFL5"I9/$Z>LI'"08$\.&61_(;7GQ#\(C>P
M*VEB#*Z'4N;TV%,_WOOC'Q.[YD:<.JK,;,HLJ;.Y1?*\J@JJDU#_F=_][Z??
MPL5;M@WT#1\?FS#+DT3R/.[:M6M%9_N&]>M;6N;KN]/?W]_>/NV5.CI6'NON
M=_>B1<4/?K#KXBU;UZPYJ91Z=/3XV-C8L=[^_O[^X]GQNE#VHBD$F4-/"3R=
MOV[-LP</QI@3!57?M^_'E8EX\<7S"5V,C8VY.T#J-E>&6LUAU7BY:+_F[>W7
MO'WBP?]W]*Y/5/?OS9F)M,CN5K<8V7,E(B-G(H81I=!HYN*N:;+Z?]]]KBM&
M4B/E)""/7L2H2\D"<YR=P"!QB1XC@1P)G7CVM(AXJ[)1-`>G9G`WTC@Q/NXQ
M9V8C,!H8INS,"1-%RPGR4SNV7[%EVXPI$S<4NYZBGIK@3J3F!B66X`ZP%&>'
MIADS4#0\<Q>4?N]]M[QIYYF39E__^JONO__^2G4*`%$P>&]/S]'N[E*IU-+2
M4E]?GR2)F;FBDE6R:G5T=%150^!KK[VVL+#YPLU#Q[YK"C-U<HUX[+&]>_?L
M2TLA34/,4:E4G(Q(3$D"!2Z9@>!%?QT.I_J7S9LW#0X/#`V.,$!$FM/!9Y][
M_KDC[>WMR]I:2J7$W2UZM'QB8J*_?W!J:BJ/QBP.)R:V,ROXU1Q6C9>7AM>]
M>>/KWMS_E4]7OO(W([T'V`6J1#0Z601MB2V-/AFX#`43$6=&Z7FW?Z&\?O.Y
MKN4*T5#D>Q=)YYKE\T\A&,R=7!E%LQ8GY'3R+$X%S-#@>2PZQY@2!XTYBT3D
M1$0DFD?A)*I"(A&O7[GR[S[Q/T^Z/"/`0(!$F$!!+`1VRT$$8@!!421B*N4&
MD*4$XH3O^,![/G++?&68EUYZZ>[=NR<G)XN0DH.%0U:-1[M[)4PWZ<KS/"0)
MW)DYQAA">6;ZTB6-6[9<]/CC3TH@-3(#L^19[NZ52H4IN#NQ`%1H@29,S4U-
ME4JE6JT*)Q;M](#XE5?L_/9WOS,R>-PL%OUR5+6WM[>OO]>GZZ:IZ*@K(C$W
MENF./C.50*=3"[K7^$G0?N.'5W_UB?/><WMH7@8S,\OR>G=7)4?.8$9$HL:2
MI++LYM]N_.DSM'A:D)S(.&,4Q3$!'G2A&)8C$(DC-\M=C1`!N)UX+B0@"5!H
MYGD4)0\`(XA9+/K/D+.K)TZ)I)$H$-C"?]WYFH?N^=-3E/G<,B@")44AL810
MZ%`(LQ"912!&B+M'C^PLEA+SY=LW//B7G[IM7F\%H+6U]>JKKUZ[=FV:I@Z5
M`/,<9&DIN!&<32E(B2$$B7':@\RVL&;-FE>_>D<(C&EWXFF:.H$X.($$Y'!5
M>%Q27[]]V]8KK[QB\^9-`*S(E3M3HL:55^SL.F\EL8%LNII:9+KUCG/1<B*J
M1E7U.",ZQD":IJ=;0^T-J\9/DI:;/])R\T>&[OV;OL_=/G9P5$()R`3B,8%3
MM*Q$WGS]S2M^_7\M;.M,E"T74&0PB:M9`"VD%D"<NSI(*+"K@1*HS3ZA;UW:
MF#W\C6]^_Y'O[7GJWQ[>\\B/GJY4)M25B$"DYB`"I*HFP;=N7'_#ZZ^\Z=JK
M-ZY=>?I:NNO^W?N?/G2DYU!O_Z'N8\\^?_AP[^#AWH'AX^,`0+E[9$E)J;.]
M[?+MFZ^^]%5OW'G9NO/.5IX%P+9MV[9MVW;DR-&!OL&CO=V%>B>QOY`!9D1)
MU(Q%EC0TG"[\TMG9V=G9V=<WT-?7U]?7-S$Q8:8B"3-8J*6IM;.S<]FREAE1
MTZZNKM[>OF.]_:I*?.;OAAT[MN_8L7W_CYXZ<K1[8J*B9@"*C'8B<O.BU6NI
M5%K:V-C2TM+8V-C4U#179^E:(]4:_SE4AP;,':Y%=RP"G(PS#9U=+]KFP$BU
MFDVPF8%,P(J0)BM:YVNJ/C0Z5:E.!4%49;"SJO-Y[?,IX?4-C1X;'!P>FSA>
MF<IB3$.H2\+RYN;5*SN6-M:]Z(OO'QA5591"QZ)V@1\>'E:=?F,BYB`R?R3^
MY69T=#3+LJ).FP,%3I)$SE[6N>:P:M2H\8JA%L.J4:/&*X::PZI1H\8KAIK#
DJE&CQBN&FL.J4:/&*X;_#\9@"6+617\#`````$E%3D2N0F""




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
        <int nm="BREAKPOINT" vl="532" />
        <int nm="BREAKPOINT" vl="339" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-23100 version distinction .net8 added" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="9" />
      <str nm="DATE" vl="2/5/2025 3:41:41 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-14929 multiple block overrides added (i.e. SDE)" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="8" />
      <str nm="DATE" vl="3/17/2022 3:11:03 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-14929 numeric fixture article numbers supported" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="7" />
      <str nm="DATE" vl="3/16/2022 12:18:39 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-14929 Fixture import added" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="6" />
      <str nm="DATE" vl="3/15/2022 5:00:56 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-14805 bugfix writing map key" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="5" />
      <str nm="DATE" vl="2/25/2022 4:40:21 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-14805 now supporting individual files for localisation" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="4" />
      <str nm="DATE" vl="2/25/2022 12:06:20 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-14639 supporting adjustable straps" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="3" />
      <str nm="DATE" vl="2/21/2022 5:44:12 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-14324 bugfix writing new manufacturer" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="2" />
      <str nm="DATE" vl="2/21/2022 12:22:40 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-14324 joist and alpha ranges added" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="2/4/2022 3:38:35 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-14324 initial version" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="2/2/2022 4:45:01 PM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End