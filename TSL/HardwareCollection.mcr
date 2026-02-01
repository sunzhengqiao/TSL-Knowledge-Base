#Version 8
#BeginDescription
#Versions
Version 1.2 19.09.2024 HSB-22699 new responibilty added, exports to notes
Version 1.1 19.07.2024 HSB-22439 new commands and properties added
Version 1.0 05.07.2024 HSB-22374 initial version

This tsl creates creates instances with cuistmizable hardware content


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 2
#KeyWords 
#BeginContents
//region Part #1

//region <History>
// #Versions
// 1.2 19.09.2024 HSB-22699 new responibilty added, exports to notes , Author Thorsten Huck
// 1.1 19.07.2024 HSB-22439 new commands and properties added , Author Thorsten Huck
// 1.0 05.07.2024 HSB-22374 initial version , Author Thorsten Huck

/// <insert Lang=en>
/// Pick insertion point
/// </insert>

// <summary Lang=en>
// This tsl creates creates instances with cuistmizable hardware content
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "HardwareCollection")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Show Article Dialog|") (_TM "|Select hardware collection|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Set Dependency|") (_TM "|Select hardware collection|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Set Alignment|") (_TM "|Select hardware collection|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Rotate|") (_TM "|Select hardware collection|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Set Block Definition|") (_TM "|Select hardware collection|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Remove Block Definition|") (_TM "|Select hardware collection|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add Article|") (_TM "|Select hardware collection|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Edit Article|") (_TM "|Select hardware collection|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Delete Articles|") (_TM "|Select hardware collection|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Import Settings|") (_TM "|Select hardware collection|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Export Settings|") (_TM "|Select hardware collection|"))) TSLCONTENT
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
	int darkyellow3D = bIsDark?rgb(157, 137, 88):rgb(254,234,185);

	Vector3d vecXView = getViewDirection(0);
	Vector3d vecYView = getViewDirection(1);
	Vector3d vecZView = getViewDirection(2);
		
//endregion 	
	
//end Constants//endregion

//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sPathGeneral = _kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\";	
	String sFileName ="HardwareCollection";
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
	String kArticle = "Article";
	Map mapArticles= mapSetting.getMap(kArticle+"[]");
//End Read Settings//endregion 

//End Settings//endregion	

//region Functions

//region Function ValidateBlockPath
	// validates / creates the required block path
	String ValidateBlockPath(String parentFolder, String folderName)
	{ 
		String out;
		
		String path=_kPathHsbCompany + "\\" + parentFolder;
		int bExists = (getFoldersInFolder(path, folderName).length() == 1);
		
		if (bExists)
		{
			out = path+"\\" + folderName;
		}
		else
		{ 
			
		// create parent folder if it doesn't exist
			bExists = (getFoldersInFolder(_kPathHsbCompany, parentFolder).length() == 1);
			if (!bExists)
			{ 
				makeFolder(path);
			}
		// create folder
			path += "\\" + folderName;
			bExists = makeFolder(path);
			if (bExists)
				out = path;
		}

		
		return out;
	}//endregion

//region Function ReadArticles
	// returns the articles specified in map
	String[] ReadArticles(Map mapArticles)
	{ 
		String sArticles[0];
		for (int i=0;i<mapArticles.length();i++) 
		{ 
			Map m = mapArticles.getMap(i);
			String key = m.getMapKey();
			if (key.length()>0 && sArticles.findNoCase(key, -1)<0)
				sArticles.append(key); 
		}//next i	
		sArticles.sorted();
		return sArticles;
	}//endregion

//region Function FilterTslsByName
	// returns all tsl instances with a certain scriptname
	// ents: the array to search, if empty all tsls in modelspace are taken
	// names: the names of the tsls to be returned, all if empty
	TslInst[] FilterTslsByName(Entity ents[], String names[])
	{ 
		TslInst out[0];
		int bAll = names.length() < 1;
		
		if (ents.length()<1)
			ents = Group().collectEntities(true, TslInst(),  _kModelSpace);
		
		for (int i=0;i<ents.length();i++) 
		{ 
			TslInst t= (TslInst)ents[i]; 
			//reportNotice("\ngetTslsByName: " + t.scriptName() +" "+names);
			if (t.bIsValid())
			{
				if (!bAll && names.findNoCase(t.scriptName(),-1)>-1)
					out.append(t);	
				else if (bAll)
					out.append(t);									
			}
				
		}//next i

		return out;
	
	}//endregion
	
//region Function GetGripByName
	// returns the grip index if found in array of grips
	// name: the name of the grip
	int GetGripByName(Grip grips[], String name)
	{ 
		int out = - 1;
		for (int i=0;i<grips.length();i++) 
		{ 
			if (grips[i].name()== name)
			{
				out = i;
				break;
			}	 
		}//next i
		return out;
	}//endregion

//region Function GetFaceProfiles
	// returns the front/back faces
	// t: the tslInstance to 
	PlaneProfile[] GetFaceProfiles(Point3d ptx, Map mapFaces, int& index, int bFront)
	{ 
		PlaneProfile pps[0];
		for (int i = 0; i < mapFaces.length(); i++)
		{
			PlaneProfile pp = mapFaces.getPlaneProfile(i);
			CoordSys cs = pp.coordSys();
			Vector3d vecZ = cs.vecZ();
			Point3d ptOrg = cs.ptOrg();
			
//			Display dpx(i);
//			dpx.draw(PLine(pp.ptMid(), pp.ptMid() + vecZ * U(200)));

			double dFront = vecZ.dotProduct(vecZView);
			if ((dFront > 0 && bFront) || (dFront < 0 && !bFront))
			{
				Point3d pt = ptx;
				Line(ptx, vecZView).hasIntersection(Plane(ptOrg, vecZ), pt);//
				if (pp.pointInProfile(pt)==_kPointInProfile)
					index = pps.length();
				pps.append(pp);
			}
		}
		
		return pps;
	}//endregion

//region Function SetGenBeamFaces
	// returns the faces of the genbeam as profiles
	Map SetGenBeamFaces(GenBeam gb)
	{ 
		int bIsOrthoView = gb.vecD(vecZView).isParallelTo(vecZView);	
		Vector3d vecFace = bIsOrthoView?vecZView:gb.vecD(vecZView);
		int nFaceIndex = - 1;
		
		Vector3d vecX = gb.vecX();
		int bIsBeam = gb.bIsKindOf(Beam());
		Body bd = gb.envelopeBody(false, true);
		Map mapFaces;
		
		Vector3d vecFaces[] ={ gb.vecY(), gb.vecZ() , - gb.vecY(), - gb.vecZ()};
		if (bIsBeam)
		{
			vecFaces.append(gb.vecX());
			vecFaces.append(-gb.vecX());
		}

		PlaneProfile ppFace,pps[0];//yz-y-z
		for (int i=0;i<vecFaces.length();i++) 
		{ 
			Vector3d vecFaceI = vecFaces[i];
			double dD = .5 * (vecFaceI.isParallelTo(vecX)?gb.solidLength():gb.dD(vecFaceI));
			Plane pn(gb.ptCen() + vecFaceI * dD,vecFaceI);
			
			PlaneProfile pp = bd.extractContactFaceInPlane(pn, U(1)); 
			if(pp.area()<pow(dEps,2))
				pp = bd.shadowProfile(pn);
			pps.append(pp);
			mapFaces.appendPlaneProfile("pp", pp);
			
			if (bIsOrthoView && vecFace.isCodirectionalTo(vecFaceI))
			{
				nFaceIndex = i;
				ppFace = pp;
				mapFaces.setInt("FaceIndex", nFaceIndex);
			}
			
		}//next i

		return mapFaces;
	}//endregion

//region Function DrawJigFaces
	// draws the jig faces of the referenced entity
	void DrawJigFaces(PlaneProfile pps[], int index)
	{ 

		Display dp(-1);
		if (index < 0 && pps.length() > 0)index = 0;
		for (int i = 0; i < pps.length(); i++)
		{
			PlaneProfile pp = pps[i];
			
			if (in3dGraphicsMode())
			{ 
				pp.transformBy(pp.coordSys().vecZ() *10*dEps);
				dp.trueColor(i == index?darkyellow3D:lightblue);				
			}
			else
			{ 
				dp.trueColor(i == index?darkyellow:lightblue,75);				
			}
			dp.draw(pp, _kDrawFilled);
		}//next i

		return;

	}//endregion

//region Function DrawSolidJig
	// draws a solid jig
	void DrawSolidJig(Body bd, Display dp)
	{ 
		if(!bd.isNull())
		{
			dp.draw(bd);
			PlaneProfile pp = bd.shadowProfile(Plane(bd.ptCen(), vecZView));
			Display dp2(-1);
			dp2.trueColor(lightblue, 80);
			dp2.draw(pp, _kDrawFilled);
		}
		return;
	} //endregion	

//region Function ShowArticleDialog
	// shows the article dialog and returns the selected article
	String ShowArticleDialog(String sArticles[], String current)
	{ 

		Map mapIn,mapItems;
		mapIn.setString("Title", T("|Article Selection|"));
		mapIn.setString("Prompt", T("|Select an article|"));
		mapIn.setInt("EnableMultipleSelection", false);
		mapIn.setInt("ShowSelectAll", true);

	// append to list
		sArticles = sArticles.sorted();
		for (int i = 0; i < sArticles.length(); i++)
		{ 
			String name = sArticles[i];

			Map m;
			m.setString("Text", name);
			//m.setString("ToolTip", toolTips[i]);
			m.setInt("IsSelected", name == current);
			mapItems.appendMap("Item", m);	
		}				
		mapIn.setMap("Items[]", mapItems);

		Map mapOut = callDotNetFunction2(sDialogLibrary, sClass, listSelectorMethod, mapIn);// optionsMethod,listSelectorMethod				
		int bCancel = mapOut.getInt("WasCancelled");


		//reportNotice("\nout" + mapOut + " \n" +mapOut.getMap("Selection[]") );
		
		if (!bCancel)
		{ 
			Map m = mapItems.getMap(mapOut.getInt("SelectedIndex"));
			String entry = m.getString("Text");
			if (sArticles.findNoCase(entry,-1)>-1)
				current = entry;
		}
		
		return current;
	}//endregion	

//region Function AddArticleDialog
	// shows a dialog to specify a new article name
	String AddArticleDialog(String sArticles[], String current)
	{ 
		String out;
		Map mapIn,mapItems;
		mapIn.setString("Title", T("|Add new article|"));
		mapIn.setString("Prompt", T("|Specify a new article name|"));
		
		if (current.length()>0)
		{ 
	  		mapIn.setString("PrefillText", current);//__optional, default is empty string
			mapIn.setInt("PrefillIsSelected", 1);//__optional, default is false			
		}

		int bCancel;
		
		while(!bCancel && out=="")
		{ 
			Map mapOut = callDotNetFunction2(sDialogLibrary, sClass, simpleTextMethod, mapIn);// optionsMethod,listSelectorMethod				
			bCancel = !mapOut.hasString("Text");
	
			if (!bCancel)
			{ 
				String entry = mapOut.getString("Text");
				if (sArticles.findNoCase(entry,-1)>-1)
				{
					Map mpAskIn;
					//mpAskIn.setString("Title", entry);
					mpAskIn.setString("question", entry + TN("|The article already exists, do you want to overwrite it?|"));
					Map mpAskOut = callDotNetFunction2(sDialogLibrary, sClass, askYesNoMethod, mpAskIn);
					int reply = mpAskOut.getInt("Answer"); //__1 for positive, 0 for negative
					if (reply==1)
						out = entry;
				}
				else
					out = entry;
			}			
		}
		return out;
	}//endregion

//region Function ShowArticleDialog
	// shows the article dialog and returns the selected article
	String[] RemoveArticleDialog(String sArticles[])
	{ 
		String out[0];
		Map mapIn,mapItems;
		mapIn.setString("Title", T("|Article Selection|"));
		mapIn.setString("Prompt", T("|Select an article|"));
		mapIn.setInt("EnableMultipleSelection", true);
		mapIn.setInt("ShowSelectAll", true);

	// append to list
		sArticles = sArticles.sorted();
		for (int i = 0; i < sArticles.length(); i++)
		{ 
			String name = sArticles[i];

			Map m;
			m.setString("Text", name);
			mapItems.appendMap("Item", m);	
		}				
		mapIn.setMap("Items[]", mapItems);

		Map mapOut = callDotNetFunction2(sDialogLibrary, sClass, listSelectorMethod, mapIn);// optionsMethod,listSelectorMethod				
		int bCancel = mapOut.getInt("WasCancelled");

		if (!bCancel)
		{ 
			mapItems = mapOut.getMap("Selection[]");
			for (int i = 0; i < mapItems.length(); i++)
				out.append(mapItems.getString(i));
		}
		return out;
	}//endregion

//region Function HardWrCompToMap
	// returns the hardware component as map
	Map HardWrCompToMap(HardWrComp hwc)
	{ 
		Map m;

		m.setString("ArticleNumber", hwc.articleNumber());
		m.setString("Name", hwc.name());
		m.setString("Description", hwc.description());
		m.setString("Manufacturer", hwc.manufacturer());
		m.setString("Model", hwc.model());
		m.setString("Material", hwc.material());
		m.setString("Category", hwc.category());
		m.setString("Group", hwc.group());
		m.setString("Notes", hwc.notes());
		m.setString("RepType", hwc.repType());
		
		m.setInt("Quantity", hwc.quantity());
	
		m.setDouble("ScaleX", hwc.dScaleX(), _kLength);
		m.setDouble("ScaleY", hwc.dScaleY(), _kLength);
		m.setDouble("ScaleZ", hwc.dScaleZ(), _kLength);

		return m;
	}//endregion

//region Function MapToHardWrComps
	// returns the hardware stored in map
	HardWrComp[] MapToHardWrComps(Map mapArticle)
	{ 
		HardWrComp hwcs[0];
		//Map mapEntries = mapArticle.getMap(0);
		for (int i=0;i<mapArticle.length();i++)
		{
			Map m = mapArticle.getMap(i);
			String key = m.getMapKey().makeUpper();
			if (key == "BLOCK")
			{
				continue;
			}
			else
			{ 
				HardWrComp hwc;
				hwc.setName(m.getString("Name"));			
				hwc.setArticleNumber(m.getString("ArticleNumber"));			
				hwc.setDescription(m.getString("Description"));
				hwc.setManufacturer(m.getString("Manufacturer"));
				hwc.setModel(m.getString("Model"));
				hwc.setMaterial(m.getString("Material"));			
				hwc.setCategory(m.getString("Category"));
				hwc.setGroup(m.getString("Group"));
				hwc.setNotes(m.getString("Notes"));			
				hwc.setRepType(m.getString("RepType"));
				
				hwc.setQuantity(m.getInt("Quantity"));
	
				hwc.setDScaleX(m.getDouble("ScaleX"));	
				hwc.setDScaleY(m.getDouble("ScaleY"));				
				hwc.setDScaleZ(m.getDouble("ScaleZ"));	
										
				hwcs.append(hwc);				
			}

				
		}	
		return hwcs;
	}//endregion

//region Function GetHardware
	// returns the hardware stored in map
	HardWrComp[] SetHardware(Map mapArticle, int qty)
	{ 
		HardWrComp hwcs[0];
		//Map mapEntries = mapArticle.getMap(0);
		for (int i=0;i<mapArticle.length();i++)
		{
			Map m = mapArticle.getMap(i);
			String key = m.getMapKey();
			if (key == "block"){continue;}
			
			HardWrComp hwc;
			hwc.setName(m.getString("Name"));			
			hwc.setArticleNumber(m.getString("ArticleNumber"));			
			hwc.setDescription(m.getString("Description"));
			hwc.setManufacturer(m.getString("Manufacturer"));
			hwc.setModel(m.getString("Model"));
			hwc.setMaterial(m.getString("Material"));			
			hwc.setCategory(m.getString("Category"));
			hwc.setGroup(m.getString("Group"));
			hwc.setNotes(m.getString("Notes"));			

			hwc.setQuantity(m.getInt("Quantity")*qty);

			hwc.setDScaleX(m.getDouble("ScaleX"));	
			hwc.setDScaleY(m.getDouble("ScaleY"));				
			hwc.setDScaleZ(m.getDouble("ScaleZ"));	
									
			hwcs.append(hwc);
				
		}	
		return hwcs;
	}//endregion	

//region Function GetArticleMap
	// returns the article map based on the entry name
	Map GetArticleMap(Map mapArticles, String article)
	{ 
		Map mapArticle;
		article.makeUpper();
		for (int i=0;i<mapArticles.length();i++) 
		{ 
			Map m = mapArticles.getMap(i);
			String key = m.getMapKey().makeUpper();
			if (key==article)
			{
				mapArticle = m;
				break;
			}

		}//next i
		return mapArticle;
	}//endregion

//region Function SetArticleMap
	// returns the article map based on the entry name
	void SetArticleMap(Map mapArticles, Map mapArticle)
	{ 
		String article = mapArticle.getMapKey();
		
		//reportNotice("\nSet article " + article + " "  + mapArticle);	
		for (int i=0;i<mapArticles.length();i++) 
		{ 
			Map m = mapArticles.getMap(i);
			String key = m.getMapKey();
			if (key==article)
			{
				//reportNotice("\nSet key " + key +  " "+ mapArticle.getMap("Block").getString("Definition"));
				mapArticles.removeAt(i, true);
				mapArticles.appendMap(key, mapArticle);
				mapArticles.moveLastTo(i);
				break;
			}
		}//next i
		mapSetting.setMap(kArticle+"[]", mapArticles);
		if (mo.bIsValid())mo.setMap(mapSetting);
		else mo.dbCreate(mapSetting);
		return;
	}//endregion


//endregion 

//region JIGS
	int bJig;	
	String kShowFront = "showFront";
	String kJigSelectFace = "SelectFace";		
		
	if (_bOnJig && _kExecuteKey== kJigSelectFace) 
	{
		Point3d ptJig = _Map.getPoint3d("_PtJig"); //running point
		int bFront = ! _Map.hasInt(kShowFront) ? true : _Map.getInt(kShowFront);
		Map mapFaces = _Map.getMap("Face[]");

		int index = - 1;		
		PlaneProfile pps[] = GetFaceProfiles(ptJig,mapFaces, index, bFront);
		DrawJigFaces(pps, index);

		return;		
	}


	//region Function GetRotationTransformation
	// returns
	CoordSys GetRotationTransformation(CoordSys cs,Point3d ptPick, double radius)
	{ 
		CoordSys csOut=cs;

		Point3d ptOrg = cs.ptOrg();		
		Vector3d vecX = cs.vecX();
		Vector3d vecY = cs.vecY();
		Vector3d vecZ = cs.vecZ();
		Plane pn(ptOrg, vecZ);
		
		Point3d pt=ptPick;
		Line(pt, vecZ).hasIntersection(pn, pt);

		Vector3d vecXNew = pt - ptOrg;
		double dist = vecXNew.length();
		if (dist>0)
		{ 
			vecXNew.normalize();
		}

		if (dist<radius)
		{ 
			double dx = vecXNew.dotProduct(vecX);
			double dy = vecXNew.dotProduct(vecY);
			
			if (abs(dx)>abs(dy) && abs(dx)>0)
			{ 
				vecX = vecX * dx / abs(dx);
			}
			else
			{ 
				vecX = vecY * dy / abs(dy);
			}			
			vecY = vecX.crossProduct(-vecZ);
		}
		else
		{ 
			vecX = vecXNew;
			vecY = vecX.crossProduct(-vecZ);			
		}
		csOut = CoordSys(ptOrg, vecX, vecY, vecZ);
		return csOut;
	}//endregion





	String kJigRotate = "Rotate";
	if (_bOnJig && _kExecuteKey== kJigRotate) 
	{
		Point3d ptJig = _Map.getPoint3d("_PtJig"); //running point
		Map mapFaces = _Map.getMap("Face[]");

		int index = - 1;		
		PlaneProfile pp, pps[0];
		pp = _Map.getPlaneProfile("ppFace");
		pps.append(pp);
		DrawJigFaces(pps, index);

		CoordSys cs = pp.coordSys();
		double radius = getViewHeight()*.2;
		cs = GetRotationTransformation(cs, ptJig, radius);
		Point3d ptOrg = cs.ptOrg();		
		Vector3d vecX = cs.vecX();
		Vector3d vecY = cs.vecY();
		Vector3d vecZ = cs.vecZ();		

		double angle = _XE.angleTo(vecX);
		
		Display dp(3);	
		dp.textHeight(radius*.1);
		dp.draw(angle+ "°\n", ptJig, _XW, _YW, 0, 0, _kDeviceX);
		
		
		for (int i=0;i<4;i++) 
		{ 
			PLine c;
			c.createCircle(ptOrg, vecZ, radius * (i + 1));
			dp.color(i+1);
			dp.draw(c);
		}//next i
		

		String sDefinition =_Map.getString("Definition");
		if (sDefinition.length()>0 && _BlockNames.findNoCase(sDefinition,-1)>-1)
		{ 
			Block block(sDefinition);
			Display dp(252);
			dp.draw(block,ptOrg, vecX, vecY, vecZ);
		}

		return;		
	}



	String kJigLocation = "SelectLocation";
	if (_bOnJig && _kExecuteKey== kJigLocation) 
	{
		Point3d ptJig = _Map.getPoint3d("_PtJig"); //running point

		int index=-1;		
		PlaneProfile pp, pps[0];
		pp = _Map.getPlaneProfile("ppFace");
		pps.append(pp);
		
		CoordSys cs = pp.coordSys();
		
		Vector3d vecX = cs.vecX();
		Vector3d vecY = cs.vecY();
		Vector3d vecZ = cs.vecZ();
		Plane pn(cs.ptOrg(), vecZ);
		
		Point3d pt=ptJig;
		Line(ptJig, vecZ).hasIntersection(pn, pt);
		DrawJigFaces(pps, index);


		String sDefinition =_Map.getString("Definition");
		
		
		if (sDefinition.length()>0 && _BlockNames.findNoCase(sDefinition,-1)>-1)
		{ 
			Block block(sDefinition);
			Display dp(252);
			dp.draw(block,pt, vecX, vecY, vecZ);
		}



		return;		
	}		
//END Jigs //endregion 
	
//region Legacy Article Import
	String sArticles[]= ReadArticles(mapArticles);
	if ((_bOnDbCreated || _bOnInsert) && sArticles.length()<1)
	{ 
		String sPath = _kPathHsbCompany + "\\Abbund\\Lux-HolzbauartikelDB.xml";
		if (findFile(sPath).length()>0)
		{ 
			Map mapTemp; 
			mapArticles.readFromXmlFile(sPath);

			if (mapArticles.length()>0)// && !bDebug)
			{ 
				sArticles= ReadArticles(mapArticles);
				
				if (_bOnDbCreated)
				{ 
					mapSetting.setMap(kArticle+"[]", mapArticles);
					if (mo.bIsValid())mo.setMap(mapSetting);
					else mo.dbCreate(mapSetting);
					setExecutionLoops(2);
					return;					
				}
			}		
		}
	}
//endregion 

//region Properties
	String sArticleName=T("|Article|");	
	PropString sArticle;
	if (sArticles.length()<1)
		sArticle=PropString(0, T("|New Article|"), sArticleName);	
	else
	{
		sArticle=PropString(0, sArticles.sorted(), sArticleName);
		if (sArticles.findNoCase(sArticle,-1)<0)
			sArticle.set(sArticles.first());
	}		
	sArticle.setDescription(T("|Defines the name of the article|"));
	sArticle.setCategory(category);
		
	String tRProduction = T("|Production|"), tROnsite = T("|On Site|"), tRCustomer = T("|by Customer|");
	String sResponsibilities[] = {tRProduction,tROnsite, tRCustomer};
	String sResponsibilityName=T("|Mounting|");	
	PropString sResponsibility(3, sResponsibilities, sResponsibilityName);	
	sResponsibility.setDescription(T("|Defines the Responsibility|"));
	sResponsibility.setCategory(category);
	if (sResponsibilities.findNoCase(sResponsibility ,- 1) < 0) sResponsibility.set(sResponsibilities[0]);
	
	String sQuantityName=T("|Quantity|");	
	PropInt nQuantity(nIntIndex++, 1, sQuantityName);	
	nQuantity.setDescription(T("|Defines the quantity of article collections|") );
	nQuantity.setCategory(category);
	if (nQuantity < 1)nQuantity.set(1);
	nQuantity.setReadOnly(bDebug ? false : _kHidden); //TODO

category = T("|Display|");
	String sDimStyleName=T("|Dimstyle|");	
	PropString sDimStyle(1, _DimStyles.sorted(), sDimStyleName);	
	sDimStyle.setDescription(T("|Defines the dimstyle|"));
	sDimStyle.setCategory(category);

	String sTextHeightName=T("|Text Height|");	
	PropDouble dTextHeight(0, U(0), sTextHeightName);	
	dTextHeight.setDescription(T("|Defines the text height|") + T(", |0 = byDimstyle|"));
	dTextHeight.setCategory(category);
	
	String sFormatName=T("|Format|");	
	PropString sFormat(2, "@("+ T("|Article|")+")", sFormatName);	
	sFormat.setDescription(T("|Defines the format to display text.|") + T("|Empty = no text if block is specified, else default text|"));
	sFormat.setCategory(category);

//End Properties//endregion 

//region OnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		
		Map mapAdd;
		mapAdd.setString(sArticleName, sArticle);
		mapAdd.setInt("HardwareModified", 0 );// nothing modified on insert
		sFormat.setDefinesFormatting("TslInstance", mapAdd);
		
	// silent/dialog
		if (_kExecuteKey.length()>0 && TslInst().getListOfCatalogNames(scriptName()).findNoCase(_kExecuteKey,-1)>-1)
			setPropValuesFromCatalog(_kExecuteKey);						
	// standard dialog	
		else	
			showDialog();
			
		_Pt0 = getPoint();	
			
		return;
	}			
//endregion 

//region Standards
	Vector3d vecX = _XE;
	Vector3d vecY = _YE;
	Vector3d vecZ = _ZE;
	Plane pnZ(_Pt0, vecZ);
	
	String sParentFolder = "Block";
	String sBlockPath = ValidateBlockPath(sParentFolder, sFileName);

//endregion 


//region Referenced Entities

	GenBeam gb;
	Element el;
	int bHasGenBeam, bHasElement;

	for (int i=0;i<_Entity.length();i++) 
	{ 
		GenBeam g = (GenBeam)_Entity[i]; 
		Element e = (Element)_Entity[i]; 
		
		if (!bHasGenBeam && g.bIsValid())
		{ 
			gb = g;
			bHasGenBeam = true;
			setDependencyOnEntity(g);
			
			e = g.element();
			bHasElement = e.bIsValid();
			if (bHasElement)
				el = e;
		}
		else if (e.bIsValid())
		{ 
			el = e;
			bHasElement = true;
			setDependencyOnEntity(e);
		}
		if (bHasGenBeam && bHasElement)
			break;
	}//next i	
	
	if (bHasGenBeam && !bHasElement)assignToGroups(gb, 'I');
	
//endregion		

//Part #1 //endregion 

//region Debug

	if (0 && bDebug)
	{ 
		int index = - 1;
		int bFront = true;
		if (bHasGenBeam)
		{ 
			Map mapFaces = SetGenBeamFaces(gb);
			_Pt0.vis(1);
			PlaneProfile pps[] = GetFaceProfiles(gb.ptCen(), mapFaces, index, bFront);
			DrawJigFaces(pps, index);
		}
	
	}
		
//endregion 





//region Defaults
	addRecalcTrigger(_kGripPointDrag, "_Pt0");
	int bDragLocation = _bOnGripPointDrag && _kExecuteKey == "_Pt0";

	Map mapArticle = mapArticles.length()>0?GetArticleMap(mapArticles, sArticle):_Map.getMap(kArticle); 
	Map mapBlock = mapArticle.getMap("Block");
	String sDefinition = mapBlock.getString("Definition");
	Block block;
	int bValidBlock;
	if (sDefinition.length()>0 && _BlockNames.findNoCase(sDefinition,-1)>-1)
	{ 
		block = Block(sDefinition);
		bValidBlock = true;
	}
	
	int bHasFormat = sFormat.length() > 0;
	int bAddGrip = ! bValidBlock || (bValidBlock && bHasFormat);
	
//	if (bDebug)
//	{ 
//		HardWrComp hwcs[] = SetHardware(mapArticle, 5);
//	}	
//endregion 






//region Function GetHwcCompareKey
	// returns a comparison key of an hardware component
	String GetHwcCompareKey(HardWrComp hwc)
	{ 
		Map m = HardWrCompToMap(hwc);

		String format = "@(ArticleNumber)_@(Name)_@(Description)_@(Manufacturer)_@(Model)_@(Material)_@(ScaleX)_@(ScaleY)_@(ScaleZ)";
		String compareKey = _ThisInst.formatObject(format, m);
		compareKey.makeUpper();		
		return compareKey;
	}//endregion


//region Function CompareHardwareSets
	// compares two sets of hardware components
	int CompareHardwareSets(HardWrComp hwcs1[], HardWrComp hwcs2[])
	{ 
		int bHasModification = false;
	
		if (hwcs1.length()!=hwcs2.length())
			bHasModification = true;
		else
		{ 
			bHasModification = true;
			int cnt;
			int bIsFound[hwcs2.length()]; // flag to indicate if an item has been mapped against first set
			for (int i=0;i<hwcs1.length();i++) 
			{ 
				int bFound;
				String key1 = GetHwcCompareKey(hwcs1[i]);
				for (int j=0;j<hwcs2.length();j++) 
				{ 
					if (bIsFound[j]){ continue;}
					String key2 = GetHwcCompareKey(hwcs2[j]);
					if (key1==key2)
					{ 
						bFound = true;
						bIsFound[j] = true;
						cnt++;
						break;
					}
				}//next i				 
			}//next i
			if (cnt == hwcs2.length())
			{ 
				bHasModification = false;
			}
		}
	
		return bHasModification;
	}//endregion

//region Validate Hardware Assignments
	HardWrComp hwcs[] = _ThisInst.hardWrComps();
	HardWrComp hwcsDB[] = MapToHardWrComps(mapArticle);
	int bHasModification = CompareHardwareSets(hwcs, hwcsDB);
	Map mapAdd;
	mapAdd.setInt("PosNum", _ThisInst.posnum());
	mapAdd.setInt("HardwareModified", bHasModification);
	_ThisInst.setColor(bHasModification ? 6 : 3);
	sFormat.setDefinesFormatting(_ThisInst, mapAdd);
//endregion 






//region Display
	Display dpWhite(-1), dpPlan(-1), dpModel(bDragLocation?252:_ThisInst.color());
	dpPlan.dimStyle(sDimStyle);
	double textHeight = dTextHeight>0 ?dTextHeight:dpPlan.textHeightForStyle("G", sDimStyle );
	dpPlan.textHeight(textHeight);
	
	dpWhite.trueColor(rgb(255, 255, 254), 10);
	dpWhite.textHeight(textHeight);

//endregion 

//region Grip #GM
	addRecalcTrigger(_kGripPointDrag, "_Grip");
	
	Vector3d vecOffsetApplied;
	int indexOfMovedGrip = Grip().indexOfMovedGrip(_Grip);
	int bDrag, bOnDragEnd;
	if (indexOfMovedGrip>-1)
	{ 
		bDrag = _bOnGripPointDrag && _kExecuteKey=="_Grip";
		bOnDragEnd = !_bOnGripPointDrag;
		
		Grip grip = _Grip[indexOfMovedGrip];
		vecOffsetApplied = grip.vecOffsetApplied();
	}
	
	int nGrip = GetGripByName(_Grip, "Tag");
	Point3d ptTag = nGrip>-1? _Grip[nGrip].ptLoc():_Pt0+_XE*.1*textHeight;
	
	//Remove Grip
	if (nGrip>-1 && !bAddGrip)
	{ 
		_Grip.removeAt(nGrip);
	}
	//Add Grip
	else if (nGrip<0 && bAddGrip)
	{ 	
		Grip g;
		g.setName("Tag");
		g.setPtLoc(ptTag);
		g.setVecX(_XE);
		g.setVecY(_YE);
		g.addViewDirection(_ZE);
		g.setColor(40);
		g.setShapeType(_kGSTCircle);				
		g.setToolTip(T("|Moves the tag of the entity|"));	
		
		_Grip.append(g);
		nGrip = _Grip.length() - 1;		
	}	
	// Relocate grip: tag grip may not be at _Pt0
	else if ((ptTag-_Pt0).length()<dEps)
	{ 
		ptTag = _Pt0 + _XE * .1 * textHeight;
		_Grip[nGrip].setPtLoc(ptTag);
	}//endregion

//endregion 

//region Draw	
	String text;
	if (bValidBlock)
		dpModel.draw(block, _Pt0, _XE, _YE, _ZE);
	else	
		text = sArticle;
		
	if (sFormat.length()>0)
		text = _ThisInst.formatObject(sFormat, mapAdd);
	
	// during dragging the text is not available
	if (bDrag)text = _Map.getString("text");
	else _Map.setString("Text", text);
	
	if (text.length()>0)
	{
		dpPlan.draw(text, ptTag, _XW, _YW, 1, 0);
	}
//endregion 

//region Export
	String compareKey = sArticle;
	{ 
		String keys[0];
		for (int i=0;i<hwcs.length();i++) 
		{ 
			String key= GetHwcCompareKey(hwcs[i]);
			keys.append(key);
		}//next i		
		keys = keys.sorted();
		for (int i=0;i<keys.length();i++) 
			compareKey+= "_"+keys[i]; 		
	}
	setCompareKey(compareKey);
	
//endregion 



//region Events
	if (_bOnDbCreated ||  _kNameLastChangedProp==sArticleName ||  _kNameLastChangedProp==sResponsibilityName)
	{
		mapArticle = GetArticleMap(mapArticles, sArticle);
		
		HardWrComp hwcs[0];
		hwcs = MapToHardWrComps(mapArticle);
		for (int i=0;i<hwcs.length();i++) 
		{ 
			hwcs[i].setNotes(sResponsibility); 			 
		}//next i
		
		_ThisInst.setHardWrComps(hwcs);
		setExecutionLoops(2);
		return;
	}
//	if (_kNameLastChangedProp==sQuantityName)
//	{
//		mapArticle = GetArticleMap(mapArticles, sArticle);
//		_ThisInst.setHardWrComps(SetHardware(mapArticle, nQuantity));
//		setExecutionLoops(2);
//		return;
//	}
//endregion 


//region User Triggers

// Trigger ShowDialogTrigger//region
	String sTriggerShowDialogTrigger = T("|Show Article Dialog|");
	addRecalcTrigger(_kContextRoot, sTriggerShowDialogTrigger );
	if (_bOnRecalc && (_kExecuteKey==sTriggerShowDialogTrigger || _kExecuteKey==sDoubleClick))
	{
		
		String article = ShowArticleDialog(sArticles, sArticle);
		if (article!=sArticle)
		{
			sArticle.set(article);
			mapArticle = GetArticleMap(mapArticles, article);
			_ThisInst.setHardWrComps(MapToHardWrComps(mapArticle));
		}
		setExecutionLoops(2);
		return;
	}//endregion

//region Trigger Set Dependency or Alignment
	String sTriggerSetDependency = T("|Set Dependency|");
	addRecalcTrigger(_kContextRoot, sTriggerSetDependency );
	int bSetDependency=_bOnRecalc && _kExecuteKey==sTriggerSetDependency;
	
	String sTriggerSetAlignment = T("|Set Alignment|");
	addRecalcTrigger(_kContextRoot, sTriggerSetAlignment );
	int bAlignTo=_bOnRecalc && _kExecuteKey==sTriggerSetAlignment;
	
	if (bSetDependency || bAlignTo)
	{
	// prompt for entities
		String prompt = bSetDependency ? T("|Select entity to link the instance to|") : T("|Select entity to to align with|")+T(", |<Enter> to pick points|");
		Entity ents[0];
		PrEntity ssE(prompt, Element());
		ssE.addAllowedClass(GenBeam());
		if (ssE.go())
			ents.append(ssE.set());
		
		
		for (int i=0;i<ents.length();i++) 
		{ 
			GenBeam g = (GenBeam)ents[i]; 
			Element e = (Element)ents[i]; 		
			if (g.bIsValid())
			{ 
				if (bSetDependency)
				{ 
					_Entity.setLength(0);
					_Entity.append(g);					
				}
				gb = g;
				break;
			}
			else if (e.bIsValid())
			{ 
				if (bSetDependency)
				{ 
					_Entity.setLength(0);
					_Entity.append(e);					
				}				
				el = e;
				break;
			}			 
		}//next i
	
	//region Face Selection
		PlaneProfile ppFace;
		double dH;
		int nFaceIndex = -1;
		Vector3d vecFace;
		Body bd;
		Quader qdr;
		
		if (gb.bIsValid())
		{
			bd= gb.envelopeBody(false, true);
			qdr =Quader(gb.ptCen(), gb.vecX(), gb.vecY(), gb.vecZ(), gb.solidLength(), gb.solidWidth(), gb.solidHeight(), 0, 0, 0);
		
			int bIsOrthoView = gb.vecD(vecZView).isParallelTo(vecZView);	
			vecFace = bIsOrthoView?vecZView:gb.vecD(vecZView);
	
		// not in ortho view
			if ( !bIsOrthoView)
			{
				int bFront = true; //default to pick a face on viewing side
				Map mapArgs, mapFaces;
				mapArgs.setInt("_Highlight", in3dGraphicsMode());
				mapArgs.setInt("showFront", bFront);
	
				mapFaces = SetGenBeamFaces(gb);
				PlaneProfile pps[] = GetFaceProfiles(gb.ptCen(), mapFaces, nFaceIndex, bFront);
				
				if (pps.length() > 0)ppFace = pps.first();
				mapArgs.setMap("Face[]", mapFaces);	
				
			//region Face selection
				int nGoJig = -1;
				PrPoint ssP(T("|Select face|")+ T(" |[Flip face]|"));
				ssP.setSnapMode(TRUE, 0); // turn off snaps
			    while (!bIsOrthoView && nGoJig != _kOk && nGoJig != _kNone)
			    {
			        nGoJig = ssP.goJig(kJigSelectFace, mapArgs); 
		
			        if (nGoJig == _kOk)
			        {
			            Point3d ptPick = ssP.value();
						int index;
						for (int i=0;i<pps.length();i++) 
						{
							PlaneProfile pp = pps[i];
							CoordSys cs = pp.coordSys();
							Vector3d vecZ = cs.vecZ();
							if (vecZ.isPerpendicularTo(vecZView))continue;
							Point3d ptOrg = cs.ptOrg();
							double dFront = vecZ.dotProduct(vecZView);
							if((dFront>0 && bFront) || (dFront<0 && !bFront)) // accept only profiles in view wirection or opposite
							{
								Point3d pt = ptPick;
								Line(pt, vecZView).hasIntersection(Plane(ptOrg, vecZ), pt);
								if (pp.pointInProfile(pt)==_kPointInProfile)
									index = i;
							}
						}    
			            
			            if (index>-1)
			            { 
			            	vecFace = qdr.vecD(pps[index].coordSys().vecZ());
			            	mapArgs.setInt("FaceIndex", index);
			            	nFaceIndex = index;
			            	ppFace = pps[index];	
			            }  
			        } 
			    	else if (nGoJig == _kKeyWord)
			        { 
			        // toggle in or opposite view	
			            if (ssP.keywordIndex() == 0)
			            {
			            	bFront =!bFront;
			            	mapArgs.setInt("showFront", bFront);
			            }    
			        }   
			        else
			        { 
			        	break;
			        }
			    }	
				ssP.setSnapMode(false, 0); // turn on snaps			    
				//End Face selection//endregion 		
			}	
		// orthogonal view, set ref or top side
			else
			{ 
				vecFace*=nFaceIndex; 
			}
			
	
			Point3d ptFace = qdr.pointAt(0,0,0) + .5 * vecFace * qdr.dD(vecFace);
			Plane pnFace = Plane(ptFace, vecFace);
	
		//region Show Jig
			PrPoint ssPLoc(T("|Select location|"), _Pt0); // second argument will set _PtBase in map
		    Map mapArgs;
		    mapArgs.setPlaneProfile("ppFace", ppFace);
		    mapArgs.setString("Definition", sDefinition);
		   //mapArgs.setInt("FaceIndex", nFaceIndex);
		   
		    int nGoJig = -1;
		    while (nGoJig != _kOk && nGoJig != _kNone)
		    {
		        nGoJig = ssPLoc.goJig(kJigLocation, mapArgs); 
		        if (bDebug)reportMessage("\ngoJig returned: " + nGoJig);
		        
		        if (nGoJig == _kOk)
		        {
		            Point3d ptPick= ssPLoc.value(); //retrieve the selected point
		            Line(ptPick, vecFace).hasIntersection(pnFace, ptPick);
		            //
		            
		            CoordSys cs = ppFace.coordSys();
		            CoordSys csAlign;
		            csAlign.setToAlignCoordSys(_Pt0, _XE, _YE, _ZE, ptPick, cs.vecX(), cs.vecY(), cs.vecZ());
		            _ThisInst.transformBy(csAlign);
		            _Pt0 = ptPick; 
		        }
	//	        else if (nGoJig == _kKeyWord) // TODO add options
	//	        { 
	//	            if (ssPLoc.keywordIndex() == 0)mapArgs.setInt("isLeft", TRUE);
	//	            else                 mapArgs.setInt("isLeft", FALSE);
	//	        }
		        else if (nGoJig == _kCancel)
		        { 
		        	break;
		        }
		    }
		    ssPLoc.setSnapMode(false, 0); // turn on snaps	
		//End Show Jig//endregion 

		
		}// End if gb.bIsValid()
		
		else if (el.bIsValid())
		{ 
			reportNotice("\n" + T("|Element alignment not implemented yet|"));
		}
		else
		{ 
			Point3d pts[0];
			pts.append(getPoint(T("|Pick new origin|")));
			pts.append(getPoint(T("|Pick point on X-Axis|")));
			pts.append(getPoint(T("|Pick point on Y-Axis|")));
			
			Vector3d vecX = pts[1] - pts[0]; vecX.normalize();
			Vector3d vecY = pts[2] - pts[0]; vecX.normalize();
			if (vecX.isParallelTo(vecY))
			{ 
				reportNotice(T("|Invalid points picked|"));
				setExecutionLoops(2);
				return;				
			}
			Vector3d vecZ = vecX.crossProduct(vecY);
			vecY = vecX.crossProduct(-vecZ);
            CoordSys cs(pts[0], vecX, vecY, vecZ);
            CoordSys csAlign;
            csAlign.setToAlignCoordSys(_Pt0, _XE, _YE, _ZE, cs.ptOrg(), cs.vecX(), cs.vecY(), cs.vecZ());			
			_ThisInst.transformBy(csAlign);
			_Pt0 = cs.ptOrg();	
		}
	//endregion 

		setExecutionLoops(2);
		return;
	}//endregion	

//region Trigger Rotate
	String sTriggerRotate = T("|Rotate|");
	addRecalcTrigger(_kContextRoot, sTriggerRotate );
	if (_bOnRecalc && _kExecuteKey==sTriggerRotate)
	{
		
		PlaneProfile ppFace(CoordSys(_Pt0, vecX, vecY, vecZ));
//		if (bHasGenBeam)
//		{
//			ppFace=PlaneProfile(CoordSys(_Pt0, gb.vecX(), gb.vecY(), gb.vecZ()));
//			ppFace.unionWith(gb.realBody().extractContactFaceInPlane(pnZ, dEps));
//		}
		
	//region Show Jig
		PrPoint ssP(T("|Pick point for rotation|"), _Pt0); // second argument will set _PtBase in map
		ssP.setSnapMode(TRUE, 0); // turn off snaps	
		
	    Map mapArgs, mapFaces;
	   	mapArgs.setPlaneProfile("ppFace", ppFace);
	    mapArgs.setString("Definition", sDefinition);
	    mapArgs.setString("Article", sArticle);

		
	    int nGoJig = -1;
	    while (nGoJig != _kOk && nGoJig != _kNone)
	    {
	        nGoJig = ssP.goJig(kJigRotate, mapArgs); 
	        if (bDebug)reportMessage("\ngoJig returned: " + nGoJig);
	        
	        if (nGoJig == _kOk)
	        {
	            Point3d ptPick = ssP.value(); //retrieve the selected point
				double radius = getViewHeight()*.2;
				CoordSys cs = GetRotationTransformation(ppFace.coordSys(), ptPick, radius);

	            CoordSys csAlign;
	            csAlign.setToAlignCoordSys(_Pt0, _XE, _YE, _ZE, _Pt0, cs.vecX(), cs.vecY(), cs.vecZ());
	            _ThisInst.transformBy(csAlign);
	            //_Pt0 = ptPick; 
	        }
	        else if (nGoJig == _kKeyWord)
	        { 
	            if (ssP.keywordIndex() == 0)
	                mapArgs.setInt("isLeft", TRUE);
	            else 
	                mapArgs.setInt("isLeft", FALSE);
	        }
	        else if (nGoJig == _kCancel)
	        { 
	        	break;
	        }
	    }
	    ssP.setSnapMode(false, 0); // turn on snaps	
	//End Show Jig//endregion 


		
		
		
		setExecutionLoops(2);
		return;
	}//endregion	


//End User Triggers //endregion 


//region Admin Triggers


//region Trigger SetBlockDefinition
	String sTriggerSetBlockDefinition = T("|Set Block Definition|");
	addRecalcTrigger(_kContext, sTriggerSetBlockDefinition );
	if (_bOnRecalc && _kExecuteKey==sTriggerSetBlockDefinition)
	{
		BlockRef bref = getBlockRef();
		sDefinition = bref.definition();
		
		Map mapBlock;
		mapBlock.setString("Definition", sDefinition);
		mapArticle.setMap("Block", mapBlock);
		mapArticle.setMapKey(sArticle);
		//reportNotice("\nStoring block " + sDefinition + " in map\n"+mapArticle);
		SetArticleMap(mapArticles, mapArticle);

		if (sBlockPath.length()>0)
		{ 
			Block block(sDefinition);
			String fullPath = sBlockPath + "\\" + sDefinition + ".dwg";
			int bWriteDwg;
			if (findFile(fullPath).length()>0)
			{ 

				Map mpAskIn;
				//mpAskIn.setString("Title", entry);
				mpAskIn.setString("question", fullPath + TN("|The file already exists, do you want to overwrite it?|"));
				Map mpAskOut = callDotNetFunction2(sDialogLibrary, sClass, askYesNoMethod, mpAskIn);
				int reply = mpAskOut.getInt("Answer"); //__1 for positive, 0 for negative
				if (reply==1)
					bWriteDwg=true;				
			}
			else
			{ 
				bWriteDwg = true;
			}
			if (bWriteDwg)
			{ 
				int errCode =  block.writeToDwg(sBlockPath+"\\"+sDefinition+".dwg");
				if (errCode != 0)
				{ 
					reportMessage("\n"+ scriptName() + T(" |reports error code|: ") + errCode);				
				}				
			}
		}


		setExecutionLoops(2);
		return;
	}//endregion	

//region Trigger RemoveBlockDefinition
	String sTriggerRemoveBlockDefinition = T("|Remove Block Definition|");
	if (bValidBlock)addRecalcTrigger(_kContext, sTriggerRemoveBlockDefinition );
	if (_bOnRecalc && _kExecuteKey==sTriggerRemoveBlockDefinition)
	{
		mapArticle.removeAt("Block", true);
		//mapArticle.setMapKey(sArticle);
		SetArticleMap(mapArticles, mapArticle);
		setExecutionLoops(2);
		return;
	}//endregion
	
//region Trigger AddArticle
	String sAddArticleTrigger = T("|Add Article|");
	addRecalcTrigger(_kContext, sAddArticleTrigger );
	if (_bOnRecalc && _kExecuteKey==sAddArticleTrigger)
	{
		
		String article = AddArticleDialog(sArticles, sArticle);
		
		if (article.length()>0)
		{
			//reportNotice("\nAppending new article " + article);
			sArticle.set(article);
			mapArticle.setMapKey(article);
			mapArticles.appendMap(article, mapArticle);
			mapSetting.setMap(kArticle+"[]", mapArticles);
			if (mo.bIsValid())mo.setMap(mapSetting);
			else mo.dbCreate(mapSetting);
		}
		setExecutionLoops(2);
		return;
	}//endregion	


//region Function RemoveArticleFromMap
	// returns the modfied articles map
	// t: the tslInstance to 
	void RemoveArticleFromMap(Map& mapArticles, String article)
	{ 
		for (int i=mapArticles.length()-1; i>=0 ; i--) 
		{ 
			Map mapArticle = mapArticles.getMap(i);
			String key = mapArticle.getMapKey().makeUpper();
			if (key == article.makeUpper())
			{ 
				mapArticles.removeAt(i, true);
				//break;
			}			 
		}//next j
		return;
	}//endregion


//region Trigger EditArticle
	String sTriggerEditArticle = T("|Edit Article|");
	addRecalcTrigger(_kContext, sTriggerEditArticle );
	if (_bOnRecalc && _kExecuteKey==sTriggerEditArticle)
	{
		hwcs =HardWrComp().showDialog(_ThisInst.hardWrComps());
		_ThisInst.setHardWrComps(hwcs);
		
		Map mapBlock = mapArticle.getMap("Block");
		Map mapNewArticle;
		if (mapBlock.length()>0)
			mapNewArticle.appendMap("Block", mapBlock);
		for (int i=0;i<hwcs.length();i++) 
		{ 
			Map m= HardWrCompToMap(hwcs[i]);
			//m.setMapKey(sArticle);
			mapNewArticle.appendMap("Entry", m);
		}//next i
		
		RemoveArticleFromMap(mapArticles, sArticle);

		mapNewArticle.setMapKey(sArticle);
		mapArticles.appendMap(sArticle, mapNewArticle);
		mapSetting.setMap(kArticle+"[]", mapArticles);
		if (mo.bIsValid())mo.setMap(mapSetting);
		else mo.dbCreate(mapSetting);
		
		setExecutionLoops(2);
		return;
	}//endregion	

//region Trigger DeleteArticle
	String sDeleteArticleTrigger = T("|Delete Articles|");
	addRecalcTrigger(_kContext, sDeleteArticleTrigger );
	if (_bOnRecalc && _kExecuteKey==sDeleteArticleTrigger)
	{

	// Find all instances currently in this dwg
		String names[] ={ scriptName()};
		Entity ents[0];
		TslInst tsls[] = FilterTslsByName(ents, names);
		String articlesInUse[0];
		for (int i=0;i<tsls.length();i++) 
		{ 
			String article= tsls[i].propString(0);
			if (article.length()>0 && articlesInUse.findNoCase(article,-1)<0)
				articlesInUse.append(article);		 
		}//next i

		String articles[] = RemoveArticleDialog(sArticles);
		
		int num;
		TslInst tslsInUse[0];
		for (int i=0;i<articles.length();i++) 
		{ 
			String article = articles[i].makeUpper(); 
			
			if (articlesInUse.findNoCase(article ,- 1) >- 1)
			{
				reportNotice("\n" + article + T(" |refers to instances in the dwg and cannot be deleted.|"));
				for (int j = 0; j < tsls.length(); j++)
					if (tsls[j].propString(0).makeUpper() == article)
						tslsInUse.append(tsls[j]);		
				continue;		
			}
			
			for (int j=0;j<mapArticles.length();j++) 
			{ 
				Map mapArticle = mapArticles.getMap(j);
				String key = mapArticle.getMapKey(),makeUpper();
				if (key == article)
				{ 
					num++;
					mapArticles.removeAt(j, true);
					break;
				}			 
			}//next j 
		}//next i
		
		if (num>0)
		{ 
			mapSetting.setMap(kArticle+"[]", mapArticles);
			if (mo.bIsValid())mo.setMap(mapSetting);
			else mo.dbCreate(mapSetting);			
		}
		
	// Select non purgable instances	
		if (tslsInUse.length()>0)
		{			
			PrEntity().setPickFirstSS(tslsInUse);
		}
		setExecutionLoops(2);
		return;
	}//endregion

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

		
//End Admin Triggers //endregion 


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
        <int nm="BreakPoint" vl="925" />
        <int nm="BreakPoint" vl="960" />
        <int nm="BreakPoint" vl="540" />
        <int nm="BreakPoint" vl="922" />
        <int nm="BreakPoint" vl="1060" />
        <int nm="BreakPoint" vl="537" />
        <int nm="BreakPoint" vl="1560" />
        <int nm="BreakPoint" vl="1564" />
        <int nm="BreakPoint" vl="1104" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-22699 new responibilty added, exports to notes" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="2" />
      <str nm="DATE" vl="9/19/2024 9:40:41 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-22439 new commands and properties added" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="7/19/2024 3:47:23 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-22374 initial version" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="7/5/2024 4:51:46 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End