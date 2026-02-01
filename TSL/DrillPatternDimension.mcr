#Version 8
#BeginDescription
#Versions
Version 1.7 15.03.2023 HSB-18273 creation by blockspace mode improved, dimlines always drawn in front of other entities

Version 1.6 15.06.2022 HSB-15746 supports definition in multipage blockspace for automatic model creation
Version 1.5 02.05.2022 HSB-15384 formatting on dimlines suppressed when perpendicular to 2D pattern
Version 1.4 26.04.2022 HSB-15328 Creation by Multipage supported
Version 1.3 25.04.2022 HSB-15319 loose drills added
Version 1.2 22.04.2022 HSB-14915 alignment shopdrawings enhanced 
Version 1.1 07.04.2022 HSB-15167 new commands to add/remove points and drill locations
Version 1.0 28.03.2022 HSB-15053 Initial version

Creates multiple instances to dimension drill patterns







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
//region <History>
// #Versions
// 1.7 15.03.2023 HSB-18273 creation by blockspace mode improved, dimlines always drawn in front of other entities , Author Thorsten Huck
// 1.6 15.06.2022 HSB-15746 supports definition in multipage blockspace for automatic model creation , Author Thorsten Huck
// 1.5 02.05.2022 HSB-15384 formatting on dimlines suppressed when perpendicular to 2D pattern , Author Thorsten Huck
// 1.4 26.04.2022 HSB-15328 Creation by Multipage supported , Author Thorsten Huck
// 1.3 25.04.2022 HSB-15319 loose drills added , Author Thorsten Huck
// 1.2 22.04.2022 HSB-14915 alignment shopdrawings enhanced , Author Thorsten Huck
// 1.1 07.04.2022 HSB-15167 new commands to add/remove points and drill locations , Author Thorsten Huck
// 1.0 28.03.2022 HSB-15053 Initial version , Author Thorsten Huck
/// <insert Lang=en>
/// Select genbeams, multipages or childpanels to place pattern dimensions
/// </insert>

// <summary Lang=en>
// This tsl creates multiple instances to dimension drill patterns
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "DrillPatternDimension")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add Points|") (_TM "|Select dimension|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Remove Points|") (_TM "|Select dimension|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add Drills|") (_TM "|Select dimension|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Flip Delta <> Chain|") (_TM "|Select dimension|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Reset Modifications|") (_TM "|Select dimension|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Remove Drills|") (_TM "|Select dimension|"))) TSLCONTENT

//endregion

//region Part #1

//region Constants 
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;

	// read a potential mapObject defiarsd by hsbDebugController
	{ 
		MapObject mo("hsbTSLDev" ,"hsbTSLDebugController");
		if (mo.bIsValid()){Map m = mo.map(); for (int i=0;i<m.length();i++) if (m.getString(i)==scriptName()){bDebug = true;	break;}}
		if(bDebug)reportMessage("\n"+ scriptName() + " starting " + _ThisInst.handle() + " _Entity " + _Entity.length() + "xec:" + _kExecuteKey);		
	}
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
	int blueFence = rgb(10, 57, 133);
	int greenFence = rgb(19,162,72);
	
	Vector3d vecXView = getViewDirection(0);
	Vector3d vecYView = getViewDirection(1);
	Vector3d vecZView = getViewDirection(2);
	double dViewHeight = getViewHeight();	
	//endregion 	

	String kUID = "UniqueId", kCompareKey="CompareKey", kAllowedView = "vecAllowedView", kBoundary= "Boundary", kServer = "patternServer";

	String strDllPath= _kPathHsbInstall+"\\NetAc\\hsbGeoPattern.dll";
	String strClassName="hsbGeoPattern.PatternGenerator";
	String strFunction="Run";

	int bLogger = false;
	int tick = bLogger?getTickCount():0;
	
	
	String kDimlineGroupIndex = "DimlineGroupIndex";
	String kPatterns= "Pattern[]",kPattern= "Pattern", kNodes="Node[]", kDiameter = "Diameter";
	String kJigAddRemove = "JigRemove", kAddPoints = "AddPoints";
	
	int bDeltaOnTop = _Map.getInt("DeltaOnTop");
//end Constants//endregion

//region bOnJig
	// AddRemove with Fence
	if (_bOnJig && _kExecuteKey==kJigAddRemove) 
	{
	    Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point
	    Vector3d vecDir = _Map.getVector3d("vecDir"); vecDir.normalize();
	    Vector3d vecPerp = _Map.getVector3d("vecPerp");vecPerp.normalize();
	    Vector3d vecZ = vecDir.crossProduct(vecPerp);
	    Point3d ptLoc= _Map.getPoint3d("ptLoc");
	    int nDimLineGroupIndex = _Map.getInt(kDimlineGroupIndex);
	    
	    Point3d ptFence= _Map.getPoint3d("ptFence");
	    int bFence = _Map.hasPoint3d("ptFence"), nFenceMode;
	    
	    //_ThisInst.setDebug(TRUE); // sets the debug state on the jig only, if you want to see the effect of vis methods
	    //ptJig.vis(1);

 		Display dpPlan(-1), dpSelect(-1), dpFence(-1);
 		dpPlan.trueColor(lightblue, 50);
 		dpSelect.trueColor(red, 50);
	

	//region Get fence and draw mini view
		// if the user selects from left to right anything fully inside is taken
		// selecting from right to left any intersection is taken	
		PlaneProfile ppFence;
		if (bFence)
		{
			nFenceMode = vecXView.dotProduct(ptJig - ptFence) > 0?-1:1; // 1 = full, -1 = intersect
			dpFence.trueColor(nFenceMode==1?greenFence:blueFence,50);	
			ppFence.createRectangle(LineSeg(ptFence, ptJig),vecXView, vecYView);
	
		// mini, indicating the mode
			double d = dViewHeight / 200;
			PlaneProfile ppMini;
			ppMini.createRectangle(LineSeg(ptJig-(vecXView+vecYView)*.5*d,ptJig+(vecXView+vecYView)*.5*d),vecXView, vecYView);
			ppMini.transformBy((vecXView + vecYView) * 2*d);
			if (nFenceMode==1)ppMini.transformBy(-vecXView * d);
			dpFence.transparency(0);
			dpFence.draw(ppMini);
			dpFence.draw(ppMini, _kDrawFilled);
			
		// the bounding box will draw in hidden line if in intersect mode	
			if (nFenceMode==1)
			{
				String lineType ="Hidden"; // no clue how to get language independent to hidden linetype
				String lineTypes[0];lineTypes = _LineTypes;
				if (lineTypes.findNoCase(lineType,-1)<0)
					lineType = "Verdeckt";
				if (lineTypes.findNoCase(lineType,-1)>0)
					dpFence.lineType(lineType, .05);
			}
			dpFence.trueColor(white,0);
			ppMini.createRectangle(LineSeg(ptJig-(vecXView+vecYView)*d,ptJig+(vecXView+vecYView)*d),vecXView, vecYView);
			ppMini.transformBy((vecXView + vecYView) * 2*d);
			dpFence.draw(ppMini);	
		}			
	//endregion 

	// Collect locations
		PlaneProfile pps[0];
		{
			Map m=_Map.getMap("pps");
			for (int i=0;i<m.length();i++) 
				pps.append(m.getPlaneProfile(i)); 
		}

		for (int i=0;i<pps.length();i++) 
		{ 
			PlaneProfile pp = pps[i]; 
			
			if (bFence)
			{ 
				PlaneProfile ppTest = pp;
				int bIntersect = ppTest.intersectWith(ppFence);
				if (bIntersect && (nFenceMode==1 || (nFenceMode==-1 && abs(ppTest.area()-pp.area())<pow(dEps,2))))
				{
					dpSelect.draw(pp,_kDrawFilled);
					ppFence.subtractProfile(pp);
				}
				else
					dpPlan.draw(pp,_kDrawFilled);
			}
			else
			{ 
				if (pp.pointInProfile(ptJig)==_kPointOutsideProfile)
					dpPlan.draw(pp,_kDrawFilled);
				else
				{ 
					dpSelect.draw(pp,_kDrawFilled);
					
					PLine pl(pp.ptMid(), Line(ptLoc, vecDir).closestPointTo(pp.ptMid()));
					dpSelect.draw(pl);				
				}				
			}
		}//next i		
				
		PlaneProfile ppRemovals[0];
		{
			Map m=_Map.getMap("ppRemoval[]");
			for (int i=0;i<m.length();i++) 
				ppRemovals.append(m.getPlaneProfile(i)); 
		}		
		for (int i=0;i<ppRemovals.length();i++) 
		{ 
			PlaneProfile pp = ppRemovals[i]; 
			dpSelect.draw(pp,_kDrawFilled);
			
			PLine pl(pp.ptMid(), Line(ptLoc, vecDir).closestPointTo(pp.ptMid()));
			dpSelect.draw(pl);				

			ppFence.subtractProfile(pp);
		}//next i		

	// finally draw the fence with the selction result being subtracted
		if (bFence)
		{ 
			dpFence.trueColor(nFenceMode==1?greenFence:blueFence,50);
			dpFence.draw(ppFence, _kDrawFilled);
			ppFence.createRectangle(ppFence.extentInDir(vecXView), vecXView, vecYView);
			dpFence.trueColor(white,0);
			dpFence.draw(ppFence);			
			
		}
	    return;
	}
		
	//Add Points Jig
	else if (_bOnJig && _kExecuteKey == kAddPoints)
	{
		Point3d ptJig = _Map.getPoint3d("_PtJig");	
		Vector3d vecDir = _Map.getVector3d("vecDir"); vecDir.normalize();
	    Vector3d vecPerp = _Map.getVector3d("vecPerp");vecPerp.normalize();
	    Vector3d vecZ = vecDir.crossProduct(vecPerp);
	    Point3d ptLoc= _Map.getPoint3d("ptLoc");
		Point3d pts[] = _Map.getPoint3dArray("pts");

		String sDimStyle= _Map.getString("dimStyle");
		double scale =  _Map.getDouble("Scale");
		scale = scale > 0?scale : 1;
		double textHeight =  _Map.getDouble("textHeight");
		String text= _Map.getString("text");
		int nChainMode = _Map.getInt("chainMode");
		int nDeltaMode = _Map.getInt("deltaMode");
		

		Display dpPlan(-1), dpSelect(-1), dpFence(-1);
 		dpPlan.trueColor(lightblue, 50);
 		dpSelect.trueColor(red, 50);
		if (sDimStyle.length()>0)
			dpPlan.dimStyle(sDimStyle, scale);
		if (textHeight>0)
			dpPlan.textHeight(textHeight);
		pts.append(ptJig);
		Line lnDir(ptLoc, vecDir);
		pts = lnDir.orderPoints(pts, dEps);

 		PLine pl(ptJig, Line(ptLoc, vecDir).closestPointTo(ptJig));
 		dpSelect.draw(pl);	

		DimLine dl(ptLoc, vecDir, vecPerp);
		dl.setUseDisplayTextHeight(true);
		Dim dim(dl,  pts, "<>",  "<>", nDeltaMode, nChainMode); 
		dim.setReadDirection(vecYView - vecXView);
		dim.setDeltaOnTop(_Map.getInt("deltaOnTop"));
		dpPlan.draw(dim);

//	    Display dpJ(1);	 
//		Point3d ptBase = _Pt0;
//	    double radius = Vector3d(ptJig - ptLoc).length();
//
//	    dpJ.textHeight(U(100));
//	    PLine plCir; 
//	    plCir.createCircle(ptBase, _ZU, radius);
//	    dpJ.draw(plCir);

	    return;
	}
		
//End bOnJig//endregion 

//region Properties
category = T("|Display|");
	String sDimStyleName=T("|Dimstyle|");	
	PropString sDimStyle(nStringIndex++, _DimStyles.sorted(), sDimStyleName);	
	sDimStyle.setDescription(T("|Defines the Dimstyle|"));
	sDimStyle.setCategory(category);
	
	String sTextHeightName=T("|Text Height|");	
	PropDouble dTextHeight(nDoubleIndex++, U(0), sTextHeightName);	
	dTextHeight.setDescription(T("|Defines the text height|") + T(", |0 = byDimstyle|"));
	dTextHeight.setCategory(category);

	Map mapAdditional;
	mapAdditional.setDouble("Radius", U(10));
	mapAdditional.setDouble("Diameter", U(20));
	mapAdditional.setDouble("RadiusSink", U(10));
	mapAdditional.setDouble("DiameterSink", U(10));
	mapAdditional.setDouble("Depth", 0);
	mapAdditional.setDouble("DepthSink", 0);
	mapAdditional.setDouble("Bevel", 0);
	mapAdditional.setDouble("Angle", 0);
	mapAdditional.setString("PatternGroup", "1");
	mapAdditional.setInt("Quantity", 1);

category = T("|Dimline|");
	String sFormatName=T("|Delta Format|");	
	PropString sDeltaFormat(nStringIndex++, "<>[@(PatternIndex:D)]", sFormatName);	
	sDeltaFormat.setDescription(T("|Defines the Format of global dimension lines.|") + T("|<> = dimension value|"));	
	sDeltaFormat.setCategory(category);

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
	sDisplayMode.setDescription(T("|Defines the display mode of the dimline|"));
	sDisplayMode.setCategory(category);
	int nDisplayMode = sDisplayModes.find(sDisplayMode, 0);
	int nDeltaMode = nDeltaModes[nDisplayMode];
	int nChainMode = nPerpModes[nDisplayMode];


category = T("|Tag|");
	String sFormatPatternName=T("|Format|");	
	PropString sFormatPattern(nStringIndex++, "@(Quantity)x Ø@(Diameter)\P[@(PatternIndex:D)]", sFormatPatternName);	
	sFormatPattern.setDescription(T("|Defines the format of the pattern tag|"));
	sFormatPattern.setCategory(category);

category = T("|Pattern Detection|");
	String sMaxInterdistanceName=T("|Max. Interdistance|");	
	PropDouble dMaxInterdistance(nDoubleIndex++, U(200), sMaxInterdistanceName);	
	dMaxInterdistance.setDescription(T("|Defines the max. Interdistance between drills to detect a pattern|"));
	dMaxInterdistance.setCategory(category);

	String sPatternModes[] = {T("|All|"), T("|1 dimensional|"), T("|2 dimensional|")};
	String sPatternModeName=T("|Pattern Mode|");	
	PropString sPatternMode(nStringIndex++, sPatternModes, sPatternModeName);	
	sPatternMode.setDescription(T("|Defines the PatternMode|"));
	sPatternMode.setCategory(category);
	sPatternMode.setReadOnly(bDebug ? 0 : _kHidden);
	int nPatternMode = sPatternModes.find(sPatternMode, 0);
	
	String sLocationOverlapCountName=T("|Location Overlap Count|");	
	int nLocationOverlapCounts[]={1,2,3,4};
	PropInt nLocationOverlapCount(nIntIndex++, nLocationOverlapCounts, sLocationOverlapCountName,0);	
	nLocationOverlapCount.setDescription(T("|Defines the amount of maximal maximal patterns where an individual drill may beong to.|"));
	nLocationOverlapCount.setCategory(category);
	nLocationOverlapCount.setReadOnly(bDebug ? 0 : _kHidden);
	
	



//End Properties//endregion 

//region bOnInsert
	int mode = _Map.getInt("mode");
	if (_bOnInsert)
	{
		if (insertCycleCount() > 1) { eraseInstance(); return; }
		
		sDeltaFormat.setDefinesFormatting(GenBeam(), mapAdditional);
		sFormatPattern.setDefinesFormatting(GenBeam(), mapAdditional);
		
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
		
	
	// get current space and property ints
		int bInLayoutTab = Viewport().inLayoutTab();
		int bInPaperSpace = Viewport().inPaperSpace();
		int bInBlockSpace, bHasSDV;
	// find out if we are block space and have some shopdraw viewports
		Entity entsSDV[0];
		if (!bInLayoutTab)
		{
			entsSDV= Group().collectEntities(true, ShopDrawView(), _kMySpace);
		
		// shopdraw viewports found and no genbeams or multipages are found
			if (entsSDV.length()>0)
			{ 
				bHasSDV = true;
				Entity ents[]= Group().collectEntities(true, GenBeam(), _kMySpace);
				ents.append(Group().collectEntities(true, MultiPage(), _kMySpace));
				if (ents.length()<1)
				{ 
					bInBlockSpace = true;
				}
			}
		}

	// prompt for entities
		PrEntity ssE;
		if (bInBlockSpace)
		{ 
			ssE = PrEntity(T("|Select shopdraw viewports|"), ShopDrawView());
		}
		else if (bHasSDV)
		{ 
			ssE = PrEntity(T("|Select references (multipages, shopdraw viewports or genbeams|"), ShopDrawView());
			ssE.addAllowedClass(GenBeam());
			ssE.addAllowedClass(ChildPanel());
			ssE.addAllowedClass(MultiPage());
		}		
		else
		{
			ssE = PrEntity(T("|Select multipages|"), MultiPage());
			ssE.addAllowedClass(GenBeam());
			ssE.addAllowedClass(ChildPanel());				
		}

		if (ssE.go())
			_Entity.append(ssE.set());
			
			
	// set to block space
		if (bInBlockSpace || bHasSDV)
		{ 
			ShopDrawView sdvs[0];
			for (int i=0;i<_Entity.length();i++) 
			{ 
				ShopDrawView sdv= (ShopDrawView)_Entity[i]; 
				if (sdv.bIsValid())
					sdvs.append(sdv);
				 
			}//next i
			if (sdvs.length()>0)
			{ 
				_Pt0 = getPoint();
				mode = 5;
				_Map.setInt("mode", mode);
				return;
			}
		}		
	}

	if (mode==0 && _Entity.length()>0)
	{ 
	// Create an instance per item
		for (int i=0;i<_Entity.length();i++) 
		{ 
			Entity defineSet[0], entDefine = _Entity[i]; 
			MultiPage mp = (MultiPage)entDefine; 
			ChildPanel child= (ChildPanel)entDefine; 
			GenBeam gb= (GenBeam)entDefine; 
			Point3d pt;
			
		// Multipage	
			if (mp.bIsValid())
			{ 
				pt = mp.coordSys().ptOrg();
				defineSet= mp.defineSet();	
				if (defineSet.length()<1){ continue;}
				
				Entity entDefine = defineSet.first();
				gb = (GenBeam)entDefine;
				if (defineSet.length()<1)
				{ 
					reportMessage("\n"+ scriptName() + T("|does not support| ")+entDefine.typeDxfName());
					continue;
				}
			}
		// ChildPanel
			else if (child.bIsValid())
			{
				pt = child.realBody().ptCen();
				gb= child.sipEntity();
			}
			else if (gb.bIsValid())
			{
				pt = gb.ptCen();
			}
			
			
			Vector3d vecAllowedView = _Map.getVector3d(kAllowedView);
			if (gb.bIsValid() && vecAllowedView.bIsZeroLength()) // first multipage in sset
			{
				pt = gb.ptCen();
			// the allowed view for panels and sheets is set to the vecZ	
				Beam bm= (Beam)gb;
				Sip sip= (Sip)gb;
				Sheet sheet= (Sheet)gb;
				if (bm.bIsValid())
				{
					if (entDefine == bm)
						vecAllowedView = bm.vecD(_ZU);
					else
						vecAllowedView = bm.vecY(); // TODO allow view port selection 
				}
				else if (sip.bIsValid())
					vecAllowedView = sip.vecZ();
				else if (sheet.bIsValid())
					vecAllowedView = sheet.vecZ(); 
			}		

			if (!vecAllowedView.bIsZeroLength())
			{ 
				if (bLogger)reportNotice("\nCreating distributor for " + entDefine.typeDxfName() + " " + entDefine.handle());


			// create TSL
				TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
				GenBeam gbsTsl[] = {};		Entity entsTsl[] = {entDefine};			Point3d ptsTsl[] = {pt};
				int nProps[]={nLocationOverlapCount};			
				double dProps[]={dTextHeight,dMaxInterdistance};				
				String sProps[]={sDimStyle,sDeltaFormat,sDisplayMode,sFormatPattern,sPatternMode};
				Map mapTsl;	
				mapTsl.setInt("mode", 1); // insert / creation mode
				mapTsl.setVector3d(kAllowedView, vecAllowedView);

				tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);			
			}
		}//next i
		eraseInstance();
		return;
	}
	else if (mode==0)// wait for onGenerateShopDraw recalc
	{ 
		if (bDebug) reportMessage("\n"+ scriptName() +" waiting");
		return;
	}	
// end on insert //endregion

// End Part #1	
//endregion 

//region Part #1A
//region Blockspace Mode
	else if (mode==5)
	{ 		
		ShopDrawView sdvs[0];
		for (int i=0;i<_Entity.length();i++) 
		{ 
			ShopDrawView sdv= (ShopDrawView)_Entity[i]; 
			if (sdv.bIsValid())
				sdvs.append(sdv);			 
		}//next i	
		if (sdvs.length()<1)
		{ 
			eraseInstance();
			return;
		}

	//region On Generate ShopDrawing
		if(_bOnGenerateShopDrawing)
		{ 
		
		// the multipage instance
			Entity entCollector = _Map.getEntity(_kOnGenerateShopDrawing +"\\entCollector");
			Map mapTslCreatedFlags = entCollector.subMapX("mpTslCreatedFlags");
			int bIsCreated = mapTslCreatedFlags.hasInt(scriptName());

			_ThisInst.setCatalogFromPropValues(sLastInserted);


			//Display dp(171); dp.textHeight(U(50));

			if (!bIsCreated && entCollector.bIsValid())
			{ 
				
				GenBeam gb;		
				AnalysedDrill ads[0];// collect from first viewport
				
				for (int i = 0; i < sdvs.length(); i++)
				{
				// shopdraw view and its view data	
					ShopDrawView sdv = sdvs[i];
					
					ViewData viewDatas[] = ViewData().convertFromSubMap( _Map, _kOnGenerateShopDrawing + "\\" + _kViewDataSets,0); 
 					int nIndFound = ViewData().findDataForViewport(viewDatas, sdv);// find the viewData for my view
					if (nIndFound<0){ continue;}
					ViewData viewData = viewDatas[nIndFound];

				// Get defining genbeam
					Entity entDefine;
					Entity ents[] = viewData.showSetDefineEntities();
					if (ents.length()>0 && ents.first().bIsKindOf(GenBeam()))
						entDefine = ents.first();			
					if (!entDefine.bIsValid()) { continue;}
					
				// Get all drills	
					if (!gb.bIsValid() || (gb.bIsValid() && gb!=entDefine))
					{
						gb = (GenBeam)entDefine;
						if (!gb.bIsValid()) { continue;}
						ads =AnalysedDrill().filterToolsOfToolType(gb.analysedTools(0));
					}

				// Transformations
					CoordSys ms2ps = viewData.coordSys();
					CoordSys ps2ms = ms2ps;
					ps2ms.invert();
					
					Vector3d vecAllowedView = _ZW;
					vecAllowedView.transformBy(ps2ms);
					vecAllowedView.normalize();
					
				// Refuse if no drills in alloewed view are found
					int bHasDir;
					for (int i=0;i<ads.length();i++) 
					{ 
						if (ads[i].vecSide().isParallelTo(vecAllowedView))
						{
							bHasDir=true;
							break;
						}
					}//next i					
					if (!bHasDir)
					{ 
						//reportNotice("\n" + scriptName()+ " View " + vecAllowedView+ " has no drills in specified direction" );
						continue;		
					}
					
					Point3d ptRef = _Pt0;
					ptRef.transformBy(ps2ms);

				// create TSL
					TslInst tslNew;
					GenBeam gbsTsl[] = {};		Entity entsTsl[] = {entCollector};			Point3d ptsTsl[] = {ptRef};
					int nProps[]={nLocationOverlapCount};			
					double dProps[]={dTextHeight,dMaxInterdistance};				
					String sProps[]={sDimStyle,sDeltaFormat,sDisplayMode,sFormatPattern,sPatternMode};
					Map mapTsl;	
					mapTsl.setInt("mode", 0);
					mapTsl.setVector3d(kAllowedView, vecAllowedView);
					tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);			

					if (tslNew.bIsValid())
					{
						tslNew.transformBy(Vector3d(0, 0, 0));
						
					// flag entCollector such that on regenaration no additional instances will be created	
						if (!bIsCreated)
						{
							bIsCreated=true;
							mapTslCreatedFlags.setInt(scriptName(), true);
							entCollector.setSubMapX("mpTslCreatedFlags",mapTslCreatedFlags);
						}
					}
					
				}
			}
		}
				
	//endregion 
	
	//region Draw Setup of Blockspace
		else
		{ 
			addRecalcTrigger(_kGripPointDrag, "_Pt0");
			double scale = 1;
			Display dp(-1);
			double textHeight = dTextHeight;
			dp.dimStyle(sDimStyle, scale);
			if (textHeight>0)
				dp.textHeight(textHeight);
			else	
				textHeight = dp.textHeightForStyle("O", sDimStyle);	
			
		// Get bounds of viewports
			CoordSys cs();
			PlaneProfile pp(cs);
			
			PLine plines[0];
			for (int i=0;i<sdvs.length();i++) 
			{
				ShopDrawView sdv= sdvs[i];
				Point3d pts[] = sdv.gripPoints();
				double dX = U(1000), dY =dX; // something
				pts = Line(_Pt0, _XW).orderPoints(pts);
				if (pts.length()>0)
					dX = _XW.dotProduct(pts.last() - pts.first());
				Point3d ptsH[0]; ptsH = pts;
				
				pts = Line(_Pt0, _YW).orderPoints(pts);	
				if (pts.length()>0)
					dY = _YW.dotProduct(pts.last() - pts.first());	
					
				Point3d ptCen= sdv.coordSys().ptOrg();
				
				PLine pl;
				pl.createRectangle(LineSeg(ptCen - .5 * (_XW * dX + _YW * dY), ptCen + .5 * (_XW * dX + _YW * dY)), _XW, _YW);
				plines.append(pl);
				pp.joinRing(pl, _kAdd);				
			}
			
			
			Point3d ptNext = pp.closestPointTo(_Pt0);
			double dDeltaX = _XW.dotProduct(_Pt0-ptNext);
			double dDeltaY = _YW.dotProduct(_Pt0-ptNext);
			if (pp.pointInProfile(_Pt0)==_kPointInProfile)
			{ 
				dDeltaX *= -1;
				dDeltaY *= -1;
			}
			//pp.transformBy(_ZW * U(100));
			pp.vis(3);
			PLine(ptNext, _Pt0).vis(1);

			for (int i=0;i<sdvs.length();i++) 
			{ 
				ShopDrawView sdv= sdvs[i]; 
				Point3d pts[] = sdv.gripPoints();
				double dX = U(1000), dY =dX; // something
				pts = Line(_Pt0, _XW).orderPoints(pts);
				if (pts.length()>0)
					dX = _XW.dotProduct(pts.last() - pts.first());
				Point3d ptsH[0]; ptsH = pts;
				
				pts = Line(_Pt0, _YW).orderPoints(pts);	
				if (pts.length()>0)
					dY = _YW.dotProduct(pts.last() - pts.first());
				Point3d ptsV[0]; ptsV = pts;
				
	
				Point3d ptCen= sdv.coordSys().ptOrg();
				int nDirX = _XW.dotProduct(_Pt0 - ptCen) > 0 ? 1 :- 1;
				int nDirY = _YW.dotProduct(_Pt0 - ptCen) > 0 ? 1 :- 1;
				
			// show pseudo dims
	
			// Horizontal	
				Point3d ptLoc = ptCen + _XW *nDirX*.5*dX +_YW * (nDirY*.5*dY+dDeltaY);
				DimLine dl(ptLoc, _XW, _YW);
				dl.setUseDisplayTextHeight(true);
				Dim dim(dl,  ptsH, "<>",  "<>", nDeltaMode, nChainMode); 
				dim.setReadDirection(_YW - _XW);
				dim.setDeltaOnTop(_Map.getInt("deltaOnTop"));
				dp.draw(dim);	
				
			// Vertical
				ptLoc = ptCen + _XW *(nDirX*.5*dX+dDeltaX) +_YW * nDirY*(.5*dY);
				DimLine dlV(ptLoc, _YW, -_XW);
				dlV.setUseDisplayTextHeight(true);
				Dim dimV(dlV,  ptsV, "<>",  "<>", nDeltaMode, nChainMode); 
				dimV.setReadDirection(_YW - _XW);
				dimV.setDeltaOnTop(_Map.getInt("deltaOnTop"));
				dp.draw(dimV);
			}
		
		
		// Trigger Add / Remove Viewports//region
		// Trigger AddViewport
			String sTriggerAddViewport = T("|Add Viewports|");
			addRecalcTrigger(_kContextRoot, sTriggerAddViewport );
			if (_bOnRecalc && _kExecuteKey==sTriggerAddViewport)
			{
				PrEntity ssE(T("|Select shopdraw viewports|"), ShopDrawView());
				Entity ents[0];
				if (ssE.go())
					ents.append(ssE.set());
					
				for (int i=0;i<ents.length();i++) 
				{ 
					int n = _Entity.find(ents[i]);
					if (n<0)
						_Entity.append(ents[i]);					 
				}//next i

				setExecutionLoops(2);
				return;
			}	
			
		// Trigger RemoveViewport
			String sTriggerRemoveViewport = T("|Remove Viewports|");
			if (_Entity.length()>1)addRecalcTrigger(_kContextRoot, sTriggerRemoveViewport );
			if (_bOnRecalc && _kExecuteKey==sTriggerRemoveViewport)
			{
				PrEntity ssE(T("|Select shopdraw viewports|"), ShopDrawView());
				Entity ents[0];
				if (ssE.go())
					ents.append(ssE.set());
					
				for (int i=0;i<ents.length();i++) 
				{ 
					int n = _Entity.find(ents[i]);
					if (n>-1 && _Entity.length()>1)
						_Entity.removeAt(n);
				}//next i

				setExecutionLoops(2);
				return;
			}
		//endregion			
			
			
			
		}
	//endregion 	

		return;
	}
//endregion 

//region CoordSys and Transformations	
	Vector3d vecX, vecY, vecZ, vecAllowedView = _Map.getVector3d(kAllowedView);
	Vector3d vecReadDirection = _YW - _XW;
	PlaneProfile ppView;
	CoordSys ms2ps, ps2ms, cs;
	Vector3d vecXPS=_XW, vecYPS=_YW;
	double scale = 1;		
//endregion 

//region Resolve entities
	GenBeam gb;
	MultiPage mp;
	ChildPanel child;
	Entity entDefine, showSet[0], defineSet[0];
	for (int i=0;i<_Entity.length();i++) 
	{ 
		
		Entity& ent = _Entity[i];
		MultiPage _mp = (MultiPage)ent; 
		ChildPanel _child= (ChildPanel)ent; 
		GenBeam _gb= (GenBeam)ent; 
		if (_mp.bIsValid() && !entDefine.bIsValid()) // first multipage in sset
		{
			entDefine = _mp;
			mp = _mp;
			setDependencyOnEntity(mp);
			
		}
		else if (_gb.bIsValid() && !entDefine.bIsValid()) // first beam in sset
		{
			entDefine = _gb;
			gb = _gb;
			vecX = gb.vecX(); // TODO allow any view direction on beam
			vecY = gb.vecY();
			vecZ = gb.vecZ();
			
			if (!vecAllowedView.bIsZeroLength())
			{ 
				vecZ = vecAllowedView;
				vecY = vecX.crossProduct(-vecZ);
			}
			
			vecReadDirection = vecYView - vecXView;
			vecXPS = vecX;
			vecYPS = vecY;

			showSet.append(gb);
			defineSet.append(gb);
			setDependencyOnEntity(child);
			_ThisInst.setAllowGripAtPt0(false);
		}		
		else if (_child.bIsValid() && !entDefine.bIsValid()) // first multipage in sset
		{
			entDefine = _child;
			child = _child;
			Sip sip= child.sipEntity();
			gb = sip;
			ms2ps = child.sipToMeTransformation();
			ps2ms =ms2ps;
			ps2ms.invert();

			vecReadDirection.transformBy(ms2ps);
			

			vecX = ps2ms.vecX();
			vecY = ps2ms.vecY();
			vecZ = ps2ms.vecZ();
			vecX.normalize();
			vecY.normalize();
			vecZ.normalize();

			setDependencyOnEntity(child);

		}
	}
	
	vecXPS.transformBy(ps2ms);vecXPS.normalize();
	vecYPS.transformBy(ps2ms);vecYPS.normalize();
	
	
// validate reference
	if (!child.bIsValid() && !gb.bIsValid() && !mp.bIsValid())
	{
		reportMessage("\n" + scriptName() + ": " +T("|this tool requires a multipage or at least one genbeam in the selection set.| "));
		for (int i=0;i<_Entity.length();i++)
			reportMessage("\n  entity " +_Entity[i].typeDxfName());	
		eraseInstance();
		return;	
	}	
//endregion 

//region Identify the pattern server
	TslInst server, clients[0];
	int bIsServer;
	{ 

		Entity ent = _Map.getEntity("patternServer");
		if (ent.bIsValid())
		{
			server = (TslInst)ent;
			//server.removeSubMapX("RemovedLocation[]");
		}
		
		Entity ents[] = _Map.getEntityArray("Client[]", "", "Client");
		for (int i=0;i<ents.length();i++) 
		{ 
			TslInst t = (TslInst)ents[i]; 
			if (t.bIsValid() && t!=server)
				clients.append(t);			 
		}//next i
	
		if (server.bIsValid())
		{
			bIsServer= server == _ThisInst;	
			//if (bLogger)reportNotice("\n" + _ThisInst.handle()+ " " + (bIsServer?" is server " : " is client ") + " server = "  + server.handle());
			//if (bDebug && clients.length() < 1)bIsServer = true;
	
		// set dependency to the server	
			if (!bIsServer && !bDebug)
			{ 
				_Entity.append(server);
				setDependencyOnEntity(server);
			}
		// set dependency to genbeam just for the server	
			else if (!bDebug)
			{ 
				if (_Entity.find(gb)<0)
					_Entity.append(gb);
				setDependencyOnEntity(gb);	
			}
		}
	// set thisInst to be the server if no server could be found
		else
		{ 
			for (int i=0;i<clients.length();i++) 
			{ 
				Map m = clients[i].map();
				Entity ent = m.getEntity(kServer);
				server = (TslInst)ent;
				if (server.bIsValid())break;
			}//next i		
			
			
			if (!server.bIsValid() && !_bOnDbCreated)
			{ 
				bIsServer = true;
				server = _ThisInst;
				_Map.setEntity("patternServer", server);
				for (int i=0;i<clients.length();i++) 
				{ 
					Map m = clients[i].map();
					m.setEntity("patternServer", server);
					clients[i].setMap(m);
				}//next i			
			}		
		}		
	}
		
	
//endregion 

//region MultiPage
	PlaneProfile ppViewports[0], ppCollisionArea,ppCollisionAreas[0];
	int nIndexView = -1;
	MultiPageView mpvs[0], mpv;
	if (mp.bIsValid())
	{
		showSet= mp.showSet();
		defineSet= mp.defineSet();		
		mpvs = mp.views();

		if (mpvs.length()<1)
		{ 
			reportMessage("\n"+ scriptName() + T("|Invalid multipage with no views| ")+T("|Tool will be deleted.|"));
			eraseInstance();
			return;
		}

	// Collect bounds of viewports and distinguish selected if has been set
		for (int i=0;i<mpvs.length();i++) 
		{ 
			mpv = mpvs[i];
			PlaneProfile pp(cs);
			pp.joinRing(mpv.plShape(), _kAdd);	pp.extentInDir(_XW).vis(i);
			ppViewports.append(pp);
			
			ms2ps = mpv.modelToView();
			ps2ms = ms2ps;	
			ps2ms.invert();

			if (!vecAllowedView.bIsZeroLength() && ps2ms.vecZ().isParallelTo(vecAllowedView))
			{	
				nIndexView = i;	
				if (bDebug) reportMessage(("\nView ") + nIndexView + " detected " + vecAllowedView);				
				break;
			}
		}
		
		
		cs=mp.coordSys();				cs.vis(2);
		
	// validate location
		Vector3d vecOrg = cs.ptOrg()-_Pt0;
		if (vecOrg.length()>dEps)
		{
			_Pt0.transformBy(vecOrg);
			//_ThisInst.transformBy(vecOrg);
			for (int i=0;i<_PtG.length();i++) 	
				_PtG[i]+=vecOrg; 
		}			


		//_Pt0 = cs.ptOrg();
		//_ThisInst.setAllowGripAtPt0(false);
		assignToGroups(mp, 'D');
		for (int i=0;i<_PtG.length();i++) 
		{ 
			_PtG[i]+=_ZW*_ZW.dotProduct(_Pt0-_PtG[i]); 
			 
		}//next i		
		
		
		
		
		
	// select closest if nothing selected	
		if (nIndexView<0)
		{ 
			double dist = U(10e5);
			for (int i=0;i<ppViewports.length();i++) 
			{ 
				ppViewports[i].extentInDir(_XW).vis(i);
				double d = Vector3d(ppViewports[i].extentInDir(_XW).ptMid() - _Pt0).length();
				if (d<dist)
				{ 
					nIndexView = i;
					dist = d;
				}				 
			}//next i
		}
		if (nIndexView <0)
		{
			reportMessage("\n"+ scriptName() + T("|Unexpected error| ")+T("|Tool will be deleted.|"));
			eraseInstance();
			return;
		}
		
		mpv = mpvs[nIndexView];
		scale = 1/mpv.viewScale();//vdatas[nView];
		ppCollisionAreas = mpv.dimCollisionAreas(false);
		
		for (int i=0;i<ppCollisionAreas.length();i++) 
		{ 
			ppCollisionAreas[i].vis(2);
			ppCollisionAreas[i].shrink(-dEps);
//			ppCollisionAreas[i].transformBy(ps2ms);
			ppCollisionArea.unionWith(ppCollisionAreas[i]); 
		}//next i

		
		ms2ps = mpvs[nIndexView].modelToView();
		ps2ms =ms2ps;
		ps2ms.invert();

		vecX = ps2ms.vecX();
		vecY = ps2ms.vecY();
		vecZ = ps2ms.vecZ();
		vecX.normalize();
		vecY.normalize();
		vecZ.normalize();

		vecReadDirection.transformBy(ps2ms);
		ppCollisionArea.transformBy(ps2ms);

		for (int i = 0; i < defineSet.length(); i++)
		{
			gb = (GenBeam)defineSet[i];
			if (gb.bIsValid())
				break;
		}
		
	}	
	//ppCollisionArea.vis(3);
//endregion 

//region Collect items
	GenBeam genbeams[0];
	Body bodies[0];
	for (int i = 0; i < showSet.length(); i++)
	{
		Entity ent = showSet[i];
		GenBeam gb = (GenBeam)ent;
		if (gb.bIsValid())
		{
			genbeams.append(gb);
			Body bd = gb.realBody(); 	bd.vis(4);
			bodies.append(bd);
			
			vecX.vis(bd.ptCen(), 1);
			vecY.vis(bd.ptCen(), 3);
//			
//			
//			bd.transformBy(ps2ms);
//			bd.vis(i);
		}
	}
//End Collect items//endregion 

//region Display
	Display dp(-1);
	double textHeight = dTextHeight;
	dp.dimStyle(sDimStyle, scale);
	if (textHeight>0)
		dp.textHeight(textHeight);
	else	
		textHeight = dp.textHeightForStyle("O", sDimStyle);
		
//endregion 

//region Get properties and geometry of defining genbeam
	if (!gb.bIsValid())
	{
		reportMessage("\n"+ scriptName() + T("|Unexpected error| ")+T("|Tool will be deleted.|"));
		eraseInstance();
		return;
	}
	if (bIsServer)_GenBeam.append(gb);
	
	Vector3d vecXG = gb.vecX();
	Vector3d vecYG = gb.vecY();
	Vector3d vecZG = gb.vecZ();
	Point3d ptCen = gb.ptCen();
	Quader qdr(ptCen, vecXG, vecYG, vecZG, gb.solidLength(), gb.solidWidth(), gb.solidHeight(), 0, 0, 0);
	Vector3d vecSide = qdr.vecD(vecZ);
	vecSide.vis(ptCen, 2);
	CoordSys csView(ptCen, vecX, vecY, vecZ);
	Plane pn(ptCen, vecSide);
	Body bdEnv = gb.envelopeBody(true, true);
	PlaneProfile ppShadow(csView);
	ppShadow.unionWith(bdEnv.shadowProfile(pn));
	//ppShadow.vis(1);
	
	PlaneProfile ppSnap = ppShadow;
	ppSnap.shrink(-textHeight*.2);			ppSnap.vis(161);
	LineSeg segShadow = ppShadow.extentInDir(vecX);segShadow.vis(40);
	Point3d ptMid = segShadow.ptMid();
	
	if(mode!=2)
	{ 
		PlaneProfile pp = ppSnap;
		ppSnap.subtractProfile(ppShadow);
		ppCollisionArea.unionWith(ppSnap);
		ppCollisionArea.shrink(-textHeight);
		ppCollisionArea.shrink(textHeight);
		
	}
	ppCollisionArea.vis(2);	
//endregion 

//region Reference Points: Collect linesegments of the reference where the normal points outwards
	PLine plRef(vecZ);
	{ 
		PLine rings[] = ppShadow.allRings(true, false);
		if (rings.length()>0)
			plRef = rings.first();
		plRef.convertToLineApprox(dEps);	
	}	
	LineSeg segs[0];
	{ 
		Point3d pts[] = plRef.vertexPoints(false);
		for (int p=0;p<pts.length()-1;p++) 
		{ 
			Point3d pt1= pts[p]; 
			Point3d pt2= pts[p+1];
			Point3d ptm = (pt1 + pt2) * .5;
			Vector3d vecX = pt2 - pt1;
			vecX.normalize();
			Vector3d vecY = vecX.crossProduct(vecZ);
			if (ppShadow.pointInProfile(ptm+vecY*dEps)==_kPointOutsideProfile)
			{ 
				pt1 = pts[p + 1];
				pt2 = pts[p];
			}
			LineSeg seg(pt1, pt2);
			segs.append(seg);
		}//next p
	}	

//endregion

// End Part #1A	
//endregion 

//region Part #2

//region Run in server mode or distribution mode
	if (bIsServer || mode==1 )// )// || (bDebug && server.bIsValid())     // || bDebug)
	{ 
		if (bLogger)reportNotice("\n"+ _ThisInst.handle() + " collecting tools and patterns " + (getTickCount()-tick)+"ms");
		
		TslInst tsls[0]; // all tag and dimline instances
		
	// Collect tools
		AnalysedTool tools[] = gb.analysedTools(_bOnDebug); // 2 means verbose reportNotice 
		AnalysedDrill drills[]= AnalysedDrill().filterToolsOfToolType(tools);	
		Map mapDrills[drills.length()];

	//region Run Pattern Detection per relevant side
		double maxInterDistance = dMaxInterdistance<=0?U(300):dMaxInterdistance;
	
		Map mapPatternInput;
		mapPatternInput.setInt("MAV",1);
		mapPatternInput.setDouble("MaximumAllowedLocationInterDistance",maxInterDistance);
		mapPatternInput.setDouble("EqualDistanceTolerance",dEps);
		
		mapPatternInput.setInt("RejectPatternsWithLocationOverlapCount",nLocationOverlapCount);
		mapPatternInput.setInt("AllowVec1DPatterns",nPatternMode !=2);
		mapPatternInput.setInt("AllowVec2DPatterns",nPatternMode !=1);	
		mapPatternInput.setPoint3d("ptOrg",ptCen);
		mapPatternInput.setVector3d("vecX",vecX);
		mapPatternInput.setVector3d("vecY",vecY);
		mapPatternInput.setVector3d("vecZ",vecZ);	
		
		//region Collect potential locations
		Map mapLocations;
		for (int i=0;i<drills.length();i++) 
		{ 
			AnalysedDrill drill = drills[i]; 
			Vector3d _vecSide = drill.vecSide();
			if (!_vecSide.isParallelTo(vecZ)) { continue; }
			
			double dDiameter = drill.dDiameter();
			double dDepth = drill.dDepth();
			double dBevel = drill.dBevel();
			double dAngle = drill.dAngle();
			Point3d pt = drill.ptStart();
			String compareKey =dDepth +"_"+ dDiameter+"_"+dBevel+"_"+dAngle+"_" + (_vecSide.dotProduct(vecZ)<0?-1:1);
			
			PLine circ; circ.createCircle(pt,drill.vecFree(), dDiameter*.5);
			circ.convertToLineApprox(dEps);
			PlaneProfile pp(circ);
			
			Map mapLocation;
			mapLocation.setInt("MAV",1);
			mapLocation.setPoint3d("Pt",pt);	
			mapLocation.setString(kUID,i);
			mapLocation.setDouble("Diameter",dDiameter);
			mapLocation.setDouble("Bevel",dBevel);
			mapLocation.setDouble("Angle",dAngle);
			mapLocation.setDouble("Depth",dDepth);
			
			mapLocation.setPlaneProfile("pp", pp);
			pp.project(Plane(pt, vecZ),drill.vecFree(),dEps);
			mapLocation.setPlaneProfile("ppProjected", pp);
			
			mapLocation.setString(kCompareKey,compareKey );	
			mapLocations.appendMap("Location",mapLocation);	
		}
		mapLocations.setMapName("Location[]");
		//endregion 

		Map mapLocationsAll = mapLocations;
		Map mapFreeLocations;
		if (server.subMapXKeys().findNoCase("RemovedLocation[]",-1)>-1)
		{ 
			Map m = server.subMapX("RemovedLocation[]");
			String uids[0];
			for (int i=0;i<m.length();i++) 
			{
				String uid = m.getString(i);
				if (uid.length()>0 && uids.findNoCase(uid,-1)<0)
					uids.append(uid); 
			}
					
			for (int i=mapLocations.length()-1; i>=0 ; i--) 
			{ 
				String uid = mapLocations.getMap(i).getString(kUID);
				if (uids.findNoCase(uid,-1)>-1)
					mapLocations.removeAt(i, true);
			}
		}

		Map mapIn, mapPatternGeneration;
		mapPatternInput.setMap("Location[]",mapLocations);
		mapPatternGeneration.setInt("MAV",1);
		mapPatternGeneration.setMap("PatternInput",mapPatternInput);
		mapIn.setMap("PatternGeneration", mapPatternGeneration);

	// Call pattern generator	
		Map mapOut =callDotNetFunction2(strDllPath, strClassName, strFunction, mapIn);	
		Map mapOutputPatterns = mapOut.getMap("PatternOutput\\Patterns");
		
		if (mapOutputPatterns.length()<1)
		{ 
			if (bDebug || bLogger) 
				reportMessage(TN("|No patterns detected in view| ") + vecSide + "\nMax Interdistance" + dMaxInterdistance + " mapLocs " + mapLocations);
			if (!bDebug) 
				eraseInstance();
			return;
		}

		if (bLogger)reportNotice(", elapsed " + (tick-getTickCount())+"ms");		

//	//region Get boundaries of each pattern collected
		Map mapPatterns;// Build enriched map per pattern
		String uidPatternLocations[0];
		Vector3d vecPerps[0]; // collection of perpendicular dim directions
		for (int pa=0;pa<mapOutputPatterns.length();pa++) 
		{ 
			Map m = mapOutputPatterns.getMap(pa); 
			Map locations =m.getMap("Locations");
			String compareKey = m.getString(kCompareKey);
			
			Vector3d vecAMain,vecA, vecB=m.getVector3d("vecB");
			int bIs2D;
			if (vecB.bIsZeroLength())
				vecA = m.getVector3d("vec");
			else
			{
				bIs2D = true;
				vecA = m.getVector3d("vecA");
			}
	
			Point3d pts[0];
			double diameter;
			
			// loop locations of this pattern
			for (int i=0;i<locations.length();i++) 
			{ 
				String uid= locations.getString(i);
				
				// append to all patternized UIDs
				if (uidPatternLocations.findNoCase(uid,-1)<0)
					uidPatternLocations.append(uid);
							
				// find this location in all locations
				for (int j=0;j<mapLocations.length();j++) 
				{ 
					Map location = mapLocations.getMap(j);				
					if (uid == location.getString(kUID))
					{
						diameter = location.getDouble("diameter");
						pts.append(location.getPoint3d("pt"));
						break;// j
					}			
				}//next j 
			}//next i
			
			Point3d ptm;
			ptm.setToAverage(pts);		//ptm.vis(3);
	
			CoordSys csPattern;
			{ 
				Vector3d vecXP = vecA; vecXP.normalize();
				Vector3d vecYP = vecXP.crossProduct(-vecAllowedView);
				Vector3d vecZP = vecAllowedView;
				csPattern = CoordSys(ptm, vecXP, vecYP, vecZP);
			}

			PlaneProfile pp(csPattern);
			if (bIs2D)
			{
				PLine pl; pl.createConvexHull(pn,pts);
				pp.joinRing(pl, _kAdd);	
				pp.shrink(-.5 * diameter);
				ptm = pp.ptMid();
			}
			else
			{
				Vector3d vecDir = vecA; vecDir.normalize();
				Vector3d vecPerp = vecDir.crossProduct(-vecZ);
				
				pts = Line(_Pt0, vecDir).orderPoints(pts, dEps);
				if (pts.length() < 2)continue;
				
				Point3d pt1 = pts.first();
				Point3d pt2 = pts.last();
				double dX = abs(vecDir.dotProduct(pt2-pt1));
				PlaneProfile _pp;
				_pp.createRectangle(LineSeg(ptm-.5*(vecDir*(dX+diameter)+ vecPerp*diameter),
					ptm +.5 * (vecDir * (dX+diameter) + vecPerp * diameter)), vecDir, vecPerp);
				pp.unionWith(_pp);
			}
			//pp.vis(pa);
			
			
		// clone for X and Y and store quadrant
			double dX = vecX.dotProduct(ptm-ptCen);
			double dY = vecY.dotProduct(ptm-ptCen);
			m.setPoint3dArray("Node[]", pts);
			m.setPoint3d("ptm", ptm);
						
			m.setDouble("diameter", diameter);
			m.setInt("is2D", bIs2D);
			if (vecAMain.bIsZeroLength())m.setVector3d("vecAMain", vecAMain); // the main pattern direction might not be aligned with boundings of pattern
			m.setInt("PatternIndex", pa+1);
			m.setPlaneProfile(kBoundary, pp);
			
			Vector3d vecPerpX = vecX;
			Vector3d vecPerpY = vecY;
			
			if (dX>=0 && dY>=0)// upper right
			{ 
				m.setInt("quadrant", 0);
				vecPerpX = vecX;
				vecPerpY = vecY;			
			}
			else if (dX<0 && dY>=0)// upper left
			{ 
				m.setInt("quadrant", 1);
				vecPerpX = -vecX;
				vecPerpY = vecY;													
			}		
			else if (dX<0 && dY<0)// lower left
			{ 
				m.setInt("quadrant", 2);
				vecPerpX = -vecX;
				vecPerpY = -vecY;							
			}		
			else if (dX>=0 && dY<0)// lower right
			{ 
				m.setInt("quadrant", 3);
				vecPerpX = vecX;
				vecPerpY = -vecY;									
			}
			
			m.setVector3d("vecPerpX", vecPerpX);
			m.setVector3d("vecPerpY", vecPerpY);
			
			pp.vis(pa);
//			vecPerpX.vis(pp.ptMid(), pa);
//			vecPerpY.vis(pp.ptMid(), pa);
			
		// collect all perp dim directions	
			for (int i = 0; i < 2; i++)
			{
				Vector3d vecPerp = i == 0 ? vecPerpX : vecPerpY;
				int bFound;
				for (int j = 0; j < vecPerps.length(); j++)
					if (vecPerp.isCodirectionalTo(vecPerps[j]))
					{
						bFound = true;
						break;
					}
				if (!bFound)
					vecPerps.append(vecPerp);
			}
			mapPatterns.appendMap("Pattern",m);	

		}//next pa
		
	//endregion 				
	
	//region Split / Duplicate patterns in their perp directions
		Map patterns[0];
		for (int i=0;i<mapPatterns.length();i++) 
		{ 
			Map m= mapPatterns.getMap(i); 
			m.setVector3d("vecPerp", m.getVector3d("vecPerpX"));
			patterns.append(m);
			
			m.setVector3d("vecPerp", m.getVector3d("vecPerpY"));
			patterns.append(m);
		}//next i



		
	//endregion 

	//region Group patterns such they would not intersect within dimline
		int numGroups[vecPerps.length()]; // counter how many grouped dimlines need to be created per perp direction
		for (int v = 0; v < vecPerps.length(); v++)
		{ 
		// get patterns codirectional	
			Vector3d vecPerp = vecPerps[v];
			Vector3d vecDir = vecPerp.crossProduct(vecZ);
		
		//order by perp direction offset
			for (int i = 0; i < patterns.length(); i++)
				for (int j = 0; j < patterns.length() - 1; j++)
				{				
					double d1 = vecPerp.dotProduct(patterns[j].getPoint3d("ptm") - ptCen);
					double d2 = vecPerp.dotProduct(patterns[j + 1].getPoint3d("ptm") - ptCen);	
					if (d1 > d2)
						patterns.swap(j, j + 1);
				}


			PlaneProfile ppProtect;
			for (int i = 0; i < patterns.length(); i++)
			{
				Map& m = patterns[i];
				if (!patterns[i].getVector3d("vecPerp").isCodirectionalTo(vecPerp)){ continue;}
				
				PlaneProfile ppBoundary = m.getPlaneProfile(kBoundary);
				LineSeg seg = ppBoundary.extentInDir(vecDir);
				seg.transformBy(vecPerp * (vecPerp.dotProduct(ptCen-seg.ptMid())+ 
					.5*abs(vecPerp.dotProduct(segShadow.ptEnd()-segShadow.ptStart()))));
				double dX = abs(vecDir.dotProduct(seg.ptEnd() - seg.ptStart()));
				
				PlaneProfile pp;
				pp.createRectangle(LineSeg(seg.ptMid() - vecDir * .5 * dX, seg.ptMid() + vecDir * .5 * dX + vecPerp * textHeight), vecDir, vecPerp);
					
				PlaneProfile ppt=pp;
				int cnt, bIntersect = ppt.intersectWith(ppProtect);		
				while (bIntersect && cnt < 10)
				{
					cnt++;
					ppt = pp;
					ppt.transformBy(vecPerp * cnt * (textHeight + dEps));
					//ppt.vis(cnt);
					bIntersect = ppt.intersectWith(ppProtect);	
					if (!bIntersect)
					{
						pp.transformBy(vecPerp * cnt * (textHeight + dEps));
						break;
					}	
				}
				ppProtect.unionWith(pp);
				pp.vis(i);//ppBoundary.vis(v);
				
				patterns[i].getVector3d("vecPerp").vis(ppBoundary.ptMid(), v);
				
				
				if (bDebug)dp.draw(cnt+1, pp.ptMid(), vecDir, vecPerp, 0, 0);
				m.setInt("GroupIndex", cnt+1);

				if (numGroups[v]<cnt+1)
					numGroups[v] = cnt + 1;
			}						
		}
	//endregion

	//region Collect loose / non patternized drills
		Map mapLooseLocations;
		Vector3d vecLoosePerps[0];
		for (int i=0;i<mapLocationsAll.length();i++) 
		{ 
			Map m= mapLocationsAll.getMap(i);
			if (!m.hasString(kUID) || uidPatternLocations.findNoCase(m.getString(kUID))>-1)
			{ 
				continue;
			}
			
			Point3d pt = m.getPoint3d("pt");
			double dX = vecX.dotProduct(pt-ptCen);
			double dY = vecY.dotProduct(pt-ptCen);
			
			int nA = vecX.dotProduct(pt - ptCen) > 0 ? 1 :- 1;
			int nB = vecY.dotProduct(pt - ptCen) > 0 ? 1 :- 1;
			
			Vector3d vecA = nA*vecX;
			Vector3d vecB = nB*vecY;
			
			if (nA>0 && nB>0)// upper right
				m.setInt("quadrant", 0);
			else if (nA<0 && nB>0)// upper left
				m.setInt("quadrant", 1);
			else if (nA<0 && nB<0)//  lower left
				m.setInt("quadrant", 2);
			else// lower right
				m.setInt("quadrant", 3);
			m.setVector3d("vecA", vecA);
			m.setVector3d("vecB", vecB);
			
			vecA.vis(pt, m.getInt("quadrant"));vecB.vis(pt, 3);			
			mapLooseLocations.appendMap("Location", m); 

		// collect all perp dim directions	
			for (int jj = 0; jj < 2; jj++)
			{
				Vector3d vecAB = jj == 0 ? vecA : vecB;
				int bFound;
				for (int j = 0; j < vecLoosePerps.length(); j++)
					if (vecAB.isCodirectionalTo(vecLoosePerps[j]))
					{
						bFound = true;
						break;
					}
				if (!bFound)
					vecLoosePerps.append(vecAB);
			}

		}//next i
		
	//endregion 



	//region Revert to map/Submap
		Map mapOutX;
		for (int i=0;i<patterns.length();i++) 
			mapOutX.appendMap("Pattern",patterns[i]); 
		mapOutX.setMap("Location[]",mapLocationsAll);
		mapOutX.setMap("LooseLocation[]",mapLooseLocations);
		// update server and clients
		_ThisInst.setSubMapX("PatternsX",mapOutX);
	
		for (int i=0;i<clients.length();i++) 
		{
			clients[i].setSubMapX("PatternsX",mapOutX);
		//	clients[i].setSubMapX("RawOut",mapOut);
//			clients[i].setSubMapX("FreeLocation[]",mapFreeLocations);
		}
		
		
	//endregion 



// _Map.getInt("AddLoose");
		
	//region Create tag and dimline instances
		if (mode==1)// 
		{ 
			int sequenceNumber = 1;
		//region Create a tag instance per pattern
			if (bLogger)reportNotice("\n"+ _ThisInst.handle() + " creating tags... ");
			for (int pa=0;pa<mapPatterns.length();pa++) 
			{ 
				Map m = mapPatterns.getMap(pa); 
				Point3d ptm = m.getPoint3d("ptm");
				int bIs2D = m.getInt("is2D");
			
			
			
			// create TSL
				TslInst tslNew;				Map mapTsl;	
				GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {ptCen, ptm};
				int nProps[]={nLocationOverlapCount};			
				double dProps[]={dTextHeight,dMaxInterdistance};				
				String sProps[]={sDimStyle,sDeltaFormat,sDisplayMode,sFormatPattern,sPatternMode};
				if (bIs2D)ptsTsl.append(ptm);

				mapTsl.setInt("mode", 2); // tag mode
				mapTsl.setInt("Index", m.getInt("PatternIndex"));
				mapTsl.setVector3d(kAllowedView, vecZ);
				mapTsl.setMap("Pattern[]", mapOutX);//mapPatterns);

				entsTsl = _Entity;
				entsTsl.append(entDefine);
				gbsTsl = _GenBeam;
				
				if (_bOnDbCreated)
				{ 
					tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
					if (tslNew.bIsValid())
						tsls.append(tslNew);					
				}

			}//next pa
		//endregion
		
		//region Create a dimline instance per perp direction
			if (bLogger)reportNotice("\n"+ _ThisInst.handle() + " creating dimlines... ");
			for (int i=0;i<vecPerps.length();i++) 
			{ 
				Vector3d& vecPerp = vecPerps[i];
				Vector3d vecDir = vecPerp.crossProduct(vecZ);
				
				Point3d pts[] = Line(ptCen, - vecPerp).orderPoints(ppCollisionArea.intersectPoints(Plane(ptCen, vecDir), true, false));
				Point3d ptLoc=ptCen;
				if (pts.length()>0)
					ptLoc = pts.first()+vecPerp*textHeight;
				ptLoc -= vecDir *abs(vecDir.dotProduct(segShadow.ptMid() - ptLoc));
				ptLoc -= vecDir * .5* abs(vecDir.dotProduct(segShadow.ptEnd() - segShadow.ptStart()));
				
				int numGroup = numGroups[i];
	
	
			// create TSL
				TslInst tslNew;				Map mapTsl;	
				GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = { ptCen, ptLoc};
				int nProps[]={nLocationOverlapCount};			
				double dProps[]={dTextHeight,dMaxInterdistance};				
				String sProps[]={sDimStyle,sDeltaFormat,sDisplayMode,sFormatPattern,sPatternMode};
				ptsTsl[0].transformBy(ms2ps);
				if (mp.bIsValid())ptsTsl[0] = mp.coordSys().ptOrg();

				mapTsl.setInt("mode", 3); //dimline mode
				mapTsl.setVector3d("vecPerp", vecPerp);
				mapTsl.setMap("Pattern[]", mapOutX);
				mapTsl.setVector3d(kAllowedView, vecZ);

				entsTsl = _Entity;
				entsTsl.append(entDefine);
				gbsTsl = _GenBeam;
				
				for (int j=0;j<numGroup;j++) 
				{ 
					ptLoc.vis(40);
					ptsTsl[1] = ptLoc;
					ptsTsl[1].transformBy(ms2ps);
				
					mapTsl.setInt("DimlineGroupIndex", j+1);
					mapTsl.setInt("sequenceNumber", sequenceNumber++);
					
					
					if (_bOnDbCreated)
					{ 
						tslNew.dbCreate(scriptName() , vecX ,vecY,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
						if (tslNew.bIsValid())
							tsls.append(tslNew);					
					}			
					ptLoc += vecPerp * 2*textHeight;
				}//next j	
			}
		//endregion 		

		//region Create loose drill dimlines 
			if (bLogger)reportNotice("\n"+ _ThisInst.handle() + " creating loose dimlines... ");	
			for (int i=0;i<vecLoosePerps.length();i++) 
			{ 
				Vector3d& vecPerp = vecLoosePerps[i];
				Vector3d vecDir = vecPerp.crossProduct(vecZ);			
			
				Point3d pts[] = Line(ptCen, - vecPerp).orderPoints(ppCollisionArea.intersectPoints(Plane(ptCen, vecDir), true, false));

				Point3d ptLoc=ptCen;
				if (pts.length()>0)
					ptLoc = pts.first()+vecPerp*textHeight;
				ptLoc -= vecDir *abs(vecDir.dotProduct(segShadow.ptMid() - ptLoc));
				ptLoc -= vecDir * .5* abs(vecDir.dotProduct(segShadow.ptEnd() - segShadow.ptStart()));


			// create TSL
				TslInst tslNew;				Map mapTsl;	
				GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = { ptCen, ptLoc};
				int nProps[]={nLocationOverlapCount};			
				double dProps[]={dTextHeight,dMaxInterdistance};				
				String sProps[]={sDimStyle,sDeltaFormat,sDisplayMode,sFormatPattern,sPatternMode};
				ptsTsl[0].transformBy(ms2ps);
				ptsTsl[1].transformBy(ms2ps);
				if (mp.bIsValid())ptsTsl[0] = mp.coordSys().ptOrg();

				mapTsl.setInt("mode", 4); //dimline mode
				mapTsl.setVector3d("vecPerp", vecPerp);
				mapTsl.setMap("Pattern[]", mapOutX);
				mapTsl.setVector3d(kAllowedView, vecZ);
				mapTsl.setInt("AddLoose", true);

				entsTsl = _Entity;
				entsTsl.append(entDefine);
				gbsTsl = _GenBeam;

				if (_bOnDbCreated)
				{ 
					mapTsl.setInt("sequenceNumber", sequenceNumber++);
					tslNew.dbCreate(scriptName() , vecX ,vecY,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
					if (tslNew.bIsValid())
						tsls.append(tslNew);					
				}
			}			
			
		//endregion 


			if (!bDebug && tsls.length()>0)
			{
			// update created instances, the first one will be server for the pattern update procedure	
				Entity server = tsls.first();
				for (int i=0;i<tsls.length();i++) 
				{ 
					if (bLogger)reportNotice("\n"+ _ThisInst.handle() + " updating " + tsls[i].handle());
					Map m = tsls[i].map();
					m.setEntity("patternServer",server);
					m.setEntityArray(tsls, true, "Client[]", "", "Client");
					tsls[i].setMap(m);				
				}//next i
			
				if (bLogger)reportNotice("\n"+ _ThisInst.handle() + " distribution done.");
				eraseInstance();
				return;
			}
		}
	//endregion 	
	
//endregion 
	}
// END server mode
//	else
//	{ 
//		mapPatterns = _Map.getMap("Pattern[]");
//		//reportNotice("\nclient of " + server + " patterns collected " + mapPatterns.length());//XX
//	}
//endregion 

// End Part #2
//endregion 

//region Collect Patterns
	Map mapPatterns[0], mapPatternsX,mapFreeLocations, mapLocations, mapLooseLocations;	
	Map m;
	if (_bOnDbCreated || bDebug) // store pattern data in mapX to suppress transformation of mapped data
	{ 
		mapPatternsX = _Map.getMap("Pattern[]");
		_ThisInst.setSubMapX("PatternsX", mapPatternsX);
//		_ThisInst.setSubMapX("Out", mapInOut);
	}
	else if (_bOnGripPointDrag)
	{
		mapPatternsX = server.subMapX("PatternsX");	
//		mapFreeLocations = server.subMapX("FreeLocation[]");
	}
	else
	{
		mapPatternsX = _ThisInst.subMapX("PatternsX");
//		mapFreeLocations = _ThisInst.subMapX("FreeLocation[]");
	}

	// for the ease of sorting make it accesible by index
	for (int i=0;i<mapPatternsX.length();i++) 
	{
		Map m = mapPatternsX.getMap(i);
		if (m.getMapName().find("Location[]",0,false)<0)
			mapPatterns.append(mapPatternsX.getMap(i)); 
	}
	mapLocations = mapPatternsX.getMap("Location[]");
	mapLooseLocations = mapPatternsX.getMap("LooseLocation[]");
	int nIndex = _Map.getInt("Index");
	int sequenceNumber = _Map.getInt("sequenceNumber");
	Vector3d vecPerp = _Map.getVector3d("vecPerp");
	_ThisInst.setDrawOrderToFront(true);
//endregion 


//region Tag mode
	if (mode==2 && (_bOnGripPointDrag || (nIndex>0 && nIndex <=mapPatterns.length())))
	{ 
		if (bLogger)reportNotice("\n"+ _ThisInst.handle() + " tag mode starting ");
		sDeltaFormat.setReadOnly(_kHidden);
		
		int nDrag=-1;
		Point3d ptDrag;
		if (_bOnGripPointDrag)
		{
			if (_kExecuteKey == "_PtG0")nDrag = 0;
			else if (_kExecuteKey == "_PtG1")nDrag = 1;
			else if (_kExecuteKey == "_PtG2")nDrag = 2;	
			
			reportMessage("\ndragging index " +nDrag);
			
			ptDrag = _PtG[nDrag];
		}
	
		
	// find pattern which matches the stored index
		Map m;
		int index;
		for (int i=0;i<mapPatterns.length();i++) 
		{ 
			m = mapPatterns[i]; 
			index = m.getInt("PatternIndex");
			if (index==nIndex)
			{	break;}
			else
				index = -1;
		}//next i
		if (index<0)
		{ 
			eraseInstance();
			return;
		}
		
		PlaneProfile pp = m.getPlaneProfile(kBoundary);
		Point3d ptm = m.getPoint3d("ptm");
		Point3d ptNodes[] = m.getPoint3dArray("Node[]");
		if (ptNodes.length()<1)
		{ 
			return;
		}		
		double dDiameter = m.getDouble("diameter");
		double dDepth = m.getDouble("depth");
		double dAngle = m.getDouble("angle");
		double dBevel = m.getDouble("bevel");
		
		int bIs2D = m.getInt("is2D");
		Vector3d vecA = bIs2D ? m.getVector3d("vecA") : m.getVector3d("vec");
		Vector3d vecB = m.getVector3d("vecB");	
		Vector3d vecAN = vecA; vecAN.normalize();
		Vector3d vecBN;
		if(bIs2D)
		{
			vecBN= vecB;
			vecBN.normalize();
			if (nDrag<0)_PtG.setLength(3);
		}
		
		if (!_bOnGripPointDrag)
		{ 
			if(bIs2D)_PtG.setLength(3);
			else _PtG.setLength(2);
			for (int i=0;i<_PtG.length();i++) 
				addRecalcTrigger(_kGripPointDrag, "_PtG"+i);
		}
	
		ptm.vis(6);


	// get closest node to mid point of pattern
		Point3d ptX = ptNodes.first();
		double dist = U(10e4);
		for (int p=0;p<ptNodes.length();p++) 
		{ 
			double d = Vector3d(ptm-ptNodes[p]).length();
			if (d<dist)
			{ 
				dist = d;
				ptX = ptNodes[p];
			}		 
		}//next p

	//region Local chain dims
		Vector3d vecDir = _XE;
		Vector3d vecPerp = _YE;
		Vector3d vecZ = _ZE;
		CoordSys cs (ptm, vecDir, vecPerp, vecZ);
		
		PlaneProfile ppCollisionLocal(cs);
	
		for (int ab=0;ab<(bIs2D?2:1);ab++) 
		{ 
			PlaneProfile ppTextArea(CoordSys(_Pt0, vecDir, vecPerp, vecZ));
			Vector3d vecAB = ab == 0 ? vecA : vecB;
			
			Point3d pts[] = Line(ptX, vecAB).filterClosePoints(ptNodes, dEps);	
			if (pts.length()>1)
			{ 
				Vector3d vecDimlineDir = vecAB; vecDimlineDir.normalize();
				Vector3d vecDimlinePerp= vecDimlineDir.crossProduct(-vecZ);
				
				ptX = pts[0];
				
				Point3d ptA = pts[0], ptB = pts[1];
				if (pts.length()>2)
				{ 
					Point3d ptRef = (_bOnGripPointDrag && nDrag == ab + 1) ? ptDrag : _PtG[ab + 1];
					ptRef.transformBy(ps2ms);
					
					int nearest;
					double dist = U(10e5);
					for (int i=0;i<pts.length()-1;i++) 
					{ 
						double d = abs(vecDimlineDir.dotProduct(ptRef - pts[i]));
						//reportMessage("\nd = " + d + " disr" + dist);
						if (d<dist)
						{ 
							dist = d;
							nearest = i;
							
						}
					}//next i
					//reportMessage("\nnearest = " +nearest);
					if (nearest>0)
					{ 
						ptA = pts[nearest];
						ptB = pts[nearest+1];
						ptX = ptA;
					}
				}					
				
				Point3d ptOrg =ptX + .6 * vecDimlinePerp * (dDiameter > dTextHeight ? dDiameter : dTextHeight);
				
				if (_bOnGripPointDrag && nDrag==ab+1)
				{ 
					ptOrg = ptDrag;
					ptOrg.transformBy(ps2ms);
				}				
				else if (!_bOnDbCreated)
				{ 
					ptOrg = _PtG[ab + 1];
					ptOrg.transformBy(ps2ms);
					ptOrg.vis(4);
				}				
				
				
				DimLine dl(ptOrg, vecDimlineDir, vecDimlinePerp);
				dl.setUseDisplayTextHeight(dTextHeight>0);
		
				Dim dim(dl,  "<>",  "<>", _kDimPar);
				dim.setReadDirection(vecReadDirection);
				dim.setDeltaOnTop(true);
				

				
				
				dim.append(ptA, "<>", "<>"); 
				dim.append(ptB, "<>", "<>"); 
				
				//dp.draw(dim);
				
			//Get range of this dim
				PLine plines[] = dim.getTextAreas(dp);
				for (int i=0;i<plines.length();i++) ppTextArea.joinRing(plines[i],_kAdd); 			
				PLine pl; pl.createRectangle(LineSeg(pts[0]- vecDimlinePerp*.5*textHeight, pts[1] + vecDimlinePerp*.5*textHeight), vecDimlineDir, vecDimlinePerp);
				pl.transformBy(vecDimlinePerp * vecDimlinePerp.dotProduct(dl.ptOrg() - pts[0]));
				ppTextArea.joinRing(pl,_kAdd);						
				ppTextArea.vis(4);							

			// offset dim if it intersects with collsion areas
				if (_bOnDbCreated)// || bDebug)
				{ 
					PlaneProfile ppt = ppTextArea;
					int cnt,bIntersect = ppt.intersectWith(ppCollisionArea);
					while (bIntersect && cnt<30)
					{ 
						cnt++;
						for (int p=0;p<2;p++) // try in both directions
						{ 
							Vector3d vec =(p==0?1:-1)* cnt * .5*vecDimlinePerp * textHeight;
							ppt = ppTextArea;
							ppt.transformBy(vec);	ppt.vis(cnt);
							bIntersect =ppt.intersectWith(ppCollisionArea);
							if (!bIntersect)
							{
								ptOrg.transformBy(vec);
								dim.transformBy(vec);
								ppTextArea.transformBy(vec);
							}						 
						}//next p
					}					
				}

				ppCollisionLocal.unionWith(ppTextArea);
				ppCollisionArea.unionWith(ppTextArea);
				
				dim.transformBy(ms2ps);
				dp.draw(dim);
				
				if (nDrag<0)
				{ 
					ptOrg += vecDimlineDir * vecDimlineDir.dotProduct(ptX - ptOrg);
					ptOrg.transformBy(ms2ps);
					ptOrg.vis(6);
					_PtG[ab + 1] = ptOrg;					
				}
				
				
			}						 
		}//next ab
			
	//endregion 

	//region Pattern Tag
		mapAdditional.setInt("Quantity", ptNodes.length());
		mapAdditional.setDouble("Radius", m.getDouble("Diameter")*.5);
		mapAdditional.setDouble("Diameter", m.getDouble("Diameter"));
		mapAdditional.setDouble("RadiusSink", 0);
		mapAdditional.setDouble("DiameterSink", 0);
		mapAdditional.setDouble("Depth", 0);
		mapAdditional.setDouble("DepthSink", 0);
		mapAdditional.setDouble("Bevel", 0);
		mapAdditional.setDouble("Rotation", 0);
		mapAdditional.setInt("PatternIndex", index);
		
		// pattern angle
		double dAngleA = vecAN.angleTo(vecDir);
		double dAngleB = bIs2D?vecBN.angleTo(vecDir):0;
		if (abs(dAngleA) > 90) dAngleA -= 90 * abs(dAngleA) / dAngleA;
		if (abs(dAngleB) > 90) dAngleB -= 90 * abs(dAngleB) / dAngleB;
		if (abs(dAngleA) > .1) 
			mapAdditional.setDouble("AngleA", dAngleA);
		if (abs(dAngleB) > .1) 
			mapAdditional.setDouble("AngleB", dAngleB);

		String tag = gb.formatObject(sFormatPattern, mapAdditional);
		
		double textLengthForStyle = dp.textLengthForStyle(tag, sDimStyle, textHeight);
		double textHeightForStyle = dp.textHeightForStyle(tag, sDimStyle, textHeight);
	
		Point3d ptTag = _PtG[0];
		ptTag.transformBy(ps2ms);
		if(_bOnDbCreated)
			ptTag = ptm;
		PlaneProfile tagBox; 
		tagBox.createRectangle(LineSeg(ptTag-vecXPS*.5*textLengthForStyle-vecYPS*.5*textHeightForStyle,
			ptTag+vecXPS*.5*textLengthForStyle+.5*vecYPS*textHeightForStyle), vecXPS, vecYPS );
		
	//region Find a proper location for the tag
	// first attempt is along the axis of the pattern, if this cannot find a solution daw along fibonacci spiral if intersection found
		PlaneProfile ppt = tagBox;
		int bIntersect = ppt.intersectWith(ppCollisionArea);
		
		// try axis placemnet
		int bFindLoc = (bDebug || _bOnDbCreated || _kNameLastChangedProp == sTextHeightName);
		if(bIntersect && bFindLoc)
		{ 
			Point3d pts[] =  { ptm};
			
		// vecA
			LineSeg seg = pp.extentInDir(vecAN);
			double dist = abs(vecAN.dotProduct(seg.ptEnd() - seg.ptStart()));			
			int n = textHeight>0? dist / textHeight:0;
			for (int i=0;i<n;i++) 
			{ 
				pts.append(ptm - vecAN * (i + 1) * textHeight);
				pts.append(ptm + vecAN * (i + 1) * textHeight);			
			}//next i
		// vecB
			if (bIs2D)
			{ 
				LineSeg seg = pp.extentInDir(vecBN);
				double dist = abs(vecBN.dotProduct(seg.ptEnd() - seg.ptStart()))*.5;			
				int n = textHeight>0? dist / textHeight:0;
				for (int i=0;i<n;i++) 
				{ 
					pts.append(ptm - vecBN * (i + 1) * .5*textHeight);
					pts.append(ptm + vecBN * (i + 1) * .5*textHeight);			
				}//next i				
			}
			

			for (int j=0;j<pts.length();j++) 
			{ 
				ppt = tagBox;
				ppt.transformBy(pts[j] - ppt.ptMid());	//ppt.vis(j);
				bIntersect = ppt.intersectWith(ppCollisionArea);
				if (!bIntersect)
				{
					tagBox.transformBy(pts[j] - tagBox.ptMid());
					ptTag = tagBox.ptMid();
					break;
				}							
				pts[j].vis(1);
			}
		}
		tagBox.vis(4);
		
		// try fibonacci
		if(bIntersect && bFindLoc)				
		{ 
			double dSize = textHeight;
			double dMaxSize = .6*(pp.dX()>pp.dY()?pp.dX():pp.dY());
			int num = dMaxSize / dSize * 4 + 1;					
		
			Point3d pt = ptm;
			CoordSys csRot; 
			csRot.setToRotation(90, vecZ, pt);
		
			Point3d pts[0];
			for (int j=1;j<num;j++) 
			{ 
				double d = (j - 1 + j) * dSize/8;
				pt -= vecX * d;		
				if (j==1)pts.append(pt + vecX * d);
				pt = pt + vecY * d;
				pts.append(pt);
				vecX.transformBy(csRot);		vecY.transformBy(csRot);	 
			}//next 0
			
			PLine pl(vecZ);
			if (pts.length()>0)pl.addVertex(pts[0]);
			for (int i=1;i<pts.length();i++) 
				pl.addVertex(pts[i], tan(22.5));
		
		// collect equidistant points
			int n = pl.length() / dSize+1;	
			Point3d ptsIn[0], ptsOut[0];
			for (int j=0;j<n;j++) 
			{ 
				Point3d x=pl.getPointAtDist(j*dSize); 		
				if (pp.pointInProfile(x) == _kPointInProfile)
				{
					if (ppCollisionArea.pointInProfile(x) == _kPointInProfile){ continue;}
					ptsIn.append(x);
					x.vis(252);
				}
				else
					ptsOut.append(x);			
			}//next j
			
		// first attempt is to snap locations withing the pattern boundaries	
			for (int j=0;j<ptsIn.length();j++) 
			{ 
				ppt = tagBox;
				ppt.transformBy(ptsIn[j] - ppt.ptMid());	//ppt.vis(j);
				bIntersect = ppt.intersectWith(ppCollisionArea);
				if (!bIntersect)
				{
					tagBox.transformBy(ptsIn[j] - tagBox.ptMid());
					ptTag = tagBox.ptMid();
					break;
				}							
				//ptsIn[j].vis(1);
			}
			
		// second attempt snap to any closest on fibonacci	
			if (bIntersect)
			for (int j=0;j<ptsOut.length();j++) 
			{ 
				ppt = tagBox;
				ppt.transformBy(ptsOut[j] - ppt.ptMid());	//ppt.vis(j);
				bIntersect = ppt.intersectWith(ppCollisionArea);
				if (!bIntersect)
				{
					tagBox.transformBy(ptsOut[j] - tagBox.ptMid());
					ptTag = tagBox.ptMid();	
					break;
				}							
				//ptsOut[j].vis(1);
			}			

//					for (int i=0;i<ptsOut.length();i++) 	
//						ptsOut[i].vis(i);
		
		
			//pl.vis(4);	
		}		
	//End Create fibonacci spiral//endregion 	

	// Leader Line
		if (pp.pointInProfile(ptTag)!=_kPointInProfile)
		{ 
			PlaneProfile box = tagBox;
			box.shrink(-.25 * textHeight);
			Point3d pt1 = pp.closestPointTo(ptTag);
			Point3d pt2 = box.closestPointTo(pt1);
			pt1.transformBy(ms2ps);
			pt2.transformBy(ms2ps);
			
			pt1.vis(3);				pt2.vis(4);
			pp.vis(3);
			PLine pl(pt1, pt2);
			if (pl.length()>2*dTextHeight)
				dp.draw(pl);
		}
	
		ppCollisionArea.unionWith(tagBox);		
		ptTag.transformBy(ms2ps);
		dp.draw(tag, ptTag, vecXPS, vecYPS,0,0);
		
	// show pattern range during drag	
		if (nDrag>-1)
		{ 
			pp.transformBy(ms2ps);
			dp.trueColor(darkyellow, 80);
			dp.draw(pp);
		}
		
		
		
		if (!bDebug && !_bOnGripPointDrag)
		{
			_PtG[0] = ptTag;
		}		
	
		//tagBox.vis(2);

	//endregion 
		sFormatPattern.setDefinesFormatting(GenBeam(),mapAdditional);
		
	}
//endregion 

//region Snap to sequence grid on creation
	int nUpdateLocation =_Map.getInt("updateLocation") || (_bOnDbCreated || bDebug || _bOnRecalc);
	TslInst nextClient;
	if (!vecPerp.bIsZeroLength() && (mode==3 || mode==4) && nUpdateLocation>0)
	{ 
		if (_PtG.length() < 1)_PtG.append(_Pt0);

	// the remote update location needs to execution loops to get new location
		if (nUpdateLocation>0)
		{ 
			nUpdateLocation++;
			_Map.setInt("updateLocation", nUpdateLocation);
			if (nUpdateLocation>2)
				_Map.removeAt("updateLocation", true);
		}
		
		Point3d pts[0];
		TslInst lastClient;
		int sequenceLast, sequenceNext;
		for (int i=0;i<clients.length();i++) 
		{ 
			TslInst& t = clients[i];
			if (t==_ThisInst){ continue;}
			Map m= t.map();
			int sequenceClient = m.getInt("sequenceNumber");
			Vector3d vecPerpClient = m.getVector3d("vecPerp");
			
			if (!vecPerpClient.isCodirectionalTo(vecPerp) ||sequenceClient<=0){ continue;}
			if (sequenceNumber<sequenceClient)
			{
				if (sequenceNext==0 || sequenceClient<sequenceNext)
				{
					sequenceNext = sequenceClient;
					nextClient = t;
				}
				continue;
			}
			if (sequenceLast<sequenceClient)
			{
				sequenceLast = sequenceClient;
				lastClient = t;
			}
			Point3d pt = t.gripPoint(0);				
			pts.append(pt);
		}//next i
		
	// snap to last client
		if (lastClient.bIsValid() && lastClient.map().hasPlaneProfile("ppTextArea"))
		{ 
			PlaneProfile ppTextArea = lastClient.map().getPlaneProfile("ppTextArea");
			ppCollisionArea.unionWith(ppTextArea);
			ppTextArea.vis(1);				
		}
	
	
		if (ppCollisionArea.area()>pow(dEps,2))
		{ 
		// get extents of profile
			LineSeg seg = ppCollisionArea.extentInDir(vecX);
			double dPerp = abs(vecPerp.dotProduct(seg.ptStart()-seg.ptEnd()));

			Point3d pt = ppCollisionArea.ptMid() + vecPerp * (textHeight + .5 * dPerp); 
			pt.transformBy(ms2ps);
			_PtG[0] += vecPerp * vecPerp.dotProduct(pt - _PtG[0]);
			//_PtG[0].vis(6);			
		}
	}	
//endregion 

//region Pattern Dimline Mode
	if (mode==3 && !vecPerp.bIsZeroLength())
	{ 
		if (bLogger)reportNotice("\n"+ _ThisInst.handle() + " dimline mode starting ");
		sFormatPattern.setReadOnly(_kHidden);
		
		Vector3d vecDir = vecPerp.crossProduct(vecZ);
		
		if (mp.bIsValid()) // left2right and bottom2top orientation
		{ 
			Vector3d vec = vecDir;
			vec.transformBy(ms2ps);
			if (vec.isParallelTo(_XW) && !vec.isCodirectionalTo(_XW))vecDir*=-1;
			else if (vec.isParallelTo(_YW)&& !vec.isCodirectionalTo(_YW))vecDir*=-1;
		}	
		
		int nDimLineGroupIndex = _Map.getInt("DimlineGroupIndex");
		
	// collect all patterns with this perp direction
		Map patterns[0];
		for (int i=0;i<mapPatterns.length();i++) 
		{ 
			Map m= mapPatterns[i]; 
			if ( !vecPerp.isCodirectionalTo(m.getVector3d("vecPerp"))){continue;}	
			if ( nDimLineGroupIndex!=m.getInt("GroupIndex")){continue;}	
			patterns.append(m);
		}//next i
		
		
		if (patterns.length()<1)
		{ 
			if (bDebug) reportMessage(TN("|No patterns found for perpendicular direction| ") + vecPerp);
			eraseInstance();
			return;
		}
		
	// order by dimline direction offset
		for (int i=0;i<patterns.length();i++) 
			for (int j=0;j<patterns.length()-1;j++) 
			{
				double d1 = vecDir.dotProduct(patterns[j].getPoint3d("ptm") - ptCen);
				double d2 = vecDir.dotProduct(patterns[j+1].getPoint3d("ptm") - ptCen);
				
				if (d1>d2)
					patterns.swap(j, j + 1);
			}


		Vector3d vecDimlineDir = vecDir; vecDimlineDir.normalize();
		Vector3d vecDimlinePerp = vecDimlineDir.crossProduct(-vecZ);
		int deltaOnTop = vecReadDirection.dotProduct(vecPerp) > 0;
		if (bDeltaOnTop)deltaOnTop =! deltaOnTop;
		
		Point3d ptOrg = _PtG[0];
		ptOrg.transformBy(ps2ms);
		
		
		DimLine dl(ptOrg, vecDimlineDir, vecDimlinePerp);
		dl.setUseDisplayTextHeight(dTextHeight > 0);
		Point3d ptRefs[0];
		Dim dim(dl,ptRefs, " <> ", " <> ", nDeltaMode, nChainMode);
		dim.setReadDirection(vecReadDirection);
		dim.setDeltaOnTop(deltaOnTop);

	//region Append reference points
		
		for (int i=0;i<segs.length();i++) 
		{ 
			LineSeg seg= segs[i]; 
			Vector3d vecXS = seg.ptEnd() - seg.ptStart();
			Vector3d vecYS = vecXS.crossProduct(vecZ);
			if (vecYS.dotProduct(vecPerp)>0)
			{
				ptRefs.append(seg.ptStart());
				ptRefs.append(seg.ptEnd());
				//seg.transformBy(vecZT * U(20)); seg.vis(i);
			} 
		}//next i
		ptRefs = Line(ptCen, vecDimlineDir).orderPoints(ptRefs, dEps);	
		
	// project to offseted outline	
		for (int i=0;i<ptRefs.length();i++) 
		{ 
			Point3d pts[]=  Line(_Pt0, - vecPerp).orderPoints(ppSnap.intersectPoints(Plane(ptRefs[i], vecDir), true, false));
			if (pts.length()>0)
				ptRefs[i] = pts.first();
		}//next i					

		if (ptRefs.length()>1)
			dim.append(ptRefs.first(), "<>", " "); 
	//endregion 

	// collect extreme nodes per pattern
		Point3d pts[0];
		PlaneProfile pps[0]; String uids[0]; // keep in sync

		for (int i=0;i<patterns.length();i++) 
		{ 
			Map m = patterns[i];
			int bIs2D = m.getInt("is2D");
			Vector3d vecA = bIs2D ? m.getVector3d("vecA") : m.getVector3d("vec");			
			Vector3d vecB = m.getVector3d("vecB");					
			Point3d ptNodes[0];//=m.getPoint3dArray("Node[]");
			double diameter = m.getDouble(kDiameter);
			double diameterSink = m.getDouble("DiameterSink");
			double depthSink = m.getDouble("DepthSink");
			
			if (depthSink > 0 && diameterSink > diameter)diameter = diameterSink;
			
			double a = m.getVector3d("vecA").length();
			double b = m.getVector3d("vecB").length();
			a = a > diameter ? a - diameter : a;
			b = b > diameter ? b - diameter : b;					
			double blowUp = (b>0 && b<a?b:a) * -.2;
	
			Map locations = m.getMap("locations");
			
			for (int j=0;j<locations.length();j++) 
			{ 
				String uid = locations.getString(j); 
				for (int x=0;x<mapLocations.length();x++) 
				{ 
					Map ml = mapLocations.getMap(x); 
					if (ml.getString(kUID)==uid)
					{ 
						PlaneProfile pp = ml.getPlaneProfile("pp");
						pp.shrink(blowUp);
						pp.transformBy(ms2ps);
						pps.append(pp);
						uids.append(uid);
						ptNodes.append(ml.getPoint3d("pt"));
						break;
					}				 
				}//next jj			
			}//next j
			pts.append(ptNodes);
//			for (int p=0;p<ptNodes.length();p++) 
//			{ 
//				PLine circ; circ.createCircle(ptNodes[p],vecZ, diameter*.5);
//				circ.convertToLineApprox(dEps);
//				PlaneProfile pp(circ);
//				pp.shrink(blowUp);
//				pp.transformBy(ms2ps);
//				pps.append(pp);	
//			}//next p	

			mapAdditional.setInt("Quantity", ptNodes.length());
			mapAdditional.setDouble("Radius", m.getDouble("Diameter")*.5);
			mapAdditional.setDouble("Diameter", m.getDouble("Diameter"));
			mapAdditional.setDouble("RadiusSink", 0);
			mapAdditional.setDouble("DiameterSink", 0);
			mapAdditional.setDouble("Depth", 0);
			mapAdditional.setDouble("DepthSink", 0);
			mapAdditional.setDouble("Bevel", 0);
			mapAdditional.setDouble("Rotation", 0);
			mapAdditional.setInt("PatternIndex", m.getInt("PatternIndex"));	
			mapAdditional.setInt("groupIndex", m.getInt("groupIndex"));	
			
			String deltaText = gb.formatObject(sDeltaFormat, mapAdditional);
			if (deltaText.length() < 1)deltaText = "<>";
			
			ptNodes = Line(_Pt0, vecDimlineDir).orderPoints(ptNodes, dEps);
			if (ptNodes.length()>1)
			{ 	
				Point3d pt1 = ptNodes.first();
				Point3d pt2 = ptNodes.last();
				if (abs(vecDimlineDir.dotProduct(pt1-pt2))>dEps)
				{ 
					pt2.vis(i);
					dim.append(pt1, deltaText, "<>");
					dim.append(pt2, "<>", "<>");
				}
				else
					dim.append(pt2, "<>", "<>");
				pt1.vis(i);

			}
		}//next i

		if (ptRefs.length()>1)
		{
			pts.append(ptRefs);
			dim.append(ptRefs.last(), "<>", "<>"); 
		}



	//Store range of dim
		{ 
			Line ln(ptOrg, vecDir);
			pts =ln.orderPoints(ln.projectPoints(pts), dEps);
			PlaneProfile ppTextArea(CoordSys(ptOrg, vecDir, vecPerp, vecDir.crossProduct(vecPerp)));
			PLine plines[] = dim.getTextAreas(dp);
			for (int i=0;i<plines.length();i++) ppTextArea.joinRing(plines[i],_kAdd); 			
			PLine pl; 
			if (pts.length()>0)
			{ 
				pl.createRectangle(LineSeg(pts.first()- vecPerp*.5*textHeight, pts.last() + vecPerp*.5*textHeight), vecDir, vecPerp);
				pl.transformBy(vecPerp * vecPerp.dotProduct(dl.ptOrg() - pts[0]));
				ppTextArea.joinRing(pl,_kAdd);					
			}
					
			ppTextArea.vis(4);	
			_Map.setPlaneProfile("ppTextArea", ppTextArea);
		}
	



		dim.transformBy(ms2ps);
		dp.draw(dim);

	
		//dp.draw(scriptName() + " ("+patterns.length()+")", _PtG[0], vecDir, vecPerp, 1, 0);		

		_ThisInst.setAllowGripAtPt0(false);
		sDeltaFormat.setDefinesFormatting(GenBeam(),mapAdditional);
		
	
	//region Trigger RemoveDrill
		String sTriggerRemoveDrill = T("|Remove Drills|");
		addRecalcTrigger(_kContextRoot, sTriggerRemoveDrill );
		if (_bOnRecalc && _kExecuteKey==sTriggerRemoveDrill)
		{
			PlaneProfile ppRemovals[0]; String uidRemovals[0];
			int bCreateFreeDimline = true;
			
		//region Show Jig
		 	PrPoint ssP(T("|Select drills, [New/Add] dimline|"));
		 	ssP.setSnapMode(TRUE, 0); // turn off all snaps
		 	
		 	Map mapArgs;
		 	mapArgs.setVector3d("vecDir", vecDir);
			mapArgs.setVector3d("vecPerp", vecPerp);
			mapArgs.transformBy(ps2ms);		
		 	mapArgs.setPoint3d("ptLoc", _PtG[0]); // location of dimline
			mapArgs.setInt(kDimlineGroupIndex,nDimLineGroupIndex);
    		{ 
        		Map m;
        		for (int j=0;j<pps.length();j++) 
        			m.appendPlaneProfile("pp",pps[j]); 
        		mapArgs.setMap("pps", m);			        			
    		}

			int nGoJig = -1;
			Point3d ptFences[0];			
			while (nGoJig != _kNone)//nGoJig != _kOk && 
			{
			    nGoJig = ssP.goJig(kJigAddRemove, mapArgs); 
			    if (nGoJig == _kOk)
			    {
			        Point3d ptPick = ssP.value(); //retrieve the selected point
			        //ptPick += vecZ * vecZ.dotProduct(_Pt0 - ptPick);

			        PlaneProfile ppFence;
			        if (ptFences.length()>0)
			        {
			        	int fenceMode = vecXView.dotProduct(ptPick - ptFences.first()) > 0?-1:1;			        	
			        	ppFence.createRectangle(LineSeg(ptFences.first(), ptPick),vecXView, vecYView);
			        	ptFences.setLength(0);
			        	mapArgs.removeAt("ptFence", true);
			        	for (int i=pps.length()-1; i>=0 ; i--) 
			        	{ 
			        		PlaneProfile pp = pps[i];
			        		String uid = uids[i];
			        		PlaneProfile ppTest = pp;
			        		int bIntersect = ppTest.intersectWith(ppFence);
							if (bIntersect && (fenceMode==1 || (fenceMode==-1 && abs(ppTest.area()-pp.area())<pow(dEps,2))))
							{
								ppRemovals.append(pp);
								uidRemovals.append(uid);
								pps.removeAt(i);
							}
			        	}
			        }
			        else
			        { 
			        	int bFound;
				        for (int i=pps.length()-1; i>=0 ; i--) 
				        { 
				       		PlaneProfile pp = pps[i]; 
				       		String uid = uids[i];
							if (pp.pointInProfile(ptPick)!=_kPointOutsideProfile)
							{
				        		bFound = true;
				        		ppRemovals.append(pp);
				        		uidRemovals.append(uid);
				        		pps.removeAt(i);
				        	}		 
				        }//next i
				        
				        if (!bFound)
				        { 
				        	ptFences.append(ptPick);	
							mapArgs.setPoint3d("ptFence", ptPick);
				        }
				        
			        }
					{ 
		        		Map m;
		        		for (int j=0;j<ppRemovals.length();j++) 
		        			m.appendPlaneProfile("pp",ppRemovals[j]); 
		        		mapArgs.setMap("ppRemoval[]", m);			        			
	        		}
	        		{ 
		        		Map m;
		        		for (int j=0;j<pps.length();j++) 
		        			m.appendPlaneProfile("pp",pps[j]); 
		        		mapArgs.setMap("pps", m);			        			
	        		}	
			    }
//			    else if (nGoJig == _kKeyWord)
//			    { 
//			        if (ssP.keywordIndex() == 0)
//			            mapArgs.setInt("isLeft", TRUE);
//			        else 
//			            mapArgs.setInt("isLeft", FALSE);
//			    }
			    else if (nGoJig == _kCancel)
			    { 
			       break;
			    }
			}			
			
			ssP.setSnapMode(false, 0); // turn on all snaps	
		//End Show Jig//endregion 

			if (server.bIsValid() && uidRemovals.length()>0)
    		{ 
    			if (bLogger)reportNotice("\n"+ _ThisInst.handle() + " updating server with removals ");
        		Map mapServer = server.subMapX("RemovedLocation[]");
        		Map m;
        		for (int j=0;j<uidRemovals.length();j++) 
        		{
        			m.appendString("LocId", uidRemovals[j]);
        			mapServer.appendString("LocId", uidRemovals[j]);
        		}
        		server.setSubMapX("RemovedLocation[]", mapServer);	
        		server.recalcNow();
        		
        	// create new free dimline
        		setCatalogFromPropValues(sLastInserted);
    		// create TSL
    			TslInst tslNew;				Map mapTsl;
    			int bForceModelSpace = true;	
    			String sExecuteKey,sCatalogName = sLastInserted;
    			String sEvent="OnDbCreated"; // "OnElementConstructed", "OnRecalc", "OnMapIO"...

				GenBeam gbsTsl[] = {};		Entity entsTsl[] = {entDefine};			Point3d ptsTsl[] = {ptOrg+vecPerp * 2 * textHeight};
				ptsTsl[0].transformBy(ms2ps);
				
				mapTsl.setInt("mode", 4); // loose mode
				mapTsl.setVector3d(kAllowedView, vecAllowedView);
				mapTsl.setVector3d("vecPerp", vecPerp);
				mapTsl.setMap("CustomLocation[]", m);
				mapTsl.setMap("Pattern[]", mapPatternsX);
				if (server.bIsValid())
					mapTsl.setEntity("patternServer", server);
				tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, sCatalogName, bForceModelSpace, mapTsl, sExecuteKey, sEvent); 		
			


    		}
	
			setExecutionLoops(2);
			return;
		}//endregion	
	
	}
//endregion 

//region Loose Dimline Mode
	else if (mode==4 && !vecPerp.bIsZeroLength())
	{
		Vector3d vecDir = vecPerp.crossProduct(vecZ);
		if (mp.bIsValid()) // left2right and bottom2top orientation
		{ 
			Vector3d vec = vecDir;
			vec.transformBy(ms2ps);
			if (vec.isParallelTo(_XW) && !vec.isCodirectionalTo(_XW))vecDir*=-1;
			else if (vec.isParallelTo(_YW)&& !vec.isCodirectionalTo(_YW))vecDir*=-1;
		}
		if (_PtG.length() < 1)_PtG.append(_Pt0);
		Point3d ptOrg = _PtG[0];
		
		vecDir.vis(ptOrg, sequenceNumber);
		vecPerp.vis(ptOrg, 3);
		ptOrg.transformBy(ps2ms);
	
	// disable format property
		if (_bOnDbCreated)sDeltaFormat.set("<>");
		sDeltaFormat.setReadOnly(bDebug?false:_kHidden);
		sFormatPattern.setReadOnly(bDebug?false:_kHidden);
		dMaxInterdistance.setReadOnly(bDebug?false:_kHidden);

		int bAddLoose = _Map.getInt("AddLoose");
	
	// get custom locations
		Map mapCustomLocations = _Map.getMap("CustomLocation[]");
		PlaneProfile pps[0];
		Point3d ptNodes[0];
		
		String uids[0];
		for (int i=0;i<mapCustomLocations.length();i++) 
			uids.append(mapCustomLocations.getString(i));

		for (int i=0;i<mapLocations.length();i++) 
		{ 
			Map m = mapLocations.getMap(i);
			if (uids.findNoCase(m.getString(kUID),-1)>-1)
			{ 
//				PlaneProfile pp = m.getPlaneProfile("pp");
//				//pp.shrink(blowUp);
//				pp.transformBy(ms2ps);
//				pps.append(pp);
				ptNodes.append(m.getPoint3d("pt"));				
			}			 
		}//next jj			
		
	// get custom points	
		Map mapCustomPoints = _ThisInst.subMapX("CustomPoint[]");
		Point3d ptCustomPoints[0];
		for (int i=0;i<mapCustomPoints.length();i++) 
		{ 
			if (mapCustomPoints.hasVector3d(i))
			{ 
				Vector3d vec = mapCustomPoints.getVector3d(i);
				Point3d pt = gb.ptRef() + vec;
				ptCustomPoints.append(pt); 
			}		
		}//next i
		
	// Get loose locations
		if (bAddLoose)
			for (int i=0;i<mapLooseLocations.length();i++) 
			{ 
				Map m = mapLooseLocations.getMap(i);
				int quadrant = m.getInt("Quadrant");
				Vector3d vecA = m.getVector3d("vecA");
				Vector3d vecB = m.getVector3d("vecB");
				Point3d pt = m.getPoint3d("pt");
				vecA.vis(pt, quadrant);
				vecB.vis(pt, quadrant);
				
				if (vecA.isCodirectionalTo(vecPerp) || vecB.isCodirectionalTo(vecPerp))
				{ 
					ptNodes.append(pt);				
				}			 
			}//next jj			
			
	// create grips for custom grip points	
		if (_PtG.length()-1!=ptCustomPoints.length())
		{ 
			_PtG.setLength(1); // the dimline location is grip 0
			for (int i=0;i<ptCustomPoints.length();i++) 
			{ 
				Point3d pt= ptCustomPoints[i];
				pt.transformBy(ms2ps);
				_PtG.append(pt); 
				addRecalcTrigger(_kGripPointDrag, "_PtG"+(i+1));
			}//next i
		}
	// update custom points if a grip was dragged
		else if (_kNameLastChangedProp.find("_PtG",0, false)==0 && _kNameLastChangedProp!="_PtG0")
		{ 
			int n = _kNameLastChangedProp.right(_kNameLastChangedProp.length() - 4).atoi();
			
			if (n>0)
			{ 
				if (bDebug) reportMessage("\nupdating grip "+n);
				
				Point3d pt = _PtG[n];
				pt.transformBy(ps2ms);
				Vector3d vecOrg = pt-gb.ptRef();
				mapCustomPoints.removeAt(n - 1,true);
				mapCustomPoints.appendVector3d("vecOrg", vecOrg);
				_ThisInst.setSubMapX("CustomPoint[]", mapCustomPoints);
				_PtG.setLength(1); // this will force the repos
				setExecutionLoops(2);
				return;
			}	
		}
		
		
		
		ptNodes.append(ptCustomPoints);
		ptNodes = Line(_Pt0, vecDir).orderPoints(ptNodes, dEps);
	
		Vector3d vecDimlineDir = vecDir; vecDimlineDir.normalize();
		Vector3d vecDimlinePerp = vecDimlineDir.crossProduct(-vecZ);
		int deltaOnTop = vecReadDirection.dotProduct(vecPerp) > 0;
		if (bDeltaOnTop)deltaOnTop =! deltaOnTop;
		
		DimLine dl(ptOrg, vecDimlineDir, vecDimlinePerp);
		dl.setUseDisplayTextHeight(dTextHeight > 0);
		
		Point3d ptRefs[0]; // use empty array as constructor
		Dim dim(dl, ptRefs, "<>", "<>", nDeltaMode, nChainMode);
		dim.setReadDirection(vecReadDirection);
		dim.setDeltaOnTop(deltaOnTop);
		
	//region Append reference points	
		for (int i=0;i<segs.length();i++) 
		{ 
			LineSeg seg= segs[i]; 
			Vector3d vecXS = seg.ptEnd() - seg.ptStart();
			Vector3d vecYS = vecXS.crossProduct(vecZ);
			if (vecYS.dotProduct(vecPerp)>0)
			{
				ptRefs.append(seg.ptStart());
				ptRefs.append(seg.ptEnd());
				//seg.transformBy(vecZT * U(20)); seg.vis(i);
			} 
		}//next i
		ptRefs = Line(ptCen, vecDimlineDir).orderPoints(ptRefs, dEps);	
		
	// project to offseted outline	
		for (int i=0;i<ptRefs.length();i++) 
		{ 
			Point3d pts[]=  Line(_Pt0, - vecPerp).orderPoints(ppSnap.intersectPoints(Plane(ptRefs[i], vecDir), true, false));
			if (pts.length()>0)
				ptRefs[i] = pts.first();
		}//next i					

		if (ptRefs.length()>1)
			dim.append(ptRefs.first(), "<>", " "); 
	//endregion 		
	
	// Append Drill Locations
		for (int i=0;i<ptNodes.length();i++) 
			dim.append(ptNodes[i], "<>", "<>"); 

		if (ptRefs.length()>1)
			dim.append(ptRefs.last(), "<>", "<>"); 

		dim.transformBy(ms2ps);
		dp.draw(dim);	
		//dp.draw(scriptName(), _Pt0, _XW, _YW, 1, 0);


	//region Trigger AddPoints
		String sTriggerAddPoints = T("|Add Points|");
		addRecalcTrigger(_kContextRoot, sTriggerAddPoints );
		if (_bOnRecalc && _kExecuteKey==sTriggerAddPoints)
		{
			Point3d pts[0];
			pts.append(ptNodes);
			pts.append(ptRefs);
			pts = Line(_Pt0, vecDir).orderPoints(pts, dEps);	
			
			Map mapArgs;
		 	mapArgs.setVector3d("vecDir", vecDir);
			mapArgs.setVector3d("vecPerp", vecPerp);	
			mapArgs.setPoint3dArray("pts", pts);
			mapArgs.transformBy(ms2ps);		
		 	mapArgs.setPoint3d("ptLoc", _PtG[0]); // location of dimline
		 	
			
			mapArgs.setString("dimStyle", sDimStyle);
			mapArgs.setDouble("textHeight", textHeight);
			mapArgs.setDouble("scale", scale);
			mapArgs.setInt("deltaMode", _kDimPar);
			mapArgs.setInt("deltaOnTop", true);

			String prompt = T("|Pick points|");
			PrPoint ssP(prompt);	
			int nGoJig = -1;
			while (nGoJig != _kNone)// && nGoJig != _kOk
			{
				nGoJig = ssP.goJig(kAddPoints, mapArgs);
			
				if (nGoJig == _kOk)//Jig: point picked
				{
					Point3d pt = ssP.value();
					
					// get points in paperspace
					Point3d _pts[]=mapArgs.getPoint3dArray("pts");
					_pts.append(pt);
					
					pt.transformBy(ps2ms);
					Vector3d vecOrg = pt - gb.ptRef();
					int bAdd = true;
	 
					mapArgs.setPoint3dArray("pts", _pts);

					if (bAdd)
					{ 
						mapCustomPoints.appendVector3d("vecOrg", vecOrg);
						_ThisInst.setSubMapX("CustomPoint[]", mapCustomPoints);
					}				 		
				} 			
			// Jig: cancel
				else if (nGoJig == _kCancel)
				{
					break;
				}
			}				
	
			setExecutionLoops(2);
			return;
		}//endregion	
	
	//region Trigger RemovePoints
		String sTriggerRemovePoints = T("|Remove Points|");
		addRecalcTrigger(_kContextRoot, sTriggerRemovePoints );
		if (_bOnRecalc && _kExecuteKey==sTriggerRemovePoints)
		{
			Map mapArgs;
			
			Point3d pts[0];
			pts.append(ptCustomPoints);

			PlaneProfile pps[0], ppRemovals[0];
			{ 
				double maxDiam = U(100);
				double diam = dViewHeight / 100;
				diam = diam > maxDiam ? maxDiam : diam;
				for (int i=0;i<pts.length();i++) 
				{ 
					PLine circle;
					circle.createCircle(pts[i], vecZ,diam) ; 
					circle.convertToLineApprox(dEps);
					PlaneProfile pp(circle);
					pp.transformBy(ms2ps);
					pps.append(pp);
				}//next i	
			}

		 	mapArgs.setVector3d("vecDir", vecDir);
			mapArgs.setVector3d("vecPerp", vecPerp);
			mapArgs.transformBy(ps2ms);	
		    // update jig arguments    
    		{ 
        		Map m;
        		for (int j=0;j<pps.length();j++) 
        			m.appendPlaneProfile("pp",pps[j]); 
        		mapArgs.setMap("pps", m);			        			
    		}				
			
		 	mapArgs.setPoint3d("ptLoc", _PtG[0]); // location of dimline
			mapArgs.setPoint3dArray("pts", pts); // location of dimline
			mapArgs.setString("dimStyle", sDimStyle);
			mapArgs.setDouble("textHeight", textHeight);
			mapArgs.setDouble("scale", scale);
			mapArgs.setInt("deltaMode", _kDimPar);
			mapArgs.setInt("deltaOnTop", true);

			String prompt = T("|Pick points|");
			PrPoint ssP(prompt);	
			ssP.setSnapMode(TRUE, 0); // turn off all snaps
			
			int nGoJig = -1;
			Point3d ptFences[0];
			while (nGoJig != _kNone)// && nGoJig != _kOk
			{
				nGoJig = ssP.goJig(kJigAddRemove, mapArgs);
			
				if (nGoJig == _kOk)//Jig: point picked
				{
					Point3d ptPick = ssP.value();
				  	ptPick += vecZ * vecZ.dotProduct(_Pt0 - ptPick);
					PlaneProfile ppFence;
					
			        if (ptFences.length()>0)
			        {
			        	int fenceMode = vecXView.dotProduct(ptPick - ptFences.first()) > 0?-1:1;			        	
			        	ppFence.createRectangle(LineSeg(ptFences.first(), ptPick),vecXView, vecYView);
			        	ptFences.setLength(0);
			        	mapArgs.removeAt("ptFence", true);
			        	for (int i=pps.length()-1; i>=0 ; i--) 
			        	{ 
			        		PlaneProfile pp = pps[i];
			        		PlaneProfile ppTest = pp;
			        		int bIntersect = ppTest.intersectWith(ppFence);
							if (bIntersect && (fenceMode==1 || (fenceMode==-1 && abs(ppTest.area()-pp.area())<pow(dEps,2))))
							{
								ppRemovals.append(pp);
								pps.removeAt(i);
								ptCustomPoints.removeAt(i);
							}
			        	}
			        } 
			        else
			        { 
			        	Point3d ptPickPS = ptPick;
			        	ptPickPS.transformBy(ms2ps);
			        	int bFound;
				        for (int i=pps.length()-1; i>=0 ; i--) 
				        { 
				       		PlaneProfile pp = pps[i]; 
							if (pp.pointInProfile(ptPickPS)!=_kPointOutsideProfile)
							{
				        		bFound = true;
				        		ppRemovals.append(pp);
				        		pps.removeAt(i);
				        		ptCustomPoints.removeAt(i);
				        	}		 
				        }//next i
				        
				        if (!bFound)
				        { 
				        	ptFences.append(ptPick);	
							mapArgs.setPoint3d("ptFence", ptPick);
				        }			        	
			        }
			        
			    // update jig arguments    
					{ 
		        		Map m;
		        		for (int j=0;j<ppRemovals.length();j++) 
		        			m.appendPlaneProfile("pp",ppRemovals[j]); 
		        		mapArgs.setMap("ppRemoval[]", m);			        			
	        		}
	        		{ 
		        		Map m;
		        		for (int j=0;j<pps.length();j++) 
		        			m.appendPlaneProfile("pp",pps[j]); 
		        		mapArgs.setMap("pps", m);			        			
	        		}			        
 
				} 			
			// Jig: cancel
				else if (nGoJig == _kCancel)
				{
					break;
				}
			}
			ssP.setSnapMode(false, 0);
			
			
		// rewrite custom points
			mapCustomPoints = Map();
			//reportMessage("\nptCustomPoints " + ptCustomPoints.length() + " " +ptCustomPoints);
			for (int i=0;i<ptCustomPoints.length();i++) 
			{ 
				Point3d pt = ptCustomPoints[i]; 
				//pt.transformBy(ps2ms);
				Vector3d vecOrg = pt - gb.ptRef();
				mapCustomPoints.appendVector3d("vecOrg", vecOrg);
			}//next i
			if (mapCustomPoints.length()<1)
				_ThisInst.removeSubMapX("CustomPoint[]");	
			else
				_ThisInst.setSubMapX("CustomPoint[]", mapCustomPoints);	
			
			setExecutionLoops(2);
			return;
		}//endregion	
	



	//region Trigger AddDrills
		String sTriggerAddDrills = T("|Add Drills|");
		addRecalcTrigger(_kContextRoot, sTriggerAddDrills );
		if (_bOnRecalc && _kExecuteKey==sTriggerAddDrills)
		{
			PlaneProfile ppRemovals[0];
			int bCreateFreeDimline = true;
			
		//region Show Jig
		 	PrPoint ssP(T("|Select drills [New/Add]|")); // second argument will set _PtBase in map
		 	ssP.setSnapMode(TRUE, 0); // turn off all snaps
		 	
		 	Map mapArgs;
		 	mapArgs.setVector3d("vecDir", vecDir);
			mapArgs.setVector3d("vecPerp", vecPerp);
			mapArgs.transformBy(ps2ms);		
		 	mapArgs.setPoint3d("ptLoc", _PtG[0]); // location of dimline
			
			//mapArgs.setInt(kDimlineGroupIndex,nDimLineGroupIndex);
			PlaneProfile pps[0];
			int uids[0];


			int nGoJig = -1;
			Point3d ptFences[0];			
			while (nGoJig != _kNone)//nGoJig != _kOk && 
			{
			    nGoJig = ssP.goJig(kJigAddRemove, mapArgs); 
			    if (nGoJig == _kOk)
			    {
			        Point3d ptPick = ssP.value(); //retrieve the selected point
			        ptPick += vecZ * vecZ.dotProduct(_Pt0 - ptPick);

			        PlaneProfile ppFence;
			        if (ptFences.length()>0)
			        {
			        	int fenceMode = vecXView.dotProduct(ptPick - ptFences.first()) > 0?-1:1;			        	
			        	ppFence.createRectangle(LineSeg(ptFences.first(), ptPick),vecXView, vecYView);
			        	ptFences.setLength(0);
			        	mapArgs.removeAt("ptFence", true);
			        	for (int i=pps.length()-1; i>=0 ; i--) 
			        	{ 
			        		PlaneProfile pp = pps[i];
			        		PlaneProfile ppTest = pp;
			        		int bIntersect = ppTest.intersectWith(ppFence);
							if (bIntersect && (fenceMode==1 || (fenceMode==-1 && abs(ppTest.area()-pp.area())<pow(dEps,2))))
							{
								ppRemovals.append(pp);
								pps.removeAt(i);
							}
			        	}
			        }
			        else
			        { 
			        	int bFound;
				        for (int i=pps.length()-1; i>=0 ; i--) 
				        { 
				       		PlaneProfile pp = pps[i]; 
							if (pp.pointInProfile(ptPick)!=_kPointOutsideProfile)
							{
				        		bFound = true;
				        		ppRemovals.append(pp);
				        		pps.removeAt(i);
				        	}		 
				        }//next i
				        
				        if (!bFound)
				        { 
				        	ptFences.append(ptPick);	
							mapArgs.setPoint3d("ptFence", ptPick);
				        }
				        
			        }
					{ 
		        		Map m;
		        		for (int j=0;j<ppRemovals.length();j++) 
		        			m.appendPlaneProfile("pp",ppRemovals[j]); 
		        		mapArgs.setMap("ppRemoval[]", m);			        			
	        		}
	        		{ 
		        		Map m;
		        		for (int j=0;j<pps.length();j++) 
		        			m.appendPlaneProfile("pp",pps[j]); 
		        		mapArgs.setMap("pps", m);			        			
	        		}	
			    }
//			    else if (nGoJig == _kKeyWord)
//			    { 
//			        if (ssP.keywordIndex() == 0)
//			            mapArgs.setInt("isLeft", TRUE);
//			        else 
//			            mapArgs.setInt("isLeft", FALSE);
//			    }
			    else if (nGoJig == _kCancel)
			    { 
			       break;
			    }
			}			
			
			ssP.setSnapMode(false, 0); // turn on all snaps	
		//End Show Jig//endregion 



			setExecutionLoops(2);
			return;
		}//endregion	
	

	}
//endregion 


// TriggerFlipSide
	String sTriggerFlipDelta = T("|Flip Delta <> Chain|");
	addRecalcTrigger(_kContextRoot, sTriggerFlipDelta );
	if (_bOnRecalc && _kExecuteKey==sTriggerFlipDelta)
	{
		 _Map.setInt("DeltaOnTop",!bDeltaOnTop);
		setExecutionLoops(2);
		return;
	}


//region Trigger ResetModifications
	if (server.bIsValid() )//&& server.subMapKeys().findNoCase("RemovedLocation[]",-1)>-1)
	{ 
		String sTriggerResetModifications = T("|Reset Modifications|");
		addRecalcTrigger(_kContextRoot, sTriggerResetModifications );
		if (_bOnRecalc && _kExecuteKey==sTriggerResetModifications)
		{
			server.removeSubMapX("RemovedLocation[]");
			server.recalcNow();
			setExecutionLoops(2);
			return;
		}//endregion		
	}
	
// Trigger the update of the next dimline
	if (nextClient.bIsValid())
	{ 
		//reportNotice("\n"+ _ThisInst.handle() + " triggers location of " + nextClient.handle());
		Map m= nextClient.map();
		m.setInt("updateLocation", true);
		nextClient.setMap(m);
		nextClient.transformBy(Vector3d(0, 0, 0));
		nextClient.transformBy(Vector3d(0, 0, 0)); // mimics setExecutionLoops(2)
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
        <int nm="BreakPoint" vl="2645" />
        <int nm="BreakPoint" vl="3076" />
        <int nm="BreakPoint" vl="2464" />
        <int nm="BreakPoint" vl="1667" />
        <int nm="BreakPoint" vl="1613" />
        <int nm="BreakPoint" vl="1548" />
        <int nm="BreakPoint" vl="2819" />
        <int nm="BreakPoint" vl="2306" />
        <int nm="BreakPoint" vl="846" />
        <int nm="BreakPoint" vl="2812" />
        <int nm="BreakPoint" vl="2754" />
        <int nm="BreakPoint" vl="2767" />
        <int nm="BreakPoint" vl="2496" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-18273 creation by blockspace mode improved, dimlines always drawn in front of other entities" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="3/15/2023 11:35:29 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15746 supports definition in multipage blockspace for automatic model creation" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="6/15/2022 2:43:05 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15384 formatting on dimlines suppressed when perpendicular to 2D pattern" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="5/2/2022 9:24:05 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15328 Creation by Multipage supported" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="4/26/2022 5:31:14 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15319 loose drills added" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="4/25/2022 3:43:08 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14915 alignment shopdrawings enhanced" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="4/22/2022 3:36:35 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15167 new commands to add/remove points and drill locations" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="4/7/2022 5:36:18 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15053 Initial version" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="3/28/2022 11:34:40 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End