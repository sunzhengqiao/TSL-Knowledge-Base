#Version 8
#BeginDescription
#Versions
Version 1.5    18.06.2021    HSB-11864 Cleanup added, view dependency modified , Author Thorsten Huck

Version 1.4    14.06.2021    HSB-11864 map definition of type and subtypes added , Author Thorsten Huck
Version 1.3    11.05.2021    HSB-11864 settings and multiple rules per stereotype supported, renamed , Author Thorsten Huck
Version 1.2    11.05.2021    HSB-11856 dimensions of ruleset tsls are contributing for dim location , Author Thorsten Huck
Version 1.1    07.05.2021    HSB-11742 updated using new multipageview class , Author Thorsten Huck
Version 1.0    05.05.2021    HSB-11725 first draft of model based dimensioning (shopdrawings and model) , Author Thorsten Huck





#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 5
#KeyWords 
#BeginContents
//region Part #1
//region <History>
// #Versions
// 1.5 18.06.2021 HSB-11864 Cleanup added, view dependency modified , Author Thorsten Huck
// 1.4 14.06.2021 HSB-11864 map definition of type and subtypes added , Author Thorsten Huck
// 1.3 11.05.2021 HSB-11864 settings and multiple rules per stereotype supported, renamed , Author Thorsten Huck
// 1.2 11.05.2021 HSB-11856 dimensions of ruleset tsls are contributing for dim location , Author Thorsten Huck
// 1.1 07.05.2021 HSB-11742 updated using new multipageview class , Author Thorsten Huck
// 1.0 05.05.2021 HSB-11725 first draft of model based dimensioning (shopdrawings and model) , Author Thorsten Huck

/// <insert Lang=en>
/// Select a multipage or a genbeam
/// </insert>

// <summary Lang=en>
// This tsl creates a dimension line on a genbeam or its multipage (shopdrawing)
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "mpDim")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Set View|") (_TM "|Select dimension|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Append Tool|") (_TM "|Select dimension|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add Points|") (_TM "|Select dimension|"))) TSLCONTENT
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

	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	
	
	String analysedBeamCut_subTypes[] = { _kABCSeatCut, _kABCRisingSeatCut, _kABCOpenSeatCut, _kABCLapJoint, _kABCBirdsmouth, _kABCReversedBirdsmouth, _kABCClosedBirdsmouth, _kABCDiagonalSeatCut, _kABCOpenDiagonalSeatCut, _kABCBlindBirdsmouth, _kABCHousing, _kABCHousingThroughout, _kABCHouseRotated, _kABCHouseTilted, _kABCJapaneseHipCut, _kABCHipBirdsmouth, _kABCValleyBirdsmouth, _kABCRisingBirdsmouth, _kABCHoused5Axis, _kABCSimpleHousing, _kABCRabbet, _kABCDado, _kABC5Axis, _kABC5AxisBirdsmouth, _kABC5AxisBlindBirdsmouth};
	String analysedDrill_subTypes[] = {_kADPerpendicular, _kADRotated, _kADTilted, _kADHead, _kAD5Axis};			
	
	
	
	
// distinguish if current background is light or dark	
	int bIsDark;{int n = getBackgroundTrueColor();bIsDark = ((rgbR(n) + rgbB(n) + rgbG(n)) / 3 < 127);}
	
	int lightblue = rgb(204,204,255);
	int darkblue = rgb(26,50,137);	

	
	int yellow = rgb(241,235,31);
	int orange = rgb(242,103,34);
	int red = rgb(205,32,39);
	int purple = rgb(147,39,143);
	int blue = rgb(69,84,185);
	int petrol = rgb(16,86,137);
	int green = rgb(19,155,72);
	
	int grey = bIsDark?rgb(199,200,202):rgb(99,100,102);
	int white = bIsDark?rgb(255,255,255):rgb(0,0,0);


	int darkyellow = rgb(254, 204, 102);	
	
	Vector3d vecXView = getViewDirection(0);
	Vector3d vecYView = getViewDirection(1);
	Vector3d vecZView = getViewDirection(2);
	
	double dViewHeight = getViewHeight();

	String sToolTypes[] = { "AnalysedBeamCut", "AnalysedDrill", "AnalysedMortise", "AnalysedHouse", "AnalysedCut", "AnalysedFreeProfile"};
	int rgbToolColors[] = { red, blue, yellow, green, orange, purple};


	String sDisabled = T("<|Disabled|>");
	String sDefault = T("<|Default|>");
	String sSubXKey = "ViewProtect";
//end Constants//endregion

//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sPathGeneral = _kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\";	
	String sFileName ="ModelDimension";
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
//	String sStereotypes[] = {};int nStereoMapIndices[] ={};
//	Map mapStereotype, mapStereotypes;
//{
//	String k;
//	Map m = mapSetting.getMap("Stereotype[]");
//	//if (m.length()<1)m=_Map.getMap("Stereotype[]");
//	mapStereotypes = m;
//
////region Stereotypes
//	String sStereotypes[0];
//	for (int i=0;i<mapStereotypes.length();i++) 
//	{ 
//		Map m = mapStereotypes.getMap(i);
//		String name = m.getMapName();
//		if (name.length()>0 && sStereotypes.findNoCase(name,-1)<0)
//		{ 
//			sStereotypes.append(name);
//			nStereoMapIndices.append(i);
//		}	 
//	}//next i
//	
//	sStereotypes.insertAt(0, sDisabled);
//	nStereoMapIndices.insertAt(0 ,- 1);	
//	//End Stereotypes
//endregion 



//	k="DoubleEntry";		if (m.hasDouble(k))	dDoubleEntry = m.getDouble(k);
//	k="StringEntry";		if (m.hasString(k))	sStringEntry = m.getString(k);
//	k="IntEntry";			if (m.hasInt(k))	sIntEntry = m.getInt(k);
//	
//}
//End Read Settings//endregion 

//End Part #1//endregion 

//region Part #2

//region DialogMode
	int nDialogMode = _Map.getInt("DialogMode");
	if (nDialogMode>0)
	{ 
		String sRuleTypes[0],subTypes[0];
		if (nDialogMode == 1)// Beamcut
		{
			setOPMKey("Beamcut");
			subTypes = analysedBeamCut_subTypes.sorted();
		}
		else if (nDialogMode == 2)// Drill
		{
			setOPMKey("Drill");
			subTypes = analysedDrill_subTypes.sorted();		 	
		}

		else if (nDialogMode == 100)// RemoveTool
		{
			setOPMKey("RemoveTool");
			
			Map mapTools = _Map.getMap("Tool[]");
			for (int i=0;i<mapTools.length();i++) // collect all specified tools
			{ 
				Map m = mapTools.getMap(i);
				String type = m.getString("type");
				String subType = m.getString("subtype");
				
				String sRuleType = type + "__" + subType;
				if (type.length()>0 && subType.length()>0 && sRuleTypes.findNoCase(sRuleType)<0)
					sRuleTypes.append(sRuleType);
			}//next i						
			sRuleTypes = sRuleTypes.sorted();		 	
		}

		subTypes.insertAt(0, T("|All Types|"));

category = T("|Tool|");
		String sToolTypeName=T("|Tool Type|");	
		PropString sToolType(nStringIndex++, nDialogMode == 100?sRuleTypes:"", sToolTypeName);	
		sToolType.setDescription(T("|Defines the ToolType|"));
		sToolType.setCategory(category);
		sToolType.setReadOnly(true);

		String sSubTypeName=T("|Subtype|");
		subTypes.insertAt(0, T("|All Types|"));
		PropString sSubType(nStringIndex++, subTypes, sSubTypeName);	
		sSubType.setDescription(T("|Defines the subtype of the tool|"));
		sSubType.setCategory(category);
			
		
		if (nDialogMode == 50)
		{ 
			sToolType.setReadOnly(true);
			sSubType.setReadOnly(_kHidden);
		}
		else if (nDialogMode == 100)
		{ 
			sToolType.setReadOnly(false);
			sSubType.setReadOnly(_kHidden);
		}		
		
		return;
	}
//End DialogMode//endregion

//region Variables
	Vector3d vecX, vecY, vecZ;
	Vector3d vecXMS, vecYMS, vecZMS = _Map.getVector3d("vecZMS");
	Vector3d vecXPS, vecYPS, vecZPS;

	CoordSys cs;
	
	MultiPage mp;
	PlaneProfile ppViewports[0];	CoordSys csPaperspaces[0];  // to be in synch
	ViewData vdatas[0];
	MultiPageView mpvs[0], mpv;
	Entity entDefine, showSet[0], defineSet[0];
	ChildPanel child;
//End Variables//endregion 	
	
//region Get the multipage for jiggig or from _Entity
	int bJig = _bOnJig && _kExecuteKey == "Jig";
	int bToolJig = _bOnJig && _kExecuteKey == "ToolJig";
	int bPointJig = _bOnJig && _kExecuteKey == "PointJig";
	if (bJig)
	{ 
		Entity entDefine = _Map.getEntity("entDefine");
		mp = (MultiPage)entDefine;
	}
	else if (bToolJig)
	{ 
		Entity entDefine = _Map.getEntity("entDefine");
		mp = (MultiPage)entDefine;		
	}
	else if (!bPointJig)
	{ 
		for (int i=0;i<_Entity.length();i++) 
		{ 
			MultiPage _mp = (MultiPage)_Entity[i]; 
			ChildPanel _child= (ChildPanel)_Entity[i]; 
			if (_mp.bIsValid() && !mp.bIsValid()) // first multipage in sset
			{
				mp = _mp;
				setDependencyOnEntity(_mp);
				break;
			}
			else if (_child.bIsValid() && !entDefine.bIsValid()) // first multipage in sset
			{
				entDefine = _child;
				child = _child;
				setDependencyOnEntity(_child);
				break;
			}
		}
	}

	int nView = -1;
	if (mp.bIsValid())
	{ 
		cs=mp.coordSys();
		vecX = cs.vecX();	vecXPS = cs.vecX();
		vecY = cs.vecY();	vecYPS = cs.vecY();
		vecZ = cs.vecZ();	vecZPS = cs.vecZ();

		showSet= mp.showSet();
		defineSet= mp.defineSet();

		mpvs = mp.views();
		for (int i=0;i<mpvs.length();i++) 
		{ 
			MultiPageView& mpv = mpvs[i];
			
			PlaneProfile pp(cs);
			pp.joinRing(mpv.plShape(), _kAdd);
			ppViewports.append(pp);
			
			CoordSys ps2ms = mpv.modelToView();
			ps2ms.invert();
			if (!vecZMS.bIsZeroLength() && ps2ms.vecZ().isParallelTo(vecZMS))
			{	
				nView = i;	
				reportMessage(("\nView ") + nView + " detected " + vecZMS);
			}
		}	
	}
	else if (_GenBeam.length() > 0)
	{
		GenBeam g = _GenBeam.first();
		Quader qdr(g.ptCen(), g.vecX(), g.vecY(), g.vecZ(), g.solidLength(), g.solidWidth(), g.solidHeight(), 0, 0, 0);
		vecZ = qdr.vecD(_ZU);
		vecX = qdr.vecD(_XU);
		vecY = vecX.crossProduct(-vecZ);
		cs = CoordSys(g.ptCen(), vecX, vecY, vecZ);
	
		for (int i=0;i<_GenBeam.length();i++) 
			showSet.append(_GenBeam[i]);
	}
	else if (child.bIsValid())
	{ 
		CoordSys csChild = child.coordSys();
		Body bd = child.realBody();
		Quader qdr(bd.ptCen(), csChild.vecX(), csChild.vecY(), csChild.vecZ(),
			bd.lengthInDirection(csChild.vecX()), 
			bd.lengthInDirection(csChild.vecY()),
			bd.lengthInDirection(csChild.vecZ()), 0, 0, 0);
		vecZ = qdr.vecD(_ZU);
		vecX = qdr.vecD(_XU);
		vecY = vecX.crossProduct(-vecZ);
		cs = CoordSys(bd.ptCen(), vecX, vecY, vecZ);		
		
		showSet.append(child.sipEntity());
	}
	else if (!_bOnJig  && !_bOnInsert)
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|No defining entity found|"));
		eraseInstance();
		return;
	}
	Plane pnZ(cs.ptOrg(), cs.vecZ());
//End Get the multipage for jiggig or from _Entity//endregion 

		
//End Part #2//endregion 

//region Part #3 Jigs

//region bOnJig
	
	if (bJig) 
	{
	//_ThisInst.setDebug(TRUE);
		//Point3d ptBase = _Map.getPoint3d("_PtBase"); // set by second argument in PrPoint
		Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point
		Line(ptJig, vecZView).hasIntersection(pnZ, ptJig);
			
		Display dp(-1);

	// get closest view
		int n = -1;
		double dDist = U(10e6);
		
		for (int i = 0; i < ppViewports.length(); i++)
		{
			double d = Vector3d(ptJig - ppViewports[i].closestPointTo(ptJig)).length();
			if (d < dDist)
			{
				dDist = d;
				n = i;
			}
		}
		
	// draw jig
		for (int i = 0; i < ppViewports.length(); i++)
		{ 	
			PlaneProfile pp = ppViewports[i];
			if (i==n)
			{ 
				PlaneProfile pp2 = pp;
				pp2.shrink(dViewHeight / 200);

				dp.trueColor(darkyellow, 50);
				dp.draw(pp2,_kDrawFilled);

				dp.color(1);
				dp.draw(pp);				
				pp.subtractProfile(pp2);
				dp.draw(pp,_kDrawFilled);
			}
			else
			{ 
				dp.trueColor(lightblue, 50);
				dp.draw(pp,_kDrawFilled);
			}
 
		}//next i
		


	    return;
	}		
//End bOnJig//endregion 

//region bOnToolJig
	else if (bToolJig)
	{ 
		Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point
		Line(ptJig, vecZView).hasIntersection(pnZ, ptJig);
		
		CoordSys csView(ptJig, vecXView, vecYView, vecZView);
		Plane pnView(ptJig, vecZView);

		Display dp(-1);
		String sDimStyle = _Map.getString("DimStyle");
		dp.dimStyle(sDimStyle);
		double textHeight = getViewHeight() / 75;
		if (textHeight > U(100))textHeight = U(100); // paperspace
		dp.textHeight(textHeight);
		
		PlaneProfile pps[0];
		Body bodies[0];
		String types[0],subTypes[0], texts[0];

		for (int i=0;i<_Map.length();i++) 
		{ 
			Map m = _Map.getMap(i);
			
			PlaneProfile pp(CoordSys(ptJig, vecXView, vecYView, vecZView));
			if (m.hasPlaneProfile("ppTool")) 
				pp=m.getPlaneProfile("ppTool");
			else if (m.hasBody("bdTool")) 
				pp.unionWith(m.getBody("bdTool").shadowProfile(pnView));
			else continue;
			pps.append(pp);
			texts.append(m.getString("text"));
			types.append(m.getString("toolType"));
		}//next i
		

	// get closest tool
		int n = -1;
		double dDist = U(10e6);
		
		for (int i = 0; i < pps.length(); i++)
		{
			double d = Vector3d(ptJig - pps[i].closestPointTo(ptJig)).length();
			if (d < dDist)
			{
				dDist = d;
				n = i;
			}
		}		
	// draw jig
		for (int i = 0; i < pps.length(); i++)
		{ 	
			PlaneProfile pp = pps[i];
				
			if (i==n)
			{ 		
				int x = sToolTypes.findNoCase(types[i] ,0)%rgbToolColors.length();
				dp.trueColor((x >- 1 ? rgbToolColors[x] : red),50);
				dp.draw(pp,_kDrawFilled);
				dp.draw(pp);	
	
				double dX = dp.textLengthForStyle(texts[i], sDimStyle, textHeight);
				double dY = dp.textHeightForStyle(texts[i], sDimStyle, textHeight);
				
				Point3d pt = ptJig + vecXView * 2 * textHeight;
				PlaneProfile ppBox; ppBox.createRectangle(LineSeg(pt-vecYView*.5*dY,pt+vecYView*.5*dY+vecXView*dX), vecXView, vecYView);
				ppBox.shrink(-.5 * textHeight);
				dp.trueColor(grey, 50);
				dp.draw(ppBox,_kDrawFilled);
				dp.trueColor(white);
				dp.draw(texts[i], pt, vecXView, vecYView, 1, 0);
				dp.draw(texts[i], pt, vecXView, vecYView, 1, 0);
				dp.draw(PLine(pt, ptJig, pp.closestPointTo(ptJig)));

			}
			else
			{ 
				dp.trueColor(lightblue, 50);
				//dp.draw(ppShadows[i],_kDrawFilled);
				dp.draw(pp,_kDrawFilled);
			}
 
		}//next i	
		
		return;
	}
//End bOnJig//endregion 

//region bOnToolJig
	else if (bPointJig)// || _bOnGripPointDrag)
	{ 
		Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point
		Line(ptJig, vecZView).hasIntersection(pnZ, ptJig);
		
//		if (_bOnGripPointDrag)_Map = _Map.getMap("DimProps");
//reportMessage("\nHit Jig with keys" + " "+ _Map);
//
		Display dp(4);
		String sDimStyle = _Map.getString("DimStyle");
		dp.dimStyle(sDimStyle);	
		
		Point3d ptLoc=_Map.getPoint3d("ptLoc");
		Vector3d vecDir=_Map.getVector3d("vecDir"), vecPerp=_Map.getVector3d("vecPerp");
		DimLine dl(ptLoc, vecDir, vecPerp);
		Dim dim;
		{
			Point3d pts[0];
			dim = Dim(dl,  pts, "",  "", _Map.getInt("DeltaMode"), _Map.getInt("ChainMode")); 
		}
					
	// add dimpoints
		Point3d pts[]=_Map.getPoint3dArray("pts");
		pts.append(ptJig);
		for (int i=0;i<pts.length();i++) 
		{
			dim.append(pts[i],"<>","<>"); 
		}
		dim.setReadDirection(_Map.getVector3d("readDirection"));
		dim.setDeltaOnTop(_Map.getInt("DeltaOnTop"));
		dp.draw(dim);
		
	// draw guideline	
		dp.trueColor(red);
		dp.draw(PLine(ptJig, Line(ptLoc, vecDir).closestPointTo(ptJig)));
		
		dp.lineType("DASHED");
		Point3d ptsNew[]=_Map.getPoint3dArray("ptsNew");
		for (int i=0;i<ptsNew.length();i++) 
		{ 
 
			dp.draw(PLine(ptsNew[i], Line(ptLoc, vecDir).closestPointTo(ptsNew[i]))); 
		}//next i
		
		
		return;
	}
//endregion

//End Part #3 Jigs//endregion 


//region Properties
category = T("|Dimension|");
	String _strategies[] = { T("|X-Global|"), T("|Y-Global|")};
	String sStrategies[0]; sStrategies = _strategies;
	String sStrategyName=T("|Strategy|");	
	PropString sStrategy(nStringIndex++, sStrategies.sorted(), sStrategyName);	
	sStrategy.setDescription(T("|Defines the Strategy|"));
	sStrategy.setCategory(category);
	int nStrategy = _strategies.find(sStrategy);// 0 = X-Global,1 = Y-Global
	if (nStrategy<0){ sStrategy.set(_strategies.first()); setExecutionLoops(2); return;}


	// get stereotypes
	String sStereotypes[0];
//	if (mp.bIsValid())
//	{ 
//		MultiPageStyle mps(mp.style());
//		if (nStrategy == 0 || nStrategy == 1)
//			sStereotypes.append(mps.getListOfStereotypeOverrides());
//	}
//	sStereotypes=sStereotypes.sorted();
	sStereotypes.insertAt(0, sDefault);


	String sStereotypeName=T("|Stereotype|");	
	PropString sStereotype(nStringIndex++, sStereotypes, sStereotypeName);	
	sStereotype.setDescription(T("|Defines the Stereotype|"));
	sStereotype.setCategory(category);
	int nStereotype = sStereotypes.find(sStereotype);
	if (nStereotype<0 && sStereotypes.length()>0){ nStereotype=0;sStereotype.set(sStereotypes[0]);}

category = T("|Display|");
	String sDimStyleName=T("|DimStyle|");	
	PropString sDimStyle(nStringIndex++, _DimStyles.sorted(), sDimStyleName);	
	sDimStyle.setDescription(T("|Defines the Dimstyle|"));
	sDimStyle.setCategory(category);
	
	String sDisplayModeName=T("|Delta/Chain Mode|");
	String sSingleDisplayModes[] = { T("|parallel|"), T("|perpendicular|"), "---"};
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
	sDisplayMode.setDescription(T("|Defines the DisplayMode|"));
	sDisplayMode.setCategory(category);
	int nDisplayMode = sDisplayModes.find(sDisplayMode, 0);
	int nDeltaMode = nDeltaModes[nDisplayMode];
	int nChainMode = nPerpModes[nDisplayMode];	
	

	String sSequenceName=T("|Sequence|");
	PropInt nSequence(nIntIndex++, 0, sSequenceName);	
	nSequence.setDescription(T("|Defines the sequence how collisions with other dimlines and tags will be resolved.| ") + T("|-1 = Disabled, 0 = Automatic|"));
	nSequence.setCategory(category);

	String sMapRuleName=T("|MapRule|");	
	PropString sMapRule(nStringIndex++, "", sMapRuleName);	
	sMapRule.setDescription(T("|Defines the MapRule|"));
	sMapRule.setCategory(category);
	sMapRule.setReadOnly(true);


	
//End Properties//endregion 

//region bOnInsert
	if(_bOnInsert)
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
		
		
	// prompt for entities
		Entity ents[0];
		PrEntity ssE(T("|Select multipage|"), MultiPage());
		ssE.addAllowedClass(GenBeam());
		ssE.addAllowedClass(ChildPanel());
		if (ssE.go())
			ents.append(ssE.set());

		GenBeam gb;
		ChildPanel child;
		for (int i=0;i<ents.length();i++) 
		{ 
			MultiPage _mp = (MultiPage)ents[i]; 
			GenBeam _gb = (GenBeam)ents[i]; 
			ChildPanel _child = (ChildPanel)ents[i];
			if (_mp.bIsValid())
				mp = _mp;
			else if (_gb.bIsValid())
				gb = _gb;	
			else if (_child.bIsValid())
				child = _child;			
		}
		
		
	// default model view direction
		vecZMS = _ZU;

	// multipage insert
		if (mp.bIsValid())
		{ 
			_Pt0 = mp.coordSys().ptOrg();
			_Entity.append(mp);
			
			
			MultiPageView mpvs[] = mp.views();
			PlaneProfile ppViewports[0];
			for (int i=0;i<mpvs.length();i++) 
			{ 
				MultiPageView& mpv = mpvs[i];
				PlaneProfile pp(cs);
				pp.joinRing(mpv.plShape(), _kAdd);
				ppViewports.append(pp);	
			}

		// insert by view
			Map mapArgs;
			mapArgs.setEntity("entDefine", mp);
	
		// Prompt to pick a view
			String prompt = T("|Select view|");
			PrPoint ssP(prompt);	
		
			int nGoJig = -1;
			while (nGoJig != _kNone && nGoJig != _kOk)
			{
				nGoJig = ssP.goJig("Jig", mapArgs);
				//Jig: point picked
				if (nGoJig == _kOk)
				{
					Point3d pt = ssP.value();

					int nView = -1;
					double dDist = U(10e6);	
					for (int i = 0; i < ppViewports.length(); i++)
					{
						double d = Vector3d(pt - ppViewports[i].closestPointTo(pt)).length();
						if (d < dDist)
						{
							dDist = d;
							nView = i;
						}
					}		
					
					if (nView>-1)
					{ 
						mpv = mpvs[nView];
						ViewData vdata = mpv.viewData();//vdatas[nView];
						CoordSys ps2ms = mpv.modelToView();
						ps2ms.invert();
						vecZMS = _ZW;
						vecZMS.transformBy(ps2ms);vecZMS.normalize();		
					}					
					
				}
				// Jig: cancel
				else if (nGoJig == _kCancel)
				{
					break;
				}
			}			
		}

		else if (gb.bIsValid())
		{ 
			_GenBeam.append(gb);
			_Pt0 = gb.ptCen();
			_PtG.append(getPoint());
		}
		else if (child.bIsValid())
		{ 
			_Entity.append(child);
			_Pt0 = child.realBody().ptCen();
			_PtG.append(getPoint());
		}		
		_Map.setVector3d("vecZMS", vecZMS);
		
		return;
	}	
// end on insert	__________________//endregion




//region Standards

// validate reference
	if (!mp.bIsValid() && _GenBeam.length()<1 && !child.bIsValid())
	{
		reportMessage("\n" + scriptName() + ": " +T("|this tool requires a multipage or at least one genbeam in the selection set.| "));
		eraseInstance();
		return;	
	}	

	if (_bOnDbCreated)setExecutionLoops(2);
	if (nSequence > 0)_ThisInst.setSequenceNumber(nSequence);
	_ThisInst.setAllowGripAtPt0(false);
	
	
// instance based rule map
	Map mapRule; mapRule.setDxContent(sMapRule, true);
	Map mapTools = mapRule.getMap("Tool[]");
	String sRuleTypes[0];
	for (int i=0;i<mapTools.length();i++) // collect all specified tools
	{ 
		Map m = mapTools.getMap(i);
		String type = m.getString("type");
		String subType = m.getString("subtype");
		
		String sRuleType = type + "__" + subType;
		if (type.length()>0 && subType.length()>0 && sRuleTypes.findNoCase(sRuleType)<0)
			sRuleTypes.append(sRuleType);
	}//next i	
	
	
	
//End Standards//endregion 


//region Get properties and data from multipage
	vecXPS = vecX;
	vecYPS = vecY;
	if (nStrategy == 1)
	{
		vecXPS = vecY;
		vecYPS = -vecX;	
	}
	 //cs.vis();
	vecXMS = vecXPS;
	vecYMS = vecYPS;	
	_Pt0 = cs.ptOrg();
	Plane pnW(_Pt0, cs.vecZ());
	
	int bIsAssembly = showSet.length() > 1;

//End Get properties and data from multipage//endregion 	

	
//region The view and its transformation
// get closest view
//	
//	{ 
//		double dDist = U(10e6);	
//		for (int i = 0; i < ppViewports.length(); i++)
//		{
//			double d = Vector3d(ptNearView - ppViewports[i].closestPointTo(ptNearView)).length();
//			if (d < dDist)
//			{
//				dDist = d;
//				nView = i;
//			}
//		}			
//	}
	
	PlaneProfile ppView;
	CoordSys ms2ps, ps2ms;
	double scale = 1;
	if (nView>-1)
	{ 
		mpv = mpvs[nView];
		ViewData vdata = mpv.viewData();//vdatas[nView];
		scale = vdata.dScale();	

		ms2ps = mpv.modelToView();
		ps2ms = ms2ps;
		ps2ms.invert();	
		
		vecXMS.transformBy(ps2ms);vecXMS.normalize();
		vecYMS.transformBy(ps2ms);vecYMS.normalize();	

		ppView= ppViewports[nView];
		//ppView.vis(1);		
	}
	else if (mp.bIsValid() && nView<0)
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|View could not be detected.|"));
		eraseInstance();
		return;
		
	}
	else if (child.bIsValid())
	{ 
		ms2ps = child.sipToMeTransformation();
		ps2ms = ms2ps;
		ps2ms.invert();	
		
		vecXMS.transformBy(ps2ms);vecXMS.normalize();
		vecYMS.transformBy(ps2ms);vecYMS.normalize();		
	}
	for (int i=1;i<_PtG.length();i++) 
	{ 
		_PtG[i]+=vecZPS*vecZPS.dotProduct(_Pt0-_PtG[i]); 
		addRecalcTrigger(_kGripPointDrag, "_PtG"+i); 
	}//next i
	
	
	
	
//End Transformation of view//endregion 

//region Sequencing
	Entity entTags[0];
	entTags= Group().collectEntities(true, TslInst(), _kMySpace);
	for (int j=entTags.length()-1; j>=0 ; j--) 
	{ 
		TslInst t=(TslInst)entTags[j]; 
		if (!t.bIsValid())
		{ 
			entTags.removeAt(j); 
			continue;
		}
		Entity ents[] = t.entity();
		GenBeam gbs[] = t.genBeam();
		if (ents.find(mp) < 0)entTags.removeAt(j);
		else if (_GenBeam.length()>0 && gbs.find(_GenBeam.first()) < 0)entTags.removeAt(j);
		else if (child.bIsValid() && ents.find(child) < 0)entTags.removeAt(j);
	}//next j
	
//region Order tagging entities by sequence number
	PlaneProfile ppProtect(cs);
	
// order by sequence number
	TslInst tslSeqs[0];
	int nSequences[0];
	if (!_bOnGripPointDrag)
	{ 
		for (int i=0;i<entTags.length();i++) 
		{ 
			TslInst t = (TslInst)entTags[i];
			if (t.bIsValid() && t.sequenceNumber()>=0 && 
				t.subMapXKeys().find(sSubXKey) >-1)// sSubXKey qualifies tsls with protection area
				{
					Map m = t.subMapX(sSubXKey);
					if (m.hasInt("viewIndex") && nView!=m.getInt("viewIndex")) // ignore those being assigned to another view or other view side
					{ 
						continue;
					}
					tslSeqs.append(t);
					nSequences.append(t.sequenceNumber());
				}
		}	
	}
	for (int i=0;i<tslSeqs.length();i++) 
		for (int j=0;j<tslSeqs.length()-1;j++) 
			if (nSequences[j]>nSequences[j+1])
			{
				tslSeqs.swap(j, j + 1);
				nSequences.swap(j, j + 1);
			}
				
// set sequence number during relevant events
	if (nSequence==0 && !_bOnGripPointDrag)//(_bOnDbCreated || _kNameLastChangedProp==sSequenceName) && 
	{ 
		int nNext = 1;
		for (int i=0;i<nSequences.length();i++) 
			if (nSequences.find(nNext)>-1)
			{
				//reportMessage("\n" + _ThisInst.handle()+ ": "+ nNext + " found in " +nSequences);
				nNext++;
			}
		nSequence.set(nNext);
		if (bDebug)reportMessage("\n" + _ThisInst.handle() + " sequence number set to " + nSequence);
		setExecutionLoops(2);
		return;
	}

// add/remove dependency to any sequenced tsl with a lower sequence number
	int nThisIndex = tslSeqs.find(_ThisInst);
	//reportMessage("\n" + _ThisInst.handle() + " with sequence " + nSequence + " rank " + nThisIndex+ " depends on");
	for (int i=0;i<tslSeqs.length();i++) 
	{ 
		TslInst t = tslSeqs[i];
		int x = _Entity.find(t);
		if(i<nThisIndex)
		{ 
			_Entity.append(t);
			setDependencyOnEntity(t);
			//reportMessage("\n	" + t.handle() + " with seq " + t.sequenceNumber());
		}
		else if (x>-1)
			_Entity.removeAt(x);		 
	}//next i
	
//End Order tagging entities by sequence number//endregion 	


//region Protection area by sequence // HSB-8276 
	// collect protection areas of sequenced tagging tsl with a higher or equal sequence number
	
	for (int i=0;i<tslSeqs.length();i++) 
	{ 
		TslInst t = tslSeqs[i]; 
		if (!t.bIsValid() || t==_ThisInst) {continue;}// validate tsl
		String s = t.scriptName();
		int n = t.sequenceNumber();
		if (n<nSequence || (n==nSequence && t.handle()>_ThisInst.handle()))
		{ 
			Map m = t.subMapX(sSubXKey);
			PlaneProfile pp =m.getPlaneProfile("ppProtect");
			if (pp.area() < pow(dEps, 2)) { continue};
			
			if (ppProtect.area() < pow(dEps, 2))	ppProtect = pp;
			else ppProtect.unionWith(pp);
		}
	}//next i
//	if (ppProtect.area()>pow(dEps,2))
//		ppProtect.vis(bIsDark?4:1);		
//End Protection area by sequence//endregion 

//End Sequencing//endregion 

//region Extent protected range by ruleset dimlines
	if (mp.bIsValid())
	{ 
		PlaneProfile pps[] = mpv.dimCollisionAreas(false);
		for (int i=0;i<pps.length();i++) 
		{ 
			ppProtect.unionWith(pps[i]);
			//pps[i].vis(2);  
		}//next i
	}
//End Extent protected range by ruleset dimlines//endregion 

//region Display
	Display dp(-1);
	dp.dimStyle(sDimStyle, scale);
	dp.addHideDirection(vecX);	dp.addHideDirection(-vecX);
	dp.addHideDirection(vecY);	dp.addHideDirection(-vecY);
	double dTextHeight = dp.textHeightForStyle("O", sDimStyle)/scale;
	if (_PtG.length() < 1)
	{
		if (nView>0)
			_PtG.append(ppView.coordSys().ptOrg()-(vecXPS+vecYPS)*dTextHeight);	
		else
			_PtG.append(_Pt0 + vecYMS * dTextHeight);
	}
	
//End Display//endregion 

//region Collect items
	GenBeam genbeams[0];
	Body bodies[showSet.length()];
	for (int i = 0; i < showSet.length(); i++)
	{
		Entity ent = showSet[i];
		GenBeam gb = (GenBeam)ent;
		if (gb.bIsValid())
		{
			genbeams.append(gb);
			bodies[i] = gb.realBody();
		}
	}
//End Collect items//endregion 

//region Dimpoint Collections
	Line lnX(_PtG[0], vecXMS);
	PlaneProfile ppVisible(cs);
	Point3d ptXExtremes[0],ptYExtremes[0]; 
	Point3d ptsBC[0];

	AnalysedDrill drills[0];
	String sDrillFormats[0]; // to be in synch with drills, carries optional data formatting

//End Dimpoint Collections//endregion 


// Loop items
	int numRuleToolFound;
	for (int i=0;i<showSet.length();i++) 
	{ 
		Entity ent= showSet[i]; 
		Body bd;
		GenBeam gb = (GenBeam)ent;
		if (gb.bIsValid())
		{
			  int n = genbeams.find(gb);
			  if (n>-1)bd = bodies[n];
		}
		else
		{ 
			reportMessage("\n"+ent.typeDxfName() + T(" |not supported|"));		
			continue;
		}
		//vecXMS.vis(bd.ptCen(), 3);

	//Get extremes
		ptXExtremes.append(bd.extremeVertices(vecXMS));	
		ptYExtremes.append(bd.extremeVertices(vecYMS));		

	//region Get Tools //XX
		//Map mapRules = mapSetting.getMap("Rule[]");//mapStereotype
		AnalysedTool tools[]= gb.analysedTools();
		for (int j=0;j<mapTools.length();j++) 
		{ 
			Map m = mapTools.getMap(j); 
			String type = m.getString("Type");
			String subType= m.getString("SubType");
			
		//region BEAMCUTS
			if (type=="AnalysedBeamCut")
			{ 
				AnalysedBeamCut beamcuts[]=  AnalysedBeamCut().filterToolsOfToolType(tools,subType);
				for (int j=beamcuts.length()-1; j>=0 ; j--) 
				{ 
					numRuleToolFound++;// count tools found in the rules
					AnalysedBeamCut t = beamcuts[j];
					Point3d pts[] = lnX.orderPoints(t.genBeamQuaderIntersectPoints(),dEps);
					if (pts.length()>0)
					{
						ptsBC.append(pts.first());
						ptsBC.append(pts.last());						
					}

				}//next j				
			}
				
		//End BEAMCUTS//endregion 	
				
		//region DRILLS
			else if (type=="AnalysedDrill")
			{ 
				AnalysedDrill _drills[]=  AnalysedDrill().filterToolsOfToolType(tools,subType);
				
				for (int j=_drills.length()-1; j>=0 ; j--) 
				{
					numRuleToolFound++;// count tools found in the rules
					drills.append(_drills[j]);
					sDrillFormats.append(" R: @(Radius)");
				}//next j				
			}
				
		//End DRILLS//endregion 				
		}//next j
	//End Get Tools//endregion 

		if (mp.bIsValid() ||child.bIsValid())	bd.transformBy(ms2ps);
		
		PlaneProfile pp = bd.shadowProfile(pnW);
		pp.shrink(-dEps);
		ppVisible.unionWith(pp);
		bd.vis(6);
		 
	}//next i
	
//region The visible profile and offsets
	ppVisible.shrink(dEps);
	ppVisible.extentInDir(vecX).vis(2);
	Point3d ptLoc = _PtG[0];
	Vector3d vecSide = vecYPS;
	{ 
		PlaneProfile pp = ppVisible;
		pp.shrink(-dTextHeight);	pp.vis(3);
		if (ppProtect.area()<pow(dEps,2))
			ppProtect = pp;
		else
			pp = ppProtect;
		
		
		LineSeg seg = pp.extentInDir(vecXPS);
		if (vecSide.dotProduct(ptLoc - seg.ptMid()) < 0)
			vecSide*=-1;
		Point3d pts[] ={ seg.ptStart(), seg.ptEnd()};
		pts = Line(_Pt0, -vecSide).orderPoints(pts);
		if (pts.length() > 0)
		{
			ptLoc.transformBy(vecSide * vecSide.dotProduct(pts.first() - ptLoc));		
		}
	}
//End The visible profile and offsets//endregion 	
	
//region Purge instances which do not match with at least one tool.
	if ((sRuleTypes.length()>0 && numRuleToolFound<1))
	{ 
		reportMessage("\nnone of the RuleTypes " + sRuleTypes + " found");
		eraseInstance();
		return;	
	}
//End Purge instances which do not match with at least one tool.//endregion 




	
	vecSide.vis(ptLoc, numRuleToolFound>0?3:1);
// declare dimline	
	DimLine dl(ptLoc, vecXPS, vecYPS);
	Dim dim;
	{
		Point3d pts[0];
		dim = Dim(dl,  pts, "",  "", nDeltaMode, nChainMode); 
	}
	dim.setReadDirection(vecY - vecX);
	int bDeltaOnTop = vecSide.dotProduct(vecY)<0;
	dim.setDeltaOnTop(bDeltaOnTop);
	
	
// add dimpoints
	Point3d ptsDimAll[0];
	

// Extremes
	ptXExtremes = lnX.orderPoints(ptXExtremes);
	for (int i=0;i<ptXExtremes.length();i++) 
	{ 
		Point3d& pt = ptXExtremes[i];
		if (mp.bIsValid() || child.bIsValid())pt.transformBy(ms2ps);
		dim.append(pt,"<>",(i==0?" ":"<>")); 
		ptsDimAll.append(pt);
	}//next i	
	
// Beamcuts
	for (int i=0;i<ptsBC.length();i++) 
	{ 
		Point3d& pt = ptsBC[i];
		if (mp.bIsValid()|| child.bIsValid())pt.transformBy(ms2ps);
		dim.append(pt,"<>","<>"); 
		ptsDimAll.append(pt);
	}//next i	
	
// Drills
		for (int j=drills.length()-1; j>=0 ; j--) 
		{ 
			AnalysedDrill t = drills[j];
			String format = sDrillFormats[j];

			String textEnd = "<>";
			if (format.length()>0)
			{ 
				Map mapAdditionalVars;
				mapAdditionalVars.setDouble("Radius", t.dRadius());	
				textEnd += _ThisInst.formatObject(format, mapAdditionalVars);
			}

			
			//Body bd = t.cuttingBody();
			Point3d pt = t.ptStart();
			if (mp.bIsValid()|| child.bIsValid())pt.transformBy(ms2ps);
			dim.append(pt,"<>",textEnd); 
			
			//ptsDrill.append(t.ptStart());
			if (!t.bThrough())
			{
				pt = t.ptEndExtreme();
				if (mp.bIsValid()|| child.bIsValid())pt.transformBy(ms2ps);
				dim.append(pt,"<>","<>");
			}
		}//next j	
//	
//	
//	
//	
//	for (int i=0;i<ptsDrill.length();i++) 
//	{ 
//		Point3d& pt = ptsDrill[i];
//		if (mp.bIsValid())pt.transformBy(ms2ps);
//		
//		ptsDimAll.append(pt);
//	}//next i
	
	// Additional
	for (int i=1;i<_PtG.length();i++) 
	{ 
		dim.append(_PtG[i],"<>","<>");
		ptsDimAll.append(_PtG[i]);
	}//next i
	
	
	
// get potential overlapping
	{ 
		PLine plTextAreas[]= dim.getTextAreas(dp);	
		if (ptXExtremes.length()>0)
		{ 
			Point3d pt1 = ptXExtremes.first();
			pt1 += vecYPS * (vecYPS.dotProduct(ptLoc - pt1)-.5*dTextHeight);
			Point3d pt2 = ptXExtremes.last();
			pt2 += vecYPS * (vecYPS.dotProduct(ptLoc - pt2)+.5*dTextHeight);
			
			PLine pl; pl.createRectangle(LineSeg(pt1,pt2), vecX, vecY);	//pl.vis(3);
			plTextAreas.append(pl);
		}	

		PlaneProfile pp(cs);
		for (int i=0;i<plTextAreas.length();i++) 
			pp.joinRing(plTextAreas[i], _kAdd); 
		pp.shrink(-.25*dTextHeight);	
		PlaneProfile pp2 = pp;
		pp2.intersectWith(ppProtect.area()>pow(dEps,2)?ppProtect:ppVisible);
		LineSeg seg = pp2.extentInDir(vecSide);
	
		double d = abs(vecSide.dotProduct(seg.ptStart()-seg.ptEnd()));	
		if (d>dEps)
		{
			dim.transformBy(vecSide * (d+.5*dTextHeight));
			pp.transformBy(vecSide * (d+.5*dTextHeight));
			ptLoc+=(vecSide * (d+.5*dTextHeight));
		}
		ppProtect.unionWith(pp);
	}

	dp.draw(dim);




//region Trigger SetView
	if (mp.bIsValid())
	{ 
		String sTriggerSetView = T("|Set View|");
		addRecalcTrigger(_kContextRoot, sTriggerSetView );
		if (_bOnRecalc && _kExecuteKey==sTriggerSetView)
		{
			Point3d pt = getPoint();
			
			Vector3d vecView = vecZMS;

			int view = -1;
			double dist = U(10e6);	
			
			for (int i=0;i<ppViewports.length(); i++)
			{
				double d = Vector3d(pt - ppViewports[i].closestPointTo(pt)).length();
				if (d < dist)
				{
					dist = d;
					view = i;
				}
			}		
			
			if (view>-1)
			{ 
				mpv = mpvs[view];
				ViewData vdata = mpv.viewData();//vdatas[nView];
				CoordSys ps2ms = mpv.modelToView();
				ps2ms.invert();
				vecView = _ZW;
				vecView.transformBy(ps2ms);vecView.normalize();	
				_Map.setVector3d("vecZMS", vecView);
			}
		
			setExecutionLoops(2);
			return;
		}	
	}
	//endregion	
	
//region Trigger AddPoints
	Map mapDim;
	mapDim.setString("DimStyle", sDimStyle);	
	mapDim.setPoint3dArray("pts", ptsDimAll);
	mapDim.setVector3d("vecDir", vecXPS);
	mapDim.setVector3d("vecPerp", vecYPS);
	mapDim.setPoint3d("ptLoc", ptLoc);		
	mapDim.setInt("DeltaOnTop", bDeltaOnTop);	
	mapDim.setVector3d("readDirection", vecY-vecX);
	mapDim.setInt("DeltaMode", nDeltaMode);
	mapDim.setInt("ChainMode", nChainMode);
	_Map.setMap("DimProps", mapDim);
	String sTriggerAddPoints = T("|Add Points|");
	addRecalcTrigger(_kContextRoot, sTriggerAddPoints );
	if (_bOnRecalc && _kExecuteKey==sTriggerAddPoints)
	{	
		Point3d ptsNew[0];
		
	// Prompt to pick a dim point
		String prompt = T("|Pick point|");
		PrPoint ssP(prompt);	
		int nGoJig = -1;
		while (nGoJig != _kNone)
		{
			nGoJig = ssP.goJig("PointJig", mapDim);
			//Jig: point picked
			if (nGoJig == _kOk)
			{
				Point3d pt = ssP.value();
				Point3d pts[] = mapDim.getPoint3dArray("pts");
				pts.append(pt);
				ptsNew.append(pt);
				mapDim.setPoint3dArray("pts", pts);
				mapDim.setPoint3dArray("ptsNew", ptsNew);
			}
			// Jig: cancel
			else if (nGoJig == _kCancel)
			{
				ptsNew.setLength(0);
				break;
			}
		}
		
		for (int i=0;i<ptsNew.length();i++) 
		{ 
			_PtG.append(ptsNew[i]); 
			 
		}//next i
		
		
		setExecutionLoops(2);
		return;
	}
	
//Trigger DeleteAllCustomPoints
	if (_PtG.length()>1)
	{ 
		String sTriggerDeleteAllCustomPoints = T("|Delete all custom points|");
		addRecalcTrigger(_kContextRoot, sTriggerDeleteAllCustomPoints );
		if (_bOnRecalc && _kExecuteKey==sTriggerDeleteAllCustomPoints)
		{
			_PtG.setLength(1);		
			setExecutionLoops(2);
			return;
		}			
	}

	
//endregion	

//region Trigger AppendTool
	String sTriggerAppendTool = T("|Append Tool|");
	addRecalcTrigger(_kContextRoot, sTriggerAppendTool );
	if (_bOnRecalc && _kExecuteKey==sTriggerAppendTool)
	{
		Map mapArgs;
		mapArgs.setString("DimStyle", sDimStyle);
		
		CoordSys csView(_Pt0, vecXView, vecYView, vecZView);
		Plane pnView(_Pt0, vecZView);
		PlaneProfile ppTools[0];
		Body bdTools[0];
		String sTypes[0], sSubtypes[0], sTexts[0];		
		String sDatas[0];
		AnalysedTool tools[0];

		for (int i=0;i<genbeams.length();i++) 
		{ 
			AnalysedTool tools[] = genbeams[i].analysedTools();
			Body bdDef = genbeams[i].envelopeBody(false, true);
		//region CUTS
			AnalysedCut cuts[]=  AnalysedCut().filterToolsOfToolType(tools);
			for (int j=cuts.length()-1; j>=0 ; j--) 
			{ 
				AnalysedCut t = cuts[j];	
				PlaneProfile pp=bodies[i].extractContactFaceInPlane(Plane(t.ptOrg(), t.normal()),dEps);				
				if (pp.area()<pow(dEps,2)){continue;} // ignore redundant cuts
				if (mp.bIsValid()|| child.bIsValid())
					pp.transformBy(ms2ps);
				
				String text= T("|Type|: ") + t.toolType();
				text += T("\P|SubType|: ") + t.toolSubType();
				text += T("\P|Angle|: ") + String().formatUnit(t.dAngle(),_kAngle);
				text += T("\P|Bevel|: ") + String().formatUnit(t.dBevel(), _kAngle);				
				
				Map m;
				m.setPlaneProfile("ppTool", pp);
				m.setString("text",text);
				m.setString("type",t.toolType());
				m.setString("subType",t.toolSubType());
				
				mapArgs.appendMap("Tool", m);				
				
				ppTools.append(pp);
				sTypes.append(t.toolType());
				sSubtypes.append(t.toolSubType());
			}//next i				
		//End CUTS//endregion 
		
		//region BEAMCUTS
			AnalysedBeamCut beamcuts[]=  AnalysedBeamCut().filterToolsOfToolType(tools);
			for (int j=beamcuts.length()-1; j>=0 ; j--) 
			{ 
				AnalysedBeamCut t = beamcuts[j];
				Body bd = t.cuttingBody();
				if (mp.bIsValid()|| child.bIsValid())
					bd.transformBy(ms2ps);
				
				String text= T("|Type|: ") + t.toolType()+T("\P|SubType|: ") + t.toolSubType();					
				
				Map m;
				m.setBody("bdTool", bd);
				m.setString("text",text);
				m.setString("type",t.toolType());
				m.setString("subType",t.toolSubType());
				
				mapArgs.appendMap("Tool", m);				
				
				ppTools.append(bd.shadowProfile(pnView));
				sTypes.append(t.toolType());
				sSubtypes.append(t.toolSubType());
			}//next j				
		//End BEAMCUTS//endregion 
		
		//region HOUSES
			AnalysedHouse houses[]=  AnalysedHouse().filterToolsOfToolType(tools);
			for (int j=houses.length()-1; j>=0 ; j--) 
			{ 
				AnalysedHouse t = houses[j];
				Body bd = t.cuttingBody();
				if (mp.bIsValid()|| child.bIsValid())
					bd.transformBy(ms2ps);
				
				String text= T("|Type|: ") + t.toolType()+T("\P|SubType|: ") + t.toolSubType();					
				
				Map m;
				m.setBody("bdTool", bd);
				m.setString("text",text);
				m.setString("type",t.toolType());
				m.setString("subType",t.toolSubType());
				
				mapArgs.appendMap("Tool", m);				
				
				ppTools.append(bd.shadowProfile(pnView));
				sTypes.append(t.toolType());
				sSubtypes.append(t.toolSubType());
			}//next j				
		//End HOUSES//endregion 		
		
		//region SLOTS
			AnalysedSlot slots[]=  AnalysedSlot().filterToolsOfToolType(tools);
			for (int j=slots.length()-1; j>=0 ; j--) 
			{ 
				AnalysedSlot t = slots[j];
				Body bd = t.cuttingBody();			bd.intersectWith(bdDef);
				if (mp.bIsValid()|| child.bIsValid())
					bd.transformBy(ms2ps);
				
				String text= T("|Type|: ") + t.toolType()+T("\P|SubType|: ") + t.toolSubType();					
				
				Map m;
				m.setBody("bdTool", bd);
				m.setString("text",text);
				m.setString("type",t.toolType());
				m.setString("subType",t.toolSubType());
				
				mapArgs.appendMap("Tool", m);				
				
				ppTools.append(bd.shadowProfile(pnView));
				sTypes.append(t.toolType());
				sSubtypes.append(t.toolSubType());
			}//next j				
		//End SLOTS//endregion 		
		
		//region MORTISES
			AnalysedMortise mortises[]=  AnalysedMortise().filterToolsOfToolType(tools);
			for (int j=mortises.length()-1; j>=0 ; j--) 
			{ 
				AnalysedMortise t = mortises[j];
				Body bd = t.cuttingBody();
				if (mp.bIsValid()|| child.bIsValid())
					bd.transformBy(ms2ps);
				
				String text= T("|Type|: ") + t.toolType()+T("\P|SubType|: ") + t.toolSubType();					
				
				Map m;
				m.setBody("bdTool", bd);
				m.setString("text",text);
				m.setString("type",t.toolType());
				m.setString("subType",t.toolSubType());
				
				mapArgs.appendMap("Tool", m);				
				
				ppTools.append(bd.shadowProfile(pnView));
				sTypes.append(t.toolType());
				sSubtypes.append(t.toolSubType());
			}//next j				
		//End HOUSES//endregion 		
		
		//region DRILLS
			AnalysedDrill drills[]=  AnalysedDrill().filterToolsOfToolType(tools);
			for (int j=drills.length()-1; j>=0 ; j--) 
			{ 
				AnalysedDrill t = drills[j];
				Body bd(t.ptStartExtreme(), t.ptEndExtreme(), t.dRadius());
				if (mp.bIsValid()|| child.bIsValid())
					bd.transformBy(ms2ps);
				
				String text= T("|Type|: ") + t.toolType()+T("\P|SubType|: ") + t.toolSubType();				
				text += t.toolSubType() + T("\P|Radius|: ") + t.dRadius() + T("\P|Depth|: ") + t.dDepth();
				
				Map m;
				m.setBody("bdTool", bd);
				m.setString("text",text);
				m.setString("type",t.toolType());
				m.setString("subType",t.toolSubType());
				
				mapArgs.appendMap("Tool", m);				
				
				ppTools.append(bd.shadowProfile(pnView));
				sTypes.append(t.toolType());
				sSubtypes.append(t.toolSubType());
			}//next j					
		//End DRILLS//endregion 
		
		//region FREEPROFILES
			AnalysedFreeProfile fps[]=  AnalysedFreeProfile().filterToolsOfToolType(tools);
			for (int j=fps.length()-1; j>=0 ; j--) 
			{ 
				AnalysedFreeProfile t = fps[j];	
				PLine pl = t.plDefining();
				Body bd(pl, t.vecZ()*t.dDepth(),1);
				if (mp.bIsValid()|| child.bIsValid())
					bd.transformBy(ms2ps);
				
				String text= T("|Type|: ") + t.toolType()+T("\P|SubType|: ") + t.toolSubType();	
				
				Map m;
				m.setBody("bdTool", bd);
				m.setString("text",text);
				m.setString("type",t.toolType());
				m.setString("subType",t.toolSubType());
				
				mapArgs.appendMap("Tool", m);				
				
				ppTools.append(bd.shadowProfile(pnView));
				sTypes.append(t.toolType());
				sSubtypes.append(t.toolSubType());
			}//next j				
		//End FREEPROFILES//endregion 
		
		}//next i

	// select tool		
	// Prompt to pick a tool
		String prompt = T("|Select tool|");
		PrPoint ssP(prompt);	
		String type, subType;
		int nGoJig = -1;
		while (nGoJig != _kNone && nGoJig != _kOk)
		{
			nGoJig = ssP.goJig("ToolJig", mapArgs);
			//Jig: point picked
			if (nGoJig == _kOk)
			{
				Point3d pt = ssP.value();
				Line(pt, vecZView).hasIntersection(pnView, pt);
				
			// get closest tool
				int n = -1;
				double dDist = U(10e6);			
				for (int i = 0; i < ppTools.length(); i++)
				{
					double d = Vector3d(pt - ppTools[i].closestPointTo(pt)).length();
					if (d < dDist)
					{
						dDist = d;
						n = i;
					}
				}	
				
				if (n>-1)
				{ 
					type = sTypes[n];
					subType = sSubtypes[n];
				}
				
			}
			// Jig: cancel
			else if (nGoJig == _kCancel)
			{
				break;
			}
		}		

		
		if (type.length()>0)
		{ 
		// create TSL
			TslInst tslDialog;			Map mapTsl;
			GenBeam gbsTsl[] = { };		Entity entsTsl[] = { };			Point3d ptsTsl[] = { _Pt0};
			int nProps[] ={ };			double dProps[] ={ };			String sProps[] ={ };	
			
		// prepare dialog instance
			int nDialog = sToolTypes.find(type) + 1;
			if (nDialog<1)	{setExecutionLoops(2);		return;	}
			mapTsl.setInt("DialogMode", nDialog);
			
			//sProps.append(nStereotype<=0? type + "_"+subType:sStereotype);
			sProps.append(type);
			sProps.append(subType);

	
			tslDialog.dbCreate(scriptName() , _XW, _YW, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
			
			if (tslDialog.bIsValid())
			{
				int bOk = tslDialog.showDialog();
				
				if (bOk)
				{
					String type = tslDialog.propString(0);
					String subType = tslDialog.propString(1);
					
					String sRuleType = type + "__" + subType;
					if (type.length()<1 && subType.length()<1) // invalid
					{ 
						tslDialog.dbErase();
						setExecutionLoops(2);
						return;
					}	
					
				// rewrite tool map	
					Map mapTool;
					mapTool.setString("type",type);
					mapTool.setString("subtype",subType);
					mapTool.setMapName(sRuleType);

				// write rules
					Map mapNewTools;
					for (int i=0;i<mapTools.length();i++) 
					{ 
						Map m = mapTools.getMap(i); 
						String name = m.getMapName();
						if (name == sRuleType || name.length()<1){ continue;}
						mapNewTools.appendMap("Tool", m);
					}//next i
					mapNewTools.appendMap("Tool", mapTool);
					mapTools = mapNewTools;

					mapRule.setMap("Tool[]", mapTools);
					sMapRule.set(mapRule.getDxContent(true));
					
					
				}
				tslDialog.dbErase();
			}
		}

		setExecutionLoops(2);
		return;
	}//endregion	

//region Trigger RemoveTool
	if (sRuleTypes.length()>0)
	{ 
	//Trigger RenoveTool
		String sTriggerRenoveTool = T("|Renove Tool|");
		addRecalcTrigger(_kContextRoot, sTriggerRenoveTool );
		if (_bOnRecalc && _kExecuteKey==sTriggerRenoveTool)
		{

		// create TSL
			TslInst tslDialog;			Map mapTsl;
			GenBeam gbsTsl[] = { };		Entity entsTsl[] = { };			Point3d ptsTsl[] = { _Pt0};
			int nProps[] ={ };			double dProps[] ={ };			String sProps[] ={ };	
			
		// prepare dialog instance
			int nDialog = 100;
			if (nDialog<1)	{setExecutionLoops(2);		return;	}
			mapTsl.setInt("DialogMode", nDialog);
			mapTsl.setMap("Tool[]", mapTools);
	
			sProps.append(sRuleTypes[0]);
			tslDialog.dbCreate(scriptName() , _XW, _YW, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
			
			if (tslDialog.bIsValid())
			{
				int bOk = tslDialog.showDialog();
				
				if (bOk)
				{ 		
					String sRuleType = tslDialog.propString(0);
				// write rules
					Map mapNewTools;
					for (int i=0;i<mapTools.length();i++) 
					{ 
						Map m = mapTools.getMap(i); 
						String name = m.getMapName();
						if (name == sRuleType || name.length()<1){ continue;}
						mapNewTools.appendMap("Tool", m);
					}//next i
					mapTools = mapNewTools;

					mapRule.setMap("Tool[]", mapTools);
					sMapRule.set(mapRule.getDxContent(true));	
				}
				tslDialog.dbErase();

			}
	
			setExecutionLoops(2);
			return;
		}	
		
	}
//End RemoveTool//endregion 

// publish protection area
	{ 
		//ppProtect.vis(nSequence);
		Map mapX;
		mapX.setPlaneProfile("ppProtect", ppProtect);
		mapX.setInt("Priority", nSequence);
		mapX.setVector3d("vecSide", vecSide);
		mapX.setInt("viewIndex", nView);
		_ThisInst.setSubMapX(sSubXKey, mapX);
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
        <int nm="BreakPoint" vl="1258" />
        <int nm="BreakPoint" vl="1248" />
        <int nm="BreakPoint" vl="142" />
        <int nm="BreakPoint" vl="1044" />
        <int nm="BreakPoint" vl="1161" />
        <int nm="BreakPoint" vl="798" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11864 Cleanup added, view dependency modified" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="6/18/2021 3:06:28 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11864 map definition of type and subtypes added" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="6/14/2021 3:56:51 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11864 settings and multiple rules per stereotype supported, renamed" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="5/11/2021 4:34:44 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11856 dimensions of ruleset tsls are contributing for dim location" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="5/11/2021 8:52:09 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11742 updated using new multipageview class" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="5/7/2021 12:16:07 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11725 first draft of model based dimensioning (shopdrawings and model)" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="5/5/2021 1:58:40 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End