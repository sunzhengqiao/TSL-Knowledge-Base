#Version 8
#BeginDescription
#Versions
Version 1.4 29.02.2024 HSB-21528 thickness dic corrected , Author Thorsten Huck


assignment changed to Z layer (to make the TSL visible when plotting)</version>


D >>> Dieses TSL erstellt einen Rothoblaas DISC Verbinder an einer oder mehreren Stab-Verbindungen.

E >>> This TSL creates Rothoblaas DISC connector at one or multiple beam connections.


#End
#Type T
#NumBeamsReq 2
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 4
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This TSL inserts a Rothoblaas DISC connector between two or more beams. It refers to the real body of the beams, so the insert at
/// already tooled beams is possible.
/// </summary>

/// <insert Lang=en>
/// At least one beam is necessary. Multiple beam selection is possible.
/// </insert>

/// <remark Lang=en>
/// TSL refers to the real body of the beams, so it's possible to insert the connector at already cut beams, or when male beam is an integrated tool in the female beam. 
/// </remark>

// #Versions
// 1.4 29.02.2024 HSB-21528 thickness dic corrected , Author Thorsten Huck
/// <version value="1.3" date="08aug17" author="florian.wuermseer@hsbcad.com"> assignment changed to Z layer (to make the TSL visible when plotting)</version>
/// <version value="1.0" date="28jan16" author="florian.wuermseer@hsbcad.com"> initial version</version>

// basics and props
	U(1,"mm");
	double dEps=U(.1);
	int bDebug = 0;
	int nDoubleIndex, nStringIndex, nIntIndex;
		
	String sLastEntry = T("|_LastInserted|");
	String sDoubleClick = "TslDoubleClick";
	
	
// connector's properties collection
	String sArticles[] = {"DISC55", "DISC80", "DISC120"};
	double dThreadDias[] = {U(12), U(16), U(20)};
	double dTopPlateDias[] = {U(55), U(80), U(120)};
	double dTopPlateThicks[] = {U(10), U(15), U(15)};//HSB-21528
	double dPipeLengths[] = {U(20), U(25), U(30)};
	double dPipeDias[] = {U(20), U(25), U(30)};
	String sMaterials[] = {T("|Steel, zincated|"), T("|Steel, zincated|"), T("|Steel, zincated|")};
	
// fixing screws
	double dFixingScrewLengths[] = {U(50), U(60), U(90)};
	double dFixingScrewDias[] = {U(5), U(6), U(6)};
	int nFixingScrewQuants[] = {8, 8, 16};
	
	String sFixingScrewArticles[] = {T("|Screw|") + " DISC55", T("|Screw|") + " DISC80", T("|Screw|") + " DISC120"};
	String sFixingScrewName = T("|Wood construction screw|");
	
// threaded bolt
	// threaded bolt KOS
	String sMainScrewName = T("|Threaded bolt|");
	double dMainScrewSWs[] = {U(19), U(24), U(30)};
	double dMainScrewHeadHeights[] = {U(7.5), U(10), U(12.5)};
	
	//washer ULS 1052
	String sMainWasherName = T("|ULS 1052|");
	String sMainWasherArticles[] = {"ULS14586", "ULS18686", "ULS22808"};
	double dMainWasherDias[] = {U(58), U(68), U(80)};
	double dMainWasherHeights[] = {U(6), U(6), U(8)};
	


// properties category
	String sCatType = T("|Category|");
	
	String sArticleName = "A - " + T("|Article|");
	PropString sArticle	(nStringIndex++, sArticles, sArticleName);
	sArticle.setCategory (sCatType);
	sArticle.setDescription(T("|Defines the type of the connector|"));	
	int nArticle = sArticles.find(sArticle);

// properties tooling	
	String sCatToolMale = T("|Tooling male beam|");
	String sCatToolFemale = T("|Tooling female beam|");

//male beam	
	String sMillDepthName = "B - " + T("|Additional mill depth|");
	PropDouble dMillDepth (nDoubleIndex++, U(0), sMillDepthName);
	dMillDepth.setCategory (sCatToolMale);
	dMillDepth.setDescription(T("|Defines the additional milling depth. (mm)|") + "\n" + T("|Negative values|") + " --> " + T("|Main plate will be milled into female beam|"));	
	
	String sTopDrillDiaOversizeName = "C - " + T("|Oversize mill|");
	PropDouble dTopDrillDiaOversize (nDoubleIndex++, U(1), sTopDrillDiaOversizeName);
	dTopDrillDiaOversize.setCategory (sCatToolMale);
	dTopDrillDiaOversize.setDescription(T("|Defines the extra diameter of the milling. (mm)|"));	
	
	String sYOffName = "D - " + T("|Offset Lateral|");	
	PropDouble dYOff (nDoubleIndex++, U(0), sYOffName);
	dYOff.setCategory (sCatToolMale);
	dYOff.setDescription(T("|Defines the lateral offset of the connector. (mm)|"));	

	String sZOffName = "E - " + T("|Offset Vertical|");	
	PropDouble dZOff (nDoubleIndex++, U(0), sZOffName);
	dZOff.setCategory (sCatToolMale);
	dZOff.setDescription(T("|Defines the vertical offset of the connector. (mm)|"));

// female beam		
	String sFemaleToolName = "F - " + T("|Tools in female beam|");
	String sFemaleTools[] = {T("|No|"), T("|Yes|")};
	PropString sFemaleTool (nStringIndex++, sFemaleTools, sFemaleToolName, 1);
	sFemaleTool.setCategory (sCatToolFemale);
	sFemaleTool.setDescription(T("|Insert tools and hardware in female beam?|"));
	int nFemaleTool = sFemaleTools.find(sFemaleTool);

	String sExitDepthName = "G - " + T("|Extra depth sink hole|");
	PropDouble dExitDepth	(nDoubleIndex++, U(0), sExitDepthName);
	dExitDepth.setCategory (sCatToolFemale);
	dExitDepth.setDescription(T("|Defines the extra depth of the sink hole. (mm)|"));	

	String sExitDiaOversizeName = "H  - " + T("|Oversize sink hole|");
	PropDouble dExitDiaOversize	(nDoubleIndex++, U(4), sExitDiaOversizeName);
	dExitDiaOversize.setCategory (sCatToolFemale);
	dExitDiaOversize.setDescription(T("|Defines the extra diameter of the sink hole. (mm)|"));	


// get properties depending from from selected article
	double dThreadDia = dThreadDias[nArticle];
	double dTopPlateDia = dTopPlateDias[nArticle];
	double dTopPlateThick = dTopPlateThicks[nArticle];
	double dPipeLength = dPipeLengths[nArticle];
	double dPipeDia = dPipeDias[nArticle];
	String sMaterial = sMaterials[nArticle];
	
	String sFixingScrewArticle = sFixingScrewArticles[nArticle];
	int nFixingScrewQuant = nFixingScrewQuants[nArticle];
	double dFixingScrewDia = dFixingScrewDias[nArticle];
	double dFixingScrewLength = dFixingScrewLengths[nArticle];
	
	double dMainScrewSW = dMainScrewSWs[nArticle];
	double dMainScrewHeadHeight = dMainScrewHeadHeights[nArticle];
	
	double dMainWasherDia = dMainWasherDias[nArticle];
	double dMainWasherHeight = dMainWasherHeights[nArticle];
	String sMainWasherArticle = sMainWasherArticles[nArticle];
	


// other standard properties

	double dScrewOverlap = U(5);
	double dExitDia = dMainWasherDia + dExitDiaOversize;	
	double dTopDrillDia = dTopPlateDia + dTopDrillDiaOversize;
	double dPipeDrillDia = dPipeDia + dTopDrillDiaOversize;
	double dPipeDrillDepth = dPipeLength + U(40);
	double dThreadDiaOversize = U(1);
	
// bOn Insert
if (_bOnInsert)
{
	if (insertCycleCount() > 1) {eraseInstance(); return;}
	
// use catalog properties, or call dialog
	String sCat = _kExecuteKey;
	sCat.makeUpper();
	String sCatalogNames[] = _ThisInst.getListOfCatalogNames(scriptName());
	for (int i=0; i<sCatalogNames.length(); i++)
		sCatalogNames[i].makeUpper();
		
	int nCatPos = sCatalogNames.find(sCat);
	
	if (nCatPos>-1)
		setPropValuesFromCatalog(sCat);
		
	else
		showDialog(sLastEntry);	

// select (multiple) beams to insert the connector
	Entity entMales[0], entFemales[0], ents[0];
	PrEntity ssMale(T("|Select male beam(s)|"), Beam());
	if (ssMale.go())
		entMales = ssMale.set();


	PrEntity ssFemale(T("|Select female beam(s)|"), Beam());
	if (ssFemale.go())
	{
	// avoid males to be added to females again
		ents = ssFemale.set();
		for (int i=0;i<ents.length();i++)
			if(entMales.find(ents[i])<0)
			{
				entFemales.append(ents[i]);
			}		
	}	


		
// declare TSL props
	TslInst tslNew;
	Vector3d vUcsX = _XW;
	Vector3d vUcsY = _YW;
	GenBeam gbAr[2];
	Entity entAr[0];
	Point3d ptAr[0];
	int nArProps[0];
	double dArProps[] = {dMillDepth, dTopDrillDiaOversize, dYOff, dZOff, dExitDepth};
	String sArProps[] = {sArticle, sFemaleTool};
	Map mapTsl;
	
		
	// loop males
	for (int i=0;i<entMales.length();i++)
	{
		Beam bmMale = (Beam)entMales[i];
		//if (!bmMale.bIsValid())continue;
		gbAr[0] =bmMale;
		Vector3d vxMale = bmMale.vecX();	
	
		// loop females
			for (int j=0;j<entFemales.length();j++)
			{
				Beam bmFemale = (Beam) entFemales[j];
				//if (!bmFemale.bIsValid())continue;		
				Vector3d vxFemale = bmFemale.vecX();
				if (vxMale.isParallelTo(vxFemale))continue;
				
				LineBeamIntersect lbi(bmMale.ptCen(), vxMale, bmFemale);
				
				Point3d ptI = lbi.pt1();
				Point3d ptImin = bmFemale.ptCen();
				Point3d ptImax = bmFemale.ptCen();
				ptImin.transformBy(-vxFemale * bmFemale.solidLength() * .5);
				ptImax.transformBy(vxFemale * bmFemale.solidLength() * .5);
				double dInt = vxFemale.dotProduct(ptI-bmFemale.ptCen());
				double dIntMin = vxFemale.dotProduct(ptImin - bmFemale.ptCen());
				double dIntMax = vxFemale.dotProduct(ptImax - bmFemale.ptCen());
				
				if (bDebug == 1)
				{
					reportMessage ("\n" + "Intersection? " + lbi.bHasContact());
					reportMessage ("\n" + "Minimum: " + dIntMin + " Wert: " + dInt + " Maximum: " + dIntMax);
				}
				
				if (dInt <= dIntMin || dInt >= dIntMax)continue;
				if (!lbi.bHasContact())continue;
				
									
				gbAr[1] = bmFemale;
				// create new instance	
				tslNew.dbCreate(scriptName(), vUcsX, vUcsY, gbAr, entAr, ptAr, nArProps, dArProps, sArProps, _kModelSpace, mapTsl); // create new instance	
			} // next j
	}	// next i
	
} // end on insert __________________________________________________________________________________________________________________________________________________________________________


// define beams and points

	Beam bm0 = _Beam0;
	Beam bm1 = _Beam1;
	_Entity.append(bm0);
	_Entity.append(bm1);
	assignToGroups(bm1, 'Z');
	
	setDependencyOnEntity(bm1); // to force a recalc, if tools on female beam change
	
	Vector3d vecX0 = _X0;
	Vector3d vecY0 = _Y0;
	Vector3d vecZ0 = _Z0;


	Vector3d vecX1 = _Y1.crossProduct(_Z1);
	Vector3d vecY1 = _Y1;
	Vector3d vecZ1 = _Z1;


	vecX0.vis(_Pt0 + vecX0* U(-150), 30);
	vecY0.vis(_Pt0 + vecX0* U(-150), 4);
	vecZ0.vis(_Pt0 + vecX0* U(-150), 5);

	vecX1.vis(_Pt0, 1);
	vecY1.vis(_Pt0, 3);
	vecZ1.vis(_Pt0, 150);


// define bodies for connection area
	Body bd0 = bm0.realBody();
	Body bd1 = bm1.realBody();


// get connection area
	Plane pnShadow (_Pt0, vecX0); 

	PlaneProfile ppFront = bd0.shadowProfile(pnShadow);
	//PlaneProfile ppFront = bd0.extractContactFaceInPlane(_Plf, dEps);
	//ppFront.vis(6);
	
	PlaneProfile ppSide = bd1.shadowProfile(_Plf);
	//ppSide.vis(5);

	PlaneProfile ppContact = ppFront;
	ppContact.intersectWith(ppSide);
	LineSeg lsContact = ppContact.extentInDir(vecZ0);
	Point3d ptlsCen = (lsContact.ptStart()+lsContact.ptEnd())/2;
	ptlsCen.vis(3);
	ppContact.vis(2);	
	
// get vertices of connection area
	Point3d ptPlanes[] = ppContact.getGripVertexPoints();
	Point3d ptCuttingPlanes[0];
	Point3d ptExitPlanes[0];
	
// get projected vertices on the female's beam surface (ptCuttingPlanes will create the cutting plane, ptOppositePlanes give the plane, until that the screw has to reach)
		for (int i=0; i<ptPlanes.length(); i++)
	{
		Vector3d vecTrans = ptlsCen-ptPlanes[i];
		vecTrans.normalize();
		Line lnIntBody (ptPlanes[i]+vecTrans*dEps, vecX0);
		Point3d ptIntBody[] = bd1.intersectPoints(lnIntBody);
		if (ptIntBody.length() > 0)
		{
			ptCuttingPlanes.append(ptIntBody[0]);
			ptExitPlanes.append(ptIntBody[1]);
		}
		else
			continue;
	}
	
// only more than 3 points are a valid result (otherwise no cutting plane can be created)
	if (ptCuttingPlanes.length() < 3)
	{
		reportMessage(T("|No Intersection of beams possible|") + " --> " + T("|Tool will be erased|"));
		eraseInstance();
		return;
	}
	
	for (int i=0; i<ptCuttingPlanes.length(); i++)
		ptCuttingPlanes[i].vis(1);
				
	for (int i=0; i<ptExitPlanes.length(); i++)
		ptExitPlanes[i].vis(3);
		
// define planes (cutting plane and exit plane of the screw)	
	Plane pnCut (ptCuttingPlanes[1], ptCuttingPlanes[2], ptCuttingPlanes[3]);
	Plane pnExit (ptExitPlanes[1], ptExitPlanes[2], ptExitPlanes[3]);
	
// get dimension of contact area
	LineSeg segContact = ppContact.extentInDir (vecX1);
	//segContact.vis(2);
	
	double dX = abs((vecX1.dotProduct (segContact.ptStart() - segContact.ptEnd())));
	double dY = abs((vecY1.dotProduct (segContact.ptStart() - segContact.ptEnd())));


// erase TSL when connecting area is too small	
	if (dX < dTopDrillDia || dY < dTopDrillDia)
	{
		reportMessage(T("|Intersection area of beams too small for the connector|") + " --> " + T("|Tool will be erased|"));
		eraseInstance();
		return;
	}
	
// center point of contact area
	Line lnRef (segContact.ptMid(), vecX0);
	lnRef.transformBy(-vecX1 * dYOff + vecY1 * dZOff);
	Point3d ptRef = lnRef.intersect(pnCut,0);
	//ptRef.vis(1);	
	
// exit point of the screw (projection of ptRef in exit plane pnExit)
	Point3d ptExitRef = lnRef.intersect(pnExit,0);
	//ptExitRef.vis(1);

// cut to stretch male to female
	Point3d ptCut = _Pt0;
	
	Cut ct0 (pnCut, bm0.ptCen(), 0);
	bm0.addTool (ct0, _kStretchOnToolChange);

	
// detect important point for tooling (lowest point in Drill areas)
	Point3d ptDrillAreas[0];
	Point3d ptExitDrillAreas[0];
	
	for (int i=0; i<4; i++)
	{
		int nDirY = 1;
		int nDirZ = 1;
		if (i==1 || i ==3)
			nDirY = -1;

		if (i==2 || i==3)
			nDirZ = -1;

		Line lnDrillArea (ptRef-vecX0*bm1.dD(vecX0) + nDirY*vecY0*.5*dTopDrillDia + nDirZ*vecZ0*.5*dTopDrillDia , vecX0);
		Point3d ptDrillArea = lnDrillArea.intersect(pnCut,0);
		ptDrillAreas.append(ptDrillArea);
		
		Line lnExitDrillArea (ptRef-vecX0*bm1.dD(vecX0) + nDirY*vecY0*.5*dExitDia + nDirZ*vecZ0*.5*dExitDia , vecX0);
		Point3d ptExitDrillArea = lnExitDrillArea.intersect(pnExit,0);
		ptExitDrillAreas.append(ptExitDrillArea);
	}
	
	ptDrillAreas = lnRef.orderPoints(ptDrillAreas);
	ptExitDrillAreas = lnRef.orderPoints(ptExitDrillAreas);	

// set reference points for tools	
	Point3d ptToolRef = ptRef;
	ptToolRef.transformBy(-vecX0 * vecX0.dotProduct(ptRef-ptDrillAreas[0]));
	
	Point3d ptExitToolRef = ptExitRef;
	ptExitToolRef.transformBy(-vecX0 * vecX0.dotProduct(ptExitRef-ptExitDrillAreas[0]));

	if (bDebug)
	{
		for (int i=0; i<ptDrillAreas.length(); i++)
		ptDrillAreas[i].vis(i+1);
		
		for (int i=0; i<ptExitDrillAreas.length(); i++)
		ptExitDrillAreas[i].vis(i+1);
		
		ptToolRef.vis(6);
		ptExitToolRef.vis(6);
	}
	
// determine screw length
	Point3d ptScrewEnd = ptToolRef-vecX0*(dTopPlateThick + dMillDepth + dPipeLength);
	//ptScrewEnd.vis(5);
	Point3d ptScrewStart = ptExitToolRef + vecX0 * (dMainWasherHeight - dExitDepth);
	//ptScrewStart.vis(30);	

// get screw length in 20mm steps	
	double dMainScrewLength = vecX0.dotProduct(ptScrewStart - ptScrewEnd);
	dMainScrewLength = round(dMainScrewLength/U(20))*U(20);

// set correct screw end point for determined length	
	ptScrewEnd = ptScrewStart - vecX0*dMainScrewLength;
	
	

	
// draw bodies that represent the screw
	Body bdScrew (ptScrewStart, ptScrewEnd, .5*dThreadDia);
	
	// hexagon head
	PLine plExtrude;
	Vector3d vecVertex = vecY0;
	for (int i=0; i<6; i++)
	{
		plExtrude.addVertex(ptScrewStart + vecVertex *.5*dMainScrewSW/cos(30));
		vecVertex = vecVertex.rotateBy(60, vecX0);
	}
	plExtrude.close();
	Body bdHexagon = Body(plExtrude, vecX0*dMainScrewHeadHeight);
	
	Body bdWasher (ptExitToolRef, ptExitToolRef+vecX0*dMainWasherHeight, .5*dMainWasherDia);
	bdWasher.transformBy(-vecX0*dExitDepth);
	
	bdScrew = bdScrew + bdHexagon;


// draw bodies that represent the connector
	Body bdTopPlate (ptToolRef-vecX0*(dMillDepth), ptToolRef-vecX0*(dTopPlateThick + dMillDepth), .5*dTopPlateDia);
	Body bdPipe (ptToolRef-vecX0*(dTopPlateThick + dMillDepth), ptToolRef-vecX0*(dTopPlateThick + dMillDepth + dPipeLength), .5*dPipeDia);
	Body bdHole (ptToolRef-vecX0*(dTopPlateThick + dMillDepth + dPipeLength + U(10)), ptToolRef-vecX0*(dMillDepth - U(10)), .5*dThreadDia);
	Body bdConnector = bdTopPlate + bdPipe - bdHole;
	bdConnector.vis(3);
	
// correct dMillDepth value if needed
	if (dMillDepth < -dTopPlateThick)
	{
		dMillDepth.set(-dTopPlateThick);
		reportMessage(T("|Additional mill depth|") + " " + T("|out of range|") + "  -->  " + T("|value corrected to|") + " " + -dTopPlateThick);
	}
	
// tools in male beam 
	Drill drTopPlate (ptToolRef+vecX0*vecX0.dotProduct(ptDrillAreas[ptDrillAreas.length()-1]-ptDrillAreas[0]), ptToolRef-vecX0*(dTopPlateThick + dMillDepth), .5*dTopDrillDia);
	
	if (pnCut.normal().isParallelTo(vecX0))
	{
		if (dMillDepth > 0 || dMillDepth > -dTopPlateThick)
			bm0.addTool(drTopPlate);
	}
	else
		bm0.addTool(drTopPlate);
		
	
	if (dPipeDia != 0)
	{
		Drill drPipe (ptToolRef+vecX0*vecX0.dotProduct(ptDrillAreas[ptDrillAreas.length()-1]-ptDrillAreas[0]), ptToolRef-vecX0*(dTopPlateThick + dMillDepth + dPipeDrillDepth), .5*dPipeDrillDia);
		//Drill drWelding (ptToolRef+vecX0*vecX0.dotProduct(ptDrillAreas[ptDrillAreas.length()-1]-ptDrillAreas[0]), ptToolRef-vecX0*(dTopPlateThick + dMillDepth + U(7)), .5*dPipeDrillDia + U(7));
		bm0.addTool(drPipe);
		//bm0.addTool(drWelding);
	}
	else
	{
		Drill drThread (ptToolRef+vecX0*vecX0.dotProduct(ptDrillAreas[ptDrillAreas.length()-1]-ptDrillAreas[0]), ptToolRef-vecX0*(dTopPlateThick + dMillDepth + U(40)), U(10));
		bm0.addTool(drThread);
	}
	
// tools in female beam
	Drill drTopPlateFemale (ptToolRef-vecX0*vecX0.dotProduct(ptDrillAreas[ptDrillAreas.length()-1]-ptDrillAreas[0]), ptToolRef-vecX0*(dMillDepth-U(4)), .5*dTopDrillDia);
	if (dMillDepth < 0 && dMillDepth >= -dTopPlateThick)
		bm1.addTool(drTopPlateFemale);
	
	
	if (nFemaleTool == 1)
	{
		Drill drScrew (ptExitRef, ptRef, .5*(dThreadDia + dThreadDiaOversize), pnExit.normal(), pnCut.normal());
		bm1.addTool(drScrew);
		
		if (dExitDia != 0)
		{
			Drill drExit (ptExitToolRef+vecX0*vecX0.dotProduct(ptExitDrillAreas[ptExitDrillAreas.length()-1]-ptExitDrillAreas[0]), ptExitToolRef-vecX0*dExitDepth, .5*dExitDia);
			bm1.addTool(drExit);
		}
	}

// hardware

// properties that require recalc of hardware
	String sHWChangeProps[] = {sArticleName, sMillDepthName, sFemaleToolName, sExitDepthName};
	
// get previous screw length, to have a trigger in case of tool change at female beam
	double dScrewLengthPrev = _Map.getDouble("ScrewLength");
		
	
	if (_bOnDbCreated || dScrewLengthPrev != dMainScrewLength || sHWChangeProps.find(_kNameLastChangedProp) > -1)
	{
		HardWrComp hwComps[0];	
		
		String sDescription = sArticle + " " + T("|Connector|") + " - M" + dThreadDia;
			
		HardWrComp hw(sArticle , 1);	
		hw.setName(sArticle);
		hw.setCategory(T("|Connector|"));
		hw.setManufacturer("Rothoblaas");
		hw.setModel(sArticle);
		hw.setMaterial(sMaterial);
		hw.setDescription(sDescription);
		hw.setDScaleX(dTopPlateDia);
		hw.setDScaleY(dTopPlateThick+dPipeLength);
		hw.setDScaleZ(0);	
		hwComps.append(hw);
		
		HardWrComp hwFixingScrew(sFixingScrewArticle, nFixingScrewQuant);	
		hwFixingScrew.setName(sFixingScrewName);
		hwFixingScrew.setCategory(T("|Connector|"));
		hwFixingScrew.setManufacturer("Rothoblaas");
		hwFixingScrew.setModel(dFixingScrewDia + " x " + dFixingScrewLength);
		hwFixingScrew.setMaterial(T("|Steel, zincated|"));		
		hwFixingScrew.setDescription(sFixingScrewName + " " + dFixingScrewDia + " x " + dFixingScrewLength);
		hwFixingScrew.setDScaleX(dFixingScrewLength);
		hwFixingScrew.setDScaleY(dFixingScrewDia);
		hwFixingScrew.setDScaleZ(0);	
		hwComps.append(hwFixingScrew);	
		
		if (nFemaleTool == 1)
		{
			String sMainScrewArticle = "KOS" + dThreadDia + dMainScrewLength + "B";
			HardWrComp hwMainScrew(sMainScrewArticle, 1);
			hwMainScrew.setName(sMainScrewName);	
			hwMainScrew.setCategory(T("|Connector|"));
			hwMainScrew.setManufacturer("Rothoblaas");
			hwMainScrew.setModel("M" + dThreadDia + " x " + dMainScrewLength);
			hwMainScrew.setMaterial(T("|Steel, zincated|"));		
			hwMainScrew.setDescription(sMainScrewName + " M" + dThreadDia + " x " + dMainScrewLength);
			hwMainScrew.setDScaleX(dMainScrewLength);
			hwMainScrew.setDScaleY(dThreadDia);
			hwMainScrew.setDScaleZ(0);	
			hwComps.append(hwMainScrew);	
			
			HardWrComp hwMainWasher(sMainWasherArticle, 1);	
			hwMainWasher.setName(sMainWasherName);
			hwMainWasher.setCategory(T("|Connector|"));
			hwMainWasher.setManufacturer("Rothoblaas");
			hwMainWasher.setModel(dMainWasherDia + " x " + dMainWasherHeight);
			hwMainWasher.setMaterial(T("|Steel, zincated|"));		
			hwMainWasher.setDescription(sMainWasherName + " " + dMainWasherDia + " x " + dMainWasherHeight);
			hwMainWasher.setDScaleX(dMainWasherDia);
			hwMainWasher.setDScaleY(dMainWasherHeight);
			hwMainWasher.setDScaleZ(0);	
			hwComps.append(hwMainWasher);
		}
		
		_ThisInst.setHardWrComps(hwComps);
	}

// Display
_ThisInst.setHyperlink("http://www.rothoblaas.com/products/fastening/brackets-and-plates/concealed-junctions/disc");
Display dp(8);

dp.draw(bdConnector);

if (nFemaleTool == 1)
{
	dp.draw(bdScrew);
	dp.draw(bdWasher);
}

// Map screw length
_Map.setDouble("ScrewLength", dMainScrewLength);

#End
#BeginThumbnail
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
*%%%`!1110!__V5%`
`



#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HOSTSETTINGS">
      <dbl nm="PREVIEWTEXTHEIGHT" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BREAKPOINTS" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="VERSION">
      <str nm="COMMENT" vl="HSB-21528 thickness dic corrected" />
      <int nm="MAJORVERSION" vl="1" />
      <int nm="MINORVERSION" vl="4" />
      <str nm="DATE" vl="2/29/2024 9:33:13 AM" />
    </lst>
  </lst>
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End