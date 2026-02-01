#Version 8
#BeginDescription
#Versions
Version 3.5 20.10.2021 HSB-13561 bugfix for openings of multi elements , Author Thorsten Huck
Version 3.4    11.10.2021    HSB-12241 performance improved when using byZone options and/or opening type , Author Thorsten Huck
Version 3.3    30.09.2021    HSB-13329 tolerance issues of underlying combined clip body fixed , Author Thorsten Huck
Version 3.2    25.06.2021    HSB-12370 accepting empty custom dimrequests to support invalidation (instaXX) , Author Thorsten Huck
Version 3.1    24.06.2021    HSB-12371 new point modes added to dimension packed genbeams (use options 'merged') , Author Thorsten Huck
Version 3.0    24.06.2021    HSB-12370 new property 'Reference Point Mode' added to control subset of reference points , Author Thorsten Huck
Version 2.9    23.06.2021    HSB-123333, HSB-12370 multi element transformation and point mode of tsl based map requests supported
Version 2.8    18.06.2021    HSB-12241 performance enhanced , Author Thorsten Huck
Version 2.7    17.06.2021    HSB-12241 performance enhanced for opening dimensions , Author Thorsten Huck
Version 2.6    21.05.2021    HSB-11973 dummies are considered if painter definition is used , Author Thorsten Huck

Version 2.5    06.04.2021   HSB-11312 Single element references of a multielement can be dimensioned if the elements itself can be found in the same dwg , Author Thorsten Huck
Version 2.4    25.02.2021    HSB-10896 collection of section entities improved , Author Thorsten Huck

2.3 12.02.2021 
HSB-10160 Multielement openings added if references can be found in same dwg , Author Thorsten Huck
HSB-10724 local dimlines with custm location contribute to collision check , Author Thorsten Huck
HSB-10429 start point of extension line is now projected to bounding contour (global) , Author Thorsten Huck
HSB-10715 Wirechase dimension added, tsls of genbeams supported , Author Thorsten Huck

HSB-8276 new property 'sequence' introduced to make dimlines collision free among each other , Author Thorsten Huck
HSB-6978 new point mode 'Extremes' and new dimension type 'Element' added 
HSB-6978 sync of versions as 22 does not support painter definitions 

HSB-6978, HSB-5343 
painter definitions supported to filter dimension and reference objects
sheets and panels supported
individual placement of local alignments via RMC 
NOTE: Requires at least 22.1.69 or 23.0.43

HSB-7788 bugfix dimpoint tolerances, merge conflict with HSB-7254 resolved
HSB-6511 custom text added to tsl type by mapRequest
HSB-6131 custom triggers added to add/remove points/reference point


This tsl creates a dimension line based on the given properties. It can be attached to one of the following view entities: Viewport, Section, Shopdrawing Viewport

















#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 3
#MinorVersion 5
#KeyWords Section;Viewport;Shopdrawing;Dimension
#BeginContents
//region Part 1

/// <History>//region
// #Versions
// 3.5 20.10.2021 HSB-13561 bugfix for openings of multi elements , Author Thorsten Huck
// 3.4 11.10.2021 HSB-12241 performance improved when using byZone options and/or opening type , Author Thorsten Huck
// 3.3 30.09.2021 HSB-13329 tolerance issues of underlying combined clip body fixed , Author Thorsten Huck
// 3.2 25.06.2021 HSB-12370 accepting empty custom dimrequests to support invalidation (instaXX) , Author Thorsten Huck
// 3.1 24.06.2021 HSB-12371 new point modes added to dimension packed genbeams (use options 'merged') , Author Thorsten Huck
// 3.0 24.06.2021 HSB-12370 new property 'Reference Point Mode' added to control subset of reference points , Author Thorsten Huck
// 2.9 23.06.2021 HSB-123333, HSB-12370 multi element transformation and point mode of tsl based map requests supported
// 2.8 18.06.2021 HSB-12241 performance enhanced , Author Thorsten Huck
// 2.7 17.06.2021 HSB-12241 performance enhanced for opening dimensions , Author Thorsten Huck
// 2.6 21.05.2021 HSB-11973 dummies are considered if painter definition is used , Author Thorsten Huck
// 2.5 06.04.2021 HSB-11312 Single element references of a multielement can be dimensioned if the elements itself can be found in the same dwg , Author Thorsten Huck
// 2.4 25.02.2021 HSB-10896 collection of section entities improved , Author Thorsten Huck
// 2.3 12.02.2021 HSB-10160 Multielement openings added if references can be found in same dwg , Author Thorsten Huck
// 2.2 11.02.2021 HSB-10724 local dimlines with custm location contribute to collision check , Author Thorsten Huck
// 2.1 11.02.2021 HSB-10429 start point of extension line is now projected to bounding contour (global) , Author Thorsten Huck
// 2.0 11.02.2021 HSB-10715 Wirechase dimension added, tsls of genbeams supported , Author Thorsten Huck
// 1.9 10.02.2021 HSB-8276 new property 'sequence' introduced to make dimlines collision free among each other , Author Thorsten Huck
/// <version value="1.8" date="26jun2020" author="thorsten.huck@hsbcad.com"> HSB-6978 new point mode 'Extremes' and new dimension type 'Element' added  </version>
/// <version value="1.7" date="22jun2020" author="thorsten.huck@hsbcad.com"> HSB-6978 sync of versions as 22 does not support painter definitions </version>
/// <version value="1.6" date="10jun2020" author="thorsten.huck@hsbcad.com"> HSB-6978, HSB-5343 painter definitions supported to filter dimension and reference objects, sheets and panels supported, individual placement of local alignments via RMC </version>
/// <version value="1.5" date="29may2020" author="thorsten.huck@hsbcad.com"> HSB-7788 bugfix dimpoint tolerances,merge conflict with HSB-7254 resolved </version>
/// <version value="1.4" date="14apr2020" author="thorsten.huck@hsbcad.com"> HSB-7254 new option <disabled> on property reference will suppress any reference points </version>
/// <version value="1.3" date="30jan2020" author="thorsten.huck@hsbcad.com"> HSB-6511 custom text added to tsl type by mapRequest </version>
/// <version value="1.2" date="20dec2019" author="thorsten.huck@hsbcad.com"> HSB-6131 custom triggers added to add/remove points/reference point </version>
/// <version value="1.1" date="09dec2019" author="thorsten.huck@hsbcad.com"> HSB-6131 bugfix element ref points </version>
/// <version value="1.0" date="06dec2019" author="thorsten.huck@hsbcad.com"> HSB-6131 initial </version>
/// </History>

/// <insert Lang=en>
/// Select any view entity (Viewport, Section, Shopdrawing Viewport), select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates a dimension line based on the given properties. It can be attached to one of the following
/// view entities: Viewport, Section, Shopdrawing Viewport
/// </summary>

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbViewDimension")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "../|Add Entities|") (_TM "|Select view dimension|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "../|Remove Entities|") (_TM "|Select view dimension|"))) TSLCONTENT
//endregion

//region constants 
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug = _bOnDebug || _kShiftKeyPressed;
	if(bDebug)reportMessage("\n"+ scriptName() + " starting " + _ThisInst.handle());
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
	
	String sKeyDimInfo = "Hsb_DimensionInfo";
	String sSubXKey = "ViewProtect";
	
	int nSequenceOffset = 100; // a default offset to start all sequences, will be different i.e. for hsbViewTag
	int bIsDark;{int n = getBackgroundTrueColor();bIsDark = ((rgbR(n) + rgbB(n) + rgbG(n)) / 3 < 127);}
	int nTickStart = getTickCount();
//end constants//endregion

//region bOnJig
	String sJigAction = "JigAction";
	if (_bOnJig && _kExecuteKey==sJigAction) 
	{
		String k;
	    Point3d ptBase = _Map.getPoint3d("_PtBase"); // set by second argument in PrPoint
	    Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point
	    
	    Vector3d vecDir = _Map.getVector3d("vecDir");
	    Vector3d vecPerp = _Map.getVector3d("vecPerp");
	    
	    Point3d ptFrom =ptJig;
	    int bShowDim;
	    if (_Map.hasPoint3d("ptFrom"))
	    {
	    	ptFrom = _Map.getPoint3d("ptFrom");
	    	bShowDim = true;
	    }
	    
	    Map mapDims = _Map.getMap("Dim[]");
	    Map mapCustomLocations = _Map.getMap("CustomLocation[]");	
	    double dTextHeight = _Map.getDouble("TextHeight");
		String sDimStyle =_Map.getString("DimStyle");
		int nChainMode = _Map.getInt("ChainMode");
		int nDeltaMode = _Map.getInt("DeltaMode");
		double dScale = _Map.getDouble("Scale");
		    
	    //_ThisInst.setDebug(TRUE); // sets the debug state on the jig only, if you want to see the effect of vis methods
	    //ptJig.vis(1);
	    Display dp(-1),dpRed(1), dpOrange(-1);
	    dp.trueColor(bIsDark ? rgb(0,69,138) : rgb(219,237,255));
	    dpOrange.trueColor(bIsDark ? rgb(143,107,0) : rgb(255,213,87));
	    dp.transparency(80);
		dpOrange.transparency(80);
		dpRed.dimStyle(sDimStyle, 1/dScale);
		
	    
	    PlaneProfile ppJig;
	    Line lnThis;
	    
	    double dDist = U(10e4);
	    Map mapDim;
	    for (int i=0;i<mapDims.length();i++) 
	    { 
	    	Map m= mapDims.getMap(i);
	    	
	    	Point3d ptLoc = m.getPoint3d("ptLoc");
	    	Entity entParent= m.getEntity("parentEnt");
			if (mapCustomLocations.hasPoint3d(entParent.handle()))
				ptLoc = mapCustomLocations.getPoint3d(entParent.handle());	
							
	    	Line ln(ptLoc, vecDir);
	    	double d = abs(vecPerp.dotProduct(ln.closestPointTo(ptFrom)-ptFrom));
	    	if (d<dDist)
	    	{ 
	    		dDist = d;
	    		ppJig = m.getPlaneProfile("visibleShape");
	    		lnThis = ln;
	    		mapDim = m;
	    	}

	    }//next i
	    dp.draw(ppJig, _kDrawFilled);
	    
	// draw guide line    
	 	{ 
	 		Point3d pts[] = lnThis.orderPoints(lnThis.projectPoints(mapDim.getPoint3dArray("pts")));
	 		PLine plDim;
	 		if (pts.length()>1)
	 		{ 
	 			plDim.addVertex(pts.first());
	 			plDim.addVertex(pts.last());		
	 		}

	 		PLine pl;
	 		pl.addVertex(ptJig);
	 		Point3d pt1 = lnThis.closestPointTo(ptFrom);
	 		Vector3d vec = pt1 - ptJig; vec.normalize();
	 		Point3d pt2 = ptJig + (vec + vecDir) * dTextHeight;
	 		if (vec.dotProduct(pt2-pt1)<0)
	 			pl.addVertex(pt2);
	 		else
	 			pt2 = ptJig;
	 		
	 		if (plDim.length()>0)
	 			pl.addVertex(plDim.closestPointTo(pt2));	
	 		else
	 			pl.addVertex(lnThis.closestPointTo(pt2));
	 		dpRed.draw(pl);
	 	}   
	    
		
		
	// draw from dim
		if (bShowDim)
		{ 
			Point3d pts[] = lnThis.orderPoints(lnThis.projectPoints(mapDim.getPoint3dArray("pts")));
			if (pts.length()>1)
			{ 
				PlaneProfile pp;
				pp.createRectangle(LineSeg(pts.first()-vecPerp*.5*dTextHeight,pts.last()+vecPerp*.5*dTextHeight), vecDir, vecPerp);
				dpOrange.draw(pp, _kDrawFilled, 80);
		
				pts = Line(ptJig, vecDir).projectPoints(pts);
			
				DimLine dl(ptJig, vecDir, vecPerp);
				Dim dim(dl, pts, "<>", "<>", nDeltaMode,nChainMode); 
				//dim.setDeltaOnTop(bSwapDeltaChain);
				Vector3d vecXRead = vecDir;
				Vector3d vecYRead = vecPerp;
				if (vecXRead.isPerpendicularTo(_ZW))
				{ 
					vecXRead =_XW;
					vecYRead =_YW;				
				}
				dim.setReadDirection(vecYRead - vecXRead);
				dpRed.draw(dim);

			}
			
		}

	    return;
	}		
//End bOnJig//endregion 


//region Properties
	String sRefByUser = T("|byUser|");
	String sRefByElement = T("|byElement|");
	
	String sTypeBeam = T("|Beam|");
	String sTypeSheet = T("|Sheet|");
	String sTypePanel = T("|Panel|");
	String sTypeGenBeam = T("|GenBeam|");
	String sTypeOpening = T("|Opening|");
	String sTypeElement = T("|Element|");
	String sTypeTsl = T("|TSL|");
	String sTypes[] ={sTypeBeam,sTypeOpening,sTypeTsl,sTypePanel, sTypeSheet,sTypeElement};
	//{ T("|byZone|"),T("|Beam|"), T("|Sheet|"), T("|Panel|"), T("|GenBeam|"),
	//	T("|TSL|"),T("|Opening|"), T("|Door|"), T("|Window|"), T("|Window Assembly|"),
	//	T("|Truss|"), T("|Metalpart|"),T("|Massgroup|"), T("|Element|")};

	String sZones[0];
	for (int i=0;i<11;i++) 
		sZones.append(T("|Zone| ") + (i - 5));

	// #PainterDefinition comment/uncomment version 22/23
	String sPainters[] = PainterDefinition().getAllEntryNames().sorted();


// content
category = T("|Content|");
	String sTypeName=T("|Type|");	
	sTypes.append(sZones);

	String sPainterDims[0];
	for (int i=0;i<sPainters.length();i++) 
	{
		String sPainterDim = sPainters[i];
		if (sTypes.findNoCase(sPainters[i] ,- 1) >-1)sPainterDim += T(" |(Painter)|");
		if (sPainterDims.findNoCase(sPainters[i] ,- 1) >-1)sPainterDim += " ("+i+")";
		sPainterDims.append(sPainterDim); 	
	}	
	sTypes.append(sPainterDims);//#PainterDefinition comment/uncomment version 22/23
	PropString sType(0, sTypes, sTypeName);	
	sType.setDescription(T("|Defines the type of entity which will be collected.|") + T(" |Empty = by current zone, else specify types.|") + T(" |Use context commands to select.|"));
	sType.setCategory(category);

	String sStereotypeName=T("|Stereotype|");	
	PropString sStereotype(1, "", sStereotypeName);	
	sStereotype.setDescription(T("|The Stereotype specifies which dimension requests are drawn.|") + T(" |This can be a list of semicolon separated tsl names or stereotypes defined in a submap of any entity.|") + T(" |For Panels and sip elements one can also use the keyword 'Wirechase' to include dimesnions of potential wirechase segments.|"));
	sStereotype.setCategory(category);

	String sDimPointModeName=T("|Point Mode|");
	String sDimPointModes[] = { T("|Automatic|"),T("|First Point|"), T("|Mid Point|"), T("|Last Point|"), T("|First + Last|"), T("|Extremes|"), T("|First Point (Merged)|"),T("|Last Point (Merged)|"),T("|First + Last (Merged)|")};
	PropString sDimPointMode(2, sDimPointModes, sDimPointModeName,2);	
	sDimPointMode.setDescription(T("|Defines which points are considered of the dimensioning.|") + T(" |'Merged' modes combine neighbouring entities into one (supported for genbeams only)|"));
	sDimPointMode.setCategory(category);
	int nDimPointMode = sDimPointModes.find(sDimPointMode);
	if (nDimPointMode < 0){sDimPointMode.set(sDimPointModes.first()); setExecutionLoops(2); return;}

	String sDescriptionName=T("|Format|");	
	PropString sDescription(6, "@(Type)", sDescriptionName);	
	sDescription.setDescription(T("|Defines the description at the dimline.|") + T("|Format expressions supported, i.e. @(Name)|"));
	sDescription.setCategory(category);
	
	
category = T("|Reference|");	
	String sReferences[] = {T("<|Disabled|>"),sRefByElement,sRefByUser};
	sReferences.append(sZones);	
	String sPainterRefs[0];
	for (int i=0;i<sPainters.length();i++) 
	{
		String sPainterRef = sPainters[i];
		if (sReferences.findNoCase(sPainters[i] ,- 1) >-1)sPainterRef += T(" |(Painter)|");
		if (sPainterRefs.findNoCase(sPainters[i] ,- 1) >-1)sPainterRef += " ("+i+")";
		sPainterRefs.append(sPainterRef); 	
	}
	sReferences.append(sPainterRefs);//#PainterDefinition comment/uncomment version 22/23	
	String sReferenceName=T("|Reference|");	
	PropString sReference(3, sReferences, sReferenceName,1);	// 1.3: keep property sequence of previous versions
	sReference.setDescription(T("|Defines the reference of the dimension.| ") + T("|In case the specified reference is invalid the reference will fall back to zone 0 or the element outline.|"));
	sReference.setCategory(category);

	String sRefPointModeName=T("|Point Mode|");
	String sRefPointModes[0];sRefPointModes = sDimPointModes;sRefPointModes.setLength(6); // exclude merged modes	
	PropString sRefPointMode(8, sRefPointModes, sRefPointModeName,0);	
	sRefPointMode.setDescription(T("|Defines the which points of the reference are taken.|"));
	sRefPointMode.setCategory(category);
	int nRefPointMode = sRefPointModes.find(sRefPointMode);
	if (nRefPointMode < 0){sRefPointMode.set(sRefPointModes.first()); setExecutionLoops(2); return;}
	
//Display
category = T("|Style|");
	
	String sAlignmentName=T("|Alignment|");
	String sAlignments[] ={ T("|Horizontal Local|"), T("|Horizontal Global|"), T("|Vertical Local|"),T("|Vertical Global|")};
	PropString sAlignment(4, sAlignments, sAlignmentName);	
	sAlignment.setDescription(T("|Defines the Alignment|"));
	sAlignment.setCategory(category);
	
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
	PropString sDisplayMode(5, sDisplayModes, sDisplayModeName,0);	
	sDisplayMode.setDescription(T("|Defines the DisplayMode|"));
	sDisplayMode.setCategory(category);
	int nDisplayMode = sDisplayModes.find(sDisplayMode, 0);
	int nDeltaMode = nDeltaModes[nDisplayMode];
	int nChainMode = nPerpModes[nDisplayMode];

	
category = T("|Display|");
	String sDimStyleName=T("|Dimstyle|");	
	PropString sDimStyle(7, _DimStyles.sorted(), sDimStyleName);	
	sDimStyle.setDescription(T("|Defines the Dimstyle|"));
	sDimStyle.setCategory(category);	

	String sSequenceName=T("|Sequence|");
	PropInt nSequence(nIntIndex++, 0, sSequenceName);	
	nSequence.setDescription(T("|Defines the sequence how collisions with other dimlines and tags will be resolved.| ") + T("|-1 = Disabled, 0 = Automatic|"));
	nSequence.setCategory(category);

//End Properties//endregion 

//region bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
	// silent/dialog
		String sKey = _kExecuteKey;
		sKey.makeUpper();
		if (sKey.length()>0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
			if (sEntries.findNoCase(sKey,-1)>-1)			
				setPropValuesFromCatalog(sKey);
			else
				showDialog();					
		}		
		else	
			showDialog();

	// get current space and property ints
		int bInLayoutTab = Viewport().inLayoutTab();
		int bInPaperSpace = Viewport().inPaperSpace();

		int nAlignment = sAlignments.find(sAlignment, 0);// 0 = horizontal , 2= horizontal global,3 = vertical , 4= vertical global
		int bIsGlobal = nAlignment == 1 || nAlignment == 3;
		int bIsVertical = nAlignment >1;

		int nReference = sReferences.find(sReference);
		int nRefZone = sZones.find(sReference)-5;
		int nZone = sZones.find(sType)-5;
		int bRefByElement = sReference==sRefByElement;
		int bRefByUser = sReference==sRefByUser;
		int bRefByZone = bRefByElement!=true && bRefByUser!=true;
		int bDimByZone = nZone >- 6 && nZone < 6;
		
		int bAddOpening = sType==sTypeOpening;
		int bAddBeam= sType==sTypeBeam || bDimByZone | bRefByZone;
		
	// find out if we are block space and have some shopdraw viewports
		Entity viewEnts[0];
		if (!bInLayoutTab)viewEnts= Group().collectEntities(true, ShopDrawView(), _kMySpace);

	// distinguish selection mode bySpace
		if (viewEnts.length()>0)
			_Entity.append(getShopDrawView());
	// switch to paperspace succeeded: paperspace with viewports
		if (_Entity.length()<1)
		{ 
		// paperspace get viewPort
			if (bInLayoutTab)
			{
				_Viewport.append(getViewport(T("|Select a viewport|")));
				
			// prompt for entity selection if not an element viewport	
				Element el;
				if(_Viewport.length()>0 && !_Viewport[0].element().bIsValid())
				{
					int bSuccess = Viewport().switchToModelSpace();
					if (bSuccess)
					{ 
					// prompt for entities
						PrEntity ssE;
						if (bAddBeam)ssE = PrEntity(T("|Select beams|"), Beam());
//						else if (nType==2)ssE = PrEntity(T("|Select sheets|"), Sheet());
//						else if (nType==3)ssE = PrEntity(T("|Select sips|"), Sip());
//						else if (nType==4)ssE = PrEntity(T("|Select genbeams|"), GenBeam());
//						else if (nType==5)ssE = PrEntity(T("|Select tsl(s)|"), TslInst());
						else if (bAddOpening)
						{
							ssE = PrEntity(T("|Select openings or elements|"), Opening());	
							ssE.addAllowedClass(ElementWall());
						}
//						else if (nType==10)ssE = PrEntity(T("|Select trusses|"), TrussEntity());
//						else if (nType==11)ssE = PrEntity(T("|Select metalparts|"), MetalPartCollectionEnt());
//						else if (nType==12)ssE = PrEntity(T("|Select massgroups|"), MassGroup());
						//else if (nType==13)ssE = PrEntity(T("|Select elements|"), Element());
						if (ssE.go())
						{
							Entity _ents[] = ssE.set();
							reportMessage("\nents " + _ents.length() + " selected");
							_Entity.append(ssE.set());
						}
						bSuccess = Viewport().switchToPaperSpace();	
					}
				}
				else
					el = _Viewport[0].element();

				_Pt0 = getPoint(T("|Pick insertion point|"));
				if (bRefByUser)
				{ 
					_PtG.append(getPoint(T("|Pick reference point|")));
					_Map.setInt("HasCustomRef"+(el.bIsValid()?el.handle():""), true);// indicate that [0] is the refpoint		
				}				
			}	
		// modelspace: get Section2d or ClipVolume
			else
			{ 
			// create TSL
				TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
				GenBeam gbsTsl[] = {};		Entity entsTsl[1];			Point3d ptsTsl[] = {_Pt0};
				int nProps[]={nSequence};
				double dProps[]={};//dTextHeight
				String sProps[]={sType,sStereotype,sDimPointMode, sReference,sAlignment,sDisplayMode,sDescription,sDimStyle, sRefPointMode};
				Map mapTsl;	

				if (bRefByUser)
				{ 
					ptsTsl.append(getPoint(T("|Pick reference point|")));
					mapTsl.setInt("HasCustomRef", true);// indicate that [0] is the refpoint		
				}

			// prompt for entities
				Entity ents[0];
				PrEntity ssE(T("|Select Section2d|"), Section2d());
				if (ssE.go())
					ents.append(ssE.set());	
	
	
			// create per section
				for (int i=0;i<ents.length();i++) 
				{ 
					mapTsl.setInt("GetInsertLocation", true);
					entsTsl[0] = ents[i]; 
					tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);	 
				}//next i
							
				eraseInstance();
				return;		
			}			
		}
		else 
			_Pt0 = getPoint(T("|Pick insertion point|"));
		return;
	}	
// end on insert	__________________//endregion

//region Standards
	// on creation
	if (_bOnDbCreated)setExecutionLoops(2);
	if (nSequence > 0)_ThisInst.setSequenceNumber(nSequence);
	//_ThisInst.setSequenceNumber(500);
	
// some variables
	double dXVp, dYVp; // X/Y of viewport/shopdrawviewport
	Point3d ptCenVp=_Pt0;
	int nActiveZoneIndex = 99;
	int nc = _ThisInst.color();
	
	int nAlignment = sAlignments.find(sAlignment, 0);// 0 = horizontal , 2= horizontal global,3 = vertical , 4= vertical global
	int bIsGlobal = nAlignment == 1 || nAlignment == 3;
	int bIsVertical = nAlignment >1;
	
	// #PainterDefinition comment/uncomment version 22/23
	int bRefByPainter = sPainterRefs.findNoCase(sReference ,- 1) >- 1;
	PainterDefinition painterRef;
	if (bRefByPainter)
	{
		int n = sPainterRefs.findNoCase(sReference ,- 1);
		if (n>-1)painterRef = PainterDefinition(sPainters[n]);
		if (!painterRef.bIsValid())bRefByPainter = false;
	}	
	
	int nReference = sReferences.find(sReference);
	int nRefZone = sZones.find(sReference)-5;
	int nZone = sZones.find(sType)-5;
	int bRefByElement = sReference==sRefByElement;
	int bRefByUser = sReference==sRefByUser;
	int bRefByZone = bRefByElement!=true && bRefByUser!=true && bRefByPainter!=true;
	
	int bDimByZone = nZone >- 6 && nZone < 6;

	// #PainterDefinition comment/uncomment version 22/23
	int bDimByPainter = sPainterDims.findNoCase(sType ,- 1) >- 1;
	PainterDefinition painter;
	if (bDimByPainter)
	{
		int n = sPainterDims.findNoCase(sType ,- 1);
		if (n>-1)painter = PainterDefinition(sPainters[n]);
		if (!painter.bIsValid())bDimByPainter = false;
	}
	
//region type flags and temp painter
	int bAddOpening = sType==sTypeOpening;
	int bAddBeam= sType==sTypeBeam || (bDimByPainter && painter.type() == "Beam");
	int bAddTsl= sType==sTypeTsl || (bDimByPainter && painter.type() == "TslInstance") ;
	int bAddPanel= sType==sTypePanel|| (bDimByPainter && painter.type() == "Panel") ;
	int bAddSheet= sType==sTypeSheet|| (bDimByPainter && painter.type() == "Sheet");
	int bAddElement= sType==sTypeElement;

	int bRefBeam = (bRefByPainter && painterRef.type() == "Beam") || bRefByZone; // 2.8 18.06.2021 HSB-12241
	int bRefSheet = (bRefByPainter && painterRef.type() == "Sheet") || bRefByZone;
	int bRefPanel = (bRefByPainter && painterRef.type() == "Panel") || bRefByZone;

// TRIAL cretae painter on the fly: eats up a bit of resources on create, setFilter and dbErase
//	String sTempPainterName = "temp_" + scriptName();	
//	PainterDefinition pdTemp(sTempPainterName);
//	if (!bDimByPainter && !bRefByPainter && (bDimByZone || bRefByZone)) 
//	{ 
//		if (sPainters.findNoCase(sTempPainterName,-1)<0)pdTemp.dbCreate();
//		pdTemp.setType("GenBeam");
//		
////		if (bDimByZone || bRefByZone)
//			pdTemp.setFilter("(Equals(IsDummy,'false'))and(Equals(ZoneIndex,"+(bRefByZone?nRefZone:nZone)+"))");
////		else if (bAddBeam || bRefBeam)
////			pdTemp.setFilter("(Equals(IsDummy,'false'))and(Equals(TypeName,'Beam'))");
////		else if (bAddSheet || bRefSheet)
////			pdTemp.setFilter("(Equals(IsDummy,'false'))and(Equals(TypeName,'Sheet'))");
////		else if (bAddPanel || bRefPanel)
////			pdTemp.setFilter("(Equals(IsDummy,'false'))and(Equals(TypeName,'Sip'))");			
////		else
////			pdTemp.setFilter("(Equals(IsDummy,'false'))");		
//	}

//End type flags//endregion 

	Vector3d vecDir = bIsVertical?_YW:_XW;
	Vector3d vecPerp = bIsVertical?-_XW:_YW;
	Vector3d vecZPS = vecDir.crossProduct(vecPerp);
	Vector3d vecDirMS = vecDir;
	Vector3d vecPerpMS = vecPerp;
	Element el;
	ElementMulti em;
	int bIsElementViewport;	
	Point3d ptMidEl;
	LineSeg segEl;
//	int nPerpAlignment; // 0 = Axis, -1=left/bottom, +1=right/top
	CoordSys ms2ps, ps2ms;

	Point3d ptDatum = _Pt0;
	CoordSys csW(_PtW, _XW, _YW, _ZW);
	
	String sStereotypes[] =sStereotype.tokenize(";");
	int bHasStereotype = sStereotypes.length() > 0;
	
	int bSwapDeltaChain = _Map.getInt("SwapDeltaChain");
	
	Map mapAdditionalVariables;
	mapAdditionalVariables.appendInt("Sequence", _ThisInst.sequenceNumber());
	
	int bDimAuto = nDimPointMode == 0;
	int bDimExtreme = nDimPointMode == 5;
	int bDimFirst = (nDimPointMode == 0 || nDimPointMode == 1 || nDimPointMode == 4 || nDimPointMode == 5 || nDimPointMode == 6 || nDimPointMode == 8);
	int bDimLast = (nDimPointMode == 0 || nDimPointMode == 3 || nDimPointMode == 4 || nDimPointMode == 5 || nDimPointMode == 7 || nDimPointMode == 8);
	int bDimMid = (nDimPointMode == 2);

	int bRefAuto = nRefPointMode == 0;
	int bRefExtreme = nRefPointMode == 5;
	int bRefFirst = (nRefPointMode == 0 || nRefPointMode == 1 || nRefPointMode == 4 || nRefPointMode == 5 || nRefPointMode == 6 || nRefPointMode == 8);
	int bRefLast = (nRefPointMode == 0 || nRefPointMode == 3 || nRefPointMode == 4 || nRefPointMode == 5 || nRefPointMode == 7 || nRefPointMode == 8);
	int bRefMid = (nRefPointMode == 2);	
//End Standards//endregion 
//End Part 1//endregion



//region Part 2

//region get defining viewport entity
// Collection of supported classes
	Beam beams[0];
	Sheet sheets[0];
	Sip sips[0];
	TslInst tsls[0];
	Opening openings[0];
	Element elements[0];

	
//region Collect parent entities
	ShopDrawView sdv;
	Section2d section;ClipVolume clipVolume;
	Body bdClip;
	Entity entsDefineSet[0],entsShowset[0];
	int bHasSDV, bHasSection;
	PlaneProfile ppView(csW);
	Plane pnSection;
	LineSeg segPS;

// other hsbViewXXX- Instances attached to the parent 
	Entity entTags[0];


// Get ShopdrawView or Section2D
	for (int i=0;i<_Entity.length();i++) 
	{ 
	// Shopdraw View
		sdv = (ShopDrawView)_Entity[i]; 
		if (sdv.bIsValid())
		{ 
		// interprete the list of ViewData in my _Map
			ViewData viewDatas[] = ViewData().convertFromSubMap( _Map, _kOnGenerateShopDrawing + "\\" + _kViewDataSets,0); // 2 means verbose
			int nIndex = ViewData().findDataForViewport(viewDatas, sdv);// find the viewData for my view
			if (nIndex>-1)
			{ 
				ViewData viewData = viewDatas[nIndex];
				dXVp = viewData.widthPS();
				dYVp = viewData.heightPS();
				ptCenVp= viewData.ptCenPS();
				
				ms2ps = viewData.coordSys();
				ps2ms = ms2ps; ps2ms.invert();
				
				entsDefineSet = viewData.showSetDefineEntities();
				entsShowset = viewData.showSetEntities();
				for (int j=0;j<entsDefineSet.length();j++) 
				{ 
					el= (Element)entsDefineSet[j]; 
					elements.append(el);
					if (el.bIsValid())break;					 
				}//next j
			}
			bHasSDV = true;
			break;
		}
	// Section	
		section = (Section2d)_Entity[i]; 
		if (section.bIsValid())
		{
			pnSection = Plane(section.coordSys().ptOrg(), section.coordSys().vecZ());pnSection.vis(2);
			bHasSection = true;
			clipVolume= section.clipVolume();
			if (!clipVolume.bIsValid())
			{ 
				reportMessage(TN("|Clip volume not valid|"));
				eraseInstance();
				return;
			}
			bdClip.addPart(clipVolume.clippingBody());
			
			_Entity.append(clipVolume);
			ms2ps = section.modelToSection();
			ps2ms = ms2ps; ps2ms.invert();
			entsShowset = clipVolume.entitiesInClipVolume();
			
			//_ThisInst.setAllowGripAtPt0(bIsGlobal);
			
			setDependencyOnEntity(section);
			setDependencyOnEntity(clipVolume);

		// get extents of section
			// HSB-13329 combinedClipped seems to have issues therefor the boundaries are simply taken from the clipBody 
			Body bd = bdClip;//clipVolume.combinedClippedBodyOfEntities();	
			bd.transformBy(ms2ps);
			segPS = bd.shadowProfile(Plane(_PtW, _ZW)).extentInDir(_XW);//segPS.vis(3);
			ptCenVp = segPS.ptMid();
			ppView.createRectangle(segPS, _XW, _YW);

		// get insert location
			if (_Map.getInt("GetInsertLocation") || _kNameLastChangedProp==sAlignmentName)
			{						
				Vector3d vecX = bIsVertical ? _XW : -_YW; // dimline left or below
				Vector3d vecY = vecX.crossProduct(_ZW);
				double dX = abs(vecX.dotProduct(segPS.ptEnd() - segPS.ptStart()))*.5;
				double dY = abs(vecY.dotProduct(segPS.ptEnd() - segPS.ptStart()))*.5;
				
				Display dp;
				dp.dimStyle(sDimStyle);
				double d = dp.textHeightForStyle("O", sDimStyle) * 5;
				dX += d;
				dY += d;
				_Pt0 = segPS.ptMid() + vecX*dX+vecY*dY;
				_Map.removeAt("GetInsertLocation", true);
			}
			
		// get other tagging entities from section HSB-8276
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
				if (ents.find(section) < 0)entTags.removeAt(j);		
			}//next j

			break;
		}
	}//next i
	//bdClip.vis(2);

	
// Get viewport data
	Viewport vp;
	int bIsAcaViewport;
	double dScale = 1;
	if (_Viewport.length()>0)
	{ 
		vp = _Viewport[_Viewport.length()-1]; // take last element of array
		_Map.setString("ViewHandle", vp);
		_Viewport[0] = vp; // make sure the connection to the first one is lost
		ms2ps = vp.coordSys();
		ps2ms = ms2ps; ps2ms.invert(); // take the inverse of ms2ps
	
		dXVp = vp.widthPS();
		dYVp = vp.heightPS();
		ptCenVp= vp.ptCenPS();	
		dScale = vp.dScale();
		nActiveZoneIndex = vp.activeZoneIndex();
		
		ppView.createRectangle(LineSeg(ptCenVp - .5 * (_XW * dXVp + _YW * dYVp), ptCenVp + .5 * (_XW * dXVp + _YW * dYVp)), _XW, _YW);

	// HSBCAD Viewport
		el = vp.element();
		if (el.bIsValid())
		{ 
			elements.append(el);
			ptDatum = el.ptOrg();

		// get all element entities
			if (bAddBeam || bRefBeam)beams = el.beam();
			if (bAddSheet|| bRefSheet)sheets = el.sheet();
			if (bAddPanel|| bRefPanel)sips = el.sip();				

			if (bAddTsl)tsls= el.tslInstAttached();
			openings=el.opening();
	
		}
	// ACA Viewport	
		else
		{
			entsShowset = _Entity;
			bIsAcaViewport = true;
		}
		entTags= Group().collectEntities(true, TslInst(), _kMySpace);
		
	// make sure it is assigned to layer 0 on creation
		if (_bOnDbCreated) assignToLayer("0");		
	}
// Get scale if not viewport
	else	
	{ 
		Vector3d vecScale(1, 0, 0);
		vecScale.transformBy(ps2ms);
		dScale = vecScale.length();	
		
	}
	
//region MultiElement: collecting elements of multi if in same dwg
	Element elMultis[0];
	SingleElementRef srefs[0];				
	em = (ElementMulti)el;
	if (em.bIsValid())
	{ 
		srefs = em.singleElementRefs();
		String numbers[0];
		for (int j=0;j<srefs.length();j++) 
			numbers.append(srefs[j].number()); 
	
		Entity _ents[] = Group().collectEntities(true, Element(), _kModelSpace);
		for (int i=0;i<_ents.length();i++) 
		{ 
			Element e = (Element)_ents[i];
			if (e.bIsValid() && numbers.findNoCase(e.number(),-1)>-1)	
			{
				elMultis.append(e);	 
				openings.append(e.opening());// Collect openings of single refs
			}
		}//next j				
	}	
//End MultiElement//endregion 	
	
	
	


// HSB-7788 paperspace tolerance
	double dEpsPS = dScale<1?dEps * dScale:dEps;
	int nXAlign = vecDir.dotProduct(ptCenVp - _Pt0) > 0 ?- 1 : 1;

	for (int i=0;i<entsShowset.length();i++) 
	{ 

		//if (bRefByPainter && !entsShowset[i].acceptObject(painterRef.filter())){ continue;} // not accpeted by painter
		int z = entsShowset[i].myZoneIndex();
		int bValidZone = z == nRefZone || z == nZone || !bDimByZone;
		
		if (bAddBeam)
		{ 
			Beam b= (Beam)entsShowset[i]; 
			if (b.bIsValid() && beams.find(b)<0 && bValidZone){ beams.append(b);continue;}			
		}

		if (bAddPanel)
		{ 
		Sip sip= (Sip)entsShowset[i]; 
		if (sip.bIsValid()&& sips.find(sip)<0 && bValidZone){ sips.append(sip); continue;}			
		}

		if (bAddSheet)
		{ 
			Sheet s= (Sheet)entsShowset[i]; 
			if (s.bIsValid() && sheets.find(s)<0 && bValidZone){ sheets.append(s); continue;}			
		}

		if (bAddTsl)
		{ 
			TslInst t= (TslInst)entsShowset[i]; 
			if (t.bIsValid()&& tsls.find(t)<0){ tsls.append(t); continue;}			
		}

		
		Element e= (Element)entsShowset[i];
		Opening _openings[0];
		if (e.bIsValid() && elements.find(e)<0)
		{
			elements.append(e); 
			if (!bAddOpening){continue;}
			else _openings = e.opening(); // autoselect openings from element
		}
		
		Opening o= (Opening)entsShowset[i]; 
		if (o.bIsValid() && openings.find(o)<0)
			_openings.append(o);
		for (int i=0;i<_openings.length();i++) 
		{ 
			Opening o = _openings[i]; 
		// test intersection. openings could be collected in a section by their base representation
			int bOk = true;
			if (bdClip.volume()>pow(dEps,3))
			{ 
				Body bd(o.plShape(), o.element().vecZ() * U(10), 0);
				bOk = bd.hasIntersection(bdClip);
			}
			if (bOk)
			{ 
				o.plShape().vis();
				openings.append(o);				
			}			 
		}//next i		
	}//next i
//End Collect parent entities//endregion 





//// it has no shopdraw viewport and no viewport
//	if (!bHasSDV && _Viewport.length()==0 && !bHasSection && Viewport().switchToPaperSpace()) 
//	{
//		Display dp(1);
//		if (dTextHeight>0)dp.textHeight(U(dTextHeight));
//		dp.draw(scriptName() + T(": |please add a viewport|"), _Pt0, _XW, _YW, 1, 0);
//
//	// Trigger AddViewPort
//		String sTriggerAddViewPort = T("|Add Viewport|");
//		addRecalcTrigger(_kContext, sTriggerAddViewPort );
//		if (_bOnRecalc && (_kExecuteKey==sTriggerAddViewPort || _kExecuteKey==sDoubleClick))
//		{
//			_Viewport.append(getViewport(T("|Select a viewport|"))); 
//			setExecutionLoops(2);
//			return;
//		}	
//		return; // _Viewport array has some elParents
//	}
	


// element viewport/shopdraw viewport
	bIsElementViewport = el.bIsValid();
	Map mapParent, mapParents=_Map.getMap("Parent[]"); // the map wich stores the grip relation
	if (bIsElementViewport)
	{ 			
		segEl = el.segmentMinMax();
		segEl.transformBy(ms2ps);//segEl.vis(252);
		ptMidEl = segEl.ptMid();ptMidEl.vis(40);
		segPS = segEl;

	// Trigger AutomaticLocation
		int bAutomaticLocation = _Map.getInt("AutomaticLocation");
		String sTriggerAutomaticLocation =bAutomaticLocation?T("|Fixed Global Location|"):T("|Automatic Global Location|");
		addRecalcTrigger(_kContextRoot, sTriggerAutomaticLocation);
		if (_bOnRecalc && _kExecuteKey==sTriggerAutomaticLocation)
		{
			bAutomaticLocation = bAutomaticLocation ? false : true;
			_Map.setInt("AutomaticLocation", bAutomaticLocation);		
			setExecutionLoops(2);
			return;
		}

	// get/set offset of global dimline in relation to the element
		double dPerp  = abs(vecPerp.dotProduct(segEl.ptStart()-segEl.ptEnd()));	
		LineSeg segPerp(ptMidEl - vecPerp * .5 * dPerp, ptMidEl + vecPerp * .5 * dPerp);
		segPerp.vis(6);	
		double dLocOffset=_Map.getDouble("GlobalLocOffset");
		if (_kNameLastChangedProp=="_Pt0" || !_Map.hasDouble("GlobalLocOffset"))
		{
			dLocOffset = vecPerp.dotProduct(_Pt0 - segPerp.closestPointTo(_Pt0));//reportMessage("\nstoring dx " + dLocOffset);
			_Map.setDouble("GlobalLocOffset", dLocOffset);
			//reportMessage("\nsetting loc offset " + dLocOffset);
		}
		double dCurrentOffset = vecPerp.dotProduct(_Pt0 - segPerp.closestPointTo(_Pt0));
		if (abs(dLocOffset-dCurrentOffset)>dEps && bAutomaticLocation)
		{ 
			//reportMessage("\ntransforming dx " + (dLocOffset - dCurrentOffset));
			_Pt0 += vecPerp * (dLocOffset - dCurrentOffset);
		}

//	// set alignment of göobal dimlines
//		if (bIsGlobal)
//			nPerpAlignment=vecDir.dotProduct(_Pt0 - ptMidEl) < 0 ?- 1 : 1;

		if (mapParents.hasMap(el.handle()))
			mapParent = mapParents.getMap(el.handle());
			

	
			
	}
	else if (mapParents.hasMap("View"))
		mapParent = mapParents.getMap("View");
	//reportMessage("\nXXX is element viewport");




// get viewdirection in model
	Vector3d vecXView = _XW;	vecXView.transformBy(ps2ms);	vecXView.normalize();
	Vector3d vecYView = _YW;	vecYView.transformBy(ps2ms);	vecYView.normalize();
	Vector3d vecZView = _ZW;	vecZView.transformBy(ps2ms);	vecZView.normalize();
	//vecZView.vis(el.ptOrg(), 4);

// world plane in MS
	Plane pnZPS(_PtW, _ZW);
	Plane pnZMS = pnZPS;
	pnZMS.transformBy(ps2ms);
	CoordSys csMS = csW;
	csMS.transformBy(ps2ms);
	vecDirMS.transformBy(ps2ms);
	vecDirMS.normalize();
	vecPerpMS.transformBy(ps2ms);
	vecPerpMS.normalize();	
		
//// the viewport / section profile 
//	PlaneProfile ppVp, ppVpInverse, ppClip, ppParent;
//	if (bHasSection)
//	{ 
//		ppClip = bdClip.shadowProfile(Plane(clipVolume.coordSys().ptOrg(), clipVolume.viewFromDir()));
//		ppVp = ppClip;
//		ppVp.transformBy(ms2ps);
//		ppParent = ppVp;
//			
//	// get extents of profile
//		LineSeg seg = ppVp.extentInDir(_XW);;
//		ptCenVp = seg.ptMid();
//		dXVp = 10*abs(_XW.dotProduct(seg.ptStart()-seg.ptEnd()));
//		dYVp = 10*abs(_YW.dotProduct(seg.ptStart()-seg.ptEnd()));
//		ppVp.createRectangle(seg, _XW, _YW);
//		//_Pt0 = ppVp.closestPointTo(_Pt0);
//		if (!bIsGlobal)_Pt0 = clipVolume.coordSys().ptOrg();
//	}
//	else
//		ppVp.createRectangle(LineSeg(ptCenVp-.5*(_XW*dXVp+_YW*dYVp),ptCenVp+.5*(_XW*dXVp+_YW*dYVp)),_XW,_YW);
//
//End get defining viewport entity//endregion 	



//region Order tagging entities by sequence number
// order by sequence number
	TslInst tslSeqs[0];
	int nSequences[0];
	for (int i=0;i<entTags.length();i++) 
	{ 
		TslInst t = (TslInst)entTags[i];
		if (!t.bIsValid() || t.sequenceNumber()<0 || t.subMapXKeys().find(sSubXKey)<0) {continue;}
		
		Map m = t.subMapX(sSubXKey);
		
		Vector3d _vecZView = m.getVector3d("vecZView");
		if(!_vecZView.bIsZeroLength() && !_vecZView.isParallelTo(vecZView))
		{
			continue;
		}
		else			
		{
			tslSeqs.append(t);
			nSequences.append(t.sequenceNumber());
		}
		//t.subMapXKeys().find(sSubXKey) >-1)// sSubXKey qualifies tsls with protection area	
	}
	for (int i=0;i<tslSeqs.length();i++) 
		for (int j=0;j<tslSeqs.length()-1;j++) 
			if (nSequences[j]>nSequences[j+1])
			{
				tslSeqs.swap(j, j + 1);
				nSequences.swap(j, j + 1);
			}
				
// set sequence number during relevant events
	if (nSequence==0)//(_bOnDbCreated || _kNameLastChangedProp==sSequenceName) && 
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
















//region Filter all genbeams and collect bodies
	GenBeam gbDims[0],gbsAll[0];
	Body bodies[0]; // transformed to paperspace, same length and index as gbsAll!
	PlaneProfile shadows[0]; // dito
	
	int bCollectGenbeam = true;
	if (bAddOpening && bRefByElement)bCollectGenbeam = false;

	

	//if (bRefByZone || bDimByZone || bAddBeam || bRefByPainter || bDimByPainter)
	if (bCollectGenbeam)
	{ 
		// TRIAL HSB-12241
//		if (pdTemp.bIsValid())
//		{ 
//			beams = pdTemp.filterAcceptedEntities(beams);
//			sheets= pdTemp.filterAcceptedEntities(sheets);
//			sips = pdTemp.filterAcceptedEntities(sips);			
//		}	
		
	// get subset if refByZone and addOpening HSB-12241
		if (bAddOpening && (bRefByZone ||bRefByPainter))
		{ 
			Beam _beams[0];
			Sheet _sheets[0];
			Sip _sips[0];
			for (int i=0;i<openings.length();i++) 
			{ 
				Opening o = openings[i];
				PlaneProfile pp(o.plShape());
				
				
				if (em.bIsValid() && elMultis.length()>0)
				{
					int n = elMultis.find(o.element());
					Element e = o.element(); //e.plEnvelope().vis(3);
					CoordSys c = srefs[n].coordSys(), cs2em;
					cs2em.setToAlignCoordSys(e.ptOrg(), e.vecX(), e.vecY(), e.vecZ(), c.ptOrg(), c.vecX(), c.vecY(), c.vecZ() );
					pp.transformBy(cs2em);//pp.vis(5);
				}

				LineSeg seg = pp.extentInDir(vecDirMS);
				Point3d pt1 = seg.ptStart() + vecDirMS * U(10e4);
				Point3d pt2 = seg.ptEnd() - vecDirMS * U(10e4);
				seg = LineSeg(pt1, pt2);
				double dPerp = abs(vecPerpMS.dotProduct(seg.ptEnd() - seg.ptStart()));
				PLine pl; pl.createRectangle(seg, vecDirMS, vecPerpMS); //pl.vis(6);
				Body bd(pl, pl.coordSys().vecZ()*U(1000), 0);
				
				if (beams.length()>0)_beams.append(bd.filterGenBeamsIntersect(beams));
				if (sheets.length()>0)_sheets.append(bd.filterGenBeamsIntersect(sheets));
				if (sips.length()>0)_sips.append(bd.filterGenBeamsIntersect(sips));
				
				//bd.vis(5);
				 
			}//next i
			
			beams = _beams;
			sheets = _sheets;
			sips = _sips;
			
		}
		
		
		
		
		
		for (int i=beams.length()-1; i>=0 ; i--) 
		{ 
			if (gbsAll.find(beams[i])<0 && (!beams[i].bIsDummy() || bDimByPainter))	gbsAll.append(beams[i]); 
			else beams.removeAt(i);
		}//next i
		for (int i=sheets.length()-1; i>=0 ; i--) 
		{ 		
			if (gbsAll.find(sheets[i])<0 && (!sheets[i].bIsDummy()|| bDimByPainter))	gbsAll.append(sheets[i]); 
			else sheets.removeAt(i);
		}//next i		
		for (int i=sips.length()-1; i>=0 ; i--) 
		{ 
			if (gbsAll.find(sips[i])<0 && (!sips[i].bIsDummy()|| bDimByPainter))	gbsAll.append(sips[i]); 
			else sips.removeAt(i);
		}//next i
		

	// collect all bodies and ref and dim beams if specified	
		bodies.setLength(gbsAll.length());
		shadows.setLength(gbsAll.length());
		for (int i=gbsAll.length()-1; i>=0 ; i--) 
		{ 
			Body bd = gbsAll[i].realBodyTry();
			
		// kickout invalid	
			if (bd.volume()<pow(dEps,3))
			{ 
				gbsAll.removeAt(i);
				continue;
			}
			bd.transformBy(ms2ps);
			bodies[i]=bd;
			shadows[i]=bd.shadowProfile(pnZPS);
			
		}
	}

//region Append tooling tsls of genbeams
	for (int i=0;i<gbsAll.length();i++) 
	{ 
		GenBeam& gb= gbsAll[i];	
		Entity ents[]= gb.eToolsConnected(); 
		for (int j=0;j<ents.length();j++) 
		{ 
			TslInst t= (TslInst)ents[j]; 
			if (t.bIsValid() && tsls.find(t)<0)
				tsls.append(t);		 
		}//next j 
	}//next i
		
//End Append tooling tsls of genbeams//endregion 



	if (bDebug)
	{ 
		reportNotice("\n" + scriptName() + " collected: " 
		+"\n	"+ beams.length() + " beams" +
		+"\n	"+ sheets.length() + " sheets" +
		+"\n	"+ sips.length() + " sips" +
		+"\n	"+ tsls.length() + " tsls" +
		+"\n	"+ elements.length() + " elements" +
		+"\n	"+ openings.length() + " openings" + 
		+"\n	"+ bodies.length()  + " genbeam bodies");
	}
	
	
	
//End Filter all genbeams and collect bodies//endregion 

//region Filter genBeams to be dimensioned
	for (int i=0;i<gbsAll.length();i++) 
	{ 
		GenBeam gb = gbsAll[i]; 
		Body bd = bodies[i];

		if (bDimByPainter)
		{
			if (gb.acceptObject(painter.filter()))
			{ 
				String type = painter.type().makeLower();
				if (type == "beam")bAddBeam = true;
				else if (type == "sheet")bAddSheet = true;
				else if (type == "panel")bAddPanel = true;
			}
			else { continue; }
		}
		else if (bAddBeam && beams.find(gb)<0){ continue;}
		else if (bDimByZone && gbsAll[i].myZoneIndex()!=nZone){ continue;}

	// filter those which make contact to the section plane
		if (bHasSection)
		{ 
			PlaneProfile pp = bd.getSlice(pnSection);	
			if(!pp.area() > pow(dEpsPS, 2))
			{
				bd.vis(1);
				continue;
			}	
			else
			{ 
				;//bd.vis(3);
			}
		}
		gbDims.append(gb); 
	}//next i
		
//End Filter genBeams to be dimensioned//endregion 



//region the reference profile
	PlaneProfile ppRef(csW), ppZone(csW);
	Point3d ptsAllRefs[0];

// collect reference genbeams
	GenBeam gbRefs[0];
	Body bdRefs[0]; 
	for (int i = 0; i < gbsAll.length(); i++)
	{
		GenBeam gb = gbsAll[i];
		Body bd = bodies[i];

		if (gb.bIsDummy()){ continue;}	// ignore dummies
		else if (bRefByZone && gbsAll[i].myZoneIndex()!=nRefZone){ continue;}
		else if (bRefByPainter && !gb.acceptObject(painterRef.filter())){	continue;}// ignore rejected by painter

		gbRefs.append(gb);
		bdRefs.append(bd);
	}

// collect element reference
	if (bRefByElement)
	{
		Element _elements[0];
		_elements = em.bIsValid()?elMultis:elements;// HSB-11312
		for (int i=0;i<_elements.length();i++) 
		{ 
			Element e = _elements[i];
			Vector3d vecXE = e.vecX();
			Vector3d vecYE = e.vecY();
			Vector3d vecZE = e.vecZ();	
			CoordSys cs2em;
		// multi transformation // HSB-11312		
			if (em.bIsValid())
			{ 
				CoordSys c = srefs[i].coordSys();
				cs2em.setToAlignCoordSys(e.ptOrg(), e.vecX(), e.vecY(), e.vecZ(), c.ptOrg(), c.vecX(), c.vecY(), c.vecZ() );		
				vecXE.transformBy(cs2em);
				vecYE.transformBy(cs2em);
				vecZE.transformBy(cs2em);
				
			}			
			
			
			PLine pl;
			if (e.bIsKindOf(ElementWall()) && vecZView.isParallelTo(vecYE))
				pl = e.plOutlineWall();
			else if (vecZView.isParallelTo(vecZE))
				pl = e.plEnvelope();
			else
			{
				//element.segmentMinMax().vis(2);
				pl.createRectangle(e.segmentMinMax(), vecXView, vecYView);
			}
				
			if (pl.area()>pow(dEps,2))
			{ 
				
			
			// multi transformation // HSB-11312		
				if (em.bIsValid())
				{ 
					pl.transformBy(cs2em);
				}

				pl.transformBy(ms2ps);			
				ppRef.joinRing(pl, _kAdd);// pl.vis(6);				
			}

		}//next i			

		//ppRef.vis(6);
	}
	else if (bRefByZone || bRefByPainter)
	{ 
	// get ref profile
		for (int i=0;i<gbRefs.length();i++) 
		{ 
			int n = gbsAll.find(gbRefs[i]);
			
			PlaneProfile pp;
			if (n>-1)
			{ 
				pp = shadows[n];
			}
			else
			{ 
				Body bd= bdRefs[i];
				//bd.vis(gbRefs[i].bIsKindOf(Beam())?32:2);
				pp = bd.shadowProfile(pnZPS);
			}

			pp.intersectWith(ppView);
			PLine plRings[] = pp.allRings(true, false);
			for (int r=0;r<plRings.length();r++) 
			{
				//plRings[r].vis(4);
				ptsAllRefs.append(plRings[r].vertexPoints(true));
				ppRef.joinRing(plRings[r],_kAdd);
			}

			//ppRef.vis(4);
		}//next i
		ppRef.shrink(dEps);			ppRef.shrink(-dEps);
		//ppRef.vis(4);
	}

//End the reference profile//endregion 

// declare entity collections by type
	Entity ents[0], entsAll[0];

// transform direction to paperspace
	Vector3d vecXRead, vecYRead;
	vecXRead = vecPerp;
	vecYRead = vecXRead.crossProduct(-_ZW);
//	vecDir.transformBy(ps2ms);
//	vecDir.normalize();
//	vecPerp.transformBy(ps2ms);
//	vecPerp.normalize();	

	Map mapDims; 
	Map mapCustomLocations = _Map.getMap("CustomLocation[]"); // get a potential map of all elements in this dwg
	Point3d ptDimLocs[0];

// reference point of global dimensions refers to _Pt0 in modelspace
	int bIsValidRef=true;
	if (!bHasSection)
	{ 
		LineSeg seg(_Pt0 - vecYRead * U(10e4), _Pt0 + vecYRead * U(10e4)); //seg.vis(3);
		LineSeg segs[] = ppView.splitSegments(seg, true);
		bIsValidRef = segs.length() > 0;
	}

//region Protection area by sequence // HSB-8276 
	// collect protection areas of sequnced tagging tsl with a higher or equal sequence number
	PlaneProfile ppProtect(csW);
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
			if (pp.area() < pow(dEpsPS, 2)) { continue};
			
			if (ppProtect.area() < pow(dEpsPS, 2))	ppProtect = pp;
			else ppProtect.unionWith(pp);
		}
	}//next i
	if (ppProtect.area()>pow(dEpsPS,2))ppProtect.vis(bIsDark?4:1);		
//End Protection area by sequence//endregion 



//region Display
	Display dp(nc);
	dp.dimStyle(sDimStyle, 1/dScale);//,dLinearScale>0?1/dLinearScale:1);
	double dTextHeight = dp.textHeightForStyle("O",sDimStyle);
	dp.textHeight(dTextHeight);
//End Display//endregion	

// global collector of points
	Point3d ptDims[0];
	Point3d ptDimLoc = _Pt0;

//region maintain custom grips
	String keyCustomRef = "HasCustomRef" + (el.bIsValid() ? el.handle() : 0);
	Map mapRemovePoints = _Map.getMap("vecRemoval[]");
	Map mapAdd = _Map.getMap("vecAdd[]");
	int bHasCustomRef = _Map.getInt(keyCustomRef);
	if (bRefByUser && !bHasCustomRef) // it is not possible to get the user ref point on property change
	{ 
		reportMessage("\n" + sReferenceName + T(" |set to| ") + sRefByElement + T(". |Please pick reference point via context commands.|"));
		sReference.set(sRefByElement);
		setExecutionLoops(2);
		return;
	}
// remove customRef if it has been set for another element
	if (!bHasCustomRef && _bOnViewportsSetInLayout && _PtG.length()>mapAdd.length())
	{ 
		_PtG.removeAt(0);
	}	
// make sure grips stay at same location even when _Pt0 is moved	
	if (_kNameLastChangedProp=="_Pt0")
	{ 
		for (int i=0;i<mapAdd.length();i++) 
			if (i<_PtG.length())
				_PtG[i] =_PtW+mapAdd.getVector3d(i); 
	}
//End maintain custom grips//endregion

//region Get Contour
// get opening rings of frame
	PLine plFrameOpenings[0];
	plFrameOpenings=ppRef.allRings(false, true);
	
	PlaneProfile ppContour = ppRef;
	ppContour.intersectWith(ppView); // only within view
	ppContour.removeAllOpeningRings();
	//ppContour.vis(3);
	
	LineSeg seg = ppContour.extentInDir(vecDir);
	seg.vis(6);

	PLine(_PtW,_Pt0).vis(2);

// get refpoints	
	Point3d ptsRef[0];
	if (bHasCustomRef && _PtG.length()>0)
		ptsRef.append(_PtG.first());
	else if (ppContour.area()>pow(dEpsPS,2))
	{
		if (em.bIsValid()) // HSB-10160
		{ 
			PLine rings[] = ppContour.allRings(true, false);
			for (int r=0;r<rings.length();r++) 
			{ 
				LineSeg _seg= PlaneProfile(rings[r]).extentInDir(vecDir);
				ptsRef.append(_seg.ptStart());
				ptsRef.append(_seg.ptEnd());		 
			}//next r
		}
		else
		{ 
			ptsRef.append(seg.ptStart());
			ptsRef.append(seg.ptEnd());			
		}
		ptsRef = Line(_Pt0, vecDir).orderPoints(ptsRef, dEpsPS); // HSB-7788
	}
	
	if (nRefPointMode>0 && ptsRef.length()>0) // HSB-12370, refpoint mode added
	{
		Point3d _pts[0];	
		if (bRefFirst)	_pts.append(ptsRef.first());	// first or both
		if (bRefLast)	_pts.append(ptsRef.last());	// last or both
		if (bRefMid)	_pts.append((ptsRef.first()+ptsRef.last())/2);		// center	
		ptsRef = _pts;					
	}

//End Get Contour//endregion 
		
//End Part 2//endregion 


//region Part #3
//region #Beams
	if(bAddBeam || bDimByZone)
	{ 	
	// collect profiles to be dimensioned, if point mode is set to be merged, collect merged profiles
		PlaneProfile pps[0], ppMerged;
		Entity entParents[0];
		for (int i = 0; i < gbDims.length(); i++)
		{
			Point3d ptDims[0];
			GenBeam b = gbDims[i];
			if (beams.find(b) < 0) { continue; }
			int n = gbsAll.find(b);
			if (n < 0)continue;
			//Body bd = bodies[n];//bd.vis(6);
			PlaneProfile pp = shadows[n];
			
			if (nDimPointMode<6)// not merged
			{
				pps.append(pp);
				entParents.append(b);
			}
			else
			{ 
				pp.shrink(-dEps);
				ppMerged.unionWith(pp);
			}			
		}
		if (pps.length()<1)
		{ 
			ppMerged.shrink(dEps);			//ppMerged.vis(5);
			PLine rings[] = ppMerged.allRings(true, false);
			for (int r=0;r<rings.length();r++) 
			{ 
				PlaneProfile pp(csW);
				pp.joinRing(rings[r], _kAdd);
				pps.append(pp); 
				entParents.append(Entity());
			}//next r	
		}

	// loop profiles
		for (int i=0;i<pps.length();i++) 
		{ 

			PlaneProfile pp = pps[i];
			pp.intersectWith(ppView);//pp.vis(32);		
			
			LineSeg seg = pp.extentInDir(vecDir);
			seg.vis(40);
			Point3d pts[] = { seg.ptStart(),seg.ptEnd()};//bd.extremeVertices(vecDir);;
			if (pp.area()<pow(dEpsPS,2)|| pts.length() < 1)continue;
			if (bDimFirst)	ptDims.append(pts.first());	// first or both
			if (bDimLast)	ptDims.append(pts.last());	// last or both
			if (bDimMid)	ptDims.append((pts.first()+pts.last())/2);		// center	

		// order and/or remove points by custom request		
			ptDims.append(_PtG);	// append custom points
			ptDims = Line(_Pt0, vecDir).orderPoints(ptDims, dEpsPS); // HSB-7788
			if (mapRemovePoints.length()>0)
			{ 
				for (int i=0;i<mapRemovePoints.length();i++) 
				{ 
					Point3d pt = _PtW+mapRemovePoints.getVector3d(i); 
					for (int j=ptDims.length()-1; j>=0 ; j--) 
						if (abs(vecDir.dotProduct(pt-ptDims[j]))<dEps)
							ptDims.removeAt(j); 
				}//next i	
			}	
			
		// reference points	
			for (int i=ptsRef.length()-1; i>=0 ; i--) 
				ptDims.insertAt(0,ptsRef[i]);

		// store in map
			Map map;
			map.setEntity("parentEnt",entParents[i]);// b);
			map.setPoint3d("ptLoc", bIsGlobal?ptDimLoc:seg.ptMid());
			map.setPoint3dArray("pts", ptDims);
			map.setPlaneProfile("visibleShape", pp);
			mapDims.appendMap("Dim", map);		
		}//next i
	}
//End Beams//endregion 

//region #Sheet
	if (bAddSheet || bDimByZone)
	{ 
	// collect profiles to be dimensioned, if point mode is set to be merged, collect merged profiles
		PlaneProfile pps[0], ppMerged;
		Entity entParents[0];
		for (int i = 0; i < gbDims.length(); i++)
		{
			Point3d ptDims[0];
			GenBeam b = gbDims[i];
			if (sheets.find(b) < 0) { continue; }
			int n = gbsAll.find(b);
			if (n < 0)continue;
			PlaneProfile pp = shadows[n];		
			if (nDimPointMode<6)// not merged
			{
				pps.append(pp);
				entParents.append(b);
			}
			else
			{ 
				pp.shrink(-dEps);
				ppMerged.unionWith(pp);
			}			
		}
		if (pps.length()<1)
		{ 
			ppMerged.shrink(dEps);			ppMerged.vis(5);
			PLine rings[] = ppMerged.allRings(true, false);
			for (int r=0;r<rings.length();r++) 
			{ 
				PlaneProfile pp(csW);
				pp.joinRing(rings[r], _kAdd);
				pps.append(pp); 
				entParents.append(Entity());
			}//next r	
		}

	// loop profiles
		for (int i=0;i<pps.length();i++) 
		{ 

			PlaneProfile pp = pps[i];		
			pp.intersectWith(ppView);
			LineSeg seg = pp.extentInDir(vecDir);
			Point3d pts[] = { seg.ptStart(),seg.ptEnd()};//bd.extremeVertices(vecDir);;
			if (pp.area()<pow(dEps,2)|| pts.length() < 1)continue;
			if (bDimFirst)	ptDims.append(pts.first());	// first or both
			if (bDimLast)	ptDims.append(pts.last());	// last or both
			if (bDimMid)	ptDims.append((pts.first()+pts.last())/2);		// center	

		// order and/or remove points by custom request		
			ptDims.append(_PtG);	// append custom points
			ptDims = Line(_Pt0, vecDir).orderPoints(ptDims, dEpsPS); // HSB-7788
			if (mapRemovePoints.length()>0)
			{ 
				for (int i=0;i<mapRemovePoints.length();i++) 
				{ 
					Point3d pt = _PtW+mapRemovePoints.getVector3d(i); 
					for (int j=ptDims.length()-1; j>=0 ; j--) 
						if (abs(vecDir.dotProduct(pt-ptDims[j]))<dEps)
							ptDims.removeAt(j); 
				}//next i	
			}	
			
		// reference points	
			for (int i=ptsRef.length()-1; i>=0 ; i--) 
				ptDims.insertAt(0,ptsRef[i]);

		// store in map
			Map map;
			map.setEntity("parentEnt",entParents[i]);// b);
			map.setPoint3d("ptLoc", bIsGlobal?ptDimLoc:seg.ptMid());
			map.setPoint3dArray("pts", ptDims);
			map.setPlaneProfile("shape", pp);
			map.setPlaneProfile("visibleShape", pp);
			mapDims.appendMap("Dim", map);		
		}//next i

	}
//End Sheet//endregion 

//region #Panel
	if (bAddPanel || bDimByZone)
	{ 

	// collect profiles to be dimensioned, if point mode is set to be merged, collect merged profiles
		PlaneProfile pps[0], ppMerged;
		Entity entParents[0];
		for (int i = 0; i < gbDims.length(); i++)
		{
			GenBeam b = gbDims[i];		
			if (sips.find(b) < 0) { continue; }
			int n = gbsAll.find(b);
			if (n < 0)continue;
				
			PlaneProfile pp = shadows[n];		
			if (nDimPointMode<6)// not merged
			{
				pps.append(pp);
				entParents.append(b);
			}
			else
			{ 
				pp.shrink(-dEps);
				ppMerged.unionWith(pp);
			}			
		}
		if (pps.length()<1)
		{ 
			ppMerged.shrink(dEps);			//ppMerged.vis(5);
			PLine rings[] = ppMerged.allRings(true, false);
			for (int r=0;r<rings.length();r++) 
			{ 
				PlaneProfile pp(csW);
				pp.joinRing(rings[r], _kAdd);
				pps.append(pp); 
				entParents.append(Entity());
			}//next r	
		}

	// loop profiles
		for (int i=0;i<pps.length();i++) 
		{ 
			Point3d ptDims[0];
			PlaneProfile pp = pps[i];		

			pp.intersectWith(ppView);
			LineSeg seg = pp.extentInDir(vecDir);
			Point3d pts[] = { seg.ptStart(),seg.ptEnd()};//bd.extremeVertices(vecDir);;
			if (pp.area() < pow(dEps, 2) || pts.length() < 1) { continue; }

			if (bDimFirst)	ptDims.append(pts.first());	// first or both
			if (bDimLast)	ptDims.append(pts.last());	// last or both
			if (bDimMid)	ptDims.append((pts.first()+pts.last())/2);		// center

			if (nDimPointMode<6 && i<sips.length()) // wirechases not supported for merged point mode
			{ 
				Sip sip = sips[i];
			// add wirechases
				int bAddWirechase = sStereotypes.findNoCase("Wirechase" ,- 1)>-1;
				if (bAddWirechase && sip.bIsValid())
				{ 
					LineSeg segs[] = sip.getWirechaseSegs();
					Point3d pts[0];
					for (int j=0;j<segs.length();j++) 
					{ 
						segs[j].transformBy(ms2ps);
						pts.append(segs[j].ptStart());
						pts.append(segs[j].ptEnd());	 
					}//next j
					pts = Line(_Pt0, vecDir).orderPoints(pts, dEpsPS);

					if (bDimFirst)	ptDims.append(pts.first());	// first or both
					if (bDimLast)	ptDims.append(pts.last());	// last or both
					if (bDimMid)	ptDims.append((pts.first()+pts.last())/2);		// center		
				}		
			}

		// order and/or remove points by custom request		
			ptDims.append(_PtG);	// append custom points
			ptDims = Line(_Pt0, vecDir).orderPoints(ptDims, dEpsPS); // HSB-7788
			if (mapRemovePoints.length()>0)
			{ 
				for (int i=0;i<mapRemovePoints.length();i++) 
				{ 
					Point3d pt = _PtW+mapRemovePoints.getVector3d(i); 
					for (int j=ptDims.length()-1; j>=0 ; j--) 
						if (abs(vecDir.dotProduct(pt-ptDims[j]))<dEps)
							ptDims.removeAt(j); 
				}//next i	
			}	
			
		// reference points	
			for (int i=ptsRef.length()-1; i>=0 ; i--) 
				ptDims.insertAt(0,ptsRef[i]);

		// store in map
			Map map;
			map.setEntity("parentEnt",entParents[i]);// b);
			map.setPoint3d("ptLoc", bIsGlobal?ptDimLoc:seg.ptMid());
			map.setPoint3dArray("pts", ptDims);
			//map.setPlaneProfile("shape", pp);
			map.setPlaneProfile("visibleShape", pp);
			mapDims.appendMap("Dim", map);		
		}//next i

	}
//End Panel//endregion 

//region #Element
	if (bAddElement)
	{ 
		Point3d ptLoc = _Pt0; // the global location
		
		Element _elements[0];
		_elements = em.bIsValid()?elMultis:elements;// HSB-11312
		for (int i=0;i<_elements.length();i++) 
		{ 
			Element e = _elements[i]; 
			ElementWall wall = (ElementWall)_elements[i]; 
			ElementRoof roof= (ElementRoof)_elements[i]; 
			
			Vector3d vecXE = _elements[i].vecX();
			Vector3d vecYE = _elements[i].vecY();
			Vector3d vecZE = _elements[i].vecZ();

		// multi transformation // HSB-11312		
			if (em.bIsValid())
			{ 
				CoordSys c = srefs[i].coordSys(), cs2em;
				cs2em.setToAlignCoordSys(e.ptOrg(), e.vecX(), e.vecY(), e.vecZ(), c.ptOrg(), c.vecX(), c.vecY(), c.vecZ() );		
				vecXE.transformBy(cs2em);
				vecYE.transformBy(cs2em);
				vecZE.transformBy(cs2em);
			}


			PlaneProfile ppShape;
			if (wall.bIsValid())
			{ 
				if (vecZView.isParallelTo(vecZE))
					ppShape=PlaneProfile(wall.plEnvelope());
				else if (vecZView.isParallelTo(vecYE))
					ppShape=PlaneProfile(wall.plOutlineWall());
				else 
				{ 
					ppShape = wall.realBody().shadowProfile(Plane(csMS.ptOrg(), vecZView));
				}
			}
			else if (roof.bIsValid())
			{ 
				if (vecZView.isParallelTo(vecZE))
					ppShape=PlaneProfile(roof.plEnvelope());
				else 
				{ 
					LineSeg seg = roof.segmentMinMax();
					double dZ = abs(vecZE.dotProduct(seg.ptStart() - seg.ptEnd()));
					Body bd(roof.plEnvelope(), vecZE * dZ ,- 1);
					ppShape = bd.shadowProfile(Plane(csMS.ptOrg(), vecZView));
				}
			}	
			
		// multi transformation // HSB-11312
			if (em.bIsValid())
			{ 
				CoordSys c = srefs[i].coordSys(), cs2em;
				cs2em.setToAlignCoordSys(e.ptOrg(), e.vecX(), e.vecY(), e.vecZ(), c.ptOrg(), c.vecX(), c.vecY(), c.vecZ() );		
				ppShape.transformBy(cs2em);	
			}
			
			
			
			ppShape.transformBy(ms2ps);						//ppShape.vis(4);
			
		// the dimpoints and the default location
			LineSeg seg = ppShape.extentInDir(vecDir);		//seg.vis(i);
			if (!bIsGlobal)		
				ptLoc = seg.ptMid();
			Point3d ptDims[0];			
			
		// mid point
			if (nDimPointMode==2)				
				ptDims.append(seg.ptMid());
		// get extremes of element		
			else if (nDimPointMode!=3)	
				ptDims.append(seg.ptStart());	// first or both
			if (nDimPointMode!=2 && nDimPointMode!=1)	
				ptDims.append(seg.ptEnd());	// last or both		 				


		// add wirechases
			int bAddWirechase = sStereotypes.findNoCase("Wirechase" ,- 1)>-1;
			if (bAddWirechase && sips.length()>0)
			{ 
				for (int ii=0;ii<sips.length();ii++) 
				{ 
					Sip sip= sips[ii]; 
					if (sip.element()!=_elements[i]){ continue;}
					LineSeg segs[] = sip.getWirechaseSegs();
					Point3d pts[0];
					for (int j=0;j<segs.length();j++) 
					{ 
						segs[j].transformBy(ms2ps);
						pts.append(segs[j].ptStart());
						pts.append(segs[j].ptEnd());	 
					}//next j
					pts = Line(_Pt0, vecDir).orderPoints(pts, dEpsPS);
					
					ptDims.append(pts);		 
				}//next ii
			}	

		// store in map	
			Map map;
			map.setEntity("parentEnt", _elements[i]);
			map.setPoint3d("ptLoc", ptLoc);
			map.setPoint3dArray("pts", ptDims);
			mapDims.appendMap("Dim", map);
 
		}//next i

	}
//End #Element//endregion 

//region #Openings
	if (bAddOpening)
	{ 
		Point3d ptLoc = _Pt0; // the global location

	// order openings by area: the location of the smallest opening has highest priority in placement
		PLine plShapes[0];
		for (int i=0;i<openings.length();i++) 
		{
			Opening& o = openings[i];
			PLine plShape = o.plShape();
			
		// transform multi element opening shapes // HSB-10160
			if (em.bIsValid())
			{ 
				Element e = o.element();
				CoordSys csSingle;
				for (int j=0;j<srefs.length();j++) 
				{ 
					if (srefs[j].number().makeUpper()==e.number().makeUpper())
					{
						csSingle=srefs[j].coordSys(); 
						break;
					}	 
				}//next j
				CoordSys cs2em;
				cs2em.setToAlignCoordSys(e.ptOrg(), e.vecX(), e.vecY(), e.vecZ(), csSingle.ptOrg(), csSingle.vecX(), csSingle.vecY(), csSingle.vecZ() );
				plShape.transformBy(cs2em);				
			}
			plShapes.append(plShape);
		}
		for (int i=0;i<plShapes.length();i++) 
			for (int j=0;j<plShapes.length()-1;j++) 
				if (plShapes[j].area()>plShapes[j+1].area())
				{
					plShapes.swap(j, j + 1);
					openings.swap(j, j + 1);
				}



	// loop openings and identify opening relation	
		for (int i=0;i<plShapes.length();i++) 
		{ 
			PLine plShape = plShapes[i];
			plShape.transformBy(ms2ps); 
			PlaneProfile ppShape(plShape);
			Point3d ptMid = ppShape.extentInDir(vecXView).ptMid();
			int bFound;
			for (int j=0;j<plFrameOpenings.length();j++) 
			{ 
				if (PlaneProfile(plFrameOpenings[j]).pointInProfile(ptMid)!=_kPointOutsideProfile)
				{
					plShape = plFrameOpenings[j];
					ppShape = PlaneProfile(plShape);
					ptMid = ppShape.extentInDir(vecXView).ptMid();
					bFound=true;
					break;
				}
			}//next j

		// the dimpoints and the default location
			if (!bIsGlobal)		ptLoc = ptMid;
			Point3d pts[0];			
			LineSeg seg = ppShape.extentInDir(vecXView);		seg.vis(i);
		// mid point
			if (nDimPointMode==2)				pts.append(ptMid);
		// get extremes of opening		
			else
			{ 
				if (nDimPointMode==0 || nDimPointMode==1 || nDimPointMode==4 || nDimPointMode==5)	pts.append(seg.ptStart());	// first or both
				if (nDimPointMode==0 || nDimPointMode==3 || nDimPointMode==4 || nDimPointMode==5)	pts.append(seg.ptEnd());	// last or both		 				
			}

		//region Get reference points of Contour
			if (ppContour.area()>pow(dEpsPS,2) && (!bIsGlobal || i==0)) // only once in global
			{ 
			// get intersection	in opening range
				PlaneProfile pp = ppContour;
				if (!bIsGlobal)
				{ 
					Point3d pt1 = seg.ptStart()-vecDir*U(10e4);
					Point3d pt2 = seg.ptEnd()+vecDir*U(10e4);
					pp.createRectangle(LineSeg(pt1, pt2), vecDir, vecPerp);
					pp.intersectWith(ppContour);
					
				}
				LineSeg _seg = pp.extentInDir(vecDir);	//_seg.vis(40);
				pts.append(_seg.ptStart());
				pts.append(_seg.ptEnd());
				
			}
			
		//End contour//endregion 

		// append custom points and order
			pts.append(_PtG);
			pts = Line(_Pt0, vecDir).orderPoints(pts, dEpsPS); // HSB-7788
			//ptDims.append(pts);
			
			for (int i=ptsRef.length()-1; i>=0 ; i--) 
				pts.insertAt(0,ptsRef[i]);	
		
		// store in map
			Map map;
			map.setEntity("parentEnt", openings[i]);
			map.setPoint3d("ptLoc", ptLoc);
			map.setPoint3dArray("pts", pts);
			map.setPlaneProfile("visibleShape", ppShape);
			mapDims.appendMap("Dim", map);

		}//next i
	}
//End Openings
//endregion 

//region #Tsl
	if (bAddTsl)
	{ 
		
		String k;
		
		CoordSys cs2em; // HSB-12370
		int bMulti;
		if (srefs.length()>0)
		{ 
			Element e = elMultis.first();
			CoordSys c = srefs[0].coordSys();
			cs2em.setToAlignCoordSys(e.ptOrg(), e.vecX(), e.vecY(), e.vecZ(), c.ptOrg(), c.vecX(), c.vecY(), c.vecZ() );
			bMulti = true;
		}		
	
	//region Collect requests from tsls
		Map mapRequests;
		for (int i=tsls.length()-1; i>=0 ; i--) 
		{ 
			TslInst t = tsls[i];


		// query mapX based requests
			Map mapX = t.subMapX(sKeyDimInfo);
			int bHasRequest = mapX.hasMap("DimRequest[]");
			Map _mapRequests = mapX.getMap("DimRequest[]");
			for (int j=0;j<_mapRequests.length();j++) 
			{ 
				Map mapRequest = _mapRequests.getMap(j);
				mapRequest.setEntity("ParentEnt", t);
				String stereotype = mapRequest.getString("Stereotype");
				if (bMulti) mapRequest.transformBy(cs2em);// HSB-12370
				if (bHasStereotype && sStereotypes.findNoCase(stereotype,-1)>-1)
				{ 
					mapRequests.appendMap("DimRequest", mapRequest);
				}
			}//next j
			
		// continue if mapX based requests defined	
			if (bHasRequest)
			{
				continue;
			}
			
		// collect default location if stereotype matches scriptName
			if (sStereotypes.findNoCase(t.scriptName(),-1)>-1)
			{ 
				Point3d pts[] ={t.ptOrg()}; 
				Map m;
				m.setVector3d("vecDimLineDir", bIsVertical ? vecYView : vecXView);
				m.setVector3d("vecPerpDimLineDir", bIsVertical ? -vecXView : vecYView);//t.coordSys().vecY());
				m.setVector3d("AllowedView", vecZView);
				m.setPoint3dArray("Node[]",pts);
				m.setEntity("ParentEnt", t);
				m.setInt("AlsoReverseDirection", true);
				if (bMulti) m.transformBy(cs2em);// HSB-12370
				mapRequests.appendMap("DimRequest", m);	
			}
			
		}//next i			
	//End Collect requests from tsls//endregion 

	//region Collect dimpoints from requests
		for (int i=0;i<mapRequests.length();i++) 
		{ 
			Map m = mapRequests.getMap(i); 
			m.transformBy(ms2ps);
			int bOk = true;
			int bAlsoReverse = m.getInt("AlsoReverseDirection");
			
		// test view	
			Vector3d vecAllowedView= m.getVector3d("AllowedView"); 
			if (vecAllowedView.bIsZeroLength() || (!vecAllowedView.isParallelTo(vecZPS) || (!bAlsoReverse && !vecAllowedView.isCodirectionalTo(vecZPS))))
				bOk = false;
		
		//region TEXT request
			if (m.hasString("Text") && m.hasPoint3d("ptLocation"))
			{ 
				
			// test read direction	
				Vector3d vecX= m.getVector3d("vecX"); 
				if (vecX.bIsZeroLength() || (!vecX.isParallelTo(vecDir)))bOk = false;
 
				Vector3d vecY; k = "vecY"; if (m.hasVector3d(k))vecY = m.getVector3d(k);else vecY = vecX.crossProduct(-vecZPS);
				Point3d ptTxt; k = "ptLocation"; if (m.hasPoint3d(k))ptTxt = m.getPoint3d(k);else bOk = false;
				double dXFlag = 0; k = "dXFlag"; if (m.hasDouble(k))dXFlag = m.getDouble(k);
				double dYFlag = 0; k = "dYFlag"; if (m.hasDouble(k))dYFlag = m.getDouble(k);				
				String text; k = "Text"; text = m.getString(k);
				if (!bOk || text.length()<1){continue;}	
				
			// project given location to dimline location
				if (m.getInt("ProjectToDimline"))
				{
					double d = vecY.dotProduct(_Pt0 - ptTxt)+dTextHeight;
					ptTxt += vecY * d;
				}

			// get bounds
				PlaneProfile ppBox;
				double dX = .5*dp.textLengthForStyle(text, sDimStyle,dTextHeight);
				double dY = dp.textHeightForStyle(text,sDimStyle,dTextHeight);
				ppBox.createRectangle(LineSeg(ptTxt - vecX*dX, ptTxt + vecX*dX + vecY*dY), vecX, vecY);
				ppBox.transformBy(vecX * (dXFlag==0?0:dXFlag/abs(dXFlag))*dX);
				
			// try 4x to transform until collision free
				for (int x=0;x<4;x++) 
				{ 
					PlaneProfile pp = ppProtect;
					pp.intersectWith(ppBox);
					if (pp.area()>pow(dEps,2))
					{ 
						ppBox.transformBy(vecY * dTextHeight*1.5);
						ptTxt.transformBy(vecY * dTextHeight*1.5);
					} 
					else
						break;
				}//next x
				ppProtect.unionWith(ppBox);	//ppBox.vis(6);
				dp.draw(text, ptTxt, vecX, vecX.crossProduct(-_ZW), dXFlag, dYFlag );
			}				
		//End TEXT request//endregion 

		//region DIMREQUESTPOINT
			else
			{ 
			// test direction	
				Vector3d vecDimLineDir= m.getVector3d("vecDimLineDir"); 
				if (vecDimLineDir.bIsZeroLength() || 
					(bIsVertical && !vecDimLineDir.isParallelTo(_YW)) ||
					(!bIsVertical && !vecDimLineDir.isParallelTo(_XW)))
					bOk = false;			
				if (!bOk)
				{ 
					continue;
				}
			
			// consider point mode HSB-12333 HSB-12370
				Point3d pts[] = Line(_Pt0, vecDir).orderPoints(m.getPoint3dArray("Node[]"));	
				if (nDimPointMode>0)
				{
					Point3d _pts[0];	
					if (nDimPointMode==1 || nDimPointMode==4 || nDimPointMode==5)	_pts.append(pts.first());	// first or both
					if (nDimPointMode==3 || nDimPointMode==4 || nDimPointMode==5)	_pts.append(pts.last());	// last or both
					if (nDimPointMode==2)	_pts.append((pts.first()+pts.last())/2);		// center	
					pts = _pts;					
				}

			// local
				if (!bIsGlobal)
				{ 
					Point3d ptLoc;
					ptLoc.setToAverage(pts);
					pts.append(_PtG);	// append custom points
					if (pts.length()>0)
					{ 	
						pts = Line(_Pt0, vecDir).orderPoints(pts, dEpsPS); // HSB-7788
						for (int i=ptsRef.length()-1; i>=0 ; i--) 
							pts.insertAt(0,ptsRef[i]);			
					}	
						
				// store in map
					Map map;
					map.setEntity("parentEnt", m.getEntity("ParentEnt"));
					map.setPoint3d("ptLoc", ptLoc);
					map.setPoint3dArray("pts", pts);
					if (pts.length()>1)
						mapDims.appendMap("Dim", map);					
				}
			// global
				else
				{ 
					ptDims.append(pts);
				}
			}				
		//End DIMREQUESTPOINT//endregion 

		}//next i
					
	//End Collect dimpoints from requests//endregion 

	//region Append ref points if any dimpoint found
		if (bIsGlobal)
		{ 
			ptDims.append(_PtG);	// append custom points
			if (ptDims.length()>0)
			{ 	
				ptDims = Line(_Pt0, vecDir).orderPoints(ptDims, dEpsPS); // HSB-7788
				for (int i=ptsRef.length()-1; i>=0 ; i--) 
					ptDims.insertAt(0,ptsRef[i]);			
			}			
		// Draw dimline at location
			ptDimLocs.append(ptDimLoc);			
		}
			
	//End Append ref points if any dimpoint found//endregion 

	}
//End Tsl
//endregion 
		
//End Part #3//endregion 


//region Assignment and sublayers
	int bAssignToToolLayer = ptDims.length() < 2;
	if (bHasSection)
	{
		_ThisInst.assignToGroups(section, 'D');
		//_ThisInst.assignToGroups(section, (bAssignToToolLayer?'T':'D'));
	}
//End Assignment and sublayers//endregion 


//region Get bounding profile to snap extension lines to HSB-10429
	PlaneProfile ppSnap(csW);
	if (bIsGlobal)
	{ 
		GenBeam gbs[0];
		gbs = gbRefs.length() > 0 ? gbRefs : gbDims;

		for (int i=0;i<gbs.length();i++) 
		{ 
			int n = gbsAll.find(gbs[i]); 
			if (n<0){ continue;}
			
			PLine rings[] = shadows[n].allRings(true, false);
			for (int r=0;r<rings.length();r++) 
				ppSnap.joinRing(rings[r], _kAdd); 

		}//next i
		
		//ppSnap.shrink(-.1 * dTextHeight);
		
		ppSnap.removeAllOpeningRings();
//		PLine rings[] = ppSnap.allRings(true, false);
//		int cnt=1;
//		PlaneProfile pp = ppSnap;
//		double d = (pp.dX() > pp.dY() ? pp.dX() : pp.dY()) * .002;
//		while (rings.length()>1 && cnt<50)
//		{ 
//			pp.shrink(-d*cnt);//pp.vis(cnt);
//			pp.shrink(d*cnt);			
//			rings = pp.allRings(true, false);
//			cnt++;
//		}
//		if (cnt > 1)ppSnap = pp;
		
		
		
		//ppSnap.vis(1);
	}
//End Get bounding profile to snap extension lines to//endregion 






//region Draw Dimensions
	Point3d ptLocGlobalDescription = _Pt0;
// map based
	Map mapTemp;
	if (mapDims.length()>0)
	{ 
		String k;
		for (int i=0;i<mapDims.length();i++) 
		{ 
			int bIsLast = i == mapDims.length() - 1;
			Map m = mapDims.getMap(i);
			Entity entParent;
			k = "ptLoc"; if(m.hasPoint3d(k)) ptDimLoc = m.getPoint3d(k); else { continue;}
			k = "pts"; 
			if(m.hasPoint3dArray(k)) 
			{
				if (bIsGlobal)
				{
					ptDims.append(m.getPoint3dArray(k));
					if(!bIsLast) { continue};
				}
				else
					ptDims = m.getPoint3dArray(k);
			}
			else if(!bIsLast) { continue};
			k = "parentEnt"; if(m.hasEntity(k)) entParent = m.getEntity(k); else { continue;}
			
			PlaneProfile ppVisible;
			k = "visibleShape"; if(m.hasPlaneProfile(k))  ppVisible = m.getPlaneProfile(k);
			
			//ppVisible.vis(3);
			
		// Local protection area
			Vector3d vecP = vecPerp;
			if (!bIsGlobal)
			{ 
			// get custom location if set	
				int bIsCustomLoc;
				k = entParent.handle(); 	
				if (mapCustomLocations.hasPoint3d(k)) 	
				{
					ptDimLoc = mapCustomLocations.getPoint3d(k);	
					bIsCustomLoc = true;
				}
				
			// get dimpoints by shape at dimline location	
				k = "Shape";
				if(m.hasPlaneProfile(k)) 
				{
					PlaneProfile shape = m.getPlaneProfile(k);
					Plane pn (shape.closestPointTo(ptDimLoc), vecPerp);
					ptDims = shape.intersectPoints(pn,true,true); 
					
					ptDims.append(_PtG);	// append custom points
					ptDims = Line(_Pt0, vecDir).orderPoints(ptDims, dEpsPS); // HSB-7788
					
					if (nDimPointMode==5 && ptDims.length()>2)
					{ 
						ptDims.swap(1, ptDims.length() - 1);
						ptDims.setLength(2);
					}
					
					
					for (int ii=ptsRef.length()-1; ii>=0 ; ii--) 
						ptDims.insertAt(0,ptsRef[ii]);	
				}
				
				ptDimLoc += _ZW * _ZW.dotProduct(_Pt0 - ptDimLoc);
				Point3d pts[] = Line(ptDimLoc, vecDir).projectPoints(ptDims);

			//region // Try to get collision free placement of dim HSB-8276
				if (pts.length()>1 && !bIsCustomLoc)
				{ 
					DimLine dl(ptDimLoc, vecDir, vecPerp);
					Dim dim(dl, pts, "<>", "<>", nDeltaMode,nChainMode);
					dim.setDeltaOnTop(bSwapDeltaChain);
					PLine plines[] = dim.getTextAreas(dp);
					
					PlaneProfile pp(csW);
					//pp.createRectangle(LineSeg(pts.first()-vecPerp*.1*dTextHeight, pts.last()+vecPerp*.1*dTextHeight),vecDir, vecPerp);
					for (int x=0;x<plines.length();x++) 
						pp.joinRing(plines[x],_kAdd);
					pp.shrink(-.75*dTextHeight); // merge
					pp.shrink(.5*dTextHeight);
					pp.vis(i+6); 
				
				// no protection area yet
					if (ppProtect.area()<pow(dEpsPS,2))
						ppProtect = pp;
				// try placement 20 attempts per side if sequencing isn't disabled'
					else if (nSequence>-1)
					{ 
						PlaneProfile ppX = ppProtect;
						ppX.intersectWith(pp);
						
						// buffer best area and offset
						double bestArea=ppX.area();
						Vector3d bestOffset;
						
						int bHasInterference = bestArea > pow(dEpsPS, 2);
						
//						{ 
//							Display dp(1);
//							dp.draw(ppX, _kDrawFilled);
//						}
						
						int cnt;
						int lr = -1;
						Point3d ptNew = ptDimLoc;
						while (cnt<40 && bHasInterference)
						{ 
							int n = cnt / 2+1;
							Vector3d thisOffset = n * lr * vecPerp * dTextHeight * .75;
							lr*=-1;	
							cnt++;	
							ptNew = ptDimLoc+thisOffset;		//ptNew.vis(cnt);
							
						// validate if still within local range
							if (ppVisible.area()>0)
							{ 
								PlaneProfile _pp = ppVisible;
								_pp.shrink(-dTextHeight); // blowup by text height to allow dimlines near tro the visible profile
								LineSeg s[] = _pp.splitSegments(LineSeg(ptNew - vecDir * U(10e4), ptNew + vecDir * U(10e4)), true);
								if (s.length() < 1){continue;} // do not use this location as it does not intersect the visible range
							}

							pp.transformBy(vecPerp * vecPerp.dotProduct(ptNew - ptDimLoc));

							ppX = ppProtect;
							ppX.intersectWith(pp);
							double thisArea=ppX.area();
							bHasInterference = thisArea > pow(dEpsPS, 2);
//							if (bHasInterference)
//							{ 
//								Display dp(cnt);
//								dp.draw(ppX, _kDrawFilled);
//							}
							
							
							if (thisArea<bestArea) // keep best solution in case it cannot be fully resolved
							{ 
								bestArea = thisArea;
								bestOffset = thisOffset;
							}
						}
						
						if (!bHasInterference)
						{
							//pp.vis(40);
							ptDimLoc = ptNew;	//ptDimLoc.vis(5);
						}
						else
						{ 
							ptDimLoc = ptDimLoc+bestOffset;
							ptDimLoc.vis(5);
						}
						
						ppProtect.unionWith(pp);
						pts = Line(ptDimLoc, vecDir).projectPoints(pts);
					}
					m.setPoint3d("ptLoc", ptDimLoc);
				}
									
			//End // Try to get collision free placement of dim HSB-8276//endregion 

			// project dimpoints to current location
				Line lnDim(ptDimLoc, vecDir);
				if (ppVisible.area()>pow(dEpsPS,2))
				{ 
					PlaneProfile pp(CoordSys(ptDimLoc, vecDir, vecPerp, vecDir.crossProduct(vecPerp)));
					LineSeg seg = ppVisible.extentInDir(vecDir);
					Vector3d vecA= abs(vecPerp.dotProduct(seg.ptStart() - seg.ptEnd()))*.5*vecPerp+vecDir * U(10e4);
					Point3d ptMid = ppVisible.ptMid();
					pp.createRectangle(LineSeg(ptMid - vecA, ptMid + vecA), vecDir, vecPerp);
					pp.shrink(-dTextHeight);
					//pp.vis(3);
					for (int p=0;p<ptDims.length();p++) 
					{ 
						Point3d pt = ptDims[p];
						if (pp.pointInProfile(pt)==_kPointOutsideProfile)
						{ 
							Point3d _pts[] = Line(pt,vecPerp).orderPoints(pp.intersectPoints(Plane(pt,vecDir), true, false));
							double dMin = U(10e4);
							for (int ii=0;ii<_pts.length();ii++) 
							{ 
								double d = abs(vecPerp.dotProduct(_pts[ii]-ptDims[p]));
								if (d<dMin)
								{ 
									dMin = d;
									pt = _pts[ii];
								}
								 
							}//next ii
							ptDims[p] = pt;
						}	
						else
							ptDims[p]=lnDim.closestPointTo(pt);

						 
					}//next p
					
				}
				else
					ptDims = lnDim.projectPoints(ptDims);
				
				
			}
		
		// Global
			else
			{
				vecP = vecPerp * (vecPerp.dotProduct(segEl.ptMid() - _Pt0) > 0 ?- 1 : 1);
		
				ptDims = Line(_Pt0, vecDir).orderPoints(ptDims, dEpsPS);
				if (nDimPointMode==5 && ptDims.length()>2)
				{ 
					ptDims.swap(1, ptDims.length() - 1);
					ptDims.setLength(2);
				}
				DimLine dl(ptDimLoc, vecDir, vecPerp);
				Dim dim(dl, ptDims, "<>", "<>", nDeltaMode,nChainMode);
				dim.setDeltaOnTop(bSwapDeltaChain);
				PLine plines[] = dim.getTextAreas(dp);
				
				PlaneProfile pp(csW);
				{ 
					Line ln(ptDimLoc, vecDir);
					Point3d pts[] = ln.orderPoints(ln.projectPoints(ptDims));
					pp.createRectangle(LineSeg(pts.first() - vecPerp * .75 * dTextHeight, pts.last() + vecPerp * .75 * dTextHeight), vecDir, vecPerp);
				}
				for (int x=0;x<plines.length();x++) pp.joinRing(plines[x],_kAdd);
				pp.shrink(-.75*dTextHeight); // merge
				pp.shrink(.5*dTextHeight);	//pp.vis(2);	
				
			// no protection area yet
				if (ppProtect.area()<pow(dEpsPS,2))
					ppProtect = pp;
			// try placement 40 attempts per side if sequencing isn't disabled'
				else if (nSequence >- 1)
				{
					PlaneProfile ppX = ppProtect;
					ppX.intersectWith(pp);
					ppX.vis(3);
					
					Point3d ptNew = ptDimLoc;
					int bHasInterference = ppX.area() > pow(dEpsPS, 2);			
					int cnt;
					while (cnt<40 && bHasInterference)
					{ 
						pp.transformBy(vecP * .25 * dTextHeight);
						ptNew.transformBy(vecP * .25 * dTextHeight);
						ppX = ppProtect;
						ppX.intersectWith(pp);
						bHasInterference = ppX.area()> pow(dEpsPS, 2);
						cnt++;
					}
					ptDimLoc = ptNew;
					ppProtect.unionWith(pp);
				}	
				ptLocGlobalDescription += vecPerp * vecPerp.dotProduct(ptDimLoc - ptLocGlobalDescription);
				
				vecP.vis(ptLocGlobalDescription, 1);
				vecPerp.vis(ptLocGlobalDescription, 1);
			}

		// only extremes
			if (nDimPointMode==5 && ptDims.length()>2)
			{ 
				ptDims.swap(1, ptDims.length()-1);
				ptDims.setLength(2);
			}
			
		// project dimpoints to snap HSB-10429
			if (ppSnap.area()>pow(dEpsPS,2))
			{ 
				for (int p=0;p<ptDims.length();p++) 
				{ 
					Point3d& pt= ptDims[p];
					
					Point3d _pts[] = Line(pt, -vecP).orderPoints(ppSnap.intersectPoints(Plane(pt, vecDir), true, false));
					if (_pts.length()>0)
					{
						pt = _pts.first();
						//pt.vis(3);
					}
				}//next p
			}
			
		// draw dim	
			DimLine dl(ptDimLoc, vecDir, vecPerp);
			Dim dim(dl, ptDims, "<>", "<>", nDeltaMode,nChainMode); 
			dim.setDeltaOnTop(bSwapDeltaChain);
			Vector3d vecXRead = vecDir;
			Vector3d vecYRead = vecPerp;
			if (vecXRead.isPerpendicularTo(_ZW))
			{ 
				vecXRead =_XW;
				vecYRead =_YW;				
			}
			dim.setReadDirection(vecYRead - vecXRead);
			dp.draw(dim);	
			
			{ // HSB-10724
				PLine plines[] = dim.getTextAreas(dp);
				PlaneProfile pp(csW);
				//pp.createRectangle(LineSeg(pts.first()-vecPerp*.1*dTextHeight, pts.last()+vecPerp*.1*dTextHeight),vecDir, vecPerp);
				for (int x=0;x<plines.length();x++) 
					pp.joinRing(plines[x],_kAdd);
				pp.shrink(-.75*dTextHeight); // merge
				pp.shrink(.5*dTextHeight);
				pp.vis(32); 
			
			// no protection area yet
				if (ppProtect.area()<pow(dEpsPS,2))
					ppProtect = pp;		
				else 
					ppProtect.unionWith(pp);		
			}	
			
			
			
			
		// draw local description
			k = "parentEnt";	
			if (!bIsGlobal && m.hasEntity(k) && sDescription.length()>0)
			{ 
				Entity ent = m.getEntity(k); 
				String sText = ent.formatObject(sDescription,mapAdditionalVariables);
				Point3d pt = ptDimLoc + vecDir * vecDir.dotProduct(_Pt0 - ptDimLoc);
				dp.draw(sText, pt, vecDir,vecPerp, nXAlign, 0);
			}
			
			mapTemp.appendMap("Dim", m);
			
		}//next i	
		mapDims = mapTemp; // write updated
	}
// alert if nothing could be found
	else if (ptDims.length()<2)
	{ 
		reportMessage("\n"+ scriptName() + T(" |no dimension points found for selected type| ") + "("+sType+")");		
		
		
		return;
}			
	else
	{ 
		Vector3d vecOffset = vecPerp * (vecPerp.dotProduct(segEl.ptMid() - _Pt0) > 0 ?- 1 : 1);
		vecOffset.vis(segEl.ptMid(), 150);
		
		for (int i=0;i<ptDimLocs.length();i++) 
		{ 
			Point3d& ptDimLoc = ptDimLocs[i];
			DimLine dl(ptDimLoc, vecDir, vecPerp);
			Dim dim(dl, ptDims, "<>", "<>", nDeltaMode,nChainMode); 
			dim.setDeltaOnTop(bSwapDeltaChain);
			Vector3d vecXRead = vecDir;
			Vector3d vecYRead = vecPerp;
			if (vecXRead.isPerpendicularTo(_ZW))
			{ 
				vecXRead =_XW;
				vecYRead =_YW;				
			}
			dim.setReadDirection(vecYRead - vecXRead);
			
			PLine plines[] = dim.getTextAreas(dp);			
			PlaneProfile pp(csW);
			{ 
				Line ln(ptDimLoc, vecDir);
				Point3d pts[] = ln.orderPoints(ln.projectPoints(ptDims));
				pp.createRectangle(LineSeg(pts.first() - vecPerp * .75 * dTextHeight, pts.last() + vecPerp * .75 * dTextHeight), vecDir, vecPerp);
			}
			for (int x=0;x<plines.length();x++) pp.joinRing(plines[x],_kAdd);
			
			pp.shrink(-.75*dTextHeight); // merge
			pp.shrink(.5*dTextHeight);	//pp.vis(i+40);		

		// no protection area yet
			if (ppProtect.area()<pow(dEpsPS,2))
				ppProtect = pp;
		// try placement 40 attempts per side if sequencing isn't disabled'
			else if (nSequence >- 1)
			{
				PlaneProfile ppX = ppProtect;
				ppX.intersectWith(pp);		//ppX.vis(3);
				
				int bHasInterference = ppX.area() > pow(dEpsPS, 2);			
				int cnt;
				while (cnt<40 && bHasInterference)
				{ 
					pp.transformBy(vecOffset * .25 * dTextHeight);
					dl.transformBy(vecOffset * .25 * dTextHeight);
					ptDimLoc.transformBy(vecOffset * .25 * dTextHeight);
					ppX = ppProtect;
					ppX.intersectWith(pp);
					bHasInterference = ppX.area()> pow(dEpsPS, 2);
					cnt++;
				}
				ppProtect.unionWith(pp);
			}
			
		// project dimpoints to snap HSB-10429
			if (ppSnap.area()>pow(dEpsPS,2))
			{ 
				for (int p=0;p<ptDims.length();p++) 
				{ 
					Point3d& pt= ptDims[p];
					
					Point3d _pts[] = Line(pt, -vecPerp).orderPoints(ppSnap.intersectPoints(Plane(pt, vecDir), true, false));
					if (_pts.length()>0)
						pt = _pts.first();
				}//next p
			}	

			ptLocGlobalDescription += vecPerp * vecPerp.dotProduct(ptDimLoc - ptLocGlobalDescription);
			dim = Dim (dl, ptDims, "<>", "<>", nDeltaMode,nChainMode);
			dim.setDeltaOnTop(bSwapDeltaChain);
			dp.draw(dim);				 
		}//next i			
	}

	
// Description
	// ptCenVp.vis(2);
	int bDrawSetupInfo = sDescription.length()<1;
	if (bHasSDV && entsDefineSet.length() >0)
		bDrawSetupInfo=false ;
	else if (bHasSection && (ents.length() >0 || ptDims.length()>0))
		bDrawSetupInfo=false ;
	if (bDrawSetupInfo)
	{ 
		String sText = scriptName();
		if (nActiveZoneIndex!=99)sText+="\\P" + T("|Zone| ")+ nActiveZoneIndex;
		sText+=" " + sAlignment;
		//if(nRule>0)sText+="\\P"+sRuleName + ": " + sRule;
//		if(!bIsValidRef && bIsGlobal)
//		{
//			dp.color(1);
//			sText += "\\P" + T("|No intersection found for global dimension, \\Pplease adjust location.|");
//		}
		dp.draw(sText, _Pt0, _XW, _YW, nXAlign, 0);
		
		//dp.draw(sTypeName + ": " + sType + (nType==5?sSetupText2:"") + " ("+ents.length()+"), " + T("|Priority| ")+(nSequence+1),  _Pt0, _XW, _YW, 1, -2);
		//dp.draw(T("|Format|") + ": " + sAutoAttribute,  _Pt0, _XW, _YW, 1, -5);		
	}
	else if (ptDims.length()>0 && bIsElementViewport)
	{ 
		String sText = _ThisInst.formatObject(sDescription,mapAdditionalVariables); // +"\\P"+sSequenceName+": @(Sequence)"
//		if (bIsElementViewport)
//		{
//			String ss[] = el.formatObjectVariables();
//			sText = el.formatObject(sText);
//		}
		dp.draw(sText, ptLocGlobalDescription, vecDir,vecPerp, nXAlign, 0);
		
		vecDir.vis(_Pt0, 1);
		vecPerp.vis(_Pt0, 3);
		
	}
	
	
	
//End Draw Dimensions//endregion 

//region Trigger
// TriggerAddEntity in viewport mode
	String sTriggerAddEntity = T("../|Add Entities|");
	String sTriggerRemoveEntity = T("../|Remove Entities|");
	if (bIsAcaViewport)
	{
		addRecalcTrigger(_kContextRoot, sTriggerAddEntity );
		if (_Entity.length()>0)addRecalcTrigger(_kContextRoot, sTriggerRemoveEntity );
	}
	String events[] ={ sTriggerAddEntity, sDoubleClick, sTriggerRemoveEntity};
	int nEvent = events.findNoCase(_kExecuteKey ,- 1);
	if (_bOnRecalc && nEvent>-1)
	{
		int bSuccess = Viewport().switchToModelSpace();
		if (bSuccess)
		{ 
			PrEntity ssE(T("|Select entities|"), Entity());
			Entity ents[0];
			if (ssE.go())
				ents = ssE.set();
			
			for (int i=0;i<ents.length();i++) 
			{ 
				int n = _Entity.find(ents[i]); 
			// remove	
				if (n > 0 && nEvent == 2)_Entity.removeAt(n);
			// add
				else if (n < 0)_Entity.append(ents[i]);	 
			}//next i
			//reportMessage("\n" + _Entity.length() + " selected");	
			bSuccess = Viewport().switchToPaperSpace();	
			setExecutionLoops(2);
			return;			
		}
	}	
	
	
// Trigger SetReferencePoint//region
	String sTriggerSetReferencePoint = T("../|Set Reference Point|");
	addRecalcTrigger(_kContextRoot, sTriggerSetReferencePoint);
	if (_bOnRecalc && _kExecuteKey==sTriggerSetReferencePoint)
	{
	// prompt for point input
		PrPoint ssP(TN("|Select point|"));
		Point3d pts[0];
		if (ssP.go()==_kOk) 
			pts.append(ssP.value()); 
		
	// replace existing reference point
		if (pts.length()>0)
		{
			_Map.setInt(keyCustomRef, true);// indicate that [0] is the refpoint
			mapAdd = Map();
			if(bHasCustomRef && _PtG.length()>0)
				_PtG[0]=pts[0];	
			else
				_PtG.insertAt(0,pts[0]);
				
			for (int j=1;j<_PtG.length();j++) 
				mapAdd.appendVector3d("vecAdd", _PtG[j] - _PtW);		
		}
				
	// rewrite grip location vecs
		if (mapAdd.length()>0)	_Map.setMap("vecAdd[]",mapAdd);
		else					_Map.removeAt("vecAdd[]", true);

		setExecutionLoops(2);
		return;
	}//endregion	
	
// Trigger AddPoints//region
	String sTriggerAddPoints = T("|Add Points|");
	addRecalcTrigger(_kContextRoot, sTriggerAddPoints );
	if (_bOnRecalc && _kExecuteKey==sTriggerAddPoints)
	{
	// prompt for point input
		Point3d pts[0];
		while(1)
		{ 
			PrPoint ssP(TN("|Select point|"));
			if (ssP.go()==_kOk) 
				pts.append(ssP.value());
			else 
				break;
		}	
		
	// do not add any duplicate	
		Map m= _Map.getMap("vecAdd[]");
		for (int i=0;i<pts.length();i++) 
		{ 
			int bAdd=true;
			for (int j=0;j<_PtG.length();j++) 
			{ 
				if (abs(vecDir.dotProduct(_PtG[j]-pts[i]))<dEps)
				{
					bAdd=false;
					break;
				} 
			}//next j
			if (bAdd)
			{ 
				_PtG.append(pts[i]);
				m.appendVector3d("vecAdd", pts[i] - _PtW);
			}
		}
		if (m.length()>0)	 _Map.setMap("vecAdd[]",m);
		else				_Map.removeAt("vecAdd[]", true);		
		setExecutionLoops(2);
		return;
	}//endregion	
		
// Trigger RemovePoints//region
	String sTriggerRemovePoints = T("|Remove Points|");
	addRecalcTrigger(_kContextRoot, sTriggerRemovePoints );
	if (_bOnRecalc && _kExecuteKey==sTriggerRemovePoints)
	{
	// prompt for point input
		Point3d pts[0];
		while(1)
		{ 
			PrPoint ssP(TN("|Select point|"));
			if (ssP.go()==_kOk) 
				pts.append(ssP.value());
			else 
				break;
		}
		
		Map m= _Map.getMap("vecRemoval[]");
		for (int i=0;i<pts.length();i++) 
		{
			int bAdd=true;
			for (int j=0;j<_PtG.length();j++) 
			{ 
				if (abs(vecDir.dotProduct(_PtG[j]-pts[i]))<dEpsPS)
				{
					bAdd=false;
				// remove flag that first grip is reference
					if (bHasCustomRef && j==0)
					{ 
						bHasCustomRef = false;
						_Map.removeAt(keyCustomRef, true);
						if (bRefByUser) sReference.set(sRefByElement);
					}
					_PtG.removeAt(j);
					mapAdd.removeAt(j, true);
					break;
				} 
			}//next j
			if (bAdd)
			{ 
				_PtG.append(pts[i]);
				m.appendVector3d("vecRemoval", pts[i] - _PtW);
			}			 
		}//next i
		if (m.length()>0)
			 _Map.setMap("vecRemoval[]",m);
		else
			_Map.removeAt("vecRemoval[]", true);			

	// rewrite grip location vecs
		if (mapAdd.length()>0)	_Map.setMap("vecAdd[]",mapAdd);
		else					_Map.removeAt("vecAdd[]", true);

		setExecutionLoops(2);
		return;
	}//endregion	
	

// Trigger CustomLocation only for local dimlines
	if (!bIsGlobal && mapDims.length()>0)
	{ 
		String k;
	// Trigger SetLocation//region
		String sTriggerSetLocation = T("|Set Location|");
		addRecalcTrigger(_kContextRoot, sTriggerSetLocation );
		if (_bOnRecalc && _kExecuteKey==sTriggerSetLocation)
		{
			
		//region Add Jig
			Point3d pts[0];
//			
//		    _Pt0 = getPoint(T("\n|Select point|"));
//			Point3d ptLast = _Pt0;
//		
			
			PrPoint ssP(T("|Pick point near dimline|")); // second argument will set _PtBase in map
		    Map mapArgs;
		    mapArgs.setVector3d("vecDir", vecDir);
			mapArgs.setVector3d("vecPerp", vecPerp);
		    mapArgs.setMap("Dim[]", mapDims);
		    mapArgs.setMap("CustomLocation[]", mapCustomLocations);
		    mapArgs.setPoint3d("ptBase", _Pt0);
		    mapArgs.setDouble("TextHeight", dTextHeight);
		    mapArgs.setString("DimStyle", sDimStyle);
		    mapArgs.setInt("ChainMode", nChainMode);
		    mapArgs.setInt("DeltaMode", nDeltaMode);
			mapArgs.setDouble("Scale", dScale);
		
		     // add all the info you need for Jigging
		    
		    int nGoJig = -1;
		    Entity entParent;
		    while (pts.length()<2 && nGoJig != _kNone)
		    {
		        nGoJig = ssP.goJig("JigAction", mapArgs); 
		        
		        if (nGoJig == _kOk)
		        {
		            pts.append(ssP.value()); //retrieve the selected point
		            
		        // show from jig    
		            if (pts.length()==1)
		            {
		            	double dDistMin = U(10e4);
		            	for (int i=0;i<mapDims.length();i++) 
		            	{ 
		            		Map m = mapDims.getMap(i);
							Point3d pt = m.getPoint3d("ptLoc");
							double dDist = abs(vecPerp.dotProduct(pts.first() - pt));
							if (dDist<dDistMin)
							{ 
								dDistMin = dDist;
								pts[0] = pt;
								entParent= m.getEntity("parentEnt");
							}
		            	}
		            	
		            // show current position if already moved	

		            	mapArgs.setPoint3d("ptFrom", pts[0]);
		            }
		        
		        // set new location
					else if (pts.length() == 2)
					{
						Point3d ptFrom = pts.first();
						Point3d ptTo = pts.last();
						//ptTo+= vecPerp * vecPerp.dotProduct(ptTo-ptFrom);		
						mapCustomLocations.setPoint3d(entParent.handle(), ptTo);
						_Map.setMap("CustomLocation[]",mapCustomLocations);
					}
		            

					ssP = PrPoint(T("|Pick new location|"));
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
		            //eraseInstance(); // do not insert this instance
		            return; 
		        }
		        
		        
		    }			
		//End Show Jig//endregion 


			setExecutionLoops(2);
			return;
		}//endregion	
	
	// Trigger ResetByElement//region
		if (mapCustomLocations.length()>0)
		{ 
			Entity ents[0];
			for (int i=0;i<mapCustomLocations.length();i++) 
			{ 
				Entity ent;
				ent.setFromHandle(mapCustomLocations.keyAt(i));
				if (!ent.bIsValid()){ continue;}
				Element _el = ent.element();
				if (_el.bIsValid() && el == _el)
					ents.append(ent);
			}//next i
			
			if (ents.length()>0)
			{ 
				String sTriggerResetByElement = T("|Reset locations of current element|");
				addRecalcTrigger(_kContextRoot, sTriggerResetByElement );
				if (_bOnRecalc && _kExecuteKey==sTriggerResetByElement)
				{
					for (int i=ents.length()-1; i>=0 ; i--) 
					{ 
						k = ents[i].handle(); if (mapCustomLocations.hasPoint3d(k)) mapCustomLocations.removeAt(k,true); 			
					}//next i
					_Map.setMap("CustomLocation[]",mapCustomLocations);
					setExecutionLoops(2);
					return;
				}				
			}
			
			String sTriggerResetAll = T("|Reset locations of all elements| (") + mapCustomLocations.length()+ ")";
			addRecalcTrigger(_kContextRoot, sTriggerResetAll );
			if (_bOnRecalc && _kExecuteKey==sTriggerResetAll)
			{
				_Map.removeAt("CustomLocation[]",true);
				setExecutionLoops(2);
				return;
			}
			
			

			
		}
		//endregion	
	}

// TriggerSwapDeltaChain 
	String sTriggerSwapDeltaChain = T("|Swap Delta/Chain|");
	addRecalcTrigger(_kContextRoot, sTriggerSwapDeltaChain );
	if (_bOnRecalc && _kExecuteKey==sTriggerSwapDeltaChain)
	{
		 _Map.setInt("SwapDeltaChain",!bSwapDeltaChain);
		setExecutionLoops(2);
		return;
	}


//End Trigger//endregion 

// publish protection area
	{ 
		ppProtect.vis(0);
		Map mapX;
		mapX.setPlaneProfile("ppProtect", ppProtect);
		mapX.setInt("Priority", nSequence);//HSB-8276
		mapX.setVector3d("vecZView", vecZView); // HSB-12241 storing the view direction filters only parallel view directions
		_ThisInst.setSubMapX(sSubXKey, mapX);
	}
//	TRIAL HSB-12241
//	if (pdTemp.bIsValid())
//		pdTemp.dbErase();
	
	
	//reportNotice("\n"  +_ThisInst.handle()+ " Time " + (getTickCount() - nTickStart)  + " type: " + sType);
















#End
#BeginThumbnail
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
;#!815<;_![_:$K#EXM1B`````$E%3D2N0F""






















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
        <int nm="BreakPoint" vl="2124" />
        <int nm="BreakPoint" vl="2423" />
        <int nm="BreakPoint" vl="1550" />
        <int nm="BreakPoint" vl="2281" />
        <int nm="BreakPoint" vl="1493" />
        <int nm="BreakPoint" vl="1603" />
        <int nm="BreakPoint" vl="3053" />
        <int nm="BreakPoint" vl="1156" />
        <int nm="BreakPoint" vl="1336" />
        <int nm="BreakPoint" vl="1332" />
        <int nm="BreakPoint" vl="783" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13561 bugfix for openings of multi elements" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="10/20/2021 11:03:13 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12241 performance improved when using byZone options and/or opening type" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="10/11/2021 12:09:17 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13329 tolerance issues of underlying combined clip body fixed" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="9/30/2021 2:05:38 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12370 accepting empty custom dimrequests to support invalidation (instaXX)" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="6/25/2021 12:03:42 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12371 new point modes added to dimension packed genbeams (use options 'merged')" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="6/24/2021 3:05:29 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12370 new property 'Reference Point Mode' added to control subset of reference points" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="6/24/2021 2:56:53 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-123333 the point mode of tsl based map requests is supported" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="6/23/2021 11:00:01 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12241 performance enhanced" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="6/18/2021 10:42:01 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12241 performance enhanced for opening dimensions" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="6/17/2021 3:09:50 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11973 dummies are considered if painter definition is used" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="5/21/2021 11:53:00 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End