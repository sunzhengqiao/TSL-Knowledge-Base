#Version 8
#BeginDescription
version value="2.0" date="22aug19" author="nils.gregor@hsbcad.com"> Instance will be erased if zone thickness is zero

bugfix zone assignment
tool supports also doors
bugfix

This tsl modifies the sheetings above or below an opening.
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 2
#MinorVersion 0
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl modifies the sheetings above or below an opening. 
/// </summary>

/// <insert=en>
/// Select an opening
/// </insert>


/// <remark>
/// The calculation is based on the assumption that the opeing has a rectangular shape
/// </remark>

/// History
///<version value="2.0" date="22aug19" author="nils.gregor@hsbcad.com"> Instance will be erased if zone thickness is zero</version>
///<version value="1.9" date="12jul19" author="nils.gregor@hsbcad.com"> Corrected the description of the horizontal properties</version>
///<version value="1.8" date="27jun19" author="nils.gregor@hsbcad.com"> Add properties for horizontal gaps underneath and upon the shutter sheet</version>
///<version value="1.7" date="29april16" author="florian.wuermseer@hsbcad.com"> bugfix sheet alignment in negative zones </version>
///<version value="1.6" date="14jan16" author="thorsten.huck@hsbcad.com"> bugfix zone assignment </version>
///<version value="1.5" date="25nov15" author="thorsten.huck@hsbcad.com"> tool supports also doors </version>
///<version value="1.4" date="25nov15" author="thorsten.huck@hsbcad.com"> bugfix </version>
///<version value="1.3" date="12nov15" author="thorsten.huck@hsbcad.com"> bugfix new option 'lateral offset' enables a lateral gap of the shutter sheets </version>
///<version value="1.2" date="11nov15" author="thorsten.huck@hsbcad.com"> takes gap of sheeting zone into consideration, new option 'lateral offset' enables a lateral gap of the shutter sheets </version>
///<version value="1.1" date="09jul15" author="thorsten.huck@hsbcad.com"> bugfix z-position of sheet </version>
///<version value="1.0" date="08jul15" author="thorsten.huck@hsbcad.com"> initial </version>

// constants
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	int bDebug;//=true;

	String sZoneName = T("|Zone|");
	int nZones[] = {-5,-4,-3,-2,-1,1,2,3,4,5};
	PropInt nZone(nIntIndex++, nZones, sZoneName,5);
	
	String sCategoryGeometry = T("|Geometry|");
	String sXOffsetName=T("|X-Offset|");
	PropDouble dXOffset(nDoubleIndex++,0, sXOffsetName);
	dXOffset.setCategory(sCategoryGeometry );
	dXOffset.setDescription(T("|Defines the offset in X-direction|"));

	String sYOffsetName=T("|Y-Offset|");
	PropDouble dYOffset(nDoubleIndex++,0, sYOffsetName);
	dYOffset.setCategory(sCategoryGeometry );
	dYOffset.setDescription(T("|Defines the offset in X-direction|"));

	String sMaxHeightName=T("|max. Height|");
	PropDouble dMaxHeight(nDoubleIndex++,0, sMaxHeightName);
	dMaxHeight.setCategory(sCategoryGeometry );
	dMaxHeight.setDescription(T("|Defines the maximal height of the sheet above/below the opening|") + " " + T("|0 = no limit|"));

	String sXGapName=T("|Lateral offset|");
	PropDouble dXGap(nDoubleIndex++,0, sXGapName);
	dXGap.setCategory(sCategoryGeometry );
	dXGap.setDescription(T("|Defines a horizontal gap|"));

	String sYGapName=T("|Gap towards opening|");
	PropDouble dYGap1(nDoubleIndex++,0, sYGapName);
	dYGap1.setCategory(sCategoryGeometry );
	dYGap1.setDescription(T("|Defines a horizontal gap at the side of the opening|"));
	
	String sYGapName2=T("|Gap opposite opening|");
	PropDouble dYGap2(nDoubleIndex++,0, sYGapName2);
	dYGap2.setCategory(sCategoryGeometry );
	dYGap2.setDescription(T("|Defines a horizontall gap at the opposide side of the opening|"));
	
	String sCategoryAlignment =T("|Alignment|");
	String sAlignments[] = {T("|Bottom|"),T("|Top|")};
	PropString sAlignment(nStringIndex++,sAlignments, sCategoryAlignment,1);
	sAlignment.setCategory(sCategoryAlignment);
	sAlignment.setDescription(T("|Defines the alignment|"));
	
// on insert
	if (_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }	

	// a potential catalog entry name and all available entries
		String sEntry = _kExecuteKey;
		String sEntryUpper = sEntry; sEntryUpper.makeUpper();
		String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
		for (int i=0;i<sEntries.length();i++)
			sEntries[i].makeUpper();
		int nEntry = sEntries.find(sEntryUpper);
							
	// silent/dialog
		if (nEntry>-1)
			setPropValuesFromCatalog(sEntry);	
		else
		{
		//// get element and zone by sheet
			//Sheet sh = getSheet();
			//Element el = sh.element();
			//if (!el.bIsValid())
			//{
				//reportMessage(T("|Invalid selection|") + " " + T("|Tool will be deleted|"));
				//eraseInstance();
				//return;	
			//}	
			//nZone.set(sh.myZoneIndex());	
			showDialog()	;	
		}
		
	// selection set
		Entity entsSet[0];
		PrEntity ssE(T("|Select opening(s)|"), OpeningSF());	
		if (ssE.go())
			entsSet= ssE.set();		
		
	// declare the tsl props
		TslInst tslNew;
		Vector3d vecUcsX = _XW;
		Vector3d vecUcsY = _YW;
		GenBeam gbs[0];
		Entity ents[1];
		Point3d pts[0];
		int nProps[] = {nZone};
		double dProps[] = {dXOffset,dYOffset,dMaxHeight,dXGap, dYGap1, dYGap2};
		String sProps[] = {sAlignment};
		Map mapTsl;
		String sScriptname = scriptName();			

	// insert per opening
		if (bDebug)	reportMessage("\n" + entsSet.length() + " " + entsSet.length());

		for (int e=0;e<entsSet.length();e++)
		{
			ents[0] = entsSet[e];
			tslNew.dbCreate(sScriptname, vecUcsX,vecUcsY,gbs, ents, pts, 
				nProps, dProps, sProps,_kModelSpace, mapTsl); // create new instance

		}
		
		
		eraseInstance();	
		return;
	}	
//end on insert________________________________________________________________________________

// the dialog it attached as opening tsl
	String sKeys[] = {"Zone","XOffset","YOffset","MaxHeight","Alignment"};
	if (_bOnMapIO)
	{
		showDialog();
		_Map=Map();
		int nInd;
		_Map.setString(sKeys[nInd++], nZone);
		_Map.setString(sKeys[nInd++], dXOffset);
		_Map.setString(sKeys[nInd++], dYOffset);
		_Map.setString(sKeys[nInd++], dMaxHeight);
		_Map.setString(sKeys[nInd++], sAlignment);
		return;	
	}

// set properties on dbCreated if this is an opening tsl instance
	if (_bOnDbCreated)
	{
		int nInd;
		if(_Map.hasString(sKeys[nInd])) nZone.set(_Map.getString(sKeys[nInd]).atoi());nInd++;	// zone
		if(_Map.hasString(sKeys[nInd])) dXOffset.set(_Map.getString(sKeys[nInd]).atof());nInd++;	// dXOffset
		if(_Map.hasString(sKeys[nInd])) dYOffset.set(_Map.getString(sKeys[nInd]).atof());nInd++;	// dYOffset
		if(_Map.hasString(sKeys[nInd])) dMaxHeight.set(_Map.getString(sKeys[nInd]).atof());nInd++;	// dMaxHeight
		if(_Map.hasString(sKeys[nInd])) sAlignment.set(_Map.getString(sKeys[nInd]));nInd++;	// sAlignment
		
		//reportMessage ("\n" + scriptName());
		//reportMessage ("\n	Zone " + nZone);
		//reportMessage ("\n	X " + dXOffset);
		//reportMessage ("\n	Y " + dYOffset);
		//reportMessage ("\n	Max " + dMaxHeight);
		//reportMessage ("\n	Align " + sAlignment);

	}

// validate opening
	if (_Opening.length()<1)
	{
		if (bDebug)reportMessage("\nno opening");
		eraseInstance();
		return;	
	}
	
// the opening
	Opening opening = _Opening[0];
	Element el = opening.element();
	if (!el.bIsValid())	
	{
		if (bDebug)reportMessage("\nno element");		
		eraseInstance();
		return;			
	}
	Vector3d vecX = el.vecX();
	Vector3d vecY = el.vecY();
	Vector3d vecZ = el.vecZ();
	Point3d ptOrg = el.ptOrg();
	CoordSys cs = el.coordSys();
	if (bDebug && _bOnDbCreated)_Pt0 = ptOrg;
	PLine plOpeningShape = opening.plShape();

	
// get alignment
	int nAlignment=sAlignments.find(sAlignment);	
	
// query items of the referenced zone
	Sheet sheets[] = el.sheet(nZone);
	// wait
	if (sheets.length()<1)
	{
	// Erase instance if the zone is thinner than dEps
		if(el.zone(nZone).dH() < dEps)
		{
			eraseInstance();
			return;
		}
		
		Display dp(12);
		dp.draw(scriptName() + " " + T("|waiting for construction|"), opening.coordSys().ptOrg(), vecX, vecY,0,0,_kDeviceX);
		setExecutionLoops(2);
		return;	
	}
	
	
// build profile of selected zone
	ElemZone zo = el.zone(nZone);
	CoordSys csZone(zo.ptOrg(), -zo.vecZ().crossProduct(vecY),vecY, zo.vecZ());	
	csZone.vis(3);
	PlaneProfile ppZone(csZone);
	for (int i=0;i<sheets.length();i++)
	{
		PLine pl = sheets[i].plEnvelope();
		ppZone.joinRing(pl, _kAdd);	
	}	
	
// merge zone
	double dMerge = dEps;
	if (zo.hasVar("gap"))
		dMerge  = zo.dVar("gap");
	ppZone.shrink(-dMerge-dEps);
	ppZone.shrink(dMerge+dEps);
	//ppZone.vis(2);
	
// find real opening contour of this zone
	Point3d ptMid;
	plOpeningShape .projectPointsToPlane(Plane(zo.ptOrg(), zo.vecZ()), zo.vecZ());//plOpeningShape.vis(8);
	ptMid.setToAverage(plOpeningShape .vertexPoints(true));
	//ptMid.vis(3);	
	
	PLine plRings[] = ppZone.allRings();	//ppZone.vis(18);
	int bIsOp[] = ppZone.ringIsOpening();
	PLine plShape;
	for (int r=0;r<plRings.length();r++)
	{
		if (bIsOp[r])
		{
			PlaneProfile pp(plRings[r]);
			if (pp.pointInProfile(ptMid)==_kPointInProfile)
			{
				plShape=plRings[r];
				break;	
			}	
		}
	}
	
// if the opening detection has failed it might be a door
	if (plShape.area()<pow(dEps,2))
	{
	// get a hull of the zone
		PLine plHull;
		plHull.createConvexHull(Plane(ptMid, vecZ),ppZone.getGripVertexPoints());
		//plHull.vis(252);	
		
	// use hull as bounding
		PlaneProfile ppHull(plHull);
		ppHull.subtractProfile(ppZone);
		plRings = ppHull.allRings();	
		bIsOp = ppHull.ringIsOpening();
		for (int r=0;r<plRings.length();r++)
		{
			if (!bIsOp[r])
			{
				PlaneProfile pp(plRings[r]);
				if (pp.pointInProfile(ptMid)==_kPointInProfile)
				{
					plShape=plRings[r];
					break;	
				}	
			}
		}			
		
	}	
	
	//plShape.vis(1);	
	
// set direction vec
	Vector3d vecDir = vecY; // default top
	if (nAlignment==0)vecDir*=-1;
	
// get total shape seg		
	PlaneProfile ppShape(csZone);
	ppShape.joinRing(plShape,_kAdd);//ppShape.vis(5);
	LineSeg seg = ppShape.extentInDir(vecX);seg.vis(2);
	double dX = abs(vecX.dotProduct(seg.ptStart()-seg.ptEnd()));
	double dY = abs(vecY.dotProduct(seg.ptStart()-seg.ptEnd()));
	//return;
	
// Use vertical gaps at the right side. dYGap1 is always towards the opening, dYGap2 is opposite
	int dYUseGap1, dYUseGap2;
	if(nAlignment == 0)
	{
		dYUseGap1 = dYGap2;
		dYUseGap2 = dYGap1;
	}
	else
	{
		dYUseGap1 = dYGap1;
		dYUseGap2 = dYGap2;		
	}
	
// the opening should have height and width
	if (dX<dEps || dY < dEps)
	{
		reportMessage ("\n" + scriptName() + " : " +T("|Tool is not applicable.|"));	
		if (!bDebug)eraseInstance();
		return;
	}	

// get test height	
	double dTestHeight = U(10e4);
	if (dMaxHeight>0) dTestHeight =dMaxHeight;
	
	PLine plTest(vecZ);
	plTest.createRectangle(LineSeg(seg.ptMid()-(vecX*(.5*dX+dXOffset)-vecDir*(.5*dY+dYOffset - dYUseGap1)), seg.ptMid()+(vecX*(.5*dX+dXOffset)+vecDir*(.5*dY+dYOffset+dTestHeight + dYUseGap2))), vecX, vecY);
	plTest.setNormal(zo.vecZ());//plTest.vis(4);
	
	if(nAlignment == 0 )
		plTest.transformBy(vecDir * (dYUseGap1 - dYUseGap2));
	
	Body bdTest(plTest,zo.vecZ()*zo.dH()*2, 0);
	//bdTest.vis(222);	
	PlaneProfile ppTest(plTest);
// find intersecting sheets above/below
	Sheet shShutters[] = bdTest.filterGenBeamsIntersect(sheets);

	// subtract test area
	if (!bDebug)
		for (int i=shShutters.length()-1;i>=0;i--)
		{
			shShutters[i].joinRing(plTest,_kSubtract);	
			if (shShutters[i].bIsValid() && shShutters[i].profShape().area()<pow(dEps,2))
				shShutters[i].dbErase();
		}		

	
// build a profile for the shutter board
	PlaneProfile ppShutter(plTest);
	ppShutter.intersectWith(ppZone);
	ppShutter.transformBy(vecZ*U(50));
	ppShutter.vis(3);	
	
	LineSeg segShutter = ppShutter.extentInDir(vecX);
	double dXShutter = abs(vecX.dotProduct(segShutter .ptStart()-segShutter .ptEnd()));
	double dYShutter = abs(vecY.dotProduct(segShutter .ptStart()-segShutter .ptEnd()));	
	double dXShutterNet = dXShutter-2*dXGap;

// subtract gap left and right
	if (dXGap>0)
	{
		PLine pl;
		pl.createRectangle(LineSeg(segShutter.ptMid()-vecX*.5*dXShutterNet -vecY*U(10e4),segShutter.ptMid()+vecX*.5*dXShutterNet+vecY*U(10e4)), vecX, vecY);
		pl.transformBy(-vecX*dXShutterNet);
		ppShutter.joinRing(pl,_kSubtract);
		pl.transformBy(vecX*2*dXShutterNet);
		ppShutter.joinRing(pl,_kSubtract);
		//ppShutter.vis(4);	
	}	
	
// get zone values
	double dSheetWidth;
	if (zo.hasVar(2))
		dSheetWidth= zo.dVar(2);
	double dSheetHeight;
	if (zo.hasVar(6))
		dSheetHeight = zo.dVar(5);		
	double dSheetGap;
	if (zo.hasVar("gap"))
		dSheetGap= zo.dVar("gap");		

// if height and width are known from the zone validate if shutter sheets need to be distributed
	//if (dXShutterNet<dSheetWidth && dXShutterNet<dSheetHeight)
	if (dSheetWidth< dEps)
		dSheetWidth = U(10000);
	if (dSheetHeight< dEps)		
		dSheetHeight = U(10000);

	{
	// assign max dX value in case shutter width exceeds max sheeting size
		double dXS = dSheetWidth;
		double dYS = dYShutter;
		
		if (dXShutterNet>dSheetWidth && dSheetWidth<dSheetHeight && dYShutter<=dSheetWidth)
		{
		// use rotated dimensions
			dXS = dSheetHeight;
		}	
		
	// num to distribute
		int n=dXShutterNet/dXS+.99;		
	
	// loop
		Point3d pt = segShutter.ptMid()-vecX*.5*dXShutterNet;
		for (int x=0;x<n;x++)
		{
			pt.vis(2);
			PLine pl;
			pl.createRectangle(LineSeg(pt-vecY*(.5*dYS - dYUseGap1),pt+vecX*dXS+vecY*(.5*dYS - dYUseGap2)), vecX, vecY);	
			
			CoordSys csSheet;
			if (nZone > 0)
			{
				csSheet = csZone;
			}
			
			else
			{
				csSheet = CoordSys (csZone.ptOrg(), csZone.vecX(), -csZone.vecY(), -csZone.vecZ());
			}
			
			
			PlaneProfile ppSheet(csSheet);
			ppSheet.joinRing(pl,_kAdd);
			ppSheet.intersectWith(ppShutter);
			if (bDebug|| _bOnDebug)
				ppSheet.vis(x);
			else if (ppSheet.area()>pow(dEps,2))
			{
			// create the shutter board
				Sheet shShutter;
				
				if (nZone < 0)
				{
					ppSheet.transformBy(-vecZ*zo.dH());
				}			
					shShutter.dbCreate(ppSheet, zo.dH(),1);
					shShutter.assignToElementGroup(el, true, nZone,'Z');
					shShutter.setMaterial(zo.material());
					shShutter.setColor(zo.color());	
			}

			pt.transformBy(vecX*(dXS+dSheetGap));
		}	
	}
	
	if (!bDebug)
		eraseInstance();
	return;	
	
#End
#BeginThumbnail
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
,HXPI(Z<"K%%`'__9
`













#End