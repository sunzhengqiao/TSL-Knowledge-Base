#Version 8
#BeginDescription
#Versions
Version 1.4 25.02.2025 HSB-23533 dialog for article definitions improved, invalid entries will be removed.
Version 1.3 14.08.2024 HSB-22529 major update to enable custom settings and tool detection
Version 1.2 10.04.2024 HSB-21860 panel is now supporting DataLink reference
Version 1.1 25.01.2024 HSB-21123 shopdrawing requests added
Version 1.0 15.01.2024 HSB-21120 initial version




#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 4
#KeyWords 
#BeginContents
//region <History>
// #Versions
// 1.4 25.02.2025 HSB-23533 dialog for article definitions improved, invalid entries will be removed. , Author Thorsten Huck
// 1.3 14.08.2024 HSB-22529 major update to enable custom settings and tool detection , Author Thorsten Huck
// 1.2 10.04.2024 HSB-21860 panel is now supporting DataLink reference , Author Thorsten Huck
// 1.1 25.01.2024 HSB-21123 shopdrawing requests added , Author Thorsten Huck
// 1.0 15.01.2024 HSB-21120 initial version , Author Thorsten Huck

/// <insert Lang=en>
/// Select entities
/// </insert>

// <summary Lang=en>
// This tsl creates 
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "WetGuard")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Revert Distribution|") (_TM "|Select Tool|"))) TSLCONTENT
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


//region Dialog config
	String kRowDefinitions = "MPROWDEFINITIONS";
	String kControlTypeKey = "ControlType";
	String kHorizontalAlignment = "HorizontalAlignment";
	String kLabelType = "Label";
	String kHeader = "Title";
	String kIntegerBox = "IntegerBox";
	String kTextBox = "TextBox";
	String kDoubleBox = "DoubleBox";
	String kComboBox = "ComboBox";
	String kCheckBox = "CheckBox";
	String kLeft = "Left", kRight = "Right", kCenter = "Center", kStretch = "Stretch";	

	String tToolTipColor = T("|Specifies the color of the override.|");
	String tToolTipTransparency = T("|Specifies the level of transparency of the shape of the tool.|");

//endregion	

	String kDataLink = "DataLink";
	
	
	String tDOCoverage = T("|Coverage|"), tDOOverlap = T("|Overlap|"), tDONone = T("|None|"), tDisplayOptions[] ={ tDOCoverage, tDOOverlap, tDONone };
	
//end Constants//endregion


//region DialogMode
	int nDialogMode = _Map.getInt("DialogMode");
	if (nDialogMode>0)
	{ 
		if (nDialogMode == 1) // specify index when triggered to get different dialogs
		{
			setOPMKey("Display Settings");	

		category = T("|Display|");
			String sModelName=T("|Model|");	
			PropString sModel(nStringIndex++, tDisplayOptions, sModelName);	
			sModel.setDescription(T("|Defines how the tape shall be displayed in model.|"));
			sModel.setCategory(category);
			
			String sShopdrawingName=T("|Shopdrawing|");	
			PropString sShopdrawing(nStringIndex++, tDisplayOptions, sShopdrawingName);	
			sShopdrawing.setDescription(T("|Defines how the tape shall be displayed in Shopdrawing.|"));
			sShopdrawing.setCategory(category);


		category = T("|Geometry|");
			String sOverlapName=T("|Overlap|");	
			PropDouble dOverlap(nDoubleIndex++, U(150), sOverlapName, _kLength);	
			dOverlap.setDescription(T("|Defines the overlap of two strips, may not be negative|"));
			dOverlap.setCategory(category);

			String sMinOpeningAreaName=T("|Minimal Opening Area|");	
			PropDouble dMinOpeningArea(nDoubleIndex++, U(0), sMinOpeningAreaName, _kArea);	
			dMinOpeningArea.setDescription(T("|Openings >= the given value will be subtracted from the coverage|"));
			dMinOpeningArea.setCategory(category);


		}			
		return;		
	}
//End DialogMode//endregion

//region Functions


//region Function GetEdgeCoordSys
	// returns the coordSys of a sip edge
	// edge: the relevant edge
	// vecN: the normal of the edge perp to vecFace
	CoordSys GetEdgeCoordSys(SipEdge edge, Vector3d& vecN, Vector3d vecFace)
	{ 
		PLine plEdge = edge.plEdge();
		Point3d ptOrg = edge.ptMid();
		Vector3d vecX = plEdge.getTangentAtPoint(ptOrg);
		Vector3d vecZ = edge.vecNormal();
		Vector3d vecY = vecX.crossProduct(-vecZ);
		CoordSys csOut(ptOrg, vecX, vecY, vecZ);
		
		vecN = vecZ.crossProduct(vecFace).crossProduct(-vecFace);	
		vecN.normalize();
		
		return csOut;
	}//endregion


//region Function AddHardware
	void AddHardware(PlaneProfile pp, HardWrComp& hwcs[], Map map)
	{ 
		double dScaleX= pp.dX();
		double dScaleY= map.getDouble("ScaleY");	
		String articleNumber = map.getString("articleNumber");
		if (dScaleX<dEps || dScaleY<dEps || articleNumber.length()<1 ){ return;}

		int color = map.getInt("color");
		int transparency = map.getInt("transparency");
		

		HardWrComp hwc(articleNumber,1); // the articleNumber and the quantity is mandatory
		hwc.setModel(map.getString("model"));
		hwc.setManufacturer(map.getString("manufacturer"));
		//hwc.setDescription(sHWDescription);
		//hwc.setMaterial(sHWMaterial);
		String notes = "ColorIndex;" + color+";Transparency;" + transparency;
		hwc.setNotes(notes);
		
		hwc.setGroup(map.getString("groupName"));
		hwc.setLinkedEntity(map.getEntity("ent"));	
		hwc.setCategory("Tape");
		hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
		
		hwc.setDScaleX(dScaleX);
		hwc.setDScaleY(dScaleY);
		hwc.setDScaleZ(0);
		
	// cumulate length with existing entry	
		int n=-1;
		for (int i=0;i<hwcs.length();i++) 
		{ 
			HardWrComp h= hwcs[i]; 
			if (h.articleNumber() != articleNumber)continue;
			n = i;
			break;
		}//next i
		if (n>-1)
			hwcs[n].setDScaleX(hwcs[n].dScaleX()+dScaleX);
		else
			hwcs.append(hwc);		
		
		return;
	}//endregion


//region Function UnionWithBridges
	// modifies the first argument and tries to union by bridges with the second argument
	void UnionWithBridges(PlaneProfile& ppMax,PlaneProfile pps[])
	{ 
		CoordSys cs = ppMax.coordSys();
		Plane pn(cs.ptOrg(), cs.vecZ());
		PlaneProfile ppBridges[0];
		for (int i=0;i<pps.length();i++) 
		{ 
			for (int j=i+1;j<pps.length();j++) 
			{ 
				PlaneProfile ppi= pps[i]; 
				PlaneProfile ppj= pps[j]; 
				
				ppi.shrink(-dEps);
				ppj.shrink(-dEps);
				
				if (ppi.intersectWith(ppj))
				{ 
					//ppi.vis(i);
					
					PlaneProfile ppai = ppi;
					ppai.intersectWith(pps[i]);
					//ppai.vis(i);
					
					PlaneProfile ppaj = ppi;
					ppaj.intersectWith(pps[j]);
					//ppaj.vis(j);				
					
					Point3d pts[0];
					pts.append(ppai.getGripVertexPoints());
					pts.append(ppaj.getGripVertexPoints());
					
					PLine hull;
					hull.createConvexHull(pn, pts);
					//hull.vis(j);
					
					PlaneProfile ppBridge(cs);
					ppBridge.joinRing(hull, _kAdd);
					ppMax.unionWith(ppBridge);
				}
			}//next j
	
		}//next i

		return;

	}//endregion


//region Function UnionTry
	// returns true or false if the unification was successful and modifies the first argument wit the resulting pp
	int UnionTry(PlaneProfile& ppUnion, PlaneProfile pp)
	{ 
		int out;
		
		PlaneProfile ppa = ppUnion;
		PlaneProfile ppb = pp;	
		ppb.shrink(-dEps);
		
		double areaUnion = ppUnion.area();
		if (areaUnion<pow(dEps,2))
		{ 
			ppUnion = pp;
			out= true;			
		}

		else if (ppb.intersectWith(ppa))
		{ 
			ppb = pp;
			ppa.shrink(-dEps);
			ppb.shrink(-dEps);
			ppa.unionWith(ppb);
			ppa.shrink(dEps);
		}
		else
		{
			ppb = pp;
			ppa.unionWith(ppb);
		}
		if (ppa.area()>pow(dEps,2) && ppa.area()>areaUnion)
		{ 
			ppUnion = ppa;
			out= true;				
		}	

		return out;
	}//endregion

	
//region Function ShowDialogEdit
	// returns
	Map ShowDialogEdit(Map mapIn)
	{ 
		Map rowDefinitions = mapIn.getMap(kRowDefinitions);
		int numRow = rowDefinitions.length() < 1 ? 1:rowDefinitions.length();
		double dHeight = numRow * 40 + 160;

		Map mapBlocks = mapIn.getMap("Blocks");
		Map mapEntityTypes = mapIn.getMap("EntityTypes");
		Map mapComponents = mapIn.getMap("Components");

	
	//region dialog config	
		Map mapDialog ;
		Map mapDialogConfig ;
		mapDialogConfig.setString("Title", T("|Article Selection|"));
		mapDialogConfig.setDouble("Height", dHeight);
		mapDialogConfig.setDouble("Width", 1100);
		mapDialogConfig.setDouble("MaxHeight",1200);
		mapDialogConfig.setDouble("MaxWidth", 2000);
		mapDialogConfig.setDouble("MinHeight", 100);
		mapDialogConfig.setDouble("MinWidth", 600);
		mapDialogConfig.setInt("AllowRowAdd", 1);	
		
	    mapDialogConfig.setString("Description",T("|The article properties are delineated within the drawing and will impact all subsequent instances once this command has been confirmed.|") + 
	    	T(" |Utilize the 'export settings' command in order to grant access to other users.|"));
	    mapDialog.setMap("mpDialogConfig", mapDialogConfig);			
	//endregion 		

	//region Columns
	    Map columnDefinitions,column ;
	    
	   	column.setString(kControlTypeKey, kTextBox);
	    column.setString(kHorizontalAlignment, kStretch);
	    column.setString(kHeader, T("|Articlenumber|"));
	    column.setString("ToolTip", T("|Specifies the article of this row.|")); 	
	    columnDefinitions.setMap("ArticleNumber", column);	    

	    column.setString(kControlTypeKey, kDoubleBox);
	    column.setString(kHorizontalAlignment, kStretch);
	    column.setString(kHeader, T("|Width|"));
    	column.setString("ToolTip", T("|Specifie the width of the tape, must be > 0|"));   
	    columnDefinitions.setMap("Width", column);	

	    column.setString(kControlTypeKey, kDoubleBox);
	    column.setString(kHorizontalAlignment, kStretch);
	    column.setString(kHeader, T("|Length|"));
    	column.setString("ToolTip", T("|Specifie the length of the tape, must be > 0|"));   
	    columnDefinitions.setMap("Length", column);	

	    column.setString(kControlTypeKey, kDoubleBox);
	    column.setString(kHorizontalAlignment, kStretch);
	    column.setString(kHeader, T("|Overlap|"));
    	column.setString("ToolTip", T("|Specifie the overlap of the tape|"));   
	    columnDefinitions.setMap("Overlap", column);	

	    column.setString(kControlTypeKey, kIntegerBox);
	    column.setString(kHorizontalAlignment, kStretch);
	    column.setString(kHeader, T("|Rolls|"));
	    column.setString("ToolTip", T("|Specifies the number of rolls, must be > 0|"));
	    columnDefinitions.setMap("Rolls", column);

	    column.setString(kControlTypeKey, kIntegerBox);
	    column.setString(kHorizontalAlignment, kStretch);
	    column.setString(kHeader, T("|Color|"));
	    column.setString("ToolTip", tToolTipColor);
	    columnDefinitions.setMap("Color", column);	

	    column.setString(kControlTypeKey, kIntegerBox);
	    column.setString(kHorizontalAlignment, kStretch);
	    column.setString(kHeader, T("|Transparency|"));
	    column.setString("ToolTip", tToolTipTransparency);
	    columnDefinitions.setMap("Transparency", column);

		mapDialog.setMap("mpColumnDefinitions", columnDefinitions);			
	//endregion 

	//region Default Rows	
		if (rowDefinitions.length()<1)
		{ 
			Map row;
	
			row.setString("ArticleNumber", "8220-039050");
			row.setDouble("Width", U(390));
			row.setDouble("Length", U(50000));
			row.setDouble("Overlap", U(150));
			row.setInt("Rolls", 64); 
			row.setInt("Color", 40);
			row.setInt("Transparency", 70);		
			rowDefinitions.setMap("row"+rowDefinitions.length(), row);	

			row.setString("ArticleNumber", "8220-078050");
			row.setDouble("Width", U(390));
			row.setDouble("Length", U(50000));
			row.setDouble("Overlap", U(150));
			row.setInt("Rolls", 32); 
			row.setInt("Color", 140);
			row.setInt("Transparency", 70);
			rowDefinitions.setMap("row"+rowDefinitions.length(), row);				
		}
		mapDialog.setMap(kRowDefinitions, rowDefinitions);		

		Map mapRet = callDotNetFunction2(sDialogLibrary, sClass, showDynamic, mapDialog);
		
		if (0 && mapRet.length()>0)
		{ 
			String sFileMap = _kPathPersonalTemp + "\\" + scriptName() + ".dxx";
			mapRet.writeToDxxFile(sFileMap);
			spawn_detach("",_kPathHsbInstall+"\\Utilities\\hsbMapExplorer\\hsbMapExplorer.exe", sFileMap,"");			
		}

		return mapRet;
	}//endregion






//region Function: CreatePainter
	// Creates a painter definition in a given collection if at least one object can be found in the database
	// sPainters: existing painters + new painter on success
	// type: the entity type
	// filter: the painter filter
	// format: the painter format
	// collectionName: the collectionName of the painter
	// name: the name of the painter definition	
		void CreatePainter(String& sPainters[], String type, String filter, String format, String collectionName, String name)
		{ 
			if (sPainters.findNoCase(name,-1)<0)
			{ 
				Entity ents[0];
				if (type.find("Beam",0,false)==0)
					ents= Group().collectEntities(true, Beam(), _kModelSpace);
				else if (type.find("Panel",0,false)==0)
					ents= Group().collectEntities(true, Sip(), _kModelSpace);
				else if (type.find("Sheet",0,false)==0)
					ents= Group().collectEntities(true, Sheet(), _kModelSpace);
				else 
					return;
					
				String painter = collectionName + name;
				PainterDefinition pd(painter);	
				if (!pd.bIsValid() && ents.length()>0)
				{ 
					pd.dbCreate();
					if (pd.bIsValid())
					{ 
						pd.setType(type);
						if (filter.length()>0)pd.setFilter(filter);
						if (format.length()>0)pd.setFormat(format);
					}
				}				
				if (sPainters.findNoCase(name,-1)<0 && pd.bIsValid())
					sPainters.append(name);		
			}			
		}//endregion
	
//region Function OrderPlaneProfiles
	// returns an ordered list of profiles
	// vecDir: the direction to order
	void OrderPlaneProfiles(PlaneProfile& pps[], Vector3d vecDir)
	{ 
		for (int i=0;i<pps.length();i++) 
			for (int j=0;j<pps.length()-1;j++) 
			{
				double da = vecDir.isParallelTo(pps[j].coordSys().vecX()) ? pps[j].dX() : pps[j].dY();
				double db = vecDir.isParallelTo(pps[j+1].coordSys().vecX()) ? pps[j+1].dX() : pps[j+1].dY();
				
				Point3d pta = pps[j].ptMid() - vecDir * .5 * da;
				Point3d ptb = pps[j+1].ptMid() - vecDir * .5 * db;
				
				if (vecDir.dotProduct(_Pt0-pta)>vecDir.dotProduct(_Pt0-ptb))
					pps.swap(j, j + 1);
			}	
		return;
	}//End OrderPlaneProfiles //endregion

//region Function CollectSubmapNames
	// returns a new submap with all appended entries and appends unique named submaps as entries
	Map CollectNamedSubmaps(String& entries[], Map map)
	{ 
		Map mapOut;
		for (int i=0;i<map.length();i++) 
		{ 
			Map m = map.getMap(i);
			String name = m.getMapName();
			
			if (name.length()>0 && entries.findNoCase(name,-1)<0)
			{ 
				mapOut.appendMap(m.getMapKey(), m);
				entries.append(name);
			}			 
		}//next i			
		return mapOut;
	}//endregion

//region Function GetNamedSubmap
	// returns the submap with the requested name
	Map GetNamedSubmap(String entry, Map mapIn)
	{ 
		Map mapOut;
		entry.makeUpper();
		for (int i=0;i<mapIn.length();i++) 
		{ 
			Map m = mapIn.getMap(i);
			String name = m.getMapName().makeUpper();
			
			if (name.length()>0 && entry==name)
			{ 
				mapOut = m;
				break;
			}			 
		}//next i			
		return mapOut;		
	}//endregion

//region Function GetFirstOrDefaultMap
	Map GetFirstOrDefaultMap(String entries[], String& entry, String key, Map mapIn)
	{ 
		Map mapOut;
		if (entries.length()>0)
		{ 
			entry = _Map.getString(key);
			
		// default entry not found or invalid	
			if (entries.findNoCase(entry,-1)<0)
			{
				entry = entries.first();
				_Map.setString(key, entry);
			}
			Map mapSub = GetNamedSubmap(entry, mapIn);
			mapOut = mapSub;
		}
		return mapOut;	
	}//endregion

//region Function WriteSelectedArticles
	// returns
	Map WriteSelectedArticles(Map mapIn)
	{ 
		Map mapOut;
		
		for (int i=0;i<mapIn.length();i++) 
		{ 
			Map m = mapIn.getMap(i);
			String article = m.getMapKey(); 
			
			Map mapArticle;
			mapArticle.setMapName(article);
			
			int n; //avoid translation issues by referring to the sequence
			mapArticle.setInt("isActive",m.getInt(n++));
			mapArticle.setDouble("width",m.getDouble(n++));
			mapArticle.setDouble("length",m.getDouble(n++));			
			mapArticle.setInt("Rolls",m.getInt(n++));
			mapArticle.setInt("Color",m.getInt(n++));
			mapArticle.setInt("Transparency",m.getInt(n++));

			mapOut.appendMap("Article", mapArticle);
		}//next i
		return mapOut;
	}//endregion

//region Function GetExtremes
	// returns the extreme points
	// t: the tslInstance to 
	Point3d [] GetExtremes(Line ln, PlaneProfile pp, int bProject2Line)
	{ 
		LineSeg seg = pp.extentInDir(ln.vecX());
		Point3d pts[] = { seg.ptStart(), seg.ptEnd()};
		if (bProject2Line)
			pts = ln.projectPoints(pts);
		pts = ln.orderPoints(pts, dEps);
		
		if (bDebug)
			for (int i=0;i<pts.length();i++) 
				pts[i].vis(i); 
		
		return pts;
	}//endregion

//endregion 

//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sPathGeneral = _kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\";	
	String sFileName ="WetGuard";
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
	
//region Read Settings







//region Collect articles
	String model = "Wetguard ® 200 SA";
	String manufacturer = "Siga";
	double dWidths[0];// = { U(390), U(780), U(1560)};
	String sArticles[0];// = { "8220-039050", "8220-078050", "8220-156050"};
	int nRolls[0];// = { 64, 32, 16}; // rolls per palette
	int colors[0];// ={40,140,210};
	double dLength = U(50000);
	double dOverlap = U(150);
	double dLengths[0];
	int transparencies[0];
	

	
	
// Get Manufacturer	
	String sManufacturers[0], sManufacturer;
	Map mapManufacturers = CollectNamedSubmaps(sManufacturers, mapSetting.getMap("Manufacturer[]"));
	Map mapManufacturer = GetFirstOrDefaultMap(sManufacturers, sManufacturer, "manufacturer", mapManufacturers);

	
//Get Family	
	String sFamily, sFamilies[0];
	Map mapFamily, mapFamilies;
	if (sManufacturer.length()>0)
	{ 
		mapFamilies = CollectNamedSubmaps(sFamilies, mapManufacturer.getMap("Family[]"));
		mapFamily = GetFirstOrDefaultMap(sFamilies, sFamily, "family", mapFamilies);
	}

// Get Articles
	Map mapArticles = CollectNamedSubmaps(sArticles, mapFamily.getMap("Article[]"));







	{ 
		Map debugTest = _Map.getMap("debugTest");
		Map test2 = WriteSelectedArticles(debugTest);
	}

//region Append Default Articles
	if (mapArticles.length()<1)
	{ 
		sFamily = "Wetguard ® 200 SA";
		sManufacturer = "Siga";
		
		double widths[] = { U(390), U(780), U(1560)};
		String articles[] = { "8220-039050", "8220-078050", "8220-156050"};
		int rolls[] = { 64, 32, 16}; // rolls per palette
		int _colors[] ={40,140,210};

		for (int i=0;i<articles.length();i++) 
		{ 
			sArticles.append(articles[i]);
			
			Map m;
			m.setMapName(articles[i]);
			m.setDouble("width", widths[i]);
			m.setDouble("length", U(50000));
			m.setDouble("overlap", U(150));
			
			m.setInt("rolls", rolls[i]);
			m.setInt("color", _colors[i]);
			m.setInt("transparency", 70);
 
			mapArticles.appendMap("Article", m);
		}//next i
		
		mapFamily.setMapName(sFamily);
		mapFamily.setMap("Article[]", mapArticles);
		mapFamilies.appendMap("Family", mapFamily);
		
		mapManufacturer.setMapName(sManufacturer);
		mapManufacturer.setMap("Family[]", mapFamilies);
		mapManufacturers.appendMap("Manufacturer", mapManufacturer);
		
		mapSetting.setMap("Manufacturer[]", mapManufacturers);
		
		
		
	}//endregion 

//region Read Articles
	for (int i=0;i<mapArticles.length();i++) 
	{ 
		Map m= mapArticles.getMap(i);
		double width = m.getDouble("width");
		double length = m.getDouble("length");
		double overlap = m.getDouble("overlap");
		int numRoll = m.getInt("rolls");
		int color = m.getInt("color");
		int transparency = m.getInt("transparency");

		dWidths.append(width);
		dLengths.append(length);
		
		nRolls.append(numRoll);
		colors.append(color);
		transparencies.append(transparency);		
	}//next i	
//endregion 


	
//endregion 
	int bShowCoverage=true, bShowOverlap=true;
	String sModelDisplay = tDONone, sShopdrawDisplay = tDOCoverage;
	double dMinOpeningArea;
{
	String k;
	Map m = mapSetting.getMap("Display");
//	k="StringEntry";		if (m.hasString(k))	sStringEntry = m.getString(k);
	k="Model";				if (m.hasString(k))	sModelDisplay = m.getString(k);
	k="Shopdraw";			if (m.hasString(k))	sShopdrawDisplay = m.getString(k);
	k="Overlap";			if (m.hasDouble(k))	dOverlap = m.getDouble(k);
	k="MinOpeningArea";		if (m.hasDouble(k))	dMinOpeningArea = m.getDouble(k);
	
}
//End Read Settings//endregion 
	
	
	
//End Settings//endregion	





//region PreRequisites Painters and Dimstyles

	//region Painters

	String tDisabledEntry = T("<|Disabled|>");
	String tBySelection = T("<|bySelection|>");
	String tPDFloor= T("|Floor|"), tPDRoof = T("|Roof|"), tPDFloorRoof = T("|Floor & Roof |");
	
// Get or create default painter definition
	String sPainterCollection = "TSL\\WetGuard\\";
	String sPainters[0],sAllPainters[] = PainterDefinition().getAllEntryNames().sorted();
	for (int i=0;i<sAllPainters.length();i++) 
	{ 
		if (sPainterCollection.length()<1 || sAllPainters[i].find(sPainterCollection,0,false)==0)
		{
			PainterDefinition pd(sAllPainters[i]);
			if (!pd.bIsValid()){continue;}
			
		// add painter name	
			String name = sAllPainters[i];
			name = name.right(name.length() - sPainterCollection.length());
			if (sPainters.findNoCase(name,-1)<0)// && name!=tSelectionPainter)
				sPainters.append(name);
		}		 
	}//next i
	
// Create Default Painters	
	if (_bOnInsert || _bOnRecalc)
	{ 
		String types[] ={"Panel","Panel","Panel"};
		String names[] ={tPDFloor,tPDRoof,tPDFloorRoof};
		String formats[] ={"@(PosNum:PL5;0)","@(PosNum:PL5;0)","@(PosNum:PL5;0)"};
		String filters[] ={"isParallelWorldZ = 'true'", "isPerpendicularWorldZ = 'false' or isParallelWorldZ = 'true'", "isParallelWorldZ = 'false'"};
		
		for (int i=0;i<types.length();i++) 
			CreatePainter(sPainters, types[i], filters[i], formats[i], sPainterCollection, names[i]);	
	}

	sPainters.sorted();	
	sPainters.insertAt(0, tBySelection);
	sPainters.insertAt(0, tDisabledEntry);
	//END Painters //endregion

	//region DimStyles
	// Find DimStyle Overrides, order and add Linear only
	String sDimStyles[0], sSourceDimStyles[0];
	{ 
	// append potential linear overrides	
		String sOverrides[0];
		for (int i=0;i<_DimStyles.length();i++) 
		{ 
			String dimStyle = _DimStyles[i]; 
			int n = dimStyle.find("$0", 0, false);	// indicating it is a linear override of the dimstyle
			if (n>-1 && sSourceDimStyles.find(dimStyle,-1)<0)
			{
				sDimStyles.append(dimStyle.left(n));
				sSourceDimStyles.append(dimStyle);
			}
		}//next i
		
	// append all non overrides	
		for (int i = 0; i < _DimStyles.length(); i++)
		{
			String dimStyle = _DimStyles[i]; 
			int nx = dimStyle.find("$", 0, false);	// <0 it is not any override of the dimstyle
			if (nx<0 && sDimStyles.findNoCase(dimStyle)<0)
			{ 
				sDimStyles.append(dimStyle);
				sSourceDimStyles.append(dimStyle);				
			}
		}

	// order alphabetically
		for (int i=0;i<sDimStyles.length();i++) 
			for (int j=0;j<sDimStyles.length()-1;j++) 
				if (sDimStyles[j]>sDimStyles[j+1])
				{
					sDimStyles.swap(j, j + 1);
					sSourceDimStyles.swap(j, j + 1);
				}
	}//endregion
		
//PreRequisites //endregion 

//region Properties


category = T("|Filter|");
	String sPainterName=T("|Filter|");	
	PropString sPainter(nStringIndex++, sPainters, sPainterName,2);	
	sPainter.setDescription(T("|Defines the painter definition which will be used to filter items|"));
	sPainter.setCategory(category);
	sPainter.setReadOnly(_bOnInsert || bDebug ? false : _kHidden);



category = T("|Display|");
	String sDimStyleName=T("|Dimstyle|");	
	PropString sDimStyle(nStringIndex++, sDimStyles, sDimStyleName);	
	sDimStyle.setDescription(T("|Defines the Dimstyle|"));
	sDimStyle.setCategory(category);
	String dimStyle = sSourceDimStyles[sDimStyles.find(sDimStyle,0)];
	if (_DimStyles.findNoCase(dimStyle ,- 1) < 0)dimStyle = _DimStyles.first();

	String sTextHeightName=T("|Text Height|");	
	PropDouble dTextHeight(nDoubleIndex++, U(100), sTextHeightName,_kLength);	
	dTextHeight.setDescription(T("|Defines the text height|") + T(", |0 = byDimstyle|"));
	dTextHeight.setCategory(category);	
	
	
//End Properties//endregion 



//region OnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
	// silent/dialog
		if (_kExecuteKey.length()>0 && TslInst().getListOfCatalogNames(scriptName()).findNoCase(_kExecuteKey,-1)>-1)
			setPropValuesFromCatalog(_kExecuteKey);						
	// standard dialog	
		else	
			showDialog();
		
	
	
	// prompt for sips
		Entity ents[0];
		PrEntity ssE(T("|Select panels|"), Sip());
		if (ssE.go())
			ents.append(ssE.set());
		
		
		PainterDefinition pd(sPainterCollection+sPainter);
		if (pd.bIsValid())
			ents= pd.filterAcceptedEntities(ents);
		
	
	
	// create TSL
		TslInst tslNew;
		Entity entsTsl[] = {};					
		int nProps[]={};			double dProps[]={dTextHeight};				String sProps[]={sPainter,sDimStyle};
		Map mapTsl;	
					
						
		for (int i=0;i<ents.length();i++) 
		{ 
			Sip sip = (Sip)ents[i];
			GenBeam gbsTsl[] = {sip};			
			Point3d ptsTsl[] = {sip.ptCen()};
			tslNew.dbCreate(scriptName() , sip.vecX() ,sip.vecY(),gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);			 
		}//next i
		
		eraseInstance();
		return;
	}			
//endregion 



//region Panel standards
	if (_Sip.length()<1)
	{
		reportMessage("\n" + scriptName() + ": " +T("|Invalid reference.|") + " " + T("|Tool will be deleted|"));
		eraseInstance();
		return;
	}

	Sip sip = _Sip[0];
	Vector3d vecX = sip.vecX();
	Vector3d vecY = sip.vecY();
	Vector3d vecZ = sip.vecZ();
	Point3d ptCen = sip.ptCenSolid();
	double dH = sip.dH();
	vecX.vis(ptCen,1);vecY.vis(ptCen,3);vecZ.vis(ptCen,150);
	
	assignToGroups(sip, 'T');
	_ThisInst.setDrawOrderToFront(false);
	
	PLine plOpenings[] = sip.plOpenings();
	PLine plEnvelope = sip.plEnvelope();
	Body bd = sip.envelopeBody(true, false);
	Body bdReal = sip.realBodyTry();
	if (bdReal.isNull())bdReal = bd;
	
	SipEdge edges[] = sip.sipEdges();
	SipStyle style(sip.style());
	
	int bFlip = _Map.getInt("flip");
	Vector3d vecDir = (bFlip ?- 1 : 1) * vecY;
	Line lnX(_Pt0, vecX);
	Line lnY(_Pt0, vecDir);
	if (bDebug)
	{ 
		Display dp(1); dp.draw(scriptName(), _Pt0, _XW, _YW, 0, 0);
	}	
//End Panel standards//endregion 

//region Grip Management #GM
	addRecalcTrigger(_kGripPointDrag, "_Grip");
	Point3d ptLoc = _Pt0;
	int indexOfMovedGrip = Grip().indexOfMovedGrip(_Grip);	
	int bDragLoc, bDrag = _bOnGripPointDrag && indexOfMovedGrip >- 1 && _kExecuteKey=="_Grip";
	int bOnDragEnd = !_bOnGripPointDrag && indexOfMovedGrip >- 1;
	Grip grip;
	Vector3d vecApplied;
	int nGripLoc = -1;	
	
	if (_Grip.length()>0)
		ptLoc = _Grip[0].ptLoc();		
//endregion 

	double textHeight = dTextHeight;
	Display dp(4);
	dp.dimStyle(dimStyle);
	if (dTextHeight<0)
		textHeight = dp.textHeightForStyle("O", dimStyle);
	dp.textHeight(textHeight);


//region Draw SHapes during Dragging
	if (bDrag)
	{
		dp.trueColor(darkyellow);
		Map mapShapes=_Map.getMap("Shapes");
		for (int i=0;i<mapShapes.length();i++) 
		{ 
			PlaneProfile pp = mapShapes.getPlaneProfile(i);
			dp.draw(pp,_kDrawFilled, 70);
			 
		}//next i
		return;
	}
//endregion 




//region Get Face
	Vector3d vecFace = vecZ;
	if (!vecFace.isPerpendicularTo(_ZW) && vecFace.dotProduct(_ZW)<0)
		vecFace *= -1;
	
	Point3d ptFace = ptCen + .5 * vecFace * dH;
	Plane pnFace(ptFace, vecFace);
	CoordSys csFace(ptFace, vecX, vecX.crossProduct(-vecFace), vecFace);
	PlaneProfile ppFace(csFace);
	ppFace.unionWith(bd.extractContactFaceInPlane(pnFace, dEps));

	Point3d ptExtents[] = GetExtremes(lnX, ppFace, false);
//endregion 

//region Openings and tag edges to be rejected
	PlaneProfile ppOpening(csFace);
	int bRejectedEdges[edges.length()];
	for (int i=0;i<plOpenings.length();i++) 
	{ 
		double area =plOpenings[i].area();
		if (dMinOpeningArea<=0 || area>=dMinOpeningArea)
		{
			ppOpening.joinRing(plOpenings[i],_kAdd);
		}
			
		else if (dMinOpeningArea>0 && area<dMinOpeningArea)
		{
			for (int j=edges.length()-1; j>=0 ; j--) 
			{ 
				int nRing = sip.findClosestRingIndex(edges[j].ptMid());
				if (nRing == i)
				{ 
					bRejectedEdges[j] = true;
					//edges[j].plEdge().vis(1);
				}
				
			}//next j
		}
			
			
	}//next i

	
	//{ Display dpx(150); dpx.draw(ppOpening, _kDrawFilled, 60);}
//endregion 





	
//region Find Relevant Lap Joints at edge
	AnalysedTool tools[] = sip.analysedTools();
	
	String sAbcSubTypes[] ={ _kABCRabbet,_kABCSimpleHousing};
	AnalysedBeamCut abcs[0];
	for (int i=0;i<sAbcSubTypes.length();i++) 
		abcs.append(AnalysedBeamCut().filterToolsOfToolType(tools,sAbcSubTypes[i]));

	String sAfpSubTypes[] ={ _kAFPPerpendicular};
	AnalysedFreeProfile afps[0];
	for (int i=0;i<sAfpSubTypes.length();i++) 
		afps.append(AnalysedFreeProfile().filterToolsOfToolType(tools,sAfpSubTypes[i]));

// Collect tool quaders

//region AnalysedBeamcuts
	Quader qdrs[0];
	for (int i=0;i<abcs.length();i++) 
	{ 
		AnalysedBeamCut t =abcs[i]; 
		Quader q = t.quader();		
		int bOnFace = t.bIsFreeD(vecFace);
		if (!bOnFace){ continue;}

		Point3d ptOrg = q.ptOrg();
		int ind = sip.findClosestEdgeIndex(ptOrg);
		int nRing = sip.findClosestRingIndex(ptOrg);
		if (ind >- 1)
		{
			SipEdge e = edges[ind];
			Vector3d vecZN;
			CoordSys cs = GetEdgeCoordSys(e, vecZN, vecZ);
			if (nRing>-1 && !bRejectedEdges[ind] && ppOpening.pointInProfile(ptOrg+vecZN*(.5*q.dD(vecZN)+dEps))!=_kPointOutsideProfile)
			{ 
				qdrs.append(q);
				//if(bDebug)q.vis(150);
			}
			else if (t.bIsFreeD(vecZN))
			{ 
				qdrs.append(q);
				//if(bDebug)q.vis(3);
			}
//			else if(bDebug)
//			{ 
//				q.vis(1);
//			}
		}
	}//next i	//endregion 			
	
//region AnalysedFreeProfile	
	for (int i=0;i<afps.length();i++) 
	{ 
		AnalysedFreeProfile t =afps[i]; 
		
		double dY = t.millDiameter();
		double dZ = t.dDepth();
		Vector3d vecSide = t.vecSide();		
		int bOnFace = vecSide.isCodirectionalTo(vecFace);
		if (!bOnFace){ continue;}

		PLine plDefining = t.plDefining();
		plDefining.simplify();
		plDefining.convertToLineApprox(dEps);
		//plDefining.vis(4);
		
		if (!plDefining.isClosed())
		{ 
			Point3d pts[] = plDefining.vertexPoints(!plDefining.isClosed());
			for (int p=0;p<pts.length()-1;p++) 
			{ 
				Point3d pt1 = pts[p];
				Point3d pt2 = pts[p+1];
				Vector3d vecXS = pt2 - pt1;
				vecXS.normalize();
				
			// add overshoot value to avoid chunks on non perp edges	
				pt1 -= vecXS * dH;				
				if (p<pts.length()-2)
					pt2 += vecXS * dH;
					
				Point3d ptm = (pt1 + pt2) * .5;
				
				vecXS = pt2 - pt1;
				double dX = vecXS.length();
				vecXS.normalize();
				
				Vector3d vecYS = vecXS.crossProduct(-vecSide);			
				Vector3d vecZS = vecXS.crossProduct(vecYS);
	//			vecXS.vis(ptm, 1);
	//			vecYS.vis(ptm, 3);
	//			vecZS.vis(ptm, 150);
				Quader qdr(ptm, vecXS, vecYS, vecZS, dX, dY, dZ, 0, 0, 1);
				//qdr.vis(4);
	
				qdrs.append(qdr);
				
				
				
			}//next p			
		}
	// single extrusion segments //TODO needs verification	
		else
		{ 
			Point3d ptm; 
			ptm.setToAverage(plDefining.vertexPoints(true));
			ptm.vis(1);
			int ind = sip.findClosestEdgeIndex(ptm);
			
			if (ind>-1)
			{ 
				SipEdge e = edges[ind];
				Vector3d vecZN;
				CoordSys cs = GetEdgeCoordSys(e, vecZN, vecZ);

				CoordSys csN(ptm, cs.vecX(), cs.vecX().crossProduct(-vecSide), vecSide);
				//csN.vis(2);
				PlaneProfile pp(csN);
				pp.joinRing(plDefining,_kAdd);
				
				Quader qdr(ptm, csN.vecX(), csN.vecY(), csN.vecZ(), pp.dX(), pp.dY(), dZ, 0, 0, 1);
				qdrs.append(qdr);
				
				
			}
			
			
		}
	}//next i	//endregion 


//region Collect edge planes and profiles
	PlaneProfile ppEdges[0];
	for (int i=0;i<edges.length();i++) 
	{ 
		SipEdge e = edges[i];
		if (bRejectedEdges[i])
		{ 
			continue;
		}
		
		Vector3d vecZN;
		CoordSys cs = GetEdgeCoordSys(e, vecZN, vecZ);
		Vector3d vecZE = e.vecNormal();
		//vecZN.vis(cs.ptOrg(), 3);
		
		int bIsBeveled = ! vecZE.isPerpendicularTo(vecZ);
		
		Plane pn(cs.ptOrg(), vecZE);
		PlaneProfile pp(cs);
		pp.unionWith(bd.extractContactFaceInPlane(pn, dEps));
		//if(bDebug){ Display dpx(150); dpx.draw(pp, _kDrawFilled, 60);}
		
		
	// subtract and re-add potential edge tools like beamcuts or freeprofiles
		for (int j=qdrs.length()-1; j>=0 ; j--) 
		{ 
			Quader& q= qdrs[j]; 
			if (!q.vecD(vecZN).isParallelTo(vecZN))
			{
				continue;
			}
			Point3d ptOrg = q.ptOrg();	
			int ind = sip.findClosestEdgeIndex(ptOrg);
			if (ind != i)
			{
				continue;
			}
			//q.vecD(vecZN).vis(ptOrg, 2);
			
			Body bdq(q.ptOrg(), q.vecX(), q.vecY(), q.vecZ(), q.dX(), q.dY(), q.dZ(), 0, 0, 0);
			//bdq.vis(2);
			
		// subtract beveled	
			if (bIsBeveled)
			{ 
				PlaneProfile ppx(cs);
				ppx.unionWith(bdq.getSlice(pn));
				Vector3d vec = cs.vecX() * .5*ppx.dX() + cs.vecY() * U(10e3);
				ppx.createRectangle(LineSeg(ppx.ptMid() - vec, ppx.ptMid() + vec), cs.vecX(), cs.vecY());
				//{ Display dpx(1); dpx.draw(ppx, _kDrawFilled, 60);}
				pp.subtractProfile(ppx);
			}
		// subtract perpendicular	
			else
			{ 
				PlaneProfile ppx(cs);
				
				ppx.unionWith(bdq.extractContactFaceInPlane(pn, dEps));
				if (ppx.area()<pow(dEps,2))
					ppx.unionWith(bdReal.extractContactFaceInPlane(pn, dEps));	
				Vector3d vec = cs.vecX() * .5*ppx.dX() + cs.vecY() * U(10e3);
				ppx.createRectangle(LineSeg(ppx.ptMid() - vec, ppx.ptMid() + vec), cs.vecX(), cs.vecY());
				//{ Display dpx(12); dpx.draw(ppx, _kDrawFilled, 60);}
				pp.subtractProfile(ppx);
				
				
				
			}			
			
		// Collect relevamt tool edge profile
			Point3d ptEdge = q.ptOrg() - vecZN * .5 * q.dD(vecZN);	
			Plane pnEdge(ptEdge, vecZN);													//pnEdge.vis(4);
			CoordSys csEdge(ptEdge, cs.vecX(), cs.vecX().crossProduct(-vecZN),vecZN );		//csEdge.vis(4);
			PlaneProfile ppEdge(csEdge);
			ppEdge.unionWith(bdReal.extractContactFaceInPlane(pnEdge, dEps));
					
			if (ppEdge.area()>pow(dEps,2))
			{
				ppEdges.append(ppEdge);
				//{ Display dpx(3); dpx.draw(ppEdge, _kDrawFilled, 30);}
			}
			qdrs.removeAt(j);
		}//next j
		
		if (pp.area()>pow(dEps,2))
		{
			ppEdges.append(pp);	
			//{ Display dpx(40); dpx.draw(pp, _kDrawFilled, 40);}
		}

	}//next i
//endregion 	

//region Get transformed edges in face and append to net profile
	PlaneProfile ppAllEdges[0]; CoordSys cs2Edges[0];
	for (int i=0;i<ppEdges.length();i++) 
	{ 
		PlaneProfile& ppEdge = ppEdges[i];
		
//	// ignore very small chunks
//		if (ppEdge.area()<ppEdge.dY()*U(25))
//		{ 
//			continue;
//		}

		CoordSys cse = ppEdge.coordSys();		//cse.vis(4);
		Point3d ptOrg=cse.ptOrg();
		Vector3d vecX1 = cse.vecX();
		Vector3d vecY1 = cse.vecY();
		Vector3d vecZ1 = cse.vecZ();
		
		Vector3d vecX2 = cse.vecX();
		Vector3d vecY2 = vecX2.crossProduct(-vecFace);
		Vector3d vecZ2 = vecFace;

		if (!Line(ptOrg, vecFace).hasIntersection(pnFace, ptOrg)){ continue;}

		PlaneProfile ppEdgeFace = ppEdge;
		CoordSys cs2Face;
		cs2Face.setToAlignCoordSys(ptOrg, vecX1, vecY1, vecZ1, ptOrg, vecX2, vecY2, vecZ2 );
		ppEdgeFace.transformBy(cs2Face);
		
		if (ppEdgeFace.area()>pow(dEps,2))
		{ 
			ppFace.subtractProfile(ppEdgeFace);			
			ppAllEdges.append(ppEdgeFace);	
			
			CoordSys cs2Edge = cs2Face;
			cs2Edge.invert();
			cs2Edges.append(cs2Edge);
		}

		
//		if(!UnionTry(ppAllEdge, ppEdgeFace))
//		{ 
//			{ Display dpx(40); dpx.draw(ppEdgeFace, _kDrawFilled, 40);}
//			PlaneProfile pps[] = {ppAllEdge, ppEdgeFace};
//			PlaneProfile ppBridge = ppAllEdge;
//			UnionWithBridges(ppBridge, pps);
//			//ppAllEdge.unionWith(ppEdgeFace);
//			{ Display dpx(3); dpx.draw(ppBridge, _kDrawFilled, 20);} 	
//		}
		//
		
//		{ Display dpx(4); dpx.draw(ppEdge, _kDrawFilled, 30);}//, _kDrawFilled, 30 
//		{ Display dpx(40); dpx.draw(ppEdgeFace, _kDrawFilled, 40);} 			
 
	}//next i
	
//endregion 



//endregion 	

	
	//{ Display dpx(4); dpx.draw(ppNet, _kDrawFilled, 80);}

	PlaneProfile ppNet = ppFace;
	for (int i=0;i<ppAllEdges.length();i++) 
	{ 
		ppNet.unionWith(ppAllEdges[i]); 
	}//next i
	
	
	PlaneProfile ppBox; ppBox.createRectangle(ppNet.extentInDir(vecX), vecX, vecY);	ppBox.vis(2);


//	dp.draw(ppFace, _kDrawFilled, 90);
//	dp.draw(ppNet);

	int nt = 85;
	Map mapRequests,mapRequest;
	mapRequest.setString("Stereotype", scriptName());
	mapRequest.setString("ParentUID", sip.handle());
	mapRequest.setString("dimStyle", dimStyle);
	mapRequest.setDouble("textHeight", textHeight);	
	//mapRequest.setVector3d("AllowedView", vecZ);
	mapRequest.setInt("AlsoReverseDirection", true);
	
	mapRequest.setVector3d("vecX", vecX);
	mapRequest.setVector3d("vecY", vecY);
	mapRequest.setDouble("dXFlag", 1);
	mapRequest.setDouble("dYFlag", 0);
	mapRequest.setInt("deviceMode", _kDevice);
	
	
	





//region Hardware
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
		if (elHW.bIsValid()) 	
			sHWGroupName=elHW.elementGroup().name();
	// loose
		else
		{
			Group groups[] = _ThisInst.groups();
			if (groups.length()>0)	sHWGroupName=groups[0].name();
		}		
	}		
//endregion 




//region Distribute
	PlaneProfile pps[0];	int nPPColors[0], nPPTransparencies[0];

	PlaneProfile ppShapes[0];//pp1(csFace), pp2(csFace), pp3(csFace);
	double dL = ppNet.dX();
	
	
	Point3d ptStart = ppNet.ptMid() - vecDir * .5 * ppNet.dY(), pt1 = ptStart;		//ptStart.vis(2);
	Point3d ptEnd = ppNet.ptMid() + vecDir * .5 * ppNet.dY();						//ptEnd.vis(2);
	
	int cntMax = ppNet.dY()/dWidths[0], cnt;
	double area;
	
	int n = dWidths.length()-1;
	while ((vecDir.dotProduct(ptEnd-pt1))>0  && cntMax>cnt)
	{ 
		
		
		double range = vecDir.dotProduct(ptEnd - pt1) + dH;		
		double d = range / dWidths[n];
		while (d<.5 && n>0)
		{ 
			n--;
			d = range / dWidths[n];			
		}
		double width = dWidths[n];
		int color =  colors[n];
		int transparency=  transparencies[n];
		String  articleNumber=  sArticles[n];
		dp.color(color);
		
		Point3d pt2 = pt1 + vecDir * dWidths[n];

	// get row profile	
		PlaneProfile ppr;
		ppr.createRectangle(LineSeg(pt1 - vecX * .5 * dL, pt1 + vecX * .5 * dL + vecDir * dWidths[n]), vecX, vecY);
		ppr.intersectWith(ppNet);
		
		ppShapes.append(ppr);
		nPPColors.append(color);
		nPPTransparencies.append(transparency);
		
		
		area += ppr.area();
		
		Map mapHwc;
		mapHwc.setEntity("ent", sip);
		mapHwc.setString("articleNumber",articleNumber);
		mapHwc.setString("groupName",sHWGroupName);
		mapHwc.setString("manufacturer","Siga");
		mapHwc.setInt("transparency", transparency);
		mapHwc.setInt("Color", color);
		mapHwc.setDouble("ScaleY", width);

		AddHardware(ppr, hwcs, mapHwc);
		
		
		//{ Display dpx(2); dpx.draw(ppr, _kDrawFilled, 90);}
		
	// Collect strips on main face	
		PlaneProfile ppA = ppr;
		ppA.intersectWith(ppFace);
		//{ Display dpx(4); dpx.draw(ppA, _kDrawFilled, 50);}
		
		if (bDrag)
		{
			dp.trueColor(darkyellow);
			dp.draw(ppr, _kDrawFilled,transparency-5);
			dp.draw(ppr);
		}		
		else if (sModelDisplay==tDOCoverage)
		{
			dp.draw(ppA, _kDrawFilled,transparency);
			dp.draw(ppA);
		}			
		
		if (sShopdrawDisplay==tDOCoverage)
		{ 
			mapRequest.setInt("Transparency", transparency);
			mapRequest.setInt("Color", color);
			mapRequest.setInt("DrawFilled", _kDrawFilled);
			mapRequest.setPlaneProfile("PlaneProfile", ppA);
			mapRequest.setVector3d("AllowedView", vecFace);
			mapRequests.appendMap("DimRequest", mapRequest);					
		}




	// Collect profiles on main face intersecting the projected edges
		if(!bDrag)
		for (int i=0;i<ppAllEdges.length();i++) 
		{ 
			PlaneProfile ppEdge = ppAllEdges[i]; 
			ppEdge.intersectWith(ppr);
			ppEdge.transformBy(cs2Edges[i]);
			//{ Display dpx(6); dpx.draw(ppEdge, _kDrawFilled, 50);}
			
			if (sModelDisplay==tDOCoverage)
			{
				dp.draw(ppEdge, _kDrawFilled,transparency);
				dp.draw(ppEdge);
			}			
			
			if (sShopdrawDisplay==tDOCoverage)
			{ 
				mapRequest.setInt("Transparency", transparency);
				mapRequest.setInt("Color", color);
				mapRequest.setInt("DrawFilled", _kDrawFilled);
				mapRequest.setPlaneProfile("PlaneProfile", ppEdge);
				mapRequest.removeAt("AllowedView", true);
				mapRequests.appendMap("DimRequest", mapRequest);					
			}			
			
			
		}//next i

		if (ppBox.pointInProfile(pt2)!=_kPointInProfile)
		{ 
			break;
		}
		//pt1.vis(n);
		pt1 += vecDir * (dWidths[n]-dOverlap);
		
		cnt++;
	}
	if (bDrag)
	{
		return;
	}
//endregion 

//region Count rows
	Point3d pts3[0];
	for (int i=0;i<pps.length();i++) 
	{ 
		PlaneProfile pp=pps[i];
		Point3d pt = pp.ptMid() + vecX * .5 * pp.dX() + vecDir * .5 * pp.dY(); 
		if (dWidths.length()>2 && pp.dY()>dWidths[dWidths.length()-2])
		{ 
			//pt.vis(2);
			pts3.append(pt);
		}
		
	}//next i
	pts3 = lnY.orderPoints(lnY.projectPoints(pts3), dEps);
	
//endregion 





//region Symbol
	
	double dSize = textHeight;
	PlaneProfile ppt(csFace);
	PLine plt(vecZ);
	plt.addVertex(ptCen);
	plt.addVertex(ptCen+vecX*2*dSize);
	plt.addVertex(ptCen+vecX*2*dSize+vecDir*dSize);
	plt.close();
	ppt.joinRing(plt, _kAdd);
	//ppt.vis(6);
//endregion 



//region Draw Overlaps
	if (sModelDisplay==tDOOverlap ||sShopdrawDisplay==tDOOverlap)
	{ 
		for (int i = 0; i < ppShapes.length(); i++)
		{
			PlaneProfile ppShape = ppShapes[i];
			int color = nPPColors[i];
			int transparency = nPPTransparencies[i];
			for (int j = i+1; j < ppShapes.length(); j++)
			{
				PlaneProfile ppOverlap = ppShapes[j];
				ppOverlap.intersectWith(ppShape);
				ppOverlap.intersectWith(ppFace);
				if (ppOverlap.area()>pow(dEps,2))
				{ 
					if (sModelDisplay==tDOOverlap)
					{ 
						dp.color(color);
						dp.draw(ppOverlap, _kDrawFilled,transparency);
						
						dp.color(nPPColors[j]);
						dp.transparency(nPPTransparencies[j]);
						dp.draw(ppOverlap);							
					}
					if (sShopdrawDisplay==tDOOverlap)
					{ 
						mapRequest.setInt("Transparency", transparency);
						mapRequest.setInt("Color", color);
						mapRequest.setInt("DrawFilled", _kDrawFilled);
						mapRequest.setPlaneProfile("PlaneProfile", ppOverlap);
						mapRequest.removeAt("AllowedView", true);
						mapRequests.appendMap("DimRequest", mapRequest);	
						
						mapRequest.setInt("Transparency", nPPTransparencies[j]);
						mapRequest.setInt("Color", nPPColors[j]);
						mapRequest.removeAt("DrawFilled", true);
						mapRequests.appendMap("DimRequest", mapRequest);	
						
					}					
			
					
					//{ Display dpx(3); dpx.draw(ppOverlap, _kDrawFilled, 80);}
				}
				
				
			}		
			
			
		}		
	}

//endregion 



//region Distribute symbol locations
	Map mapShapes;
	for (int i=0;i<ppShapes.length();i++) 
	{ 
		PlaneProfile ppShape = ppShapes[i]; 
		mapShapes.appendPlaneProfile("shape", ppShape);
//		{ Display dpx(3); dpx.draw(ppShape, _kDrawFilled, 80);}
		
		PLine rings[] = ppShape.allRings(true, false);
		for (int r=0;r<rings.length();r++) 
		{ 
			int color = nPPColors[i];
			PlaneProfile pp(csFace);
			pp.joinRing(rings[r], _kAdd);
			Point3d pt = pp.ptMid() + vecX * .5 * pp.dX() - vecDir * .5 * pp.dY();

			pp.shrink(-textHeight);
			Point3d pts[] = pp.intersectPoints(Plane(pt, vecDir), true, false);
			pts = lnX.orderPoints(pts);
			if (pts.length()>0)
				pt = pts.last();
				
			Point3d ptNearest = ppFace.closestPointTo(pt);
			pt += vecDir * vecDir.dotProduct(ptNearest - pt);
			//pt.vis(4);	
			
			PlaneProfile ppSym = ppt;
			ppSym.transformBy(pt - ptCen);
			
			dp.color(color);
			dp.draw(ppSym, _kDrawFilled,70);
			dp.draw(ppSym);

//			mapRequest.removeAt("Text", true);
//			mapRequest.setInt("Transparency", 70);
//			mapRequest.setInt("Color", color);
//			mapRequest.setInt("DrawFilled", _kDrawFilled);
//			mapRequest.setPlaneProfile("PlaneProfile", ppSym);
//			mapRequests.appendMap("DimRequest", mapRequest);
//			
//			mapRequest.setInt("DrawFilled", _kDrawAsCurves);
//			mapRequests.appendMap("DimRequest", mapRequest);

			if (i==2 && r==0)
			{ 
				int n = pts3.length();
				if (n>1)
				{
					String text = n + "x";
					dp.draw(text, pt+(vecX*3*dSize+.5*vecDir*dSize), vecX, vecY, 1, 0,_kDevice);
					
//					mapRequest.removeAt("PlaneProfile", true);
//					mapRequest.setPoint3d("ptLocation", pt+(vecX*3*dSize+.5*vecDir*dSize));
//					mapRequest.setString("Text", text);
//					mapRequests.appendMap("DimRequest", mapRequest);
				}
			}
			
			if (_Grip.length()<1)
				ptLoc = pt; // last to be default location
		}
	}//next i
	
	_Map.setMap("Shapes", mapShapes);
	
	
//	
//	pp1.vis(1);
//	pp2.vis(2);
//	pp3.vis(3);
//
//endregion 


//region Grip Management #GM

	
	if (_Grip.length()<1)
	{ 
		Grip gp;
		gp.setPtLoc(ptLoc);
		gp.setName("Location");
		gp.setColor(40);
		gp.setShapeType(_kGSTCircle);	
		
		gp.setVecX(vecX);
		gp.setVecY(vecY);
		
		gp.addHideDirection(vecX);
		gp.addHideDirection(-vecX);
		gp.addHideDirection(vecY);
		gp.addHideDirection(-vecY);	
		
		gp.setToolTip(T("|Drag location of text and show temporarly distribution of the strips|"));
		
		_Grip.append(gp);			
	}
	_ThisInst.setAllowGripAtPt0(_Grip.length()<1);

	_Map.setDouble("Area", area,_kArea);
	String text = _ThisInst.formatObject("@(Area:CU;m:RL0)m²", _Map);
	dp.draw(text, ptLoc, vecX, vecY, 1, 2, _kDevice);
	

	Map m = sip.subMapX(kDataLink);
	m.setEntity("WetGuard", _ThisInst);
	sip.setSubMapX(kDataLink, m);	
//endregion 




//region Hardware
//// collect existing hardware
//	HardWrComp hwcs[] = _ThisInst.hardWrComps();
//	
//// remove any tsl repType: the assumption is that any hardware component of type _kRTTsl has been attached by this instance
//	for (int i=hwcs.length()-1; i>=0 ; i--) 
//		if (hwcs[i].repType() == _kRTTsl)
//			hwcs.removeAt(i); 
//
//// declare the groupname of the hardware components
//	String sHWGroupName;
//	// set group name
//	{ 
//	// element
//		// try to catch the element from the parent entity
//		Element elHW =sip.element(); 
//		if (elHW.bIsValid()) 	
//			sHWGroupName=elHW.elementGroup().name();
//	// loose
//		else
//		{
//			Group groups[] = _ThisInst.groups();
//			if (groups.length()>0)	sHWGroupName=groups[0].name();
//		}		
//	}


// Add components to hardware
//	if(0)
//	{ 
//		
//		for (int i=0;i<pps.length();i++) 
//		{ 
//			double dScaleX= pps[i].dX();
//			double dScaleY= pps[i].dY();
//			
//			if (dScaleX<dEps){ continue;}
//			
//			String articleNumber = sArticles.last();
//			for (int j=0;j<dWidths.length();j++) 
//			{ 
//				if (dScaleY<=dWidths[j])
//				{
//					dScaleY = dWidths[j];
//					articleNumber = sArticles[j];
//					break;
//				}	 
//			}//next j
//			
//			
//			HardWrComp hwc(articleNumber,1); // the articleNumber and the quantity is mandatory
//			hwc.setModel(model);
//			hwc.setManufacturer(manufacturer);
//			//hwc.setDescription(sHWDescription);
//			//hwc.setMaterial(sHWMaterial);
//			String notes = "ColorIndex;" + nPPColors[i]+";Transparency;" + nPPTransparencies[i];
//			hwc.setNotes(notes);
//			
//			hwc.setGroup(sHWGroupName);
//			hwc.setLinkedEntity(sip);	
//			hwc.setCategory("Tape");
//			hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
//			
//			hwc.setDScaleX(dScaleX);
//			hwc.setDScaleY(dScaleY);
//			hwc.setDScaleZ(0);
//			
//		// cumulate length with existing entry	
//			int n=-1;
//			for (int i=0;i<hwcs.length();i++) 
//			{ 
//				HardWrComp h= hwcs[i]; 
//				if (h.articleNumber() != articleNumber)continue;
//				n = i;
//				break;
//			}//next i
//			if (n>-1)
//				hwcs[n].setDScaleX(hwcs[n].dScaleX()+dScaleX);
//			else
//				hwcs.append(hwc);			
//			 
//		}//next i
//
//	}

// make sure the hardware is updated
	if (_bOnDbCreated)	setExecutionLoops(2);				
	_ThisInst.setHardWrComps(hwcs);	
	
	
	if (mapRequests.length()>0)
		_Map.setMap("DimRequest[]", mapRequests);
	else
		_Map.removeAt("DimRequest[]", true);	
	
	//endregion


// Trigger RevertDistribution//region
	String sTriggerRevertDistribution = T("|Revert Distribution|");
	addRecalcTrigger(_kContextRoot, sTriggerRevertDistribution );
	if (_bOnRecalc && (_kExecuteKey==sTriggerRevertDistribution || _kExecuteKey==sDoubleClick))
	{
		_Map.setInt("flip", !bFlip);
		setExecutionLoops(2);
		return;
	}//endregion	


//region Trigger EditArticles
	String sTriggerEditArticles = T("|Edit Articles|");
	addRecalcTrigger(_kContext, sTriggerEditArticles );
	if (_bOnRecalc && _kExecuteKey==sTriggerEditArticles)
	{	
	
	// legacy: the articles have been defined with map key instead of articleNumber
		Map rows, articles = mapFamily.getMap("Article[]");
		for (int i=0;i<articles.length();i++) 
		{ 
			Map row = articles.getMap(i);
			String articleNumber = row.getMapName();
			row.setString("articleNumber", articleNumber);
			row.removeAt(0, true);
			row.moveLastTo(0);
			rows.appendMap("row"+rows.length(),row); 	 
		}//next i			

		Map mapIn; mapIn.setMap(kRowDefinitions, rows);
		Map mapOut=ShowDialogEdit(mapIn);

//_Map.setMap("XX", mapOut);
	// keep legacy structure
	// rewrite articles
		rows = Map();
		for (int i=0;i<mapOut.length();i++) 
		{ 
			Map row= mapOut.getMap(i);
			row.setMapName(row.getString("articleNumber"));
			row.removeAt("articleNumber", true);
			row.moveLastTo(0);
			rows.appendMap("Article", row);
		}//next i
		
		if (rows.length()>0)
		{ 
			mapFamily.setMap("Article[]", rows);
			
		// remove any family entry with this name
			for (int i=mapFamilies.length()-1; i>=0 ; i--) 
			{ 
				String name= mapFamilies.getMap(i).getMapName();
				if (name == sFamily)
					mapFamilies.removeAt(i, true);				
			}//next i
			mapFamilies.appendMap("Family", mapFamily);
			mapManufacturer.setMap("Family[]", mapFamilies);
		
		// remove any manufacturer entry with this name
			for (int i=mapManufacturers.length()-1; i>=0 ; i--) 
			{ 
				String name= mapManufacturers.getMap(i).getMapName();
				if (name == sManufacturer)
					mapManufacturers.removeAt(i, true);				
			}//next i			
			mapManufacturers.appendMap("Manufacturer", mapManufacturer);	
			
			mapSetting.setMap("Manufacturer[]", mapManufacturers);
			if (mapSetting.length()>0)
			{ 
				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);	
				reportMessage(TN("|Settings successfully updated| "));	
			}				
			
		}

		if (0 && rows.length()>0)
		{ 
			String sFileMap = _kPathPersonalTemp + "\\" + scriptName() + ".dxx";
			rows.writeToDxxFile(sFileMap);
			spawn_detach("",_kPathHsbInstall+"\\Utilities\\hsbMapExplorer\\hsbMapExplorer.exe", sFileMap,"");			
		}
		
		
		
		
		
		
		setExecutionLoops(2);
		return;
	}//endregion	



// Trigger ToggleCoverage
	String sTriggerToggleCoverage =bShowCoverage?T("|Hide Coverage|"):T("|Show Coverage|");
	addRecalcTrigger(_kContext, sTriggerToggleCoverage);
	if (_bOnRecalc && _kExecuteKey==sTriggerToggleCoverage)
	{
		bShowCoverage= !bShowCoverage;

		Map m = mapSetting.getMap("Display");
		m.setInt("ShowCoverage", bShowCoverage );
		mapSetting.setMap("Display", m);
		if (mo.bIsValid())mo.setMap(mapSetting);
		else mo.dbCreate(mapSetting);
		setExecutionLoops(2);
		return;
	}


//region Dialog Trigger
{ 
	// create TSL
	TslInst tslDialog;			Map mapTsl;						
	GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
	int nProps[] ={ };			double dProps[] ={ };			String sProps[] ={ };
	
//region Trigger DisplaySettings
	String sTriggerDisplaySetting = T("|Display settings|");
	addRecalcTrigger(_kContext, sTriggerDisplaySetting );
	if (_bOnRecalc && _kExecuteKey==sTriggerDisplaySetting)	
	{ 
		mapTsl.setInt("DialogMode",1);
		
		sProps.append(sModelDisplay);
		sProps.append(sShopdrawDisplay);
		dProps.append(dOverlap);
		dProps.append(dMinOpeningArea);
	
		tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);						
		if (tslDialog.bIsValid())
		{
			int bOk = tslDialog.showDialog();
			if (bOk)
			{ 
				sModelDisplay = tslDialog.propString(0);
				sShopdrawDisplay = tslDialog.propString(1);
				dOverlap = tslDialog.propDouble(0);
				dMinOpeningArea = tslDialog.propDouble(1);

				Map m = mapSetting.getMap("Display");
				m.setString("Model",sModelDisplay);
				m.setString("Shopdraw",sShopdrawDisplay);
				m.setDouble("Overlap",dOverlap);
				m.setDouble("MinOpeningArea",dMinOpeningArea);

				mapSetting.setMap("Display", m);
				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);				
			}
			tslDialog.dbErase();
		}
		setExecutionLoops(2);
		return;	
	}
	//endregion	
}
//End Dialog Trigger//endregion 

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
	}//endregion 







#End
#BeginThumbnail
M_]C_X``02D9)1@`!``$`8`!@``#__@`?3$5!1"!496-H;F]L;V=I97,@26YC
M+B!6,2XP,0#_VP"$``@&!@<&!0@'!P<*"0@*#18.#0P,#1L3%!`6(!PB(1\<
M'QXC*#,K(R8P)AX?+#TM,#4V.3HY(BL_0SXX0S,X.3<!"0H*#0L-&@X.&C<D
M'R0W-S<W-S<W-S<W-S<W-S<W-S<W-S<W-S<W-S<W-S<W-S<W-S<W-S<W-S<W
M-S<W-S<W-__$`:(```$%`0$!`0$!```````````!`@,$!08'"`D*"P$``P$!
M`0$!`0$!`0````````$"`P0%!@<("0H+$``"`0,#`@0#!04$!````7T!`@,`
M!!$%$B$Q008346$'(G$4,H&1H0@C0K'!%5+1\"0S8G*""0H6%Q@9&B4F)R@I
M*C0U-C<X.3I#1$5&1TA)2E-455976%E:8V1E9F=H:6IS='5V=WAY>H.$A8:'
MB(F*DI.4E9:7F)F:HJ.DI::GJ*FJLK.TM;:WN+FZPL/$Q<;'R,G*TM/4U=;7
MV-G:X>+CY.7FY^CIZO'R\_3U]O?X^?H1``(!`@0$`P0'!00$``$"=P`!`@,1
M!`4A,08205$'87$3(C*!"!1"D:&QP0DC,U+P%6)RT0H6)#3A)?$7&!D:)B<H
M*2HU-C<X.3I#1$5&1TA)2E-455976%E:8V1E9F=H:6IS='5V=WAY>H*#A(6&
MAXB)BI*3E)66EYB9FJ*CI*6FIZBIJK*SM+6VM[BYNL+#Q,7&Q\C)RM+3U-76
MU]C9VN+CY.7FY^CIZO+S]/7V]_CY^O_``!$(`2P!D`,!$0`"$0$#$0'_V@`,
M`P$``A$#$0`_`/?Z`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"
M@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`
M*`"@`H`*`"@`H`*`.<\1>,]-\/-Y#[KB[QGR8S]W_>/;^==F'P=2OJM$>?B\
MPI87W7K+L<=+\5=0+YATZW1?1F9C^?%>BLKAUDSR)9W4OI%&AIWQ3@DE":C8
M-"I_Y:0MNQ^!_P`:QJ98TKPD;T<ZBW:K&WH=_;7,%Y;1W-M*LL,@W*ZG((KR
MI1<'RRW/>A.,XJ47=,YOQ7XR_P"$8NK>'[!]I\Y"V?-V8P<>AKLPN#^L)OFM
M;R/.QN8?5)*/+>_G;]#,T?XD?VMJ]K8?V3Y7GOMW_:-VW\-HK>MEWLH.?-MY
M?\$YL/F_MJL:?):_G_P#O*\H]PY[Q!XQTSP^?)E8SW6,^3'U'U/:NNAA*E?5
M:+N<&*S"EAM'J^R.-E^*M\9,PZ;;HF>CNS'\QBO265PMK)GCRSNI?W8(TM+^
M*5K-*L>I636ZDX\V-MX'U'7\LUA5RR25Z;N=%'.H2=JL;>:.]@GBN8$G@D62
M)QN5E.017E2BXNS/=C)32E%W1)2*$9@BEF("@9)/:@&[:GG,GQ71976/1RZ`
MD*QN,9'8XV\5["RMVUE^'_!/GGGB3TA^/_`.@\*>,8_$TES%]D^RRP@,%\S?
MN![]!TX_.N3%81X=)WO<[\#CUBVURV:\[G3UQ'I'F_B/XK_\(_X@N]+_`+%\
M_P"SL%\S[3MW9`/38<=?6N:=?EE:Q]/@L@^M4(UO:6OTM_P1MC\3]5U+3;K4
M+/PBTMI:@F:07H`0`9/5/2A5I-740JY%0HU(TIU[2ELN7Y=S-_X7?_U+O_DY
M_P#85/UGR.K_`%7_`.GO_DO_``3U/3[K[=IMK>;-GGQ+)MSG;N`.,]^M=2=U
M<^3K4_95)4[[-K[BS3,@H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"
M@`H`*`"@`H`*`"@`H`*`"@`H`BN9OL]I--C/EH7QZX&:J*YI)$SERQ<NQ\[W
M-S+>74MS.Y>65B[,>Y-?7QBH)16R/S^<W.3E+=G;^%O`VF:[HJW<NHR>>Q(:
M.+;^[YX!SST&>W6O,Q.-J4:G*HZ'M8++:6(I<[EKY=#%U3P7K-AJ4UM;V<]W
M"A^6:.(X88S732QE*<%)M)]CBK9=7IU'&,6UWL=Q\.+?5;"UO++4+2>"(,KQ
M>:I`R<[@,_05Y>82ISDI0=V>WE,*U.,H5(M+I?\`$Q/BK_R$]/\`^N+?SKIR
MOX)>IQ9W_$AZ'-^#_P#D;M,_Z[#^5=N+_@2]#SL!_O,/4]>\4ZU_8.@3WB8,
MW"1`]-YZ?ER?PKY_"T?;55%['UF-Q'U:BYK?IZGA$LLD\SRRNSR.2S,QR2?6
MOJ4E%61\1*3D[O<[72?AIJ%_8QW-S=QVGF+N6,H6;';/3%>95S&$)<L5<]BA
MD]2I!2E*USFM=T.[\/ZDUE=[2VT,CKT=3W'Y5VT*T:\.:)YV)PT\-4Y)G8_#
M#6I$NIM'E?,3J98@?X6'4#ZCG\*\[,J*Y557S/7R;$-2=%[;H]/KQ#Z4YGQY
MJG]F>%K@*V);G]PGX_>_3-=N!I>TK+LM3S<SK>QP[MN]/Z^1XE7TQ\8;W@[5
M/[(\3VD[-B*1O*D]-K<?H<'\*Y<72]K1:Z[G=@*WL,1&739_,]UKY8^W/G?Q
MO]F_X6A>B\.+7[3'YW7[FU=W3GIGI7G5+>T=S])ROG_LR/L_BL[>NMCU;P^/
M!@\*:L-&)_L?:_VS_6]-GS?>^;[OI77#V?*^78^1Q?\`:/UJG[?^)IR_#WTV
MTW[GC?C,>&QK$/\`PBQS8^0-_P#K/]9N;/W^>FWVKCJ<E_</MLM^N>R?USXK
M^6UEV\[GT+X?_P"1;TO_`*](O_0!7H0^%'YOC/\`>*G^)_F:-4<P4`%`!0`4
M`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`-=%
MDC:-QE&!!'J*:=G=":35F>'^(_"6H:#=2'R7ELLDI.HR,?[7H?K7TV'Q<*R6
MMGV/BL7@:N&D]+Q[F%!/-;2B6"5XI!T9&*D?B*ZG%25FCBC*4'>+LSHM.\>>
M(-/(!O/M,8_@N!NS^/7]:Y*F!H3Z6]#T*69XFE]J_K_5STSPOXKM?$MNX5/)
MNXAF2(G/'J#W%>)B<++#ONCZ3!8Z&*CIHUT.-^*O_(3T_P#ZXM_.O1ROX)>I
MX^=_Q(>AS?@__D;M,_Z[#^5=N+_@2]#SL!_O,/4[7XK2LNGZ=$#\K2LQ'N`,
M?S->;E:]Z3/9SMM0@O-GG>D1)/K5A#)C9)<1JV>F"P%>O5;C3DUV9\_0BI58
MQ?=?F?0U?(GWYYA+\3[><@S>'8Y".A><''_CE>VLME':I^'_``3YJ6<QE\5*
M_P`_^`7=#\=VNH:U:V<6@16SS/L$JR@E?_'!6=?`RA3<G.]OZ[FV&S.%6K&"
MII7ZW_X!Z%7D'OGD?Q,U7[7KL=@C9CLT^;_?;D_IC]:^@RVERTW-]3Y3.*_/
M65-;1_-E;P+H"ZU/J1D'R1VS1J?1W!`/X`&KQM?V*C;O^1EEN%6(<[]%;YLY
M-T:-V1AAE."#V-=Z=]4>6U9V9[SX6U3^V/#EG=LV9=FR3_>7@_GU_&OE<32]
ME5<3[G!5O;T(SZ]?4XKQ+\*I]?\`$5YJBZM'"MPP(C,).W"@=<^U>=.@Y2O<
M^TP6?QPN'C1=.]O/_@"Z?\-]?TO2KO3+/Q/%%9W8831_8U.[*[3R3D<>AH5&
M459,*V=86M5C6J46Y1V?-VU,G_A25S_T'(O_``'/_P`54?5GW.O_`%GA_P`^
MG]__``#UG3K4V.F6EF7WF"%(]P&,[0!G]*ZTK*Q\A6J>UJ2GW;?WEFF9!0`4
M`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!
M0!F>(-2FTC0KJ_@A$TD(!"$X!&X`_H2:VH4U5J*#=KG-BJTJ%&52*NT>?_\`
M"U;W_H&0?]]FO6_LN'\S/!_MNI_(CJK71_#WBS1[>_DL(!)*@+F'Y"K]P2,9
MP?6N&5:OAIN"D].YZD,/AL;251Q5WV[GF7BW1K70=<:RL[DS1A`QW8W(3GY3
MC\#^->WA:TJU/FDK'S>.P\,-6Y(.Z_(O_#DR#QA`$)"F-P^/3'^.*QS"WL'?
MR-\INL4K=F:GQ5_Y">G_`/7%OYUAE?P2]3ISO^)#T.;\'_\`(W:9_P!=A_*N
MW%_P)>AYV`_WF'J>A_$O3VNO#:7,:Y-K*&;_`'3P?UQ7D9;44:O*^I]!G%)S
MH*2^RSR2&5[>>.:,X>-@RGT(.17OM)JS/E(R<6I+H>YZ+XKTK6+*.5;N*&?'
MSPR.%93WZ]1[U\Q6PM2E*UM#[;#XZC7@G=)]CR?Q-I.D:1+%!IVIF]F.3)C!
M5!VY'>O>PU6K53<XV1\MC*%"@U&E/F?49X/_`.1NTS_KL/Y4\7_`EZ$X#_>8
M>I[C=W4=E93W4QQ'"A=C[`9KYB$7.2BNI]K4FJ<'.6R/GF]NY+Z^GNYCF29R
M[?4G-?70@H145T/@:DW4FYRW9L:%XNU'P]:R6]DD!61][&1"3G&/7VKGKX2G
M7E>=SJPV.JX6+C"VICW=R][>3W4BJKS.78(,`$G)Q71"*A%170Y*DW.;F^IW
MWPLU39/>:4[<./.C'N.&_3'Y5Y69TKI5%Z'O9+6LY47ZK]3H==6\@U6\:+4Y
MD5]-E=5=PB1;73H0`1D$_,<D9KYZ5T]^A]YA'3E2BG!:37FW=/N_P5KF>UW>
M9N;>`-!8M>P1D2W);R\H2P+J3@$A.`>=V.,U-WLCI5.G[LI:RY9/1;V>FC2\
M]6NGD!N+BY-M9>>J01K=9>2[=49D=1\KC#$`$X!/R\]=HHNWIZAR1AS5+:OD
MVBKV:>ZVUZ]_*[.RTJX^U:197!61?-@1\2'+#*@\^];Q=TF>)7A[.K*'9O;;
M<MTS$*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H
M`*`"@`H`*`([B"*ZMI;>9`\4JE'4]P1@TXR<6FNA,HJ<7&6S/&?$'@;5-'N'
M>WA>[L\DK)&NY@/]H#I]>E?24,;3JJTG9GQ^*RVM0DW%7C_6YS<<\]LS"*62
M(]#M8K78XQENCSE*4-G8GLM,O]4F"6=I-<.3U121^)Z#\:F=2%-7D[&E.C4K
M.T(MGK/@GPBWAZ&2ZO"K7TR[2%.1&O7&>YSU^E>!C<7[=\L=D?4Y=@'A4YS^
M)_@8'Q0M;B?4K`PP22`1-DHI..:Z\LE&,)79PYS"4JD>57T.<\)6-W'XKTUW
MM9E42C),9`'%=F*G%T9),\_`TYK$P;3W/;9H8[B!X9D#Q2*593T(/45\RFXN
MZ/LI14DXO8\>\2^`]0TFX>:PBDN[$G(*#+I[$#G\:^APV.A55INS/DL9EE2C
M*]-7C^)R)!4E2""."#VKT#RMC9TCPMJFKQR30V[I;QH7,KC`.!G`]2?:N>KB
M:=)V;U.NA@JU=-I:+J6?"5C=Q^*]-=[695$HR3&0!Q48J<71DDS7`TYK$P;3
MW/0/B->3Q^'ULK:*1Y+I\-L4G"#D]/?'ZUY.7PBZO/+H>[FU22H\D5O^1Y7:
MZ/?W5W#;K:S*97"`F,X&3C->[*M",6[['S$,/4G)1L]?(]6'PV\/`#,<Y_[:
MUX/]HU_(^H_LC#=G]YRWC7P7;Z1;6EQI4,SJSE)%R7.<9!_0UW8/&2JMQJ,\
MS,<OC0C&5%/SZG.Z"U_H^N6=\+.XVQ2#?B(\J>&'3T)KLK\E6FX76IY^&]I0
MK1J<KT\CW8I&YW%%8E<9(['M7RMC[I2:6C&K:VZVYMU@C$)ZQA!M_*E9;%.I
M-RYKZB-:6SQ)$]O$T:?=0H"%^@HL@52:?,F[DU,@*`"@`H`*`"@`H`*`"@`H
M`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`&-#$YRT:
M,?4J#33:V$XI[H<`%``&`.@%(>PM`!0`4`%`!0`QHHW;<T:L?4C---K83BGN
MA](84`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`
M4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`
M!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4
M`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!
M0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`
M%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0
M`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%
M`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`9H`,T`%`!0`4`%`!0`4`%
M`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`
M4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`&)X@OY[)8!"6`<G.T<GI_C32NQ2=
ME<JV5Y/*"9`RC_:;)IR26S%%M[JQ;A2<L&DN/E!SA5Q^M5>-M$2HSO=L?*L$
MLHR^7Q]T/_2A.44#4)2W*5Q>^5F.)7RO'RKP/QHY&]6Q<Z3Y4B"VU:ZBOX4:
M0F$MAMQZ"I25M2W>ZL=&+ZU/285)0X7<!Z2"@!?M,/\`?%`!]HB_OB@!?/B_
MOT`'GQ_WZ`#SX_[]`!Y\?]^@`\^/^]0`>='_`'J`#SH_[U`!YT?]Z@`\Z/\`
MO4`+YT?]Z@`\Z/\`O4`'G1_WJ`#SH_[U`!YT?]Z@`\V/^]0`>:G]Z@`\U/[U
M`"&:,=6%`#P01D$$>U`"T`%`!0`4`%`!0`4`%`!0`4`%`"9YH`6@`H`*`"@`
MH`*`"@`H`*`.;\4EUDLPB`_>Y)QCI512ZDR<ELBK"DCA0DI3UP,YHBTMT$HR
M>SL:*/;PPF.:4'/7>>35)2D[Q1#<(KEDR1O*@A#PP9W=D7!HUD[-C]V"O%%.
M9W=&+1F/T!/-2TELRHMO=6,3$WVJ,NZXST44VX]$3%3O[S-2(U!H6TH`F4T`
M/%`"CB@!0<CB@!:`$)Q0`HH`6@!,\XH`6@!10`9[4@"@84``.>E`@H&+G`IB
M%H`*0#'Z8H`K+<R6SY0\=Q3&:MK>1W*_*<..JT"+%`!0`4`%`!0`4`%`!0`4
M`%`!0`4`%`!0`4`%`!0`4`%`!0!SOB;_`%EK]&_I0!GVL:Q@22S,VW^\<`5I
MS-Z11ERJ/O29K6LL,SDHNYL<MM_K2<916HXRA)Z#VDN6;`A55S]YF[?2G:"6
MX7FW:Q3ODD;[LFQ>XVYS2BTMT.49/9V,5MJ3QH7RV>YY-)W>MAJRT;-&(]*D
MHMI0!.M`#Q0`Z@!10`M`!0`"@!:`"@`H`!0`M(`H&(2`,DX`H`:LL9&1(I&<
M9SWH`42(7V!UW#MGFF`OF(-WS`;>O/2D(575QE6!'M0,7FF(#TH`I3+R:`*9
M9XG#HQ5AT(H&;6GZHMR/+EPLH_(T"-'-`!0`4`%`!0`4`%`!0`4`%`!0`4`%
M`!0`4`%`!0`4`%`'->*4#26>791\W`.,]*J+MLB)1ONRC;R10*(MK-Q]T*35
M)2EJ2Y1A[IL(TOD*8D4-Z.<8%2DKZEMRM[J)%6;8WFNN3TV#&*&X]`BI6]YF
M;<0QPJ9#(S;>K,V:IRE+1(A0C#WFS&+127:L@!.>6Q0U**LQQ<).\32A-9FI
M<2@1.M`$@H`=VH`44`+0`4`%`"T`%`!0`4`+2`*8$<Z&2%T`!)&,$XH&4EM9
M]H!4`"16P2,X%(!T=M-'*GR*0KEBV>2#0`16LPE9I`I$@(<`_E0!=AB\I2!W
M.33`DH$&*`*LPYH`I2+0!38F.4$>E-.PFKHW+75/+"+.<QMTD]/K3M?8GFMN
M:ZD$`@@@]"*DL6@`H`*`"@`H`*`"@!,<T`+0`4`%`!0`4`%`!0`4`%`'-^*M
MH>T=AG:&/3/I51OLB967O/H4[*4N<"-E7U;BFXVZBC+F>QIQ)<,W^M5$SP%7
MG%%XI;"M-O?0DGC@E91(V3T"[L9_`41<HK0)1A)I,S[MXX084C8X[*O%/E<O
M>;%S1A[J1DREO/CPO\7.3TJ=#2[TT+T7:I&7(Z`)TH`E%`#NU``O3TH`=0`A
MX[4`+0`HH`3//2@!:`"@!0?:@`H`*``=.F*`%Q0`G0=,T`.%`"T`(3TXH`@F
M%`%1Q0!2F7GI0,=:295H<C/5<]_:J1$K]"_!>O:$'.8CU0\?E3L2GU-JWN(K
MF(20N&7^7UJ#0EH`3<O3-`"*P;.#TH`=0`4`%`!0`4`%`!0`4`%`!0`4`%`"
M8H`YOQ2[)):!49CANGX544GNR92:V5RK`LK(H1@C=SC-"Y4]0DI-:.QJ0A(8
MR)I\[NNXX_*GK)^ZB=(KWF.5+>&'S8(=P[;!R:;<I.TF)*$5S114F=W4[HB@
M[9/-2TELRHR;W5C`N#-'*'9UP#T`IMQMH@2G?5DD=XP\S`'!`7WJ#0TH[J,,
M%).<X)QQF@":&\!,N]2JIWQ0!*M[$0Q^8;5W'([4")?M4>[;DYV[^G:@8U;V
M+#D[AM&X@CM0`?;H=H(W')P!MZTA"6UQ+.N[:N-Q!^E`%NF`"@!:`"@`H`6@
M`H`6@`H`*`"@!10`M`!0!!**`*K"@"K*/FQVQ0!1<['S3`G=4?"76\IV96(_
ME5)V)<;FGIT%M:,7M@1O')WDYI"-/S"PS2&(22.O%`R6`X;%`(L4AA0`4`)W
MH`6@`H`*`"@`H`*`"@`H`*`.=\3?ZZT],-_2F!1M8F'S23,5'..@%7S+9(SY
M7O*1J026T\@"A9'`Z[<X_&BTXKL)2IS>FI-(\^2D<`VC^)FP#^%)*-KMC;G>
MR13O4=T`60IZX'6DFENAR4GL[&!<QKN\HR99CW/--W>MAJT=&]22"S`:([ON
M>W6H++D5F!)G<-N[.".:`+!M#B;#;EDYV].?K0((K661I/-W*&3;EL9H&2K8
MO\Q,QR4V9`QB@!!IY`<&0?,NWA:`)I+4L(2DFUXNAQFD(?;0&W0J6W98G.*`
M)Z8`*`%H&%`A:``4`+0`4`%`!0`4`**`%H`*`(I1Q0!484`02`[O;%`S/N%Q
MF@#2LX1=Z>C=67Y3^%,1!LFLWRG*]UH!JY?M;Q9!P<$=0>HID[%]6##BD`]/
ME?B@"V*104`%`!0`4`%`!0`4`%`!0`4`%`!0!S7BE2\MH`Y08;.._2JB[="9
M1;ZV*=M)#;KL9B2>2,;B:I*4M40Y0A[K-E&D$"F&,;CCY6.,"I25]64V^7W4
M2()MI,I7V"CI0^7H./-]HS;B&.,&1Y7?;W9L@5?,WHD1R1C[S9BR/')<`J,D
M?Q;:34HK4<91D[HN1=JS-"Y%0!:2@"44`.H`09QS0`X4`!SVH`6D`#K3`7G-
M`"T`%``,T`+0`4`(,]Z`%H`0YQQ0`X4`+2`3GM0`R3[M,"JPYH`B8?E0,I7"
M<&@"YX>?YKB$^S#^5,1JS6RN.E(#)N;%HVWQY##TI@%O?-&P2;@^O8TQ-6-2
M*8-@YYH$7T(V#'2I*'4`%`"9H`6@`H`*`"@`H`*`"@`H`*`.9\4A%FM'?H@8
M_P`JJ-]D3*R]Y]"O8RB0_*C``?>(Q3<>5:BC/F>B-2-;EF_UB(F>,#)(HO!+
M85IM[Z#YXX)659'^;D!0V,T1<HK0)1C)I,HW,D<(,*1,<=E7BGRN7O-BYHP]
MU(Q[@MYJ8'?GGI4Z&FNA8B[5(RY%0!;2@"4=*`'"@`H`44#%H$%``.M`#J`"
M@`H`*`%H`*`"@`H`*`%%`"T`%`QK]*!%9EH`B*G=[8H`@FCR#0!'IA\C5(_1
M\J:8'34@(Y(E=2"*`,J>S!ZJ%'N:!E,&:S;'+1^GI57):+T&H,I#HV].C(?\
M\&G8F[1L12I*@=#D?RJ"R2@`H`*`"@`H`*`"@`H`*`"@`H`YGQ3)LGM`$9B0
MV`!]*J*N3*7+T((!*T:[&5&[Y&:%RIZA+F:TT-.';#&?.F!SU+8%/XG[J)TB
MO>8Y5@B@\V"(,.VT<G\Z;<F[28DH17-!%65Y'!WQ&,=LG)I-);,J+D]U8PIE
ME\\%G&,]`*&XVT0)3O=LLQ5!9=CH`M)TH`E'2@!XH`*!BB@!:!!0`4`.%`!0
M`4`%`"T`%`!0`4`%`"T`+0`4`(W2@"$B@",I\V>V*`&.G%`%-D*2JXZJ0:`.
MD!&W/XT`1-<PI]Z1?P.:`*4URK,=B%O<T#()&DEZJJCV%`B);8#H*`+=H6@D
MRO0]10!LT`%`!0`4`%`!0`4`%`!0`4`%`'-^)<BXM1VVM_,4P*=K&_#23':.
M<#@5?,MDC/E>\I&I"]M-*,!9'`ZXSC\:+3BNPKTYR[LFD>?<5CA`4?Q,W'Y4
MDHVNV-N=[)%2]1W0!9"GK@=:46ENARBWL[&#-MCE"%R6)S\QYIN[UL"M'2^I
M9BJ"RY'0!:CZ4`3#I0,>!0`H&!0`4"`CWQ0`M`!0`OXT`+0`4`)P#UY]*`%W
M#'4?G0`M``.!US0`M`"'D8SB@!10`[H*`$X.,-^1H`#TH`9MH`;LYZ_A0`>7
M0`PVX-`!Y)(`9F('J:`%$`':@!?)&/2@!PB%`"^4*`%6,!@:`-*@!.]`"T`%
M`!0`4`%`!0`4`%`!0!S'B@%[BU"N4P&S@>XJHM+=$R3>SL5;9X8$V.Y8GJ#R
M35)2EJB'*$-&S8C+B!3#$-QQ\K?+BI5K^\RFWR^ZB5!-M)E*^P7M^-#Y>@X\
MWVC.N(8XU,C2N^WNS9Q5\S>B1')&/O-[&0JK=WJ)'@,QQO88`_&I<7%:CC*,
MGH:J:5*O6>#_`+Z/^%0:%A+!EZS1?]]4`3I;;1S+%_WU0`\1`#_6Q_\`?5`#
MA&/^>L?YT`&P?\]8_P`Z`#8/^>L?YT`+L7_GK'^=`!L'_/6/\Z`#8/\`GK'^
M=``%`_Y:Q_G0`NU?^>J?G0`;5_YZ1_G0!7N+8R2121RQ!HSGENU`%:/3I%"*
MT\)0/O/S'T^E`RPL5SNRUS#@YR`>GICB@0R*UN(8"BW,.XMG)/04`/\`*N@K
M#[5"3D;3[=^U`#S',3)_I,*@XV=\>M`#/+N@C`7,);<-I)[>_%``T5RRA?M<
M.,')]30`^UMD@B0-)'O48X;B@"Q\O_/1/SH`/D_YZ)^=`";4W9\Q.F.M`"_)
M_P`]$_.@`^3_`)Z)^=`!\G_/1/SH`7Y/^>B?G0`93_GHGYT`&4_YZ)^=`!E/
M^>B?G0`]$#'AU/XT`6Z`"@`H`*`"@`H`*`"@`H`*`$H`I7VG0WH7>,E>0?2F
MG8329372Y(3E,&D,>8;P8"A5'TYJDTMT2U)[,2:VFGV[XA@=MQQ1&3CL*4%+
M<06$Q4(%5%]`*3;;NRDE%61)%HT:G<YRWK2&3?V7#ZF@`_LN#U-`!_9</J:`
M#^RX?4T`']EP^IH`/[+A]30`?V7#ZF@`_LN'U-`!_9<'J:`#^RX?4T`']EP^
MIH`/[+A]30`?V7#ZF@`_LN'U-`!_9</J:`#^RX/4T`']EP^IH`/[+A]30`?V
M7#ZF@`_LN'U-`!_9</J:`#^RX/4T`']EP>IH`/[+A]30`?V7#ZF@`_LN'U-`
M!_9<'J:`#^RX?4T`']EP^IH`/[+@]30`?V7#ZF@`_LN'U-`$T5I'$<KF@"Q0
M`"@!:`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`
M*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@
M`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*
M`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`
MH`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`
M"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H
M`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"
M@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`
M*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@
M`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*
M`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`
MH`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`
M"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H
M`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"
M@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`
MJS:E96U_;6$US&EW=;O)A)^9]H))`]`!UIV=KBND[%JD,*`"@`H`*`"@"K8Z
ME9:FDSV-S'<)#(8G:,Y`<8R,^V13::W$FGL6J0PH`*`"@`H`*`"@`H`*`"@!
M&944LS!5`R23@"@!(W62-9$.48`@^HH`=0`4`%`!0`4`%`!0`4`%`!0`4`%`
M!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`</KWQ#CTS47L[&V2Y\OAY"^!N[@
M>N*\G$9DJ<^2"O8]["9.ZU-3J.U^ASM[\4]4AA:06UI$.WRL3_.N99E6F^6*
M1WK),/'>3?W?Y'<>"/$#^)?#$%_-M^T[VCE"C`#`\?H5/XU[-&;G!-[GS^.P
MZPU=PCMT-/6[J6QT#4;N`A9H+:21"1G#!21_*MUJSAD[)L^=OA=J-YJOQ<T^
M\O[F2YN9!,6DD;)/[IO\XKJJ)*%D<-)MU$V?3%<AWA0`4`%`!0!Y'\=M<U+3
M-,TJQLKMX(+[SA<!."X79@9ZX^8Y'>MZ*3NV<V(DU9(T/@7QX`E_Z_9/_04J
M:OQ%8?X#TRLC<*`"@`H`*`"@`H`*`"@`H`Y_Q8Q%A"`2`9.1Z\4T!K:9QI5F
M/^F*?^@BD!:H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`
MH`*`"@`H`XWQQXJ_LFV.GV4@^VRK\[#_`)9*?ZGM^?I7F8_%^R7LX?$_P/;R
MO`>WE[6HO=7XO_(\MM+6>]NH[:VC:6:1L*H[U\]"$IR48[L^KJ5(THN<G9(Y
MK6?M,>ISVMRAB>W=HRA[$'!KU*='V2L]R(U%4BIQV9Z'\%]7\K4+_1W;"S()
MXP?[R\-^8(_[YKT<)*S<3PLZHWA&JNFAZCXF_P"14UC_`*\IO_0#7H1W1\O+
MX6?+G@/Q!:^%O&%GK%Y%+)!;K(&6$`L=R,HZD#J179.-XV//IR4979Z9<_M!
M(LY%KX=+1=C+=;6/X!3C\ZR]CW9N\3V1VG@CXG:5XTF:S2%[+4%7?Y$C!@X'
M7:W?'I@&LYTW$VA54]#5\7>-=(\&6*7&HNS2RY$,$0R\A'\A[FIC!RV*G44%
MJ>77'[05SYI^S^'HEC[>9<DG]%%;>Q\SG^L/L7](^/D%S=Q6^HZ%)$)&"AX)
MP_4X^Z0/YTG1MLQQQ%]T5_VA.%\._6X_]ITZ/46)Z&'X%^*-CX)\&MI_V":\
MOGN7EVA@B*I"@9;GT/:JG3<G<FG54(V.AT_]H&VDN%74=!D@A/5X9Q(1_P`!
M('\ZET>S+6([H]<TK5;+6M-AU#3KA9[6891U_D?0^U8--.S.E-25T1ZCK%KI
MN%D)>4C(1>OX^E(9E#Q/<2<PZ>2OU)_I3L!>TK6FU&Y>![4PLJ;L[LYYQTQ[
MT;`1:CK\EI?/:069E=,9.?49Z`4@*K>([^(;I=.*I[AA^M,#5TS6;?4\JH,<
MRC)1OZ>M+8"Q>W]OI\/FW#X'8#J?I0!B-XL!8B*Q9U'<O@_R-`&?J^M1ZG:Q
MQB%HG1\D$Y'2GL!U6F_\@NT_ZXI_Z"*0%J@`H`*`"@`H`*`"@`H`*`"@`H`*
M`"@`H`*`"@`H`*`"@`H`*`"@`H`*`,/Q;XCA\,:$]])R[,(H@02"Y!(S[8!/
MX5AB*KI4W**NSMP6%^M5E#IN_0\&O/$,=Q<R7$KR332,69L=37S;H59R<I/4
M^XA&-.*A%:(]G\!>'XM-T:#498_]-NXPYW=8U/(4?AC/_P!:O;P6$C0CS/=G
MR.9XV5>HZ:^&/XG`_%[P^8-?M]4MT&V]3$@!_C7`S^(*_E48NT)*3ZGIY-6<
MZ3IO[/Y,Y+PE/>:3XLTR[BA=BLRJRKR65OE8`?0FN>E5C&::/2QE)5*$HOL?
M0GB;CPIK'_7E-_Z`:]V.Z/@9?"SY<\!>'[;Q-XSL-(O'D2WF+L_EG#$*A;&>
MV<8KKF^6-T>?3BI229]$O\+_``:VFM8C0X44KM$H)\P>^\G.:YO:2O>YV^RA
M:UCYW\'R2Z5\1M($+G='J"0D^JE]A_,$UTRUBSBAI-'5_'CSO^$ZM?,SY?V%
M/+]/OOG]:BC\)IB+\QTGA+6OA19^&;"*]@L1>B%1<?:[(ROYF/F^8J>,YQ@]
M,5,E4OH:0E245<WK/2OA9XMNEBTR.P^UH0Z+;9MWR.<A>,_D:B]2.Y:5*6QS
MG[0G"^'?K<?^TZNCI<SQ/0;\(/`OAW7?#,FJZIIXN[D7+Q+YCMM"@+_"#CN>
MM%6<HNR"C3C*-V2_%OX>:)I?A@ZWH]DMG+;R(LJQD[&1CCIV()'3WHI3;=F.
MM3BHW0WX`:G)Y.M:;(Y\F/9.@[*3D-_)?RHK*UF+#O='=:-;C5M9EN+D;POS
ME3R"<\#Z?X5AL=9V(`4````<`#M2`6@"K=:A9V)Q<3K&QYQU/Y"@"I_PD6EG
M(-P<>\;?X4`8-@\(\5(UJ1Y)<[<#`P0:?0"?4%.I^*4M&)\M"%P/0#)_K0!U
M,4,<$8CB141>@48I`8'BR-!:P2!!OWXW8YQCUH`V--_Y!=I_UQ3_`-!%`%J@
M`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`.,^*=C
M]L\!W;*NY[>2.51_P+:?T8USXE?NV^QZ>53Y,5%=[H\(M[#&&F_!:\.=:VD3
M[1(Z8>.O$>E0KY&J2MC"JLF'&/3D5I1Q%;FMS'#4R_"SW@OR%UKQK=^+K6S6
M\MHHI;0MEXB</NQV/3[OKWIXNLZG*GT%@\%#"2DX/1V_4]!^'?@_[%"FM7\>
M+F0?N(V'^K4_Q'W/\OK79@L-R+VDM^AXV:X_G?L*;T6_F=;XFX\*:Q_UY3?^
M@&O5CNCYZ7PL^<O@[_R4[2_]V;_T4U=57X&<-'XT?45<9Z!\C:)_R4?3O^PK
M'_Z-%=S^$\R/QKU/I'QCX,T3QE#!:ZDQBNHPS02Q,!(HXSP>HZ9_I7)&3CL=
M\X1GHS@3^S[:9^7Q#,![VP/_`+-6OMK=#'ZLNYY1XFT6?P7XNN-.AO?,FLW5
MX[B/Y3R`P/L1FMHOFC<YI1Y)6/0_C7>/J&@^#;V0;7N+>25AZ%EB/]:RI:-H
MVKNZBSKO@7QX`E_Z_9/_`$%*BM\1KA_@#XW:U;V7@DZ695^U7\J`1Y^;8K;B
MV/3*@?C127O7"O*T;',_`"Q=Y-=NR"(]D<(/J3N)_+C\ZJL[61&&6[/0_#,G
MV359K67Y68%<'^\#T_G6!UG7T@`G`)Q0!Q>D6RZQJLTEXQ;C>1G&>?Y4]@.B
M_L'3-N/LB@?[Q_QI;`<_:P1VWBQ885VQI(0!G..*8$TK"S\9"23`1F')Z89<
M4=`.LI`<_P"+/^/&#_KI_2@#6TW_`)!=I_UQ3_T$4`6J`"@`H`*`"@`H`*`"
M@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`*`"@`H`0@,"I`(/!!H#8XW7OAQI6
MJ!I;$"PN>O[L?NV/NO;\*X*V!ISUCHSV,+FU:C[L_>7X_>>::M\-?%:W'E0:
M<L\:=)(YD"M],D'\Q7)#"587NCVXYKA9)-RM\F=#X"^&]];7YNM?M1#%"P:.
M`LK^8W;."1@>E;T\(W-2J+1'%CLTA[/DP[U?7L>NUZ9\R9^NV\MWX>U*VMTW
MS36LD:+G&6*D`<^]..C1,E=-(\3^&OP]\4Z#X\T_4=3TEK>TB$@>0S1MC,;`
M<!B>I%=%2<7&R.6E3E&:;1[Y7,=A\Y:3\-/&%MXWL=0ET9EM8]029I//CX02
M`DXW9Z5U.I'EM<X8TIJ2=CT/XL>"=;\6?V5<:*T7F6/F;E:38QW;<;3C'\)Z
MD5E3FH[F]:$I6L><+X9^+EFH@C?5T0<`1ZCE1^3UMS4S#DJHM>'_`(+>(]5U
M);CQ"PL[8ONFW2B2:3UQ@D9/J3^!I.K%*R'&A)OWCO?BGX!U/Q;:Z/'HOV9%
ML!(ICE<KPP3;MX(XVGKCM65.:C>YM5IN5N7H>7Q_"[XB:8Y^Q6<B#NUO>HN?
M_'@:V]I`Y_95%L6K'X-^,]8O!)JK1V@)^>6XN!*^/8*3G\2*/:QCL-4)O<]X
M\,>&['PGH4.E6`/EI\SNWWI'/5C_`)["N:4N9W.R$5!61%JV@&[G^U6CB*?J
M0>`2.^>QJ2BLK^)8!LV"0#H3M-,"_I7]L-<NVH8$6SY5^7KD>GXT@,Z?0KZR
MO&N-+D&,\+D`CVYX(I@/$'B6Y^2280KZ[E'_`*#S1H`EIH%U8ZQ;2J?-A'+O
MD#!P>U`&CK.C+J:*\;!+A!@$]"/0TM@,V(^([1!"(A*J\`G:>/KG^=/0"*YL
M=>U3:MRB*BG(!*@`_AS0!TUG"UO900L06CC521TR!BD!-0`4`%`!0`4`%`!0
M`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%
A`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`%`!0`4`?_9



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
        <int nm="BREAKPOINT" vl="550" />
        <int nm="BREAKPOINT" vl="1323" />
        <int nm="BREAKPOINT" vl="1318" />
        <int nm="BREAKPOINT" vl="1407" />
        <int nm="BREAKPOINT" vl="1460" />
        <int nm="BREAKPOINT" vl="1853" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-23533 dialog for article definitions improved, invalid entries will be removed." />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="4" />
      <str nm="DATE" vl="2/25/2025 5:04:05 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-22529 major update to enable custom settings and tool detection" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="3" />
      <str nm="DATE" vl="8/14/2024 2:08:23 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-21860 panel is now supporting DataLink reference" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="2" />
      <str nm="DATE" vl="4/10/2024 3:46:49 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-21123 shopdrawing requests added" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="1/25/2024 9:45:02 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-21123 initial version" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="1/15/2024 5:06:26 PM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End