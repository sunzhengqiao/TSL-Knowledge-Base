#Version 8
#BeginDescription
#Versions
Version 1.7 30.10.2024 HSB-22166 island strategy will always mill 4 sides, extension mode enhanced
Version 1.6 08.07.2024 HSB-22166 island strategy revised
Version 1.5 03.07.2024 HSB-22166 bugfix corner duplex mode
Version 1.4 03.07.2024 HSB-22166 new bridgin mode and pffset property to mill on 4 sides, NOTE not applicable for openings
Version 1.3 10.04.2024 HSB-21850 bugfix assigning automatic tool indices
Version 1.2 10.04.2024 HSB-21850 new property 'bridge mode' supports duplex bridging

Version 1.1 21.03.2024 HSB-21725placement considers panels nested within openings
Version 1.0 21.03.2024 HSB-19026 Initial version

This tsl creates tool operations to cut quality test panels from a masterpanel







#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 7
#KeyWords 
#BeginContents
//region Part #1
	

//region <History>
// #Versions
// 1.7 30.10.2024 HSB-22166 island strategy will always mill 4 sides, extension mode enhanced , Author Thorsten Huck
// 1.6 08.07.2024 HSB-22166 island strategy revised , Author Thorsten Huck
// 1.5 03.07.2024 HSB-22166 bugfix corner duplex mode , Author Thorsten Huck
// 1.4 03.07.2024 HSB-22166 new bridgin mode and offset property to mill on 4 sides, NOTE not applicable for openings , Author Thorsten Huck
// 1.3 10.04.2024 HSB-21850 bugfix assigning automatic tool indices , Author Thorsten Huck
// 1.2 10.04.2024 HSB-21850 new property 'bridge mode' supports duplex bridging  , Author Thorsten Huck
// 1.1 21.03.2024 HSB-21725 placement considers panels nested within openings , Author Thorsten Huck
// 1.0 21.03.2024 HSB-19026 Initial version , Author Thorsten Huck

/// <insert Lang=en>
/// Select masterpanels
/// </insert>

// <summary Lang=en>
// This tsl creates tool operations to cut quality test panels from a masterpanel
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbCLT-QC")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Stretch Masterpanel|") (_TM "|Select Tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Import Settings|") (_TM "|Select Tool|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Export Settings|") (_TM "|Select Tool|"))) TSLCONTENT
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

	Vector3d vecXView = getViewDirection(0);
	Vector3d vecYView = getViewDirection(1);
	Vector3d vecZView = getViewDirection(2);
	double dViewHeight = getViewHeight();	
//endregion 	


	
//end Constants//endregion

//region Functions
	
	//region Function DrawPlaneProfile
	// draws a planeprofile
	// pp: the profile to be drawn
	// color: 0-255 index color, > 255 RGB
	// transparency: 0<value<100 transparency value, else curve style
	void DrawPlaneProfile(PlaneProfile pp, Display dp, int color, int transparency, Vector3d vecTrans)
	{ 
		pp.transformBy(vecTrans);
		if (color<256)
			dp.color(color);
		else	
			dp.trueColor(color);
		
		if (transparency>0 && transparency<100)
			dp.draw(pp, _kDrawFilled, transparency);
		dp.draw(pp);
		return;
	}//End drawShape //endregion	

//endregion 

//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sPathGeneral = _kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\";	
	String sFileName ="hsbCLT-QC";
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
	double dThicknesses[0];
	double dDiameters[0];
	int nToolIndices[0];
	
{
	String k;
	Map mapTools= mapSetting.getMap("Tool[]");
	for (int i=0;i<mapTools.length();i++) 
	{ 
		Map m = mapTools.getMap(i);
		
		double thickness, diameter;
		int toolIndex;
		k="Thickness";		if (m.hasDouble(k))	thickness = m.getDouble(k);
		k="Diameter";		if (m.hasDouble(k))	diameter = m.getDouble(k);
		k="ToolIndex";		if (m.hasInt(k))	toolIndex = m.getInt(k);
		
		if (thickness>0 && diameter>0 && toolIndex>-1 && dThicknesses.find(thickness)<0)
		{ 
			dThicknesses.append(thickness);
			dDiameters.append(diameter);
			nToolIndices.append(toolIndex);		
		}
		else
		{ 
			String text;
			if (thickness < dEps)text += TN("|Specified Thickness invalid, must be > 0|");
			if (dThicknesses.find(thickness)>-1)text += TN("|Thickness already defined|: ") + thickness;
			if (diameter < dEps)text += TN("|Specified Diameter invalid, must be > 0|");
			if (toolIndex < 0)text += TN("|Specified ToolIndex invalid, must be >= 0|");
			if (text.length()>0)
				reportMessage(T("|Invalid parameters detected|")+text);
		}
	}//next i
	
// order ascending
	for (int i=0;i<dThicknesses.length();i++) 
		for (int j=0;j<dThicknesses.length()-1;j++) 
			if (dThicknesses[j]>dThicknesses[j+1])
			{
				dThicknesses.swap(j, j + 1);
				dDiameters.swap(j, j + 1);
				nToolIndices.swap(j, j + 1);				
			}
}
//End Read Settings//endregion 

//End Settings//endregion	

//region Jig Insert
	MasterPanel master;	
	String kJigInsert = "JigInsert";
	int bJig;
	if (_bOnJig && _kExecuteKey==kJigInsert) 
	{
	    _Pt0 = _Map.getPoint3d("_PtJig"); // running point		
		
		Map mapProps = _Map.getMap("Properties");
		setPropValuesFromMap(mapProps);
		
		Entity ent = _Map.getEntity("master");
		master = (MasterPanel)ent;
		bJig = true;

	}
//endregion 

//region Properties
category = T("|Distribution|");
	String sQuantityName=T("|Quantity|");	
	PropInt nQuantity(nIntIndex++, 2, sQuantityName);	
	nQuantity.setDescription(T("|Specifies the number of test panels that must be generated.|"));
	nQuantity.setCategory(category);
	nQuantity.setReadOnly(_bOnInsert || bDebug ? false: _kHidden);

category = T("|Geometry|");
	String sLengthName=T("|Length|");	
	PropDouble dLength(0, U(100), sLengthName);	
	dLength.setDescription(T("|Defines the length of the test piece in grain direction|"));
	dLength.setCategory(category);
	
	String sWidthName=T("|Width|");	
	PropDouble dWidth(1, U(100), sWidthName);	
	dWidth.setDescription(T("|Defines the width of the test piece in perpendicular to grain direction|"));
	dWidth.setCategory(category);

	String sOffsetName=T("|Offset|");	
	PropDouble dOffset(4, U(0), sOffsetName);	
	dOffset.setDescription(T("|Defines an additional offset from the masterpanel edge.|") + T("|This offset only applies to outer edges and will be ignored within openings or on inner edges of cut outs.|"));
	dOffset.setCategory(category);
//	if (dOffset<0)
//	{ 
//		dOffset.set(0);
//		reportMessage(T("|The offset may not be negative.|"));
//	}
	
	
	
	


category = T("|Tooling|");
	String sBridgeThicknessName=T("|Bridge Thickness|");	
	PropDouble dBridgeThickness(2, U(10), sBridgeThicknessName);	
	dBridgeThickness.setDescription(T("|Small items such as test pieces have a tendency to disrupt tooling devices upon detachment.|") + 
		T(" |In order to mitigate this issue, it is advisable to maintain a connection to the master by means of a bridge, thus thwarting any inadvertent damage.|")+
		T(" |The bridge will consistently maintain alignment with the grain direction to facilitate seamless detachment from the masterpanel.|"));
	dBridgeThickness.setCategory(category);
	dBridgeThickness.setControlsOtherProperties(true);
	
	String sBridgeModeName=T("|Bridge Mode|");	
	String tBMSingle = T("|Single Bridge|"), tBMDuplex = T("|Duplex Bridge|"),tBMDuplex4 = T("|Island|"), tBMNone=T("|No Bridge|"), sBridgeModes[] ={ tBMSingle, tBMDuplex,tBMDuplex4, tBMNone};
	PropString sBridgeMode(nStringIndex++, sBridgeModes, sBridgeModeName);	
	sBridgeMode.setDescription(T("|Defines the Bridge Mode|"));
	sBridgeMode.setCategory(category);
	sBridgeMode.setControlsOtherProperties(true);
	if (sBridgeModes.findNoCase(sBridgeMode ,- 1) < 0)sBridgeMode.set(sBridgeModes.first());
	
	if (_kNameLastChangedProp==sBridgeModeName)
	{ 
		if (sBridgeMode==tBMNone && dBridgeThickness>0)dBridgeThickness.set(0);
		else if (sBridgeMode!=tBMNone && dBridgeThickness<dEps)dBridgeThickness.set(U(10));
	}
	
//	if (dBridgeThickness <= dEps && sBridgeMode!=tBMNone)
//	{
//		sBridgeMode.set(tBMNone);
//	}
//	else if (dBridgeThickness > dEps && sBridgeMode==tBMNone)
//	{
//		sBridgeMode.set(tBMDuplex);
//	}

	String sToolDiameterName=T("|Tool Diameter|");	
	PropDouble dToolDiameter(3, U(40), sToolDiameterName);	
	dToolDiameter.setDescription(T("|If a tool configuration is present in the settings, the tool diameter will be assigned the appropriate diameter if the property is set to zero.|"));
	dToolDiameter.setCategory(category);
	dToolDiameter.setControlsOtherProperties(true);
	
	
	int bBySettings = dDiameters.length() > 0 && (dToolDiameter <= 0 || dDiameters.find(dToolDiameter)>-1);
	
	String sToolIndexName=T("|Tool Index|");	
	PropInt nToolIndex(nIntIndex++, 1, sToolIndexName);	
	nToolIndex.setDescription(T("|The toolindex specifies a particular tool during CNC export.|") +
		T("|In the event that a tool configuration has been defined in the settings and the tool diameter matches or is set to zero, this attribute will transform into a read-only state.|"));
	nToolIndex.setCategory(category);
	nToolIndex.setReadOnly(bBySettings?_kReadOnly:false);
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

		bBySettings = dDiameters.length() > 0 && (dToolDiameter <= 0 || dDiameters.find(dToolDiameter)>-1);
		
	// Validate
		if (nQuantity < 1)nQuantity.set(1);
		
		if (dToolDiameter<dEps && !bBySettings)
			dToolDiameter.set(U(40));


	// prompt for entities
		Entity ents[0];
		PrEntity ssE(T("|Select masterpanels|"), MasterPanel());
		if (ssE.go())
			ents.append(ssE.set());
		
	//region INsert Loation Show Jig	
		if (nQuantity==1 && ents.length()==1)
		{
		
			PrPoint ssP(T("|Select location|")); // second argument will set _PtBase in map
		    Map mapArgs;
		    mapArgs.setMap("Properties", _ThisInst.mapWithPropValues());
		    mapArgs.setEntity("master", ents[0]);
		    int nGoJig = -1;
		    while (nGoJig != _kOk && nGoJig != _kNone)
		    {
		        nGoJig = ssP.goJig(kJigInsert, mapArgs); 
		        if (bDebug)reportMessage("\ngoJig returned: " + nGoJig);
		        
		        if (nGoJig == _kOk)
		        {
		            _Pt0 = ssP.value(); //retrieve the selected point
		        }
//		        else if (nGoJig == _kKeyWord)
//		        { 
//		            if (ssP.keywordIndex() == 0)
//		                mapArgs.setInt("isLeft", TRUE);
//		            else 
//		                mapArgs.setInt("isLeft", FALSE);
//		        }
		        else if (nGoJig == _kCancel)
		        { 
		            eraseInstance(); // do not insert this instance
		            return; 
		        }
		    }			
		}//End Show Jig//endregion 

	// create TSL
		TslInst tslNew;
		GenBeam gbsTsl[] = {};
		int nProps[]={nQuantity, nToolIndex};			
		double dProps[]={dLength, dWidth, dBridgeThickness, dToolDiameter, dOffset};				
		String sProps[]={sBridgeMode};
		Map mapTsl;	

		
		for (int i=0;i<ents.length();i++) 
		{ 
			MasterPanel master = (MasterPanel)ents[i];
			if (!master.bIsValid()){ continue;}
			
			Point3d ptsTsl[] = {ents.length()==1?_Pt0:master.ptRef()};
			Entity entsTsl[] = {master};
			
			
			tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);			
	
		
		}//next i

		eraseInstance();
		return;
	}					
//endregion 

//region General
	Display dp(-1);	
	dp.textHeight(U(50));

	String kDataLink = "DataLink";	
	int bDrag = _bOnGripPointDrag && _kExecuteKey == "_Pt0";
	
	if (!bJig)
	{ 
		_ThisInst.setDrawOrderToFront(-1);
		addRecalcTrigger(_kGripPointDrag, "_Pt0");
		setExecutionLoops(2);		
	}


	
// Validate tool diameter
	if (dToolDiameter<dEps && !bBySettings)
	{
		reportNotice("\n"+scriptName()+": " + T("|Tool Diameter must be greater 0, auto corrected to 40mm|"));
		dToolDiameter.set(U(40));	
	}
// Validate size
	if (dLength<dEps)
	{
		reportNotice("\n"+scriptName()+": " + T("|Length must be greater 0, auto corrected to 100mm|"));
		dLength.set(U(100));	
	}	
	if (dWidth<dEps)
	{
		reportNotice("\n"+scriptName()+": " + T("|Width must be greater 0, auto corrected to 100mm|"));
		dWidth.set(U(100));	
	}
	int bIsDuplex = sBridgeMode == tBMDuplex;
	int bIsIsland = sBridgeMode == tBMDuplex4;
//endregion 

//region Get Master
	CoordSys cs();
	Plane pn(_PtW, _ZW);	

	
	for (int i=0;i<_Entity.length();i++) 
	{ 
		Entity e = _Entity[i];		
		if (!master.bIsValid())
			master = (MasterPanel)e; 		
		setDependencyOnEntity(e);
	}//next i

	if (!master.bIsValid())
	{ 
		eraseInstance();
		return;
	}


	Vector3d vecXGrain = master.getMainGrainDirectionFromChildPanels();	
	Vector3d vecYGrain = vecXGrain.crossProduct(-_ZW);
	int bLengthWise = vecXGrain.isParallelTo(_XW);
	
	double dThickness = master.dThickness(), dSpacing;
	double dDiameter = dToolDiameter;
	if (bBySettings)
	{ 
		for (int i=0;i<dThicknesses.length();i++) 
		{ 
			if (dThickness<=dThicknesses[i])
			{ 
				dDiameter = dDiameters[i];
				dToolDiameter.set(dDiameter);
				nToolIndex.set(nToolIndices[i]);
				break;
			}			 
		}//next i		
	}
	
	
	
	double dMasterOffsetX, dMasterOffsetY,dMPMOffsetX, dMPMOffsetY;
	TslInst tslMPM, siblings[0];
	{ 
		String name="hsbCLT-Masterpanelmanager".makeUpper();
		
		TslInst tsls[] = master.tslInstAttached();
		for (int i=0;i<tsls.length();i++) 
		{ 
			TslInst t = tsls[i];
			if (t.scriptName().makeUpper() == name)
			{ 
				tslMPM = t;
				dSpacing = tslMPM.propDouble(4);
				Map m = t.map();
				
				dMPMOffsetX = m.getDouble("MasterOversizeX");
				dMPMOffsetY = m.getDouble("MasterOversizeY");
				dMasterOffsetX = dMPMOffsetX;
				dMasterOffsetY = dMPMOffsetY;
				
			}
			else if (t.scriptName() == (bDebug?"hsbCLT-QC":scriptName()) && t!=_ThisInst)
			{ 
				siblings.append(t);
			}			 
		}//next i	
	}
	
//	// HSB-22166
//	if (dOffset<=dDiameter && bIsIsland)
//	{ 
//		dMasterOffsetX += dDiameter;
//		dMasterOffsetY += dDiameter;			
//	}
//	else
//	{ 
//		dMasterOffsetX += dOffset;
//		dMasterOffsetY += dOffset;			
//	}

//HSB-22166
	if (bIsIsland)
	{ 
		dMasterOffsetX=dDiameter;
		dMasterOffsetY=dDiameter;
	}
	if (dOffset>=-dDiameter)
	{ 
		dMasterOffsetX += dOffset;
		dMasterOffsetY += dOffset;				
	}
	

//Get Master //endregion 

//region Childs
	Sip clts[0];
	ChildPanel childs[] = master.nestedChildPanels();
	PlaneProfile ppAllChilds(cs), ppChilds[0];
	for (int i=0;i<childs.length();i++) 
	{ 
		
		ChildPanel& child = childs[i]; 
		
	// CLT	
		Sip clt = child.sipEntity();
		clts.append(clt);
		CoordSys csi = child.sipToMeTransformation();		

	// Body and Profile
		Body bd = clt.envelopeBody(true, true);
		bd.transformBy(csi);
		
		PlaneProfile ppChild(cs);
		ppChild.unionWith(bd.shadowProfile(pn));
		//dp.draw(ppChild);//.vis(252);
		ppChilds.append(ppChild);
		
		ppChild.shrink(-dSpacing-dEps);
		ppAllChilds.unionWith(ppChild); 
	}//next i	
	ppAllChilds.shrink(dSpacing+dEps);
	//ppAllChilds.vis(3);
	// { Display dp(6); dp.draw(ppAllChilds, _kDrawFilled, 20);}
//endregion 

//region Get Master Profiles
	PlaneProfile ppMaster(cs);
	ppMaster.joinRing(master.plShape(), _kAdd);	
	PlaneProfile ppMasterRect; ppMasterRect.createRectangle(ppMaster.extentInDir(_XW), _XW, _YW);
	
	double dXMaster = ppMaster.dX();
	double dYMaster = ppMaster.dY();
	Point3d ptMid = ppMaster.ptMid();
	vecXGrain.vis(ptMid, 7);

// openings	
	PlaneProfile ppMasterOpening(cs);
	int openingCount = master.openingCount(); 
	PLine plOpenings[0];
	for (int i=0;i<openingCount;i++) 
	{ 
		PLine plOpening = master.plOpeningAt(i);
		
		ppMaster.joinRing(plOpening,_kSubtract); 
		plOpenings.append(plOpening); 
		ppMasterOpening.joinRing(plOpening, _kAdd);
	}//next i
	
//Get net shape	
	PlaneProfile ppMasterOverSize(cs);
	if (dMasterOffsetX>0)
	{ 
		Vector3d vec = .5 * (_XW * dMasterOffsetX + _YW * dYMaster);
		PLine rec; 
		rec.createRectangle(LineSeg(ptMid - vec, ptMid + vec), _XW, _YW);
		rec.transformBy(_XW * .5 * (dXMaster - dMasterOffsetX));
		ppMasterOverSize.joinRing(rec, _kAdd);
		rec.transformBy(-_XW * (dXMaster - dMasterOffsetX));
		ppMasterOverSize.joinRing(rec, _kAdd);
		
		vec = .5 * (_YW * dMasterOffsetY + _XW * dXMaster);
		rec.createRectangle(LineSeg(ptMid - vec, ptMid + vec), _XW, _YW);
		rec.transformBy(_YW * .5 * (dYMaster - dMasterOffsetY));
		ppMasterOverSize.joinRing(rec, _kAdd);
		rec.transformBy(-_YW * (dYMaster - dMasterOffsetY));
		ppMasterOverSize.joinRing(rec, _kAdd);	
		//{ Display dpx(6); dpx.draw(ppMasterOverSize, _kDrawFilled, 20);}
	}		
	PlaneProfile ppMasterNet=ppMaster;
	ppMasterNet.subtractProfile(ppMasterOverSize);
	//{ Display dpx(6); dpx.draw(ppMasterNet, _kDrawFilled, 20);}

// Get possible range
	PlaneProfile ppOpening(cs);
	PlaneProfile ppRange=ppMasterNet;
	{ 
		PlaneProfile ppSub=ppAllChilds;
		ppSub.shrink(-dDiameter);		
		ppRange.subtractProfile(ppSub);
	}
	
	// subtract childs in openings
	{ 
		PlaneProfile pp(cs);	
		PLine rings[] = ppAllChilds.allRings(false, true);
		for (int r=0;r<rings.length();r++) 
		{
			pp.joinRing(rings[r],_kAdd);
			ppOpening.joinRing(rings[r], _kAdd);
		}
		//{ Display dp(2); dp.draw(pp, _kDrawFilled, 20);}
		rings = ppAllChilds.allRings(true, false);
	
	// order byArea descending
		for (int i=0;i<rings.length();i++) 
			for (int j=0;j<rings.length()-1;j++) 
				if (rings[j].area()<rings[j+1].area())
					rings.swap(j, j + 1);
		for (int r=1;r<rings.length();r++) // ignore main void
		{
			PlaneProfile ppIn(rings[r]);
			if (ppIn.intersectWith(pp))
			{
				//rings[r].vis(4);
				ppRange.joinRing(rings[r],_kSubtract); 
			}	
		}
			
	}

	// subtract siblings areas
	for (int i=0;i<siblings.length();i++) 
	{
		ppRange.subtractProfile(siblings[i].map().getPlaneProfile("ppQC")); 
	}

	
//	ppRange.shrink(.5*dWidth);
//	ppRange.shrink(-.5*dWidth);
	//{ Display dpx(6); dpx.draw(ppRange, _kDrawFilled, 20);}
	//{ Display dpx(6); dpx.draw(ppMasterNet, _kDrawFilled, 20);}

	PlaneProfile ppSecRange = ppRange;
//endregion 	

	
//Part #1 //endregion 

//region Tool
	double dToolWidth = dWidth + (dBridgeThickness>dEps?dDiameter:0);
	Vector3d vecT = - .5 * (vecXGrain * dLength + vecYGrain *dToolWidth);//TODO dToolWidth
	LineSeg segTool(_Pt0 - vecT, _Pt0 + vecT);segTool.vis(6);
	PlaneProfile ppTool; ppTool.createRectangle(segTool, _XW, _YW);
	
	PlaneProfile ppToolNet;
	{ 
		Vector3d vecT = - .5 * (vecXGrain * dLength + vecYGrain *dWidth);
		LineSeg segTool(_Pt0 - vecT, _Pt0 +vecT);
		ppToolNet.createRectangle(segTool, _XW, _YW);
	}
	//{ Display dpx(6); dpx.draw(ppTool, _kDrawFilled, 10);}
	
	Body bd;
	if (dLength>dEps && dWidth>dEps && dThickness>dEps)
		bd=Body(_Pt0, vecXGrain, vecYGrain, _ZW, dLength, dWidth, dThickness, 0, 0 ,- 1);			
//endregion 


//region Functions

	//region Function CreateMinRectangle
	// returns the minimal rectangular rings of a profile
	void CreateMinRectangle(PlaneProfile& ppRange)
	{ 
		CoordSys cs = ppRange.coordSys();
		Vector3d vecX = cs.vecX();
		Vector3d vecY = cs.vecY();
		
		PLine rings[] = ppRange.allRings(true, false);
		for (int r=0;r<rings.length();r++) 
		{ 
			PlaneProfile pp(cs);
			pp.joinRing(rings[r],_kAdd);
			PlaneProfile ppMax; ppMax.createRectangle(pp.extentInDir(vecX), vecX, vecY);
			PlaneProfile ppSub = ppMax; ppSub.subtractProfile(pp);
			PLine subs[] = ppSub.allRings(true, false);
			for (int i=0;i<subs.length();i++) 
			{ 
				ppSub = PlaneProfile(cs);
				ppSub.joinRing(subs[i],_kAdd);
				ppSub.createRectangle(ppSub.extentInDir(vecX), vecX, vecY);
				//ppSub.vis(1);
				ppRange.subtractProfile(ppSub); 
			}//next i
		}//next r
		return;
	}//endregion

	//region Function TrimRectangle
	// trims the given profile in dependency of the grain direction
	void TrimRectangle(PlaneProfile& ppRange, Vector3d vecXGrain, double dXTrim, double dYTrim)
	{ 
		Point3d ptm = ppRange.ptMid();
		double dX = ppRange.dX();
		double dY = ppRange.dY();

		CoordSys cs = ppRange.coordSys();
		Vector3d vecX = cs.vecX();
		Vector3d vecY = cs.vecY();

		
		double dx = vecX.isParallelTo(vecXGrain) ? dXTrim : dYTrim;
		double dy = vecX.isParallelTo(vecXGrain) ? dYTrim : dXTrim;
		

		PlaneProfile ppSub; ppSub.createRectangle(LineSeg(ptm-vecX*dx-vecY*dY,ptm+vecX*dx+vecY*dY), vecX, vecY);
		ppSub.transformBy(-vecX * .5 * dX);	//ppSub.vis(1);
		ppRange.subtractProfile(ppSub);
		ppSub.transformBy(vecX * dX);		//ppSub.vis(1);
		ppRange.subtractProfile(ppSub);
		return;
	}//End TrimRectangle //endregion

	//region Function GetSubRanges
	// returns profiles as subranges on the edges of given rings of a profile
	// subtracts primary ranges from secondary range (ppSecRange)
	PlaneProfile[] GetSubRange(PlaneProfile ppRange,PlaneProfile& ppSecRange,PlaneProfile& ppDisplayRange, PlaneProfile ppTool, Vector3d vecXGrain)
	{ 	
		PlaneProfile outs[0];

		int bXParallel = ppRange.coordSys().vecX().isParallelTo(vecXGrain);
		Vector3d vecYGrain = vecXGrain.crossProduct(-_ZW);

		Vector3d vecDirs[] ={ vecXGrain, vecYGrain ,- vecXGrain ,- vecYGrain};
		
		double dX = ppRange.dX();
		double dY = ppRange.dY();
		Point3d ptMid = ppRange.ptMid();

		LineSeg segR = ppRange.extentInDir(_XW);
		LineSeg segT = ppTool.extentInDir(_XW);


		for (int i=0;i<vecDirs.length();i++) 
		{ 
			Vector3d vecX = vecDirs[i];
			Vector3d vecY = vecX.crossProduct(-_ZW);

			double dXR = abs(vecX.dotProduct(segR.ptEnd()-segR.ptStart()));
			double dYR = abs(vecY.dotProduct(segR.ptEnd()-segR.ptStart()));	

			double dXT = abs(vecX.dotProduct(segT.ptEnd()-segT.ptStart()));
			double dYT = abs(vecY.dotProduct(segT.ptEnd()-segT.ptStart()));

//		// shorten perp edges
//			if (i%2==1)
//				dXR -= 2 * dXT;
//			if (bIsDuplex && vecX.isParallelTo(vecXGrain))
//			{
//				//dXR -= dDiameter;
//				dYT += dDiameter;
//			}
			
			Point3d pt = ptMid + vecY * .5 * dYR;	
			LineSeg seg (pt - vecX * .5 * dXR, pt + vecX * .5 * dXR - vecY * dYT);

			PlaneProfile ppx;
			ppx.createRectangle(seg, vecX, vecY);
			ppx.intersectWith(ppRange);			

			ppSecRange.subtractProfile(ppx);
			
			double dmin = (dYT < dXT ? dYT : dXT) * .5;
			ppx.shrink(.5 * dmin - dEps);
			ppx.shrink(-.5 * dmin + dEps);
//			
//			{ 
//				vecY.vis(pt, 4);
//				Display dpx(i); dpx.draw(ppx, _kDrawFilled, 60);
//			}
//						
			
			CreateMinRectangle(ppx);
			//{ Display dp(i+1); dp.draw(ppx, _kDrawFilled, 10);}
//			if (bDrag)
//				DrawPlaneProfile(ppx, dp, lightblue, 80, Vector3d());
			ppDisplayRange.unionWith(ppx);	
			
			TrimRectangle(ppx, vecXGrain, .5 * (dLength), .5*(dWidth));//TODO    + dDiameter      TODO   (bIsDuplex?2:1)*
			outs.append(ppx);
			//{ Display dp(i+3); dp.draw(ppx, _kDrawFilled, 20);}
		}//next i


		return  outs;
	}//endregion

	//region Function CollectSegments
	// returns
	// t: the tslInstance to 
	LineSeg[] CollectSegments(PlaneProfile pps[], double axisOffset)
	{ 
		LineSeg segs[0];		
		for (int i=0;i<pps.length();i++) 
		{ 
			PlaneProfile pp= pps[i]; 
			
			//{ Display dpx(2); dpx.draw(pp, _kDrawFilled, 40);}
			
			CoordSys cs = pp.coordSys();
			Vector3d vecX = cs.vecX();
			Vector3d vecY = cs.vecY();
			Point3d ptm = pp.ptMid();
			vecX.vis(ptm, 1);
			vecY.vis(ptm, 3);
			if (vecX.isParallelTo(vecXGrain))
				ptm+=vecY*axisOffset;//(.5*pp.dY()-)
			segs.append(pp.splitSegments(LineSeg(ptm - vecX * U(10e5), ptm + vecX * U(10e5)), true));
		}//next i
		
		//{ Display dp(2); dp.draw(segs);}
		
		return segs;
	}//endregion

	//region Function AddMill
	// returns
	// t: the tslInstance to 
	PLine AddMill(double depth, Point3d pt1, Point3d pt2, int side, int toolIndex, double offset)
	{ 
		PLine pl(_ZW);
		pl.addVertex(pt1); 
		pl.addVertex(pt2); //pl.vis(6);
		ElemMill em(0, pl, depth, toolIndex, side, _kTurnAgainstCourse, _kOverShoot);	
		if (!bJig)master.addTool(em);
		
		Vector3d vecX = pt2 - pt1; vecX.normalize();
		Vector3d vecY = vecX.crossProduct(-_ZW);
		
		PLine shape(_ZW);
		shape.createRectangle(LineSeg(pt1, pt2 - side*vecY * offset), _XW, _YW);	shape.vis(40);
		return shape;
	}//End AddMill //endregion	
	
	//region Function AddMillPath
	// returns
	// t: the tslInstance to 
	PLine AddMillPath(double depth, Point3d pts[], int side, int toolIndex, double offset, int bClose)
	{ 
		if (pts.length()<2)
			return;

		PLine pl(_ZW);
		for (int i=0;i<pts.length();i++) 
			pl.addVertex(pts[i]); 
		if (bClose)pl.close();	
		//pl.vis(6);
		ElemMill em(0, pl, depth, toolIndex, side, _kTurnAgainstCourse, _kOverShoot);	
		if (!bJig)master.addTool(em);
		
		PLine shape = pl;

		if (!bClose)
		{ 
			pl.offset(-side*offset, true);
			pl.reverse();
			shape.append(pl);
			shape.close();			
		}
		else
			shape.offset(-offset, true);

		
		return shape;
	}//End AddMillPath //endregion	

	//region Function GetPointOnProfile
	// returns the closest point on a profile
	// t: the tslInstance to 
	Point3d  GetPointOnProfile(PlaneProfile pp, Point3d pt, Vector3d vecN, Vector3d vecSide)
	{ 
		
		CoordSys cs = pp.coordSys();
		Vector3d vecX = cs.vecX();
		Vector3d vecY = cs.vecY();
		Point3d pts[] = Line(pt,-vecN).orderPoints(pp.intersectPoints(Plane(pt, vecN.crossProduct(-_ZW)), true, false));
	
		if (pts.length()>0) 
			pt = pts.first();	
		pt += vecSide;	
		return pt;
	}//endregion

//Functions //endregion 	
	
	//{ Display dpx(2); dpx.draw(ppDisplayRange, _kDrawFilled, 40);}


	//region Function OrderSubRanges
	// orders the subranges such that first will be always aligned with the corresponding edge
	// t: the tslInstance to 
	void OrderSubRanges(Point3d ptMid, PlaneProfile ppTool, PlaneProfile& pps[])
	{ 
		
		Point3d pt0 = ppTool.ptMid();
		double dx = _XW.dotProduct(pt0 - ptMid);
		double dy = _YW.dotProduct(pt0 - ptMid);

		Vector3d vecDir = _XW;
		double dd = dx;
		if (abs(dy)>abs(dx))
		{ 
			dd = dx;
			vecDir = _YW;
		}
		int sgn = dd==0?1:abs(dd) / dd;
		
		vecDir = vecDir*sgn;


	// order byArea
		for (int i=0;i<pps.length();i++) 
			for (int j=0;j<pps.length()-1;j++) 
			{
				double d1=pps[j].area();
				double d2=pps[j+1].area();				
				if (d1<d2)
					pps.swap(j, j + 1);
			}

	// order byAlignment
		for (int i=0;i<pps.length();i++) 
			for (int j=0;j<pps.length()-1;j++) 
			{
				Vector3d vecY1=pps[j].coordSys().vecY();
				Vector3d vecY2=pps[j+1].coordSys().vecY();			
				if (!vecY1.isCodirectionalTo(vecDir) && vecY2.isCodirectionalTo(vecDir))
					pps.swap(j, j + 1);
			}
//					
//		
//	
//		pps[0].coordSys().vecY().vis(pt0, 4);
//
//
		//vecDir.vis(pt0, 4);
		return;
	}//endregion

//region get SubRanges
	PlaneProfile ppDisplayRange(cs), ppSubRanges[0];
	PLine rings[] = ppRange.allRings(true, false);
	for (int i=0;i<rings.length();i++) 
	{ 
		PlaneProfile pp(cs);
		pp.joinRing(rings[i],_kAdd);
		pp.intersectWith(ppRange);
		//{ Display dpx(6); dpx.draw(pp, _kDrawFilled, 60);}
		
		PlaneProfile pps[0];
		pps.append(GetSubRange(pp,ppSecRange,ppDisplayRange, ppTool, vecXGrain)); 
		
		OrderSubRanges(ppMaster.ptMid(), ppTool, pps);
		
//		for (int j=0;j<pps.length();j++) 
//		{
//			pps[j].extentInDir(_XW).vis(2);
//			Display dp(j); 
//			dp.draw(pps[j], _kDrawFilled, 20);
//		}
		
		
		ppSubRanges.append(pps);
	}//next i

	double dSegmentOffset = dBridgeThickness < dEps && sBridgeMode == tBMDuplex4 ? 0 : .5 * dDiameter;
	LineSeg segs[] = CollectSegments(ppSubRanges, dSegmentOffset);
	
	if (bDrag || bDebug ||bJig)
		DrawPlaneProfile(ppDisplayRange, dp, lightblue, 70, Vector3d());
	//dp.draw(segs);
//	
//	for (int i=0;i<ppSubRanges.length();i++) 
//		ppSubRange.unionWith(ppSubRanges[i], _kAdd); 

//endregion 	




//region Function AddIslandNoBridge
	// adds the tool and returns the milling shape
	PlaneProfile AddIslandNoBridge(PlaneProfile ppTool, double dThickness, int nToolIndex,double dDiameter)
	{ 
		Point3d pts[] =ppTool.getGripVertexPoints();
		PLine shape = AddMillPath(dThickness, pts,_kRight, nToolIndex,dDiameter, true);					//shape.vis(6);					
		
		PlaneProfile ppMillingShape(CoordSys());
		ppMillingShape.joinRing(shape, _kAdd);
		ppMillingShape.subtractProfile(ppTool);
		
		return ppMillingShape;
	}//endregion




//region Snap to closest

	Point3d ptLoc = _Pt0;
	double dXT = ppToolNet.dX();
	double dYT = ppToolNet.dY();


// Bridge
	double depthBridge = dThickness - dBridgeThickness;
	PLine plBridge(_ZW);
	PlaneProfile ppBridge(cs);

// tooling shape
	PlaneProfile ppMillingShape(cs);	
	PLine shape(_ZW);

	int color = green;
	double dMin = U(10e10);
	int mySeg = -1;
	for (int i=0;i<segs.length();i++) 
	{ 
		LineSeg& seg = segs[i];
		double d = seg.distanceTo(_Pt0);
		seg.vis(i);
		if (dMin>d)
		{ 
			dMin = d;
			mySeg = i;
		} 
	}//next i
	
	
	
	
	if (mySeg>-1)
	{
		LineSeg seg = segs[mySeg];
		if (bDrag)
		{
			dp.color(12);
			dp.draw(seg);
		}
		ptLoc = seg.closestPointTo(_Pt0);
		
		ppTool.transformBy(ptLoc - _Pt0);
		ppToolNet.transformBy(ptLoc - _Pt0);		
		
		_Pt0 = ptLoc;

		//{ Display dpx(4); dpx.draw(ppToolNet, _kDrawFilled, 20);}
		
	// find subrange to retrieve relative location
		PlaneProfile ppr(CoordSys());// default world orientation
		for (int i=0;i<ppSubRanges.length();i++) 
		{ 
			//{ Display dp(i+3); dp.draw(ppSubRanges[i], _kDrawFilled, 20);}
			
			if (ppSubRanges[i].pointInProfile(_Pt0)!=_kPointOutsideProfile)
			{
				ppr=ppSubRanges[i]; 
				break;
			}	 
		}//next i
			
		CoordSys csr = ppr.coordSys();
		//csr.vis(2);
		Vector3d vecXR = csr.vecX();
		Vector3d vecYR = csr.vecY();	


	// alignment flag master net
		double dXN = .5 * (ppMasterNet.dX() - dXT);
		double dYN = .5 * (ppMasterNet.dY() - dYT);
		Point3d ptMidN = ppMasterNet.ptMid();
		double dXMid = _XW.dotProduct(_Pt0 - ptMidN);
		double dYMid = _YW.dotProduct(_Pt0 - ptMidN);		
		int nx = abs(dXN+dXMid)<dEps ?- 1 : (abs(dXN-dXMid)<dEps ? 1 : 0);
		int ny = abs(dYN+dYMid)<dEps ?- 1 : (abs(dYN-dYMid)<dEps ? 1 : 0);

	// alignment flag detected range
		double dXR = .5*(vecXR.isParallelTo(_XW)?ppr.dX():ppr.dY());
		double dYR = .5*(vecXR.isParallelTo(_XW)?ppr.dY():ppr.dX());
		Point3d ptMidR = ppr.ptMid();
		double dXMidR = _XW.dotProduct(_Pt0 - ptMidR);
		double dYMidR = _YW.dotProduct(_Pt0 - ptMidR);
		int nxr, nyr;
		vecYR.vis(ptMidR, 6);
		
		if (vecYR.isParallelTo(_XW))
		{ 
			nxr	= vecYR.isCodirectionalTo(_XW)?1:-1;
			nyr = abs(dYR+dYMidR)<dEps ?- 1 : (abs(dYR-dYMidR)<dEps ? 1 : 0);
		}
		else if (vecYR.isParallelTo(_YW))
		{ 
			nxr = abs(dXR+dXMidR)<dEps ?- 1 : (abs(dXR-dXMidR)<dEps ? 1 : 0);
			nyr	=vecYR.isCodirectionalTo(_YW)?1:-1;
		}		

		int bAtOpening = ppOpening.pointInProfile(_Pt0) != _kPointOutsideProfile;
		dOffset.setReadOnly(bAtOpening && !bDebug ? _kHidden: false);
		
		
	// No bridge and island	HSB-22166 
		if (dBridgeThickness<dEps && sBridgeMode==tBMDuplex4)
		{ 
			ppMillingShape = AddIslandNoBridge(ppTool, dThickness, nToolIndex, dDiameter);
		}

	// Corner placement
		else if ((abs(nx)==1 && abs(ny)==1) || (abs(nxr)==1 && abs(nyr)==1) )
		{ 
			int dirX = nx != 0 ? nx : nxr;
			int dirY = ny != 0 ? ny : nyr;
			
			double dx = .5 * dirX*dXT;
			double dy = .5 * dirY*dYT;
			double dxE = nx != 0?dMasterOffsetX : dDiameter;
			double dyE = ny != 0?dMasterOffsetY : dDiameter;
			
			int bOnMasterCorner = nx== nxr;
			
			Point3d pt1,pt2,pt3,pt4,pts[0];
			
		// Lengthwise	
			if (bLengthWise)
			{ 
				int side = dirX * dirY == 1 ? _kRight : _kLeft;
				
				pt1 = _Pt0 -_XW*dx + _YW*(dy+dirY*dyE);
				pt2 = _Pt0 -_XW*dx - _YW*dy;
				
				pt3 = _Pt0 +_XW*(dx+dirX*dxE) - _YW*dy;
				pt4 = _Pt0 -_XW*dx - _YW*dy;				
				
				if (dBridgeThickness>dEps)
				{ 
					pt1=GetPointOnProfile(ny==0?ppToolNet:ppMaster, _Pt0, dirY*_YW, -dx*_XW);	
					pt2=GetPointOnProfile(nx==0?ppToolNet:ppMaster, _Pt0, dirX*_XW, -dy*_YW);	
					if (nx==0)pt2 += dirX * _XW * dDiameter;
					if (ny==0)pt1 += dirY * _YW * dDiameter;
					Line(pt1, _YW).hasIntersection(Plane(pt2, _YW), pt3);
					
					if (bIsDuplex)
					{ 
						Point3d pts[] ={ pt1, pt3, pt2};
						if (depthBridge>dEps)
							ppBridge.joinRing(AddMillPath(depthBridge, pts,side, nToolIndex,dDiameter, false),_kAdd);							
					}
					else if (bIsIsland)
					{ 
						
						side = nxr*nyr==-1 ? _kLeft : _kRight;
						Vector3d vecDir = -nyr * _YW;
						Vector3d vecSide =.5*dYT*vecDir;
	
						pt1=GetPointOnProfile(ppToolNet, _Pt0, -dirX*_XW,vecSide);
						pt2=GetPointOnProfile(ppToolNet, _Pt0,  dirX*_XW,vecSide);
						pt3=GetPointOnProfile(ppToolNet, _Pt0,  dirX*_XW,-vecSide);
						pt4=GetPointOnProfile(ppToolNet, _Pt0, -dirX*_XW,-vecSide);		
	
						pt1 += vecDir * dDiameter;
						pt2 += vecDir * dDiameter;				
						
					// on master edge	
						Point3d pts[] ={ pt1, pt4};
						if (bOnMasterCorner)
						{ 
							pts.append(pt3);
							pts.append(pt2);
							shape = AddMillPath(dThickness, pts,-side, nToolIndex,dDiameter, false);
							ppMillingShape.joinRing(shape, _kAdd);//shape.vis(4);
							
						}
					// inner edge at opening
						else if (bAtOpening)
						{ 
							shape = AddMill(dThickness, pt1, pt4, -side, nToolIndex, dDiameter);
							ppMillingShape.joinRing(shape, _kAdd);//shape.vis(4);							
	
//							if (ppOpening.pointInProfile(_Pt0) == _kPointOutsideProfile)
//							{
//								shape = AddMill(dThickness, pt2, pt3, side, nToolIndex, dDiameter);
//								ppMillingShape.joinRing(shape, _kAdd);//shape.vis(4);
//							}
						}						
					// inner edge	
						else if (!bAtOpening)
						{ 
							pts.append(pt3);
							shape = AddMillPath(dThickness, pts,-side, nToolIndex,dDiameter, false);
							ppMillingShape.joinRing(shape, _kAdd);//shape.vis(4);								
							
//							shape = AddMill(dThickness, pt1, pt4, -side, nToolIndex, dDiameter);
//							ppMillingShape.joinRing(shape, _kAdd);//shape.vis(4);							
	
//							if (ppOpening.pointInProfile(_Pt0) == _kPointOutsideProfile)
//							{
//								shape = AddMill(dThickness, pt2, pt3, side, nToolIndex, dDiameter);
//								ppMillingShape.joinRing(shape, _kAdd);//shape.vis(4);
//							}
						}
						
						if (depthBridge>dEps)
						{
							ppBridge.joinRing(AddMill(depthBridge, pt2, pt1, side, nToolIndex, dDiameter), _kAdd);	
						}
	
						pt1.vis(1); pt2.vis(2); pt3.vis(3); pt4.vis(4);							
					}
					else
					{ 						
						if (depthBridge>dEps)
							ppBridge.joinRing(AddMill(depthBridge, pt3, pt2, side, nToolIndex, dDiameter), _kAdd);						
						
						pt3 -= _YW * dirY * dDiameter;
						shape = AddMill(dThickness, pt1, pt3, side, nToolIndex, dDiameter);
						ppMillingShape.joinRing(shape, _kAdd);//shape.vis(4);
						
					}				

					pt1.vis(1); pt2.vis(2); pt3.vis(3); pt4.vis(4);;


				}			
				else if (sBridgeMode==tBMDuplex4)
				{ 
					Point3d pts[] =ppTool.getGripVertexPoints();
					shape = AddMillPath(dThickness, pts,side, nToolIndex,dDiameter, true);					//shape.vis(6);					
					ppMillingShape.joinRing(shape, _kAdd);
					ppMillingShape.subtractProfile(ppTool);
					//shape.vis(1);
				}
				else
				{ 
					Point3d pts[] ={ pt1, pt2, pt3};						
					shape = AddMillPath(dThickness, pts,side, nToolIndex,dDiameter, false);
					ppMillingShape.joinRing(shape, _kAdd);//shape.vis(4);
					
					
					
					
					
				}				
			}
		// Crosswise		
			else
			{ 
				int side = dirX * dirY == 1 ? _kLeft : _kRight;
				
				//{ Display dpx(6); dpx.draw(ppOpening, _kDrawFilled, 20);}
				if (bIsIsland)// && ppOpening.pointInProfile(_Pt0)==_kPointOutsideProfile)
				{
					side = nxr*nyr==1 ? _kLeft : _kRight;
					Vector3d vecDir = -nxr * _XW;
					Vector3d vecSide =.5*dXT*vecDir;

					pt1=GetPointOnProfile(ppToolNet, _Pt0, -dirY*_YW,vecSide);
					pt2=GetPointOnProfile(ppToolNet, _Pt0,  dirY*_YW,vecSide);
					pt3=GetPointOnProfile(ppToolNet, _Pt0,  dirY*_YW,-vecSide);
					pt4=GetPointOnProfile(ppToolNet, _Pt0, -dirY*_YW,-vecSide);		

					pt1 += vecDir * dDiameter;
					pt2 += vecDir * dDiameter;				
					
				// on master edge	
					Point3d pts[] ={ pt1, pt4};
					if (bOnMasterCorner)
					{ 
						pts.append(pt3);
						pts.append(pt2);
						shape = AddMillPath(dThickness, pts ,- side, nToolIndex, dDiameter, false);
						ppMillingShape.joinRing(shape, _kAdd);//shape.vis(4);
						
					}
				// inner edge	
					else
					{ 
						shape = AddMill(dThickness, pt1, pt4, -side, nToolIndex, dDiameter);
						ppMillingShape.joinRing(shape, _kAdd);//shape.vis(4);							

						if (ppOpening.pointInProfile(_Pt0) == _kPointOutsideProfile)
						{
							shape = AddMill(dThickness, pt2, pt3, side, nToolIndex, dDiameter);
							ppMillingShape.joinRing(shape, _kAdd);//shape.vis(4);
						}
					}
					
					if (depthBridge>dEps)
						ppBridge.joinRing(AddMill(depthBridge, pt2, pt1, side, nToolIndex, dDiameter), _kAdd);	

					pt1.vis(1); pt2.vis(2); pt3.vis(3); pt4.vis(4);
				}
				else
				{
					pt1=GetPointOnProfile(nx==0?ppToolNet:ppMaster, _Pt0, dirX*_XW, -dy*_YW);
					pt2=GetPointOnProfile(ppr, _Pt0, -dirX*_XW, -dy*_YW);pt2.vis(2);
					pt3=GetPointOnProfile(nx==0?ppToolNet:ppMaster, _Pt0, dirY*_YW, Vector3d());
					pt3 = pt2 + _YW * _YW.dotProduct(pt3 - pt2);
					//pt3 = _Pt0 - _XW * dx + _YW * (dy + dirY * dyE);	
					pt4 = pt2;//_Pt0 -_XW*dx - _YW*dy;	
					
					
					pt1.vis(1);
					//pt1 = _Pt0 +_XW*(dx+dirX*dxE) - _YW*dy;				
					//pt2 = pt1-_XW*dirX*(dWidth+dDiameter+dMasterOffsetX);pt2.vis(2);//_Pt0 -_XW*dx - _YW*dy;
	
					pt3.vis(3);
					if (dBridgeThickness > dEps)
					{
						if (bIsDuplex  || bIsIsland)
						{ 
							pt3=GetPointOnProfile(ny==0?ppToolNet:ppMaster, _Pt0, dirY*_YW, -dirX*(.5*dWidth)*_XW);pt3.vis(3);
							Line(pt1, _XW).hasIntersection(Plane(pt3, _XW), pt2);pt2.vis(2);
	//						pt3 += dirX * _XW*dDiameter;
							Point3d pts[] ={ pt1, pt2, pt3};
							if (depthBridge>dEps)
								ppBridge.joinRing(AddMillPath(depthBridge, pts,side, nToolIndex,dDiameter, false),_kAdd);						
						}							
						else						
						{
							shape = AddMill(dThickness, pt1, pt2, side, nToolIndex, dDiameter);
							ppMillingShape.joinRing(shape, _kAdd);//shape.vis(4);
							
							ppBridge.joinRing( AddMill(depthBridge, pt3, pt4, side, nToolIndex, dDiameter), _kAdd);
						}
					}
					else
					{ 
						Point3d pts[] ={ pt1, pt2, pt3};						
						shape = AddMillPath(dThickness, pts,side, nToolIndex,dDiameter, false);
						ppMillingShape.joinRing(shape, _kAdd);//shape.vis(4);
					}					
					
					
					
					
					
				}
					

			}
		}
	// Mid placement
		else
		{ 
		// Direction Flag	
			int dirX = nx != 0 ? nx : nxr;
			int dirY = ny != 0 ? ny : nyr;
			
		// Oversize or inner ring offset	
			double dxE = nx != 0?dMasterOffsetX : dDiameter;
			double dyE = ny != 0?dMasterOffsetY : dDiameter;	
			
		// set direction to closest edge	
			if (dirX==0)
			{
				dirX = _XW.dotProduct(_Pt0 - ptMidR) < 0 ?- 1 : 1;
				//dxE = 0;
			}
			if (dirY==0)
			{
				dirY = _YW.dotProduct(_Pt0 - ptMidR) < 0 ?- 1 : 1;
				//dyE = 0;
			}
			
			
			double dx = .5 * dirX*dXT;
			double dy = .5 * dirY*dYT;

			
			Point3d pt1,pt2,pt3,pt4,pt5, pt6, pts[0];
			
			if (bDebug)
			{ 
				String text = "dirX: " + dirX + " dirY: " + dirY +"\nnx: " + nx + " ny: " + ny + "\nnxr: " + nxr + " nyr: " + nyr;
				dp.draw(text, _Pt0, _XW, _YW, 1, 0);
			}
			
			
			
		// Lengthwise	
			if (bLengthWise)
			{ 
			// Y-Aligned	
				if (vecYR.isParallelTo(_YW))
				{ 
					int side = dirX * dirY == 1 ? _kRight : _kLeft;
					//int side = dirY == 1 ? _kRight : _kLeft;
					pt1 = _Pt0 +_XW*dx - _YW*dy;
					pt2 = _Pt0 +_XW*dx + _YW*(dy+dirY*dyE);
					
					pt3 = _Pt0 -_XW*dx - _YW*dy;
					pt4 = _Pt0 -_XW*dx + _YW*(dy+dirY*dyE);	
					
				// Bridge	
					if (dBridgeThickness>dEps)
					{ 
						if (bIsDuplex || bIsIsland)
						{ 	
							if (bIsIsland ||(bIsDuplex && dirY!=0 && ny==0))
							{
								pt2=GetPointOnProfile(ppr, _Pt0, dirY*_YW, _XW * dx);//+_YW * ny* dDiameter;
								pt4=GetPointOnProfile(ppr, _Pt0, dirY*_YW, -_XW * dx);//+_YW * ny* dDiameter;								
							}

							if (depthBridge>dEps)					
							{
								ppBridge.joinRing(AddMill(depthBridge, pt1, pt3, -side, nToolIndex, dDiameter), _kAdd);
								if (bIsIsland && ny!=0)
									ppBridge.joinRing(AddMill(depthBridge, pt2, pt4, side, nToolIndex, dDiameter), _kAdd);
							}
								
							pt1 -= _YW * dirY*dDiameter;
							pt3 -= _YW * dirY*dDiameter;								
							if (bIsIsland)//
							{ 
								pt2 += _YW * ny*dDiameter;
								pt4 += _YW * ny*dDiameter;							
							}


							shape = AddMill(dThickness, pt2, pt1, -side, nToolIndex, dDiameter);
							ppMillingShape.joinRing(shape, _kAdd);//shape.vis(4);

							shape = AddMill(dThickness, pt4, pt3, side, nToolIndex, dDiameter);
							ppMillingShape.joinRing(shape, _kAdd);//shape.vis(4);

							pt1.vis(1);pt2.vis(2);pt3.vis(3); pt4.vis(4);pt5.vis(40); pt6.vis(40);	
						}
						else
						{ 
							shape = AddMill(dThickness, pt1, pt2, side, nToolIndex, dDiameter);
							ppMillingShape.joinRing(shape, _kAdd);//shape.vis(4);
						
							shape = AddMill(dThickness, pt3, pt4, -side, nToolIndex, dDiameter);				
							ppMillingShape.joinRing(shape, _kAdd);//shape.vis(4);
							
							if (depthBridge>dEps)
							{ 
								pt3 = _Pt0 +_XW*dx - _YW*dy;
								pt4 = _Pt0 -_XW*dx - _YW*dy;						
								ppBridge.joinRing(AddMill(depthBridge, pt3, pt4, side, nToolIndex, dDiameter), _kAdd);	
							}							
						}
						
					}
				// No Bridge	
					else
					{
						pt3 = _Pt0 -_XW*dx - _YW*dy;
						pt4 = _Pt0 -_XW*dx + _YW*(dy+dirY*dyE);						
						Point3d pts[] ={ pt4, pt3, pt1, pt2};						
						shape = AddMillPath(dThickness, pts,side, nToolIndex,dDiameter, false);
						ppMillingShape.joinRing(shape, _kAdd);//shape.vis(4);						
					}
				}				
			// No bridge
				else if (dBridgeThickness<dEps)
				{ 
					int side = dirX * dirY == 1 ? _kLeft : _kRight;
					Point3d pts[0];
					
					pts.append(_Pt0 +_XW*(dx+dirX*dxE) - _YW*dy);
					pts.append(_Pt0 -_XW*dx - _YW*dy);
					pts.append(_Pt0 -_XW*dx + _YW*dy);
					pts.append(_Pt0 +_XW*(dx+dirX*dxE) + _YW*dy);

					shape = AddMillPath(dThickness, pts,side, nToolIndex,dDiameter, false);
					ppMillingShape.joinRing(shape, _kAdd);//shape.vis(4);					
				}				
				else
				{ 
					int side = dirX * dirY == 1 ? _kRight : _kLeft;
	
					if (bIsDuplex || bIsIsland)
					{ 
						pt1=GetPointOnProfile(ppr, _Pt0, -dirX*_XW, -_YW * dy);
						pt2=GetPointOnProfile(ppr, _Pt0, -dirX*_XW, _YW * dy);						
						pt3 = pt1-dirY*_YW*dDiameter;
						pt4 = pt2+dirY*_YW*dDiameter;
						shape = AddMill(dThickness, pt3, pt4, -side, nToolIndex, dDiameter);
						//{ Display dpx(6); dpx.draw(PlaneProfile(shape), _kDrawFilled,10);}
						ppMillingShape.joinRing(shape, _kAdd);//shape.vis(4);
									
						if (bIsDuplex || nx==0)
						{
							pt5=GetPointOnProfile(nx==0?ppr:ppMaster, _Pt0, dirX*_XW, -_YW * dy)-dirY * _YW * dDiameter;
							pt6=GetPointOnProfile(nx==0?ppr:ppMaster, _Pt0, dirX*_XW, _YW * dy)+dirY * _YW * dDiameter;	
						}
						else if (bIsIsland)
						{
							pt5=GetPointOnProfile(ppr, _Pt0, dirX*_XW, -_YW * dy)-dirY * _YW * dDiameter;	
							pt6=GetPointOnProfile(ppr, _Pt0, dirX*_XW, _YW * dy)+dirY * _YW * dDiameter;															
							
							shape = AddMill(dThickness, pt5, pt6, side, nToolIndex, dDiameter);
							ppMillingShape.joinRing(shape, _kAdd);shape.vis(4);								
						}	
//						pt5 -= dirY * _YW * dDiameter;
//						pt6 += dirY*_YW*dDiameter;
						
						if (depthBridge>dEps)
						{
							ppBridge.joinRing(AddMill(depthBridge, pt3, pt5, -side, nToolIndex, dDiameter), _kAdd);
							ppBridge.joinRing(AddMill(depthBridge, pt4, pt6, side, nToolIndex, dDiameter), _kAdd);							
						}						
						
						
						pt1.vis(1);pt2.vis(2);pt3.vis(3); pt4.vis(4);pt5.vis(40); pt6.vis(40);					
					}					
					else
					{ 
						
						pt1 = _Pt0 +_XW*(dx+dirX*dxE) + _YW*dy;
						pt2 = _Pt0 -_XW*dx + _YW*dy;
						pt3 = _Pt0 - _XW * dx - _YW * (dy + dirY * dyE);	//pt1.vis(1); pt2.vis(2); pt3.vis(3);
						pt1.vis(1); pt2.vis(2); pt3.vis(3);
						Point3d pts[]={pt1,pt2,pt3};	
						shape = AddMillPath(dThickness, pts,side, nToolIndex,dDiameter, false);
						ppMillingShape.joinRing(shape, _kAdd);//shape.vis(4);
						
						
						if (depthBridge>dEps)
						{ 
							pt3 = _Pt0 +_XW*(dx+dirX*dxE) - _YW*dy;//(dy+dirY*dyE);
							pt4 = _Pt0 -_XW*dx - _YW*dy;	
							ppBridge.joinRing(AddMill(depthBridge, pt3, pt4, -side, nToolIndex, dDiameter), _kAdd);	
						}						
						
					}

				
					
				}
			}
		// Crosswise	
			else
			{	
			// Y-Aligned	
				if (vecYR.isParallelTo(_YW))
				{ 
					int side = dirX * dirY == 1 ? _kLeft : _kRight;
					Point3d pts[0];

					pt1=GetPointOnProfile(ppr, _Pt0, -dirY*_YW, -_XW * dx);
					pt2=GetPointOnProfile(ppr, _Pt0, -dirY*_YW, _XW * dx);						
					pt3 = pt1-dirX*_XW*dDiameter;
					pt4 = pt2+dirX*_XW*dDiameter;
					
					
					if (bIsDuplex)
					{ 
						shape = AddMill(dThickness, pt3, pt4, -side, nToolIndex, dDiameter);
						ppMillingShape.joinRing(shape, _kAdd);//shape.vis(4);	


						pt5=GetPointOnProfile(ny==0?ppr:ppMaster, _Pt0, dirY*_YW, -_XW * dx)-dirX * _XW * dDiameter;						
						pt6=GetPointOnProfile(ny==0?ppr:ppMaster, _Pt0, dirY*_YW, _XW * dx)+dirX * _XW * dDiameter;

					}
					else if (bIsIsland)
					{ 
						side = nyr==1 ? _kLeft : _kRight;
						Vector3d vecDir =  -_XW;
						Vector3d vecSide =.5*dXT*vecDir;
	
						pt1=GetPointOnProfile(ppToolNet, _Pt0, -dirY*_YW,vecSide);
						pt2=GetPointOnProfile(ppToolNet, _Pt0,  dirY*_YW,vecSide);
						pt3=GetPointOnProfile(ppToolNet, _Pt0,  dirY*_YW,-vecSide);
						pt4=GetPointOnProfile(ppToolNet, _Pt0, -dirY*_YW,-vecSide);	
						
						pt1 += vecDir * dDiameter;
						pt2 += vecDir * dDiameter;	
						pt3 -= vecDir * dDiameter;
						pt4 -= vecDir * dDiameter;						

						if (bAtOpening)
						{
							shape = AddMill(dThickness, pt4, pt1, side, nToolIndex, dDiameter);
							ppMillingShape.joinRing(shape, _kAdd);//shape.vis(4);
						}
						else
						{ 
							shape = AddMill(dThickness, pt1, pt4, -side, nToolIndex, dDiameter);
							ppMillingShape.joinRing(shape, _kAdd);//shape.vis(4);							
							shape = AddMill(dThickness, pt2, pt3, side, nToolIndex, dDiameter);
							ppMillingShape.joinRing(shape, _kAdd);//shape.vis(4);								
						}

						if (depthBridge>dEps)
						{
							ppBridge.joinRing(AddMill(depthBridge, pt2, pt1, side, nToolIndex, dDiameter), _kAdd);	
							ppBridge.joinRing(AddMill(depthBridge, pt4, pt3, side, nToolIndex, dDiameter), _kAdd);								
						}
						
						pt1.vis(1);pt2.vis(2);pt3.vis(3); pt4.vis(4);pt5.vis(40); pt6.vis(40);
						
						
					}
					else 
					{ 
						pt1 = _Pt0 + _XW * (dx) + _YW * (dy + dirY * dyE);
						pt2 = _Pt0 + _XW * (dx)- _YW*dy;
						pts.append(pt1);
						pts.append(pt2);

						if (dBridgeThickness>dEps)
						{ 
							pt3 = _Pt0 -_XW*(dx+ dirX * dxE) - _YW * dy;
							pt4 = _Pt0 -_XW*(dx+ dirX * dxE) + _YW * (dy + dirY * dyE);
							pts.append(pt3);
							shape = AddMillPath(dThickness, pts,+side, nToolIndex,dDiameter, false);
							shape.vis(4);
							ppMillingShape.joinRing(shape, _kAdd);shape.vis(4);
							
							ppBridge.joinRing(AddMill(depthBridge, pt3, pt4, -side, nToolIndex, dDiameter), _kAdd);	
						}
						else
						{ 
							pt3 = _Pt0 -_XW*dx - _YW * dy;
							pt4 = _Pt0 -_XW*dx + _YW*(dy+dirY*dyE);
							pts.append(pt3);
							pts.append(pt4);
							shape = AddMillPath(dThickness, pts,+side, nToolIndex,dDiameter, false);
							shape.vis(4);
							ppMillingShape.joinRing(shape, _kAdd);shape.vis(4);							
						}
						
					}
					
					if ((bIsDuplex) && depthBridge>dEps)
					{
						ppBridge.joinRing(AddMill(depthBridge, pt3, pt5, -side, nToolIndex, dDiameter), _kAdd);
						ppBridge.joinRing(AddMill(depthBridge, pt4, pt6, side, nToolIndex, dDiameter), _kAdd);							
					}						
														

					pt1.vis(1);pt2.vis(2);pt3.vis(3); pt4.vis(4);pt5.vis(40); pt6.vis(40);

				}
			// No bridge
				else if (dBridgeThickness<dEps)
				{ 
					int side = dirX * dirY == 1 ? _kLeft : _kRight;
					Point3d pts[0];
					
					pt1=GetPointOnProfile(nx==0?ppr:ppMaster, _Pt0, dirX*_XW, -_YW * dy);
					pt2=_Pt0 -_XW*dx - _YW*dy;//GetPointOnProfile(ppr, _Pt0, -dirX*_XW, -_YW * dy);					
					pt3=_Pt0 -_XW*dx + _YW*dy;//GetPointOnProfile(dirX==0?ppr:ppMaster, _Pt0, -dirX*_XW, +_YW * dy)+dirY * _YW * dDiameter;	
					pt4=GetPointOnProfile(nx==0?ppr:ppMaster, _Pt0, dirX*_XW, +_YW * dy);						

					pts.append(pt1);//_Pt0 +_XW*(dx+dirX*dxE) - _YW*dy);
					pts.append(pt2);//_Pt0 -_XW*dx - _YW*dy);
					pts.append(pt3);//_Pt0 -_XW*dx + _YW*dy);
					pts.append(pt4);//_Pt0 +_XW*(dx+dirX*dxE) + _YW*dy);

					shape = AddMillPath(dThickness, pts,side, nToolIndex,dDiameter, false);
					ppMillingShape.joinRing(shape, _kAdd);//shape.vis(4);	
					
					pt1.vis(1);pt2.vis(2);pt3.vis(3); pt4.vis(4);pt5.vis(40); pt6.vis(40);
				}
			// X-Aligned	
				else
				{ 
					int bOnMasterEdge = nx== nxr;
					int side = dirX * dirY == 1 ? _kLeft : _kRight;
					
					if (bIsIsland)
					{ 
						side = nxr==1?_kLeft:_kRight;

						Vector3d vecDir =  -dirX*_XW;
						Vector3d vecSide =.5*dXT*vecDir;
	
						pt1=GetPointOnProfile(ppToolNet, _Pt0, _YW,vecSide);
						pt2=GetPointOnProfile(ppToolNet, _Pt0, _YW,-vecSide);		
						pt3=GetPointOnProfile(ppToolNet, _Pt0,  -_YW,-vecSide);						
						pt4=GetPointOnProfile(ppToolNet, _Pt0, -_YW,vecSide);

						pt1 += vecDir * dDiameter;
						pt4 += vecDir * dDiameter;

					// on master edge	
						Point3d pts[] ={ pt1, pt2};
						if (bAtOpening)
						{ 
							shape = AddMill(dThickness, pt1, pt2, side, nToolIndex, dDiameter);
							ppMillingShape.joinRing(shape, _kAdd);//shape.vis(4);
							shape = AddMill(dThickness, pt4, pt3, -side, nToolIndex, dDiameter);
							ppMillingShape.joinRing(shape, _kAdd);//shape.vis(4);							
						}
						else
						{
							pts.append(pt3);
							pts.append(pt4);
							shape = AddMillPath(dThickness, pts,side, nToolIndex,dDiameter, false);
							ppMillingShape.joinRing(shape, _kAdd);//shape.vis(4);							
						}

						
						if (depthBridge>dEps)
						{
							ppBridge.joinRing(AddMill(depthBridge, pt1, pt4, side, nToolIndex, dDiameter), _kAdd);								
						}

					}
					
					else
					{ 
						Vector3d vecDY = -_YW * dy;
	
						for (int i=0;i<2;i++) 
						{ 
							pt1=GetPointOnProfile(nx==0?ppr:ppMaster, _Pt0, dirX*_XW, vecDY);
							pt2=GetPointOnProfile(ppr, _Pt0, -dirX*_XW, vecDY);			//pt1.vis(1);pt2.vis(2);
							
							if (i==0)
							{
								pt5 = pt1;
								pt3 = pt2;
							}
							else
							{
								pt6 = pt1;
								pt4 = pt2;							
							}
		
							shape = AddMill(dThickness, pt1, pt2, side, nToolIndex, dDiameter);
							ppMillingShape.joinRing(shape, _kAdd);//shape.vis(4);
	
							
							side *= -1;
							vecDY*=-1; 
						}//next i
	
		
						if (depthBridge>dEps)
						{ 
							//pt3.vis(1);pt4.vis(2);	
							ppBridge.joinRing( AddMill(depthBridge, pt3, pt4, -side, nToolIndex, dDiameter), _kAdd);
							if (bIsIsland && nx!=0)
								ppBridge.joinRing( AddMill(depthBridge, pt5, pt6, side, nToolIndex, dDiameter), _kAdd);
							
						}						
					}
					
					
					

					
					pt1.vis(1);pt2.vis(2);pt3.vis(3); pt4.vis(4);pt5.vis(40); pt6.vis(40);
					
					
				}				
			}

		}

		if (depthBridge>dEps && ppBridge.area()>pow(dEps,2) && dBridgeThickness>dEps)
		{ 
			ppBridge.intersectWith(ppMaster);
			PLine rings[] = ppBridge.allRings(true, false);
			for (int r=0;r<rings.length();r++) 
			{ 
				PLine pl = rings[r];
				//pl.vis(3);
				Body bridge(pl, _ZW *dBridgeThickness ,- 1);
				bridge.transformBy(-_ZW * depthBridge);
				//bridge.vis(4);
				//SolidSubtract sosu(sub,_kSubtract);	
				bd.addPart(bridge);
				ppMillingShape.joinRing(pl, _kAdd);
				ppTool.joinRing(pl, _kSubtract);			 
			}//next r
			ppMillingShape.intersectWith(ppMaster);

		}
		else if (dBridgeThickness<dEps && sBridgeMode==tBMDuplex4)
		{ 
			ppMillingShape.intersectWith(ppMaster);
		}
		
		//DrawPlaneProfile(PlaneProfile(plBridge), dp, color, 95, -_ZW*depthBridge );
		DrawPlaneProfile(ppMillingShape, dp, darkyellow, 95,Vector3d());

		if (bDebug)
		{ 
			dp.textHeight(U(20));
			dp.color(6);
			dp.draw("nx:"+nx + "/ny:" + ny+"\nnxr"+nxr + "/nyr:" + nyr, _Pt0, _XW, _YW, 0, 0);
		}
		
		_Map.removeAt("ppStretch", true);
	}
	
// no valid segment found
	else
	{ 
		ptLoc = ppAllChilds.closestPointTo(_Pt0);
		
		double dXChild = ppAllChilds.dX();
		double dYMasterNet = ppAllChilds.dY();
		Point3d ptMidChild = ppAllChilds.ptMid();

		//{Display dpx(1); dpx.draw(ppAllChilds, _kDrawFilled,80);}
	
		Vector3d vecX = _XW;
		Vector3d vecY = _YW;
		if (vecX.dotProduct(ptLoc - ptMid) < 0)vecX *= -1;
		if (vecY.dotProduct(ptLoc - ptMid) < 0)vecY *= -1;
		
		Point3d ptMasterExtr = ptMid + vecX * (.5 * dXMaster);		ptMasterExtr.vis(1);
		Point3d ptChildExtr = ptMidChild + vecX * (.5 * dXChild);	ptChildExtr.vis(2);
		double dXExtension = dXT + (bIsIsland ? 2 : 1) * dDiameter + dOffset;
		dXExtension-=vecX.dotProduct(ptMasterExtr - ptChildExtr);// subtract existing dx range
		
		Point3d ptExt = ptMasterExtr + vecX * dXExtension;			ptExt.vis(3);

		ptLoc+=vecX*(vecX.dotProduct(ptChildExtr-ptLoc)+dDiameter+.5*dXT);

		double dYMidOffset = vecY.dotProduct(ptLoc - ptMid);
		double dYMaxOffset = .5 * (dYMaster - dYT) - dOffset-dDiameter;
		if (dYMidOffset>dYMaxOffset)
		{ 
			ptLoc -= vecY * (dYMidOffset - dYMaxOffset);
		}
		_Pt0 = ptLoc;

		
	// Draw master extension
		Vector3d vecYM = _YW * (.5 * dYMaster);
		PLine pl(_ZW);
		Point3d pt1 = ptMid + vecX * (.5 * dXMaster) + vecYM;
		pl.addVertex(pt1);
		pl.addVertex(pt1 + vecX * dXExtension);
		pl.addVertex(pt1 + vecX * dXExtension-2*vecYM);
		pl.addVertex(pt1-2*vecYM);

		Point3d ptTxt = pl.ptMid();
	
		dp.trueColor(orange);
		PLine pl2 = pl;
		pl2.offset(U(5), false);
		pl2.reverse();
		pl2.append(pl);
		pl2.close();
		PlaneProfile pp(pl2);
		//pp.subtractProfile(ppTool);
		DrawPlaneProfile(pp, dp, orange, 30,Vector3d());
		color = red;
		
		dp.textHeight(U(150));
		dp.draw(T("|Stretch Masterpanel|"), ptTxt, _YW, - _XW, 0, 2*(vecX.isCodirectionalTo(_XW)?-1:1));
		
		pl.close();
		_Map.setPlaneProfile("ppStretch", PlaneProfile(pl));
		
	// Trigger StretchMasterPanel//region
		String sTriggerStretchMasterPanel = T("|Stretch Masterpanel|");
		addRecalcTrigger(_kContextRoot, sTriggerStretchMasterPanel );
		if (_bOnRecalc && (_kExecuteKey==sTriggerStretchMasterPanel || _kExecuteKey==sDoubleClick))
		{	
			ppMaster.joinRing(pl, _kAdd);
			
//		// add siblings stretch areas
			for (int i=0;i<siblings.length();i++) 
			{
				if (siblings[i]!=_ThisInst)
					ppMaster.unionWith(siblings[i].map().getPlaneProfile("ppStretch")); 
			}
			
			pl.createRectangle(ppMaster.extentInDir(_XW), _XW, _YW);
			//pl.transformBy(-vecX * .5 * (dDiameter+dOffset));
			master.setPlShape(pl);
			setExecutionLoops(2);
			return;
		}//endregion	

	}
	
	

//endregion 	


//region Draw
	DrawPlaneProfile(ppToolNet, dp, color, 80, Vector3d() );
	if (bJig)return;	
	dp.color(31);
	if (bDrag)bd.transformBy(ptLoc - _Pt0);
	dp.draw(bd);
//endregion 

//region Distribute
	if ((_bOnDbCreated || bDebug) && nQuantity>1)
	{ 
		PlaneProfile ppSnap = ppMaster;
		PlaneProfile ppHull(cs);
		if (ppDisplayRange.area()>pow(dEps,2))
		{ 
			ppSnap = ppDisplayRange;
			PLine hull; 
			hull.createConvexHull(pn,ppDisplayRange.getGripVertexPoints() );
			ppHull.joinRing(hull, _kAdd);			
		}
		else
			ppHull=ppMaster;

		Point3d pt = ppHull.ptMid();
		
		Point3d pts[0];
		if (nQuantity==2 || nQuantity==4)
		{ 
			pts.append(pt-_XW*dXMaster-_YW*dYMaster);
			pts.append(pt+_XW*dXMaster+_YW*dYMaster);		
		}
		else if (nQuantity==3)
		 { 
		 	
			pts.append(ppHull.closestPointTo(pt-_YW*dYMaster));
			pts.append(ppHull.closestPointTo(pt-_XW*dXMaster+_YW*dYMaster));	
			pts.append(ppHull.closestPointTo(pt+_XW*dXMaster+_YW*dYMaster));	
		}
		if (nQuantity==4)
		{ 
			pts.append(pt-_XW*dXMaster+_YW*dYMaster);
			pts.append(pt+_XW*dXMaster-_YW*dYMaster);		
		}		
		else if (nQuantity>4)
		{ 
			CoordSys rot;
			double a = 360 / nQuantity;
			rot.setToRotation(a, _ZW, pt);
			
			Vector3d vecX = -_YW;
			Vector3d vecY = _XW;
			for (int i=0;i<nQuantity;i++) 
			{ 
				Point3d ptsX[] = ppHull.intersectPoints(Plane(pt, vecY), true, false);
				ptsX = Line(pt, vecX).orderPoints(ptsX);
				
				Point3d ptX = pt + vecX * U(10e4);
				if (ptsX.length())
					ptX = ptsX.last();
				
				
				vecX = ptX - pt; vecX.normalize();
				vecY = vecX.crossProduct(-_ZW);
				
				pts.append(ptX);
				
				
				vecX.transformBy(rot);
				vecY.transformBy(rot);
				 
			}//next i
			
		}
		
	// create TSL
		TslInst tslNew;
		Entity entsTsl[] = {master};
		GenBeam gbsTsl[] = {};
		int nProps[]={1, nToolIndex};			
		double dProps[]={dLength, dWidth, dBridgeThickness, dToolDiameter, dOffset};				
		String sProps[]={sBridgeMode};
		Map mapTsl;	

		
		for (int i=0;i<pts.length();i++) 
		{ 
			Point3d ptX= ppSnap.closestPointTo(pts[i]);
			Point3d ptsTsl[] = {ptX};
			if(bDebug)
			{
				pts[i].vis(i); 
				PLine(pt, ptX).vis(i);
			}
			else
				tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);			
		}//next i	

		if (!bDebug)
			eraseInstance();
		return;
	}
//endregion 

//region Publish
	Map mapX;
	mapX.setEntity("Masterpanel", master);
	_ThisInst.setSubMapX(kDataLink, mapX);

	
// publish shapes	
	PlaneProfile ppQC; ppQC.createRectangle(ppMillingShape.extentInDir(_XW), _XW, _YW);
	//ppQC.subtractProfile(ppMasterOverSize);	ppQC.vis(2);
	_Map.setPlaneProfile("ppQC", ppQC);
	_Map.setPlaneProfile("Shape", ppTool );		


//endregion 

//region Dialog Trigger
{ 
	// create TSL
	TslInst tslDialog;			Map mapTsl;						
	GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
	int nProps[] ={ };			double dProps[] ={ };			String sProps[] ={ };
	
//region Trigger AddTool
	String sTriggerAddTool = T("|Add Tool|");
	//TODO addRecalcTrigger(_kContextRoot, sTriggerAddTool );
	if (_bOnRecalc && _kExecuteKey==sTriggerAddTool)
	{
		
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
}
//End Dialog Trigger//endregion 






// TODO collect inner range
//	ppSecRange.shrink(.5 * dToolWidth - dEps);
//	ppSecRange.shrink(-.5 * dToolWidth + dEps);
//	{ 
//		PlaneProfile ppSub = ppAllChilds;
//		ppSub.shrink(-dToolDiameter);
//		ppSecRange.subtractProfile(ppSub);
//	}
//	
//	{ Display dp(40); dp.draw(ppSecRange, _kDrawFilled, 30);}


//	ppSubRange.intersectWith(ppRange);
//	
//	{ Display dp(40); dp.draw(ppSubRange, _kDrawFilled, 20);}
//








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
        <int nm="BreakPoint" vl="1483" />
        <int nm="BreakPoint" vl="1543" />
        <int nm="BreakPoint" vl="1770" />
        <int nm="BreakPoint" vl="823" />
        <int nm="BreakPoint" vl="1440" />
        <int nm="BreakPoint" vl="1497" />
        <int nm="BreakPoint" vl="1410" />
        <int nm="BreakPoint" vl="1414" />
        <int nm="BreakPoint" vl="1649" />
        <int nm="BreakPoint" vl="1762" />
        <int nm="BreakPoint" vl="1613" />
        <int nm="BreakPoint" vl="1399" />
        <int nm="BreakPoint" vl="1305" />
        <int nm="BreakPoint" vl="1281" />
        <int nm="BreakPoint" vl="1609" />
        <int nm="BreakPoint" vl="1683" />
        <int nm="BreakPoint" vl="1576" />
        <int nm="BreakPoint" vl="1884" />
        <int nm="BreakPoint" vl="1102" />
        <int nm="BreakPoint" vl="1071" />
        <int nm="BreakPoint" vl="1015" />
        <int nm="BreakPoint" vl="1140" />
        <int nm="BreakPoint" vl="1261" />
        <int nm="BreakPoint" vl="1242" />
        <int nm="BreakPoint" vl="1794" />
        <int nm="BreakPoint" vl="1792" />
        <int nm="BreakPoint" vl="1773" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22166 island strategy will always mill 4 sides, extension mode enhanced" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="10/30/2024 12:48:23 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22166 island strategy revised" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="7/8/2024 4:53:09 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22166 bugfix corner duplex mode" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="7/3/2024 5:10:52 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22166 new bridgin mode and pffset property to mill on 4 sides, NOTE not applicable for openings" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="7/3/2024 4:06:24 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21850 bugfix assigning automatic tool indices" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="4/10/2024 3:03:27 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21850 new property 'bridge mode' supports duplex bridging " />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="4/10/2024 8:53:00 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19026 placement considers panels nested within openings" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="3/21/2024 2:07:25 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19026 Initial version" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="3/21/2024 11:47:09 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End