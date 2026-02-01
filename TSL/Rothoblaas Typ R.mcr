#Version 8
#BeginDescription
version value="1.4" date="17Apr2018" author="thorsten.huck@hsbcad.com"
translation issue fixed
insert mechanism with catalog entry improved 
assignment changed to Z layer (to make the TSL visible when plotting)

D >>> Dieses TSL erstellt einen Pfostenträger Rothoblaas Typ R an einem oder mehreren Stäben.

E >>> This TSL creates Rothoblaas post bases type R on one or multiple beams.

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
#MinorVersion 4
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This TSL creates Rothoblaas post bases type R on one or multiple beams.
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

/// <version value="1.4" date="17Apr2018" author="thorsten.huck@hsbcad.com"> translation issue fixed </version>
/// <version value="1.2" date="04oct17" author="thorsten.huck@hsbcad.com"> insert mechanism with catalog entry improved </version>
/// <version value="1.1" date="08aug17" author="florian.wuermseer@hsbcad.com"> assignment changed to Z layer (to make the TSL visible when plotting)</version>
/// <version value="1.0" date="06sep16" author="florian.wuermseer@hsbcad.com"> initial version</version>

// constants
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=projectSpecial().find("debugTsl",0)>-1;
	
		
	
// post base's properties collection
	// Typ R
	String sSizesR10[] = {"1", "2", "3"};
	String sSizesR20[] = {"1", "2", "3"};
	String sSizesR30[] = {"1", "2"};
	String sSizesR40[] = {"1", "2", "3", "4"};
	
	String sArticleAlls[] = {"R10_1", "R10_2", "R10_3", "R20_1", "R20_2", "R20_3", "R30_1", "R30_2", "R40_1", "R40_2", "R40_3", "R40_4"};
	String sArticleNumbers[] = {"FE500450", "FE500455", "FE500460", "FE500485", "FE500490", "FE500495", "FE501700", "FE501705", "FE500265", "FE500270", "FE500280", "FE500285"};
	double dRangeMins[] = {U(130), U(160), U(190), U(130), U(160), U(190), U(135), U(165), U(40), U(40), U(40), U(40)};
	double dRangeMaxs[] = {U(165), U(205), U(250), U(165), U(205), U(250), U(170), U(210), U(105), U(105), U(156), U(256)};
	double dThreadDias[] = {U(16), U(20), U(24), U(16), U(20), U(24), U(16), U(20), U(16), U(20), U(20), U(24)};
	
	double dLowerTubeDias[] = {U(36), U(46), U(55), U(36), U(46), U(55), U(36), U(46), U(16), U(20), U(20), U(24)};
	double dLowerTubeLengths[] = {U(90), U(110), U(130), U(90), U(110), U(130), U(90), U(110), U(99), U(99), U(150), U(250)};
	double dUpperTubeDias[] = {U(46), U(57), U(68), U(46), U(57), U(68), U(46), U(57), U(16), U(20), U(20), U(24)};
	double dTopPlateDias[] = {U(80), U(100), U(140), U(80), U(100), U(140), U(80), U(120), U(70), U(80), U(100), U(100)};
	double dTopPlateThicks[] = {U(6), U(6), U(8), U(6), U(6), U(8), U(6), U(10), U(6), U(6), U(6), U(6)};
	double dTopLengths[] = {U(0), U(0), U(0), U(85), U(125), U(155), U(150), U(200), U(0), U(0), U(0), U(0)};
	double dBottomPlateLengths[] = {U(120), U(160), U(200), U(120), U(160), U(200), U(120), U(160), U(100), U(100), U(160), U(160)};
	double dBottomPlateWidths[] = {U(120), U(160), U(200), U(120), U(160), U(200), U(120), U(160), U(100), U(100), U(100), U(100)};
	double dBottomPlateThicks[] = {U(6), U(6), U(8), U(6), U(6), U(8), U(6), U(6), U(6), U(6), U(6), U(6)};
	
// required screws (top plate)
	int nScrewQuantTops[] = {4, 4, 4, 4, 4, 4, 8, 16, 2, 4, 4, 4};
	int nScrewQuantBottoms[] = {4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4};
	String sScrewArticleTops[] = {"HBS+ evo", "HBS+ evo", "HBS+ evo", "HBS+ evo", "HBS+ evo", "HBS+ evo", T("|Screw|") + " DISC", T("|Screw|") + " DISC", "HBS+ evo", "HBS+ evo", "HBS+ evo", "HBS+ evo"};
	String sScrewNameTops[] = {T("|Wood construction screw|"), T("|Screw for Type R30|")};
	double dScrewDiaTops[] = {U(6), U(8), U(8), U(6), U(8), U(8), U(6), U(6), U(6), U(8), U(8), U(8)};
	double dScrewLengthTops[] = {U(90), U(80), U(80), U(90), U(80), U(80), U(60), U(80), U(90), U(80), U(80), U(80)};

// required screws (mounting on ground)	
	String sScrewArticleBottoms[] = {"AB1", "SKR", "VINYLPRO", "EPOPLUS"};
	String sScrewNameBottoms[] = {T("|Expansion anchor|"), T("|Screw anchor|"), T("|Chemical dowel|") + " VINYLPRO", T("|Chemical dowel|") + " EPOPLUS"};
	double dScrewDiaBottoms[] = {U(10), U(10), U(10), U(10)};


// properties category
	String sCatType = T("|Category|");
	
	String sFamilyName = "A - " + T("|Type|");
	String sFamilies[] = {"R10", "R20", "R30", "R40"};
	PropString sFamily (nStringIndex++, sFamilies, sFamilyName);
	sFamily.setCategory(sCatType);
	sFamily.setDescription(T("|Type|") + ":\n" + " R10 = " + T("|Flat top plate|")
											+ "\n" + " R20 = " + T("|Top plate with threaded rod|")
											+ "\n" + " R30 = " + T("|Disc type top plate with threaded rod|")
											+ "\n" + " R40 = " + T("|uncovered, passing through threaded rod|"));
	int nFamily = sFamilies.find(sFamily);


// on insert
// get execute key to preset family or model
	String sKeys[] = _kExecuteKey.tokenize("?");
	String sEntry;
	if (_bOnInsert)
	{
		if (insertCycleCount() > 1) { eraseInstance(); return; }
		int nFamily =sKeys.length()>0?sFamilies.find(sKeys[0].makeUpper()):- 1;
		if (nFamily>-1)
			sFamily.set(sFamilies[nFamily]);
		else
		{
			showDialog();
		}
		sEntry = sKeys.length() > 1 ? sKeys[1] : (nFamily == -1 ? "" : sKeys[0]);
	}






	String sSizes[0];
	String sDescription;
	if (nFamily == 0)
	{
		sSizes = sSizesR10;
		sDescription = "R10 " + T("|Size|") + ":\n" + " 1 = 130 - 165mm" + 
													"\n" + " 2 = 160 - 205mm" + 
													"\n" + " 3 = 190 - 250mm";
	}
	else if (nFamily == 1)
	{
		sSizes = sSizesR20;
		sDescription = "R20 " + T("|Size|") + ":\n" + " 1 = 130 - 165mm" + 
													"\n" + " 2 = 160 - 205mm" + 
													"\n" + " 3 = 190 - 250mm";
	}
	else if (nFamily == 2)
	{
		sSizes = sSizesR30;
		sDescription = "R30 " + T("|Size|") + ":\n" + " 1 = 135 - 170mm" + 
													"\n" + " 2 = 165 - 210mm";
	}	
	else if (nFamily == 3)
	{
		sSizes = sSizesR40;
		sDescription = "R40 " + T("|Size|") + ":\n" + " 1 = 40 - 105mm   quadratische Grundplatte" + 
													"\n" + " 2 = 40 - 105mm   quadratische Grundplatte" + 
													"\n" + " 3 = 40 - 156mm   rechteckige Grundplatte" + 
													"\n" + " 4 = 40 - 156mm   rechteckige Grundplatte";
	}	




	
// bOn Insert ________________________________________________________________________________________________________________________________________________________________
if (_bOnInsert)
{
	if (insertCycleCount() > 1) {eraseInstance(); return;}
	
//	// silent/dialog
//		String sKey = _kExecuteKey;
//		sKey.makeUpper();
//
//		if (sKey.length()>0)
//		{
//			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
//			for(int i=0;i<sEntries.length();i++)
//				sEntries[i] = sEntries[i].makeUpper();	
//			if (sEntries.find(sKey)>-1)
//				setPropValuesFromCatalog(sKey);
//		}		
//		showDialog();
	
	int nFamily = sFamilies.find(sFamily);	
	sFamily.setReadOnly(TRUE);
	
	// set OPM name 
	setOPMKey(sFamily);	

// flag if dialog needs to be shown
	int bShowDialog = TslInst().getListOfCatalogNames(scriptName()).find(sEntry)<0;		



	
	
	
	if (nFamily == 0)
	{
		sSizes = sSizesR10;
		sDescription = "R10 " + T("|Size|") + ":\n" + " 1 = 130 - 165mm" + 
													"\n" + " 2 = 160 - 205mm" + 
													"\n" + " 3 = 190 - 250mm";
	}
	else if (nFamily == 1)
	{
		sSizes = sSizesR20;
		sDescription = "R20 " + T("|Size|") + ":\n" + " 1 = 130 - 165mm" + 
													"\n" + " 2 = 160 - 205mm" + 
													"\n" + " 3 = 190 - 250mm";
	}
	else if (nFamily == 2)
	{
		sSizes = sSizesR30;
		sDescription = "R30 " + T("|Size|") + ":\n" + " 1 = 135 - 170mm" + 
													"\n" + " 2 = 165 - 210mm";	
	}
	else if (nFamily == 3)
	{
		sSizes = sSizesR40;
		sDescription = "R40 " + T("|Size|") + ":\n" + " 1 = 40 - 105mm   quadratische Grundplatte" + 
													"\n" + " 2 = 40 - 105mm   quadratische Grundplatte" + 
													"\n" + " 3 = 40 - 156mm   rechteckige Grundplatte" + 
													"\n" + " 4 = 40 - 156mm   rechteckige Grundplatte";
	}	
		
	String sSizeName = "B - " + T("|Size|");
	PropString sSize (nStringIndex++, sSizes, sSizeName);
	sSize.setCategory (sCatType);
	sSize.setDescription(sDescription);
	
	String sArticle = sFamily + "_" + sSize;

// properties tooling	
	String sCatTool = T("|Tooling|");
	
	String sMillName = "D - " + T("|Milled|");
	String sMills[] = {T("|No|"), T("|Yes|")};
	PropString sMill (nStringIndex++, sMills, sMillName);
	sMill.setCategory (sCatTool);
	
	int nMill = sMills.find(sMill);
	
	String sMillDepthName = "E - " + T("|Additional mill depth|");
	PropDouble dMillDepth (nDoubleIndex++, U(0), sMillDepthName);
	dMillDepth.setCategory (sCatTool);	
	
	String sMillOversizeName = "F - " + T("|Oversize milling|");
	PropDouble dMillOversize (nDoubleIndex++, U(2), sMillOversizeName);
	dMillOversize.setCategory (sCatTool);	
	
	String sDrillDiaOversizeName = "G - " + T("|Oversize drill|");
	PropDouble dDrillDiaOversize (nDoubleIndex++, U(2), sDrillDiaOversizeName);
	dDrillDiaOversize.setCategory (sCatTool);	

	
// properties mounting
	String sCatMounting = T("|Mounting|");
	
	String sMountings[] = {T("|Expansion anchor|"), T("|Screw anchor|"), T("|Chemical dowel|")};
	String sMountingName = "H - " + T("|Anchoring to the ground|");
	PropString sMounting (nStringIndex++, sMountings, sMountingName);
	sMounting.setCategory (sCatMounting);	
	int nMounting = sMountings.find(sMounting);

	if (bShowDialog)
	{
		sFamily.setReadOnly(true);
		showDialog();
	}
	else
	{
		setPropValuesFromCatalog(sEntry);
	}

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
	double dArProps[] = {dMillDepth, dMillOversize, dDrillDiaOversize};
	String sArProps[] = {sFamily, sSize, sMill, sMounting};
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
	
	eraseInstance();
	return;
} // end on insert _________________________________________________________________________________________________________________________________________________________________________


	String sSizeName = "B - " + T("|Size|");
	PropString sSize (nStringIndex++, sSizes, sSizeName);
	sSize.setCategory (sCatType);
	sSize.setDescription(sDescription);
	
	if (sSizes.find(sSize) < 0)
		sSize.set(sSizes[sSizes.length()-1]);
	
	String sArticle = sFamily + "_" + sSize;

// properties tooling	
	String sCatTool = T("|Tooling|");
	
	String sMillName = "D - " + T("|Milled|");
	String sMills[] = {T("|No|"), T("|Yes|")};
	PropString sMill (nStringIndex++, sMills, sMillName);
	sMill.setCategory (sCatTool);
	
	int nMill = sMills.find(sMill);
	
	String sMillDepthName = "E - " + T("|Additional mill depth|");
	PropDouble dMillDepth (nDoubleIndex++, U(0), sMillDepthName);
	dMillDepth.setCategory (sCatTool);	
	
	String sMillOversizeName = "F - " + T("|Oversize milling|");
	PropDouble dMillOversize (nDoubleIndex++, U(2), sMillOversizeName);
	dMillOversize.setCategory (sCatTool);
	
	String sDrillDiaOversizeName = "G - " + T("|Oversize drill|");
	PropDouble dDrillDiaOversize (nDoubleIndex++, U(2), sDrillDiaOversizeName);
	dDrillDiaOversize.setCategory (sCatTool);	

	
// properties mounting
	String sCatMounting = T("|Mounting|");
	
	String sMountings[] = {T("|Expansion anchor|"), T("|Screw anchor|"), T("|Chemical dowel|")};
	String sMountingName = "H - " + T("|Anchoring to the ground|");
	PropString sMounting (nStringIndex++, sMountings, sMountingName);
	sMounting.setCategory (sCatMounting);	
	int nMounting = sMountings.find(sMounting);


// get properties depending from from selected mounting method	
	String sScrewArticleBottom = sScrewArticleBottoms[nMounting];
	String sScrewNameBottom = sScrewNameBottoms[nMounting];
	double dScrewDiaBottom = dScrewDiaBottoms[nMounting];
	String sScrewLengthBottom = T("|Length depending on static requirements|");

// get properties depending from from selected article
	int nArticle = sArticleAlls.find(sArticle);
	
	String sArticleNumber = sArticleNumbers[nArticle];
	double dRangeMin = dRangeMins[nArticle];
	double dRangeMax = dRangeMaxs[nArticle];
	double dThreadDia = dThreadDias[nArticle];
	double dLowerTubeDia = dLowerTubeDias[nArticle];
	double dLowerTubeLength = dLowerTubeLengths[nArticle];
	double dUpperTubeDia = dUpperTubeDias[nArticle];
	double dUpperTubeLength = dLowerTubeLength - U(10);
	double dTopPlateDia = dTopPlateDias[nArticle];
	double dTopPlateThick = dTopPlateThicks[nArticle];
	double dTopLength = dTopLengths[nArticle];
	double dBottomPlateLength = dBottomPlateLengths[nArticle];
	double dBottomPlateWidth = dBottomPlateWidths[nArticle];
	double dBottomPlateThick = dBottomPlateThicks[nArticle];
		
	int nScrewQuantTop = nScrewQuantTops[nArticle];
	String sScrewArticleTop = sScrewArticleTops[nArticle];
	double dScrewDiaTop = dScrewDiaTops[nArticle];
	double dScrewLengthTop = dScrewLengthTops[nArticle];
	
	String sScrewNameTop = sScrewNameTops[0];
	if (nFamily == 2) 
		sScrewNameTop = sScrewNameTops[1];
	
	int nScrewQuantBottom = nScrewQuantBottoms[nArticle];

// some declarations ________________________________________________________________________________________________________________________________________________________________
	Beam bm0 = _Beam0;
	assignToGroups(bm0, 'Z');
	
	Vector3d vecX =_X0;// _Pt0-bm0.ptCen();
	vecX.normalize();
	Vector3d vecY = _Y0; //bm0.vecY();
	Vector3d vecZ = _Z0; //vecX.crossProduct(vecY);

	if(bDebug)	
	{
		vecX.vis(_Pt0, 1);
		vecY.vis(_Pt0, 3);
		vecZ.vis(_Pt0, 5);
	}
	
	
//	property height only appears on inserted instances
	String sHeightName = "C - " + T("|Post base height|");
	PropDouble dHeight (nDoubleIndex++, (dRangeMin+dRangeMax)/2, sHeightName);
	dHeight.setCategory (sCatType);
	
// trigger to reset height of the post base
	String sTriggerResetHeight = T("|Set to standard height|");
	addRecalcTrigger(_kContext, sTriggerResetHeight);
	
	if (_bOnDbCreated || (_bOnRecalc && _kExecuteKey==sTriggerResetHeight))// || _kNameLastChangedProp == sFamilyName || _kNameLastChangedProp == sSizeName)
	{
		dHeight.set((dRangeMin+dRangeMax)/2);
	}
	
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



// tools ________________________________________________________________________________________________________________________________________________________________
	Point3d ptCut = _Pt0 - vecX*dHeight;
	Point3d ptTopRef = ptCut;
	double dExtraDrillDepth = U(5);
	double dDrillRad = .5*(dThreadDia + dDrillDiaOversize);
	
	if (nFamily == 3)
	{
		dTopLength = dRangeMax - dHeight;
		dExtraDrillDepth = U(50);
	}
	
	double dDrillDepth = dTopLength + dExtraDrillDepth;
	
// mill top plate into beam head	
	if (nMill == 1)
	{
		ptCut.transformBy(vecX*(dTopPlateThick + dMillDepth));
		dDrillDepth = (dDrillDepth + dTopPlateThick + dMillDepth);
		
		if (nFamily == 2)
		{
			Drill drTopPlate (ptCut, ptCut-vecX*(dTopPlateThick + dMillDepth), .5*(dTopPlateDia + dMillOversize));
			bm0.addTool(drTopPlate);
		}
		else
		{
			BeamCut bcTopPlate (ptCut, -vecX, -vecY, vecZ, dTopPlateThick + dMillDepth, dTopPlateDia + dMillOversize, dTopPlateDia + dMillOversize, 1,0,0);
			bm0.addTool(bcTopPlate );
		}
	}

// cut the beam
	Cut ctPostBase (ptCut, vecX);
	bm0.addTool(ctPostBase, _kStretchOnToolChange);
	
// drill for top rod of the post base
	Drill drTop(ptCut, -vecX, dDrillDepth, dDrillRad);
	if (nFamily != 0)
		bm0.addTool(drTop);


	
	
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
	Body bdPostBase;
	Body bdBottomPlate;
	Body bdTopPlate;
	Body bdHexagon;
	Body bdLowerTube;
	Body bdBase;
	Body bdUpperTube;
	Body bdTopRod;
	
	
// bottom plate
	PLine plBottomPlate;
	plBottomPlate.addVertex(_Pt0 + vecY*dBottomPlateLength*.5 + vecZ*dBottomPlateWidth*.5);
	plBottomPlate.addVertex(_Pt0 + vecY*dBottomPlateLength*.5 - vecZ*dBottomPlateWidth*.5);
	plBottomPlate.addVertex(_Pt0 - vecY*dBottomPlateLength*.5 - vecZ*dBottomPlateWidth*.5);
	plBottomPlate.addVertex(_Pt0 - vecY*dBottomPlateLength*.5 + vecZ*dBottomPlateWidth*.5);
	plBottomPlate.close();
	
	bdBottomPlate = Body (plBottomPlate, -vecX*dBottomPlateThick);
	
// top plate	
	PLine plTopPlate;
	plTopPlate.addVertex(ptTopRef + vecY*dTopPlateDia*.5 + vecZ*dTopPlateDia*.5);
	plTopPlate.addVertex(ptTopRef + vecY*dTopPlateDia*.5 - vecZ*dTopPlateDia*.5);
	plTopPlate.addVertex(ptTopRef - vecY*dTopPlateDia*.5 - vecZ*dTopPlateDia*.5);
	plTopPlate.addVertex(ptTopRef - vecY*dTopPlateDia*.5 + vecZ*dTopPlateDia*.5);
	plTopPlate.close();

	bdTopPlate = Body(plTopPlate, +vecX*dTopPlateThick);
	if (nFamily == 2)
		bdTopPlate = Body(ptTopRef, ptTopRef + vecX*dTopPlateThick, .5*dTopPlateDia);
	
// top rod
if (nFamily == 3) // in this case, the rod passes through, completely from the bottom to the top
	bdTopRod = Body(_Pt0, _Pt0 - vecX*dRangeMax, dThreadDia/2);
	
	
if (nFamily != 3)
	{
	// hexagon nut
		PLine plExtrude;
		Vector3d vecVertex = vecY;
		for (int i=0; i<6; i++)
		{
			plExtrude.addVertex(_Pt0 - vecX*(dBottomPlateThick + U(10)) + vecVertex * .5*dLowerTubeDia/cos(30));
			vecVertex = vecVertex.rotateBy(60, vecX);
		}
		plExtrude.close();
		bdHexagon = Body(plExtrude, -vecX*U(6));

	// lower tube
		bdLowerTube = Body(_Pt0, _Pt0 - vecX*dLowerTubeLength, dLowerTubeDia/2);
		bdBase = Body(_Pt0, _Pt0 - vecX*(dBottomPlateThick + U(10)), dUpperTubeDia/2 + U(20), dUpperTubeDia/2);
	
	// upper tube
		bdUpperTube = Body(ptTopRef, ptTopRef + vecX*dUpperTubeLength, dUpperTubeDia/2);
		
	// top rod
		bdTopRod = Body(ptTopRef, ptTopRef - vecX*dTopLength, dThreadDia/2);
	}


// join all parts to one body	
	bdPostBase = bdBottomPlate + bdBase + bdHexagon + bdLowerTube + bdTopPlate + bdUpperTube + bdTopRod;
	
	
	
// hardware

	if (_bOnDbCreated || _kNameLastChangedProp == sFamilyName || _kNameLastChangedProp == sSizeName || _kNameLastChangedProp == sMountingName)
	{
		HardWrComp hwComps[0];	
		
		String sModel;
		if (nFamily == 0)
			sModel = sFamilies[nFamily] + " (" + T("|Flat top plate|") +")";
		else if (nFamily == 1)
			sModel = sFamilies[nFamily] + " (" + T("|Top plate with threaded rod|") +")";
		else
			sModel = sFamilies[nFamily] + " (" + T("|Disc type top plate with threaded rod|") +")";
			
		String sDescription = T("|Post base|") + " - " + T("|Adjustment range|") + " " + dRangeMin + " - " + dRangeMax + " mm";
		
	// post base itself	
		HardWrComp hw(sArticleNumber , 1);	
		hw.setCategory(T("|Post base|"));
		hw.setManufacturer("Rothoblaas");
		hw.setModel(sModel);
		hw.setMaterial(T("|Steel|"));
		hw.setDescription(sDescription);
		hw.setDScaleX(dBottomPlateLength);
		hw.setDScaleY(dBottomPlateWidth);
		hw.setDScaleZ(dHeight);	
		hwComps.append(hw);
	
	// screws top		
		HardWrComp hwScrewTop(sScrewArticleTop, nScrewQuantTop);	
		hwScrewTop.setCategory(T("|Post base|"));
		hwScrewTop.setManufacturer("Rothoblaas");
		hwScrewTop.setModel(dScrewDiaTop + " x " + dScrewLengthTop);
		hwScrewTop.setMaterial(T("|Steel|"));		
		hwScrewTop.setDescription(sScrewNameTop + " " + dScrewDiaTop + " x " + dScrewLengthTop);
		hwScrewTop.setDScaleX(dScrewLengthTop);
		hwScrewTop.setDScaleY(dScrewDiaTop);
		hwScrewTop.setDScaleZ(0);	
		hwComps.append(hwScrewTop);
		
	// screws bottom		
		HardWrComp hwScrewBottom(sScrewArticleBottom, nScrewQuantBottom);	
		hwScrewBottom.setCategory(T("|Post base|"));
		hwScrewBottom.setManufacturer("Rothoblaas");
		hwScrewBottom.setModel("M" + dScrewDiaBottom);
		hwScrewBottom.setMaterial(T("|Steel|"));		
		hwScrewBottom.setDescription(sScrewNameBottom + " M" + dScrewDiaBottom + " (" + sScrewLengthBottom + ")");
		hwScrewBottom.setDScaleX(0);
		hwScrewBottom.setDScaleY(dScrewDiaBottom);
		hwScrewBottom.setDScaleZ(0);	
		hwComps.append(hwScrewBottom);	
		

		_ThisInst.setHardWrComps(hwComps);
	}

// display
	_ThisInst.setHyperlink("http://www.rothoblaas.com/products/fastening/brackets-and-plates/pillar-bases/typ-r10-r20");
	Display dp(9);
	dp.draw(bdPostBase);

// map some properties
	_Map.setInt("Rotate", bRotate90);

#End
#BeginThumbnail
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
GS[5D_P#"-B-CY%[-&I/W16]10!B1^&X1,LDUS+*5.1FMNBB@#__9
`



#End
#BeginMapX

#End