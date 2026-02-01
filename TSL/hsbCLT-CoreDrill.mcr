#Version 8
#BeginDescription
#Versions:
2.3 09/09/2024 HSB-22608: Add shopdraw information for hidden lines of core drills Marsel Nakuci
2.2 25.05.2022 HSB-15563: add string "Stereotype" to control visibility in sd_EntitySymbolDisplay Author: Marsel Nakuci
2.1 17.03.2021 HSB-11245: write a maprequest for its dimension Author: Marsel Nakuci

///<version value="2.0" date="20oct2020" author="thorsten.huck@hsbcad.com"

HSB-9338 internal naming bugfix </version>
Properties categorized, symbol display enhanced

DACH
Dieses TSL erzeugt eine Kernbohrung an der Schmalseite eines CLT Panels.

EN
This tsl creates a core drill on the edge of a sip/clt panel


#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 3
#KeyWords klh, format, drill, core, shopdraw
#BeginContents
/// <History>//region

/// <summary Lang=de>
/// Dieses TSL erzeugt eine Kernbohrung an der Schmalseite eines CLT Panels.
/// </summary>

/// <summary Lang=en>
/// This tsl creates a drill on the edge of a sip/clt panel
/// </summary>

/// <insert Lang=en>
/// Select one or multiple defining tsl's to reference to or select a point and a panel to insert an individual instance
/// </insert>

/// History
//#Versions:
// 2.3 09/09/2024 HSB-22608: Add shopdraw information for hidden lines of core drills Marsel Nakuci
// 2.2 25.05.2022 HSB-15563: add string "Stereotype" to control visibility in sd_EntitySymbolDisplay Author: Marsel Nakuci
// Version 2.1 17.03.2021 HSB-11245: write a maprequest for its dimension  Author: Marsel Nakuci
///<version value="2.0" date="20oct2020" author="thorsten.huck@hsbcad.com"> HSB-9338 internal naming bugfix </version>
///<version value="1.9" date="26mar20" author="marsel.nakuci@hsbcad.com"> HSB-7108: sAllowOverwrite has index 3 in properties </version>
///<version value="1.8" date="20mar20" author="marsel.nakuci@hsbcad.com"> HSB-7022: add flag sAllowOverwrite to tell sd_EntitySymbolDisplay whether value overwrite is allowed or not </version>
///<version value="1.7" date=28feb20" author="marsel.nakuci@hsbcad.com"> HSB-6768: each time drill direction is changed, set ptg to middle </version>
///<version value="1.6" date=28feb20" author="marsel.nakuci@hsbcad.com"> HSB-6768: custom command to set drill direction </version>
///<version value="1.5" date=27feb20" author="marsel.nakuci@hsbcad.com"> HSB-6768: fix orientation vertical/horizontal, add Hardware </version>
///<version value="1.4" date=27feb20" author="marsel.nakuci@hsbcad.com"> HSB-6768: dTextHeight is given at tslNew.dbcreate </version>
///<version value="1.3" date=27feb20" author="marsel.nakuci@hsbcad.com"> HSB-6768: initialise grip point at middle of drill </version>
///<version value="1.2" date=26feb20" author="marsel.nakuci@hsbcad.com"> HSB-6768: add format and send to shopdraw </version>
///<version value="1.1" date=03Dec18" author="thorsten.huck@hsbcad.com"> Properties categorized, symbol display enhanced </version>
///<version  value="1.0" date="14oct14" author="th@hsbCAD.de">initial </version>

/// commands
// command to insert
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "hsbCLT-CoreDrill")) TSLCONTENT
//endregion

//region constants 
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	// read a potential mapObject defined by hsbDebugController
	{ 
		MapObject mo("hsbTSLDev" ,"hsbTSLDebugController");
		if (mo.bIsValid()){Map m = mo.map(); for (int i=0;i<m.length();i++) if (m.getString(i)==scriptName()){bDebug = true;break;}}
		if(bDebug)reportMessage("\n"+ scriptName() + " starting " + _ThisInst.handle());		
	}
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};
//end constants//endregion

//region Functions
//region pLine2pp
// this transform a pline into a hidden line with thickness
// The thickness in hidden line is created by multiple
// planeprofiles 
// HSB-22608
	PlaneProfile pLine2pp(PLine pl,Vector3d _vecZ)
	{ 
		// this transform a pline into a hidden line with thickness
		// The thickness in hidden line is created by multiple
		// planeprofiles
//		Vector3d vecZ=pl.coordSys().vecZ();
		Plane pn(pl.coordSys().ptOrg(),_vecZ);
		PlaneProfile pp(pn);
		pl.vis(2);
		Point3d pts[]=pl.vertexPoints(false);
		double dLmod=U(50);
		double dLspace=U(18);
		double dTotMod=dLmod+dLspace;
		for (int p=0;p<pts.length()-1;p++) 
		{ 
			Point3d pt0=pts[p];
			Point3d pt1=pts[p+1];
			Vector3d vecDir=pt1-pt0;vecDir.normalize();
			Vector3d vecN=vecDir.crossProduct(_vecZ);
			vecN.normalize();
			double dLi=abs(vecDir.dotProduct(pt1-pt0));
			int nNri=(dLi-dLmod)/dTotMod;
			// keep the space fix
			double _dTotMod=(dLi+dLspace)/(nNri+2);
			double _dLmod=_dTotMod-dLspace;
			
			Point3d pt=pt0;
			for (int i=0;i<nNri+2;i++) 
			{ 
				PlaneProfile ppI(pn);
				ppI.createRectangle(LineSeg(pt-vecN*U(6),
					pt+vecDir*_dLmod+vecN*U(6)),vecDir,vecN);
				ppI.vis(6);
				pp.unionWith(ppI);
				pt+=vecDir*_dTotMod;
			}//next i
		}//next p
		return pp;
		
	}
//End pLine2pp//endregion	
//End Functions//endregion 

//region Properties
	category = T("|Geometry|");
	String sDiameterName=T("|Diameter|");	
	PropDouble dDiameter(nDoubleIndex++, U(30), sDiameterName);	
	dDiameter.setDescription(T("|Defines the Diameter|"));
	dDiameter.setCategory(category);

	String sMaxDepthName=T("|Max Depth|");	
	PropDouble dMaxDepth(nDoubleIndex++, U(0), sMaxDepthName);	
	dMaxDepth.setDescription(T("|Defines the maximal depth from the edge of the panel.|") + T("|The depth is controlled by the insertion point.|"));
	dMaxDepth.setCategory(category);
	
	category = T("|Alignment|");
	String sZOffsetName=T("|Z-Offset|");	
	PropDouble dZOffset(nDoubleIndex++, U(0), sZOffsetName);	
	dZOffset.setDescription(T("|Defines the Z-Offset of the drill|"));
	dZOffset.setCategory(category);

	String sAlignments[] = {T("|Vertical|"), T("|Horizontal|")};
	String sAlignmentName=T("|Alignment|");	
	PropString sAlignment(1,sAlignments, sAlignmentName);	
	sAlignment.setDescription(T("|The alignment is seen relative to the panel alignment|") + " " + 
		T("|Panels which are not parallel or perpendicular to world Z-axis will use the panel coordinate system.|"));
	sAlignment.setCategory(category);

	String sDirectionName=T("|Direction|");	
	String sDirections[] = {T("|Bottom (Left)|"), T("|Top (Right)|"), T("|Both|")};	
	PropString sDirection(0, sDirections, sDirectionName);	
	sDirection.setDescription(T("|Defines the reference edge from which the drill enters the panel|"));
	sDirection.setCategory(category);
	
	category = T("|Display|");
	String sFormatName=T("|Format|");	
	PropString sFormat(2, "R@(Radius)", sFormatName);	
	sFormat.setDescription(T("|Defines the format of the description.|"));
	sFormat.setCategory(category);
	// color
	String sColorName=T("|Color|");	
	PropInt nColor(nIntIndex++, 6, sColorName);	
	nColor.setDescription(T("|Defines the Color|"));
	nColor.setCategory(category);
	// text height
	String sTextHeightName=T("|Text Height|");	
	PropDouble dTextHeight(nDoubleIndex++, U(0), sTextHeightName);	
	dTextHeight.setDescription(T("|Defines the TextHeight|"));
	dTextHeight.setCategory(category);
	// flag if it allows sd_EntitySymbolDisplay to overwrite 
	String sAllowOverwriteName=T("|Allow Overwrite|");	
	PropString sAllowOverwrite(3, sNoYes, sAllowOverwriteName);	
	sAllowOverwrite.setDescription(T("|Allows overwriting of text properties colour and heigth from TSL sd_EntitySymbolDisplay|"));
	sAllowOverwrite.setCategory(category);
//End Properties//endregion 	
	

// the map entry which determines if a tsl is supported
	String sKeyAllowsEdgeDrill = "AllowsEdgeDrill";
	
// on insert
	if (_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
	
	// set properties from catalog
		if (_kExecuteKey!="")
			setPropValuesFromCatalog(_kExecuteKey);			
		else
			showDialog();

	
	// prompt for sips
		Entity ents[0];
		PrEntity ssE(T("|Select panel|")+T(", |<Enter> to select supported tools|"), Sip());
		if (ssE.go())
			ents.append(ssE.set());
		
	// panel selected
		Sip sips[0];
		Point3d pts[0];
		TslInst tsls[0];
		if (ents.length()>0)
		{ 
			sips.append((Sip)ents[0]);
			pts.append(getPoint(T("|Pick point at depth|")));
			
		}
		else
		{ 
			PrEntity ssE(T("|Select supported tsl tools|"), TslInst());
			if (ssE.go()) 
				ents= ssE.set();
				
		// collect valid entities
			for (int e =0;e<ents.length();e++)
			{
				TslInst tsl = (TslInst)ents[e];
				if (tsl.bIsValid() && tsl.map().getInt(sKeyAllowsEdgeDrill))
				{
				// the first sip is taken as reference
					GenBeam genBeams[] = tsl.genBeam();
					Sip sip;
					for (int i=0;i<genBeams.length();i++)
						if(genBeams[i].bIsKindOf(Sip()))
						{
							sip = (Sip)genBeams[i];
							break;
						}
					if (sip.bIsValid())
					{
						Point3d ptRef = tsl.ptOrg();
						Map map = tsl.map();
						if (map.hasPoint3d("ptEdgeDrillRef"))
							ptRef =map.getPoint3d("ptEdgeDrillRef");
							
						pts.append(ptRef);
						sips.append(sip);
						tsls.append(tsl);
						
					}
				}
			}						
		}
		

	// insert per selected tool
		// declare the tsl props
		TslInst tslNew;
		Vector3d vUcsX = _XW;
		Vector3d vUcsY = _YW;
		GenBeam gbAr[1];
		Entity entAr[0];
		Point3d ptAr[1];
		int nArProps[] ={ nColor};
		double dArProps[] = {dDiameter ,dMaxDepth,dZOffset,dTextHeight};
		String sArProps[]={sDirection,sAlignment, sFormat, sAllowOverwrite};
		Map mapTsl;
		String sScriptname = scriptName();

	
	// collect valid entities
		for (int e =0;e<sips.length();e++)
		{
			Sip& sip = sips[e];
			ptAr[0] = pts[e];
			gbAr[0] = sips[e];
			entAr.setLength(0);
			if (tsls.length()>e)
				entAr.append(tsls[e]);				
			tslNew.dbCreate(sScriptname, vUcsX,vUcsY,gbAr, entAr, ptAr, 
				nArProps, dArProps, sArProps,_kModelSpace, mapTsl); // create new instance
		}
		
		eraseInstance();
		return;
	}
// end on insert
	setEraseAndCopyWithBeams(_kBeam0);
	
// validate sset
	if (_Sip.length()<1)
	{
		reportMessage("\nselection set invalid");
		eraseInstance();
		return;
	}	
	Sip sip = _Sip[0];
	assignToGroups(sip);	

// trigger select tool ref
	String sSelectRefTrigger = T("|Select Tool Reference|");
	addRecalcTrigger(_kContext, sSelectRefTrigger );
	if (_bOnRecalc && _kExecuteKey==sSelectRefTrigger ) 
	{
		PrEntity ssE(T("|Select supported tsl tool|"), TslInst());
		Entity ents[0];
		if (ssE.go()) 
			ents= ssE.set();
		for (int e =0;e<ents.length();e++)
		{
			TslInst tsl = (TslInst)ents[e];
			if (tsl.bIsValid() && tsl.map().getInt(sKeyAllowsEdgeDrill))
			{
				_Entity.setLength(0);
				_Entity.append(tsl);	
			}	
		}
		setExecutionLoops(2);					
	}
// trigger release tool ref
	String sReleaseRefTrigger = T("|Release Tool Reference|");
	addRecalcTrigger(_kContext, sReleaseRefTrigger );
	if (_bOnRecalc && _kExecuteKey==sReleaseRefTrigger ) 
	{
		_Entity.setLength(0);
		setExecutionLoops(2);					
	}
	
// test if tsl based reference is set
// collect valid tool entity
	TslInst tslRef;
	Point3d ptRef=_Pt0;
	for (int e =0;e<_Entity.length();e++)
	{
		TslInst tsl = (TslInst)_Entity[e];
		if (tsl.bIsValid() && tsl.map().getInt(sKeyAllowsEdgeDrill))
		{
			setDependencyOnEntity(tsl);
			ptRef=tsl.ptOrg();
			tslRef = tsl;
			Map map = tsl.map();
			if (map.hasPoint3d("ptEdgeDrillRef"))
				ptRef =map.getPoint3d("ptEdgeDrillRef");
		}
	}

// get ints
	int nAlignment = sAlignments.find(sAlignment);// 0 = vertical, 1 = horizontal
	int nDirection = sDirections.find(sDirection );// 0 = bottom/left, 1 = top/right, 2 = both

	
// the coordSys
	//vecNormal.vis(_Pt0,150);
	Vector3d vecX=sip.vecX(), vecY=sip.vecY(), vecZ=sip.vecZ();
	//vecX.vis(_Pt0,20);
	//vecY.vis(_Pt0,20);
// treat me like a wall in ZW plane
	if (vecZ.isParallelTo(_ZW) && (vecX.isParallelTo(_XW) || vecY.isParallelTo(_XW)))
	{
		vecX=_XW;
		vecY=_YW;	
	}
// treat me like a wall in model
	else if (vecZ.isPerpendicularTo(_ZW) && (vecX.isParallelTo(_ZW) || vecY.isParallelTo(_ZW)))
	{
		if (vecX.isParallelTo(_ZW))
		{
			vecY=_ZW;
			vecX=vecY.crossProduct(vecZ);
		}
		else
		{
			vecX=_ZW;
			vecY=vecX.crossProduct(-vecZ);
		}
	}
	
	{ 
		Quader qd(sip.ptCen(), sip.vecX(), sip.vecY(), sip.vecZ());
		if(sip.vecZ().isParallelTo(_ZW))
		{ 
			// lies horizontally
//			vecX = qd.vecD(_XW);
			vecX = _XW;
			vecZ = _ZW;
			vecY = vecZ.crossProduct(vecX);
			vecY.normalize();
			if(vecY.dotProduct(_YW)<0)
			{ 
				vecY *= -1;
				vecZ *= -1;
			}
		}
		else
		{ 
			vecY = _ZW.crossProduct(sip.vecZ());
			vecY.normalize();
			vecY = vecY.crossProduct(sip.vecZ());
			vecY.normalize();
			if (vecY.dotProduct(_ZW) < 0)vecY *= -1;
			
			vecZ = sip.vecZ();
			vecX = vecY.crossProduct(vecZ);vecX.normalize();
			if(vecX.dotProduct(_XW)<0)
			{ 
				vecX *= -1;
				vecZ *= -1;
			}
		}
	}
//	vecX.vis(_Pt0,1);
//	vecY.vis(_Pt0,3);
//	vecZ.vis(_Pt0,150);
// Trigger setDrillDirection//region
	String sTriggersetDrillDirection = T("|set Drill Direction|");
	addRecalcTrigger(_kContext, sTriggersetDrillDirection );
	if (_bOnRecalc && (_kExecuteKey==sTriggersetDrillDirection || _kExecuteKey==sDoubleClick))
	{
		//get Point	
		Point3d pt1 = getPoint(TN("|Select the first Point|"));
		Point3d pt2 = getPoint(TN("|Select the second Point|"));
		
		Vector3d vecDir = (pt2 - pt1);
		vecDir.normalize();
		if(vecDir.isParallelTo(vecZ))
		{ 
			reportMessage(TN("|vector not valid|"));
		}
		
		// project to plane
		vecDir = vecDir.crossProduct(vecZ);
		vecDir.normalize();
		vecDir = vecZ.crossProduct(vecDir);
		vecDir.normalize();
		vecX = vecDir.crossProduct(vecZ);
		
		_Map.setVector3d("vecX", vecX);
		_Map.setVector3d("vecY", vecDir);
		_Map.setVector3d("vecZ", vecZ);
		// we take note the trigger is triggered so we set ptg to middle
		_Map.setInt("trigger", 1);

		setExecutionLoops(2);
		return;
	}//endregion	
	
// Trigger setDefaultDrillDirection//region
	String sTriggersetDefaultDrillDirection = T("|set Default Drill Direction|");
	addRecalcTrigger(_kContext, sTriggersetDefaultDrillDirection );
	if (_bOnRecalc && (_kExecuteKey==sTriggersetDefaultDrillDirection || _kExecuteKey==sDoubleClick))
	{
		if (_Map.hasVector3d("vecX"))_Map.removeAt("vecX",true);
		if (_Map.hasVector3d("vecY"))_Map.removeAt("vecY",true);
		if (_Map.hasVector3d("vecZ"))_Map.removeAt("vecZ",true);
		_Map.setInt("trigger", 1);
		setExecutionLoops(2);
		return;
	}//endregion
	
	if (_Map.hasVector3d("vecX")) vecX=_Map.getVector3d("vecX");
	if (_Map.hasVector3d("vecY")) vecY=_Map.getVector3d("vecY");
	if (_Map.hasVector3d("vecZ")) vecZ=_Map.getVector3d("vecZ");
	
	vecX.vis(_Pt0,1);
	vecY.vis(_Pt0,3);
	vecZ.vis(_Pt0,150);
// get intersection direction
	Vector3d vecXDir = vecY;
	if (nAlignment==1)
		vecXDir = vecX;
	Vector3d vecYDir = vecXDir.crossProduct(-vecZ);	

	ptRef.transformBy(vecZ*(vecZ.dotProduct(sip.ptCenSolid()-ptRef)+dZOffset));
	ptRef.vis(1);
	Plane pn(ptRef, vecYDir);
	Line ln(ptRef,vecXDir);
	_Pt0 = ptRef;
	vecXDir.vis(_Pt0+vecZ*U(20),20);
	vecYDir.vis(_Pt0+vecZ*U(20),90);
// get extreme intersections
	Body bdEnv = sip.envelopeBody(false, true);
// sip planeprofile
	PlaneProfile ppSip=sip.realBody().shadowProfile(Plane(sip.ptCen(),sip.vecZ()));
	Body bdTest(ptRef-vecXDir*U(50000),ptRef+vecXDir*U(50000), dDiameter/2);
	bdTest.intersectWith(bdEnv); //bdTest.vis(3);
	Point3d ptsInt[] = ln.orderPoints(ln.projectPoints(bdTest.extremeVertices(vecXDir)));
	if (ptsInt.length()<2)
	{	
		reportMessage("\ninvalid location");
		eraseInstance();
		return;		
	}	
	
// test max dist and if two drills are required
	double dMaxDist = abs(vecXDir.dotProduct(ptsInt[0]-ptsInt[ptsInt.length()-1]));
	double dDist1 = abs(vecXDir.dotProduct(ptRef-ptsInt[0]));
	double dDist2 = abs(vecXDir.dotProduct(ptRef-ptsInt[ptsInt.length()-1]));
	
	Point3d ptsEnd[0], ptsStart[0];
	int bAdd2 = nDirection==2;

// test if two drills are required
	if (dMaxDist>dMaxDepth)
	{
		//if dMaxDist/2<=dMaxDepth)
		if ((nDirection==0 && dDist1>dMaxDepth) || 
			 (nDirection==1 && dDist2>dMaxDepth))
			bAdd2=true;
	}	
	if (bAdd2)
	{
		Point3d ptEnd = (ptsInt[0]+ptsInt[ptsInt.length()-1])/2;
		int bExceeds;
		if (abs(vecXDir.dotProduct(ptsInt[0]-ptEnd))>dMaxDepth)
			bExceeds=true;		
		
		ptsStart.append(ptsInt[0]);
		if (bExceeds)	ptEnd=ptsInt[0]+vecXDir*dMaxDepth;
		ptsEnd.append(ptEnd);
		
		ptsStart.append(ptsInt[1]);		
		if (bExceeds)	ptEnd=ptsInt[1]-vecXDir*dMaxDepth;
		ptsEnd.append(ptEnd);
	}
	else if (nDirection==0)// bottom/left
	{
		ptsStart.append(ptsInt[0]);
		ptsEnd.append(ptRef);
	}
	else if (nDirection==1)// top/right
	{
		ptsStart.append(ptsInt[1]);
		ptsEnd.append(ptRef);		
	}

// Display
	Display dp(6);
	dp.color(nColor);
// point for text
	Point3d pt1;
// add drills
	CoordSys csRot;
	csRot.setToRotation(60, vecXDir, _Pt0);
	double dLengths[0], dDiameters[0];
	LineSeg lSegsDrill[0];
	for (int i=0;i<ptsStart.length();i++)
	{
		Point3d& ptStart=ptsStart[i];
		Point3d& ptEnd = ptsEnd[i];
		Vector3d vecX2 = ptEnd - ptStart;
		vecX2.normalize();
		dp.draw(PLine(ptStart, ptEnd));
		
		PLine plTip(ptEnd, ptEnd - vecX2 * 2 * dDiameter + vecYDir * .5 * dDiameter);
		for (int j=0;j<6;j++) 
		{ 
			dp.draw(plTip);
			plTip.transformBy(csRot); 
		}//next j
		plTip.createCircle(ptEnd-vecX2 * 2 * dDiameter, vecX2, dDiameter / 2);
		dp.draw(plTip);
		
		Drill drill(ptStart, ptEnd, dDiameter/2);
		sip.addTool(drill);
		// HSB-22608
		{ 
			LineSeg lSeg(ptStart-vecYDir*dDiameter/2, ptEnd-vecYDir*dDiameter/2);
			LineSeg lSegs[]=ppSip.splitSegments(lSeg,true);
			for (int s=0;s<lSegs.length();s++) 
			{ 
				lSegsDrill.append(lSegs[s]);
			}//next s
			lSeg=LineSeg (ptStart+vecYDir*dDiameter/2, ptEnd+vecYDir*dDiameter/2);
			LineSeg lSegs2[]=ppSip.splitSegments(lSeg,true);
			for (int s=0;s<lSegs2.length();s++) 
			{ 
				lSegsDrill.append(lSegs2[s]);
			}//next s
		}
		//
		dLengths.append((ptEnd - ptStart).length());
		dDiameters.append(dDiameter);
	}	
		
Entity ents[0];
ents.append(sip);

//region Parse text and display if founsd
//region Collect list of available object variables and append properties which are unsupported by formatObject (yet)
	String sObjectVariables[] = _ThisInst.formatObjectVariables();

//region Add custom variables for format resolving
	// adding custom variables or variables which are currently not supported by core
//	String sCustomVariables[] ={ "Radius", "Diameter", "Length", "Area"};
	String sCustomVariables[] ={ sDiameterName, sMaxDepthName, sZOffsetName, sAlignmentName, sDirectionName};
	String sCustomValues[] ={ dDiameter, dMaxDepth, dZOffset, sAlignment, sDirection};
	
	for (int i=0;i<sCustomVariables.length();i++)
	{ 
		String k = sCustomVariables[i];
		if (sObjectVariables.find(k) < 0)
			sObjectVariables.append(k);
	}	
	
// get translated list of variables
	String sTranslatedVariables[0];
	for (int i=0;i<sObjectVariables.length();i++) 
		sTranslatedVariables.append(T("|"+sObjectVariables[i]+"|")); 
	
// order both arrays alphabetically
	for (int i=0;i<sTranslatedVariables.length();i++) 
		for (int j=0;j<sTranslatedVariables.length()-1;j++) 
			if (sTranslatedVariables[j]>sTranslatedVariables[j+1])
			{
				sObjectVariables.swap(j, j + 1);
				sTranslatedVariables.swap(j, j + 1);
			}			
//End add custom variables//endregion 
//End get list of available object variables//endregion 

//region Trigger AddRemoveFormat
	String sTriggerAddRemoveFormat = T("|Add/Remove Format|");
	addRecalcTrigger(_kContext, "../"+sTriggerAddRemoveFormat );
	if (_bOnRecalc && (_kExecuteKey=="../"+sTriggerAddRemoveFormat || _kExecuteKey==sTriggerAddRemoveFormat))
	{
		String sPrompt;
//		if (bHasSDV && entsDefineSet.length()<1)
//			sPrompt += "\n" + T("|NOTE: During a block setup only limited properties are accesable, but you can enter \nany valid format expression or use custom catalog entries.|");
		sPrompt+="\n"+ T("|Select a property by index to add(+) or to remove(-)|") + T(" ,|-1 = Exit|");
		reportNotice(sPrompt);
		
		for (int s=0;s<sObjectVariables.length();s++) 
		{ 
			String key = sObjectVariables[s]; 
			String keyT = sTranslatedVariables[s];
			String sValue;
			for (int j=0;j<ents.length();j++) 
			{ 
				String _value = ents[j].formatObject("@(" + key + ")");
				if (_value.length()>0)
				{ 
					sValue = _value;
					break;
				}
			}//next j

			String sAddRemove = sFormat.find(key,0, false)<0?"(+)" : "(-)";
			int x = s + 1;
			String sIndex = ((x<10)?"    " + x:"   " + x)+ "  "+sAddRemove+"  :";
			
			reportNotice("\n"+sIndex+keyT + "........: "+ sValue);
			
		}//next i
		int nRetVal = getInt(sPrompt)-1;
				
	// select property	
		while (nRetVal>-1)
		{ 
			if (nRetVal>-1 && nRetVal<=sObjectVariables.length())
			{ 
				String newAttrribute = sFormat;
	
			// get variable	and append if not already in list	
				String variable ="@(" + sObjectVariables[nRetVal] + ")";
				int x = sFormat.find(variable, 0);
				if (x>-1)
				{
					int y = sFormat.find(")", x);
					String left = sFormat.left(x);
					String right= sFormat.right(sFormat.length()-y-1);
					newAttrribute = left + right;
					reportMessage("\n" + sObjectVariables[nRetVal] + " new: " + newAttrribute);				
				}
				else
				{ 
					newAttrribute+="@(" +sObjectVariables[nRetVal]+")";
								
				}
				sFormat.set(newAttrribute);
				reportMessage("\n" + sFormatName + " " + T("|set to|")+" " +sFormat);	
			}
			nRetVal = getInt(sPrompt)-1;
		}
	
		setExecutionLoops(2);
		return;
	}	
	
	
//endregion 

//region Resolve format by entity
	String text;// = "R" + dDiameter * .5;
	if (sFormat.length()>0)
	{ 
		String sLines[0];// store the resolved variables by line (if \P was found)	
		String sValues[0];	
		String sValue=  _ThisInst.formatObject(sFormat);
	
	// parse for any \P (new line)
		int left= sValue.find("\\P",0);
		while(left>-1)
		{
			sValues.append(sValue.left(left));
			sValue = sValue.right(sValue.length() - 2-left);
			left= sValue.find("\\P",0);
		}
		sValues.append(sValue);	
	
	// resolve unknown variables
		for (int v= 0; v < sValues.length(); v++)
		{
			String& value = sValues[v];
			int left = value.find("@(", 0);
			
		// get formatVariables and prefixes
			if (left>-1)
			{ 
				// tokenize does not work for strings like '(@(KEY))'
				String sTokens[0];
				while (value.length() > 0)
				{
					left = value.find("@(", 0);
					int right = value.find(")", left);
					
				// key found at first location	
					if (left == 0 && right > 0)
					{
						String sVariable = value.left(right + 1);
						
						//"Radius", "Diameter", "Length", "Area"
						String s;
						if (sVariable.find("@("+sCustomVariables[0]+")",0,false)>-1)
						{
							s.formatUnit(dDiameter*.5,_kLength);
							sTokens.append(s);
						}
						else if (sVariable.find("@("+sCustomVariables[1]+")",0,false)>-1)
						{
							s.formatUnit(dMaxDepth*.5,_kLength);
							sTokens.append(s);	
						}
						else if (sVariable.find("@("+sCustomVariables[2]+")",0,false)>-1)
						{ 
							s.formatUnit(dZOffset,_kLength);
							sTokens.append(s);
						}							
						else if (sVariable.find("@("+sCustomVariables[3]+")",0,false)>-1)
						{ 
							s = sAlignment;
							sTokens.append(s);
						}
						else if (sVariable.find("@("+sCustomVariables[4]+")",0,false)>-1)
						{ 
							s = sDirection;
							sTokens.append(s);
						}
						value = value.right(value.length() - right - 1);
					}
				// any text inbetween two variables	
					else if (left > 0 && right > 0)
					{
						sTokens.append(value.left(left));
						value = value.right(value.length() - left);
					}
				// any postfix text
					else
					{
						sTokens.append(value);
						value = "";
					}
				}
//	
				for (int j=0;j<sTokens.length();j++) 
					value+= sTokens[j]; 
			}
//			//sAppendix += value;
			sLines.append(value);
		}	
//		
	// text out
		for (int j=0;j<sLines.length();j++) 
		{ 
			text += sLines[j];
			if (j < sLines.length() - 1)text += "\\P";		 
		}//next j
	}
//		
//End Resolve format by entity//endregion 

// find outside location and draw text
	String sDimStyle = _DimStyles.first();
	double textHeight = dp.textHeightForStyle("O", sDimStyle);
	if (dTextHeight <= 0)dTextHeight.set(textHeight); 
	textHeight = dTextHeight;
	dp.textHeight(textHeight);
	Vector3d vxText, vyText;
	if (text.length()>0)
	{ 
//		Point3d pt1 = _Pt0 - vecY * U(10);
		Point3d pt1 = .5 * (ptsStart[0] + ptsEnd[0]);
		Line ln(pt1, vecY);
		if (_PtG.length() < 1)_PtG.append(pt1);
		// each time direction is changed, set ptg to middle
		if(_Map.getInt("trigger"))
		{ 
			_Map.setInt("trigger", 0);
			// each time direction is changed, set ptg to middle
			if (_PtG.length() > 0)_PtG[0] = .5 * (ptsStart[0] + ptsEnd[0]);
		}
		// allow only along the line
		_PtG[0] = ln.closestPointTo(_PtG[0]);
		String events[0];
		events.append(sCustomVariables);
		
		if (_bOnDbCreated || events.find(_kNameLastChangedProp)>-1 || bDebug)
		{ 
			double dX = dp.textLengthForStyle(text, sDimStyle, textHeight);
			double dY = dp.textHeightForStyle(text, sDimStyle, textHeight);
//			PlaneProfile ppText;
//			ppText.createRectangle(LineSeg(pt1-.5*(vecX*dX+vecY*dY),pt1+.5*(vecX*dX+vecY*dY)), vecX, vecY);//ppText.vis(6);
//			ppSym.removeAllOpeningRings();
//			ppText.intersectWith(ppSym);
//			if (ppText.area()>pow(dEps,2))
//			{ 
//				LineSeg segs[] = ppText.splitSegments(LineSeg (ppSym.extentInDir(vecX).ptMid(),pt1), true);
//				if (segs.length()>0)
//				{
//					//segs.first().vis(5);
//					Vector3d v = Vector3d(segs.first().ptEnd() - segs.first().ptStart());
//					double d = v.length() + .25 * textHeight;
//					v.normalize();
//					pt1 += v*d;
//				}
//			}
			pt1.vis(3);	
			_PtG[0] = pt1;	
		}
		if(nAlignment==0)
		{ 
			vxText = vecY;vyText = -vecX;
			dp.draw(text, _PtG[0], vecY, -vecX, 0, 0);
		}
		else
		{ 
			vxText = vecX;vyText = vecY;
			dp.draw(text, _PtG[0], vecX, vecY, 0, 0);
		}
		
	}
	else
		_PtG.setLength(0);
//End Parse text and display if founsd//endregion 

//region publish in map for blocks at shopdraw
//	Map mpAnnotation;
//	mpAnnotation.setString("Annotation",text);
//	mpAnnotation.setPoint3d("ptAText",_PtG[0]);
//	//mpAnnotation.setPoint3d("ptAL",_PtG[0]-vecX*U(100));
//	mpAnnotation.setPoint3d("ptAL",_PtG[0]);
//	
//	mpAnnotation.setDouble("Color",6);
//	mpAnnotation.setDouble("Height",textHeight);
//	_Map.setMap("Anno",mpAnnotation);
	if (_Map.hasMap("Anno"))_Map.removeAt("Anno",false);
	
	int iAllowOverwrite = 0;
	if (sNoYes.find(sAllowOverwrite) == 1)iAllowOverwrite = 1;
	Map mapRequests, mapRequestText;
	mapRequestText.setString("Stereotype", "CoreDrillText");
	mapRequestText.setString("text", text);
	mapRequestText.setVector3d("AllowedView", vecZ);
	mapRequestText.setVector3d("vecX" ,vxText);
	mapRequestText.setVector3d("vecY", vyText);
	mapRequestText.setInt("AlsoReverseDirection", true);
	mapRequestText.setDouble("textHeight", textHeight);
	mapRequestText.setInt("color", nColor);
	mapRequestText.setPoint3d("ptLocation", _PtG[0]);
	mapRequestText.setDouble("dXFlag", 0);
	mapRequestText.setDouble("dYFlag", 0);
	mapRequestText.setInt("AllowOverwrite",iAllowOverwrite );
	mapRequests.appendMap("DimRequest", mapRequestText);
	
	// HSB-11245: publish dimension
	Map mapRequestDim;
//	mapRequestDim.setString("DimRequestPoint", "DimRequestPoint");
	mapRequestDim.setString("DimRequestChain", "DimRequestChain");
	mapRequestDim.setVector3d("AllowedView", vecZ);
	mapRequestDim.setInt("AlsoReverseDirection", true);
	mapRequestDim.setVector3d("vecDimLineDir", vxText);
	mapRequestDim.setVector3d("vecPerpDimLineDir", vyText);
	mapRequestDim.setString("stereotype", "hsbCLT-CoreDrill");
	mapRequestDim.setPoint3d("ptRef", _Pt0);
	Point3d ptNodes[0];
	ptNodes.append(ptsStart[0]);
	ptNodes.append(ptsEnd[0]);
	mapRequestDim.setPoint3dArray("Node[]", ptNodes);
	// HSB-22608: maprequest pline
	Map mapRequestPline;
	mapRequestPline.setVector3d("AllowedView",vecZ);
	mapRequestPline.setInt("AlsoReverseDirection",true);
	mapRequestPline.setInt("color", 30);
	int iLineTypeHidden=_LineTypes.find("HIDDEN");
	double dLineScale=8;
	if (iLineTypeHidden<0)
	{
		iLineTypeHidden=_LineTypes.find("HIDDEN2");
		dLineScale=.6;
	}
	
	if(iLineTypeHidden>-1)
	{ 
		// HSB-22608
		mapRequestPline.setString("lineType",_LineTypes[iLineTypeHidden]);
		mapRequestPline.setDouble("lineTypeScale",dLineScale);
		mapRequestPline.setString("Stereotype","CoreDrillHidden");
		
		for (int s=0;s<lSegsDrill.length();s++) 
		{ 
			LineSeg lSegS=lSegsDrill[s];
			PLine pl;
			pl.addVertex(lSegS.ptStart());
			pl.addVertex(lSegS.ptEnd());
			mapRequestPline.setPLine("pline", pl);
			mapRequests.appendMap("DimRequest", mapRequestPline);
		}//next s
	}
	
	mapRequests.appendMap("DimRequest", mapRequestDim);
	
	_Map.setMap("DimRequest[]", mapRequests);
//End publish in map for shopdraw//endregion 	

//region publish hardware
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
		if (elHW.bIsValid()) 	sHWGroupName=elHW.elementGroup().name();
	// loose
		else
		{
			Group groups[] = _ThisInst.groups();
			if (groups.length()>0)
				sHWGroupName=groups[0].name();
		}		
	}
	
// add main componnent
	for (int i=0;i<dLengths.length();i++) 
	{ 
		HardWrComp hwc("CoreDrill", 1); // the articleNumber and the quantity is mandatory
		
		hwc.setManufacturer("KLH");
		
//		hwc.setModel(pdHeight+"x"+pdWidth);
		hwc.setName("CoreDrill");
//		hwc.setDescription(sHWDescription);
//		hwc.setMaterial(sHWMaterial);
//		hwc.setNotes(sHWNotes);
		
		hwc.setGroup(sHWGroupName);
		hwc.setLinkedEntity(sip);	
		hwc.setCategory(T("|Tool|"));
		hwc.setRepType(_kRTTsl); // the repType is used to distinguish between predefined and custom components
		
		hwc.setDScaleX(dLengths[i]);
		hwc.setDScaleY(dDiameter);
//		hwc.setDScaleZ(pdHeight);

	// apppend component to the list of components
		hwcs.append(hwc);
	}

// make sure the hardware is updated
	if (_bOnDbCreated)	setExecutionLoops(2);
	_ThisInst.setHardWrComps(hwcs);		
//End publish hardware//endregion 



#End
#BeginThumbnail
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
?4144Y`)4`'\.:Z6SA:"S@A8@M'&JDCID#%6**`/_V>?Y
`











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
        <int nm="BreakPoint" vl="876" />
        <int nm="BreakPoint" vl="532" />
      </lst>
    </lst>
  </lst>
  <lst nm="TslInfo">
    <lst nm="TSLINFO">
      <lst nm="TSLINFO">
        <lst nm="TSLINFO">
          <lst nm="TSLINFO">
            <lst nm="TSLINFO" />
          </lst>
        </lst>
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22608: Add shopdraw information for hidden lines of core drills" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="9/9/2024 10:32:29 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-15563: add string &quot;Stereotype&quot; to control visibility in sd_EntitySymbolDisplay" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="5/25/2022 10:53:26 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11245: write a maprequest for its dimension" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="3/17/2021 4:45:45 PM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End