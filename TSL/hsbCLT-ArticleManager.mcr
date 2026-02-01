#Version 8
#BeginDescription
#Versions
Version 1.6 11.11.2025 HSB-24891: Fix when running hsbExcelToMap , Author: Marsel Nakuci
Version 1.5 10.01.2023 HSB-17414 article collection derived from associated panels if in masterpanel mode , Author Thorsten Huck
Version 1.4 07.12.2022 HSB-17273 Grade, Description and Material appended as predefined optional component definitions
Version 1.3 07.12.2022 HSB-17273 new article definition requires semicolon based component convention
Version 1.2 06.12.2022 HSB-17273 supports layer preselection if defined in style name (convention: <Thickness> <NumComponents><SingleDoubleComponnet> ) 
Version 1.1 01.07.2022 HSB-15891 supports also masterpanels
Version 1.0 29.06.2022 HSB-15891 initial version











#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 6
#KeyWords 
#BeginContents
//region <History>
// #Versions:
// 1.6 11.11.2025 HSB-24891: Fix when running hsbExcelToMap , Author: Marsel Nakuci
// 1.5 10.01.2023 HSB-17414 article collection derived from associated panels if in masterpanel mode , Author Thorsten Huck
// 1.4 07.12.2022 HSB-17273 Grade, Description and Material appended as predefined optional component definitions , Author Thorsten Huck
// 1.3 07.12.2022 HSB-17273 new article definition requires semicolon based component convention  , Author Thorsten Huck
// 1.2 06.12.2022 HSB-17273 supports layer preselection if defined in style name (convention: <Thickness> <NumComponents><SingleDoubleComponnet> ) , Author Thorsten Huck
// 1.1 01.07.2022 HSB-15891 supports also masterpanels , Author Thorsten Huck
// 1.0 29.06.2022 HSB-15891 initial version , Author Thorsten Huck


/// <insert Lang=en>
/// Select panels or attach tsl to generation rule
/// </insert>

// <summary Lang=en>
// This appends layer component data to a custom mapX entry of the panel.
// The article data can be imported from an excel file or from the corresponding xml file in company\tsl\settings
// When importing from excel the data must be organized in columns with at least these columns
// Thickness  -> value to be defined in [mm]
// Quality 1  -> surface quality name as defined in surfaceQualityStyles
// Quality 2  -> surface quality name as defined in surfaceQualityStyles
// Components -> string expressing the thickness of the individual layer components, layers to be separated by '-', grouped componets to braced i.e. '(20-20)', example (20-20)-30-40-30-40
// The data can be accessed via format expressions using one or multiple of these arguments:
// @(CLT-ArticleData.ComponentDescription)
// @(CLT-ArticleData.ComponentDescriptionAligned)
// @(CLT-ArticleData.Layer)
// @(CLT-ArticleData.Quality1)
// @(CLT-ArticleData.Quality2)
// @(CLT-ArticleData.Description)
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "CLT-ArticleManager")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Import Excel Articles|") (_TM "|Select tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Export Settings|") (_TM "|Select tool|"))) TSLCONTENT
//endregion

//region Constants 
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;

	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	
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

	String kQuality1="Quality 1", kQuality2="Quality 2", kComponents="Components", kName="Name", kThickness="Thickness";
//end Constants//endregion

//region Functions #FU
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
//endregion Functions #FU

//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sPathGeneral = _kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\";	
	String sFileName ="CLT-ArticleManager";
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
	Map mapArticles = mapSetting.getMap("Article[]");
	
//End Settings//endregion	

//region bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
		String sArticles[0];
		PropString sArticle(nStringIndex++, sArticles, T("|Article|"));	// do noting on insert
		sArticle.setReadOnly(_kHidden);
		
//	// silent/dialog
//		if (_kExecuteKey.length()>0)
//		{
//			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());	
//			if (sEntries.findNoCase(_kExecuteKey,-1)>-1)
//				setPropValuesFromCatalog(_kExecuteKey);
//			else
//				setPropValuesFromCatalog(sLastInserted);					
//		}	
//	// standard dialog	
//		else	
//			showDialog();
		
	// prompt for entities
		Entity ents[0];
		PrEntity ssE(T("|Select panels|"), Sip());
		ssE.addAllowedClass(MasterPanel());
		if (ssE.go())
			ents.append(ssE.set());
		
	
	// create TSLs
		TslInst tslNew;				Map mapTsl;
		int bForceModelSpace = true;	
		String sExecuteKey,sCatalogName = sLastInserted;
		String sEvent="OnDbCreated"; // "OnElementConstructed", "OnRecalc", "OnMapIO"...
		Point3d ptsTsl[1];
	
	
		for (int i=0;i<ents.length();i++) 
		{ 
			Entity entsTsl[] = {};
			GenBeam gbsTsl[] = {};
			
			Sip sip =(Sip) ents[i]; 
			if (sip.bIsValid())
			{ 
				gbsTsl.append(sip);
				ptsTsl[0] = sip.ptCen();
				tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, sCatalogName, bForceModelSpace, mapTsl, sExecuteKey, sEvent);
			}
			MasterPanel master=(MasterPanel) ents[i]; 
			if (master.bIsValid())
			{ 
				PlaneProfile pp(CoordSys());
				pp.joinRing(master.plShape(), _kAdd);
				entsTsl.append(master);
				ptsTsl[0] = pp.ptMid()-.5*(_XW*pp.dX()+_YW*pp.dY());
				tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, sCatalogName, bForceModelSpace, mapTsl, sExecuteKey, sEvent);
			}			
			
		}//next i

		eraseInstance();
		return;
	}	
// end on insert	__________________//endregion

//region Panel standards	
	Sip sip;
	MasterPanel master;
	
	if (_Sip.length()>0)
		sip= _Sip[0];

	else if (_Entity.length()>0)
		master = (MasterPanel)_Entity[0];
	if (!sip.bIsValid() && !master.bIsValid())
	{
		reportMessage("\n" + scriptName() + ": " +T("|Invalid reference.|") + " " + T("|Tool will be deleted|"));
		eraseInstance();
		return;
	}			
		
	String qualities[0];

	Vector3d vecX=_XW, vecY=_YW, vecZ=_ZW;
	Point3d ptCen = _Pt0;
	double dZ;
	PLine plEnvelope;
	Entity entDefine;
	String styleName, styleDescription;
	SurfaceQualityStyle sqBot, sqTop;
	String sSQEntries[] = SurfaceQualityStyle().getAllEntryNames();
	// get lowest quality as default
	String sDefaultSQ;
	{ 
		int nDefaultQuality = 10e6;
		
		if (sSQEntries.length()>1)
		{
			int n = sSQEntries.findNoCase("Standard", - 1);
			if (n>-1)
				sSQEntries.removeAt(n);
		}
			
		
		for (int i=0;i<sSQEntries.length();i++) 
		{ 
			int n = SurfaceQualityStyle(sSQEntries[i]).quality(); 
			if (n<nDefaultQuality)
			{ 
				nDefaultQuality=n;
				sDefaultSQ = sSQEntries[i];
			}		 
		}//next i		
	}
	
	
	
	
	
	
	Entity tents[0];
	Map mapChildData; 
	PlaneProfile ppShape(CoordSys());
// Panel
	if (sip.bIsValid())
	{ 
	// avoid duplictates
		tents = sip.eToolsConnected();
		for (int i=0;i<tents.length();i++)
		{ 
			TslInst t= (TslInst)tents[i]; 
			if (t.bIsValid() && t.scriptName()==scriptName() && t!=_ThisInst)
			{ 
				reportMessage("\n"+ scriptName() + T(" |already attached to panel| ")+sip.posnum() +" - "+ sip.name() + T(", |Tool will be deleted.|"));
				eraseInstance();
				return;
			}
		}	
		
		
		styleName = sip.style();
		SipStyle style(styleName);
		
		vecX = sip.vecX();
		vecY = sip.vecY();
		vecZ = sip.vecZ();		
		
		ptCen = sip.ptCen();
		
		dZ = sip.dH();
		plEnvelope= sip.plEnvelope();
		
		ppShape = PlaneProfile(CoordSys(ptCen, vecX, vecY, vecZ));
		ppShape.joinRing(plEnvelope, _kAdd);
		
		entDefine = sip;

		String sqBotName = sip.formatObject("@(SurfaceQualityBottomStyle)");
		if (sqBotName.length()<1)
			sqBotName = sDefaultSQ;
		sqBot =  SurfaceQualityStyle(sqBotName);
		
		String sqTopName = sip.formatObject("@(SurfaceQualityTopStyle)");
		if (sqTopName.length()<1)
			sqTopName = sDefaultSQ;
		sqTop =  SurfaceQualityStyle(sqTopName);	
				
	}
	else if (master.bIsValid())
	{ 
		styleName = master.style();
		MasterPanelStyle style(styleName);
		dZ = style.dThickness();

		ppShape.joinRing(master.plShape(), _kAdd);
		ptCen = ppShape.ptMid();//-.5*(_XW*pp.dX()+_YW*pp.dY());		
		
		entDefine = master;

		String sqBotName = master.formatObject("@(SurfaceQualityBottomStyle)");
		if (sqBotName.length()<1)
			sqBotName = sDefaultSQ;
		sqBot =  SurfaceQualityStyle(sqBotName);
		
		String sqTopName = master.formatObject("@(SurfaceQualityTopStyle)");
		if (sqTopName.length()<1)
			sqTopName = sDefaultSQ;
		sqTop =  SurfaceQualityStyle(sqTopName);
		
	// HSB-17414 article collection derived from associated panels if in masterpanel mode	
		ChildPanel childs[] = master.nestedChildPanels();
		for (int i=0;i<childs.length();i++) 
		{ 
			Sip sip = childs[i].sipEntity();
			if (sip.subMapXKeys().findNoCase("CLT_ArticleData",-1)>-1)
			{ 
				Map m = sip.subMapX("CLT_ArticleData");
				String name = m.getString("name");
				if (name.length()>0)
				{ 
					int bOk = true;
					for (int j=0;j<mapChildData.length();j++) 
					{ 
						if (name == mapChildData.getMap(j).getString("name"))
						{
							bOk=false;
							break;
						}	 
					}//next j
					mapChildData.appendMap(mapChildData.length() + 1, m);
				}
			}			
		}//next i		 		
		
		
	}
	
	if(_bOnDbCreated)_Pt0 = ptCen;
	vecX.vis(ptCen,1);vecY.vis(ptCen,3);vecZ.vis(ptCen,150);
	
	_Entity.append(entDefine);
	setDependencyOnEntity(entDefine);
	assignToGroups(entDefine, 'T');	
		
	qualities.append(sqBot.entryName());
	qualities.append(sqTop.entryName());
	
	
//region Analyse Style Name by Conventions
	int nNumComponent,bIsParallelStyleName; // flag to indicate if the 2 outer components are parallel (ss)
	{ 
		String tokens[] = styleName.tokenize(" ");

	// find token which contains a amount of component and parallel/non parallel definition
		for (int i=0;i<tokens.length();i++) 
		{ 
			String token = tokens[i];
			int n = token.left(2).atoi();
			String s = n;
			if (n>0 && token.find("s", 0, false) > s.length()-1)
			{ 
				nNumComponent = n;
				bIsParallelStyleName = token.find("ss", 0, false) >- 1;				
				break;
			}	 
		}//next i
	}
//endregion 	


//endregion 

//region Article data
	Map mapFamily=_Map.getMap("FamilyArticle[]"); // a copy of the article data with the given thickness of the panel. this is to speed up the search.
	Map mapFamilyMatch;
	String sArticles[0];
	double dFamilyThickness = mapFamily.getDouble("Thickness"); // thickness used to distinguish if full data needs to be read
	int bSetFamily = abs(dFamilyThickness - dZ) > dEps || mapFamily.length()<2;

	Map mapData = mapFamily;
	if (mapChildData.length()>0)
	{ 
		mapData = mapChildData;
	}
	else if (bSetFamily )//|| bDebug  // use initially all articles, on second run use only articles with corresponding thickness
	{ 
		if (bDebug)reportMessage(TN("|Reading full article data|"));	
		mapFamily = Map();
		mapData = mapArticles;
		
	// trigger grain direction to be updated
		for (int i=0;i<tents.length();i++) 
		{ 
			TslInst t= (TslInst)tents[i]; 
			if (t.bIsValid() && t.scriptName().find("graindirection",0,false)>-1 && t!=_ThisInst)
			{ 
				t.recalc();
				break;
			}
		}		
		
	}


	
	
// collect articles with matching thickness and quality	
	for (int id=0;id<mapData.length();id++) 
	{ 
		Map m = mapData.getMap(id);
		
	//region Validate required fields
		double d = m.getDouble(kThickness);
		if (abs(d - dZ) > dEps)
		{
			continue;
		}
		
		String quality1 = m.getString(kQuality1);
		String quality2 = m.getString(kQuality2);		
		if (quality1.length() < 1)quality1 = sDefaultSQ;
		if (quality2.length() < 1)quality2 = sDefaultSQ;
		if (quality1.length() < 1)
		{
			continue;
		}
		if (quality2.length() < 1)
		{
			continue;
		}

		String components = m.getString(kComponents);
		if (components.length()<1 || components.find(";",0, false)<0)
		{
			continue;
		}
		
		String sName  = m.getString(kName);
		
		
	//endregion 

		if (bSetFamily)
			mapFamily.appendMap("Article", m);


	//region Collect components
		double dThicknessComps[0];
		int nDirComps[0]; // same length as dThicknessComps, 1 = outer dir, 0 =  cross wise to outer
		int nIndexParallelGrains[0]; //indicating the first component which has a parallel neighbour
		{ 
			String tokens[] = components.tokenize(";");
		
		// validate content
			double dZComp;
			int bOk=true;
			int nDirComp=1;
			for (int i=0;i<tokens.length();i++) 
			{ 
				double d = tokens[i].atof();
				if (d<=0)
				{
					dZComp += d;
					dThicknessComps.append(d);
					nDirComps.append(nDirComp);
				}
				else
				{ 
					String subTokens[] = tokens[i].tokenize("-");
					if (subTokens.length()>1)
						nIndexParallelGrains.append(dThicknessComps.length());
					for (int j=0;j<subTokens.length();j++) 
					{ 
						double d = subTokens[j].atof();
						if (d>0)
						{
							dZComp += d;
							dThicknessComps.append(d);
							nDirComps.append(nDirComp);
						}
						else
						{
							bOk = false;
							break;
						}
					}//next j
					if (subTokens.length() < 1)
						bOk = false;
				}
				nDirComp =! nDirComp;
			}//next i	
			
		// HSB-17414 accept minor tolerances, i.e. if components of thickness 100 are defined as 3x 33.3	
			if (abs(dZ - dZComp)>dEps)
			{
				double d = dZ - dZComp;
				if (abs(d)<2*dEps)
					dZComp += d;
			}
			
			
			if (bOk && abs(dZ-dZComp)>dEps)
			{ 
				reportNotice(TN("|The components of the style description do not match style thickness.|"));
				bOk = false;
			}
			
			if (!bOk)
			{ 
				dThicknessComps.setLength(0);
				nDirComps.setLength(0);	
				nIndexParallelGrains.setLength(0);	
			}			
		}	
	//endregion 

	// Validate optional amount of specified components of style name
		if (nNumComponent>0 && dThicknessComps.length()!=nNumComponent)
		{ 
				continue;
		}
	// Validate optional specified parallel components of style name
		if (bIsParallelStyleName && nIndexParallelGrains.length()<2 ) 
		{ 
				continue;
		}
	// Validate optional specified parallel components of style name	
		if (!bIsParallelStyleName && nIndexParallelGrains.length()>0)  
		{ 
			if (nIndexParallelGrains.length()==1)
			{
				if (nIndexParallelGrains[0]>0 && nIndexParallelGrains[0]<dThicknessComps.length()-2)
					; // accept middle double components on xxxs style names, i.e. 300s
				else
					continue;
			}
				
			else
				continue;
		}		
		
	// Validate quality match	
		int n1 = qualities.findNoCase(quality1 ,- 1);
		int n2 = qualities.findNoCase(quality2 ,- 1);	
		String article = sName.length() > 0 ? sName : components;
		
		if (sArticles.findNoCase(article ,- 1) <0 && 
			n1>-1 && n2>-1 && 
			(n1!=n2 || qualities[0]==qualities[1])) 
		{ 
			sArticles.append(article);
			mapFamilyMatch.appendMap("Article", m); // collect articles which match qualities and thickness
		} 
	}//next i
	
	if (bSetFamily)
	{ 
		mapFamily.setDouble(kThickness, dZ);
		_Map.setMap("FamilyArticle[]", mapFamily);
	}
//endregion 

//region Properties
	String sArticleName=T("|Article|");	
	PropString sArticle(nStringIndex++, sArticles, sArticleName);	
	sArticle.setDescription(T("|Defines the Article|"));
	sArticle.setCategory(category);
	int nArticle = sArticles.find(sArticle);
	if (nArticle < 0)
	{
		if (sArticles.length() > 0)
		{ 
			nArticle = 0;
			sArticle.set(sArticles[nArticle]);			
		}
		else
		{ 
			sArticle.set("");
			sArticle.setReadOnly(true);		
		}
	}
	
//endregion 

//region Trigger associated articleManager of master if present // HSB-17414 article collection derived from associated panels if in masterpanel mode
	if (_kNameLastChangedProp==sArticleName && sip.bIsValid())
	{ 
		Entity ents[] = Group().collectEntities(true, ChildPanel(),_kModelSpace);
		for (int i=0;i<ents.length();i++) 
		{ 
			ChildPanel c = (ChildPanel)ents[i];
			if (c.bIsValid() && c.sipEntity() == sip)
			{ 
				MasterPanel master = c.getMasterPanel();
				if (master.bIsValid())
				{ 
					TslInst tents[] = master.tslInstAttached();
					for (int j=0;j<tents.length();j++) 
					{ 
						if (tents[j].scriptName()==scriptName())
						{
							tents[j].recalc();
							
						}
						 
					}//next j
					
					//reportMessage("\nmaster found " + tents.length());
					break;
				}		
			} 
		}//next i		
	}
//endregion 


//region Display and export	to subMapX
	if (sArticles.length()>0)
	{ 
	// get article from map
		Map mapArticle;
		for (int i=0;i<mapFamilyMatch.length();i++) 
		{ 
			Map m= mapFamilyMatch.getMap(i); 
			String name = m.getString("Name");
			String componentDescription = m.getString(kComponents);
			if (name==sArticle || componentDescription==sArticle)
			{ 
				mapArticle = m;
				break;
			}
		}//next i
		
		String quality1 = mapArticle.getString(kQuality1);
		String quality2 = mapArticle.getString(kQuality2);

		String components = mapArticle.getString(kComponents);
		String componentDescription = mapArticle.getString(kComponents);
		String componentAlignedDescription=componentDescription;
		String description = mapArticle.getString("Description");
		String sGrade = mapArticle.getString("Grade");
		String sMaterial = mapArticle.getString("Material");
		
		
	//region revert componnent description	
		int bRevert = quality1 == qualities[1] && quality2 == qualities[0] && qualities[0] != qualities[1];
		if (bRevert)
		{ 
			String tokens[] = components.tokenize(";");
			String reverted;
			for (int i=tokens.length()-1; i>=0 ; i--) 
				reverted+=(reverted.length()>0?";":"")+tokens[i]; 
			components = reverted;
			
			reverted = "";
			tokens = sGrade.tokenize(";");
			for (int i=tokens.length()-1; i>=0 ; i--) 
				reverted+=(reverted.length()>0?";":"")+tokens[i]; 
			sGrade = reverted;

			reverted = "";
			tokens = sMaterial.tokenize(";");
			for (int i=tokens.length()-1; i>=0 ; i--) 
				reverted+=(reverted.length()>0?";":"")+tokens[i]; 
			sMaterial = reverted;

			reverted = "";
			tokens = description.tokenize(";");
			for (int i=tokens.length()-1; i>=0 ; i--) 
				reverted+=(reverted.length()>0?";":"")+tokens[i]; 
			description = reverted;
		}
	//endregion

	//region Collect component thicknesses and parallel component sets			
		double dThicknessComps[0];
		int nDirComps[0]; // same length as dThicknessComps, 1 = outer dir, 0 =  cross wise to outer
		int nIndexParallelGrains[0]; //indicating the first component which has a parallel neighbour
		{ 
			String tokens[] = components.tokenize(";");
		
		// validate content
			double dZComp;
			int nDirComp=1;
			for (int i=0;i<tokens.length();i++) 
			{ 
				double d = tokens[i].atof();
				if (d<=0)
				{
					dZComp += d;
					dThicknessComps.append(d);
					nDirComps.append(nDirComp);
				}
				else
				{ 
					String subTokens[] = tokens[i].tokenize("-");
					if (subTokens.length()>1)
						nIndexParallelGrains.append(dThicknessComps.length());
					for (int j=0;j<subTokens.length();j++) 
					{ 
						double d = subTokens[j].atof();
						if (d>0)
						{
							dZComp += d;
							dThicknessComps.append(d);
							nDirComps.append(nDirComp);
						}
						else
						{
							break;
						}
					}//next j
				}
				nDirComp =! nDirComp;
			}//next i	
		}
	//endregion 
	
	//region Collect material, grade and description of each component if defined
		String sDescComps[0], sGradeComps[0], sMaterialComps[0];
		for (int j=0;j<3;j++) 
		{ 
			String tokens[0];
			if (j == 0)tokens = description.tokenize("; ");
			else if (j == 1)tokens = sGrade.tokenize("; ");
			else if (j == 2)tokens = sMaterial.tokenize("; ");
			
			if (tokens.length()!=dThicknessComps.length()) // invalid
			{ 
				continue;
			}
			
			if (j==0)sDescComps = tokens;
			else if (j==1)sGradeComps = tokens;
			else if (j==2)sMaterialComps = tokens;
		}//next j
		
	//endregion 

	// Display
		Display dpX(3),dpY(3), dpModel(3);
		int nTransparency = sip.bIsValid() ? 70 : 0;
		dpX.transparency(nTransparency);
		dpX.addViewDirection(vecX);
		dpX.addViewDirection(-vecX);
		
		dpY.transparency(nTransparency);
		dpY.addViewDirection(vecY);
		dpY.addViewDirection(-vecY);		
		
		dpModel.transparency(nTransparency);
		dpModel.addHideDirection(vecX);
		dpModel.addHideDirection(-vecX);
		dpModel.addHideDirection(vecY);
		dpModel.addHideDirection(-vecY);
		
		double textHeight = U(100);
		dpModel.textHeight(textHeight);
		
		if (bDebug)
		{ 
			String text = componentDescription + "\\P"+componentAlignedDescription + "\\P Q1/2 " + quality1 + " " + quality2 + "\\P"+
				"QP1/2 " + qualities[0] + " " +qualities[1];
			dpModel.draw(text, _Pt0, _XW, _YW, 0, 0, _kDeviceX);
		}
			
	// draw leader	
		Point3d ptL1 = ppShape.closestPointTo(_Pt0);
		if (ppShape.pointInProfile(_Pt0)==_kPointOutsideProfile && (ptL1-_Pt0).length()>textHeight)
		{ 
			Vector3d vec = .5 * textHeight * (vecX + vecY);
			PLine rec; rec.createRectangle(LineSeg(_Pt0-vec, _Pt0+vec), vecX, vecY);
			rec.vis(2);
			Point3d ptL2 = rec.closestPointTo(ptL1);
			dpModel.draw(PLine(ptL1, ptL2));
		}

	// Draw Grain images
		String imageNameC = "C-Grain";
		String imageNameL = "L-Grain";
		String imageName = imageNameL;
		String imageXName = imageNameC;
		double f = textHeight / dZ;
		double xFactor = master.bIsValid() ? 2 : 1;
		Point3d pt1 = _Pt0 + vecY * .5 * textHeight;
		Point3d pt2 = _Pt0 + vecZ * .5 * dZ;

		int bSwapColor = true;
		for (int i=0;i<dThicknessComps.length();i++) 
		{ 
			double d = dThicknessComps[i]*f; 
			PlaneProfile pp;
			pp.createRectangle(LineSeg(pt1 - vecX * .5 * textHeight, pt1 + vecX * (xFactor-.5) * textHeight - vecY * d), vecX, vecY);

			String image = TslScript(bDebug?"hsbCLT-ArticleManager":scriptName()).subMapX("Resource[]\\Image[]\\"+imageName).getString("Encoding");
			String imageX = TslScript(bDebug?"hsbCLT-ArticleManager":scriptName()).subMapX("Resource[]\\Image[]\\"+imageXName).getString("Encoding");
			if (image.length() == 0)
			{ 
			   reportMessage("\nAdd image '"+imageNameL + "' to the resouces of the tsl.");
			
			}
			double dSizeInX = textHeight*xFactor;
			double dSizeInY = d;
			

			double dHOverW = imageX.encodedImageHeightOverWidth();
			
			double dSizeInX2 = textHeight*xFactor;
			double dSizeInY2 = dThicknessComps[i];
			
			dpModel.color(bSwapColor?43:252);			
			dpModel.draw(pp);
			dpModel.drawImage(image, pt1 - vecX * .5 * textHeight, vecX, vecY, 1, -1, dSizeInX, dSizeInY); 
			

			dpX.drawImage(imageX, pt2 - vecY * .5 * textHeight, vecY, vecZ, 1, -1, dSizeInX2, dSizeInY2); 
			dpY.drawImage(image, pt2 - vecX * .5 * textHeight, vecX, vecZ, 1, -1, dSizeInX2, dSizeInY2); 


			bSwapColor = !bSwapColor;	
			
			int bNextSameDir;
			if(nIndexParallelGrains.length()>0)
			{
				int n = nIndexParallelGrains.find(i);
				if (n>-1 && nIndexParallelGrains[n]==i)
					bNextSameDir = true;
			}
			
			if (bNextSameDir)
			{ 
				;// keep images
			}
			else
			{ 
				imageName = imageName == imageNameL ? imageNameC : imageNameL;
				imageXName = imageXName == imageNameL ? imageNameC : imageNameL;	
			}
			
			
			
			
			
			pt1-=vecY*d;
			pt2-=vecZ*dThicknessComps[i];
		}//next i			

	// submapX
		Map mapX = mapArticle;
		
	// append additional fields
		if (!mapX.hasInt("NumComponents"))
			mapX.setInt("NumComponents", dThicknessComps.length());		

		for (int i = 0; i < dThicknessComps.length(); i++)
		{
			Map m;
			m.setInt("Index" , i+1);
			m.setDouble("Thickness" , dThicknessComps[i]);
			
			if (sDescComps.length()>i)m.setString("Description" , sDescComps[i]);
			if (sGradeComps.length()>i)m.setString("Grade" , sGradeComps[i]);
			if (sMaterialComps.length()>i)m.setString("Material" , sMaterialComps[i]);
			m.setMapKey((i + 1));
			mapX.setMap("Component"+(i+1), m);
		}	


		
		mapX.setEntity("Originator", _ThisInst);

	
		
		
		
//		mapX.setString("ComponentDescription",componentDescription);
//		mapX.setString("ComponentDescriptionAligned",componentAlignedDescription);
//		mapX.setInt("Layer",numLayer);	
//		mapX.setString("Quality 1",quality1);	
//		mapX.setString("Quality 2",quality2);
//		mapX.setString("Description",description);

//		String Xcomponents[] = componentDescription.tokenize("-");
//		String materials[] = sMaterial.tokenize("-");
//		String grades[] = sGrade.tokenize("-");
//		
//		String alignment = "x"; // sets the orientation of the layer
//		int bKeepAlignment;
//		for (int i=0;i<Xcomponents.length();i++) 
//		{ 
//			String value = Xcomponents[i].trimLeft().trimRight(); 
//			if (value.left(1)=="(")
//			{
//				value = value.right(value.length() - 1);
//				bKeepAlignment = true;
//			}
//
//			if (value.right(1)==")")
//			{
//				value = value.left(value.length() - 1);	
//				bKeepAlignment = false;
//			}
//
//
//			double d = value.atof();
//			String material = materials.length() > 0 ? materials.first():"";
//			if (materials.length()== Xcomponents.length())
//				material = materials[i];
//			String grade = grades.length() > 0 ? grades.first():"";
//			if (grades.length()== Xcomponents.length())
//				grade = grades[i];
//				
//			
//			Map m;
//			m.setDouble("Thickness", d,_kLength );
//			m.setString("Grade", grade );
//			m.setString("Material", material);
//			m.setString("Alignment", alignment);
//			m.setInt("Index", i);
//			m.setMapName("Component" + i);
//			
//			if (!bKeepAlignment)
//				alignment = alignment == "x" ? "y" : "x";				
//			
//			mapX.appendMap("Component" + i, m);
//
//		}//next i
		
		entDefine.setSubMapX("CLT_ArticleData", mapX);
		
		if (_kNameLastChangedProp==sArticleName) // HSB-13387 make sure associated panel and tsl's are updated
		{
			entDefine.transformBy(Vector3d(0,0,0));
		}	
			
		if (sip.bIsValid())
		{
			sip.setSubMapX("CLT_ArticleData", mapX);
			
			// HSB-15029 write to masterpanel
			Entity entsChilds[] = Group().collectEntities(true, ChildPanel(), _kModelSpace );
			for (int ic=0;ic<entsChilds.length();ic++) 
			{ 
				ChildPanel childI = (ChildPanel)entsChilds[ic]; 
				if (!childI.bIsValid())continue;
				Sip sipI = childI.sipEntity();
				if (sipI != sip)continue;
				MasterPanel mpI = childI.getMasterPanel();
				mpI.setSubMapX("CLT_ArticleData", mapArticle);
				break;
			}//next ic
			
			
		}
	}
	// error display
	else 
	{ 
		Display dp(1);
		dp.draw(PlaneProfile(plEnvelope), _kDrawFilled, 50);
		dp.textHeight(U(100));
		String text;
		if (mapArticles.length()<1)
			text = T("|No article definitions found.|") + "\\P" + T("|Please use context command\\Pto import definitions from an excel file.|");
		else
		{
			text = T("|Could not find matching data|");
			text += "\n" + styleName;
			text += "\n" + T("|Thickness| ") + dZ;
			text += "\n" + sqBot.entryName() + " " + sqTop.entryName();
			
		}
		dp.draw(text, _Pt0, _XW, _YW, 0, 0, _kDeviceX);
		sip.removeSubMapX("CLT-ArticleData");	
	}
//endregion 

//region Trigger

//region Trigger ImportExcel
	String sTriggerImportExcel = T("|Import Excel Articles|");
	addRecalcTrigger(_kContext, sTriggerImportExcel );
	if (_bOnRecalc && _kExecuteKey==sTriggerImportExcel)
	{
		_Map.removeAt("FamilyArticle[]", true); // make sure the buffered entrties for the correspoonding thickness are written again
		
		int nVersionNumber = GetHsbVersionNumber();
		String strAssemblyPath = _kPathHsbInstall + "\\Utilities\\hsbExcelToMap\\hsbExcelToMap"+ (nVersionNumber>=28?".dll":".exe");
		String strType = "hsbCad.hsbExcelToMap.HsbCadIO";
		String strFunction = "ExcelToMap";
		
		Map mapIn, mapOut;	
		mapIn.setString("LastAccessedFilePath", _Map.getString("LastAccessedFilePath"));
		mapOut = callDotNetFunction2( strAssemblyPath, strType, strFunction , mapIn);
		String filepath = mapOut.getString("LastAccessedFilePath");
		if (filepath != "")
			_Map.setString("LastAccessedFilePath",filepath);
	
	//region Find sheet matching the required data
		Map mapSheets = mapOut.getMap("Sheets");
		Map mapArticles;
		for (int i=0;i<mapSheets.length();i++) 
		{ 
			Map m = mapSheets.getMap(i).getMap(0);
			if (m.hasDouble(kThickness) && m.hasString(kQuality1)  && m.hasString(kQuality2) && m.hasString(kComponents)) //
			{ 
				mapArticles = mapSheets.getMap(i);
			}
		}//next i
		
		if (mapArticles.length()>0)
		{ 
			mapSetting.setMap("Article[]", mapArticles);
			if (mo.bIsValid())
				mo.setMap(mapSetting);
			else
				mo.dbCreate(mapSetting);
		}
		else
		{ 
			reportMessage("\n"+scriptName()+" "+T("|Import not successful|"));
			reportMessage("\n"+scriptName()+" "+T("|Required fields are|"));
			reportMessage("\n"+scriptName()+" "+"Thickness, Quality 1, Quality 2, Components");
		}

	//endregion 

		setExecutionLoops(2);
		return;
	}//endregion	

//region Trigger ExportSettings
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
	}//endregion 
	
//endregion 	










#End
#BeginThumbnail








#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="Resource[]">
    <lst nm="IMAGE[]">
      <lst nm="C-GRAIN">
        <str nm="DESCRIPTION" vl="" />
        <str nm="ENCODING" vl="M_]C_X``02D9)1@`!`0$`8`!@``#_VP!#``@&amp;!@&lt;&amp;!0@'!P&lt;)&quot;0@*#!0-#`L+&#xD;&#xA;M#!D2$P\4'1H?'AT:'!P@)&quot;XG(&quot;(L(QP&lt;*#&lt;I+#`Q-#0T'R&lt;Y/3@R/&quot;XS-#+_&#xD;&#xA;MVP!#`0D)&quot;0P+#!@-#1@R(1PA,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R&#xD;&#xA;M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1&quot;`#&gt;&quot;IX#`2(``A$!`Q$!_\0`&#xD;&#xA;M'P```04!`0$!`0$```````````$&quot;`P0%!@&lt;(&quot;0H+_\0`M1```@$#`P($`P4%&#xD;&#xA;M!`0```%]`0(#``01!1(A,4$&amp;$U%A!R)Q%#*!D:$((T*QP152T?`D,V)R@@D*&#xD;&#xA;M%A&lt;8&amp;1HE)B&lt;H*2HT-38W.#DZ0T1%1D=(24I35%565UA96F-D969G:&amp;EJ&lt;W1U&#xD;&#xA;M=G=X&gt;7J#A(6&amp;AXB)BI*3E)66EYB9FJ*CI*6FIZBIJK*SM+6VM[BYNL+#Q,7&amp;&#xD;&#xA;MQ\C)RM+3U-76U]C9VN'BX^3EYN?HZ&gt;KQ\O/T]?;W^/GZ_\0`'P$``P$!`0$!&#xD;&#xA;M`0$!`0````````$&quot;`P0%!@&lt;(&quot;0H+_\0`M1$``@$&quot;!`0#!`&lt;%!`0``0)W``$&quot;&#xD;&#xA;M`Q$$!2$Q!A)!40=A&lt;1,B,H$(%$*1H;'!&quot;2,S4O`58G+1&quot;A8D-.$E\1&lt;8&amp;1HF&#xD;&#xA;M)R@I*C4V-S@Y.D-$149'2$E*4U155E=865IC9&amp;5F9VAI:G-T=79W&gt;'EZ@H.$&#xD;&#xA;MA8:'B(F*DI.4E9:7F)F:HJ.DI::GJ*FJLK.TM;:WN+FZPL/$Q&lt;;'R,G*TM/4&#xD;&#xA;MU=;7V-G:XN/DY&gt;;GZ.GJ\O/T]?;W^/GZ_]H`#`,!``(1`Q$`/P#N+')TFU_W&#xD;&#xA;M!3)YQ$IYJ%;U+?2+89_@%9$UTUR_'2O';U/52T'SW1E?:.]36]M@;C1;V6?G&#xD;&#xA;M-7MN%P*`$6,=J=LP:=&amp;&quot;#BI&lt;&lt;TQ7$04II0,4[&amp;:JPB,5(!1MQ2]*`%`(H.%&amp;&#xD;&#xA;M&gt;U(\R(O)K(O=4&quot;1LBGK4MC2&amp;:I?A044UAQQO/+N)-&quot;K)&lt;S;CG&amp;:U(;?;VI%(&#xD;&#xA;M6&amp;W5%%6XUI@4BK42\4[`V*%I&gt;E./RTSJ:9+8\4[;0@J4&quot;F(:JU,,4@HVY/%,&#xD;&#xA;M=A'SVI`P49-.E=8DRQK$O=2'(0U+8TBUJ6H)%`=K&lt;UR4EU)&lt;SD9.*?&lt;/-&lt;.1&#xD;&#xA;MSBK-G9%3N85FQDUM9@@$U=^S;&lt;$&quot;I(8^U7,&lt;8Q22'&lt;J#IC%,:+/:K?D\U-Y0&#xD;&#xA;MQ56%&lt;S4B.[I5M801TJ&lt;0BG8`HL*Y5:W&amp;*B$.#6AC/%-&gt;/`IV&quot;Y4,&amp;135!0XJ&#xD;&#xA;M&lt;N1QBHG]:+#N/X(IC#TI-V*&lt;IR*EC'(&lt;59CYJKWJU%3B2T38IP%)E0,DU0O=&#xD;&#xA;M22%2`13;!(GN;I(EZBL&gt;YU4CA35&amp;6[&gt;Y?CO2Q6+N&lt;G-0F58?$7N9,G-:]M$5&#xD;&#xA;M&amp;#4=I:^6&gt;E:,&lt;?-42,$?M4P4\8J3:`*`&lt;50A&amp;.$J!)/GJT5W+57RP&amp;H$2N`P&#xD;&#xA;MI(X\&lt;TH'%2ITQ2&amp;5IV(&amp;!38LD=*L/&amp;&amp;:E50O%`%&gt;-F$AJTIS1L7K3&gt;E.PA76&#xD;&#xA;MH^:FW&lt;4W@BG8&quot;(MCFI4D#K4,BYJ(;E;BAH9:SM:J\XW&lt;U(`Q&amp;&lt;4[`QS2`AB;&#xD;&#xA;M:,5,'-,**#G-.$L2]6J0'[CZ4E1/&gt;0KT&lt;57?4(^S&quot;A#L7`W-.^7.&lt;UCR:AM4&#xD;&#xA;ME3FLR75[@28&quot;G%,=CJ'G51UJL]U$1@L!6(+V&gt;9.5-5629W[T!8Z1+F)&gt;=XID&#xD;&#xA;M^K1J,!A61%9NR\DU#)IS;_O&amp;I`T&amp;UG:&gt;*:VN-C[M4$T\Y[U/_9XQS18&quot;W::R&#xD;&#xA;M\K$%:DN+HGD&quot;H+&gt;R5#5X6JL.:=@,Q[V4=`:B.H7)X&quot;&amp;M-[0`9`J-!MXVBBP%&#xD;&#xA;M!;J=FY4U;W2/'QFK'E;AG;3D&amp;WC%%@,IXI&lt;\L:C5I8V^\36O(I8]*IRQ;&gt;&lt;4&#xD;&#xA;M`0^;(_K4HA+CER*:G)P:LF,A&lt;B@&gt;A1FM6SD.33$4C@FM&amp;)2V0PJ*:V^&lt;%:+#&#xD;&#xA;M%AMO,')J4VRIWI\`(7&amp;*5D;=3L(A^QAS3UM%0U:B%#`EZ=A#%5$[&quot;I@%(Z&quot;H&#xD;&#xA;MS'3T6@0UH%/:F,@7M5L+Q410L&gt;E,1&amp;@0C[HI&quot;%#?=%/&quot;8IWEY-%@&amp;84CI4;6&#xD;&#xA;MZ'L*G*GI2;*+`5_*5&gt;@%*(P:E&gt;/CBF*&quot;#TH&quot;XA0#M0;99%]*F&quot;CO3@O%`7,V&#xD;&#xA;M6P`/6HOL7H:U'%,&quot;\T6'&lt;HI9,.=YIQ20+@$FKV!3E`]*+!&lt;PY&amp;F1\C-6(KV&lt;&#xD;&#xA;M+]TFM&amp;2%7/2FB(1CH*+!&lt;A%ZX3)7FD746S@BI'C#]JA-NM*P%I-1'&gt;K*74&lt;@&#xD;&#xA;MY85C26W'!JN4DC/&amp;:5@.A+(QX-3J`!P:YE+F1/6K4&gt;I.IYH$;9&amp;#3&amp;ZU1755&#xD;&#xA;M;C(J=+I6&amp;&lt;BF!,S'R]N*2*,#GO3EFC;@D4OR[OE-`&quot;[&lt;M3&quot;F34K'&quot;TBD&amp;D`F&#xD;&#xA;M`JTB,,TYQQ42C#50B9A497-2=J8#S3`;MH&quot;U*&lt;4&lt;$4&quot;(\4GX4X#YJ=WI@1&amp;+&#xD;&#xA;M&lt;*:%V\&amp;IR*8RC%(95GMED[53&gt;R`Z5J`]:9L%`S%:V93D$TZ.:6,XYK3&gt;,D]*&#xD;&#xA;M8(`&gt;HI#&amp;QW1QDBK,=XNWDU`UL#T-4KB-TX&amp;:!&amp;Q]I1_XA4HP5X-&lt;NKS(^&gt;:N&#xD;&#xA;MQ:FR':U`&amp;V#S3^U9T-Z'.&lt;U=CG5N]`&quot;D\T4IVGO3&lt;&quot;@`P*3%.Q24`-Q28I]-&#xD;&#xA;MH`C(I2V%QBG@4I4&amp;J`@7KS0\2,.@J9DP*@W!3R:0%&quot;XT\29(XJDL&lt;MLW&amp;2*W&#xD;&#xA;MQL&lt;=:9(@(P`*0S,349$ZK5V#44?AR`:C&gt;T&amp;.E9T]B0=ZDY%`'1H4?D-FG%1T&#xD;&#xA;MKG+&gt;\D@X;M6G;Z@KGDBF(MMD=JC,&gt;&gt;:LB6.1&gt;#S32I]*!%4QBHB,=JM,AS3&quot;&#xD;&#xA;ME*P%*&gt;$.O2LB&gt;S^;I70X%1R0*PI#.8:!HSD5:MKN2,@$FK\UISTJI)!CH*8S&#xD;&#xA;M3@OU(^8BKT&lt;\;?Q&quot;N4=9%/&amp;:5+F:(]Z`.QPK#BD*BL&quot;UU&lt;@A6-;$-RDR]:!&quot;&#xD;&#xA;MM`&amp;IJV^TU/GTIX7UI`0]!BF^6''-2R8SQ4:D@XI@5I;&lt;`8K-EAD5\KG%;D@S&#xD;&#xA;M48C&amp;.128S)CNGCX;-:45R'CZU!/:!SD56V/#T!J1DLKE9,BM&amp;UG^49-8RS`O&#xD;&#xA;MACBKZXV`J:`--XDF'6J%QI:,#BFBY&gt;/K3XKY6;#&amp;E&lt;+&amp;1)9RV\GR@XJW;W11&#xD;&#xA;M&lt;-Q6_%%#&lt;1Y.,UC:C8E)?D''M3N!;BG61,9ICP!VZ5B^=);-R#6Q8W2S*-QI&#xD;&#xA;MV`IW%BR?,M0K&lt;M#P1TK=?:&gt;O2LZYLEESMZT`)!=&gt;9QNJTK;1FN&gt;=9;27@'&amp;:&#xD;&#xA;MT([TO'AN*0%]I]QXJ:)\BJ-N0V235M&lt;`\4`38SUJM-$DAV\&lt;U.TA`Q46W)W4&#xD;&#xA;M@,R?3&lt;'(JI%$T4_?%=&quot;2&quot;O-1/;(ZY'6BPR%`K)R:C:3RCQ33')&amp;V,'%0SL`O&#xD;&#xA;M7FG8#0A&quot;R]34LMDK+P*YQ-1&gt;&amp;3':N@L=1CF4!F&amp;:0C*NK#8215-)7A?'.*ZB&#xD;&#xA;MYB21&lt;KS6-&lt;6N%/%-`6+:Y610&quot;:F=.XK`C=X)&gt;^*UX;L.F&quot;:M&quot;'D5&amp;PP*L*H;&#xD;&#xA;MFF3+QQ2D&quot;,Z\4NF!5*UMV\PYK5\O=UIZQI&amp;,USR1:0L4(P.*MJJQC-4C=JO0&#xD;&#xA;MU&quot;UTS]*SV*+\MX%X%53*TIJN%9SS5^VA]:T3)9!]C+'-7((?+%6E08Z4I`K1&#xD;&#xA;M$W%5B5Q3^U,4@4QYQG&amp;:8@&gt;3%0&gt;9N-(YS4'(:@=B22(-48AVU.OO4H7(IV&quot;Y&#xD;&#xA;M`GH:L(HIOE&lt;U(@YHL*XNWFJ]S((ESFK+L%%8&gt;JS-L.*3!$&lt;MRLS%:K&amp;UR&lt;@5&#xD;&#xA;M2@D_&gt;9)K&lt;M=K@5%C0;:(8^U:J'(J,0#&amp;13U4BM$B&amp;6$;BF2OA:!Q3)_]6:0(&#xD;&#xA;MS9KG]]MS4R+N7=61/N^U9%;%HV8P#0,&gt;!@5(G-*R_+0E4(E%)*WR&amp;BH+E]L9&#xD;&#xA;MH8T9%U=?O=N:T;##+DUS\J,]QGWK?L050&quot;D#-%5%28&amp;*2/&amp;*=BG8@8&gt;*K3/5&#xD;&#xA;MB0X%5BNXT6`9'DM5KHM-C0&quot;HYI=O%!1GWHR:2S&amp;&amp;YI[_`+PU+!#@YI6&amp;7TZ&quot;&#xD;&#xA;MG]J1!@4ZCE)97G.(C52'D58NCGBHH4P*+`BP!A*E!_=TP=,4OM18;%7O6+J6&#xD;&#xA;M6;`K&lt;882L:X&amp;Z3\:5@(K&quot;WYR:V$7:*@M$`6K5-(!^[B@=*:HIXIV$)4,N,5,&#xD;&#xA;M_P!W-4)I?FQ18&quot;,QY:K,2A144?/-3JM.PQX`)I3\M&quot;C%#\BE8&quot;.64!#FLF23&#xD;&#xA;M?)Q5B\DXP#5&gt;UB+-DTK`7((\8K00C%01I4X7%,ECQ1WI,XI#3$/S1FFBDSS0&#xD;&#xA;M4A]1.U/S44I`4\T@*\EQMJE&lt;2&amp;0=:;/)\U,7YJ5AD2(0V&lt;U&lt;C5B*(HLGI5U(&#xD;&#xA;MPJTK`,C0U.JXIH.*=FJ2$+TIN0W%!!-/6+O3L(:L0)J95Q2JN*?CBAH+&quot;4[@&#xD;&#xA;M&quot;HV8#O566YQ4,=BQ*X`ZU1ED).!49N&quot;QI,YZU(6&amp;X.[-2&quot;4BD)&amp;*`A8T#L2J&#xD;&#xA;MQ&lt;U85,#-1PIMI\LP5:+CL*\H0=:R[JY.&lt;`TVZNB&gt;AJF&amp;+O0%B6+&lt;[=:V+5,#&#xD;&#xA;MFJUK;Y&amp;:OJNP520$I'-)BDW4X&amp;J2(8FVEV4X4\&quot;G8&quot;,)3ME/Q12:`9Y=+MXJ&#xD;&#xA;M3(%0R3*!UJ1BCIS3'=1WJO)=&lt;'!JC)&lt;L32*L7GE&amp;.M5);C`X-0&gt;8S&quot;F,C-4A&#xD;&#xA;M8D^TD]Z7S21UJOY1!J55-(=@\QLU(LIIOETNS%(=A3(?6@.&lt;]:`F:=Y=`6'!&#xD;&#xA;MSZT[&lt;:15I^V@0]&amp;-2@FH`*E4TQ,D%+30:&quot;::%8=FDS3&lt;THIA8-QHS0:2@8N3&#xD;&#xA;M2%C29H)XI&quot;L1O(0*J23D&amp;K+\FJDT&gt;:EC2'1W1]:G%SQUK/\`+(-.Y`I7'8T%&#xD;&#xA;MN_&gt;IDN`&gt;]8^6!IZ2E:$PL;/F#'6@2&gt;]9@N3BE^U$52D*QJAN*,UF&quot;]QWIRWP&#xD;&#xA;M]:KF&quot;QJ&quot;D(JBMX#WJQ'.&amp;[TKBL2YHH&amp;#3L5:%88&lt;TV9C]F7_`'JFVYI)XQ]F&#xD;&#xA;M7_&gt;IV%8Y@SR3V-LH[**U=-M?DRPJ+3[+_0+=B/X16M$FP8%.VHUL/`*\`&lt;5(&#xD;&#xA;M%H&amp;:D44TA-@%XS2T\&quot;D(IDB`&quot;G`4F,4N1BJ&amp;D*&gt;E5YY1&amp;I)J220(A)KFM5U(&#xD;&#xA;MEMB&amp;IDRDAFH:BS/MC.:K0PO&lt;?-)FFV]OO;&gt;U:2[5&amp;!68[#H(1&amp;G`JS'TID8)&#xD;&#xA;M%6%BQS5I`/5&lt;]:?]WI3&lt;XI.IJB&amp;Q^2U/5#0B5-@XH)$&quot;T\4Y%!'--(/6E&lt;:%&#xD;&#xA;M&quot;D]*;-,MNA+'%5KK4$M8R&lt;\BN1U+7I;ARBMP:AR-$:FH:KYK%(SFJ4%N\K9?&#xD;&#xA;M-5M.@:1@[UTD,:A1BFM1E&gt;&amp;Q`/2K)@VC`%64&amp;*5J=A$,:8J55]:55J94IV(;&#xD;&#xA;M$5&lt;T\KQ3@,4O6F(BI-IS4NT4H`-%@(U7!IVW-2;1VI,&amp;@:*DD&amp;3Q4;P_+6C@&#xD;&#xA;M=ZB=,]*0S&amp;F!!Q0CX'-79;;)SBL^\!B4XK.12)XW5FZU;\Q8UR37*I?M&amp;YYI&#xD;&#xA;M;G5RR8!YJ.:Q:1IZCJHC!&quot;M7.RW;W+\FH6,MPV3FI[&gt;V*GD5/-&lt;&amp;C1TZ'YA7&#xD;&#xA;M111C8.*S+&quot;(#%;2+@5&lt;40Q-H`J5&lt;XXI-M.'%:I$CMX[TUF(/%1'[U3``KS56&#xD;&#xA;M$2QD%:C&gt;/YLTB\&amp;I2W%(&quot;,#%*.M!H%(`)IF&gt;:&gt;W2HN&lt;T`2`TC9H4&amp;AF&quot;]:5Q&#xD;&#xA;M@*`,5$;A!WJM-J44?5J+CL76(J,R1H&lt;L:R'U4.&lt;(&gt;:K2S3R&gt;M%PL;S7\&quot;C!8&#xD;&#xA;M55EU2#^%QFL987?[V:D&amp;G*3DYI#L76OBX^4U1FEG9C@&amp;KD5LJC%65@4&lt;XI`9&#xD;&#xA;M$=O&lt;2'Y@:L?86QSFM13CC%2A=PZ52`RDLAWIWV!.M7V0@T!&lt;TPN016JA&gt;E!B&#xD;&#xA;M4-P*M@`)3-O-%A7&amp;*G'2FM$2&lt;XJRJFGA,T6&quot;Y2$&gt;#THV$GI5PQ4S9@T6%&lt;A$&#xD;&#xA;M&gt;#4X&amp;!3P@Q2,I[4PN-`R#4?D@M4RAL=*&lt;%;-`7(M@5&lt;4P*&quot;:M%,U&quot;PVM0%Q@&#xD;&#xA;M3YJCD@#'BIUY-.VG.12L%R@+'YLXJ&lt;0X&amp;&quot;*M*#W%(PHL!`8%'W:/)R*D!Q36&#xD;&#xA;ME&quot;=:`N-$.WM2B//:IXR)$R*BD9T/%%P%$.#1MP:8MS\V&amp;JQ\KKD4FQ$&gt;S&lt;.*&#xD;&#xA;M41[&gt;M1O,8C[5/%+'.,9YHN,3ITH4=:&amp;!0^U+D8XIW`A8&lt;TI'I4;O\V*G5?EY&#xD;&#xA;MI@-7GK2E`::W!XI5)S0(0IBC9Q4K=*8#0!7ER.E+&amp;Q(YJ1USUIPC`&amp;:0#3&amp;,&#xD;&#xA;M9J,H:F:5!@9IX`*Y%.XRL(Q2E0*&gt;!EL4Z2%EYQ0!$,BAU)%2*`100&gt;@I@5]A&#xD;&#xA;M%,*5:*'%,*4#*^P4TQ@CI5G8,4SG-(#,N(]AIBPAD.:O7&quot;JY%+Y`V&lt;&quot;D!F+;&#xD;&#xA;MIG.:LJZ*,*:;)&quot;R@@&quot;JFR16Z4!8L/)(#E,TL6H2QM\_%26ZL&gt;HI+BV5Z0[%Q&#xD;&#xA;M-25U&amp;6JPERA'!KG701&lt;&quot;IK=F-(+'2K(&amp;'6D`YK,BF&lt;#%.:\:/K5(+&amp;MCBH2&quot;&#xD;&#xA;M&amp;JE'J:,&lt;%JN1SQR#@T7)L2'D4U&lt;@T[Z4H'K1&lt;5A&lt;4F2*4YQD4`&lt;9/6J$&amp;,BF&#xD;&#xA;M$5+VII`I`1%:4+3C24QB&amp;HVJ;`--9*`N0TUXP_6G[2#2XH`@-JI'2J&lt;VGIU'&#xD;&#xA;M6M7M32N:+`9*6[)TS4RETZ9J_P&quot;6,5'L&amp;:+`56NY$ZT1ZDN&lt;$U8EMED6LJ?3&#xD;&#xA;MV1LJ#2L,W(KR-QRU3!E;I7+%;B,\`\5/'J,T1PU#`Z/%)BLR'5%8&lt;FK:72MW&#xD;&#xA;MI`3$GH*%!S2IAQQUIP5U--`!)Q@U4N(L\BK3&amp;E(4CFF!G0HRM5U1D4CH!TIR&#xD;&#xA;M*0.:!7(V7U%1-&amp;,=*LMR::1@&gt;]`7*$MBLBY[U0DM'A.5!K;RP%(5#CFD!SPU&#xD;&#xA;M&quot;&gt;W?!Z5KVNKI*H#L!5&gt;[L$?G%9TUFT0RF:!G3K/'(/E.:7;NKF8+F:$UJ6^I&#xD;&#xA;M#C&gt;:86+SQ$4S:&lt;5*MW!*!@TYE!/R]*`*C#/%0FW!YQ5YHN*AVMV%`7*36WM4&#xD;&#xA;M$EIN&amp;,5IE6[B@*.]`7.8N+-XVRH-)!&gt;SP-@YKI98$&lt;=*R+NRZX%`RW:ZJK8W&#xD;&#xA;M-6Q#&lt;I*O!KB3&quot;\;9YJQ;ZC)`P!/%(5CL&quot;H(S41R#Q5&amp;TU6.1&lt;,U:&quot;O&amp;ZY%`#&#xD;&#xA;M&quot;V.M.5@PYI3&amp;&amp;-($P&gt;*3&amp;AY1=M0/$'R,5++N5.*C@?+8:BP&amp;5&lt;6)W$BHH[IH&#xD;&#xA;M&amp;&quot;MTK?DC4CCO63=Z?O.X&quot;DQDY&gt;.:+(/.*S2D@?Y0::?-A..U6;:X7.'-0T!&lt;&#xD;&#xA;ML;F2/`:M3&gt;DR^]4U6*1&lt;I306B?VH0&quot;7=@)5/%99CDM#D`XK?6=6'/6F36RW&quot;&#xD;&#xA;M8Q6B`RX]0W@*QJ]#(I&amp;0&lt;UEW=@T/*#FH;2YECDP_`J0-B&gt;!)1\U4);,+RM:*&#xD;&#xA;MR)*@P&gt;:0BF@,N+S$ZBK&lt;=SM.&amp;-6?)5AQ52:T;.0*+&quot;+F\2#(I-QZ5064Q?*:&#xD;&#xA;ME68MS2&amp;7EC+&quot;FKF.3!Z407('!-+&lt;,&quot;N11&lt;9(0CBLZYLPV&lt;5+'(Y;%61TYI7&amp;&#xD;&#xA;M&lt;U&lt;V)!Z4R&quot;-H6R&quot;&gt;*Z&quot;:'S.U9=S&amp;T?04&quot;-*RNB^%8U?EMU=&lt;URL-TT3Y)Z5M&#xD;&#xA;MVNJQR1X9N:$!!=60R&lt;&quot;LYD&gt;$\&quot;NCRDT&gt;Y&gt;:SY[&lt;L&gt;15IDLJVUTV0#6B,2+FL&#xD;&#xA;M&gt;6/RCD5-;7F#@FF]0N69VV=*SY;ACQ6BY2120:RV3][^-83*3$CC9SFKT5OT&#xD;&#xA;MS4L$`V@BK03%8EC4@`J=%&quot;TF0HYH\^/'6J0FB?=@4UG%4I[L`8!J!+DL&gt;M6F&#xD;&#xA;M0T77DQ5!I6\PU9&quot;F04TVW.&lt;5:!$D+;AS3]M)$@6IPHJK#N,`IZGFEVT[9MY-&#xD;&#xA;M!-AXQTIDKK&amp;,DTQIU7O5&quot;ZF:3(%%PL.DN0[X!JK=Q&gt;9%5;+H^:OQ'S4P:0TC&#xD;&#xA;M`^SLLG2M&gt;QC(Q5EK,'M5B*`(*+%$Z=,5(%%0KD5,AXJB6#8JO.XV$9J:3@5E&#xD;&#xA;MW$V'Q2`@:'&lt;V&lt;5:ARHHA_&gt;+4QCVBA(9*&amp;!6I$%54/S5:3@50AQ&amp;*S;R0'C-:&#xD;&#xA;M$KX0UR]]=[9NO&gt;DQE^&amp;V#MFM.&quot;,**S=-G\P5K@8Q20F2CBG[@!48Z4US@9JD&#xD;&#xA;M2-E8DTL:YI@.\U/]Q,T,:&amp;M\HJA&lt;GTI\]WR1FJI?&gt;:EC(XW._%:MMR*I0P9;&#xD;&#xA;M-:42!13N(FQ@5&amp;QQ4A-5[@[5IW`JS2*9&lt;$U.@&amp;S(K(DD+7`-:D#$I2N!,/&gt;E&#xD;&#xA;M'6DQFGA&gt;*:$.;[GX5CS#][QZUI32;5JB!ODS0,L09&quot;BK*\U$BX45,HH`&lt;!2X&#xD;&#xA;MYH[49YH`CE.U#66YW25I7!^4BJ&quot;I\](&quot;&gt;-?EJ51S3%!`J04[C'CFF3L(TY-.&#xD;&#xA;M!QS5&amp;^D)&amp;*`*A/FR_C6E'&quot;J@8K-ME.[-::$XH`F48J45&amp;*D%!+#%)@4II*8!&#xD;&#xA;M24$^E)DFD-#9'&quot;C@U0EN-QP#3KUC&amp;O%8XE82'-(9&lt;D3=R*(4;=TI\)WBKJ18&#xD;&#xA;M&amp;:0Q\,8Q3WXXIN_;2&lt;L:H0@!)J8+Q2*AJ95IDC0M/![4=*8T@7F@9(&gt;*CDE`&#xD;&#xA;M'6JTEUVS48.^DQA+*3TJHQ+'FKGEBFM$!4,971*?BEQBG!&quot;:5@(QR:MPK3%A&#xD;&#xA;M.&gt;E6$4@4#0V0[169&lt;S]1FM&quot;Y.$-&lt;_/(3(14@+R[5&lt;M[8Y!(J.TCW$9K82(;:&#xD;&#xA;MI(0L(&quot;BI^M1*,5*E:)$W%&quot;TX+3L&quot;E%,0@%.%+2Y&amp;*`$S2$BHI)0*KM&lt;CUI-C&#xD;&#xA;M1--,%'6LN&gt;Y.&gt;#4LLF_O51HB34,8@&lt;M4@BS3HH&lt;59$=2.Y6$6*E5,G%3^70$&#xD;&#xA;MP&lt;T6&quot;Y$8O:FF/%6]I-(8O:GRA&lt;J[::PJWY7M1Y.&gt;U'*.Y44&amp;I@.*F\G':CR\&#xD;&#xA;M4&lt;H7(&lt;4M2;*-E'**XS%%2;:-E'**XU:&lt;12A&lt;4N*+&quot;N,Q3J,446&quot;XAIN:=2$4&#xD;&#xA;MK#N,)YH/2@BDHL%R)NM-ZU+MS3&quot;G-2T4B,H*85%3[&gt;*C9&gt;:FQ1%L%)Y=2[:4&#xD;&#xA;M&quot;E89!Y=,9*M[:8T=%A%%E-1$L*OF+VIC09[468%196!JW#=;&gt;IJ(VY]*:833&#xD;&#xA;M5Q&amp;K%=@]ZN),I[USZ!D.:F6Y([U:D)G0AU(ZT3G-LO\`O5DQ71/&gt;K$MU_HR\&#xD;&#xA;M_P`56I$V+-FO_$LML?W15M%&amp;*@L1_P`2RV_W!5D&quot;MK:F=PQ3A2[:4&quot;BP7'&quot;D&#xD;&#xA;MH%+2!`.&gt;*A;*DD]*=)*L0R:R;_4@%(4U+9:(-5O]J[4-8L&lt;;2R;FJ4!KF0EN&#xD;&#xA;M15U(@H&amp;!4WN4/C3&quot;X%2)&quot;=XS3X8R35L1]ZI(&amp;-1=M2A^*8&gt;*:`2:JQ#9,!FI&#xD;&#xA;M%04D:FIU6@D55IXH`XH-(+#2^SDU1N]3CBC89YINIWJ0QD9YQ7&amp;W5S+/*0&quot;&lt;&#xD;&#xA;M9J&amp;RTB&gt;]O9+MR%.14=MIH9MS&quot;IK.U(^\.36S%!M7%3N4,MH`N`!6BB%14&lt;:A&#xD;&#xA;M:MHN:T2L)L&lt;@.*?LS0,#BI!57);&amp;A,4\&quot;BE%*Y(4[%%&amp;:`#%+M`%`YI'R!3`&#xD;&#xA;M.*&quot;34&gt;[!R35.\OUB4X/-2V4D7_,5&gt;IJO)?1)GFN8N-3F=R$8U$/M,O4FH;*L&#xD;&#xA;M:]SK&quot;9(4UBWNH22\`THL96.3226++VJ6[E)&amp;7LE&lt;DFI([&lt;GEA6@EN0.12B+;&#xD;&#xA;M4V+N,@B4=JO10*2.*@0`&amp;KD.:FPFR_;1A,8K0'W:IV^&gt;*N`&lt;5M`S8X=*!24X&#xD;&#xA;M&quot;M2`&quot;9-/V\4HI:`&amp;X%--2;:85YI`&quot;FCJ:.U&amp;0!G-2V581@0,U7&gt;X2/J:K7U^&#xD;&#xA;M(U.#7,76H32.0K&amp;E&lt;+'4MJ&lt;2GK52]O\`&lt;G[LUST27$I!S6O!!E0'H'8II&lt;W#&#xD;&#xA;MO@DXJRUH\P!(JX+1!R!5A%VB@&quot;G;Z?&amp;@R1\U6/)4=JL8&amp;*0(Q:BP7(#&amp;!TIZ&#xD;&#xA;M*:M+!QS4BQ+Z5:B*Y5V&lt;\5(.!S5C8H/2HI8R1\M)H5Q4$9J9=H'%4%CE#5&lt;C&#xD;&#xA;M!`YI&quot;N$A7/-&quot;!304WFI4CQ5(&quot;)@,XI0BXITB_-28XH&amp;*-N*&lt;#5?D-4JYH$.)&#xD;&#xA;MI,4N**`&amp;T$\4['-.*`B@&quot;'S!4B-FF-&amp;*%(%`R;%59&lt;[JL*V31(@/-`$&quot;#'-2&#xD;&#xA;M%PHR:-N%I#&amp;77%(!P=33]H-9TQ&gt;+I3K&gt;X8G!-*X%ITQ5:6%GY%6B&lt;T&quot;BX$5H&#xD;&#xA;MK)P:LR(IZU'G::&amp;G&amp;:0%:2`%^*1F&gt;-&lt;&quot;IQ&lt;1A^:F\M)?FQQ2`JJ@EC^:FQQ-&#xD;&#xA;M`Y(Z5)&lt;@QI\E1Q2%AAJ8%E#YW%*$(SFH5?RSD5*)@]-`021D'=Z4])`RX%3,&#xD;&#xA;MN4-5HXRAI@28YYIX3GBHW/&amp;:DMVR.:`%8$&quot;F*.:L2`$57Z&amp;@0DP^48I4R4Q2&#xD;&#xA;MGD4Y0%%#`S[F)PP(J:*0A,&amp;IY&quot;'.*:\84&lt;5(RE-*\&lt;H*]*N1W7G+@]:KR%-I&#xD;&#xA;M#=:;;,JM1&lt;9=&quot;8ILDJQC)J=&amp;5^E175N64XII@1I.LAI[#TJE%&amp;T;\U?0@BJ$&#xD;&#xA;M18-)M&amp;#4IQFE*&lt;9I@9[0G?FIT'%2,*:@(I!&lt;8\0)Z5&amp;]JI.&lt;5:IP((H'&lt;I+$&#xD;&#xA;M%/2D&gt;+C-677GBHW!V8I!&lt;Q[J$YR*BA)4XK8\G&gt;.14368!R!2L%R&quot;.4#K4=VZ&#xD;&#xA;MLO%326C8XJK+:2T[!&lt;H8D#$BK$%S.IX-2)`P'-121NAXI,&quot;^NIR*?F-65U12&#xD;&#xA;MO)K'0`_&gt;%6!$C)P*0&amp;Q'J,93K4T=TC\YKG7B=4^6J_G7&quot;'AC5&quot;L=F)$(X-!K&#xD;&#xA;MD8M1G1L,QK5@U/*C)IH+&amp;J&gt;M'6J::E%T)J=+A&amp;Z&amp;F*Q8!&quot;TY&lt;/3-N\=:!F.D&#xD;&#xA;M(61,&quot;H:GWA^*:4Q3`8!1BG8I*`$Q2%%IXQWIVW-`R'&amp;.E,=-U3$8I`.:`*IM&#xD;&#xA;MP&gt;HJ&amp;33XVZBM!R!2*-U`S)_L]5/`ILL&lt;L0^6M9EP:0QJXY%2!CPW\L3_`#&amp;M&#xD;&#xA;M&quot;'54&lt;X8TV6Q0\XJ@]@ZME!3`WQ)'(N5-.&quot;DUSXFF@&amp;&quot;:GBU-MP&amp;33&amp;:^#GFG&#xD;&#xA;M$\5#%&lt;HX&amp;34QP1Q2)&amp;#`ZTAY.:1LYIR_=Q0!&amp;S#.*.HXJ.13NIZ9Q0`A3/6H&#xD;&#xA;MWMU&lt;8Q4Y!IN&quot;*0S/DLAZ55&gt;Q/85ME&lt;BHBAICN8H$D!S5RWU#LQJT]NKCD50G&#xD;&#xA;MLB#E!3$:T5RD@ZU*&lt;=17.&quot;26!NIJU'J8'#&amp;D%C7`W=:&amp;BXXJ&amp;VNXY*N!E;I0&#xD;&#xA;MA%78143Q!NHJ[(G'%5]IIA&lt;S)[('D&quot;LV:PW'@5T+C-1F)3T%!1S+0R0-\N:M&#xD;&#xA;M0:C)&amp;=I)K6&gt;R#C)%9\]AAL@4`78-44D!C6K#(LJY4UQTL$J'*U8LM3D@&lt;*Y-&#xD;&#xA;M`'6$%C@U!)%L.14=OJ,&lt;J@YYJTS+*G%(1&quot;DNXXJ=DRM4F0Q-FI8+L'AJ5@(K&#xD;&#xA;MBU5@&gt;.:Q+JWDCR5%=1E6JK&lt;P*_&amp;*+!&lt;PM/O9(FQ(:WDFBG3KS6+&gt;690Y45!;&#xD;&#xA;MRRPR&lt;DXHL4;SH4Y%&quot;WOECDTR&amp;Z65&lt;&amp;DEMO,&amp;5J;@7&quot;R7$&gt;3WJI-IH8%D%5O,&#xD;&#xA;M&gt;`[3VJ]:WP;Y6-`&amp;0WG6SD&lt;XJQ;WH8X8UKS6\4Z9P.:Q+FP&gt;-BR&quot;J`V(B&amp;7(&#xD;&#xA;MIQP1@UBV]V\9PYZ5HI&lt;HXZT`-EM%&lt;Y`J!H3'Q5SS&lt;=Z-R2\=Z3`RR^V6KBW$&#xD;&#xA;M90`FFW%KCD&quot;J1&amp;UL&amp;I`U[?RF.:L3!=G%9&lt;,FT&lt;5*)')Y/%(!ZN0V#TIT\&lt;,J&#xD;&#xA;M].:4(K#WIAA?.0&gt;*&amp;!CWME@$J*R,R1'C-=5,-PVFLR?3V8[@.*2&amp;.TJ_;(1C&#xD;&#xA;M70[4D6N7MHO)G!-=';RJ4'-6F(I7MNN#Q65)&quot;5Y%='*%DXJC/;X'2J3)9B+&lt;&#xD;&#xA;M/&amp;V&quot;&gt;*F#AR#3KFUXSBJB9C;FLIHI&amp;Y;/A.:=)&lt;A&gt;]9GVK&quot;\&amp;D5S*:YV:(LS7&#xD;&#xA;M1(X-1QN[GK1Y)-/CC*FA,!QMV&gt;E6W935R(&amp;I63-:(0R'@8J&lt;C(J-4P:F7BM%&#xD;&#xA;M(EHC&quot;D'FI!TI=PJ&quot;2&lt;)3YQ*)*6VFH+FZ&quot;H&gt;:IRWPSC-0,3..*7,6D0R7I:3`&#xD;&#xA;M/%7+9ED'-9&lt;ULR-4EN[J&lt;4KC:-*&gt;%3THMUV&amp;I(09!S5@0U:(8Y&lt;FG;33E7%/&#xD;&#xA;MJ[$W$&quot;TN,4X&quot;A\*M(+E&gt;=^,5D3Q%WR*O32?/BG1QAQF@9#:#8O-6S\PIOE;&gt;&#xD;&#xA;ME*.*:`!%@YJ510#E:&lt;O'-,&quot;M&gt;-MC-&lt;K=1&amp;67(]:Z#4IN,5GV\8D?FH&amp;2:5$4&#xD;&#xA;MZBMQN@JM;P!.U7-N1180B_=JM-)@$5:.`M5'CWM5!86W;O4TSDIBF1Q[5I&amp;=&#xD;&#xA;M&lt;X-)@8MRS&quot;0U/:_-C-37$`D.0*=:VY5NE*P%^&amp;/`S5A5-,3@5.K&lt;4[$C&amp;.WK&#xD;&#xA;M52Z(92!4MR^%)K,^T%GQ0-$2VY,F&lt;5HPKM&amp;*2-!BI@M`#P!3Q3*4&amp;@13OLA&lt;&#xD;&#xA;MU2MI,OBK=^XV5FVG,M`S&lt;3H*D%,3[@J04Q,*#2BD;I0P*LQYJ),$U)-4&lt;8YI&#xD;&#xA;M#)\4\&quot;F&quot;I%H&amp;(W&quot;UFW&amp;&amp;;%:%TX6+-9&amp;\O)^-`%VVB&amp;,U:&quot;XIEOPE28)-,!XI&#xD;&#xA;MXIE.%,EBTAIQIAH`.U122!14G:LR^EV`XI,I&quot;7,HEXJBT&amp;YABH8KDF0YK1ML&#xD;&#xA;M/S4C)+:':!FKW\--4`&quot;ES3$-*$FI43%*HJ4#-4(!2T$8%022[:`%ED&quot;U4=F:&#xD;&#xA;MFR,7/%/0&lt;&lt;T@1#Y9)J51MJ?`Q4+T[#%W&lt;T_&amp;:A4'-6D%)H5R'RN:F2*I=HIW&#xD;&#xA;M`%2QC,`5'),JTV:4**SII&amp;8\&amp;I92%NKG&lt;&quot;`:SECWOFK)C+5-;P&lt;U($EO'LQ6&#xD;&#xA;M@K&lt;4Q8P!3L&lt;UI%$L&gt;!FI%%,6IEZ59(M**3-&amp;&lt;4@%+&quot;H9)&lt;4V24&quot;J$TY[&amp;D`^&#xD;&#xA;M60DG%5&amp;WDU(C;CS5E8@&gt;U(947&lt;&gt;M3JM3&gt;2!VIPCIV&amp;,5*F5:`M.`HL*XX+2[&#xD;&#xA;M10*=3L)L0`4[`IM**=A7#%&amp;*&lt;*7%,=QA6FE*EQ1BE8+D02E*5)12&quot;Y%MHQ4A&#xD;&#xA;M%,-%@&amp;$4W%28H(HL`S%(12DXIN:+`-HI:*30##3:&gt;:3%2,0&quot;D*U(HYI2*5@N&#xD;&#xA;M1!:0QU*!3L4K#3*WE^U'EU8VTX+3Y1W(!'1Y7M5G:*-M/E#F*OD^U)Y/M5K%&#xD;&#xA;M!JN5&quot;YBFT0]*C,(]*NE:C*&amp;I&lt;1W*CPC%5VM_:M+R\TABK-Q&amp;9Z1E:6?&lt;(%_W&#xD;&#xA;MJN&gt;5[4DT.;=&gt;/XJ$F!J60_XE=K_N&quot;K2]*KV7_(+M?]P5945UWU,.@M)GFG8H&#xD;&#xA;MXH;!(`IQFFR2*B\FDFF$&lt;9.:YC4=3;&lt;54FLVS1(GU*_))5369%'),V6/%.MT&#xD;&#xA;M:X.6K3B@$?:H'8@2W\L&lt;&quot;K$&lt;1-3A,]JF1`.U-(+C44*.E2*&gt;,4[;Q28YJT3&lt;&#xD;&#xA;M79FE5/FP!3U%2@8'3FF(15QQ4F*%'K0PXSFD(7-0W-PD,1)(Z5#&lt;W:PH&gt;&gt;:Y&#xD;&#xA;M/4-4&gt;61D#&amp;I;-(H@U2^:YGVJ&gt;]/M;;#*6'6J\$!+[SSFMF&amp;+=MQQBI*:L65B&#xD;&#xA;M&quot;[&lt;&quot;K4:DTU4P`#5N),&quot;JB0V($J91@4JK2D50AP'%/%1K4JB@0N*6C/:C;2$%&#xD;&#xA;M!H)J-[A44Y%*XTAZY!ZU%=7*QH235*7457H:S+B62[;:I/-%RK$TNI%F(4FJ&#xD;&#xA;M4R2S]S6E9Z4?+R_)J^EFJCI18#G[?3FW985II98`P*TA&quot;H[5(J`4&lt;HKE%;8`&#xD;&#xA;M8Q3);3(Z5I%!2&lt;=Q2Y&quot;N=F`]J5/2HFAXZ5ORQ*PX%4)8&lt;=J+#N8SH5:K4'2G&#xD;&#xA;M2Q&lt;T1$*&lt;4K`7[&lt;\XJZ*H1L!R*NQ'&lt;*:$R1:D%-^Z.:`&lt;U:,Q]&amp;:;NH[^E#8&quot;&#xD;&#xA;M[C4;S*@R34%[=)&quot;AP1FN9NM4&gt;238&quot;1FH&lt;BTC?FU!0#@UG3:B[G&quot;DU1AWLXW'&#xD;&#xA;M-6PJ[_NT;EE2599CR32Q6/.6%:D&lt;(8=*F\C`IV$V45B&quot;8P*O1(&amp;`P*5;?)JX&#xD;&#xA;MD.U:=B;D:QTOE8/-3)UJ5E%%A7(EC7;THV`'I4@%!'-,!I;M0H[T[;36R*=Q&#xD;&#xA;M#B*0C`H0YZTY^E#8$;8Q40+$\5*PXJ.+[U0P'*Q4X-6$4]:A?&amp;X&amp;K&quot;M\E&quot;`:&#xD;&#xA;M^&quot;U,V\T&lt;[ZDXI@,*J!DBFC!Z4K\TU&gt;#0`XG%)3NM%`:C:7)IQ%1GB@!V:;@4&#xD;&#xA;M]1FE(YIC&amp;`8YIQ;(Q2'KUII*@&lt;D4`([&lt;8IT&gt;&lt;5'\K?Q&quot;EWJO\0I,`EC63M4:&#xD;&#xA;MP&quot;/G%.&gt;=5YR*%F1NK&quot;IL`9YIV#2&amp;6(?Q&quot;F_:XQW!H`E*^M,V#/2F_;$-,-_$&#xD;&#xA;MIYQ0`U[9FDW#I5J/*IMJNVH1L.&quot;*A.HHM%@+[8Q\W-5B%5N*KG4D-5)M1&amp;&gt;*&#xD;&#xA;M=AFL%#BF+&amp;5?K65'J)[9I_V]CZT`;N]=M0,Z[LYK,-R[+QFJ,MU*#WIA8Z!I&#xD;&#xA;M$/&lt;4J.HZ$5RS7DQXR:;]HN,&lt;,U`6.O\`.7U%-\Q#W%&lt;HES/GDFK`NY0.]`6.&#xD;&#xA;MF`5NXH(]ZY@ZE+'SS4\6LG^(&amp;D(W0!FAU+=#63_:&gt;[H*D74=O)%(&quot;ZUJ9!6=&#xD;&#xA;M&lt;VTT)R#23:V$;`!I4U:.5?F%*PRQ82N%^8U&gt;:1F;K66-2A08&quot;BK%O?QN&lt;G%,&#xD;&#xA;M&quot;TR9I%!4\TX7$9/44K2QD=13$,P2:F'W:C5U)ZBI?EQUIW$1#!-(5YIY*BD'&#xD;&#xA;M-%P&amp;-P*B#\XJTP!'2JSQ'=D4`3JFX9IK(,XI8\HE,+'=0,!&amp;0&lt;T_8#0#Q2K3&#xD;&#xA;M$5Y5]*9M!'(JT2,]*38#TH`I_9QZ5'):ACC%7F7:*@\T*&gt;:0RHVG$(:J&gt;1)&amp;&#xD;&#xA;M^*V!)O;%2F!=N2*$@,U8=\?(IHM%W&lt;K5\)M/3BG^5GFG8+F+&lt;62]A5?R2@K&gt;&#xD;&#xA;M&gt;+/:JDL/M0.YC-#*Q^4XJW:K.GWF-65A^;I5OR@%%,&quot;'[&gt;8L9-6(=2CDX:JD&#xD;&#xA;M]KNZ52-K(G*FI86.F1T89!%*7&amp;&gt;M&lt;KYT\+?&gt;.*FCU)@&gt;2:+BL=)UJ,]:S8M5&#xD;&#xA;M4\$5&gt;CN4E[BBX6)0*=N'2D.,&lt;&amp;H]ISG-`6).2:7&amp;*16[4,ISG-,DC?DTJY`I&#xD;&#xA;M^**87(R&lt;FE;A&gt;*&quot;.:7;\M%AW&amp;CYA0R#%+C`IC/@\T#1$]JK]151[$`_**T@&lt;&#xD;&#xA;MBG!,]:0S!=9H6R&quot;&lt;5&lt;MM0P,/FKWE(_!%02V2X^48H$6$N$DJ4$9X-8,JRP'@&#xD;&#xA;MFG0ZB58!LT`;,G`R:;&amp;P:HDNDF7&amp;15B.,`9S0`K&lt;&quot;J[/@U.1EL4QHQ2`-WRB&#xD;&#xA;MC._I2D&lt;4S.TT`&amp;,4QQ4I(85`3M/-`$#VZN.E4)[$Y^45L;E(XH&quot;@CFF!SX$U&#xD;&#xA;MN&gt;IJY:ZBRL-Q-7I+=6/(JNUF.H%&quot;&quot;US1COHY%%2C:_2L,PR)T)I\5\8#AJ86&#xD;&#xA;M-AHQBH-O-$-\DHQ4C8)X-`$?.,4UD&amp;WD5:&quot;#;FHB.&gt;E`KE)K96'2LVYTX;BP&#xD;&#xA;M%;Q7'.*BDCWCCB@9S1$T!X)P*OV&gt;J%2%&lt;FI[BV&amp;,8S6&gt;]DP;&lt;!0!T8E2XC&amp;*&#xD;&#xA;MKFW*OD5DPSR0'!)J_%?AQ@U(%^,D&lt;&amp;I\`C-4XOG.0U6B^T8IW`@E@\SFL^&gt;T&#xD;&#xA;MZX%:8#$YSQ2G8_R]Z!G/?O('SGBM&amp;TU%&gt;`U2W-B&quot;&quot;:R+BW=/N\4K#.@:.*==&#xD;&#xA;MP`YJE-9O&amp;=R53M;IX@`Q-;$5VDR`&amp;A(&quot;*WF=2`Q-7V&quot;3IBH/)4\BDR4Z&amp;A@5&#xD;&#xA;M;G3#@LM9C)-&quot;_4UMB&lt;E@#TITL,&lt;I&amp;!0!E12L_P`I/-/D+PC(-27=HT2%EK/2&#xD;&#xA;M=NDF30!J6ER)OE;K2W%L#DJ*CLRA8$8%7&amp;ZU(C$?S(W[U&gt;M)U8X;K5B2!7'2&#xD;&#xA;MLYHVBDR*+#-*Z5D0,IXJ.RN#(2K&amp;JIO?,78&gt;U-BD\E\TF@-&gt;6`$@@5&amp;8,IBI&#xD;&#xA;MK:]B=,'%2L`_*U(&amp;-&lt;:&gt;_EEE/-9ANY;&lt;[&quot;3FNEE4]*S+FR5\MCFJ0%&quot;+4G#Y&#xD;&#xA;M+&amp;M^VD6YA'K7+R0%)&gt;G%:^G2E0!FF!9NX!C@5C746WG%=(X#KDUEW\'R\4I;&#xD;&#xA;M`C!!YQ5^U%4=A#FKUJ#7')ZFB-!%S3R@%-0[144UP.U&quot;T'8MK*JB@W2UD/&lt;'&#xD;&#xA;ML:C\YO6CG!1-&lt;W0]:8U^!6:')'6FL&quot;:.&lt;?*7S?Y/!H:0R#K6=M(-6HV(IJ06&#xD;&#xA;M&amp;M`&lt;YJ2'Y35E%#&quot;CRL'I6BN2.,0E7I47V7:&gt;E7(AQ4H3-6D2V0VZ[#S5U2#4&#xD;&#xA;M(3%2J*TB0V/`I&gt;!2]J0CUJR;#&quot;&gt;:CFD^6FS3A.*K;S(U2RDBO)EGJW;G`YIW&#xD;&#xA;MV?/-.&quot;;::&amp;R;&amp;X5&amp;R&lt;T]6Q3NM63&lt;C48I[GY.*=LXJM/+L&amp;,U+*,74&amp;+-BEL`&#xD;&#xA;M0W-/D3S7JW:6^WM2`T8L%14H%,08%/!H$5IVV'%,C.XTEWR&gt;*=:H=N30,E?Y&#xD;&#xA;M8\UC7$S&quot;4X-;$Q&amp;S%8URF6)%`RU;OO49K2A0$5C6I((K:@^[FF22[&lt;4C&lt;&quot;G5&#xD;&#xA;M7N)-JFF(JW,N&lt;BJD-NS2!O&gt;GA@[_`(U&gt;B0`&lt;4ACE&amp;T@5*,4A0DYIX7`H)N)M&#xD;&#xA;MS1CBG$_+43R!%R:&quot;DC,U`'%5[.([\U9GE61L5/;Q@#-(993[H%24Q1BI!3)8&#xD;&#xA;M&quot;ANE*!2/TIB*,Q^:A.E-F^_3D'%(I$HI_:FJ.*D[4,9GW[G9BJ=LA+Y-7KL`&#xD;&#xA;M\4VWBP:2$65&amp;`,5-&amp;0!S3%%2`55@%ZTX4@%.%`A:813Z3O0!&amp;_RIFL&gt;\8.2*&#xD;&#xA;MTKI\*&lt;5S\\I,I%2RD,$.6R*U;.,JM5;=,X-;$*@*.*0Q`,4HIS4Z-0:HEBH*&#xD;&#xA;ME'%``I&amp;XIB$=\&quot;LZ:3&lt;V!5J5LBJ3*2U,9/`H[U*P`Z5%'P*&gt;&lt;FD`W)IP7/6G&#xD;&#xA;M&quot;,T\+3`%08IZBE`HZ4F`$X-1RR86H9Y@#UJLTNX8S4,9#/*2U$2ECS3O*W'-&#xD;&#xA;M3Q1XI6'&lt;!`34J)LJ5!3RM'*.Y&amp;#4@7--&quot;\U*!BK1#8H6I%'%-%/Q3$&amp;*@F?:&#xD;&#xA;M*E=MJUGS2;N*D97EN,MBF[2](8\MFIT7BD`1Q@5:0#%-5.*E5::0&quot;A&lt;TX+2B&#xD;&#xA;MG5=@N,VTF*DIIH`!3QBF8H-`K#\&quot;D--!HS0(4'FI,U&amp;*=0(=12BBD,::2E-)&#xD;&#xA;M@T@`TPBI@M-(IC(\4N*?2X%,&quot;$K32M3X%)MI`0;:0BI]M,*4@(&quot;*,5-Y=&amp;RE&#xD;&#xA;M89%2XJ;92A*5A$`%/QQ4NRD*T[`0XIPXI&lt;4A%.PQ:*;3UIB#'%-Q3S3:8Q-M&#xD;&#xA;M)MI2V*B:7%2V!)P*:2#5&lt;W%`G'K4V07)\`T2KBV7_&gt;J,2@U)*P^S+_O522'&lt;&#xD;&#xA;MN6/_`&quot;&quot;[7_&lt;%6U%5K$?\2NU_W!5H=*.ID@IK$*NXFD&gt;3:,FL74=2VJ5!JKFB&#xD;&#xA;M1#JM^=Q1363#;M.^X]Z=&amp;#&lt;R[F[UL00K&amp;G2L^HR&amp;VA$1QBKJKNIFW)Z5(AP:&#xD;&#xA;M=@)U0`4_%-4YJ0+32(;$&quot;T\1YIRK4JBJ0ABKBG4\BF'I3!&quot;;^V*I7\Y@B+9J&#xD;&#xA;M:&gt;80H7;BN3U36S+(T2CBHD6HE6\U5I9&amp;0$U46,NP:F+$2^_UK3MH@`#BLB[6&#xD;&#xA;M)K&gt;,$`5HPQE&lt;5##$2&gt;E:&lt;,&gt;,&lt;5:0FQ40GDU948%.51BE-78A@*?C--%2`4A&quot;&#xD;&#xA;M!:D`I,9IP&amp;!UH`-F.:/:ES4,LZ(/O4#L/=A$I)-85_?;FVI3[V^+?*O.:@M;&#xD;&#xA;M)I6W-0.Q5B@DF?)S6U:6(1&lt;GK5B&amp;U5!TJ8+M:BP#E^48Q3P,TN1CI323FG85&#xD;&#xA;MQQ48IH'-+CBCI3$!.!3&quot;N[I3R,T8Q0!%MVTCQAD)J4C-&amp;.U)CN8\T&gt;#TJH4.&#xD;&#xA;M&lt;ULW,6&gt;E4)(]JU-AW((R&lt;XS5^&amp;?9Q6&lt;&amp;VO5B/+-D46&amp;:^1(@-`7CK4,&amp;6`!X&#xD;&#xA;MI\\B0QY+4&quot;2$+&quot;,DDU0OM45$*KUK,O=5^8JIK.#-&lt;-DDU#92B/,DMS+RQQFI&#xD;&#xA;M&amp;LOF!Q4L$&gt;PBM&amp;)`Z\U(6L9T4)5Q6A'!N.:&lt;;4ALU:ACPM7%&quot;;&quot;./:*G&quot;YIP&#xD;&#xA;M05($P*LFXU4`IYY&amp;*:&lt;TY?&gt;F(AP0:&gt;&amp;S3V`--&quot;\T`.!P:&lt;W)IK#BF(?FYI!&lt;&#xD;&#xA;MFI&quot;N13CTIHI@1[&lt;&amp;GXR***`$8#%1A,&amp;G\YIX%2.Y&amp;1@4L3&lt;4]ES2&quot;/%`AQQB&#xD;&#xA;MF9-*?EZTSS4!QD4P'[&lt;\T;:J3WZ0]Q5)]&lt;`X`S0.QL&lt;=Z7*_WA7.MK;.V`M1&#xD;&#xA;MO?RL.]`['2F2,?QBH'NHE_B%&lt;O)+&lt;-TW5!BY)Y+4#L=0^IHG0BJ[ZTJC.*QH&#xD;&#xA;M[:5^I-3#3&amp;;J:8$TVOGLAJFVLR2'&amp;&quot;*OQ:.I7YC2MI*(W&amp;*`,W^T)^VZ@75P&#xD;&#xA;MQS\U;$5@GH*G%DF,;10!B-/,5'6G`SLO!(K:,$8&amp;-HIHB7^Z*`,(17+-]]JF&#xD;&#xA;M6*=/O$FMM45/X12/M?\`A%%A&amp;&lt;B2%&lt;9-4KFVF+\,:WE4#M2%`3R*0&amp;%%9SXY&#xD;&#xA;M8TYK:7.,FM]43'04C0+UXIV&amp;8B6C]S3OL#,&gt;M:Q0&quot;E&quot;`4&quot;,Y-/(JPEGR.*N&lt;&#xD;&#xA;M5,F/2@&quot;!855&gt;1436R,?NBK;TT&quot;@5RBUBF?NBGK9H!]T5&gt;VY&amp;::1Q2`I?9$ST&#xD;&#xA;M%+]B7T%6MO-.QQ0!1-BG=0:C^P(3T`K2VXI-M`S/.G@4PV^*TV&amp;%JH9/FQBB&#xD;&#xA;MP%&quot;2R\SM4/\`9S`&lt;'%;JXV=*CV;J+`8?V&amp;3UI19R]F(K;V!5Z5&amp;F-W2BP&amp;7L&#xD;&#xA;MGC&amp;-Q-)YLP[FMMD4CH*C\E,]!3L!F+=RIU!J4:FX_A-7F@0CH*A^RKZ&quot;BPBL&#xD;&#xA;MVIL2.#5J'4&lt;+DU#)9#L*C:T.W'2D!&gt;75$+8XJXD\;KG(KG3IS[LAC2D2P\9-&#xD;&#xA;M`'2`J?XA1M%&lt;XE[*GK5N'4WSRM`&amp;MM)-2!&lt;&quot;JB7Z%&gt;&lt;&quot;E%Z@;[PH`LLP`Z5!&#xD;&#xA;MN.[BI%&gt;.49WBE``/'-,!WWEY%5)H3@D5?&quot;?+3,=B*0%&amp;V^5QD5H,01Q4$D0!&#xD;&#xA;MR*:KGH:8B;`*]*3'%*IXIW6F!'M%1,@)J9@:CX!Y-`$?E&gt;U,,9]:O1E&amp;7J*C&#xD;&#xA;M(&amp;32&amp;4F4BFJH(Z5:9`U-$6*8S.NH!@\51\@&quot;MV6+*U1&gt;V)%)@4/L_H:3,L/(&#xD;&#xA;M)JUY+(:E&quot;[A@K2&amp;5[?4W#8;-:$6I*QP:HO9CJ.*K?9FW&lt;,10!T&lt;&lt;B2&lt;[A4F!&#xD;&#xA;M_&gt;S7/(DL8R&amp;)IZ:C)&amp;P#`TR6CH&lt;?+3`V.U4X-1208)%7`\;+G&lt;*8K&quot;Y!-..,&#xD;&#xA;M568G/R\U)&amp;2W6@0_M56523Q5IN*`@/6@&quot;&amp;#(ZU88\4PC'2ES2&quot;XW%-)*GGFI&#xD;&#xA;M&quot;,4APPQ0412*DRXP*R;JQZ[:U3$0&lt;BC:,\T#.&lt;59H&amp;SS@5H0ZJ54*U:DELDB&#xD;&#xA;M=!63-IQWG%`&amp;A!?I(&gt;&lt;5;&amp;'.0U&lt;Q);RP'*YJQ:ZDZ':PH$=`T&gt;!5=SD]*(;Y&#xD;&#xA;M95P2*FPIYSUI`0)FED7(J8*`.*K32%&gt;@H`@9C'4D+[ZK,YE.,59MX&quot;.:0$S8&#xD;&#xA;M'4T#:1UJ.XB)'!J!&quot;\8YS2N,M&amp;,'M6?=V&gt;[D5:CN=S8-6&amp;4,*I,#FV66!^&quot;:&#xD;&#xA;MN1:@PP&amp;!%:4ELK$9`JE&gt;V(*_+Q5&quot;+EO?HV`2*O`I(,K7(-!+&quot;V035^QU%D(5&#xD;&#xA;MZ`-_9ZU#(&quot;.E/CG249W&quot;G-CMS0@*9&amp;&gt;M(T0*]*L&amp;/&lt;:-NT4P,F&gt;#GI58VY'(&#xD;&#xA;M.*VG0,*HS1'M4L&quot;M;WC0M@\UHK&gt;K*1VK.$!STI&amp;C9&gt;0:`.AB(:/`YS52&gt;-HV&#xD;&#xA;MW`U1MM0:`[&quot;,UH^:MQ'UIC(5OA]QJE-HMVN015*:S.[&lt;#4UI,\3[&gt;:D9#-IQ&#xD;&#xA;MC)'I5)_,@/&amp;:Z%Y=Z\K56&gt;%67I3`HVVJE/E:KJW*S]*Q[JU(.14$-U)`V&quot;#2&#xD;&#xA;M8'3*HQ3E.T]:SH+P.!S5Q3N&amp;:`+C;9$YK)N[`,25%66D8&lt;`5-&quot;X*8:F(YTF2&#xD;&#xA;MUD[UJV=ZL@`;K4EU;++T%94EN]NVX$T`;XC#&lt;@U7GC!!&amp;*S;?5&amp;1@K5L0LMP&#xD;&#xA;MH(-%AF,]JRDL*JS2,.,5T4T:J.:S;BT60$K4,#-MYG#CYC716=Q\H!K!%N8W&#xD;&#xA;MY%:MF1QDU-@-)V#5$4!I9&quot;,9!IB29XH`K3VBOVYJF5:!JU?XZBNX0\?`YI@1&#xD;&#xA;M17.X`9J6&gt;/?%GVK+P\+Y.:TX[D-%CVH&gt;P(P+A-DAJ:V-.U`8D'O1$`%KCGN:&#xD;&#xA;MHLNWRU1?):K.[/%-*9YK-LHJE:0BIG2H]M1&lt;8+4H%(BU.J52`CVYI0O-3K'3&#xD;&#xA;MO*K2)+'0U95&lt;U&quot;BXJPG%;Q(8NW%3)TI@YIXXK2Q`['-/QQ3133(!3N%AY8&quot;H&#xD;&#xA;MI+@8P*K33D9JJKEFIW&quot;PZ8,[9%.A.SK5J-`5YICPY.13`LQ2`BE&lt;9J!`5JPO&#xD;&#xA;M(H0F18-2I3MM!&amp;!57$.)&amp;VL2_E(8XK68G%9MS;ESF@9!9_.W-:T&lt;&gt;`*I6D&amp;Q&#xD;&#xA;MJU`,**+`.&quot;C;4$K[:E9L&quot;JDN30(8&amp;WMS5@$(E5XD/6GR?=Q4LI%2XN?F(IL8&#xD;&#xA;M$PJO&lt;(2V:DM6*D`T#+T5L`&lt;U=C&amp;!BHHCN%6`,&quot;FB6%4;S)%72&lt;`U2E&lt;,&lt;50(&#xD;&#xA;MSX@?,K5C/`JND8ZU808%(IEA6&amp;VESD5&amp;/2G@4&amp;0UN!6?=O\`+@&amp;I[N;RU-9W&#xD;&#xA;MF^:V*&quot;T01HS2YK7@&amp;%%,AMP%SBK&quot;KB@9(!3L4@IU,ABTQ^E25&amp;YXH!%&amp;09&gt;G&#xD;&#xA;MJ/EIK'YZE4?+21:$%2?PTW%./W:&amp;!0N#\U3VH!%4;HG?5FR&lt;TD(T-N**7-%4&#xD;&#xA;M`M`H%+0(*8U.IC_=H&amp;5KG_5YK`E7,V?&gt;MB[DRN*SQ'N:DQENS3&lt;HJ\HVU6M5&#xD;&#xA;M*5:SFD#%QFI$!`IJBIT`Q3($7KS39CA&lt;TY^*AE;]V:8(I-+\V*E0!A54J2]6&#xD;&#xA;MXQ@4RA2,4)UJ3&amp;:&lt;%H`=VIN#FG&quot;GDX6@!H8`&lt;U5N)P.AJ.YN2F&lt;5EFX:1ZEC&#xD;&#xA;M))Y69N,TZ!6-3PP;QDU=C@&quot;CI0D`R&amp;/UJ?8!2@8IPJK&quot;8T#%/`I&lt;4X+185Q`&#xD;&#xA;MM+MIP%/`I,0P&quot;ES22';51[C!J;C0ZXDP&quot;*H9W/3Y)-[4(O&gt;D4.&quot;\5(JTJC-3&#xD;&#xA;M*G%,0U:D%&amp;VG`52$%&amp;:#3:I`/S2&amp;DS1UH`4&amp;BFXI:!&quot;TH%`6G`8H`4+2XI&lt;\&#xD;&#xA;M4A:D.PM-)I#(`*@DF`H;&quot;Q8#&quot;C&lt;,]:H&amp;Y]ZA&gt;\(.!4W'8U/,'K33(/6LK[8Q&#xD;&#xA;MH-PQ%%P-(SJ.]'V@&gt;M8[R-[T@=_&gt;BX&amp;L;H#O3/M8]:RV+^],^:@9K_:QBF_:&#xD;&#xA;MA68-U.PU(#52Y!'6G&gt;&lt;#WK(RXI?,?WI@;`E`[THG%9'G/[T&gt;&gt;PH&amp;;0E!I2XK&#xD;&#xA;M)2Y(J3[72N*Q?R#1Q5(70J&gt;.4-WHYA$M.`I.,49IW$.--(IR\T[%,&quot;NX.*I2&#xD;&#xA;M@BM,K4+P[JFP&amp;+(Q%0B5LUI36W/2JXM&gt;:D8U)2*FDN/]'7G^*FM`0*@F0B`?&#xD;&#xA;M[U%QG4V0_P&quot;)5:_[@J4'M3+(?\2FU_W!232+$A&lt;GI6LD9112U.Y\A#GBN5DE&#xD;&#xA;M:XDS5_5+W[9+M!JK!;[*R;-T6;10F,UJ(,KD5G(IK4M?N@&amp;FA,E1!CF@KDU(&#xD;&#xA;M?:D45H2V&quot;Y'%6HUJ-5YJTH^6D0PP,4W)!XIP&amp;ZFL64X`I@.Y(J&amp;29(&gt;6.*)+&#xD;&#xA;MCRURW%&lt;GK&gt;JL694-2V4D&amp;O:R&amp;#1H?RKGH1YC;V/6H&quot;))Y-S9JY#$PP,5.YJB&#xD;&#xA;M]%#E1Q6A;P'BFV:9`!K6A@&amp;*.44F$&quot;#%75&amp;.U1K'MJ4&amp;K2,KCQTHZFEZT]%I&#xD;&#xA;MC!5IW2I,&lt;4W&amp;:3$`-'4TTY%13SK&amp;F2&gt;:D&quot;.[NQ&quot;O6L.6Y&gt;=L#-.G9[J4@=,U&#xD;&#xA;M:MK#:`2*19%:VA)W'FMF&quot;(!&gt;E$,(458Q@52$'2DQFDIPJD2P%*:2EQ3$%`ZT&#xD;&#xA;M'@4SO0!)24+QUI3CM4C&amp;D4E.P::2%ZT@#;N&amp;35&gt;:`,*E-U$HY:H6OK8=7%*Y&#xD;&#xA;M21EW%N5:FP7*PMAJL75[;LIVN&quot;:YJ]N&amp;+G;2&lt;BK'0SZLD2;E85A7&gt;M27!*CI&#xD;&#xA;M6&gt;_F2*!S3H+4YR163D-(?#$TS9.:T8X_+%+;0@5&lt;\GI24BB*,G(XK2MT)P:@&#xD;&#xA;MCAYZ5I0(`*UB2V/&quot;\8Q2A,4_%*.*M&amp;38T*1S2&gt;9@X-3!@1BH9(\GBF(F3!%-&#xD;&#xA;M[D4L(QUJ1E&amp;,T`18H`-&amp;&gt;:&gt;2,4AAP1BH2,/4H`S37'S&lt;4!8=GY:7^'--`-+P&#xD;&#xA;MIYH'8.U)5:XO4C.`:IMJ/H:!\IK@KW--&gt;6-?XJPI=0FQ\HJL+BXD;D&amp;@5C&gt;&gt;&#xD;&#xA;M]1.XJM+JNS[O-4#&quot;\F,YIXL&quot;WK2'8236)7.`M,2&gt;61MQ!JPFGA&gt;HJRMNJTQ&amp;&#xD;&#xA;M3/!),W&gt;F)II[DUN^6`*;@`]*8S+CTT*&lt;FK'V1&lt;&quot;KAIO&amp;&gt;:`N-CMH\&lt;XIY@3^&#xD;&#xA;MZ*?@-C%2[%QUH&quot;Y7\M5[&quot;GKMS3Y(R&gt;E1+&amp;P/-`7)&amp;&amp;&amp;XI2,BF2,$7WJ&gt;V&quot;R1&#xD;&#xA;MY)IA&lt;@^Z:&lt;&amp;).*D=!OXINW'2@+C?*[TFW%/R12#FD*XPBH7;::LNO%5V0-U-&#xD;&#xA;M*XQ\;AJD*J1G-5/+93\M3KG;S1&lt;&quot;01C;G-(5-1JS&gt;9M`XJP1\M%P*Y5L]*&amp;R&#xD;&#xA;M%Z59^4)[TR3;LHN(IAV+&lt;&quot;K&lt;1..153+J^0O%74&lt;8'K1&lt;!LC;::K@]34CJ'-5&#xD;&#xA;M;F,QCBBX%Y&quot;-G'-,-5[$LR&lt;U988-&quot;`92]:,4Y0:8#&lt;&gt;M*0*#DFEQQ3$(&gt;F*J&#xD;&#xA;MF'+U9R,TH'&gt;D*XW;M7%1@8-2,2U,[T#0C#(Q31'@9J2EXVTQC.U,I^*4)0`P&#xD;&#xA;M4M/V@4TXH`900#3\9HVT6`8H`[4R2,-V%2@4XJ,&lt;T6`H_95)Z4&amp;T7%6^,TI3&#xD;&#xA;MBD!0:SXR&amp;-5)H)%^[DUL8Q2;0#G%%@,599H.3FK$6LE3AJT)+=)1@UFW&amp;E(3&#xD;&#xA;MD$T`:D.IQN.6%64N8W/WA7+FU&gt;+[N:DB&gt;5.N:`.K_=D?&gt;J)H^&lt;BL$7LJ&amp;KD&amp;&#xD;&#xA;MK+C:[`&amp;@1I@8&amp;*4'%0QW,;C(:I@P(R.E,!W;FJUPA(^6K!/%(.&gt;E)@9J%U?O&#xD;&#xA;M5U7#+S4A@4\GBHQ&quot;1D]JD!2I[&lt;TO\.:(Y4!VDU))MV\&amp;J3&amp;09R*C(I5+;O:G&#xD;&#xA;MX#/BA@,$:MUIKP`&lt;BI'C*]*5&gt;&gt;M(9`8LK5=X&quot;.0*MN^#@4\89:`N4(VP&lt;,*;&#xD;&#xA;M&lt;6L&lt;JY!JV]ON/%-\@KUI@8WV&lt;Q'(8TY;B5#QDU?N8@.15:-=QQB@&quot;6'5&quot;G#&quot;&#xD;&#xA;MM&quot;*^CD&amp;&lt;@5BW=MP2*HK(\1ZF@+'9*RN.#FC)%&lt;Y:ZFR-R:UX]1CD4;F&amp;:0K%&#xD;&#xA;MRF_&gt;IJ3(W0U(1QE:8K&quot;#I4+EE;@5)OP:7*M0,:)OEP131M9LYHEA)&amp;5JJ?,0&#xD;&#xA;MYQ0,T`,=*8XSU%0PW!_BJQE6%`B!HE&lt;8(JE/IJ-RO6M$KSQ4;$KS0!D?9I83&#xD;&#xA;MD`TK7\D9`(Z5K^8)%Q@54N+)7!-`&quot;V^I(XPS`5&gt;41S)P17+SV&lt;D;Y3-6+:^F&#xD;&#xA;M@(5AQ0,VFM%5LBK2`+'5&quot;&amp;_1NK&lt;U:$X?@&amp;DP(9'/FXQQ2G#+C%2,@V[A59RP&#xD;&#xA;MYJ+&quot;(#$5DR*OQ@[!FJB2'?S5U7RF!3&amp;-;#=:C(W=:BG9U.0*8L[$X-6F`Y[9&#xD;&#xA;M6'2J,]ACYA6Q%AA394)[4`&lt;^)IK=N,FM&quot;WU,G`&gt;IGME8&lt;BJ&lt;UECE&gt;M%Q&amp;Q',&#xD;&#xA;MDBYS32^6Q6&quot;L\UNV&quot;.*TK6[1\$GFF@+C*0,U$5W=:M[E=1MYI&amp;C44`46C]!4&#xD;&#xA;M3Q^U7V7CBHMF&gt;M,#)GA.&lt;@5''.\+8.:U98^&gt;E59+&lt;,*&amp;,L07BR+M;%2A%#;U&#xD;&#xA;MYK%='A;*YJQ;WI'#5(&amp;ZBAE]Z:Z]JB@GC&lt;?&gt;YI)IBIXI#$DMPR]*SY+!6SQ6&#xD;&#xA;MI#)Y@YJ.7*MP*`,+[,\+9&amp;&gt;*LQ:@R+M:M)H@Z&lt;BLRXL\YQ0@-&amp;WNHI5P6&amp;:E&#xD;&#xA;M,?.5YKFT#P2=ZV;6_&amp;S:QH$758+]ZB6V2X3(JE&lt;3[AE34=O?NC;32N!5O]/:&#xD;&#xA;M$;E%-L+][9\-^M;_`,EW'@XK'O=,()*CI1&lt;9&lt;N;P2Q@@U!;2L6QC.:R'EDA.&#xD;&#xA;MT]JTM-N$8_,:`+DT.X9Q5;YH^E:SA64%&gt;:JRQ9'2E8&quot;O%=?PL:F9]B[UYK+N&#xD;&#xA;M8G5MV#4:W[!?+-)@;D$OF&lt;GK5H*.]9=C(I()-;2HI3(I`RA&lt;6ZRCTQ6:R/&quot;W&#xD;&#xA;MM6T4PQJ&quot;Y@W)P*?01B7;&quot;3'M443L.*DEB(&lt;YI\47-&lt;M1%Q8J*2&lt;U-MXJ18\&quot;&#xD;&#xA;MG;*YF:7*S)D5'LJ[LIICJ;,:965*L(M-*X-/2K07)E44XJ/6A%W4Q\J:UB2Q&#xD;&#xA;MX%/4]JCC8&amp;IAC-;1:))$%2'%1A@*C&gt;7TK:Z%8=+)L7BJGG[FP33I,L*K;&amp;#5&#xD;&#xA;M+8$[IN%1&quot;/:&lt;U:CY3%*T&gt;:0&quot;1R=JLI@BJ@0@U83BJ3)',O-.7BI``143=:JX&#xD;&#xA;MB9&lt;4US0ORKS44DHZ52%80O@T\`,.E08+&lt;U9B7`J@&amp;B/!J0'M3N]!7`S3`1P`&#xD;&#xA;M*KD9I99#21?,:0#E3:*K3R@5=DP$K$O'.\XJ64B3B09I%CPW%0V[YXK1BCR,&#xD;&#xA;MTALL6XPHJWU6H8QQBI&gt;U6B&amp;59VV`UE/.?,K3N&gt;0:RS$3)G%)E(T+&lt;;ES5E5X&#xD;&#xA;MJO`-HJTK4`V&amp;.].##%!&amp;:AF^12:9-C.U%BV0*JVD9#Y-2RS!Y,&amp;K,$?`(I#1&#xD;&#xA;M=0C8!3PM1HIQ4R4P$QBG`4N&gt;:&lt;&gt;E!(G%12\&quot;G@&lt;U'.0%I#118_O*LH?EJIU?&#xD;&#xA;M-6T^[310X&lt;FE;[M`'-#]*&amp;!F7&quot;@M4]K'BJ=Q+B7'O6A:D%14H3+&gt;,4N*5&gt;12&#xD;&#xA;MXJA#&gt;E+12]J8#&lt;5%*V!BI:@G.!2&amp;9EP3FD@7)J21=QI84(-`RVJX6E[TX?=I&#xD;&#xA;M!R:5A,D6I0&lt;4U5XI:9(IYJI.V.*L,&lt;5GW$GSXH!#XUSS4OM208VU(&lt;9H*$4\&#xD;&#xA;MU**B`YJ44P%IDDF!BI.BU1N'.&lt;&quot;D!4N!O-116IW9Q5I$W-S5Z.(8I#(X(\+B&#xD;&#xA;MK&amp;,4#`-.Q30A`,T[%`%/Q5&quot;&amp;@5(`*2@4KB'8IA?;3RX`ZU0N;@+WI-E)#IY^&#xD;&#xA;M*S9'+&amp;D,YD;%2I#NYK-CL-B%6U7BF)%@U95.*:!C4'-3@\4S9BE%42/HHI*8&#xD;&#xA;M`::11FC-%P$YIP%**&lt;!1&lt;``HQS3J&quot;0!0*P9Q06J)Y0!522[QWHN.Q&lt;,H'&gt;HW&#xD;&#xA;MF'K6&lt;]R341G;-(HOR3^E5'D)I%8M4@0GM2`AP33A&quot;35E8JE5`*+`43`13EB/&#xD;&#xA;MI5XQB@)CM3Y0*GDY[4X0^U6]OM2[::0F5?)%-^SBK&gt;VC8*+&quot;N5E@IP@Q5H**&#xD;&#xA;M&quot;*+!&lt;JF$&gt;E)Y`J?O3U%`7*GD&gt;U-:VJ^0`*3`-.PTS.,&amp;*B:(UJ&amp;,5&amp;8Q4N([&#xD;&#xA;MF4Z,*5)G2M%H0:@&gt;W]*CE`6.Z)ZU968$=:SS$RGI0-PHL,UDD![U*7&amp;*QQ&lt;,&#xD;&#xA;MG%/6\)/-+GL*QI;^:=N&amp;*H&quot;Y'K3Q&lt;*&gt;]/FN!8&lt;!JC\L4Y&amp;4]Z?Q3$0-'GM4,&#xD;&#xA;M]O\`Z.O'\57012S`?9E_WJ5@+44JQ:-:D_W!7.:GJI),:G@U8NKTG2;55/\`&#xD;&#xA;M`*P/*::3&lt;?6KE(:CH3VL1&lt;[ZO`@-BD@39'@5-'`6.XBHL,GBC#5:5=@ID0&quot;U&#xD;&#xA;M-G-6B;BJ&lt;]:E3FHU7)XJRD9'-,EDBJ,4\,.E-`.*`N.M,0[D&lt;BJUS&gt;&quot;%26/2&#xD;&#xA;MGRS&quot;)&quot;6-&lt;EK6J!F*JU2V6D2ZAK#2DHAK&amp;&gt;-IFRW6H(`[MNK8MH2Y!-1&lt;T2*D&#xD;&#xA;M5F?2KT5H.XJ_'$@.*LQVV6R!Q31+94MX-K5JP#%(+&lt;#M4JIBJ1FV/P#2!.:&lt;&#xD;&#xA;MJG-2A:M&quot;&amp;JM2`&lt;T;:7I2&gt;@Q3DBDQM7)H+A1DUFWVI*JE0:EL8MYJ*0`\U@R:&#xD;&#xA;MA+=2[1TS2.KWDN.2*U++3(XU!(YJ1DUA:X4.PY-:6!C`I$7:N!TIX%.PKC03&#xD;&#xA;M3P:,&quot;BJ%&lt;*6BEIB#M2YIIH%`&quot;MDU'@U*,9H?`%)L!G)I&amp;&lt;1C+&amp;J\EVD6&gt;:S+&#xD;&#xA;MN_:3A32YBC4DU&quot;-0&lt;-61=ZLW(4U4C261N:F&gt;Q4\D&lt;U+921G2WLS&gt;M5G&gt;5AU-&#xD;&#xA;M:K60`Z5&quot;8`.U9ME)&amp;:B2EN]3?9R&gt;HJ]'&amp;`&lt;5-Y)/.*DHHI;X'2G8&quot;U&lt;\L@56&#xD;&#xA;MD0YH&lt;09)!UK0B&amp;ZJ$&quot;UHP8%.,2&amp;RPB58CR*$48J55K:*(;#!I&quot;IJ4&quot;CC%78D&#xD;&#xA;MA&quot;D&amp;I!2TF0*0[&quot;YQ3&lt;DTI.:.@I#&amp;$'-.`]:CDG1.IJA-J(4X!H&amp;:GRCFJ\MW&#xD;&#xA;M''U-9WVN613M-9T_VEWQS0!KOJ@!^4U7N-2D9/EJE#:2'[PJ_%8AQ@B@=S-S&#xD;&#xA;M-.V3GFK$5J_&lt;5IK:!.`*G\K&quot;T#N5H;1&quot;/FJ7[+&amp;G(I_(Z4Y`6ZTQ7(4`S5E0&#xD;&#xA;M,4P1X-2[1BG8EL/EIA49IVVE&quot;\\T6&quot;Y$0.E,*C-6-@J-AB@!GEY%5)PR]*OH&#xD;&#xA;MU,E0-0!4MB_.:D61PW-31*%I2JD\4@)8F!&amp;32OR,BFJN.*'98N&amp;I`4Y(GDEY&#xD;&#xA;M'%/7=&amp;=@JRDL;KA&gt;M-:,JVXT`2*/DR&gt;M,SSS3TR1[4A49IB&amp;D`TSI4NWBF-Q&#xD;&#xA;M2`3K4;QXY%/!]*=@]Z0R*'/&lt;4LN`WM3^AXI6160YZT`-C,&gt;&lt;@\T]R&lt;9%5O*&lt;&#xD;&#xA;M'*]*E5CC!H`AW/OYZ594(Z]:=L5A4;;8N30`\H@'%1^5W%-8LPRM+'*&gt;AH`&lt;&#xD;&#xA;MNX&amp;B52XYIV]0&gt;:E&amp;QAF@95B(AXJ7?NZ5'-'GD4L2D#FF`YB0*8)PO6IL!N*@&#xD;&#xA;MDMZ!&quot;27''RTL4^[@TD4`)^:GFW&quot;G*T7&quot;PK)GF@-@8-/4]C2F,$9I7%8C##%1&#xD;&#xA;M-,@;K3Y$/050FAD#Y%`&amp;BI5EXICYJ.V#`8-3NO%,9&quot;IYJ8=*@Y#5(&quot;&lt;47$*U&#xD;&#xA;M1'.:G&quot;DTC1\4`(HR*&quot;,4U'P&lt;5,2&amp;'%5&lt;!J8ILN=O%*%(H+#.#0,K+NS5J/D&lt;&#xD;&#xA;MT;1BF@X:D`]HQ3&quot;@I^3BDI@0D4;14I6FE:`*SQBH_LX/45&lt;VT;.]`%-K5&quot;O-&#xD;&#xA;M95S8OYF4!K?&lt;`]*18\=13`Q(_/BCQ@U9CU&amp;:-&lt;-TK3:&amp;-EY%5'M%8XQQ2`5-&#xD;&#xA;M4C(^9N:N6]]&amp;3P:QYM/`Y44L-K+'S@T@.BWB3I2R;MF!6)]IEB_&quot;I(]7`X&lt;T&#xD;&#xA;MK`6EMR6)-2G(&amp;*9'&gt;(ZY!I?/1AP:`$YZ4F2C9J:,!J&amp;BR:0`)`R\U'(&lt;#BE,&#xD;&#xA;M97BC82*`*K!LYJ56XJ5PFT`TY8E*Y%`#$D`ZTXNK&amp;H9%(.!47E2CD4`3R0!U&#xD;&#xA;MXJ!;&lt;*&gt;E2Q2,!AJF.&quot;*H5RA/$7&amp;`*R[BT8=JZ`K4,D0?@BD.YRY0J:-S+SDU&#xD;&#xA;MN36*D94&lt;UF26SJWS#BD4);7\RO@]*W;&gt;_4J,GFL&gt;.V4CI4,Y:$C;3`ZD/&amp;_?&#xD;&#xA;MK3O+[K7)C4I(B,FM.UUM2`&amp;:F(WTR%YJ*15;BH8KU)1P:F'/-!)`T&amp;.E*@*G&#xD;&#xA;M!JQO%1D9-``3@9J,NKG!J0@D8J,1!3DT#&amp;JFTY%/R3UIN&gt;&gt;*)9`F,U+8QKHI&#xD;&#xA;MXQ436*.N34QD0X.:%=B&gt;.E*XS+FLFC.4!IL,\L;8?I6YM4K@U5EM4;M5&quot;'0W&#xD;&#xA;MB,-I-3[4DK'FM)(CN0&amp;B&amp;ZDC.&amp;/-%A&amp;G+;A%R*JI.RR8-68;M91AC3VMHV^8&#xD;&#xA;M46`?\DB#-1&amp;U'44X(5(Q5@.,8I#*)&lt;PGFI$ND&lt;8)I;B'S!Q5,6[(U-`7B-PX&#xD;&#xA;MIJISR*2-F%39!&amp;&gt;],&quot;G&lt;6J2]:SI;.2'F,'%;&gt;,G-(_S+BJ`Q[:^:)L2'%;4$&#xD;&#xA;MR3KG-9-Y9!N4'-48[N:T?!/%)@=,1S32N*JVE^DJC&lt;&gt;:NY#&lt;BE&lt;1&amp;P&amp;,&amp;H#%&#xD;&#xA;MZ588`U&amp;0P^E,&quot;I-#D&lt;BLV6#!XK;;##FJDL5.PS,BEEBD]JT8YQ*,,:A:('BH&#xD;&#xA;M6#1G(I,9J!@@RM)]H!8`FLU+OG!-6HU609J&amp;!I@Q[.#3#&quot;&amp;!P*@B5C4_GK&amp;0&#xD;&#xA;M#0!3FL&lt;\XJE);%#QFNB4H\1-57B5C3`Q`S#AJ%,&gt;_)-7[BV7G`K)GMY5)*BI&#xD;&#xA;M`T(;Y8FPIK3BE^TKQ7)Q[_,^:MJQO!&quot;.M`R&gt;[TQ7!.*R/(:UDR,UT(OXGX8T&#xD;&#xA;MV6&quot;&quot;Y4[&gt;M,14M+Y=F&amp;-6?/1^&lt;UC7EI);$[1Q4=O=,!@FF!LN(I?DSR:SY],V&#xD;&#xA;M-O`JMYTWVH,OW:Z*$B:UPWWJE@&lt;\'&gt;%N*V+._)7#&amp;J]S:?,&gt;.*J.WDCBH8&amp;L&#xD;&#xA;M+EI)&lt;+ZUH[,Q&lt;^E8.G7,7F?,:Z!)4D3`JD%C'N+?+$XJ%8L5K3H.U4]O-8U$&#xD;&#xA;M-$86G;:?C%%&lt;C6I8S%-(J2F&amp;BPT0L*1:&lt;W6A5IA&lt;FB;;395+#(I2,`5(F&amp;&amp;*&#xD;&#xA;M+B,\R-&amp;U2+&lt;G'6GW,`[&quot;JH3%4FP)S&lt;'UI5&lt;L:A&quot;U8B6M%-A8L(N1S2M&amp;*5&gt;*&#xD;&#xA;MD`S6B=R60`$&amp;ITYH*4W[M78D&gt;5I!3T^84CC;0(&gt;F:4@`Y-5S&lt;!&gt;]0R7G'6E&lt;&#xD;&#xA;MI(GGF&quot;KP:H&quot;8M+B@L9:(X2'S6D6)HT8ERM3J,5'!PHS5CKTK2Y`FVFLX`P:&gt;&#xD;&#xA;M3M%9T]P`V,U-QHF9=QIRC;38&amp;#&quot;I)!A3BBXR&quot;&gt;48QFLZ1`X-%S(V_%-1CWI7&#xD;&#xA;M*0V./:&lt;UIVYRH%01Q[TJ&gt;)-E-&quot;9&lt;05(Y`6F(&lt;BDD/R&amp;J)*,THW8I$&quot;L:I3N?&#xD;&#xA;M-Q[U&lt;@4[0:DHLA/2I0,&amp;B+I3\9-4B+@6Q5&quot;_G(C-7I!@9K)O&amp;#`BE(M&amp;6CEI&#xD;&#xA;MN:W;8#RQ6/%%\^16Q;*=HI1$RTN*&gt;HYJ-&gt;#S4PZ50AI%&amp;:=BC%`A'.Q&lt;UFS7&#xD;&#xA;M.6QFKMR^$(K#;+2U)2-&amp;)0PS5E5P*@MN(^:L&quot;J0Q0.:1Q\IIZCFE=&gt;*&amp;!S]Z&#xD;&#xA;MA#Y]ZO61.P47$&amp;XU+!'L`J4)EU&gt;E+FF#I3Q5$@:!2XXI.AI@+C`S6=?2[5-:&#xD;&#xA;M3?&lt;K$O\`[QI%H2%PV,U&lt;11UK)ADVFM2%BPH$R?C%)CFC!IZ*&gt;],1*IXI::!3&#xD;&#xA;MN@I`0S'`K.==SYJW&lt;O@&amp;JT3;C0!(A*BI%;)H*&lt;4B#!H&amp;3J*&gt;*:.E/`S0(;(&lt;&#xD;&#xA;M+6?+RU37&lt;OEBJ&lt;,PE&gt;@99B4YJZG`IL40VYI2&lt;-BF`[;S3P*%&amp;13A0(;WIV:7&#xD;&#xA;M'-(5.:&amp;&quot;&quot;H99U0=:65]BUC74[$GFIN-%J2\]#5.5VDJLK%FYK1@AW#FD6BI$&#xD;&#xA;MA#&lt;UJ08(IIMQV%2QIMIV);)@HIX%(M.(IV)#`HQ0*4TP&amp;4AIV*:W%)@-)I,B&#xD;&#xA;MHG?!I@E]ZBX%Q33]P`JH)12--[U8R:2&lt;**J/=]LTR1MU5_+YS2'8G,I8579&quot;&#xD;&#xA;MQJQ'%FI/)-`%,0FG^1S5P1X[4[90!!'#BK`04`8IPIB%&quot;TX#FE`I&lt;&amp;F`;:,4&#xD;&#xA;MO2FE@*JXA113!(M!E6E&lt;!]&amp;*B,P[5&amp;9\=Z0[%P)377`JLMT&lt;]:&gt;TX:D(.]2+&#xD;&#xA;MTJJTN#0MQ[T&quot;L72.*;TJ%9P:D#J:I#%R:2EWK3=PI@&amp;*-N:4&amp;ES4L9&amp;T0-0O&#xD;&#xA;M%5K--X-0PN4'@R:@:`K6KM&amp;:1HU(K-P'&lt;QCN%-WN*TG@'I4#0&gt;U'+8&quot;NMVZU&#xD;&#xA;M:CO,]34#6OM49@=&gt;E,#26&lt;$]:L2.#:KS_%6&amp;&amp;=35AKHBV4$_Q4TQ6*%F[2V4&#xD;&#xA;M`;^[5P08Z&quot;H;.(K8P'_9K2ACW&quot;GU*Z&quot;0Q&lt;&lt;U;1`!0J@&quot;E%4B6&amp;!FGJ.:0#)J&#xD;&#xA;M:-&gt;:H0^-&lt;&amp;K`/%-5.*D.,8HL(!GM45Q&lt;I$A+&amp;B680H2:Y'6=5+/M1JALI(GU&#xD;&#xA;M/5MP95:N&lt;:-YY=S5*@:5LDYK0BA4#I47-+!:VX```K0BC*'%);Q8(Q6A'#GF&#xD;&#xA;MFD2V.@A!&amp;2.:NHN*;$@`J;%:)$-B#K3P!30.:DQ3($&quot;G-24JT[&amp;:`&amp;CFFD$&lt;&#xD;&#xA;MFG$[:J75VL2')YH9:*U_&gt;!%*@\UC&gt;4]PVZK+G[4VX5&gt;M8T4`8K-C&amp;6=F(U!(&#xD;&#xA;MYK11:%`IXQFA(5QV**D`&amp;*81S5B$IPH%+02+1BE`HH&amp;,/%)FE;&amp;*86&quot;K0V`\&#xD;&#xA;M&lt;&lt;FJ%]?&quot;-2`&gt;:2&gt;ZP,`U12!KJ0YJ&quot;K&amp;5)&lt;32RGDXJ[;PY&amp;6J^NGHG\/(IACP&#xD;&#xA;M&lt;&quot;BPQ(U&quot;]*F&quot;[NM+%$&lt;\U;$7M3L,K-&quot;&quot;*J26QSTK8$8Q2&amp;$4N4+F(+8@]*G$&#xD;&#xA;M9&quot;UH-&quot;/2FF'CI2Y0N9A4[N:CEB&amp;,XK0:#!J-XN.E%AW,Z-2#5R,\C%-:+%$1&#xD;&#xA;MV\&amp;@3-2%@5J=15&amp;!B*NH&lt;\U29#'8.[VH84XL.E1DU38)&quot;@5&amp;[JO4U5NM02W'&#xD;&#xA;M)K%N-5,APAJ64;4M]'%U-9USK`;B,FJD&quot;O&lt;M\QR*TDT^'`RO-(&quot;C%-+/G)-3&#xD;&#xA;M&quot;S+,&quot;:OQVJ)]T8J79MJD!%#;H@QBI3!'GI3L9-.R`V#3$,,8QP*`&amp;4&lt;=:E(]&#xD;&#xA;M*:%R&gt;M.P%=6D$F6JUNW+4;X6B)PQQ18&quot;4+F@?*:&lt;V0.*CSS18&quot;3@TF:!TI#3&#xD;&#xA;M)'9I-U-HH`&amp;DQ300U&amp;`3S00%'%(8XJ`*9U-&quot;L6-.QBD``&quot;G?*#30*&quot;IS0%R8&#xD;&#xA;MXZBJURAD'O4P&amp;*5B,T@N9T*/$_-:&amp;2Z\U&amp;Z9Y%20C`YH`&gt;N`N*B&lt;\\5-@9IK&#xD;&#xA;M(&quot;&gt;HHN`P'BF')-2OM5&gt;HJ%I54&lt;XH&amp;.&quot;^E+@U&quot;+Z),YJ)M6@S0!;VD4H7(K.;&#xD;&#xA;M58STJ-M65&gt;E*P&amp;N!MX-(P0CCK6.NK@GG-/\`M^XY&amp;:5@-5%-,N(&amp;D6LHW[[L&#xD;&#xA;M`FIEOGQR33&amp;7K:)E)#]*D:%03BL_^TU3K2_VD#TH`NB')YI_EE1Q63)J+`\$&#xD;&#xA;MU$=3&lt;]S0!L\=Z,KTK&quot;^W.QZFG&quot;YD]30,W`!G-..&quot;.:P6O)!W--%_)GJ:`-\`&#xD;&#xA;M=J48[FL$WDI'RL&lt;U`=0G0\L:!'2,JCI4&gt;_MFL'^U7QR34+:C(3P30(Z!R2&gt;#&#xD;&#xA;M2`!A\Q%&lt;Q-?W'\+&amp;BWO[@M\S&amp;G8#J.%/%/\`O5EPW1*\U'-&gt;2*?D)%`&amp;I*`H&#xD;&#xA;M]ZCC89YK$;4GZ,2355]3&lt;/@$TP.J\X`X!J0Y9&gt;*YB._;`))K0M]70##46&quot;QI&#xD;&#xA;M&amp;+TIRJ5JHNJ19JTE[$XX(H`EX--\H%J!,G8BGAUZYH`:R%14/.:MA@W&gt;D(2@&#xD;&#xA;M&quot;(#BC%/X[4E,!G&gt;@T\+36XH`;BD)P*&lt;#FFR&lt;&quot;@!@(S3R*J!CYE7D&amp;1S3$0D'&#xD;&#xA;M.*-O%3%&gt;:0KQ3`BVC%*%&amp;*?MXIRBD!2DA5B&gt;*J/IVXY`K49&gt;:8&lt;@T#,EK&gt;&gt;+&#xD;&#xA;M@=*@&gt;6&gt;/N:WBH8&lt;U!+;(W:D%S/MM2=3\Y-:T%_')5'[)&amp;/X:5(-K?**0&amp;H95&#xD;&#xA;M8Y%*.&gt;E9[[XUSFJQU/RCALTK`:-PC]JFMB=N&amp;JK!J,4ZX[U81QGBD`LW!I%F&#xD;&#xA;M4&lt;&amp;I&quot;`_6F-;YY%,`95D.4J-U=1FI%C93P:G`!7!IB*&quot;SA3AJF#*_W:)K=3R!&#xD;&#xA;M5&lt;!DZ4`3E1FF-;I)U%-+'&amp;:$D^:D,C:U&quot;`[167&lt;6Y)Z5T)*E:A:%'[4QG,/:&#xD;&#xA;M;AR*J/;.A^6NK:T'I526T'I0!C03S1=S6M:ZKP%&lt;\U`UI[51N;=HSE:06.IA&#xD;&#xA;MNHY.]6LJ5^6N'BO)8CRQK8M-19E&amp;31&lt;5C&lt;R0:02*QP:K)=*PY-*HW-E30!8:&#xD;&#xA;M(GE:I7B-CWK21]JX-,D19#TJ0.?+S(W)XJ[:WB9`/6KTEDK+TK,ETYTDW)Q4&#xD;&#xA;MC-;&lt;&amp;7(H4^M9T4K1L%8UIQNA3-4@!D##FJ&lt;MFAR0*O\`6FLR@8JA'/S+)&quot;V5&#xD;&#xA;MZ5);ZH4(60UJ/&quot;DN&gt;*Q[S2WSN2@:-J.YCE3Y333NW&lt;5SBRS6K8)-:5OJ*M@$&#xD;&#xA;M\T#-;&lt;0M)N382U$3+(N13GB#(0*!$'F(&gt;E,;&gt;3\IXJC=K)`2&lt;\58L+CS%&amp;:&amp;&#xD;&#xA;MP1:CW]&amp;I[9[4F-S&lt;4V5_+7FG&lt;`V''-4;BSCESQS6A%.CKB@1@DF@#GS#+;OD&#xD;&#xA;M=*OV^HA1M8U:N805QBLB6T&lt;-E:!&amp;]%*LO*U88#9[USD$LD!^8FM6WU!'(#4`&#xD;&#xA;M2E&quot;#FHV7)Q4LLJGI3208\CK3`B:#Y&lt;BJDJ#H:T$R1S2&amp;%6/(IC,.2`#D&quot;EM[&#xD;&#xA;MAHFVM5^XB`Z&quot;J$L7?%%@-B*ZB6/GJ:IS2B27*UFL9/6I[0Y8;JAH9H&quot;60+M4&#xD;&#xA;MU/%YFS+5&quot;XQR*M6\J-%L/6IN`@&amp;\U!&lt;0Y7`%7UC`Y%5Y&lt;[J=QF+/:E1D#FH(&#xD;&#xA;M`=^&amp;K;*!^,53GMMG(%#0#9(?D!6GV33!NM5&amp;G=&gt;#4D%QM[TK&quot;-J6)9UP_)K*&#xD;&#xA;MN=-*$E!4OVIR1@U&lt;CD\U,-S1&lt;#%C'EM\]:=M=QC`!J&quot;\M3R0*S#YD39YH`Z&lt;&#xD;&#xA;MA9EXK-NK/.&gt;*;8W9X!-:6Y9118$&lt;]%:R)-GM6]:.54`U#-%CD5!$[J_-%@9L&#xD;&#xA;M\,M595&quot;FIH)`5YIDXS43!%?/%-I.&lt;TN*Y);E`3333]M&amp;VH*(=M/5:D&quot;4\+3L&#xD;&#xA;M`S;FG(N#2GBGIS3L(5H@R\U1EA*GBM(&amp;FRQ@K5)!&lt;R@M3QC%+Y&gt;*%X-.P7)P&#xD;&#xA;M!BG!L4U&gt;13MM:(AD@((I&amp;04+Q3BPQ5W%8C\Q4%4Y[@D\&amp;I)SZ53VEFJ6RDA&quot;&#xD;&#xA;MS-3-I)JY'!FI?L_M4JY17A2KD&lt;?-&quot;0XJRJ@5M%DL50`*D`-(%R:5W&quot;+5W):*&#xD;&#xA;M]Q+@8S6&gt;T9D;-232%WJ6%&lt;&quot;D)(D@0J*DD&lt;!&lt;&amp;E7@54N9.:&quot;BM+&amp;'?-1,F&amp;JT&#xD;&#xA;MGS&quot;D:/)JD@)+8C;BK6W/2J\&lt;9%6HQBJL)BQ@@\TD[`+4PQ69?2E:EB(?)$DF&#xD;&#xA;M:MJI4`55LY-S&lt;UHA,T(8J8`J5*85Q3AQ5&quot;L073D(:YZ:&lt;^=C-;]Y_JS7-S*3&#xD;&#xA;M/FID6C2M%#8S6LBA5XK*LN`*U5/RT1%(4`DT\&quot;D'6G59F+0&gt;E`IK-@&amp;D-%.Z&#xD;&#xA;MJDL8+9J2[G^;%%L=W-(M%B/Y&gt;*G7FFB/C-.44Q$RBHYI`JTN[`JC&gt;2G!J6,3&#xD;&#xA;MS@SXJU'@UC1LQ&gt;M:VZ&quot;DA,M!:7%.7&amp;*6K1(VD-/J-NM#&amp;A&amp;)&quot;UE78#,?6M*0&#xD;&#xA;MX6LF5OWM1&lt;H@$)S6A:J1UJ.-0PJT@Q5H&amp;2FI4`Q4/6I5Z4R!::2:6FMQ2&amp;4[&#xD;&#xA;MI2&lt;U#`A4U:;YC0$`H`&quot;&gt;*=&amp;N34;=:FBH`DQ3A@&quot;EJ*5L+0,S-0)&lt;X%5;6)E&gt;&#xD;&#xA;MK,AW/5J&amp;(8SBD!:C;&quot;`48R&gt;:%2I`*I&quot;'+TIV*3I2TV(.](S;5IPZU6NGPIJ6&#xD;&#xA;M-%.YGR&lt;`U2,9&lt;T-N&gt;2K&lt;4&gt;!S2**HM3G@5=@1E'-2JM2*,4[&quot;;'&quot;EI0**9(@.&#xD;&#xA;M*7=332#.:`'TN:2FF@8XM3&quot;X-(:C?(J6-#9,&amp;JDC%&gt;E2.]4Y7-2,4SGL:&lt;LI&#xD;&#xA;M:H%0M5F&amp;$YIH9/&amp;F&gt;M3&quot;'VIR)M%2_P`-4B1J*!4G%-%/`IV$1D4`5)@4&lt;4`1&#xD;&#xA;ME:`,4\D5&amp;S4`2Y&amp;*#(H%5BQJ-BQ-`%EI14$DAH4&gt;M(P%,!@+&amp;EPU31(#5CRU&#xD;&#xA;M]*`*8C)H\DFKFP&gt;E.&quot;T@N4/LY]*&lt;(FJ[BDV46%&lt;J&gt;0333;'L*NXQ2T6&amp;4/(=&#xD;&#xA;M:&lt;%8&amp;KN,TTI[4[#*IS3`3FK9BS3##2LQ#`^!S39)L#BI#'Q5&gt;2(FI:8%=[QE&#xD;&#xA;M/6G)?`]35&gt;X@:J)#*:FP&amp;]'&lt;JW&gt;I_,!'%&lt;]'(^[K5^*9@.33'8TL9IOE\U%'&#xD;&#xA;M&lt;#O5A)5:J%J-\DTTPYZU:!R*0BE8:,Z2V7TJK&lt;08A7']ZM9TS4%Q#F!?]ZER&#xD;&#xA;MC*]E'NT^WX_A%:$&lt;85:CL(=NFVQ_V15HT[:A?0BQ2!&gt;:DQ3U7FF2V(J581&gt;*&#xD;&#xA;M0+Q4JC&quot;TR;@I[4Q@5))-.7Y6R:HZC?+'&amp;0#2DQI&amp;?K6H!(RH-&lt;4[M+,2&gt;&lt;FM&#xD;&#xA;M'4)VG&lt;\U4MU#/R*Q&lt;C9(O6D9(%:\,.:K0*`HP*T(5.::!LL0PX'2KL:C;3(E&#xD;&#xA;M&amp;VIEZUJD928#BI!S3&lt;&lt;T]15$CP*&lt;*/X:*EL=A:&lt;HIH]S4-Q&lt;&quot;-:5P'3N%4MG&#xD;&#xA;MI7*ZG=M-&lt;;$)YK2FO#(&quot;H[U6AT\R2B0B@:)M+MVV`-6IY&amp;UZ=;P;%!`Q4Y&amp;:&#xD;&#xA;M5@&amp;@?+30IS4P&amp;**I(D5&gt;E!HHQ3`.*6FD&gt;]*![TAAFEYHZ=:B&gt;X5:FX6$EF6,&#xD;&#xA;M&lt;FLNYN]QPM5]0N&amp;&gt;8A2&lt;400DIN;FD.PJJS\FK5N?+-+&quot;5)VXJPD66Z4QCPI8&#xD;&#xA;M9S0(!G)%/V%&lt;5+CBJ2)N1A!G@5)@8H6G%&lt;U5@N-%%.Q246&quot;XFVC;3Z&quot;.*+!&lt;&#xD;&#xA;MB,8-021U:)P*8PS4L=S,E7%5CP&lt;UHS1U2FC(4U#*%CER&lt;`U?A)QUKGC=&gt;1)S&#xD;&#xA;M5L:Q&amp;%ZBIN.QM.X5&lt;DUEW&gt;IK&amp;I`/-9=WK)92!6;&quot;9+J;)/!IW%8L3O-&gt;2'!.&#xD;&#xA;M#4EO8,&quot;-PK7L[5$0$@9JX(%SG%-`5+&gt;#RP.*O)THVC&amp;,4[&amp;*M(0J]:&gt;1FF`4&#xD;&#xA;MX4[&quot;N)VJ)Y-AY'-6&gt;U1N%*Y(I`,BDWFHKQ)=N4.*DC(#]*L%E&lt;8(I@06JF2$&#xD;&#xA;M*W6E6$I(:=G8?EXIPSUH$2$_+43&lt;T\G(IH6@`7@44H%**+B&amp;XII-38XJ-EHN&#xD;&#xA;M`WDBG!21S3E3C-/ZC&amp;*5QV(\`=!2=33]AZFDWJO&lt;47'83::-ISUJ)[M$[BJ4&#xD;&#xA;MVLHAP!FE&lt;=C5X7J:CDE3U%84NLM(&lt;`&amp;J\MU*XXS0.QT/VJ-4Y85&amp;=0C4=17*&#xD;&#xA;M.;ESC&lt;:DCM;AOXC2'9&amp;[)JRAN*JRZLV.,U!#ITA.6-7X]-&amp;.1FBP.QG_`-HS&#xD;&#xA;M2'J:&gt;)I9.,FM$6&lt;:_P`(JPEHHYVTR3G[F&quot;?;D$U1BMIY7^]7731Q&amp;,@XK*$:&#xD;&#xA;MI-\I'7M3$5X],F(R6JS%IQ'WN:TU;RX\D4Q+E7;`%`$(LHU'W14BVZ#^$5&gt;6&#xD;&#xA;M(,N&lt;TUX\&quot;@+E`VH+9`IX@4#D5=1!BF2)Z46&quot;Y0EM0_04P6945&gt;4[3R*E!#46&#xD;&#xA;M&quot;YEFW]11]E']VM38N&gt;E+Y:XZ46'&lt;RA;+GI4ZVZXZ5=\H=J7RZ!7*+6RD=*8+&#xD;&#xA;M-&lt;]*T-E*%`ZT!&lt;I?9`!TJ-K)3_#6GD4G%`&amp;2UBO]VF'3P&gt;@K79!31@=J8&amp;/_&#xD;&#xA;M`&amp;&gt;`&gt;14J62+_``5ILH)SBD)4#&amp;*+`54@7'`I'M5STJXFT^U#ISUI`9&lt;MI'C[&#xD;&#xA;MO-4C8J6^[70&gt;6.XJL\(W&lt;4`9?V,`=*AEM]H^45NB#(IK6P]*8[G.&amp;UG/()H`&#xD;&#xA;MN(OXC71BW4=J9):*PZ4`827&lt;X/4U:BO9=P!)JW]A4'[M(UF.PH`&gt;-1\L&lt;U$=&#xD;&#xA;M9&amp;_D&amp;FFS)JO+98'`I`;5MJT+J`0*M+&lt;QN&gt;&quot;*XUK:96^4D5(LEQ&quot;,EF-`':!T&#xD;&#xA;MQU%,90QX-&lt;JFH2KU)JW!J[#J#0(W@FTT-'YG2LY=74CD5*FIHQZB@&quot;?R-K9J&#xD;&#xA;M91BF)*DO.X4YB%/!H`4CFC'%(&amp;W&amp;GT7)(R*4&quot;@]:4&amp;BX$;&quot;D$&gt;:E/2FBG&lt;9!&#xD;&#xA;M(K#I21@G@U-O'&gt;CY&lt;T&quot;()(_FR*0#'-3N1493(IV!#&amp;92,$56N+1)5^5&gt;:MK'&#xD;&#xA;M2JOSXI6&amp;8HL98FRIQ5N-WB7YB:T-BYYJ*9%QTI6'&lt;@6^.&gt;AJW#&gt;J&gt;M55A4]L&#xD;&#xA;M5'):.&lt;[6Q18#4,RL&gt;&quot;*&gt;I![UA&quot;*:'JQ-2+&gt;/%U!-`&amp;X0,5%L4]JH1ZLIX88J&#xD;&#xA;MW'&lt;)+T84`*T0Q58KM:KX`(QFHVAR:0%?)Q34&lt;[NM3B/&amp;:H&gt;=LE.12`T!R*C&lt;&#xD;&#xA;M+GD4L-RK#&amp;*AO9=BDBG&lt;9)Y&quot;NN0*IW5ENC)Q4UA&gt;!HCFI7ND9MM(#FI;$@]*&#xD;&#xA;M6.,QKTKHS&quot;D@X`J&quot;2Q%(9B&gt;&gt;Z'O4MOJFQ\&amp;K4UD,=*RY+1D8G%`CI8=1B=1G&#xD;&#xA;M%7$='&amp;017$[9E/#$5&lt;BU!X,!B33L(Z[!)X--D3UK-LM460&lt;FM-9TE7J*+#1F&#xD;&#xA;M7&lt;7.5J&quot;W\S=@MQ6I+;[CG-5S%M/`H&amp;RW&amp;IV=:KR@A^M2(2JU6E&lt;ESQ2)'J^V&#xD;&#xA;MK*;9%P:SB2.:FAN`.]`QEY8)(&quot;0!6!/:2PL2N&gt;*Z@S!J;Y22\%1S0,Q=/OG3&#xD;&#xA;MY7S6TEXG'-4[G2]OS)Q63,TT,G?%4A,Z.98[@=!5?[/Y0^48JC::AT5N*UXW&#xD;&#xA;M65.HH8$$.[=R:9&gt;;F7`JPXV]!34`=OFJ0*ENK&quot;IA&lt;%&amp;P:M,B`8'%5)HQG(IW&#xD;&#xA;M`M+B49IC1`4R%MHIWF`GDU28$$ELK=JS+FWDB?&lt;AK&lt;`W=*:T2GAAF@#(@N6Q&#xD;&#xA;MM?.:TK&gt;0-U/%03V0SE&gt;*IN[VX[T`;V5[4$9Z50M)_-0&lt;U:4D&amp;F(:\&gt;&gt;M5I(-&#xD;&#xA;MW2KLC9'%1F,]:8&amp;;]GSVJ*2,Q&lt;BM9@,&lt;&quot;JDB9H914CN\'#U&lt;B&lt;,&lt;J:S+F$YR&#xD;&#xA;MO%1P7+0/\QK)H#K(3\G)IDNTUF0:B).!4AD8MG-(&quot;\L(QD5%/'D=*2*YZ*:O&#xD;&#xA;M%%:/-4F!B7-NI7@&lt;UER(T)SBN@&gt;/YJ@FMUE'2J8&amp;/%=@=16I97:'%4)[(Q]!&#xD;&#xA;M201E3UQ4,#H79)1C%4[BS4H3BDM\EA\U7GC^3K0(YJ;=`WRU?L+O^]5J6T5Q&#xD;&#xA;MR*RKF!X22M4AHW(IXY7*TDL`Z@5C:?(PEY-=&quot;&quot;&amp;C%.PF4T)0U(9P&gt;*=-%QQ5&#xD;&#xA;M)U*M6-1`B&lt;X)I&lt;BHD)(IV:XGN:(?NI0U1THH&amp;3`BC-,%.JD(0\T]*0&quot;EZ55A&#xD;&#xA;M#L\U*#N%0BG@XH$,D05688-7&amp;Y%0,O-,8(:F&amp;*JEMM)YY%%PL7.!4,DF*A,Y&#xD;&#xA;M(J/EC5)@*07-/2'O3XU]JLJF:H5QBC%2@9H*TX#%.PK@%IV*0FF,^!1&lt;&quot;4.%&#xD;&#xA;M%59Y&quot;W2F-(2:51NJDP(4C).35I$IZQC%.QBJ0QDIV)67*2S5=N9.U55&amp;:&amp;Q#&#xD;&#xA;M8GP&lt;&amp;KJ`-S5)E(-6K9CTJHL&amp;656I,8I0M+6A(PM@5GW2^95^0?+6&gt;QS)BE(!&#xD;&#xA;M+6$HU:2\+442C:#4P%)(!1S2G@4T?+2N&gt;*8&amp;=&gt;RXR*SDC$C9JQJ+$$U!9-DU&#xD;&#xA;M+*+D4&gt;TU&gt;CZ4Q%&amp;*F48II&quot;8[M3EIM*IYJB!_2HI?NFI,U!&lt;OM6DQHRKB,L]6&#xD;&#xA;M+:/:*C5@[U=08%(H&gt;#Q3UZ4@'%&amp;#3$*V,5F3C&gt;Q%:;C$6:R6?]^:30Q8X.:O&#xD;&#xA;MQ+M%-C4%0:G&quot;TD@'AJ&gt;#46*&gt;M6(?3#UI],-2P1!.&lt;*:QY?OUJ7)X-9C&lt;FH11&#xD;&#xA;M/;M5P=*H19!J^OW:T0F.7K4XZ5`O6K`'%!(T]:;)]VE;BF2-Q3*(.]/'2HQR&#xD;&#xA;M:?TH!AMS3T&amp;#35J51S0(?VJK&lt;M@5:;A:R[R7G%2QHB4Y&gt;M.``K6;;IN;-:&lt;0&#xD;&#xA;MVBD#)1Q3Q3*&gt;M6B1W:D%.QQ0!0`QSA:S;F7/&amp;:OW!VH:Q)F)&gt;D-$T*@MFKJJ&#xD;&#xA;M,54AZ#FKL:YIV&amp;.48IV!2[:3.*=A,7%+BDS1@FBPA#UH`I,4HI`.Q2;:44Z@&#xD;&#xA;M9&amp;5J&quot;4@&quot;I)9,52EDS4C(9'&amp;:A*;J?M+-5N*#/.*+!&lt;A@@]:NI%BGA`.U/`IV&#xD;&#xA;M&quot;XPBE4&lt;4_;FC&amp;*8@&quot;T$8IC/MIGG9I@#28J-I&lt;]*&lt;1NH6*@!H8FGA34B1BG.`&#xD;&#xA;M%XH$0$`4PLH%,E8YJ##,:0R4R&lt;\4W)-((S4R1^U%P)8,U:`J)$Q4_;K2N(3%&#xD;&#xA;M+BC/O3LCUHN%AE**=\OK2''K57%80@4F*,^]*&quot;/6G&lt;JPH6EVT9'K1D8ZT[C&amp;&#xD;&#xA;MT8S13@*+B(RE,:.IS3&quot;*0BJ\`852FLL]JU0M*4!%*P&amp;#]FVGI37!45N&amp;`'M5&#xD;&#xA;M::U![5FT68WG$&amp;K&lt;$_2FR69S2+`RFF(VH6W**DJI;28&amp;#5D/DTT(&lt;13)Q_HR&#xD;&#xA;M_P&quot;]3\YI9A_HJ_[U588EIC^RK;_&lt;%'&gt;BS.=+MO\`&lt;%2!&gt;&lt;TNI-]!H3-3(F*4&#xD;&#xA;M+3P,&quot;D(*4?,,4F?6J\]TD&quot;EMU)L:1%J%V+&gt;(C/-&lt;9?ZBTCGFKVK:AYQ(!K&quot;9&#xD;&#xA;M2QR:RDS5(?$WF'FK2P&lt;@BJ\&quot;&lt;UK6T?K4(HGMHB,5IQ1\5%!'TJ\@P*WBC.3'&#xD;&#xA;MQ&lt;&quot;I:8HJ059D/4&lt;5(!3(QEL5,PP.*!H0+2&amp;E7.*@EN!$#FI915O;WR!6:+I[&#xD;&#xA;MIL`&amp;FW6Z[EP.F:T]/L%B7)ZU($&lt;&amp;GG(8UHQQ!&gt;U2@[1C%+5)`+QCBFT4H%4(&#xD;&#xA;M,48HHJA&quot;@4IH%!J6.PUNE1;C&amp;&gt;:E`!Y/:J-[&lt;HIP#4,+$D]T!&amp;:R'N69^].:&#xD;&#xA;M0R&lt;9I%BQUI%HAV;WR:NQ+\N*B&quot;G=5N)*:0V.CC^;-75'%-1.*E455C-L;BGX&#xD;&#xA;MIO&gt;G]J8A!2T@I:+@&amp;&gt;::W)IU(PSWIW`4=*&quot;&gt;*:&quot;&gt;E*Q&quot;KDT7`:W(Q3OE1&lt;DU&#xD;&#xA;M2N+T1]*S;C5F88`J&amp;RD;#-&amp;2&gt;16?&gt;74&lt;2D&lt;&amp;L234I@3@&amp;J&lt;MQ+.&gt;&lt;U#+0E_)&#xD;&#xA;MYS_+Q5%89,_&gt;-7D@9CDU+Y/S=*S9:*2VY)YK3M+;;C%&quot;PXYQ5F)MK`4(&amp;:ML&#xD;&#xA;MA&quot;&quot;K`XJ&amp;W?*BIS6J(8@ZT[%-7K3ZU1##%+110(&lt;#Q33\U%*!4L!GEXHIYI.M&#xD;&#xA;M`#,4X=*=LI0G-`A!2XI=N*&gt;%XYI7&amp;-Q2[:1F&quot;]Z@DO$3N*!EG;Q43L$ZFLZ;&#xD;&#xA;M5RO&quot;C-9\VI2R'I0!O?:T4=14$NJI$.QKGS+*WK2&amp;&quot;64&lt;YH&amp;:LFO[N%6JC7TD&#xD;&#xA;MA.`&gt;:CM[`[OFK12U50.*0S-*ROW/-(E@['))K;%LO7%.*A&gt;U`&amp;=%IX':K0L5&#xD;&#xA;MVYQ5R,`BGX[4T(H)8J&gt;&lt;59BME0]!5C&amp;!TI`13)N.$28XQ2,NQ&lt;@9J%RX;@&amp;K&#xD;&#xA;M,+[EPPIA&lt;J@[FYXJR&quot;&quot;F!220KG(-,4%#[4AW,R]B;.-Y&amp;:K6]B\&lt;@?&gt;6K5N[&#xD;&#xA;M&lt;2KE3S5&gt;T+Q-M=?SH`NX\V$KC'%5([$K)G-:.%*\&amp;JTTYAY`S4M@6$C(XS0_&#xD;&#xA;M!QUJ.WO!,,-Q4Y4?6A&quot;(=V*0#&gt;U#KS2+\IJ@'30_+Q4$8:,\U&lt;#[AS2$!J`(&#xD;&#xA;MP1UI7?/04TILIR#(S0!'YFP&lt;U(L@D'%1S0EUR*CA1D.#0!,QVU%*&lt;IP:?(I8&#xD;&#xA;M\5'L/0T#'PDLN#4F,&amp;FP[&lt;XS4I4=C0`S%,/%2TUEIB(_,V\48WTUH\M4@&amp;T4&#xD;&#xA;M`5I@T9R*6&quot;0MP:L[!*.:C$(C;BD!)M.*KE3OJT&amp;QUI&quot;5)H`9R%'%`&amp;&gt;M2@K0&#xD;&#xA;MR[ONTT(@9&lt;=*:*L&gt;6`IR:J;COP*8[DC&lt;CI31@'&amp;*DVTH5=W)I!&lt;9L!IKVXQF&#xD;&#xA;MK!CQR*:W/%(95$&quot;,&lt;8%-DL$8&lt;8J&lt;KBECZT@N9C:&lt;,]*/[.&amp;*U2.&gt;E'X4P,&amp;6&#xD;&#xA;MP;/!JJUO+&quot;&gt;IKIO*R&gt;144]JKKTH`P4O)(N,FKD.KD#:PIS::&quot;V:KRZ&lt;V[@4@&#xD;&#xA;M-BWU!#@DBKJSI+T(KE_LDB#@FKMH9$'.:`-MW4C:#S49W+6:;EH9&quot;QJ:/5$E&#xD;&#xA;M^4X%,=B&gt;&gt;5@!@4^&amp;0[?F'6D26*3N*D901\M(5AC)NY%5I&amp;*M5@$J#FJLSY:F&#xD;&#xA;M*Q(LA+8JTH^6J&lt;1RPJ\H('3BJ3$*@!.*KSYC)(J?/--GY3FBX%1`S-G-6,9&amp;&#xD;&#xA;M&quot;*2-!4@&amp;*0R)X\].*0+M[U/D$X--EB(&amp;12N,K,P#8Q3O(CD3G`I-I)Y&amp;*?Y&gt;&#xD;&#xA;M5ZTK@9EQII9LHWY5!%#-;/G)-7Y)W@DP5R*LPSP3+\Q`-,&quot;FNHNG535F+40Y&#xD;&#xA;MYXI9K1''RU0FL609&amp;:`-E65QD-UJ&amp;6U67IQ6(MY+;MC!J[;ZD3]ZI8%M+0QG&#xD;&#xA;MK4=W&amp;60@&lt;U;CNXY1RPJ0(A]ZD#`BC=#CD&quot;K26WF-G=6A&lt;VX*$H*S`\L+?=-,&#xD;&#xA;M:)BS6\F.2*G\W&gt;NZJ;7:L&lt;-@&amp;K4*+(@P:!B??.,5');*U62GEU&quot;S8/6F!2DM&#xD;&#xA;M@1PM9UQ9L3TKHXP&amp;ZBB6W5QTHN(Y98Y(&gt;A-68-1DBZYK3DL0,XYK.N+/8W`I&#xD;&#xA;MW`T;?5@_!K2CD21&lt;Y%&lt;EY#(V035R&amp;^&gt;#@T@9T6.:0J!U%9\&amp;K*&lt;9(J^LJ3+D&#xD;&#xA;M-2$,FB!3(K*=75^,UL.&quot;%J!TR.E`RO`VX&lt;FK&lt;&lt;H4UGF*4/PIQ5J&amp;'.,F@9?$&#xD;&#xA;MGF+C%5IK6-T/`S5D`1)347S#FJ0F&lt;Y&lt;V+HY9&lt;T07;VYPV&gt;*Z&amp;6-2=N*R[VP#&#xD;&#xA;M*2M4!;MKV.X`!(JTT(&quot;[E-&lt;DHFM9&gt;^*W[._#QA6-2T`VZN&amp;3BJT-R[-R&quot;:OS&#xD;&#xA;MPB89%110&quot;/.14@/!R.N*J3[U/&amp;:?*3O&amp;VK*('3YA0!'9SG;AJNG#+D55%N%Y&#xD;&#xA;M!J1&quot;1Q3`DQ\N*JW5N)(^E7!S2%,U2`Q$#P-WQ5Z&amp;[#&lt;&amp;IY+=6XJA+:M&amp;V033&#xD;&#xA;M`TA@C.:&gt;&amp;'2LM+MH^#5R&amp;99!DFBXB5EQ^-,,&gt;12LYSQS3P=PH&amp;498,]JS[BS&#xD;&#xA;MRI(K&lt;*8[5&amp;T(9:+`&lt;W&amp;[6\G-:L%TKKS4=Y8@J2*RV+PG`S2:&amp;;H?&lt;WRUH)(3&#xD;&#xA;M&amp;`3BL/3KD;OG-:S2HRC:U1L!80!S3G@V\U!&quot;Y'3FI'G&lt;#E:=P(I4##&amp;VLV:W&#xD;&#xA;M9,L*U%F#'FG2QJZ4Q&amp;''&gt;M&quot;_(K1BU$2#!JG&lt;6?4BLUV&gt;%^*E@=4C&quot;1&gt;*CFMQ&#xD;&#xA;M(,8K,L+[D!C6G]LC8X##-)#,\V1@?&lt;*M17F,*&gt;U:#1K-#6+=6[1L2,UI%B9K&#xD;&#xA;M(XE7(-0S1Y.:HV5RR-AJTY'5TX-*:N@14`I2,4B@JU*WS&amp;N&quot;:U-$)0**!4(9&#xD;&#xA;M**&lt;*C%/%6A$@H-`HIB$`IXI`*=30AIJ-^E2FHGIV&amp;BNPR:;LJ;%.&quot;TBB`)4R&#xD;&#xA;M)2[.:E1::)8JK4BK3@M/`XK1&amp;=Q`*8YQ3R&lt;57D;-44,:2FC+'%*JY-3QH`&lt;U&#xD;&#xA;MFP(/*J5%Q4^T4F,52`0&quot;ED(&quot;45!._P`M6!0N&amp;RU-B/-#C&lt;:0#;47*L6-H:IX&#xD;&#xA;M$VU7B;+5H(O&amp;:TB2QX.#3CS3`/FIYX%:$E&gt;Y.V.LF-R9SFM6XPR8-4(X/WI(&#xD;&#xA;MHN,OQ\H*F'%0H&quot;HQ4HJB6./-,?I3Z;)Q&amp;328T9%ZNXFHK2'#`T3RYFQ5RV7*&#xD;&#xA;MYJ1EI!4F.*1`:DJTA7$`I,'-/`I&lt;4&quot;&amp;XQ5&quot;_DXJ^QP#65=L';%2,KVI)?\:U&#xD;&#xA;M5Z50MH&lt;'-7Q0!*G2GU&amp;IQ4@YJ@(YS\E9+IF2M6XX2LW(\RD!;B!&quot;&quot;IQ3(QE!&#xD;&#xA;M4BK0,6G&quot;D-`-,0[-(&gt;M+334L$5[K[AK-4@MBM&amp;ZY0UED%6S4E%N,#-6%%4H9&#xD;&#xA;M/FK07!7-6A,1/O59'2JR_&gt;JPO2@D:]5G:K+CBJ$S8-,9(G)IS#FH8B:G!S0-&#xD;&#xA;M@M2KQ3`*&gt;*!&quot;NW%8]QS(:TY#BJ+)N&gt;I90ZT7FM$#BJT&quot;;:MBFD2PJ1::*=3)&#xD;&#xA;M)!]VD'6FTC'&quot;YI#13O'Y(S6&gt;5W4^]E.XTEJ=^,T%#XHR#6C$,&quot;D2(8J3;BF*&#xD;&#xA;MXN,TTBGBD:F(:!11FE%%P$QQ0%J04XCBD!&amp;*;(P`I6.VJ-Q-VI#(9I&lt;MBD1=&#xD;&#xA;MU0C+-5R),4#'1P\]*MA0%IJ`5+QBG81&amp;!4@7BF@4I?:*8&quot;-Q43/222YJ%&lt;L]&#xD;&#xA;M`AKY)IR(:L+&amp;&quot;:E$0`H`A5:&gt;%Q3]N*&lt;!0,;BD*9%244A%*2'FE6(8Z58&lt;BH7&#xD;&#xA;MG5!2&amp;.6$4K[4%4GOL'%0/&lt;EZ5QV+INE6H_MHSUK-=F-1\YZU+8TC4:]J,WQ]&#xD;&#xA;M:S^32E#1&lt;=B\+XYZT[[:36;@@U(HS3N%B\;[`J(WYS5=H\BHMF#1=A8T4OS4&#xD;&#xA;MRWF&gt;]9:H:=M84KB9KK=CUJRMPK&quot;L!&lt;@]:LI(0.M-,31K%QZTH(/&gt;LU96-/%P&#xD;&#xA;M157$:(%!&amp;*JI&lt;^]3K*&amp;[T[B'4%0:=QBC-`$!B![5$T`JWC-)LS2L!FE&quot;K&lt;5*&#xD;&#xA;MCXZU;DA&amp;*J21$=*!DROGO4DS?Z*O^]5!7*GFK$DH-JO^]5!&lt;L6`SI=M_NBK2&#xD;&#xA;MK4-@/^)7:_[@JWCBDR.@W&amp;!Q2*&quot;&gt;M.W8XI9)52`DFI;*2*UU.D49^;FN0U/4&#xD;&#xA;M'=V53Q2ZSJ;^&gt;RH&gt;*R4=Y&gt;3UJ&amp;S5(9EW;G-6XX-PJ2&amp;V9CDBK\-O@]*EHHHB&#xD;&#xA;M`IR!5ZT5G/(JXML&amp;QD5&lt;BM5CZ548DMCH4PM3@4JKBI&quot;.*TL9#1TJ5!484U*G&#xD;&#xA;M`H&quot;Q)C;S1YGK3P,K52=UC')H`EDN%4=:R;MFG;`IDLY=L+5F&quot;/H:!CK*T&quot;\L&#xD;&#xA;M*T0,=*$`VTN:$A&quot;]J;S13@*8`,T[FG*.*#0(3M33Q3J0T`A&lt;\4F:=@8JO,X1&#xD;&#xA;M3S2;+2*M[&gt;^2I`/6L&quot;6:263/-6;QS))UI%B..!4,=A]N&gt;1FK_E;AD51C0@UI&#xD;&#xA;MVW*8--&quot;;$2`5.D86GXQTIXJD3&lt;4'BG+30.:?CBJ$,/6I%Z4A%**0&quot;&amp;D!I213&#xD;&#xA;M&quot;&lt;4@'YIA&amp;&gt;:&lt;&quot;&amp;&amp;:J7-XL:E0&gt;:0R9KB*,&lt;L,UG7&gt;HK@A&amp;S5-DDN),G.#3VTY&#xD;&#xA;M0F&gt;&lt;T#*ZR-&lt;OBI?L!ZFI[2U\M\UHX!&amp;*0S)_LU6'(IC::%[5LL&quot;O04A7/6DQ&#xD;&#xA;MW,06VTXQ2FW`-:4D7/%0M&amp;?2H:&amp;F46`!Q3`F7S4LR'=31P*5AW+=N^WC-7@P&#xD;&#xA;M(K&amp;27YZT(7R!5H3+@%+2K@K32&gt;:T1FQ:7%-S3UJA#2*56Q3B*84.:0R7`84W&#xD;&#xA;M;@TY#@4K&amp;@0T$=Z&gt;%7KFHGDB4&lt;MBL^XU`+Q&amp;&lt;T@-&amp;26.,&lt;M5234HQPK&quot;LB:&gt;&#xD;&#xA;M&gt;;L:BBM79\MFE8HN7%](?N#-9[22RMSFMB.VC&quot;8[T&quot;S&amp;&lt;@4)#,^*U+#FK26*&#xD;&#xA;MGK5^.$*,5*(Q3$9_V0+P!5F.$!&gt;E3%&lt;'%**`(O*YZ5(L0-29`%0F7::5@N3;&#xD;&#xA;M.*;Y8[TZ)]]1W)?&amp;8QF@+C@F#Q3)G*&amp;FVL['A^M+&lt;C&lt;&gt;*87'Q.TJ]*BD$B/G&#xD;&#xA;M%/M-R8XJQ,VX&lt;BBX$&lt;+[AAA4N,=*9&amp;@ZU(!S2N(0]*B=V/&amp;*E[T!033`JJS(&#xD;&#xA;MW-3&amp;(2C.,5*UN#S2J=O%(9`J;&gt;*26$.*M.JD9'6HX^?O4K`4EM&quot;C;A5N,G&amp;#&#xD;&#xA;M3VR&amp;PHXICC&quot;Y'6C8&quot;1T!7-5CP:&gt;LC'@T_9NZ4[A89&amp;,T2G:,BI$&amp;W.:1D#9H&#xD;&#xA;MN%B!)?-!SVIT&lt;@!VYZTB0^7GWH6)=V&gt;]`6+.`HQ3-F6IP/K064#BF(;C!ICK&#xD;&#xA;MNZ4[.:,X-`RFZ.C9`J&gt;(MCYA5@8/6DXH$)2$&lt;4[`IN]/6@!@0]&lt;48S4OFQ@&lt;&#xD;&#xA;MFHFGB`X:@=AP&amp;U&gt;*JM(?-Q4R7$9X)J*:6!6W;J0[%D*K)UYJ-HB!FJ\=]!O^&#xD;&#xA;M]5E[ZW&quot;?&gt;%`K%.8R+R`:9#?2(VTBII;R$J&lt;,*R);Z$2&lt;L.M4(Z,8&gt;//J*JGY&#xD;&#xA;M'JM!J4/EX5ZADO09!@TQ&amp;KDD=*A:)MVX5+:2+(G-6L`&quot;@&quot;*/+)R*-F6J0&gt;U/&#xD;&#xA;M`J1E&amp;Y5@.!5&gt;%W#_`#&quot;M1T+#I5=[&lt;GH*!CEPPHV&quot;H&amp;+IP*FA)/WJ!&quot;FF,,U*&#xD;&#xA;MVW/%(RFF!`4V\CF@98&lt;K4RKS3F]*0%4PKCI3#$!T%6MM)@4T,I36HE3FL:&gt;Q&#xD;&#xA;M&gt;%B5S72\=*1H$D'-#0SETGFA/(-:%MJK*,/5Z6PC;K5*;3!VS4B+(OXYCRPI&#xD;&#xA;M6$;&lt;ALUC26&lt;D1RH-$5S+&amp;V&amp;H`W(8CG-7#.B1X)YK)AU(!=I--FD\SYE-%PL;&#xD;&#xA;M46U^0:;+@G%4+2Y90%-7$PSYI7&quot;P1_*://0MC-.FX3BL.8S1R[L'&amp;:5PL;C1&#xD;&#xA;MG&amp;Y::+C+;6J&amp;QO0\95SVI6$;G@\U-QV+9CC&lt;9!IHB!;@UDW5Q/;&lt;*.*6SU%\&#xD;&#xA;M9&gt;BX%[4856V9CQ7(+&lt;,+[:C$\UT]W=&quot;ZC,9/6L,:1+%&lt;&gt;?&amp;I/-4F!OV&lt;DGDC&#xD;&#xA;M(I[7&quot;,=K8!IUGD0#&gt;,-5*]MWW[T!JK@2SV*NN[L:I&amp;S3G:W(J[;73.GER&lt;8I&#xD;&#xA;MP@&quot;$LO.:FX&amp;08Y8CE&lt;\5-;ZC.AVR#`K3$8/456GM!(.E581?M[R%T^^&quot;:E*1&#xD;&#xA;M2ISBN&gt;^RO`?DS5J&amp;:55^;K2&amp;+=Z63(77-1022VS[2.!5];\@8:I!]FG&amp;2PW4&#xD;&#xA;MAD+709.&gt;M4]Y=^&gt;E7Y+),96J4L;QGY10!&lt;B&lt;$`$U*S[5K-B\PGD5++*R@!J0&#xD;&#xA;M$RS%FQ4LELCKGO4%L8SSFK8((XHN!FR67/`JE/9D]JZ#KQ4&lt;D*GK3!G*/;21&#xD;&#xA;MGC-36M[+&quot;^#G`K&gt;&gt;R#KD&quot;J$]@!VYJA(M6^HB3@FKH8,,BN&gt;^SO$=RYJ:._&gt;,&#xD;&#xA;MX:DT,WV=4C/`K)DO627`]:&lt;MXLHP3UI?LJNP:D!82X,HYJQ&amp;S*.!4,=OC&amp;*F&#xD;&#xA;MSM.*9+)0-_)J-UR&lt;5)T&amp;:3&lt;O&gt;J3`HW%FKIG%9+Q/!)D9Q72XW#BJ\MJK]10,&#xD;&#xA;MS;:^*&lt;-5SSDFZ&amp;JT^G#JM4V66T.&lt;'%*P&amp;U%:CJ:&gt;X5.AJC::FL@VD\U)/+Z'&#xD;&#xA;MK2L!+N&amp;&lt;4[Y0,YJG'YC&lt;XJ;RG88(I@2+.@/)JR'4KD&amp;LB&gt;&quot;1.@.:GM/,V`,*&#xD;&#xA;M`+S#C-0L&quot;W44I8CK4T91EY-,#.GM0PR*S7:2!^,XK?=.&gt;*ADM4&lt;&lt;]:8$%I&lt;K&#xD;&#xA;M(,.&lt;5?0+U4YK`NH9('R@XJQ9ZAM^5SS2`V6`J)@0?:A)!+R#4QVLFWO1&lt;&quot;I(&#xD;&#xA;M@&lt;8K.GL58FM&lt;Q8J-XQ5(#FIK=H3E&lt;T^WN6!P36Q/:[UZ5D36[1L&lt;&quot;AI6&quot;YK6&#xD;&#xA;M-UEN:T9G#IQ7+6\YC?GBMVUG$@'-9#&amp;*K&quot;3)JZ/G7CFG20Y3(IEME3BF(;)#&#xD;&#xA;MD8-9US8J036ZX4U7EAR*!G*NC0N&lt;57M[F;[5SG&amp;:W[BUSGBLTVI23.*&amp;AG1V&#xD;&#xA;M$Q&gt;(`^E/GA#]JHV-S%&amp;`&amp;:M$7,3C[U(3,V2UV\BH!&lt;-&amp;V#TK895&lt;&lt;5G75H&lt;$&#xD;&#xA;M@55]`0\2K(*&gt;O2J%NCH^#6D.E&lt;M1%(C*]Z,4\TVL;#%%.%-I:8#P:=FH\TX&amp;&#xD;&#xA;M@1(*6FBGU:$--,:I&quot;*8PJ@N1@&lt;U(!30*E44K!&lt;`M.`Q0*=BFD#%4T_-,Q3NU&#xD;&#xA;M601RGBJW4U/)S4('-3&lt;9(BU,!@5&amp;E3&quot;F@$'6E(H[TO:J0#2.*I738J\W2LZZ&#xD;&#xA;MR:'L-%=3DT\KQ4:#!J&lt;8Q4(L9&amp;,-6I!RM443FK:$J*VBB66&quot;H'-,/-`&lt;'K0W&#xD;&#xA;M3-6S,S;Z8QK264N\U#J*EQ3K$!0,THEFH`#134/-28S6A#$'6FS_`.J-2`5'&#xD;&#xA;M*?EP:E@CG9T;[1GWK7LO]6,U&quot;\(9\U9@0J*2&amp;RV`,48H'2EJR1&gt;U+1VH%)@5&#xD;&#xA;M+E]JFL-YR9?QK9O0=IQ6'Y9,OXU):-&gt;U(*58Q5&gt;V!&quot;BK5-`*.M2&quot;F**DQ0(K&#xD;&#xA;M7+'967D^96M.N5K.*?/3`NP-\H%6:J1#`JRIH`=28IU%,0&quot;@]*!14L&quot;O,N15&#xD;&#xA;M&quot;1`&gt;*T)\@$UF&amp;7]]BE8I!''AJOC(4573EJLG[HI@.09-3XP*BBJ8T$C&amp;Z&amp;L^&#xD;&#xA;M&lt;?/6@1P:I2XWT`AJ+\M2+UIZ`%*9@AJ91,.E.IJT_M0&quot;*EP^*AA.YJ+SVI+0&#xD;&#xA;M&lt;TALT$3`J4+2#A13@:I$,!3Q3:44,D=BHIVPAJ6JETX53FH+1DW/SR$5+:KM&#xD;&#xA;M-1@AIJNQIW%`RY&amp;WRT^HH^*F[4T2QM!H-%,$,-`/-.Q2!&gt;:`'#K3Q30*4T@*&#xD;&#xA;M]R^%K*D&lt;LU:-SR*H&quot;([LT#)($R&lt;U=5,&quot;HX4Q5D#`H`:.*&lt;#S2XS1C`YI@#-Q&#xD;&#xA;M5&gt;1C3G:HP-QIB&amp;J&quot;34Z)CFA4P*=0!(O%/W5&amp;*&gt;!0`M%+@`5!-($'6@&quot;0L!WJ&#xD;&#xA;MO+&lt;!&gt;]4WNCNQFF$F3FIN.P^2Z)J$ON')I&quot;F*94LH0KD]:3&amp;*D`S2[*0R,+FE&#xD;&#xA;M\@GM4H&amp;*D$@`I`0&quot;'%2B)&lt;4UY@*A-T,]:$%R?R%---OM-1K=#UJ7[1NZU5@N&#xD;&#xA;M.$0(IK6U-,^WO4B70/6G80U8&lt;5)Y6:E#HXXI0&lt;46`J/&quot;W84(A'6KX(-(8P:=&#xD;&#xA;M@(0!MJ)E.:L^7MH*&lt;4&quot;*FXBI(YB#2/&amp;?2F8Q4@:&quot;3_+UJ19AZUGJ&gt;*89&amp;4TT&#xD;&#xA;MPL;*L&quot;.*7)K-@N#GDUH)*&amp;%,5AQII`(IYP:3%,3*&lt;L'I5&gt;=2MNH_VJU=H(JM&#xD;&#xA;M=Q?N%Q_&gt;IB+M@O\`Q*K7_&lt;%6.E0V1QI5K_N&quot;I2&gt;,FE)B2&amp;M@(6:N&gt;U;4?+#(&#xD;&#xA;MK58U74Q;J5W5QMW=/&lt;R$@\5DV:Q0LF;B3&lt;&gt;:L6\!##CBH[,&lt;C-;4,`*@U%RP&#xD;&#xA;MC7&quot;BIXE.ZA(SNQ5^*#C.*T2$Y#46K&quot;\&quot;E$6VGJ*T2,VQ!UJ51FD5:&gt;H-,D=M&#xD;&#xA;MXQ0%QUI&gt;AI_!6I8T1L^T&lt;5A:C.[L56M*ZN$B!&amp;:Q%&lt;S71]*D9:L+=V.7%:R1&#xD;&#xA;MA13;=&lt;1@#K4X!I@*IQ3QS3&quot;N*;O(IB9+BG+R*B60$X-3\8XIB%S@4W&lt;&quot;:#FF&#xD;&#xA;M@&lt;T7`?2%&gt;](6Q5:[O5CCX/-)L:18+@*&lt;UBW]X`2`:HRZG,SD*&gt;*K-OE.6J&amp;6&#xD;&#xA;MB3&gt;6;-:-N,K5&amp;-.1FM6VCXH2!L&gt;L(J=$VFG`8I3P:I(S9(*=BF*:EJ@`4X4E&#xD;&#xA;M**`#'K02*,GO24@L-;J*;)TR&gt;E1W%PD0R369)J8D4HIZTBK%N&gt;]1(RJGFL5F&#xD;&#xA;MDEGR&gt;E.\N1WSVJ_;VZXY'--(!]L/D%6PF12)&amp;$I_.:JPABJ`:&gt;!2=Z&lt;*5A#7&#xD;&#xA;M)I&gt;M.*TF*7*`S;3'7BI\5&amp;XXI.(T9\R&lt;U69*T9$JNT?-9V-$9Q7:]689*&lt;\.&#xD;&#xA;M:8L&gt;TT`:D3_**EQFJ&lt;+&lt;8JXG(JXD,-M.%*:&lt;BYJR1R@4K#&quot;Y-1RR+&amp;.M9MU?&#xD;&#xA;MD1G::5QEJ&gt;Z2,=:SGU%V.$-4-TUP?:KD-IM4$BD.PG[Z;KFD%FV[)%7XUP,&quot;&#xD;&#xA;MGMFF@(HK48Z586%1VJ6-E5&gt;:&lt;I5C3&quot;Y$(@#Q4@7BI#CM33Q0`FS%`'--:7M2&#xD;&#xA;MI\W-`#7P#34)+5(Z&lt;YI%`%(!&lt;`]:K31\\5+SOXJ41Y'-`AEK\HJ88P1ZU'$N&#xD;&#xA;M&amp;-.?@T6`@\G:VZG#YSS5@8*XJ,+M-`#E7'2G;`W6G`C%.7!H`CVXZ4`&amp;G,&quot;#&#xD;&#xA;M2?-0`8H'%.P&lt;5&amp;7&quot;]:`)0Q/%(XP:@:[C7O5&gt;74XQU-(9=I.E9#ZJ,X4TJWCN&#xD;&#xA;M.#0!J^&lt;BGDU%)=19ZUCSO.&gt;AJF?M!/&gt;@#9&gt;\0-UI$U)5;K66D$K=:&gt;+4YY%*&#xD;&#xA;MPS1;44SG--&amp;IH/XJK&amp;T!7I5=K0YX%%@-!]35NAJ$:@=XYJNEIZBG_90#G%,#&#xD;&#xA;M1-X#'G-5'U`CO2&quot;/&quot;XJ&quot;2W#=!3$*=58-P:&gt;-38CDU5%JN[D5.+1=N0*+`61?&#xD;&#xA;ML1UJ&amp;:_F`^6F!%'%3&quot;%2.E%AE(ZE=YYZ4OV^;')JTT,?I4?V53T%%@*;WMPW&#xD;&#xA;M2H?M%T&gt;F:T1;HO:GB*,=J+#,H3W&gt;[G-2EIY%YS5\QIGI3Q&amp;H%%A&amp;6D$N[O4C&#xD;&#xA;MQ2D8YK42(=&lt;4](U+]*`,4Q3;&lt;&lt;UDW%M,6)P:[,PIZ54DM4)/%-$LXZ*2XA?!&#xD;&#xA;MSBM`3.&lt;&amp;M.73T=NE/^P(`.*8B&quot;#4+B,?+5R/5Y_XCQ2QV:#C%2?8D[BDP+,6&#xD;&#xA;MJICEJF_M5`&gt;#67):(!\HJN('W4BC&gt;75HCU:G'45/W36%]E/:FO#&lt;*/EHN,WT&#xD;&#xA;MN8W;YC5H-$R?(&gt;:Y(M&lt;(.&lt;TZ._N(SU-`CI`K[\]JM8RM8$.JL&gt;&amp;-7X;]2O6F&#xD;&#xA;M%BX&lt;@TXXQFJJWD;'DU.'1UX(H$`()Q0P`'O2*NTYIS8-`%5VV')IT$ZN&lt;`U)&#xD;&#xA;M+$'3%5H[=HWR*+@66&amp;328!ZT]4;'-!%(&quot;*2&amp;-EK.GL`QX%:P0TNP&quot;FAG.O8,&#xD;&#xA;MHX'-5S]HAXQQ722)DU7D@5AR*30T8T5WM;#'FMBUNHRHR:S;C3\G&lt;HJDR7,1&#xD;&#xA;MP,XJ6@.K$D+]ZANX5D3&quot;UA07CKPYYK0BU!3@$U-@'V]H5)XI+E7A^9&gt;U7XI`&#xD;&#xA;MXRIILJ&gt;8,&amp;D,P7O6E?$O:K]M%!+'QUJO&gt;V(&amp;64&lt;U'8B5&amp;]J`+&lt;EHT;;E%2P7&#xD;&#xA;MC`^6]*TYSM-0O&amp;`V^@#3`!&amp;13@`00:@MYT&quot;`-4K$D92BX&amp;=.$23CUJW;G&lt;O-&#xD;&#xA;M5+B)BV:?&quot;74&lt;TKB+A`%'&amp;,5!O+C&quot;]:9B9&gt;&gt;U:7`F,?/2FF%2*$E^7YJGC(89&#xD;&#xA;MH$4)[&lt;;36:WFPOE&lt;UO2IS4#PQNN&quot;.:H94MM1)^5S5T21R&quot;L^6RP&lt;H*@_?1GZ&#xD;&#xA;M5+&amp;;+QJJY6L^XCDES@=*%ON`K&amp;KMM)&amp;XYI6`QXO-B;%7XVG.,5?-O`YR!S4&lt;&#xD;&#xA;ML$B#*=*EH`C9P&lt;M2S/E&lt;CK5;SBK8DJY'Y&lt;B&lt;4K@5XKI@VT]*LM$)%W4T6HWY&#xD;&#xA;M-3JP7Y:M,&quot;F\`QC%9EU8=2!6\\&gt;[D5&quot;Z`C!JK@&lt;MAXF[\5&gt;M;\E@I-6;BRSD&#xD;&#xA;M@5G&amp;U:-MP'2D!TD,JE1S3I%RNZL&quot;&amp;[=&quot;,GI6E%?JXVD]:0%I'SP:BN-P3*U(&#xD;&#xA;MJC;NIGFH3L-%Q#+6XD+;6JV6.&lt;TU+=&lt;;EIQ1@*=P%;!45!/:B&gt;/!%(6&lt;-BIH&#xD;&#xA;MW:BX'/3V#VS[D!IJW#[AO[5TS+$ZG&gt;*S+K3T8$H*8$]C-&amp;Z=:NX&amp;&lt;K7,_O;5&#xD;&#xA;ML#I6E::@,88T`7IT)YQ4&lt;;!3AJD\\2#@U5F5NHI`72L&lt;@XII@*]*I1M(M6/M&#xD;&#xA;M#@&lt;F@&quot;=00.::1D\4U)-]2#Y&gt;M4!7FAWJ1CK6+&lt;V#1R;E%=&amp;&gt;M-DB61&gt;10!A6&#xD;&#xA;M]RT(P35N.[W/D'FH[NS/)45F!W@E^;I4W`Z&gt;-RRY-.9&lt;]*S[.[60`9K4097-&#xD;&#xA;M4A$!4BJT]NKCI5]QFH2A[U=M!'-W=L5;('2F07;0-@FMV&gt;`,#Q6)&lt;VN&amp;.!4-&#xD;&#xA;M#-2+5E*8+5:MIO-^9&gt;E&lt;KC8W-:EE&gt;&quot;)-H-9LHZ`/\_-6/E9:P&amp;NV9LJ:OV4S&#xD;&#xA;MNP!-&quot;8%B2$9K/N8.N!6Q(.*J.H:JN)G-S(\9R*2VNW\S!-;%Q;JP/%9$EL8W&#xD;&#xA;MR!0!NV\XVC)JVV)%KGHI6W**W[8Y2F%RL\6UJ49Q4\Z\U'CBL*A28RDQ3B*3&#xD;&#xA;M%8%!124M(!&lt;4HH%%-`/!IXJ(5(*M&quot;'@4QQ3Z0C-620CBI%-*4XIG0TK`3#I3&#xD;&#xA;MJC5J?30#J:3Q1FD;I5$D1-`&amp;:8V0:DC-9,HD'%.%-R*4&amp;FA#J&lt;IYIF:&lt;O6K3&#xD;&#xA;M`&amp;%49^35]NAK.N#AJ)#1%MIX&amp;*:IR*=213+$=3!:BAZ59`XK&gt;.Q#8T)@YHD;&#xD;&#xA;M&quot;U(!D5',,1T,1FS$,V*2)&quot;#Q59Y#]H(J_;_,.:$-D\9-6!TJ/``I5:K1`^H+&#xD;&#xA;M@U/4%R/E-#&amp;BO&amp;R[L5=5!MR*R%+&quot;6M:%ODYI#8[&amp;#3J#C%+VJT2%#'`IM))]&#xD;&#xA;MRI8&amp;?=3#.*@AB#MFJ]ZQ$GXU8LY&gt;*S+1?1-HIU(&amp;W&quot;E[U:`&gt;M2@5$M2J&gt;*8B&#xD;&#xA;MO&lt;MA:HK\SU8O6PM4(9?GYI#-)!@5)4&lt;9R*E`IB'`4ZC%)0(.U(.M+2#K0)$=&#xD;&#xA;MS]PUB2*5ES6]*`5K,GB[T%H9`_-71TK/C&amp;UJOIRM(&quot;:,&lt;U/U%0)UJ=:!#6Z&amp;&#xD;&#xA;ML^&lt;'=FM%A529030!'$_&amp;*E'K4*K@U*#30$@ZTK&lt;+0M$WW*&amp;-%&amp;;YC4ENF#59&#xD;&#xA;MI,28J[`&lt;@5(RSVI10!Q0!5HACJ44@IPH8@SBJ-\,H35QJS[N4&lt;I4,M&amp;9&amp;3YM&#xD;&#xA;M:\#?*!6?%%\V:O0J0:$)EI1WJ2D4&lt;4M,0E%+24P&quot;E`I*&lt;*`&quot;D;@9I33)#\M(&#xD;&#xA;M&quot;C._S8H49%02Y\RK$7W10,FC%3TQ5XIU4A&quot;CBHI7XJ7M4$@S0!5+DFIHNM)Y&#xD;&#xA;M-2(F#0,E-,'6GTJKS0(%%/Z=:3I5:&gt;X&quot;CK2'8?-&lt;!1P:SY9C(&lt;5%)*SM0G'6&#xD;&#xA;MI92%,&gt;&gt;:-^WBGEABH6Y-(8XOFF8R:`I-2J`!S0(5%]:D)4&quot;J\LVT&lt;54,[LW6&#xD;&#xA;MBP%N24#I5*2&lt;@\5,J,XIXL]W446`H^8[TX1,:T%LU7M4@B44[`4$A:IQ&quot;X'2&#xD;&#xA;MK851TIPYI@4&amp;C:FB)LU?*4P@&quot;F!'$&amp;6GM(PIX84NU6H$1&quot;X(ZFIDN@&gt;]020^&#xD;&#xA;ME0&quot;-E-`&amp;LL@84[(-9R2%14HF-(&quot;[L!%5WB.&gt;*1;G`Y-2I*K]:`(`F#S2,N15&#xD;&#xA;MPQAAD5&quot;RD&amp;D!4(*'-21W)7O3W7(J#R^:0&amp;E%&lt;!NIJVK#%82N4:M&amp;WGW#DU2$&#xD;&#xA;MRZ.:;&lt;_\&gt;Z_[U*I&amp;*+C_`(]E_P!ZJ1(^QR=*M?\`&lt;%1WMT(8FR:FL,?V/;'T&#xD;&#xA;M05@:U&lt;@DJ#6&lt;F7%&amp;%J5P;J8X-5XH54&lt;B@_?S4\8W&amp;LC1$T$'.X5IP-T6J\&quot;X&#xD;&#xA;M&amp;*TK&gt;`9SBFD)LL01@\U:`V]*A12#Q5A1QS6B('+@B@K@\4#VJ9`&quot;.:T1+0U!&#xD;&#xA;MQ2G@TX#GBE.*386``8R:SK[44MP5!YJ:ZN0BE0&gt;:Q9+62Z?&lt;3FH&quot;Q7:9[J7@&#xD;&#xA;M\5HVEIM(8CFGVMB(\9%:*J%'2BPQL8*FILTT4M,0[.:0IFA1S4G2F!5*D'BK&#xD;&#xA;M4).WYJ:0#3XR!P10(5B,\4TG:N:&gt;^`,UD7NH&quot;+*T%)&quot;7E^(R0#5'&lt;UP,D\&amp;F&#xD;&#xA;ME#&lt;G=ZU/%'L&amp;VI&amp;1I;1@\CFIA:@]!5B.+G)%6EAXS2`HK:9/`JY%'L&amp;*M1(,&#xD;&#xA;M'BD*@5:0KC`*&quot;!FI%PPJ&amp;3(;%423HO%/Q38CE&lt;4ISF@84&quot;DI1QR:FX&quot;[@W'I&#xD;&#xA;M5:YN5A'6F7=['&quot;IQUKG;BYDN9&gt;&quot;&lt;9J;E$U]-).#L-5+*)]_S&gt;M:-M`2F&amp;'6K&#xD;&#xA;M,5J$ZBF`L2```BK(7'(H5!4F*:%&lt;49(I&lt;C&amp;*2E%42`I&lt;44;NU*X#J*9FI!3N&#xD;&#xA;M`E-(I_&gt;@K0]01$8P:KRQX/2KHXI'4,.E0XE7,MA@5&amp;15Z6'BJ;?*:@=Q8S@U&#xD;&#xA;M=C/%9ADVFK-M-N/6BX6-`#-,N+E(4/-$KA(B=PZ5S&amp;H7;RR[5:GS!REFYO7E&#xD;&#xA;M?&quot;FB*%Y%^:H[&amp;#C&lt;_-:J;00`*&gt;X;$&lt;5L$7@5,JMTJP@!%/&quot;#-4D*XR,#I4C1&#xD;&#xA;M9%-.$.:&lt;DF\X%5813F5P&gt;*D@&lt;J/FJ=P.]0G&amp;&gt;E2V!,KY/%*U$87%-D8*V*$P&#xD;&#xA;M(G7FI8SM2C9OZ&amp;G^2=F,TQC#+G@5'EMU2)`5;)J&lt;(OI0!#&amp;.&gt;:D+=JD&quot;BF&amp;/&#xD;&#xA;MF@0T+WIVW/6G=!3&lt;T7``AI6%(90B\FJ4U^J`\T@+Z;&lt;&lt;FHVF6-^M&lt;_-JK9^0&#xD;&#xA;MFH4NI96R2:!V.CFOHT3)-4)-70=#6?,LLB8!J)+1B.:0[%\ZN3T)IOVMY.A-&#xD;&#xA;M-AM$'WA5KR44?=I@5=LC]Z3[(S=:N``=!3E!H`I+8@'D5:CA51TJ;::&lt;&quot;.F*&#xD;&#xA;M`(3'FFF`!&lt;U9`&amp;:;-PM`$*(,4NWFE3IFG$8!-`Q$P&gt;*:R&lt;U6#NDO?&amp;:O?&gt;0&amp;&#xD;&#xA;MD!$,`4H*D4QT9P0*KA'1L$TK@6\`CBF;&lt;#%2HRK'@D9I%^&lt;\4)@56BRV14@4&#xD;&#xA;M[&lt;5,5VGFE.-N:JX$`@SS4@`48-.7.:&lt;SJ@RPIW$1M$#S497%3+.C\&quot;E*47$5&#xD;&#xA;M=A&lt;\4_R&gt;.:F5,4'(I@0&gt;4,]*&gt;(\\4_MFG(N3UI-@'RHF#3`Z@YIMR&amp;45&amp;J%D&#xD;&#xA;MS47*)A(I:AL5'``9,58&gt;/:M.XFB#:IZ&quot;FB,[J&gt;O6I&quot;:?,*PPH`:=QWIV-U,*&#xD;&#xA;M$?2BX6&amp;/%N^[3%BP&gt;:L*:4K2`@,?I4;`]*LD$&quot;FC#'D4@*_D!AR*ADM%[&quot;M(&#xD;&#xA;M+D&lt;4QDJAF6MH`&gt;E3^20,+5C8&lt;TI&amp;TTP*,D&lt;JC*GFJ1N+R.3ACBMP[6&amp;,5$]L&#xD;&#xA;MK=J!%&gt;#5&amp;1?WI)K0AU&amp;-^&gt;U9DMEWQ3(XBIXI,#HA&lt;HPXIX92,YKGW68K\C$5&#xD;&#xA;M+:SRJ=KDG%-`;V&lt;CBFXYK-^V[*GBU!#UH`N\XIA!I#&lt;IC@T(X&gt;BX&quot;$&quot;FML&quot;\&#xD;&#xA;MBIR!4+KDT[BN0A0_`J*6U7N*L;2#Q2GD&lt;U+'&lt;R6TX,Q(%4Y[*6/E:Z+:`.M-&#xD;&#xA;MDC5AR*EC,&amp;&quot;YEAX8FKT&gt;H+_%4KV2MT`JM+8G'`I6'&lt;FEF6X^X&gt;*=;1`&lt;FL&gt;2&#xD;&#xA;M*&gt;!N&quot;&lt;4^*_&gt;,8;-%@-&gt;XAYW&quot;J;^8PV@U-!?HR8:GDHS;UQ4V`A5'C0%JE%YM&#xD;&#xA;M`&amp;::]PI^6J&lt;ZDC*TF!L(5F7CK4#(\;&lt;]*S[&gt;X&gt;-@,FMF&amp;1)H^&gt;M2P(DEC4X'&#xD;&#xA;M6I7&lt;%*ISQ'S,KQ3O*D9&lt;@]*7,`I=5C-,@G(;K3'1MI%-AA;=FK3&quot;QJ9WK4+(&#xD;&#xA;M0:&gt;/ECS526ZV')!Q5W`&gt;6YP:=Y`D'2H%O(C@D5?C=)$^2ES#,^XL0%R!S6&gt;K&#xD;&#xA;M31/C)Q6XV&lt;\\U&quot;\2.&gt;E-,16BO&quot;N,UHP7(E')XK/ELB.5JN3);^M-@7-15&gt;2@&#xD;&#xA;MJG;32(&gt;M2I&lt;&quot;5,,.:%&quot;[N*S:`LB[8\9J578\U715W595/ESGBD,L1S`#!J&quot;6&#xD;&#xA;M4;N*JNY#XS4BQEQUJDP+&lt;&gt;UQS4&lt;UNA'`I(T9:F)Q@&amp;JN!B75IMR5%9O[R)\\&#xD;&#xA;M\5U;PJXZ5GW5D&amp;4X6@&quot;M!J.8MA/-1O*V[&lt;#5*6TDBDR.E/24CAA0(U[/4#D*&#xD;&#xA;MQK4\]&amp;7-8=HJ,V[%7;AO)B#=JE@6I&amp;11FH?M&quot;YXJO'+YPQ3X8&quot;7.:5P+2'=S&#xD;&#xA;M3LC.*J72R(!L.*JI&lt;/'(-Y)JDP-&quot;XLUE/2L&gt;\LY(,E*W8IQ(N:D:))DYQ3N(&#xD;&#xA;MYNTO6C.),UN6\B3J,5EZAIYY,8Q5:VN)+;&quot;MGBF!NR*J5'YL9XQ3([M)TP&gt;M&#xD;&#xA;M$D&amp;!N!I`6(L=14A^:J&quot;3[3@U:AE!/-%QDV&lt;&quot;D1^U3^6'7(JE,?)&gt;G&lt;1.Z*PZ&#xD;&#xA;M5F75@),D&quot;M**82)3BN:+`&lt;WY4ELV?2M&gt;SO0RA6-2SPHZXQS6--&amp;]N^X=*I:`&#xD;&#xA;M=,I5AFHI!GI679WV[&quot;DUI!@PSFJ3`B*FH9+=6'(JWUIK#-#8&amp;!&gt;V@&amp;2!6:N8&#xD;&#xA;MVKIYH@P(QUK'NK,J&lt;XK-Q`+&gt;9&gt;,UKV&lt;R!ABN:^9&amp;K4T]_F&amp;34V&amp;;SSU&amp;&quot;352&#xD;&#xA;M:^BCX-:%F\=Q&amp;&quot;N.:`(MF3S5&gt;XMU9&gt;!6A/$8QFJ:R[FP:8C+,)1LXZ5&lt;M;G!&#xD;&#xA;MP35B6$,O`J@T+(V15DFT&quot;)%S4+KBJ]M&lt;\;35ECNYK&amp;HBD14AI2:3-&lt;S+&amp;XIP&#xD;&#xA;MHQ2T6&amp;%)2TNTU20A!3Q3&quot;-O6G!J:0B4&amp;G&quot;HP*D%6A#\&lt;5`Z\U86@IFKL(K`X&#xD;&#xA;MIP;-)(N#3%;!J6,GI130&lt;TM4A#7CXJ+[M6&gt;HJ-X\]*B2`C#U*#Q5&lt;J5/-2HW&#xD;&#xA;M%38!Y-*C&lt;TP\TY&gt;#3B!,.:H7BU=!JM=#(JF4BHIQ4E1=#4@-);C9:AJP:@@J&#xD;&#xA;MP&lt;&amp;MXLS8Y2-M0W)_=FG#(-)/_JJ&amp;&quot;.?8?Z036G!P@JA(/WQJ[!]T4D4RVIS3&#xD;&#xA;M]M,0YZ5(*T3,Q5J.XQMJ6J=U)M-)L:(%0%\U=CX%5;&lt;AS5X)0F#'&quot;G=J:.M.&#xD;&#xA;MJA`14&lt;APM38XJK.&lt;*:EC1CW:[GI;=2*'8&amp;2K$2&lt;9%06BU$&gt;*E[U55L'%3*V3&#xD;&#xA;M5(3+&quot;]*6D6E//2J$5+I=RU1C@.^K\YQUID&amp;&amp;:D,DC3`J=:7;@9H`IH3'4F*6&#xD;&#xA;M@4Q#&lt;44IH]Z0AK#Y:HR$;\5H-RM9%RQ62@HE$63FIT&amp;.*@AE!4&quot;IUZYH`E4&lt;&#xD;&#xA;MU.O2HEYJ8=*!#7JE*&lt;/5YJISKEP10`@`HQS2`XIXQBA#'KTHEYCH%*_^KH8S&#xD;&#xA;M%E_UI^M:-L/E%53%F8FK\,9&quot;BI&quot;Y9'2BFBG&quot;J1+`4X$4=J`*&amp;(CD;%85Y(?M&#xD;&#xA;M7M6Y-TK'N(M\F12+1+;,#BKZKWK/MQM.*TX^10(&lt;II],(P:&lt;#3$*:;3S28I@&#xD;&#xA;M(*6BBD`'I4$IP*GJM&lt;L`,4AHJ$;FS4T0YJ%#S5F)&lt;G-&quot;&amp;65'RTE.!P,4W&amp;35&#xD;&#xA;MI$@QP*ASDU(_2FHO-`#U2C;S4F0!41&lt;$TACL4X&quot;D7FF2OL%(!)W&quot;K6-,[.]6&#xD;&#xA;M99B[8S480=:0T-C08YI2OI32^#@5(N&gt;]24,*&amp;A8SGFK*)FB3&quot;BF(@?&quot;&quot;J4DQ&#xD;&#xA;MW8!J61RQQ4/DEGIB$&quot;M(:LQ6HZD5+!#M'-6.W%.P#5B44XX'2@*34R0$]:`(&#xD;&#xA;M.31Y9-6C$%IG`H&amp;1&quot;&amp;GB,`4C2&lt;&lt;5%YQH`D*4TP%C3/-]Z8UR5H`G%KQF@Q%:&#xD;&#xA;M@2_&amp;[!JREPCT&quot;(B#4;KQ5T[&quot;.U--ONYH`S@ASS4H48J9XMM1D&amp;@&quot;&quot;13VJ-79&#xD;&#xA;M35P+D&lt;U$\63Q0!9M[G*X-6L!Q6:L90U82;;Q0!*\7%5G4@U;60,*:T&gt;:+`46&#xD;&#xA;M6D1V0U89.&lt;4GEC%%@)[&gt;YSP35Z4AK5?]ZL3!1N*MFX/V103_`!4$EB6Y%OHM&#xD;&#xA;MMANJ&quot;N2NKAII&quot;&lt;U:O;EVTZU7/\(K.5&lt;=&gt;:Q;U-%L.4;ZO6MJ3S56#_6`5NP1&#xD;&#xA;M@**2&amp;PCML#-7X%[4V-,BK4:A16B(8]4I&lt;&amp;EW8%`?GI5$W!5J=&gt;E1YXI5)&amp;:=&#xD;&#xA;MP)$4U%&lt;R&quot;*%B&gt;M.6;!QBLG5IV+[1T-2V!E37,DUU@9QFMJS7$0!JOI]FC1[S&#xD;&#xA;M@FM!5&quot;MQ2N`NTYI_04QGP&gt;E*6RM.XQXYIP%1(V#4@:G&lt;0O&gt;IAC'-57DVU+$Y&#xD;&#xA;M&lt;4K@2[:1G&quot;#)IOF;6`JKJ,Q6,X]*+C2*UYJ(#;0:JK']I^8UF'=)/DFMBV&amp;U&#xD;&#xA;M!1&lt;8^&amp;#8V*E6+$G2E5L'-3J00&gt;*`'B,(,]:D'`K,DOC#+C&amp;&gt;:TH9A/%G&amp;.*5&#xD;&#xA;MQ#UD4`BF;3UK/G=HY&gt;#WJ_;2^8N&quot;*JX#@P4]*:Y#]JD&gt;$&gt;M-,&gt;U&lt;YHN(1,K4&#xD;&#xA;MN&lt;BJZ2_O,8JR_*Y%*X$;,$&amp;2:S;S4U52JGFG:C.5A(%&lt;NF^6Z.6XS2N!.9)9&#xD;&#xA;MY3DG!-:%K:=R*L0VR&quot;-3@5;2,#I5#'1QA1TJ7@B@#BE`IB`+2XIPH-5H)C0M&#xD;&#xA;M&amp;,4[-)UHN(:6VTQWST%+)566Y\@?=S4,:+&lt;0)ZT\\5!97?VC(VXJZT6T9SUI&#xD;&#xA;M(=ABKNYIX7FH^12ABJ$U:8K#V&amp;#2&lt;57:ZP,XK,N-49'(&quot;TI-%&amp;O(H8=:I3Q*&#xD;&#xA;MHR360VLR;ONFFRZB\B=&quot;*R;&amp;B2:502,BJC7WEGBJCNSN&gt;:/+W=:R;+2)WU62&#xD;&#xA;M0;&lt;FFPJ9'W,*?#;+G/%6U0+T%),HMP`!&lt;`5=BC[FJ]JH/-7LXZ5M!F4Q&lt;8Z5&#xD;&#xA;M(@XJ,4I;%;(@'7-0(^R0C%2EC2,`!G%#8R*9SUI%&lt;/QWJ8*)!S5&gt;2/9(,'O6&#xD;&#xA;M3'8L+$ZD&lt;TZ2,DU*G1:E*#K30%(*P-6(]Q'6I-H)IQ4**8#=M-8@#K4,MWLX&#xD;&#xA;MQ5&quot;:\8CI3`U1(!_$*@ENE4_&gt;%8YN';N:KR*\A^^:5P-A]151ZU5?51G`!JB+&#xD;&#xA;M9CU&gt;K$5NH//-(8/=22CC(JJUO*[9+'%:JJBC[M-(&amp;&gt;E,&quot;@MJ!U%6HUC3^&amp;IL&#xD;&#xA;M!C2B$9ZT`-`!Z&quot;G&amp;/CBITB&amp;*1EQ3&quot;XP1X%.5&lt;]:&lt;#VIRC-.X$93;5:&gt;X\D]*&#xD;&#xA;MT?+##.&gt;E4YX@V&lt;T@'VTXF7I4WRYP:BM$&quot;(:IW\S1R9%*X$\LIAEW8R*D$XF7&#xD;&#xA;M.VH[202V^YER:M0A7^4+BE&lt;&quot;)`&quot;U2LG%4;BX-O.0!G%/^W&amp;2/&amp;W%3&lt;9))+&quot;G&#xD;&#xA;M!QFE617X4BLJXM7D);S,52^TR6LJKDGFE&lt;#JTB`0U3GMR[8!P34ME&lt;&amp;:,9IE&#xD;&#xA;M\YB&amp;12N!F7,,UJ#EBU/L+O)`:IXI?M-HP&lt;&lt;^M9@@,4N0U.XS?=@1FF'+#BJ&quot;&#xD;&#xA;M79`VD9K4M\/%NQ1&lt;!L*X/-,O82T&gt;15=[DK&lt;%0.]:6/-@&amp;?2G&lt;1B6D4@F.3WK&#xD;&#xA;M6?Y5`J-8`C$T\?.&lt;4^80W!-.$9(YI9%VXQ0KX%.X6&amp;/P,52:Z,&lt;VWFK\A'ED&#xD;&#xA;MXK-&amp;&amp;N,D4FQ&amp;@5$UON[U3\_:WEXJZJ;5SGCTJ&amp;6-3\V*ALHK)%)&amp;_F9.#5L7&#xD;&#xA;M2RKL/!J1L&gt;2!BLRYC(.5;%.X%N*W9&amp;+%LBE&gt;Y3&gt;%Z5#;NP7!.:ANX26#!L47&#xD;&#xA;M&amp;:$D@CCW#FFVUP)EP15*W+.-K'-74M`J&lt;-BBXB1\1C(YJ(7`8XQ3&quot;Q0[3S4B&#xD;&#xA;MP!QN!Q3N!*,$4DB`+D'%*%V#%4;J5LX!IW`LQ9W'FGL,]ZJ0S$+4?GMYE.XB&#xD;&#xA;MYMQ3O+SR:&lt;@WJ#2D8'6G&lt;&quot;+RZ=TXI5J81@C-%P*K)FHO(YS5F4;:8C;N*+@,&#xD;&#xA;M5&lt;#I055&gt;=M6D0=:8[C.-M4!4:+S.E5GA9#P:T\#&amp;147EC)S2;$9IDE4]35RU&#xD;&#xA;MNRO!S4C1KZ4WR1VH`O)&gt;*&gt;M3&quot;9&amp;%9&amp;PANM/$C*&gt;M,1IG!/%,D!&quot;U7BN#W%2F&#xD;&#xA;M?(Z5+`JF9@^#DU;#&gt;8G'%1QJLC=*L^2%&amp;0:0RGAXVR3D5,LBN,8I[`'J*!&amp;&quot;&#xD;&#xA;M..*`(7M5D&amp;&gt;*I3:&lt;N&quot;0!6LD!`^]4&lt;J;1C-,#`&gt;T=5^6J,MS-;'!R0*Z=8PW6&#xD;&#xA;MH+G3HYE.&lt;4@.774B\N,$5N6Q66,9-4)='02G#`4JHUO\H;I2L.Y&gt;N%6,#`J&gt;&#xD;&#xA;MSW&gt;M9XNBWRD9J_;G`S4M#+&lt;L@7M3H9`&gt;*CV^;2M'M3BLW$9),8^@(R:2-`HS&#xD;&#xA;MD5@7L\B3C#&amp;KEM&lt;N\&gt;&quot;:0[&amp;KN5VVYJ&quot;YB7&amp;,9JDLS1S9SFKBWF[@K3N%BC&lt;6&#xD;&#xA;MY$8*\4^P:2)OF)(JQ/(&amp;3I38F&amp;.E*X%I+A6)R*81O;*GI4#]#CBDM&lt;JYR&lt;UI&#xD;&#xA;M$EE^,?+\U1ND;G!Q4Y&amp;8ZP=2N'@!*DUJ27)K/#90C'M59E&gt;,]ZH6&amp;MN6VLI/&#xD;&#xA;M/K6]'(MQ'DKBI8T9@F;S,5HQR$Q]:K3VX5LBD$OEITJ&amp;B@N49?FS26MT0&lt;'-&#xD;&#xA;M))&lt;&gt;8N,40QC.:0&amp;E!?INP1UJS-M*[@16,T&gt;&amp;X-68@P7ELT[@317/[P`UH$QL&#xD;&#xA;MO05CL,.*O0*67.ZG&lt;&quot;&amp;Y@5FZ52&gt;Q!&amp;0*W5B#+@U#,`@VXJTP,(QM#TI3=&gt;8N&#xD;&#xA;MQA6F\*NF:H36H7)!I,&quot;)'\HY!JW#&lt;C/6L@L0Y&amp;:&lt;CDFH`Z,E9$SUK.G0%N!3&#xD;&#xA;M[68E&lt;&amp;K&quot;1B0\T`58V9%Q3XYW#XR&lt;5;:V5:8(ESTIIB983;*GS&quot;J-W8J&lt;L!5]&#xD;&#xA;M%XXH;T-4B3G#')`^X$XJY;W?F#8QJ\T&quot;RD@BL2]B-O(2I[T,$:9A'4$4[:5Y&#xD;&#xA;MK*M;U\@')K75O-4=JEE$L5R0,$U'/F4YI?)VC.:6%@&amp;P1FA`$`*\5:52QZTX&#xD;&#xA;MH-N:H2W+12X%:)B+K1X-5KBW$B&lt;BK$$_F)DBG/\`-Q0V!S4]O)&quot;Y*YHAU%Q\&#xD;&#xA;MI)XK&lt;DA5AR*Q=0M%A.Y3UJ;C-.TN/,[UH;,BN;M)S&amp;16]:W'F``BFF`K)S4$&#xD;&#xA;M]N'%7I%XS4%7&lt;DP+JR(?BJH62(\$UTCQ!^M4+BU&amp;&gt;M)C.?NC*Y^\:TM(OGB9&#xD;&#xA;M58GBH9H`&amp;QFEMX@C9J6AG:QNMQ&quot;,D&lt;BJKV6UBP-9'VUX44#-7K74&amp;&lt;&lt;C-(&quot;7&#xD;&#xA;M!%(Z*R$8J&lt;.'[4CIQ5(5C&amp;DC:*3.&gt;*GCNP1@U-/$'!J@(=C]:SF4B]OS2BHD&#xD;&#xA;MJ2N9E#LT4VC-&quot;`DIRFHZ&lt;G6K0ATBYJ+.#5GJ*C:,5HD2.B;*U**K`[3BID-&quot;&#xD;&#xA;M6HB8&lt;4_-,I:T$,D7-56&amp;TU=/2J\J5+0QJ-4HZ56'!J96I`2`\T_'%1]Z&gt;#28&#xD;&#xA;MA#'NJ!UV\5:SBFL@:AH&quot;JK5*O-,=-IHC:DD,GJ*09%3KR*'0%:JPT9;?&gt;IU)&#xD;&#xA;M,,-2*:@HLPM5L&amp;J,?6KBUM`ADFW)J.&lt;?)BIDILHR*&lt;A&amp;`YQ.:O0C*UG70VW)&#xD;&#xA;MQZU?LVRHJ4-EJ,$&amp;IA2#%+5HD=65J3;36JM4;Z(/0P11L)236Y'R*R+:`(&lt;Y&#xD;&#xA;MK5BH0V2L*:*=0*LD7M5.Y'RFK9JK.&gt;*EC1AMD2GZU?MC\M0R1C=4D8VUF63L&#xD;&#xA;MO&gt;FJ2&amp;IP;-+MS5HEDZ-Q4R],U60&lt;U9SA*IB10O6ZU!:R'?C-%ZQ&amp;:IPS8?I2&#xD;&#xA;M*.@!RM+56WFW&quot;K6&lt;BFB6+2T4E4(&quot;*.U.'2FXJ;`-/2LZYCW,36BXJJXYH&amp;5(&#xD;&#xA;MD*U&lt;7I46!FI1TIC)4/-6!TJLG6K(/%`ACU6DY:K#FJDCX&gt;D`I&amp;*%/.*7JM-4&#xD;&#xA;M?-0,L*.*9,&lt;+4@.%J*8;EH8%$./,K0A.5%9+C$G6M*V/R&quot;D!9(HI*51S31+'&#xD;&#xA;MBC-+VIAZT,$13GY*RW;Y\5IW'^K-8SG]]2+1?@CSS5Y%P*J6OW!5T4T2QII1&#xD;&#xA;M110`ZBFBGCI3`8&gt;M+VH-%`#6Z52N%9N]6)G*U6\W&lt;&lt;8J01%&amp;I!J]$IQ4&quot;)DU&#xD;&#xA;M9'RK30Q]+3`V:=5B$&gt;A%IC'FI(S28&quot;/G%5^&lt;U&lt;&lt;#%0;1FD`Z/I4%R&gt;#5D&lt;+5&#xD;&#xA;M28Y)%(9FY/FU.&amp;XI7B`YJ+O2&amp;2+%N.:D&quot;8IT72GL,+2&amp;1%PE5Y9MU174A!J*&#xD;&#xA;M'YSS3`E1-S5;2(#J*(HPHJ7&amp;33$&amp;WBE6,DU*J5)D+VIB&amp;J@'6GE@HXJ%Y#3-&#xD;&#xA;MQ84#!Y&quot;33#DBEV\U(H%(&quot;OM)IAC-72!3&amp;QZ4AE41&amp;F/;DBK!;%,,GM0!2:U8&#xD;&#xA;M=*01R*&gt;IJ^&amp;![4[Y2.E,&quot;HLKJ.&lt;U(M^4ZU+Y0:J\UJ/6@&quot;;[:DE31LDGI61+&#xD;&#xA;M`8^C4D$[QGKF@1MF(=J@D0J:;#=D]15I2)!TH`@7!'-(Z&gt;E3/'@\4VF!75RK&#xD;&#xA;M5:27(J&quot;1134)!IB+;*&quot;.*CVD5)&amp;U2,`10!1D%,E!^SK_`+U66CYILR@6Z_[U&#xD;&#xA;$(#__V0``&#xD;&#xA;" />
      </lst>
      <lst nm="L-GRAIN">
        <str nm="DESCRIPTION" vl="" />
        <str nm="ENCODING" vl="M_]C_X``02D9)1@`!`0$`8`!@``#_VP!#``@&amp;!@&lt;&amp;!0@'!P&lt;)&quot;0@*#!0-#`L+&#xD;&#xA;M#!D2$P\4'1H?'AT:'!P@)&quot;XG(&quot;(L(QP&lt;*#&lt;I+#`Q-#0T'R&lt;Y/3@R/&quot;XS-#+_&#xD;&#xA;MVP!#`0D)&quot;0P+#!@-#1@R(1PA,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R&#xD;&#xA;M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1&quot;``^`L8#`2(``A$!`Q$!_\0`&#xD;&#xA;M'P```04!`0$!`0$```````````$&quot;`P0%!@&lt;(&quot;0H+_\0`M1```@$#`P($`P4%&#xD;&#xA;M!`0```%]`0(#``01!1(A,4$&amp;$U%A!R)Q%#*!D:$((T*QP152T?`D,V)R@@D*&#xD;&#xA;M%A&lt;8&amp;1HE)B&lt;H*2HT-38W.#DZ0T1%1D=(24I35%565UA96F-D969G:&amp;EJ&lt;W1U&#xD;&#xA;M=G=X&gt;7J#A(6&amp;AXB)BI*3E)66EYB9FJ*CI*6FIZBIJK*SM+6VM[BYNL+#Q,7&amp;&#xD;&#xA;MQ\C)RM+3U-76U]C9VN'BX^3EYN?HZ&gt;KQ\O/T]?;W^/GZ_\0`'P$``P$!`0$!&#xD;&#xA;M`0$!`0````````$&quot;`P0%!@&lt;(&quot;0H+_\0`M1$``@$&quot;!`0#!`&lt;%!`0``0)W``$&quot;&#xD;&#xA;M`Q$$!2$Q!A)!40=A&lt;1,B,H$(%$*1H;'!&quot;2,S4O`58G+1&quot;A8D-.$E\1&lt;8&amp;1HF&#xD;&#xA;M)R@I*C4V-S@Y.D-$149'2$E*4U155E=865IC9&amp;5F9VAI:G-T=79W&gt;'EZ@H.$&#xD;&#xA;MA8:'B(F*DI.4E9:7F)F:HJ.DI::GJ*FJLK.TM;:WN+FZPL/$Q&lt;;'R,G*TM/4&#xD;&#xA;MU=;7V-G:XN/DY&gt;;GZ.GJ\O/T]?;W^/GZ_]H`#`,!``(1`Q$`/P#JRDI;E(R:&#xD;&#xA;M9LN/^&gt;2?G3_M:=IE-/$Z$#$PKP]&amp;&gt;KJ-VS[1B)2._-,99\\1+_WU4HN$!P9E&#xD;&#xA;MQWH$ZJIS,O/0FG8&quot;'$XZ1+GUW4Y?.[PC/KFI#,N`=ZYH\Y01EQ^5%D`PASTA&#xD;&#xA;M&amp;?8TW;+GF%?Q:I&amp;E`Z.#STQ0TJ]/,_2EH!&amp;%E4\1+]-U#&gt;;_`,\?KAJE$H''&#xD;&#xA;MF8I1.H_Y:J/&lt;B@9!^\_YXL?^!4C%\X\F3\#4QG`Z2K^5*)MR_?2EH*Y4#.K9&#xD;&#xA;M\N3CWS3U=P&lt;[)5S5@R@#(=*!+C^-?SHL,KLSAN%E^F:8)65B2DHJT)1U#)UZ&#xD;&#xA;MYI1)EL'9G'7-*S&quot;Y768]DFQ]*&amp;F)Z++CUQ5H/SC&quot;_G1O&quot;MR$Q]:=F%T43&lt;$9&#xD;&#xA;MP)5]\4&quot;Y53DF7_OFK^_V7'UIN_T13^-%O,=RFMXI4C=)^*TUKL$\22&lt;&lt;_=JZ&#xD;&#xA;MK8ZHOYBAB-W,0_,4K,+E07BD\R2+_P``I1=H.2Y^NRK@92W^K&amp;?7-.#+R#$#&#xD;&#xA;M19L+E%KR,')D./\`&lt;I%O(MW#Y]BE7&quot;`,CRA]*0[&lt;#$7%&amp;H:%9KM`1\Y'_`*1&#xD;&#xA;M;Q=Q^&lt;_]\5&lt;W+C_5J?Q%*S#:/W8_,46\PN5#=(`27/UV4&quot;\08(=L=SLJSN!Z&#xD;&#xA;MH/TI^[&amp;/W0_*C4+E,W&lt;7!#\=_DIRW,;&lt;%Q[90\U9RIS^[Z]N*,*1S$/\*+,5&#xD;&#xA;MRL9T'\:?0I1]IBW?\L_H14YV,/\`5\^U'E0E&lt;F$?E1J.Z(A&lt;1#('ED_7I1]H&#xD;&#xA;MC;@^6&gt;.YJ3RH&gt;@@`_&quot;D$$&amp;&lt;M$/RI:BT(]T##A8LGIR.:5616Y2,GTW&quot;I!;VW&#xD;&#xA;M!$0&amp;.V*%@MSG$7Z4^4+D3&amp;/=PD7_`'UTI&amp;&gt;,=8XR&lt;]C4Y@M@,&gt;5^E(8;8&lt;&amp;+&#xD;&#xA;MGZ468[HBW1'I#&amp;/&lt;,*421]/*0_B*D-M:G@QX]&lt;&quot;C[':!3B,_3%&amp;K&quot;Z(R(F.3&#xD;&#xA;M;J/H11M@[P&lt;&gt;F:?]GM&lt;;0F!Z8H^RVQ3;Y&gt;*-0NA@^SD$&quot;W/X8IH2!AN-LQ/0&#xD;&#xA;MM4GV.UQ@`Y'?)I1:6ZKDY'XFBS&quot;Z(B(`W^H(`]J`MN&lt;`Q.,GUJ06=MNX+8_W&#xD;&#xA;MCS2&amp;QM6.2QSZ!C2LPNA#%;;&gt;(FQ[TCK;$?ZJ0X[`4];.V48+L/8,&gt;*4VEMMX&#xD;&#xA;MD8_5J+,+H@&quot;VS?*8Y!^!IYBM^I20^AYI6LK;;N#MCTW4&quot;TMRW^M?IW;I2U#0&#xD;&#xA;M55@YS&amp;WZTF+&lt;\&amp;)P/H:&gt;MM&quot;O5WS_`+QH:U@8`^8P_P&quot;!&amp;AH-&quot;+RK9FQLD'US&#xD;&#xA;M3@L.,;),#ZTIM(&gt;HD&lt;?\&quot;IK6D1(S,Y_X%0`,L/`*2$?C1LM\8\ESZ8S2FSM^&#xD;&#xA;MK2M[?-339V[8/FO]=YI68&quot;B.(9Q$X/K3L1+UA8^])]CMQ@ESG_?I39VQY#-G&#xD;&#xA;MN=]/4&gt;@UHHF;B%L?6@PPXP(&amp;_$TY;2V4&lt;,V&gt;_P`U#65L3D.W_?5%F&amp;@@2$?*&#xD;&#xA;M+?\``]*4+&quot;1@6X'U-(MC:=VW&gt;VZE-G;'TQ]:-170N(3A1`@(Z]*0,BMQ`GUR&#xD;&#xA;M*7[-8A1P,#N2:&gt;+&gt;TV]%SCBBS&quot;Z&amp;;TR?W*?4$4%XSMQ&quot;I^C&quot;G&quot;WM&gt;?D'UQ1]&#xD;&#xA;MCM`02N&quot;&gt;E&amp;H70$H%^6!0Q]QS3=Y7DVZ?F.:&lt;;&gt;U[+C\Z62WMMN-F1[TK,+H8&#xD;&#xA;MS*W6%0&gt;N&quot;12J4)QY&quot;%NW2F_9[4`83]#1]CM=P)!'H&lt;T]1Z$@8*O$*Y'&lt;8H9D&#xD;&#xA;M/WH#CUXIOV:U[DY]&lt;G--^RVF[.3G_&gt;-&amp;HM!VU.ODE?P%.&quot;QD`&amp;%OP/7]::MO&#xD;&#xA;M;%&gt;'8&gt;VXTHMK8,#O8'V&lt;T:A=`ZH!GRI%/H,YI5\O:&lt;B3]:7R(3G$C?\`?9I%&#xD;&#xA;MM(R3B9Q_P.BS#0%,)Y/F9Z#K0RQ=C(#Z&lt;XH%HH)_?R?3=2FW)X\]R&gt;WS#I2:&#xD;&#xA;M:#0`L0Z229'\.3S2J$+';,X&amp;.F:3[.XZ3N!G/)S2K;OS_I#'Z@&lt;4U&lt;6@*RJ&lt;&#xD;&#xA;M&amp;X?ZDTH9#D?:&lt;Y]QQ2M!*,`39)_V141M+G.X21G(YR@HU#0D4G[PN&lt;`]L&quot;EP&#xD;&#xA;MRL&lt;W&quot;X'TJ$07*J/FB)SW3K3S!&lt;MU\HGT*&lt;&amp;C4!^YR&lt;?:0&quot;&gt;V!0PE/2Y4XZC'&#xD;&#xA;M2HOLTQY(B/\`P&quot;E$$P.2L)'LN#0!,OFX^:93]!14#07`.%AA(Z\`T478[$'D&#xD;&#xA;MLO(MDQ]:&gt;JDJ/]'4508ZJ3@!&lt;#T%2+)JA7:56KN*S+AC.W/D+3&lt;,?^7=2/&lt;U&#xD;&#xA;M6$FH8&quot;E1TZXIJOJ/(V#/;BAL+,O@,``(12.77'[E3^-41+J0P2F?PIS-J+#[&#xD;&#xA;MHS]*.96'RET%V'^JQCWI2&amp;;&amp;(P#W-4%?402&quot;BG/M0'U(N,JH'KBE&lt;5B^RM@$&#xD;&#xA;M1@_0TP[EP/)Z]JKM)?E=NP&lt;4&quot;:_`&amp;8U!]*=T.Q:P5&amp;!;_E0#@X%N3D55^T7P&#xD;&#xA;M7'DCD\T&quot;ZOU)_&lt;+^5%T%BUM&amp;/]0?R%-8`\&quot;`@&gt;N*A^U7H))M^*3[;=X_X]J+&#xD;&#xA;MH5F380+CR&quot;#]*&gt;I4&lt;&gt;20&gt;^!5-+Z\&amp;&lt;6V!2F_N@__`!Z_+CC'&gt;BZ&quot;S+#LF&gt;86&#xD;&#xA;M/MB@O&quot;``8&amp;/_``&amp;JIO[IF&amp;;5E^M..H3X4?9GX[BE&lt;$F6E,1'^J8'Z4F(0QS&amp;&#xD;&#xA;MQ'L*J?VC&lt;$D_9VQ31J4PS_HS8HYD/E9:;R`W&quot;,/PIX6W)R$;/OFJHU.1EQ]F&#xD;&#xA;M84#47'2V:G=&quot;LRWMB'0-CWS0S1+_``L?SJJVK.%`%M)G/I2G4G*Y^S29[\4&lt;&#xD;&#xA;MR#E9:8P,N2&amp;_(TQ?(/\`&quot;^/H:@&amp;HOMP;9S^%(=1E7A;9S[9I&lt;R&quot;S+!6`?P/]&#xD;&#xA;M3FD`@Z%'_(U&quot;=1N.?]&amp;;Z4BW]RS&lt;VA`/?/-*Z&quot;S)##`6QLD'YTI6W5@&quot;)#CZ&#xD;&#xA;MU']MN!G-LWX5&amp;^H7/:U(QW)I70[,L+Y`ZB3'N#3E\@9R)?;&amp;:K?VC&gt;$;A:%O&#xD;&#xA;M:E74;C&lt;0UHPX[470698/D`9+.OYBDS!_SU&lt;'ZFH?[1F`Q]D&gt;F-J$RD9M7H;0&#xD;&#xA;M6998Q`&lt;SR?K2AH2I_P!(&lt;?4U7&amp;J-T:UDYZ&lt;4K:BN!FW;`ZG;1S!9DRA.INCC&#xD;&#xA;MMS0)$7/^DMCU-5VU2(''D-GME:5-4B)'[H_]\T.28[,LAX67FX8GZTA:(+S&lt;&#xD;&#xA;ML#VR:B&amp;H1*3F$G_@-#:A%P6@8_\``:+IBL2JR'_EZ/YU*'CY_P!(Z&gt;]4SJ46&#xD;&#xA;MX8@./&lt;4O]HQDD&gt;0WM\M&quot;:%9DQ,;]+IA^-&amp;,A3]KX^@J%=1BY!MGS_NTC7\`R&#xD;&#xA;MWDL!Z;*=T.S+/5@?M/Y&quot;A_-&quot;X%PI^JU5.K6N.8F`]EIRZG`6(,;`#@?+2YD%&#xD;&#xA;MF3XE(R+A./5:0/-N&amp;Z&gt;/Z8J-=1MBV-I'OMIC:E9!MI0DCOLI:=PLRPQE#;O.&#xD;&#xA;MBQ]*&quot;TQ8$S0X]A4']H6++]PY_P!VFBZL&quot;W*#GJ=M%T!9S/NVAXL^N*&gt;IG/5H&#xD;&#xA;MSZX'6JHGL2&lt;XPH_V:&lt;+JRW#&quot;Y!]C3N%GV)V,N#AXQ]13E,N,!HS]14'VBPW&lt;&#xD;&#xA;MCZ&lt;'BD\VSW?&gt;&amp;&lt;]&gt;:0%C;&lt;!3N,9].*`91G(C&amp;*A\^R)&amp;'7/&lt;DFAI[,9;?GVW&#xD;&#xA;M4]`LR8&quot;8&lt;CRR?&lt;4UC&lt;%&gt;$B8BH_,LF4L'!..@:D#687AUQ_OT@)U$Y7[D0-#?&#xD;&#xA;M:1P!&amp;?J:A5[(-C?@#_;H9K+=N#*???3T[B)&amp;%R&quot;`5B^M*!&lt;&lt;$B.HMUJW(=&gt;.&#xD;&#xA;MOS\TYFLU',B_]]TMQDBK-QQ%STQ2XG8$9C!^E1++:9R)!D&gt;K\4BRVNXL67\Z&#xD;&#xA;M&gt;@B7,RC`DC!_W:`9CP9$'OBFM-:=GC^N:89K+`W-&amp;2/QI)KN!*4F/25,?2EQ&#xD;&#xA;M-M&amp;74@&gt;U1&amp;&gt;RQ@/'GWI!&lt;VJX!=&gt;*-.X$Y9V!_&gt;*![&quot;FL9&quot;!B89'&lt;@4W[3:[3&#xD;&#xA;M@H31]IM%&amp;=Z9QVH`&gt;HD9N9E_[YI_S`;A*@(Z\5&quot;UW;!-P=/PH6[ML'+(1GIB&#xD;&#xA;MGH&amp;K)?WA.1*O/^SF@K,!N#QD#VJ)KBR89#QC';-(D]D1@NGYT:!9DRF3/#K_&#xD;&#xA;M`-\TK;]H.]3QZ5&quot;L]H#Q(OUS2?:;3/WT)]`U&amp;@$R)*#QL8?2G!'5CQ%]*B$M&#xD;&#xA;MJ6`#IZGYJ4O:E`1*HY_OT6068X[MW,&lt;?/8=*&amp;1\`B%&quot;?8]*:?(/`ES_P.E&quot;H&#xD;&#xA;MV0)L&lt;8^]0`J[CTAS[[\4T*Y89BQ@]GH4HORF&lt;X';=3\(S!A,?P84E&lt;`*E&gt;!$&#xD;&#xA;MP'J7I2&amp;5,;),CT&gt;D9&lt;9Q*WJ.13D#A?EFR,=U%,&quot;)68]4E_.GEC@9$N`&gt;F&gt;E.&#xD;&#xA;M*OWD&quot;_04A\W^&amp;4'ZK0`SS&amp;*G&quot;R@YZXI!.0V&quot;)&gt;O=&lt;BI%$X.0Z$&gt;I6D/GJ.)(&#xD;&#xA;MS_P&amp;EJ%A?.&amp;XY&gt;7VRM%(/M74O'^&quot;FBGJ%B)E;=Q.&quot;.XI0K?&gt;\X8[&quot;LA?L^&gt;)&#xD;&#xA;M9`?I3R+95P9V%4I#Y33*.S;A(,&gt;]*B..L@_*LEC;E&lt;&quot;Y&lt;4Q5ME_Y&gt;I/S-','&#xD;&#xA;M*;)5QG$BY^E*L&lt;C=9,FL?%L3_P`?4@&amp;.*&gt;&amp;A&amp;&quot;+I^?&gt;CF#E-8QN#D/GVQ3MK&#xD;&#xA;MMGYQCTK&amp;;82,7K#\:7:F&gt;+[&amp;1TS1S!RFMMDW??&amp;*-DC-D$5EX)&amp;!&gt;8(]:0$C&#xD;&#xA;M(^W?K1S&quot;LS6(D`&amp;&quot;,TUEEX!(S[5F+N&amp;&lt;7N[-($D)XO1^!HY@Y6:^)MI(VD&quot;F&#xD;&#xA;MD2JN&gt;#FL]%E5=AO5.3SS2,T@R!&gt;*![FCF'RFD%D+=5P1FAEER`=HS64#&lt;;AB&#xD;&#xA;M\7&amp;.YI^9^/\`2U..]'-Y&quot;LR^?-W`!03[F@&amp;8OC8N?8U1)F()%XC?C3%-P,DW&#xD;&#xA;MB#Z&amp;CF'8T6\P-NVKTYH_&gt;ARNQ&gt;F:RU%QN(-\I_&amp;I4,NX`W@_.BX6\R^#+NP$&#xD;&#xA;M&amp;*7+\Y1&gt;N*HEG`_X^QN^M)F0@_Z7S[&amp;A2'RFA\XP-@/I0&amp;DR3L'';UK/82X5&#xD;&#xA;MC?I[#-(S2,W_`!_KD^E%Q&lt;IH*9&quot;2=@'XTH\POC8/SK/)8$$WQSZBC&gt;O4WK9]&#xD;&#xA;M1Q2N/E+SB96X1??)H/G;@0J\&gt;]46&gt;-A_Q^OSW!IK^6S`&amp;\DR/3O3N*QH9F+'&#xD;&#xA;M*J,^]&amp;)%7!&quot;\^]9H$.3_`*3+P.10&amp;M^\\K?7M4W&quot;QI$RA0,)^=&amp;791@+GZUD&#xD;&#xA;MLMN!GSIR/3FB+[,RY^T3X^AHO&lt;?*:I:7J0/IFG;9&quot;N=BG\:RR+884S3?4YI=&#xD;&#xA;MT`X\^4?@&gt;:+BL7MTJCE%/XTH:1ER8E`^M93K$6W&amp;XE7VP:&lt;PB*C%W(/4&amp;ES#&#xD;&#xA;ML:8+&lt;`PK[=*1@Y/$(##KTK-'EJ`1&gt;R''K3O,1L_Z&gt;Q'?KQ1S(+,TBSC!\GZX&#xD;&#xA;MQ2EG'/DY_*LY60XQJ!Q]:&lt;K(&amp;(-^6]R:3DPL7F9@O,0`]0!2JS=!'^@JDQ7&lt;&#xD;&#xA;M&quot;-0./3-!4[AMOC],T[L5B\&amp;8L?W&gt;&lt;&gt;U&amp;[?P(B?;BJ+;L'%XOYT#SEY^W)THN&#xD;&#xA;M/E+N%QG[/R#SP*8'&amp;_\`U!'_``$539I1D?;E_&quot;D664M@WD9'J31&lt;.5EQMF?^&#xD;&#xA;M/?\`)*,(&lt;L;?_P`=JJLTY;B[CP*432KR;F(GZTKA9EK]T.EL.G7929B(QY&amp;&lt;&#xD;&#xA;M=?EJJUS&lt;[/\`C[BP.QZTD5Q.5;;=1'/7(IWT&quot;S+BK&quot;3Q!C_@-*RQ]?*_\=JJ&#xD;&#xA;MMQ.6&amp;ZX@;'3%.:&gt;;J9H&lt;?7BDFA699*Q,HW0\XS]VD*V[?\LUQCTJJ+JYW?ZZ&#xD;&#xA;M(^G/%`N+DY^&gt;`G&amp;1S3N.S)_+MFSF,&lt;?[-((K7D&amp;$9[Y!J(7%RLF083D=S3?M&#xD;&#xA;M5T3C?;XSD@-S1=!J3&quot;*T5&gt;(ESWP*&amp;ALRH;8H.::US&lt;D8/D`#N&amp;IPNKA5X2#I&#xD;&#xA;MP=]/0+,#;V9'W%.?K2F&amp;Q51^['([U$;B[`!V6^?3?1]JN01A(,]/O]:5T@LR&#xD;&#xA;M06UB,91&gt;&gt;^:0VM@V#L!)_2A;FX/!@B9AT&amp;\4AGN2O$$0]&lt;/1H&amp;I(+2Q4GY1G&#xD;&#xA;MW-`BM,[1&amp;F!3!&lt;W(.3;1$#OOY-&quot;W%UW@3KQ\U'NH-1S06&amp;,[%'KFD\BS49&quot;*&#xD;&#xA;M?H#0+BZW*6MH0/\`?ZTYI[G/%M&amp;O/`+TM`U%$=KN&amp;8ACZ4_;;#@Q*,=.*JM&lt;&#xD;&#xA;M7@&lt;$1Q9STWT-&lt;7A4@1QY/4!L4:(+,M9A*C&quot;+Z]*&lt;ODD&lt;1+]2*K1SWF,F*,@=&#xD;&#xA;MM]/,]T!@11=&gt;S470K,G*VX7&amp;Q,^PJ,&amp;#&amp;`B_E433W3-PD8Q[]:03WBD;H(@/&#xD;&#xA;M7?1S+H.S)-MJ&lt;9B4&gt;I(I1#9L#^[7\JC,MSD?N8S[;Z&lt;T]VJ\6T1_X%3NNH68&#xD;&#xA;MH@LE!RBCT.:%@L54L$3/2F&quot;YN&lt;8-FC#U#THGGV$&amp;S0&lt;_WA1H%F/:VL6Y&quot;J#]&#xD;&#xA;M:8MI9%MI4#GKOI1/.%R;/'T(IIGFX8V&amp;/QS2]T-1ZV-BI)`_-NM+]BLR,9P3&#xD;&#xA;MT^:F&amp;Y;H;)LX]!2+,^WFQ&lt;9/M1=!9BMIUL3R6)'^U0=-M,[@6Z8X:D&gt;;*@&quot;S&#xD;&#xA;MD)'7BA;HXXL9`.Y]*-`U'?V;;LO$C_\`?5)_9T9X$S\&gt;]`G#&lt;-92'T(IRR1Y&#xD;&#xA;M.;9P1^M/0-1#IJ''^D2?G0U@NT#[1(..YI#.BMC[+)MZD&amp;FM/&quot;3_`,&gt;LH].*&#xD;&#xA;MEV#5DB:&lt;0@`NI&lt;?6AM.&lt;MQ&lt;NOL3UJ-9H^AMIF'L#Q3S/$!G[/*?P.:-&amp;&amp;H+I&#xD;&#xA;MTV3B[&lt;?C12//!GBWF/THI^Z&amp;HS[5:`#,&gt;#V^6C[3:-N&amp;PG_@-2LX6/(4&lt;GGB&#xD;&#xA;MDD;;$LB@#(Z8K?D9-T0M/9C_`)9G/^[3?/LR.8O_`!RG_:@8P1&amp;O/7(IANU4&#xD;&#xA;M\Q@\4&lt;K'S(/M-C@'83ZC;2B:Q9&gt;8\#']VH?MWS`&gt;4F/I4UO&lt;&quot;68Q&amp;-1COBER&#xD;&#xA;ML+H0S6!7E._'%)YVGEAA?_':O(B-&amp;Q*+Q[5`2@G5!&amp;N&quot;.&gt;*.1BNB(O8,H^49&#xD;&#xA;M^E(!IXZXSZ8JZJ)G&amp;Q?3I3C;1!&gt;44_A1[-AS(HAM/W-C!X[&quot;D,E@IQQ],5&gt;^&#xD;&#xA;MSIM#;5S]*1;&gt;-V8&gt;6F1WQ0Z;#F14W6+J&quot;&lt;?E0XL,C./RJ\+6,?PK^51R11H5&#xD;&#xA;M!12&quot;&lt;=*7(PYD4]^G+SD9^E/$UACMD^U6FLH@3\BG'J*9Y,0/^K3\J.1V#F17&#xD;&#xA;M$MCTX_*EWV!Z8'X5:,4(P/*7/K2&amp;WBR!Y8HY6A\R*@DTY&gt;RY^E)YFFXSQU]*&#xD;&#xA;MO_98#SY:Y^E(+.`@_NU_*CE;%S(HB;3P&lt;$`G/I3V:P&amp;?NY[#%69;:&amp;)E&amp;P8)&#xD;&#xA;M[&quot;GFSB'6-#Z&lt;4N5AS(HEM/X&amp;U21[4+)8;]PV_E5M88&quot;Q4QC(&amp;&lt;XJ0VL*#)C3&#xD;&#xA;M\!2Y6/F13$UGN.$R/7;2&amp;XM,D!./]WI5P6Z$$JBC'MUI#'$9&quot;-@^4&lt;\=:=F'&#xD;&#xA;M,BF;BR'W$#?\`I_VRU15S$W/&lt;+4[&quot;-&amp;.$'3TI5=`,&amp;,'TXHLPNBI]N@+_P&quot;K&#xD;&#xA;M;G_9I?MMMN&quot;^4V?]VI6G5#S&amp;#QGBF-=)M!\H5-FF/0:;^`9Q&quot;Q`]5I/MZ;FV&#xD;&#xA;MV[_E2-?J,CRAT]:&lt;+\..(@#CUINZ$.%XKJO[B3_OFFM=QQMDV[8_W:!?_(!Y&#xD;&#xA;M8X]Z:;\X'[L?G2&amp;*+N)B?W#=,@[:&amp;NX6ZP,?^`U&amp;-4(.?)4]J%OB&gt;/+&amp;#[TK&#xD;&#xA;M@*;FVQQ`^1SRM*;BT=&lt;K;_-W^6E^V\$^4OIUIRWPV@&gt;4O%&quot;LP(3-9J!FWY[_&#xD;&#xA;M`&quot;4ADL&amp;;B(@=QMJ8WBMR8A^=-%Y&amp;(B?('7UI,8&quot;6PQ@PD#M\M#36`QNC/M\M&#xD;&#xA;M*+]0,^2M(]TF[&lt;8@1Z4KBL'GVC+A8Q^*T&quot;6R`&amp;4Y_P!VD6ZC8#$(!^M*U_&quot;C&#xD;&#xA;M?-#G'3&amp;*I`)FQ+9VY_&quot;D#6&quot;_\LA_WS3FO48'$(&amp;#GK0M[$XR(,&lt;]SFEH`U9K&#xD;&#xA;M`9!1&lt;_[M/+V`7=L&amp;&lt;&gt;E#W$60WDCZ4+&gt;P=?(_E0@#S+#:`ZC&lt;3P=M*L]D#@1!&#xD;&#xA;MO?;3/MUOG!@S@\=*&gt;;N)/E\GOB@!5FL5_@49']VA9[,J,(@]?EI!=VY'$'3I&#xD;&#xA;MG%'VJ(-_J&lt;XH&quot;Q()[0C(1&lt;#_`&amp;:8UQ8@#Y5'K\M(;R)LD0XYI1&lt;0'+B'CT(%&#xD;&#xA;M.X!Y]F2/E7';Y:4RV(/W4!]Q3?/M]PS#U]`*1[NV4@&gt;0&gt;?I26X#]U@&lt;$;!ZB&#xD;&#xA;MD9K#&lt;,*ON:#&lt;6X1CY/(]AS2K+:,F?((;J&gt;F#0`C'3V7YE7Z&quot;FA=.93]T'L,T&#xD;&#xA;MOF6RJ3Y.3]!09[;*@P9_`4.X!ML.P7]:&amp;6P#C!'S#N33A):@8\D_D*?OM1&amp;#&#xD;&#xA;MY)!QC@&quot;GT`CQ8@\8!_WJ7R['*@.#GK\U+Y]IC_4'IZ&quot;D2&gt;W88\G'X&quot;I`4K8*&#xD;&#xA;M#C:3GU--?[`H!!!!/J:&gt;T]N4R(CGW`IK&amp;U,1;R&gt;1[&quot;F!&amp;T-@&gt;2RD'WI?*L0.&#xD;&#xA;M6S_P*E\VV&quot;K^Y[&gt;@I0]J3@PGGO@4ABHMAMR&lt;$YZ%C3@MBVY5*X]&lt;T1-;OD&gt;5&#xD;&#xA;MC\!4RFW`X0_]\BFKBN0^38*V`5YZD'-`@LMWWE'K\U/8VX_Y9G\A0CP,YW1Y&#xD;&#xA;MX]!1;N(88K'((8&lt;?[1.:&lt;T%CLP6'XO4CQVX8*(_QH,5L#\T6&gt;.U%F!$;:RV@&#xD;&#xA;MF3_Q^D^RV88YF/\`WW3VMK9SS&amp;&gt;:3[):EO\`5GBD,1H+8(&quot;)6`_W^*?]FMVB&#xD;&#xA;MXD8X']^D^QVIQF,GGO3VMK95P(J+`,6VM\_ZYE^C\&amp;GBWAZ&gt;&gt;W3.=](+.W(^&#xD;&#xA;MX&gt;!GK3$L[=F8%#P/6BX:#Q;QLF#&lt;R?@])]CC9&lt;B&gt;0'N0]*+*V_N-^=+]C@Y&amp;&#xD;&#xA;M&amp;P.G-/Y&quot;N*MFA48N9/SI?LNW_EXD^FZD-E&quot;1T(QZ&amp;D:RB(!^;GWH$(+0L^3&lt;&#xD;&#xA;MR'O@M3FM'))%U(!VYI!I\(;J_'^T:&lt;MK%C;\V#SUS2L.XS[&amp;^[FZD!;N#S2K&#xD;&#xA;M:/M.+N3'3DBG_8HR0!G\2:0Z?$YP=P^C&amp;@+B&quot;T?_`)^7_!J*5K&quot;$\;I./]JB&#xD;&#xA;%G8+L_]D`&#xD;&#xA;" />
      </lst>
    </lst>
  </lst>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints">
        <int nm="BreakPoint" vl="765" />
        <int nm="BreakPoint" vl="749" />
        <int nm="BreakPoint" vl="559" />
        <int nm="BreakPoint" vl="567" />
        <int nm="BreakPoint" vl="529" />
        <int nm="BreakPoint" vl="524" />
        <int nm="BreakPoint" vl="543" />
        <int nm="BreakPoint" vl="539" />
        <int nm="BreakPoint" vl="537" />
        <int nm="BreakPoint" vl="551" />
        <int nm="BreakPoint" vl="798" />
        <int nm="BreakPoint" vl="836" />
        <int nm="BreakPoint" vl="839" />
        <int nm="BreakPoint" vl="499" />
        <int nm="BreakPoint" vl="413" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-24891: Fix when running hsbExcelToMap" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="6" />
      <str nm="DATE" vl="11/11/2025 4:14:57 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-17414 article collection derived from associated panels if in masterpanel mode" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="5" />
      <str nm="DATE" vl="1/10/2023 12:22:20 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-17273 Grade, Description and Material appended as predefined optional component definitions" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="4" />
      <str nm="DATE" vl="12/7/2022 2:58:37 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-17273 new article definition requires semicolon based component convention " />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="3" />
      <str nm="DATE" vl="12/7/2022 11:08:22 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-17273 supports layer preselection if defined in style name (convention: &lt;Thickness&gt; &lt;NumComponents&gt;&lt;SingleDoubleComponnet&gt; )" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="2" />
      <str nm="DATE" vl="12/6/2022 11:54:25 AM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-15891 supports also masterpanels" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="1" />
      <str nm="DATE" vl="7/1/2022 2:37:35 PM" />
    </lst>
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-15891 initial version" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="0" />
      <str nm="DATE" vl="6/30/2022 12:00:00 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End