#Version 8
#BeginDescription
#Versions: 
1.6 29.11.2022 HSB-16561: Fix bug at direction vectors
1.5 08.11.2022 HSB-16561: Introduce xml structure; add 10920.1390 and 10920.1490
heavy duty models with squared top plate added (10930.1xxx and 10931.1xxx)

D >>> Dieses TSL erstellt einen Pfostenträger aus dem Pitzl System 10930 oder 10931 an einem oder mehreren Stäben.

E >>> This TSL creates Pitzl post bases type 10930 or 10931 on one or multiple beams.

TSL can be inserted in different ways:
Without point selection (just press enter) the TSL will be inserted on the bottom point of vertical beams, only. 
It is always pointing downwards, then. The bottom point of the original beam will be the bottom of the post base.

With point selection, the selected point will be projected to the x-axis of each beam. This projected point will become the bottom point of the post base.
Sloped beams are possible with this method, but no horizontal ones.
With the point selection it's even possible to insert the post base upside down on top of a post.


#End
#Type E
#NumBeamsReq 1
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 6
#KeyWords Pitzl, post base
#BeginContents
/// <summary Lang=en>
/// this TSL creates Pitzl post bases Type 10930 or 10931 on one or multiple beams.
/// </summary>

/// <insert Lang=en>
/// At least one beam is necessary. Multiple beam selection is possible.
/// Optional you can also select a point, that defines the position, where the post base is inserted (in X-Direction of each beam)
/// </insert>

/// <remark Lang=en>
/// TSL can be inserted in different ways:
/// Without point selection (just press enter) the TSL will be inserted on the bottom point of vertical beams, only. 
/// It is always pointing downwards, then. The bottom point of the original beam will be the bottom of the post base.
///
/// With point selection, the selected point will be projected to the x-axis of each beam. This projected point will become the bottom point of the post base.
/// Sloped beams are possible with this method, but no horizontal ones.
/// With the point selection it's even possible to insert the post base upside down on top of a post.
/// </remark>
/// #Versions:
// 1.6 29.11.2022 HSB-16561: Fix bug at direction vectors Author: Marsel Nakuci
// 1.5 08.11.2022 HSB-16561: Introduce xml structure; add 10920.1390 and 10920.1490 Author: Marsel Nakuci
/// <version value="1.4" date="20oct17" author="florian.wuermseer@hsbcad.com"> heavy duty models with squared top plate added (10930.1xxx and 10931.1xxx)</version>
/// <version value="1.3" date="03feb16" author="florian.wuermseer@hsbcad.com"> oversize for drill diameters added </version>
/// <version value="1.2" date="25november15" author="florian.wuermseer@hsbcad.com"> additional drill for welding added </version>
/// <version value="1.1" date="25november15" author="florian.wuermseer@hsbcad.com"> vectors corrected, standard rotation method supported, insertion not possible for horizontal beams </version>
/// <version value="1.0" date="25november15" author="florian.wuermseer@hsbcad.com"> initial version</version>

//region Constants
// basics and props
	U(1,"mm");
	double dEps=U(.1);
	int bDebug = 0;
	int nDoubleIndex, nStringIndex, nIntIndex;
	
	String sLastInserted = T("|_LastInserted|");
	String sDoubleClick = "TslDoubleClick";
//end Constants//endregion	
	
	
//region Settings
	// HSB-16561
// settings prerequisites
	String sDictionary = "hsbTSL";
	String sPath = _kPathHsbCompany+"\\TSL";
	String sFolder="Settings";
	String sPathGeneral = _kPathHsbInstall+"\\Content\\General\\TSL\\"+sFolder+"\\";	
	String sFileName ="Pitzl Pfostenträger";
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

	Map mapManufacturer=mapSetting.getMap("Manufacturer");
	Map mapFamilies=mapManufacturer.getMap("Family[]");
	String sFamilies[0];
	for (int i=0;i<mapFamilies.length();i++) 
	{ 
		Map mapFamilyI=mapFamilies.getMap(i);
		sFamilies.append(mapFamilyI.getMapName());
	}//next i
	
	
// post base's properties collection
//	String sArticles[] = 		  	{"1000", "1100", "1200", "1300", "1600", "1005", "1082", "1003", "1006", "1106", "1206", "1306"};
//	double dRangeMins[] = 		   	{U(170), U(195), U(255), U(285), U(110), U(170), U(150), U(195), U(205), U(230), U(290), U(320)};
//	double dRangeMaxs[] = 		   	{U(285), U(310), U(370), U(400), U(200), U(285), U(250), U(285), U(300), U(325), U(385), U(415)};
//	double dThreadDias[] = 		   	{U(24),  U(24),  U(24),  U(24),  U(24),  U(24),  U(20),  U(30),  U(30),  U(30),  U(30),  U(30)};
//	double dLowerThreadLengths[] = 	{U(65),  U(90),  U(150), U(180), U(35),  U(65),  U(55),  U(65),  U(65),  U(90),  U(150), U(180)};
//	double dScrewNutLengths[] = 	{U(120), U(120), U(120), U(120), U(60),  U(120), U(120), U(120), U(120), U(120), U(120), U(120)};
//	double dTopPlateDias[] = 		{U(100), U(100), U(100), U(100), U(100), U(100), U(80),  U(100), U(100), U(100), U(100), U(100)};
//	double dTopPlateThicks[] = 		{U(8),   U(8),   U(8),   U(8),   U(8),   U(8),   U(6),   U(10),  U(15),  U(15),  U(15),  U(15)};
//	double dTopLengths[] = 			{U(130), U(130), U(130), U(130), U(130), U(70),  U(130), U(130), U(130), U(130), U(130), U(130)};
//	double dBottomPlateLengths[] = 	{U(160), U(160), U(160), U(160), U(160), U(160), U(160), U(160), U(160), U(160), U(160), U(160)};
//	double dBottomPlateWidths[] = 	{U(100), U(100), U(100), U(100), U(100), U(100), U(100), U(100), U(100), U(100), U(100), U(100)};
//	double dBottomPlateThicks[] = 	{U(8),   U(8),   U(8),   U(8),   U(8),   U(8),   U(6),   U(10),  U(15),  U(15),  U(15),  U(15)};
//	int nSquaredTops[] = 			{0,      0, 	 0, 	 0, 	 0, 	 0, 	 0, 	 0, 	 1, 	 1, 	 1, 	 1};
//	
//	String sCoverHullArticles[] = {"10834.3001", "10834.1012", "10834.3020", "10834.3030", "10834.1060", "10834.3001", "10834.0000", "10833.3000", "10833.3000", "10833.3000", "", ""};
	
// required screws
	int nScrewQuant = 4;
	String sScrewArticle = "99310.1012";
	String sScrewName = T("|Plate screw|");
	double dScrewDia = U(10);
	double dScrewLength = U(120);
	
// properties category
	String sCatType = T("|Category|");
	
	String sFamilyName = T("|Type|");
//	String sFamilies[] = {"10930", "10931"};		//plane pipe, threaded pipe
	PropString sFamily (nStringIndex++, sFamilies, sFamilyName);
	sFamily.setCategory(sCatType);
	sFamily.setDescription(T("|Type|") + ":\n" + " 10930 = " + T("|Plane pipe|") + "\n" + " 10930 = " + T("|Threaded pipe|"));

	int nFamily = sFamilies.find(sFamily);
	
	
	String sArticleName = T("|Article|");
//	PropString sArticle (nStringIndex++, sArticles, sArticleName);
	PropString sArticle (nStringIndex++, "", sArticleName);
	sArticle.setCategory (sCatType);
	sArticle.setDescription(T("|Article|") + ":\n" + " 1000 = 170 - 285mm" + 
													"\n" + " 1100 = 195 - 310mm" + 
													"\n" + " 1200 = 255 - 370mm" + 
													"\n" + " 1300 = 285 - 400mm" + 
													"\n" + " 1600 = 110 - 200mm" + 
													"\n" + " 1005 = 170 - 285mm" + 
													"\n" + " 1082 = 150 - 250mm" +
													"\n" + " 1003 = 195 - 285mm (HeavyDuty)" + 
													"\n" + " 1006 = 205 - 300mm (HeavyDuty)" + 
													"\n" + " 1106 = 230 - 325mm (HeavyDuty)" + 
													"\n" + " 1206 = 290 - 385mm (HeavyDuty)" + 
													"\n" + " 1306 = 320 - 415mm (HeavyDuty)");

// properties tooling	
	String sCatTool = T("|Tooling|");
	
	String sMillName = T("|Milled|");
	String sMills[] = {T("|No|"), T("|Yes|")};
	PropString sMill (nStringIndex++, sMills, sMillName);
	sMill.setCategory (sCatTool);
	
	int nMill = sMills.find(sMill);
	
	String sMillDepthName = T("|Additional mill depth|");
	PropDouble dMillDepth (nDoubleIndex++, U(8), sMillDepthName);
	dMillDepth.setCategory (sCatTool);	
	
	String sDrillDiaOversizeName = T("|Oversize drill|");
	PropDouble dDrillDiaOversize (nDoubleIndex++, U(2), sDrillDiaOversizeName);
	dDrillDiaOversize.setCategory (sCatTool);	

	
// properties accessories
	String sCatAccessories = T("|Accessories|");
	
	String sCoverHulls[] = {T("|No|"), T("|Yes|")};
	String sCoverHullName = T("|Cover hull|");
	PropString sCoverHull (nStringIndex++, sCoverHulls, sCoverHullName);
	sCoverHull.setCategory (sCatAccessories);	
	
	int nCoverHull = sCoverHulls.find(sCoverHull);
	
	
// bOn Insert
if (_bOnInsert)
{
//	if (insertCycleCount() > 1) {eraseInstance(); return;}
//	
//// use catalog properties, or call dialog
//	String sCat = _kExecuteKey;
//	sCat.makeUpper();
//	String sCatalogNames[] = _ThisInst.getListOfCatalogNames(scriptName());
//	for (int i=0; i<sCatalogNames.length(); i++)
//		sCatalogNames[i].makeUpper();
//		
//	int nCatPos = sCatalogNames.find(sCat);
//	
//	if (nCatPos>-1)
//		setPropValuesFromCatalog(sCat);
//		
//	else
//		showDialog(sLastInserted);	
	
	if (insertCycleCount()>1) {eraseInstance(); return;}
	
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
	
	sArticle.set("---");
	sArticle.setReadOnly(true);
	showDialog("---");
	Map mapArticles;
	for (int i=0;i<mapFamilies.length();i++) 
	{ 
		Map mapFamilyI=mapFamilies.getMap(i);
		if(mapFamilyI.getMapName()==sFamily)
		{ 
			mapArticles=mapFamilyI.getMap("Product[]");
			break;
		}
	}//next i
	
	String sProducts[0];
	for (int i=0;i<mapArticles.length();i++)
	{ 
		Map mapArticleI=mapArticles.getMap(i);
		sProducts.append(mapArticleI.getMapName());
	}//next i
	
	sFamily.setReadOnly(true);
	sArticle=PropString(1,sProducts,sArticleName,0);
	sArticle.set(sProducts[0]);
	sArticle.setReadOnly(false);
	
	showDialog("---");
//		showDialog();
	
// select (multiple) beams to insert the post base
	Entity entPosts[0];
	PrEntity ssBeam(T("|Select Beam(s)|"), Beam());
	if (ssBeam.go())
		entPosts = ssBeam.set();

// select insert point	
	int nNoPoint = 0;
	Point3d ptSelect;	
	PrPoint ssPoint(T("|Select Point|") + " " + T("|or <Enter> to put post base on bottom end of the beam|"));
	if (ssPoint.go() == _kOk)
	{
		ptSelect = ssPoint.value();
	}

// if no point is selected, set flag "noPoint" --> lowest point in _ZW is selected		
	else
	{	
		nNoPoint = 1;
	}
		
// declare TSL props
	TslInst tslNew;
	Vector3d vUcsX = _XW;
	Vector3d vUcsY = _YW;
	GenBeam gbAr[1];
	Entity entAr[0];
	Point3d ptAr[1];
	int nArProps[0];
	double dArProps[] = {dMillDepth};
	String sArProps[] = {sFamily, sArticle, sMill, sCoverHull };
	Map mapTsl;
	
// if no point is selected, accept only vertical beams
	if (nNoPoint == 1)
	{
		int n=0;
		for (int i=entPosts.length()-1; i>=0; i--)
		{
			Beam bmInsert = (Beam)entPosts[i];
			if (!bmInsert.vecX().isParallelTo(_ZW))
			{
				entPosts.removeAt(i);
				n++;
			}
		}	
		if (n>0) reportMessage("\n" + T("|Only vertical beams possible|") + " --> " + n + " " + T("|Beams filtered out|"));
	}

// if point is selected, exclude only horizontal beams 
	int n=0;
	for (int i=entPosts.length()-1; i>=0; i--)
	{
		Beam bmInsert = (Beam)entPosts[i];
		if (bmInsert.vecX().isPerpendicularTo(_ZW))
		{
			entPosts.removeAt(i);
			n++;
		}
	}	
	if (n>0) reportMessage("\n" + T("|Horizontal beams not possible|") + " --> " + n + " " + T("|Beams filtered out|"));
		
// loop over all selected beams
	for (int i=0; i<entPosts.length(); i++)
	{
		gbAr[0] = (Beam)entPosts[i];
		Point3d ptInsert;
		
		if (nNoPoint == 0)
			ptInsert = (gbAr[0].ptCen() - gbAr[0].vecX() * (gbAr[0].vecX().dotProduct(gbAr[0].ptCen()-ptSelect)));
		
		else
		{
			ptInsert = (gbAr[0].ptCen() - _ZW * 0.5 * gbAr[0].dL());
		}
		
		ptAr[0] = ptInsert;
		
		
	// create new instance	
		tslNew.dbCreate(scriptName(), vUcsX, vUcsY, gbAr, entAr, ptAr, nArProps, dArProps, sArProps, _kModelSpace, mapTsl); // create new instance on each beam
	}
		
} // end on insert

	
	String sArticles[0];
	Map mapArticles;
	for (int i=0;i<mapFamilies.length();i++) 
	{ 
		Map mapFamilyI=mapFamilies.getMap(i);
		if(mapFamilyI.getMapName()==sFamily)
		{ 
			mapArticles=mapFamilyI.getMap("Product[]");
			break;
		}
	}//next i
	for (int i=0;i<mapArticles.length();i++) 
	{ 
		Map mapArticleI=mapArticles.getMap(i);
		sArticles.append(mapArticleI.getMapName());
	}//next i
	
	int indexArticle = sArticles.find(sArticle);
	if(indexArticle>-1)
	{ 
		sArticle=PropString(1,sArticles,sArticleName,indexArticle);
	}
	else
	{ 
		sArticle=PropString(1,sArticles,sArticleName,0);
		sArticle.set(sArticles[0]);
	}
	
// get properties depending from from selected article
	int nArticle = sArticles.find(sArticle);

//	double dRangeMin = dRangeMins[nArticle];
//	double dRangeMax = dRangeMaxs[nArticle];
//	double dThreadDia = dThreadDias[nArticle];
//	double dLowerThreadLength = dLowerThreadLengths[nArticle];
//	double dScrewNutLength = dScrewNutLengths[nArticle];
//	double dTopPlateDia = dTopPlateDias[nArticle];
//	double dTopPlateThick = dTopPlateThicks[nArticle];
//	double dTopLength = dTopLengths[nArticle];
//	double dBottomPlateLength = dBottomPlateLengths[nArticle];
//	double dBottomPlateWidth = dBottomPlateWidths[nArticle];
//	double dBottomPlateThick = dBottomPlateThicks[nArticle];
//	int nSquaredTop = nSquaredTops[nArticle];	
//	String sCoverHullArticle = sCoverHullArticles[nArticle];	
	
	
	Map mapArticle;
	for (int i=0;i<mapArticles.length();i++) 
	{ 
		Map mapArticleI=mapArticles.getMap(i);
		if(mapArticleI.getMapName()==sArticle)
		{ 
			mapArticle=mapArticleI;
			break;
		}
	}//next i
	
	double dRangeMin=mapArticle.getDouble("RangeMin");
	double dRangeMax=mapArticle.getDouble("RangeMax");
	double dThreadDia=mapArticle.getDouble("ThreadDiam");
	double dLowerThreadLength=mapArticle.getDouble("LowerThreadLength");
	double dScrewNutLength=mapArticle.getDouble("ScrewNutLength");
	double dTopPlateDia=mapArticle.getDouble("TopPlateDiam");
	double dTopPlateThick=mapArticle.getDouble("TopPlateThick");
	double dTopLength=mapArticle.getDouble("TopLength");
	double dBottomPlateLength=mapArticle.getDouble("BottomPlateLength");
	double dBottomPlateWidth=mapArticle.getDouble("BottomPlateWidth");
	double dBottomPlateThick=mapArticle.getDouble("BottomPlateThick");
	int nSquaredTop=mapArticle.getInt("SquaredTop");
	String sCoverHullArticle=mapArticle.getString("CoverHullArticle");
	
	double dDrillDepth = dTopLength + U(5);
	
// some declarations
	Beam bm0 = _Beam0;
	
	Vector3d vecX =_X0;// _Pt0-bm0.ptCen();
	vecX.normalize();
	Vector3d vecY = _Y0; //bm0.vecY();
	if(vecY.length()<dEps)return
	Vector3d vecZ = _Z0; //vecX.crossProduct(vecY);
	if(vecZ.length()<dEps)return
	
	if(bDebug)	
	{
		vecX.vis(_Pt0, 1);
		vecY.vis(_Pt0, 3);
		vecZ.vis(_Pt0, 5);
	}
	
//	property height only appears on inserted instances
	String sHeightName = T("|Post base height|");
	PropDouble dHeight (nDoubleIndex++, (dRangeMin+dRangeMax)/2, sHeightName);
	dHeight.setCategory (sCatType);
	
	if (_bOnDbCreated)
		dHeight.set((dRangeMin+dRangeMax)/2);

// set post base height to possible values 
	if (dHeight < dRangeMin)
	{
		reportMessage("\n" + T("|Height|") + " " + dHeight + " " + T("|out of range|") + "  -->  " + T("|value corrected to|") + " " + dRangeMin);
		dHeight.set(dRangeMin);
	}
	if (dHeight > dRangeMax)
	{
		reportMessage("\n" + T("|Height|") + " " + dHeight + " " + T("|out of range|") + "  -->  " + T("|value corrected to|") + " " + dRangeMax);
		dHeight.set(dRangeMax);
	}
	
// trigger to override height of the post base
	String sTriggerResetHeight = T("|Set to standard height|");
	addRecalcTrigger(_kContext, sTriggerResetHeight);
	
	if (_bOnRecalc && _kExecuteKey==sTriggerResetHeight || _kNameLastChangedProp == sFamilyName || _kNameLastChangedProp == sArticleName)
	{
		dHeight.set((dRangeMin+dRangeMax)/2);
	}
	
// cut the beam
	Point3d ptCut = _Pt0 - vecX*dHeight;
	Point3d ptTopRef = ptCut;
	
	
	if (nMill == 1)
	{
		ptCut.transformBy(vecX*(dTopPlateThick + dMillDepth));
		if (nSquaredTop == 0)
		{
			Drill drTopPlate (ptCut, ptCut-vecX*(dTopPlateThick + dMillDepth), .5*dTopPlateDia + dDrillDiaOversize);
			bm0.addTool(drTopPlate);
		}
		else
		{
			BeamCut bcTopPlate (ptCut, vecX, vecY, vecZ, 2*(dTopPlateThick + dMillDepth), dTopPlateDia + dDrillDiaOversize, dTopPlateDia + dDrillDiaOversize, 0, 0, 0);
			bm0.addTool(bcTopPlate);
		}
		dDrillDepth = (dTopLength + dTopPlateThick + dMillDepth + U(5));
	}

	Cut ctPostBase (ptCut, vecX);
	bm0.addTool(ctPostBase, _kStretchOnToolChange);
	
// drill for top pipe of the post base
	double dDrillRad;
	if (nFamily == 0)
		dDrillRad = U(42.5)/2 + dDrillDiaOversize;
	
	else if (nFamily == 1)
		dDrillRad = U(43.5)/2 + dDrillDiaOversize;
		
	Drill drTop(ptCut, -vecX, dDrillDepth, dDrillRad);
	bm0.addTool(drTop);

// drill for welding
	if (nMill == 1)
	{
		Drill drWelding (ptCut, -vecX, (dTopPlateThick + dMillDepth) + U(7), dDrillRad+U(7));
		bm0.addTool(drWelding);	
	}
	
	else
	{		
		Drill drWelding (ptCut, -vecX, U(7), dDrillRad+U(7));
		bm0.addTool(drWelding);	
	}
	
// trigger to rotate the post base 90°
	String sTriggerRotate = T("|Rotate post base|");
	addRecalcTrigger(_kContext, sTriggerRotate);	

	int bRotate90 = _Map.getInt("Rotate");
	if (_bOnRecalc && (_kExecuteKey==sTriggerRotate || _kExecuteKey==sDoubleClick))
	{
		if(bRotate90)
			bRotate90=false;
		else
			bRotate90 =true; 
	}
	 
	if (bRotate90)
	{
		Vector3d vec = vecY;
		vecY=vecZ;
		vecZ=-vec; 
	}
	
// body to represent the post base
	PLine plQuader;
	plQuader.addVertex(_Pt0 + vecY*dBottomPlateLength*.5 + vecZ*dBottomPlateWidth*.5);
	plQuader.addVertex(_Pt0 + vecY*dBottomPlateLength*.5 - vecZ*dBottomPlateWidth*.5);
	plQuader.addVertex(_Pt0 - vecY*dBottomPlateLength*.5 - vecZ*dBottomPlateWidth*.5);
	plQuader.addVertex(_Pt0 - vecY*dBottomPlateLength*.5 + vecZ*dBottomPlateWidth*.5);
	plQuader.close();

	PLine plExtrude;
	Vector3d vecVertex = vecY;
	double dNut = U(36);
	if (dThreadDia == U(30))
		dNut = U(46);
	for (int i=0; i<6; i++)
	{
		plExtrude.addVertex(_Pt0 + vecVertex * (dNut/2)/cos(30));
		vecVertex = vecVertex.rotateBy(60, vecX);
	}
	plExtrude.close();

	Body bdTopPlate(ptTopRef, ptTopRef + vecX*dTopPlateThick, .5*dTopPlateDia);
	if (nSquaredTop)
		bdTopPlate = Body(ptTopRef, vecX, vecY, vecZ, dTopPlateThick, dTopPlateDia, dTopPlateDia, 1, 0, 0);
	Body bdTop(ptTopRef, ptTopRef - vecX*dTopLength, dDrillRad-dDrillDiaOversize);
	Body bdThreadRod(ptTopRef + vecX*dTopPlateThick, _Pt0, dThreadDia/2);
	Body bdBottomPlate(plQuader, -vecX*dBottomPlateThick);

	Body bdScrewNut1(plExtrude, U(30)*vecX, 0);
	bdScrewNut1.transformBy(vecX * (vecX.dotProduct(ptTopRef-_Pt0) + dTopPlateThick + U(15)));
	Body bdScrewNut2(plExtrude, dScrewNutLength*vecX, 0);
	bdScrewNut2.transformBy(-vecX * (dBottomPlateThick + dLowerThreadLength));


	Body bdPostBase = bdTopPlate + bdTop + bdThreadRod + bdBottomPlate + bdScrewNut1 + bdScrewNut2;
	
// cover body only if selected	
	if (nCoverHull == 1)
	{
		Body bdCoverHull (ptTopRef, _Pt0, U(23));
		bdPostBase = bdPostBase + bdCoverHull;
	}

// hardware

	if (_bOnDbCreated || _kNameLastChangedProp == sFamilyName || _kNameLastChangedProp == sArticleName || _kNameLastChangedProp == sCoverHullName)
	{
		HardWrComp hwComps[0];	
		
		String sArtNo = sFamilies[nFamily] + "." + sArticles[nArticle];
		
		String sModel;
		if (nFamily == 0)
			sModel = T("|Plane pipe|");
		else
			sModel = T("|Threaded pipe|");
			
		String sDescription = T("|Post base|") + " - " + T("|Adjustment range|") + " " + dRangeMin + " - " + dRangeMax + " mm";
			
		HardWrComp hw(sArtNo , 1);	
		hw.setCategory(T("|Post base|"));
		hw.setManufacturer("Pitzl");
		hw.setModel(sModel);
		hw.setMaterial(T("|Steel|"));
		hw.setDescription(sDescription);
		hw.setDScaleX(dBottomPlateLength);
		hw.setDScaleY(dBottomPlateWidth);
		hw.setDScaleZ(dHeight);	
		hwComps.append(hw);
		
		HardWrComp hwScrew(sScrewArticle, nScrewQuant);	
		hwScrew.setCategory(T("|Post base|"));
		hwScrew.setManufacturer("Pitzl");
		hwScrew.setModel(dScrewDia + " x " + dScrewLength);
		hwScrew.setMaterial(T("|Steel|"));		
		hwScrew.setDescription(sScrewName + " " + dScrewDia + " x " + dScrewLength);
		hwScrew.setDScaleX(dScrewLength);
		hwScrew.setDScaleY(dScrewDia);
		hwScrew.setDScaleZ(0);	
		hwComps.append(hwScrew);	
		
	// cover only if selected	
		if (nCoverHull == 1)
		{
			HardWrComp hwCover(sCoverHullArticle, 1);	
			hwCover.setCategory(T("|Post base|"));
			hwCover.setManufacturer("Pitzl");
			hwCover.setModel(T("|Cover hull|"));
			hwCover.setMaterial(T("|Steel|"));		
			hwCover.setDescription(T("|Cover hull|") + " (" + T("|for|") + " " + T("|Post base|") + " " + sArtNo + ")");
			hwCover.setDScaleX(0);
			hwCover.setDScaleY(0);
			hwCover.setDScaleZ(0);	
			hwComps.append(hwCover);
		}
	
		_ThisInst.setHardWrComps(hwComps);
	}

// display
	
	Display dp(9);
	dp.draw(bdPostBase);

// map some properties
	_Map.setInt("Rotate", bRotate90);

#End
#BeginThumbnail
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
EUE+H%W"-D&IR)'V&*WZ*`,2U\/"*\2ZFNY)9$.1FMNBB@#__V5KY
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
        <int nm="BreakPoint" vl="538" />
      </lst>
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16561: Fix bug at direction vectors" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="6" />
      <str nm="Date" vl="11/29/2022 12:51:52 PM" />
    </lst>
    <lst nm="Version">
      <str nm="Comment" vl="HSB-16561: Introduce xml structure; add 10920.1390 and 10920.1490" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="5" />
      <str nm="Date" vl="11/8/2022 11:44:11 AM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End