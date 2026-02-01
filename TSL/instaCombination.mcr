#Version 8
#BeginDescription
This tsl creates a combination of installation cells and it is the parent object of an installation.
Configuration can be done once inserted and rules can be stored and reused at design time.
It requires a set of tsls , which are instaCombination, instaCell and instaConduit

#Versions
Version 3.8 17.01.2024 HSB-20506 layer assignment on zone 0 = Z-Layer

Version 3.7 06.09.2022 HSB-16090 centered anchoring of combination supported, new property to toggle available anchor nodes
Version 3.6    06.09.2022   HSB-16089 new command to list full syntax of available commands in report dialog, formatting dialog added
Version 3.5    03.08.2022   HSB-16091 relevant face terminology unified
Version 3.4    01.08.2022   HSB-16090 snap profiles published
Version 3.3    26.07.2022   HSB-14204 minor changes in description and naming
Version 3.2   14.12.2021    HSB-14015 supports multi storey element insertion, bugfix planview face detection
Version 3.1   13.12.2021    HSB-14130 bugfix selection loose genbeams
Version 3.0   10.12.2021    HSB-14083 supports conduit creation to edge on insert
Version 2.9   08.12.2021    HSB-14084 conduit preview when linking combinations with conduits
Version 2.8   02.12.2021    HSB-13202 block in dwg now updated when hardware is stored
Version 2.7   01.12.2021    HSB-13729 new property to select conduit catalog on insert to auto connect to selected combinations, supports export to share and make
Version 2.6   08.10.2021    HSB-13446 bugfix duplicate on insert, planview jig enhanced, face flip does not alter node sequence
Version 2.5   29.09.2021    HSB-13203 supporting element tools if element is of type stickframe or roof element, new tooling options and new tool index property
Version 2.4   16.09.2021    HSB-13129 conduit supports rule based insertion
Version 2.3   20.07.2021    HSB-12641 height of mortise and beamcut shapes support byCombination
Version 2.2   25.06.2021    HSB-12284 supporting mortise or beamcut tools of cells
Version 2.1   18.06.2021    HSB-12298 bugfix default insert
Version 2.0   29.03.2021    HSB-11403 snapping improved
Version 1.9   26.03.2021    HSB-11234 bugfix log course index
Version 1.8   25.03.2021    HSB-11234 log course setting does not conflict with non log walls
Version 1.7   24.03.2021    HSB-11286 Block display bugfix
Version 1.6   22.03.2021    HSB-11286 Block display supported
Version 1.5   17.03.2021    HSB-11236 optional offset for vertical combinations added, HSB-11227 elevation property added
Version 1.4   15.03.2021    HSB-10793 element support added
Version 1.3    02.03.2021   HSB-11022 new property format and optional connection pocket added
Version 1.2    01.03.2021   HSB-10991 changing tool mode updates cells
Version 1.1   18.02.2021    HSB-10758 rule based creation added
Version 1.0   17.02.2021    HSB-10758 initial version
































#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 3
#MinorVersion 8
#KeyWords Electra;Sanitary;Sip;Installation;CLT;BSP
#BeginContents
//region Part #0
//region History
// #Versions
// 3.8 17.01.2024 HSB-20506 layer assignment on zone 0 = Z-Layer , Author Thorsten Huck
// 3.7 06.09.2022 HSB-16090 centered anchoring of combination supported, new property to toggle available anchor nodes , Author Thorsten Huck
// 3.6 06.09.2022 HSB-16089 new command to list full syntax of available commands in report dialog, formatting dialog added , Author Thorsten Huck
// 3.5 03.08.2022 HSB-16091 relevant face terminology unified , Author Thorsten Huck
// 3.4 01.08.2022 HSB-16090 snap profiles published , Author Thorsten Huck
// 3.3 26.07.2022 HSB-14204 minor changes in description and naming , Author Thorsten Huck
// 3.2 14.12.2021 HSB-14015 supports multi storey element insertion, bugfix planview face detection , Author Thorsten Huck
// 3.1 10.12.2021 HSB-14130 bugfix selection loose genbeams , Author Thorsten Huck
// 3.0 10.12.2021 HSB-14083 supports conduit creation to edge on insert , Author Thorsten Huck
// 2.9 08.12.2021 HSB-14084 conduit preview when linking combinations with conduits , Author Thorsten Huck
// 2.8 02.12.2021 HSB-13202 block in dwg now updated when hardware is stored , Author Thorsten Huck
// 2.7 01.12.2021 HSB-13729 new property to select conduit catalog on insert to auto connect to selected combinations, supports export to share and make , Author Thorsten Huck
// 2.6 08.10.2021 HSB-13446 bugfix duplicate on insert, planview jig enhanced, face flip does not alter node sequence , Author Thorsten Huck
// 2.5 29.09.2021 HSB-13203 supporting element tools if element is of type stickframe or roof element, new tooling options and new tool index property  , Author Thorsten Huck
// 2.4 16.09.2021 HSB-13129 conduit supports rule based insertion , Author Thorsten Huck
// 2.3 20.07.2021 HSB-12641 height of mortise and beamcut shapes support byCombination , Author Thorsten Huck
// 2.2 25.06.2021 HSB-12284 supporting mortise or beamcut tools of cells , Author Thorsten Huck
// 2.1 18.06.2021 HSB-12298 bugfix default insert , Author Thorsten Huck
// 2.0 29.03.2021 HSB-11403 snapping improved , Author Thorsten Huck
// 1.9 26.03.2021 HSB-11234 bugfix log course index , Author Thorsten Huck
// 1.8 25.03.2021 HSB-11234 log course setting does not conflict with non log walls , Author Thorsten Huck
// 1.7 24.03.2021 HSB-11286 Block display dpbugfix , Author Thorsten Huck
// 1.6 22.03.2021 HSB-11286 Block display supported , Author Thorsten Huck
// 1.5 17.03.2021 HSB-11236 optional offset for vertical combinations added, HSB-11227 elevation property added , Author Thorsten Huck
// 1.4 15.03.2021 HSB-10793 element support added , Author Thorsten Huck
// 1.3 02.03.2021 HSB-11022 new property format and optional connection pocket added , Author Thorsten Huck
// 1.2 01.03.2021 HSB-10991 changing tool mode updates cells , Author Thorsten Huck
// 1.1 18.02.2021 HSB-10758 rule based creation added , Author Thorsten Huck
// 1.0 17.02.2021 HSB-10758 initial version , Author Thorsten Huck

/// <insert Lang=en>
/// Select a panel and an insertion point, select properties or catalog entry and press OK
/// </insert>

/// <summary Lang=en>
/// This tsl creates a combination of installation cells. It requires the tsl set instaCombination, instaCell and instaConduit
/// </summary>

/// commands
// command to insert the tool
// ^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert "instaCombination")) TSLCONTENT
// optional commands of this tool
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Flip Face|") (_TM "|Select combination|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Save as rule|") (_TM "|Select combination|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Delete rule|") (_TM "|Select combination|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Hide Tools|") (_TM "|Select combination|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Show Tools|") (_TM "|Select combination|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Specify vertical cell offset|") (_TM "|Select combination|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Plan view settings|") (_TM "|Select combination|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Element view settings|") (_TM "|Select combination|"))) TSLCONTENT
// ^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM "|Log Wall Settings|") (_TM "|Select combination|"))) TSLCONTENT

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
		if(bDebug)reportMessage("\n"+ scriptName() + " starting " + _ThisInst.handle() + (_kGripPointDrag?"in drag mode":"") + " executeKey: "+_kExecuteKey);		
	}
	String sDefault =T("|_Default|");
	String sLastInserted =T("|_LastInserted|");	
	String category = T("|General|");
	String sNoYes[] = { T("|No|"), T("|Yes|")};


	String sDefaultRule = T("<|Default|>");
	String sTriggerFlipSide = T("|Flip Face|");
	String kDisabled = T("<|Disabled|>");
	String kByRule = T("<|byRule|>");
	String kBottom = T("|Bottom|"),kTop= T("|Top|"),kTopBottom = T("|Top + Bottom|");
	String kConduitMode= "ConduitMode";
	String kInstaConduit = "instaConduit", kInstaCombination = "instaCombination", tAnchorAny = T("<|Default|>"), tAnchorCell = T("|Cells|"), tAnchorCombination = T("|Combination|"),kSnaps="Snap[]",kNodes="Node[]";
	String kJigAction = "JigAction";

	String kByCombination = T("|byCombination|");
	String kReferenceSide = T("|Reference Side|");
	String kOppositeSide = T("|Opposite Side|");
	
	Vector3d vecZView = getViewDirection();
	int bIsDark;{int n = getBackgroundTrueColor();bIsDark = ((rgbR(n) + rgbB(n) + rgbG(n)) / 3 < 127);}
	int green = rgb(88,186,72);//19, 155, 72  
	int cyan = rgb(88, 186, 178);
	int red = rgb(205,32,39);
	int blue = rgb(39,118,187);
	int orange = rgb(255,63,0);//205,105,40
	int darkyellow = rgb(254, 204, 102);
	int lightblue = rgb(204,204,255);
	
	int nc = 7;
	double dTextHeight = U(60);	
	double dViewHeight = getViewHeight();	
	
//end Constants//endregion

//End Part #0//endregion 

//region Part #1
//region bOnJig
	if (_bOnJig && _kExecuteKey==kJigAction) 
	{
	    Point3d ptJig = _Map.getPoint3d("_PtJig"); // running point		
		
		Point3d ptOrg = _Map.getPoint3d("ptOrg");
		Vector3d vecX = _Map.getVector3d("vecX");
		Vector3d vecY = _Map.getVector3d("vecY");
		Vector3d vecZ = _Map.getVector3d("vecZ");
		PlaneProfile ppContour = _Map.getPlaneProfile("Contour");
		PlaneProfile ppContourPlan = _Map.getPlaneProfile("ContourPlan");
		double dElevation = _Map.getDouble("Elevation");
		int nConduitMode = _Map.getInt(kConduitMode);
		int nFace = _Map.getInt("Face");
		
		
		Line lnRef(ptOrg, vecX);
		Plane pn(ptOrg, vecZView.isPerpendicularTo(vecZ)?vecZView:vecZ);
		Line(ptJig, vecZView).hasIntersection(pn, ptJig);
		
		int bIsPlan = vecZView.isParallelTo(vecY);
		Point3d pt2 = ptJig + vecZ * vecZ.dotProduct(ptOrg - ptJig);
		Point3d pt1 = lnRef.closestPointTo(pt2);
		Point3d pt3 = pt1 + vecY * dElevation;
		Display dpElement(-1),dpPlan(-1), dpJig(-1), dpTxt(-1), dpJ(2), dpConduit(-1);
	    dpJ.textHeight(U(40));
		
		dpElement.trueColor(nFace==1?green:cyan,50);
		dpElement.addHideDirection(vecY);
		dpElement.addHideDirection(-vecY);
		dpElement.addHideDirection(vecX);
		dpElement.addHideDirection(-vecX);
		dpElement.textHeight(dViewHeight / 50);
		
		dpPlan.trueColor(darkyellow);
		dpPlan.addViewDirection(vecY);
		dpPlan.addViewDirection(-vecY);	
		dpPlan.textHeight(dViewHeight / 50);
		
		dpConduit.trueColor(green,50);
		dpJig.trueColor(rgb(151,116,2));
		//dpJig.transparency(90);
		dpJig.textHeight(dViewHeight / 50);
		
		dpTxt.trueColor(bIsDark ? rgb(255,180,0) : rgb(0,100,160));
		dpTxt.textHeight(dViewHeight / 50);


	// getlinked combination entities
		Entity links[] = _Map.getEntityArray("Combination[]", "", "Combination");
		String sConduitCatalog = _Map.getString("ConduitCatalog");
		double dWidthConduit;
		if (sConduitCatalog.length()>0)
		{ 
			 Map m=TslInst().mapWithPropValuesFromCatalog(kInstaConduit, sConduitCatalog).getMap("PropDouble[]").getMap(0); 
			 dWidthConduit = m.getDouble("dValue");
		}

		PlaneProfile ppErr;
		{
			double dD = U(70);
			Vector3d vec = vecX * dD + (bIsPlan?vecZ:vecY) * .15 * dD;
			ppErr.createRectangle(LineSeg(pt2 - vec, pt2 + vec), vecX, (bIsPlan?vecZ:vecY));
			PlaneProfile pp2 = ppErr;
			CoordSys csRot; csRot.setToRotation(45, bIsPlan?vecY:vecZ, pt2);
			ppErr.transformBy(csRot);
			csRot.setToRotation(135, bIsPlan?vecY:vecZ, pt2);
			pp2.transformBy(csRot);
			ppErr.unionWith(pp2);	
		}
					
	// element view	 
	// valid
		if (ppContour.pointInProfile(ptJig)==_kPointInProfile)
		{ 
			Point3d ptX = (dElevation <= 0 ? pt2 : pt3);
			
			Vector3d vecXDim = -vecY;
			Vector3d vecYDim = vecY.crossProduct(vecZView);
			
			DimLine dl(pt2-vecYDim*dWidthConduit, vecXDim,vecYDim);
			dl.setUseDisplayTextHeight(true);
			Point3d pts[0];
			Dim dim(dl,  pts,  "<>",  "<>", _kDimNone, _kDimPerp); 
			dim.append(pt1," ", " ");
			dim.append(ptX, "<>", T("|Elevation| ")+"<>");
			dim.setReadDirection(vecY-vecX);
			dpJig.addHideDirection(vecY);
			dpJig.draw(dim);

		// Conduit to edge
			if (dWidthConduit>0 && nConduitMode>0)
			{ 
				PlaneProfile pp;
				Point3d ptA = ptX;
				Point3d ptB = ptX - vecY * U(10e4);// bottom
				if (nConduitMode==2)
					ptB = ptX + vecY * U(10e4);// top
				if (nConduitMode==3)
					ptA = ptX + vecY * U(10e4);// top and bottom	
				pp.createRectangle(LineSeg(ptA - vecX * .5 * dWidthConduit, ptB + vecX * .5 * dWidthConduit), vecX, vecY );
				pp.intersectWith(ppContour);
				dpElement.draw(pp, _kDrawFilled);
			}




		// linked combinations
			for (int i = 0; i < links.length(); i++)
			{
				TslInst t = (TslInst)links[i];
				//dpJ.draw(t.scriptName() + "-" + scriptName() + "-" + t.bIsValid(), t.ptOrg(), _XW, _YW, 1, 0, _kDevice);
				if (t.bIsValid() && t.scriptName() == scriptName())
				{
					// build orthogonal connection vecs seen from source
					Point3d ptA = ptX, ptB = t.ptOrg();						
					ptA += vecZ * vecZ.dotProduct(ptB - ptA);
					
					Point3d ptm = (ptA + ptB) * .5;
					Vector3d vecC = ptB - ptA;
					Vector3d vecXC = vecX, vecYC = vecY;
					if (vecC.dotProduct(vecX) < 0) vecXC *= -1;
					if (vecC.dotProduct(vecY) < 0) vecYC *= -1;
					
					double dx = vecXC.dotProduct(ptB - ptA);
					double dy = vecYC.dotProduct(ptB - ptA);
					
					// collect closest node of source pointing towards target
					Vector3d vec1 = dx > dy ? vecXC : vecYC;
					Vector3d vec2 = dx > dy ? vecYC : vecXC;

					int index1 = -1, index2 = -1;
					Vector3d vecN1=vec1*(dx<0?-1:1), vecN2;

				// find cell in linked combination
					{ 
						double dMin = U(10e5);
						Map mapCombi = t.map();
						Map mapNodes = mapCombi.getMap("Node[]");				
						for (int j=0;j<mapNodes.length();j++) 
						{ 
							Map m = mapNodes.getMap(j);
							
							Point3d pt = m.getPoint3d("pt");
							Vector3d vecNormal = m.getVector3d("vecNormal");
							double d = (pt - ptA).length();
							if ((vecNormal.isCodirectionalTo(-vec2) && d<dMin) || 							// simple angled and closed to
								vecNormal.isCodirectionalTo(-vec1) && abs(vec2.dotProduct(pt-ptA))<U(50))	// straight (with tolerance of +-50mm)
							{ 
								dMin = d;
								index2 = m.getInt("nodeIndex");
								ptB = pt;
								vecN2 = vecNormal;
							}
						}//next j	
					}
	
					PLine pl(vecZ);
					pl.addVertex(ptA);
					Point3d ptC;
					if (Line(ptA, vec1).hasIntersection(Plane(ptB,vec1), ptC))
					{
						pl.addVertex(ptC);
					}
					pl.addVertex(ptB);	

					PLine pl1 = pl;
					pl1.offset(.5 * dWidthConduit);
					PLine pl2 = pl;
					pl.offset(-.5 * dWidthConduit);
					pl.reverse();
					pl.append(pl1);

					dpElement.draw(PlaneProfile(pl), _kDrawFilled);
					dpElement.draw(pl);
					
//						dpConduit.trueColor(red);
//						dpConduit.draw(PLine(_PtW,pt1));					
//						dpConduit.trueColor(green);
//						dpConduit.draw(PLine(_PtW,pt2));
//						dpConduit.trueColor(blue);
//						dpConduit.draw(PLine(_PtW,pt3));
					
				}
			}
		}
	// invalid
		else if (!vecZView.isPerpendicularTo(vecZ))
		{ 
			dpTxt.color(1);
			dpTxt.draw(ppErr, _kDrawFilled);
		}

	
	// plan view
		//else if (bIsPlan)
		{ 		
		// valid	
			LineSeg segs[] = ppContourPlan.splitSegments(LineSeg(ptJig - vecZ * U(10e4), ptJig + vecZ * U(10e4)), true);
			if (segs.length()>0)
			{ 
				pt2 = ptJig + vecY * vecY.dotProduct(ptOrg - ptJig);
				pt3 = ppContourPlan.closestPointTo(pt2);
	
				Vector3d vecPerp = pt2 - pt3;
				vecPerp.normalize();
				Vector3d vecDir = vecPerp.crossProduct(vecZView);
				double n = vecPerp.isCodirectionalTo(vecZ) ?- 1.2: 1.2;
				dpPlan.draw(PLine(pt2,pt3));
				dpPlan.draw(T("|Elevation| ")+dElevation, pt2, vecDir, vecPerp,n,n, _kDeviceX);	
				
				PLine pl;
				pl.createCircle(pt3, vecZView, dViewHeight / 150);
				pl.convertToLineApprox(dEps);
				dpPlan.draw(PlaneProfile(pl),_kDrawFilled);
				
				
			}
		// invalid	
			else
			{ 
				dpTxt.color(1);
				dpTxt.draw(ppErr, _kDrawFilled);				
			}	
		}

//
//
//	    Point3d ptBase = _Map.getPoint3d("_PtBase"); // set by second argument in PrPoint
//
//	    
//	    _ThisInst.setDebug(TRUE); // sets the debug state on the jig only, if you want to see the effect of vis methods
//	    //ptJig.vis(1);
//	    
//	    double radius = Vector3d(ptJig - ptBase).length();
//
// 		dpJ.draw(nConduitMode + "\\P"+dWidthConduit, ptJig, _XW, _YW, 1, 0, _kDevice);
//	    dpJ.draw(dElevation + "\\P"+links, ptJig, _XW, _YW, 1, 0, _kDevice);
//	    PLine plCir;//(pt1,pt2); 
//	    plCir.createCircle(ptJig, vecZ, U(100));
//	    dpJ.draw(plCir);
//	    
//	    dpJ.color(1);
//	    dpJ.draw(PLine(_PtW,ptJig, ptJig + vecX * U(400)));
//	    
//	    dpJ.color(3);
//	    dpJ.draw(PLine(_PtW,ptJig, ptJig + vecY * U(400)));
	    
    
	    return;
	}	

//End bOnJig//endregion 

//region Settings
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sPathGeneral = _kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\";	
	String sFileName ="instaCombination";
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
//End Settings//endregion	

//region Read Settings
	Map mapRules,mapRule;
	mapRules = mapSetting.getMap("Rule[]");	
	String sRules[0];
	int bIsDefaultRule;
	
	// connection mill between cells
	double dWidthConnection = U(30);
	double dDepthConnection = U(30);
	
	// vertical cell offset
	int nNumVerticalCellOffset = 0;
	int nNumRequiredCellOffset = 5;
	
	// plan view
	double dScalePlan = 1;
	double dTextHeightPlan = dTextHeight;
	String sDimStylePlan;
	int nColorPlan=nc;
	int nColorPlanSymbol = 0;// byBlock

	// element view
	double dScaleElement = 1;
	double dTextHeightElement = dTextHeight;
	String sDimStyleElement;
	int nColorElement=nc;
	int nColorElementSymbol = 0;// byBlock
	int nColorElementOpposite= 0;// byBlock
	double dSymbolOffsetElement=999; // 999 means by cell

	// Log
	int bIsCourseElevation  = true; // elevation in log walls is given from course number by default
	
{
	String k;
// Get rules of configuration
	for (int i=0;i<mapRules.length();i++) 
	{ 
		Map m = mapRules.getMap(i);
		String name = mapRules.nameAt(i);
		Map mapCells = m.getMap("Cell[]");
		if (name.length()>0 && sRules.findNoCase(name,-1)<0 && mapCells.length()>0)
			sRules.append(name);
	}//next i
	
	if (sRules.length()<1)
	{ 
		bIsDefaultRule = true;
		sRules.append(sDefaultRule);
	}
	
	Map mapCombination = mapSetting.getMap("Combination");
	{ 
		Map m = mapCombination.getMap("ConnectionPocket");
		k = "Width"; if (m.hasDouble(k)) dWidthConnection = m.getDouble(k);
		k = "Depth"; if (m.hasDouble(k)) dDepthConnection = m.getDouble(k);		
	}
	{ 
		Map m = mapCombination.getMap("Placement\\VerticalOffset");
		k = "CellOffset"; if (m.hasInt(k)) nNumVerticalCellOffset = m.getInt(k);
		k = "NumRequired"; if (m.hasInt(k)) nNumRequiredCellOffset = m.getInt(k);
	}	
	{ 
		Map m = mapCombination.getMap("Planview");
		k = "Color"; if (m.hasInt(k)) nColorPlan = m.getInt(k);
		k = "DimStyle"; if (m.hasString(k)) sDimStylePlan = m.getString(k);
		k = "TextHeight"; if (m.hasDouble(k)) dTextHeightPlan = m.getDouble(k);	
		k = "Scale"; if (m.hasDouble(k)) dScalePlan = m.getDouble(k);
		k = "ColorSymbol"; if (m.hasInt(k)) nColorPlanSymbol = m.getInt(k);
	}	
	{ 
		Map m = mapCombination.getMap("Elementview");
		k = "Color"; if (m.hasInt(k)) nColorElement = m.getInt(k);
		k = "DimStyle"; if (m.hasString(k)) sDimStyleElement = m.getString(k);
		k = "TextHeight"; if (m.hasDouble(k)) dTextHeightElement = m.getDouble(k);	
		k = "Scale"; if (m.hasDouble(k)) dScaleElement = m.getDouble(k);
		k = "ColorSymbol"; if (m.hasInt(k)) nColorElementSymbol = m.getInt(k);
		k = "ColorOpposite"; if (m.hasInt(k)) nColorElementOpposite = m.getInt(k);
		
	}	
	{ 
		Map m = mapCombination.getMap("LogWall");
		k = "IsCourseElevation"; if (m.hasInt(k)) bIsCourseElevation = m.getInt(k);
	}	
}
//End Read Settings//endregion 

//region DialogMode
	int nDialogMode = _Map.getInt("DialogMode");
	if (nDialogMode>0)
	{ 
		if (nDialogMode == 1) // specify index when triggered to get different dialogs
		{
			setOPMKey("AddRule");	

			String sNameName=T("|Name|");	
			PropString sName(nStringIndex++, T("|Name|"), sNameName);	
			sName.setDescription(T("|Defines the Name|"));
			sName.setCategory(category);	
			
//			String sIncludeConduitName=T("|Include Conduits|");	
//			PropString sIncludeConduit(nStringIndex++, sNoYes, sIncludeConduitName);	
//			sIncludeConduit.setDescription(T("|Defines the IncludeConduit|"));
//			sIncludeConduit.setCategory(category);
//			
//			if (!_Map.getInt("HasConduit"))
//			{ 
//				sIncludeConduit.set(sNoYes[0]);
//				sIncludeConduit.setReadOnly(_kHidden);
//			}	
		}	
		else if (nDialogMode == 2) // specify index when triggered to get different dialogs
		{
			setOPMKey("DeleteRule");	

			String sNameName=T("|Name|");	
			PropString sName(nStringIndex++, sRules, sNameName);	
			sName.setDescription(T("|Defines the name of the rule to be deleted|"));
			sName.setCategory(category);			
		}
		else if (nDialogMode == 3) // vertical offset
		{
			setOPMKey("VerticalOffset");	

			String sCellOffsetName=T("|Cell Offset|");	
			PropInt nCellOffset(nIntIndex++, 1, sCellOffsetName);	
			nCellOffset.setDescription(T("|Defines the quantity of cells to offset the elevation|"));
			nCellOffset.setCategory(category);
			
			String sRequiredCellName=T("|Required cells|");	
			PropInt nRequiredCell(nIntIndex++, 5, sRequiredCellName);	
			nRequiredCell.setDescription(T("|Defines how many cells must be present to offset the combination by the given cell offset|"));
			nRequiredCell.setCategory(category);			
		}	
		else if (nDialogMode == 4) // plan view setup
		{
			setOPMKey("PlanView");	

		category = T("|Text|");
			String sTextHeightName=T("|Text Height|");	
			PropDouble dTextHeight(nDoubleIndex++, U(0), sTextHeightName);	
			dTextHeight.setDescription(T("|Defines the text height|") + T(", |0 = byDimstyle|"));
			dTextHeight.setCategory(category);
			
			String sDimStyleName=T("|Dimstyle|");	
			PropString sDimStyle(nStringIndex++, _DimStyles.sorted(), sDimStyleName);	
			sDimStyle.setDescription(T("|Defines the dimstyle|"));
			sDimStyle.setCategory(category);
			
			String sColorName=T("|Color|");	
			PropInt nColor(nIntIndex++, 252, sColorName);	
			nColor.setDescription(T("|Defines the text color|"));
			nColor.setCategory(category);
		
		category = T("|Symbols|");
			String sScaleName=T("|Scalefactor|");	
			PropDouble dScale(nDoubleIndex++, U(0), sScaleName);	
			dScale.setDescription(T("|Defines the scale factor of the symbols in relation to the specified text height|"));
			dScale.setCategory(category);

			String sColorSymbolName=T("|Color| ");	
			PropInt nColorSymbol(nIntIndex++, 0, sColorSymbolName);	
			nColorSymbol.setDescription(T("|Defines the symbol color|") + T(", |0 = byBlock|"));
			nColorSymbol.setCategory(category);			
		}
		else if (nDialogMode == 5) // plan view setup
		{
			setOPMKey("ElementView");	

		category = T("|Text|");
			String sTextHeightName=T("|Text Height|");	
			PropDouble dTextHeight(nDoubleIndex++, U(0), sTextHeightName);	
			dTextHeight.setDescription(T("|Defines the text height|") + T(", |0 = byDimstyle|"));
			dTextHeight.setCategory(category);
			
			String sDimStyleName=T("|Dimstyle|");	
			PropString sDimStyle(nStringIndex++, _DimStyles.sorted(), sDimStyleName);	
			sDimStyle.setDescription(T("|Defines the dimstyle|"));
			sDimStyle.setCategory(category);
			
			String sColorName=T("|Color|");	
			PropInt nColor(nIntIndex++, 7, sColorName);	
			nColor.setDescription(T("|Defines the text color|"));
			nColor.setCategory(category);
		
		category = T("|Symbols|");
			String sScaleName=T("|Scalefactor|");	
			PropDouble dScale(nDoubleIndex++, U(0), sScaleName);	
			dScale.setDescription(T("|Defines the scale factor of the symbols in relation to the specified text height|"));
			dScale.setCategory(category);

			String sColorSymbolName=T("|Color Icon| ");	
			PropInt nColorSymbol(nIntIndex++, 0, sColorSymbolName);	
			nColorSymbol.setDescription(T("|Defines the symbol color|") + T(", |0 = byBlock|"));
			nColorSymbol.setCategory(category);	

			String sColorOppositeName=T("|Color Opposite|");	
			PropInt nColorOpposite(nIntIndex++, 0, sColorOppositeName);	
			nColorOpposite.setDescription(T("|Defines the symbol color on the opposite side|") + T(", |0 = byBlock|"));
			nColorOpposite.setCategory(category);	
			
			String sOffsetName=T("|Offset|");	
			PropDouble dOffset(nDoubleIndex++, U(0), sOffsetName);	
			dOffset.setDescription(T("|Defines the perpendicular offset of potential block symbols|"));
			dOffset.setCategory(category);
			dOffset.setReadOnly(_kHidden); // TODO not implemented yet
		}		
		else if (nDialogMode == 6) // plan view setup
		{
			setOPMKey("Log Wall");	

		category = T("|Elevation Mode|");
			String sCourseElevationName=T("|Elevation from course number|");	
			PropString sCourseElevation(nStringIndex++, sNoYes, sCourseElevationName);	
			sCourseElevation.setDescription(T("|Defines if the elevation will be specified by elevation or by course number.|"));
			sCourseElevation.setCategory(category);
		}			
		return;		
	}
//End DialogMode//endregion

//region Get parent entity
	Element el;
	if (_Element.length() > 0)el = _Element[0];
	Vector3d vecX, vecY, vecZ;
	Point3d ptOrg, ptCen;
	double dZ;
	int bHasElement = el.bIsValid(), bHasSip, bIsLogWall, bIsSipWall, bIsSFWall, bIsFloor, bAddElementTool;
	Sip sip, sips[0];
	Beam beams[0]; 
	Sheet sheets[0];
	GenBeam genbeams[0]; genbeams=_GenBeam;

// Get element if not found yet
	if(!bHasElement)
	for (int i=0;i<genbeams.length();i++) 
	{ 
		Element _el = genbeams[i].element(); 
		if (_el.bIsValid())
		{ 
			el = _el;
			_Element.append(_el);
			break;
		}
	}//next i
	
//region Identify wall type if any
	ElementLog elLog;
	if (el.bIsValid())
	{
		int bTypeCheck = true;	
		if (bTypeCheck)
		{ 
			ElementWallSF elX = (ElementWallSF)el;
			bIsSFWall= elX.bIsValid();
			bAddElementTool = bIsSFWall;
			bTypeCheck = !bIsSFWall;
		}
		if (bTypeCheck)
		{ 
			elLog = (ElementLog)el;
			bIsLogWall = elLog.bIsValid();
			bTypeCheck = !bIsLogWall;
		}
		if (bTypeCheck)
		{ 
			ElementRoof elX = (ElementRoof)el;
			bIsFloor = elX.bIsValid();
			bAddElementTool = bIsSFWall;
			bTypeCheck = !bIsFloor;
		}		
		if (!bIsSFWall)
		{ 
			ElementWall elX = (ElementWall)el;
			bIsSipWall = elX.bIsValid();
			bTypeCheck = !bIsSipWall;
		}
		bHasElement = true;
		genbeams = el.genBeam();
		
		assignToElementGroup(el, false, 0, 'E');
		vecX = el.vecX();
		vecY = el.vecY();
		vecZ = el.vecZ();
		ptOrg = el.ptOrg();
		LineSeg seg = el.segmentMinMax(); seg.vis(2);	
		ptCen = seg.ptMid();
		dZ = abs(vecZ.dotProduct(seg.ptStart()-seg.ptEnd()));	
		
		if (dZ<=dEps) // strange enough some walls don't have a valid segmentMinMax
		{ 
			seg = PlaneProfile(el.plOutlineWall()).extentInDir(vecX);
			ptCen = seg.ptMid();
			dZ = abs(vecZ.dotProduct(seg.ptStart()-seg.ptEnd()));
		}
		//seg.vis(6);
	}
	
	else if (genbeams.length()>0) // HSB-14130
	{ 
		GenBeam gb = genbeams.first();
		ptCen = gb.ptCen();
		vecX = gb.vecX();
		vecY = gb.vecY();
		vecZ = gb.vecZ();
		dZ = gb.dD(vecZ);
		
		ptOrg = ptCen+vecZ *.5*dZ;		
	}	
	
	
	
////endregion 
////endregion 

//region Properties
category = T("|Rule|");
	String sRuleName=T("|Rule|");	
	PropString sRule(0, sRules.sorted(), sRuleName);	
	sRule.setDescription(T("|Defines the rule of the combination.|") + T("|You can create additional rules based on an existing combination.|"));
	sRule.setCategory(category);

category = T("|Alignment|");
	String sElevationName=T("|Elevation|");	
	PropDouble dElevation(nDoubleIndex++, U(0), sElevationName);	
	dElevation.setDescription(T("|Defines the Elevation|"));
	dElevation.setCategory(category);

	String sDirectionName=T("|Direction|");	
	String sDirections[] = { T("|Horizontal|"), T("|Vertical|")};
	PropString sDirection(1, sDirections, sDirectionName);	
	sDirection.setDescription(T("|Defines the Direction|"));
	sDirection.setCategory(category);
	int nDirection = sDirections.find(sDirection);
	if (nDirection < 0) { sDirection.set(sDirections[0]); setExecutionLoops(2); return;}

	String sPositionName=T("|Position|");
	String sPositions[] ={T("|First Cell|"), T("|Middle Cell|"), T("|Last Cell|")};
	PropString sPosition(2, sPositions, sPositionName);	
	sPosition.setDescription(T("|Defines the Position|"));
	sPosition.setCategory(category);
	int nPosition = sPositions.find(sPosition);
	if (nPosition < 0) { sPosition.set(sPositions[0]); setExecutionLoops(2); return;}

	String sFaceName=T("|Face|");
	String sFaces[] = { kReferenceSide, kOppositeSide};
	PropString sFace(3, sFaces, sFaceName);	
	sFace.setDescription(T("|Defines the Face|"));
	sFace.setCategory(category);
	int nFace = sFaces.find(sFace)==1?1:-1;

category = T("|Tooling|");
	String sToolingName=T("|Tooling|");	
	String sToolings[] ={T("|byCell|"),T("|byCell with Mill|"), T("|byCombination|")};
	if (bAddElementTool)
	{
		sToolings.append( T("|Sawline|"));
		sToolings.append( T("|Milling|"));
	}
	PropString sTooling(4, sToolings, sToolingName);	
	sTooling.setDescription(T("|Defines the Tooling|"));
	sTooling.setCategory(category);
	int nTooling = sToolings.find(sTooling);
	if (nTooling < 0) { sTooling.set(sToolings[0]); setExecutionLoops(2); return;}	
	int bByCombination = nTooling == 2;
	int bByCell = nTooling == 0;
	int bByCellMill = nTooling == 1;
	
	String sToolIndexName=T("|Tool Index|");	
	PropInt nToolIndex(nIntIndex++, 1, sToolIndexName);	
	nToolIndex.setDescription(T("|Defines the Tool Index|"));
	nToolIndex.setCategory(category);
	if (bHasElement && (!bAddElementTool || nTooling<2))	nToolIndex.setReadOnly(_kHidden);
	
	String sRadiusName=T("|Radius|");	
	PropDouble dRadius(nDoubleIndex++, U(0), sRadiusName);	
	dRadius.setDescription(T("|Defines the Radius|"));
	dRadius.setCategory(category);

category = T("|Conduit|");
	String sConduitCatalogName=T("|Catalog|");
	String sCatalogEntries[] = TslInst().getListOfCatalogNames(kInstaConduit).sorted(); 
	sCatalogEntries.insertAt(0, kDisabled);
	PropString sConduitCatalog(6, sCatalogEntries, sConduitCatalogName);	
	sConduitCatalog.setDescription(T("|Defines the properties of the connecting conduits|"));
	sConduitCatalog.setCategory(category);
	sConduitCatalog.setReadOnly(_bOnInsert ||_bOnDebug ? false : _kHidden);

	String sConduitAlignmentName=T("|Alignment|");
	String sConduitAlignments[] = { kDisabled, kBottom , kTop,  kTopBottom};//,kByRule TODO allow multiple conduits to be created byRule definition
	PropString sConduitAlignment(7, sConduitAlignments, sConduitAlignmentName);	
	sConduitAlignment.setDescription(T("|Defines the ConduitAlignment|"));
	sConduitAlignment.setCategory(category);
	sConduitAlignment.setReadOnly(_bOnInsert ||_bOnDebug ? false : _kHidden);

category = T("|Display|");
	String sFormatName=T("|Format|");	
	PropString sFormat(5, "@(Quantity)x @(Length:RL0) x @(Width:RL0)", sFormatName);	
	sFormat.setDescription(T("|Defines the format of the description|"));
	sFormat.setCategory(category);
	


//End Properties//endregion 

//region bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
	// silent/dialog
		if (_kExecuteKey.length()>0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());	
			if (sEntries.findNoCase(_kExecuteKey,-1)>-1)
				setPropValuesFromCatalog(_kExecuteKey);
			else
				setPropValuesFromCatalog(sLastInserted);					
		}	
	// standard dialog	
		else	
			showDialog();

		int bHasConduitCatalog = sCatalogEntries.find(sConduitCatalog)>0; // if not disabled
		int nFace = sFaces.find(sFace)==1?1:-1;
		
	// prompt parent entity
		String prompt = T("|Select element|");
		if (bHasConduitCatalog)
			prompt = T("|Select element or combinations to connect|"); // allows also elements
		
		PrEntity ssE(prompt, ElementWall()); // HSB-14130 allow all classes to be selected
		ssE.addAllowedClass(ElementRoof());
		ssE.addAllowedClass(TslInst());
		ssE.addAllowedClass(GenBeam());	
			
		Element el; 
	    Vector3d vecX, vecY, vecZ;
	    Point3d ptOrg, ptCen;
		GenBeam gbs[0];
		TslInst combis[0];
		if (ssE.go())
	  		_Element = ssE.elementSet();
	  		  		
		if (_Element.length()<1)
		{ 
			double dZ;
			Entity ents[] = ssE.set();
			Point3d pts[0];
			for (int i=0;i<ents.length();i++) 
			{ 
			// try Combination TSL	
				TslInst t = (TslInst)ents[i];
				if (t.bIsValid())
				{
					if (t.scriptName()!=scriptName()){ continue;}//accept only combinations			
					Element _el = t.element();
					if (_el.bIsValid())
					{ 
						if (_Element.length()<1)
						{ 
							el = _el;
							_Element.append(el);
						}	
					}
					if (el==_el)
					{
						combis.append(t);
					}
					continue;
				}
			
			// Try genbeam
				GenBeam gb = (GenBeam)ents[i]; 
				if (gb.bIsValid())
				{
					_GenBeam.append(gb);
					gbs.append(gb);
					if (_Element.length()<1)
					{ 
						el = gb.element();
						if (el.bIsValid())
							_Element.append(el);
					}
					
					if (vecX.bIsZeroLength() && gb.bIsKindOf(Sip()))
					{ 
						Vector3d vecXS = gb.vecX();
						Vector3d vecYS = gb.vecY();
						ptCen = gb.ptCen();
						vecZ = gb.vecZ();
						// flattened to XY-World
						if (vecZ.isParallelTo(_ZW) && (vecXS.isParallelTo(_XW) || vecYS.isParallelTo(_XW))) 
							vecX = _XW;	
						// 3D-Model as wall	
						else if (vecZ.isPerpendicularTo(_ZW)) 					
							vecX = _ZW.crossProduct(vecZ);
						else	// HSB-14130
							vecX = vecXS;
						vecY = vecX.crossProduct(-vecZ);	
						dZ = gb.dD(vecZ);
					}
//					else
//					{ 
//						vecX = gb.vecX();
//						vecY = gb.vecY();
//						vecZ = gb.vecZ();
//						
//					}
					
					pts.append(gb.envelopeBody(true, true).extremeVertices(vecY));
				}
				
			}//next i
			
		// set ptOrg if genbeam selected	
			pts = Line(_Pt0, vecY).orderPoints(pts);
			if (pts.length() > 0)
			{
				ptOrg = pts.first();
				ptOrg += nFace*vecZ * (vecZ.dotProduct(ptCen - ptOrg) - .5 * dZ);
				
//				EntPLine epl;
//				epl.dbCreate(PLine(_PtW, ptOrg, ptCen));
			}
			
			
		} 


		if (_Element.length() < 1 && _GenBeam.length() < 1)
		{
			reportMessage("\n"+ scriptName() + T("|Could not find a valid reference| ")+T("|Tool will be deleted.|"));
			eraseInstance();
			return;			
		}
		else if (_Element.length()>0)
		{ 
			el = _Element[0];
			vecX = el.vecX();
			vecY = el.vecY();
			vecZ = el.vecZ();
			ptOrg = el.ptOrg();	
			gbs = el.genBeam();
		}

	// Log Wall Specials
		ElementLog elLog = (ElementLog)el;
		int bIsLogWall;
		double dThisElevation = dElevation;
		if (elLog.bIsValid())// log walls have by default a log course elevation	
		{ 
			bIsLogWall = true;
			int nCourseNr = dElevation<0?0:dElevation-1;
			if (bIsCourseElevation)
				dThisElevation = elLog.dHeightFromCourseNr(nCourseNr) + .5*(nCourseNr <= 1 ? elLog.dFirstLog() : elLog.dVisibleHeight());			
		}
		else
			 bIsCourseElevation = false;

	//region Show Jig
		int nIndexKeyWord;
		String sKeywordLists[] ={T("|[Elevation]|"), 
			T("|[Elevation/PickPoint]|"), 
			T("|[Elevation/PickPoint/LogCourse]|"), 
			T("|[Elevation/PickPoint/flipFace/conduitBottom/conduitTop/conduitBOth/conduitNone]|") };
		int nPosition = sPositions.find(sPosition);
		if (vecZView.isParallelTo(vecY))	nIndexKeyWord = 0; // plan view
		else if (elLog.bIsValid())			nIndexKeyWord = 2; // log wall
		else if (bHasConduitCatalog)		nIndexKeyWord = 3; // element view with conduit catalog selected
		else								nIndexKeyWord = 1; // element view
		PrPoint ssP(T("|Select point| ") +sKeywordLists[nIndexKeyWord]);
		
		if (combis.length()>0)
			ssP=PrPoint (T("|Select point| ") +sKeywordLists[nIndexKeyWord], combis.first().ptOrg());

	//region Get Contour
		Plane pnZ(ptOrg, vecZ);
		PlaneProfile ppContour(CoordSys(ptOrg, vecX, vecY, vecZ));
		PlaneProfile ppContourPlan(CoordSys(ptOrg, vecX, -vecZ, vecY));
		if (gbs.length()>0)// GenBeam based
		{ 
			
			Plane pnY(ptOrg, vecY);
			for (int i=0;i<gbs.length();i++) 
			{
				Body bd = gbs[i].envelopeBody(true, true);
				ppContour.unionWith(bd.shadowProfile(pnZ));
				ppContourPlan.unionWith(bd.shadowProfile(pnY));
			}
			ppContour.shrink(-dEps);	ppContour.shrink(dEps);
			ppContourPlan.shrink(-dEps);	ppContourPlan.shrink(dEps);

			
		}
		if (el.bIsValid())
		{
			ppContour.joinRing(el.plEnvelope(), _kAdd); 
			ppContourPlan.joinRing(el.plOutlineWall(), _kAdd); 
			
			Opening openings[]= el.opening();
			for (int i=0;i<openings.length();i++) 
				ppContour.joinRing(openings[i].plShape(),_kSubtract); 

		}

	//End Get Contour//endregion 	   
	   	   
	   	Map mapArgs;
		mapArgs.setInt("Face", nFace);
		mapArgs.setPoint3d("ptOrg", ptOrg);
		mapArgs.setVector3d("vecX", vecX);
		mapArgs.setVector3d("vecY", vecY);
		mapArgs.setVector3d("vecZ", vecZ);
		mapArgs.setDouble("Elevation", dThisElevation);
		mapArgs.setPlaneProfile("Contour", ppContour);
		mapArgs.setPlaneProfile("ContourPlan", ppContourPlan);

		if (sConduitAlignment == kBottom)mapArgs.setInt(kConduitMode, 1);
		else if (sConduitAlignment == kTop)mapArgs.setInt(kConduitMode, 2);
		else if (sConduitAlignment == kTopBottom)mapArgs.setInt(kConduitMode, 3);

    // Prerequisites Combination
        String sProps[]={sRule,sDirection,sPosition,sFace,sTooling,sFormat, sConduitCatalog, sConduitAlignment};

	//region Jig
	    int nGoJig = -1;
	    while (nGoJig != _kNone)//nGoJig != _kOk && 
	    {
	    // set conduit args	
	    	if(sConduitCatalog!=kDisabled)
	    	{
	    		mapArgs.setString("ConduitCatalog", sConduitCatalog);
	    		if (combis.length()>0)
	    			mapArgs.setEntityArray(combis, false, "Combination[]", "","Combination");
	    	}
		
		// Jig OK
	        nGoJig = ssP.goJig(kJigAction, mapArgs); 	        
	        if (nGoJig == _kOk)
	        {   
	        	Point3d ptPick = ssP.value();
	            if (!Line(ptPick, vecZView).hasIntersection(pnZ,_Pt0))
	            	_Pt0 = ptPick;
	        
	        // set elevation to selected point
	        	if (mapArgs.getDouble("Elevation")<=dEps)
	        	{
	        		double dNewElevation = vecY.dotProduct(_Pt0 - ptOrg);	        		
	        		if (bIsCourseElevation) // Log Wall
	        		{ 
						double a,b,d = dNewElevation;
						int n;
						if (d < elLog.dFirstLog())// snap to first
						{
							n = 1; 
							b = .5 * elLog.dFirstLog();
						}
						int num = elLog.logCourses().length(); 		
						for (int i=0;i<num;i++) 
						{ 
							int nCourseNr = i + 1;
							a = elLog.dHeightFromCourseNr(nCourseNr);
							b = a + elLog.dVisibleHeight();
							if (d>=a && d<b)
							{ 
								n = nCourseNr;
								b-=.5*elLog.dVisibleHeight();
								break;
							}
							
						}//next i
						if (n == 0)n = num; // snap to last
						dElevation.set(n);
					
					// snap to axis
						_Pt0 += vecY * vecY.dotProduct((ptOrg + vecY * b)-_Pt0);
						
	        		}	        			
	        		else
						dElevation.set(dNewElevation);
	        	}
	        // use log course index
	        	else if (bIsCourseElevation)
	        	{ 		
					int nCourseNr = dElevation<0?0:dElevation-1; // zero based
					int num = elLog.logCourses().length(); 	
					if (nCourseNr>=num)nCourseNr = num-1;
					
					dThisElevation = elLog.dHeightFromCourseNr(nCourseNr) + .5*(nCourseNr <= 1 ? elLog.dFirstLog() : elLog.dVisibleHeight());		        		
	        		_Pt0 += vecY * (vecY.dotProduct(ptOrg - _Pt0) + dThisElevation);
	        		mapArgs.setDouble("Elevation", dThisElevation);
	        	}
	        // use current elevation	
	        	else// if (bIsCourseElevation)
	        	{         		
	        		_Pt0 += vecY * (vecY.dotProduct(ptOrg - _Pt0) + dElevation);
	        	}	        	

			// toggle face by pick point in plan view
	        	if (vecZView.isParallelTo(vecY))
	        	{ 
	        		int nPickFace = 1; 
	        		if (vecZ.dotProduct(_Pt0 - ppContourPlan.closestPointTo(_Pt0))<0)
	        			nPickFace *= -1;
	        			        		
	        		sProps[3] = nPickFace == 1 ? kOppositeSide : kReferenceSide;	
//	        		; vecSide.normalize();
//	        		double d = vecSide.dotProduct(vecZ);
//	        		nFace = sFaces.find(sFace);
//	        		if ((d<0 && nFace==1) || (d>0 && nFace==0))
//	        			sFace.set(sFaces[!nFace]);
	        		
	        		if (el.bIsValid())
	        		{ 
	        			Point3d pt = el.plOutlineWall().closestPointTo(_Pt0);
	        			_Pt0 += vecZ * vecZ.dotProduct(pt - _Pt0);
	        		}		
	        	}
	        		        	
	        // Create Combination
	        	TslInst tslNew;				Vector3d vecXTsl= _XW;			Vector3d vecYTsl= _YW;
	        	GenBeam gbsTsl[] = {};		Point3d ptsTsl[] = {_Pt0};
	        	int nProps[]={nToolIndex};			
	        	double dProps[]={dElevation};					        
	        	Map mapTsl;	
	        	// append potential other ccombinations to be linked
	        	if (combis.length()>0 && sConduitCatalog!=kDisabled)
	        		mapTsl.setEntityArray(combis, false, "Combination[]", "","Combination");
       	
       	
       		// multiple wall element insertion
       			if (el.bIsValid() && el.bIsKindOf(ElementWall()) && _Element.length()>1)
       			{ 
       				for (int i=0;i<_Element.length();i++) 
       				{ 
       					Element e = _Element[i];
       					PlaneProfile ppPlan(e.plOutlineWall());
//       					ppPlan.createRectangle(e.segmentMinMax(), e.vecX(), -e.vecZ());
//       					
//       					PLine pl; pl.createRectangle(e.segmentMinMax(), e.vecX(), -e.vecZ());
//       					EntPLine epl;
//       					epl.dbCreate(pl);
//       					
//       					
       					
       					if(!e.vecX().isParallelTo(vecX))
       					{
       						reportMessage(TN("|Element| ") + e.number() + T(" |is not parallel to reference element and will be skipped.|") );     						
       						continue;
       					}
       					if(ppPlan.pointInProfile(_Pt0)==_kPointOutsideProfile)
       					{
       						reportMessage(TN("|Location is outside of element| ") + e.number() + T(" |and will be skipped.|") );     						
       						continue;
       					}       					
       					Point3d pt = _Pt0 + vecY * (vecY.dotProduct(e.ptOrg() - _Pt0) + dElevation);
						Point3d pts[] = { pt};
       					Entity ents[] = {e};	
       					tslNew.dbCreate(scriptName() , vecX ,vecY,gbsTsl, ents, pts, nProps, dProps, sProps,_kModelSpace, mapTsl);      					 
       				}//next i      				
       			}
       			else
       			{ 
       				tslNew.dbCreate(scriptName() , vecX ,vecY,_GenBeam, _Element, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);
       				
		        // connect to previously created combi
		        	if (tslNew.bIsValid() && combis.length()>0)
		        	{ 
		        		combis.setLength(0);
		        		combis.append(tslNew);
		        		nIndexKeyWord = 3;
						ssP=PrPoint (T("|Select point| ") +sKeywordLists[nIndexKeyWord], tslNew.ptOrg());
		        	}       				
       				
       			}

	        }
	    // Keywords    
	        else if (nGoJig == _kKeyWord)
	        { 	        	
	        	int keywordIndex = ssP.keywordIndex();
	            if (keywordIndex == 0) // Elevation
	            { 
	            	double dNewElevation = getDouble(T("|Enter new elevation|"));
	            	if (dNewElevation>0)
	            	{ 
	            		dElevation.set(dNewElevation);
	            		mapArgs.setDouble("Elevation", dElevation);
	            	}	            	
	            }
	            else if (keywordIndex== 1) // elevation by pick point
	            { 
	            	mapArgs.setDouble("Elevation", 0);
	            }
	            else if (keywordIndex == 2 && nIndexKeyWord==2) // elevation by pick point for log walls
	            { 
	            	int nCourseNr = getInt(T("|Enter log course|"));
	            	if (nCourseNr>0 && nCourseNr <=elLog.logCourses().length())
	            	{ 
	            		dThisElevation = nCourseNr>1?elLog.dHeightFromCourseNr(nCourseNr-1) + .5*elLog.dVisibleHeight() :.5*elLog.dFirstLog();		     
	            		dElevation.set(nCourseNr);
	            		mapArgs.setDouble("Elevation", dThisElevation);
	            	}
	            }
	            else if (keywordIndex==2) // flip face
	            { 
	            	nFace *= -1;
	            	mapArgs.setInt("Face", nFace);
	            	sProps[3] = nFace==-1?kReferenceSide:kOppositeSide;
	            }	            
	            else if (keywordIndex==3) // conduit bottom
	            { 
	            	mapArgs.setInt(kConduitMode, 1);
	            	sProps[7] = kBottom;
	            }
	            else if (keywordIndex==4) // conduit top
	            { 
	            	mapArgs.setInt(kConduitMode, 2);
	            	sProps[7] = kTop;
	            }
	            else if (keywordIndex==5) // conduit top and bottom
	            { 
	            	mapArgs.setInt(kConduitMode, 3);
	            	sProps[7] = kTopBottom;
	            }
	            else if (keywordIndex==6) // conduit none
	            { 
	            	mapArgs.setInt(kConduitMode, 0);
	            	sProps[7] = kDisabled;
	            }	            
	        }
	    // Cancel    
	        else if (nGoJig == _kCancel)
	        { 
	            eraseInstance(); // do not insert this instance
	            return; 
	        }
	    }		
	//endregion  
	
	//End Show Jig//endregion 
		
		eraseInstance();
		return;
	}	
// end on insert	__________________//endregion


//End Part #1//endregion 

//region Part #2

//region Verify dependencies
	sRule.setReadOnly(_kHidden);
	addRecalcTrigger(_kGripPointDrag, "_Pt0");
	if (_PtG.length()>0)addRecalcTrigger(_kGripPointDrag, "_PtG0");
	int bDrag = _bOnGripPointDrag && (_kExecuteKey == "_Pt0" || _kExecuteKey == "_PtG0");
	if (!bHasElement && _GenBeam.length()<1)
	{
		reportMessage("\n" + scriptName() + ": " +T("|Invalid reference.|") + " " + T("|Tool will be deleted|"));
		eraseInstance();
		return;
	}
	
	if (nTooling == 3 && abs(dRadius)>0)
	{ 
		nTooling = 2;
		sTooling.set(sToolings[nTooling]);
		reportMessage(TN("|Sawline mode is not applicable if radius is not 0 and has been reset to| ") + sTooling);	
	}
	
	
//endregion 

//region Collect genbeam subtypes
	Point3d ptVerticalExtremes[0];
	Body bodies[0]; // cache the bodies
	int nGenBeamZones[0]; // a collection of zone indices which contain genbeams
	for (int i=0;i<genbeams.length();i++) 
	{ 
		GenBeam gb = genbeams[i];
		bodies.append(gb.envelopeBody(true, true));
		
		int n = gb.myZoneIndex();
		if (nGenBeamZones.find(n) < 0)nGenBeamZones.append(n);
		//bodies[bodies.length() - 1].vis(i);
		Sip sip = (Sip)gb;
		Beam beam= (Beam)gb;
		Sheet sheet= (Sheet)gb;
		if (sip.bIsValid())sips.append(sip);
		else if (beam.bIsValid())beams.append(beam);
		else if (sheet.bIsValid())sheets.append(sheet);
		
		ptVerticalExtremes.append(bodies.last().extremeVertices(vecY));
	}//next i
	ptVerticalExtremes = Line(_Pt0, vecY).orderPoints(ptVerticalExtremes, dEps);
	
	
// GenBeam based, get coordSys and main ref if loose
	if (!bHasElement)
	{ 
		if (ptVerticalExtremes.length() > 0)ptOrg = ptVerticalExtremes.first();
		ptOrg += nFace*vecZ * (vecZ.dotProduct(ptCen - ptOrg) - .5 * dZ);
		ptOrg.vis(2);
		
		if (sips.length()>0)
		{ 
			sip = sips.first();
			dZ = sip.dH();
			ptCen = sip.ptCen();
			Vector3d vecXS = sip.vecX();
			Vector3d vecYS = sip.vecY();
			vecZ = sip.vecZ();
			// flattened to XY-World
			if (vecZ.isParallelTo(_ZW) && (vecXS.isParallelTo(_XW) || vecYS.isParallelTo(_XW))) 
				vecX = _XW;	
			// 3D-Model as wall	
			else if (vecZ.isPerpendicularTo(_ZW)) 					
				vecX = _ZW.crossProduct(vecZ);
			else
				vecX = vecXS;
			vecY = vecX.crossProduct(-vecZ);			
		}
		
		assignToGroups(genbeams.first(), 'T');
		if (genbeams.length()==1)setEraseAndCopyWithBeams(_kBeam0);
	}
	vecX.vis(ptCen,1);vecY.vis(ptCen,3);vecZ.vis(ptCen,150);	
//End Collect genbeam subtypes//endregion 


//End  Part #2//endregion 

//region Elevation
	double dThisElevation = dElevation;
	if (bIsLogWall && bIsCourseElevation)
	{ 
	// log walls have by default a log course elevation			
		int nCourseNr = dElevation<0?0:dElevation-1; // zero based
		int num = elLog.logCourses().length(); 
		if (nCourseNr>=num)nCourseNr = num-1;
		if (bIsCourseElevation)
			dThisElevation = elLog.dHeightFromCourseNr(nCourseNr) + .5*(nCourseNr==0?elLog.dFirstLog():elLog.dVisibleHeight());
		PLine (ptOrg + vecY * dThisElevation, ptOrg + vecX * U(4000) + vecY * dThisElevation).vis(2);	
		
	}
	// make sure a course elevation setting does not conflict with non log walls
	else if (!bIsLogWall && bIsCourseElevation)
	{
		bIsCourseElevation = false;
	}
	if (_kNameLastChangedProp == "_Pt0")
	{ 
		if (bIsCourseElevation)
		{ 
			double a,b,d = vecY.dotProduct(_Pt0 - ptOrg);
			int n=-1;
			if (d < elLog.dFirstLog())// snap to first
			{
				n = 0; 
				b = .5 * elLog.dFirstLog();
			}
			int num = elLog.logCourses().length(); 		
			for (int i=1;i<num;i++) 
			{ 
				int nCourseNr = i;
				a = elLog.dHeightFromCourseNr(nCourseNr);
				b = a + elLog.dVisibleHeight();
				if (d>=a && d<b)
				{ 
					n = nCourseNr;
					b-=.5*elLog.dVisibleHeight();
					break;
				}
				
			}//next i
			if (n == -1)n = num; // snap to last
			dElevation.set(n+1);

		// snap to axis
			_Pt0 += vecY * vecY.dotProduct((ptOrg + vecY * b)-_Pt0);

		}
		else
			dElevation.set(vecY.dotProduct(_Pt0 - ptOrg));	
			
	// keep grip positions independent from Z-dragging of _Pt0 // HSB-14130
		for (int i=0;i<_PtG.length();i++) 
		{ 
			if (!_Map.hasVector3d("grip" + i))continue;
			_PtG[i] = _PtW + _Map.getVector3d("grip" + i);
			_PtG[i] += vecX * vecX.dotProduct(_Pt0 - _PtG[i]);
			 
		}//next i			
			
	}
	else if (_kNameLastChangedProp == sElevationName)
	{ 
		_Pt0 += vecY * (vecY.dotProduct(ptOrg-_Pt0) + dThisElevation);
	}
//End Elevation//endregion 

//region Get Contour
	PlaneProfile ppContour(CoordSys(ptOrg, vecX, vecY, vecZ));
	if (bDrag) // calculating the contour during jig has too much flickering
	{
		ppContour = _Map.getPlaneProfile("Contour");
		ppContour.transformBy((_PtW + _Map.getVector3d("vecOrg")) - ppContour.coordSys().ptOrg());
	}
	else
	{ 
	// Sip based
		if (sips.length()>0)
		{ 
			for (int i=0;i<sips.length();i++) 
				ppContour.joinRing(sips[i].plEnvelope(), _kAdd); 
			ppContour.shrink(-dEps);
			ppContour.shrink(dEps);
			for (int i=0;i<sips.length();i++) 
			{
				PLine plOpenings[] = sips[i].plOpenings();
				for (int j=0;j<plOpenings.length();j++) 
					ppContour.joinRing(plOpenings[j], _kSubtract); 
			}		
		}
	// Log Wall	
		else if (bIsLogWall)
		{ 
			Plane pnZ(ptOrg, vecZ);
			for (int i=0;i<genbeams.length();i++) 
				ppContour.unionWith(genbeams[i].envelopeBody(true, true).shadowProfile(pnZ));	
			ppContour.shrink(-dEps);
			ppContour.shrink(dEps);			
		}
		else if (bHasElement)
		{ 
			ppContour.joinRing(el.plEnvelope(), _kAdd); 
		}
		ppContour.vis(2);		
	}

//End Get Contour//endregion 

//region Jig
	if (bDrag)
	{ 
		Display dpJig(-1);
		dpJig.trueColor(lightblue,80);//bIsDark ? rgb(189,253,139) : rgb(51,116,2));
		dpJig.textHeight(dViewHeight / 50);
		PlaneProfile pp;	
		Point3d ptJig = _Pt0;
		
	//region _Pt0
		if (_kExecuteKey == "_Pt0")
		{ 
		// element view	
			if (!vecZView.isParallelTo(vecY))
			{ 
				DimLine dl(ptJig, vecY,-vecX);
				dl.setUseDisplayTextHeight(true);
				Dim dim(dl, "<>",  "<>", _kDimDelta);  
				dim.append(ptJig);
				
				Point3d pts[] = ppContour.intersectPoints(Plane(_Pt0, vecX), true, false);
				if (pts.length()>0)
				{ 
					dim.append(pts.first());
					dim.append(pts.last());			
				}
		
				dpJig.addHideDirection(vecY);
				dpJig.draw(dim);
				
				pp = _Map.getPlaneProfile("Shape");		
			}
		
		// plan view
			else
			{ 
				dpJig.addViewDirection(vecY);
				pp = _Map.getPlaneProfile("ShapePlan");
			}
			pp.transformBy(ptJig - pp.coordSys().ptOrg());
		}	
	//End _Pt0//endregion 	
		
	//region _PtG0
		if (_kExecuteKey == "_PtG0")
		{
			ptJig = _PtG[0];
		
		// plan view
			int bPlanView = vecZView.isParallelTo(vecY);
			if(bPlanView)
			{ 
				dpJig.addViewDirection(vecY);
				pp = _Map.getPlaneProfile("SymbolPlan");
			}
			
			Point3d pt = pp.coordSys().ptOrg();
			pp.transformBy(ptJig - pt);
			
			if(bPlanView)
			{ 
				Vector3d vecZBadge = vecZ;
				if (vecZBadge.dotProduct(ptJig - ptCen) < 0)vecZBadge *= -1;
				Point3d pts[] = Line(_Pt0,vecZBadge).orderPoints(pp.intersectPoints(Plane(ptJig, vecX), true, false));
				if (pts.length() > 0)
					pt=(pts.first()+pts.last())*.5;
				pp.transformBy(ptJig - pt);				
			}

		}

		//TODO add plan view text
		dpJig.draw(pp, _kDrawFilled);
		dpJig.draw(pp);
		return;
	}
//End Jig//endregion 

//region Tool CoordSys	
	Vector3d vecFace = nFace * vecZ;	//vecFace.vis(ptCen,2);	
	Point3d ptFace = ptCen + vecFace * .5 * dZ;vecFace.vis(ptFace,2);
	Vector3d vecDir = vecX;
	if (vecZ.isParallelTo(_ZW))// flattened XY World
	{ 
		if (vecX.isParallelTo(_XW) ||vecX.isParallelTo(_YW))
			vecDir = _XW;
		else if (sip.solidWidth()>sip.solidLength())
			vecDir = vecY;
	}
	else if (vecZ.isPerpendicularTo(_ZW)) // 3D wall
	{ 
		vecDir = _ZW.crossProduct(vecZ);
	}
	
	if (nDirection==1)
	{ 
		vecDir = vecDir.crossProduct(vecZ);
	}
	Vector3d vecPerp = vecDir.crossProduct(-vecFace);
	vecDir.vis(_Pt0, 1);
	vecPerp.vis(_Pt0, 3);
	_Pt0 += vecFace * vecFace.dotProduct(ptFace - _Pt0);
	CoordSys cs(_Pt0, vecDir, vecPerp, vecFace);	

//End Tool CoordSys//endregion 


//region Create cells by rule
	if (_bOnDbCreated)
	{ 
		Map mapRule;
		String _sRule = sRule;
		_sRule.makeUpper();
		for (int i=0;i<mapRules.length();i++) 
		{ 
			Map m = mapRules.getMap(i);
			String name = mapRules.nameAt(i).makeUpper();
			Map mapCells = m.getMap("Cell[]");
			if (name ==_sRule && mapCells.length()>0)
				mapRule = m;
		}//next i


		TslInst cells[0];

	// create default	
		if (mapRule.length()<1)
		{ 
		// create TSL
			TslInst tslNew;				Map mapTsl;
			int bForceModelSpace = true;	
			String sExecuteKey,sCatalogName = sDefault;
			String sEvent="OnDbCreated"; // "OnElementConstructed", "OnRecalc", "OnMapIO"...
			GenBeam gbsTsl[0];		Entity entsTsl[] = {_ThisInst};			Point3d ptsTsl[] = {_Pt0};
			gbsTsl = genbeams;
			mapTsl.setVector3d("vecFace", vecFace);
			if (bHasElement)entsTsl.append(el);

//EntPLine epl;
//epl.dbCreate(PLine(_PtW, _Pt0, _Pt0+vecFace*U(500)));


			tslNew.dbCreate("instaCell" , vecDir ,vecPerp,gbsTsl, entsTsl, ptsTsl, sCatalogName, bForceModelSpace, mapTsl, sExecuteKey, sEvent); 	
			
			if (tslNew.bIsValid())
			{
				tslNew.transformBy(Vector3d(0, 0, 0));
	 			cells.append(tslNew);
	 			_Entity.append(tslNew);
	 		}
	 		_Map.setEntityArray(cells, false, "Cell[]","", "Cell"); 	
		}
		else
		{ 
		// create TSL
			TslInst tslNew;
			GenBeam gbsTsl[0];		Entity entsTsl[] = {_ThisInst};			Point3d ptsTsl[] = {_Pt0};
			gbsTsl = genbeams;
			if (bHasElement)entsTsl.append(el);
			int nProps[]={};			double dProps[]={};				String sProps[]={};
			Map mapTsl;	

		// cell creation
			Map mapCells= mapRule.getMap("Cell[]"), mapBuffers;
			for (int i=0;i<mapCells.length();i++) 
			{ 
				Map m= mapCells.getMap(i);
				
				String scriptName = m.getString("scriptName");
				if (scriptName.length() < 1)continue;
				
				Map mapProperties = m.getMap("Properties");
				int nProps[]={};
				Map mapInts = mapProperties.getMap("PropInt[]");
				for (int ii=0;ii<mapInts.length();ii++) 
					nProps.append(mapInts.getMap(ii).getInt("lValue")); 

				double dProps[]={};
				Map mapDoubles = mapProperties.getMap("PropDouble[]");
				for (int ii=0;ii<mapDoubles.length();ii++) 
					dProps.append(mapDoubles.getMap(ii).getDouble("dValue")); 
				
				String sProps[]={};
				Map mapStrings = mapProperties.getMap("PropString[]");
				for (int ii=0;ii<mapStrings.length();ii++) 
					sProps.append(mapStrings.getMap(ii).getString("strValue")); 
				
				ptsTsl[0] += vecDir * i * U(1); // offset in direction to maintain sequence
				tslNew.dbCreate(scriptName ,vecX ,vecY,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);						
	 		 
	 		 	if (tslNew.bIsValid())
	 		 	{ 
	 		 		tslNew.transformBy(Vector3d(0, 0, 0));
	 		 		cells.append(tslNew);
	 		 		_Entity.append(tslNew);
	 		 		
	 		 		//if (m.hasMap("Conduit[]"))
	 		 		mapBuffers.appendMap("Cell", m); // to make sure cells and maps are in sync
	 		 	}
			}//next i
			_Map.setEntityArray(cells, false, "Cell[]","", "Cell");
			
			
		// conduit creation
			mapCells = mapBuffers;// to make sure cells and maps are in sync
			
			if(0)
			for (int i = 0; i < cells.length(); i++)
			{
				Map m = mapCells.getMap(i);			
				Map mapConduits = m.getMap("Conduit[]");
//reportMessage("\nCell " + i + " has conduits " + mapConduits.length() );
				
				for (int j=0;j<mapConduits.length();j++) 
				{ 
					Map mapConduit= mapConduits.getMap(j);
					Vector3d vecN1 = mapConduit.getVector3d("vecN1");
					int nNodeIndexA= mapConduit.getInt("nodeIndexA");		
					double dN1 = mapConduit.getDouble("Width")*.5;
					
					entsTsl.setLength(0);
					entsTsl.append(cells[i]);
					if (bHasElement)entsTsl.append(el);
					
					ptsTsl.setLength(0);
					ptsTsl.append(cells[i].ptOrg());
					ptsTsl.append(cells[i].ptOrg()+vecN1* dN1);
					
					mapTsl = Map();
					mapTsl.setInt("nodeIndexA", nNodeIndexA );
					mapTsl.setEntity("cell", cells[i] );
					mapTsl.setVector3d("vecN1", vecN1);
					mapTsl.setPoint3d("pt", cells[i].ptOrg()+vecN1*dN1);
					mapTsl.setInt("ConnectionType", mapConduit.getInt("ConnectionType"));
					//mapTsl.setPLine("plRoute", mapConduit.getPLine("plRoute"));
					
					String scriptName = mapConduit.getString("scriptName");
					if (scriptName.length() < 1)continue;
					
					Map mapProperties = mapConduit.getMap("Properties");
					int nProps[]={};
					Map mapInts = mapProperties.getMap("PropInt[]");
					for (int ii=0;ii<mapInts.length();ii++) 
						nProps.append(mapInts.getMap(ii).getInt("lValue")); 
	
					double dProps[]={};
					Map mapDoubles = mapProperties.getMap("PropDouble[]");
					for (int ii=0;ii<mapDoubles.length();ii++) 
						dProps.append(mapDoubles.getMap(ii).getDouble("dValue")); 
					
					String sProps[]={};
					Map mapStrings = mapProperties.getMap("PropString[]");
					for (int ii=0;ii<mapStrings.length();ii++) 
						sProps.append(mapStrings.getMap(ii).getString("strValue")); 
					
					 
					tslNew.dbCreate(scriptName ,vecX ,vecY,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);					

					 
				}//next j
				
				
			}

			
		}
		
		//setExecutionLoops(2);
	}
//End Create cells by rule//endregion 




//End Part #2//endregion 

//region Get Cells
	TslInst tslCells[0];
	{ 
		Entity cells[] = _Map.getEntityArray("Cell[]","", "Cell");	
		for (int i=0;i<cells.length();i++) 
		{ 
			TslInst t = (TslInst)cells[i]; 
			if (t.bIsValid())
			{
				
				tslCells.append(t);
				_Entity.append(t);
			}
		}//next i		
	}
	
	if (!bDrag)
	for (int i=0;i<_Entity.length();i++) 
	{ 
		//_Entity[i].transformBy(Vector3d(0, 0, 0));
		setDependencyOnEntity(_Entity[i]); 
		//if (bDebug)reportMessage("\n" + scriptName() + " " + _ThisInst.handle() + " depends on " + _Entity[i].typeDxfName() + " " + _Entity[i].handle());
		 
	}//next i
	if (tslCells.length()<1)
	{ 
		reportMessage("\n" + scriptName() + ": " +T("|no cells found|"));
		eraseInstance();
		return;
	}
	
// update cells // || _kNameLastChangedProp=="_Pt0"
	if (_kNameLastChangedProp == sToolingName || _kNameLastChangedProp==sFaceName  || 
		(_bOnRecalc && (_kExecuteKey==sTriggerFlipSide || _kExecuteKey==sDoubleClick)))
	{ 
		for (int i=0;i<tslCells.length();i++) 
			tslCells[i].transformBy(Vector3d(0,0,0));//recalc();
	}
	
	
// order by direction
	if (_kNameLastChangedProp!=sDirectionName)
	{
		for (int i=0;i<tslCells.length();i++) 
			for (int j=0;j<tslCells.length()-1;j++) 
			{
				double d1 = vecDir.dotProduct(_Pt0 - tslCells[j].ptOrg());
				double d2 = vecDir.dotProduct(_Pt0 - tslCells[j+1].ptOrg());
				if (d1<d2)
					tslCells.swap(j, j + 1);
			}	
			
	}

		
// loop cells and collect total dims	
	double dLength, dDirCells[0], dWidth, dDepth;
	for (int i = 0; i < tslCells.length(); i++)
	{
		TslInst& t = tslCells[i];
		String tool = t.propString(1);
		double dDiamWidth = t.propDouble(0); // diameter/width
		double dHeight = t.propDouble(4); // diameter/width
		
		double dX = dDiamWidth;
		
		dX +=2*t.propDouble(3);
		dLength += dX;
		dDirCells.append(dX);
		

		dWidth =(tool!=T("|Drill|"))?dHeight: dDiamWidth;
		
		double _dDepth = t.propDouble(1);
		if (_dDepth>0 && dDepth<_dDepth)
			dDepth = _dDepth;
		
	}
	double dLengthFirst, dLengthLast;
	if (dDirCells.length()>0)
	{ 
		dLengthFirst = dDirCells.first();
		dLengthLast = dDirCells.last();		
	}

// set additional variables
	Entity entFormat = _ThisInst;
	Map mapAdditional;
	String sVariables[0];
	sVariables = entFormat.formatObjectVariables();	
	{ 
		String k;
		k = "Quantity"; if (sVariables.findNoCase(k,-1)<0) {sVariables.append(k);	mapAdditional.setInt(k, tslCells.length());}
		k = "Length"; 	if (sVariables.findNoCase(k,-1)<0) {sVariables.append(k);	mapAdditional.setDouble(k, dLength);}
		k = "Width"; 	if (sVariables.findNoCase(k,-1)<0) {sVariables.append(k);	mapAdditional.setDouble(k, dWidth);}
		k = "Depth"; 	if (sVariables.findNoCase(k,-1)<0) {sVariables.append(k);	mapAdditional.setDouble(k, dDepth);}
		
		if (bIsLogWall && !bIsCourseElevation)
			dThisElevation = vecY.dotProduct(_Pt0 - ptOrg);
		mapAdditional.setDouble("Elevation", dThisElevation); // overwrite elevation property
		mapAdditional.setDouble(T("|Elevation|"), dThisElevation); // overwrite elevation property
	}

	Point3d ptRef = _Pt0; 	// first position
	if (nDirection == 1 && nPosition==0 && nNumVerticalCellOffset>0 && tslCells.length()>=nNumRequiredCellOffset)
	{ 
	// vertical offset if specified	
		for (int i=0;i<nNumVerticalCellOffset;i++) 
		{ 
			if (i == tslCells.length() - 1) { break; } //limit to n - 1
			ptRef -= vecDir * .5*(dDirCells[i]+dDirCells[i+1]);
		}//next i	
	}
	else if (nPosition==1)		// middle position
		ptRef -= vecDir * .5*(dLength -(dLengthFirst));
	else if (nPosition==2)	// last position
		ptRef -= vecDir * (dLength -.5*(dLengthFirst+dLengthLast));
	
	Point3d ptLoc = ptRef;
	Point3d ptLocs[0];
	for (int i=0;i<tslCells.length();i++) 
	{ 
		TslInst& t = tslCells[i];
		double dXY = dDirCells[i];
		Point3d pt = t.ptOrg();

		if (i>0)ptLoc += vecDir * .5 * dXY;
		
		Vector3d vecMove = vecDir * vecDir.dotProduct(ptLoc - t.ptOrg()) + vecPerp * vecPerp.dotProduct(ptLoc - t.ptOrg());
 		if (!vecMove.bIsZeroLength())
 		{
 			//reportMessage(TN("|transforming| ") + t.handle());		
 			t.transformBy(vecMove);
 		}
 		else if (_kNameLastChangedProp==sDirectionName) // force update if direction has been changed
 			t.transformBy(Vector3d(0,0,0));
 		ptLocs.append(ptLoc);
 		ptLoc += vecDir * .5 * dXY;
 		
	}//next i
	ptRef.vis(2);
	
	if (_PtG.length() > 0)_PtG[0] += vecY * (vecY.dotProduct(ptRef - _PtG[0]) + dWidth); // grip always offsted in element view to distinguish between _Pt0 and grip
	
	Point3d ptMid = ptRef + vecDir * .5 * (dLength - dLengthFirst);
//End Get Cells//endregion 

//region Get conduits attached to single cells
	TslInst tslConduits[0];
	{ 
		TslInst tsls[0];
		if (bHasElement)
			tsls.append(el.tslInstAttached());
		// TODO find cells of loose genbeams
		
		for (int i=0;i<tsls.length();i++) 
		{ 
			TslInst t = tsls[i]; 
			if (t.scriptName().makeLower() != kInstaConduit.makeLower()) {continue;}

			Map m = t.map();
			Entity cell1=m.getEntity("cell1"), cell2=m.getEntity("cell2");
			if (!(cell1.bIsValid() && !cell2.bIsValid())){continue;}
			
			if (tslCells.find(cell1)<0){ continue;}
			
			tslConduits.append(t);
			//m.getVector3d("vecN1").vis(t.ptOrg(), i);
			if (bDebug)m.getPLine("plRoute").vis(i);
			 
		}//next i	
	}

		
//endregion 

//region Display
	Display dp(nc),dpModel(nc), dpElement(nColorElement), dpPlan(nColorPlan);
	if (_DimStyles.findNoCase(sDimStyleElement ,- 1) >- 1)dpElement.dimStyle(sDimStyleElement);
	if (dTextHeightElement>0)dpElement.textHeight(dTextHeightElement);
	dpElement.addViewDirection(vecZ);
	dpElement.addViewDirection(-vecZ);
	dpElement.showInDxa(true);

	dpModel.addHideDirection(vecZ);
	dpModel.addHideDirection(-vecZ);
	dpModel.addHideDirection(vecY);
	
	if (_DimStyles.findNoCase(sDimStylePlan ,- 1) >- 1)dpPlan.dimStyle(sDimStylePlan);
	if (dTextHeightPlan>0)dpPlan.textHeight(dTextHeightPlan);
	dpPlan.addViewDirection(_ZW);
	dpPlan.showInDxa(true);
	
	PlaneProfile ppTool(cs), ppPlanTool(CoordSys(_Pt0, vecX, -vecZ, vecY));
	PLine plTool(vecZ);
	
// byCombination, Sawline or Milling line	
	if (nTooling>=2 && dLength>dEps && dWidth>dEps && dDepth>dEps)// byCombination
	{
		dpModel.showInDxa(true);
		double radius = dRadius > 0 ? dRadius : 0;

		Mortise ms(ptMid, vecDir, vecPerp, -vecFace, dLength, dWidth, dDepth, 0, 0,1);	
		ms.setRoundType(_kExplicitRadius);
		ms.setExplicitRadius (radius);
		ms.addMeToGenBeamsIntersect(genbeams);
		
		Body bd = ms.cuttingBody();	//bd.vis(2);
		ppTool.unionWith(bd.shadowProfile(Plane(ptFace, vecZ)));
		ppPlanTool = bd.shadowProfile(Plane(_Pt0, vecY));
		
		PLine rings[] = ppTool.allRings(true, false);
		if (rings.length()>0)
		{
			dpModel.draw(Body(rings.first(), vecFace*dDepth,-1));
		}
	}	
	
	else// byCell
	{ 
		
		
		for (int i=0;i<tslCells.length();i++) 
		{ 
			TslInst& t = tslCells[i];
			Map m = t.map();
			ppTool.unionWith(m.getPlaneProfile("ShapeBox"));
		
			// TODO add plan view
		}//next i
		
	// add connection pocket
		if (nTooling == 1 && dWidthConnection>dEps && dDepthConnection>dEps && tslCells.length()>1)
		{ 
			Point3d pt1 = tslCells.first().ptOrg();
			pt1 += vecFace * vecFace.dotProduct(ptFace - pt1);
			Point3d pt2 = tslCells.last().ptOrg();
			pt2 += vecFace * vecFace.dotProduct(ptFace - pt2);
			Point3d pt = (pt1 + pt2) * .5;
			double dL = abs(vecDir.dotProduct(pt2 - pt1));
			Mortise ms(pt, vecDir, vecPerp, -vecFace, dL, dWidthConnection, dDepthConnection, 0, 0,1);	
//			ms.setRoundType(_kExplicitRadius);
//			ms.setExplicitRadius (radius);
			
			ms.addMeToGenBeamsIntersect(genbeams);	
			Body bd = ms.cuttingBody();bd.vis(2);
			
			ppPlanTool.unionWith(bd.shadowProfile(Plane(_Pt0, vecY)));		// TODO make intersection with plan veiw of affected solids	
		}
		
		
	}

	if (nTooling>=2)
		dp.draw(ppTool, _kDrawFilled, 80);
	dp.draw(ppTool);

//region Custom Dimrequest
	Map mapRequests;
	if (nTooling>=2) //bByCombination
	{ 	
		LineSeg seg = ppTool.extentInDir(vecDir);
		Point3d pts[] = { seg.ptStart(),seg.ptEnd()};
		
		Map m;
		m.setVector3d("vecDimLineDir", vecDir);
		m.setVector3d("vecPerpDimLineDir", vecPerp);
		m.setVector3d("AllowedView", vecFace);
		m.setPoint3dArray("Node[]",pts);
		m.setString("Stereotype", _ThisInst.scriptName());
		m.setEntity("ParentEnt", _ThisInst);
		m.setInt("AlsoReverseDirection", true);
		mapRequests.appendMap("DimRequest", m);			
		m.setVector3d("vecDimLineDir", vecPerp);
		m.setVector3d("vecPerpDimLineDir", - vecDir);
		mapRequests.appendMap("DimRequest", m);	
	}
	{ 
		Map mapX; 
		mapX.setMap("DimRequest[]", mapRequests);
		_ThisInst.setSubMapX("Hsb_DimensionInfo", mapX);		
	}
//End Custom Dimrequest//endregion




// tagging
	sFormat.setDefinesFormatting(_ThisInst, mapAdditional);
	String text = _ThisInst.formatObject(sFormat, mapAdditional);
	
// XY / Element-View Text
	PlaneProfile ppPlanSym;//(CoordSys(ptOrg, vecX, -vecZ, vecY));
	Point3d ptXY = _Pt0;
	if (text.length()>0)
	{ 
		Point3d pts[] = Line(ptXY, -vecX).orderPoints(ppTool.intersectPoints(Plane(ptXY, vecY), true, false));
		Point3d ptTxt = (pts.length() > 0 ? pts.first() : ptXY) + vecX*.5*dTextHeight;
		dpElement.draw(PLine(ptTxt, ppTool.closestPointTo(ptTxt)));
		dpElement.draw(text, ptTxt, vecX, vecY, 1, 0, _kDeviceX);
	}

// XZ / Plan-View Text
	Point3d ptXZ = _Pt0;
	if (vecZ.isPerpendicularTo(_ZW))
	{ 
		if (_PtG.length() < 1)	_PtG.append(_Pt0 + vecFace * dTextHeight);
		ptXZ= _PtG[0];

	// Plan badge 
		Vector3d vecZBadge = vecFace;			// vector pointing on the side of the badge
		if (vecFace.dotProduct(_PtG[0] - _Pt0) < 0)vecZBadge *= -1;		
		Vector3d vecDirP = nDirection==1?vecZBadge:vecX;// vector pointing the hor/ver transformation of the direction vector
	
	// transformation to plan	
		CoordSys cs2Plan;
		Vector3d vecXP = vecX;
		Vector3d vecYP = vecX.crossProduct(-_ZW);
		Vector3d vecZP = _ZW;		
		cs2Plan.setToAlignCoordSys(_Pt0, vecX, vecY, vecZ, ptXZ, vecXP*dScalePlan, vecYP*dScalePlan, vecZP*dScalePlan);
						
	// transform combination shape to plan view			
		PlaneProfile pp = ppTool;
		pp.transformBy(cs2Plan);
		if (nDirection == 1)
		{
			Point3d pts[] = Line(_Pt0,vecZBadge).orderPoints(pp.intersectPoints(Plane(_PtG[0], vecX), true, false));
			if (pts.length() > 0)
			{
				pts.first().vis(6);
				ptXZ+=vecZBadge*vecZBadge.dotProduct(ptXZ-pts.first());
			}

			cs2Plan.setToAlignCoordSys(_Pt0, vecX, vecY, vecZ, ptXZ, vecXP*dScalePlan, vecYP*dScalePlan, vecZP*dScalePlan);
			pp = ppTool;
			pp.transformBy(cs2Plan);
		}//pp.vis(2);
		ppPlanSym = PlaneProfile(CoordSys(ptXZ, vecXP, vecYP, vecZP));
		ppPlanSym.unionWith(pp);
		//dpPlan.draw(pp); // draw combi outline
		
	// guide line
		{
			PLine plGuide(vecZP);
			Point3d pt1 = _PtG[0], pt2=_Pt0;
						
			Point3d pts[] = Line(_Pt0,vecZBadge).orderPoints(pp.intersectPoints(Plane(_PtG[0], vecX), true, false));
			if (pts.length() > 0)pt1 = pts.first();
			else 
			{
				pt2 = pp.closestPointTo(_PtG[0]);
				pt1 = pt2 + vecYP * vecYP.dotProduct((pp.closestPointTo(_Pt0)) - pt2);
			}
		
			double d = abs(vecZBadge.dotProduct(pt1-pt2));
			d = d > dTextHeight? .5 * dTextHeight : d * .33;
			
			plGuide.addVertex(pt1);
			plGuide.addVertex(pt1-vecZBadge*d);
			plGuide.addVertex(pt2+vecZBadge*d);				
			plGuide.addVertex(pt2);
			dpPlan.draw(plGuide);
		}

	// text
		Point3d pts[] = Line(ptXZ, -vecX).orderPoints(pp.intersectPoints(Plane(ptXZ, vecFace), true, false));
		Point3d ptTxt = (pts.length() > 0 ? pts.first() : ptXZ) + vecX*.5*dTextHeight;
		ptXZ.vis(3);
		if (text.length()>0)
		{
			dpPlan.draw(PLine(ptTxt, pp.closestPointTo(ptTxt)));	
			dpPlan.draw(text, ptTxt, vecX, -nFace*vecFace, 1, 0);//, _kDeviceX);
		}
		
	// symbols	
		dpPlan.color(nColorPlanSymbol);
		for (int i = 0; i < tslCells.length(); i++)
		{
			Map m = tslCells[i].map();
			
			pp = m.getPlaneProfile("Shape");
			pp.transformBy(cs2Plan);
			pp.transformBy(_ZW * _ZW.dotProduct(ptXZ - pp.coordSys().ptOrg())); // project to plan
			//pp.vis(4);

		// get extents of profile
			double dXY = dWidth;//pp.dX() > pp.dY() ? pp.dX() : pp.dY();
			{ 
				LineSeg seg = pp.extentInDir(vecXP);
				double dX = abs(vecXP.dotProduct(seg.ptStart()-seg.ptEnd()));
				double dY = abs(vecYP.dotProduct(seg.ptStart()-seg.ptEnd()));	
				dXY = dX > dY ? dX : dY;
			}

		
			String sType = tslCells[i].propString(0);
			if (_BlockNames.findNoCase(sType)>-1)
			{ 
				Block block(sType);
				LineSeg seg = block.getExtents();
				double dX = abs(_XW.dotProduct(seg.ptEnd() - seg.ptStart()));
				double dY = abs(_YW.dotProduct(seg.ptEnd() - seg.ptStart()));
				double dMax = (dX < dY ? dY : dX)*1.1; dMax = dMax <= 0 ? 1 : dMax;
				
				double scale = dXY / dMax;
				dpPlan.draw(block, pp.coordSys().ptOrg(), vecXP*scale, vecYP*scale, vecZP*scale);	
			}
			else
			{ 
				dpPlan.draw(pp);
			}
			ppPlanSym.unionWith(pp);
		}
	}
//End Display//endregion 

//region Element Tooling
	PLine plTools[] = ppTool.allRings(true, false);
	if (bAddElementTool && plTools.length()>0)
	{
	//  NoNail		
		PLine plNN;
		plNN.createRectangle(ppTool.extentInDir(vecX), vecX, vecY);
		
		double dHTotal;
		int nOuterZone;
		for (int i=0;i<5;i++) 
		{ 
			int nZone = nFace * (i + 1);
			ElemZone zone = el.zone(nZone);
			double dH = zone.dH();
			
		// skip zones which do not contain any genbeam	// TODO ptFace needs to be adopted as well
			//if (nGenBeamZones.length() > 0 && nGenBeamZones.find(nZone) < 0)continue;
			
			if (dH>dEps)
			{ 
				nOuterZone = nZone;
				dHTotal += dH;
				ElemNoNail nn(nZone, plNN);
				el.addTool(nn);
			}			 
		}//next i
		
	// Sawline´
		double dToolDepth = dHTotal;
		PLine plTool = plTools.first();
		if (nTooling==3 || (bByCombination && dRadius==0))
		{ 
			ElemSaw tool(nOuterZone, plTool, dToolDepth, nToolIndex, _kLeft, _kCCWise, _kNoOverShoot);
			el.addTool(tool);
		}	
	// Milling Line
		else if (nTooling==4 || (bByCombination && abs(dRadius)>0))
		{ 
			ElemMill tool(nOuterZone, plTool, dToolDepth, nToolIndex, _kLeft, _kCCWise, _kNoOverShoot);
			el.addTool(tool);
		}			

		assignToElementGroup(el, true, nOuterZone, nOuterZone==0?'Z':'E');

	}
	else if (bHasElement)
	{
		assignToElementGroup(el, true, 0, 'Z');
	}
//endregion 

//region Collect and publish receptor nodes
	// a node is a location where tubing or milling could link to
	Map mapNodes;
	{ 
		Vector3d vecDir45=vecDir+vecPerp, vecPerp45=vecPerp-vecDir;
		vecDir45.normalize(); vecPerp45.normalize();
		Vector3d vecDirs[] = { vecPerp*nFace, -vecPerp*nFace, vecDir, - vecDir};//, - vecPerp45, vecPerp45, vecDir45, - vecDir45 };
		int numCell = tslCells.length();
		
		for (int i=0;i<ptLocs.length();i++) 
		{ 
			Point3d& ptLoc = ptLocs[i]; 
			TslInst& t = tslCells[i];
			Map mapCellNodes;
			Map m;
			
			for (int j=0;j<vecDirs.length();j++) 
			{ 
				Vector3d vecN = vecDirs[j]; 
				Vector3d vecP = vecN.crossProduct(-vecFace);				
				
				if (numCell>1)
				{
					if (i == 0 && vecN.dotProduct(-vecDir) > 0)
					{ continue;}
					else if (i>0 && i < numCell - 1 && !vecN.isParallelTo(vecPerp))
					{ continue;}
					else if (i == numCell - 1 && vecN.dotProduct(vecDir) > 0) 
					{ continue;}
				} // skip any 

				
				Point3d pt,pts[0];
				pts = Line(ptLoc, vecN).orderPoints(ppTool.intersectPoints(Plane(ptLoc, vecP), true, false));
				
				if (pts.length()>0)
				{ 
					pt = pts.first();
					m.setPoint3d("pt", pt);			//pt.vis(i);
					m.setVector3d("vecNormal", -vecN);
					m.setEntity("cell", t);	
					m.setInt("nodeIndex", j+1);
					mapNodes.appendMap("Node", m);	
					mapCellNodes.appendMap("Node", m);		
					
					
					if (bDebug)
					{ 
						Display dpX(1);dpX.textHeight(U(10));
						dpX.draw(j + 1, pt, _XW, _YW, 0, 0, _kDeviceX );						
					}

				}
				
			}//next j	
	
		// store data in submap x of cell
			Map mapX;
			mapX.setMap("Node[]", mapCellNodes);
			mapX.setPlaneProfile("Shape", ppTool);
			mapX.setVector3d("vecDir", vecDir);
			mapX.setVector3d("vecPerp", vecPerp);
			mapX.setDouble("Length", dLength);
			mapX.setDouble("Width", dWidth);
			mapX.setVector3d("vecFace", vecFace);
			mapX.setEntity("ent", _ThisInst);
			t.setSubMapX(kInstaCombination, mapX);		
			
			 
		}//next i
					
	}

//End Collect and publish receptors//endregion 

//region Publish coordSys and nodes
	_Map.setMap("Node[]", mapNodes);
	_Map.setDouble("Length", dLength);
	_Map.setDouble("Width", dWidth);
	_Map.setPlaneProfile("Shape", ppTool);
	_Map.setPlaneProfile("ShapePlan", ppPlanTool);
	_Map.setPlaneProfile("SymbolPlan", ppPlanSym);
	_Map.setPlaneProfile("Contour", ppContour);

	// Publish combination snap profiles
	{ 
		Vector3d vecXD = vecX*.5*ppTool.dX();
		Vector3d vecYD = vecY*.5*ppTool.dY();
		Point3d pt = ppTool.ptMid();
		Map m;
		for (int i=0;i<4;i++) 
		{ 	
		// the vecX of the snap profile defines the connection direction	
			Vector3d vecXN = vecYD; vecXN.normalize();
			Vector3d vecYN = vecXN.crossProduct(-vecFace);
		
		// a triangle shape towards center
			PLine pl(pt, pt - vecXD + vecYD, pt + vecXD + vecYD);
			PlaneProfile pp(CoordSys(pt,vecXN, vecYN, vecFace));
			pp.joinRing(pl, _kAdd);
			//if (bDebug){Display dpx(i); dpx.draw(pp,_kDrawFilled, 80);}pp.coordSys().vis(i);
			if (i % 2 == 0) // swap side
				vecYD *= -1;
			if (i==1) // swap X and Y
			{
				Vector3d vec =vecYD;
				vecYD=vecXD;
				vecXD=vec;
			}
			
			m.appendPlaneProfile("Snap", pp);	 
		}//next i
		Map mapX;
		mapX.setPlaneProfile("Shape", ppTool);
		mapX.setVector3d("vecFace", vecFace);
		mapX.setEntity("ent", _ThisInst);
		mapX.setMap("Snap[]", m);
		_ThisInst.setSubMapX(kInstaCombination, mapX);
	}

	_Map.setVector3d("vecDir", vecDir);
	_Map.setVector3d("vecPerp", vecPerp);
	_Map.setVector3d("vecFace", vecFace);	
	_Map.setVector3d("vecX", vecX);
	_Map.setVector3d("vecY", vecY);
	_Map.setVector3d("vecZ", vecZ);
	_Map.setVector3d("vecOrg", ptOrg-_PtW);
	
	_Map.setString("Text", text);
	_Map.setPoint3d("ptPlanText", ptXZ);
	
	for (int i=0;i<_PtG.length();i++) // make grip position independent from dragging of _Pt0
	{ 
		_Map.setVector3d("grip"+i, _PtG[i] - _PtW); 
		 
	}//next i

//End Publish coordSys//endregion 


//region Conduit Creation
	if (_bOnDbCreated || bDebug)
	{ 	
	//region Auto Connect Conduits Between Combinations
		Entity links[] = _Map.getEntityArray("Combination[]", "", "Combination");		
		for (int i=0;i<links.length();i++) 
		{ 
			TslInst t = (TslInst)links[i];
			if (t.bIsValid() && (t.scriptName()==scriptName() || (t.scriptName()=="instaCombination" && scriptName()=="__HSB__PREVIEW")))
			{ 
			// build orthogonal connection vecs seen from source
				Point3d pt1=_Pt0, pt2=t.ptOrg();
				Point3d ptm = (pt1+pt2) * .5;
				Vector3d vecC = pt2 - pt1;
				Vector3d vecXC = vecX, vecYC = vecY;
				if (vecC.dotProduct(vecX) < 0) vecXC *= -1;
				if (vecC.dotProduct(vecY) < 0) vecYC *= -1;
				
				double dx = vecXC.dotProduct(pt2 - pt1);
				double dy = vecYC.dotProduct(pt2 - pt1);
				
			// collect closest node of source pointing towards target
				Vector3d vec1 = dx > dy ? vecXC : vecYC;
				Vector3d vec2 = dx > dy ? vecYC : vecXC;
				
				vecXC.vis(ptm, 1);
				vecYC.vis(ptm, 3);
				
				int index1 = -1, index2 = -1;
				Entity cellA, cellB;
				Vector3d vecN1, vecN2;
			
			// find cell in parent	
				{ 
					double dMin = U(10e5);
					Map mapNodes = _Map.getMap("Node[]");
					for (int j=0;j<mapNodes.length();j++)
					{ 
						Map m = mapNodes.getMap(j);					
						Point3d pt = m.getPoint3d("pt");
						Vector3d vecNormal = m.getVector3d("vecNormal");
						if (!vecNormal.isCodirectionalTo(vec1))continue;
						
						double d = (pt - pt2).length();
						if (d<dMin)
						{ 
							dMin = d;
							index1 = m.getInt("nodeIndex");
							cellA = m.getEntity("cell");
							
							if (cellA.bIsValid())
							{ 
								pt.vis(6);
							}
							cellA.realBody().vis(6);
							pt1 = pt;
							vecN1 = vecNormal;
							
						}
					}
					pt1.vis(index1);
				}

			// find cell in linked combination
				{ 
					double dMin = U(10e5);
					Map mapCombi = t.map();
					Map mapNodes = mapCombi.getMap("Node[]");				
					for (int j=0;j<mapNodes.length();j++) 
					{ 
						Map m = mapNodes.getMap(j);
						
						Point3d pt = m.getPoint3d("pt");
						Vector3d vecNormal = m.getVector3d("vecNormal");
						double d = (pt - pt1).length();
						if ((vecNormal.isCodirectionalTo(-vec2) && d<dMin) || 							// simple angled and closed to
							vecNormal.isCodirectionalTo(-vec1) && abs(vec2.dotProduct(pt-pt1))<U(50))	// straight (with tolerance of +-50mm)
						{ 
							dMin = d;
							index2 = m.getInt("nodeIndex");
							cellB = m.getEntity("cell");
							
							
							if (cellB.bIsValid())
							{ 
								pt.vis(6);
							}	
							
							pt2 = pt;
							vecN2 = vecNormal;
						}
					}//next j	
					pt2.vis(index2);	
				}

			// Create conduit
			// create TSL
				TslInst tslNew;				Map mapTsl;
				int bForceModelSpace = true;	
				String sExecuteKey,sCatalogName = sConduitCatalog;
				String sEvent="OnDbCreated"; // "OnElementConstructed", "OnRecalc", "OnMapIO"...
				GenBeam gbsTsl[] = {};		Entity entsTsl[] = {_ThisInst, t, cellA, cellB};			Point3d ptsTsl[] = {ptm, pt1, pt2};
				gbsTsl = genbeams;
				if (bHasElement)entsTsl.append(el);

				mapTsl.setInt("nodeIndexA", index1);
				mapTsl.setInt("nodeIndexB", index2);
				//mapTsl.setEntity("cell1", cellA);
				//mapTsl.setVector3d("vecN1", vecN1);
				mapTsl.setPoint3d("pt", pt1);//cells[i].ptOrg()+vecN1*dN1);
				//mapTsl.setEntity("cell2", cellB);
				//mapTsl.setVector3d("vecN2", vecN2);


				PLine pl;
				pl.addVertex(pt1);
				Point3d pt3;
				if (Line(pt1, vec1).hasIntersection(Plane(pt2,vec1), pt3))
				{
					pl.addVertex(pt3);
					//ptsTsl.append(pt3);
					//mapTsl.setInt("ConnectionType", 2);// simple angled
				}
				pl.addVertex(pt2);	
				

				if (bDebug)
					pl.vis(i);
				else
					tslNew.dbCreate(kInstaConduit , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, sCatalogName, bForceModelSpace, mapTsl, sExecuteKey, sEvent); 	
			}
			 
		}//next i
	//endregion 
	
	//region Edge Conduits
		if (sConduitCatalog!=kDisabled)
		{ 
			
		// Get anchor entry to distinguish between cell and combination nodes	
			Map properties = TslInst().mapWithPropValuesFromCatalog(kInstaConduit,sConduitCatalog);
			String anchor = properties.getMap("PropString[]").getMap(2).getString("strValue");
			int bAnchorCombi = anchor == tAnchorCombination;
			Map mapCombinationNodes = _ThisInst.subMapX(kInstaCombination);
			
			
			
			Vector3d vecConduitDirs[0];
			if (sConduitAlignment == kTopBottom || sConduitAlignment == kBottom) vecConduitDirs.append(-nFace*(nDirection==0?vecPerp:vecDir));
			if (sConduitAlignment == kTopBottom || sConduitAlignment == kTop) vecConduitDirs.append(nFace*(nDirection==0?vecPerp:vecDir));
	
			
		//region Cell dependency
		// Find closest cell to position	
			if (sConduitAlignment!=kByRule && !bAnchorCombi)
			{ 		
				Map mapCells;
				Map mapNodes = _Map.getMap("Node[]");
				for (int i=0;i<vecConduitDirs.length();i++) 
				{ 
					Vector3d vecConduitDir = vecConduitDirs[i];
					
					double dMin = U(10e5);
					Map mapCell;
					Point3d pt1;
					int index1;
					Vector3d vecN1;	
					
					for (int j=0;j<mapNodes.length();j++)
					{ 
						Map m = mapNodes.getMap(j);					
						Point3d pt = m.getPoint3d("pt");
						Vector3d vecNormal = m.getVector3d("vecNormal");
						if (!vecNormal.isCodirectionalTo(vecConduitDir))continue;
	
						double d = (pt - _Pt0).length();
						if (d<dMin)
						{ 
							dMin = d;
							mapCell = m;
							index1 = m.getInt("nodeIndex");
							pt1 = pt;
							vecN1 = vecNormal;	
						}
					}					
					//vecN1.vis(pt1,index1);
					if (mapCell.length()>0)
						mapCells.appendMap("NodeCell",mapCell);
				}//next i	
				
			// Create conduit per cell node
				for (int i=0;i<mapCells.length();i++) 
				{ 
					Map m= mapCells.getMap(i);
					Point3d pt = m.getPoint3d("pt");
					Vector3d vecNormal = m.getVector3d("vecNormal");
					Entity cell = m.getEntity("Cell"); 
					int index1 = m.getInt("nodeIndex");
					
					
					if (bDebug)
						vecNormal.vis(pt,index1);
				// Create conduit		
					else
					{ 
						TslInst tslNew;		Map mapTsl;		int bForceModelSpace = true;	
						String sExecuteKey,sCatalogName = sConduitCatalog;
						String sEvent="OnDbCreated"; // "OnElementConstructed", "OnRecalc", "OnMapIO"...
						GenBeam gbsTsl[] = {};		Entity entsTsl[] = {_ThisInst, cell};			Point3d ptsTsl[] = {pt+vecNormal*U(200), pt};
						gbsTsl = genbeams;
						if (bHasElement)entsTsl.append(el);
						
						mapTsl.setInt("nodeIndexA", index1);
						mapTsl.setPoint3d("pt", pt);
						tslNew.dbCreate(kInstaConduit , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, sCatalogName, bForceModelSpace, mapTsl, sExecuteKey, sEvent); 		
					}				
				}//next i					
				
			}			
		//endregion 

		//region Combination dependency
			else if (sConduitAlignment != kByRule && bAnchorCombi)
			{
				Map mapNodes = mapCombinationNodes.getMap(kSnaps);
				
				LineSeg seg = ppTool.extentInDir(vecX);
				double dy = abs(vecY.dotProduct(seg.ptEnd() - seg.ptStart()));
				
				for (int i = 0; i < vecConduitDirs.length(); i++)
				{
					Vector3d vecNormal = vecConduitDirs[i];
					
					Point3d pt = ppTool.ptMid() + vecY * .5 * dy * (vecNormal.isCodirectionalTo(vecY) ? 1 :- 1);
					pt.vis(40);
					if (bDebug)
						vecNormal.vis(pt,1);
				// Create conduit		
					else
					{ 
						TslInst tslNew;		Map mapTsl;		int bForceModelSpace = true;	
						String sExecuteKey;
						String sEvent="OnDbCreated"; // "OnElementConstructed", "OnRecalc", "OnMapIO"...
						GenBeam gbsTsl[] = {};		Entity entsTsl[] = {_ThisInst};			Point3d ptsTsl[] = {pt+vecNormal*U(200), pt};
						gbsTsl = genbeams;
						if (bHasElement)entsTsl.append(el);

						mapTsl.setVector3d("vecN1", vecNormal);
						mapTsl.setEntity("ent1", _ThisInst);
						tslNew.dbCreate(kInstaConduit , _XW ,_YW,gbsTsl, entsTsl, ptsTsl, sConduitCatalog, bForceModelSpace, mapTsl, sExecuteKey, sEvent); 
						
						reportMessage("\n creation " + tslNew.bIsValid());
						if (tslNew.bIsValid())
							tslNew.transformBy(Vector3d(0, 0, 0));
						
					}						
				}

			}
		//endregion 
			
			
			
		}
		
	//endregion 
	}

	
	
//endregion 





//region Trigger
{ 

	// create TSL
	TslInst tslDialog;			Map mapTsl;						
	GenBeam gbsTsl[] = {};		Entity entsTsl[] = {};			Point3d ptsTsl[] = {_Pt0};
	int nProps[] ={ };			double dProps[] ={ };			String sProps[] ={ };
	

// TriggerFlipFace
	addRecalcTrigger(_kContextRoot, sTriggerFlipSide );
	if (_bOnRecalc && (_kExecuteKey==sTriggerFlipSide || _kExecuteKey==sDoubleClick))
	{
		sFace.set(nFace==1?sFaces[0]:sFaces[1]);
		
	// swap grip to opposite side	
		if (_Map.hasDouble("ZOffsetPlan") && _PtG.length()>0)
			_PtG[0] -= vecFace * (vecFace.dotProduct(_PtG[0]-_Pt0)+dZ+ _Map.getDouble("ZOffsetPlan"));

		setExecutionLoops(2);
		return;
	}
	if (_PtG.length()>0)
		_Map.setDouble("ZOffsetPlan", vecFace.dotProduct(_PtG[0] - _Pt0));


// Trigger ShowHideTool
	int bShowElementTool = _Map.hasInt("ShowElementTool")?_Map.getInt("ShowElementTool"):true;
	String sTriggerShowHideTool =bShowElementTool?T("|Hide Tools|"):T("|Show Tools|");
	addRecalcTrigger(_kContextRoot, sTriggerShowHideTool);
	if (_bOnRecalc && _kExecuteKey==sTriggerShowHideTool)
	{
		bShowElementTool = bShowElementTool ? false : true;
		_Map.setInt("ShowElementTool", bShowElementTool);		
		setExecutionLoops(2);
		return;
	}
	_ThisInst.setShowElementTools(bShowElementTool);

//region Trigger AddRule
	String sTriggerAddRule = T("|Save as rule|");
	addRecalcTrigger(_kContextRoot, sTriggerAddRule );
	if (_bOnRecalc && _kExecuteKey==sTriggerAddRule)
	{
		//int bHasConduit = tslConduits.length()>0; 
		String sRuleName = tslCells.length() + "x " + dDepth;
		mapTsl.setInt("DialogMode",1);
		//mapTsl.setInt("HasConduit", bHasConduit);
		sProps.append(sRuleName);
		
		tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);						
				
		
		if (tslDialog.bIsValid())
		{ 
			int bOk = tslDialog.showDialog();
			if (bOk)
			{
				sRuleName = tslDialog.propString(0);
				int nRule = sRules.findNoCase(sRuleName ,- 1);
				if (bIsDefaultRule) // reset default rule map
				{ 
					mapRules = Map();
					nRule = -1;
				}
			// build rule
				Map mapNewRule, mapCells;
				for (int i=0;i<tslCells.length();i++) 
				{ 
					TslInst cell = tslCells[i];
					Map m;
					m.setString("scriptName", cell.scriptName());
					m.setMap("Properties", cell.mapWithPropValues());
					
				//region Add Conduits
//					if (bHasConduit)
//					{ 
//						Map mapConduits;
//						for (int j=0;j<tslConduits.length();j++) 
//						{ 
//							TslInst conduit= tslConduits[j]; 
//							Map mapConduit = conduit.map();
//						// cehck if linked cell matches
//							Entity cell1 = mapConduit.getEntity("cell1");
//							if ( ! cell1.bIsValid() || cell != cell1)continue;
//							
//							mapConduit.setString("scriptName", conduit.scriptName());
//							mapConduit.setMap("Properties", conduit.mapWithPropValues());
// 							mapConduits.appendMap("Conduit", mapConduit);
//						}//next j
//	
//						if (mapConduits.length()>0)
//							m.setMap("Conduit[]", mapConduits);
//					}
				//endregion 	

					mapCells.appendMap("Cell", m);
				}//next i
				mapNewRule.setMap("Cell[]", mapCells);
				mapNewRule.setMapName(sRuleName);
				
			// invalid name
				if (sRuleName.length()<1)
				{
					reportMessage("\n" + T("|Invalid name.|"));
				}
				else
				{ 
					sRule.set(sRuleName); // set the rule name to this instance
				// add new rule
					if (nRule<0)
					{ 
						mapRules.appendMap("Rule", mapNewRule);
						mapSetting.setMap("Rule[]", mapRules);
					}
					else
					{ 
						Map mapTemp;
						for (int i=0;i<mapRules.length();i++) 
						{ 
							Map m = nRule==i?mapNewRule:mapRules.getMap(i);
							mapTemp.appendMap("Rule", m);
							 
						}//next i
						mapRules = mapTemp;
						mapSetting.setMap("Rule[]", mapRules);
					}
					if (mo.bIsValid())mo.setMap(mapSetting);
					else mo.dbCreate(mapSetting);	
				}

			}
			tslDialog.dbErase();
		}
		setExecutionLoops(2);
		return;			
	}
	//endregion
	
//region Trigger DeleteRule
	String sTriggerDeleteRule = T("|Delete rule|");
	addRecalcTrigger(_kContextRoot, sTriggerDeleteRule );
	if (_bOnRecalc && _kExecuteKey==sTriggerDeleteRule)	
	{ 
		mapTsl.setInt("DialogMode",2);
		sProps.append(sRule);
		
		tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);						
		if (tslDialog.bIsValid())
		{
			int bOk = tslDialog.showDialog();
			if (bOk)
			{ 
				String sRuleName = tslDialog.propString(0).makeUpper();
				Map mapTemp;
				for (int i=0;i<mapRules.length();i++) 
				{ 
					Map m = mapRules.getMap(i);
					String _sRuleName = m.nameAt(i).makeUpper();
					if (_sRuleName==sRuleName){ continue;}
					mapTemp.appendMap("Rule", m);
					 
				}//next i
				mapRules = mapTemp;
				mapSetting.setMap("Rule[]", mapRules);
				
				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);				
			}
			tslDialog.dbErase();
		}
		setExecutionLoops(2);
		return;	
	}
	//endregion

// Context Trigger

//region Trigger Set Vertical Cell Offset
	// from a certain qty on one would like to offset vertical installations by a given num of cells to have the combination range within standard reach 
	String sTriggerVerticalOffsetRule = T("|Specify vertical cell offset|");
	addRecalcTrigger(_kContext, sTriggerVerticalOffsetRule );
	if (_bOnRecalc && _kExecuteKey==sTriggerVerticalOffsetRule)	
	{ 
		mapTsl.setInt("DialogMode",3);
		nProps.append(nNumVerticalCellOffset); // the offset
		nProps.append(nNumRequiredCellOffset); // min required cells

		tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);						
		if (tslDialog.bIsValid())
		{
			int bOk = tslDialog.showDialog();
			if (bOk)
			{ 
				nNumVerticalCellOffset= tslDialog.propInt(0);
				if (nNumVerticalCellOffset < 1)nNumVerticalCellOffset = 0;// dsiabled
				nNumRequiredCellOffset= tslDialog.propInt(1);
				Map map = mapSetting.getMap("Combination\\Placement\\VerticalOffset");
				map.setInt("CellOffset", nNumVerticalCellOffset);
				map.setInt("NumRequired", nNumRequiredCellOffset);		
				mapSetting.setMap("Combination\\Placement\\VerticalOffset", map);				
				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);				
			}
			tslDialog.dbErase();
		}
		setExecutionLoops(2);
		return;	
	}
	//endregion	
	
//region Trigger Define plan view
	// from a certain qty on one would like to offset vertical installations by a given num of cells to have the combination range within standard reach 
	String sTriggerPlanviewSettings = T("|Plan view settings|");
	addRecalcTrigger(_kContext, sTriggerPlanviewSettings );
	if (_bOnRecalc && _kExecuteKey==sTriggerPlanviewSettings)	
	{ 
		mapTsl.setInt("DialogMode",4);
		
		if (_DimStyles.findNoCase(sDimStylePlan ,- 1) >- 1)
			sProps.append(sDimStylePlan);
		nProps.append(nColorPlan);
		nProps.append(nColorPlanSymbol);
		dProps.append(dTextHeightPlan);
		dProps.append(dScalePlan > 0 ? dScalePlan : 1);

		tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);						
		if (tslDialog.bIsValid())
		{
			int bOk = tslDialog.showDialog();
			if (bOk)
			{ 
				dTextHeightPlan = tslDialog.propDouble(0);
				dScalePlan = tslDialog.propDouble(1);
				sDimStylePlan = tslDialog.propString(0);
				nColorPlan = tslDialog.propInt(0);
				nColorPlanSymbol = tslDialog.propInt(1);
				Map map = mapSetting.getMap("Combination\\Planview");
				map.setInt("Color",nColorPlan );
				map.setString("DimStyle", sDimStylePlan);
				map.setDouble("TextHeight", dTextHeightPlan>0?dTextHeightPlan:0);
				map.setDouble("Scale",dScalePlan>0?dScalePlan:1);
				map.setInt("ColorSymbol",nColorPlanSymbol );
				mapSetting.setMap("Combination\\Planview", map);				
				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);				
			}
			tslDialog.dbErase();
		}
		setExecutionLoops(2);
		return;	
	}
	//endregion	

//region Trigger Define element view
	// from a certain qty on one would like to offset vertical installations by a given num of cells to have the combination range within standard reach 
	String sTriggerElementviewSettings = T("|Element view settings|");
	addRecalcTrigger(_kContext, sTriggerElementviewSettings );
	if (_bOnRecalc && _kExecuteKey==sTriggerElementviewSettings)	
	{ 
		mapTsl.setInt("DialogMode",5);
		
		if (_DimStyles.findNoCase(sDimStyleElement ,- 1) >- 1)
			sProps.append(sDimStyleElement);
		nProps.append(nColorElement);
		nProps.append(nColorElementSymbol);
		nProps.append(nColorElementOpposite);
		
		dProps.append(dTextHeightElement);
		dProps.append(dScaleElement > 0 ? dScaleElement : 1);
		dProps.append(dSymbolOffsetElement);
		
		tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);						
		if (tslDialog.bIsValid())
		{
			int bOk = tslDialog.showDialog();
			if (bOk)
			{ 
				dTextHeightElement = tslDialog.propDouble(0);
				dScaleElement = tslDialog.propDouble(1);
				dSymbolOffsetElement = tslDialog.propDouble(2);
				sDimStyleElement = tslDialog.propString(0);
				nColorElement = tslDialog.propInt(0);
				nColorElementSymbol = tslDialog.propInt(1);
				nColorElementOpposite = tslDialog.propInt(2);
				Map map = mapSetting.getMap("Combination\\Elementview");
				map.setInt("Color",nColorElement );
				map.setString("DimStyle", sDimStyleElement);
				map.setDouble("TextHeight", dTextHeightElement>0?dTextHeightElement:0);
				map.setDouble("Scale",dScaleElement>0?dScaleElement:1);
				map.setDouble("OffsetSymbol",dSymbolOffsetElement);
				map.setInt("ColorSymbol",nColorElementSymbol );
				map.setInt("ColorOpposite",nColorElementOpposite );
				mapSetting.setMap("Combination\\Elementview", map);				
				if (mo.bIsValid())mo.setMap(mapSetting);
				else mo.dbCreate(mapSetting);				
			}
			tslDialog.dbErase();
		}
		setExecutionLoops(2);
		return;	
	}
	//endregion

//region Trigger Define plan view
	// from a certain qty on one would like to offset vertical installations by a given num of cells to have the combination range within standard reach 
	String sTriggerLogSettings = T("|Log Wall Settings|");
	if(bIsLogWall)
	{
		addRecalcTrigger(_kContext, sTriggerLogSettings );
		if (_bOnRecalc && _kExecuteKey==sTriggerLogSettings)	
		{ 
			mapTsl.setInt("DialogMode",6);
			sProps.append(sNoYes[bIsCourseElevation]);
			tslDialog.dbCreate(scriptName() , _XW,_YW,gbsTsl, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);						
			if (tslDialog.bIsValid())
			{
				int bOk = tslDialog.showDialog();
				if (bOk)
				{ 
					bIsCourseElevation = sNoYes.find(tslDialog.propString(0),1);
					Map map = mapSetting.getMap("Combination\\LogWall");
					map.setInt("IsCourseElevation",bIsCourseElevation );
					mapSetting.setMap("Combination\\LogWall", map);				
					if (mo.bIsValid())mo.setMap(mapSetting);
					else mo.dbCreate(mapSetting);				
				}
				tslDialog.dbErase();
			}
			setExecutionLoops(2);
			return;	
		}		
	}

	//endregion	

//	HSB-16090
//region Trigger PrintAllCommands
	String sTriggerPrintCommand2 = T("|Show all Commands for UI Creation|");
	addRecalcTrigger(_kContext, sTriggerPrintCommand2 );
	if (_bOnRecalc && _kExecuteKey==sTriggerPrintCommand2)
	{
		String text = TN("|You can create a toolbutton, a palette or a ribbon command using one of the following commands.|")+
			TN("|Copy the corresponding line starting with ^C^C below into the command property of the button definition|");	
		
		String command;
		
		command += TN("|Command to insert a new instance of the tool|")+"\n";
		command += "^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert \"instaCombination\")) TSLCONTENT";
		
		command += TN("\n|Command to insert a new instance of the tool with no dialog using an existing catalog entry, i.e. 'ABC123'|")+"\n";
		command += "^C^C(defun c:TSLCONTENT() (hsb_ScriptInsert \"instaCombination\" \"ABC123\")) TSLCONTENT";
		
		command += TN("\n|Command to flip the face of the tool|")+"\n";
		command += "^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM \"|Flip Face|\") (_TM \"|Select combination|\"))) TSLCONTENT";
		
		command += TN("\n|Command to save the current state as rule|")+"\n";
		command += "^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM \"|Save as rule|\") (_TM \"|Select combination|\"))) TSLCONTENT";
		
		command += TN("\n|Command to delete a rule|")+"\n";
		command += "^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM \"|Delete rule|\") (_TM \"|Select combination|\"))) TSLCONTENT";
		
		command += TN("\n|Command to hide potential CNC tools|")+"\n";
		command += "^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM \"|Hide Tools|\") (_TM \"|Select combination|\"))) TSLCONTENT";
		
		command += TN("\n|Command to show potential CNC tools|")+"\n";
		command += "^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM \"|Show Tools|\") (_TM \"|Select combination|\"))) TSLCONTENT";
		
		command += TN("\n|Command to specify the vertical offset when combination consists of more than n cells|")+"\n";
		command += "^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM \"|Specify vertical cell offset|\") (_TM \"|Select combination|\"))) TSLCONTENT";
		
		command += TN("\n|Command to specify the plan view appearance of the instance|")+"\n";
		command += "^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM \"|Plan view settings|\") (_TM \"|Select combination|\"))) TSLCONTENT";
		
		command += TN("\n|Command to specify the element view appearance of the instance|")+"\n";
		command += "^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM \"|Element view settings|\") (_TM \"|Select combination|\"))) TSLCONTENT";
		
		command += TN("\n|Command to specify the log wall settings of the instance|")+"\n";
		command += "^C^C(defun c:TSLCONTENT() (hsb_RecalcTslWithKey (_TM \"|Log Wall Settings|\") (_TM \"|Select combination|\"))) TSLCONTENT";

		reportNotice(text +"\n\n"+ command);		
		setExecutionLoops(2);
		return;
	}//endregion	
	
	
	
	
	
	
	
}
	
	
//End Trigger//endregion 

//reportMessage("\n"+ scriptName() + " end " + _ThisInst.handle() + " tick:" +getTickCount());

//if(bDebug)reportMessage("\n"+ scriptName() + " ending " + _ThisInst.handle() + + " tick:" +getTickCount());


























#End
#BeginThumbnail
MB5!.1PT*&@H````-24A$4@``!34```/H"`8````/^1I>```@`$E$051X`>S=
M;6A=67[O^2Z2[DZGV@^=3D^EJU-84(1VB(,*,CC<\0LY^$7`D,A-7E5RL0T=
MN+Y@D&%"W/&+,9?@+JA`:5Z482"4S:!`\J*PC#,OBF&0Q_1<F(G!*AHN,S4U
MD8RYKLIX'*EDE7Q5?M`:?D>]Y*WM=?;9^YRUSUIKK^\!<8ZVSMD/G[6/M,]/
M_[W_7_O:U[YF^,*`?8!]@'V`?8!]@'V`?8!]@'V`?8!]@'V`?8!]@'V`?8!]
M@'T@F7W`<$,``0000``!!!!```$$$$```0000``!!!(2^%I"Z\JJ(H```@@@
M@``""""```((((```@@@@``"AE"3G0`!!!!```$$$$```0000``!!!!```$$
MDA(@U$QJN%A9!!!```$$$$```0000``!!!!```$$$"#49!]```$$$$```000
M0``!!!!```$$$$``@:0$"#63&BY6%@$$$$```0000``!!!!```$$$$```00(
M-=D'$$```0000``!!!!```$$$$```0000"`I`4+-I(:+E44``0000``!!!!`
M``$$$$```0000``!0DWV`0000``!!!!```$$$$```0000``!!!!(2H!0,ZGA
M8F410``!!!!```$$$$```0000``!!!!`@%"3?0`!!!!```$$$$```0000``!
M!!!```$$DA(@U$QJN%A9!!!```$$$$```0000``!!!!```$$$"#49!]```$$
M$$```0000``!!!!```$$$$``@:0$"#63&BY6%@$$$$```0000``!!!!```$$
M$$```00(-=D'$$```0000``!!!!```$$$$```0000"`I`4+-I(:+E44``000
M0``!!!!```$$$$```0000``!0DWV`0000``!!!!```$$$$```0000``!!!!(
M2H!0,ZGA8F410``!!!!```$$$$```0000``!!!!`@%"3?0`!!!!```$$$$``
M`0000``!!!!```$$DA(@U$QJN%A9!!!```$$$$```0000``!!!!```$$$"#4
M9!]```$$$$```0000``!!!!```$$$$``@:0$"#63&BY6%@$$$$```0000``!
M!!!```$$$$```00(-=D'$$```0000``!!!!```$$$$```0000"`I`4+-I(:+
ME44``0000``!!!!```$$$$```0000``!0DWV`0000``!!!!```$$$$```000
M0``!!!!(2H!0,ZGA8F410``!!!!```$$$$```0000``!!!!`@%"3?0`!!!!`
M``$$$$```0000``!!!!```$$DA(@U$QJN%A9!!!```$$$$```0000``!!!!`
M``$$$"#49!]```$$$$```0000``!!!!```$$$$``@:0$"#63&BY6%@$$$$``
M`0000``!!!!```$$$$```00(-=D'$$```0000``!!!!```$$$$```0000"`I
M`4+-I(:+E44``0000``!!!!```$$$$```0000``!0DWV`0000``!!!!```$$
M$$```0000``!!!!(2H!0,ZGA8F410``!!!!```$$$$```0000``!!!!`@%"3
M?0`!!!!```$$$$```0000``!!!!```$$DA(@U$QJN%A9!!!```$$$$```000
M0``!!!!```$$$"#49!]```$$$$```0000``!!!!```$$$$``@:0$"#63&BY6
M%@$$$$```0000``!!!!```$$$$```00(-=D'$$```0000``!!!!```$$$$``
M`0000"`I`4+-I(:+E44``0000``!!!!```$$$$```0000``!0DWV`0000``!
M!!!```$$$$```0000``!!!!(2H!0,ZGA8F410``!!!!```$$$$```0000``!
M!!!`@%"3?0`!!!!```$$$$```0000``!!!!```$$DA(@U$QJN%A9!!!```$$
M$$```0000``!!!!```$$$"#49!]```$$$$```0000``!!!!```$$$$``@:0$
M"#63&BY6%@$$$$```0000``!!!!```$$$$```00(-=D'$$```0000``!!!!`
M``$$$$```0000"`I`4+-I(:+E44``0000``!!!!```$$$$```0000``!0DWV
M`0000``!!!!```$$$$```0000``!!!!(2H!0,ZGA8F410``!!!!```$$$$``
M`0000``!!!!`@%"3?0`!!!!```$$$$```0000``!!!!```$$DA(@U$QJN%A9
M!!!```$$$$```0000``!!!!```$$$"#49!]```$$$$```0000``!!!!```$$
M$$``@:0$"#63&BY6%@$$$$```0000``!!!!```$$$$```00(-=D'$$```000
M0``!!!!```$$$$```0000"`I`4+-I(:+E44``0000``!!!!```$$$$```000
M0``!0DWV`0000``!!!!```$$$$```0000``!!!!(2H!0,ZGA8F410``!!!!`
M``$$$$```0000``!!!!`@%"3?0`!!!!```$$$$```0000``!!!!```$$DA(@
MU$QJN%A9!'8++"\OFZM7KYJ+%R_V_9J=G34W;][L?2TN+NZ>`=\A@``""""`
M``((((```@@@@``""0H0:B8X:*PR`O/S\V9J:LI\[6M?&^KKP($#O=<K#-6\
M5E=7044``0000``!!!!```$$$$```022$2#43&:H6-'<!10\JNI2@>2P86;5
MZR8G)WOS5_4G-P000``!!!!```$$$$```0000"!F`4+-F$>'=4/`&*-3QD^=
M.M5*D-DOY)R>GNZ=KLX`((```@@@@``""""```((((```C$*$&K&."JL$P+&
M]*Z5.>@4\U_ZI5\RJK#\V[_]VYWK9MKK9]I[57?::VXJK!PTSV+0J><N+"PP
M'@@@@``""""```((((```@@@@$!4`H2:40T'*Y.[@$[]5@"Y;]^^RLK,;W_[
MV^8O_N(O1KH6IBI`U61(5:"#3FF?F9D9:5FYCRO;CP`""""```((((```@@@
M@``"?@4(-?UZ,C<$AA)05:6J*(M5DJ['APX=,O_XC_\XU#(&O<B>YMXO4%5%
M*-W3!RGR<P000``!!!!```$$$$```000&(<`H>8XE%D&`@X!-?Y1I>2@*LFO
M?_WKO6K*I:4EQUS\3])ZJ5IT[]Z]+X6L"CP)-OV;,T<$$$```0000``!!!!`
M``$$$&@F0*C9S(MG(S"R@$XQURG?_2HB;87F:Z^]9O[F;_YFY.4-.P.%FR=.
MG"#8'!:0UR&```((((```@@@@``""""`0&L"A)JMT3)C!'8+J"JS3I.>(T>.
MF#MW[NQ^<<#OM-XV:+7W"F05>G)#``$$$$```0000``!!!!```$$0@@0:H90
M9YG9"-A3N0>=8KYGSQX3<S,>5["I@)8;`@@@@``""""```((((```@@@$$*`
M4#.$.LOLO(`:_^@4<UO9V._^AS_\H?F[O_N[)#Q<P::F<4,``0000``!!!!`
M``$$$$```03&+4"H.6YQEM=I`85\ZA+>+\34]&]\XQOF3__T3XVNK9G:3=6D
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
<`@0($.@A\/\VM$J+[B&H^@````!)14Y$KD)@@@``






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
        <int nm="BreakPoint" vl="942" />
        <int nm="BreakPoint" vl="1603" />
        <int nm="BreakPoint" vl="141" />
        <int nm="BreakPoint" vl="2293" />
        <int nm="BreakPoint" vl="2193" />
        <int nm="BreakPoint" vl="2147" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-20506 layer assignment on zone 0 = Z-Layer" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="1/17/2024 5:06:54 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16090 centered anchoring of combination supported, new property to toggle available anchor nodes" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="9/6/2022 3:40:09 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16089 new command to list full syntax of available commands in report dialog, formatting dialog added" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="9/6/2022 9:05:54 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16091 relevant face terminology unified" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="8/3/2022 10:48:02 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16090 snap profiles published" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="8/1/2022 4:57:06 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14204 minor changes in description and naming" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="7/26/2022 12:32:26 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14015 supports multi storey element insertion, bugfix planview face detection" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="12/14/2021 10:26:13 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14130 bugfix selection loose genbeams" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="12/10/2021 3:23:02 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14083 supports conduit creation to edge on insert" />
      <int nm="MajorVersion" vl="3" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="12/10/2021 11:48:26 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-14084 conduit preview when linking combinations with conduits" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="12/8/2021 5:41:01 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13202 block in dwg now updated when hardware is stored" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="12/2/2021 3:26:27 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13729 new property to select conduit catalog on insert to auto connect to selected combinations, supports export to share and make" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="12/1/2021 5:27:25 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13446 bugfix duplicate on insert, planview jig enhanced, face flip does not alter node sequence" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="10/8/2021 9:38:15 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13203 supporting element tools if element is of type stickframe or roof element, new tooling options and new tool index property " />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="9/29/2021 11:18:46 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-13129 conduit supports rule based insertion" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="9/16/2021 5:04:22 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12641 height of mortise and beamcut shapes support byCombination" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="7/20/2021 8:39:36 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12284 supporting mortise or beamcut tools of cells" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="6/25/2021 11:33:11 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-12298 bugfix default insert" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="6/18/2021 11:27:42 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11403 snapping improved" />
      <int nm="MajorVersion" vl="2" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="3/29/2021 4:11:12 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11234 bugfix log course index" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="9" />
      <str nm="Date" vl="3/26/2021 9:40:28 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11234 log course setting does not conflict with non log walls" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="8" />
      <str nm="Date" vl="3/25/2021 4:37:10 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11286 Block display bugfix" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="7" />
      <str nm="Date" vl="3/24/2021 2:06:23 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11286 Block display supported" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="3/22/2021 9:53:49 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11236 optional offset for vertical combinations added, HSB-11227 elevation property added" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="3/17/2021 1:23:01 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-10793 element support added" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="4" />
      <str nm="Date" vl="3/15/2021 5:05:11 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-11022 new property format and optional connection pocket added" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="3/2/2021 5:06:52 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-10991 changing tool mode updates cells" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="2" />
      <str nm="Date" vl="3/1/2021 10:33:43 AM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-10758 rule based creation added" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="1" />
      <str nm="Date" vl="2/18/2021 5:05:24 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-10758 initial version" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="0" />
      <str nm="Date" vl="2/17/2021 4:55:05 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End