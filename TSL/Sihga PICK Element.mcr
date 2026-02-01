#Version 8
#BeginDescription
This TSL creates SIHGA PICK lifting devices in Roof/Floor Elements, referring to the center of gravity.

version value="1.1" date="08sep17" author="florian.wuermseer@hsbcad.com"> 
Belt lengths now displayed
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords Lifting Device, Center of Gravity
#BeginContents
/// <summary Lang=en>
/// This TSL creates SIHGA PICK lifting devices in Roof/Floor Elements, referring to the center of gravity.
/// </summary>

/// <insert Lang=en>
/// At least one Roof/Floor element is required. Multiple selection is possible.
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>


/// <version value="1.1" date="08sep17" author="florian.wuermseer@hsbcad.com"> Belt lengths now displayed </version>
/// <version value="1.0" date="30aug17" author="florian.wuermseer@hsbcad.com"> initial version </version>



	
	
	
// constants
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	bDebug = (projectSpecial().makeUpper().find("DEBUGTSL",0)>-1?true:(projectSpecial().makeUpper().find(scriptName().makeUpper(),0)>-1?true:bDebug));
	
	

// data
	double dMaxAngle = 45;
	double dBoundaryAngles[] = {5, 10, 15, 20, 25, 30, 35, 40, 45};
	double dMaxLoadsCase0[] = {2640, 2436, 2231, 2027, 1822, 1618, 1413, 1209, 1004, 800};
	double dMaxLoadsCase1[] = {3308, 3101, 2894, 2687, 2480, 2272, 2065, 1858, 1651, 1444};
	double dMaxLoadsCase2[] = {3480, 3254, 3028, 2801, 2575, 2349, 2123, 1896, 1670, 1444};
	double dMaxLoadsCase3[] = {1400, 1297, 1194, 1091, 988, 884, 781, 678, 575, 472};
	double dMaxLoadsCase4[] = {1680, 1601, 1523, 1444, 1365, 1287, 1208, 1129, 1051, 972};
	
	
// drills' parameters	
	double dDiamMain = U(50);
	

// properties	
// distribution
	String sCatDist = T("|Distribution|");
	int nQuants[] = {3, 4};
	String sQuantName = "(A) - " + T("|Quantity|");
	PropInt nQuant (nIntIndex++, nQuants, sQuantName, 1);
	nQuant.setCategory(sCatDist);
	
	String sBeltLengthName = "(B) - " + T("|Lifting Belt Length|");
	PropDouble dBeltLength (nDoubleIndex++, U(2000), sBeltLengthName);
	dBeltLength.setCategory(sCatDist);
	
	String sInterdistanceName = "(C) - " + T("|Distance Lifting points|");
	PropDouble dInterdistance (nDoubleIndex++, U(1000), sInterdistanceName);
	dInterdistance.setCategory(sCatDist);

	double dMaxInterdistance = ceil(-(dBeltLength * cos(45)*10000))/-10000;
	if (nQuant == 2)
		dMaxInterdistance = ceil(-(2*dBeltLength * cos(45)*10000))/-10000;
	int nForceRecalc;
	if (dInterdistance > dMaxInterdistance)
	{ 
		reportMessage("\n" + T("|Distance corrected to|") + " " + dMaxInterdistance + " --> " + T("|min. lifting belt angle = 45°|"));
		dInterdistance.set(dMaxInterdistance);
		nForceRecalc = 1;
	}
	
// tooling
	String sCatTooling = T("|Tooling|");
	
	String sYesNo[] = {T("|No|"), T("|Yes|")};
	String sWeinmannToolsName = "(D) - " + T("|Apply Weinmann Tools|");
	PropString sWeinmannTools (nStringIndex++, sYesNo, sWeinmannToolsName);
	sWeinmannTools.setCategory(sCatTooling);
	int nWeinmannTools = sYesNo.find(sWeinmannTools);



	
// on insert __________________________________________________________________________________________________
	if (_bOnInsert)
	{
		if (insertCycleCount()>1) {eraseInstance(); return; }	
		
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
			showDialog();

	// declare the tsl props
		TslInst tslNew;
		Vector3d vecUcsX = _XW;
		Vector3d vecUcsY = _YW;
		GenBeam gbs[0];
		Entity ents[1];
		Point3d pts[0];
		int nProps[] = {nQuant};
		double dProps[] = {dBeltLength, dInterdistance};
		String sProps[] = {sWeinmannTools};
		Map mapTsl;
		String sScriptname = scriptName();	
				
	// selection set
		Entity entsSet[0];
		PrEntity ssE(T("|Select element(s)|"), ElementRoof());	
		if (ssE.go())
			entsSet= ssE.set();

	// insert per element
		if (bDebug)reportMessage("\n" + entsSet.length() + " " + T("|Element(s) selected|"));
		for (int e=0;e<entsSet.length();e++)

		{
			ents[0] = entsSet[e];
			tslNew.dbCreate(sScriptname, vecUcsX,vecUcsY,gbs, ents, pts, nProps, dProps, sProps,_kModelSpace, mapTsl); // create new instance
		}

		eraseInstance();
		return;
	}	
//end on insert___________________________________________________________________________________

	String sCatInfo = T("|Information|");
	
	String sWeightName = T("|Element weight|");
	PropString sWeight (nStringIndex++, 0, sWeightName);
	sWeight.setCategory(sCatInfo);
	
	sWeight.setReadOnly(TRUE);
	double dWeight;

	

// validate element
	if (_Element.length()<1)
	{
		if (bDebug)reportMessage("\nno element");
		eraseInstance();
		return;	
	}

	if (!_Element[0].bIsKindOf(ElementRoof()))
	{
		if (bDebug)reportMessage("\nno wall element");
		eraseInstance();
		return;	
	}
	
	ElementRoof el = (ElementRoof)_Element[0];

// assigning
	assignToElementGroup(el, true, 0, 'I');	
	
	Vector3d vecX = el.vecX();
	Vector3d vecY = el.vecY();
	Vector3d vecZ = el.vecZ();
	Point3d ptOrg = el.ptOrg();
	Point3d ptGrav;
	//_Pt0 = el.ptOrg();
	
	vecX.vis(el.ptOrg(),1);
	vecY.vis(el.ptOrg(),3);
	vecZ.vis(el.ptOrg(),5);
	
// display
	_ThisInst.setHyperlink("https://www.sihga.com/pick.html");
	Display dpErrorModel(1);
	dpErrorModel.addHideDirection(_ZW);	

	Display dpErrorPlan (1);
	dpErrorPlan.addViewDirection(_ZW);
	
	Display dpPlan(7);
	dpPlan.addViewDirection(_ZW);
	
	Display dpModel(7);
//	dpModel.addHideDirection(_ZW);	
	
// the planes of the Element
	Plane pnZ0 (el.ptOrg(), vecZ);
	Plane pnCen (el.ptOrg() - vecZ * .5*el.dBeamWidth(), vecZ);
	
// determine the thickness of the sheets in upper zones
	double dTopZonesThickness;
	for (int i=1 ; i < 6 ; i++)
	    dTopZonesThickness = dTopZonesThickness + el.zone(i).dH();
	    
// if the top zones thickness > 22mm, the lifting device can't be used
	if(dTopZonesThickness > U(22)+dEps)
	{
		reportMessage("\n" + T("|Top sheeting zones' thickness is out of range (> 22mm)|") + " --> " + T("|Tool will be deleted|"));
		dpErrorModel.draw("Error", _Pt0, vecX, vecY, 0,1);
		if (!bDebug) eraseInstance();
		return;
	}

	Plane pnTop = pnZ0;
	pnTop.transformBy(vecZ * dTopZonesThickness);
	pnTop.vis(30);
		
// declare important beams	
	Beam bmAll[]=el.beam();
// remove dummy beams
	for (int i=bmAll.length()-1; i>=0; i--)
	{
		if (bmAll[i].bIsDummy() == TRUE)
		 	bmAll.removeAt(i);
	}
	
// beams in plane
	Beam bmPlanes[] = vecZ.filterBeamsPerpendicularSort(bmAll);
	if (bmPlanes.length()<1)
		return;	

	
// detect possible areas for the lifting device (only Axis lines of beams > 80x120mm)
	PLine plBeamsAxis[0];
	PLine plEnv = el.plEnvelope();
	PlaneProfile ppEnv;
	
	for (int b = 0; b < bmPlanes.length(); b++)
	{
		double dBeamH = bmPlanes[b].dD(vecZ);
		double dBeamW = bmPlanes[b].dD(vecZ.crossProduct(bmPlanes[b].vecX()));
		
		if (dBeamH < U(120)-dEps || dBeamW < U(80)-dEps)
			continue;
		
		LineSeg lsBeam = bmPlanes[b].envelopeBody(0, 1).shadowProfile(pnTop).extentInDir(bmPlanes[b].vecX());
		double dLength = bmPlanes[b].vecX().dotProduct(lsBeam.ptEnd() - lsBeam.ptStart()) - U(500);
		if (dLength > dEps)
		{ 
			PLine plAxis (lsBeam.ptMid() - .5*bmPlanes[b].vecX()*dLength, lsBeam.ptMid() + .5*bmPlanes[b].vecX()*dLength);
			plAxis.vis(4);
			plBeamsAxis.append(plAxis);
		}
	}
	

	




// Distribution____________________________________________________________________________
// query other instances of this script attached to the same element
 	TslInst tslAttacheds[] = el.tslInst(); 
	for (int i=tslAttacheds.length()-1;i>=0;i--)
 		if (tslAttacheds[i].scriptName()!=scriptName())
	  		tslAttacheds.removeAt(i);
	//reportMessage ("\n" + tslAttacheds + "\n" + "(" + _ThisInst + ")");
// prevent execution, if another instance is already present
	if (tslAttacheds.length() > 1)	{eraseInstance(); return;}	


// get point of gravity
	Map mapIO; 
	Map mapEntities; 

	for (int e=0;e<bmAll.length();e++) 
	    mapEntities.appendEntity("Entity", bmAll[e]); 			
	Sheet sheets[]=el.sheet();
	for (int e=0;e<sheets.length();e++) 
	    mapEntities.appendEntity("Entity", sheets[e]);
	TslInst tsls[]=el.tslInst();
	for (int e=0;e<tsls.length();e++) 
	    mapEntities.appendEntity("Entity", tsls[e]);			

	mapIO.setMap("Entity[]",mapEntities); 
	String scriptNameIO = "hsbCenterOfGravity";
	int bOk = TslInst().callMapIO(scriptNameIO , mapIO); 
	if(!bOk)
	{
		reportNotice("\n******************** " + scriptName() + " ********************")	;
		reportNotice("\n" + T("|The calcualtion of the point of gravity has failed.|") + "\n" + 
		T("|Please ensure that the TSL|") + "\n\n" + scriptNameIO + "\n\n" +
		T("|is loaded into the dwg or is present in the standard\ntsl search path|") + "\n" + 
		T("|Tool will be deleted|"));
		reportNotice("\n*************************************************************")	;
		if(!bDebug)
		{
			eraseInstance();
			return;	
		}
		
	}
	ptGrav = mapIO.getPoint3d("ptCen");
	sWeight.set(round(mapIO.getDouble ("Weight")) + " kg");
	dWeight = round(mapIO.getDouble ("Weight"));
	
				
	ptGrav.vis(6);
	_Pt0 = ptGrav;
	
// declare initial distribution points
	PLine plModelLifts[0];	
	Body bdModelLifts[0];

	Point3d ptRef = ptGrav.projectPoint(pnTop, 0);
	ptRef.vis(30);	
	
	PLine plDistribution(vecZ);
	plDistribution.createCircle(ptRef, vecZ, dInterdistance);
	plDistribution.vis(1);
	
	Point3d ptTemps[0];
	Point3d ptDs[0];
	
	for (int p=0 ; p < plBeamsAxis.length() ; p++)
	    ptTemps.append(plDistribution.intersectPLine(plBeamsAxis[p]));
	    
	if (ptTemps.length() < nQuant)
	{
		reportMessage("\n" + T("|Not enough valid lifting points found|") + " --> " + T("|Tool will be deleted|"));
		dpErrorModel.draw("Error", _Pt0, vecX, vecY, 0,1);
		if (!bDebug) eraseInstance();
	}	

	
// find the best distribution
	double dBestDistribution = U(50000);
	double dBestArea;
	
	for (int p=0 ; p < ptTemps.length() ; p++)
	{
	    Point3d ptThis = ptTemps[p];
//	    ptThis.vis(p + 1);
	    Vector3d vecThis (ptThis - ptRef);
	    vecThis.normalize();

	    Point3d ptChecks[0];
	    
	    for (int i=0 ; i < nQuant-1 ; i++)
	    {
	        vecThis = vecThis.rotateBy(U(360)/nQuant, vecZ);
	        Line lnCheck (ptRef, vecThis);
	        Point3d ptInts[] = plDistribution.intersectPoints(lnCheck);
	        for (int j=0 ; j < ptInts.length() ; j++)
	        {
	            if (vecThis.dotProduct(ptInts[j] - ptRef) > dEps)
	            	ptChecks.append(ptInts[j]); 
	        }

	    }
	    
	    Point3d ptClosests[0];
	    double dDistAll;
	    for (int i=0 ; i < ptChecks.length() ; i++)
	    {
	    	double d = U(50000);
	    	Point3d ptClosest;
	    	
	    	for (int j=0 ; j < ptTemps.length() ; j++)
	    	{
	    	    double dDist = (ptTemps[j] - ptChecks[i]).length();
	    	    if (dDist < d)
	    	    { 
	    	    	d = dDist;
	    	    	ptClosest = ptTemps[j];
	    	    }
	    	}
	    	ptClosests.append(ptClosest);
	    	dDistAll = dDistAll + d;
	    }
	 
	// validate the distribution (only if the gravity point is inside the area between the lifting points)
		PlaneProfile ppValidArea (pnTop);
	    ppValidArea.joinRing(PLine(ptThis, ptClosests[0], ptClosests[1]), 0);
	    double dArea = ppValidArea.area();
	    ppValidArea.vis(3);
	    
//	    reportMessage("\n" + T("|dist|") + dDistAll);
	    
	    
	    if ((dDistAll < dBestDistribution || (dDistAll == dBestDistribution && dArea > dBestArea)) && ppValidArea.pointInProfile(ptRef) == 0)
	    { 
	    	dBestDistribution = dDistAll;
	    	dBestArea = dArea;
	    	ptDs.setLength(0);
	    	ptDs.append(ptThis);
	    	ptDs.append(ptClosests);
	    }
	    
	    
	}
	if (ptDs.length() < nQuant)
	{
		reportMessage("\n" + T("|Not enough valid lifting points found|") + " --> " + T("|Tool will be deleted|"));
		dpErrorModel.draw("Error", _Pt0, vecX, vecY, 0,1);
		if (!bDebug) eraseInstance();
	}
	
	for (int i=0; i<ptDs.length(); i++) ptDs[i].vis(30);
				
// determine the crane hook point
	Point3d ptHook = ptRef + vecZ * dBeltLength;

	double dH = sqrt(pow(dBeltLength, 2) - pow(dInterdistance, 2));
	ptHook = ptRef + vecZ * dH;

// End Distribution____________________________________________________________________________






// tooling ________________________________________________________________________________________	
int nReportWarning;
// loop over all lifting points	
	for (int i=0; i<ptDs.length(); i++)
	{	
		Point3d ptToolRef = ptDs[i];

	// find beams at the lifting points
		Body bdTool (ptToolRef, ptToolRef - vecZ * U(70), U(25));
		
		Beam bmTool;
		Beam bmTools[] = bdTool.filterGenBeamsIntersect(bmPlanes);
		if (bmTools.length() > 0)
			bmTool = bmTools[0];

		else
		{
			reportMessage("\n" + T("|No beams found at lifting points|") + " --> " + T("|Tool will be deleted|"));
			dpErrorModel.draw("Error", _Pt0, vecX, vecY, 0,1);
			if (!bDebug) eraseInstance();
		}				
		
	// determine tool standards
	// vectors for tools		
		Vector3d vecXT = bmTool.vecX();
		if (vecXT.dotProduct(vecX) < 0)
			vecXT = -vecXT;
		Vector3d vecZT = bmTool.vecD(vecZ);
		Vector3d vecYT = vecXT.crossProduct(vecZT);
		
		vecZT.vis(ptToolRef, 5);
		
		double dHeight = bmTool.dD(vecZT);
		double dWidth = bmTool.dD(vecYT);
		
	// case selection
		int nCase = -1;
		
		if (dHeight >= U(120))
		{ 
			if (dTopZonesThickness == 0)
			{ 
				if (dWidth >= U(120))
					nCase = 2;
				else if (dWidth >= U(100))
					nCase = 1;
				else if (dWidth >= U(80))
					nCase = 0;
				else
				{ 
					reportNotice("\n" + T("|Beam at lifting point is too small for SIHGA PICK lifting system|") + " --> " + T("|Tool will be deleted|"));
					if (!bDebug) eraseInstance();
					return;
				}
			}
			
			if (dTopZonesThickness <= U(22)+dEps)
			{ 
				if (dWidth >= U(100))
					nCase = 4;
				else if (dWidth >= U(80))
					nCase = 3;
				else
				{ 
					reportNotice("\n" + T("|Beam at lifting point is too small for SIHGA PICK lifting system|") + " --> " + T("|Tool will be deleted|"));
					if (!bDebug) eraseInstance();
					return;
				}
			}
			
			else
			{ 
				reportNotice("\n" + T("|Top sheeting zones' thickness is out of range (> 22mm)|") + " --> " + T("|Tool will be deleted|"));
				if (!bDebug) eraseInstance();
				return;
			}
		}

		else
		{ 
			reportNotice("\n" + T("|Beam at lifting point is too small for SIHGA PICK lifting system|") + " --> " + T("|Tool will be deleted|"));
			if (!bDebug) eraseInstance();
			return;
		}
			
			
	
	// determine the belt vector at this point
		double dBeltAngle = (ptDs[i] - ptHook).angleTo(-vecZT);
	
			
	// define the toolings
	// main drill (for the hanger)
	// tools
		Drill drMains[0];
		PLine plNoNailMain;
					
	// main drills (for the hanger loop)
		for (int j=0; j<2; j++)
		{
			Drill drMain (ptToolRef + vecZT*U(1000), ptToolRef - vecZT*U(80), .5*dDiamMain);
			drMains.append(drMain);
		}
	
	// add drills
		for (int j=0; j<drMains.length(); j++)
		{
			bmTool.addTool(drMains[j]);
			if (dTopZonesThickness > dEps)
				drMains[j].addMeToGenBeamsIntersect(el.sheet());
		}

	// weinmann tools (no nail areas and cnc drills)
		if (nWeinmannTools == 1)
		{ 
			plNoNailMain.addVertex(ptToolRef + vecXT * (.5*dDiamMain + U(10)) + vecYT * (.5*dDiamMain + U(10)));
			plNoNailMain.addVertex(ptToolRef + vecXT * (.5*dDiamMain + U(10)) - vecYT * (.5*dDiamMain + U(10)));
			plNoNailMain.addVertex(ptToolRef - vecXT * (.5*dDiamMain + U(10)) - vecYT * (.5*dDiamMain + U(10)));
			plNoNailMain.addVertex(ptToolRef - vecXT * (.5*dDiamMain + U(10)) + vecYT * (.5*dDiamMain + U(10)));
			plNoNailMain.close();
			//plNoNailMain.vis(2);
		
		// add no nail areas and drills
			int nCount;
			for (int j=1; j<6; j++)
			{
				if (el.zone(j).dH() > 0)
				{
					nCount = j;
					ElemNoNail ennMain (j, plNoNailMain);
					el.addTool(ennMain);			
				}
			}
			ElemDrill eld (nCount, ptToolRef + vecZT*dTopZonesThickness, -vecZT, dTopZonesThickness, dDiamMain, 0);
			el.addTool(eld);
		}
		
	//Display and load validation
	// create the lines, representing the lifting belts	
		PLine plDraw (ptDs[i], ptHook);
		plDraw.vis(5);
		plModelLifts.append(plDraw);
	
	// Body of the lifting device
		Body bdModelLift;
		bdModelLift = Body (ptDs[i], ptDs[i] - vecZT * U(68), U(25));
		bdModelLift = bdModelLift + Body (ptDs[i], ptDs[i] + vecZT * U(26), U(47));
		bdModelLift = bdModelLift + Body (ptDs[i] + vecZT * U(26), ptDs[i] + vecZT * U(45), U(33));
		bdModelLift = bdModelLift + Body (ptDs[i] + vecZT * U(45), ptDs[i] + vecZT * U(82), U(16));
		bdModelLifts.append(bdModelLift);
		bdModelLift.vis(3);
		
	// validate the load
		double dMaxLoads[0];
		dMaxLoads = dMaxLoadsCase0;
		if (nCase == 1)
			dMaxLoads = dMaxLoadsCase1;
		else if (nCase == 2)
			dMaxLoads = dMaxLoadsCase2;
		else if (nCase == 3)
			dMaxLoads = dMaxLoadsCase3;
		else if (nCase == 4)
			dMaxLoads = dMaxLoadsCase4;
		
		int nAngle;
		for (int k = 0; k < dBoundaryAngles.length(); k++)
		{
			double d = dBoundaryAngles[k];
			double e = dBeltAngle;
			
			if (dBeltAngle < dBoundaryAngles[k])
			{
				nAngle++;
				break;
			}

			else
				nAngle++;
		}
		double dAng = dBeltAngle;
		double dMaxLoad = dMaxLoads[nAngle]/2*nQuant;
		double dMaxRangeLoad = dMaxLoads[0]/2*nQuant;
		
		String sWarning;
		if (dWeight > dMaxRangeLoad)
		{ 
			sWarning = "   " + T("|The load is to heavy for|") + " " + nQuant + " " + T("|Lifting points|");
		}
		
		else if (dBeltAngle > dMaxAngle)
		{ 
			sWarning = "   " + T("|The lifting angle at this point is out of range|");
		}
		
		else if (dWeight > dMaxLoad)
		{ 
			sWarning = "   " + T("|The lifting angle at this point|") + " (" + dAng + "°) " + T("|is too flat to carry the load|" + "!!!");
		}
		
		if (sWarning.length() > 0)
		{ 
			dpErrorModel.textHeight(50);
			dpErrorModel.draw(sWarning, ptDs[i], vecX, vecY, 1, 0, _kDeviceX);
			dpErrorModel.draw("!!! " + T("|Attention|") + " !!!", _Pt0, vecX, vecY, 0, 0, _kDeviceX);
			dpErrorPlan.draw(sWarning, ptDs[i], -vecZ, vecX, 1, 0, _kDevice);
			nReportWarning++;
		}
	}
	
// warning message
	if (nReportWarning > 0)
	{
		reportNotice("\n" + T("|Element|") + " " + el.number() + " - " + T("|'SIHGA Pick Wall' TSL|") + "  -->  " + T("|Attention, the load is out of range for this lifting situation|") + "!!!");
		dpModel.color(1);
	}
	

// display
	for (int i=0; i<plModelLifts.length(); i++)
	{ 
		dpModel.draw(plModelLifts[i]);
		Point3d ptText = plModelLifts[i].ptMid();
		Vector3d vecText = plModelLifts[i].ptStart() - plModelLifts[i].ptEnd();
		Vector3d vecTextVert = vecText.crossProduct(vecZ);
		String sText;
		
		if (nReportWarning > 0)
			sText = "!!! " + T("|Attention|") + " !!!";
		else
			sText = "L=" + String().formatUnit(dBeltLength, _kLength) + "mm";
		
		dpModel.draw(sText, ptText, vecText, vecTextVert, 0, 1.3, _kDevice);
	}
	
	for (int i=0; i<plModelLifts.length(); i++)
		dpModel.draw(plModelLifts[i]);

	dpModel.color(253);
	for (int i=0; i<bdModelLifts.length(); i++)
		dpModel.draw(bdModelLifts[i]);
#End
#BeginThumbnail
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
$*`/_V0Q)
`



#End