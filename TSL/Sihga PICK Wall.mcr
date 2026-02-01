#Version 8
#BeginDescription
This TSL creates SIHGA PICK lifting devices in Stickframe Walls, referring to it's center of gravity.

version value="1.4" date="07nov17" author="florian.wuermseer@hsbcad.com">
situation 4 points with hanger chains added
lifting angle calculation at 4 points without traverse fixed
situation 4 points without traverse added, Belt lengths now displayed
bugfix distribution when wall length < distribution length
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 4
#KeyWords Lifting Device, Center of Gravity
#BeginContents
/// <summary Lang=en>
/// this TSL creates SIHGA PICK lifting devices in Stickframe Walls, referring to it's center of gravity.
/// </summary>

/// <insert Lang=en>
/// At least one Stickframe element is required. Multiple selection is possible.
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version value="1.4" date="07nov17" author="florian.wuermseer@hsbcad.com"> situation 4 points with hanger chains added</version>
/// <version value="1.3" date="28sep17" author="florian.wuermseer@hsbcad.com"> lifting angle calculation at 4 points without traverse fixed</version>
/// <version value="1.2" date="08sep17" author="florian.wuermseer@hsbcad.com"> situation 4 points without traverse added, Belt lengths now displayed</version>
/// <version value="1.1" date="30aug17" author="florian.wuermseer@hsbcad.com"> bugfix distribution when wall length < distribution length </version>
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
	double dMaxLoadsCase0[] = {1012, 939, 867, 794, 721, 649, 576, 503, 431, 358};
	double dMaxLoadsCase1[] = {1246, 1210, 1174, 1139, 1103, 1067, 1031, 996, 960, 924};
	double dMaxLoadsCase2[] = {1800, 1752, 1704, 1657, 1609, 1561, 1513, 1466, 1418, 1370};
	double dMaxLoadsCase3[] = {1320, 1278, 1236, 1194, 1152, 1110, 1068, 1026, 984, 942};
	double dMaxLoadsCase4[] = {1800, 1752, 1704, 1657, 1609, 1561, 1513, 1466, 1418, 1370};
	double dMaxLoadsCase5[] = {1320, 1280, 1239, 1199, 1158, 1118, 1077, 1037, 996, 956};
	double dMaxLoadsCase6[] = {1654, 1580, 1506, 1433, 1359, 1285, 1211, 1138, 1064, 990};
	double dMaxLoadsCase7[] = {1740, 1657, 1573, 1490, 1407, 1323, 1240, 1157, 1073, 990};
	
	
// drills' parameters	
	double dDiamMain = U(50);
	

// properties	
// distribution
	String sCatDist = T("|Distribution|");
	
	int nQuants[] = {1, 2, 4, 4, 4};
	String sQuants[] = { "1", "2", "4", "4 + Traverse", "4 + Hanger Chains"};
	String sQuantName = "(A) - " + T("|Quantity|");
	PropString sQuant (nStringIndex++, sQuants, sQuantName, 1);
	int nQuantIndex = sQuants.find(sQuant);
	int nQuant = nQuants[sQuants.find(sQuant)];
	sQuant.setCategory(sCatDist);
	
	String sBeltLengthName = "(B) - " + T("|Lifting Belt Length|");
	PropDouble dBeltLength (nDoubleIndex++, U(2000), sBeltLengthName);
	dBeltLength.setCategory(sCatDist);
	
	String sInterdistanceName = "(C) - " + T("|Interdistance of Lifting Points|");
	PropDouble dInterdistance (nDoubleIndex++, U(1000), sInterdistanceName);
	dInterdistance.setCategory(sCatDist);
	
	String sChainTravLengthName = "(D) - " + T("|Chain / Traverse Length|");
	PropDouble dChainTravLength (nDoubleIndex++, U(2000), sChainTravLengthName);
	dChainTravLength.setCategory(sCatDist);

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
	String sWeinmannToolsName = "(E) - " + T("|Apply Weinmann Tools|");
	PropString sWeinmannTools (nStringIndex++, sYesNo, sWeinmannToolsName);
	sWeinmannTools.setCategory(sCatTooling);
	int nWeinmannTools = sYesNo.find(sWeinmannTools);
	




	
// on insert __________________________________________________________________________________________________
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
			showDialog();

	// declare the tsl props
		TslInst tslNew;
		Vector3d vecUcsX = _XW;
		Vector3d vecUcsY = _YW;
		GenBeam gbs[0];
		Entity ents[1];
		Point3d pts[0];
		int nProps[0];
		double dProps[] = {dBeltLength, dInterdistance, dChainTravLength};
		String sProps[] = {sQuant, sWeinmannTools};
		Map mapTsl;
		String sScriptname = scriptName();	
				
	// selection set
		Entity entsSet[0];
		PrEntity ssE(T("|Select wall(s)|"), ElementWallSF());	
		if (ssE.go())
			entsSet= ssE.set();

	// insert per wall
		if (bDebug)reportMessage("\n" + entsSet.length() + " " + T("|Wall(s) selected|"));
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

	if (!_Element[0].bIsKindOf(ElementWallSF()))
	{
		if (bDebug)reportMessage("\nno wall element");
		eraseInstance();
		return;	
	}
	
	ElementWallSF elWall = (ElementWallSF)_Element[0];

// assigning
	assignToElementGroup(elWall, true, 0, 'I');	
	
	Vector3d vecX = elWall.vecX();
	Vector3d vecY = elWall.vecY();
	Vector3d vecZ = elWall.vecZ();
	Point3d ptOrg = elWall.ptOrg();
	Point3d ptGrav;
	Line lnVert (_Pt0, - vecY);
	//_Pt0 = elWall.ptOrg();
	
	vecX.vis(elWall.ptOrg(),1);
	vecY.vis(elWall.ptOrg(),3);
	vecZ.vis(elWall.ptOrg(),5);

	int nGetDrill = 0;
	int nGetDrillL = 0;
	int nGetDrillR = 0;
	
// precalculation of the maximum distance of the extreme distribution points
	PLine plEllipsoid (vecZ);
	double dMaxRange = dInterdistance;
	double dHalfBelt = dBeltLength / 2;
	
	if (nQuantIndex >= 2)
	{
		PLine plBelt(vecZ);
		PLine plChain(vecZ);
		
		Point3d ptCraneHook;
		double dHalfDist = dInterdistance / 2;
		for (int i=-dHalfBelt; i < dHalfBelt+1 ; i++)
		{
		    double x = i;
		 	double y = (sqrt(pow(dHalfBelt, 2) - pow(dHalfDist, 2)) / dHalfBelt) * sqrt(pow(dHalfBelt, 2) - pow(x, 2));
		    plEllipsoid.addVertex(_Pt0 + vecX * x + vecY *y);
		}
		plEllipsoid.vis(6);
		
		Plane pn45Deg (_Pt0 - vecX * dHalfDist, vecX - vecY);
		Point3d pts[] = plEllipsoid.intersectPoints(pn45Deg);
		if (pts.length() > 0)
		{
			Vector3d vecChainTrav = vecX;
			double dRelevantLength = 0; 

			if (nQuantIndex == 3)
			{
				vecChainTrav = vecX;
				dRelevantLength = dChainTravLength / 2;
			}
			
			else if (nQuantIndex == 4)
			{
				vecChainTrav = (pts[0] - (_Pt0 - vecX * dHalfDist)) + (pts[0] - (_Pt0 + vecX * dHalfDist));
				dRelevantLength = dChainTravLength;
			}
			
			vecChainTrav.normalize();
			ptCraneHook = pts[0] + vecChainTrav * dRelevantLength;
			ptCraneHook.vis(6);
			
			dMaxRange = abs(vecX.dotProduct(ptCraneHook - (_Pt0 - vecX * dHalfDist)));
			
			plBelt.addVertex(_Pt0 - vecX * dHalfDist);
			plBelt.addVertex(pts[0]);
			plBelt.addVertex(_Pt0 + vecX * dHalfDist);
			plChain.addVertex(pts[0]);
			plChain.addVertex(ptCraneHook);
			
			plBelt.vis(4);
			plChain.vis(4);
		}
	}
		
		
// declare important beams	
	Beam bmAll[]=elWall.beam();
// remove dummy beams
	for (int i=bmAll.length()-1; i>=0; i--)
	{
		if (bmAll[i].bIsDummy() == TRUE)
		 	bmAll.removeAt(i);
	}
	
// vertical beams
	Beam bmVerts[] = vecX.filterBeamsPerpendicularSort(bmAll);
	if (bmVerts.length()<1)
		return;	

// not vertical beams
	Beam bmNotVerts[0];
	bmNotVerts = bmAll;
	
	for (int i=bmNotVerts.length()-1; i>=0; i--)
		if (bmNotVerts[i].vecX().isParallelTo(vecY))
				bmNotVerts.removeAt(i);
				
//	for (int i=bmAll.length()-1; i>=0; i--)
//		bmAll[i].envelopeBody().vis(2);

	
// detect contour
	Plane pnZ0 (elWall.ptOrg(), vecZ);
	Plane pnCen (elWall.ptOrg() - vecZ * .5*elWall.dBeamWidth(), vecZ);
	
	pnCen.vis(3);

	PLine plEnv = elWall.plEnvelope();
	PlaneProfile ppEnv;
	
	// get envelope contour of zone 0
	if (bmAll.length()>0)
	{
		for (int b=0;b<bmAll.length();b++)
		{
			Body bd = bmAll[b].envelopeBody(1,1);
			//if (t==0) bd = bmAll[b].realBody();
			//if (t==1) bd = bmAll[b].envelopeBody();
			
			PlaneProfile ppBm = bd.shadowProfile(pnCen);
//			ppBm.vis(3);
			ppBm.shrink(-dEps);
			if (ppEnv.area()<pow(dEps,2))
				ppEnv = ppBm;
			else
				ppEnv.unionWith(ppBm);
		}
		

	// get biggest ring
		PLine plRings[]=ppEnv.allRings();
		int bIsOp[]=ppEnv.ringIsOpening();
		plEnv = PLine();
		int nVoids;
		for (int r=0;r<plRings.length();r++)
		{
			PlaneProfile ppTemp (plRings[r]);
			ppTemp.shrink(dEps);
			PLine plTemps[] = ppTemp.allRings();
			//plRings[r].vis(r);
			if (plTemps[0].area()>plEnv.area() && !bIsOp[r])
			{
				plEnv = plTemps[0];
			}
		}
	}
// fall back to enevlope if shadow collection has failed	
	if (plEnv.area()<pow(dEps,2))
		plEnv = elWall.plEnvelope();
		

// project to center
	plEnv.transformBy(-vecZ*vecZ.dotProduct(plEnv.ptStart()-(ptOrg-vecZ*.5*elWall.dBeamWidth())));
	plEnv.vis(6);	
	
	PlaneProfile ppWall (plEnv);


// display
	Display dpErrorModel (1);
	dpErrorModel.addHideDirection(_ZW);	

	Display dpErrorPlan (1);
	dpErrorPlan.addViewDirection(_ZW);
	
	Display dpPlan(7);
	dpPlan.addViewDirection(_ZW);
	
	Display dpModel(7);
//	dpModel.addHideDirection(_ZW);
	
	PLine plModelLifts[0];
	PLine plModelTraverse[0];	
	Body bdModelLifts[0];



// DistributionMode____________________________________________________________________________
// query other instances of this script attached to the same element
 	TslInst tslAttacheds[] = elWall.tslInst(); 
	for (int i=tslAttacheds.length()-1;i>=0;i--)
 		if (tslAttacheds[i].scriptName()!=scriptName())
	  		tslAttacheds.removeAt(i);

	//reportMessage ("\n" + tslAttacheds + "\n" + "(" + _ThisInst + ")");

	if (tslAttacheds.length() > 1)	{eraseInstance(); return;}		
	
	
// get point of gravity
	Map mapIO; 
	Map mapEntities; 

	for (int e=0;e<bmAll.length();e++) 
	    mapEntities.appendEntity("Entity", bmAll[e]); 			
	Sheet sheets[]=elWall.sheet();
	for (int e=0;e<sheets.length();e++) 
	    mapEntities.appendEntity("Entity", sheets[e]);
	TslInst tsls[]=elWall.tslInst();
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
	
// validate maximum distance
	LineSeg ls = ppWall.extentInDir(vecX);
	double dLengthWall = vecX.dotProduct(ls.ptEnd()-ls.ptStart());
	Point3d ptWallMid = (ls.ptEnd()+ls.ptStart())/2;
	ptWallMid.vis(2);
	double dOffset = abs(vecX.dotProduct(ptGrav - ptWallMid));
	
	if (2*dMaxRange > (dLengthWall-2*dOffset) - U(500) + dEps)
		dMaxRange = (dLengthWall - 2 * dOffset - U(500))/2;
//	
// declare initial distribution points
	Point3d ptRef = ptGrav.projectPoint(pnCen, 0);
	ptRef.vis(30);	
	
	Point3d ptDs[0];

	if (nQuant == 1)
		ptDs.append(ptRef);
		
	else if (nQuant > 1 && nQuantIndex <= 2)
	{
		if ((nQuant-1)*dInterdistance > 2*dMaxRange + dEps)
		{ 
			dInterdistance.set((2*dMaxRange) / (nQuant - 1));
			nForceRecalc = 1;
		}
			
		ptDs.append(ptRef - vecX * .5 * (nQuant-1) * dInterdistance);
		
		for (int i=0; i<nQuant-1; i++)
			ptDs.append(ptDs[i] + vecX * dInterdistance);
	}
	
	else if (nQuant > 3 && nQuantIndex == 3) // traverse
	{	
		double dRange = dChainTravLength;
		if (dChainTravLength/2 > dMaxRange - dInterdistance + dEps)
		{
			dRange = 2*dMaxRange - dInterdistance;
			nForceRecalc = 1;
		}
		ptDs.append(ptRef - vecX * .5 * (dRange + dInterdistance));
		ptDs.append(ptRef - vecX * .5 * (dRange - dInterdistance));
		ptDs.append(ptRef + vecX * .5 * (dRange + dInterdistance));
		ptDs.append(ptRef + vecX * .5 * (dRange - dInterdistance));
	}
	
	else if (nQuant > 3 && nQuantIndex == 4) // chain
	{
		ptDs.append(ptRef - vecX * .5 * (dMaxRange + dInterdistance));
		ptDs.append(ptRef - vecX * .5 * (dMaxRange - dInterdistance));
		ptDs.append(ptRef + vecX * .5 * (dMaxRange + dInterdistance));
		ptDs.append(ptRef + vecX * .5 * (dMaxRange - dInterdistance));
	}
		
	for (int i=0; i<ptDs.length(); i++) ptDs[i].vis(30);



// get the plate beams over the distrbution points	
	Beam bmPlates[0];

	for (int i=0; i<ptDs.length(); i++)
	{
		Point3d pt;
		Point3d ptInts[] = plEnv.intersectPoints(Plane(ptDs[i],vecX));
			ptInts=Line(ptDs[i],-vecY).orderPoints(ptInts);
		if (ptInts.length() > 0)
			pt=ptInts[0];
		else
		{ 
//			eraseInstance();
			return;
		}


		Beam bmIntersects[] = Beam().filterBeamsHalfLineIntersectSort(bmNotVerts, pt, -vecY);
		if (bmIntersects.length() > 0)
		{
			if (bmPlates.find(bmIntersects[0])==-1)
				bmPlates.append(bmIntersects[0]);
			if (bDebug) for (int j=0; j<bmPlates.length(); j++) bmPlates[j].envelopeBody().vis(2);
		}
	}

// add detail plate beams to potential plates array	
	for (int i=0; i<bmNotVerts.length(); i++)
		if (bmNotVerts[i].hsbId() == "4" || bmNotVerts[i].hsbId() == "3" || bmNotVerts[i].hsbId() == "5")
			bmPlates.append(bmNotVerts[i]);

	
// get the area, where distribution can be made = projection of the plate beam(s)
	Plane pnProject (ptOrg, vecY);

	PlaneProfile ppDist;
	for (int i=0; i<bmPlates.length(); i++)
		ppDist.unionWith(bmPlates[i].envelopeBody().shadowProfile(pnProject));
		
	ppDist.transformBy(vecY*U(-400));
	if(bDebug) ppDist.vis(30);
	
// subtract minimum enddistance from distribution area (250mm from the plate ends)
	LineSeg lsDist = ppDist.extentInDir(vecX);
	int nDir = -1;
	for (int i = 0; i < 2; i++)
	{
		Point3d ptThis = lsDist.ptStart();
		if (i == 1)
			ptThis = lsDist.ptEnd();
			
		ptThis = ptThis - nDir * vecX * U(250);
		
		PLine plDiff;
		plDiff.addVertex(ptThis + vecZ * U(5000));
		plDiff.addVertex(ptThis - vecZ * U(5000));
		plDiff.addVertex(ptThis - vecZ * U(5000) + nDir * vecX * U(20000));
		plDiff.addVertex(ptThis + vecZ * U(5000) + nDir * vecX * U(20000));
		plDiff.close();
		
		plDiff.vis(5);
		
		ppDist.joinRing(plDiff, 1);
		nDir *= -1;
	}

// subtract the area outside the outmost studs from the distribution area
// get outmost beams
	Beam bmOutmosts[0];
	bmOutmosts.append(bmVerts[0]);
	bmOutmosts.append(bmVerts[bmVerts.length()-1]);
	
// create pline to subtract from distribution area	
	nDir = -1;
	for (int i=0; i<bmOutmosts.length(); i++)
	{
		Point3d ptBeam (bmOutmosts[i].ptCen());
		PLine plDiff;
		ptBeam.transformBy(-vecX * nDir * .5 * bmOutmosts[i].dD(vecX));
		plDiff.addVertex(ptBeam + vecZ * U(5000));
		plDiff.addVertex(ptBeam - vecZ * U(5000));
		plDiff.addVertex(ptBeam - vecZ * U(5000) + nDir * vecX * U(20000));
		plDiff.addVertex(ptBeam + vecZ * U(5000) + nDir * vecX * U(20000));
		plDiff.close();
		
		plDiff.vis(5);
		
		ppDist.joinRing(plDiff, 1);
		nDir = nDir*-1;
	}

	ppDist.transformBy(-vecY * U(200));
//	ppDist.shrink(dEps);
	if (bDebug) ppDist.vis(3);
	
// validate maximum distance
	LineSeg lsMaxDist = ppDist.extentInDir(vecX);
	lsMaxDist.vis(2);
	
	double dMaxDist = 2*abs(vecX.dotProduct(ptGrav-lsMaxDist.ptStart()));
	if (abs(vecX.dotProduct(ptGrav-lsMaxDist.ptEnd())) < dMaxDist)
		dMaxDist = 2*abs(vecX.dotProduct(ptGrav-lsMaxDist.ptEnd()));
	
	if ((nQuant - 1) * dInterdistance > dMaxDist)
	{
		dInterdistance.set(dMaxDist / (nQuant - 1));
		nForceRecalc = 1;
	}
	
	
// query if distribution points are possible (in the Distrib-Area)
	for (int i=0; i<ptDs.length(); i++)
	{
		if(ppDist.pointInProfile(ptDs[i]) == 1)
		{
			Point3d ptClose (ppDist.closestPointTo(ptDs[i]));
			ptClose.setZ(ptDs[i].Z());
			ptDs[i] = ptClose;
		}
	}
	
	if (bDebug) for (int i=0; i<ptDs.length(); i++)	ptDs[i].vis(1);
	
			
// if quantity or interdistance were changed, completely restart distribution
	if (_bOnDbCreated || _kNameLastChangedProp == sQuantName || _kNameLastChangedProp == sInterdistanceName || _kNameLastChangedProp == sChainTravLengthName || nForceRecalc)	
	{
		_PtG.setLength(0);
		for (int i=0;i<ptDs.length();i++)
		{
			Point3d ptInt[] = plEnv.intersectPoints(Plane(ptDs[i],vecX));
			ptInt=Line(ptDs[i],-vecY).orderPoints(ptInt);
			if (ptInt.length()>0) ptDs[i]=ptInt[0];
			
			_PtG.append(ptDs[i]);
			
			if (bDebug) ptDs[i].vis(2);
			
			if (!_bOnDbCreated)
				setExecutionLoops(2);		
		}
	}


// if grips have been moved...
	if (_kNameLastChangedProp.find("PtG",0))
	{
	
	// snap grip to nearest possible point if outside distribution area
		for (int i=0; i<_PtG.length(); i++)
		{
			if(ppDist.pointInProfile(_PtG[i]) == 1)
			{
				Point3d ptClose (ppDist.closestPointTo(_PtG[i]));
				ptClose.setZ(_PtG[i].Z());
				_PtG[i] = ptClose;
			}
		
		// project grip to center of Z0 and to top point of the plate beam		
			_PtG[i] = _PtG[i].projectPoint(pnCen,0);
			Point3d ptInt[] = plEnv.intersectPoints(Plane(_PtG[i],vecX));
			ptInt=Line(_PtG[i],-vecY).orderPoints(ptInt);
			if (ptInt.length()>0)
				_PtG[i]=ptInt[0];
		}
	}	
	
	
// validate the lifting belt length
	Point3d ptLift1 = _PtG[0] + vecY * dBeltLength;
	Point3d ptLift2 = _PtG[0] + vecY * dBeltLength;
	PLine plEllipsoids[0];
	
	if (_PtG.length() > 1 && _PtG.length() < 3)
	{ 
		for (int i = 0; i < _PtG.length(); i++)
		{
			if (i==0)
				continue;
			
			Plane pnLift (_PtG[i], (_PtG[i] - _PtG[i - 1]).crossProduct(vecZ));
			Vector3d vecLift = vecZ.crossProduct((_PtG[i] - _PtG[i - 1]));
			if (vecY.dotProduct(vecLift) < 0)
				vecLift = vecZ.crossProduct((_PtG[i - 1] - _PtG[i]));
			
			vecLift.normalize();
			double dDist = (_PtG[i] - _PtG[i - 1]).length();
			
			Point3d ptLiftRef = (_PtG[i] + _PtG[i - 1]) / 2;
			
			PLine plLift1 (vecZ);
			PLine plLift2 (vecZ);
			
			double dH = .5 * sqrt(4 * pow(dBeltLength, 2) - pow(dDist, 2));
			ptLift1 = ptLiftRef + vecLift * dH;
		}
	}
	
	
	
	else if (_PtG.length() == 4)
	{
		for (int i = 0; i < _PtG.length(); i++)
		{
			if (i == 0 || i == 2)
				continue;
			Vector3d vecPointsX = (_PtG[i] - _PtG[i - 1]);
			double dPointDist = vecPointsX.length();
			vecPointsX.normalize();
			Vector3d vecPointsY = vecPointsX.crossProduct(vecZ);
			
			Plane pnLift (_PtG[i], (_PtG[i] - _PtG[i - 1]).crossProduct(vecZ));
			Point3d ptLiftRef = (_PtG[i] + _PtG[i - 1]) / 2;
//			ptLiftRef.vis(3);
			PLine plEllLift(vecZ);
			
			for (int i = - dHalfBelt; i < dHalfBelt + 10; i = i + 10)
			{
				double x = i;
				double y = (sqrt(pow(dHalfBelt, 2) - pow(dPointDist / 2, 2)) / dHalfBelt) * sqrt(pow(dHalfBelt, 2) - pow(x, 2));
				if (vecX.dotProduct(vecPointsX) < 0)
					plEllLift.addVertex(ptLiftRef + vecPointsX * x + vecPointsY * y);
				else
					plEllLift.addVertex(ptLiftRef + vecPointsX * x - vecPointsY * y);
			}
			plEllLift.vis(6);
			plEllipsoids.append(plEllLift);
		}
		
		if (bDebug)
			for (int i = 0; i < plEllipsoids.length(); i++)
				plEllipsoids[i].vis(i + 1);
		
		if (nQuantIndex == 2)
		{
			Point3d ptLifts[] = plEllipsoids[0].intersectPLine(plEllipsoids[plEllipsoids.length() - 1]);
			ptLifts = lnVert.orderPoints(ptLifts);
			ptLift1 = ptLifts[0];
			ptLift2 = ptLifts[0];
		}
		
		if (nQuantIndex == 3)
		{
			ptLift1 = (ptGrav - vecX*.5*dChainTravLength);
			ptLift2 = (ptGrav + vecX*.5*dChainTravLength);
			Vector3d vecPointsX1 = (_PtG[1] - _PtG[0]);	vecPointsX1.normalize();
			Vector3d vecPointsX2 = (_PtG[3] - _PtG[2]);	vecPointsX2.normalize();
			Vector3d vecPointsY1 = vecPointsX1.crossProduct(vecZ);
			if (_ZW.dotProduct(vecPointsY1) < 0)
				vecPointsY1 = - vecPointsY1;
			Vector3d vecPointsY2 = vecPointsX2.crossProduct(vecZ);
			if (_ZW.dotProduct(vecPointsY2) < 0)
				vecPointsY2 = - vecPointsY2;
			
			double dLiftX1 = vecPointsX1.dotProduct(ptLift1 - (_PtG[0] + _PtG[1]) / 2);
			double dLiftX2 = vecPointsX2.dotProduct(ptLift2 - (_PtG[2] + _PtG[3]) / 2);
			double dLiftY1 = abs(sqrt(pow(dHalfBelt, 2) - pow((_PtG[1] - _PtG[0]).length() / 2, 2)) / dHalfBelt) * sqrt(pow(dHalfBelt, 2) - pow(dLiftX1, 2));
			double dLiftY2 = abs(sqrt(pow(dHalfBelt, 2) - pow((_PtG[2] - _PtG[3]).length() / 2, 2)) / dHalfBelt) * sqrt(pow(dHalfBelt, 2) - pow(dLiftX2, 2));
			ptLift1 = (_PtG[0] + _PtG[1]) / 2 + vecPointsX1 * dLiftX1 + vecPointsY1 * dLiftY1;
			ptLift2 = (_PtG[2] + _PtG[3]) / 2 + vecPointsX2 * dLiftX2 + vecPointsY2 * dLiftY2;
		}
				
				
		if (nQuantIndex == 4)
		{
			PLine pl ((_PtG[0] + _PtG[1]) / 2, (_PtG[2] + _PtG[3]) / 2);
			Point3d ptLiftRefs[] = pl.intersectPoints(Plane (ptRef, vecX));
			double dH = dChainTravLength + dBeltLength / 2;
			Point3d ptHook = ptLiftRefs[0] + vecY * dH;
			ptHook.vis(14);
			
			
			PLine plCircle;
			Point3d ptLifts1[0];
			Point3d ptLifts2[0];
			int c;
			while (ptLifts1.length() < 1 || ptLifts2.length() < 1 && c < 1 + dChainTravLength + dBeltLength / 2)
			{
				double dH = dChainTravLength + dBeltLength / 2;
				ptHook = ptHook - vecY * 100;
				plCircle.createCircle(ptHook, vecZ, dChainTravLength);
				ptLifts1 = plCircle.intersectPLine(plEllipsoids[0]);
				if (ptLifts1.length() < 1)
					continue;
				
				ptLifts2 = plCircle.intersectPLine(plEllipsoids[1]);
				c++;
			}
			
			ptLift1 = (ptLifts1[0] + ptLifts1[ptLifts1.length() - 1]) / 2;
			ptLift2 = (ptLifts2[0] + ptLifts2[ptLifts2.length() - 1]) / 2;
			Vector3d vecPointsX1 = (_PtG[1] - _PtG[0]);	vecPointsX1.normalize();
			Vector3d vecPointsX2 = (_PtG[3] - _PtG[2]);	vecPointsX2.normalize();
			Vector3d vecPointsY1 = vecPointsX1.crossProduct(vecZ);
			if (_ZW.dotProduct(vecPointsY1) < 0)
				vecPointsY1 = - vecPointsY1;
			Vector3d vecPointsY2 = vecPointsX2.crossProduct(vecZ);
			if (_ZW.dotProduct(vecPointsY2) < 0)
				vecPointsY2 = - vecPointsY2;
			
			double dLiftX1 = vecPointsX1.dotProduct(ptLift1 - (_PtG[0] + _PtG[1]) / 2);
			double dLiftX2 = vecPointsX2.dotProduct(ptLift2 - (_PtG[2] + _PtG[3]) / 2);
			double dLiftY1 = abs(sqrt(pow(dHalfBelt, 2) - pow((_PtG[1] - _PtG[0]).length() / 2, 2)) / dHalfBelt) * sqrt(pow(dHalfBelt, 2) - pow(dLiftX1, 2));
			double dLiftY2 = abs(sqrt(pow(dHalfBelt, 2) - pow((_PtG[2] - _PtG[3]).length() / 2, 2)) / dHalfBelt) * sqrt(pow(dHalfBelt, 2) - pow(dLiftX2, 2));
			ptLift1 = (_PtG[0] + _PtG[1]) / 2 + vecPointsX1 * dLiftX1 + vecPointsY1 * dLiftY1;
			ptLift2 = (_PtG[2] + _PtG[3]) / 2 + vecPointsX2 * dLiftX2 + vecPointsY2 * dLiftY2;
		}
	}

// generate the linework, that represents the belts, chains	and traverses
	for (int i = 0; i < _PtG.length(); i++)
	{
		if (i <= 1)
		{ 
			PLine plDraw (_PtG[i], ptLift1);
			plDraw.vis(5);
			plModelLifts.append(plDraw);
			
		}
		
		if (i > 1 && nQuantIndex < 4)
		{ 
			PLine plDraw (_PtG[i], ptLift2);
			plDraw.vis(5);
			plModelLifts.append(plDraw);
			
			PLine plConnect (ptLift1, ptLift2);
			plConnect.vis(1);
			plModelTraverse.append(plConnect);
		}
		
		else if (i > 1 && nQuantIndex == 4)
		{ 
			PLine plDraw (_PtG[i], ptLift2);
			plDraw.vis(5);
			plModelLifts.append(plDraw);
			
			PLine plCircle1;
			plCircle1.createCircle(ptLift1, vecZ, dChainTravLength);
			PLine plCircle2;
			plCircle2.createCircle(ptLift2, vecZ, dChainTravLength);
			Point3d ptIntersectCircles[] = plCircle1.intersectPLine(plCircle2);
			
			lnVert.orderPoints(ptIntersectCircles);
			plModelTraverse.append(PLine (ptLift1, ptIntersectCircles[0]));
			plModelTraverse.append(PLine (ptLift2, ptIntersectCircles[0]));
		}
	}

// End DistributionMode____________________________________________________________________________

		
// tooling ________________________________________________________________________________________
	int nReportWarning;
	
// loop over all lifting points	
	for (int i=0; i<_PtG.length(); i++)
	{	
		Point3d ptToolRef = _PtG[i];

	// get plate beams for each lifting point
	// front one (10mm inside zone 1)	
		Beam bmToolPlate;
		Beam bmHeadPlates[] = Beam().filterBeamsHalfLineIntersectSort(bmNotVerts, ptToolRef, -vecY);
		if (bmHeadPlates.length() > 0)
			bmToolPlate = bmHeadPlates[0];

		else
		{
			reportMessage("\n" + T("|No top beams found|") + T("|Tool will be deleted|"));
			dpErrorModel.draw("Error", _Pt0, vecX, vecY, 0,1);
			if (!bDebug) eraseInstance();
		}				
		
	// determine tool standards
	// vectors for tools		
		Vector3d vecXT = bmToolPlate.vecX();
		if (vecXT.dotProduct(vecX) < 0)
			vecXT = -vecXT;
		Vector3d vecYT = bmToolPlate.vecD(_ZW);
		Vector3d vecZT = vecYT.crossProduct(vecXT);
		
		double dHeight = bmToolPlate.dD(vecY);
		double dWidth = bmToolPlate.dD(vecZ);
		
	// case selection
		int nCase = -1;
		if (dHeight >= U(100))
		{ 
			if (dWidth >= U(120))
				nCase = 7;
			else if (dWidth >= U(100))
				nCase = 6;
			else if (dWidth >= U(80))
				nCase = 5;
			else
			{ 
				reportNotice("\n" + T("|Top plate is too small for SIHGA PICK lifting system|") + " --> " + T("|Tool will be deleted|"));
				eraseInstance();
				return;
			}
		}
		else if (dHeight >= U(80))
		{ 
			if (dWidth >= U(140))
				nCase = 4;
			else if (dWidth >= U(100))
				nCase = 3;
			else if (dWidth >= U(80))
				nCase = 0;  //this case is defined for 60mm height of beams, but it can be applied at 80mm beam height, as well
			else
			{ 
				reportNotice("\n" + T("|Top plate is too small for SIHGA PICK lifting system|") + " --> " + T("|Tool will be deleted|"));
				eraseInstance();
				return;
			}
		}
		else if (dHeight >= U(60))
		{ 
			if (dWidth >= U(140))
				nCase = 2;
			else if (dWidth >= U(100))
				nCase = 1;
			else if (dWidth >= U(80))
				nCase = 0;
			else
			{ 
				reportNotice("\n" + T("|Top plate is too small for SIHGA PICK lifting system|") + " --> " + T("|Tool will be deleted|"));
				eraseInstance();
				return;
			}
		}
		else
		{ 
			reportNotice("\n" + T("|Top plate is too small for SIHGA PICK lifting system|") + " --> " + T("|Tool will be deleted|"));
			eraseInstance();
			return;
		}
			
			
	
	// determine the belt vector at this point
		double dBeltAngle = (_PtG[i] - ptLift1).angleTo(-vecYT);
		if (i > 1)
			dBeltAngle = (_PtG[i] - ptLift2).angleTo(-vecYT);
		
			
	// define the toolings
		Drill drMains[0];
		PLine plNoNailMain;
					
	// main drills
		for (int j=0; j<2; j++)
		{
			Drill drMain (ptToolRef + vecYT*U(1000), ptToolRef - vecYT*U(1000), .5*dDiamMain);
			drMains.append(drMain);
		}
		
	// add drills
		for (int j=0; j<drMains.length(); j++)
			bmToolPlate.addTool(drMains[j]);
							
	// no nail areas
		if (nWeinmannTools == 1)
		{
			plNoNailMain.addVertex(ptToolRef + vecXT * .5*dDiamMain);
			plNoNailMain.addVertex(ptToolRef + vecXT * .5*dDiamMain - vecYT * bmToolPlate.dW());
			plNoNailMain.addVertex(ptToolRef - vecXT * .5*dDiamMain - vecYT * bmToolPlate.dW());
			plNoNailMain.addVertex(ptToolRef - vecXT * .5*dDiamMain);
			plNoNailMain.close();

		// add no nail areas	
			nDir = 1;
			for (int j=0; j<2; j++)
			{
				if (elWall.zone(nDir).dH() > 0)
				{
					ElemNoNail ennMain (nDir, plNoNailMain);
					elWall.addTool(ennMain);		
				}
				nDir *= -1;
			}
		}
		
	//Display and load validation
		Body bdModelLift;
		
		bdModelLift = Body (_PtG[i], _PtG[i] - vecYT * U(68), U(25));
		bdModelLift = bdModelLift + Body (_PtG[i], _PtG[i] + vecYT * U(26), U(47));
		bdModelLift = bdModelLift + Body (_PtG[i] + vecYT * U(26), _PtG[i] + vecYT * U(45), U(33));
		bdModelLift = bdModelLift + Body (_PtG[i] + vecYT * U(45), _PtG[i] + vecYT * U(82), U(16));
		bdModelLifts.append(bdModelLift);
		bdModelLift.vis(3);
		
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
		else if (nCase == 5)
			dMaxLoads = dMaxLoadsCase5;
		else if (nCase == 6)
			dMaxLoads = dMaxLoadsCase6;
		else if (nCase == 7)
			dMaxLoads = dMaxLoadsCase7;
		
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
		
		else if (dBeltAngle > dMaxAngle + dEps)
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
			dpErrorModel.draw(sWarning, _PtG[i], vecX, vecY, 1, 0, _kDeviceX);
			dpErrorModel.draw("!!! " + T("|Attention|") + " !!!", _Pt0, vecX, vecY, 0, 0, _kDeviceX);
			dpErrorPlan.draw(sWarning, _PtG[i], -vecZ, vecX, 1, 0, _kDevice);
			nReportWarning++;
		}
	}
	
// warning message
	if (nReportWarning > 0)
	{
		reportNotice("\n" + T("|Element|") + " " + elWall.number() + " - " + T("|'SIHGA Pick Wall' TSL|") + "  -->  " + T("|Attention, the load is out of range for this lifting situation|") + "!!!");
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
		else if (plModelLifts.length()>2 && i < 2)
			sText = T("|Continuous belt|") + " 1  L=" + String().formatUnit(dBeltLength, _kLength) + "mm";
		else if (plModelLifts.length()>2 && i >= 2)
			sText = T("|Continuous belt|") + " 2  L=" + String().formatUnit(dBeltLength, _kLength) + "mm";
		else
			sText = "L=" + String().formatUnit(dBeltLength, _kLength) + "mm";
		
		dpModel.draw(sText, ptText, vecText, vecTextVert, 0, 1.3, _kDevice);
	}
	
	dpModel.color(5);
	for (int i=0; i<plModelTraverse.length(); i++)
	{ 
		dpModel.draw(plModelTraverse[i]);
		if (plModelTraverse[i].length() < dEps)
			continue;
		Point3d ptText = plModelTraverse[i].ptMid();
		Vector3d vecText = plModelTraverse[i].ptStart() - plModelTraverse[i].ptEnd();
		Vector3d vecTextVert = vecText.crossProduct(vecZ);
		String sText;
		
		if (nReportWarning > 0)
			sText = "!!! " + T("|Attention|") + " !!!";
		else if (nQuantIndex == 3)
			sText = T("|Traverse|") + "  L=" + String().formatUnit(dChainTravLength, _kLength) + "mm";
		else if (nQuantIndex == 4)
			sText = T("|Hanger Chain|") + "  L=" + String().formatUnit(dChainTravLength, _kLength) + "mm";
		if (sText.length() > 0)
			dpModel.draw(sText, ptText, vecText, vecTextVert, 0, 1.3, _kDevice);
	}	
		
		

	dpModel.color(253);
	for (int i=0; i<bdModelLifts.length(); i++)
		dpModel.draw(bdModelLifts[i]);


		
#End
#BeginThumbnail
M_]C_X``02D9)1@`!`0$`8`!@``#_VP!#``@&!@<&!0@'!P<)"0@*#!0-#`L+
M#!D2$P\4'1H?'AT:'!P@)"XG("(L(QP<*#<I+#`Q-#0T'R<Y/3@R/"XS-#+_
MVP!#`0D)"0P+#!@-#1@R(1PA,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C(R
M,C(R,C(R,C(R,C(R,C(R,C(R,C(R,C+_P``1"`$L`9P#`2(``A$!`Q$!_\0`
M'P```04!`0$!`0$```````````$"`P0%!@<("0H+_\0`M1```@$#`P($`P4%
M!`0```%]`0(#``01!1(A,4$&$U%A!R)Q%#*!D:$((T*QP152T?`D,V)R@@D*
M%A<8&1HE)B<H*2HT-38W.#DZ0T1%1D=(24I35%565UA96F-D969G:&EJ<W1U
M=G=X>7J#A(6&AXB)BI*3E)66EYB9FJ*CI*6FIZBIJK*SM+6VM[BYNL+#Q,7&
MQ\C)RM+3U-76U]C9VN'BX^3EYN?HZ>KQ\O/T]?;W^/GZ_\0`'P$``P$!`0$!
M`0$!`0````````$"`P0%!@<("0H+_\0`M1$``@$"!`0#!`<%!`0``0)W``$"
M`Q$$!2$Q!A)!40=A<1,B,H$(%$*1H;'!"2,S4O`58G+1"A8D-.$E\1<8&1HF
M)R@I*C4V-S@Y.D-$149'2$E*4U155E=865IC9&5F9VAI:G-T=79W>'EZ@H.$
MA8:'B(F*DI.4E9:7F)F:HJ.DI::GJ*FJLK.TM;:WN+FZPL/$Q<;'R,G*TM/4
MU=;7V-G:XN/DY>;GZ.GJ\O/T]?;W^/GZ_]H`#`,!``(1`Q$`/P#W^BBB@`HI
M&.U2?09KQB?XYW$-Q+$-$B(1RN?./.#]*TITIU/A1G.I&'Q'M%%>*?\`"][C
M_H!Q?]_C_A1_PO>X_P"@'%_W^/\`A6OU2KV(^LTNY[717BG_``O>X_Z`<7_?
MX_X4?\+WN/\`H!Q?]_C_`(4?5*O8/K-+N>UT5XI_PO>X_P"@'%_W^/\`A1_P
MO>X_Z`<7_?X_X4?5*O8/K-+N>UT5XI_PO>X_Z`<7_?X_X4?\+WN/^@'%_P!_
MC_A1]4J]@^LTNY[717BG_"][C_H!Q?\`?X_X5ZGX7UIO$7ARSU5H1";A2QC!
MSCDCK6=2A.FKR1<*L)NT6;%%%%9&@4444`%%%%`!1110`4444`%%%%`!1110
M`55M+Y+N6Z1593;R^4Q/<[0<C\ZM5CZ+_P`?>L?]?G_M-*`-BBN>N_$HM9W3
M9'L&2I+=0.,U!9^,;2_GV6\MM.JXWF&4,5!]?3\:\_\`M3"W:YMO)_Y&_P!6
MJ6O8WKV^2Q$)=&;S9EB&.Q8XS5JL;7B&BT\@Y!O8<'_@0K6ED6&%Y7W;44L=
MJDG`]`.37H&`^BJ(DU&<[HX[>"/<V/,W,S+M&TD<;3NSD<\#KD\*J:GE=TUH
M1F/=B%NG_+3'S=^WIWS3L*Y=HJ@4U;RSBXLO,V'!\A\;]W!^_P!-O&/7G/:G
ME=2WG$UKLWO@&)L[=OR_Q=0>OJ/3K0%RY15)4U/*[IK0C,>[$+=/^6F/F[]O
M3OFFE-6\LXN++S-AP?(?&_=P?O\`3;QCUYSVH"Y?HJF5U+><36NS>^`8FSMV
M_+_%U!Z^H].M($U3Y<SV?6/=B%O^VG\7?MZ=\T!<NT51*:KY9Q/9;]C8)@;&
M[=\I^_TV]1Z_E3RNH^8<36NS>V!Y39V[?E_BZ[NOMZ=:`N6Z*I*FI_+NGM/^
M6>[$+?\``\?-W[>G?-(4U7RSB>RW[&P3`V-V[Y3]_IMZCU_*@+EZBJA74?,.
M)K79O;`\IL[=OR_Q==W7V].M-5-3^7=/:?\`+/=B%O\`@>/F[]O3OFD%R[15
M$IJOEG$]EOV-@F!L;MWRG[_3;U'K^5)->7%EOENXXS:JS,TT9/[M`!@LO4G.
M>G3BG8+E^BBBD,****`&R?ZMOH:^/+W_`(_[C_KJW\Z^PY/]6WT-?'E[_P`?
M]Q_UU;^=>A@/M'%C.A"N-PW9QWQ6@^FC,GEE_DQ@-C+=S6=2[CG.3^=>@TSA
M31I-IB+(ZDN0J[@PZ?3I56&"-TD+B3*$#Y?<U7W-ZG\ZDMX9;F=88@6=S@"E
M9I:L=U?1%]=,C/F99SM)''L!UXJ"ULTG:<,6'E]/\XIVHZ5?Z4RB[B:/?TYZ
MU1R?4\TEJM&-Z/5&D^FQI(R[G^4=^_XXJO/#;Q+C,H<H&4''>JNYO[Q_.DSG
MK32?<3:[!7T_\,O^2>:3_P!<S_Z$:^8*^G_AE_R3S2?^N9_]"-<F._AKU.G!
M_&SK:***\L]$****`"BBB@`HHHH`****`"BBB@`HHHH`*YN"Y%JFN.>=UX5'
MU,:5TG:O(+:\O=1\0>(+UMR0BZ-K;PDD`N"%+8_!?R-<685W1P\I1WV7JS:A
M#GJ)'/:QKFH^)M>O?#7APR1MN\NYO6&!$@ZC/J23GZ58T:^TGPEJ]GX2T"WD
MO[QY!_:$ZC.WCG=CT/;L/>J>JW3Z3<R^"O"MK+)JMS^\O+]\@J6Y+$XYZCVQ
MQ5::Y@\#6Z>'/#*&^\47I'GW/WBI/<_GT_.O&C1BZ:I15DUHN_\`>D^B[(ZW
M-I\S_KR1[/<W0N-.TX'[Z7L*$'@C#CM6OJ>UC91.8]LETF0X;DKEQC;WRH//
M'!KRVXDU73'\.3W$QDDCN88[V.-OE<DKSCUSBO5+]B)K'#,,W`!Q,$S\C<$?
MQ_[OX]J]C+:_ML.F]UH_E_5SCQ$.6;1=HJO?7L.G6%Q>W!(A@C:1\#)P!FJ^
MBZO!KFF1WUO'-$K,R&.==KHRL5(8`GD$'O7<9&A1110`4444`%8GARZGNO[6
M\^5I/*U*:)-Q^ZHQ@#VK;KGO"O\`S&_^PM/_`.RT`=#1110!EZ_J4NG:<!:*
MKW]RXM[-&Z-*V<$_[*@%C[*:I>'GN=/N;C0+^[FNYK=1-;7,YR]Q"W=CW96R
MI]MA[TNG@ZQXAN-6<$VMD6L[('HSYQ-)^8V#_<;LU3>([6<V\&J6,9DO].<S
M1QKUF0C$D7_`EZ?[2H>U`&U14-K=0WMG#=VT@D@GC62-QT92,@_D:FH`****
M`*.CMOT>TPZN!$%#"8RYQQG>>6/'6KU4]+W_`-F0>9YF_;SYH4-U[[>/RJY0
M]Q+8****!C9/]6WT-?'E[_Q_W'_75OYU]AR?ZMOH:^/+W_C_`+C_`*ZM_.O0
MP'VCBQG0A`R0,XS6GJ.E"UM8;FWD\^W88>5>@;T]JRZOZ9J<FGR,I42VTHVS
M0MT<?X^]=\K[HXE;9E"M'06*ZW:[>[XYJ34],CBB6^L6,MA*>#WC/]UO>H]"
M_P"0Y9_]=!2;3BQI-21U/Q&22&>UC<@Y7)YSVKA:[_XH?\?UIZ[*XO3]/N-3
MNUM[=<D\LQX5!W)/85%%VIILJJO?L&GZ=<:E>+;P)ENK$\!5[DGL*?JUO96U
M\T5C<FXB`&7*XY[X]1[UKZIJMI#8OIVGRMNP!/<!<?:"/U`_G7-54'*3NR9)
M)605]/\`PR_Y)YI/_7,_^A&OF"OI_P"&7_)/-)_ZYG_T(US8[^&O4Z,'\;.M
MHHHKRST0HHHH`****`"BBB@`HHHH`****`"BBB@`KB_$6B7,,<TVG2+;3,QD
M298P0KGJ6'0]3^?Y=I3719$*.,J1@BN3&858F'+>S6J?F:TJKIRN>,>(9]:T
M^S8:-8&]UJ]14GO@@"Q`<9_#G`^IJMI?A^[\':9&^G6QU/Q#?-B6ZD(*1$]2
M3Z<_CBO0?%T<.B:0VHJ[)'$0'.<G!.``/QIGA`VGB326OS(9E,A3)X((Z@_I
M^=>''#XZ,O8\J[MZV?J_+L=CJ4;<UROX6\.R!C/<RF65I?.FF*X#R?[(Z#':
MNPOE8RV.U7.+@$[8@^!M;J3]T>XY[=ZLQQ)#&L<:A548`%4]1V>?I^_R\_:A
MMWAB<['^[COUZ\=>^*]S!818>#3=Y/5OS.*M5=1^2.?\<W$\S:3I%K:27DES
M=+--#&%W&&(AF/S$+C.T<D=:K^';J:U\8:UIMW8W%C;7R"^MX9S'P<!9<%'8
M`9VGKW[=^R-M;FZ6Z,$1N%0H)2@WA3R1GKCVI)+.VFN([B6WA>>(,L<C("R!
MNH!Z@'O74M%]_P#7X(R:N[^G]?BRKHEOIEIHUK!HS1-IR+B`Q2^8N,GHV3GG
M/>M"HK:UM[*W2WM8(H((QA(HD"JH]@.!4=_J%KIEHUU>3+%"I`R<DDG@*`.6
M8G@`9)/2J;N[A%65BS17!:RFK>+=1MM%>6XTJPF7S[B&%]MQY`.!YC#[F]N`
M@.<!R3QM$^@ZUJNDV<MMKC/>QV4AM[BZ1<RPD<AY%'WHV4A@XY`.&SAFI#.V
MI``,X`&3DXIL4L<\*30R))$ZAD=&R&!Z$$=13B0!DG`'4T`+17%V'B77];U*
MXCTZWTVWMBBSV9NS(6N("2HE&WC!()QU`*YZU-+I_C"37;34O-T0?9[::W\O
M]]AO,:)L_4>5^IH`ZZBN-U77/%6C/:B2STN]>9R?LUJ9!*T:#=(PW<<*.,]2
M5'>NLM;J&]M(;NVD$D$\:R1NO1E(R#^5`$U4M1U:PTD6QOKE(/M,ZV\.[/SR
M-T7]#5QF5%+,P55&22<`"N1L!8^--0U6[F`FT^!&TZWC/&0RJ\DH_P!X,FT_
MW5R#\U`'7T5SWA76A?V\^G7,_F:CITKVTSD8\X(Q42CUSCG'`;<.U=#0!1T8
M*-(M@BQJNS@1Q-&O7LK<C\:O52T=@VDVS!@P*=1/YV?^!]ZNTWN);!1112&-
MD_U;?0U\>7O_`!_W'_75OYU]AR?ZMOH:^/+W_C_N/^NK?SKT,!]HXL9T(***
M*]$X#3T?6)-+DD1D$MK,-LT)Z,/\:Z#3=(LY+JVO-/G(C=^"T>[RSZ-@UQE;
M_A"6[&MQQ6^XHX_>+CC'J?3ZUA6A=71M2GK9G9^+M)FO]1MDNIHF<IQY41"J
M/5B2<"N+U+4;:SMY-+TDGR"?W]Q_%,?3_=%=9X]N=12P55!6-B%E9>I&.`?:
MO-:C#PNKLNM*SL@HHHKJ.8*^G_AE_P`D\TG_`*YG_P!"-?,%?3_PR_Y)YI/_
M`%S/_H1KBQW\->IUX/XV=;1117EGHA1110`4444`%%%%`!1110`4444`%%%8
MUWX@,&L2Z9;:3?WT\4*32&`PJJJY8#F21>?E/2@&[&S6;K^L0Z!H-YJEQ_J[
M:,OCU/8?B<"GZ3K%KK-O));B5'AD,4T,R%)(G`!*L/7!'3(/8FLSQUI#ZYX+
MU2PB0O(\6Y$!P693N`_$B@#Y^T^3Q1\4/$+27%W)*[YD@MLE884SC<1Z=/>O
M<+&WT7X5^#':ZG8QJQEFDZM-*1SM'X<#T%>%?#GQM_PA6KO-<6,DRO!]FG@4
MA9(]IR"`>ON*U_'GC23XD:CI^BZ393*6E"Q0LP+,3U9@.``/ZT`?0&A:J-<T
M2TU-;>6W6Y3S%BF&&`[9^HY_&I-38PP1W.6"6\JR28E\M0G1BQ[@*2V.^T5/
M:P"ULX;=3E8HU0?0#%3=1@T`(K*Z*Z,&5AD$'((I:H-I:^9,\-W=P&4<A)=P
M4Y!RH;('3'`QR>*>;&4NS?VA=C+.V!LP-PP!]WHO4>_7-,1<K(LM%*WHU'4Y
MQ>Z@,^6VW;';@]HEYV\=6.6/KC@6UL90RG^T+LX*'!V<[1@C[O\`%U/Z8IG]
MG2^7L_M.]SL*;LQYSNSN^YU[>F.V>:0#=,TPV5Q?74THFNKR<N\FW&$'$:`>
MBK^9+'O0VF%=?35()1'O@,%S'MR)0#E#GL5);\'/M4IL92[-_:%V,L[8&S`W
M#`'W>B]1[]<T+8RAE/\`:%V<%#@[.=HP1]W^+J?TQ3`J0Z*=/U$3Z9.+>VE<
MM<V97,3$_P`2#/R-GKC@\Y&3FK&L:<VK:9+8>>88IR$F*C)://SJ#GC<N5SV
MS56_,.FVR_:]:O$+J8XP-C22-NW?*H3+-CC`!X[9YK$UJ7Q!_95UJ%M=3Z=#
M'N>-9A&\LA;`5=H&$4'D9+-R<XH2$Y6.CO=)6XN].NK>06\UE(=I5,AHF&'C
M(XX.%/L54]L5HU2%A*&!_M&[.#&<'9SMZ_P_Q=_TQ33ITQC*_P!J7H)1EW?N
M\Y+9W?<ZCH.V.V>:!B0Z9LURYU2:7S9'B6"!=N!#&.6`]2S<D\<*H_AHTC3/
M[)BN+>.;=;/</+!'MQY*M@E,]QN+$=,`@=JD-E*9"W]H70!=FVC9@97`'W>@
MZCWZYZ4BV$J[?^)C=G'E]=G.WKGY?XN_Z8I`1:AI1U2XC2ZFW:>@R]J%XF?/
M&\]U']WN>N1Q2PZ6;?6[W4(9@JW<,:/$4R!(FX!^O=2`1_LBG'3IC&5_M2]!
M*,N[]WG);.[[G4=!VQVSS3S92F0M_:%T`79MHV8&5P!]WH.H]^N>E,#-@\,0
MP:'8V0N'%[9J6COD`$GFMR[XZ89B2RG@YK8,IM[57N9$W*H#LORJS=.`3QD]
M`3WJ!;"5=O\`Q,;LX\OKLYV]<_+_`!=_TQ2QZ;&&1IYI[EE&!YSY7[VX':,+
MD$#!QD8ZT`.TY)(]-MUFWB3RP6#A0P)Z@A>..G%6J**0PHHHH`;)_JV^AKX\
MO?\`C_N/^NK?SK[#D_U;?0U\>7O_`!_W'_75OYUZ&`^T<6,Z$%%%%>B<!9L+
M"?4;I8(%R3RS'HH[DGTKI])OK>SU>UTS33NC+CSY^\I_^)JM865W_8SP1>2B
M3X9F$Z*SCT/.<5)I6CS6.IP7++#MC;)_TF/_`.*KDG54KIG3"FU9HZ7Q[J,F
MG7]LX57B==LL3#AU(Z5PNI:;%Y`U#3R7LW/S+_%$WH?\:Z_Q>/[?GA>!8]L8
MYW7$8_\`9JQM/TV\T\R&/R"KKM:-KB,JX]_FJ(5%!>9<X.3\CDZ*GO8O)O9H
MPH7:Q&`VX#\>]05VIW5SD:LPKZ?^&7_)/-)_ZYG_`-"-?,%?3_PR_P"2>:3_
M`-<S_P"A&N/'?PUZG5@_C9UM%%%>6>B%%%%`!1110`4444`9-K-*WBO4X6D8
MQ):6S(A/"DM-D@>IP/R%:U<8G_"1_P#"P=9^R'3OLGV2VV^=OW8S)MZ>_F9_
MX#6U_P`5-_U"/_(E4T2F;-%8W_%3?]0C_P`B4?\`%3?]0C_R)2L.YLUSEG_R
M4/5_^P=:_P#H<U6O^*F_ZA'_`)$K.OM`O=3G$]_I/AJ[F"[1)/;-(V/3)'3D
MT<NJ$WH)X>,=YXP\1:E:;6LSY-MYB]'E0'>1ZXW*/J*ZNL*&'Q#;PI##'HL4
M2#:B(L@51Z`#I4G_`!4W_4(_\B46!,Y+XC?#_P`-7VA:KK,FG*M_';NXEB8I
MEL=2!P?QKH_#?@/PWX39GT?34AE88,K$N^/]X\UE^-/^$B_X0G6C-_9?E+:2
M,^SS-V`,G&>];W_%3?\`4(_\B46'<V:*QO\`BIO^H1_Y$H_XJ;_J$?\`D2BP
M7-FBL;_BIO\`J$?^1*/^*F_ZA'_D2BP7-FBL&XN/$%K`\]Q-HL,*#+R2-(JJ
M/<GI6?#J7BW4]PL+?38X.UW<)*JM_N(<,WU(`]":?*+F.GO+VUT^W,]W/'#$
M#C<[8R>P'J3Z5S/AZ\UO5O#]GY)-K&4^>]N?GEDY/W$_]F?T^Z120:)XAMG:
M[9],O-1"G9<W1D8J3V4``(/90,]\U8^'_P!N'@K3_P"T#$9L-CR^FW<<9]Z=
MK(5VV:]AH]I82-.H>:Z<8DNIVWRN/3<>@_V1@#L*J^*?FT41Y_UMW:Q_]]3Q
M@_H:V:Q?$?S+I<7_`#TU&#_QTE__`&6I6XWHC:HHHI%!1110`4444`%%%%`!
M1110`4444`-D_P!6WT-?'E[_`,?]Q_UU;^=?8;C*,!W%?'VH(T>IW2-]Y9G!
M_,UZ&`^T<6,Z%:K$-G)-'YFZ-$S@%VQDU7J_9S;8=GVH1\YV.F5KT)7MH<2(
M!93%9S\N(`"_S>OI236DL-PL#[=[!2,'CGI5\W5J([Y8R!YD2JN%P&8'GCM4
MESJH^VP^5Y31*J`L4R?>HYI7*M$H?V=/Y\L1VKY1P[EL*/QJ.>UDM]I8HRMT
M9&R#5^YN;:[DN8C+L5IC(CXR#]:=%)I\?D(Y1S$=[.JXW8Z+[T<SZARHJS:3
M<01I)*8T5P",M45SI]W9HCSPLL;\JXY5OH1Q5ZXU"VOK6:-D,4F[S$)8G)[C
MVKM/A3I<FK?VE!J,>_0S"?-,@^57[%3V(J95'"/-(J,%*7*CS2OI_P"&7_)/
M-)_ZYG_T(U\SWT<45_<1P-NA61@C>HSQ7TU\-HVB^'VD!A@F+</H236&-?[M
M&V$7OLZNBBBO+/0"BBB@`H[444`8\?B.S29+?44DTRY?A4NP%5S_`++@E&^@
M.?:MBO,K'5=3UKXO7-O?:?/'I=O;2VL<<T>4.=C$MVRP`./3;79_\(_]C^;1
MKV73\=(,>;;_`$\LGY1_N%:IQL1&38MI_P`CCJW_`%Y6G_H4];->/VDGBRZ\
M0ZGI$TNH2ZA:MYLC6VIK'$4=B4"J5XPI7CMD>M:G]D>,/[FL?^#F/_XFDRD>
MF45YG_9'C#^YK'_@YC_^)H_LCQA_<UC_`,',?_Q-(9Z917F?]D>,/[FL?^#F
M/_XFC^R/&']S6/\`P<Q__$T`>F45YG_9'C#^YK'_`(.8_P#XFC^R/&']S6/_
M``<Q_P#Q-`'6>.O^1!\0?]@^;_T`UT%>6WGAWQ3?V4UI=0:O);SH8Y$;68\,
MI&"/NU-_9'C#^YK'_@YC_P#B:`/3**\S_LCQA_<UC_P<Q_\`Q-9\)\47D[PV
M"ZS=%#AY4UA/*4^F_;@D=P,D=Z`/6W=8T9W8*BC+,QP`*QCK,^H'9HEN+A>]
MY-E8!_NGK)_P'C_:%<!)X6\5WB*-1BU2ZVG<(VU:/RP>QVD')'J:N_V/XP`P
M$UC_`,',?_Q-/06IVUOH<?GI=:E.VH7:'<C2C$<1_P"F<?1?KRWN:UJ\S_LC
MQA_<UC_P<Q__`!-']D>,/[FL?^#F/_XFD.UCTRL7PC_R*FG_`/7/^IKC'TOQ
M='&SN-75%!+,=9CP!_WS6_\`#74+S5O!L.H7<LSB>:5H1/('D2,,5"L0!R""
M*?05M3KJQ=:^?5_#T?\`T_.Y^@MYOZD5M5BZA\_BO18_[L5S+^01?_9Z$#V-
MJBBBD,****`"BBB@`HHHH`****`"BBB@`KP_XH_#JYBO9M=TB%I893NN(4'*
M'U`]*]PI"`1@C(/4&M*565.7,C.I352-F?&G0X-21K&WWY"G_`<U]$^*?A1H
MNO,]S:#[!>-SNC'R,?<5Y/K/PL\3Z2S,EI]KA'1X#GCW%>K3Q-.:WLSSIT)P
MZ7.7CL8Y3\E];*/^FK%?Z&K2:`\GW-1TX_\`;?']*HW&GWMF<7-I/#SC]Y&5
M_G5:MM7LS.Z6Z-Y?"[XS)J^E(O<FX/\`A4J^']'CYN?$UH,=1!$S_P"%<Y4D
M-O/</L@ADE8]D4L?TI.,NX)KL=9!+X'TMMYBU#5I!T63$29^G<4S6_B!J6IV
M']FV<4.FZ:!C[/;#&1[GO4&D_#_Q-K#+Y&F2QH?^6DPV`?GS7IWAKX+6=HR7
M&N7'VJ0<^1'P@^I[USSG2AK)W9M"-6>D59'GG@7P'>^*]0222-HM-C;,LQ&-
MP_NK7TK:VT5G:16T"!(HE"(H[`4MM:P6=ND%M"D42#"H@P!4M>?7KNJ]=CMH
MTE37F%%%%8FP56U!F33+IT8JRPN00<$'!JS4-Y"UQ97$*$!I(V0$],D8I2V=
MAQW1YIH.J2!/"4EK>:K]KO"JWSZA)<F"53&20IE^0N2`5V>GI7I5Y=PV%E-=
MSMMBA0NQ`R<#T]3[5R-IX<UV71-%T2^33H;2P>!Y)X+AY9)/*P0%4QJ%R0,G
M)P,UMS?\3G6$MUYL;!Q),>TLXY1/<+]X^^WT(K25FWZF4+I$^@V<MII:M<KB
M\N7:XN!Z2.<E?HHPH]E%:$LL<$+S2N$CC4L[$\`#DFGUS_B0G47M?#L9_P"/
M_+71'\-JN/,_[Z)6/_@9/:H-%H8.DQ26>H:+XCG0H^LSW"W`(P56<*\`;W58
M8H_JU=]69K^F-JNAW%I`RQW`"R6SGHDJ,'C/T#*M2Z-J2:OH]K?HAC\Z,%XV
MZQOT9#[JP(/N*`+U%%%`!1110`445G7FM6UK<?98EDN[W&1:VX#.`>A;H$'N
MQ`H"YHUE7.N1+</:6$+W]XAP\<)&V,_]-'/RI]/O>@-1?V=J.J<ZK<_9[<_\
MN5FY&?\`?EX9OHNT=CNK5MK:"SMTM[:&.&%!A8XU"JOT`IZ"U9E?V/<ZB=^M
MW(EC/_+C!E8![-_%)_P+"G^[6Q'&D4:QQHJ(HPJJ,`#T`IU%%P2"BBBD,***
M*`,#Q>[2Z+_94+%;C5I!8H5."%<'S&'^[&)&_"F>&T73M4UO1U4(D5R+N!0,
M`13#/3_KHLOY4ZS_`.)QXIN-0ZVFF!K.W]'F.#,_X85!Z$2"C6O^)9KVF:T.
M(7;[!=^RR,/+;\)-J_20GM0!T%8LOS^-K7_IEITW_C\D7_Q%;58L/S^-;TY_
MU6G6X_[ZDF_^(%-"9M4444AA1110`4444`%%%%`!1110`4444`%%%%`!1110
M!%+:V]P,3012?[Z`_P`ZHR^'=&F_UFE6;?\`;%:TZ*:;6PFD]S*C\-:'$VY-
M)LP?^N(JY%I]E`<Q6D$9]5C`JS10Y-[L%%+8****0PHHHH`****`"BJ]Z+O[
M.39-$)U(8+*#M?U4D<C/KSCK@]*X'Q@/$?C*)-%T&'[#%&RM?S7,HC9''*QX
M&6Q_%D`@\8.*:5R92LCLKZ\FN)VTW3FQ<X'G3@`K;*>_NY'1?H3QUNV=I#8V
MD=M;IMBC&`,Y)[DD]R3DDGJ3530-/GTO1+:TNY(Y;I%_?31@@2N>K'/))ZDG
MJ:T20`23@#J30^PUW(;R[@L+.:[NI!'!"I=W/8#_`#TK,T"SN#]HU>_C,=_?
M$$Q-UMXA_JXOJ`23_M,W;%0P`^)+V&^8'^R+9]]JI_Y>I!TE/^P/X/4_-V4U
MT%(85S\'_$C\2R6Q^6PU9S+">T=R!ET_X&!O'NK]R*Z"J>J:=#JNG2V<Y95?
M!61#AHW!RKJ>S*P!'N*`+E%96CZC-.9;"_"IJ5J`)0HPLJG[LJ?[+8/'8@CM
MDVK_`%.STU%:ZF",YQ'&H+/(?15&2Q]@*`+=4;_5[33W6*1FDN9!F.VA4O*_
MT4=O<X`[D53_`.)QJOKI-F?]U[EQ^JQ_^/'_`'35^PTRSTU&6UA"LYS)(Q+/
M(?5F.2Q]R:8KM[%#[/JVJ\W<ITVU/_+O;OF9A_M2#A?HG/HU:5G8VNGP>1:0
M)#'G)"CJ>Y)[D^IYJQ11<+!1112&%%%%`!1110`5D:]?SPQ1:?I[`:E>DI`<
M9\I1C?*1Z*#GW)4=ZMZEJ,.EVGGRAW9F"111C+RN>B*.Y/Y#DG`!-5M(TZ:"
M2;4-0*/J5UCS-ARL*#[L2'^Z,DYXR23QD``%S3["WTO3X+&U4K#"@1<G)/N3
MW)/)/<FEO[&#4M/N+&Z3?!<1F.09P<$8X/8^]6**`,?P]?3S6LEC?ONU*P;R
M;@XQY@_@E'LZX/L=P[4W3OG\4:W)_=6WB_)6;_V>EUBRN$N8=8TZ/?>VRE)(
M0<?:83R4]-P/*D]\C@,:K^%[R#4[C6]0MGWPSWJ["00<+;P@@@\@AMV0>AIH
M3W1T-%%%(84444`%%%%`!1110`4444`%%%%`!117E>N?'OPQH>NWVE26.J3R
MV<S02211IM+J<,!N<'@@CIVH`]4HKRK2_P!H+P9?W`AN%U'3\D`27$`*?^.,
MQ'Y5Z?:W5O?6L5U:3QSV\RAXY8V#*ZGH01U%`$U%<!X.^+NA>-_$$FCZ;::A
M'*D33"2=$",JD#LQ/<=J[74-1L])L)K[4+F.VM85W22R-A5%`%JBO(+W]HOP
MI;W3Q6UCJ=W&IP)DC5%;Z!F!_,"NK\$_%#P[XZD>VTYYX+Y$,C6MPFUMH.,@
M@D$=._>@#M**X"S^+NA7WCYO"$-IJ'VU;F2U,S(@BWINW?Q9QE3VKI_$_B73
MO"6@7&LZF[BW@`&V,9=V)P%4>I/^)XH`V**Y#P)\0].\?Q7LNFV&H6\5HRJT
MEU&H5RV>%*L<D8Y';(]:Z^@`HHKR?Q?#+=^-[N,HDJ+]FB423.NS?QP!VR<F
MHJ3Y%<WP]'VT^6]CUBJ%_IS7$BW=K((+Z(827&0R_P!QQ_$OZCJ,&O//^$#N
M_P#GG8_^!,O^%'_"!W?_`#SL?_`F7_"H]K/^4U^K4O\`GXCOX=;MQ;7#7Y2Q
MFM5W7,<KC$8_O!N,H<'#?@<$$"D(I_$QW74,EOHW5;:12LEW[R#JL?\`L'EO
MXL#*G@[CP&&N[>*>'3FG;<T0:XE).,9Q\O;(JCI^B2:C?BT2UME8K(P+7,N/
MD8*>WO2=9IKW=RH8.$DVJBT/:0```!@#H!2UY;_P@=W_`,\['_P)E_PH_P"$
M#N_^>=C_`.!,O^%/VLOY2?JU+_GXCU*BO)-0\(7&G6$UW)!9LD0R0MS+D\X]
M*ATOPO/JD<[QV]HGDR^4P:YEY.U6XX]&%3[>5[<I:P<''G]HK?UYGIVLZ2VI
M0K):W+66HP@_9KM%#&,GJ"#PRGC*GT!Z@$4?#HLTGFAFMWAUM%'VG[1)YDKC
M^\KG[T9/3&`.F%.0.._X0.[_`.>=C_X$R_X5!/X&9)[431Z>)9)"D!-Q-DMM
M9B!Q_=5C^%5[6?\`*0\-2_Y^(]9HKQS5?#4^E&`26]HYF+`;;F7C`SZ5:LO!
MES>V-O=I#9JD\2R*&N9<@,,^GO4^VE>W*6\'!14G45G_`%W/6:*\M_X0.[_Y
MYV/_`($R_P"%'_"!W?\`SSL?_`F7_"J]K+^4CZM2_P"?B/4J*\4N=$DM=4^P
MM:VQ?S8HBPN9<9<C';WK9_X0.[_YYV/_`($R_P"%2J[>T2Y8.$4G*HM?Z[GJ
M5%>6_P#"!W?_`#SL?_`F7_"C_A`[O_GG8_\`@3+_`(57M9?RD?5J7_/Q'J59
M^IZO!IHCC*//=S9$%K",R2D=<#H`.['`'<UY)I.BR:M<K#%:VR%H3*"US+T!
M`].O-:,'@9I;FX:&/3VFC813$7$V00`P!X]&!_&IC6E)742ZF#A3ERRFKGHF
MG:9/]I_M+5'26_*E41"3';*>JIGJ?5B,M[#`&M7EO_"!W?\`SSL?_`F7_"JF
MI>$;C3;"2[D@LV5"H(6YESRP'I[TW5DE?E%'"TY.RJ+^OF>NT5X_I?A6XU2W
MDECM[1`DAC(:YEZC'M[U>_X0.[_YYV/_`($R_P"%"K2:NHA+"4XNSJ*_]>9Z
ME6'<V4VD7<NI:5`9(YGWWME'@&4]Y$[>9ZC^(#UQ7$_\('=_\\['_P`"9?\`
M"LO5O#TVDR0I);6KF5'<;;F7@+MSV_VA2E6E%7<1PP=.<N6-17_KS/7K*^MM
M1M$NK242POG!'!!'!!!Y!!X(/(/!JQ7D%AX-^U;Y+>*P$CJDDJ_:)01N7*YX
MZXJ[_P`('=_\\['_`,"9?\*KVLOY2/JU+K41ZE17EO\`P@=W_P`\['_P)E_P
MK,MK&XTKQ=80K'%$T.HPPN\4\C;@P5B,'MAL4O;--7B4L)"2?+.]E<]EHHHK
M<X0HHHH`****`"BBB@`KY0T:RM=1_:/NK2]MH;FVDUJ]#PSQAT8;I#RIX/-?
M5]?'T\^M6WQQU6;P[`L^K+K%Y]GC8`ACODSU('3/>@#UKXU^!O#-C\/[G5K#
M2+*PO+66+8UK"L6\,X4@A<`\'/X5/^SI>7%QX#O+>60M#;7[)"#_``@JK$#\
M23^-<EK'AGXP?$26"PUV"*RT]&#'<\:1!AGYB%)9C@_3Z5[5X&\(6G@?PO;Z
M-:R&9E)DGG*A3+(W5L?@`/8#DT`?/?[//_)2I/\`L'R_^A)6E^T'XHN=0\4V
M_A>UD8V]HBO+$G)DF?D`COA2N!_M&LW]GG_DI4G_`&#Y?_0DJE\4W_L_XZ7E
MU<JT<*W-K-N*GE`D>2/7H?RH`]T\'_"7POX?T"WM[[2++4K]D#7%Q>0+*2Y'
M(4,"%4=`!^/-:FF_#GPWHWBI/$.E60L;E87A:&#Y8FW8YV]B,=L#FNK!#`$$
M$$9!'>EH`^5_#9`_:9G)(`&M7I)/UEJ[XVUJ_P#C'\1K7PUH+DZ7:NRI*,E#
MC[\[8[=E_#NV*P8=(37OCWJFE/<36ZW6JW\9EA?:Z9,O(/\`3N.*TOAMKTWP
MK^)-[H>OQPPPW#K:W4Q/$1'*2!O[AW<].&![4`?2/AKP[8>%?#]IH^G)M@MT
MQN.-TC=V;W)YK6H!!&0<@T4`%>8Z_P#\CU>?]=K'_P!"%>G5YCK_`/R/5Y_U
MVL?_`$(5C7^'YG;@?XC]#O:***T.(Q[_`/Y&?1O]RX_DM<[X8_Y&-/\`KE<_
M^C5KHK__`)&?1O\`<N/Y+7.^&/\`D8T_ZY7/_HU:RJ_%`[,)_#J_UT.ZHHHK
M4XS(\4?\BU>_[@_]"%4_!_\`Q[ZG_P!?O_M&*KGBC_D6KW_<'_H0JGX/_P"/
M?4_^OW_VC%6+_C+T.V'^Z2]?\CHZQ]9_Y"GA[_L(/_Z33UL5CZS_`,A3P]_V
M$'_])IZW1PO8SO&/^LT[_>E_]!K8T#_D7-+_`.O2+_T`5C^,?]9IW^]+_P"@
MUL:!_P`BYI?_`%Z1?^@"L(_Q9'=4_P!UAZO]31HHHK8XCA-6_P"1O;_K\M/Y
MI7=UPFK?\C>W_7Y:?S2N[K&E\4O4[<7\%/T_R"BBBMCB.#\%_P#(5A_Z\6_]
M#2NDT3_C^UW_`+"'_M"*N;\%_P#(5A_Z\6_]#2NDT3_C^UW_`+"'_M"*LL/_
M``SLS'^.;%8OBO\`Y%NY_P!Z+_T8M;58OBO_`)%NY_WHO_1BU<_A9CA_XT/5
M?F0^$/\`D'77_7V_\EKH*Y_PA_R#KK_K[?\`DM=!4TO@0\5_&D%<AXT_X^[#
M_KA<?^TZZ^N0\:?\?=A_UPN/_:=*O_#9I@?X\?G^3+?AC_CZO/\`KWM/_15=
M)7-^&/\`CZO/^O>T_P#15=)6QRR^)^K"O/\`4/\`D>8_^PQ;?^BHZ]`KS_4/
M^1YC_P"PQ;?^BHZPK?9]4=F"WG_A?Z'J-%%%=!Q!1110`4444`%%%%`!7RUX
M<C=/VG)E9&#?VS>-@CL?-(/Y<U]2T4`%%%%`'RU^SY&\?Q-G1T962PE#*1@J
M=R#FO0/C?\-+[Q/]G\0:'!Y]_;Q^3<6Z_>EC!R"O/)&3QU(/M@^RT4`?,7AO
MXZZ_X3TQ-$UG1_MTEH!$C32-!*B@<*^5.<#O@'US7??#OQWXR\=^,!=7&E_8
M/#<5NY^6,[7<XVYD;[QZ_=QP>:];DMX96#20QNPZ%E!(J0``8`P!0!\M>'(W
M3]IR961@W]LWC8(['S2#^7->A_';P`VO:,OB/382^HV";9D1>9H>N?<KU^A/
MM7L5%`'E'P,\<R^)O#3Z1?%FO]*54\PDGS(CPI)]1C'X`UZO110`5YCK_P#R
M/5Y_UVL?_0A7IU>8Z_\`\CU>?]=K'_T(5C7^'YG;@?XC]#O:***T.(Y[7K^T
MTS6M*O+V=(+>..X+2.>!PM<5X4\7:,_B=@;H1QQPSGSI!M5MTBD`9YZ>U=[J
M`!\3:.",@QW&1_P%:Y;PE8VL'BO[1#;QQRR0W*NR+C<!*F,U,W"\>9&]!57"
M?(U;K]QU7_"5Z!_T%K7_`+^4?\)7H'_06M?^_E;%8NN:A=1W=AI=A(L5U?.P
M,[+N\F-5RS`'@MT`SQSDYQBKT.?4S/$?B;1)O#]Y'%JEL[LHPH?D\BJGA7Q)
MHL%OJ'FZG;)ON]RY?J/*C&?S!K2UJRO;30=1\_59KV%HUVK/%&'5MPZ,@48Q
MV*Y]^U/\'_\`'OJ?_7[_`.T8JRER^U7I_70ZX<_U67K_`)>9%K'Q`T#2+);G
M[4MT#($,=NP9P#WP2*K1>*M&\2:EH)TN\$KI?L7C*E67_1I^H-=+J6E6.KVR
MVVH6R7$*N'$;],CID=ZSM0M;>SOO#L%K!%!$NH/B.)`JC_1I^PK=<MCB?-?R
M*?C'_6:=_O2_^@UL:!_R+FE_]>D7_H`K'\8_ZS3O]Z7_`-!K8T#_`)%S2_\`
MKTB_]`%<T?XLCT*G^ZP]7^IHT445L<1PFK?\C>W_`%^6G\TKNZX35O\`D;V_
MZ_+3^:5W=8TOBEZG;B_@I^G^04445L<1P?@O_D*P_P#7BW_H:5:?Q7HWAN[U
MLZG>")WO\I&JEG;]S%T`_K57P7_R%8?^O%O_`$-*W]-M;>\N->ANH(IXFU#E
M)4#*?W$78UGAK<FIV9E?VVA4TCQ_H&K67VK[6MJ-Y41W#!7('?`)ZU#XE\2Z
M)<:#/%%JEL[LT>`''_/1371Z=I=CI%J;;3[9+>`N7\M.@)ZX]*H>*_\`D6[G
M_>B_]&+6E1QY78YL.I>UAKK=&'X5\2Z+!I]RLNIVZ$W3D!GQD87FM[_A*]`_
MZ"UK_P!_*YO0[N]N;M]&L;C[)F22YN+E45G5`54*@8%<DYR2#@#ISQV%A;7=
MJLB7.H/>J6S&\L2JZC'()0!3ST^4?C4TN5TTRL3S>VDOZ_,I_P#"5Z!_T%K7
M_OY7#>,_&NC-K5I;)/YB);2$SQ_,F7(`''.1L_45ZC7"^-]+L9=7L[R2UBDN
M&MIE+NN[A2I7&>F-S=/6BJX<CYD/"JHZT>1J_GZ&AX.NH+U[N>VE66,P6H#*
M>,B/!_6NJKF_#'_'U>?]>]I_Z*KI*MF3O=W[L*\_U#_D>8_^PQ;?^BHZ]`KS
M_4/^1YC_`.PQ;?\`HJ.L*WV?5'9@MY_X7^AZC11170<04444`%%%%`!1110`
M4444`%%%%`!1110`4444`%%%%`!1110`5YCK_P#R/5Y_UVL?_0A7IU>8Z_\`
M\CU>?]=K'_T(5C7^'YG;@?XC]#O:***T.(Q[_P#Y&?1O]RX_DM<[X8_Y&-/^
MN5S_`.C5KM)+6&6ZAN73,L(81MD\;L9_D*XOPQ_R,:?]<KG_`-&K657XH'9A
M5^[J^G^9W58>NZ?>/>Z?JVGHLUS8L^;=F"^=&PPP!/`;H1GCU]:W**U\SC.:
MUJ\N[OP_J'G:7/91+&,&XEC+,=PZ!&88]R1]*=X/_P"/?4_^OW_VC%5SQ1_R
M+5[_`+@_]"%4_!__`![ZG_U^_P#M&*L9?QEZ';#_`'27K_D='6/K/_(4\/?]
MA!__`$FGK8J&:UAN);>65-SV\AEB.?NL59,_]\LP_&MT<+.<\8_ZS3O]Z7_T
M&MC0/^1<TO\`Z](O_0!6/XQ_UFG?[TO_`*#6QH'_`"+FE_\`7I%_Z`*PC_%D
M=U3_`'6'J_U-&BBBMCB.$U;_`)&]O^ORT_FE=W7":M_R-[?]?EI_-*[NL:7Q
M2]3MQ?P4_3_(****V.(X/P7_`,A6'_KQ;_T-*Z31/^/[7?\`L(?^T(JYOP7_
M`,A6'_KQ;_T-*[:"UAMI+AXDVM<2>;(<DY;:%S^2BLL/_#.W,?XY-6+XK_Y%
MNY_WHO\`T8M;58OBO_D6[G_>B_\`1BU<_A9AA_XT/5?F<WH=I?VU\^M6,!NU
M#R6MQ;*RJY7*L&0L0,@YR"1D5V=C<W5TKO<6$EFH.$261&<^I(0E0/3YC^%9
M7A#_`)!UU_U]O_):Z"E2_AI!BE^_D_,*Y#QI_P`?=A_UPN/_`&G77UR'C3_C
M[L/^N%Q_[3J:_P##9K@?X\?G^3+?AC_CZO/^O>T_]%5TE9NB6L,.GP7"+B6>
MWA\PY/.U`!6E6M]#FG\3]0KS_4/^1YC_`.PQ;?\`HJ.O0*\_U#_D>8_^PQ;?
M^BHZQK?9]4=>"WG_`(7^AZC11170<04444`%%%%`!1110`4444`%%%%`%74;
MV/3=.N+R3[L,9?&>N!TKQ+0_$7B7QS?SZJ^I3V.FQ,0+>`@#V&:]2\;3B'0Y
M=W*F.3@]"=IQ7DGPOU*W7PB]ED+*96+<]J=A-G6'QA)I\T<,FJ[7'&UR"/QK
MO]"UA=6M2Q`69/O@=#[BOG_Q!I5\=;F98'D$K`JR+D>G/I7I'A'41H[(D@+J
M8PC8;)%0F[M6)C)MZGIM%5K74+6]7,$RL?[N>1^%6:HL****`"O,=?\`^1ZO
M/^NUC_Z$*].KS'7_`/D>KS_KM8_^A"L:_P`/S.W`_P`1^AWM%%%:'$%<+X8_
MY&-/^N5S_P"C5KNJX7PQ_P`C&G_7*Y_]&K6-3XHG;A?X53T_S.ZHHHK8XC(\
M4?\`(M7O^X/_`$(53\'_`/'OJ?\`U^_^T8JN>*/^1:O?]P?^A"J?@_\`X]]3
M_P"OW_VC%6+_`(R]#MA_NDO7_(Z.BBBMCB.6\8_ZS3O]Z7_T&MC0/^1<TO\`
MZ](O_0!6/XQ_UFG?[TO_`*#6QH'_`"+FE_\`7I%_Z`*QC_%D=M3_`'6'J_U-
M&BBBMCB.$U;_`)&]O^ORT_FE=W7":M_R-[?]?EI_-*[NL:7Q2]3MQ?P4_3_(
M****V.(X/P7_`,A6'_KQ;_T-*[RN#\%_\A6'_KQ;_P!#2N\K'#_`=V8?Q@K%
M\5_\BW<_[T7_`*,6MJL7Q7_R+=S_`+T7_HQ:TG\+.?#_`,:'JOS(?"'_`"#K
MK_K[?^2UT%<_X0_Y!UU_U]O_`"6N@J:7P(>*_C2"N0\:?\?=A_UPN/\`VG77
MUR'C3_C[L/\`KA<?^TZ5?^&S3`_QX_/\F='I/_(&L?\`KWC_`/015RJ>D_\`
M(&L?^O>/_P!!%7*T6QS3^)A7G^H?\CS'_P!ABV_]%1UZ!7G^H?\`(\Q_]ABV
M_P#14=95OL^J.O!;S_PO]#U&BBBN@X@HHHH`****`"BBB@`HHHH`*K7U];:;
M927=W((X(QEF/:K-<9\3M0M;;P==6LTFV6Z'EQJ.I-`&9XG\3^&/$6D20+>7
M!E16,7EH1EMI&"<=*\$M]-U?2EBD@F$,R$AH\Y##/J*VK&*&WVEI)<G_`&S@
MU-<Q6THWXD&1QANOZU7*B;E>3QKK4=LL+P1,XXWDTNG>*'M+G[2^H?.>6C=3
MC\#6'J-D!)\LSXQW-9GV'<=WF$8I/<:6A[58^-('1/M"/;2D91^F[Z'O7;:+
MXWCDF2"[D5D<@+*.Q]Z\AT_X>>(-<\/PWVAZK;WD)&'@8[6C8=N>*W-!\!>*
MUEAAN;4Q`'YI&88`]10&I[R#D9'0T5'!&8;>*(G<40+GUP*DI#"O,=?_`.1Z
MO/\`KM8_^A"O3J\QU_\`Y'J\_P"NUC_Z$*QK_#\SMP/\1^AWM%%%:'$%<+X8
M_P"1C3_KE<_^C5KNJX7PQ_R,:?\`7*Y_]&K6-3XHG;A?X53T_P`SNJ***V.(
MR/%'_(M7O^X/_0A5/P?_`,>^I_\`7[_[1BJYXH_Y%J]_W!_Z$*I^#_\`CWU/
M_K]_]HQ5B_XR]#MA_NDO7_(Z.BBBMCB.6\8_ZS3O]Z7_`-!K8T#_`)%S2_\`
MKTB_]`%8_C'_`%FG?[TO_H-;&@?\BYI?_7I%_P"@"L8_Q9';4_W6'J_U-&BB
MBMCB.$U;_D;V_P"ORT_FE=W7":M_R-[?]?EI_-*[NL:7Q2]3MQ?P4_3_`""B
MBBMCB.#\%_\`(5A_Z\6_]#2N\K@_!?\`R%8?^O%O_0TKO*QP_P`!W9A_&"L7
MQ7_R+=S_`+T7_HQ:VJQ?%?\`R+=S_O1?^C%K2?PLY\/_`!H>J_,A\(?\@ZZ_
MZ^W_`)+705S_`(0_Y!UU_P!?;_R6N@J:7P(>*_C2"N0\:?\`'W8?]<+C_P!I
MUU]<AXT_X^[#_KA<?^TZ5?\`ALTP/\>/S_)G1Z3_`,@:Q_Z]X_\`T$5<JGI/
M_(&L?^O>/_T$5<K1;'-/XF%>?ZA_R/,?_88MO_14=>@5Y_J'_(\Q_P#88MO_
M`$5'65;[/JCKP6\_\+_0]1HHHKH.(****`"BBB@`HHHH`****`,'QI=3V?A#
M4KBVE>*9(25=.JFOFFZUS5-7F5[^_FN&0$*7.<#\J^D_'*-)X*U9$4LQ@.`O
M6OEV`,LA#9!!Z'C%-;B9JI"6BW[WR.^TFJDLMSG!F?`Z$I6A&0+?MSZ%C63.
MXR<#_P`=-4(JW#S'),KG_@%5D9GW`N>>P6I9""3_`/$FHXT122.I]<TF4C=\
M,^(M9T>[6WT_4IK>.:1?,50.?S%?5MFS/90.Q)9HU))[G%?(.BAGU6W"Y/[P
M?=.>]?7UD,6,`XXC7I]*E@3T444`%>8Z_P#\CU>?]=K'_P!"%>G5YCK_`/R/
M5Y_UVL?_`$(5C7^'YG;@?XC]#O:***T.(*X7PQ_R,:?]<KG_`-&K7=5POAC_
M`)&-/^N5S_Z-6L:GQ1.W"_PJGI_F=U1116QQ&1XH_P"1:O?]P?\`H0JGX/\`
M^/?4_P#K]_\`:,57/%'_`"+5[_N#_P!"%4_!_P#Q[ZG_`-?O_M&*L7_&7H=L
M/]TEZ_Y'1T445L<1RWC'_6:=_O2_^@UL:!_R+FE_]>D7_H`K'\8_ZS3O]Z7_
M`-!K8T#_`)%S2_\`KTB_]`%8Q_BR.VI_NL/5_J:-%%%;'$<)JW_(WM_U^6G\
MTKNZX35O^1O;_K\M/YI7=UC2^*7J=N+^"GZ?Y!1116QQ'!^"_P#D*P_]>+?^
MAI7>5P?@O_D*P_\`7BW_`*&E=Y6.'^`[LP_C!6+XK_Y%NY_WHO\`T8M;58OB
MO_D6[G_>B_\`1BUI/X6<^'_C0]5^9#X0_P"0==?]?;_R6N@KG_"'_(.NO^OM
M_P"2UT%32^!#Q7\:05R'C3_C[L/^N%Q_[3KKZY#QI_Q]V'_7"X_]ITJ_\-FF
M!_CQ^?Y,Z/2?^0-8_P#7O'_Z"*N53TG_`)`UC_U[Q_\`H(JY6BV.:?Q,*\_U
M#_D>8_\`L,6W_HJ.O0*\_P!0_P"1YC_[#%M_Z*CK*M]GU1UX+>?^%_H>HT44
M5T'$%%%%`!1110`4444`%%%%`!U&#63=>&-#O7+W&E6CN>K>6`3^(K6HH`^;
M_BG8P>'O%@@M08;26$.L<9)QZ]:X/4)8<*T$LG(YR#7H7QV)/BZW&#Q;#'YU
MYM-@1+SV]15+83*HN47F25CCVKU;X,>'=)\32ZC/J5HEU%"%"!V(P?P->028
MS_\`7KW;]GG_`(]-6`Z;E-)C1ZQ8^%=`TUE:TTBTB9>C"($C\36Q112`****
M`"O*O$UP8/'=Y^XFD&^T<F--V`I!.?PKU6L?4?"NB:M=F[OK!99RH4OO920.
MF<$5G5@YQLCIPM:-*?-)75C'_P"$NL/^?>]_[\__`%Z/^$NL/^?>]_[\_P#U
MZN_\(%X9_P"@6O\`W^D_^*H_X0+PS_T"U_[_`$G_`,54\M7NB^;"]F4O^$NL
M/^?>]_[\_P#UZY70]56RUH3S6EX(U2=<B'KN=2/T%=O_`,(%X9_Z!:_]_I/_
M`(JC_A`O#/\`T"U_[_2?_%5$J=1M.ZT-*=?#0BXI/4I?\)=8?\^][_WY_P#K
MT?\`"76'_/O>_P#?G_Z]7?\`A`O#/_0+7_O])_\`%4?\(%X9_P"@6O\`W^D_
M^*J^6KW1GS87LS!USQ):WVBW5M#;7ADD4!08?<'UJMX<U^"P@O1<6EZIFN?,
M4>3V\M%]?5373_\`"!>&?^@6O_?Z3_XJC_A`O#/_`$"U_P"_TG_Q51[.IS<U
MT:*OAE3=.SLRE_PEUA_S[WO_`'Y_^O1_PEUA_P`^][_WY_\`KU=_X0+PS_T"
MU_[_`$G_`,51_P`(%X9_Z!:_]_I/_BJOEJ]T9\V%[,Y/Q)KL-^UFUO:7K>47
MW?N?48'>M/2?$]I::-8VTMM>B2*WCC;$/<*`>];/_"!>&?\`H%K_`-_I/_BJ
M/^$"\,_]`M?^_P!)_P#%5"IU%)RNC25?#.FJ=G9%+_A+K#_GWO?^_/\`]>C_
M`(2ZP_Y][W_OS_\`7J[_`,(%X9_Z!:_]_I/_`(JC_A`O#/\`T"U_[_2?_%5?
M+5[HSYL+V9P^H:HL_B/[7':7AA-Q;R9\GLA7/\C75_\`"76'_/O>_P#?G_Z]
M7?\`A`O#/_0+7_O])_\`%4?\(%X9_P"@6O\`W^D_^*J(TZD6VFM36I7PU1)-
M/0I?\)=8?\^][_WY_P#KT?\`"76'_/O>_P#?G_Z]7?\`A`O#/_0+7_O])_\`
M%4?\(%X9_P"@6O\`W^D_^*J^6KW1ES87LSA_#6J+IU^DMQ9WBJMJT1(A[EE/
M]#75_P#"76'_`#[WO_?G_P"O5W_A`O#/_0+7_O\`2?\`Q5'_``@7AG_H%K_W
M^D_^*J(4ZD%9-&M:OAJLN:292_X2ZP_Y][W_`+\__7K,U_Q';7VBSV\%K>F1
MF0@&'T=2>_H*Z#_A`O#/_0+7_O\`2?\`Q5'_``@7AG_H%K_W^D_^*JG"JU:Z
M(A4PL)*23T.:\.^(+>PL9X[BUO59YVD`\GL0/\*V/^$NL/\`GWO?^_/_`->K
MO_"!>&?^@6O_`'^D_P#BJ/\`A`O#/_0+7_O])_\`%4HPJQ5DT%2KA9R<FGJ4
MO^$NL/\`GWO?^_/_`->N<\3:U%J,]H]O:7C".*9&_<]VV8_D:[#_`(0+PS_T
M"U_[_2?_`!5'_"!>&?\`H%K_`-_I/_BJ)TZDE9M%4JV&I34TF9-AXIL[?3K6
M&2VO=\<*(V(>X`'K5G_A+K#_`)][W_OS_P#7J[_P@7AG_H%K_P!_I/\`XJC_
M`(0+PS_T"U_[_2?_`!5/EJ]T9N>%;O9E+_A+K#_GWO?^_/\`]>N2FOQ=^-+6
M5+:Y6.;5;=T9X\#`1%_F#7=?\(%X9_Z!:_\`?Z3_`.*J6U\&>'K*ZBNK?352
M:)@Z-YCG!'0X)Q2=.I)J[6A<*^'IJ7(G=JQO4445T'`%%%%`!1110`4444`%
M%%%`!1110!\Y?'*3?XUB4CA+8`?F37G,S_NE'7CLQ_PKO?C<^?'K#TMUKS^?
MB)>O3L2::T0C/E/->Z?L\.#;ZLF><J<5X3(:]P_9V.6U;!XVK_.AC6Q[Q111
M2`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*R[OQ'H]DY
M2XU"!''\!;FLOQEXG&AV!BMW7[;*N$&>5'K_`#_*O')Y)IA-=2!Y-H+2-@G%
M>9B\>Z4_9TU=]3V<ORKZQ#VE1VCT\SVZS\8:)?7T-E;W@:>;.Q=IYQ[UNU\L
MZ;K,UEK]IJ6[!@E5@/09Y_2OJ*WG2YMHIXSE)$#J?8C-=.%K2J1]_<RS/`1P
MLH\CNGW/,M<^*C+XWM/#>E0?\O2Q7,\@]>H4?UKU&OES4KF&S^,TES<2+'#%
MJ"L[L<!0,<U[3<?%_P`%V\OEG5&D/K'"[#\P*]"<-N5'ATJM[N3.ZHK-T77]
M,\0V7VO2[M+B+.#M/*GW':L[Q#XZ\/>%Y!%JE^L<Q&?*0%W_`"'-96=[&_,K
M7.CK,\0ZY;>'-#N=5NU=H8%R509)]JX^+XU>#9)-K75Q&,_>:W;%+\0]6L=;
M^%.H7VG7"SVTBC:Z_6J4'=7(=1-/E9+\-O&]YXV;5KF>%(((946")>2H(/4]
MS7>U\_\`P>\5Z-X7T;5Y=6O%@$DR;%P2S84]`.37IVE_%/PAJUVEK;ZH$E<X
M431M&"?J:<X.^B)IU$XJ[U.RHH!!&0<@U0N=:L+1RDDP+#J%&<5F;%^BLJ+Q
M%I\LBH)&!8X&5-6;W4[73]HN'(+#(`&<T`7**QAXFT\G!,@'KMK4M[F&ZB\R
M"0.OJ*`)::[;$9O[HS4%UJ%K9#]_,J$]!WJDVOZ=+&Z+/@E2!N4B@!VC:C)J
M7VAW4*JN`JCL*U*Y[PI_Q[W/^^*Z&@`HHHH`****`"BBB@#SSX@_"VV\93C4
M+:Y^RZ@J;"6&4<#IGTKRV_\`@QXO1MD-O;SJ.-Z3CG\R*^E:*=P/F.T^!7BZ
M[D`N%M;1>[/,&_1<U[3\//A[:^`],DB2=KB[GQYTO1?H!Z5V=%(`HHHH`***
M*`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`K+\0ZW!X>T:;4;CE4X4>
MK'H*U*Y[QOI;ZQX0U"TBC,DI3?&H&26'(J*C:@^7<UH*$JL5/:ZN>)7VNC6-
M7:5G:2>=PJ@9/7@#FO9]%\(6EEX<FL)U$CW46V8L/4=/\^E>!P64MA<!I`\<
M\9SCD%36U#\0/$>DW2F&_>50.8Y_G5OZ_K7AX65*G4;:;9]?C\+6K4HQH222
M_I'/ZIH]QINJ7-DREC#(4SZCM7O?PVO9[SP7:+<(RO`3$"?X@.AS7FWAW1[S
MQKK[W$R>7"S^9<N.@SV'N:]QM+2&QM8[:WC"11KM50*[<"IN3GT/.SK$0]G&
MB]9;OR/EGQ%IPU?XK7>GF3RQ<7HC+XSC.*];N_@KX9@T"=$-R;I(F83EQG<!
MGICI7F5S_P`EO_[B2?TKZ5U#_D&W7_7%_P"1KVJDFK6/D:,(R3N?/GP.O9[;
MQQ-8*Y\J>!]ZYX)7H:P"VG7WQ/NCXKGD2T-TXE;)SP?E!]!TK7^#/_)3!_UQ
MF_E7HGB;PM\/_$OB"Y%WJ26FJ1OMG1)@A)QW!JI-*;)C%R@O4RO[)^#MZ!"E
MU;PLW`<7!!_4D5K>+=$L/#_P;OK'3)VFL_OQNS`D@D=Q7`>/_`?A?PWH/VO3
M-9,UWYBJL+.K;P>N,>E6-#N[JX^!&MQ3NS10S!8BW8'J!4M;-,I.UXM="M\)
M_`6D^,(K^XU1IR+9U5$B8*#D9YX-6/BK\.=.\*6-KJFD-*L;R>7)&[9P>Q!K
M2^!>M:9IEEJT5]?06\DDJ%%E<*6&#TI_QK\8:7J6FVNCZ==QW4@E\R4Q-D+C
MH,^M.\O:6%:'LK]3J_`GB*YO_A;!<RR%KB)C;;R>3CH?R-=1H6DV_P!B2YGC
M$DDG/S<X%<?X`T6XM/A/`LD96261KD*1SM)_^M7<^'[R.?38X@P\R(;2N>:P
MGN['33ORJY>-C:$@_9H@1R"$`IE[]A3;+>"+Y>%+U;Z=:Y2\5;SQ.(;ICY0X
M`SBI+-!]0T.53&PAP?\`8Q5#P[*(KZ\6-LPA2P'T-;3Z9IB1Y>WB"@=2:P]!
M5&U*]2+&PHP7'IFF`_1[1-6NKB]N_P!X`V%4GBMJYTNQ:W?-K'PIQ@8K*\-3
M+!+<6<AVR!L@'OBN@G_X]Y/]T_RI`87A/BWN1_MBNAKGO"G^HNO]\5T-`!11
M10`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%`!1110`4444`%%%%
M`!1110`4444`%%%%`&/K7AC2M>C(O+9?-[3(,./QK@Y_@M;RS,XUF4`G@&$'
M'ZUZI164J%.3YFM3KHX[$48\M.5D9F@Z':^']+CL;495>6<]7/J:TZ**TC%1
M5D<TYRG)RD[MGFLOPB@D\:_\)'_:\@;[0)_)\D8X[9S7HT\7GV\L.<>8A7/I
MD8J2BK<F]S.,%'8\Y\'_``HA\)>)/[8359+EMCKY;0A1\WOFH/%7P:T_Q)K5
MSJJ:G/;3W#;G78'7/MR,5Z;13]I*]R?90M:QXQ:?L_VJS!KK6Y'C!Y5(0"?Q
MSQ7H4O@?2&\'MX9@5X+)A@E#\Q/J3ZUTM%)SD]QJG&.R/')_V?\`3F8F'7+B
M,>C0!OZUI:'\#M"TV[CN+Z[GU`H<B-E"*3[@$YKU&BG[27<7L87O8:L:)$L:
M(%C4;0H'`'I6/<>&X'E,MO-);L?[O2MJBH-#"B\/RK*KR:C,X4YV\\_K5O4=
M&M]182,S1RCC>M:5%`&$OAI"P\^\FE0?PFKEEH\-A>23PL0KKC9CI^-:-%`&
M5?Z%!>S>>KM#-W9>]5?^$=G<;9-2F*^G/^-;]%`%+3=-BTV)DC9FWG))J[11
$0!__V>S>
`

#End