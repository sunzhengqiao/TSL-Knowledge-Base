#Version 8
#BeginDescription
version value="1.7" date="23apr18" author="thorsten.huck@hsbcad.com"
bugfix plane detection when beamcuts are added at intersection range of male and female 


D >>> Dieses TSL erstellt einen Pitzl SPP-Verbinder (Serie 88710, 88712, 88715 oder 88716) an einer oder mehreren Stab-Verbindungen.

E >>> This TSL creates Pitzl SPP connector (series 88710, 88712, 88715 oder 88716) at one or multiple beam connections.

#End
#Type T
#NumBeamsReq 2
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 7
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This TSL inserts a Pitzl SPP connector between two or more beams. It refers to the real body of the beams, so the insert at
/// already tooled beams is possible.
/// </summary>

/// <insert Lang=en>
/// At least one beam is necessary. Multiple beam selection is possible.
/// </insert>

/// <remark Lang=en>
/// TSL refers to the real body of the beams, so it's possible to insert the connector at already cut beams, or when male beam is an integrated tool in the female beam. 
/// </remark>
/// <version value="1.7" date="23apr18" author="thorsten.huck@hsbcad.com"> bugfix plane detection when beamcuts are added at intersection range of male and female </version>
/// <version value="1.5" date="19jan17" author="florian.wuermseer@hsbcad.com"> properties corrected</version>
/// <version value="1.4" date="09sep16" author="florian.wuermseer@hsbcad.com"> properties and hardware corrected</version>
/// <version value="1.3" date="04feb16" author="florian.wuermseer@hsbcad.com"> drill for welding added, negative mill depth supported</version>
/// <version value="1.2" date="03feb16" author="florian.wuermseer@hsbcad.com"> drill on Hundegger fixed, drill oversizes added</version>
/// <version value="1.1" date="02feb16" author="florian.wuermseer@hsbcad.com"> dependency to female beam added</version>
/// <version value="1.0" date="28jan16" author="florian.wuermseer@hsbcad.com"> initial version</version>

// basics and props
	U(1,"mm");
	double dEps=U(.1);
	int bDebug = 0;
	int nDoubleIndex, nStringIndex, nIntIndex;
		
	String sLastEntry = T("|_LastInserted|");
	String sDoubleClick = "TslDoubleClick";
	
	
// connector's properties collection
	String sArticles[] = {"88710.0000", "88712.0000", "88716.0000", "88715.0000"};
	double dThreadDias[] = {U(10), U(12), U(16), U(16)};
	double dTopPlateDias[] = {U(90), U(100), U(100), U(80)};
	double dTopPlateThicks[] = {U(10), U(6), U(6), U(8)};
	double dPipeLengths[] = {U(0), U(70), U(70), U(20)};
	double dPipeDias[] = {U(0), U(43), U(43), U(24)};
	String sMaterials[] = {T("|Steel, zincated|"), T("|Steel, zincated|"), T("|Steel, zincated|"), T("|Aluminium, anodized|")};

// properties category
	String sCatType = T("|Category|");
	
	String sArticleName = "A - " + T("|Article|");
	PropString sArticle	(nStringIndex++, sArticles, sArticleName);
	sArticle.setCategory (sCatType);
	sArticle.setDescription(T("|Defines the type of the connector|"));	
	int nArticle = sArticles.find(sArticle);

	// required screws
	// fixing
	double dFixingScrewLengths[] = {U(120), U(160)};
	String sFixingScrewLengthName = "B - " + T("|Screw Length|");
	PropDouble dFixingScrewLength (nDoubleIndex++, dFixingScrewLengths, sFixingScrewLengthName);
	dFixingScrewLength.setCategory (sCatType);
	dFixingScrewLength.setDescription(T("|Defines the length of the fixing screws. (mm)|"));	
	int nFixingScrewLength = dFixingScrewLengths.find(dFixingScrewLength);
		
	double dFixingScrewDia = U(10);
	String sFixingScrewArticles[] = {"99211.1012", "99211.1016"};
	String sFixingScrewName = T("|Countersunk screws|");
	int nFixingScrewQuant = 4;
	
	// main screw
	// threaded rod DIN 975 
	String sMainScrewName = T("|Threaded Rod|");
	
	// nut DIN 934 / ISO 4032
	String sMainNutName = T("|Nut|");
	double dMainNutSWs[] = {U(17), U(19), U(24), U(24)};
	double dMainNutHeights[] = {U(8), U(10), U(13), U(13)};
	
	double dMainNutSW = dMainNutSWs[nArticle];
	double dMainNutHeight = dMainNutHeights[nArticle];
	
	//washer DIN 9021 / ISO 7093
	String sMainWasherName = T("|Washer|");
	double dMainWasherDias[] = {U(30), U(37), U(50), U(50)};
	double dMainWasherHeight = U(3);
	
	double dMainWasherDia = dMainWasherDias[nArticle];

// properties tooling	
	String sCatToolMale = T("|Tooling male beam|");
	String sCatToolFemale = T("|Tooling female beam|");

//male beam	
	String sMillDepthName = "C - " + T("|Additional mill depth|");
	PropDouble dMillDepth (nDoubleIndex++, U(0), sMillDepthName);
	dMillDepth.setCategory (sCatToolMale);
	dMillDepth.setDescription(T("|Defines the additional milling depth. (mm)|"));	
	
	String sTopDrillDiaOversizeName = "D - " + T("|Oversize mill|");
	PropDouble dTopDrillDiaOversize (nDoubleIndex++, U(2), sTopDrillDiaOversizeName);
	dTopDrillDiaOversize.setCategory (sCatToolMale);
	dTopDrillDiaOversize.setDescription(T("|Defines the extra diameter of the milling. (mm)|"));	
	
	String sYOffName = "E - " + T("|Offset Lateral|");	
	PropDouble dYOff (nDoubleIndex++, U(0), sYOffName);
	dYOff.setCategory (sCatToolMale);
	dYOff.setDescription(T("|Defines the lateral offset of the connector. (mm)|"));	

	String sZOffName = "F - " + T("|Offset Vertical|");	
	PropDouble dZOff (nDoubleIndex++, U(0), sZOffName);
	dZOff.setCategory (sCatToolMale);
	dZOff.setDescription(T("|Defines the vertical offset of the connector. (mm)|"));

// female beam		
	String sFemaleToolName = "G - " + T("|Tools in female beam|");
	String sFemaleTools[] = {T("|No|"), T("|Yes|")};
	PropString sFemaleTool (nStringIndex++, sFemaleTools, sFemaleToolName, 1);
	sFemaleTool.setCategory (sCatToolFemale);
	sFemaleTool.setDescription(T("|Insert tools and hardware in female beam?|"));
	int nFemaleTool = sFemaleTools.find(sFemaleTool);
	
	String sExitDepthName = "H - " + T("|Extra depth sink hole|");
	PropDouble dExitDepth	(nDoubleIndex++, U(10), sExitDepthName);
	dExitDepth.setCategory (sCatToolFemale);
	dExitDepth.setDescription(T("|Defines the extra depth of the sink hole. (mm)|"));	

	String sExitDiaOversizeName = "I  - " + T("|Oversize sink hole|");
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
	
	String sFixingScrewArticle = sFixingScrewArticles[nFixingScrewLength];

// other standard properties

	double dScrewOverlap = U(5);
	double dExitDia = dMainWasherDia + dExitDiaOversize;	
	double dTopDrillDia = dTopPlateDia + dTopDrillDiaOversize;
	double dPipeDrillDia = dPipeDia + dTopDrillDiaOversize;
	double dPipeDrillDepth = dPipeLength + U(40);
	double dThreadDiaOversize = U(2);
	
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
	double dArProps[] = {dFixingScrewLength, dMillDepth, dTopDrillDiaOversize, dYOff, dZOff, dExitDepth, dExitDiaOversize};
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
	
	setDependencyOnEntity(bm1);
	
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
	Body bd1 = bm1.envelopeBody(false,true); // version 1.7: beamcuts at the edge of the female beam might lead to wrong assumptions / planes
	
	//Body bd0 = bm0.envelopeBody();
	//Body bd1 = bm1.envelopeBody();

 ////--------------------------------------------------------------------------------------------------------------------------------
 ////until here execute twice to confirm the cut before determining the contact area
 ////ATTENTION this means from here the TSL is always on second loop and _kNameLastChangedProp, kExecuteKey aren't available there
	
	//if (_kExecutionLoopCount == 0)
		//{
			//setExecutionLoops(2);
			//return;
		//}


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
	Point3d ptScrewStart = ptExitToolRef + vecX0 * (dMainWasherHeight + dMainNutHeight + dScrewOverlap - dExitDepth);
	//ptScrewStart.vis(5);	

// get screw length in 10mm steps	
	double dMainScrewLength = vecX0.dotProduct(ptScrewStart - ptScrewEnd);
	dMainScrewLength = round(dMainScrewLength/U(10))*U(10);
	
	ptScrewStart = ptToolRef-vecX0*(dTopPlateThick + dMillDepth + dPipeLength) + vecX0*dMainScrewLength;
	
	

	
// draw bodies that represent the screw
	Body bdScrew (ptScrewStart, ptScrewEnd, .5*dThreadDia);
	Body bdWasher (ptExitToolRef, ptExitToolRef+vecX0*dMainWasherHeight, .5*dMainWasherDia);
	Body bdNut (ptExitToolRef+vecX0*dMainWasherHeight, ptExitToolRef+vecX0*(dMainWasherHeight+dMainNutHeight), .5*dMainNutSW);
	bdWasher.transformBy(-vecX0*dExitDepth);
	bdNut.transformBy(-vecX0*dExitDepth);

// draw bodies that represent the connector
	Body bdTopPlate (ptToolRef-vecX0*(dMillDepth), ptToolRef-vecX0*(dTopPlateThick + dMillDepth), .5*dTopPlateDia);
	Body bdPipe (ptToolRef-vecX0*(dTopPlateThick + dMillDepth), ptToolRef-vecX0*(dTopPlateThick + dMillDepth + dPipeLength), .5*dPipeDia);
	Body bdConnector = bdTopPlate + bdPipe - bdScrew;
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
		Drill drWelding (ptToolRef+vecX0*vecX0.dotProduct(ptDrillAreas[ptDrillAreas.length()-1]-ptDrillAreas[0]), ptToolRef-vecX0*(dTopPlateThick + dMillDepth + U(7)), .5*dPipeDrillDia + U(7));
		bm0.addTool(drPipe);
		bm0.addTool(drWelding);
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
	String sHWChangeProps[] = {sArticleName, sMillDepthName, sFemaleToolName, sExitDepthName, sFixingScrewLengthName};
	
// get previous screw length, to have a trigger in case of tool change at female beam
	double dScrewLengthPrev = _Map.getDouble("ScrewLength");
		
	
	if (_bOnDbCreated || dScrewLengthPrev != dMainScrewLength || sHWChangeProps.find(_kNameLastChangedProp) > -1)
	{
		HardWrComp hwComps[0];	
		
		String sModel;
		if (nArticle != 3)
			sModel = "SPP - " + T("|Connector|");
		else
			sModel = "SPP 80 - " + T("|Connector|");
			
		String sDescription = T("|Connector|") + " - M" + dThreadDia;
			
		HardWrComp hw(sArticle , 1);	
		hw.setCategory(T("|Connector|"));
		hw.setManufacturer("Pitzl");
		hw.setModel(sModel);
		hw.setMaterial(sMaterial);
		hw.setDescription(sDescription);
		hw.setDScaleX(dTopPlateDia);
		hw.setDScaleY(dTopPlateDia);
		hw.setDScaleZ(dTopPlateThick+dPipeLength);	
		hwComps.append(hw);
		
		HardWrComp hwFixingScrew(sFixingScrewArticle, nFixingScrewQuant);	
		hwFixingScrew.setCategory(T("|Connector|"));
		hwFixingScrew.setManufacturer("Pitzl");
		hwFixingScrew.setModel(dFixingScrewDia + " x " + dFixingScrewLength);
		hwFixingScrew.setMaterial(T("|Steel, zincated|"));		
		hwFixingScrew.setDescription(sFixingScrewName + " " + dFixingScrewDia + " x " + dFixingScrewLength);
		hwFixingScrew.setDScaleX(dFixingScrewLength);
		hwFixingScrew.setDScaleY(dFixingScrewDia);
		hwFixingScrew.setDScaleZ(0);	
		hwComps.append(hwFixingScrew);	
		
		if (nFemaleTool == 1)
		{
			HardWrComp hwMainScrew("---", 1);	
			hwMainScrew.setCategory(T("|Connector|"));
			hwMainScrew.setManufacturer("DIN 975");
			hwMainScrew.setModel("M" + dThreadDia + " x " + dMainScrewLength);
			hwMainScrew.setMaterial(T("|Steel, zincated|"));		
			hwMainScrew.setDescription(sMainScrewName + " " + dThreadDia + " x " + dMainScrewLength);
			hwMainScrew.setDScaleX(dMainScrewLength);
			hwMainScrew.setDScaleY(dThreadDia);
			hwMainScrew.setDScaleZ(0);	
			hwComps.append(hwMainScrew);	
			
			HardWrComp hwMainWasher("---", 1);	
			hwMainWasher.setCategory(T("|Connector|"));
			hwMainWasher.setManufacturer("DIN 9021");
			hwMainWasher.setModel(dMainWasherDia + " x " + dMainWasherHeight);
			hwMainWasher.setMaterial(T("|Steel, zincated|"));		
			hwMainWasher.setDescription(sMainWasherName + " " + dMainWasherDia + " x " + dMainWasherHeight);
			hwMainWasher.setDScaleX(dMainWasherDia);
			hwMainWasher.setDScaleY(dMainWasherHeight);
			hwMainWasher.setDScaleZ(0);	
			hwComps.append(hwMainWasher);
			
			HardWrComp hwMainNut("---", 1);	
			hwMainNut.setCategory(T("|Connector|"));
			hwMainNut.setManufacturer("DIN 934");
			hwMainNut.setModel("M" + dThreadDia);
			hwMainNut.setMaterial(T("|Steel, zincated|"));		
			hwMainNut.setDescription(sMainNutName + " M" + dThreadDia);
			hwMainNut.setDScaleX(dMainNutSW);
			hwMainNut.setDScaleY(0);
			hwMainNut.setDScaleZ(dMainNutHeight);	
			hwComps.append(hwMainNut);
		}
		
		_ThisInst.setHardWrComps(hwComps);
	}

// Display
	
Display dp(8);

dp.draw(bdConnector);

if (nFemaleTool == 1)
{
	dp.draw(bdScrew);
	dp.draw(bdWasher);
	dp.draw(bdNut);
}

// Map screw length
_Map.setDouble("ScrewLength", dMainScrewLength);
#End
#BeginThumbnail
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
KK#J#66FC:I;CR[?5,1#H&!KH**`,.VT"5;Z.[NKUI9$;(&.M;E%%`'__V>'[
`



#End
#BeginMapX

#End