#Version 8
#BeginDescription
#Versions
Version 0.20 10.01.2022 HSB-14081 bugfix group assignment
Version 0.19 14.12.2021 HSB-13615 auto grouping (see settings) supported
Version 0.18 14.12.2021 HSB-13615 bugfix when inserting with <Enter>, beamcuts consider angled edges
Version 0.17 08.12.2021 HSB-14094 solid representation enhanced
Version 0.16 15.11.2021 HSB-13615 bugfix non perpendicular joint boards
Version 0.15 15.11.2021 HSB-13615 beam creation and symbol added
Version 0.14 12.11.2021 HSB-13615 default orientation set for certain views
Version 0.13 12.11.2021 HSB-13615 new property to choose between gap and relief gap, distinction between stretching and rejoining during drag
Version 0.12 11.11.2021 HSB-13615 Arc detection improved
Version 0.11 10.11.2021 HSB-13615 split jig improved, redundant stretching suppressed, board graphices improved














#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 0
#MinorVersion 20
#KeyWords 
#BeginContents
//region Part #1 

//region <History>
// #Versions
// 0.20 10.01.2022 HSB-14081 bugfix group assignment , Author Thorsten Huck
// 0.19 14.12.2021 HSB-13615 auto grouping (see settings) supported , Author Thorsten Huck
// 0.18 14.12.2021 HSB-13615 bugfix when inserting with <Enter>, beamcuts consider angled edges , Author Thorsten Huck
// 0.17 08.12.2021 HSB-14094 solid representation enhanced , Author Thorsten Huck
// 0.16 15.11.2021 HSB-13615 bugfix non perpendicular joint boards , Author Thorsten Huck
// 0.15 15.11.2021 HSB-13615 beam creation and symbol added , Author Thorsten Huck
// 0.14 12.11.2021 HSB-13615 default orientation set for certain views , Author Thorsten Huck
// 0.13 12.11.2021 HSB-13615 new property to choose between gap and relief gap, distinction between stretching and rejoining during drag , Author Thorsten Huck
// 0.12 11.11.2021 HSB-13615 Arc detection improved , Author Thorsten Huck
// 0.11 10.11.2021 HSB-13615 split jig improved, redundant stretching suppressed, board graphices improved , Author Thorsten Huck

/// <insert Lang=en>
/// Select entities
/// </insert>

// <summary Lang=en>
// This tsl creates 
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "JointBoard")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|RecalcKey|") (_TM "|UserPrompt|"))) TSLCONTENT
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
	
//Color and view	
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
	
//end Constants//endregion

//region Jigs
	int bDrag = _bOnGripPointDrag && _kExecuteKey == "_Pt0";
	
	// Join Panels
	if ((_bOnJig && _kExecuteKey=="JoinPanel") ) 
	{
		Point3d ptFace = _Map.getPoint3d("ptFace");
	    Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point

	    Vector3d vecX = _Map.getVector3d("vecX");
	    Vector3d vecY = _Map.getVector3d("vecY");
	    Vector3d vecZ = _Map.getVector3d("vecZ");

	    double dWidth = _Map.getDouble("Width");
	    double dHeight= _Map.getDouble("Height");
	    double dGapWidth = _Map.getDouble("GapWidth");
	    double dGapHeight= _Map.getDouble("GapHeight");
		int nFace = _Map.getInt("Face");
		

	    int bOk=Line(ptJig, vecZView).hasIntersection(Plane(ptFace, vecZ.isPerpendicularTo(vecZView)?vecZView:vecZ), ptJig);
		//ptJig += vecZ * vecZ.dotProduct(ptFace - ptJig);

		CoordSys cs(ptFace, vecX, vecY, vecZ);
	    PlaneProfile ppShapes[0], ppViews[0], ppShape(cs);
	    Map mapShapes = _Map.getMap("Shape[]");
	    Map mapSegments = _Map.getMap("Segment[]");

	    Display dpA(-1), dpB(-1), dp(255), dpRed(1);
	    dpA.trueColor(darkyellow, 50);
	    dpB.trueColor(lightblue, 50);
	    dpRed.trueColor(red, 20);

	    for (int i=0;i<mapShapes.length();i++) 
	    {
	    	PlaneProfile pp(cs);
	    	pp.unionWith(mapShapes.getPlaneProfile(i));
	    	ppShapes.append(pp);
	    	pp.shrink(-dEps);
			ppShape.unionWith(pp);
	    }		
		ppShape.shrink(dEps);

		PlaneProfile ppBoards[0];
		

		for (int i=0;i<mapSegments.length();i++) 
		{ 
			Map m = mapSegments.getMap(i);
			Point3d pt1 = m.getPoint3d("pt1");
			Point3d pt2 = m.getPoint3d("pt2");
			
			Vector3d vecDir = pt2 - pt1; vecDir.normalize();
			Vector3d vecPerp= vecDir.crossProduct(-vecZ);
			
			PlaneProfile pp(cs);
			PlaneProfile ppRec;ppRec.createRectangle(LineSeg(pt1 -vecPerp *.5*dWidth, pt2 + vecPerp *.5*dWidth), vecDir, vecPerp);
			pp.unionWith(ppRec);
			
		// get common range
			pp.intersectWith(ppShape);
			pp.shrink(.5 * dWidth-dEps);
			pp.shrink(-.5 * dWidth+dEps);

			ppBoards.append(pp);
			
		}//next i			

		
	// draw boards
		int index = - 1;
		double dist = U(10e4);
		for (int i=0;i<ppBoards.length();i++) 
		{ 
			double d = Vector3d(ptJig-ppBoards[i].closestPointTo(ptJig)).length(); 
			if (d<dist)
			{ 
				dist = d;
				index = i;
			}
		}//next i
		
		for (int i=0;i<ppBoards.length();i++) 
		{ 
			PlaneProfile pp = ppBoards[i];
			if (i==index)
			{ 
				dpA.draw(pp, _kDrawFilled);				
			}
			else
			{ 
				dpB.draw(pp, _kDrawFilled);
			}	
			
			PLine rings[] = pp.allRings(true, false);
			for (int r=0;r<rings.length();r++) 
			{ 
				PLine& pl = rings[r];
				
				Point3d pts[] = pl.vertexPoints(false);
				for (int p=0;p<pts.length()-1;p++) 
				{ 
					Point3d pt1= pts[p];
					Point3d pt2= pts[p+1];
					Point3d ptm = (pt1 + pt2) * .5;
					Vector3d vecXS = pt2 - pt1; vecXS.normalize();
					PlaneProfile pp; 
					if (nFace==0)
						pp.createRectangle(LineSeg(pt1-.5*vecZ*dHeight, pt2+.5*vecZ*dHeight), vecXS, vecZ);				
					else
						pp.createRectangle(LineSeg(pt1, pt2+nFace*vecZ*dHeight), vecXS, vecZ);
					
					if (i==index)
						dpA.draw(pp,_kDrawFilled);
					else
						dpB.draw(pp,_kDrawFilled);
				}//next p
	
				Body bd(pl, vecZ * dHeight, nFace);
				//bdBoards.append(bd);
				dp.draw(bd);	
			}//next r	

		}


	    return;
	}

	// Split Panel
	if (_bOnJig && _kExecuteKey=="SplitPanel") 
	{ 
	    Point3d ptJig =_Map.getPoint3d("_PtJig"); // running point		

		Point3d ptFace = _Map.getPoint3d("ptFace");
		Point3d ptCen = _Map.getPoint3d("ptCen");
		Point3d pts[]= _Map.getPoint3dArray("pts");

	    Vector3d vecX = _Map.getVector3d("vecX");
	    Vector3d vecY = _Map.getVector3d("vecY");
	    Vector3d vecZ = _Map.getVector3d("vecZ");

		Vector3d vecDir = _Map.getVector3d("vecDir");
		vecDir = vecDir.bIsZeroLength() ? vecY : vecDir;
		Vector3d vecPerp = vecDir.crossProduct(-vecZ);

		double dH = _Map.getDouble("dH");
	    double dWidth = _Map.getDouble("Width");
	    double dHeight= _Map.getDouble("Height");
	    double dGapWidth = _Map.getDouble("GapWidth");
	    double dGapHeight= _Map.getDouble("GapHeight");
		int nFace = _Map.getInt("Face");

		CoordSys cs(ptFace, vecX, vecY, vecZ);
	    PlaneProfile ppShapes[0], ppViews[0], ppShape(cs);
	    Map mapShapes = _Map.getMap("Shape[]");


	    for (int i=0;i<mapShapes.length();i++) 
	    {
	    	PlaneProfile pp(cs);
	    	pp.unionWith(mapShapes.getPlaneProfile(i));
	    	ppShapes.append(pp);
	    	pp.shrink(-dEps);
			ppShape.unionWith(pp);
	    }		
		ppShape.shrink(dEps);
		
		int bIsSectional = vecZ.isPerpendicularTo(vecZView);
		int bOk=Line(ptJig, vecZView).hasIntersection(Plane(ptFace, bIsSectional?vecZView:vecZ), ptJig);
		if (bIsSectional)
			ptJig += vecZ * vecZ.dotProduct(ptFace - ptJig);
		
	    Point3d ptSplit=ptJig;
	    
	   	Plane pn(ptFace, vecZ);
	    PlaneProfile ppBoard;	    
	    if (pts.length()==1)
	    { 
	    	ptSplit = pts.first();
	    	Line(ptSplit, vecZ).hasIntersection(pn, ptSplit);
	    	
	    	if ((ptJig-ptSplit).length()<dEps)
	    		vecDir = vecX;
	    	else
	    	{
	    		vecDir = ptJig-ptSplit;
	    		vecDir.normalize();
	    	}
	    	vecPerp = vecDir.crossProduct(-vecZ);
	    	
	    	   	
	    }
	    ppBoard.createRectangle(LineSeg(ptSplit - vecDir * U(10e4)-vecPerp *.5*dWidth, 
	    		ptSplit + vecDir * U(10e4) + vecPerp *.5*dWidth), vecDir, vecPerp);	 
		ppBoard.intersectWith(ppShape);
		ppBoard.shrink(.5 * dWidth-dEps);
		ppBoard.shrink(-.5 * dWidth+dEps);
		
	    LineSeg segBoard = ppBoard.extentInDir(vecDir);
	    
	    
	    PlaneProfile ppX; ppX.createRectangle(LineSeg(ptSplit - vecDir * U(10e4), ptSplit + vecDir * U(10e4) + vecPerp * U(10e4)), vecDir, vecPerp);
	    
	    PlaneProfile ppA=ppShape;
	    ppA.subtractProfile(ppX);
	    ppA.subtractProfile(ppBoard);
	    
		PlaneProfile ppB = ppShape;
		ppB.subtractProfile(ppA);
		ppB.subtractProfile(ppBoard);

	    Display dpA(-1), dpB(-1), dp(255), dpRed(1);
	    dpA.trueColor(darkyellow, 80);
	    dpB.trueColor(lightblue, 80);
	    dpRed.trueColor(red, 20);
	    
//		dpA.draw(ppA, _kDrawFilled);
//	    dpB.draw(ppB, _kDrawFilled);
//	    dp.draw(ppA);
//	    dp.draw(ppB);
	    
	// draw board    
		dpA.draw(ppBoard,_kDrawFilled);	
		
	// 3D and draw sides of board
		Body bdBoards[0];
		PLine rings[] = ppBoard.allRings(true, false);
		for (int r=0;r<rings.length();r++) 
		{ 
			PLine& pl = rings[r];
			
			Point3d pts[] = pl.vertexPoints(false);
			for (int p=0;p<pts.length()-1;p++) 
			{ 
				Point3d pt1= pts[p];
				Point3d pt2= pts[p+1];
				Point3d ptm = (pt1 + pt2) * .5;
				Vector3d vecXS = pt2 - pt1; vecXS.normalize();
				PlaneProfile pp; 
				if (nFace==0)
					pp.createRectangle(LineSeg(pt1-.5*vecZ*dHeight, pt2+.5*vecZ*dHeight), vecXS, vecZ);				
				else
					pp.createRectangle(LineSeg(pt1, pt2+nFace*vecZ*dHeight), vecXS, vecZ);
				dpA.draw(pp,_kDrawFilled);
				
				 
			}//next p

			Body bd(pl, vecZ * dHeight, nFace);
			bdBoards.append(bd);
			dp.draw(bd);	
		}//next r

	// Draw split plane
		dpB.trueColor(lightblue, 30);
		rings = ppShape.allRings(true, false);
		for (int r=0;r<rings.length();r++) 
		{ 
			Body bd(rings[r], vecZ * dH, nFace);
			for (int i=0;i<bdBoards.length();i++) 
				bd.subPart(bdBoards[i]); 

			PlaneProfile ppSlice = bd.getSlice(Plane(ptSplit, vecPerp));
			dpB.draw(ppSlice,_kDrawFilled);
			dp.draw(ppSlice);
		}//next r

		return;
	}
//End bOnJig//endregion 

//region DialogMode
	int nDialogMode = _Map.getInt("DialogMode");
	if (nDialogMode>0)
	{ 
		if (nDialogMode == 1) // specify index when triggered to get different dialogs
		{
			setOPMKey("Settings");	
		
		category = T("|Joint Board|");
			String sCreateBeamName=T("|Create Beam|");	
			PropString sCreateBeam(nStringIndex++, sNoYes, sCreateBeamName);	
			sCreateBeam.setDescription(T("|Defines if the joint board shall be created as beam.|"));
			sCreateBeam.setCategory(category);
			
			String sDefaultGroupName=T("|Auto Group|");	
			PropString sDefaultGroup(nStringIndex++, T("|Joint Board|"), sDefaultGroupName);	
			sDefaultGroup.setDescription(T("|Specify a Group Name to group joint boards into a group. You can specify the full group path i.e. 'House\\Floor\\Jointboard' or any subgroup path i.e. 'Floor\\Jointboard' or 'Jointboard'|"));
			sDefaultGroup.setCategory(category);

		category = T("|Display|");
			String sDimStyleName=T("|Dimstyle|");	
			PropString sDimStyle(nStringIndex++, _DimStyles.sorted(), sDimStyleName);	
			sDimStyle.setDescription(T("|Defines the dimension style|"));
			sDimStyle.setCategory(category);
			
			String sTextHeightName=T("|Text Height|");	
			PropDouble dTextHeight(nDoubleIndex++, U(50), sTextHeightName,_kLength);	
			dTextHeight.setDescription(T("|Defines the text height|"));
			dTextHeight.setCategory(category);
			
			String sColorName=T("|Color|");	
			PropInt nColor(nIntIndex++, 31, sColorName);	
			nColor.setDescription(T("|Defines the color|"));
			nColor.setCategory(category);	
			
			String sTransparencyName=T("|Transparency|");	
			PropInt nTransparency(nIntIndex++, 80, sTransparencyName);	
			nTransparency.setDescription(T("|Defines the transparency of the symbol|"));
			nTransparency.setCategory(category);
		}		
		return;
	}
//End DialogMode//endregion

//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sPathGeneral = _kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\";	
	String sFileName ="hsbCLT-JointBoard";
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
	
// defaults	
	double dTextHeight = U(50);
	String sDimStyle = _DimStyles.first();
	int nc = 31, nt = 80;
	int bIsBeamMode = true; // by default the jointboard will be created as beam
	String sAutoGroup;

{
	String k;	Map m;
	
	m=mapSetting.getMap("Conversion");
	k="ConvertToBeam";		if (m.hasInt(k))	bIsBeamMode = m.getInt(k);
	k="GroupName";			if (m.hasString(k))	sAutoGroup = m.getString(k);
	
	m= mapSetting.getMap("Display");
	k="DimStyle";			if (m.hasString(k))	sDimStyle = m.getString(k);
	k="TextHeight";			if (m.hasDouble(k))	dTextHeight = m.getDouble(k);
	k="Color";				if (m.hasInt(k))	nc = m.getInt(k);	
	k="Transparency";		if (m.hasInt(k))	nt = m.getInt(k);	
	
}	
	
//End Settings//endregion	

//region Properties

category = T("|Geometry|");
	String sWidthName=T("|Width|");	
	PropDouble dWidth(0, U(100), sWidthName,_kLength);	
	dWidth.setDescription(T("|Defines the width of the joint board|"));
	dWidth.setCategory(category);
	
	String sHeightName=T("|Height|");	
	PropDouble dHeight(2, U(20), sHeightName,_kLength);	
	dHeight.setDescription(T("|Defines the heiht of the joint board|"));
	dHeight.setCategory(category);
	
	String sAlignmentName=T("|Alignment|");	
	String sAlignments[] = {T("|Reference Side|"), T("|Center|"), T("|Opposite Side|"), T("|Higher Quality|"),T("|Lower Quality|") };
	PropString sAlignment(0, sAlignments, sAlignmentName);	
	sAlignment.setDescription(T("|Defines the Alignment|"));
	sAlignment.setCategory(category);	

category = T("|Gap|");
	String sGapTypeName=T("|Type|");	
	String sGapTypes[] = { T("|Cut|"), T("|Relief Cut|")};
	PropString sGapType(3, sGapTypes, sGapTypeName);	
	sGapType.setDescription(T("|Defines if the gap between male and female paneles is defined as perpendicular or relief cut.|") + T("|This property can only be changed if the gap value = 0|"));
	sGapType.setCategory(category);

	String sGapName=T("|Gap|");	
	PropDouble dGap(6, U(0), sGapName,_kLength);	
	dGap.setDescription(T("|Defines the gap between male and female panels|"));
	dGap.setCategory(category);

category = T("|Tolerances|");
	String sGapWidthName=T("|Gap Width|");	
	PropDouble dGapWidth(1, U(0), sGapWidthName,_kLength);	
	dGapWidth.setDescription(T("|Defines the tolerance in width|"));
	dGapWidth.setCategory(category);
	
	String sGapHeightName=T("|Gap Height|");	
	PropDouble dGapHeight(3, U(0), sGapHeightName,_kLength);	
	dGapHeight.setDescription(T("|Defines the tolerance in depth|"));
	dGapHeight.setCategory(category);

	String sGapLengthName=T("|Gap Length|");	
	PropDouble dGapLength(7, U(0), sGapLengthName,_kLength);	
	dGapLength.setDescription(T("|Defines the tolerance in length|"));
	dGapLength.setCategory(category);
//
category = T("|Chamfer|");
	String sChamferRefName=sAlignments[0]; // reference side	
	PropDouble dChamferRef(4, U(0), sChamferRefName);	
	dChamferRef.setDescription(T("|Defines the chamfer on the reference side|"));
	dChamferRef.setCategory(category);
	
	String sChamferOppName=sAlignments[2]; // opposite side		
	PropDouble dChamferOpp(5, U(0), sChamferOppName);	
	dChamferOpp.setDescription(T("|Defines the chamfer on the opposite side|"));
	dChamferOpp.setCategory(category);
	
category = T("|General|");
	String sMaterialName=T("|Material|");	
	PropString sMaterial(1, T("|Spruce|"), sMaterialName);	
	sMaterial.setDescription(T("|Defines the material of the joint board|"));
	sMaterial.setCategory(category);
	
	String sGradeName=T("|Grade|");	
	PropString sGrade(2, "", sGradeName);	
	sGrade.setDescription(T("|Defines the grade of the joint board|"));
	sGrade.setCategory(category);	
		
//End Properties//endregion 

//region bOnInsert #1
	Sip sips[0];sips = _Sip;
	
	if (_bOnInsert)
	{
		if (insertCycleCount() > 1) { eraseInstance(); return; }
		
		// silent/dialog
		if (_kExecuteKey.length() > 0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
			if (sEntries.findNoCase(_kExecuteKey ,- 1) >- 1)
				setPropValuesFromCatalog(_kExecuteKey);
			else
				setPropValuesFromCatalog(sLastInserted);
		}
		// standard dialog	
		else
			showDialog();
		
		if (dWidth <=dEps || dHeight<=dEps)
		{ 
			reportMessage("\n"+ scriptName() + T("|Width and Height of joint board must be > 0| ")+T("|Tool will be deleted.|"));
			eraseInstance();
			return;	
		}
		

		// prompt for sips
		Entity ents[0];
		PrEntity ssE(T("|Select panels|"), Sip());
		if (ssE.go())
			ents.append(ssE.set());
		
		Vector3d vecZ;
		for (int i = 0; i < ents.length(); i++)
		{
			Sip sip = (Sip)ents[i];
			
			if (!sip.bIsValid())continue;
			
			if (vecZ.bIsZeroLength()) vecZ = sip.vecZ();
			else if (!vecZ.isParallelTo(sip.vecZ())){ continue;}
			
			sips.append(sip);
		}//next i

	}
//bOnInsert #1//endregion 

//Part #1 //endregion

//region Part #2 


//region Main sip ref
	if (sips.length() < 1)
	{
		reportMessage("\n" + scriptName() + T("|Invalid selection| ") + T("|Tool will be deleted.|"));
		eraseInstance();
		return;
	}
	
	int nAlignment = sAlignments.find(sAlignment);
	int nGapType = sGapTypes.find(sGapType, 0);
	double dRecess = nGapType == 0 ? dGap : 0;  // if not a relief type
	sGapType.setReadOnly(abs(dGap) > dEps);
	
	Sip sip = sips[0];
	Vector3d vecX = sip.vecX();
	Vector3d vecY = sip.vecY();
	Vector3d vecZ = sip.vecZ();
	Point3d ptCen = sip.ptCen();
	double dH = sip.dH();
	Element el = sip.element();
	Quader qdr(ptCen, vecX, vecY, vecZ, sip.solidLength(), sip.solidWidth(), dH, 0, 0, 0);
	// make sure height and width are valid
	if (dHeight < dEps) dHeight.set(U(27));
	if (dWidth < dEps) dWidth.set(U(100));
	

	int nQRef = sip.formatObject("SurfaceQualityBottomStyleDefinition.Definition").atoi();
	int nQTop = sip.formatObject("SurfaceQualityTopStyleDefinition.Definition").atoi();
	
	Point3d ptFace = ptCen - vecZ *.5 * dH;// ref
	int nFace = 1;
	if (nAlignment==1)// center
	{
		nFace = 0;
		ptFace = ptCen;	
	}
	else if (nAlignment==2) // top
	{
		nFace = -1;
		ptFace = ptCen + vecZ *.5 * dH;	
	}
	else if (nAlignment==3)// higher
	{
		nFace = nQRef < nQTop ?-1 : 1;
		ptFace = ptCen - vecZ * nFace*.5*dH;	
	}
	else if (nAlignment==2)// lower
	{
		nFace = nQRef < nQTop ?1 : -1;
		ptFace = ptCen - vecZ * nFace*.5*dH;	
	}

	Plane pnFace(ptFace, vecZ);
	CoordSys cs(ptFace, vecX, vecY, vecZ);
	
	addRecalcTrigger(_kGripPointDrag, "_Pt0");
	if (_kNameLastChangedProp==sAlignmentName)setExecutionLoops(2);	

	
	Display dp(nc), dpModel(nc), dpPanel(nc);
	dpModel.addHideDirection(vecZ);
	dpModel.addHideDirection(-vecZ);

	dpPanel.addViewDirection(vecZ);
	dpPanel.addViewDirection(-vecZ);

	dp.dimStyle(sDimStyle);
	if (dTextHeight>0)dp.textHeight(dTextHeight);
	
	
//endregion 	

//region Collect bodies, profiles and projected edges
	PlaneProfile ppShapeAll(cs);
	Body bodies[0];
	PlaneProfile pps[0];
	Map maps[0];
	for (int i=0;i<sips.length();i++) 
	{ 
		Map map, mapArcs;
		Sip panel = sips[i];
		
		if (bDebug)dp.draw(panel.handle(), panel.ptCen(), vecX, vecY, 0, 0);
		
		Plane pnRef(panel.ptCen() - panel.vecZ() * .5*panel.dH(), panel.vecZ());
		PLine plEnvelope = panel.plEnvelope();
		PLine plOpenings[] = panel.plOpenings();
		PLine rings[0];
		rings.append(plEnvelope);
		rings.append(plOpenings);
		
	// collect arcs
		PLine arcs[0];
		for (int r=0;r<rings.length();r++) 
		{ 
			PLine ring = rings[r]; 
			Point3d pts[] = ring.vertexPoints(false);
			for (int p=0;p<pts.length()-1;p++) 
			{ 
				Point3d pt1 = pts[p];
				Point3d pt2 = pts[p+1];
				Point3d ptm = (pt1 + pt2) * .5;
				if (!ring.isOn(ptm))
				{ 
					PLine arc(vecZ);
					arc.addVertex(pt1);
					arc.addVertex(pt2,ring.getPointAtDist(ring.getDistAtPoint(pt1)+dEps));	
					arcs.append(arc);
					mapArcs.appendPLine("arc", arc);
				}				 
			}//next p 
		}//next r

		
		Body bd= panel.envelopeBody(false,true);
		PlaneProfile pp(cs);		
		if (nAlignment!=1)
			pp.unionWith(bd.extractContactFaceInPlane(pnFace, dEps));
		else
			pp.unionWith(bd.getSlice(pnFace));	
		bodies.append(bd);
		pps.append(pp);
		
		pp.shrink(-dEps);
		ppShapeAll.unionWith(pp);
		
		
	// collect and identify edges	
		
		SipEdge edges[] = panel.sipEdges();
		
		for (int e=0;e<edges.length();e++) 
		{ 
			SipEdge edge= edges[e]; 
			PLine plEdge = edge.plEdge();
			Point3d ptMid = edge.ptMid();
			
		// get edge coordSys	
			Vector3d vecXE =plEdge.getTangentAtPoint(ptMid);
			Vector3d vecYE = edge.vecNormal();
			Vector3d vecZE = vecXE.crossProduct(vecYE);
			Vector3d vecYN = vecYE.crossProduct(vecZ).crossProduct(-vecZ); vecYN.normalize();
			
		// project to ref plane
			Point3d ptRef;
			Line(ptMid, vecZE).hasIntersection(pnRef, ptRef);
			
		// get opening index	
			int nOpeningIndex = - 1; // envelope by default
			PLine ring = plEnvelope;
			for (int o=0;o<plOpenings.length();o++) 
			{ 
				if (plOpenings[o].isOn(ptRef))
				{
					ring = plOpenings[o];
					nOpeningIndex=o;
					break;
				}				 
			}//next o
																	//ptRef.vis(nOpeningIndex+1);
			
		// identify if segment is arced
			double d = ring.getDistAtPoint(ptRef);
			Point3d ptA = ring.getPointAtDist(d-dEps);
			Point3d ptB = ring.getPointAtDist(d+dEps);
			int bOnArc = !PLine(ptA, ptB).isOn(ptRef);				//ptRef.vis(bOnArc);
			
		// project mid point to selected face
			Point3d ptMidFace = ptMid;
			Line(ptMid, vecZE).hasIntersection(pnFace, ptMidFace);	//vecXE.vis(ptMidFace,i);
			
		// get rectangle byWidth	
			PlaneProfile pp;
			Vector3d vec = vecYN * (U(1)+.5*dGap)+vecXE*.5*abs(vecXE.dotProduct(edge.ptEnd()-edge.ptStart()));
			pp.createRectangle(LineSeg(ptMidFace + vec, ptMidFace - vec), vecXE, vecYN); //pp.vis(i);
		
			Point3d pt1 = edge.ptStart();
			int bHasArcConnection;
			for (int r=0;r<arcs.length();r++) 
			{ 
				PLine arc = arcs[r];
				arc.projectPointsToPlane(Plane(pt1, vecZ), vecZ);
				if (arc.isOn(pt1))
				{
					//arc.vis(2);	
					bHasArcConnection = true;
					break; // r
				}	 
			}//next r
			
				
			Map m;
			m.setInt("openingIndex", nOpeningIndex );
			m.setInt("edgeIndex", e );
			m.setPoint3d("ptStart", pt1);
			m.setPoint3d("ptEnd", edge.ptEnd());
			m.setPoint3d("ptMid", ptMid);
			m.setPoint3d("ptMidFace", ptMidFace);
			m.setPoint3d("ptRef", ptRef);
			m.setVector3d("vecX", vecXE);
			m.setVector3d("vecY", vecYE);
			m.setVector3d("vecZ", vecZE);
			m.setVector3d("vecYN", vecYN);
			m.setPLine("plEdge", plEdge);
			m.setPLine("ring", ring);
			m.setInt("onArc", bOnArc);
			m.setInt("hasArcConnection", bHasArcConnection);
			m.setPlaneProfile("ppEdge", pp);
			m.setEntity("SipRef", panel);
			m.setMapName(e);
		
			if (bDebug && !bOnArc)
			{
				String txt = "EdgeIndex: " + e + "\PopeningIndex: " + nOpeningIndex;
				dp.draw(txt, ptMid-vecYN*U(150), vecXE, vecYE, 0, 0,_kDevice);
			}
		
		
		
			map.appendMap("Edge", m);
			map.appendMap("Arc[]", mapArcs); // just in case store all arced pline segments of this panel

		}//next e
		maps.append(map);	
	}//next i
	ppShapeAll.shrink(dEps);
	if (dRecess>0)
	{
		ppShapeAll.shrink(-dRecess);
		ppShapeAll.shrink(dRecess);		
	}

// close little gaps
	{ 
		PlaneProfile& pp = ppShapeAll;
		PLine rings[] = pp.allRings(true, false);
		PLine openings[] = pp.allRings(false, true);
		int cnt;
		while (cnt<10 && rings.length()>1)
		{ 
			double d = (cnt + 1) * U(5);
			pp.shrink(-d);
			pp.shrink(d);
			rings = pp.allRings(true, false);
			cnt++;
		}
		if (cnt>0)
			for (int i=0;i<openings.length();i++) 
				ppShapeAll.joinRing(openings[i], _kSubtract); 
	}
	//ppShapeAll.vis(2);

	PlaneProfile pp0 = pps.first();
	
	Vector3d vecDir = _Map.getVector3d("vecDir");	vecDir.vis(_Pt0, 1);
	Vector3d vecPerp = vecDir.crossProduct(-vecZ);	vecPerp.vis(_Pt0, 3);
	
	CoordSys csTool(_Pt0, vecDir, vecPerp, vecZ);
	Vector3d vecZT = vecDir.crossProduct(vecPerp);
	int bHasDir = !vecDir.bIsZeroLength();	
	
	// the board shape across the selected panels
	PlaneProfile ppInfineteBoard;
	ppInfineteBoard.createRectangle(LineSeg(_Pt0 - vecDir * U(10e4)- vecPerp * .5*dWidth, _Pt0 + vecDir * U(10e4) + vecPerp * .5*dWidth), vecDir, vecPerp);
	ppInfineteBoard.intersectWith(ppShapeAll); 
	//ppInfineteBoard.vis(40);
	
	PlaneProfile ppInfineteTool;
	ppInfineteTool.createRectangle(LineSeg(_Pt0 - vecDir * U(10e4)- vecPerp * (.5*dWidth+ dGapWidth), _Pt0 + vecDir * U(10e4) + vecPerp *(.5*dWidth+ dGapWidth)), vecDir, vecPerp);
	ppInfineteTool.intersectWith(ppShapeAll);
	ppInfineteTool.vis(211);

	
//endregion 

//region DragDisplay
	if (bDrag)
	{ 
		PlaneProfile ppBoard = ppInfineteBoard;

	
		Display dpA(-1), dpB(-1), dp(255), dpRed(1);
	    dpA.trueColor(darkyellow, 80);
	    dpB.trueColor(lightblue, 80);
	
		PlaneProfile ppShape(cs);
	    for (int i=0;i<pps.length();i++) 
	    {
	    	PlaneProfile pp = pps[i];
	    	pp.shrink(-dEps);
			ppShape.unionWith(pp);
	    }		
		ppShape.shrink(dEps);
		
		ppBoard.intersectWith(ppShape);

		// draw board    
		dpA.draw(ppBoard,_kDrawFilled);	
		
	// 3D and draw sides of board
		Body bdBoards[0];
		PLine rings[] = ppBoard.allRings(true, false);
		for (int r=0;r<rings.length();r++) 
		{ 
			PLine& pl = rings[r];
			
			Point3d pts[] = pl.vertexPoints(false);
			for (int p=0;p<pts.length()-1;p++) 
			{ 
				Point3d pt1= pts[p];
				Point3d pt2= pts[p+1];
				Point3d ptm = (pt1 + pt2) * .5;
				Vector3d vecXS = pt2 - pt1; vecXS.normalize();
				PlaneProfile pp; 
				if (nFace==0)
					pp.createRectangle(LineSeg(pt1-.5*vecZ*dHeight, pt2+.5*vecZ*dHeight), vecXS, vecZ);				
				else
					pp.createRectangle(LineSeg(pt1, pt2+nFace*vecZ*dHeight), vecXS, vecZ);
				dpA.draw(pp,_kDrawFilled);
				
				 
			}//next p

			Body bd(pl, vecZ * dHeight, nFace);
			//bdBoards.append(bd);
			dp.draw(bd);	
		}//next r	

		return;
	}
		
//endregion 
	

//region Find common segments
	Map mapSegments;
	LineSeg segments[0];	// segments stored just for insert and jigging
	{ 
		for (int i=0;i<maps.length()-1;i++)  
		{ 
			Map mapI = maps[i];// map by sip
			
		// loop each I edge	
			for (int ii=0;ii<mapI.length();ii++) 
			{ 
				Map mapA = mapI.getMap(ii);
				Entity entA = mapA.getEntity("SipRef");
			// ignore arcs	
				int bOnArcA =  mapA.getInt("onArc");
				if (bOnArcA){continue;}
				
				Vector3d vecXA = mapA.getVector3d("vecX");
				
				if (bHasDir && !vecDir.isParallelTo(vecXA)){ continue;}
				Vector3d vecYN = mapA.getVector3d("vecYN");
				Point3d ptA = mapA.getPoint3d("ptMidFace");
				Point3d ptStartA = mapA.getPoint3d("ptStart");
				Point3d ptEndA = mapA.getPoint3d("ptEnd");
				PlaneProfile ppEdgeA = mapA.getPlaneProfile("ppEdge");	ppEdgeA.vis(3);
				int edgeIndexA = mapA.getInt("edgeIndex");

				for (int j=i+1;j<maps.length();j++) 
				{ 
					if (i == j){continue;}
					Map mapJ = maps[j];// map by sip
					
				// loop each J edge	
					for (int jj=0;jj<mapJ.length();jj++) 
					{  
						Map mapB = mapJ.getMap(jj);
						Entity entB = mapB.getEntity("SipRef");
						if (entA==entB){continue;}
						
					// ignore arcs	
						int bOnArcB =  mapB.getInt("onArc");
						if (bOnArcB){continue;}
						
						Vector3d vecXB = mapB.getVector3d("vecX");
					
					// ignore not parallel	
						if (bHasDir && !vecDir.isParallelTo(vecXB))
						{
							//PLine(ptA, mapB.getPoint3d("ptMidFace")).vis(2);
							continue;
						}
						if (!vecXA.isParallelTo(vecXB))
						{
							continue;
						}
						
						Point3d ptB = mapB.getPoint3d("ptMidFace");
						Point3d ptStartB = mapB.getPoint3d("ptStart");
						Point3d ptEndB = mapB.getPoint3d("ptEnd");
						PlaneProfile ppEdgeB = mapB.getPlaneProfile("ppEdge");	ppEdgeB.vis(4);
						
					// ignore offseted
						double dPerpOffset = abs(vecYN.dotProduct(ptA - ptB));
						if (abs(dRecess)<dEps && dPerpOffset>dEps)
						{ 
							//PLine(ptA, _PtW,ptB).vis(jj);
							continue;
						}
						else if (nGapType==0 && abs(dRecess-dPerpOffset)>dEps)
						{
							PLine(ptA, ptCen,ptB).vis(211);
							continue;
						}
				
						//if (vecXA.isParallelTo(vecXB) && dPerpOffset<dEps)
						PlaneProfile ppCommon = ppEdgeB;
						if (!ppCommon.intersectWith(ppEdgeA))
						{
							ppEdgeA.vis(1);
							continue;
						}

						if (ppCommon.area()>pow(U(2.1),2))
						{ 
							LineSeg seg = ppCommon.extentInDir(vecXA);
							seg = LineSeg(seg.ptMid() - .5 * vecXA * seg.length(), seg.ptMid() + .5 * vecXA * seg.length());
							
							if (seg.length()>dEps)
							{ 
								//PLine (ptA, ptB, _PtW).vis(i);
								//seg.vis(1);vecXA.vis(ptA, i);
								segments.append(seg);
								
								Map mapSegment;
								mapSegment.setPoint3d("pt1", seg.ptStart());
								mapSegment.setPoint3d("pt2", seg.ptEnd());
								
								Map mapEdges;
								mapEdges.appendMap("Edge", mapA);
								mapEdges.appendMap("Edge", mapB);
								mapSegment.setMap("Edge[]", mapEdges);
								mapSegments.appendMap("Segment", mapSegment);
							}	
						}
						else if (bDebug)
							ppEdgeA.vis(1);
							
						 
					}//next jj				 
				}//next j			 
			}//next ii 
		}//next i	
		
		if (bDebug)reportMessage(TN("|Segments found| ") + segments.length());
		
	}
	
	String sStretchEvents[] = { "_Pt0", sGapName, sGapType};
	int bStretch = sStretchEvents.findNoCase(_kNameLastChangedProp,-1)>-1 && _Map.hasMap("Segment[]");
	if (bStretch)// use previous segments
	{
		if (bDebug)reportMessage("\nStretch event " + _kNameLastChangedProp );
		mapSegments = _Map.getMap("Segment[]");
		setExecutionLoops(2);
	}
	else
		_Map.setMap("Segment[]", mapSegments);

// purge existing beams when stretching	
	if (_kNameLastChangedProp == "_Pt0" && _Beam.length()>0)
		for (int i=_Beam.length()-1; i>=0 ; i--) 
			_Beam[i].dbErase(); 

//endregion 
		
//Part #2 //endregion

//region Part #3 onInsert2
	if (_bOnInsert)
	{ 
		int isSectionalView = vecZView.isPerpendicularTo(vecZ);
		int isWallView = qdr.vecD(vecZView).isPerpendicularTo(_ZW);
		
	//Jig arguments
		Map mapArgs;
		Point3d pts[0];

	    mapArgs.setVector3d("vecX", vecX);
	    mapArgs.setVector3d("vecY", vecY);
	    mapArgs.setVector3d("vecZ", vecZ);
		mapArgs.setPoint3d("ptFace", ptFace);
		mapArgs.setPoint3d("ptCen", ptCen);
		mapArgs.setDouble("dH", dH);
		
		mapArgs.setDouble("Width", dWidth);
		mapArgs.setDouble("GapWidth", dGapWidth);
		mapArgs.setDouble("Height", dHeight);
		mapArgs.setDouble("GapHeight", dGapHeight);



		mapArgs.setInt("Face", nFace);
		// collect envelope shapes
		Map mapShapes;
		for (int i=0;i<pps.length();i++) 
		{
			mapShapes.appendPlaneProfile("shape",pps[i]); 
		}
		mapArgs.setMap("Shape[]", mapShapes);	    

	//region Split mode if only one selected
		if (sips.length()==1)
		{ 
			String context = T(" |[Reference side/Center/Top side/Higher quality/Lower quality/X-Axis/Y-Axis]|");
			String prompt = T("|Select point on split axis|");

		// set initial direction
			if (isSectionalView)
			{
				mapArgs.setVector3d("vecDir", vecZView);
				context = T(" |[Reference side/Center/Top side/Higher quality/Lower quality]|");
			}
			else if (isWallView)
				mapArgs.setVector3d("vecDir", qdr.vecD(_ZW));
			
			PrPoint ssP(prompt+context); // second argument will set _PtBase in map
		    int nGoJig = -1;
		    while (nGoJig != _kNone)//nGoJig != _kOk && 
		    {
		        nGoJig = ssP.goJig("SplitPanel", mapArgs); 
	        
		        if (nGoJig == _kOk)
		        {	    
		            Point3d ptPick = ssP.value(); //retrieve the selected point
		            ptPick += vecZ * vecZ.dotProduct(ptCen - ptPick);
		            pts.append(ptPick);
		            if (pts.length()==2)
		            {	
		            	break;
		            }
		            else
		            { 
		            	_Pt0 = ptPick;
		            	if (isSectionalView) break;
		            	prompt = T("|Select second point on split axis|");
		            	ssP=PrPoint (prompt+context, pts.first());
		            }    
		        }
		        else if (nGoJig == _kKeyWord)
		        { 
		        	int index = ssP.keywordIndex();

		   		    if (index ==0)// reference
					{
						nFace = 1;
						ptFace = ptCen - vecZ *.5 * dH;	
					}
		            else if (index ==1)// center
					{
						nFace = 0;
						ptFace = ptCen;	
					}
					else if (index ==2)// top
					{
						nFace = -1;
						ptFace = ptCen + vecZ *.5 * dH;	
					}		
		            else if (index ==3)// higher
					{
						nFace = nQRef < nQTop ?-1 : 1;
						ptFace = ptCen - vecZ * nFace*.5*dH;	
					}
					else if (index ==4)// lower
					{
						nFace = nQRef < nQTop ?1 : -1;
						ptFace = ptCen - vecZ * nFace*.5*dH;	
					}
 		        	else if (index == 5)
		            { 
		            	mapArgs.setVector3d("vecDir", vecY);
		            }
		            else if (index == 6)
		            {
		            	mapArgs.setVector3d("vecDir", vecX);
		            }  	
		            if (pts.length()==2){	break;}
		            
		           	mapArgs.setInt("Face", nFace);
					mapArgs.setPoint3d("ptFace", ptFace); 
		        }
		        else if (nGoJig == _kCancel)
		        { 
		            eraseInstance(); // do not insert this instance
		            return; 
		        }
		        mapArgs.setPoint3dArray("pts", pts);
		    }	
		    
		    Vector3d vecDir = mapArgs.getVector3d("vecDir");
		    if (pts.length()>1)
		    	vecDir= pts.last() - pts.first();
		    vecDir=vecDir.bIsZeroLength()?vecX:vecDir;	
		    vecDir.normalize();
		    Vector3d vecPerp = vecDir.crossProduct(-vecZ);
		    
		    int nGapType = sGapTypes.find(sGapType, 0);
		    
		    
		    Sip sips[0];
		    _Sip.append(sip);
			_Sip.append(sip.dbSplit(Plane(pts.first(), vecPerp),nGapType==0?dGap:0));
			
			_Pt0.setToAverage(pts);
			_Map.setVector3d("vecDir", vecDir);
		}			
	//endregion 
	
	//region Join modes
		// Multiple segments
		else if (sips.length()>1 && segments.length()>0)
		{ 
			Vector3d vecDir = segments[0].ptEnd() - segments[0].ptStart();
			vecDir.normalize();
			_Map.setVector3d("vecDir", vecDir);	
			_Pt0 = segments[0].ptMid();	
		
		// in case multiple segments have been detected show jig selection
			if (segments.length()>1)
			{ 
				reportMessage("\nMessage " + mapSegments);
				
//				Map mapSegments;
//				for (int i=0;i<segments.length();i++) 
//				{ 
//					LineSeg seg = segments[i];
//					Map m;
//					m.setPoint3d("pt1", seg.ptStart());
//					m.setPoint3d("pt2", seg.ptEnd());
//					mapSegments.appendMap("Segment",m); 	
//				}//next i
				mapArgs.setMap("Segment[]", mapSegments);
	
	
				String prompt = T("|Select joint board location [All/Reference side/Center/Top side/Higher quality/Lower quality]|");
				PrPoint ssP(prompt); // second argument will set _PtBase in map
	  			ssP.setSnapMode(TRUE, 0);
			    int nGoJig = -1;
			    while (nGoJig != _kOk && nGoJig != _kNone)// 
			    {
			        nGoJig = ssP.goJig("JoinPanel", mapArgs); 
		        
			        if (nGoJig == _kOk)
			        {	    
			            Point3d ptPick = ssP.value(); //retrieve the selected point
			            int bOk=Line(ptPick, vecZView).hasIntersection(Plane(ptFace, vecZ.isPerpendicularTo(vecZView)?vecZView:vecZ), ptPick);
						
						int index = -1;
						double dist = U(10e4);
						for (int i=0;i<segments.length();i++) 
						{ 
							double d = Vector3d(ptPick-segments[i].closestPointTo(ptPick)).length(); 
							if (d<dist)
							{ 
								dist = d;
								index = i;
							}
						}//next i									
						_Pt0 = ptPick;   
						if (index>-1)
						{ 
							Vector3d vecDir = segments[index].ptEnd() - segments[index].ptStart();
							vecDir.normalize();
							_Map.setVector3d("vecDir", vecDir);
							_Pt0 = segments[index].ptMid();   
						} 
						else
							nGoJig = -1;
			        }
			        else if (nGoJig == _kKeyWord)
			        { 
			        	int index = ssP.keywordIndex();
			            if (index == 0)// all
			            {
			            	//TODO
			            	;
			            	continue;
			            }
			            else if (index ==1)// reference
						{
							nFace = 1;
							ptFace = ptCen - vecZ *.5 * dH;	
						}
			            else if (index ==2)// center
						{
							nFace = 0;
							ptFace = ptCen;	
						}
						else if (index ==3)// top
						{
							nFace = -1;
							ptFace = ptCen + vecZ *.5 * dH;	
						}		
			            else if (index ==4)// higher
						{
							nFace = nQRef < nQTop ?-1 : 1;
							ptFace = ptCen - vecZ * nFace*.5*dH;	
						}
						else if (index ==5)// lower
						{
							nFace = nQRef < nQTop ?1 : -1;
							ptFace = ptCen - vecZ * nFace*.5*dH;	
						}
	
						sAlignment.set(sAlignments[index-1]);
		            	mapArgs.setInt("Face", nFace);
						mapArgs.setPoint3d("ptFace", ptFace);
			        }
			        else if (nGoJig == _kCancel)
			        { 
			            eraseInstance(); // do not insert this instance
			            return; 
			        }
	
			    }
				ssP.setSnapMode(false, 0);
				
			}

			_Sip.append(sips);
		}			
	//endregion 
		return;
	}	
// end on insert 2
//endregion

//region Part #4
	_Pt0 += vecZ * vecZ.dotProduct(ptFace - _Pt0);
	setEraseAndCopyWithBeams(_kBeam0);
	
	
//region Group Assignment
{ 
	char c = bIsBeamMode?'T':'I';
	if (sAutoGroup.length()>0)
	{ 
		String sHouseGroup = sAutoGroup.token(0,"\\");
		String sFloorGroup= sAutoGroup.token(1,"\\");
		String sItemGroup = sAutoGroup.token(2,"\\");

	// shift
		for (int i=0;i<2;i++) 
		{ 
			if (sItemGroup.length()<1)
			{
				sItemGroup=sFloorGroup;
				sFloorGroup=sHouseGroup;
				sHouseGroup="";
			} 
		}

	// full group given
		if (sHouseGroup != "" && sFloorGroup != "" && sItemGroup != "")
		{
			Group gr(sHouseGroup + "\\" + sFloorGroup + "\\" + sItemGroup);
			if (!gr.bExists())
				gr.dbCreate();
			gr.addEntity(_ThisInst, true,0, c);	
		}

	// get floor group by instance
		if (sHouseGroup == "" || sFloorGroup=="")
		{
			Group groups[] = sip.groups();
			String sNamePart0, sNamePart1, sNamePart2;
			
			for (int i=0;i<groups.length();i++) 
			{ 
				Group group= groups[i]; 
				if (group.namePart(1)!="")
				{
					sNamePart0	=group.namePart(0);
					sNamePart1	=group.namePart(1);
					break;
				}
			}
			
			if (sHouseGroup=="")sHouseGroup=sNamePart0;
			if (sFloorGroup=="")sFloorGroup=sNamePart1;
			
		}		
		if (sHouseGroup!="" && sFloorGroup!="" && sItemGroup!="")
		{
			Group gr(sHouseGroup+"\\" + sFloorGroup+ "\\"+sItemGroup);
			if (!gr.bExists())
				gr.dbCreate();	
			if(gr.bExists())
			{
				if (el.bIsValid())
					gr.addEntity(_ThisInst, true,0, c);
				else
				{
					gr.addEntity(_ThisInst, true);
					assignToGroups(_ThisInst, c);
				}
			}

		}		
		
	}
	else
	{ 
			
		if (el.bIsValid())
			assignToElementGroup(el, true, 0,c);
		else
			assignToGroups(sip, c);		
	}	
}

//endregion 

	if (_bOnDbCreated)setExecutionLoops(2);
	
	// get the angle of the reliefcut (not when centered)
	double dAngleRelief= nFace==0?0:90-acos(-nFace*dGap / dH);
	int bHasArcConnection;	// flag to indicate that the jointboard connects to an arced edge: do not stretch when dragging
	
//region Collect males, females and panels to be stretched
	LineSeg segRef(_Pt0 - vecDir * U(10e4), _Pt0 + vecDir * U(10e4));
	
	Map mapStretches;
	Sip males[0], females[0];
	PlaneProfile ppRange(cs);
	
	for (int i=0;i<mapSegments.length();i++) 
	{ 
		Map mapSegment= mapSegments.getMap(i);
		Map mapEdges = mapSegment.getMap("Edge[]");
		for (int j=0;j<mapEdges.length();j++) 
		{ 
			Map mapEdge= mapEdges.getMap(j); 
			
			Vector3d vecN = mapEdge.getVector3d("vecYN");
			Point3d ptMidFace = mapEdge.getPoint3d("ptMidFace");
			PlaneProfile pp  = mapEdge.getPlaneProfile("ppEdge");

//		// not on line	
//			if (pp.splitSegments(segRef, true).length()<1)
//			{
//				continue;
//			}

			if (mapEdge.getInt("hasArcConnection"))
				bHasArcConnection = true; 

		// add to male/female collection
			int bIsMale = vecN.dotProduct(vecPerp) > 0;
			mapEdge.setInt("isMale", bIsMale);
			
			Entity ent = mapEdge.getEntity("SipRef");
			Sip panel = (Sip)ent;
			if (!panel.bIsValid()){ continue;}				
			if (bIsMale && males.find(ent)<0)
				males.append(panel);
			else if(!bIsMale && females.find(ent)<0)
				females.append(panel);

		// Add Stretch map
			mapStretches.appendMap("Edge", mapEdge);
		}//next j
	}//next i
	
	if (bDebug)reportMessage("\n"+ males.length() + " males, " + females.length() + " females found ");
//endregion

//region Get common range of males and females
	double dBlowNShrink = dEps + .5 * dRecess;
	PlaneProfile ppMale(cs);
	for (int i=0;i<males.length();i++)
	{ 
		int n = sips.find(males[i]);
		if (n < 0)continue;
		PlaneProfile pp = pps[n];
		pp.shrink(-dBlowNShrink);
		ppMale.unionWith(pp);
	}
	ppMale.shrink(dBlowNShrink);
	ppMale.vis(1);

	PlaneProfile ppFemale(cs);
	for (int i=0;i<females.length();i++)
	{ 
		int n = sips.find(females[i]);
		if (n < 0)continue;
		PlaneProfile pp = pps[n];
		pp.shrink(-dBlowNShrink);
		ppFemale.unionWith(pp);
	}
	ppFemale.shrink(dBlowNShrink);
	ppFemale.vis(2);

	PlaneProfile ppCommon(cs);
	
	{ 
		PlaneProfile pp;
		pp= ppInfineteBoard;
		pp.intersectWith(ppMale);
		LineSeg seg = pp.extentInDir(vecDir);
		pp.createRectangle(LineSeg(seg.ptStart() - vecPerp * dWidth, seg.ptEnd() + vecPerp * dWidth), vecDir, vecPerp);
		ppCommon.unionWith(pp);

		pp= ppInfineteBoard;
		pp.intersectWith(ppFemale);
		seg = pp.extentInDir(vecDir);
		pp.createRectangle(LineSeg(seg.ptStart() - vecPerp * dWidth, seg.ptEnd() + vecPerp * dWidth), vecDir, vecPerp);
		ppCommon.intersectWith(pp);
		ppCommon.intersectWith(ppInfineteBoard);
		//ppCommon.vis(3);
	}


	PlaneProfile ppBoard = ppCommon;
	ppBoard.shrink(.5*dWidth-dEps);
	ppBoard.shrink(-.5*dWidth+dEps);
	ppBoard.vis(6);
//endregion 

//region Get Segements and find out if this board would split panels
	LineSeg segMale = ppMale.extentInDir(vecDir);
	LineSeg segFemale = ppFemale.extentInDir(vecDir);
	LineSeg segBoard = ppBoard.extentInDir(vecDir);	
	
//	Point3d ptsExtrMale[] ={ segMale.ptStart(), segMale.ptEnd()};
//	Point3d ptsExtrFemale[] ={ segFemale.ptStart(), segFemale.ptEnd()};
//	Point3d ptsExtrBoard[] ={ segBoard.ptStart(), segBoard.ptEnd()};
	
	double dXBoard = abs(vecDir.dotProduct(segBoard.ptEnd() - segBoard.ptStart()));
	
	double dMaleStart = abs(vecDir.dotProduct(segMale.ptStart() - segBoard.ptStart()));
	double dMaleEnd = abs(vecDir.dotProduct(segMale.ptEnd() - segBoard.ptEnd()));
	double dFemaleStart = abs(vecDir.dotProduct(segFemale.ptStart() - segBoard.ptStart()));
	double dFemaleEnd = abs(vecDir.dotProduct(segFemale.ptEnd() - segBoard.ptEnd()));
	
	int bCanSplit = (dMaleStart < dEps && dMaleEnd < dEps && dFemaleStart < dEps && dFemaleEnd < dEps) ||
		(ppShapeAll.pointInProfile(segBoard.ptStart()-vecDir*dEps) == _kPointOutsideProfile &&
		ppShapeAll.pointInProfile(segBoard.ptEnd()+vecDir*dEps) == _kPointOutsideProfile);	
//endregion 

//region Stretching and Joining
	if (bDebug)reportMessage("\ncanSplit ("+bCanSplit+"), bHasArcConnection ("+bHasArcConnection+")");
if (bStretch && !bDrag)
{ 
	
	if (bCanSplit)
	{ 
		if (bDebug)reportMessage("\njoing and splitting... ");
		for (int i=_Sip.length()-1; i>0 ; i--) 
			_Sip[0].dbJoin(_Sip[i]); 
		_Sip.append(_Sip[0].dbSplit(Plane(_Pt0, vecPerp),dRecess));			

		setExecutionLoops(2);
		return;		
	}
	else if (!bHasArcConnection)// no connection to any arced segment
	{ 
		if (bDebug)reportMessage("\nstretching on "+mapStretches.length() + " edges");
		for (int i=0;i<mapStretches.length();i++) 
		{ 
			Map mapEdge= mapStretches.getMap(i);
			int bIsMale = mapEdge.getInt("isMale");
			Entity ent = mapEdge.getEntity("SipRef");
			Sip panel = (Sip)ent;
			if (!panel.bIsValid()){ continue;}	
			
			int openingIndex =  mapEdge.getInt("openingIndex");
			int edgeIndex = mapEdge.getInt("edgeIndex");
			Point3d ptMid =mapEdge.getPoint3d("ptMid");
			Vector3d vecN = mapEdge.getVector3d("vecYN");
			vecN.vis(ptMid, (bIsMale ? 1 : 2));
			
			Plane pnX(_Pt0+(bIsMale?-1:1) * vecPerp *.5*dRecess, vecPerp * (openingIndex>-1?-1:1));
			
			if (bDebug)reportMessage("\nStretching openingIndex" + openingIndex + " on edge index " +edgeIndex +" to plane " +pnX+  " on a " + (bIsMale ? "male " : "female "));
			//int ret = panel.stretchEdgeTo(openingIndex, edgeIndex, pnX);
			int ret = panel.stretchEdgeTo(ptMid, pnX);
			if (bDebug)reportMessage("...done returning " + ret);	
			 
		}//next i
		setExecutionLoops(2);
	}
// snap back to previous location	
	else if (_Map.hasVector3d("vecOrg"))
	{ 
		_Pt0 = _PtW + _Map.getVector3d("vecOrg");
	}	
}
	_Map.setVector3d("vecOrg", _Pt0 - _PtW);
//endregion 




//region 
	if (!bDrag)
	for (int mf=0;mf<2;mf++) 
	{ 
		Sip panels[0];
		panels=(mf==0)?males:females;
		int nDir = mf == 0 ? 1 :-1;
		Vector3d vecYBc = nDir *vecPerp;
		Vector3d vecXBc = vecYBc.crossProduct(vecZ);
	
	// Relief Cut
		if (nGapType == 1 && dGap>0 && nFace!=0 && dXBoard>dEps)
		{ 
			CoordSys csRot; 
			csRot.setToRotation(nDir*dAngleRelief, vecDir, _Pt0);

			Point3d pt = segBoard.ptMid()-vecYBc*dGap;
			
			BeamCut bc(pt, vecXBc, vecYBc, vecZ, dXBoard, 2 * dH, 3 * dH, 0, 1, 0);
			bc.transformBy(csRot);
			bc.cuttingBody().vis(mf);
			bc.addMeToGenBeamsIntersect(panels);	
			
			if (panels.length()>0)PLine (pt , panels.first().ptCen()).vis(mf);
		}
		
	// Chamfer Cut
		CoordSys csRot; 
		if (dChamferRef>dEps && dXBoard>dEps)
		{ 	
			double a = dChamferRef * .5;
			double c = sqrt(2 * pow(a, 2));
			Point3d pt = segBoard.ptMid()-vecYBc*a;
			pt += vecZ * (vecZ.dotProduct(ptCen - pt) - .5 * dH);
			csRot.setToRotation(-nDir*45, vecDir, pt);
			BeamCut bc(pt, vecXBc, vecYBc, vecZ, dXBoard, c, c, 0, 1, 1);
			bc.transformBy(csRot);
			//bc.cuttingBody().vis(mf);
			bc.addMeToGenBeamsIntersect(panels);				
		}

		if (dChamferOpp>dEps && dXBoard>dEps)
		{ 
			double a = dChamferOpp * .5;
			double c = sqrt(2 * pow(a, 2));
			Point3d pt = segBoard.ptMid()-vecYBc*a;
			pt += vecZ * (vecZ.dotProduct(ptCen - pt) + .5 * dH);
			csRot.setToRotation(-nDir*45, vecDir, pt);
			//pt.vis(2);
			BeamCut bc(pt, vecXBc, vecYBc, vecZ, dXBoard, c, c, 0, 1, 1);
			bc.transformBy(csRot);
			//bc.cuttingBody().vis(mf);
			bc.addMeToGenBeamsIntersect(panels);				
		}



	}//next mf

//endregion


//region Solid and Beam dependencies
	Point3d ptBoard =  segBoard.ptMid();
	_Pt0 += vecDir * vecDir.dotProduct(ptBoard - _Pt0);

	int bHasBeams = _Beam.length() > 0;
	Body bdBoards[0];
	if (bHasBeams)
	{ 
		if (bIsBeamMode)
		{ 
			for (int i=0;i<_Beam.length();i++) 
			{ 
				Beam& bm = _Beam[i];
				setDependencyOnBeamLength(bm);
				if (_kNameLastChangedProp == sWidthName)bm.setD(vecPerp, dWidth);
				if (_kNameLastChangedProp == sHeightName)bm.setD(vecPerp, dHeight);			
	
				bm.setPtCtrl(ptBoard+vecZ*nFace*(.5*bm.dD(vecZ)+dGapHeight),vecDir);
				bm.assignToGroups(_ThisInst, 'Z');
				Body bd = bm.envelopeBody(false, true);
				bdBoards.append(bd);
				//dp.draw(bd);
			}//next i			
		}
		else if (_Beam.length()>0)
		{ 
			setExecutionLoops(2);
			for (int i=_Beam.length()-1; i>=0 ; i--) 
				_Beam[i].dbErase(); 
		}	
	}
	else
	{ 
		PLine rings[] = ppBoard.allRings(true, false);
		
		for (int r=0;r<rings.length();r++) 
		{ 
			PLine pl= rings[r];
			if (pl.area() < pow(dWidth, 2))continue;
			pl.transformBy(vecZ * nFace * dGapHeight);
			
			Body bd(pl, vecZ*dHeight, nFace);
			
		// create joint board beams	
			if(bIsBeamMode)
			{ 
				setExecutionLoops(2);
				Beam bm;
				bm.dbCreate(bd, vecDir, vecPerp, vecDir.crossProduct(vecPerp), true, true);
				bm.setColor(nc);
				bm.setMaterial(sMaterial);
				bm.setGrade(sGrade);
				bm.assignToGroups(_ThisInst, 'Z');
				_Beam.append(bm);
				
				bd = bm.envelopeBody(false, true);
			}
			
			bdBoards.append(bd);
			//dp.draw(bd);
			 
		}//next r		
	}
	

	if (bdBoards.length() < 1)
	{
		dp.color(1);
		dp.draw(ppInfineteBoard); // just a debug helper
	}
	
//endregion 

//region Tools
	for (int i=0;i<bdBoards.length();i++) 
	{ 
		Body bd = bdBoards[i]; 
		PlaneProfile pp(csTool);
		pp.unionWith(bd.shadowProfile(pnFace));
		PlaneProfile pp1 = pp;
	
	// consider gaps, blowup and shrink not sufficient 
		if (dGapWidth>0)
		{ 
			Point3d ptm = pp.ptMid();	
			Point3d pts[] = pp.getGripEdgeMidPoints();
			for (int p=0;p<pts.length();p++) 
			{ 
				double d = vecPerp.dotProduct(pts[p]-ptm);
				if (abs(abs(d) - .5 * dWidth) < dEps)
				{
					pp.moveGripEdgeMidPointAt(p, (d<0?-1:1)*vecPerp * dGapWidth);
					pp1.unionWith(pp);
					
				}	 
			}//next p			
		}

		LineSeg seg = pp1.extentInDir(vecDir);

		Point3d pt = seg.ptMid();
		pt += vecZ * (vecZ.dotProduct(ptFace - pt)+nFace*dGapHeight);
		double dXBc = pp1.dX()+2 *dGapLength;
		double dYBc = bd.lengthInDirection(vecPerp)+2*dGapWidth;
		double dZBc = bd.lengthInDirection(vecZ)*(abs(nFace)+1) + 2*dGapHeight;
		if (dXBc>dEps && dYBc>dEps && dZBc>dEps)
		{ 
			BeamCut bc(pt, vecDir, vecPerp, vecZ, dXBc, dYBc, dZBc, 0, 0, 0);
			//bc.cuttingBody().vis(2);
			bc.addMeToGenBeamsIntersect(sips);		
		}		
		
		 
	}//next i
	


	
		
//endregion 

//region Symbol
{ 
	

	for (int j=0;j<bdBoards.length();j++)
	{ 	
		Body& bd = bdBoards[j];
		
		Point3d pt = _Pt0+vecZ*vecZ.dotProduct(ptCen-_Pt0);
		pt += vecDir * vecDir.dotProduct(bd.ptCen()-pt);
		PlaneProfile pp = bdBoards[j].getSlice(Plane(pt, vecDir)); 
		pp.shrink(dEps);
		pp.vis(252);
		
		
		CoordSys csAlign;
		csAlign.setToAlignCoordSys(pt, vecPerp, vecZT, vecDir, pt+nFace*.5*vecZ*dH, vecPerp, vecDir, - vecZT);

		pt -= vecZ * .5 * dH;
		
		Point3d pt1 = pt - vecPerp * (.5 * dWidth + dGapWidth);
		Point3d pt2 = pt + vecPerp * (.5 * dWidth + dGapWidth);
		
			
		PLine pl1(pt1, pt1+ vecZ*dH, pt2+vecZ*dH, pt2);	
		PLine pl2(pt1, pt2);	
		dpModel.color(nc);
		if (nt>0)dpModel.draw(pp, _kDrawFilled, nt);
		dpModel.draw(pp);
		if ( ! bHasBeams)dpModel.draw(bd);
//		dpModel.draw(pl1);
//		dpModel.color(5);
//		dpModel.draw(pl2);
		
		pp.transformBy(csAlign);
		pl1.transformBy(csAlign);
		pl2.transformBy(csAlign);
		
		dpPanel.color(nc);
		if (nt>0)dpPanel.draw(pp, _kDrawFilled, nt);
		dpPanel.draw(pp);
		dpPanel.draw(pl1);
		dpPanel.color(5);
		dpPanel.draw(pl2);
	}

	
}		
//endregion 


//endregion 

//region Hardware
// collect existing hardware
	HardWrComp hwcs[] = _ThisInst.hardWrComps();
	
// remove any tsl repType: the assumption is that any hardware component of type _kRTTsl has been attached by this instance
	for (int i=hwcs.length()-1; i>=0 ; i--) 
		if (hwcs[i].repType() == _kRTTsl)
			hwcs.removeAt(i); 

// declare the groupname of the hardware components
	String sHWGroupName;
//	// set group name
//	{ 
//	// element
//		// try to catch the element from the parent entity
//		Element elHW =entHW.element(); 
//		// check if the parent entity is an element
//		if (!elHW.bIsValid())	elHW = (Element)entHW;
//		if (elHW.bIsValid()) 	sHWGroupName=elHW.elementGroup().name();
//	// loose
//		else
//		{
//			Group groups[] = _ThisInst.groups();
//			if (groups.length()>0)	sHWGroupName=groups[0].name();
//		}		
//	}
	
// add main componnent
	if (!bIsBeamMode)
	{ 
		for (int i=0;i<bdBoards.length();i++) 
		{ 
			double dL = bdBoards[i].lengthInDirection(vecDir);
			String articleNumber = sMaterial+"_"+dL+"x" + dWidth + "x" + dHeight;

			HardWrComp hwc(articleNumber, 1); // the articleNumber and the quantity is mandatory
			
			//hwc.setManufacturer(sHWManufacturer);
			
			hwc.setModel(_ThisInst.modelDescription());
			hwc.setName(T("|Joint Board|"));
			hwc.setDescription(sGrade);
			hwc.setMaterial(sMaterial);
			hwc.setNotes(_ThisInst.notes());
			
			hwc.setGroup(sAutoGroup);
			//hwc.setLinkedEntity(entHW);	
			hwc.setCategory(scriptName());
			hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
			
			hwc.setDScaleX(dL);
			hwc.setDScaleY(dWidth);
			hwc.setDScaleZ(dHeight);
			
		// apppend component to the list of components
			hwcs.append(hwc);		 
		}//next i
	}

// make sure the hardware is updated
	if (_bOnDbCreated)	setExecutionLoops(2);				
	_ThisInst.setHardWrComps(hwcs);	

//endregion 


//region Action Trigger
// TriggerAddPanel
	String sTriggerAddPanel = T("|Add Panels|");
	addRecalcTrigger(_kContextRoot, sTriggerAddPanel);
	if (_bOnRecalc && _kExecuteKey==sTriggerAddPanel)
	{
	// get selection set
		PrEntity ssE(T("|Select panel(s)|"), Sip());
			Entity ents[0];
			if (ssE.go())
				ents = ssE.set();

	// append if not found
		for (int i=0;i<ents.length();i++)
			if (_Sip.find(ents[i])<0)	
				_Sip.append((Sip)ents[i]);
		setExecutionLoops(2);
		return;
	}

//// TriggerRemovePanel: remove the panel from _Sip and reset the panel edge if applicable
//	String sTriggerRemovePanel = T("|Remove Panels|");
//	addRecalcTrigger(_kContext, sTriggerRemovePanel );
//	if (_bOnRecalc && _kExecuteKey==sTriggerRemovePanel )
//	{
//	// get selection set
//		PrEntity ssE(T("|Select panels|"), Sip());
//			Entity ents[0];
//			if (ssE.go())
//				ents = ssE.set();
//
//	// loop sset
//		for (int i=0;i<ents.length();i++)
//		{
//			Sip sipRemove = (Sip)ents[i];
////		// reset female stretch if is a female panel
////			int nFemale = sipsFemales.find(sipRemove);
////			if (nFemale >-1)
////				sipRemove.stretchEdgeTo(edgesFemales[nFemale].ptMid(),Plane(_Pt0,vecDir));
////			
//			int n = _Sip.find(sipRemove);
//			if (n>-1)
//				_Sip.removeAt(n);	
//		}
//		setExecutionLoops(2);
//		return;		
//	}


// Trigger FlipSide

	String sTriggerFlipSide = T("|Flip Side|" + T(" (|Double click|)"));
	if (nFace!=0)
	{ 
		addRecalcTrigger(_kContextRoot, sTriggerFlipSide );
		if (_bOnRecalc && (_kExecuteKey==sTriggerFlipSide || _kExecuteKey==sDoubleClick))
		{
			sAlignment.set(nFace == 1 ? sAlignments[2] : sAlignments[0]);
			setExecutionLoops(2);
			return;
		}		
	}

// Trigger MergeErase
	String sTriggerJoinErase = T("|Join + Erase|");
	addRecalcTrigger(_kContextRoot, sTriggerJoinErase );
	if (_bOnRecalc && _kExecuteKey==sTriggerJoinErase)
	{
		for (int i=_Sip.length()-1; i>0 ; i--) 
			_Sip[0].dbJoin(_Sip[i]); 
		eraseInstance();			
		return;
	}
// Trigger Erase
	String sTriggerErase = T("|Erase|");
	if (_Beam.length()>0)addRecalcTrigger(_kContextRoot, sTriggerErase );
	if (_bOnRecalc && _kExecuteKey==sTriggerErase)
	{
		for (int i=_Beam.length()-1; i>0 ; i--) 
			_Beam[i].dbErase(); 
		eraseInstance();			
		return;
	}	
//endregion	

//region Dialog Trigger
{ 
	// create TSL
	TslInst tslDialog;			Map mapTsl;						
	GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
	int nProps[] ={ };			double dProps[] ={ };			String sProps[] ={ };
	
//region Trigger DisplaySettings
	String sTriggerDisplaySetting = T("|Settings|");
	addRecalcTrigger(_kContext, sTriggerDisplaySetting );
	if (_bOnRecalc && _kExecuteKey==sTriggerDisplaySetting)	
	{ 
		mapTsl.setInt("DialogMode",1);
		sProps.append(sNoYes[bIsBeamMode]);
		sProps.append(sAutoGroup);
		sProps.append(sDimStyle);
		dProps.append(dTextHeight);
		nProps.append(nc);
		nProps.append(nt);
			
		tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);						
		if (tslDialog.bIsValid())
		{
			int bOk = tslDialog.showDialog();
			if (bOk)
			{ 
				bIsBeamMode = sNoYes.find(tslDialog.propString(0),1);
				sAutoGroup= tslDialog.propString(1);
				sDimStyle = tslDialog.propString(2);
				dTextHeight = tslDialog.propDouble(0);
				nc = tslDialog.propInt(0);
				nt = tslDialog.propInt(1);

				String subKey = "Conversion";
				Map m = mapSetting.getMap(subKey);
				m.setInt("ConvertToBeam",bIsBeamMode);
				m.setString("GroupName",sAutoGroup);
				mapSetting.setMap(subKey, m);
				
				subKey = "Display";
				m.setString("DimStyle",sDimStyle);
				m.setDouble("TextHeight",dTextHeight);
				m.setInt("Color",nc);
				m.setInt("Transparency",nt);
				mapSetting.setMap(subKey, m);

				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);				
			}
			tslDialog.dbErase();
		}
//		
//	// make sure other instances are updated	
//		if (!bIsBeamMode)
//		{ 
//			Entity ents[] = Group().collectEntities(true, TslInst(), _kModelSpace);
//			for (int i=0;i<ents.length();i++) 
//			{ 
//				TslInst t = (TslInst)ents[i]; 
//				if (t.bIsValid() && t.scriptName()==scriptName())
//				{
//					reportMessage("\nupdating " + t.scriptName() + " " + t.handle());
//					t.transformBy(Vector3d(0, 0, 0));
//					t.transformBy(Vector3d(0, 0, 0));
//				}
//				 
//			}//next i
//			
//		}
		
		
		setExecutionLoops(2);
		return;	
	}
	//endregion	

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
        <int nm="BreakPoint" vl="987" />
        <int nm="BreakPoint" vl="974" />
        <int nm="BreakPoint" vl="987" />
        <int nm="BreakPoint" vl="974" />
        <int nm="BreakPoint" vl="1767" />
        <int nm="BreakPoint" vl="833" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14081 bugfix group assignment" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="20" />
      <str nm="Date" vl="1/10/2022 10:55:07 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13615 auto grouping (see settings) supported" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="19" />
      <str nm="Date" vl="12/14/2021 5:08:16 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13615 bugfix when inserting with &lt;Enter&gt;, beamcuts consider angled edges" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="18" />
      <str nm="Date" vl="12/14/2021 4:30:36 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14094 solid representation enhanced" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="17" />
      <str nm="Date" vl="12/8/2021 10:26:46 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13615 bugfix non perpendicular joint boards" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="16" />
      <str nm="Date" vl="11/15/2021 5:52:52 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13615 beam creation and symbol added" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="15" />
      <str nm="Date" vl="11/15/2021 3:42:24 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13615 default orientation set for certain views" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="14" />
      <str nm="Date" vl="11/12/2021 9:54:46 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13615 new property to choose between gap and relief gap, distinction between stretching and rejoining during drag" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="13" />
      <str nm="Date" vl="11/12/2021 5:30:35 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13615 Arc detection improved" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="12" />
      <str nm="Date" vl="11/11/2021 6:28:56 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13615 split jig improved, redundant stretching suppressed, board graphices improved" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="11" />
      <str nm="Date" vl="11/10/2021 6:07:47 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End