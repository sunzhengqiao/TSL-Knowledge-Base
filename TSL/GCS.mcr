#Version 8
#BeginDescription
Places a Column Shoe, user can select from xml catalog in dialogue.

version value="1.9" date="26okt2020" author="geoffroy.cenni@hsbcad.com"
HSB6484 Add Top drill Z offset
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 9
#KeyWords column;shoe;catalog
#BeginContents
/// <History>//region
/// <version value="1.9" date="26okt2020" author="geoffroy.cenni@hsbcad.com"> HSB6484 Add Top drill Z offset </version>
/// <version value="1.8" date="16okt2020" author="geoffroy.cenni@hsbcad.com"> HSB6484 separate tolerance inpunt for top and width </version>
/// <version value="1.7" date="30sep2020" author="geoffroy.cenni@hsbcad.com"> HSB6484 ribbon button fixed </version>
/// <version value="1.6" date="30sep2020" author="geoffroy.cenni@hsbcad.com"> HSB6484 add top drill depth, image, top shape tolerance </version>
/// <version value="1.5" date="22sep2020" author="geoffroy.cenni@hsbcad.com"> HSB6484 when called from catalog, hide dialogue </version>
/// <version value="1.4" date="21sep2020" author="geoffroy.cenni@hsbcad.com"> HSB6484 optimized the token catalog connection </version>
/// <version value="1.3" date="16sep2020" author="geoffroy.cenni@hsbcad.com"> HSB6484 initial </version>
/// </History>

/// <insert Lang=en>
/// Select entity, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// Places a Column Shoe, user can select from xml catalog in dialogue.
/// </summary>

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "GCS" "Simpson StrongTie?PVD")) TSLCONTENT
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
	String sDisabled = T("<|Disabled|>");
	String k;
//end Constants//endregion

//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sFileName ="GCS"; //GeneralColumnShoe
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
		if (sFile.length()<1)sFile=findFile(_kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\"+sFileName+".xml");		
		if (sFile.length()>0)
		{ 
			mapSetting.readFromXmlFile(sFile);
			mo.dbCreate(mapSetting);			
		}
		else
		{
			reportMessage("\n"+ scriptName() + ": "+ T("|Could not find general column shoe catalogue " + sFileName + ".xml .| ")+ T("|Tool will be deleted.|"));
			eraseInstance();
			return;
		}
	}		
//End Settings//endregion

//region Read Settings
	String sManufacturers[0];
	{
		Map m,mapManufacturers= mapSetting.getMap("Manufacturer[]");
		for (int i=0;i<mapManufacturers.length();i++) 
		{ 
			m = mapManufacturers.getMap(i); 
			String manufacturer;
			k="Name";		if (m.hasString(k))	manufacturer = m.getString(k);
			if (manufacturer.length()>0 && sManufacturers.findNoCase(manufacturer,-1)<0)
				sManufacturers.append(manufacturer);
		}//next i
	}
	if (sManufacturers.length()<1)
	{ 
		reportMessage("\n"+ scriptName() + ": "+ T("|Could not find manufacturer data.| ")+ T("|Tool will be deleted.|"));
		eraseInstance();
		return;	
	}
//End Read Settings//endregion 

//region Properties For Dialogue

	String sPainters[0];
	String sPainterName=T("|Painter|");	
	int iPainterIndex = nStringIndex++;
//	PropString sPainter(iPainterIndex, sPainters, sPainterName);	
//	sPainter.setDescription(T("|Defines the Manufacturer|"));
//	sPainter.setCategory(category);	
//	sPainter.setReadOnly(true);
	
	String sManufacturerName=T("|Manufacturer|");
	int iManufacturerIndex = nStringIndex++;
//	PropString sManufacturer(nStringIndex++, sManufacturers, sManufacturerName);	
//	sManufacturer.setDescription(T("|Defines the Manufacturer|"));
//	sManufacturer.setCategory(T("|General|"));	

	String sFamilies[0];
	String sFamilyName=T("|Family|");
	int iFamilyIndex = nStringIndex++;	
//	PropString sFamily(iFamilyIndex, sFamilies, sFamilyName);	
//	sFamily.setDescription(T("|Defines the Manufacturer|"));
//	sFamily.setCategory(category);	
//	sFamily.setReadOnly(true);

	String sArticleNumbers[0];
	String sArticleNumberName=T("|Article Number|");	
	int iArticleNumberIndex = nStringIndex++;
//	PropString sArticleNumber(iArticleNumberIndex, sArticleNumbers, sArticleNumberName);	
//	sArticleNumber.setDescription(T("|Defines the Manufacturer|"));
//	sArticleNumber.setCategory(category);	
//	sArticleNumber.setReadOnly(true);
	
	String sMaterials[0]; String sMaterial;
	String sURLs[0]; String sURL;
	String sDescriptions[0]; String sDescription;
	int iColors[0]; int iColor;
	
	String sTop_Shapes[0]; String sTop_Shape;
	double dTop_Shape_Diameters[0]; double dTop_Shape_Diameter;
	double dTop_Heights[0]; double dTop_Height;
	double dTop_Widths[0]; double dTop_Width;
	double dTop_Lengths[0]; double dTop_Length;
	double dTop_Offsets[0]; double dTop_Offset;
	double dTop_Tolerance_Heights[0]; double dTop_Tolerance_Height;
	double dTop_Tolerance_Widths[0]; double dTop_Tolerance_Width;
	double dTop_Drill_Diameters[0]; double dTop_Drill_Diameter;
	int iTop_Drill_Rowss[0]; int iTop_Drill_Rows;
	int iTop_Drill_Columnss[0]; int iTop_Drill_Columns;
	double dTop_Drill_Edge_Verticals[0]; double dTop_Drill_Edge_Vertical;
	double dTop_Drill_Edge_Horizontals[0]; double dTop_Drill_Edge_Horizontal;
	double dTop_Drill_Between_Distances[0]; double dTop_Drill_Between_Distance;
	String sMiddle_Shapes[0]; String sMiddle_Shape;
	double dMiddle_Heights[0]; double dMiddle_Height;
	double dMiddle_Widths[0]; double dMiddle_Width;
	double dMiddle_Lengths[0]; double dMiddle_Length;
	int iMiddle_Extendables[0]; int iMiddle_Extendable;
	double dMiddle_Length_Extends[0]; double dMiddle_Length_Extend;
	double dMiddle_Drill_Diameters[0]; double dMiddle_Drill_Diameter;
	int iMiddle_Drill_Rowss[0]; int iMiddle_Drill_Rows;
	int iMiddle_Drill_Columnss[0]; int iMiddle_Drill_Columns;
	double dMiddle_Drill_Edge_Verticals[0]; double dMiddle_Drill_Edge_Vertical;
	double dMiddle_Drill_Edge_Horizontals[0]; double dMiddle_Drill_Edge_Horizontal;
	double dMiddle_Drill_Between_Distances[0]; double dMiddle_Drill_Between_Distance;
	double dBar_Heights[0]; double dBar_Height;
	double dBar_Widths[0]; double dBar_Width;
	double dBar_Lengths[0]; double dBar_Length;
	int iBar_Extendables[0]; int iBar_Extendable;
	double dBar_Height_Extends[0]; double dBar_Height_Extend;
	String sBottom_Shapes[0]; String sBottom_Shape;
	double dBottom_Heights[0]; double dBottom_Height;
	double dBottom_Widths[0]; double dBottom_Width;
	double dBottom_Drill_Diameters[0]; double dBottom_Drill_Diameter;
	int iBottom_Drill_Rowss[0]; int iBottom_Drill_Rows;
	int iBottom_Drill_Columnss[0]; int iBottom_Drill_Columns;
	double dBottom_Drill_Edge_Verticals[0]; double dBottom_Drill_Edge_Vertical;
	double dBottom_Drill_Edge_Horizontals[0]; double dBottom_Drill_Edge_Horizontal;
	double dBottom_Drill_Between_Distances[0]; double dBottom_Drill_Between_Distance;

	double dBottom_Lengths[0]; double dBottom_Length;
//End Properties For Dialogue//endregion 

//region bOnInsert
	if(_bOnInsert)
	{
//reportMessage("\n Test1");
		if (insertCycleCount()>1) { eraseInstance(); return; }

	// tokens given by the executeKey to preselect manufacturer and family	
		String sTokens[] = _kExecuteKey.tokenize("?");
		int bHasToken = sTokens.length() > 0;
		if (sTokens.length()>1 && _kExecuteKey.length()>0)
		{ 
//reportMessage("\n _kExecuteKey " +_kExecuteKey);
			String files[] =  getFilesInFolder(_kPathHsbCompany+"\\tsl\\catalog\\", scriptName()+"*.xml");
			for (int i=0;i<files.length();i++) 
			{ 
				String entry = files[i].left(files[i].length() - 4);
//reportMessage("\n files " + entry);
				String sEntries[] = TslInst().getListOfCatalogNames(entry);
				
//reportMessage("\n using sEntries " + sEntries);
//reportMessage("\n _kExecuteKey " + _kExecuteKey);
				if (sEntries.findNoCase(sTokens[1],-1)>-1)
				{ 
					Map map = _ThisInst.mapWithPropValuesFromCatalog(entry, _kExecuteKey);
					setPropValuesFromMap(map);
//reportMessage("\n using map " + map);
					break;
				}
			}//next i
		}

//reportMessage("\n Test2");
		sPainters = PainterDefinition().getAllEntryNames().sorted();
		sPainters.insertAt(0, sDisabled);
		String sPainterName = T("|Painter|");
		PropString sPainter(iPainterIndex, sPainters, sPainterName);
		sPainter.setDescription(T("|A filter which will use painter definitions|"));
		sPainter.setCategory(T("|Filter|"));
		if (sPainters.length() == 1)
		{
			sPainter.set(sPainters[0]);
		}
		
		Map m, mapManufacturer, mapFamilies, mapFamily;
		int n = - 1;
		
		PropString sManufacturer(iManufacturerIndex, sManufacturers, sManufacturerName);
		sManufacturer.setDescription(T("|Defines the Manufacturer|"));
		sManufacturer.setCategory(T("|General|"));
		if (bHasToken)n = sManufacturers.findNoCase(sTokens.first() ,- 1);
		int bManufacturerIsValid = bHasToken && n >- 1 && sManufacturers[n].length() == sTokens.first().length();
		
		// manufacturer given by token entry
		if (bManufacturerIsValid)
		{
			sManufacturer.set(sManufacturers[n]);
			//reportNotice("\nManufacturer set to " + sManufacturer);
		}
		// prompt user to select the manufacturer
		else
		{
			//setOPMKey("SelectManufacturer");
			if (sManufacturers.length() > 1) showDialog();
			if (sManufacturers.length() == 1) sManufacturer.set(sManufacturers[0]);
		}
		
		sManufacturer.setReadOnly(true);
		//region collect families of this manufacturer
		Map mapManufacturers;
		mapManufacturers = mapSetting.getMap("Manufacturer[]");
		for (int i = 0; i < mapManufacturers.length(); i++)
		{
			m = mapManufacturers.getMap(i);
			String manufacturer;
			k = "Name";		if (m.hasString(k))	manufacturer = m.getString(k);
			
			if (sManufacturer == manufacturer)
			{
				mapManufacturer = m;
				k = "Family[]";		if (m.hasMap(k))	mapFamilies = m.getMap(k);
				for (int j = 0; j < mapFamilies.length(); j++)
				{
					m = mapFamilies.getMap(j);
					String name;
					k = "Name";		if (m.hasString(k))	name = m.getString(k);
					
					if (name.length() > 0 && sFamilies.findNoCase(name ,- 1) < 0)
					{
						sFamilies.append(name);
					}
				}//next j
				break;
			}
		}//next i
		//End collect families of this manufacturer//endregion
		sFamilies = sFamilies.sorted();
		PropString sFamily(iFamilyIndex, sFamilies, sFamilyName);
		sFamily.setCategory(T("|General|"));
		//sFamily.set(sFamilies);
		sFamily.setReadOnly(sFamilies.length() == 1 ? true : false);
		
		// family given by token entry
		int bFamilyIsValid = sTokens.length() > 1 && sFamilies.findNoCase(sTokens[1] ,- 1) >- 1;
		if (bFamilyIsValid)
		{
			int n = sFamilies.findNoCase(sTokens[1] ,- 1);
			sFamily.set(sFamilies[n]);
			//reportNotice("\nsFamily set to " + sFamily);
		}
		else
		{
			//setOPMKey("SelectFamily");
			if (sFamilies.length() > 1) showDialog();
			if (sFamilies.length() == 1) sFamily.set(sFamilies[0]);
		}
		
		//region collect products of this family
		for (int i = 0; i < mapFamilies.length(); i++)
		{
			m = mapFamilies.getMap(i);
			String family;
			k = "Name";		if (m.hasString(k))	family = m.getString(k);
			
			if (sFamily == family)
			{
				Map mapProducts;
				k = "Product[]";		if (m.hasMap(k))	mapProducts = m.getMap(k);
				int prodCnt = mapProducts.length() == 0 ? 1 : mapProducts.length();
				
				for (int j = 0; j < prodCnt; j++)
				{
					String sArticleNumb;
					Map m2 = mapProducts.getMap(j); //getting the product by index
					k = "ArticleNumber"; sArticleNumbers.append(m2.hasString(k) ? m2.getString(k) : (m.hasString(k) ? m.getString(k) : ""));
					
				}//next j
				
				break;
			}
		}
		//endregion
		
		sFamily.setReadOnly(true);
		//setOPMKey("");
		PropString sArticleNumber(iArticleNumberIndex, sArticleNumbers, sArticleNumberName);
		//sArticleNumber.set(sArticleNumbers);
		sArticleNumber.setCategory(T("|General|"));
		if (sArticleNumbers.length() == 1)
		{
			sArticleNumber.set(sArticleNumbers[0]);
			sArticleNumber.setReadOnly(true);
		}
		else
		{
			showDialog("---");
			sArticleNumber.setReadOnly(false);
		}
			
		//region Selection
		// default prompt for walls
		Entity ents[0];
		PrEntity ssE(T("|Select Posts|"), Beam());
		if (ssE.go())
			ents.append(ssE.set());
		if (bDebug) reportMessage("\n Number of entities selected: " + ents.length() + "\n");
		if (ents.length()<1)
		{ 
			reportMessage("\n No post elements selected\n");
		}
		else
		{ 
		// create TSL
			TslInst tslNew;		Vector3d vecXTsl= _XW;		Vector3d vecYTsl= _YW;
			GenBeam gbsTsl[1];	Entity entsTsl[] ={ };		Point3d ptsTsl[] = { };
			int nProps[]={};	double dProps[]={ };		String sProps[]={sManufacturer, sFamily, sArticleNumber,sPainter};
			Map mapTsl;	
			//mapTsl.setInt("mode", 1); // 0 = beam/beam, 1 = element			
						
			
			for (int i=0;i<ents.length();i++) 
			{ 
				if (sPainters.find(sPainter) > 0)
				{
					PainterDefinition painter = PainterDefinition(sPainter);
					Beam bmTemp = (Beam)ents[i];
					if (!bmTemp.acceptObject(painter.filter()))
					{
						eraseInstance();
						return;
					}
				}
				
				gbsTsl[0] = (Beam)ents[i];
				tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
				 
			}//next i
			eraseInstance();
		}
		
		
	//End Selection//endregion 
	
		if (bDebug)_Pt0 = getPoint();
		
		return;
	}
// end on insert	__________________//endregion

//region adding Properties
	Map m,mapManufacturer,mapFamilies, mapFamily;
	Map mapManufacturers;
	
	PropString sManufacturer(0, sManufacturers, sManufacturerName);	//iManufacturerIndex
	sManufacturer.setDescription(T("|Defines the Manufacturer|"));
	sManufacturer.setCategory(T("|General|"));	
	mapManufacturers= mapSetting.getMap("Manufacturer[]");
	for (int i=0;i<mapManufacturers.length();i++) 
	{ 
		m = mapManufacturers.getMap(i); 
		String manufacturer;
		k="Name";		if (m.hasString(k))	manufacturer = m.getString(k);
		
		if (sManufacturer==manufacturer)
		{ 
			mapManufacturer = m;
			k="Family[]";		if (m.hasMap(k))	mapFamilies = m.getMap(k);		
			
			for (int j=0;j<mapFamilies.length();j++) 
			{ 
				m = mapFamilies.getMap(j); 
				String name;
				k="Name";		if (m.hasString(k))	name = m.getString(k);
				
				if (name.length()>0 && sFamilies.findNoCase(name,-1)<0)
					sFamilies.append(name);
			}//next j
			break;
		}	
	}//next i
		
	sManufacturer.setReadOnly(true);
	
	String sBarHeightName=T("|Bar Height|");	
	PropDouble dBarHeight(nDoubleIndex++, U(0), sBarHeightName);	
	dBarHeight.setDescription(T("|Defines the Bar Height|"));
	dBarHeight.setCategory(T("|Offsets|"));
	dBarHeight.setReadOnly(true); //To be adjust dependend of catalog selection
		
	sFamilies = sFamilies.sorted();
	PropString sFamily(1, sFamilies, sFamilyName);	//iFamilyIndex
	sFamily.setDescription(T("|Defines the Family|"));
	sFamily.setCategory(T("|General|"));
	//sFamily.set(sFamilies);
	sFamily.setReadOnly(true);
	
	setOPMKey(sFamily);
	for (int i = 0; i < mapFamilies.length(); i++)
	{
		m = mapFamilies.getMap(i);
		String family;
		k = "Name";		if (m.hasString(k))	family = m.getString(k);

		if (sFamily == family)
		{
			Map mapProducts;
			k="Product[]";		if (m.hasMap(k))	mapProducts = m.getMap(k);
			int prodCnt = mapProducts.length() == 0 ? 1 : mapProducts.length();
			for (int j=0;j<prodCnt;j++) 
			{ 
				Map m2 = mapProducts.length() == 0 ? m : mapProducts.getMap(j); // getting the product by index
				k = "Material"; sMaterials.append(m2.hasString(k) ? m2.getString(k) : (m.hasString(k) ? m.getString(k) : ""));
				k = "URL"; sURLs.append(m2.hasString(k) ? m2.getString(k) : (m.hasString(k) ? m.getString(k) : ""));
				k = "Description"; sDescriptions.append(m2.hasString(k) ? m2.getString(k) : (m.hasString(k) ? m.getString(k) : ""));
				k = "Color"; iColors.append(m2.hasInt(k) ? m2.getInt(k) : (m.hasInt(k) ? m.getInt(k) : 252));
				k = "Top Shape"; sTop_Shapes.append(m2.hasString(k) ? m2.getString(k) : (m.hasString(k) ? m.getString(k) : ""));
				k = "Top Shape Diameter"; dTop_Shape_Diameters.append(m2.hasDouble(k) ? m2.getDouble(k) : (m.hasDouble(k) ? m.getDouble(k) : 0));
				k = "Top Height"; dTop_Heights.append(m2.hasDouble(k) ? m2.getDouble(k) : (m.hasDouble(k) ? m.getDouble(k) : 0));
				k = "Top Width"; dTop_Widths.append(m2.hasDouble(k) ? m2.getDouble(k) : (m.hasDouble(k) ? m.getDouble(k) : 0));
				k = "Top Length"; dTop_Lengths.append(m2.hasDouble(k) ? m2.getDouble(k) : (m.hasDouble(k) ? m.getDouble(k) : 0));
				k = "Top Offset"; dTop_Offsets.append(m2.hasDouble(k) ? m2.getDouble(k) : (m.hasDouble(k) ? m.getDouble(k) : 0));
				k = "Top Tolerance Height"; dTop_Tolerance_Heights.append(m2.hasDouble(k) ? m2.getDouble(k) : (m.hasDouble(k) ? m.getDouble(k) : 0));
				k = "Top Tolerance Width"; dTop_Tolerance_Widths.append(m2.hasDouble(k) ? m2.getDouble(k) : (m.hasDouble(k) ? m.getDouble(k) : 0));
				k = "Top Drill Diameter"; dTop_Drill_Diameters.append(m2.hasDouble(k) ? m2.getDouble(k) : (m.hasDouble(k) ? m.getDouble(k) : 0));
				k = "Top Drill Rows"; iTop_Drill_Rowss.append(m2.hasInt(k) ? m2.getInt(k) : (m.hasInt(k) ? m.getInt(k) : 0));
				k = "Top Drill Columns"; iTop_Drill_Columnss.append(m2.hasInt(k) ? m2.getInt(k) : (m.hasInt(k) ? m.getInt(k) : 0));
				k = "Top Drill Edge Vertical"; dTop_Drill_Edge_Verticals.append(m2.hasDouble(k) ? m2.getDouble(k) : (m.hasDouble(k) ? m.getDouble(k) : 0));
				k = "Top Drill Edge Horizontal"; dTop_Drill_Edge_Horizontals.append(m2.hasDouble(k) ? m2.getDouble(k) : (m.hasDouble(k) ? m.getDouble(k) : 0));
				k = "Top Drill Between Distance"; dTop_Drill_Between_Distances.append(m2.hasDouble(k) ? m2.getDouble(k) : (m.hasDouble(k) ? m.getDouble(k) : 0));
				k = "Middle Shape"; sMiddle_Shapes.append(m2.hasString(k) ? m2.getString(k) : (m.hasString(k) ? m.getString(k) : ""));
				k = "Middle Height"; dMiddle_Heights.append(m2.hasDouble(k) ? m2.getDouble(k) : (m.hasDouble(k) ? m.getDouble(k) : 0));
				k = "Middle Width"; dMiddle_Widths.append(m2.hasDouble(k) ? m2.getDouble(k) : (m.hasDouble(k) ? m.getDouble(k) : 0));
				k = "Middle Length"; dMiddle_Lengths.append(m2.hasDouble(k) ? m2.getDouble(k) : (m.hasDouble(k) ? m.getDouble(k) : 0));
				k = "Middle Extendable"; iMiddle_Extendables.append(m2.hasInt(k) ? m2.getInt(k) : (m.hasInt(k) ? m.getInt(k) : 0));
				k = "Middle Length Extend"; dMiddle_Length_Extends.append(m2.hasDouble(k) ? m2.getDouble(k) : (m.hasDouble(k) ? m.getDouble(k) : 0));
				k = "Middle Drill Diameter"; dMiddle_Drill_Diameters.append(m2.hasDouble(k) ? m2.getDouble(k) : (m.hasDouble(k) ? m.getDouble(k) : 0));
				k = "Middle Drill Rows"; iMiddle_Drill_Rowss.append(m2.hasInt(k) ? m2.getInt(k) : (m.hasInt(k) ? m.getInt(k) : 0));
				k = "Middle Drill Columns"; iMiddle_Drill_Columnss.append(m2.hasInt(k) ? m2.getInt(k) : (m.hasInt(k) ? m.getInt(k) : 0));
				k = "Middle Drill Edge Vertical"; dMiddle_Drill_Edge_Verticals.append(m2.hasDouble(k) ? m2.getDouble(k) : (m.hasDouble(k) ? m.getDouble(k) : 0));
				k = "Middle Drill Edge Horizontal"; dMiddle_Drill_Edge_Horizontals.append(m2.hasDouble(k) ? m2.getDouble(k) : (m.hasDouble(k) ? m.getDouble(k) : 0));
				k = "Middle Drill Between Distance"; dMiddle_Drill_Between_Distances.append(m2.hasDouble(k) ? m2.getDouble(k) : (m.hasDouble(k) ? m.getDouble(k) : 0));
				k = "Bar Height"; dBar_Heights.append(m2.hasDouble(k) ? m2.getDouble(k) : (m.hasDouble(k) ? m.getDouble(k) : 0));
				k = "Bar Width"; dBar_Widths.append(m2.hasDouble(k) ? m2.getDouble(k) : (m.hasDouble(k) ? m.getDouble(k) : 0));
				k = "Bar Length"; dBar_Lengths.append(m2.hasDouble(k) ? m2.getDouble(k) : (m.hasDouble(k) ? m.getDouble(k) : 0));
				k = "Bar Extendable"; iBar_Extendables.append(m2.hasInt(k) ? m2.getInt(k) : (m.hasInt(k) ? m.getInt(k) : 0));
				k = "Bar Height Extend"; dBar_Height_Extends.append(m2.hasDouble(k) ? m2.getDouble(k) : (m.hasDouble(k) ? m.getDouble(k) : 0));
				k = "Bottom Shape"; sBottom_Shapes.append(m2.hasString(k) ? m2.getString(k) : (m.hasString(k) ? m.getString(k) : ""));
				k = "Bottom Height"; dBottom_Heights.append(m2.hasDouble(k) ? m2.getDouble(k) : (m.hasDouble(k) ? m.getDouble(k) : 0));
				k = "Bottom Width"; dBottom_Widths.append(m2.hasDouble(k) ? m2.getDouble(k) : (m.hasDouble(k) ? m.getDouble(k) : 0));
				k = "Bottom Drill Diameter"; dBottom_Drill_Diameters.append(m2.hasDouble(k) ? m2.getDouble(k) : (m.hasDouble(k) ? m.getDouble(k) : 0));
				k = "Bottom Drill Rows"; iBottom_Drill_Rowss.append(m2.hasInt(k) ? m2.getInt(k) : (m.hasInt(k) ? m.getInt(k) : 0));
				k = "Bottom Drill Columns"; iBottom_Drill_Columnss.append(m2.hasInt(k) ? m2.getInt(k) : (m.hasInt(k) ? m.getInt(k) : 0));
				k = "Bottom Drill Edge Vertical"; dBottom_Drill_Edge_Verticals.append(m2.hasDouble(k) ? m2.getDouble(k) : (m.hasDouble(k) ? m.getDouble(k) : 0));
				k = "Bottom Drill Edge Horizontal"; dBottom_Drill_Edge_Horizontals.append(m2.hasDouble(k) ? m2.getDouble(k) : (m.hasDouble(k) ? m.getDouble(k) : 0));
				k = "Bottom Drill Between Distance"; dBottom_Drill_Between_Distances.append(m2.hasDouble(k) ? m2.getDouble(k) : (m.hasDouble(k) ? m.getDouble(k) : 0));
				k = "Bottom Length"; dBottom_Lengths.append(m2.hasDouble(k) ? m2.getDouble(k) : (m.hasDouble(k) ? m.getDouble(k) : 0));
				k = "ArticleNumber"; sArticleNumbers.append(m2.hasString(k) ? m2.getString(k) : (m.hasString(k) ? m.getString(k) : ""));
			}//next j
			break;
		}
	}	
//endregion	

//region From Catalog
	PropString sArticleNumber(2, sArticleNumbers, sArticleNumberName);	//iArticleNumberIndex
	sArticleNumber.setDescription(T("|Defines the Article Number|"));
	sArticleNumber.setCategory(T("|General|"));
	//sArticleNumber.set(sArticleNumbers);
	sArticleNumber.setReadOnly(sArticleNumbers.length() == 1 ? true : false);
	
	int iProductIndex = sArticleNumbers.find(sArticleNumber);
if (bDebug) reportMessage("\n Product Index: " + iProductIndex);
	iProductIndex = iProductIndex == -1 ? 0 : iProductIndex;
	
		sMaterial = sMaterials[iProductIndex];
		sURL = sURLs[iProductIndex];	_ThisInst.setHyperlink(sURL);
		sDescription = sDescriptions[iProductIndex];
		iColor = iColors[iProductIndex];

	//TOP CONNECTION
		sTop_Shape = sTop_Shapes[iProductIndex]; //Bar Brace Cut Slot
		dTop_Shape_Diameter = dTop_Shape_Diameters[iProductIndex];
		dTop_Height = dTop_Heights[iProductIndex];
		dTop_Width = dTop_Widths[iProductIndex];
		dTop_Length = dTop_Lengths[iProductIndex];
		dTop_Offset = dTop_Offsets[iProductIndex];
		double dTop_OffsetTotal = dTop_Offset ;
		dTop_Tolerance_Height = dTop_Tolerance_Heights[iProductIndex];
		dTop_Tolerance_Width = dTop_Tolerance_Widths[iProductIndex];
		dTop_Drill_Diameter = dTop_Drill_Diameters[iProductIndex];
		iTop_Drill_Rows = iTop_Drill_Rowss[iProductIndex];
		iTop_Drill_Columns = iTop_Drill_Columnss[iProductIndex];
		dTop_Drill_Edge_Vertical = dTop_Drill_Edge_Verticals[iProductIndex];
		dTop_Drill_Edge_Horizontal = dTop_Drill_Edge_Horizontals[iProductIndex];
		dTop_Drill_Between_Distance = dTop_Drill_Between_Distances[iProductIndex];
	//MIDDLE PLATE
		sMiddle_Shape = sMiddle_Shapes[iProductIndex]; //Circular Rectangular
		dMiddle_Height = dMiddle_Heights[iProductIndex];
		dMiddle_Width = dMiddle_Widths[iProductIndex];
		dMiddle_Length = dMiddle_Lengths[iProductIndex];
		iMiddle_Extendable = iMiddle_Extendables[iProductIndex];
		dMiddle_Length_Extend = dMiddle_Length_Extends[iProductIndex];
		double dMiddleLengthTotal = dMiddle_Length + dMiddle_Length_Extend;
		dMiddle_Drill_Diameter = dMiddle_Drill_Diameters[iProductIndex];
		iMiddle_Drill_Rows = iMiddle_Drill_Rowss[iProductIndex];
		iMiddle_Drill_Columns = iMiddle_Drill_Columnss[iProductIndex];
		dMiddle_Drill_Edge_Vertical = dMiddle_Drill_Edge_Verticals[iProductIndex];
		dMiddle_Drill_Edge_Horizontal = dMiddle_Drill_Edge_Horizontals[iProductIndex];
		dMiddle_Drill_Between_Distance = dMiddle_Drill_Between_Distances[iProductIndex];
		double dMiddleOffset = dMiddle_Length;	
	//BAR
		dBar_Height = dBar_Heights[iProductIndex];
		dBar_Width = dBar_Widths[iProductIndex];
		dBar_Length = dBar_Lengths[iProductIndex];
		iBar_Extendable = iBar_Extendables[iProductIndex];
		dBar_Height_Extend = dBar_Height_Extends[iProductIndex];
		double dBarHeightTotal = dBar_Height + dBar_Height_Extend;
	//BOTTOM PLATE	
		sBottom_Shape = sBottom_Shapes[iProductIndex];
		dBottom_Height = dBottom_Heights[iProductIndex];
		dBottom_Width = dBottom_Widths[iProductIndex];
		dBottom_Drill_Diameter = dBottom_Drill_Diameters[iProductIndex];
		iBottom_Drill_Rows = iBottom_Drill_Rowss[iProductIndex];
		iBottom_Drill_Columns = iBottom_Drill_Columnss[iProductIndex];
		dBottom_Drill_Edge_Vertical = dBottom_Drill_Edge_Verticals[iProductIndex];
		dBottom_Drill_Edge_Horizontal = dBottom_Drill_Edge_Horizontals[iProductIndex];
		dBottom_Drill_Between_Distance = dBottom_Drill_Between_Distances[iProductIndex];
		dBottom_Length = dBottom_Lengths[iProductIndex];
	//OTHER CALC DEPENDEND ON CATALOG VALUE
		if(dBarHeight == 0) dBarHeight.set(dBar_Height);
//End From Catalog//endregion 

//region Global Properties
	if (_kNameLastChangedProp == "Family")
	{
		if (bDebug) reportMessage("\nProp Fam Changed\n");
		sArticleNumber.set(0);
		setExecutionLoops(2);
		return;
	}

	//Entity entPost = _Entity[0];
	Beam bmPost = _Beam0; // (Beam)entPost;
//setDependencyOnBeamLength(bmPost);
	assignToGroups(bmPost,'I');
	
	//Set/Vis Post vecs
	Vector3d vecX0 = bmPost.vecX();
	Vector3d vecY0 = bmPost.vecY();
	Vector3d vecZ0 = bmPost.vecZ();
vecX0.vis(bmPost.ptCen(), 1);
vecY0.vis(bmPost.ptCen(), 3);
vecZ0.vis(bmPost.ptCen(), 140);
	
	//Set/Vis Connection vecs
	Vector3d vecZC = vecX0;
	if (vecZC.isPerpendicularTo(_ZW))
	{
		eraseInstance();
		return;
	}
	if (vecZC.dotProduct(_ZW) > 0) vecZC *= -1;
	Vector3d vecXC = -bmPost.vecZ();
	vecXC.normalize();
	Vector3d vecYC = -bmPost.vecY();
	vecYC.normalize();
	
	int bIsRotated = _Map.getInt("bIsRotated");
	double dPostX = bmPost.dD(vecXC); //Rotated
	double dPostY = bmPost.dD(vecYC); //Not Rotated
	int bPostXFits = dPostX >= dMiddle_Length && dPostX <= dMiddleLengthTotal;
	int bPostYFits = dPostY >= dMiddle_Length && dPostY <= dMiddleLengthTotal;
	int bCanBeRotated = true;
	if (iMiddle_Extendable)
	{
		//Check if it fits in either direction
		if (bPostXFits && !bPostYFits)
		{
			bCanBeRotated = false;
			bIsRotated = true;
		}
		else if ( ! bPostXFits && bPostYFits)
		{
			bCanBeRotated = false;
			bIsRotated = false;
		}
		else if ( ! bPostXFits && !bPostYFits)
		{
			reportMessage("\n" + scriptName() + " - Post size '" + dPostX + "x" + dPostY + "' does not fit selected column shoe.");
			eraseInstance();
			return;
		}
	}
	
	if(bIsRotated)
	{ 
		vecXC = vecXC.rotateBy(U(90), vecZC);
		vecYC = vecYC.rotateBy(U(90), vecZC);
	}
	if(_bOnDbCreated)
	{ 
		_Pt0 = bmPost.ptCen() + vecZC * bmPost.solidLength() * .5;
	}
	_Pt0 = Line(bmPost.ptCen(), vecX0).closestPointTo(_Pt0);
	
vecXC.vis(_Pt0, 1);
vecYC.vis(_Pt0, 3);
vecZC.vis(_Pt0, 140);


	//Painter
	sPainters = PainterDefinition().getAllEntryNames().sorted();
	sPainters.insertAt(0, sDisabled);
	PropString sPainter(3, sPainters, sPainterName);	//iPainterIndex
	sPainter.setDescription(T("|A filter which will use painter definitions|"));
	sPainter.setCategory(T("|Filter|"));	
	sPainter.setReadOnly(true);
	PainterDefinition painter;
	int nPainter = sPainters.find(sPainter);
	if (nPainter>0)
	{
		painter = PainterDefinition(sPainter);
		sPainter.set(sDisabled);
	}
	
	//Top Shape Tolerance Height
	String sTopToleranceHeightName=T("|Top Shape Height|");	
	PropDouble dTopToleranceHeight(nDoubleIndex++,dTop_Tolerance_Height, sTopToleranceHeightName);	
	dTopToleranceHeight.setDescription(T("|Defines the Top Shape Height Tolerance|"));
	dTopToleranceHeight.setCategory(T("|Tolerance|"));
	
	//Top Shape Tolerance Width
	String sTopToleranceWidthName=T("|Top Shape Width|");	
	PropDouble dTopToleranceWidth(nDoubleIndex++,dTop_Tolerance_Width, sTopToleranceWidthName);	
	dTopToleranceWidth.setDescription(T("|Defines the Top Shape Width Tolerance|"));
	dTopToleranceWidth.setCategory(T("|Tolerance|"));
	
	category = T("|Drill|");		
	//PropDouble dDepthDr(10,U(0),T("|Drill depth|") + " " + T("|(0 = complete)|"));	
	PropDouble dOffsetX(nDoubleIndex++,U(0),T("|Top Drill offset X|"));
	dOffsetX.setDescription(T("|Moves the Drills in negative connection direction to create mounting tension|")); 
	dOffsetX.setCategory(category);	
	if (dOffsetX == 0) dOffsetX.set(bmPost.dD(vecXC) / 4);
	
	String sOffsetZName=T("|Top Drill offset Z|");	
	PropDouble dOffsetZ(nDoubleIndex++, U(0), sOffsetZName);	
	dOffsetZ.setDescription(T("|Defines the Offset Z|"));
	dOffsetZ.setCategory(category);
	
	
	

	//v1.04: Notice, this was added after release therefore new index is fixed
	String sDrillAlignments[] = {T("|Right|"), T("|Left|"), T("|Complete Through|")};
	String sDrillAlignmentName=T("|Top Drill Alignment|");
	PropString sDrillAlignment(5, sDrillAlignments, sDrillAlignmentName);	
	sDrillAlignment.setDescription(T("|Defines the Top Drill Alignment|"));
	sDrillAlignment.setCategory(category);
	
	int nDrillAlignment= sDrillAlignments.find(sDrillAlignment, 0);
	int nDrillDir = nDrillAlignment == 0 ? 1 :- 1;	//1=right, -1=left
	int bDrillThrough = nDrillAlignment == 2 ? true : false;

if(iBar_Extendable)
{
	if (dBarHeight < dBar_Height)
	{
		reportMessage("\n" + scriptName() + " - " + sBarHeightName + " '" + dBarHeight + "' cannot be lower then " + dBar_Height + ".");
		dBarHeight.set(dBar_Height);
	}
	else if (dBarHeight > dBarHeightTotal)
	{
		reportMessage("\n" + scriptName() + " - " + sBarHeightName + " '" + dBarHeight + "' cannot be higher then " + dBarHeightTotal + ".");
		dBarHeight.set(dBarHeightTotal);
	}
	dBarHeight.setReadOnly(false); //To be adjust dependend of catalog selection
}
Point3d ptInsertion = _Pt0 - vecZC * (dMiddle_Height + dBarHeight + dBottom_Height);

if(iMiddle_Extendable)
{
	
	//Check if it fits in either direction
	double dPostX = bmPost.dD(vecXC); //Rotated
	double dPostY = bmPost.dD(vecYC); //Not Rotated
	int bPostXFits = dPostX > dMiddle_Length && dPostX < dMiddleLengthTotal;
	int bPostYFits = dPostY > dMiddle_Length && dPostX < dMiddleLengthTotal;
	
	if (dPostY < dMiddle_Length)
	{
		dMiddleOffset = dMiddle_Length;
		reportMessage("\n" + scriptName() + " - Post Width '" + dPostY + "' is smaller then minimum brace width '" + dMiddle_Length + "', select another column shoe.");
	}
	else if (dPostY > dMiddleLengthTotal)
	{
		dMiddleOffset = dMiddleLengthTotal;
		reportMessage("\n" + scriptName() + " - Post Width '" + dPostY + "' is bigger then maximum brace width '" + dMiddleLengthTotal + "', select another column shoe.");
	}
	else
	{
		dMiddleOffset = dPostY;
	}
	dMiddleLengthTotal = dMiddleOffset + dTop_Width * 2;
	if (dTop_Offset != 0) dTop_OffsetTotal = dMiddleLengthTotal - dTop_Width;
}
		
	//Cut Beam and Set insertion point dependend of pt0
ptInsertion.vis(4);
 	Cut ctBottom(ptInsertion, vecZC);
	bmPost.addTool(ctBottom,1);

//ptInsertion.vis(4);
	
	Display dp(iColor);
//End Global Properties//endregion 

//region TOP CONNECTION
	Point3d ptTopLow = ptInsertion;
	Point3d ptTopHigh = ptTopLow - vecZC * dTop_Height;
	ptTopHigh.vis(4);
	if(sTop_Shape == "Bar")
	{//Bar
		//dTop_Shape_Diameter
		Body bdTop(ptTopLow, ptTopHigh, dTop_Shape_Diameter *.5);
		dp.draw(bdTop);
		Drill drTop(ptTopLow, ptTopHigh - vecZC *  + dTopToleranceHeight, dTop_Shape_Diameter *.5 + dTopToleranceWidth);
		bmPost.addTool(drTop);
	}
	else if(sTop_Shape == "Brace")
	{//Brace
		Body bdTopL(ptTopLow - vecYC * dTop_OffsetTotal *.5, vecXC, vecYC, vecZC, dTop_Length, dTop_Width, dTop_Height, 0, 0, -1);
		Body bdTopR(ptTopLow + vecYC * dTop_OffsetTotal *.5, vecXC, vecYC, vecZC, dTop_Length, dTop_Width, dTop_Height, 0, 0, -1);
		dp.draw(bdTopL);
		dp.draw(bdTopR);
	}
	else if(sTop_Shape == "Slot")
	{//Slot
		//BODY
		Body bdTop(ptTopLow, vecYC, vecXC, vecZC, dTop_Length, dTop_Width, dTop_Height, 0, 0, -1);
		//DRILL
		Point3d ptDrillStart = ptTopHigh + vecZC * dTop_Drill_Edge_Vertical - vecYC * (dTop_Length *.5 - dTop_Drill_Edge_Horizontal) - vecXC * nDrillDir * (bmPost.dD(vecXC) * .5 + dEps);
		double dHorMax = (dTop_Length - dTop_Drill_Edge_Horizontal * 2 );
		double dHorSep = iTop_Drill_Columns == 1 ? 0 : dHorMax / (iTop_Drill_Columns - 1);
		Point3d ptDrillRowStart = ptDrillStart;
		Point3d ptDrillColStart = ptDrillStart;
		for (int j=0;j<iTop_Drill_Rows;j++) 
		{ 
			for (int i=0;i< iTop_Drill_Columns;i++) 
			{
				Drill drScrewTop(ptDrillColStart, ptDrillColStart + vecXC * nDrillDir * (dEps * 2 + bmPost.dD(vecXC)), dTop_Drill_Diameter*.5 );
				Drill drScrewPost(ptDrillColStart - vecZC * dOffsetZ, ptDrillColStart + vecXC * nDrillDir * (bDrillThrough ? (dEps * 2 + bmPost.dD(vecXC)) : bmPost.dD(vecXC) - dOffsetX + dEps) - vecZC * dOffsetZ, dTop_Drill_Diameter*.5 );
				bdTop.addTool(drScrewTop);
				bmPost.addTool(drScrewPost);
ptDrillColStart.vis(4);
				ptDrillColStart = ptDrillColStart + vecYC * dHorSep;
			}//next i
			ptDrillRowStart = ptDrillRowStart + vecZC * dTop_Drill_Between_Distance;
			ptDrillColStart = ptDrillRowStart;
		}//next j
		dp.draw(bdTop);
		
		//SLOT
		Slot slTop(ptTopHigh - vecZC * dTopToleranceHeight,vecYC, vecXC, -vecZC, bmPost.dD(vecYC), dTop_Width + dTopToleranceWidth, dTop_Height *2,0,0,-1 ) ;
		bmPost.addTool(slTop);
	}
	else //(sTop_Shape == "Cut")
	{//Cut
		
	}
//End TOP CONNECTION//endregion 

//region MIDDLE PLATE
	//sMiddle_Shape
	Point3d ptMidHigh = ptTopLow;
	Point3d ptMidLow = ptMidHigh + vecZC * dMiddle_Height;
	if(sMiddle_Shape == "Rectangular")
	{//Rectangular
		Body bdMid(ptMidLow, vecXC, vecYC, vecZC, dMiddle_Width, dMiddleLengthTotal, dMiddle_Height, 0, 0, -1);

		//DRILL
		Point3d ptDrillStart = ptMidHigh + vecYC * (dMiddle_Length *.5 - dMiddle_Drill_Edge_Vertical) + vecXC * (dMiddle_Width *.5 - dMiddle_Drill_Edge_Horizontal) - vecZC * dEps;
//ptDrillStart.vis(4);
		double dHorMax = (dMiddle_Length - dMiddle_Drill_Edge_Horizontal * 2 );
		double dHorSep = iMiddle_Drill_Columns == 1 ? 0 : dHorMax / (iMiddle_Drill_Columns - 1);
		Point3d ptDrillRowStart = ptDrillStart;
		Point3d ptDrillColStart = ptDrillStart;
		for (int j=0;j<iMiddle_Drill_Rows;j++) 
		{ 
			for (int i=0;i< iMiddle_Drill_Columns;i++) 
			{
				Drill drScrew(ptDrillColStart, ptDrillColStart + vecZC * (dEps * 2 + dMiddle_Height), dMiddle_Drill_Diameter*.5 );
				bdMid.addTool(drScrew);
//ptDrillColStart.vis(4);
				ptDrillColStart = ptDrillColStart - vecYC * dHorSep;
			}//next i
			ptDrillRowStart = ptDrillRowStart - vecXC * dMiddle_Drill_Between_Distance;
			ptDrillColStart = ptDrillRowStart;
		}//next j
		dp.draw(bdMid);

	}
	else if(sMiddle_Shape == "Circular")
	{//Circular
		Body bdMid(ptMidLow, ptMidHigh, dMiddle_Width *.5);
		dp.draw(bdMid);
	}
//End MIDDLE PLATE//endregion 

//region BAR
	Point3d ptBarHigh = ptMidLow;
	Point3d ptBarLow = ptBarHigh + vecZC * dBarHeight;
	Body bdBar(ptBarLow, ptBarHigh, dBar_Width*.5);
	dp.draw(bdBar);
//End BAR//endregion 

//region BOTTOM PLATE
	Point3d ptBottomHigh = ptBarLow;
	Point3d ptBottomLow = ptBarLow + vecZC * dBottom_Height;
	if(sBottom_Shape == "Rectangular")
	{//Rectangular
		//BODY
		Body bdBottom(ptBottomLow, vecXC, vecYC, vecZC, dBottom_Width, dBottom_Length, dBottom_Height, 0, 0, -1);
		PlaneProfile ppBottom = bdBottom.shadowProfile(Plane(ptBottomLow,vecZC));
ppBottom.vis(4);
		//DRILL
		Point3d ptDrillStart = ptBottomHigh + vecYC * (dBottom_Length *.5 - dBottom_Drill_Edge_Vertical) + vecXC * (dBottom_Width *.5 - dBottom_Drill_Edge_Horizontal) - vecZC * dEps;
//ptDrillStart.vis(4);
		double dHorMax = ((iBottom_Drill_Columns >= iBottom_Drill_Rows ? dBottom_Width : dBottom_Length) - dBottom_Drill_Edge_Horizontal * 2 );
		double dHorSep = iBottom_Drill_Columns == 1 ? 0 : dHorMax / (iBottom_Drill_Columns - 1);
		Point3d ptDrillRowStart = ptDrillStart;
		Point3d ptDrillColStart = ptDrillStart;
		for (int j=0;j<iBottom_Drill_Rows;j++) 
		{ 
			for (int i=0;i< iBottom_Drill_Columns;i++) 
			{
				Drill drScrew(ptDrillColStart, ptDrillColStart + vecZC * (dEps * 2 + dBottom_Height), dBottom_Drill_Diameter*.5 );
				bdBottom.addTool(drScrew);
ptDrillColStart.vis(4);
				//check if point falls inside the body, else the offset direction should be reversed
				int inverter = ppBottom.pointInProfile(ptDrillColStart + vecXC * dHorSep) == 1 ? -1 : 1;
				ptDrillColStart = ptDrillColStart + vecXC * dHorSep * inverter;
			}//next i
			//check if point falls inside the body, else the offset direction should be reversed
			int inverter = ppBottom.pointInProfile(ptDrillRowStart - vecYC * dBottom_Drill_Between_Distance) == 1 ? -1 : 1;
			ptDrillRowStart = ptDrillRowStart - vecYC * dBottom_Drill_Between_Distance * inverter;
			ptDrillColStart = ptDrillRowStart;
		}//next j
		dp.draw(bdBottom);
	}
	else
	{ 
		
	}
//End BOTTOM PLATE//endregion 

// erase duplicates of t-connections
	TslInst tents[] = bmPost.tslInstAttached();
	for (int i=0;i<tents.length();i++) 
	{ 
		TslInst tsl = (TslInst)tents[i];
		if (tsl.bIsValid() && tsl.scriptName() == scriptName() && tsl!=_ThisInst)
		{
			Beam beams[] = tsl.beam();
			if (beams.find(bmPost)>-1)
			{
				reportMessage("\n" + scriptName() + ": " +T("|duplicate will be purged.|"));
				eraseInstance();
				break;
			}
		}
	}
	
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
		Element elHW =_ThisInst.element(); 
		// check if the parent entity is an element
		if (!elHW.bIsValid())	elHW = (Element)_ThisInst;
		if (elHW.bIsValid()) 	sHWGroupName=elHW.elementGroup().name();
	// loose
		else
		{
			Group groups[] = _ThisInst.groups();
			if (groups.length()>0)	sHWGroupName=groups[0].name();
		}		
	}
	
// add main componnent
	{ 
		HardWrComp hwc(sArticleNumber, 1); // the articleNumber and the quantity is mandatory
		
		hwc.setManufacturer(sManufacturer);
		
		hwc.setModel(sFamily);
		hwc.setName(sDescription);
		hwc.setDescription(sDescription);
		hwc.setMaterial(sMaterial);
		//hwc.setNotes(sHWNotes);
		
		hwc.setGroup(sHWGroupName);
		hwc.setLinkedEntity(_ThisInst);	
		hwc.setCategory(T("|Connector|"));
		hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
		
//		hwc.setDScaleX(dHWLength);
//		hwc.setDScaleY(dHWWidth);
//		hwc.setDScaleZ(dHWHeight);
		
	// apppend component to the list of components
		hwcs.append(hwc);
	}
	
// add sub componnent
	if(iTop_Drill_Rows * iTop_Drill_Columns != 0)
	{ 
		{ 
			HardWrComp hwc("Peg" + dTop_Drill_Diameter + "x" + bmPost.dD(vecXC), iTop_Drill_Rows * iTop_Drill_Columns); // the articleNumber and the quantity is mandatory
			
			hwc.setManufacturer(sManufacturer);
			
			hwc.setModel(sFamily);
			hwc.setName(sDescription);
			hwc.setDescription(sDescription);
			hwc.setMaterial(sMaterial);
			//hwc.setNotes(sHWNotes);
			
			hwc.setGroup(sHWGroupName);
			hwc.setLinkedEntity(_ThisInst);	
			hwc.setCategory(T("|Fixture|"));
			hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
			
			hwc.setDScaleX(bmPost.dD(vecXC));
			hwc.setDScaleY(dTop_Drill_Diameter);
			hwc.setDScaleZ(dTop_Drill_Diameter);
		// uncomment to specify area, volume or weight
		//	hwc.setDAngleA(dHWArea);
		//	hwc.setDAngleB(dHWVolume);
		//	hwc.setDAngleG(dHWWeight);
			
		// apppend component to the list of components
			hwcs.append(hwc);
		}
	}


// make sure the hardware is updated
	if (_bOnDbCreated)	setExecutionLoops(2);				
	_ThisInst.setHardWrComps(hwcs);	
	//endregion

// Triggers//region
	String sTriggerRotate = T("../|Rotate|");
	if (bCanBeRotated)
	{
		addRecalcTrigger(_kContext, sTriggerRotate );
		if (_bOnRecalc && _kExecuteKey == sTriggerRotate )
		{
			//read map here once
			
			if (iMiddle_Extendable)
			{
				int iInitialState = _Map.getInt("bIsRotated");
				//Check if it fits in either direction
				if (bPostXFits && !bPostYFits)
				{
					bCanBeRotated = false;
					bIsRotated = true;
				}
				else if ( ! bPostXFits && bPostYFits)
				{
					bCanBeRotated = false;
					bIsRotated = false;
				}
				else if ( ! bPostXFits && !bPostYFits)
				{
					reportMessage("\n" + scriptName() + " - Post size ('" + dPostX + "x" + dPostY + "')does not fit selected column shoe.");
					eraseInstance();
					return;
				}
				else
				{
					bIsRotated = ! bIsRotated;
				}
				
				if (iInitialState == bIsRotated) reportMessage("\n" + scriptName() + " - Column Shoe can not be rotated due to post size.");
				
	
			}
			else
			{
				bIsRotated = ! bIsRotated;
			}
			
			_Map.setInt("bIsRotated", bIsRotated);
			setExecutionLoops(2);
			return;
		}
	}

	// Trigger flip drill face
	String sTriggerFlipDrill=T("../|Flip Drill Face|");
	if (_bOnRecalc && _kExecuteKey==sTriggerFlipDrill)
	{
		nDrillDir *=-1;
		sDrillAlignment.set(sDrillAlignments[nDrillDir == 1 ? 0 : 1]);
		setExecutionLoops(2);
		return;
	}
	
	// TriggerCycleAlignemnts
	String sTriggerCycleAlignemnts = T("../|Cycle Drill Face| ") + T("(|DoubleClick|)");
	addRecalcTrigger(_kContext, sTriggerCycleAlignemnts );
	if (_bOnRecalc && (_kExecuteKey == sTriggerCycleAlignemnts || _kExecuteKey == sDoubleClick))
	{
		if (sDrillAlignments.find(sDrillAlignment, - 1) < 2)
		{
			sDrillAlignment.set(sDrillAlignments[sDrillAlignments.find(sDrillAlignment, - 1) + 1]);
		}
		else
		{
			sDrillAlignment.set(sDrillAlignments[0]);
		}
		setExecutionLoops(2);
		return;
	}
//endregion	
_Map.setInt("bIsRotated", bIsRotated);
#End
#BeginThumbnail
M_]C_X``02D9)1@`!`@``9`!D``#_[``11'5C:WD``0`$````9```_^X`#D%D
M;V)E`&3``````?_;`(0``0$!`0$!`0$!`0$!`0$!`0$!`0$!`0$!`0$!`0$!
M`0$!`0$!`0$!`0$!`0("`@("`@("`@("`P,#`P,#`P,#`P$!`0$!`0$"`0$"
M`@(!`@(#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#`P,#
M`P,#`P,#`P,#_\``$0@!+`&0`P$1``(1`0,1`?_$`+8``0`"`P$``P$!````
M```````("04'"@8!`P0""P$!``(#`0$!``````````````0'`04&`P(($```
M!@(!`08"!P0)`P4!`````0(#!`4&!P@1(1(3%'4)MS@BM!4UMC=X,2,V=D%1
M,K.U%G>X.6$7"M)35)0F&!$!``$"`P0&"`0$!04!``````$"`Q$$!3%Q<C4A
M0;&R<P9188$2,A,S-)'!4K.AT2(C\$)B@A3A\9)38Q7_V@`,`P$``A$#$0`_
M`._@```````````````````````%!'`/),BB<3]9QHM]=1H[-EM!#3$>TG,L
MM(+;N>&26VFWTH0GJ?["(B%/:[GL[;U?,46[UVFB+G1$5U1$=$;(B5CZ3E<K
M7IUFJNW;FJ:.F9IB9[$P'<CR%\R4]>W+RB+H2G;2<X9%UZ]"-;YF1=3&GJSV
M=JZ:KUV9]==7\VSC*Y:GHIMVX_VQ_)]"[FW=2:'+6R<0KIU0N=*6D^AD9=4J
M=,CZ&74?$YK,U1A5<N3'%/\`-]18L1.,441.Z'Y_/3?_`)DK_P"P]_ZQ\?.O
M?KJ_&7U\NW^FG\(?F,S,S,S,S,S,S,^IF9]IF9G^TS'F^WP``(;7OWW<^JV'
MUMX0:OBG>DQL8H89`````$<.8S+,CB)RHCR&FWV'^.&\&7V'D)=9>9=UEDZ'
M6G6EDI#C;B%&2DF1D9'T,3M,F8U++S&WY]OOPB9_[&]X5?=ETN\>W''M!:/=
M=6MUUW3^M''''%*6XXXO"Z52UK6HS4M:U&9F9GU,Q?62^RL^%1W85-FON;G'
M5VRW`)3P`````````````````````````````````````````````'/?P*^5
M76_JFT/B[G@I7S!SK,>)/9"S]'Y99X$P!IFR``````!#:]^^[GU6P^MO"#5\
M4[TF-C%##(`````CKS`^4KE'^G3=OPTR83M,YCE_'M]Z$7/?97O"K[LNE;CM
M\OVB_P#1W67X*I!?>2^SL^%3W85+F?N;G'5VRW$)+P``````````````````
M```````````````````````````'/?P*^576_JFT/B[G@I7S!SK,>)/9"S]'
MY99X$P!IFR``````!#:]^^[GU6P^MO"#5\4[TF-C%##(`````CKS`^4KE'^G
M3=OPTR83M,YCE_'M]Z$7/?97O"K[LNE;CM\OVB_]'=9?@JD%]Y+[.SX5/=A4
MN9^YN<=7;+<0DO``````````````````````````````````````````````
M<]_`KY5=;^J;0^+N>"E?,'.LQXD]D+/T?EEG@3`&F;(``````$-KW[[N?5;#
MZV\(-7Q3O28V,4,,@````".O,#Y2N4?Z=-V_#3)A.TSF.7\>WWH1<]]E>\*O
MNRZ5N.WR_:+_`-'=9?@JD%]Y+[.SX5/=A4N9^YN<=7;+<0DO````````````
M``````````````````````````````````<]_`KY5=;^J;0^+N>"E?,'.LQX
MD]D+/T?EEG@3`&F;(``````$-KW[[N?5;#ZV\(-7Q3O28V,4,,@````".O,#
MY2N4?Z=-V_#3)A.TSF.7\>WWH1<]]E>\*ONRZ5N.WR_:+_T=UE^"J07WDOL[
M/A4]V%2YG[FYQU=LMQ"2\```````````````````````````````````````
M``````!SW\"OE5UOZIM#XNYX*5\P<ZS'B3V0L_1^66>!,`:9LF/.UK$VB*15
MA#3<.0E6356J0TF>[7H>\LY-9BJ43SL5J09(6M)&E"E))1D:D]?OY5SY?SO=
MGY6.&.'1CMPQ].#X]^CW_EXQ\S#'#KP].#(#X?8```"&U[]]W/JMA];>$&KX
MIWI,;&*&&0````!J#D(VV]H+>#3J$.M.Z@V6VXVXE*VW&UX7=)6A:%$:5H6D
MS(R,NAD)62^]L^+1WH>&:^VN<%79*_[ARI2^(G%=:U&I2N.&CU*4HS4I2E:R
MQ@S4HSZF9F9]IC]!V/HT<,=BGKOU*N*>U(\>KX``````````````````````
M```````````````````````'/?P*^576_JFT/B[G@I7S!SK,>)/9"S]'Y99X
M$P!IFR5R<M)LR!R%XZR8,N3"D?:%:SX\1]V,]X,G+Z^/(:\5E:%^&_'=4A:>
MO12%&D^I&9#O/+-%%>AYZFN(FG">B8QV43,?Q<GKE55.JY2:9F)QC9Q0L;'!
MNL````0VO?ONY]5L/K;P@U?%.])C8Q0PR`````-1\@/R&W;_`*1;)_!MT)62
M^\L^+3WH>&9^VN<%79*_KAO\H7%7]-^COACBX_0=CZ-'#'8IZY]2KBGM20'J
M^`````````````````````````````````````````````!SW\"OE5UOZIM#
MXNYX*5\P<ZS'B3V0L_1^66>!,`:9LE;?+_\`/_CKZI3?C2L'?>5^2Y[AJ_;E
MR.O<TRF^._"R0<"ZX```!#:]^^[GU6P^MO"#5\4[TF-C%##(`````U'R`_(;
M=O\`I%LG\&W0E9+[RSXM/>AX9G[:YP5=DK^N&_RA<5?TWZ.^&.+C]!V/HT<,
M=BGKGU*N*>U)`>KX````````````````````````````````````````````
M`'/?P*^576_JFT/B[G@I7S!SK,>)/9"S]'Y99X$P!IFR5M\O_P`_^.OJE-^-
M*P=]Y7Y+GN&K]N7(Z]S3*;X[\+)!P+K@```$-KW[[N?5;#ZV\(-7Q3O28V,4
M,,@````#4?(#\AMV_P"D6R?P;="5DOO+/BT]Z'AF?MKG!5V2OZX;_*%Q5_3?
MH[X8XN/T'8^C1PQV*>N?4JXI[4D!ZO@`````````````````````````````
M````````````````<]_`KY5=;^J;0^+N>"E?,'.LQXD]D+/T?EEG@3`&F;)6
MWR__`#_XZ^J4WXTK!WWE?DN>X:OVY<CKW-,IOCOPLD'`NN````0VO?ONY]5L
M/K;P@U?%.])C8Q0PR`-(;UY!ZZX]8W"OLZE6$JPNY,F!B6&XY'BV&8YE91(_
MFI4*@KIDZL@(:AQS2J3-G2H5;#)QOS$EKQ&^]L=,TO.:MF/^/DZ<:MLS/133
M'IJG^6,SU1*%GL_EM/L_.S,X1U1'3,SZ(C_$1URT3H7F_C^Y<_BZXNL%LL`O
M;VOL)V(R7;Z%D=5>2*B*[96>/RI#$&IDU>2M4S#TUIE#,J(]&AR3*42VT(=V
M^L^5<[H^6C-UUT7+.,15[N,33CLV]4ST8^G#HZ6OTW7\MJ5^<O3351<PQC'#
MIPV[.OK3E'+MZU'R`_(;=O\`I%LG\&W0E9+[RSXM/>AX9G[:YP5=DK^.&JDK
MX@<4UH4E2%<;=&*2I)DI*DJUABYI4E1=2-)D?88_0=CZ-'#'8IZY]2KBGM22
M'J^`````````````````````````````````````````````!SW\"OE5UOZI
MM#XNYX*5\P<ZS'B3V0L_1^66>!,`:9LE;?+_`//_`(Z^J4WXTK!WWE?DN>X:
MOVY<CKW-,IOCOPLD'`NN````0VO?ONY]5L/K;P@U?%.])C8Q0PR`*N-/8V?*
M/E/MO:F21&KR#@.=0=*ZCH9Q,V&.P/)9?98;3V%C"DDVU+H\CRJKE7,I]ELG
MEHLHA*6ZU7LK1>'E;3K>GZ/:F(_O7J8N53U_U1C$>RG",/3C/6JW7L[7G-1K
MB9_M6YFBF-W1,^V<9_#T)1<B=`81@7/[CMCF%3J^TR_`L+V/M_;-C6U$:HC,
MU]GA4C5&*UDJ)`4_&@R9=IG;[M<V\HY3\*'(-3KQQEJ$/SMF:+.B56)^.]73
M3$<,Q7,^SW</;"3Y8L57=4B['PVZ:IGVQ[L1_''V)2BFUDO([`_@/-OY1R3_
M``::/6S]:CBCM>=WZ57#/8N=]O;Y!>#WZ0.-/P8PH?HU3"7X````````````
M``````````````````````````````````Y[^!7RJZW]4VA\7<\%*^8.=9CQ
M)[(6?H_++/`F`-,V2MOE_P#G_P`=?5*;\:5@[[ROR7/<-7[<N1U[FF4WQWX6
M2#@77````(;7OWW<^JV'UMX0:OBG>DQL8H89`%0-=H#F9IG:V?M:7KZ*UQ;,
M<XN<CH\JG93CU7B;5/:Y799;CL+.ZBS399=7VV$/V)Q%R:JJN/-MLID(Z>9>
MAL6KIOG/2[.F6[>9^9&9MVXIFF*<?>]V,,8G9TX8],QAL]<\#G?+6?NYZNNQ
M[DV*ZYJB9G##&<<)C;T>K'%85H_3T_6<+(\AS7+)&QMP['G0;K:&Q)<-->5U
M.K8JXE-0T%6EQ\J'"L5BONM5D`G'/#4^^^M2GI#RE<'K>LW]:S?_`"+L>[:I
MC"BG;[L?G,]<_E$.LTO3;6F9?Y-']5R>FJKTS^41U1^<MZ#3-D\CL#^`\V_E
M')/\&FCUL_6HXH[7G=^E5PSV+G?;V^07@]^D#C3\&,*'Z-4PE^``````````
M````````````````````````````````````.>_@5\JNM_5-H?%W/!2OF#G6
M8\2>R%GZ/RRSP)@#3-DK;Y?_`)_\=?5*;\:5@[[ROR7/<-7[<N1U[FF4WQWX
M62#@77````(;7OWW<^JV'UMX0:OBG>DQL8H89`````'D=@?P'FW\HY)_@TT>
MMGZU'%':\[OTJN&>Q<[[>WR"\'OT@<:?@QA0_1JF$OP`````````````````
M````````````````````````````!SW\"OE5UOZIM#XNYX*5\P<ZS'B3V0L_
M1^66>!,`:9LE;?+_`//_`(Z^J4WXTK!WWE?DN>X:OVY<CKW-,IOCOPLD'`NN
M````0VO?ONY]5L/K;P@U?%.])C8Q0PR`````/([`_@/-OY1R3_!IH];/UJ.*
M.UYW?I5<,]BYWV]OD%X/?I`XT_!C"A^C5,)?@```````````````````````
M``````````````````````#GOX%?*KK?U3:'Q=SP4KY@YUF/$GLA9^C\LL\"
M8`TS9*V^7_Y_\=?5*;\:5@[[ROR7/<-7[<N1U[FF4WQWX62#@77````(;7OW
MW<^JV'UMX0:OBG>DQL8H89`&F]V;WU[H+%V<FSR=-4Y92SK,;QFCBHLLJRRW
M\,W?LR@K%OQ65J::^G(E2GHM?!:_>RI##1&LI^G:9G-5S'_&R=/O5X8S.R*8
M],SU1_&=D1,HF=SV6R%GY^9JPIZHZYGT1'7V>EH+0W.#%MSY^UKBSP7(<`O;
MJ-:3L.D6%G4WM5D#=3&782Z67+K5-/4^7M5##\U40FI,%4:*\;4YU:.X>XUC
MRMGM'RT9NY71<LXQ%7NX_P!,SLVQTQU8^GJ:W3=>RNI7YR]%-5%S"9C'#IB-
MT[>O#^*<(YAO7D\^2I>"YHA"34I6)9&E*4D:E*4JGF$24D74S,S/L(>MGZU'
M%':\[OTZN&>Q<O[>+S4C@!P:?8=;?8?X><9GF7F5I<:>:<TKA*VW6G$&I#C;
MB%$:5$9D9'U(?HU3"88`````````````````````````````````````````
M`````Y[^!7RJZW]4VA\7<\%*^8.=9CQ)[(6?H_++/`F`-,V2MOE_^?\`QU]4
MIOQI6#OO*_)<]PU?MRY'7N:93?'?A9(.!=<````AM>_?=SZK8?6WA!J^*=Z3
M&QBAAD`528+3JY.\G-J[2NH"LBK==9S7:*U!C\UJ!=8K%GHS>7@U:]=5KTA3
M,O',[SJM?L)<^*VEWRLVO.2XJ/5MN-W=Y5TZC3](MU8?W[U,7*IZ_P"J,:8_
MVTX='IQGK5=K^=JSFHUQC_:MS-%,;NB9]L]?HP]"4N_...):RY]\=:'$)M?>
MYAB.);(V[MRUI:F-C=3`K)N"S=58G`71QIEA&KGI=MG#WD6S<5,E1HSZW'7O
M*N**+YUS-%G1*K%4Q[]ZNFF(X9BN9]GN_P`8]*1Y8L5W-4INQ\%NFJ9]L33'
M;_!+84VLD`67^T[_`,67MI_H`X;_`.W77(_22E$_P```````````````````
M``````````````````````````!SW\"OE5UOZIM#XNYX*5\P<ZS'B3V0L_1^
M66>!,`:9LE;?+_\`/_CKZI3?C2L'?>5^2Y[AJ_;ER.O<TRF^._"R0<"ZX```
M!#:]^^[GU6P^MO"#5\4[TF-C%##(`IZA:)YE:9VOG,+3>.0[_$,KSJPRVGRR
M=EF'5F%^4>S-[,<2C9M6V-FK.J^WP^98^$_)JJ:Q)]N(MUOO^8.&5KZ;YQTJ
MSI=NC,S7&:MVXIFF*9GWO=C#&)^'IPZYC#'VJ_SOEO4+F>KJL13-BNN:HJF8
MC#&<<)C;T8]42L/TAJ.WUY'R;+-@Y8O8VZMF385MM#83L9<-JS<JRFHQS%\?
MKW'7CJ<,PV)9/M0(R322WI$F6I"'I;J2X+7-:OZWF_GW(]VQ3T44[?=CKWS/
M7.Z-D0ZW2M,M:9E_E4?U7:NFJKTS_*.K\>MO8:5LP!9?[3O_`!9>VG^@#AO_
M`+==<C])*43_```````````````````````````````````````````````!
MSW\"OE5UOZIM#XNYX*5\P<ZS'B3V0L_1^66>!,`:9LE;?+_\_P#CKZI3?C2L
M'?>5^2Y[AJ_;ER.O<TRF^._"R0<"ZX```!#:]^^[GU6P^MO"#5\4[TF-C%##
M(``````++_:=_P"++VT_T`<-_P#;KKD?I)2B?X``````````````````````
M````````````````````````Y[^!7RJZW]4VA\7<\%*^8.=9CQ)[(6?H_++/
M`F`-,V2MOE_^?_'7U2F_&E8.^\K\ESW#5^W+D=>YIE-\=^%D@X%UP```"&U[
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
MCXG`>3T428],I:U6IMGU2:YJEM.%T43#9@)P---,--,,--LL,MH:99:0EMII
MIM)(;::;01(;;;01$E)$1$1="`2N]H/^#^;/Z[LU_P!N_&8!;L``````````
M````````````````````````````````````````*S?>>_XEO<>_1GR"^'%\
M`H!```!Y6VQ*LL>\ZRGR,H^I^(PDO"6K^MUCZ*%=3_::>ZH_Z3,!K2UQ^RJ#
M-4AGOQ^O1,ICJXR?]7>/H2FE'_4HBZ_T=0$4<:U+L/:^8WE9@F,6%VMJZGHF
MST(3&IZPES'C)5E;RE,U\,S1U4E"G/%<(C[B5'V`++-.\!L,Q=4:YVI/;SFY
M02'$T$/S,/$X;Q&E7[Y1FQ97QMJ3V>*4>.HC-*V%EV@)]U]=7U$&+654&'65
ML)E$>%7U\5B%!B1VRZ(8BQ(R&V([*"_8E"227]0#]@``E5[0?\'\V?UW9K_M
MWXS`+=@`````````````````````````````````````````````````!6;[
MSW_$M[CWZ,^07PXO@%`(````#X,B41I41&1D9&1EU(R/L,C(^PR,@$ZL,JZV
MHQ:BB5-=!K(IUD*0<:OB1X4<Y$F,T])?-F,VTV;TAY9K6KIWEJ,S,S,P'IP`
M```$JO:#_@_FS^N[-?\`;OQF`6[`````````````````````````````````
M`````````````````"AWW3N6N(\C>*7,?AAQ.Q^UY(;#S34>Q=,;5V1A$R#'
MX\<:I&7X_*QZRE[;W5)-[&;'-\?*R)2L)Q@K_+TO&V4V#7Q7#FMA5B``````
M)[XY_#U%Z-5_46`&9`````9WBGO:]X&'O2WWMJG+)W%?>&^K#<-5RCU@W-V%
M5ZAL[/6FL-?7>*\B-64]0>P<!QB!8ZY5*BYC4,Y'CQ1)I'<.4G@]YX+W\/S+
M$-AXM09S@&58WG.%955Q+S%\PP^\K,FQ;)*6>T3T&WH,@I94VIN*N:RHEM2(
M[SC3B3ZI49`/2``````````````````````````````````````````````"
M(_)'FOI+C18T>$Y!*R'8V\\UAKFZWXUZ=IBS[?.PHZ9/DU6M3A425%;QS#(D
MLC1-R?(95-BU:9'YRQ8[",(@6.E>4_,WQ)G,S+3T-H::XA^OX6<=<ZMFKK)J
MT_#4W$Y4<F:$Z+(\W*5'4M$[#\'30XLV;CD6;991&)M\!N+>V`8+JSB#GVO=
M9X9BNO,"Q3`W:K%\*PC'ZK%L4QVM;FL.H@4F/T<2#55<0G75+\-AI">^I2NG
M4S,PYY``````!/?'/X>HO1JOZBP`S(````"S3BS^4\/URZ_OFP&B,CX5WVJ,
MLN]O<!=D0N+FQ+^V>R'.=1SZ&9EO#W=EM)>=E6LW86BJZWQ]O!,YR!]PU2,S
MP>7C]\^^:7K0KIMM,4PVMJ/W`,?D9SC>A>6V!R>(7)')IOV+AV-9?D+.2:3W
ME;MLN.J+C9R";JZ#%ME293+"WFL<LXN.YXS'2IV10,LI\4PL-```````````
M```````````````````````````````&J=T[ST]QSU[<;6WKLC$=5Z\HE1V;
M#*LSN(M/7'.FK-FLIJXGU^:NLBNI71B!6PVY$^?)4EF.RZZI*#"N^QW'S(YG
M^)`T5295P7XW3'$(=W]M?#:YSEOM.B?\,UR-)Z`S2!/I^/=9.CDKP;_94&;D
M:"<Z?Y/B+2W+`87367^V7Q$F91BV)<B^->/;/RNVCRMLYKLKDC@63\@=IY>T
MGRY76WM@9WFT[8N99";BU)8;GR%,P4+\"&S'CI0RD+#ZBXJ<@K(%W0VE==TU
MI%:FUEO438UE66,-])+8EP)\-UZ++BO(/JAQM:D*+M(P&B>67RX[=_E*1]:B
M`.;8``````3WQS^'J+T:K^HL`,R`````LTXL_E/#]<NO[YL!(P!K_:6J-9;O
MP/(=7[AP'$MG:ZRN(4'(\+SBAKLDQRWCH<0^QYNKM(\F,J1#E-(>CO$DGH[[
M:'6E(<0E1!"J+@G,+A4A$KC7=VW,+CA6J(Y'%3=F=.%R`U[1MI-I$'C7R9S2
M>^C-JVH9-/EL3V=(?==;;\*-EM>RAF(H)L<<.7^C.4D3((VM<CL*[/\`!G8\
M+:.D]A4=CK[>6I+:0A*D5NQM6Y,U"R>B9D.=Y,*S0U(I+="#>K9LR,:7E!)T
M``````````````````````````````````````5G<D><N<4O(@^$'%?`\,RS
ME`_KFCV?>YCN_*V,,T7J?",JL;^IH+RRJ:BP/:^Z\MFR<8GNQ\7Q>%'96U$5
M]IWE(AUAYT/HU1PKQZBV%6;_`.0^>Y%RQY/UK3Z:;;>SZZM@8SJU,Q"VI59Q
MTTQ5*=U]HBJ5%<5&7,KFI64V,51HM;NR4I:U!2K_`.03M391;'XR\<+;*<FP
MWC5M3#=CY1E59C\^=CU9O#8>+W>+0&-:YC=P941[(*'%,3MGKA.*F\W$NW)!
MR9;,MJM2E@,EK&MX+X+I"9@=/Q+XJY?41JF@@UV=,2:"CJY$?-K9_%X#UC6S
ML(R"34R:!Q@G)\9Z;)6MKNI=5U4:$A#;VY<KM=%>ZG@&E^)%LM.D-SW>SG]T
MZ5P7[33IB+@%%K?)<C>WA68D_*LZ;7]GC>V(%/3LWT7RR;XK=->XI\Y,7P0Z
MLN67RX[=_E*1]:B`.;8``````3WQS^'J+T:K^HL`,R`````LTXL_E/#]<NO[
MYL!6;[TO.;>O%?&]":@XZVD;`-A<D+#9\BPW7-Q^JRAW6^#:EK,/<R"%A=)D
M<6;BDG:.6VNPZU-4[:QK"'#KH-G)5!E*93X80PTWQXXV9-@AY#RIY)>X1F6X
MK6NQ>[AY1'Y1<I;VONI&:1BJJ2PQE&LLV;PO&J^QNG)$.+!?CT42,P?4TH;<
M6XD-4Z'YA\E>%?-S36@G=O;AWUQKW'MK5FFK;5?(7+&=O;5UG8[DL(.)XKF&
M`[ADVV1["DQ,2R6V@R[BJN[.XAJQA$EYE$!YE4ET.D3D+Q#TWR0D8[DV4P\A
MPG;V!H?+5_(;4E\_KS?FK5R5+<DM89LBI:58_8%@ZOO3Z"R;L<;MRZ(L*^6W
M]`!H"%S+W=PUV/IS2'."SQ'=&&[SV?@FE-)<I]8Q<>PS8,_/ME974X/@./\`
M(OC@FS8^S%W.3W<.O>S;`O.8ZNPEM*FT6.1EI4`M^```````````````````
M``````````````````<3OOHQ,KU7[E*MM9'5Y7A&";&T1Q_Q/66W)%9<U6"6
M^Q<)RC=LVWPRLV,RPC'*S85>Q=PY4>J>F,6DAATGHS3B$J4D-O\`$SWE-JZN
M*MPWD3"G;AP=@F8C.7QW&&MGT<=)F7B2I<E;,#.&FT="[LU<><H^JE3%]"0`
MO@5)X:^X_I.PQB[J]:<BM46KM?*O,+RRIC64O'+V,A4BKF3Z*T:9R#"\NIW7
M%.09[28LR.Z7C1'R['`$&+'V"^`,FT\U4?\`](XM2&M"E8A3\G=O3J3NI>6Z
MIAFSRO(LES6%'<0HF^Y'MF4MMH23?</J9A8!Q=X1\6.&-)=4O&W3N/:[=RAR
M*]F&5+F7N8;(S=V`3I5YYQM+.K;)MC9DBL\=SRC=E:2FHGBK)A+9+41AZ/EE
M\N.W?Y2D?6H@#FV```!N'4VAMH[KL?)8%C,J;#9<)N?D,WK7XU5]J>\4VX?1
MY<WTI62BCL^-*6GJ:&E$1]`MQTE[?^M,`3$NMC+:V7E*":>\I+CJ8PVLD)+O
M*1&IUJ-R[[BE&DW)QJ:<21**,TKJ`W]L'CE@>:(>E5L9&)7BD_0GT\=M,!U9
M$1)\]3)4S%=3T(^JF38=,SZJ4KIT`07V!I?.M=N.O6M:<^F2?[N_J2=EUG<,
M_H^:5X:7ZYS]A&3Z$)-78E2B[0&IP```6:<6?RGA^N77]\V`PW+CAOH?FWK%
MK5N^,;GV==4W3&5X5E>,W,W%L_UOFD.),@P<PP/*ZU29E/<,0Y[S#S3B9%?8
MQ'G8DZ-*B.NL+"F@O8LY"8DZJGU)[FF4T6"N2HG?K=B<<HV8YBFOKIZ+"L*/
MDNM]Z:.Q&-=092WWFYB,9)M,EU+J(Z32HG`DOQL]J[BYP5R0N5W(+=F2[NVQ
MA"+"?3;:WA88WA^O]83KJ!)J+6TUYKVC:A4D+*[V#->B-V=S*R+(DHE.QH,Q
MEN4\RZ$?^6GO7H3]I85Q(IN^K]Y%>W)F57]`C_>).1A.$V+?59_V%-S+ILB_
MMH57&7<=`4AZIR7:_*7G?Q<IXTG/M[;C@\PN&VW]@_9T6\S:UPG5VL.4>I]D
M9EG6?V$1F97:ZP/'L0Q><Y%>LG($%Q;2(4$EON,QU!_H@@``````````````
M``````````````````````/(Y[@&"[4P[(M=[-PS%=AX#EU:]3Y5A.;X_595
MB>25+YI4]6WN/7D2=4VL%Q2$F;3[2T&I)'TZD0#F3YB?^/E88V=IL'VY\RBU
M,1)OSIO$?=627$[`'4=/&=BZ0W%-1>YAK&4M2%E'I+]-_CJENML17J&&T70*
M&L>V%N?C)NQW$K:#M+B[R4PUCSL[`<O8=P[.$5!3/!>LZ=V++G8OM#74Z;"-
MH[6DF7>-6!([A2'2ZI`="?$OWKJNS.LPKEG3-TLY1LQ&=OXA6NN4SYF1I\QF
M>'PD.RZMPS01KE5*'V5K<Z%"CMH-9A?3B>7XKGN/5F6X3D=)EF,7,<I55?X[
M9P[>HL&#,TFN+/@NOQW>XM)I61*[R%D:5$2B,@&F^67RX[=_E*1]:B`.;8!L
M'76JM@[8ND4.`8O9Y#-[S92GHS/AUM8VX9DF1;6KYM5U7'/H?13SB.^9=U/>
M49$86OZ1]NK%,<\G?;ELF\RN6S2\G%*AR1%Q.(OIU2BPF&B-:WSC:B)70O*1
M^O5*T/([3"R"JJ:NBKH=/25L"GJ:]E,:!65D1B!`A1T=>ZS%B16VH[#23,_H
MI21=3`9```?RM"'$*;<2E;:TJ0M"TDI"T*(TJ2I*B-*DJ2?0R/L,@$:]A\9,
M+ROQI^-=S#KI7?690F"<HY;A]I$_5DMM,,S,NA*C&VE/4S-M9@(,YUJO-M=O
MFG(ZAU$%3OA1KJ'UET\HSZ]PD3&T]&'7"29I:>)IXR(S[O3M`:[`6:<6?RGA
M^N77]\V`D.^^Q%8>DR7FH\:.TX_(D/N(988890;CKSSKAI;:::;2:E*49$DB
MZGV`*>>6/O#:6TW]J8CHYB%N_8D?QXJK>)+6UJR@FH\9KOS,@B+3*S!QAY*%
M>!4F45]LU%]H,K3W0',UR3Y?;>Y"9C1S]R9ODN=9-D-LY4:UU?BU5:7,NPN)
M?=[F-ZIU/B42=9W=V\R2$K3`A2K%]MLER7'.X;A!93P[]B[DIR(^R\ZY?W5U
MQ,TY*\.7'TYA]C3V/)[-H"O#>91F6713N\,T54V#+G==A5QW>3=SJ1RJ:2DT
MI#JDXU\5./'#_7,35/&W4^*:IPMATID^-C\1UZZRBX-LFG\ESK+;1^PRS/LM
MFH212+:ZFSK%_H7B/*(B(@D&````````````````````````````````````
M```"-W)_B'QOYEZ^_P"V?)34^-;/QJ-(=L<?DV:)=;EF#WKK!QDY1KG.Z*35
MYIKO+&&3[K=G2SX,Y*.J?$[AFDPY3^8GL@<I^,OVIF_%RRO>96D(A/S9&O;4
MZ2JY8X%7(5WC9IU,-T>#<AJFOCDI?=93C^5$V@FFHM[+7WE!7_Q;YJ[=X^Y#
M:7&D,]M:)ZJNGZK8&LLFK[.-"8OX!ML6..;+UADC-=;8SE4-MDF742HU?=0T
M'T0MKKU,+_L<]U?5/)W1F;:MSVM;U+NC(<;*HJH<R:ES7N77#TF(A+=)E,U3
M",;?E*0ISRUPIEEHC2VB9)</M"0&D/;DCDF'D.[[I$HE$Q)8PK%9W6,I*B)?
MA7N1MH)3Z%)/HIJO-)?TIE*+L`6@XMB6,8131L>Q"AJL;I(G4V*VGA,PHI.*
M2E+C[B&4)-^4\2"\1UPU.N&752C/M`>B```````!]$F+&FQWHDR.Q+BR&U-/
MQI+3;\=]I1=%-O,NI6VXVHOVDHC(P$6-B<5\:O\`S%EA,E.+VJ^\Y]F.I6]C
MTASI_90A!*E57?5VF;?BM)+L2T7[0$4,TYU:4X.Z\EX-GEFWF6X*^WN%LZNP
M:QK[:S:4^X1Q7LENV'7ZC$H:S2E2T2E'8DVLEMPW>T@'/+S(]RW=G(B#=/[$
MS6MU7IF#XDIS!:.U.@Q&/`;-'ANYC=RWX\S*GT^&A2CG.%#2^7?CQF#/N@/N
MX?\`MA\T><IU.38YC3_&#CO8^!)/?N[<6L&<OS"H=..]YG2.B;!ZFR?((UA7
MR$NPL@R15)0NH6E^(FV;)31AUD\)O;%XG<$(;]IJC#9>5;>N:]N!F/(;:<J-
MF>Z\L9(E&[!/*'(,.%AV,..+-146.0Z>C0KHHHGB=5F%A```````````````
M``````````````````````````````"MSG%[5?$OG?\`_J=A8O8:[WO75S-?
MBW)34+\'$=QTT>&EPJZIO;1=?/H]FX=$4XKI0Y3!N*E!+4MAEA_N/H#D[YA^
MW!S&X'G:Y%L3%SW]Q[K5NNL\E-)XU:R7<=J4*-+$K>6F(KU[EVN7&VB)4JXJ
M7+[&6RZO295:@R92'J^'7N<[RXY0:-G%<IK]P:5D-1GHF#W]R=Q0E4J4A1.X
M#E<1<Z5C!+9)9,E&.35]YPW%PW5]#(.GGBM[@_'?E?'C5F)Y$>([&4T2IFL,
MT<BUN2K<0T2WW,=?2\NMRR"@TK,E0G%24-([[\=CO$0"<8#PFTMDXAIK66Q=
MO[!LTTF!:JP3+MDYO<K0;B:C$,&Q^PR?);-39&1N)@4U6\Z9$9=21T`<W&KO
M<'YT<]LXG6&+;NUG[<.B7)C$'&_%UUBVU-KM-6T62]4JV'M/;D&^TK0Y7/C$
MRINHB8\MJ'9/)AIEV[9*D&&9WORJ]PKA#.@9-B?-'3ON!XA7RX$?+L-V?JG7
MN)6))FOS5'3Q]O<8,<P7&\#RA]3'A,NV6/6[;+!M+.!*4;RT!>YQ(Y+X7S"X
MZ:OY'8#`M:7']D5%B\_CE\<15[B.58QD-QA>>X3>+KWY,!VYPG.L<LJF4MAQ
M;#C\-:FU&@R,!(T!'[D!RCT?QCQS_,6X,YKL>5(8==IL<8/[1R[(U-=4^%0X
MY%-5A-2;I=Q3ZDMQ&5&7BNMEV@.:_EK[O^Z=U)M<2TRB9I'6LA#L5Z=!FH5L
MJ^A+2:'%6.215$UC+#R.TX]6:7D$9I5+>0?0!6SQHX[\FN=V43*3B9K=S8%3
M%N)=;F?(/-YT_%^.6$64>03=RQ:[,\A9R=AY;627DE(H<4BW=JTZLBFE!:-3
MZ`ZHN$'L<<:^,EKCNV-Y3E<M^1]*[&M*K-]B4$2!JO6-VTHUE*TEI,Y=QCV*
M38JB;-F\N)&090TXV:F+*.VXJ.07:@``````````````````````````````
M```````````````````"BCFS[$?'??T_(=I\9+1CB#OZX>EV]M,PW'F+31.S
MKMY*WEN;3TJS+J:AFSM)G14G(,:?H[YQ:C<E/3TI\!0<NG(31?)7@]F-7C?+
M+64[4S\RWCPL&W3B]I(RCC_G]JA\RKCPW;46'6HQC)ILA@W(U#DL>AR$^[WV
M(S[1$^H+3.)?O&;@U&=9A^_8\_=6OV5-1DY&Y):1M.@B=XB4XBVEK;BYLTRD
MU&35FMN8LS(O/)0E+8#H;P#;_&WFWJ3*Z7%LBQ_9F`YUB5UAVQ,(EO/P+MK'
M<MJ)5'D.-Y;CRW85]4-V-;/?C*<(D-/)4I4=Y:>ZX8<_TKV=^?W%BVL:GAUN
MK3^\=.2)M'(J,?W[?Y#K#:U+!QNT8L,:J\AN<>UQLW!]G3:-V*TE5RAK$9;\
M8C2['D.]];X?,OVNO=1Y'JB87N_9O&;CIJO_`#!8WEO8Z^R'+MV9N4FVL;"V
ML'\;PN9K;5^+JFDNT=;@S+?(IK$%T_$75RDH[KP7Z:BUSQ_]OKB]@6JJW(X>
M":9TQC:*5G)L^OXI6%Q9SYTVZR#)<CMGDPVK?-L^RRSFVDTHS+9R[.<[Y=A!
M*0TD*<.67O7RI)V.&<2Z4X<?J]%?V_F582I;R#):/,89ADY'<AD9]U;<NW0M
MPTF:50&U$2P%"[-SO+E3NF9A&N\:V?RIY&Y`4>RM<:QETL@NJB%8/.M0+[96
M:9!8P,,U-A:GTJ;9L,ALJN!T2;,7Q7"2R8="'#O_`,>^B4JIV'[BN75&W+5*
MV;")Q8UA874#CS2K0HG6(FT<KE1J'-N0<MEQM"WH<AB@Q-PE+C2:BR;24EP.
ME+&<8QO"\>I,1P['J/$\3QJKA4>.8QC-3`H<>Q^EK8Z(E=44E+5QXM;55=?%
M:2TQ'8:;::;224I(B(@&<```````````````````````````````````````
M``````````````>9S+"L.V-BM]@NPL2QG.\(RJMD4V3X=F5#591BN1U$M/<E
M55]CUW%G5%Q6R4=CC$AEQI9=AI,!S,\P_P#Q[TTI6NP?;GS"%A_AI=GR^)6W
M[ZYL=4V?AH-Y^'IS:,I%]FFG[*8I*_+UEFF^QCQ5ML,-TL9*G4A0779ENKC!
MNS_)F4U&T.+?)/$D/S#PO*DN8KEC]<PZEJ9<X?=5DR;BFU,`D/(\-5K03KBC
MDEU;6Z:B6V0=`7$OWK8[Q5F%<LZ<HSI$S$9V_B%:I3#JNII\QF>'P4&N.?=Z
M&N54H4DS["A)+JL!OSE3[RVFM81IN,\>XT;=.<JC=U&2N'+A:QH9#J#4VM^:
M7E;7+I+'5*E1X'@15$KIYY+B%-D'-1R)Y8[<Y!9U1S-MYCEVR<YRJT?J-::N
MQ*EM\DN[:S?2IXL8U-J/#(-A:VT\HK1&XW6P'Y2VFC>E.*)*W0%H/#_V(>1>
M_DUN<<T,DNN*VII269D31FN;NDL^267P7#0\TUL/9%<N^PS2==+8^B_6X\JZ
MR(T.=EK326E-&'5#QUXP\?\`B3KB!J7C?J?#]18#!?5-<IL5KU-RKNX=99CR
MLDR_()SLW)<WRZR:CM^<N+B9.M)AH)3\AQ1=0&]P````````````````````
M`````````````````````````````````````!'CDMQ.XZ<P]>NZOY)ZEQ3:
MV)$^J?4HO8KT;(<1N?#\)O)<!S.HD5N8Z^RN.W]%JUI)\"P;09I2\25*(PY5
MN8GL9\G>.!VF<\2;B[Y?:6C&_+D:GRB91U/*?`JY!>,M&,9`[]@X-R!IX#27
M"1'D%C^5(90TV@[^8XI9A';B3[4W-_F?)@73V)W7#G12Y9(MMJ;\P:VK=R7\
M6.X13HFJN.>0IH\DA2'B/PF[K,SIH4=S]\Q76[2?#6'6!PI]M/B=P.K),C36
M#OW.TKVM:K<ZY!;+F-9IO'/6D*0ZN+<9I)AQ6Z#'%2&TN-T%!%I\<BN$2F(#
M2NIF$^0`````````````````````````````````````````````````````
M````````````````````````````````````````````````````````````
H``````````````````````````````````````````````````?_V0``

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
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End