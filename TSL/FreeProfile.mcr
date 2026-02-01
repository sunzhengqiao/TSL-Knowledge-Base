#Version 8
#BeginDescription
This tsl creates a free profile tool based on a polyline, circle or grip definition

#Versions
Version 1.8 21.11.2025 HSB-24928: Capture error when freeprofile has no cuttingbody description; capture error when inserted without PLine definition , Author: Marsel Nakuci
Version 1.7 21.10.2025 HSB-24611 common range considers slice in depth or opposite face , Author Thorsten Huck

Version 1.6 06.10.2025 HSB-24567 radius cleanup of extrusion bodies fixed when polyline defined counter clockwise
Version 1.5 10.05.2024 HSB-21972: Fix when changing side by trigger 
Version 1.4 10.05.2024 HSB-22023 defining a polyline path and width > tool diameter exports as extrusion body
Version 1.3 01.06.2023 HSB-19098 overshoot on polyline path corrected
Version 1.2 23.05.2023 HSB-19028 additional property values exposed to submapX 'Freeprofile'
Version 1.1 19.04.2023 HSB-18473 added format variable 'Freeprofile Length', bugfix when inserting in extrusion mode
Version 1.0 05.10.2022 HSB-11699 initial version
Version 0.3 04.10.2022 HSB-11699 supports tool definition
Version 0.2 30.09.2022 HSB-11699 first beta version










#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 8
#KeyWords 
#BeginContents
//region Part #1

//region <History>
// #Versions
// 1.8 21.11.2025 HSB-24928: Capture error when freeprofile has no cuttingbody description; capture error when inserted without PLine definition , Author: Marsel Nakuci
// 1.7 21.10.2025 HSB-24611 common range considers slice in depth or opposite face , Author Thorsten Huck
// 1.6 06.10.2025 HSB-24567 radius cleanup of extrusion bodies fixed when polyline defined counter clockwise Thorsten Huck
// 1.5 10.05.2024 HSB-21972: Fix when changing side by trigger Author: Marsel Nakuci
// 1.4 10.05.2024 HSB-22023 defining a polyline path and width > tool diameter exports as extrusion body , Author Thorsten Huck
// 1.3 01.06.2023 HSB-19098 overshoot on polyline path corrected , Author Thorsten Huck
// 1.2 23.05.2023 HSB-19028 additional property values exposed to submapX 'Freeprofile' , Author Thorsten Huck
// 1.1 19.04.2023 HSB-18473 added format variable 'Freeprofile Length', bugfix when inserting in extrusion mode , Author Thorsten Huck
// 1.0 05.10.2022 HSB-11699 initial version , Author Thorsten Huck
// 0.3 04.10.2022 HSB-11699 supports tool definition , Author Thorsten Huck
// 0.2 30.09.2022 HSB-11699 first beta version , Author Thorsten Huck

/// <insert Lang=en>
/// Select genbeams and polyline
/// </inelect polert>

// <summary Lang=en>
// This tsl creates a free profile tool based on a polyline, circle or grip definition
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "FreeProfile")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT()drag (hsb_RecalcTslWithKey (_TM "|Flip Side|") (_TM "|Select Tool|"))) TSLCONTENT
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
	
// Color and view	
	int bIsDark;{int n = getBackgroundTrueColor();bIsDark = ((rgbR(n) + rgbB(n) + rgbG(n)) / 3 < 127);}
	int grey = bIsDark?rgb(199,200,202):rgb(99,100,102);
	int white = bIsDark?rgb(255,255,255):rgb(0,0,0);	
	
	int lightblue = rgb(204,204,255);
	int blue = rgb(69,84,185);
	int darkblue = rgb(26,50,137);	
	int yellow = rgb(241,235,31);
	int darkyellow = rgb(254, 204, 102);
	int darkyellow3D = bIsDark?rgb(157, 137, 88):rgb(254,234,185);
	int orange = rgb(242,103,34);
	int red = rgb(205,32,39);
	int purple = rgb(147,39,143);
	int petrol = rgb(16,86,137);
	int green = rgb(19,155,72);	

	Vector3d vecXView = getViewDirection(0);
	Vector3d vecYView = getViewDirection(1);
	Vector3d vecZView = getViewDirection(2);
	double dViewHeight = getViewHeight();	
	
	
	String tReferenceFace = T("|Bottom Face|");
	String tTopFace =  T("|Top Face|");	
	String kJigSelectFace = "SelectFace", kJigPickPath = "PickPath", kJigSelectOpening = "SelectOpening",
	tLeft=T("|Left|"),tCenter=T("|Center|"),tRight=T("|Right|");
	
	String tTMPolyline=T("|Polyline Path|"), tTMExtrusion=T("|Extrusion Body|"),
	tTMPolylineExtrusion=T("|Polyline Extrusion Body|"), tTMPolylineCombination=T("|Polyline Path Tool Combination|"), 
	tTMContour=T("|Contour|"), tTMOpening = T("|Opening|"),
	kTopColor = "TopColor",kRefColor = "RefColor", kTransparency = "Transparency", kDiameter = "Diameter", kLength = "Length", kCNCIndex = "CncIndex", kIsVertical = "isVertical", kAccuracy = "Accuracy";

	String tCCNone  = T("|None|"), tCCRound= T("|Rounded|"), tCCOvershoot = T("|Overshoot|");
	
//end Constants//endregion

//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sPathGeneral = _kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\";	
	String sFileName ="FreeProfile";
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

//region DialogMode
	int nDialogMode = _Map.getInt("DialogMode");
	if (nDialogMode>0)
	{ 
		if (nDialogMode == 1) // specify index when triggered to get different dialogs
		{
			setOPMKey("Tool");
			
		category = T("|Tool|");	
			String sDiameterName=T("|Diameter|");	
			PropDouble dDiameter(nDoubleIndex++, U(20), sDiameterName);	
			dDiameter.setDescription(T("|Defines the tool diameter|"));
			dDiameter.setCategory(category);
			
			String sLengthName=T("|Length|");	
			PropDouble dLength(nDoubleIndex++, U(0), sLengthName);	
			dLength.setDescription(T("|Defines the tool length|"));
			dLength.setCategory(category);
			
			String sToolIndexName=T("|ToolIndex|");	
			PropInt nToolIndex(nIntIndex++, 4, sToolIndexName);	
			nToolIndex.setDescription(T("|Defines the ToolIndex|"));
			nToolIndex.setCategory(category);
			
			String sNameName=T("|Name|");	
			PropString sName(nStringIndex++, "Millhead", sNameName);	
			sName.setDescription(T("|Defines the name of the tool|"));
			sName.setCategory(category);
			
			String sIsVerticalName=T("|Vertical Milling Head|");	
			PropString sIsVertical(nStringIndex++, sNoYes, sIsVerticalName,1);	
			sIsVertical.setDescription(T("|Defines if the tool is a vertical milling head.|"));
			sIsVertical.setCategory(category);

		category = T("|Arc Approximation|");		
			String sAccuracyName=T("|Accuracy|");	
			PropDouble dAccuracy(nDoubleIndex++, dEps, sAccuracyName);	
			dAccuracy.setDescription(T("|Defines the accuracy of arc to line segment approximation.|") + T("|Accuracy = 0 means no line approximation|"));
			dAccuracy.setCategory(category);
			
		category = T("|Display|");
			String sColorName=T("|Color Reference Side|");
			PropInt nColor(nIntIndex++, 40, sColorName);	
			nColor.setDescription(T("|Defines the Color|"));
			nColor.setCategory(category);

			String sColor2Name=T("|Color Top Side|");
			PropInt nColor2(nIntIndex++, 40, sColor2Name);	
			nColor2.setDescription(T("|Defines the Color|"));
			nColor2.setCategory(category);

			String sTransparencyName=T("|Transparency|");	
			PropInt nTransparency(nIntIndex++, 90, sTransparencyName);	
			nTransparency.setDescription(T("|Defines the transparency of the tool contour|"));
			nTransparency.setCategory(category);

		}
		else if (nDialogMode == 2)// Beamcut
		{
			setOPMKey("Edit Tool Combination");
			
			String sMinStraightName=T("|Min. Length|");	
			PropDouble dMinStraight(nDoubleIndex++, U(500), sMinStraightName);	
			dMinStraight.setDescription(T("|Defines the minmal length of a straight segment to be replaced as beamcut|"));
			dMinStraight.setCategory(category);
			
			String sOverlapName=T("|Overlap|");	
			PropDouble dOverlap(nDoubleIndex++, U(100), sOverlapName);	
			dOverlap.setDescription(T("|Defines the overlap of the remaining freeprofiles into the beamcut replacements.|"));
			dOverlap.setCategory(category);			
		}		
		return;		
	}
//End DialogMode//endregion	

//region Read Settings
	int bHasXmlSetting;
	String sToolNames[0];
	double dDiameters[0];
	double dLengths[0], dAccuracies[0];
	int nCncIndices[0];
	int bIsVerticals[0], nRefColors[0], nTopColors[0], nTransparencies[0];
	Map m,mapTools= mapSetting.getMap("Tool[]");
	{
		String k;
		Map m= mapSetting;//.getMap("SubNode[]");
	
		for (int i=0;i<mapTools.length();i++) 
		{ 
			Map m= mapTools.getMap(i);
			
			String name = m.getMapName();
			if (name.length()<1 || sToolNames.findNoCase(name,-1)>-1)
			{ 
				continue;
			}
			int index, isVertical, ncTop, ncRef, transparency, bOk=true;
			double diameter, length, accuracy;
			k=kDiameter;		if (m.hasDouble(k) && m.getDouble(k)>0)	diameter = m.getDouble(k);	else bOk = false;
			k=kLength;			if (m.hasDouble(k) && m.getDouble(k)>0)	length = m.getDouble(k);
			k=kCNCIndex;		if (m.hasInt(k))	index = m.getInt(k); 		else bOk = false;
			k=kIsVertical;		if (m.hasInt(k))	isVertical = m.getInt(k);
			
			k=kAccuracy;		if (m.hasDouble(k)) accuracy = m.getDouble(k);
			
			k=kTopColor;		if (m.hasInt(k))	ncTop = m.getInt(k);
			k=kRefColor;		if (m.hasInt(k))	ncRef = m.getInt(k);
			k=kTransparency;	if (m.hasInt(k))	transparency = m.getInt(k);
			
			if (bOk && nCncIndices.find(index)<0) // do not append the same cnc index twice
			{
				sToolNames.append(name);
				nCncIndices.append(index);
				dDiameters.append(diameter);
				dLengths.append(length);
				bIsVerticals.append(isVertical);
				dAccuracies.append(accuracy);
				nRefColors.append(ncRef);
				nTopColors.append(ncTop);
				nTransparencies.append(transparency);
				bHasXmlSetting = true;
			}	
		}//next i
	}


// append predefined tools values if not found in custom list
	String sUserInfo;
	if (!bHasXmlSetting)
	{ 
		sUserInfo = TN("|Use custom context commands to specify custom milling heads its properties.|");
	// default modes, not used as soon as settings or opmKey catalogs are found	
		String sDefaultModes[] = {T("|Finger Mill|"),T("|Universal Mill|"),T("|Vertical Finger Mill|")};

		PLine pl(_Pt0, _Pt0 + _XW * U(100));
		for (int i=0;i<sDefaultModes.length();i++) 
		{ 
			String name = sDefaultModes[i];
			if (sToolNames.findNoCase(name,-1)>-1) // tool found
			{ 
				continue;
			}
			
			FreeProfile fp(pl,_kLeft);
			fp.setCncMode(i);
			
			sToolNames.append(name);
			dDiameters.append(fp.millDiameter());
			nCncIndices.append(i);
			dLengths.append(0);// unknown
			bIsVerticals.append(i==1?false:true);
			
			nRefColors.append(3+i);
			nTopColors.append(6+i);
			nTransparencies.append(90);			
			
			dAccuracies.append(dEps);
		}//next i		
	}
	
// append instance tool definition if found
	if (_ThisInst.subMapXKeys().findNoCase("myConfig",-1)>-1)
	{ 
		Map m = _ThisInst.subMapX("myConfig");
		String name = m.getMapName();
		if (name.length()<1)name=m.getString("Name");
		if (name.length()>0 && sToolNames.findNoCase(name,-1)<0) // tool not found
		{ 

			sToolNames.append(name);
			dDiameters.append(m.getDouble(kDiameter));
			nCncIndices.append(m.getInt(kCNCIndex));
			dLengths.append(m.getDouble(kLength));
			bIsVerticals.append(m.getInt(kIsVertical));
			
			nRefColors.append(m.getInt(kRefColor));
			nTopColors.append(m.getInt(kTopColor));
			nTransparencies.append(m.getInt(kTransparency));		
			
			dAccuracies.append(m.getDouble(kAccuracy));
		}
	}
	
	
//End Read Settings//endregion 

//region References
	PLine plDefine;
	//GenBeam gbFemales[0];
	Point3d ptFace;
	Plane pnFace;
	Vector3d vecX, vecY,vecZ,vecFace;
	
	double dH;
	
	PlaneProfile ppRange;
	int bDrag = _bOnGripPointDrag && (_kExecuteKey.find("_PtG" ,0,false) >- 1 || _kExecuteKey == "_Pt0");
//endregion 

//region JIG
	int bJig;
	if (_bOnJig && _kExecuteKey== kJigSelectFace)
	{ 
		Point3d ptJig = _Map.getPoint3d("_PtJig"); //running point
		int bFront = ! _Map.hasInt("showFront") ? true : _Map.getInt("showFront");
		Map mapFaces = _Map.getMap("Face[]");
		PlaneProfile pps[0];
		
		double dDist = U(10e5);
		int index = - 1;
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
				Point3d pt = ptJig;
				Line(ptJig, vecZView).hasIntersection(Plane(ptOrg, vecZ), pt);//
				if (pp.pointInProfile(pt)==_kPointInProfile)
					index = pps.length();
				pps.append(pp);
			}
		}
		
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
				dp.trueColor(i == index?darkyellow:lightblue,0);	
				dp.draw(pp);
				dp.trueColor(i == index?darkyellow:lightblue,75);				
			}
			dp.draw(pp, _kDrawFilled);

//			PLine rings[] = pp.allRings(true, false);
//			for (int r=0;r<rings.length();r++) 
//			{ 
//				Body bd(rings[r], pp.coordSys().vecZ()*U(20),1);
//				dp.draw(bd);
//				 
//			}//next r
			
			
			
			
			
		}//next i

		return;		
	}	

	else if (_bOnJig && _kExecuteKey== kJigPickPath)
	{ 
		bJig = true;
		Point3d ptJig = _Map.getPoint3d("_PtJig"); 
	    ptFace = _Map.getPoint3d("ptFace");
	    vecX = _Map.getVector3d("vecX");
	    vecY = _Map.getVector3d("vecY");
	    vecZ = _Map.getVector3d("vecZ");
	    vecFace = _Map.getVector3d("vecFace");
	    Point3d pts[] = _Map.getPoint3dArray("pts");

	    setPropValuesFromMap(_Map.getMap("PropertyMap"));
	    
	    Entity ents[] = _Map.getEntityArray("GenBeam[]", "", "GenBeam");
	    for (int i=0;i<ents.length();i++) 
	    { 
	    	GenBeam gb = (GenBeam)ents[i];
	    	if (gb.bIsValid())
		    	_GenBeam.append(gb);	    	 
	    }//next i
    
	    ppRange=_Map.getPlaneProfile("range");

	    Display dp(0),dpText(0), dpRange(0);
	    dp.trueColor(darkyellow);
	    
	    pnFace=Plane(ptFace, vecFace);
	    Line(ptJig, vecZView).hasIntersection(pnFace, ptJig);
	    pts.append(ptJig);
	    pts = pnFace.projectPoints(pts);
    
	    PLine pl(vecFace);
	    for (int i=0;i<pts.length();i++) 
	    { 
	    	pl.addVertex(pts[i]); 
	    	 
	    }//next i
////	    if (pts.length()>1)
////	    	pl.close();
//	
//		dpRange.draw(ppRange, _kDrawFilled);
	    
	    dp.draw(pl);

		if (pl.length()<dEps)
			return;	
			
		plDefine=pl;
	}

	else if (_bOnJig && _kExecuteKey== kJigSelectOpening)
	{ 
		bJig = true;
		Point3d ptJig = _Map.getPoint3d("_PtJig"); 
	    ptFace = _Map.getPoint3d("ptFace");
	    vecX = _Map.getVector3d("vecX");
	    vecY = _Map.getVector3d("vecY");
	    vecZ = _Map.getVector3d("vecZ");
	    vecFace = _Map.getVector3d("vecFace");
	    Point3d pts[] = _Map.getPoint3dArray("pts");
		pnFace=Plane(ptFace, vecFace);

	    setPropValuesFromMap(_Map.getMap("PropertyMap"));

	    Entity ents[] = _Map.getEntityArray("GenBeam[]", "", "GenBeam");
	    for (int i=0;i<ents.length();i++) 
	    { 
	    	GenBeam gb = (GenBeam)ents[i];
	    	if (gb.bIsValid())
		    	_GenBeam.append(gb);    	 
	    }//next i

	    Map mapOpenings=_Map.getMap("mapOpenings");

	
		PLine plOpenings[0];
		for (int i=0;i<mapOpenings.length();i++) 
		{
			PLine plOpening = mapOpenings.getPLine(i);
			plOpening.projectPointsToPlane(pnFace, vecFace);
			plOpenings.append(plOpening); 
		}


	    Display dp(0),dpText(0), dpRange(0);
	    dp.trueColor(lightblue);
	    //dp.draw(ppRange, _kDrawFilled, 50);
	    
	    double dMin = U(10e6);
	    int n = -1; 
	    for (int i=0;i<plOpenings.length();i++) 
	    { 
	    	Point3d pt;
	    	pt.setToAverage(plOpenings[i].vertexPoints(true));
	    	double d = (pt - ptJig).length();
	    	if (d<dMin)
	    	{ 
	    		dMin = d;
	    		n = i;
	    	} 
	    }//next i
	   
	   
	    PLine pl(vecFace);
	    for (int i=0;i<plOpenings.length();i++)
	    { 
	    	PLine plOpening = plOpenings[i];	    	
	    	dp.trueColor(lightblue);
	    	if (i==n)
	    	{ 
	    		pl = plOpening;
	    		dp.trueColor(darkyellow);
	    		dp.draw(PlaneProfile(pl), _kDrawFilled, 50);
	    		_Pt0.setToAverage(pl.vertexPoints(true));
	    	}	
	    	else
	    		 dp.trueColor(lightblue);
	    	dp.draw(plOpening);
	    }
	    
		if (pl.length()<dEps)
			return;	
			
		plDefine=pl;
	}


//endregion 

// End Part #1	
//endregion 

//region Part #2

//region Properties

	String sToolModes[] ={tTMPolyline, tTMExtrusion,tTMContour, tTMOpening}; //, tTMPolylineCombination
	String sSortedModes[0];sSortedModes = sToolModes.sorted();
	String sToolModeName=T("|Mode|");	
	PropString sToolMode(nStringIndex++, sSortedModes, sToolModeName);	
	sToolMode.setDescription(T("|Defines the wether the tool will mill the contour or the entire tool path area.|") + 
	"\n" + tTMPolyline + T(": |the freeprofile will only mill along the specified path|") + 
	"\n" + tTMExtrusion + T(": |the area of the specified path will be milled completely|") + T(" |and the path will be automatically rounded if applicable|")+
	"\n" + tTMOpening + T(": |the contour of the tool is derived by the nearest opening shape in relation to the base point.|") + 
	"\n" + tTMContour + T(": |the contour of the tool is derived by the common contour of all referenced entities.|") + 
	//"\n" + tTMPolylineExtrusion + T(": |the area of the specified path will be milled completely|") + T(" |and the path will not be modified|")+ 
	//"\n" + tTMPolylineCombination + T(": |the freeprofile will only mill along the specified path|") + T(" |and straight segments extending the threshold will be excluded from the path and replaced by beamcuts|")+
	"\n" + tTMContour + T(": |the freeprofile will only mill along the specified path|") + T(" |and straight segments extending the threshold will be excluded from the path and replaced by beamcuts|") 
	);
	sToolMode.setCategory(category);
	
	String sCornerCleanups[] = { tCCNone, tCCRound, tCCOvershoot};
	String sCornerCleanupName=T("|Corner Cleanup|");	
	PropString sCornerCleanup(nStringIndex++, sCornerCleanups.sorted(), sCornerCleanupName);	
	sCornerCleanup.setDescription(T("|Defines the how the corners will be processed|"));
	sCornerCleanup.setCategory(category);

	String sFaceName=T("|Face|");	
	String sFaces[] ={ tReferenceFace, tTopFace };
	PropString sFace(nStringIndex++, sFaces, sFaceName);	
	sFace.setDescription(T("|Defines the Face|"));
	sFace.setCategory(category);

	String sAlignments[] = {tLeft, tCenter, tRight};
	String sAlignmentName=T("|Alignment|");	
	PropString sAlignment(nStringIndex++, sAlignments, sAlignmentName);	
	sAlignment.setDescription(T("|Defines the alignment of the tool seen in the direction of the defining polyline.|"));
	sAlignment.setCategory(category);

category = T("|Tool|");
	String sToolNameName=T("|Tool|");
	String sSortedToolNames[0];sSortedToolNames = sToolNames.sorted();
	PropString sToolName(nStringIndex++, sSortedToolNames, sToolNameName);
	sToolName.setDescription(T("|Defines the CNC Tool|")+sUserInfo);
	sToolName.setCategory(category);
	if (sToolNames.findNoCase(sToolName,-1)<0 && sToolNames.length()>0)
	{ 
		sToolName.set(sToolNames.first());
		reportMessage("\n" + scriptName() + ": " +T("|Tool definition not found, changed to| "+sToolName));
	}

	String sDepthName=T("|Depth|");	
	PropDouble dDepth(nDoubleIndex++, U(20), sDepthName);	
	dDepth.setDescription(T("|Defines the depth of the tool|") + T(", |0 = complete through|"));
	dDepth.setCategory(category);

	String sWidthName=T("|Width|");	
	PropDouble dPWidth(nDoubleIndex++, U(30), sWidthName);	
	dPWidth.setDescription(T("|Defines the width of the tool|")+ T(", |0 = byDiameter|") );
	dPWidth.setCategory(category);	
	
// DISPLAY
	Map mapAdd;
	// add tsl properties
	{ 
		mapAdd.setString(sToolModeName, sToolMode);
		mapAdd.setString(sFaceName, sFace);
		mapAdd.setString(sAlignmentName, sAlignment);
		mapAdd.setDouble("Freeprofile Width", dPWidth,_kLength);
		mapAdd.setDouble("Freeprofile Depth", dDepth, _kLength);
		mapAdd.setDouble("Freeprofile Length", U(1200), _kLength);
		mapAdd.setDouble("Radius", U(22), _kLength);
		mapAdd.setDouble("Freeprofile Area", U(1500), _kArea);
	}

category = T("|Display|");
	String sFormatName=T("|Format|");	
	PropString sFormat(nStringIndex++, "R@(Radius)", sFormatName);	
	sFormat.setDescription(T("|Defines the format of the description.|"));
	sFormat.setCategory(category);	
	{ 
//		Map mapAdd;
//		mapAdd.setDouble("Radius", U(22), _kLength);
		sFormat.setDefinesFormatting("Genbeam", mapAdd);
	}

	String sDimStyleName=T("|DimStyle|");	
	PropString sDimStyle(nStringIndex++, _DimStyles.sorted(), sDimStyleName);	
	sDimStyle.setDescription(T("|Defines the dimension style|"));
	sDimStyle.setCategory(category);

	String sTextHeightName=T("|Text Height|");	
	PropDouble dTextHeight(nDoubleIndex++, U(0), sTextHeightName);	
	dTextHeight.setDescription(T("|Defines the text height of a potential description|") + T("|0 = by default dimstyle|"));
	dTextHeight.setCategory(category);



//End Properties//endregion 

//region OnInsert #1 
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
	// silent/dialog
		if (_kExecuteKey.length()>0 && TslInst().getListOfCatalogNames(scriptName()).findNoCase(_kExecuteKey,-1)>-1)
			setPropValuesFromCatalog(_kExecuteKey);						
	// standard dialog	
		else	
			showDialog();

	//Collect main genbeams
		Entity ents[0];
		PrEntity ssE(T("|Select genbeams and polylines|"), GenBeam());
		ssE.addAllowedClass(EntPLine());
		ssE.addAllowedClass(EntCircle());
		if (ssE.go())
			ents.append(ssE.set());
		
		for (int i=0;i<ents.length();i++) 
		{ 
			GenBeam gb = (GenBeam)ents[i];
			EntPLine epl = (EntPLine)ents[i];
			EntCircle ecc= (EntCircle)ents[i];

			PLine pl;
			if (epl.bIsValid())
				pl = epl.getPLine();
			else if (ecc.bIsValid())
				pl = ecc.getPLine();	
			
			
			if (gb.bIsValid() && _GenBeam.find(gb)<0)
			{
				_GenBeam.append(gb);
			}
			else if (epl.bIsValid() && pl.length()>U(5))
				_Entity.append(epl);
			else if (ecc.bIsValid() && pl.length()>U(5))
				_Entity.append(ecc);				
				
		}
	}	
// End OnInsert #1	
//endregion 

//region Collect genbeams	
	GenBeam genbeams[0],gbRef;
	Quader qdrs[0];
	Point3d ptExtremes[0];
	for (int i=0;i<_GenBeam.length();i++) 
	{ 
		GenBeam gb = (GenBeam)_GenBeam[i]; 
		if (gb.bIsValid())
		{ 
			Vector3d vecXi = gb.vecX();
			Vector3d vecYi = gb.vecY();				
			Vector3d vecZi = gb.vecZ();
			Quader qdr(gb.ptCen(), vecXi, vecYi, vecZi, gb.solidLength(), gb.solidWidth(), gb.solidHeight(), 0, 0, 0);
			qdrs.append(qdr);

			ptExtremes.append(qdr.pointAt(-1, - 1 ,- 1));
			ptExtremes.append(qdr.pointAt(1,1 ,1));
			
			if (!gbRef.bIsValid())
			{
				gbRef = gb;
				vecX = gbRef.vecX();
				vecY = gbRef.vecY();
				vecZ = gbRef.vecZ();				
			}
			genbeams.append(gb);
		}	 
	}//next i
	if (genbeams.length()<1)
	{ 
		reportMessage("\n"+ scriptName() + T("|This tool requires at least one genbeam| ")+T("|Tool will be deleted.|"));
		eraseInstance();
		return;
	}
	

//endregion 

//region Collect EntPLines
	EcsMarker ecs;
	EntPLine epl;
	EntCircle ecc;
	for (int i=0;i<_Entity.length();i++) 
	{ 
		EntPLine _epl = (EntPLine)_Entity[i];
		EntCircle _ecc = (EntCircle)_Entity[i];
		if (_epl.bIsValid() && plDefine.length()<dEps)
		{
			epl = _epl;
			plDefine=epl.getPLine();
			setDependencyOnEntity(epl);
			epl.assignToGroups(gbRef, 'T');
		}
		else if (_ecc.bIsValid() && plDefine.length()<dEps)
		{
			ecc = _ecc;
			plDefine=ecc.getPLine();
			setDependencyOnEntity(ecc);
			ecc.assignToGroups(gbRef, 'T');
		}
		else if (_Entity[i].bIsKindOf(EcsMarker())) //TODO not supported yet
		{ 
			ecs = (EcsMarker)_Entity[i];
			setDependencyOnEntity(ecs);
			ecs.assignToGroups(gbRef, 'T');
		}
	}//next i
	
//endregion 
// End Part #2	
//endregion 

//region Part #3
//region Flags
	int nFace = sFace == tReferenceFace ?- 1 : 1;
	int bCleanUpNone = sCornerCleanup==tCCNone;
	int bCleanUpRound = sCornerCleanup== tCCRound;
	int bCleanUpOvershoot = sCornerCleanup==tCCOvershoot;
	if (ecc.bIsValid())// circle does not need any corner cleanup	
	{ 
		bCleanUpNone = true;
		sCornerCleanup.setReadOnly(_kHidden);
	}
	
	int nAlignment = sAlignments.find(sAlignment,1)-1; // -1 = left, 0 = center , 1 = right	
	int ncTop = 6; // default color
	int ncRef= 3; // default color
	int nt = 90; // default transparency	

	int bRefIsSip = gbRef.bIsKindOf(Sip());
	int bRefIsBeam = gbRef.bIsKindOf(Beam());	

// tool parameters	
	double dDiameter = U(22); // the tool diameter
	double dLength;
	int nCncMode=1;
	int bIsVertical = true;
	
	double dLineApproxAccuracy = dEps;
	
	int nToolName = sToolNames.find(sToolName, 0);
	if (nToolName>-1)
	{ 
		dLength = dLengths[nToolName];
		dDiameter = dDiameters[nToolName];
		nCncMode = nCncIndices[nToolName];
		bIsVertical = bIsVerticals[nToolName];
		dLineApproxAccuracy=dAccuracies[nToolName];	
		
		ncTop =nTopColors[nToolName];
		ncRef =nRefColors[nToolName];
		nt = nTransparencies[nToolName];
	}
	int nc= nFace==1?ncTop:ncRef; // default color

	if (!bIsVertical && (bCleanUpOvershoot || bCleanUpRound))
	{ 
		bCleanUpNone = true;
		bCleanUpOvershoot = false;
		bCleanUpRound = false;
		sCornerCleanup.set(tCCNone);
		reportMessage("\n" + scriptName() + ": " +T("|A non vertical tool does not support rounding or overshooting.|"));
	}
	int bIsSolidPathOnly = sToolMode==tTMPolyline || sToolMode==tTMPolylineCombination || sToolMode==tTMContour || sToolMode==tTMOpening;
	int bIsExtrusion = sToolMode==tTMExtrusion;
	int bIsContour=sToolMode==tTMContour;
	int bIsOpening=sToolMode==tTMOpening;
	
	double radius = .5 * dDiameter;
	mapAdd.setDouble("Radius", radius, _kLength);
	mapAdd.setDouble(kDiameter, dDiameter, _kLength);

	int bIsWide = dPWidth > dDiameter;
	double dWidth = dPWidth< dDiameter?dDiameter:dPWidth;	
	
	int bPathAsExtrusion;
	if (bIsSolidPathOnly && bIsWide)
	{ 
		//bIsSolidPathOnly = false;
		bPathAsExtrusion = true;
	}
	
	
	
// store current tool in subMapX to maintain it's behaviour if xml configuration changes
	if (!bJig && !bDrag)
	{ 
		Map mapThis;
		mapThis.setMapName(sToolName);
		mapThis.setString("Name", sToolName); // store the name as apparently setMapName is not stored with subMapX
		mapThis.setDouble(kDiameter, dDiameter);
		mapThis.setDouble(kAccuracy, dLineApproxAccuracy);
		mapThis.setInt(kCNCIndex, nCncMode);
		mapThis.setInt(kIsVertical, bIsVertical);
		mapThis.setInt(kTopColor, ncTop);
		mapThis.setInt(kRefColor, ncRef);		
		_ThisInst.setSubMapX("myConfig", mapThis);	
	}

//endregion 

//region OnInsert #2
	if(_bOnInsert)
	{
		Body bd = gbRef.envelopeBody(false, true);
		Quader qdr(gbRef.ptCen(), gbRef.vecX(), gbRef.vecY(), gbRef.vecZ(), gbRef.solidLength(), gbRef.solidWidth(), gbRef.solidHeight(), 0, 0, 0);
		
		Point3d grips[0];
	//region Face selection if view direction not orthogonal to one of the 4 faces of the ref genbeam
		if (bRefIsBeam)
		{ 
		// Get face of insertion
			int bIsOrthoView = gbRef.vecD(vecZView).isParallelTo(vecZView);	
			vecFace = bIsOrthoView?vecZView:gbRef.vecD(vecZView);
			
		// set face
			if (vecFace.isParallelTo(vecX))
			{
				reportMessage("\n"+ scriptName() + T("|Insertion in YZ-Plane not supported| ")+T("|Tool will be deleted.|"));
				eraseInstance();
				return;
			}		
	
			if (!bIsOrthoView)
			{
				int nFaceIndex = - 1;
				
			// default to pick a face on viewing side	
				int bFront = true; 
				if (bRefIsBeam && nFace == -1) // back faces if beam and bottom selected
					bFront = false;
				else if (bRefIsSip  && qdr.vecD(vecZView).dotProduct(vecZ)<0) // back faces
					bFront = false;
					
				Map mapArgs, mapFaces;
				mapArgs.setInt("_Highlight", in3dGraphicsMode()); 
				mapArgs.setInt("showFront", bFront);		
		
			// Set Faces and profiles
				Vector3d vecFaces[0];
				if (bRefIsBeam)
				{ 
					Vector3d vecs[] ={ gbRef.vecY(), gbRef.vecZ() , - gbRef.vecY(), - gbRef.vecZ()};
					vecFaces = vecs;
				}
				else // sip or sheet
				{ 
					Vector3d vecs[] ={ gbRef.vecZ() ,- gbRef.vecZ()};
					vecFaces = vecs;				
				}
							
				PlaneProfile ppFace,pps[0];//yz-y-z
				for (int i=0;i<vecFaces.length();i++) 
				{ 
					Vector3d vecFaceI = vecFaces[i];	
					Plane pn (gbRef.ptCen() + vecFaceI * .5 * gbRef.dD(vecFaceI), vecFaceI);
					PlaneProfile pp = bd.extractContactFaceInPlane(pn, U(1)); 
				
				// append secondary profiles	
					for (int j=1;j<genbeams.length();j++) 
					{ 
						Body bdj= genbeams[j].envelopeBody(true, true);
						PlaneProfile ppj = bdj.extractContactFaceInPlane(pn, U(1));
						//getSlice(pn);
						ppj.shrink(-dEps);
						pp.unionWith(ppj);
						 
					}//next j

					pps.append(pp);
					mapFaces.appendPlaneProfile("pp", pp);
					
					if (bIsOrthoView && vecFace.isCodirectionalTo(vecFaceI))
					{
						nFaceIndex = i;
						ppFace = pp;
						mapArgs.setInt("FaceIndex", nFaceIndex);
					}
					
				}//next i
				mapArgs.setMap("Face[]", mapFaces);				
				
			//region Face selection
				int nGoJig = -1;
				PrPoint ssP(T("|Select face|")+ T(" |[Flip side]|"));
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
			            	vecFace = gbRef.vecD(pps[index].coordSys().vecZ());	
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
			            eraseInstance(); // do not insert this instance
			            return; 
			        }
			    }			
				//End Face selection//endregion 		
				ssP.setSnapMode(false, 0); // turn on snaps	
		
			}
			// orthogonal view, set ref or top side
			else
			{ 
				vecFace*=nFace; 
			}
			
			dH = gbRef.dD(vecFace);
			
			ptExtremes = Line(_Pt0, vecFace).orderPoints(ptExtremes);
			if (ptExtremes.length()>0)
				ptFace = ptExtremes.last();
			else
				ptFace = gbRef.ptCen() + .5 * vecFace * dH;
			pnFace = Plane(ptFace, vecFace);
			
		//endregion 			
		}
		else
			vecFace = vecZ * nFace;

	
	// Tsl requisites
		TslInst tslNew;				Map mapTsl;
		int bForceModelSpace = true;	
		String sExecuteKey,sCatalogName = tLastInserted;
		String sEvent="OnDbCreated"; // "OnElementConstructed", "OnRecalc", "OnMapIO"...
		GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			
		Point3d ptsTsl[] = {gbRef.ptCen() + vecFace*.5*qdr.dD(vecFace)};
		mapTsl.setVector3d("vecFace", vecFace);
		gbsTsl = genbeams;

	//region Select Opening
		if (sToolMode==tTMOpening)	
		{ 		
			CoordSys csFace(ptFace, gbRef.vecX(), gbRef.vecX().crossProduct(-vecFace), vecFace);
			PLine plOpenings[0]; 
			for (int i=0;i<genbeams.length();i++) 
			{ 
				Sip sip = (Sip)genbeams[i];
				Sheet sheet= (Sheet)genbeams[i];

				if (sip.bIsValid())
					plOpenings.append(sip.plOpenings());
				else if (sheet.bIsValid())
					plOpenings.append(sheet.plOpenings());	
			}//next i
			
			Map mapOpenings;
			for (int i=0;i<plOpenings.length();i++) 
				mapOpenings.appendPLine("pl", plOpenings[i]); 
	
		    Map mapArgs;
		    mapArgs.setInt("_Highlight", in3dGraphicsMode()); 
		    mapArgs.setVector3d("vecX", vecX);
		    mapArgs.setVector3d("vecY", vecY);
		    mapArgs.setVector3d("vecZ", vecZ);
		    mapArgs.setVector3d("vecFace", vecFace);
		    mapArgs.setPoint3d("ptFace", ptFace);
			mapArgs.setMap("PropertyMap", mapWithPropValues());
	    	
	    	mapArgs.setEntityArray(genbeams, true,"GenBeam[]", "", "GenBeam");
	    	mapArgs.setMap("mapOpenings", mapOpenings);

		    int nGoJig = -1;
		    String prompt = T("|Pick point in opening [All/flipSide]|");
			PrPoint ssP(prompt);
			ssP.setSnapMode(true, 0); // turn off snaps	
		    while (nGoJig != _kNone && plOpenings.length()>0)
		    {
		        nGoJig = ssP.goJig(kJigSelectOpening, mapArgs); 
		        ptFace = gbRef.ptCen() + .5 * vecFace * dH;
		        pnFace = Plane(ptFace, vecFace);
		        if (nGoJig == _kOk)
		        {
		            Point3d pt = ssP.value(); //retrieve the selected point
				    Line(pt, vecFace).hasIntersection(pnFace, pt); 
				    double dMin = U(10e6);
				    int n = -1;
				    for (int i=0;i<plOpenings.length();i++) 
				    { 
				    	Point3d pti;
				    	pti.setToAverage(plOpenings[i].vertexPoints(true));
				    	double d = (pti - pt).length();
				    	if (d<dMin)
				    	{ 
				    		dMin = d;
				    		n = i;
				    	} 
				    }//next i					

					if (n>-1)
					{ 
						ptsTsl[0] = pt;
						mapOpenings.removeAt(n, true);
						plOpenings.removeAt(n);
						mapArgs.setMap("mapOpenings", mapOpenings);
						
						mapTsl.setVector3d("vecFace", vecFace);
						tslNew.dbCreate(scriptName() , vecX ,vecX.crossProduct(-vecFace),gbsTsl, entsTsl, ptsTsl, sCatalogName, bForceModelSpace, mapTsl, sExecuteKey, sEvent); 	

					}
				
		            //ssP=PrPoint (prompt, pt);
		        }
				else if (nGoJig == _kKeyWord)
				{
					int key = ssP.keywordIndex();
					if (key==0) // All
					{ 
						
					}
					else if (key==1) // Flip Side
					{ 
						sFace.set(sFace == tReferenceFace ? tTopFace : tReferenceFace);
						vecFace *= -1;
						ptFace = gbRef.ptCen() + .5 * vecFace * dH;
						mapArgs.setVector3d("vecFace", vecFace);
						mapArgs.setPoint3d("ptFace", ptFace);
						mapArgs.setMap("PropertyMap", mapWithPropValues());
						setCatalogFromPropValues(tLastInserted);
					}
					
				}
		        else if (nGoJig == _kCancel)
		        { 
		            eraseInstance(); // do not insert this instance
		            return; 
		        }
		    }
	    	
	    	eraseInstance();
	    	return;
		}
	//endregion 
	//region Contour Mode
		else if (sToolMode==tTMContour)	
		{ 
			tslNew.dbCreate(scriptName() , vecX ,vecX.crossProduct(-vecFace),gbsTsl, entsTsl, ptsTsl, sCatalogName, bForceModelSpace, mapTsl, sExecuteKey, sEvent); 	
		}
	//endregion 
	//region Pick Path if no polyline found but not in contour mode
		else if (plDefine.length()<dEps && sToolMode!=tTMContour)
		{ 
			CoordSys csFace(ptFace, gbRef.vecX(), gbRef.vecX().crossProduct(-vecFace), vecFace);
			ppRange=PlaneProfile(csFace);
			for (int i=0;i<genbeams.length();i++) 
			{ 
				Sip sip = (Sip)genbeams[i];
				Sheet sheet= (Sheet)genbeams[i];
				
				Body bd = genbeams[i].envelopeBody(true, true);
				PlaneProfile pp(csFace);
				pp = bd.extractContactFaceInPlane(pnFace, dEps);		
	
				PLine plOpenings[0];
				if (sip.bIsValid())plOpenings= sip.plOpenings();
				else if (sheet.bIsValid())plOpenings= sheet.plOpenings();	
				for (int j=0;j<plOpenings.length();j++) 
					pp.joinRing(plOpenings[j],_kSubtract); 

				pp.shrink(-dEps);
				ppRange.unionWith(pp); 
			}//next i
			ppRange.shrink(dEps);
			

			String prompt = T("|Pick point|");
			PrPoint ssP(prompt); // second argument will set _PtBase in map
		    Map mapArgs;
		    mapArgs.setInt("_Highlight", in3dGraphicsMode()); 
		    mapArgs.setVector3d("vecX", vecX);
		    mapArgs.setVector3d("vecY", vecY);
		    mapArgs.setVector3d("vecZ", vecZ);
		    mapArgs.setVector3d("vecFace", vecFace);
		    mapArgs.setPoint3d("ptFace", ptFace);
			mapArgs.setMap("PropertyMap", mapWithPropValues());
	    	
	    	mapArgs.setEntityArray(genbeams, true,"GenBeam[]", "", "GenBeam");
	    	
	    	mapArgs.setPlaneProfile("range", ppRange);

		    Point3d pts[0];
		    int nGoJig = -1;
		    prompt = T("|Pick point [Left/Center/Right/flipSide]|");
		    while (nGoJig != _kNone)
		    {
		        nGoJig = ssP.goJig(kJigPickPath, mapArgs); 
		        ptFace = gbRef.ptCen() + .5 * vecFace * dH;
		        pnFace = Plane(ptFace, vecFace);
		        if (nGoJig == _kOk)
		        {
		            Point3d pt = ssP.value(); //retrieve the selected point
		            grips.append(pt);
		            mapArgs.setPoint3dArray("pts", grips); 
		            
		            Line(grips.last(), vecFace).hasIntersection(pnFace, pt); 
		            ssP=PrPoint (prompt, pt);
		        }
		        else if (nGoJig == _kKeyWord)
		        { 
		        	int key = ssP.keywordIndex();
		            if (key == 0) sAlignment.set(tLeft);
		            else if (key == 1) sAlignment.set(tCenter);
		            else if (key == 2) sAlignment.set(tRight);
		            else if (key == 3) // flpo side
		            { 
		            	sFace.set(sFace == tReferenceFace ? tTopFace:tReferenceFace );
		            	vecFace *= -1;
		            	ptFace = gbRef.ptCen() + .5 * vecFace * dH;
		            	pnFace = Plane(ptFace, vecFace);
		            	
		            	for (int i=0;i<grips.length();i++) 
		            		Line(grips[i], vecFace).hasIntersection(pnFace, grips[i]); 
		            	mapArgs.setPoint3dArray("pts", grips);
						mapArgs.setVector3d("vecFace", vecFace);
						mapArgs.setPoint3d("ptFace", ptFace);
		            	
		            	if (grips.length()>0)
		            		ssP=PrPoint (prompt, grips.last());
		            }		                
		           // sDistributionMode.set(sDistributionModes[nDistributionMode]);
		            mapArgs.setMap("PropertyMap", mapWithPropValues());
		            setCatalogFromPropValues(tLastInserted);
		        }
		        else if (nGoJig == _kCancel)
		        { 
		            eraseInstance(); // do not insert this instance
		            return; 
		        }
		    }

		// create TSL
			ptsTsl.append(grips);	
			tslNew.dbCreate(scriptName() , vecX ,vecX.crossProduct(-vecFace),gbsTsl, entsTsl, ptsTsl, sCatalogName, bForceModelSpace, mapTsl, sExecuteKey, sEvent); 	

		}
	//endregion 
		
	//region Insert per defining polyline carrier entity
		Entity entsPL[0];;
		for (int i=0;i<_Entity.length();i++) 
		{ 
			entsTsl.setLength(0);
			EntPLine epl = (EntPLine)_Entity[i];
			EntCircle ecc = (EntCircle)_Entity[i];
			if (epl.bIsValid())
				entsTsl.append(epl);
			else if (ecc.bIsValid())
				entsTsl.append(ecc);
				
			tslNew.dbCreate(scriptName() , vecX ,vecX.crossProduct(-vecFace),gbsTsl, entsTsl, ptsTsl, sCatalogName, bForceModelSpace, mapTsl, sExecuteKey, sEvent); 	
		}//next i
		
	//endregion 

		eraseInstance();
		return;
	}
// End OnInsert #2	
//endregion 

//region Validation and Defaults
	if (!bJig)
	{ 
		setEraseAndCopyWithBeams(_kBeam0);		
	}

//region  Get Face
	vecFace = _Map.hasVector3d("vecFace")?_Map.getVector3d("vecFace"):vecZ;
	ptExtremes = Line(_Pt0, vecFace).orderPoints(ptExtremes);
	if (ptExtremes.length()>0)
		ptFace = ptExtremes.last();
	else
		ptFace = gbRef.ptCen() + .5 * vecFace * dH;
	pnFace = Plane(ptFace, vecFace);
	if (bDebug)vecFace.vis(ptFace, 4);
	_Pt0 += vecFace * vecFace.dotProduct(ptFace - _Pt0);
	CoordSys csFace(ptFace, vecX, vecX.crossProduct(-vecFace), vecFace);	

	double depth = dDepth;
	if (depth<=dEps && ptExtremes.length()>0)
	{
		depth =abs(vecFace.dotProduct(ptExtremes.last() - ptExtremes.first()));
	}


//endregion 

//region Get Common Profile
	PlaneProfile ppCommon(csFace);
	Body bodies[0];
	for (int i=0;i<genbeams.length();i++) 
	{ 
		GenBeam& gb = genbeams[i];
		Body bd = gb.envelopeBody(true, true);
		bodies.append(bd);
		
		Plane pni = qdrs[i].plFaceD(vecFace);
		PlaneProfile pp = bd.extractContactFaceInPlane(pni, dEps);	//pp.vis(4);
		//pp.project(pnFace, vecFace, dEps); // TODO openings seem to be projected wrongly
		pp.shrink(-dEps);	//pp.vis(2);
		ppCommon.unionWith(pp);
		
		// HSB-24611 append opposite face
		if (dDepth<=dEps)
			pp = bd.extractContactFaceInPlane(Plane(ptFace-vecFace*depth, qdrs[i].vecD(-vecFace)), dEps);		
				
		else
			pp = bd.getSlice(Plane(ptFace-vecFace*depth, qdrs[i].vecD(-vecFace)));	
			
		pp.shrink(-dEps);
		//if(bDebug){Display dpx(1); dpx.draw(pp, _kDrawFilled,20);}
		ppCommon.unionWith(pp);		
		
		
	}
	ppCommon.shrink(dEps);
	if (bDebug)ppCommon.vis(40);	
	
	PLine plEnvelopes[] = ppCommon.allRings(true, false);
	PLine plOpenings[] = ppCommon.allRings(false, true);
	
//endregion 

//Grip based
	if (_PtG.length()>1)
	{ 
	// restore grips from map if _Pt0 is moved
		Map mapGrips = _Map.getMap("Grip[]");
		if (_kNameLastChangedProp=="_Pt0" && mapGrips.length()>0)
		{ 
			for (int i=0;i<_PtG.length();i++) 
				if (mapGrips.hasVector3d("grip"+i))
					_PtG[i]= _PtW+mapGrips.getVector3d("grip"+i); 	
		}
		
	// Set defining polyline by grips	
		plDefine = PLine(vecFace);
		for (int i=0;i<_PtG.length();i++) 
		{ 
			_PtG[i].transformBy(vecFace*vecFace.dotProduct(ptFace-_PtG[i])); 
			plDefine.addVertex(_PtG[i]); 
			addRecalcTrigger(_kGripPointDrag, "_PtG"+i);
			mapGrips.setVector3d("grip" + i, _PtG[i] - _PtW);
		}//next i		
		_Map.setMap("Grip[]", mapGrips);
	}
// Circumference or Opening
	else if (sToolMode == tTMContour || sToolMode == tTMOpening)
	{
		sAlignment.setReadOnly(_kHidden);
		if (nFace == 1 && sAlignment!=tRight)
			sAlignment.set(tRight);
		else if (nFace == -1 && sAlignment!=tLeft)
			sAlignment.set(tLeft);
			
		double dMin = U(10e5);
		PLine plines[0];
		plines = sToolMode == tTMContour ? plEnvelopes : plOpenings;
		for (int i=0;i<plines.length();i++) 
		{ 
			PLine& pl=plines[i];
			if (i == 0)plDefine = pl; // get a default
			double d = (pl.closestPointTo(_Pt0) - _Pt0).length();
			if (d < dMin)
			{
				plDefine = pl;
				dMin = d;
			}
		}//next i
	}		
// Map based if no grips and no epl or entCircle found
	else if (plDefine.length()<dEps && _Map.hasPLine("plDefine"))
		plDefine = _Map.getPLine("plDefine");
	
	// purge potential grip vecs
	if (_PtG.length()<1 && _Map.hasMap("Grip[]"))
		_Map.removeAt("Grip[]", true);
	_Map.setPLine("plDefine", plDefine);// store as backup map in case epl or entCircle will be deleted	
	
// normal and default plTool	
	Vector3d vecNormal = plDefine.coordSys().vecZ();
	if (vecNormal.dotProduct(vecFace)<0)
	{ 
		vecNormal *= -1;
		plDefine.flipNormal();
		plDefine.reverse();
	}	
	CoordSys csNormal(ptFace, vecX, vecX.crossProduct(-vecNormal), vecNormal);
	Plane pnNormal(ptFace, vecNormal);		//vecNormal.vis(plDefine.ptStart(), 2);
	PLine plTool = plDefine;
	plTool.projectPointsToPlane(pnNormal, vecNormal);
	if(plTool.vertexPoints(true).length()<3)
	{ 
		// HSB-24928
		if(!_bOnJig)
		{
			reportMessage("\n" + scriptName() + ": " +T("|Defining PLine not accurately described|"));
		}
		eraseInstance();
		return;
	}
	int bIsClosed = Vector3d(plTool.ptStart()-plTool.ptEnd()).length() < dEps;



// Base Grip
	if (_bOnDbCreated)
	{ 
		if (bIsClosed)
			_Pt0.setToAverage(plTool.vertexPoints(true));
		else
			_Pt0 = plTool.ptStart();
	}
	//if (sFormat.length()>0)
	{
		_ThisInst.setAllowGripAtPt0(sFormat.length()>0 && dTextHeight>0);
		addRecalcTrigger(_kGripPointDrag, "_Pt0");
	}

// validate width in polyline path modes
	if (bIsSolidPathOnly && dPWidth>0 && !bIsWide && dPWidth<dDiameter && sToolMode!=tTMContour && sToolMode!=tTMOpening)
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|The width of a contour milling cannot be smaller then the tool diameter.|"));
//		dPWidth.set(dDiameter);
//		setExecutionLoops(2);
//		return;	
	}
	
//region On tool mode change
	int bIsContourOrOpening = sToolMode==tTMOpening || sToolMode==tTMContour ;
	if (_kNameLastChangedProp == sToolModeName )
	{ 
	// switch to opening	
		if (sToolMode==tTMOpening && plOpenings.length()<1)
		{ 
			reportMessage("\n" + scriptName() + ": " +T("|Could not find any opening.|"));
			sToolMode.set(_Map.getString("LastToolMode"));	
		}
		bIsContourOrOpening = sToolMode==tTMOpening || sToolMode==tTMContour ;
		
		if (bIsContourOrOpening)
		{ 
			if (_PtG.length() > 0)_PtG.setLength(0);
			_Pt0.setToAverage(plDefine.vertexPoints(true));
		}
		setExecutionLoops(2);
		return;
	}
	_Map.setString("LastToolMode", sToolMode);
	
	if (_kNameLastChangedProp == sToolModeName && bIsClosed)
	{ 
		_Pt0.setToAverage(plDefine.vertexPoints(true));	
	}
	
	
//endregion 

	
	


//endregion 

// End Part #3	
//endregion 

//region Extent defining polyline if on common edge

	PLine plDefiningPath = plTool;//HSB-18473


// Close contour if on extrusion mode
	if (!bIsClosed && bIsExtrusion)
	{ 
		plTool.close();
		bIsClosed = true;
		dPWidth.setReadOnly(_kReadOnly);
		if (bJig && plTool.area()<pow(dEps,2)){ return;}//HSB-18473
	}
// Extent defining polyline if on common edge	
	else if (!bIsClosed)
	{ 	
	// offset pline to receive round filled pline	
		double offset = bIsWide?(dWidth-dDiameter)*.5:0;
		//plTool.vis(255);
		if (nAlignment!=0)// left or right
		{ 	
			if (bIsWide)
			{
				plTool.offset(nFace*nAlignment*.5*(dWidth),false);	//plTool.vis(3);//
			}
			else
			{ 
				plTool.offset(nFace*nAlignment*radius,false);	//plTool.vis(3);
			}
			plDefiningPath = plTool;
		}
		//plTool.vis(3);		
		
	// extent if start or end is on common contour
		PLine pl = plTool;
		Point3d pts[] = { pl.ptStart(), pl.ptEnd()};
		for (int i=0;i<pts.length();i++) 
		{ 
			Point3d pt = pts[i];
			double d = (ppCommon.closestPointTo(pt) - pt).length();
			if (d<dEps)
			{ 
				Vector3d vec = pl.getTangentAtPoint(pt);
			// add at start	
				if (ppCommon.pointInProfile(pt+vec*dEps)==_kPointInProfile)
				{
					vec *= -1;
					plTool.reverse();
					plTool.addVertex(pt + vec * .5 * dDiameter);
					plTool.reverse();
				}
			// add at end	
				else
					plTool.addVertex(pt + vec * .5 * dDiameter);
				//vec.vis(pt, i);

			}		 
		}//next i			

	}	
	else if (bIsContourOrOpening)
	{ 
		double offset =  .5*dPWidth;
		if (dPWidth>dEps && dPWidth<dDiameter)
			offset -= .5*(dDiameter-dPWidth);
		offset *= nFace * nAlignment;
		plTool.offset(offset,false);
		if (bDebug)plTool.vis(1);
	}
	else if (bIsSolidPathOnly)
	{ 
		if (nAlignment!=0)// left or right
		{ 	
			double offset = nFace * nAlignment * radius;
			if (bPathAsExtrusion)offset = nFace * nAlignment * .5*dWidth;
			//if (sToolMode == tTMContour)offset *= -1;
			plTool.offset(offset,false);
			if (bDebug)plTool.vis(3);
			plDefiningPath = plTool;
		}
	}
	else if (bIsExtrusion)
	{ 
		plTool.offset(radius, false);
		plTool.offset(-radius, bCleanUpRound);
		
		if (bDebug)plTool.vis(2);
		dPWidth.setReadOnly(_kReadOnly);
		plDefiningPath = plTool;
		if (bJig && plTool.area()<pow(dEps,2)){ return;}//HSB-18473
	}
	
//	if (bDebug)
//	{ 
//		PLine pl = plDefiningPath;
//		pl.transformBy(vecZ * U(10));
//		pl.vis(1);
//	}	
	
//endregion 

//region Treat unclosed polyline path as extrusion if width > diameter
	if (bIsWide && !bIsClosed)
	{ 
		double offset = .5*dWidth-radius;
		PLine pl1 = plTool;
		PLine pl2 = plTool;
		
		pl1.offset(offset, false);
		pl2.offset(-offset, false);

		pl1.trim(radius, true);
		pl1.trim(radius, false);
		
		pl2.trim(radius, true);
		pl2.trim(radius, false);			

		pl2.reverse();		//pl1.vis(1);pl2.vis(3);	

		pl1.append(pl2);			
		pl1.close();
		pl1.offset(radius, bCleanUpRound);	
		bIsClosed = true;
		bIsExtrusion = true;
		bIsSolidPathOnly = false;
		
		plTool = pl1;
	}
//endregion 

//region Add Overshoot Cleanup
	if (bCleanUpOvershoot && bIsClosed)	
	{ 
		PLine pl1 = plTool;	
		pl1.simplify();
		PlaneProfile pp(csNormal);
		pp.joinRing(pl1, _kAdd);
		

		PLine pl(vecNormal);
		Point3d pts[] = pl1.vertexPoints(true);
		
	// HSB-24567 revert points if first segment y is pointing outwards / pline was defined counter clockwise
		if (pts.length()>2)
		{ 
			Point3d pt1 = pts[1];	
			Point3d pt0 = pts[0];
			Point3d ptX = (pt0+pt1)*.5; 
			Vector3d vecX0 = pt1 - pt0; vecX0.normalize();
			Vector3d vecY0 = vecX0.crossProduct(vecNormal);
			if (pp.pointInProfile(ptX+vecY0*dEps)!=_kPointInProfile)
			{ 
//				vecY0.vis(ptX, 1);
				pts.reverse();
			}
//			else
//			{
//				vecY0.vis(ptX, 3);
//			}
		}
		
		
		
		
		for (int i=0;i<pts.length();i++) 
		{ 
			int x1 = i == 0 ? pts.length() - 1 : i - 1;
			int x2 = i == pts.length() - 1 ? 0:i+1;
			Point3d pt1 = pts[x1];	
			Point3d ptX = pts[i]; 
			Point3d pt2 = pts[x2];

			if (ppCommon.pointInProfile(ptX)!=_kPointInProfile)
			{
				pl.addVertex(ptX);
				continue;
			}

			Vector3d vecX1 = ptX - pt1; vecX1.normalize();
			Vector3d vecX2 = ptX - pt2; vecX2.normalize(); 
			Vector3d vecXM = vecX1 + vecX2; vecXM.normalize();								//vecXM.vis(ptX, i);
			
			Vector3d vecY1 = vecX1.crossProduct(-vecNormal);								//vecY1.vis(ptX, i);vecX1.vis(ptX,1);
			Vector3d vecY2 = vecX2.crossProduct(vecNormal);									//vecY2.vis(ptX, i);vecX2.vis(ptX,2);
			
			double angle = vecX1.angleTo(vecXM);
			
			
			// accept only convex segments
			if (pp.pointInProfile(ptX+vecXM*dEps)!=_kPointInProfile)
			{ 
				Point3d ptCen = ptX - vecXM * radius;
				//ptCen.vis(i);
				
				PLine circle;circle.createCircle(ptX - vecXM * radius, vecNormal, radius);		//circle.vis(i+1);
				Point3d ptsX[] = pl1.intersectPLine(circle);
				ptsX = Line(ptX, vecXM.crossProduct(-vecNormal)).orderPoints(ptsX);
				
				
				if (angle-45<dEps && angle>0)//HSB-24567
				{ 
					Point3d ptsA1[0],ptA1, ptA2, ptmA;
					{ 
						ptsA1= circle.intersectPoints(Plane(ptCen, vecX1));
						ptsA1 = Line(ptX, -vecY1).orderPoints(ptsA1);
						if (ptsA1.length()>0)
						{ 
							Point3d ptm = (ptsA1.first() + ptX) * .5;
							ptsA1 = circle.intersectPoints(Plane(ptm, vecY1));
							ptsA1 = Line(ptX, vecX1).orderPoints(ptsA1);
						}
	
						if (ptsA1.length()>0)
						{ 
							ptA2 = ptsA1.first();
							Vector3d vec2 = ptA2- ptCen;
							ptmA = ptA2 + vec2;
							ptA1 = ptmA - vecY1 * radius;
							
							vec2.normalize();
							Vector3d vecAM = - vec2 - vecY1; vecAM.normalize();
							ptmA = ptmA + vecAM * radius;						//ptmA.vis(4);
							ptA1.vis(3);		ptA2.vis(4);				 vecAM.vis(ptmA,4);		
						}						
					}
					Point3d ptsB1[0],ptB1, ptB2, ptmB;
					{ 
						ptsB1= circle.intersectPoints(Plane(ptCen, vecX2));
						ptsB1 = Line(ptX, -vecY2).orderPoints(ptsB1);
						if (ptsB1.length()>0)
						{ 
							Point3d ptm = (ptsB1.first() + ptX) * .5;
							ptsB1 = circle.intersectPoints(Plane(ptm, vecY2));
							ptsB1 = Line(ptX, vecX2).orderPoints(ptsB1);
						}
						if (ptsB1.length()>0)
						{ 
							ptB2 = ptsB1.first();
							Vector3d vec2 = ptB2- ptCen;
							ptmB = ptB2 + vec2;
							ptB1 = ptmB - vecY2 * radius;
							
							vec2.normalize();
							Vector3d vecBM = - vec2 - vecY2; vecBM.normalize();
							ptmB = ptmB + vecBM * radius;					//ptmB.vis(4);
							ptB1.vis(3);		ptB2.vis(4);				 vecBM.vis(ptmB,4);		
						}						
					}
					//ptB1.vis();ptA1.vis();
				
				// test minimal width on sharp angles
					double d1 = (ptA1 - ptB1).length();
					double d2 = (ptmA - ptmB).length();
					if (d1<dDiameter || d2<dDiameter)
					{ 
						Vector3d vecYM = vecXM.crossProduct(-vecNormal);			//vecYM.vis(ptX, 3);
						if (vecYM.dotProduct(vecY1) > 0)vecYM *= -1;//HSB-19098
						ptsA1= pl1.intersectPoints(Plane(ptCen+vecYM*radius, vecYM));
						ptsA1 = Line(ptX, -vecX2).orderPoints(ptsA1);
						
						ptsB1= pl1.intersectPoints(Plane(ptCen-vecYM*radius, vecYM));
						ptsB1 = Line(ptX, -vecX1).orderPoints(ptsB1);	
						
						if (ptsA1.length()>0 && ptsB1.length()>0)
						{ 			
							Point3d ptNew;
							ptNew = ptsA1.first();				pl.addVertex(ptNew);		//ptNew.vis(1);
							ptNew = ptCen + vecYM * radius;		pl.addVertex(ptNew);		//ptNew.vis(2);							
							ptNew = ptCen - vecYM* radius;		pl.addVertex(ptNew,ptX);	//ptNew.vis(3);
							ptNew = ptsB1.first();				pl.addVertex(ptNew);		//ptNew.vis(4);
							
						}
						else
							pl.addVertex(ptX);
					}
					else if (ptsA1.length()>0 && ptsB1.length()>1)
					{ 
						pl.addVertex(ptA1);
						pl.addVertex(ptA2, ptmA);
						pl.addVertex(ptB2, ptX);
						pl.addVertex(ptB1, ptmB);
						
						ptB1.vis();ptA1.vis();
						
					}
					else
					{
						pl.addVertex(ptX);						
					}
				}
				else if (ptsX.length()>1)
				{ 
					ptsX.last().vis(2);
					pl.addVertex(ptsX.last());
					pl.addVertex(ptsX.first(),ptX);
					
				}					
				else
				{
					pl.addVertex(ptX);
				}
				
			}
			else
			{ 
				pl.addVertex(ptX);
			}
			//pl.vis(2);

		}
		pl.close();	
		
		//pl.vis(4);
		if (pl.area()>pl1.area())
		{ 
			pp=PlaneProfile(csNormal);
			pp.joinRing(pl, _kAdd);
			if (!bIsSolidPathOnly)//HSB-19098
				bCleanUpOvershoot = false;
		}
		
	// this should only have one ring
		//pp.vis(161);	

		PLine rings[] = pp.allRings(true, false);
		if (rings.length()>0 && !bIsSolidPathOnly)
		{ 
			if (bDebug){Display dp(2); dp.draw(pp, _kDrawFilled, 40);}
			
			plTool = rings.first();

			if (bIsWide && !bIsClosed)
			{ 
				bIsExtrusion = true;
				bIsSolidPathOnly = false;
				bIsClosed = true;				
			}
		}
		//else if (bDebug)	plTool.vis(30);	
	
	}
	else if (bIsExtrusion && !bCleanUpNone)
	{ 
		plTool.offset(-radius, false);	
		plTool.offset(radius, true);			if (bDebug)plTool.vis(2);	
	}
	
	if (bIsExtrusion)
	{
		sAlignment.setReadOnly(_kReadOnly);
	}
	
	
//endregion 

//region Loop defining tool plines
	PLine plTools[] ={ plTool}; //by default it is only one, unless ToolMode = tTMPolylineCombination
	PlaneProfile ppFreeprofile(csFace);//, ppOutline=ppBeamcutShape;
	for (int t=0;t<plTools.length();t++) 
	{ 
		plTool = plTools[t]; 
		if (plTool.length()<radius){ continue;}

		FreeProfile fp;

		if (bIsSolidPathOnly)
		{ 

		//region // Append overshoout drills (not for circles)
			if (bCleanUpOvershoot && depth>dEps && !bIsWide && !ecc.bIsValid())
			{ 
				if (bDebug)plTool.vis(2);
				Point3d pts[] = plTool.vertexPoints(true);

				for (int i=0;i<pts.length();i++) 
				{ 
					if (!bIsClosed && (i==0 || i == pts.length() - 1) )
					{ 
						continue;
					}
					
					
					int x1 = i == 0 ? pts.length() - 1 : i - 1;
					int x2 = i == pts.length() - 1 ? 0:i+1;
					Point3d pt1 = pts[x1];	
					Point3d ptX = pts[i]; 
					Point3d pt2 = pts[x2];		

					if (ppCommon.pointInProfile(ptX)!=_kPointInProfile){ continue;}

					Vector3d vecX1 = ptX - pt1; vecX1.normalize();
					Vector3d vecX2 = ptX - pt2; vecX2.normalize(); 
					Vector3d vecXM = vecX1 + vecX2; vecXM.normalize();					//vecXM.vis(ptX, 3);
					
					double alfa = vecX1.angleTo(vecXM);
					double c = radius / sin(alfa);
					Point3d ptCen = ptX + vecXM * (c-radius);
					Point3d ptCen2 = ptCen - vecNormal * depth;
					Drill dr(ptCen, ptCen2, radius);		
					if (!bJig || bDrag)dr.addMeToGenBeamsIntersect(genbeams);

					PLine circle;circle.createCircle(ptCen, vecFace, radius);
					circle.convertToLineApprox(dEps);
					
					//ptCen2.vis(2);
					if (vecFace.dotProduct(ptFace-ptCen2)>0)
					{
						if (bDebug)dr.cuttingBody().vis(72);
						ppFreeprofile.joinRing(circle, _kAdd);	
					}
					
				}//next i						

			}
		//endregion 
		
			//plTool.coordSys().vecZ().vis(plTool.ptStart(), 4);

			if (dLineApproxAccuracy>0)plTool.convertToLineApprox(dLineApproxAccuracy);
			fp=FreeProfile(plTool, 0);
			if (bPathAsExtrusion)
				fp.setSolidMillDiameter(dWidth);	
			//fp.cuttingBody().vis(211);		
		
		//region Build a display shape by corner cleanup mode
			if (!bIsClosed && !bCleanUpNone)
			{ 
				PLine pl1 = plTool;
				PLine pl2 = plTool;			//pl2.vis(2);
				pl1.trim(radius, bCleanUpRound);
				pl1.trim(radius, false);
				
				pl2.trim(radius, bCleanUpRound);
				pl2.trim(radius, false);
	
				pl1.offset(radius, true);
				pl2.offset(-radius, true);

//				pl1.offset(.5*dWidth, true);
//				pl2.offset(-.5*dWidth, true);

				pl2.reverse();
	
				pl1.addVertex(pl2.ptStart(), plTool.ptEnd());
				pl2.addVertex(pl1.ptStart(), plTool.ptStart());
				//pl1.vis(1);pl2.vis(3);			
				
				pl1.append(pl2);
				ppFreeprofile.joinRing(pl1, _kAdd);						
			}
		//endregion
		
		}
		else if (bIsExtrusion)
		{
			
			if (dLineApproxAccuracy>0)
				plTool.convertToLineApprox(dLineApproxAccuracy);
			fp=FreeProfile(plTool, plTool.vertexPoints(true));
			fp.setMachinePathOnly(false);
			
		}
		else
		{ 
			fp=FreeProfile(plTool, plTool.vertexPoints(true));
			//plTool.vis(3);
		}

		double dSolidDiameter =(dWidth > dDiameter && bIsSolidPathOnly)?dWidth: dDiameter;// HSB-7281
		if (bPathAsExtrusion)
		{
			fp.setSolidMillDiameter(dWidth);
			fp.setMachinePathOnly(false);
		}
		else
		{
			fp.setSolidMillDiameter(dSolidDiameter);
		}
		//fp.setSolidPathOnly(bIsSolidPathOnly);
		//fp.setSolidPathOnly(true);
		//fp.setMachinePathOnly(true);
		fp.setDepth(depth);
		fp.setCncMode(nCncMode);
		
		PLine plInternal=fp.plInternal();
		if(plInternal.area()<pow(U(1),2))
		{ 
			// HSB-24928
			if(!_bOnJig)
			{
				reportMessage("\n" + scriptName() + ": " +T("|Tooling not possible.|"));
			}
			return;
		}
		
		Body bdTool = fp.cuttingBody();	
		if (bDebug)bdTool.vis(t);
		if (!bJig)
			fp.addMeToGenBeams(genbeams);

	// get tool display from cuttingBody
		if (!bdTool.isNull() && (!bIsSolidPathOnly || (bIsSolidPathOnly && bIsClosed) || (bIsSolidPathOnly && bCleanUpNone)))
		{ 			
			if (!vecNormal.isCodirectionalTo(vecFace))
				ppFreeprofile.unionWith(bdTool.getSlice(pnFace));
			else
				ppFreeprofile.unionWith(bdTool.shadowProfile(pnFace));		
		}
	}
	
	// make sure intersect does not fail
	{ 
		PlaneProfile ppc(csFace);
		PlaneProfile pp = ppFreeprofile;
		if (sToolMode==tTMOpening)
			for (int i=0;i<plOpenings.length();i++) 
				pp.joinRing(plOpenings[i], _kSubtract); 		

		int bOk = pp.intersectWith(ppCommon);
		if (bOk && sToolMode!=tTMContour) // TODO something weired on the contour, doesn't resolve smetimes'
			ppFreeprofile = pp;
		
		//ppFreeprofile.vis(4);	
	}
	
	
//endregion 

//region Display
	if (!vecNormal.isCodirectionalTo(vecFace))
		ppFreeprofile.project(pnFace, vecNormal, dEps);
		
	Display dpModel(nc);
	dpModel.dimStyle(sDimStyle);
	double textHeight = dTextHeight;
	if (textHeight<=dEps)
		textHeight = dpModel.textHeightForStyle(sDimStyle, "O");
	dpModel.textHeight(textHeight);	
	if (bDrag || bJig)// || bDebug)
	{
		nt = 50;
		dpModel.trueColor(nFace==1?darkyellow:grey);
		
		PLine rings[] = ppFreeprofile.allRings(true, false);
		for (int i=0;i<rings.length();i++) 
		{ 
			Body bd (rings[i], vecFace*depth,-1);
			dpModel.draw(bd);
			 
		}//next i

		dpModel.draw(ppFreeprofile);
	}
	dpModel.draw(ppFreeprofile, _kDrawFilled, nt);
	dpModel.draw(ppFreeprofile);

// Formatting
	mapAdd.setDouble("Freeprofile Area", ppFreeprofile.area(), _kArea);
	mapAdd.setDouble("Freeprofile Length", plDefiningPath.length(), _kLength);//HSB-18473
	_ThisInst.setSubMapX("Freeprofile", mapAdd);
	
	sFormat.setDefinesFormatting(gbRef, mapAdd);	
	String sText = gbRef.formatObject(sFormat, mapAdd);
	dpModel.draw(sText, _Pt0, vecX, vecY, 0, 0, _kDevice);
	
	if (bJig)
		return;
	
//endregion 


// TriggerFlipSide
	String sTriggerFlipSide = T("|Flip Side|");
	addRecalcTrigger(_kContextRoot, sTriggerFlipSide );
	if (_bOnRecalc && (_kExecuteKey==sTriggerFlipSide || _kExecuteKey==sDoubleClick))
	{
		// HSB-21972
		vecFace *= -1;
		_Map.setVector3d("vecFace", vecFace);
		sFace.set(sFace == tReferenceFace ? tTopFace : tReferenceFace);
		if (sAlignment!=tCenter)// reversing defininig polyline HSB-19098
			sAlignment.set(sAlignment == tLeft ? tRight : tLeft);

		setExecutionLoops(2);
		return;
	}
	if (_kNameLastChangedProp==sFaceName) 
	{
		vecFace *= -1;
		_Map.setVector3d("vecFace", vecFace);
		
		if (sAlignment == tLeft)sAlignment.set(tRight); // reversing defininig polyline HSB-19098
		else if (sAlignment == tRight)sAlignment.set(tLeft);

		setExecutionLoops(2);
		return;
	}
	
//region Trigger AddGenBeams
	String sTriggerAddGenBeams = T("|Add GenBeams|");
	addRecalcTrigger(_kContextRoot, sTriggerAddGenBeams );
	if (_bOnRecalc && _kExecuteKey==sTriggerAddGenBeams)
	{
		Entity ents[0];
		PrEntity ssE(T("|Select genbeams|"), GenBeam());
		if (ssE.go())
			ents.append(ssE.set());	
			
		for (int i=0;i<ents.length();i++) 
		{ 
			GenBeam gb = (GenBeam)ents[i];
			if (gb.bIsValid() && _GenBeam.find(gb)<0)
				_GenBeam.append(gb);	
		}			
	
		setExecutionLoops(2);
		return;
	}//endregion
	
//region Trigger RemoveGenbeams
	String sTriggerRemoveGenbeams = T("|Remove Genbeams|");
	if (_GenBeam.length()>1)
		addRecalcTrigger(_kContextRoot, sTriggerRemoveGenbeams );
	if (_bOnRecalc && _kExecuteKey==sTriggerRemoveGenbeams)
	{
		Entity ents[0];
		PrEntity ssE(T("|Select genbeams|"), GenBeam());
		if (ssE.go())
			ents.append(ssE.set());	
			
		for (int i=0;i<ents.length();i++) 
		{ 
			GenBeam gb = (GenBeam)ents[i];
			int n = _GenBeam.find(gb);
			if (n>-1  && _GenBeam.length()>1)
				_GenBeam.removeAt(n);	
		}			
			
		setExecutionLoops(2);
		return;
	}//endregion	
	
	
//region Trigger SelectDefiningPLine
	String sTriggerSelectPLine= T("|Select defining polyline|");
	addRecalcTrigger(_kContextRoot, sTriggerSelectPLine );
	if (_bOnRecalc && _kExecuteKey==sTriggerSelectPLine)
	{
		Entity ents[0];
		PrEntity ssE(T("|Select polyline|"), EntPLine());
		ssE.addAllowedClass(EntCircle());
		if (ssE.go())
			ents.append(ssE.set());	
			
		for (int i=0;i<ents.length();i++) 
		{ 
			Entity& ent = ents[i];
			EntPLine epl= (EntPLine)ent;
			EntCircle ecc= (EntCircle)ent;
			PLine pl;
			if (epl.bIsValid())
				pl = epl.getPLine();
			else if (ecc.bIsValid())
				pl = ecc.getPLine();
				
			Point3d pts[] = pl.vertexPoints(true);	
			if (!pl.coordSys().vecZ().isParallelTo(vecX) && pts.length()>1)
			{ 
			// purge any ep or entcircle
				for (int j=_Entity.length()-1; j>=0 ; j--) 
					if (_Entity[j].bIsKindOf(EntPLine()) || _Entity[j].bIsKindOf(EntCircle()))
						_Entity.removeAt(j);
						
			// reset grips and append entity
				_PtG.setLength(0);
				_Entity.append(ent);
				
			// relocate _Pt0
				if ((pts.first()-pts.last()).length()<dEps ||ecc.bIsValid())
					_Pt0.setToAverage(pts);
				else
				{ 
					Vector3d vecXS = pts[1] - pts[0]; vecXS.normalize();
					Vector3d vecYS = vecXS.crossProduct(-vecFace);
					_Pt0 = pts.first() + vecXS * textHeight + vecYS * .5 * (textHeight + dWidth);
				}
				
				
				break;
			}
		}			
	
		setExecutionLoops(2);
		return;
	}//endregion	
	
//region Trigger CreateDefiningPLine
	String sTriggerCreateDefiningPLine = T("|Create defining polyline|");
	if ((_Map.hasPLine("plDefine") && !epl.bIsValid() && !ecc.bIsValid() ) || _PtG.length()>1)
		addRecalcTrigger(_kContextRoot, sTriggerCreateDefiningPLine );
	if (_bOnRecalc && _kExecuteKey==sTriggerCreateDefiningPLine)
	{
		epl.dbCreate(plDefine);
		epl.setColor(ncTop);
		epl.assignToGroups(gbRef, 'T');
		_Entity.setLength(0);
		_PtG.setLength(0);
		_Entity.append(epl);
		setExecutionLoops(2);
		return;
	}//endregion	

//region Trigger CreateGripPoints
	String sTriggerCreateGripPoints = T("|Create defining grips|");
	if (_PtG.length()<2)	
		addRecalcTrigger(_kContextRoot, sTriggerCreateGripPoints );
	if (_bOnRecalc && _kExecuteKey==sTriggerCreateGripPoints)
	{
		Point3d pts[] = plDefine.vertexPoints(bIsClosed?false:true);
		_PtG = pts;
		if (epl.bIsValid())
			epl.dbErase();
		if (ecc.bIsValid())
			ecc.dbErase();		
		setExecutionLoops(2);
		return;
	}//endregion	


//region Trigger
{
	// create TSL
	TslInst tslDialog;			Map mapTsl;
	GenBeam gbsTsl[] = { };		Entity entsTsl[] = { };			Point3d ptsTsl[] = { _Pt0};
	int nProps[] ={ };			double dProps[] ={ };			String sProps[] ={ };

	
//region Trigger ConfigureDisplay
	String sTriggerConfigureTool= T("|Configure Tool|");
	addRecalcTrigger(_kContext, sTriggerConfigureTool );
	if (_bOnRecalc && _kExecuteKey==sTriggerConfigureTool)
	{
		// prepare dialog instance
		mapTsl.setInt("DialogMode", 1);

		dProps.append(dDiameter);
		dProps.append(dLength);
		nProps.append(nCncMode);
		nProps.append(ncRef);
		nProps.append(ncTop);
		nProps.append(nt);
		sProps.append(sToolName);
		sProps.append(sNoYes[bIsVertical]);
		dProps.append(dLineApproxAccuracy);
	
		tslDialog.dbCreate(scriptName() , _XW, _YW, gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps, _kModelSpace, mapTsl);
		
		if (tslDialog.bIsValid())
		{
			int bOk = tslDialog.showDialog();
			if (bOk)
			{	
				String name = tslDialog.propString(0);
				if (name.length()<1)
				{ 
					reportMessage("\n" + scriptName() + ": " +T("|Invalid Tool Name|"));
					tslDialog.dbErase();
					setExecutionLoops(2);
					return;
				}
				int index = tslDialog.propInt(0);		
				// TODO validate if this index wasn't assigned to another tool

				Map mapTool;
				mapTool.setMapName(name);
				
				mapTool.setDouble(kDiameter, tslDialog.propDouble(0));
				mapTool.setDouble(kLength, tslDialog.propDouble(1));
				mapTool.setInt(kCNCIndex, index);
				mapTool.setInt(kIsVertical, sNoYes.findNoCase(tslDialog.propString(1),1));
				mapTool.setDouble(kAccuracy, tslDialog.propDouble(2));
				
				mapTool.setInt(kRefColor, tslDialog.propInt(1));
				mapTool.setInt(kTopColor, tslDialog.propInt(2));
				mapTool.setInt(kTransparency, tslDialog.propInt(3));

				Map mapTools = mapSetting.getMap("Tool[]");
				Map mapTemp;
				for (int i=0;i<mapTools.length();i++) 
				{ 
					Map m = mapTools.getMap(i);
					if (m.getMapName()!=name)
						mapTemp.appendMap("Tool",m); 	 
				}//next i
				mapTemp.appendMap("Tool",mapTool); 
				mapSetting.setMap("Tool[]",mapTemp);
				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);
				
				sToolName.set(name); // set current
			}
			tslDialog.dbErase();
		}
		setExecutionLoops(2);
		return;
	}//endregion	


//region Trigger ResetDefault
	String sTriggerResetDefault = T("|Reset Configuration|");
	if (bHasXmlSetting && mo.bIsValid())addRecalcTrigger(_kContext, sTriggerResetDefault );
	if (_bOnRecalc && _kExecuteKey==sTriggerResetDefault)
	{
		mo.dbErase();		
		setExecutionLoops(2);
		return;
	}//endregion	
	


//region Trigger ImportSettings
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
				reportMessage("\n" + scriptName() + ": " +T("|Settings successfully imported from| ")+ sFullPath);
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
					reportMessage("\n" + scriptName() + ": " +T("|Settings successfully exported to| ")+ sFullPath);
				else
					reportMessage("\n" + scriptName() + ": " +T("|Failed to write to| ")+ sFullPath);
			}
			
			setExecutionLoops(2);
			return;
		}
	}



}










#End
#BeginThumbnail
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
I#59T-PRC;3!A&8;1-IBP#,-H&_Y_BZ[!N3\W8WD`````245.1*Y"8((`





















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
        <int nm="BreakPoint" vl="1530" />
        <int nm="BreakPoint" vl="1940" />
        <int nm="BreakPoint" vl="1930" />
        <int nm="BreakPoint" vl="1983" />
        <int nm="BreakPoint" vl="1952" />
        <int nm="BreakPoint" vl="1515" />
        <int nm="BreakPoint" vl="1854" />
        <int nm="BreakPoint" vl="1969" />
        <int nm="BreakPoint" vl="1481" />
        <int nm="BreakPoint" vl="1689" />
        <int nm="BreakPoint" vl="1721" />
        <int nm="BreakPoint" vl="1687" />
        <int nm="BreakPoint" vl="1716" />
        <int nm="BreakPoint" vl="1608" />
        <int nm="BreakPoint" vl="1598" />
        <int nm="BreakPoint" vl="1732" />
        <int nm="BreakPoint" vl="1726" />
        <int nm="BreakPoint" vl="1634" />
        <int nm="BreakPoint" vl="1276" />
        <int nm="BreakPoint" vl="1891" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24928: Capture error when freeprofile has no cuttingbody description; capture error when inserted without PLine definition" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="11/21/2025 4:28:33 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24611 common range considers slice in depth or opposite face" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="10/21/2025 1:52:29 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24567 radius cleanup of extrusion bodies fixed when polyline definied counter clockwise" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="10/6/2025 11:54:30 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21972: Fix when changing side by trigger" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="5/10/2024 2:29:50 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22023 defining a polyline path and width &gt; tool diameter exports as extrusion body" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="5/10/2024 11:52:23 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19098 overshoot on polyline path corrected" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="6/1/2023 10:08:16 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-19028 additional property values exposed to submapX 'Freeprofile'" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="5/23/2023 6:05:28 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18473 added format variable 'Freeprofile Length', bugfix when inserting in extrusion mode" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="4/19/2023 11:00:39 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11699 initial version" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="10/5/2022 1:55:39 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11699 supports tool definition" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="10/4/2022 6:13:20 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11699 first beta version" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="9/30/2022 4:30:27 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End