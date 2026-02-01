#Version 8
#BeginDescription
version value="2.0" date="04nov20" author="marsel.nakuci@hsbcad.com" 

HSB-9123: update the TSL with the corresponding changes from Rothoblaas
assignment changed to Z layer (to make the TSL visible when plotting)


D >>> Dieses TSL erstellt einen Pfostenträger Rothoblaas Typ X an einem oder mehreren Stäben.

E >>> This TSL creates Rothoblaas post bases type X on one or multiple beams.

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
#MajorVersion 2
#MinorVersion 0
#KeyWords Rothoblaas,X10
#BeginContents
/// <summary Lang=en>
/// This TSL creates Rothoblaas post bases type X on one or multiple beams.
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

/// <version value="2.0" date="04nov20" author="marsel.nakuci@hsbcad.com"> HSB-9123: update the TSL with the corresponding changes from Rothoblaas </version>
/// <version value="1.1" date="08aug17" author="florian.wuermseer@hsbcad.com"> assignment changed to Z layer (to make the TSL visible when plotting)</version>
/// <version value="1.0" date="07sep16" author="florian.wuermseer@hsbcad.com"> initial version</version>

// constants
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=1;//projectSpecial().find("debugTsl",0)>-1;
	
// post base's properties collection
// mounting method to the post determines post base type and hardware quants
	///////////
	String sCodes[] ={ "XS10120", "XS10120", "XS10160", "XS10160", "XR10120", "XR10120 diagonal"};
	double dBottomPlateLengths[] ={ U(220), U(220), U(260), U(260), U(220), U(220)};
	double dBottomPlateWidths[] ={ U(220), U(220), U(260), U(260), U(220), U(220)};
	double dBottomPlateThicks[] ={ U(10), U(10), U(12), U(12), U(10), U(10)};
	// total height
	double dTopHeights[] ={ U(310), U(310), U(312), U(312), U(310), U(310)};
	// knife plate thickness
	double dTopWidths[] ={ U(120), U(120), U(160), U(160), U(120), U(120)};
	double dTopThicks[] ={ U(6), U(6), U(8), U(8), U(6), U(6) };
	// bottom holes at bottom plates
	double dHolesLower[] ={ U(13), U(13), U(17), U(17), U(13), U(13)};
	// configurations
	String sConfigs[] ={ "S1-SBD", "S1-STA", "S2-SBD", "S2-STA", "R1", "R2"};
	// fasteners for all configurations
	String sFasteners0[] ={ "16-Ø7.5x115", "16-Ø7.5x135"};
	String sFasteners1[] ={ "8-Ø12x120"};
	String sFasteners2[] ={ "16-Ø7.5x135", "16-Ø7.5x155"};
	String sFasteners3[] ={ "12-Ø12x160"};
	String sFasteners4[] ={ "XEPOX adhesive"};
	String sFasteners5[] ={ "XEPOX adhesive"};
	// top fasteners
	// diameters
	double dPegDias0[] = { U(7.5), U(7.5)};
	double dPegDias1[] = { U(12)};
	double dPegDias2[] = { U(7.5), U(7.5)};
	double dPegDias3[] = { U(12)};
	double dPegDias4[] = { U(0)};
	double dPegDias5[] = { U(0)};
	// lengths
	double dPegLengths0[] ={ U(115), U(135)};
	double dPegLengths1[] ={ U(120)};
	double dPegLengths2[] ={ U(135), U(155)};
	double dPegLengths3[] ={ U(160)};
	double dPegLengths4[] ={ U(0)};
	double dPegLengths5[] ={ U(0)};
	// height of extra plate
	double dHeights[] ={ U(46), U(46), U(50), U(50), U(46), U(46)};
	////////////
	String sArticlePostBases[] = {"XS10", "XS10", "XS10", "XS10", "XR10", "XR10"};
	String sArticleNumberPostBases[] = { "TYPXS101212", "TYPXS101212", "TYPXS101212", "TYPXS101212", "TYPXR101212", "TYPXR101212"};
	double dHeight = U(46);

	double dBottomPlateLength = U(220);
	double dBottomPlateWidth = U(220);
	double dBottomPlateThick = U(10);
	
	double dTopHeight = U(300);
	double dTopWidth = U(120);
	
	double dTopThick = U(6);
	double dExtraPlateHeight = U(40);
	double dExtraPlateThick = U(6);
	
// required hardware (mounting to post)	
	String sPegArticles[] = {"WS", "WS", "WS", "STA", "XEPOX", "XEPOX"};
	String sPegNames[] = {T("|Self drilling peg|"), T("|Self drilling peg|"), T("|Self drilling peg|"), T("|Peg|"), T("|Epoxy resin|"), T("|Epoxy resin|")};
	int nPegQuants[] = {16, 16, 20, 8, 1, 1};
	double dPegDias[] = { U(7), U(7), U(7), U(12), U(0), U(0)};
	double dPegLengths[] = {U(113), U(113), U(113), U(120), U(0), U(0)};
//	double dDrillSideOffsets[] = {U(40), U(40), U(30), U(44), U(0), U(0)};
	double dDrillSideOffsets[] = {U(40), U(44), U(50), U(52), U(0), U(0)};
//	double dDrillOffsetYZs[] = {U(20), U(20), U(20), U(36), U(0), U(0)};
	double dDrillOffsetYZs[] = {U(20), U(36), U(20), U(28), U(0), U(0)};
	
// required hardware (mounting on ground)	
	String sScrewArticleBottoms[] = {"AB1", "SKR", "VINYLPRO", "EPOPLUS"};
	String sScrewNameBottoms[] = {T("|Expansion anchor|"), T("|Screw anchor|"), T("|Chemical dowel|") + " VINYLPRO", T("|Chemical dowel|") + " EPOPLUS"};
	double dScrewDiaBottoms[] = {U(12), U(12), U(12), U(12)};
	int nScrewQuantBottom = 4;
	
// properties category
	String sCatMount = T("|Mounting|");
	
//	String sMountingMethods[] = {T("|S1 - Self drilling pegs - Pattern 1|"), T("|S2 - Self drilling pegs - Pattern 2|"), T("|S3 - Self drilling pegs - Pattern 3|"), T("|S4 - Plain pegs|"), T("|R1 - Epoxy resin|"), T("|R2 - Epoxy resin diagonal|")};
	String sMountingMethods[0]; sMountingMethods.append(sConfigs);
	
	String sTypeName = "A - " + T("|Mounting method|");
	PropString sType (nStringIndex++, sMountingMethods, sTypeName);
	sType.setCategory(sCatMount);
	int nType = sMountingMethods.find(sType);
	
// properties anchoring to ground
	String sAnchorings[] = {T("|Expansion anchor|"), T("|Screw anchor|"), T("|Chemical dowel|")};
	String sAnchoringName = "B - " + T("|Anchoring to the ground|");
	PropString sAnchoring(nStringIndex++, sAnchorings, sAnchoringName);
	sAnchoring.setCategory (sCatMount);	
	int nAnchoring = sAnchorings.find(sAnchoring);
	
// properties tooling	
	String sCatTool = T("|Tooling|");
	
	String sSlotWidthName = "C - " + T("|Slot width|");
	double dSlotWidths[] = { U(10), U(12)};
	PropDouble dSlotWidth (nDoubleIndex++, dSlotWidths, sSlotWidthName);
	dSlotWidth.setDescription(T("|Slot width|") + " " + T("|only for mounting with epoxy resin|"));
	dSlotWidth.setCategory (sCatTool);
	
// fasteners for timber
//	String sCatFastener = T("|Fastener|");
//	String sFasteners[0];
//	String sFastenerName = "D - " + T("|Fastener|");
//	PropString sFastener(nStringIndex++, sFasteners, sFastenerName);	
//	sFastener.setDescription(T("|Defines the Fastener|"));
//	sFastener.setCategory(sCatFastener);
	
// get values, depending on selected mounting type
	int nArticle = sMountingMethods.find(sType);
	
	String sArticlePostBase = sArticlePostBases[nArticle];
	String sArticleNumberPostBase = sArticleNumberPostBases[nArticle];
	
	String sPegArticle = sPegArticles[nArticle];
	String sPegName = sPegNames[nArticle];
	int nPegQuant = nPegQuants[nArticle];
	double dPegDia = dPegDias[nType];
	double dPegLength = dPegLengths[nType];
	double dDrillSideOffset = dDrillSideOffsets[nType];
	double dDrillOffsetYZ = dDrillOffsetYZs[nType];
	//
	dPegDias.setLength(0);
	dPegLengths.setLength(0);
	if (nType == 0)
	{
		dPegDias.append(dPegDias0);
		dPegLengths.append(dPegLengths0);
	}
	if (nType == 1)
	{
		dPegDias.append(dPegDias1);
		dPegLengths.append(dPegLengths1);
	}
	if (nType == 2)
	{
		dPegDias.append(dPegDias2);
		dPegLengths.append(dPegLengths2);
	}
	if (nType == 3)
	{
		dPegDias.append(dPegDias3);
		dPegLengths.append(dPegLengths3);
	}
	if (nType == 4)
	{
		dPegDias.append(dPegDias4);
		dPegLengths.append(dPegLengths4);
	}
	if (nType == 5)
	{
		dPegDias.append(dPegDias5);
		dPegLengths.append(dPegLengths5);
	}
	
	
	dTopWidth = dTopWidths[nType];
	dTopThick = dTopThicks[nType];
	dHeight = dHeights[nType];
	// 
// get values depending from from selected anchoring method	
	String sScrewArticleBottom = sScrewArticleBottoms[nAnchoring];
	String sScrewNameBottom = sScrewNameBottoms[nAnchoring];
	double dScrewDiaBottom = dScrewDiaBottoms[nAnchoring];
	String sScrewLengthBottom = T("|Length depending on static requirements|");
	
// bOn Insert ________________________________________________________________________________________________________________________________________________________________
if (_bOnInsert)
{
	if (insertCycleCount() > 1) {eraseInstance(); return;}
	
// silent/dialog
	String sKey = _kExecuteKey;
	sKey.makeUpper();
	
	if (sKey.length()>0)
	{
		String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
		for (int i = 0; i < sEntries.length(); i++)
			sEntries[i] = sEntries[i].makeUpper();
		if (sEntries.find(sKey)>-1)
			setPropValuesFromCatalog(sKey);
		else
			showDialog();
	}		
	else
	{
//		sType.setReadOnly(false);
//		sFastener.set("---");
//		sFastener.setReadOnly(true);
//		sAnchoring.setReadOnly(false);
//		dSlotWidth.setReadOnly(false);
//		showDialog("---");
//		
//		int iType = sMountingMethods.find(sType);
//		String sFasteners[0];
//		if (iType == 0)sFasteners.append(sFasteners0);
//		else if (iType == 1)sFasteners.append(sFasteners1);
//		else if (iType == 2)sFasteners.append(sFasteners2);
//		else if (iType == 3)sFasteners.append(sFasteners3);
//		else if (iType == 4)sFasteners.append(sFasteners4);
//		else if (iType == 5)sFasteners.append(sFasteners5);
//		
//		sType.setReadOnly(true);
//		sFastener.setReadOnly(false);
//		sFastener = PropString(2, sFasteners, sFastenerName, 0);
//		sFastener.set(sFasteners[0]);
//		sFastener.setCategory(sCatFastener);
//		sAnchoring.setReadOnly(true);
//		dSlotWidth.setReadOnly(true);
//		showDialog("---");

		showDialog();
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
	double dArProps[] = {dSlotWidth};
//	String sArProps[] = {sType, sAnchoring, sFastener};
	String sArProps[] = {sType, sAnchoring};
	Map mapTsl;
	nType = sMountingMethods.find(sType);
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
		
	// set the fastener
		Beam bm0 = (Beam)entPosts[i];
		if(nType==1 || nType==3)
		{ 
			// only one fastener
			mapTsl.setInt("iFastener",0);
		}
		else if (nType==0)
		{ 
			// if 
			if(bm0.dW()>=U(160) && bm0.dH()>=U(160))
				mapTsl.setInt("iFastener",1);
			else
				mapTsl.setInt("iFastener",0);
		}
		else if (nType == 2)
		{ 
			if(bm0.dW()>=U(200) && bm0.dH()>=U(200))
				mapTsl.setInt("iFastener",1);
			else
				mapTsl.setInt("iFastener",0);
		}
		
		
	// create new instance	
		tslNew.dbCreate(scriptName(), vUcsX, vUcsY, gbAr, entAr, ptAr, nArProps, dArProps, sArProps, _kModelSpace, mapTsl); // create new instance on each beam
	}
	
	eraseInstance();
	return;
} // end on insert _________________________________________________________________________________________________________________________________________________________________________


// sFasteners
	int iType = sMountingMethods.find(sType);
	String sFasteners[0];
	sFasteners.setLength(0);
	if (iType == 0)sFasteners.append(sFasteners0);
	else if (iType == 1)sFasteners.append(sFasteners1);
	else if (iType == 2)sFasteners.append(sFasteners2);
	else if (iType == 3)sFasteners.append(sFasteners3);
	else if (iType == 4)sFasteners.append(sFasteners4);
	else if (iType == 5)sFasteners.append(sFasteners5);
	
//	int indexFastener = sFasteners.find(sFastener);
//	if (indexFastener >- 1)
//	{
//		// selected sModelis contained in sModels
//		sFastener = PropString(2, sFasteners, sFastenerName, indexFastener);
//		sFastener.setCategory(sCatFastener);
//	}
//	else
//	{
//		// existing sModel is not found, family has been changed so set 
//		// to sModel the first Model from sModels
//		sFastener = PropString(2, sFasteners, sFastenerName, 0);
//		sFastener.set(sFasteners[0]);
//		sFastener.setCategory(sCatFastener);
//	}


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
	
	CoordSys csDiagonal;
	csDiagonal.setToRotation(45, vecX, _Pt0);
	if (nType == 5)
	{
		vecY.transformBy(csDiagonal);
		vecZ.transformBy(csDiagonal);
	}
	
//region trigger for the fasteners
	int iFastener = _Map.getInt("iFastener");
	for (int i=0;i<sFasteners.length();i++) 
	{ 
		String trigger ="../" +T("|Fastener|")+ " "+sFasteners[i];
		addRecalcTrigger(_kContext,trigger+(i == iFastener ? "   √" : ""));
		if (_bOnRecalc && _kExecuteKey==trigger)
		{
			_Map.setInt("iFastener",i);		
			setExecutionLoops(2);
			return;
		}	
	}//next i
	
	// update fastener if type is changed
	if(_kNameLastChangedProp==sTypeName)
	{ 
		if(nType==1 || nType==3)
		{ 
			// only one fastener
			_Map.setInt("iFastener",0);
			setExecutionLoops(2);
			return;
		}
		else if (nType==0)
		{ 
			// if 
			if(bm0.dW()>=U(160) && bm0.dH()>=U(160))
			{ 
				_Map.setInt("iFastener",1);
			}
			else
			{ 
				_Map.setInt("iFastener",0);
			}
			setExecutionLoops(2);
			return;
		}
		else if (nType == 2)
		{ 
			if(bm0.dW()>=U(200) && bm0.dH()>=U(200))
			{ 
				_Map.setInt("iFastener",1);
			}
			else
			{ 
				_Map.setInt("iFastener",0);
			}
			setExecutionLoops(2);
			return;
		}
	}
//End trigger for the fasteners//endregion 
	dPegDia = dPegDias[_Map.getInt("iFastener")];
	dPegLength = dPegLengths[_Map.getInt("iFastener")];
	
// tools ________________________________________________________________________________________________________________________________________________________________
	Point3d ptCut = _Pt0 - vecX*dHeight;

// cut the beam
	Cut ctPostBase (ptCut, vecX);
	bm0.addTool(ctPostBase, _kStretchOnToolChange);
	_Pt0.vis(1);
// slots for screwed mounting
	double dSlotW = dSlotWidth;
	Slot slt1;
	Slot slt2;
	
	if (nType <= 3)
	{
		dSlotW = dTopThick;

//		slt1 = Slot (ptCut + vecZ*.5*bm0.dD(vecZ), -vecX, vecY, -vecZ, U(280), dSlotW, 0.5*bm0.dD(vecZ), 1, 0, 1);
//		slt1 = Slot (ptCut, -vecX, vecY, -vecZ, U(280), dSlotW, dTopWidth, 1, 0,0);
		slt1 = Slot (ptCut, vecZ, vecY, -vecX, dTopWidth, dSlotW, U(280), 0,0,1);
		
		bm0.addTool(slt1);

//		slt2 = Slot (ptCut + vecY*.5*bm0.dD(vecY), -vecX, -vecZ, vecY, U(280), dSlotW, 0.5*bm0.dD(vecY), 1, 0, 1);
//		slt2 = Slot (ptCut, -vecX, -vecZ, vecY, U(280), dSlotW, dTopWidth, 1, 0, 0);
		slt2 = Slot (ptCut, vecY, vecZ, -vecX, dTopWidth, dSlotW, U(280) , 0, 0,1);
		bm0.addTool(slt2);
	}
	else
	{
		slt1 = Slot (ptCut, vecZ, vecY, -vecX, U(140), dSlotW, U(280), 0, 0, 1);
		bm0.addTool(slt1);

		slt2 = Slot (ptCut, vecY, -vecZ, -vecX, U(140), dSlotW, U(280), 0, 0, 1);
		bm0.addTool(slt2);
	}
	
// body to represent the post base
	Body bdPostBase;
	Body bdBottomPlate;
	Body bdSword;
	Body bdCrossSword;
	Body bdExtraPlate;
	
	CoordSys csRotate;
	csRotate.setToRotation(90, vecX, _Pt0);
	
// bottom plate
	PLine plBottomPlate;
	dBottomPlateLength = dBottomPlateLengths[iType];
	dBottomPlateWidth = dBottomPlateWidths[iType];
	dBottomPlateThick = dBottomPlateThicks[iType];
	plBottomPlate.addVertex(_Pt0 + vecY*dBottomPlateLength*.5 + vecZ*dBottomPlateWidth*.5);
	plBottomPlate.addVertex(_Pt0 + vecY*dBottomPlateLength*.5 - vecZ*dBottomPlateWidth*.5);
	plBottomPlate.addVertex(_Pt0 - vecY*dBottomPlateLength*.5 - vecZ*dBottomPlateWidth*.5);
	plBottomPlate.addVertex(_Pt0 - vecY*dBottomPlateLength*.5 + vecZ*dBottomPlateWidth*.5);
	plBottomPlate.close();
	bdBottomPlate = Body (plBottomPlate, -vecX*dBottomPlateThick);
	
// extra plate
	PLine plExtraPlate(vecX);
	Point3d ptExtraRef = _Pt0 - vecX * dHeight;ptExtraRef.vis(4);
	if(nType==2 || nType==3)
	{ 
		plExtraPlate.addVertex(ptExtraRef + vecY*dTopWidth*.5 + vecZ*U(48)*.5);
		plExtraPlate.addVertex(ptExtraRef + vecY*U(48)*.5 + vecZ*dTopWidth*.5);
		plExtraPlate.addVertex(ptExtraRef - vecY*U(48)*.5 + vecZ*dTopWidth*.5);
		plExtraPlate.addVertex(ptExtraRef - vecY*dTopWidth*.5 + vecZ*U(48)*.5);
		plExtraPlate.addVertex(ptExtraRef - vecY*dTopWidth*.5 - vecZ*U(48)*.5);
		plExtraPlate.addVertex(ptExtraRef - vecY*U(48)*.5 - vecZ*dTopWidth*.5);
		plExtraPlate.addVertex(ptExtraRef + vecY*U(48)*.5 - vecZ*dTopWidth*.5);
		plExtraPlate.addVertex(ptExtraRef + vecY*dTopWidth*.5 - vecZ*U(48)*.5);
		plExtraPlate.close();
	}
	else
	{ 
		plExtraPlate.addVertex(ptExtraRef + vecY*dTopWidth*.5 + vecZ*dTopThick*.5);
		plExtraPlate.addVertex(ptExtraRef + vecY*dTopThick*.5 + vecZ*dTopWidth*.5);
		plExtraPlate.addVertex(ptExtraRef - vecY*dTopThick*.5 + vecZ*dTopWidth*.5);
		plExtraPlate.addVertex(ptExtraRef - vecY*dTopWidth*.5 + vecZ*dTopThick*.5);
		plExtraPlate.addVertex(ptExtraRef - vecY*dTopWidth*.5 - vecZ*dTopThick*.5);
		plExtraPlate.addVertex(ptExtraRef - vecY*dTopThick*.5 - vecZ*dTopWidth*.5);
		plExtraPlate.addVertex(ptExtraRef + vecY*dTopThick*.5 - vecZ*dTopWidth*.5);
		plExtraPlate.addVertex(ptExtraRef + vecY*dTopWidth*.5 - vecZ*dTopThick*.5);
		plExtraPlate.close();
	}
	
	bdExtraPlate = Body (plExtraPlate, -vecX*dExtraPlateThick, -1);
	bdExtraPlate.vis(3);
// cross sword	
	PLine plSword (vecY);
	Point3d ptCrossRef = _Pt0 - vecX*dBottomPlateThick;
	plSword.addVertex(ptCrossRef - vecZ*dTopWidth*.5);
	plSword.addVertex(ptCrossRef - vecX*(dTopHeight-U(10)) - vecZ*dTopWidth*.5);
	plSword.addVertex(ptCrossRef - vecX*dTopHeight - vecZ*(dTopWidth*.5-U(10)));
	plSword.addVertex(ptCrossRef - vecX*dTopHeight + vecZ*(dTopWidth*.5-U(10)));
	plSword.addVertex(ptCrossRef - vecX*(dTopHeight-U(10)) + vecZ*dTopWidth*.5);
	plSword.addVertex(ptCrossRef + vecZ*dTopWidth*.5);
	plSword.close();
	plSword.vis(1);
	bdSword= Body (plSword, vecY*dTopThick, 0);

	bdCrossSword = bdSword;
	bdCrossSword.transformBy(csRotate);
	bdCrossSword = bdCrossSword + bdSword;

// join all parts to one body	
	bdPostBase = bdBottomPlate + bdCrossSword + bdExtraPlate;

	
// drill PLines
// define pattern parameters (S1, S2, S3, S4)
	Body bdPegs[0];
	
//	double dDrillVertS1[] = {U(80), U(130), U(180), U(230)};
	double dDrillVertS1[] = {U(40), U(80), U(189), U(229)};
//	double dDrillVertS2[] = {U(30), U(70), U(184), U(224)};
	double dDrillVertS2[] = {U(84), U(212)};
//	double dDrillVertS3[] = {U(30), U(127), U(224)};
	double dDrillVertS3[] = {U(42), U(82), U(187), U(227)};
//	double dDrillVertS4[] = {U(84), U(212)};
	double dDrillVertS4[] = {U(84), U(149), U(214)};

	
	for (int i=0; i<2; i++) // repeat for vecY and vecZ direction
	{
		Vector3d vecDir = -vecY;
		if (i == 1) vecDir = vecZ;
		
		Vector3d vecNorm = vecX.crossProduct(vecDir);
		vecNorm.normalize();
		
		double dDrillVert[0];
		if (nType == 0)
			dDrillVert = dDrillVertS1;
		else if (nType == 1)
			dDrillVert = dDrillVertS2;
		else if (nType == 2)
			dDrillVert = dDrillVertS3;
		else if (nType == 3)
			dDrillVert = dDrillVertS4;
		else
			continue;
			
		int nDir = 1;
		for (int j=0; j<2; j++) // repeat for both sides
		{	
			Point3d ptDrillRef (_Pt0 - vecX * (dHeight + i * dDrillOffsetYZ));
			ptDrillRef.transformBy(-vecDir * .5 * bm0.dD(vecDir));
			ptDrillRef.transformBy(nDir * vecNorm * dDrillSideOffset);
			ptDrillRef.vis(6);
			
			for (int k=0; k<dDrillVert.length(); k++) // repeat for ammount of drill lines
			{
				
				Point3d ptStartDrill = ptDrillRef - vecX*dDrillVert[k];
				Point3d ptEndDrill = ptDrillRef - vecX*dDrillVert[k] + vecDir*(dPegLength + .5*(bm0.dD(vecDir)-dPegLength));
				if(nType==2)
				{ 
					double kk = k;
					int iKhalf = kk / 2;
					double dKhalf = kk / 2;
					
					if(iKhalf<dKhalf && i==0)
					{ 
						// 1,3,5,7
						ptStartDrill.transformBy(-nDir * vecNorm * U(23));
						ptEndDrill.transformBy(-nDir * vecNorm * U(23));
					}
					else if(iKhalf==dKhalf && i==1)
					{ 
						ptStartDrill.transformBy(-nDir * vecNorm * U(23));
						ptEndDrill.transformBy(-nDir * vecNorm * U(23));
					}
				}
				
			// create bodies and tools
				Body bdPeg (ptStartDrill + vecDir * .5 * (bm0.dD(vecDir) - dPegLength), ptEndDrill, dPegDia / 2);
				bdPegs.append(bdPeg);
				Drill dr (ptStartDrill, ptEndDrill , dPegDia/2);
				//SolidSubtract sosu (bdSoSu);
				bm0.addTool(dr);
				
//				if (nType == 2 && (k == 0 || k == 2)) //special pattern S3 (every other line gets 4 drills instead of 2)
//				{
//					bdPeg.transformBy(nDir*vecNorm*U(20));
//					bdPegs.append(bdPeg);
//					
//					dr.transformBy(nDir*vecNorm*U(20));
//					//SolidSubtract sosu (bdSoSu);
//					bm0.addTool(dr);
//				}
			}
			
			nDir*= -1;
		}
	}
	

// send warning, that head slots can't be executed on Hundegger BVN
	if ((nType == 4 || nType == 5) && (_kNameLastChangedProp == sTypeName || _kNameLastChangedProp == sSlotWidthName || _bOnDbCreated))
		reportNotice("\n!!! " + T("|Attention|") + " !!!\n" + T("|The required head slots for this type can't be executed on Hundegger BVN machines!|"));


// display
//	_ThisInst.setHyperlink("http://www.rothoblaas.com/products/fastening/brackets-and-plates/pillar-bases/typ-x");
	_ThisInst.setHyperlink("https://www.rothoblaas.com/products/fastening/brackets-and-plates/pillar-bases/typ-x10");
	
	Display dp(9);
	dp.draw(bdPostBase);
	
	for (int i=0; i< bdPegs.length(); i++)
		dp.draw(bdPegs[i]);
	
// Hardware//region
// collect existing hardware
	HardWrComp hwcs[] = _ThisInst.hardWrComps();
	
// remove any tsl repType: the assumption is that any hardware component of type _kRTTsl has been attached by this instance
	for (int i=hwcs.length()-1; i>=0 ; i--) 
		if (hwcs[i].repType() == _kRTTsl || 1)
			hwcs.removeAt(i); 

// declare the groupname of the hardware components
	String sHWGroupName;
	// set group name
	{ 
	// element
		// try to catch the element from the parent entity
		Element elHW =bm0.element(); 
		// check if the parent entity is an element
		if (!elHW.bIsValid())	elHW = (Element)bm0;
		if (elHW.bIsValid()) 	sHWGroupName=elHW.elementGroup().name();
	// loose
		else
		{
			Group groups[] = _ThisInst.groups();
			if (groups.length()>0)	sHWGroupName=groups[0].name();
		}		
	}
	
// add main componnent
	{ 
		String sModel = sArticlePostBase;
		String sDescription = T("|Post base|") + " - " + T("|Type|") + " " + sArticlePostBase;

		
	// post base itself	
		HardWrComp hw(sArticleNumberPostBase , 1);
		hw.setName(sArticlePostBase);
		hw.setCategory(T("|Post base|"));
		hw.setManufacturer("Rothoblaas");
		hw.setModel(sModel);
		hw.setMaterial(T("|Steel|"));
		hw.setDescription(sDescription);
		hw.setDScaleX(dBottomPlateLength);
		hw.setDScaleY(dBottomPlateWidth);
		hw.setDScaleZ(dBottomPlateThick + dTopHeight);	
		hwcs.append(hw);
	
	// screws top
		int nQuant = bdPegs.length();
		String sDesc = sPegName + " " + dPegDia + " x " + dPegLength;
		if (nType == 4 || nType == 5)
		{
			nQuant = 1;
			sDesc = sPegName;
		}
	
		HardWrComp hwScrewTop(sPegArticle, nQuant);
		hwScrewTop.setCategory(T("|Post base|"));
		hwScrewTop.setManufacturer("Rothoblaas");
		hwScrewTop.setModel(dPegDia + " x " + dPegLength);
		hwScrewTop.setMaterial(T("|Steel|"));		
		hwScrewTop.setDescription(sDesc);
		hwScrewTop.setDScaleX(dPegLength);
		hwScrewTop.setDScaleY(dPegDia);
		hwScrewTop.setDScaleZ(0);	
		hwcs.append(hwScrewTop);
		
	// screws bottom		
		HardWrComp hwScrewBottom(sScrewArticleBottom, nScrewQuantBottom);	
		hwScrewBottom.setCategory(T("|Post base|"));
		hwScrewBottom.setManufacturer("Rothoblaas");
		hwScrewBottom.setModel("d" + dScrewDiaBottom);
		hwScrewBottom.setMaterial(T("|Steel|"));		
		hwScrewBottom.setDescription(sScrewNameBottom + " d" + dScrewDiaBottom + " (" + sScrewLengthBottom + ")");
		hwScrewBottom.setDScaleX(0);
		hwScrewBottom.setDScaleY(dScrewDiaBottom);
		hwScrewBottom.setDScaleZ(0);	
		hwcs.append(hwScrewBottom);	
		
	}

// make sure the hardware is updated
	if (_bOnDbCreated)	setExecutionLoops(2);				
	_ThisInst.setHardWrComps(hwcs);	
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
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End