#Version 8
#BeginDescription
#Versions
Version 1.3 28.10.2025 HSB-24838 sequence of fastener article data entries ordered by length

Version 1.2 21.10.2025 HSB-24585 automatic replacement invalid characters of style name (comma, slash, backslash) 
Version 1.1 20.05.2025 HSB-24054 accepting filter as input when creating styles
Version 1.0 19.05.2025 HSB-24055 report layout improved

Version 0.44 11.04.2025 HSB-22816 commas refused
Version 0.43 08.04.2025 HSB-22859 copy behaviour improved
Version 0.42 17.03.2025 HSB-23716 supporting simple wireframe and thread display
Version 0.41 12.02.2025 HSB-23512 adopted to new behaviour of controlling properties
Version 0.40 06.12.2024 HSB-22860 drill depth on tilted drills fixed
Version 0.39 29.11.2024 HSB-22866 drill added to primary beam if no secondary found
Version 0.38 11/18/2024 HSB-22946 Updating path to FastenerManager.dll cc
Version 0.37 11/18/2024 Updating path to FastenerManager.dll cc
Version 0.36 08.11.2024 HSB-22935 style creation can fired without selecting an instance if executeKey is set to EditStyle
Version 0.35 08.11.2024 HSB-22850 sink hole fixed
Version 0.34 26.09.2024 HSB-22727 jig axis orientation fixed
Version 0.33 20.09.2024 HSB-21509 hardware export added, additional entities on insert, HSB-22702 hardware partially translated
Version 0.32 17.09.2024 HSB-22689 incremental rotation fixed
Version 0.30 10.09.2024 HSB-22599 made dependent to faster assembly definition style
Version 0.31 17.09.2024 HSB-22689 workaround for anchoring to tool ent

















#End
#Type O
#NumBeamsReq 1
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
#KeyWords 
#BeginContents
//region Part #1

//region <History>
// #Versions
// 1.3 28.10.2025 HSB-24838 sequence of fastener article data entries ordered by length , Author Thorsten Huck
// 1.2 21.10.2025 HSB-24585 automatic replacement invalid characters of style name (comma, slash, backslash) , Author Thorsten Huck
// 1.1 20.05.2025 HSB-24054 accepting filter as input when creating styles , Author Thorsten Huck
// 1.0 19.05.2025 HSB-24055 report layout improved , Author Thorsten Huck
// 0.44 11.04.2025 HSB-22816 commas refused  , Author Thorsten Huck
// 0.43 08.04.2025 HSB-22859 copy behaviour improved , Author Thorsten Huck
// 0.42 17.03.2025 HSB-23716 supporting simple wireframe and thread display , Author Thorsten Huck
// 0.41 12.02.2025 HSB-23512 adopted to new behaviour of controlling properties , Author Thorsten Huck
// 0.40 06.12.2024 HSB-22860 drill depth on tilted drills fixed , Author Thorsten Huck
// 0.39 29.11.2024 HSB-22866 drill added to primary beam if no secondary found , Author Thorsten Huck
// 0.38 11/18/2024 HSB-22946 Updating path to FastenerManager.dll cc
// 0.36 08.11.2024 HSB-22935 style creation can fired without selecting an instance if executeKey is set to EditStyle , Author Thorsten Huck
// 0.35 08.11.2024 HSB-22850 sink hole fixed , Author Thorsten Huck
// 0.34 26.09.2024 HSB-22727 jig axis orientation fixed , Author Thorsten Huck
// 0.33 20.09.2024 HSB-21509 hardware export added, additional entities on insert, HSB-22702 hardware partially translated , Author Thorsten Huck
// 0.32 17.09.2024 HSB-22689 incremental rotation fixed , Author Thorsten Huck
// 0.31 17.09.2024 HSB-22689 workaround for anchoring to tool ent , Author Thorsten Huck
// 0.30 10.09.2024 HSB-22599 made dependent to faster assembly definition style , Author Thorsten Huck

/// <insert Lang=en>
/// Select entities
/// </insert>

// <summary Lang=en>
// This tsl creates a drill in a set of intersecting genbeams
// It provides methods to maintain or create fastener assembly definitions
// </summary>

// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "SimpleFastener")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Add/Edit Fastener (Double Click)|") (_TM "|Select SimpleFastener|"))) TSLCONTENT
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

	String sDialogLibrary = _kPathHsbInstall + "\\Utilities\\DialogService\\TslUtilities.dll";
	String sClass = "TslUtilities.TslDialogService";	
	String listSelectorMethod = "SelectFromList";
	String optionsMethod = "SelectOption";
	String simpleTextMethod = "GetText";
	String askYesNoMethod = "AskYesNo";
	String showNoticeMethod = "ShowNotice";
	String showMultilineNotice = "ShowMultilineNotice";
	String showDynamic = "ShowDynamicDialog";

	String kFastenerLib = _kPathHsbInstall + "\\Utilities\\FastenerManager\\FastenerManager.dll";
	String kFastenerClass = "FastenerManager.TslConnector";
	String kGetManufacturers = "GetManufacturers";
	String kGetManufacturersList = "GetManufacturersList";
	String kGetScrewListWithFilter = "GetScrewListWithFilter";
	String kGetScrewListWithSearch = "GetScrewListWithSearch";
	String kShowFastenerSelectorCommand = "ShowFastenerSelectorDialog";
	String kShowDatabaseManagerCommand = "ShowFastenerManager";	
	String kSelectedScrewsKey = "SelectedScrews";
	String kVerifyDatabaseExistsMethod = "VerifyDatabaseExists";
	String kGetLastDatabasePathMethod = "GetLastDatabasePath";

	String kManufacturer = "Manufacturer", kFamily = "Family", kDiameter= "Diameter", kModel = "Model", kLength = "Length";
	String sExistingFastenerAssemblyDefs[] = FastenerAssemblyDef().getAllEntryNames().sorted();

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

	int darkyellow3D = bIsDark?rgb(157, 137, 88):rgb(254,234,185);

	Vector3d vecXView = getViewDirection(0);
	Vector3d vecYView = getViewDirection(1);
	Vector3d vecZView = getViewDirection(2);
	double dViewHeight = getViewHeight();

//endregion 	
	
//end Constants//endregion

//region JIGS

//region Rotation Trigger Jigs and Functions


//region Function GetGripByName
	// returns the grip index if found in array of grips
	// name: the name of the grip or the the name of the grip stored in streamed map
	int GetGripByName(Grip grips[], String name)
	{ 
		int out = - 1;
		for (int i=0;i<grips.length();i++) 
		{ 
			String nameGrip = grips[i].name();
			Map m;
			int bHasMap = m.setDxContent(nameGrip, true);
			if (!bHasMap && grips[i].name()== nameGrip)
			{
				out = i;
				break;
			}			
			else if (bHasMap)
			{ 
				nameGrip = m.getMapName().makeUpper();
				if (name.makeUpper()== nameGrip)
				{ 
					out = i;
					break;					
				}
			}			
		}//next i
		return out;
	}//endregion


//region Function GetClosestCircle
	// returns the index of the closest circle
	int GetClosestCircle(Point3d pt, PLine circles[])
	{ 
	    double dMin = U(10e6);
	    int n;
	    for (int i=0;i<circles.length();i++) 
	    { 	
	    	double d = (circles[i].closestPointTo(pt)-pt).length();
	    	if (d<dMin)
	    	{ 
	    		dMin = d;
	    		n = i;
	    	}	    	 
	    }//next i
	    
	    return n;
	}//endregion

//region Function AlignCoordSysView
	// returns
	CoordSys AlignCoordSysView(Point3d ptOrg, Vector3d vecX, Vector3d vecY, Vector3d vecZ)
	{ 
    	if (vecZ.dotProduct(vecZView)<0)
    	{ 
    		vecX *= -1;
    		vecZ *= -1;		    		
    	}
    	CoordSys cs(ptOrg, vecX, vecY, vecZ);
    	
    	return cs;
	}//endregion	

//region Function GetCoordSysCircles
	// returns circles perpendicular to each vector of the coordSys
	PLine[] GetCoordSysCircles(CoordSys cs, double diameter)
	{ 
		Point3d pt = cs.ptOrg();
		PLine circle, circles[0];
	    circle.createCircle(pt, cs.vecX(), diameter);
	    circles.append(circle);
	    circle.createCircle(pt, cs.vecY(), diameter);
	    circles.append(circle);
	    circle.createCircle(pt, cs.vecZ(), diameter);
	    circles.append(circle);
	    
	    return circles;
	}//endregion

//region Function GetAngle
	// returns the rotation angle snapping to differnt grids based on the offset
	// vecDir: not normalized, the direction vector to derive the angle to vecRef
	// vecRef: the refrence vector
	// vecZ: used to distinguish neg/pos in the range of +-180°
	// diameter: the preview circle size
	// gridAngle: the angle increment derived from the selected offset, 0=full precision
	double GetAngle(Vector3d vecDir, Vector3d vecRef, Vector3d vecZ, double diameter, double& gridAngle)
	{ 

		double offset = vecDir.length();
		vecDir.normalize();
		double angle = vecRef.angleTo(vecDir) *(vecZ.dotProduct(vecRef.crossProduct(vecDir))<0?-1:1);
			
		if (offset>2*diameter)			gridAngle = 1;
		else if (offset>1.5*diameter)	gridAngle = 5;
		else if (offset>1.0*diameter)	gridAngle = 10;		
		else if (offset>0.5*diameter)	gridAngle = 22.5;
		else							gridAngle = 45;

		if (offset<2.5*diameter)
			angle = round(angle / gridAngle) * gridAngle;
		else
			gridAngle = 0;
		return angle;
	}//endregion

//region Function GetTextFlags
	// returns
	// t: the tslInstance to 
	void GetTextFlags(Vector3d vecDir, Vector3d vecRef, double& xFlag, double& yFlag)
	{ 
	    if(vecDir.isPerpendicularTo(vecRef))
	    	xFlag = 0;
	    else
	    	xFlag = vecDir.dotProduct(vecXView)<0?-1:1;

	    if(vecDir.isParallelTo(vecRef))
	    	yFlag = 0;
	    else
	    	yFlag = vecDir.dotProduct(vecYView)<0?-1:1;
	   
		return;
	}//endregion


//region Jig SelectAxis
	String kJigSelectAxis = "JigSelectAxis";
	if (_bOnJig && _kExecuteKey==kJigSelectAxis) 
	{
	    Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point		

		PlaneProfile pp = _Map.getPlaneProfile("pp");
		CoordSys cs = pp.coordSys();
		Point3d pt = cs.ptOrg();
		Vector3d vecX = cs.vecX();
		Vector3d vecY = cs.vecY();
		Vector3d vecZ = cs.vecZ();
		Plane pn(pt, vecZView);
		Line(ptJig, vecZView).hasIntersection(pn, ptJig);

		Display dp(-1);
		dp.addViewDirection(vecZView);
	    int colors[] = { 1, 3, 150};
	    
	    double diameter = dViewHeight * .15;
	    PLine circles[] = GetCoordSysCircles(cs, diameter);
  
	    double dMin = U(10e6);
	    int n = GetClosestCircle(ptJig, circles);

	    for (int i=0;i<circles.length();i++)
	    { 
	    	PLine circle = circles[i];
	    	circle.convertToLineApprox(dEps);	    	
	    	dp.color(colors[i]);
	    	if (n==i)
	    	{
	    		dp.draw(PlaneProfile(circle), _kDrawFilled, 80);
	    		dp.trueColor(darkyellow);
	    	}
	    	dp.draw(circles[i]);//, _kDrawFilled, n==i?30:60);
	    }
	    
	    return;
	}
//endregion  

//region Jig Rotation
	String kJigRotation = "JigRotation";
	if (_bOnJig && _kExecuteKey==kJigRotation) 
	{
	    Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point		
		int indexAxis = _Map.getInt("indexAxis");
		PlaneProfile pp = _Map.getPlaneProfile("pp");
		CoordSys cs = pp.coordSys();
		Point3d pt = cs.ptOrg();
		Vector3d vecX = cs.vecX();
		Vector3d vecY = cs.vecY();
		Vector3d vecZ = cs.vecZ();
		Plane pn(pt, vecZ);
		Line(ptJig, vecZView).hasIntersection(pn, ptJig);

	    int colors[] = { 1, 3, 150};
	    
	    double diameter = dViewHeight * .15;
	    PLine circles[0], circle;
	    circle.createCircle(pt, vecZ, diameter);
	    circles.append(circle);

		Vector3d vecJig = ptJig - pt;
		
		double dGridAngle;
		double angle = GetAngle(vecJig, vecX, vecZ, diameter, dGridAngle);
		double dJigLength = vecJig.length();

		
		CoordSys rot;
		rot.setToRotation(angle, vecZ, pt);
		Vector3d vecDir = vecX;
		vecDir.transformBy(rot);
		Vector3d vecMid = vecX + vecDir; vecMid.normalize();
		Point3d ptOnArc = circle.closestPointTo(pt +vecMid * diameter);

		PLine plSector(vecZ);
		plSector.addVertex(pt);
		plSector.addVertex(pt + vecX * diameter);
		plSector.addVertex(pt + vecDir * diameter, ptOnArc);	
		plSector.close();

	    Display dp(-1);
	    double textHeight = dViewHeight * .05;
	    dp.textHeight(textHeight);
	        
	    if (indexAxis>0 && indexAxis<3)
	    	dp.color(colors[indexAxis]);	    
	    dp.draw(plSector);
	    
	    
		dp.trueColor(lightblue,80);
		double diamGrid;
	    if (dJigLength>diameter) // 10°
	    { 
	    	diamGrid = diameter * 1.5;
	    	circle.createCircle(pt, vecZ, diamGrid);
	    	dp.draw(circle);
	    }	    
	    if (dJigLength>diameter*1.5)
	    { 
	    	diamGrid = diameter * 2;
	    	circle.createCircle(pt, vecZ, diamGrid);
	    	dp.draw(circle);
	    }		    
	    if (dJigLength>diameter*2)
	    { 
	    	diamGrid = diameter * 2.5;
	    	circle.createCircle(pt, vecZ, diamGrid);
	    	dp.draw(circle);
	    }		    
	    
	    Body bd = _Map.getBody("bd");
	    bd.transformBy(rot);
	    dp.draw(bd);
	    
	    Point3d ptTxt = pt + vecDir * (diameter + .5 * textHeight);
	    if(diamGrid>0)
	    { 
		    if (indexAxis>0 && indexAxis<3)
		    	dp.color(colors[indexAxis]);
		    Point3d pt2 = pt + vecDir * (diamGrid);
		    Point3d pt1 = pt2 -vecDir* .5 * diameter;
		    dp.transparency(0);
		    dp.draw(PLine(pt1, pt2));
		    ptTxt = pt2 + vecDir * .5 * textHeight;
	    }	    
	    
	    
	    
	    dp.trueColor(darkyellow);
	    dp.transparency(0);
	    if (abs(angle)>0)
	    { 
		    plSector.convertToLineApprox(dEps);
		    dp.draw(PlaneProfile(plSector), _kDrawFilled, 40);
		}   
		{ 
		    double xFlag, yFlag;
		    GetTextFlags(vecDir, vecX,xFlag, yFlag);
		    dp.draw(angle+"°", ptTxt, vecXView, vecYView, xFlag, yFlag);	   			
		}


	// draw grid angle
		dp.trueColor(lightblue);
		if (dGridAngle>0)
		{ 
			dp.textHeight(.75 * textHeight);			
			double xFlag, yFlag;
		    GetTextFlags(-vecMid,vecX, xFlag, yFlag);		
			dp.draw(dGridAngle+"°", pt-vecMid*.375*textHeight, vecXView, vecYView, xFlag, yFlag);
		}

	    return;
	}//endregion 

//region Jig ReferenceLine
	String kJigReferenceLine = "JigReferenceLine";
	if (_bOnJig && _kExecuteKey==kJigReferenceLine) 
	{
	    Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point		
		int indexAxis = _Map.getInt("indexAxis");
		PlaneProfile pp = _Map.getPlaneProfile("pp");
		CoordSys cs = pp.coordSys();
		Point3d pt = cs.ptOrg();
		Vector3d vecX = cs.vecX();
		Vector3d vecY = cs.vecY();
		Vector3d vecZ = cs.vecZ();
		Plane pn(pt, vecZ);
		Line(ptJig, vecZView).hasIntersection(pn, ptJig);

	    int colors[] = { 1, 3, 150};
	    
	    double diameter = dViewHeight * .15;
	    PLine circle;
	    circle.createCircle(pt, vecZ, diameter);
		Vector3d vecB = ptJig - pt; vecB.normalize();

	    
	    Display dp(-1);
 
	    if (indexAxis>0 && indexAxis<3)dp.color(colors[indexAxis]);	    
	    dp.draw(circle);	    
	    dp.trueColor(lightblue);
	    circle.convertToLineApprox(dEps);
	    dp.draw(PlaneProfile(circle), _kDrawFilled, 60);

		dp.trueColor(red);		
	    dp.draw(PLine (pt, pt+vecB*diameter));

	    
//	    dp2.draw(PLine(pt, pt + vecB * diameter));
	    return;
	}//endregion 
		
//END Rotation Trigger Jigs and Functions //endregion 


//region Get Face Jigs and Functions


//region Function SetPlaneProfilesToMap
	// stores an array of planeprofiles in map
	Map SetPlaneProfilesToMap(PlaneProfile pps[])
	{ 
		Map mapOut;
		for (int i=0;i<pps.length();i++) 
			mapOut.appendPlaneProfile("pp"+i,pps[i]); 
		return mapOut;
	}//endregion

//region Function SetPlaneProfilesFromMap
	// returns an array of planeprofiles stored in map
	PlaneProfile[] SetPlaneProfilesFromMap(Map mapIn)
	{ 
		PlaneProfile pps[0];
		for (int i=0;i<mapIn.length();i++) 
			if (mapIn.hasPlaneProfile(i))
				pps.append(mapIn.getPlaneProfile(i)); 
		return pps;
	}//endregion



//region Function GetFaceProfiles
	// returns the front/back faces
//	PlaneProfile[] GetFaceProfiles(Point3d ptx, Map mapFaces, int& index, int bFront)
//	{ 
//		PlaneProfile pps[0];
//		for (int i = 0; i < mapFaces.length(); i++)
//		{
//			PlaneProfile pp = mapFaces.getPlaneProfile(i);
//			CoordSys cs = pp.coordSys();
//			Vector3d vecZ = cs.vecZ();
//			Point3d ptOrg = cs.ptOrg();
//			
////			Display dpx(i);
////			dpx.draw(PLine(pp.ptMid(), pp.ptMid() + vecZ * U(200)));
//
//			double dFront = vecZ.dotProduct(vecZView);
//			if ((dFront > 0 && bFront) || (dFront < 0 && !bFront))
//			{
//				Point3d pt = ptx;
//				Line(ptx, vecZView).hasIntersection(Plane(ptOrg, vecZ), pt);//
//				if (pp.pointInProfile(pt)==_kPointInProfile)
//					index = pps.length();
//				pps.append(pp);
//			}
//		}
//		return pps;
//	}//endregion

//region Function GetPlanessBeamEnd
	// returns the planes at the end of a beam, if no cuts found the box shape will be assumed
	Plane[] GetPlanesBeamEnd(Beam bm, Vector3d vecDir, PlaneProfile& pps[])
	{ 
		Plane planes[0];
		pps.setLength(0);
		
		Point3d ptCen = bm.ptCenSolid();
		Vector3d vecX = bm.vecX();
		Vector3d vecY = bm.vecY();
		if(bm.bIsCutStraight(vecDir.dotProduct(vecX)>0))
		{ 
			Plane pn(ptCen + vecDir * .5 * bm.solidLength(), vecDir);
			planes.append(pn);
			pps.append(bm.envelopeBody(false, true).extractContactFaceInPlane(pn, dEps));
		}
		else
		{ 
			AnalysedTool tools[] = bm.analysedTools();
			AnalysedCut cuts[] = AnalysedCut().filterToolsOfToolType(tools);
			for (int i=0;i<cuts.length();i++) 
			{ 
				AnalysedCut cut = cuts[i];
				Vector3d vecNormal = cut.normal();
				if(cut.toolSubType()==_kACHip || vecNormal.dotProduct(vecDir)<0)
				{
					continue;
				}
				Plane pn(cut.ptOrg(), vecNormal);
				PLine pl; pl.createConvexHull(pn,cut.bodyPointsInPlane());
				
				Vector3d vecXE = vecY.crossProduct(vecNormal);
				Vector3d vecYE = vecXE.crossProduct(-vecNormal);
				CoordSys cse(cut.ptOrg(), vecXE, vecYE, vecNormal);
				PlaneProfile pp(cse);
				pp.joinRing(pl, _kAdd);
				pps.append(pp);
				planes.append(pn);
			}//next i			
		}
		return planes;
	}//endregionbisst

//region Function GetFacePlaneProfiles
	// returns the planeprofiles of all envelope faces
	// vecDir: only faces with a positive normal are taken, zero length = all
	PlaneProfile[] GetFacePlaneProfiles(GenBeam gb, Vector3d vecDir)
	{ 
		PlaneProfile pps[0];
		
		Point3d ptCen = gb.ptCen();
		Vector3d vecX = gb.vecX();
		Vector3d vecY = gb.vecY();
		Vector3d vecZ = gb.vecZ();		
		double dZ = gb.dH();
		
		int bAll = vecDir.bIsZeroLength();
		
		Body bd = gb.envelopeBody(false, true);
		
		Beam bm = (Beam)gb;
		Sip clt = (Sip)gb;
		Sheet sheet = (Sheet)gb;
		Quader qdr(ptCen, vecX, vecY, vecZ, gb.solidLength(), gb.solidWidth(), gb.solidHeight(), 0, 0, 0);

		Plane pnFaces[0];
	
		pnFaces.append(qdr.plFaceD(-vecZ));
		pnFaces.append(qdr.plFaceD(vecZ));
		if (bm.bIsValid())
		{	
			pnFaces.append(qdr.plFaceD(-vecY));
			pnFaces.append(qdr.plFaceD(vecY));
	
		// append straight ends 
			int bIsStraights[]= { bm.bIsCutStraight(false), bm.bIsCutStraight(true)};
			int numStraight;
			{ 
				double dX= .5 * bm.solidLength();
				for (int i=0;i<bIsStraights.length();i++) 
				{ 
					if (!bIsStraights[i])
					{
						continue;
					}
					numStraight++;

					Vector3d vecXi = vecX * (i == 0 ?- 1 : 1);
					if (!bAll && (vecDir.isPerpendicularTo(vecXi) || vecDir.dotProduct(vecXi)<0)){ continue;}
					Point3d ptFace = ptCen + vecXi * dX;
					Plane pn(ptFace, vecXi);
					PlaneProfile pp(CoordSys(ptFace, -vecY, vecZ, vecXi));
					pp.unionWith(bd.extractContactFaceInPlane(pn, dEps));
					
					if (pp.area()>pow(dEps, 2))pps.append(pp);
					
				}//next i
			}
		// append beveled cuts
			if (numStraight<2)
			{ 
				AnalysedTool tools[] = bm.analysedTools();
				AnalysedCut cuts[] = AnalysedCut().filterToolsOfToolType(tools);
				for (int i=0;i<cuts.length();i++) 
				{ 
					AnalysedCut cut = cuts[i];
					Vector3d vecZi = cut.normal();
					
//					if (cut.toolSubType()==_kACPerpendicular && vecZi.isCodirectionalTo(-vecX) && bIsStraights[0]){ continue;}
//					if (cut.toolSubType()==_kACPerpendicular && vecZi.isCodirectionalTo(vecX) && bIsStraights[1]){ continue;}
	
					if(cut.toolSubType()==_kACHip)// || cut.toolSubType()==_kACPerpendicular)
					{
						continue;
					}
					if (!bAll && (vecDir.isPerpendicularTo(vecZi) ||  vecDir.dotProduct(vecZi)<0))
					{
						continue;
					}
					Plane pn(cut.ptOrg(), vecZi);	
					Vector3d vecXi = vecY.crossProduct(vecZi);
					Vector3d vecYi = vecXi.crossProduct(-vecZi);
					CoordSys csi(cut.ptOrg(), vecXi, vecYi, vecZi);
					PlaneProfile pp(csi);
					pp.unionWith(bd.extractContactFaceInPlane(pn, dEps));

					if (pp.area()>pow(dEps, 2))
					{
						//{ Display dpx(2); dpx.draw(pp,_kDrawFilled, 40);}
						pps.append(pp);
					}
				}//next i				
			}	
		}
		else if (clt.bIsValid())
		{			
			SipEdge edges[] = clt.sipEdges();
			
			for (int i=0;i<edges.length();i++) 
			{ 
				SipEdge e= edges[i]; 
				Vector3d vecZi = e.vecNormal();
				if (!bAll && (vecDir.isPerpendicularTo(vecZi) || vecDir.dotProduct(vecZi)<0))
				{
					continue;
				}
				
				Vector3d vecXi = vecZ.crossProduct(vecZi);
				Vector3d vecYi = vecZi.crossProduct(vecXi);
				Plane pn(e.ptMid(),vecZi);
				PlaneProfile pp(CoordSys(e.ptMid(), vecXi, vecYi, vecZi));
				pp.unionWith(bd.extractContactFaceInPlane(pn, dEps));
				if (pp.area()>pow(dEps, 2))	pps.append(pp);	
			}//next i	
		}	
		else if (sheet.bIsValid())
		{
			PLine plEnvelope = sheet.plEnvelope();
			Point3d pts[] = plEnvelope.vertexPoints(false);
			for (int i=0;i<pts.length()-1;i++) 
			{ 
				Point3d pt1 = pts[i];
				Point3d pt2 = pts[i+1];
				Point3d ptm = (pt1 + pt2) * .5;
				Vector3d vecXi = pt1 - pt2; vecXi.normalize();
				Vector3d vecZi = vecXi.crossProduct(-vecZ);	
				pnFaces.append(Plane(ptm,vecZi));			 
			}//next i
		}		

	// Collect contact faces in specified planes
		for (int i=0;i<pnFaces.length();i++) 
		{ 
			Plane pn = pnFaces[i];
			pn.vis(i);
			
			Vector3d vecZi = pn.normal();
			if (!bAll && (vecDir.isPerpendicularTo(vecZi) || vecDir.dotProduct(vecZi)<0))
			{
				
				continue;
			}
			double dd = vecDir.dotProduct(vecZi);
			vecDir.vis(pn.ptOrg(), 150);
			
			Vector3d vecXi = vecX.isParallelTo(vecZi) ? vecY : vecX;
			Vector3d vecYi = vecXi.crossProduct(-vecZi);
			PlaneProfile pp(CoordSys(pn.ptOrg(), vecXi, vecYi, vecZi));
			pp.unionWith(bd.extractContactFaceInPlane(pn, U(1))); 
			if(pp.area()<pow(dEps,2))	pp = bd.shadowProfile(pn);
			if(pp.area()>pow(dEps,2))	pps.append(pp);;
		}//next i

		return pps;
	}//endregion

//region Function SetGenBeamFaces
	// returns the faces of the genbeam as profiles
	Map SetGenBeamFaces(GenBeam gb)
	{ 
		int bIsOrthoView = gb.vecD(vecZView).isParallelTo(vecZView);	
		Vector3d vecFace = bIsOrthoView?vecZView:gb.vecD(vecZView);
		int nFaceIndex = - 1;
		
		Point3d ptCen = gb.ptCen();
		Vector3d vecX = gb.vecX();
		Vector3d vecY = gb.vecY();
		Vector3d vecZ = gb.vecZ();
		
		

		Quader qdr(ptCen, vecX, vecY, vecZ, gb.solidLength(), gb.solidWidth(), gb.solidHeight(), 0, 0, 0);
		Sip clt = (Sip)gb;
		Sheet sheet = (Sheet)gb;
		Beam beam = (Beam)gb;
		
		Body bd = gb.envelopeBody(false, true);
		Map mapFaces;
		
		Plane pnFaces[0];
		Vector3d vecFaces[0];
			
		pnFaces.append(qdr.plFaceD(-vecZ));
		pnFaces.append(qdr.plFaceD(vecZ));		
		if (beam.bIsValid())
		{	
			pnFaces.append(qdr.plFaceD(vecY));
			pnFaces.append(qdr.plFaceD(-vecY));
			
			PlaneProfile pps[0];// not required here
			pnFaces.append(GetPlanesBeamEnd(beam, vecX, pps));
			pnFaces.append(GetPlanesBeamEnd(beam, -vecX, pps));		
		}
		else if (clt.bIsValid())
		{			
			SipEdge edges[] = clt.sipEdges();
			for (int i=0;i<edges.length();i++) 
			{ 
				SipEdge e= edges[i]; 
				pnFaces.append(Plane(e.ptMid(), e.vecNormal()));			 
			}//next i
		}	
		else if (sheet.bIsValid())
		{
			PLine plEnvelope = sheet.plEnvelope();
			Point3d pts[] = plEnvelope.vertexPoints(false);
			for (int i=0;i<pts.length()-1;i++) 
			{ 
				Point3d pt1 = pts[i];
				Point3d pt2 = pts[i+1];
				Point3d ptm = (pt1 + pt2) * .5;
				Vector3d vecXS = pt1 - pt2; vecXS.normalize();
				Vector3d vecYS = vecXS.crossProduct(-vecZ);				
				pnFaces.append(Plane(ptm,vecYS));			 
			}//next i
		}		

		PlaneProfile ppFace,pps[0];//yz-y-z
		for (int i=0;i<pnFaces.length();i++) 
		{ 
			Plane pn = pnFaces[i];
			
			PlaneProfile pp = bd.extractContactFaceInPlane(pn, U(1)); 
			if(pp.area()<pow(dEps,2))
				pp = bd.shadowProfile(pn);
			pps.append(pp);
			mapFaces.appendPlaneProfile("pp", pp);
			
			if (bIsOrthoView && vecFace.isCodirectionalTo(pn.normal()))
			{
				nFaceIndex = i;
				ppFace = pp;
				mapFaces.setInt("FaceIndex", nFaceIndex);
			}
			
		}//next i

		return mapFaces;
	}//endregion

//region Function DrawFaces
	// draws the planeprofile on the face of the referenced entity
	void DrawFaces(PlaneProfile pps[], int index)
	{ 
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
				dp.trueColor(i == index?darkyellow:lightblue,bIsDark?50:75);				
			}
			dp.draw(pp, _kDrawFilled);
			
			
			//dp.draw(PLine (pp.ptMid(), pp.ptMid() + pp.coordSys().vecZ() * U(200)));	
		}//next i

		return;

	}//endregion

//region Function GetViewPlaneProfiles
	// returns the planeprofiles which allign with the view or opposite view direction
	PlaneProfile[] GetPlaneProfilesViewDirection(PlaneProfile ppsIn[], Vector3d vecDir, Point3d ptLoc, int& indexLoc)
	{
		PlaneProfile pps[0];
		for (int i=0;i<ppsIn.length();i++) 
		{
			PlaneProfile pp = ppsIn[i];
			CoordSys cs = pp.coordSys();
			Vector3d vecZ = cs.vecZ();

			if (vecZ.isPerpendicularTo(vecDir))continue;
			
			Point3d ptOrg = cs.ptOrg();

			Point3d pt = ptLoc;

			if(vecZ.dotProduct(vecDir)>0)// accept only profiles in view direction or opposite
			{
				pps.append(pp);
				Line(pt, vecDir).hasIntersection(Plane(ptOrg, vecZ), pt);
				if (pp.pointInProfile(pt)!=_kPointOutsideProfile)//==_kPointInProfile)
				{
					indexLoc = pps.length()-1;
				}
			}
			
//			PLine pl(pp.ptMid(), pp.ptMid() + vecZ * U(500));
//			Display dpx(3);
//			dpx.draw(pl);
			
			
		} 		
		return pps;
	}//endregion




//region Jig Select Face	
	String kShowFront = "showFront";
	String kJigSelectFace = "SelectFace";		
		
	if (_bOnJig && _kExecuteKey== kJigSelectFace) 
	{
		Point3d ptJig = _Map.getPoint3d("_PtJig"); //running point
		int bFront = ! _Map.hasInt(kShowFront) ? true : _Map.getInt(kShowFront);
		Vector3d vecDir = vecZView * (bFront ? 1 :- 1);
		PlaneProfile pps[] = SetPlaneProfilesFromMap(_Map.getMap("Face[]"));

		int index = - 1;
		pps = GetPlaneProfilesViewDirection(pps, vecDir, ptJig, index);
		DrawFaces(pps, index);

		return;		
	}
//endregion

//Get Face Jigs and Functions //endregion 


//region Jig PickLocation	
	String kJigPickLocation = "PickLocation";		

	if (_bOnJig && _kExecuteKey== kJigPickLocation) 
	{
		Point3d ptJig = _Map.getPoint3d("_PtJig"); //running point
		int bIsOrtho = _Map.getInt("isOrtho");
		
		
		PlaneProfile ppFace = _Map.getPlaneProfile("pp");
		CoordSys cs = ppFace.coordSys();
		Vector3d vecX = cs.vecX();
		Vector3d vecY = cs.vecY();
		Vector3d vecZ = cs.vecZ();
		
		Point3d ptFace = cs.ptOrg();
		Plane pnFace(ptFace, vecZ);
		int nSnapType = _Map.getInt("SnapType");
		double dSnapOffset = _Map.getInt("SnapOffset");
		double dDiameter = _Map.getDouble("Diameter");
		if (dDiameter <= 0)dDiameter = U(10);
		
//		Point3d ptLoc = ptJig;
//		Line(ptLoc, cs.vecZ()).hasIntersection(pnFace, ptLoc);
//		    
//
		Display dp(-1);
		dp.trueColor(darkyellow);
		

		PLine c; c.createCircle(ptJig, vecZ, dDiameter*.5);
		c.convertToLineApprox(dEps);
		PlaneProfile ppc(c);
		ppc.project(pnFace, vecZ, dEps);
		
		PlaneProfile ppTest = ppc;
		if (ppTest.intersectWith(ppFace))
		{ 
			dp.draw(ppc,_kDrawFilled, 60);
			dp.draw(ppc);			
		}
		else
		{ 
			dp.trueColor(red);
			dp.draw(c);	
		}

		if (bIsOrtho)
		{ 
			Vector3d vecFace = _Map.getVector3d("vecFace");
			dp.trueColor(vecFace.isCodirectionalTo(vecZView)?darkyellow:lightblue);
			dp.draw(ppFace,_kDrawFilled, 80);
		}

		return;		
	}
//endregion



//JIGS //endregion

//region FUNCTIONS

//region General Functions

//region Function PrintMap
	// iterates thru map and appends content as text
	void PrintMap(String& text, Map map, int level)
	{ 
		for (int i=0;i<map.length();i++)
		{ 
			text += "\n";
			for (int j=0;j<level;j++) 
				text += "   ";			
			if (map.hasMap(i))
			{ 
				text += map.keyAt(i);
				PrintMap(text, map.getMap(i), level + 1);
			}
			else
			{
				text +=  map.keyAt(i)+": " + (map.hasDouble(i) ? map.getDouble(i) : map.getString(i));
			}
		}
	}//endregion
	

//region Function GetStringEntriesFromMap
	// returns unique entries of each submap
	String[] GetStringEntriesFromMap(Map mapFasteners, String key)
	{ 
		String entries[0];
		for (int i=0;i<mapFasteners.length();i++) 
		{ 
			String entry= mapFasteners.getMap(i).getString(key);
			if (entry.length()>0 && entries.findNoCase(entry,-1)<0)
				entries.append(entry);			 
		}//next i
		return entries.sorted();
	}//endregion

//region Function GetDoubleEntriesFromMap
	// returns unique doubles of each double in submap with key
	double[] GetDoubleEntriesFromMap(Map mapFasteners, String key)
	{ 
		double entries[0];
		for (int i=0;i<mapFasteners.length();i++) 
		{ 
			Map m = mapFasteners.getMap(i);
			if (m.hasDouble(key))
			{ 
				double entry= m.getDouble(key);
				if (entries.find(entry,-1)<0)
					entries.append(entry);				
			}
			 
		}//next i
		return entries.sorted();
	}//endregion
		

//region Function PurgeJigEpls
	// purges the entplines from model
	void PurgeJigEpls()
	{ 
		Entity ents[] = Group().collectEntities(true, EntPLine(), _kModelSpace, false);
		//reportNotice("\npurgeries " + ents.length());
    	for (int i=ents.length()-1; i>=0 ; i--) 
	    	if (ents[i].bIsValid())
	    		if (ents[i].subMapX("Jig").getInt("isJig"))
		    		ents[i].dbErase(); 			
		
		return;
	}//endregion


//region Function CreateJigEpls
	// returns entplines to be used as jig entities
	EntPLine [] CreateJigEpls(PlaneProfile pp, int shapeType,double offset)
	{
		PurgeJigEpls();
		CoordSys cs = pp.coordSys();
		Vector3d vecX = cs.vecX();
		Vector3d vecY = cs.vecY();
		Vector3d vecZ = cs.vecZ();
		Point3d pt = cs.ptOrg();
		
		int color = 1;
		int transparency = 20;

		Map mapX;
		mapX.setInt("isJig", true);
		
		EntPLine epls[0];
	    if (shapeType==0 ||shapeType==1)
	    {    
	    	Vector3d vecDir = shapeType == 0 ? vecX : vecY;
	    	Vector3d vecPerp = vecDir.crossProduct(-vecZ);
	    	
	    	pt+=vecPerp * offset;
	    	LineSeg seg(pt - vecDir * U(10e5), pt + vecDir * U(10e5));
	    	LineSeg segs[] = pp.splitSegments(seg, true);
	    	
	    	for (int i=0;i<segs.length();i++) 
	    	{ 
	    		EntPLine epl;
	    		epl.dbCreate(PLine(segs[i].ptStart(), segs[i].ptEnd()));
	    		epl.setColor(color);
	    		epl.setTransparency(transparency);
	    		epl.setSubMapX("Jig", mapX);
	    		epls.append(epl);
	    		 
	    	}//next i	
	    }
		else if (shapeType == 2 && abs(offset)>dEps)
		{
			pp.shrink(abs(offset));
			PLine rings[] = pp.allRings();
	    	for (int i=0;i<rings.length();i++) 
	    	{ 
	    		EntPLine epl;
	    		epl.dbCreate(rings[i]);
	    		epl.setColor(color);
	    		epl.setTransparency(transparency);
	    		epl.setSubMapX("Jig", mapX);
	    		epls.append(epl);		 
	    	}//next i					
		}		
		
		
		
		return epls;
	}//endregion




//endregion 

//region Fastener Database and Map Functions #FD

//region Function isValidDll
	// returns true if dll exists
	int isValidDll()
	{ 
		String filePath = findFile(kFastenerLib);
		int bOk;
		if(filePath == "")
		{ 
			reportNotice("\n" + T("|Cannot find fastener library, please contact your local support.|"));
			return false;
		}
		else
		{ 
			String paths[] = callDotNetFunction1(kFastenerLib, kFastenerClass, kGetLastDatabasePathMethod);
			if(paths.length() > 0)
			{ 
				Map mpDatabaseQuery;
				mpDatabaseQuery.setString("DatabasePath", paths[0]);
				Map mpDatabaseReply = callDotNetFunction2(kFastenerLib, kFastenerClass, kVerifyDatabaseExistsMethod);
				
				bOk = mpDatabaseReply.getInt("DatabaseExists");
			}			
		}
		
		return bOk;		
	}//endregion

//region Function ShowFastenerManager
	// returns a map with all filtered entries from databsae
	Map ShowFastenerManager(Map mapFilter)
	{ 
		reportMessage("\n"+ scriptName() + T(": |loading database, please wait...|"));
		
		Map mapIn;
		mapIn.setMap("mpState", mapFilter);
		
//		String sFileMap = _kPathPersonalTemp + "\\" + scriptName() + "mapIn.dxx";
//		mapIn.writeToDxxFile(sFileMap);
//		spawn_detach("",_kPathHsbInstall+"\\Utilities\\hsbMapExplorer\\hsbMapExplorer.exe", sFileMap,"");			
		
		Map out;
		out = callDotNetFunction2(kFastenerLib, kFastenerClass, kShowFastenerSelectorCommand, mapIn);
		
//		String sFileMap2 = _kPathPersonalTemp + "\\" + scriptName() + "out.dxx";
//		out.writeToDxxFile(sFileMap2);
//		spawn_detach("",_kPathHsbInstall+"\\Utilities\\hsbMapExplorer\\hsbMapExplorer.exe", sFileMap2,"");		
		
		
		return out.getMap("SelectedScrews");
	}//endregion

//region Function GetFastenersMap
	// returns a map with all filtered entries from database
	Map GetFastenersMap(Map mapFilter)
	{ 
		Map out;
		out = callDotNetFunction2(kFastenerLib, kFastenerClass, kGetScrewListWithSearch,mapFilter);
		return out;
		
//
//		String sFileMap = _kPathPersonalTemp + "\\" + scriptName() + ".dxx";
//		out.writeToDxxFile(sFileMap);
//		spawn_detach("",_kPathHsbInstall+"\\Utilities\\hsbMapExplorer\\hsbMapExplorer.exe", sFileMap,"");		

		
	}//endregion

//region Function FilterFastenerMap
	// returns a map with submaps which match all criterias
	Map FilterFastenerMap(Map mapFastenersIn, Map mapFilter)
	{ 
		Map mapFastenersOut;
		
		for (int j=0;j<mapFastenersIn.length();j++) 
		{ 
			Map m = mapFastenersIn.getMap(j); 
			int bAccepted = true;
			
			if (mapFilter.hasString(kManufacturer) && m.getString(kManufacturer)!=mapFilter.getString(kManufacturer))bAccepted=false;
			if (mapFilter.hasString(kFamily) && m.getString(kFamily)!=mapFilter.getString(kFamily))bAccepted=false;
			if (mapFilter.hasDouble(kDiameter) && m.getDouble(kDiameter)!=mapFilter.getDouble(kDiameter))bAccepted=false;
			
			if (bAccepted)
				mapFastenersOut.appendMap(m.getMapKey(), m);
			
		}//next j
	
		return mapFastenersOut;
	}//endregion

//region Function IsSimpleFastener
	// returns wether the definition describes a simple or an assembly fastene
	// woodscrews are considered to be simple fasteners
	int IsSimpleFastener(String definition)
	{ 
		int bIsSimpleFastener;
		FastenerAssemblyDef fadef(definition);
		if (fadef.bIsValid())
		{ 
			FastenerSimpleComponent fscHeads[] = fadef.headComponents();
			FastenerSimpleComponent fscTails[] = fadef.tailComponents();
			bIsSimpleFastener = fscHeads.length() <1 && fscTails.length() <1; 			
		}		
		return bIsSimpleFastener;
	}//endregion




//region Family

//region Function GetAllFamilies
	// returns all families of a manufacturer
	String[] GetAllFamilies(String manufacturer)
	{ 
		String families[0];

		Map mapFilter;
		mapFilter.appendString(kManufacturer, manufacturer);
		Map mapFasteners = GetFastenersMap(mapFilter);	

		for (int i=0;i<mapFasteners.length();i++) 
		{ 
			String family= mapFasteners.getMap(i).getString(kFamily);
			if (family.length()>0 && families.findNoCase(family,-1)<0)
				families.append(family);			 
		}//next i

		return families.sorted();
	}//endregion
	
//region Function GetFamilyDiameters
	// returns the list of available diameters of a family
	double[] GetFamilyDiameters(String manufacturer, String family, String& unit)
	{ 
		Map mapFilter;
		mapFilter.appendString(kManufacturer, manufacturer);
		mapFilter.appendString(kFamily, family);
		Map mapFasteners = GetFastenersMap(mapFilter);
		
		double diameters[0];
		for (int i=0;i<mapFasteners.length();i++) 
		{ 
			Map m = mapFasteners.getMap(i);
			double diameter= m.getDouble(kDiameter);
			if (diameter>0 && diameters.find(diameter)<0)
			{
				diameters.append(diameter);	
				if (unit=="")
				{ 
					unit = m.getString("LengthUnit");
				}
			}
		}//next i
 
		return diameters.sorted();
	}//endregion	
	
	
//Fastener Database and Map Functions //endregion 

//endregion 

//region FastenerAssembly Functions #FA

//region Function ComponentDataToMap
	// returns a map with the components data
	Map ComponentDataToMap(FastenerComponentData fcd)
	{
		Map m;
	
		m.setString("name", fcd.name());
		m.setString("type", fcd.type());
		m.setString("subType", fcd.subType());
		m.setString("manufacturer", fcd.manufacturer());
		m.setString("material", fcd.material());
		m.setString("model", fcd.model());
		m.setString("category", fcd.category());
		m.setString("group", fcd.group());
		m.setString("coating", fcd.coating());
		m.setString("grade", fcd.grade());
		m.setString("norm", fcd.norm());
		m.setString("stackThickness", fcd.stackThickness(),_kLength);
		m.setString("sinkDiameter", fcd.sinkDiameter(),_kLength);
		m.setString("mainDiameter", fcd.mainDiameter(),_kLength);

		return m;
	}//endregion

//region Function ArticleDataToMap
	// returns a map with the article data
	Map ArticleDataToMap(FastenerArticleData fad)
	{ 
		Map m = fad.map();
		//if (m.length() < 1 || !m.hasString("articleNumber"))
		{
			m.setString("articleNumber", fad.articleNumber());
			m.setString("description", fad.description());
			m.setString("notes", fad.notes());
			m.setDouble("fastenerLength", fad.fastenerLength(), _kLength);
			m.setDouble("threadLength", fad.threadLength(), _kLength);
			m.setDouble("minProjectionLength", fad.minProjectionLength(), _kLength);
			m.setDouble("maxProjectionLength", fad.maxProjectionLength(), _kLength);
			m.setInt("hasLengthInfo", fad.hasLengthInfo());
			m.setInt("isBespoke", fad.isBespoke());
		}
		return m;
	}//endregion

//region Function SimpleComponentToMap
	// returns the map of a simple component such as main, head or tail component
	Map SimpleComponentToMap(FastenerSimpleComponent fsc)
	{ 
		Map m;
		
		FastenerArticleData fad = fsc.articleData();
		Map mapArticleData = ArticleDataToMap(fad);
		
		FastenerComponentData fcd = fsc.componentData();
		Map mapComponentData = ComponentDataToMap(fcd);
		
		m.setMap("ComponentData", mapComponentData);
		m.setMap("ArticleData", mapArticleData);
		m.setMapName(fad.articleNumber());
		return m;
	}//endregion

//region Function ListComponentToMap
	// returns the map of a listComponent if the articleNumber matches
	Map ListComponentToMap(FastenerListComponent flc, String articleNumber)
	{ 
		Map m;
		
		Map mapArticleData;
		FastenerArticleData fad, fads[] = flc.articleDataSet();
		for (int f=0;f<fads.length();f++) 
		{ 
			String articleNumberF = fads[f].articleNumber(); 
			if (articleNumber==articleNumberF)
			{ 
				mapArticleData = ArticleDataToMap(fads[f]);
				break;
			}			 
		}//next i

		FastenerComponentData fcd = flc.componentData();
		Map mapComponentData = ComponentDataToMap(fcd);
		
		m.setMap("ComponentData", mapComponentData);
		m.setMap("ArticleData", mapArticleData);
		m.setMapName(articleNumber);
		return m;
	}//endregion


//region Function MainDiameter
	// returns the main diameter of a fastenerAssemblyDefinition
	double MainDiameter(String definition)
	{ 
		double mainDiameter;	
		FastenerAssemblyDef fadef(definition); 
		if (fadef.bIsValid())
		{ 
			FastenerListComponent flc = fadef.listComponent();
			FastenerComponentData fcd=flc.componentData();
			mainDiameter = fcd.mainDiameter();
		}		
		return mainDiameter;
	}//endregion	

//region Function GetDefinionsByDiameter
	// returns definitions which match the given diameter
	String[] GetDefinionsByDiameter(double diameter)
	{ 
		String definitions[0];
		
		for (int i=0;i<sExistingFastenerAssemblyDefs.length();i++) 
		{ 
			String definition = sExistingFastenerAssemblyDefs[i];
			int bIsSimple = IsSimpleFastener(definition); 
			double mainDiameter = MainDiameter(definition);
			if (bIsSimple && abs(mainDiameter-diameter)<dEps)
				definitions.append(definition);
		}//next i
		return definitions.sorted();
	}//endregion

//region Function FastenerLengthList
	// returns a sorted list with all available fastener length and thread values, duplicates are ignored"
	double[] FastenerLengthList(String definition, double& dThreadLengths[])
	{ 
		double dFastenerLengths[0];
		dThreadLengths.setLength(0);
		
		FastenerAssemblyDef fadef(definition); 
		if (fadef.bIsValid())
		{ 
			FastenerListComponent flc = fadef.listComponent();
			FastenerArticleData articleDataSet[] = flc.articleDataSet();
			for (int i=0;i<articleDataSet.length();i++) 
			{ 
				FastenerArticleData fad = articleDataSet[i]; 
				double length= fad.fastenerLength();
				double threadLength= fad.threadLength();
				if(dFastenerLengths.find(length)<0)
				{
					dFastenerLengths.append(length);
					dThreadLengths.append(threadLength);
				}
			}//next i
		}
	
	// order alphabetically
		for (int i=0;i<dFastenerLengths.length();i++) 
			for (int j=0;j<dFastenerLengths.length()-1;j++) 
				if (dFastenerLengths[j]>dFastenerLengths[j+1])
				{	
					dFastenerLengths.swap(j, j + 1);
					dThreadLengths.swap(j, j + 1);					
				}

		
		return dFastenerLengths;
	}//endregion

//region Function GetLengthFromArticleNumber
	// returns the length of the current article, 0 = invalid
	double GetLengthFromArticleNumber(FastenerAssemblyEnt fae )
	{ 
		double dLength;
		FastenerAssemblyDef fadef(fae.definition()); 
		if (fadef.bIsValid())
		{ 
			FastenerListComponent flc = fadef.listComponent();
			FastenerArticleData articleDataSet[] = flc.articleDataSet();
			for (int i=0;i<articleDataSet.length();i++) 
			{ 
				FastenerArticleData fad = articleDataSet[i]; 
				if(fad.articleNumber() == fae.articleNumber())
				{ 
					dLength= fad.fastenerLength(); 
					break;
				}
			}//next i
		}			
		return dLength;
	}//endregion

//region Function GetArticleNumberFromLength
	// returns the articlenumber if an article of the given length can be found and sets the detected listComponent
	String GetArticleNumberFromLength(String definition, double dLength, FastenerListComponent& flc)
	{ 
		String articleNumber;
		FastenerAssemblyDef fadef(definition); 
		if (fadef.bIsValid())
		{ 
			flc = fadef.listComponent();
			FastenerArticleData articleDataSet[] = flc.articleDataSet();
			for (int i=0;i<articleDataSet.length();i++) 
			{ 
				FastenerArticleData fad = articleDataSet[i]; 
				double length= fad.fastenerLength(); 
				if(abs(dLength-length)<dEps)
				{ 
					articleNumber = fad.articleNumber();
					break;
				}
			}//next i
		}			
		return articleNumber ;
	}//endregion



//region Function GetFastenerEntFamily
	// returns the family name stored in the map of the article data of the simpleComponnet
	String GetFastenerEntFamily(FastenerAssemblyEnt fae)
	{ 
		String family;
		if (fae.bIsValid())
		{
			String articleNumber = fae.articleNumber();
			FastenerAssemblyDef fadef(fae.definition());
			if (fadef.bIsValid() && articleNumber.length()>0)
			{ 
				FastenerSimpleComponent fsc = fadef.mainComponent(articleNumber);
				FastenerArticleData fad = fsc.articleData();
				Map m= fad.map();
				family = m.getString("family");
			}			
		}		
		return family;
	}//endregion	

//region Function GetFamiliesByDefinitions
	// returns a list of families of the selected fastenerAssemblyDefinitions
	String[] GetFamiliesByDefinitions(String definitions[])
	{ 
		String families[definitions.length()];
		
		for (int j=0;j<definitions.length();j++) 
		{
			FastenerAssemblyDef fadef(definitions[j]);
			if (fadef.bIsValid())
			{ 
				FastenerListComponent flc = fadef.listComponent();
				FastenerArticleData fads[] = flc.articleDataSet();
				for (int i=0;i<fads.length();i++) 
				{ 
					FastenerArticleData fad = fads[i]; 
					Map m= fad.map();
					String family = m.getString("family");
					if (family.length()>0)
					{
						families[j]=family;
						break;
					}
				}//next i				
			}
		}//next i
		return families;
	}//endregion

//region Function AppendFastenerArticleData
	// overwrites or appends new FastenerArticleData created by the map content, returns -1= invalid, 0=overwritten, 1 = added
	int AppendFastenerArticleData(Map mapFastenerArticleData, FastenerArticleData& fads[])
	{ 
		Map m = mapFastenerArticleData;
		
		FastenerArticleData fad;
		double dLength = m.getDouble("length");
		String articleNumber = m.getString("articleNumber");			
		if (dLength < dEps || articleNumber.length() < 1)
		{
			return -1; 
		}

		int bAdd=true;
		for (int f=0;f<fads.length();f++) 
		{ 
			String articleNumberF = fads[f].articleNumber(); 
			if (articleNumber==articleNumberF)
			{ 
				fad = fads[f];
				bAdd = false;
				break;
			}			 
		}//next i

		fad.setArticleNumber(articleNumber);
		fad.setDescription(m.getString("description"));
		fad.setNotes(m.getString("notes"));
		fad.setFastenerLength(dLength);
		fad.setThreadLength(m.getDouble("threadLength"));
		fad.setMinProjectionLength(0);
		fad.setMaxProjectionLength(dLength-U(1));//TODO
		fad.setHasLengthInfo(true);//TODO
		fad.setMap(mapFastenerArticleData);	// dump entire component data		

		if (bAdd)
			fads.append(fad);
		
	// order fads by length
		for (int i=0;i<fads.length();i++) 
			for (int j=0;j<fads.length()-1;j++) 
				if (fads[j].fastenerLength()>fads[j+1].fastenerLength())
					fads.swap(j, j + 1);

		return bAdd;
	}//endregion
 
//region Function SetFastenerComponentData
	// returns the FastenerComponentData created by map
	FastenerComponentData SetFastenerComponentData(Map m)
	{ 
		FastenerComponentData fcd;
		fcd.setName(m.getString("model"));
		fcd.setType(m.getString("type"));
		fcd.setSubType(m.getString("headType"));
		fcd.setManufacturer(m.getString("manufacturer"));
		fcd.setModel(m.getString(kModel));
		fcd.setMaterial(m.getString("material"));
		fcd.setCategory(m.getString("category"));
		fcd.setGroup(m.getString("group"));
		fcd.setGrade(m.getString("finish"));
		fcd.setNorm(m.getString("norms"));

		fcd.setStackThickness(m.getDouble("HeadHeight"));
		fcd.setSinkDiameter(m.getDouble("HeadDiameter"));
		fcd.setMainDiameter(m.getDouble("Diameter"));
		
		return fcd;
	}//endregion

//region Function SimpleComponentToHardware
	// returns true or false and modifies  the given hardwareComp representing the SimpleComponent
	int SimpleComponentToHardware(HardWrComp& hwc, int qty, Map mapSimpleComponent)
	{
		Map mapComponentData = mapSimpleComponent.getMap("ComponentData");
		Map mapArticleData = mapSimpleComponent.getMap("ArticleData");
		
		String articleNumber = mapArticleData.getString("articleNumber");
		if (articleNumber.length() < 1)
		{
			return false;
		}
		
		hwc=HardWrComp (articleNumber, (qty < 1 ? 1 : qty));
		hwc.setManufacturer(mapComponentData.getString("manufacturer"));
		hwc.setModel(mapArticleData.getString("model"));
		hwc.setName(mapArticleData.getString("family"));

		hwc.setDescription(T(("|"+mapArticleData.getString("description")+"|")));
		hwc.setMaterial(T(("|"+mapArticleData.getString("material")+"|")));
		//hwc.setNotes(mapArticleData.getString("manufacturer"));
		
		//hwc.setGroup(sHWGroupName);
		//hwc.setLinkedEntity(entHW);
		hwc.setCategory(T("|Fastener|"));
		hwc.setRepType(_kRTTsl); //the repType is used to distinguish between predefined and custom components
		
		hwc.setDScaleX(mapArticleData.getDouble("length"));
		hwc.setDScaleY(mapArticleData.getDouble("diameter"));
		hwc.setDScaleZ(mapArticleData.getDouble("diameter"));
		
		return true;
	}//endregion


//region Function CreateFastenerStyle
	// returns the fastener assembly definitions which have been created / updated by the selrcted fasteners
	String[] CreateFastenerStyle(Map mapSelectedFasteners)
	{ 
		String sNewDefinitions[0];
		
		int bShowLog=true;
	// ─│┌┐└
		String sManufacturers[] = GetStringEntriesFromMap(mapSelectedFasteners, kManufacturer);
		int num = sManufacturers.length();
		if (bShowLog)
			reportNotice("\n\n┌──────       " +T("|Creating new fastener assemby styles|       ──────┐\n│\n│   ")+
				num+
				(num<2?T(" |Manufacturer found in| "):T(" |Manufacturers found in| ") )+
				mapSelectedFasteners.length() + T(" |fasteners.|"));	
			
		for (int i3=0;i3<sManufacturers.length();i3++) 
		{ 
			String sManufacturer = sManufacturers[i3];
			String sSelectedFamilies[] = GetStringEntriesFromMap(mapSelectedFasteners, kFamily);
			int numFamilies = sSelectedFamilies.length();
			//String sFamilies[] = GetAllFamilies(sManufacturer);

			if (bShowLog)
				reportNotice("\n│\n│   "+sManufacturer + ": "+ numFamilies + (numFamilies<=1?T(" |family found|"):T(" |families found| ")));	

			for (int i2=0;i2<sSelectedFamilies.length();i2++) 
			{ 
				String sFamily = sSelectedFamilies[i2];
				//sFamily.replace("/", "_");//XX
				
				
				
			// Filter fasteners for this manufacturer/family
				Map mapFilter;
				mapFilter.appendString(kManufacturer, sManufacturer);
				mapFilter.appendString(kFamily, sFamily);
				Map mapFasteners = FilterFastenerMap(mapSelectedFasteners, mapFilter);
				double dDiameters[] = GetDoubleEntriesFromMap(mapFasteners, kDiameter);
				
				if (bShowLog)
				{
					reportNotice("\n│      "+sManufacturer + " "+sFamily +T(": |contains these diamters|: "));
					for (int i = 0; i < dDiameters.length(); i++)
						reportNotice((i>0?", ":"")+dDiameters[i]);
				}

				for (int i = 0; i < dDiameters.length(); i++)
				{
					double diameter = dDiameters[i];
					
//					if (1.0==U(1,"in") && sUnit.makeLower()=="mm")
//						diameter /= 2.54;
//					else if (1.0==U(1,"mm") && sUnit.makeLower()=="in")
//						diameter *= 2.54;
				
				// build new name of assemblyStyleDefinition
					Map mapAdd;
					mapAdd.setDouble(kDiameter, diameter, _kLength);
					String definition = sManufacturer + "-" + sFamily + " " + _ThisInst.formatObject("@(Diameter:DN3:PL2)", mapAdd);
					definition.replace(",", "_");// HSB-22816
					definition.replace("/", "_");// HSB-24585
					definition.replace(";", "_");
					definition.replace("\\", "_");
					
					
					FastenerAssemblyDef fadef(definition); 
					
				// Get (potential) existing data	
					FastenerListComponent flc;
					FastenerArticleData fads[0];
					FastenerComponentData fcd;										
					if (fadef.bIsValid())
					{
						flc = fadef.listComponent();
						fcd = flc.componentData();
						fads = flc.articleDataSet();	
					}

				// Filter fasteners for this manufacturer/family/diameter
					Map mapFilter;
					mapFilter.appendString(kManufacturer, sManufacturer);
					mapFilter.appendString(kFamily, sFamily);
					mapFilter.appendDouble(kDiameter, diameter);
					mapFasteners = FilterFastenerMap(mapSelectedFasteners, mapFilter);
					//Map mapFasteners = GetFastenersMap(mapFilter);

					FastenerComponentData fcdNew;
					for (int j = 0; j < mapFasteners.length(); j++)
					{
						Map m = mapFasteners.getMap(j);

						int resultData = AppendFastenerArticleData(m, fads);
						if (bShowLog)
							reportNotice("\n│          "+m.getString("model") + 
							(resultData==1?T(" |appended|"):(resultData==0?T(" |updated|"):T(" |ignored|"))));

						String name = fcdNew.name();
						if (name.length() < 1)
						{
							fcdNew = SetFastenerComponentData(m);
							fcd = fcdNew;
						}
					}
					
					
					//reportNotice("\n flc contains of "+fads.length() + " fcd"+fcd.manufacturer());
					
					flc.setArticleDataSet(fads);
					flc.setComponentData(fcd);					

					String msg;
					if (fads.length()<1)
					{ 
						msg = T(" |could be found for diameter| ") + diameter;
					}
					else if (fadef.bIsValid())
					{ 
						sNewDefinitions.append(definition);
						fadef.setListComponent(flc);
						msg = T(" |updated|");
					}
					else
					{ 
						
						sNewDefinitions.append(definition);
						fadef.dbCreate();
						//fadef.setDescription("Test");	
						fadef.setListComponent(flc);
						
						FastenerSimpleComponent fscs[0];// = fadef.tailComponents();
						fadef.setHeadComponents(fscs);
						fadef.setTailComponents(fscs);
						
						msg = fadef.bIsValid() ? T(" |successfully created|") : T(" |failed|");
					}

					msg = "\n│       " + definition + ": " + fads.length()+T(" |articles|")  + msg;
					reportNotice(msg);		
				}//next i
			}
			
		}//next i3
		
		int numDefinitions = sNewDefinitions.length();
		if (numDefinitions>0)
			reportNotice("\n│\n└──────      " + sNewDefinitions.length() + 
				(numDefinitions==1?T("|assembly definition has been edited.|"):T(" |assembly definitions have been edited.|"))+"      ──────┘");
		return sNewDefinitions;
	}//endregion

//FastenerAssembly Functions //endregion 

//region Geometry Functions #GE





//region Function GetIntersectingPlanes
	// returns the extreme planes along the drill axis
	// g: the genbeam
	// vecDir: the direction vector
	// ptAxis: point on drill axis
//	Point3d GetIntersectingPlanes(GenBeam g, Vector3d vecDir, Point3d ptAxis, Plane& pn1, Plane& pn2, double radius)
//	{ 
//		
//		Sip p = (Sip)g;
//		Beam b = (Beam)g;
//		Sheet s = (Sheet)g;		
//		Point3d ptCen = g.ptCenSolid();
//		Line lnDir(ptAxis, vecDir);
//		Vector3d vecX= g.vecX();
//		Vector3d vecY = g.vecY();
//		Vector3d vecZ = g.vecZ();
//		int bIsPerpendicularY = vecDir.isPerpendicularTo(vecY);
//		int bIsPerpendicularZ = vecDir.isPerpendicularTo(vecZ);
//		int bIsParallelZ = vecDir.isParallelTo(vecZ);
//		int bIsParallelX = vecDir.isParallelTo(vecX);		
//
//		Body bd = g.envelopeBody(false, true);
//		Point3d ptsX[]=bd.intersectPoints(lnDir);
//		ptsX = lnDir.orderPoints(ptsX, dEps);
//		
//		// fall back to body intersection
//		if (ptsX.length()<2)
//		{ 
//			Body bdx(ptAxis-vecDir * U(10e4), ptAxis+vecDir * U(10e4), radius);
//			bdx.intersectWith(bd);
//			ptsX = bdx.extremeVertices(vecDir);
//		}
//
//		if (ptsX.length()>2)
//			ptsX.swap(1, ptsX.length() - 1);
//		ptsX.setLength(2);	
//		
//	// Panel
//		if (p.bIsValid())
//		{ 
//			Body bd = p.envelopeBody(false, true);
//			if (bIsPerpendicularZ)
//			{ 
//				Vector3d vecPerp = vecDir.crossProduct(-vecZ);
//				//ptsX = p.plEnvelope().intersectPoints(Plane(ptAxis, vecPerp));
//
//				SipEdge edges[] = p.sipEdges();
//				
//				int bHasPlanes[2];
//				for (int ab=0;ab<ptsX.length();ab++) 
//				{
//					Point3d ptx = ptsX[ab];
//					for (int i=0;i<edges.length();i++) 
//					{ 
//						SipEdge& e = edges[i];
//						Point3d pt = e.ptMid();
//						Vector3d normal = e.vecNormal();
//						if (abs(normal.dotProduct(pt-ptx))>dEps)
//						{ 
//							//pt.vis(1);
//							continue;
//						}
//						Plane pn(pt, normal);
//						PlaneProfile pp = bd.extractContactFaceInPlane(pn, dEps);
//						if (pp.pointInProfile(pt)!=_kPointOutsideProfile)
//						{ 
//							if (ab==0)
//							{
//								pn1= pn;
//							}
//							else 
//							{
//								pn2= pn;
//							}
//							bHasPlanes[ab] = true;
//							break;
//						}
//					}//next i
//					if (bHasPlanes[ab]) { continue;}
//					
//				// fall back to closest ring	
//					int n = p.findClosestEdgeIndex(ptx);
//					if (n>-1)
//					{
//						//edges[n].plEdge().vis(6);
//						Point3d ptx;
//						Plane pn(edges[n].ptMid() ,edges[n].vecNormal());
//						lnDir.hasIntersection(pn, ptx);
//						pn.transformBy(ptx - pn.ptOrg());
//						if (ab==0)pn1= pn;
//						else pn2= pn;
//						
//					}					
//					
//					
//				}
//
//			}
//			else
//			{ 
//				Vector3d vecN = vecZ;
//				if (vecN.dotProduct(vecDir) > 0) vecN *= -1;
//				Point3d ptx = ptCen;
//				lnDir.hasIntersection(Plane(ptCen + vecN*.5 * p.dH(), vecN), ptx);
//				pn1 = Plane(ptx ,- vecZ);
//				
//				vecN *= -1;
//				ptx = ptCen;
//				lnDir.hasIntersection(Plane(ptCen + vecN*.5 * p.dH(), vecN), ptx);
//				pn2 = Plane(ptx ,vecZ);
//			}
//		}
//
//	// Beam
//		else if (b.bIsValid())
//		{
//			
//			double dD = bIsParallelX?g.solidLength():g.dD(vecDir);						
//			Vector3d vecN = bIsParallelX? vecDir : g.vecD(vecDir);
//			{ 
//				Point3d ptx = ptsX.first();
//				LineBeamIntersect lbi(ptx, vecDir, b);
//				int num = lbi.nNumPoints();
//				int bHasContact = lbi.bHasContact();
//				
//				if (num>0 && bHasContact)
//				{ 
//					vecN = -lbi.vecNrm1();
//					//ptx = lbi.pt1();			
//					pn1=Plane(ptx, vecN);
//					
//				}
//				else if (b.bIsCutStraight(vecDir.dotProduct(vecX)<0))
//				{
//					pn1=Plane(ptCen+vecDir*.5*dD, vecDir);
//					Line(ptAxis, vecDir).hasIntersection(pn1, ptx);
//					pn1.transformBy(ptx - pn1.ptOrg());
//					
//				}
//				else
//				{ 
//					PlaneProfile pps[0];
//					Plane planes[] = GetPlanesBeamEnd(b, -vecDir, pps);
//					int bOk;
//					for (int i=0;i<planes.length();i++) 
//					{ 
//						if(pps[i].pointInProfile(ptAxis)!=_kPointOutsideProfile)
//						{ 
//							pn1 =  planes[i];
//							bOk = true;
//							break;
//						}						 
//					}//next i
//					if(!bOk)
//					{ 
//						pn1=Plane(ptCen+vecDir*.5*dD, vecDir);
//						Line(ptAxis, vecDir).hasIntersection(pn1, ptx);
//						pn1.transformBy(ptx - pn1.ptOrg());	
//						pn1.vis(1);						
//					}
//				}				
//				//pn1.vis(1);
//			}
//			{
//				Point3d ptx = ptsX.last();
//				LineBeamIntersect lbi(ptx, -vecDir, b);
//				int num = lbi.nNumPoints();
//				int bHasContact = lbi.bHasContact();
//				
//				if (num>0 && bHasContact)
//				{ 
//					vecN = -lbi.vecNrm1();
//					//ptx = lbi.pt1();			
//					pn2=Plane(ptx, vecN);
//					
//				}
//				else if (b.bIsCutStraight(vecDir.dotProduct(vecX)>0))
//				{ 
//					pn2=Plane(ptCen+vecDir*.5*dD, vecDir);
//					Line(ptAxis, vecDir).hasIntersection(pn2, ptx);
//					pn2.transformBy(ptx - pn2.ptOrg());	
//					pn2.vis(1);	
//								
//				}
//				else
//				{ 
//					PlaneProfile pps[0];
//					Plane planes[] = GetPlanesBeamEnd(b, vecDir, pps);
//					int bOk;
//					for (int i=0;i<planes.length();i++) 
//					{ 
//						if(pps[i].pointInProfile(ptAxis)!=_kPointOutsideProfile)
//						{ 
//							pn2 =  planes[i];
//							bOk = true;
//							break;
//						}						 
//					}//next i
//					if(!bOk)
//					{ 
//						pn2=Plane(ptCen+vecDir*.5*dD, vecDir);
//						Line(ptAxis, vecDir).hasIntersection(pn2, ptx);
//						pn2.transformBy(ptx - pn2.ptOrg());	
//						pn2.vis(1);						
//					}
//				}
//				//pn2.vis(3);	
//			}
//		}
//
//	// Sheet
//		else if (s.bIsValid())
//		{ 
//			if (bIsPerpendicularZ)
//			{ 
//				Point3d pts[0];
//				PLine plEnvelope = s.plEnvelope();
//				Vector3d vecPerp = vecDir.crossProduct(-vecZ);
//				pts = plEnvelope.intersectPoints(Plane(ptAxis, vecPerp));
//				pts = lnDir.orderPoints(pts, dEps);
//				if (pts.length() < 1)return false;
//				else if (pts.length()>2)
//					pts.swap(1, pts.length() - 1);
//				pts.setLength(2);
//				
//				for (int ab=0;ab<pts.length();ab++) 
//				{ 
//					Point3d ptx = pts[ab];
//					Vector3d vecTan = plEnvelope.getTangentAtPoint(pts[ab]);
//					Vector3d vecN = vecTan.crossProduct(-vecZ);
//					if (vecN.dotProduct(vecDir) < 0)vecN *= -1;
//					Plane pn(ptx ,(ab==0?-1:1)*vecN);
//					
//					Line(ptAxis, vecDir).hasIntersection(pn, ptx);
//					pn.transformBy(ptx - pn.ptOrg());	
//					
//					if (ab==0)pn1= pn;
//					else pn2= pn;
//				}//next ab				
//			}
//			else
//			{ 
//				Vector3d vecN = vecZ;
//				if (vecN.dotProduct(vecDir) > 0) vecN *= -1;
//				
//				Point3d ptx = ptsX.first();		//PLine(ptx,_PtW).vis(40);
//				lnDir.hasIntersection(Plane(ptCen + vecN*.5 * p.dH(), vecN), ptx);
//				pn1 = Plane(ptx ,vecN);
//				//pn1.vis(1);
//				
//				ptx = ptsX.last();				//PLine(ptx,_PtW).vis(60);
//				vecN *= -1;
//				lnDir.hasIntersection(Plane(ptCen + vecN*.5 * p.dH(), vecN), ptx);
//				pn2 = Plane(ptx ,vecN);
//				//pn2.vis(3);
//			}
//		}
//
//
//		Point3d ptMid; ptMid.setToAverage(ptsX);
//		return ptMid;
//	} //endregion	

//region Function GetPlaneProfilePlane
	// returns the plane of a planeprofile
	Plane GetPlaneProfilePlane(PlaneProfile pp)
	{ 
		CoordSys cs = pp.coordSys();
		Plane pn(cs.ptOrg(), cs.vecZ());
		return pn;
	}//endregion


//region Function GetExtremePlanes
	// returns the extreme intersectin genbeams wiht its extreme faces/planes
	// gbs: the intersecting genbeams
	void GetExtremePlanes(GenBeam& gbs[], Plane& pn1, Plane& pn2, Vector3d vecDir, Point3d ptAxis, double radius)
	{ 
		ptAxis.vis(4);
		Plane pnsA[0], pnsB[0];// collection of extreme planes in vecDir
		Point3d ptsM[0];
		for (int x=0;x<gbs.length();x++) 
		{ 
			GenBeam& g = gbs[x];
			Point3d ptCen = g.ptCen();
			
			Plane pnA(ptCen, g.vecD(vecDir));
			Plane pnB=pnA;
			
			//Point3d ptm; = GetIntersectingPlanes(g, vecDir, ptAxis, pnA, pnB, radius);
		
			PlaneProfile pps[] = GetFacePlaneProfiles(g, Vector3d());// TODO check if direction vector increases performance
			
			int a = -1;
			PlaneProfile ppsA[] = GetPlaneProfilesViewDirection(pps, - vecDir, ptAxis, a);
		
			int b = -1;
			PlaneProfile ppsB[] = GetPlaneProfilesViewDirection(pps, vecDir, ptAxis, b);
			
			if (a>-1 && b>-1)
			{ 
				pnA = GetPlaneProfilePlane(ppsA[a]);
				pnB = GetPlaneProfilePlane(ppsB[b]);
				Point3d ptA=ptCen, ptB=ptCen;
				Line(ptAxis, vecDir).hasIntersection(pnA, ptA);
				Line(ptAxis, vecDir).hasIntersection(pnB, ptB);
				Point3d ptm = (ptA + ptB) * .5;
				ptsM.append(ptm);
				pnsA.append(pnA);
				pnsB.append(pnB);				
			}
		}//next x	


	// order in dir
		for (int i=0;i<gbs.length();i++) 
			for (int j=0;j<gbs.length()-1;j++) 
			{
				Point3d pt1 =ptsM[j];// (pnsA[j].ptOrg() + pnsB[j].ptOrg()) * .5;
				Point3d pt2 =ptsM[j+1];// (pnsB[j+1].ptOrg() + pnsB[j+1].ptOrg()) * .5;
				double d1 = vecDir.dotProduct(pt1-_Pt0);
				double d2 = vecDir.dotProduct(pt2-_Pt0);
				
				if (d1>d2)
				{ 
					gbs.swap(j, j + 1);
					pnsA.swap(j, j + 1);
					pnsB.swap(j, j + 1);
					ptsM.swap(j, j + 1);
				}
			}

		if (pnsA.length() > 0)pn1 = pnsA.first();
		if (pnsB.length() > 0)pn2 = pnsB.last();
		pn1.vis(1);		pn2.vis(2);
		return;
	}//endregion	

//region Function GetGenBeamsIntersect
	// returns
	GenBeam[] GetGenBeamsIntersect(GenBeam gbs[], Point3d ptAxis, Vector3d vecDir, double radius)
	{ 
		GenBeam out[0];

		Body bd(ptAxis - vecDir * U(10e4), ptAxis + vecDir * U(10e4), dEps );	//bd.vis(150);
		GenBeam gbsX[] = bd.filterGenBeamsIntersect(gbs);

	// append non dummies
		for (int i=0;i<gbsX.length();i++) 
			if (!gbsX[i].bIsDummy())
				out.append(gbsX[i]);
		
		return out;
	}//End GetGenBeamsIntersect //endregion

//region Function TransformPointToExtreme
	// transforms the given point by the offset to the extreme vertex of the projected shape
	double TransformPointToExtreme(Point3d& pt, PLine shape, Plane pn, Vector3d vecDir)
	{ 
		shape.convertToLineApprox(dEps);
		PlaneProfile pp(shape);
		pp.project(pn, vecDir, dEps);
		
		if (bDebug)pp.vis(3);
		//pp.extentInDir(pp.coordSys().vecX()).vis(1);
		//Display dp(1); dp.draw(pp, _kDrawFilled, 40);
		
		Point3d pts[] = pp.getGripVertexPoints();
		pts = Line(_Pt0, vecDir).orderPoints(pts);
		
		double out;
		if (pts.length()>0)
		{
			out = vecDir.dotProduct(pts.last() - pt);
			pt += vecDir *out ;
		}
		
		//pt.vis(4);
		
		return out;	
	}//endregion

		
//END Geometry Functions //endregion 
		
//FUNCTIONS //endregion 

//region Properties

category = T("|Geometry|");
	String sDiameterName=T("|Diameter|");	
	PropDouble dDiameter(0, U(0), sDiameterName,_kLength);	
	dDiameter.setDescription(T("|Defines the diameter.|"));
	dDiameter.setCategory(category);	
	dDiameter.setControlsOtherProperties(true);

	String sGapName=T("|Additional Diameter|");	
	PropDouble dGap(1, U(0), sGapName,_kLength);	
	dGap.setDescription(T("|Modifies the diameter of the drill by the given value|"));
	dGap.setCategory(category);

category = T("|Sink Hole|");
	String sDiameterSinkName=T("|Diameter Sink|");	
	PropDouble dDiameterSink(2, U(0), sDiameterSinkName,_kLength);	
	dDiameterSink.setDescription(T("|Defines the of the sink hole|"));
	dDiameterSink.setCategory(category);
	
	String sDepthSinkName=T("|Depth Sink|");	
	PropDouble dDepthSink(3, U(0), sDepthSinkName,_kLength);	
	dDepthSink.setDescription(T("|Defines the DepthSink|"));
	dDepthSink.setCategory(category);


category = T("|Fastener|");
	String sDefinitions[0];
	if (dDiameter>0)// control definition by diameter and isSimple
	{
		sDefinitions= GetDefinionsByDiameter(dDiameter);		
	}
	else	// append any simple
	{
		for (int i=0;i<sExistingFastenerAssemblyDefs.length();i++) 
		{ 
			String definition = sExistingFastenerAssemblyDefs[i];
			int bIsSimple = IsSimpleFastener(definition);
			if (bIsSimple)
			{
				sDefinitions.append(definition); 		 
			}
		}//next i
	}
	
	String tDisabled = T("<|Disabled|>");
	sDefinitions.append(tDisabled);
	String tAddNew = T("<|Add New|>");
	sDefinitions.append(tAddNew);
	String sDefinitionName=T("|Fastener Style|");	
	PropString sDefinition(nStringIndex++, sDefinitions, sDefinitionName);
	sDefinition.setDescription(T("|Defines the Style|"));
	sDefinition.setCategory(category);
	sDefinition.setControlsOtherProperties(true);
	if (sDefinitions.findNoCase(sDefinition ,- 1) < 0)sDefinition.set(tDisabled);
	
	String tModeHwc = T("|Hardware Component|"), tModeFae = T("|Fastener Entity|"), sModes[] ={tModeFae,tModeHwc };
	String sModeName=T("|Mode|");	
	PropString sMode(nStringIndex++, sModes, sModeName);	
	sMode.setDescription(T("|Defines the wether the fastener will be exported as non graphic hardware component or if a fastener entity will be created.|"));
	sMode.setCategory(category);

category = T("|Geometry|");
	double dThreadLengths[0], dFastenerLengths[0], dLengthList[] ={0}; // auto
	if (sDefinition!=tAddNew && sDefinition!=tDisabled)// && dDiameter>0)
		dFastenerLengths.append(FastenerLengthList(sDefinition, dThreadLengths));
	dLengthList.append(dFastenerLengths);	
	
	
	String sLengthName=T("|Length|");	
	PropDouble dLength(4, dLengthList, sLengthName,_kLength);	
	dLength.setDescription(T("|Specifies the article by Length|") + T(", |0 = automatic|"));
	dLength.setCategory(category);
	if (dLength!=0 && dFastenerLengths.find(dLength)<0)
		dLength.set(0);

	String sPenetrationDepthName=T("|Penetration Depth|");	
	PropDouble dPenetrationDepth(5, U(0), sPenetrationDepthName,_kLength);	
	dPenetrationDepth.setDescription(T("|Defines the Penetration Depth|"));
	dPenetrationDepth.setCategory(category);

	
category = T("|Display|");

	String sFormatName=T("|Format|");	
	PropString sFormat(nStringIndex++, "@(ArticleNumber)", sFormatName);	
	sFormat.setDescription(T("|Defines the format of the tag to be displayed.|"));
	sFormat.setCategory(category);
	Map mapAdd;
	sFormat.setDefinesFormatting(FastenerAssemblyEnt(), mapAdd);

	String sTextHeightName=T("|Text Height|");	
	PropDouble dTextHeight(6, U(5), sTextHeightName,_kLength);	
	dTextHeight.setDescription(T("|Defines the text height|") + T("|0 = byDimstyle|"));
	dTextHeight.setCategory(category);

	

//region Function setReadOnlyFlagOfProperties
	// sets the readOnlyFlag
	void setReadOnlyFlagOfProperties()
	{ 	
		
		int bAddNew = sDefinition == tAddNew;
		dDiameter.setReadOnly(!bAddNew || bDebug ? false : _kHidden);
		dGap.setReadOnly(!bAddNew || bDebug ? false : _kHidden);
		dDepthSink.setReadOnly(!bAddNew || bDebug ? false : _kHidden);
		dDiameterSink.setReadOnly(!bAddNew || bDebug ? false : _kHidden);
		dLength.setReadOnly(!bAddNew || bDebug ? false : _kHidden);
		sMode.setReadOnly(!bAddNew || bDebug ? false : _kHidden);
		dPenetrationDepth.setReadOnly(!bAddNew || bDebug ? false : _kHidden);
		sFormat.setReadOnly(!bAddNew || bDebug ? false : _kHidden);
		dTextHeight.setReadOnly(!bAddNew || bDebug ? false : _kHidden);
		
		//_kNameLastChangedProp==sDiameterName && 
		if (!bAddNew && sDefinitions.length()>1 ) // if diameter change results into multiple definitions
		{ 
			String families[] = GetFamiliesByDefinitions(sDefinitions);
			String prevFamily = _Map.getString("family");
			int nDefinition = prevFamily.length()<1?-1:families.findNoCase(prevFamily ,- 1);
			
			if (nDefinition>-1)
			{ 
				sDefinition.set(sDefinitions[nDefinition]);
				dLength.set(0);	
			}
			
			else if (sDefinitions.findNoCase(sDefinition,-1)<0)
			{ 
				sDefinition.set(tDisabled);
				dLength.set(0);					
			}



			//double dThreadLengths[0], dFastenerLengths[0], 

			if (sDefinition!=tDisabled)// && dDiameter>0)
			{ 
				dLengthList.setLength(0);
				dFastenerLengths.setLength(0);
				dLengthList.append(0);// auto	
				dFastenerLengths.append(FastenerLengthList(sDefinition, dThreadLengths));
				dLengthList.append(dFastenerLengths);
				dLength=PropDouble (4, dLengthList, sLengthName,_kLength);
				
			}

		}		
		
		
		
		

		return;
	}//endregion	
	
	
//endregion 



//region OnInsert
	if (_bOnInsert)
	{
		if (insertCycleCount() > 1) { eraseInstance(); return; }
		
	// if the dwg dows not contain any fastenerstyles show edit style dialog	
		int bEditStyle = sDefinitions.length()<3 || _kExecuteKey.find("EditStyle",0,false)==0;

	// silent/dialog
		if (!bEditStyle)
		{ 
			if (_kExecuteKey.length() > 0 && TslInst().getListOfCatalogNames(scriptName()).findNoCase(_kExecuteKey ,- 1) >- 1)
				setPropValuesFromCatalog(_kExecuteKey);
				// standard dialog
			else
			{
				
				setPropValuesFromCatalog(tLastInserted);
				setReadOnlyFlagOfProperties();				
				dLength.set(0);
				//dLength.setReadOnly(_kHidden);	
				while (showDialog("---") == _kUpdate) // _kUpdate means a controlling property changed.	
				{ 
					setReadOnlyFlagOfProperties(); // need to set hidden state
				}	
				setReadOnlyFlagOfProperties();
				//dLength.set(0);
			}			
		}

	// Calling the creation of styles from an instance during insert fails, the instance needs to be inserted in the dwg	
		if (bEditStyle || sDefinition == tAddNew)
		{ 
	
		// create TSL
			TslInst tslNew;				Map mapTsl;
			int bForceModelSpace = true;	
			String sExecuteKey,sCatalogName = tLastInserted;
			String sEvent="OnDbCreated"; // "OnElementConstructed", "OnRecalc", "OnMapIO"...
			GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {};
		
			mapTsl.setInt("mode", 99);
			tslNew.dbCreate(scriptName() , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, sCatalogName, bForceModelSpace, mapTsl, sExecuteKey, sEvent); 	

			eraseInstance();
			return;
			
		}		

		int nProps[] ={ };
		double dProps[] ={ dDiameter, dGap, dDiameterSink,dDepthSink, dLength, dPenetrationDepth, dTextHeight};
		String sProps[] ={ sDefinition, sMode,sFormat};
		
		
		_GenBeam.append(getGenBeam());
		GenBeam gb = _GenBeam[0];
		Point3d ptCen = gb.ptCen();
		Body bd=gb.envelopeBody(false, true);
		Quader qdr(ptCen, gb.vecX(), gb.vecY(), gb.vecZ(), gb.solidLength(), gb.solidWidth(), gb.solidHeight(), 0, 0, 0);
		
	// prompt for additional entities
		Entity ents[0];
		PrEntity ssE(T("|Select secondary entities|"), GenBeam());
		ssE.addAllowedClass(TslInst());
		ssE.addAllowedClass(MetalPartCollectionEnt());		
		if (ssE.go())
		{
			ents.append(ssE.set());
			//reportNotice("\nselect " + ents.length());
			for (int i=0;i<ents.length();i++) 
			{				
				Body bd = ents[i].realBody();
				if (bd.isNull())
				{ 
					continue;
				}
				TslInst t = (TslInst)ents[i];
				if (t.bIsValid() && t.scriptName() != scriptName())
				{ 
					_Entity.append(ents[i]);
					continue;
				}	
				
				GenBeam gbi = (GenBeam)ents[i];
				if (gbi.bIsValid() && gbi!=gb)
				{ 
					_GenBeam.append(gbi); 
					//reportNotice("\nappend gb " + gbi.handle());
					continue;
				}
				
				MetalPartCollectionEnt ce = (MetalPartCollectionEnt)ents[i];
				if (ce.bIsValid())
				{ 
					_Entity.append(ents[i]);
					continue;
				}				
			}
		}

	//region Face Detection
		int bIsOrthoView=qdr.vecD(vecZView).isParallelTo(vecZView);
		int nFaceIndex = -1;
		PlaneProfile ppFace;
		Vector3d vecFace = bIsOrthoView ? vecZView : qdr.vecD(vecZView);// the most aligned face to the current view
	
	// orthogonal view, set ref or top side
		if(bIsOrthoView)
		{ 
			Vector3d vecDir = -vecFace;
			Vector3d vecX = vecDir.isParallelTo(gb.vecX())?gb.vecZ():gb.vecX();
			Vector3d vecY = vecX.crossProduct(-vecDir);
			ppFace = PlaneProfile(CoordSys(ptCen, vecX, vecY, vecFace));
			ppFace.unionWith(bd.shadowProfile(Plane(ptCen, vecFace)));
		}	
	// not in ortho view
		else
		{
			int bFront = true; //default to pick a face on viewing side
			Map mapArgs, mapFaces;
			mapArgs.setInt("_Highlight", in3dGraphicsMode());
			mapArgs.setInt("showFront", bFront);

			PlaneProfile pps[] = GetFacePlaneProfiles(gb, Vector3d());// zero length vector means all faces			
			if (pps.length() > 0)ppFace = pps.first();
			mapFaces = SetPlaneProfilesToMap(pps);
			mapArgs.setMap("Face[]", mapFaces);	
			
		//region Face selection
			int nGoJig = -1;
			PrPoint ssP(T("|Select face|")+ T(" |[Flip face]|"));
			ssP.setSnapMode(TRUE, 0); // turn off snaps
		    while (!bIsOrthoView && nGoJig != _kOk && nGoJig != _kNone)
		    {
		        nGoJig = ssP.goJig(kJigSelectFace, mapArgs); 
	
		        if (nGoJig == _kOk)
		        {
		            Point3d ptPick = ssP.value();
					int index=-1;

					for (int i=0;i<pps.length();i++) 
					{
						PlaneProfile pp = pps[i];
						CoordSys cs = pp.coordSys();
						Vector3d vecZ = cs.vecZ();
						if (vecZ.isPerpendicularTo(vecZView))continue;
						Point3d ptOrg = cs.ptOrg();
						double dFront = vecZ.dotProduct(vecZView);

						Point3d pt = ptPick;
						Line(pt, vecZView).hasIntersection(Plane(ptOrg, vecZ), pt);

						if(((dFront>0 && bFront) || (dFront<0 && !bFront)) && pp.pointInProfile(pt)==_kPointInProfile) // accept only profiles in view direction or opposite
						{
							index = i;
						}
					}  

		            if (index>-1)
		            { 
		            	vecFace = qdr.vecD(pps[index].coordSys().vecZ());
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
		        else if (nGoJig == _kCancel)
		        { 
		        	eraseInstance();
		        	return;
		        }
		        else
		        { 
		        	break;
		        }
		    }	
			ssP.setSnapMode(false, 0); // turn on snaps			    
			//End Face selection//endregion 		
		}	
	//Face Detection //endregion 	

		
		Point3d ptFace = qdr.pointAt(0,0,0) + .5 * vecFace * qdr.dD(vecFace);
		Plane pnFace = Plane(ptFace, vecFace);
		
		Vector3d vecDir = vecFace;
		Vector3d vecX = vecDir.isParallelTo(gb.vecX())?gb.vecZ():gb.vecX();
		Vector3d vecY = vecX.crossProduct(-vecDir);

		double mainDiameter = dDiameter;
		if (sDefinition!=tAddNew && sDefinition!=tDisabled && dDiameter<=0)
			mainDiameter = MainDiameter(sDefinition);


	//region PrPoint with Jig
		Point3d ptLocs[0];
		String prompt = T("|Pick point [X-Axis/Y-Axis/Perimeter/Offset]|");
		if (bIsOrthoView)
			prompt = T("|Pick point [X-Axis/Y-Axis/Perimeter/Offset/FlipSide]|");

		PrPoint ssP;
		if (ptLocs.length()<1)
			ssP= PrPoint(prompt);			
		else
			ssP= PrPoint(prompt, ptLocs.last());
	    Map mapArgs;
		mapArgs.setInt("isOrtho", bIsOrthoView);
		mapArgs.setVector3d("vecFace", vecFace);
		mapArgs.setPlaneProfile("pp", ppFace);
		mapArgs.setDouble("diameter", mainDiameter);

	    int nSnapType; // 0 = X-Axis,1=Y-Axis, 2=Perimeter
	    double dSnapOffset;
	    
	    EntPLine epls[0];
	    CreateJigEpls(ppFace, nSnapType, dSnapOffset);

	    int nGoJig = -1;
	    while (nGoJig != _kNone)//nGoJig != _kOk && 
	    {

	        nGoJig = ssP.goJig(kJigPickLocation, mapArgs); 
	        if (bDebug)reportMessage("\ngoJig returned: " + nGoJig);
	        
	        if (nGoJig == _kOk)
	        {
	            Point3d ptPick = ssP.value(); //retrieve the selected point
	            Line(ptPick, vecFace).hasIntersection(pnFace, ptPick);
	            ptLocs.append(ptPick); //append the selected points to the list of grippoints _PtG
	            
	        
	        // create TSL
	        	TslInst tslNew;					Vector3d vecXTsl= vecX;				Vector3d vecYTsl= vecY;
	        	//GenBeam gbsTsl[] = {_GenBeam};	Entity entsTsl[] = {_Entity};
	        	Point3d ptsTsl[] = {ptPick};
	        	
	        	Map mapTsl;	
	        				
	        	tslNew.dbCreate(scriptName() , vecXTsl ,vecYTsl,_GenBeam, _Entity, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);			

	        }
	        else if (nGoJig == _kKeyWord)
	        { 
	        	int keywordIndex = ssP.keywordIndex();
	            if (keywordIndex == 0)
	            {
	            	nSnapType= 0;
	            }
	            if (keywordIndex == 1)
	            {
	            	nSnapType = 1;
	            }	            
	            else if  (keywordIndex == 2)
	            {
	            	nSnapType= 2;
	            }
	            else if  (keywordIndex == 3)//offset
	            { 
	            	dSnapOffset = getDouble(T("|Enter offset of snap linework|"));		            	
	            	
	            }
	            else if  (keywordIndex == 4)//flip side
	            { 
	            	vecX*=-1;
	            	vecFace*=-1;
	            	mapArgs.setVector3d("vecFace", vecFace);
	            	
	            }	            
	           	CreateJigEpls(ppFace, nSnapType, dSnapOffset);	    
	        }
	        else if (nGoJig == _kCancel)
	        { 
	        	PurgeJigEpls();
	            eraseInstance(); // do not insert this instance
	            return; 
	        }
	    }
		PurgeJigEpls();

			
	//endregion 
		eraseInstance(); 
		return;
	}			


	if (_Map.getInt("mode")==99 || _Map.getInt("mode")==98)
	{ 
		Map mapFilter = _Map.getMap("Filter");
		Map mapFasteners = ShowFastenerManager(mapFilter);			
		String sNewDefinitions[] = CreateFastenerStyle(mapFasteners);
		
		if (_Map.getInt("mode")==99)
		{ 
			if (sNewDefinitions.length()>0)
				reportNotice("\n" + T("|Please execute command  to use one of the existing fasteners.|"));			
			else
				reportNotice("\n" + T("|Please execute command again to create at least one fastener style.|"));			
		}

		eraseInstance();
		return;		
	}
	else
		setReadOnlyFlagOfProperties();


//endregion 

//Part #1 //endregion 

//region Part #2

//region Add New: Trigger Add/Edit Fastener Definitions or byProperty
	String sTriggerAddEdit = T("|Add/Edit Fastener (Double Click)|");
	addRecalcTrigger(_kContext, sTriggerAddEdit);
	
	int bAddNewTrigger = _bOnRecalc && (_kExecuteKey == sTriggerAddEdit || _kExecuteKey == sDoubleClick);
	int bAddNewProperty =_kNameLastChangedProp==sDefinitionName && sDefinition==tAddNew;

	if (bAddNewTrigger || bAddNewProperty)
	{		
		Map mapFilter;
		Map mapFasteners = ShowFastenerManager(mapFilter);			
		String sNewDefinitions[] = CreateFastenerStyle(mapFasteners);	
		
		if (bAddNewProperty)sDefinition.set(tDisabled);
		setExecutionLoops(2);
		return;
	}	

	if (_kNameLastChangedProp==sDefinitionName && sDefinition==tAddNew)
	{		
		Map mapFilter;
		Map mapFasteners = ShowFastenerManager(mapFilter);			
		String sNewDefinitions[] = CreateFastenerStyle(mapFasteners);
		
		
		setExecutionLoops(2);
		return;
	}
//endregion 

//region Control diameter by definition
	double mainDiameter = dDiameter;
	if (sDefinition!=tAddNew && sDefinition!=tDisabled && dDiameter<=0)
	{ 	
		mainDiameter = MainDiameter(sDefinition);
		if (mainDiameter>0 && _kNameLastChangedProp==sDefinitionName)
		{
			dDiameter.set(mainDiameter);
			dLength.set(0); // auto length
			setExecutionLoops(2);
			return;
		}	
	}		
//endregion 

//region General
	if (_GenBeam.length()<1)
	{ 
		reportMessage("\n" +scriptName()+ T(" |no referrenced genbeamm found|"));
		eraseInstance();
		return;
	}
	if (_bOnDbCreated)setExecutionLoops(2);
	setKeepReferenceToGenBeamDuringCopy(_kAllBeams);
	setEraseAndCopyWithBeams(_kNoBeams);

// Grip
	Vector3d vecOffsetApplied;
	int indexOfMovedGrip = Grip().indexOfMovedGrip(_Grip);
	int bDrag, bOnDragEnd;
	if (indexOfMovedGrip>-1)
	{ 
		bDrag = _bOnGripPointDrag && _kExecuteKey=="_Grip";
		bOnDragEnd = !_bOnGripPointDrag;
		vecOffsetApplied = _Grip[indexOfMovedGrip].vecOffsetApplied();
	}
	
// Display
	int nc = 252;
	Display dp(nc);
	String dimStyle = _DimStyles.first();
	dp.dimStyle(dimStyle);
	double textHeight = dTextHeight > 0 ? dTextHeight : dp.textHeightForStyle("G", dimStyle);
	dp.textHeight(textHeight);		

// draw onDrag
	if (bDrag && !bOnDragEnd)
	{ 
		Grip g = _Grip[indexOfMovedGrip];
		String name = g.name();
		Point3d ptLoc = g.ptLoc();
		
		Map m;
		int bHasMap = m.setDxContent(name, true);
		
//		Point3d ptStart = m.getPoint3d("ptStart");
//		Body bd = m.getBody("bd");
//		bd.transformBy(ptLoc - ptStart);
//		if ( ! bd.isNull())dp.draw(bd);
		
		
		Entity ents[] = m.getEntityArray("Genbeam[]", "", "GenBeam");
		
		Display dpx(-1);
		dpx.trueColor(lightblue);
		
		Plane pn(_PtW, vecZView);
		for (int i=0;i<ents.length();i++) 
		{ 
			Body bd= ents[i].realBody();
			PlaneProfile pp = bd.shadowProfile(pn);
			dpx.draw(pp,_kDrawFilled, 80); 
		}//next i
	
		
		
		if (m.getMapName()=="Tag")
			dp.draw(m.getString("text"), ptLoc, vecXView, vecYView, 1, 0);
		else
			reportNotice("\nunknown grip");
		
		return;
	}










// Store ThisInst in _Map to enable debugging with submapx and fastenerGuideLines until HSB-22564 is implemented
	TslInst this = _ThisInst;
	if (bDebug && _Map.hasEntity("thisInst"))
	{
		Entity ent = _Map.getEntity("thisInst");	
		this = (TslInst)ent;
	}
	else if (_bOnDbCreated || !_Map.hasEntity("thisInst"))
		_Map.setEntity("thisInst", this);

	double dRadius = mainDiameter * .5+dGap;
	double dRadiusSink = (dDiameterSink > mainDiameter || dRadius<=dEps)  ? dDiameterSink * .5:0; // HSB-22866 accepting exclusivly sink hole
	double dMaxRadius = dRadius > dRadiusSink ? dRadius : dRadiusSink;
//endregion 

//region GenBeam References and extreme intersections with drill axis	
	Vector3d vecDir = -_ZE;
	Line lnDir(_Pt0, vecDir);
	
	GenBeam gbs[] = GetGenBeamsIntersect(_GenBeam, _Pt0, vecDir, dMaxRadius);
// TODO: the following is obsolete	
//	if (gbs.length()<1 && !bDebug)
//	{ 
//		reportNotice("\n" + T("|No intersection found|"));
//
//		for (int i=_Entity.length()-1; i>=0 ; i--) 
//		{ 
//			FastenerAssemblyEnt fae =(FastenerAssemblyEnt) _Entity[i]; 
//			if (fae.bIsValid())
//				fae.dbErase();
// 
//		}//next i		
//		
//		eraseInstance();
//		return;
//	}

	Plane pn1, pn2;
	GetExtremePlanes(gbs, pn1, pn2, vecDir, _Pt0, dMaxRadius);	//pn1.vis(2);pn2.vis(3);

	GenBeam gbRef = gbs[0];	
	Vector3d vecX = gbRef.vecX();
	if (vecDir.isParallelTo(vecX))
		vecX = gbRef.vecY();
	vecX = vecX.crossProduct(-vecDir).crossProduct(vecDir); vecX.normalize();
	Vector3d vecY = vecX.crossProduct(-vecDir);	
	Vector3d vecZ = vecDir;	
	double dZ = gbRef.dD(vecZ);
	assignToGroups(gbRef, 'T');
	
	Point3d pt = _Pt0;	

//region Debug
//
//	if (bDebug)
//	{ 
//		int index = - 1;
//		int bFront = true;
//
//		Map mapFaces = SetGenBeamFaces(gbRef);
//		_Pt0.vis(1);
//		PlaneProfile pps[] = GetFaceProfiles(gbRef.ptCen(), mapFaces, index, bFront);
//		DrawFaces(pps, index);
//	
//	}
//		
//endregion

	Point3d ptStart,ptEnd;
	PLine circle; circle.createCircle(pt, vecDir, dMaxRadius); //circle.vis(40);
	
	if (lnDir.hasIntersection(pn1, ptStart) && lnDir.hasIntersection(pn2, ptEnd))
	{ 	
		;// collecting pt1 and pt2
	}
	else
	{ 
		ptStart = _Pt0 + vecDir * .5 * dZ;
		ptEnd = _Pt0 - vecDir * .5 * dZ;		
	}
	_Pt0 = ptStart;	
	double dStartExtreme = TransformPointToExtreme(ptStart, circle, pn1, - vecDir);
	double dEndExtreme = TransformPointToExtreme(ptEnd, circle, pn2, vecDir);
	
	// static length selected
	if (dLength>0)
		ptEnd = ptStart + vecDir * dLength;
	dZ = abs(vecDir.dotProduct(ptStart - ptEnd));
	//vecZ.vis(ptStart,150);
	vecZ.vis(ptEnd,150);

	

//region Penetration Depth Given
	int bHasValidPenetration;
	Point3d ptStartPenetration=_Pt0, ptPenetration=_Pt0;;
	//if (dPenetrationDepth>dEps)
	{ 
		GenBeam gbsP[] ={ gbs.last()};
		Plane pnP1, pnP2;
		GetExtremePlanes(gbsP, pnP1, pnP2, vecDir, _Pt0, dRadius);	pnP1.vis(1);pnP2.vis(4);
		Point3d ptEndP;
		lnDir.hasIntersection(pnP1, ptStartPenetration) && lnDir.hasIntersection(pnP2, ptEndP);

		ptPenetration = ptStartPenetration + vecDir * dPenetrationDepth;

		double dD = vecDir.dotProduct(ptEndP - ptPenetration);
		if (dD>0)
			bHasValidPenetration = true;	
	}


//region Collect Valid Fastener Lengths
	FastenerAssemblyEnt faes[] = this.getAttachedFasteners();
	double dValidFastenerLengths[0];
	if (dLength<=0)
	{ 
		for (int i=0;i<dFastenerLengths.length();i++) 
		{ 
			double fastenerLength = dFastenerLengths[i]; 
			double threadLength = dThreadLengths[i]; // assuming it is a full thread screw if not given
			
			Point3d ptFastenerEnd = _Pt0 + vecDir * fastenerLength;
			Point3d ptStartThread = ptStart + vecDir * threadLength;
					
			int bValidThreadStart = vecDir.dotProduct(ptStartPenetration - ptStartThread)>=0;
			int bValidFastenerEnd = vecDir.dotProduct(ptEnd-ptFastenerEnd)>=0 && vecDir.dotProduct(ptFastenerEnd-ptStartPenetration)>=0;
			int bValidPenetration = dPenetrationDepth <= dEps || vecDir.dotProduct(ptFastenerEnd - ptPenetration) >= 0;
	
			if (bValidThreadStart && bValidFastenerEnd && bValidPenetration)
			{ 
				if (bDebug)
				{
					ptStartThread.vis(20);
					PLine(_Pt0, ptStartThread,ptStartThread + vecX * U(10), ptFastenerEnd).vis(3);	
				}
				dValidFastenerLengths.append(fastenerLength);
			}	
			else if (bDebug)
			{ 
				PLine(_Pt0, ptStartThread - vecX * U(10), ptFastenerEnd).vis(1);
			}
		}//next i
		
	// use max length if no penetration depth given	
		if (dPenetrationDepth <= dEps)
		{ 
			dValidFastenerLengths.reverse();
		}		
	}
	// custom article selection
	else
	{ 
		dValidFastenerLengths.append(dLength);
	}

// set holding distance to valid length
	double fastenerLength;
	if (dValidFastenerLengths.length()>0)
		fastenerLength = dValidFastenerLengths.first();
//	else if (dLength>0)
//		fastenerLength = dLength;
//	else if (faes.length()>0)
//	{ 
//		fastenerLength = GetLengthFromArticleNumber(faes.first());
//	}

//endregion 




//endregion


//endregion 

//Part #2 //endregion 

////Debug
//{ 
//	
//	//Vector3d vecDir=gbRef.vecX();
//	PlaneProfile pps [] = GetFacePlaneProfiles(gbRef,-vecDir);
//	
//	
//	for (int i=0;i<pps.length();i++) 
//	{ 
//		Display dpx(i + 1);
//		dpx.draw(pps[i], _kDrawFilled, 60); 
//
//		 
//	}//next i
//}


//region Get Drill and Stack length
	//if (bDebug))reportNotice("\n\nStart " + scriptName() +" "+ this.handle());		
	GenBeam gbsDrill[0]; gbsDrill = gbs; // HSB-22860
	if (gbsDrill.length()>1)
		gbsDrill.setLength(gbsDrill.length()-1);
		
	if (dRadius>0)
	{ 
		double depth = fastenerLength;
		if (depth<=0 && faes.length()>0)
			depth = GetLengthFromArticleNumber(faes.first());		
		else if (depth<=0)
			depth = vecZ.dotProduct(ptEnd-ptStart);
		// HSB-22866 drill first beam if no secondary found
		Point3d pt2 =ptStart+vecZ*depth;// gbs.length()==1?ptStart+vecZ*fastenerLength:ptStartPenetration;
		Drill dr(ptStart-vecZ*dEps, pt2, dRadius);		dr.cuttingBody().vis(2);
		dr.addMeToGenBeamsIntersect(gbsDrill);	
	}
	Point3d ptSteps[0];
	double depthSink = dDepthSink>0?dDepthSink:2*dStartExtreme;
	if (dRadiusSink>dRadius && depthSink >dEps)
	{ 
		ptSteps.append(ptStart);
		ptSteps.append(ptStart+vecDir*depthSink);
		
		Drill dr(ptSteps[0]-vecDir*dEps, ptSteps[1], dRadiusSink);
		
		dr.addMeToGenBeamsIntersect(gbsDrill);// HSB-22866
//		for (int i=0;i<gbs.length()-1;i++) 
//		{ 
//			gbs[i].addTool(dr); 			 
//		}//next i
		
	}	

	if (mainDiameter>0 && indexOfMovedGrip<0)
	{ 
		FastenerGuideline fg(ptStart, ptEnd, mainDiameter * .5);
		if (ptSteps.length()>1)
			fg.addStep(ptSteps[0], ptSteps[1], dRadiusSink); 
		this.resetFastenerGuidelines();
		this.addFastenerGuideline(fg);
		fg.vis(40);
	}	
	
// report fgl
	FastenerGuideline fgls[] = this.fastenerGuidelines();
	//if (bDebug)reportNotice("\n   GuideLines: "+fgls.length() + " faes:" +faes.length()  + " " +faes); 

	//vecDir.vis(_Pt0, 2);
//endregion 



//region Create FastenerAssembly


// Get potential fastenerAssemblyEnt
	Body bd;
	FastenerAssemblyEnt fae;
	if (faes.length()>0)
	{
		fae = faes.first();
	}
	if (fae.bIsValid())
	{ 
		if ((_kNameLastChangedProp==sDefinitionName || _kNameLastChangedProp==sDiameterName) && !bDebug)
		{ 
			reportMessage(TN("|Purging fastener|") + fae.handle());			
			fae.dbErase();	
		}
		else
		{ 	
			bd = fae.realBody();
		
		// anchor the fae to the tool ent
			if (this.getAttachedFasteners().find(fae)<0)
			{ 
				int bSuccess= fae.anchorTo(this,ptStart,U(1));
				if (bDebug)reportNotice("\n   after anchoring valid: " + fae.bIsValid() + ", handle:"  + fae.handle()+ " success = " + bSuccess + " attached=" + this.getAttachedFasteners());			
			}
			
			if (_kNameLastChangedProp==sLengthName || _kNameLastChangedProp==sPenetrationDepthName)
			{ 
				String articleNumber;
			// fastener attached, but becomes invalid	
				if (fastenerLength<dEps)
				{ 
					reportMessage(TN("|Purging fastener with invalid length| ") + fastenerLength);
					fae.dbErase();
				}
			// get article from fastener length	
				else if (fastenerLength>0)
				{ 
					FastenerListComponent flc;
					articleNumber = GetArticleNumberFromLength(fae.definition(), fastenerLength, flc);
					fae.setArticleNumber(articleNumber);
					if(fae.bIsValid())
						fae.setHoldingDistance(fastenerLength, true);	
					
					if (bDebug)reportNotice("\n   length or penetration modified article " +articleNumber);
				}
				dLength.set(0);
			}
								
			else
			{ 
				double dLengthFae = GetLengthFromArticleNumber(fae);				
				if (abs(dLengthFae!=fastenerLength))
				{
					if (bDebug)reportNotice("\n   current vs expected length = " +dLengthFae + " vs " + fastenerLength);
					dLength.set(dLengthFae);
				}
			}
		}
	}
//	else if(sMode==tModeFae)
//	{ 
//		double dist = vecDir.dotProduct(ptEnd - ptStart);
//		String text = sDefinition + T(": |could not find any matching fastener for required length| ") + dist;
//		text += TN("|Select required length or choose another fastener.|");
//		reportNotice("\n"+text);
//	}

// Get Current FastenerAssemblyDef
	String definition = sDefinition;
	FastenerAssemblyDef fadef;
	FastenerSimpleComponent fscMain;
	if (fae.bIsValid())
	{
		definition = fae.definition();
		fadef = FastenerAssemblyDef(definition);
		fscMain=fadef.mainComponent(fae.articleNumber());
	}
	else if (sDefinition!=tAddNew && sDefinition!=tDisabled)
	{
		fadef=FastenerAssemblyDef(sDefinition);			
	}

	

//  Create a new FAE in the acad database
	if (sMode==tModeFae && !fae.bIsValid() && fadef.bIsValid() && fastenerLength>0)
	{ 
		if (bDebug)reportNotice("\n   Creating new fae during loop " + _kExecutionLoopCount);
		fae.dbCreate(sDefinition, CoordSys(ptStart, vecX,vecY,vecZ));
		if (fae.bIsValid())
		{ 			
		// Control article by length
			fae.setLengthSelectionIsAutomatic(false);
			if (fastenerLength>0)
			{ 
				FastenerListComponent flc;
				String articleNumber = GetArticleNumberFromLength(fae.definition(), fastenerLength , flc);
				if (articleNumber!="")
				{
					if (bDebug)reportNotice("\n   fae valid " +fae.bIsValid() + ", " + fae.handle() + " setting article "+ articleNumber);
					fae.setArticleNumber(articleNumber);
					fae.setHoldingDistance(fastenerLength, true);
				}
			}
			int bSuccess= fae.anchorTo(this,ptStart,U(1));
			

			if(!bDebug)
				setExecutionLoops(2);
			else
				reportNotice( "\n" + fae.handle() + " is valid "+ fae.bIsValid()  + " and anchored: "+bSuccess);
		}
	}
//	else if (sMode==tModeHwc)
//	{ 
//		fscMain = fadef.listComponent();
//	}
//endregion 


//region Output / Hardware
	
	String text =sDefinition;
	
//region Collect Fastener Data

	Map mapSimpleComponent;
	if (sMode==tModeHwc)
	{
		for (int i=dValidFastenerLengths.length()-1; i>=0 ; i--) 
		{ 
			double length =dValidFastenerLengths[i]; 
			if (length<=fastenerLength)
			{ 
				FastenerListComponent flc;
				String articleNumber = GetArticleNumberFromLength(sDefinition, length, flc);
				mapSimpleComponent = ListComponentToMap(flc, articleNumber);
				break;
			}
			
		}//next i	
	}
	else	
		mapSimpleComponent = SimpleComponentToMap(fscMain);


	Map mapComponentData = mapSimpleComponent.getMap("ComponentData");
	Map mapArticleData= mapSimpleComponent.getMap("ArticleData");
	
	double dStackThickness = mapComponentData.getDouble("stackThickness");
	fastenerLength = mapArticleData.getDouble("fastenerLength");
	double threadLength = mapArticleData.getDouble("threadLength");	


	if (fae.bIsValid())
	{ 
		mapAdd.copyMembersFrom(mapComponentData);
		mapAdd.copyMembersFrom(mapArticleData);
		mapAdd.setDouble("HoldingDistance", fae.holdingDistance());
		sFormat.setDefinesFormatting(fae, mapAdd);
		text =fae.formatObject(sFormat, mapAdd);		
		
//		if (bDebug)//purge debug fastener ent
//			fae.dbErase();
	}
	else if (sMode==tModeHwc)
	{ 
		mapAdd.copyMembersFrom(mapComponentData);
		mapAdd.copyMembersFrom(mapArticleData);
		sFormat.setDefinesFormatting(this, mapAdd);
		text =this.formatObject(sFormat, mapAdd);		
	}
	
// Get family name if stored in articleData
	String sFamily = mapArticleData.getString("Family");//GetFastenerEntFamily(fae);
	if (fae.bIsValid() && sFamily.length()>0)
		_Map.setString("family", sFamily);
	else
		_Map.removeAt("family", true);	
//endregion 

//region Grip #GM
	int bAddGrip = text.length()>0;

	addRecalcTrigger(_kGripPointDrag, "_Grip");	

	
	int nGrip = GetGripByName(_Grip, "Tag");

	Point3d ptLocDefault = _Pt0 - vecDir * (dStackThickness + textHeight) + (vecX + vecY) * mainDiameter;
	Point3d ptTag = nGrip>-1? _Grip[nGrip].ptLoc():ptLocDefault;
	
	//Remove Grip
	if (nGrip>-1 && !bAddGrip)
	{ 
		_Grip.removeAt(nGrip);
		nGrip = -1;
	}
	//Add Grip
	else if (nGrip<0 && bAddGrip)
	{ 	
		Map m;
		m.setMapName("Tag");
		m.setString("Text", text);
		m.setPoint3d("ptStart", ptStart);
		m.setBody("bd", bd);
		String name = m.getDxContent(true); 
				
		Grip g;
		g.setName(name);
		g.setPtLoc(ptTag);
		g.setVecX(_XE);
		g.setVecY(_YE);
		//g.addViewDirection(_ZE);
		g.setColor(40);
		g.setShapeType(_kGSTCircle);				
		g.setToolTip(T("|Moves the tag of the entity|"));	
		
		_Grip.append(g);
		nGrip = _Grip.length() - 1;		
	}	
	// Relocate grip: tag grip may not be at _Pt0
	else if ((ptTag-_Pt0).length()<dEps)
	{ 
		ptTag = ptLocDefault;
		_Grip[nGrip].setPtLoc(ptTag);
	}	
	
	if (nGrip>-1)
	{
		Map m;
		m.setMapName("Tag");
		m.setString("Text", text);
		m.setPoint3d("ptStart", ptStart);
		m.setBody("bd", bd);
		m.setEntityArray(gbs, false, "Genbeam[]", "", "GenBeam");
		String name = m.getDxContent(true);
		
		_Grip[nGrip].setName(name);
		
	}

	
	
//endregion 

//region Validate thread length against penetration depth
	Point3d ptStartThread = ptStart + vecDir * threadLength;					ptStartThread.vis(20);
	if (bHasValidPenetration)
	{ 
	// assuming it is a full thread screw if not given
		Point3d ptStartPenetration = ptPenetration - vecDir * dPenetrationDepth;	ptStartPenetration.vis(2);
		double d1 = vecDir.dotProduct(ptStartPenetration - ptStartThread);
		double d2 = vecDir.dotProduct(ptEnd-ptPenetration);
		if (d1<dEps || d2<dEps)
			bHasValidPenetration = false;
	}
	ptPenetration.vis(bHasValidPenetration?3:1);
	int nColorThread = 101;
	if (dPenetrationDepth>dEps && !bHasValidPenetration)
		nColorThread = 1;
//endregion 


//region Hardware
// collect existing hardware
	HardWrComp hwcs[] = this.hardWrComps();
	
// remove any tsl repType: the assumption is that any hardware component of type _kRTTsl has been attached by this instance
	for (int i=hwcs.length()-1; i>=0 ; i--) 
		if (hwcs[i].repType() == _kRTTsl)
			hwcs.removeAt(i); 
	if (sMode==tModeHwc)
	{ 	
		if (fae.bIsValid())
		{
			//reportNotice("\nerase on hardware mode");
			fae.dbErase();
		}

		HardWrComp hwc;
		int bHasHardware = SimpleComponentToHardware(hwc, 1, mapSimpleComponent);
		if (bHasHardware)
			hwcs.append(hwc);

		
		Point3d pt2 = _Pt0 + vecDir * (fastenerLength - threadLength);
		dp.draw(PLine(_Pt0, pt2));
		dp.color(nColorThread);
		
		PLine circ; circ.createCircle(pt2, vecDir, mainDiameter * .5);
		dp.draw(circ);
		dp.draw(PLine(pt2, pt2 + vecDir * threadLength));
		
		circ.createCircle(pt2 + vecDir * threadLength, vecDir, mainDiameter * .5);
		dp.draw(circ);
		
		dp.color(nc);
		
	}
	else
	{ 
		
		int nCurrentColor = fae.color();
		int nColor = (dPenetrationDepth>dEps && !bHasValidPenetration)?1:nc;
		if (nColor!=nCurrentColor)
			fae.setColor(nColor);
	}
	this.setHardWrComps(hwcs);
//endregion 

//Output / Hardware //endregion 

	

//region TRIGGER #TR

//region Trigger Add Beams
	String sTriggerAddBeams = T("|Add Genbeams|");
	addRecalcTrigger(_kContextRoot, sTriggerAddBeams);
	if (_bOnRecalc && _kExecuteKey==sTriggerAddBeams)
	{
	// prompt for beams
		Entity ents[0];
		PrEntity ssE(T("|Select additional genbeams|"), GenBeam());
		if (ssE.go())
			ents.append(ssE.set());

		Body bdTest(pt, vecDir * U(10e5), 0);
		for (int i=0;i<ents.length();i++) 
		{ 
			GenBeam g = (GenBeam)ents[i]; 
			if (g.bIsDummy())continue;
			
//			Body bd = g.envelopeBody(true, true);
//			if (bd.hasIntersection(bdTest))
			{ 
				_GenBeam.append(g);
			}
		}//next i

		dLength.set(0);
		if (fae.bIsValid())
			fae.dbErase();

		
		pushCommandOnCommandStack("_HSB_Recalc");
		pushCommandOnCommandStack("(handent \""+this.handle()+"\")");	
		pushCommandOnCommandStack("(Command \"\")");
		
		
		setExecutionLoops(2);
		return;
	}//endregion

//region Trigger Remove Genbeam
	String sTriggerRemoveGenBeams = T("|Remove Genbeams|");
	if (gbs.length()>1)addRecalcTrigger(_kContextRoot, sTriggerRemoveGenBeams);
	if (_bOnRecalc && _kExecuteKey==sTriggerRemoveGenBeams)
	{
	// prompt for genbeams
		Entity ents[0];
		PrEntity ssE(T("|Select genbeams|"), GenBeam());
		if (ssE.go())
			ents.append(ssE.set());

		Body bdTest(pt, vecDir * U(10e5), 0);
		for (int i=0;i<ents.length();i++) 
		{ 
			GenBeam g = (GenBeam)ents[i]; 
			// indices of _GenBeam and intersecting genbeams could be different
			int n1 = _GenBeam.find(g);
			int n2 = gbs.find(g);
			if(n1>-1)
				_GenBeam.removeAt(n1);
			if(n2>-1)
				gbs.removeAt(n2);

			if (gbs.length()==1)
				break;
		}//next i

		setExecutionLoops(2);
		return;
	}//endregion

//region Trigger Rotate //compare and update template HSB-22506 
	String sTriggerRotate = T("|Rotate|");
	addRecalcTrigger(_kContextRoot, sTriggerRotate);
	if (_bOnRecalc && _kExecuteKey==sTriggerRotate)
	{	
		int bCancel,indexAxis;//0=X, 1=Y, 2=Z
		double dAngle;
		Vector3d vecZR = -vecDir;
		Vector3d vecXR = vecY.isParallelTo(vecZR)?vecX.crossProduct(vecZR):vecY.crossProduct(vecZR);
		Vector3d vecYR = vecXR.crossProduct(-vecZR);
		CoordSys cs = CoordSys(_Pt0, vecZR, vecYR, vecXR), csRot;	

		Display dp(3);
		dp.draw(bd);
		dp.close();

	//region Select Axis Jig
	
		// Do not show axis jig if view is orthogonal to one of the axes
		if (cs.vecX().isParallelTo(vecZView))
			indexAxis = 0;
		else if (cs.vecY().isParallelTo(vecZView))
			indexAxis = 1;
		else if (cs.vecZ().isParallelTo(vecZView))
			indexAxis = 2;
		else	
		{ 
			PrPoint ssP(T("|Select axis|")); // second argument will set _PtBase in map
		    ssP.setSnapMode(TRUE, 0);
		    Map mapArgs;
		    PlaneProfile pp(cs);
		    mapArgs.setPlaneProfile("pp", pp); // carries coordSys
		
		    double diameter = dViewHeight * .15;
		    PLine circles[] = GetCoordSysCircles(cs, diameter);
	
		    int nGoJig = -1;
		    while (nGoJig != _kOk && nGoJig != _kNone)
		    {
	
		        nGoJig = ssP.goJig(kJigSelectAxis, mapArgs); 
		        if (bDebug)reportMessage("\ngoJig returned: " + nGoJig);
		        
		        if (nGoJig == _kOk)
		        {
		            Point3d ptPick  = ssP.value(); //retrieve the selected point
		            Line(ptPick, vecZView).hasIntersection(Plane(_Pt0, vecZView), ptPick);
		            indexAxis = GetClosestCircle(ptPick, circles);
		            //reportNotice("\nSelect axis = " +indexAxis);
		        }
		        else if (nGoJig == _kCancel)
		        { 
		        	bCancel = true;
		        	break;
		        }
		    }	

		}//End Select Axis Jig
		
	// Get a coordSys with a normal towardy the users view
	    if (indexAxis==0)//RotateBy X-Axis
	    	cs = AlignCoordSysView(cs.ptOrg(), cs.vecY(), cs.vecZ(), cs.vecX());
	    else if (indexAxis==1)//RotateBy Y-Axis
	    	cs = AlignCoordSysView(cs.ptOrg(), -cs.vecX(), cs.vecZ(), cs.vecY());
	    else if (indexAxis==2)//RotateBy Z-Axis
	    	cs = AlignCoordSysView(cs.ptOrg(), cs.vecX(), cs.vecY(), cs.vecZ());		
	//endregion 

	//region Show Rotation Jig
	EntPLine epls[0];
	{ 

//		PlaneProfile ppShadow(cs);
//		ppShadow.unionWith(bd.shadowProfile(Plane(cs.ptOrg(), cs.vecZ())));
//		PLine rings[] = ppShadow.allRings();  	
//    	for (int r=0;r<rings.length();r++) 
//    	{ 
//    		EntPLine epl;
//    		epl.dbCreate(rings[r]);
//    		epl.setTrueColor(lightblue);
//    		epl.setTransparency(80);
//			epls.append(epl);
//    	}//next r	   


		PrPoint ssP(T("|Pick point to rotate [Angle/Basepoint/ReferenceLine]|"));
		
	    Map mapArgs;
		Point3d pt = cs.ptOrg();
	    Plane pn(pt, cs.vecZ());
	    
	    PlaneProfile pp(cs);
	    mapArgs.setPlaneProfile("pp", pp); // carries coordSys
		mapArgs.setInt("indexAxis", indexAxis); 
		mapArgs.setBody("bd", bd); 
	
	    double diameter = dViewHeight * .15;
	    PLine circle;
	    circle.createCircle(pt, cs.vecZ(), diameter);

	    int nGoJig = -1;
	    while (!bCancel && nGoJig != _kOk && nGoJig != _kNone)
	    {

	        nGoJig = ssP.goJig(kJigRotation, mapArgs); 
	        if (bDebug)reportMessage("\ngoJig returned: " + nGoJig);        
	        if (nGoJig == _kOk)
	        {
	            Point3d ptPick  = ssP.value(); //retrieve the selected point
	            Line(ptPick, vecZView).hasIntersection(pn, ptPick);
	            
	            double diameter = dViewHeight * .15; // HSB-22689 incremental rotation fixed
	            Vector3d vecPick = ptPick-pt;
	            
	            double dGridAngle;
	            dAngle = GetAngle(vecPick, cs.vecX(), cs.vecZ(), diameter, dGridAngle);
	        }
	        else if (nGoJig == _kKeyWord)
	        { 
	            if (ssP.keywordIndex() == 0)
	            { 
	            	dAngle = getDouble(T("|Enter angle in degrees|"));
	            	break;
	            }
	            else if (ssP.keywordIndex() == 1)
	            {
	            	pt = getPoint(T("|Select base point|"));
	            	pn=Plane (pt, cs.vecZ());
	            	cs= CoordSys(pt, cs.vecX(), cs.vecY(), cs.vecZ());
	            	pp = PlaneProfile(cs);
	            	mapArgs.setPlaneProfile("pp", pp);	
	            	ssP=PrPoint (T("|Pick point to rotate [Angle/Basepoint/ReferenceLine]|"), pt);
	            }
	            else if (ssP.keywordIndex() == 2)
	            {            	
				//region Show ReferenceLineJig
					PrPoint ssP2(T("|Select point on reference line|")); // second argument will set _PtBase in map

				    int nGoJig2 = -1;
				    while (nGoJig2 != _kOk && nGoJig != _kNone)
				    {
				        nGoJig2 = ssP2.goJig(kJigReferenceLine, mapArgs); 
				        if (bDebug)reportMessage("\ngoJig returned: " + nGoJig2);
				        
				        if (nGoJig2 == _kOk)
				        {
			            	Point3d ptPick =ssP2.value();
			            	Line(ptPick, vecZView).hasIntersection(pn, ptPick);
			            	Vector3d vecXB = ptPick - pt; vecXB.normalize();
			            	cs= CoordSys(pt, vecXB, vecXB.crossProduct(-cs.vecZ()), cs.vecZ());
			            	pp = PlaneProfile(cs);
			            	mapArgs.setPlaneProfile("pp", pp);	
			            	
			            	ssP=PrPoint (T("|Pick point to rotate [Angle/Basepoint/ReferenceLine]|"), pt);
				        }
				        else if (nGoJig2 == _kCancel)
				        { 
				            break;
				        }
				    }			
				//End Show Jig//endregion 
	            }		            
	        }
	        else if (nGoJig == _kCancel)
	        { 
	        	bCancel = true;
	        	break;
	        }
	    }			
	}//End Rotation Jig//endregion 

	// Apply Rotation
		if (!bCancel && abs(dAngle)>0)
		{ 
			csRot.setToRotation(dAngle, cs.vecZ(), cs.ptOrg());
			_ThisInst.transformBy(csRot);
	
		}
		
//	// purge jig plines
//	    for (int i=epls.length()-1; i>=0 ; i--) 
//	    { 
//	    	if (epls[i].bIsValid())
//	    		epls[i].dbErase(); 
//	    	
//	    }//next i		
		
		
		setExecutionLoops(2);
		return;
	}//endregion	
	
//region Trigger FlipFace
	String sTriggerFlipFace = T("|Flip Face|");
	addRecalcTrigger(_kContextRoot, sTriggerFlipFace );
	if (_bOnRecalc && _kExecuteKey==sTriggerFlipFace)
	{
		CoordSys csRot;	
		csRot.setToRotation(180, vecY, _Pt0);
		_ThisInst.transformBy(csRot);				
		setExecutionLoops(2);
		return;
	}//endregion	

//region Trigger Show StyleManager
	String sTriggerShowStyleManager = T("|Show StyleManager|");
	addRecalcTrigger(_kContext, sTriggerShowStyleManager);
	if (_bOnRecalc && _kExecuteKey==sTriggerShowStyleManager)
	{		
		pushCommandOnCommandStack("_AecStyleManager ;");		
		setExecutionLoops(2);
		return;
	}//endregion
	
//region Trigger Load Ruleset
	String sTriggerLoadRuleset = T("|Load Graphical Ruleset|");
	addRecalcTrigger(_kContext, sTriggerLoadRuleset);
	if (_bOnRecalc && _kExecuteKey==sTriggerLoadRuleset)
	{		
		pushCommandOnCommandStack("hsb_fa_importgraphicsruleset ");		
		setExecutionLoops(2);
		return;
	}//endregion		

//region Trigger Load Ruleset
	String sTriggerChangeDB = T("|Change Database|");
	addRecalcTrigger(_kContext, sTriggerChangeDB);
	if (_bOnRecalc && _kExecuteKey==sTriggerChangeDB)
	{		
		callDotNetFunction2(kFastenerLib, kFastenerClass, kShowDatabaseManagerCommand);	
		setExecutionLoops(2);
		return;
	}//endregion	
	
	
	
//endregion 
	
//region Draw	
	if (bDebug)text += "\n" + sFamily;
	if (text.length()>0)
		dp.draw(text, ptTag, pn1.vecX(), pn1.vecY(), 1, 0, _kDeviceX);	
	if (text.length()<1 || sMode==tModeHwc)
	{ 
		circle.convertToLineApprox(dEps);
		PlaneProfile pp(circle);
		pp.project(pn1, vecDir, dEps);	
		dp.draw(pp);
	}
//endregion 



















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
        <int nm="BreakPoint" vl="3066" />
        <int nm="BreakPoint" vl="3066" />
        <int nm="BreakPoint" vl="2967" />
        <int nm="BreakPoint" vl="2999" />
        <int nm="BreakPoint" vl="3208" />
        <int nm="BreakPoint" vl="1850" />
        <int nm="BreakPoint" vl="2020" />
        <int nm="BreakPoint" vl="2910" />
        <int nm="BreakPoint" vl="551" />
        <int nm="BreakPoint" vl="668" />
        <int nm="BreakPoint" vl="646" />
        <int nm="BreakPoint" vl="558" />
        <int nm="BreakPoint" vl="568" />
        <int nm="BreakPoint" vl="586" />
        <int nm="BreakPoint" vl="2930" />
        <int nm="BreakPoint" vl="2950" />
        <int nm="BreakPoint" vl="2849" />
        <int nm="BreakPoint" vl="2898" />
        <int nm="BreakPoint" vl="3055" />
        <int nm="BreakPoint" vl="3277" />
        <int nm="BreakPoint" vl="1514" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24838 sequence of fastener article data entries ordered by length" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="10/28/2025 10:23:54 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24585 automatic replacement invalid characters of style name (comma, slash, backslash)" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="10/21/2025 3:03:33 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24054 accepting filter as input when creating styles" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="5/20/2025 2:35:35 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-24055 report layout improved" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="5/19/2025 4:42:36 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22816 commas refused " />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="44" />
      <str nm="Date" vl="4/11/2025 2:30:35 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22859 copy behaviour improved" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="43" />
      <str nm="Date" vl="4/8/2025 12:14:04 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23716 supporting simple wireframe and thread display" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="42" />
      <str nm="Date" vl="3/17/2025 2:02:03 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-23512 adopted to new behaviour of controlling properties" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="41" />
      <str nm="Date" vl="2/12/2025 2:22:26 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22860 drill depth on tilted drills fixed" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="40" />
      <str nm="Date" vl="12/6/2024 2:37:03 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22866 drill added to primary beam if no secondary found" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="39" />
      <str nm="Date" vl="11/29/2024 1:29:44 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22946 Updating path to FastenerManager.dll" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="38" />
      <str nm="Date" vl="11/18/2024 8:14:40 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22935 style creation can fired without selecting an instance if executeKey is set to EditStyle" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="36" />
      <str nm="Date" vl="11/8/2024 2:55:34 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22850 sink hole fixed" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="35" />
      <str nm="Date" vl="11/8/2024 2:44:19 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22727 jig axis orientation fixed" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="34" />
      <str nm="Date" vl="9/26/2024 1:36:39 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-21509 hardware export added, additional entities on insert, HSB-22702 hardware partially translated" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="33" />
      <str nm="Date" vl="9/20/2024 4:07:16 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22689 incremental rotation fixed" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="32" />
      <str nm="Date" vl="9/17/2024 2:06:23 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22689 workaround for anchoring to tool ent" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="31" />
      <str nm="Date" vl="9/17/2024 11:30:17 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-22599 made dependent to faster assembly definition style" />
      <int nm="MajorVersion" vl="0" />
      <int nm="MinorVersion" vl="30" />
      <str nm="Date" vl="9/10/2024 3:51:14 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End