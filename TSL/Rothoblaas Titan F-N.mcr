#Version 8
#BeginDescription
version value="1.2" date=22oct2018" author="david.rueda@hsbcad.com"

EN
Rothoblaas TITAN F/N angle bracket for shear loads in solid stick frame walls or panels.
When out of panel boundaries, tool will relocate to max. allowed limit on male panel.

DACH
Rothoblaas TITAN F/N Scheerwinkel für Holzrahmenbau und BSP.
Der Winkel kann nur innerhalb der BSP-Grenzen angeordnet werden.
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 2
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// Rothoblaas TITAN F/N angle bracket for shear loads in solid stick frame walls or panels.
/// </summary>

/// <insert Lang=en>
/// 
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

///<version value="1.2" date=22oct2018" author="david.rueda@hsbcad.com"> Thumbnail and description updated </version>
///<version value="1.1" date="14sept17" author="florian.wuermseer@hsbcad.com"> major revision, updated geometry and hardware data</version> 
///<version value="1.0" date="26oct16" author="florian.wuermseer@hsbcad.com"> initial version</version> 

// constants
	U(1,"mm");	
	double dEps =U(.1);
	int nDoubleIndex, nStringIndex, nIntIndex;
	String sDoubleClick= "TslDoubleClick";
	int bDebug=_bOnDebug;
	bDebug = (projectSpecial().makeUpper().find("DEBUGTSL",0)>-1?true:(projectSpecial().makeUpper().find(scriptName().makeUpper(),0)>-1?true:bDebug));
	
	
// collect anchor sizes and properties
	// name and descriptions
	String sArticleNames[] = {"Titan N - TCN 200", "Titan N - TCN 240", "Titan N - TTN 240", "Titan F - TCF 200", "Titan F - TTF 200"};
	String sArticleNumbers[] = {"TCN200", "TCN240", "TTN240", "TCF200", "TCF240"};
	
	// geometry
	double dHeights[] = {U(120), U(120), U(120), U(71), U(71)};
	double dWidths[] = {U(200), U(240), U(240), U(200), U(200)};
	double dDepths[] = {U(103), U(123), U(93), U(103), U(71)};
	double dThicknesses[] = {U(3), U(3), U(3), U(3), U(3)};
	double dHoleDiaTops[] = {U(5), U(5), U(5), U(5), U(5)};
	double dHoleInterdistTops[] = {U(20), U(20), U(20), U(14), U(14)};
	double dHoleOffsetTops[] = {U(60), U(60), U(60), U(26), U(26)};
	double dHoleOffsetTopSides[] = {U(10), U(10), U(10), U(10), U(10)};
	double dHoleDiaBottoms[] = {U(13), U(17), U(5), U(13), U(5)};
	double dHoleOffsetBottoms[] = {U(40), U(41), U(33), U(40), U(26)};
	double dHoleInterdistBottoms[] = {U(31.5), U(41), U(20), U(31.5), U(14)};
	double dHoleOffsetBottomSides[] = {U(25), U(39), U(10), U(25), U(10)};
	
	// hardware
	int nQuantNailsFulls[] = {30, 36, 72, 30, 60};
	String sNailTypes[] = {T("|Anchor Nail|") + " LBA 4x60", T("|Round head screw|") + " LBS 5x50"};
	String sNailNames[] = {"LBA460", "LBS550"};
	String sNailArticles[] = {"PF601460", "PF603550"};
	double dNailDias[] = {U(4), U(5)};
	double dNailLengths[] = {U(60), U(50)};
	
	String sMainScrews[] = {T("|Expansion anchor|"), T("|Screw anchor|"), T("|Chemical dowel|") + " VINYLPRO", T("|Chemical dowel|") + " EPOPLUS"};
	String sMainScrewArticles[] = {"AB1", "SKR", "VINYLPRO", "EPOPLUS"};
	double dMainScrewDias[] = {U(12), U(16)};
	int nMainScrewQuant = 2;
	
	
// reinforcement washer
	String sNameReinfWashers[] = {"TCW200", "TCW240", "---", "---", "---"};
	String sArticleReinfWashers[] = {"TCW200", "TCW240", "---", "---", "---"};
	
	double dWasherWidths[] = {U(190), U(230), U(0), U(0), U(0)};
	double dWasherDepths[] = {U(72), U(73), U(0), U(0), U(0)};
	double dWasherThicknesses[] = {U(12), U(12), U(0), U(0), U(0)};
	double dWasherDias[] = {U(14), U(18), U(0), U(0), U(0)};
	
	
// properties

// Anchor model
	String sCatType = T("|Type|");
	
	String sArticleNameName = "A - " + T("|Type|");
	PropString sArticleName (nStringIndex++, sArticleNames, sArticleNameName);
	sArticleName.setCategory(sCatType);
	sArticleName.setDescription(T("|Defines the anchor model|"));
	int nArticle = sArticleNames.find(sArticleName);

	String sNoYes[] = {T("|No|"), T("|Yes|")};
	String sWasherName = "B - " + T("|Reinforcement Washer|");
	PropString sWasher (nStringIndex++, sNoYes, sWasherName);
	sWasher.setCategory(sCatType);
	sWasher .setDescription(T("|Add a reinforcement washer to the anchor|"));
	int nWasher = sNoYes.find(sWasher);

// Mounting properties	
	String sCatMounting = T("|Mounting|");
	
	String sNailTypeName = "C - " + T("|Mounting type|");
	PropString sNailType (nStringIndex++, sNailTypes, sNailTypeName);
	sNailType.setCategory(sCatMounting);
	sNailType.setDescription(T("|Defines, if the anchor will be fixed with screws or nails|"));
	int nNailType = sNailTypes.find(sNailType);
	
	String sMainScrewName = "D - " + T("|Anchoring to the ground|");
	PropString sMainScrew (nStringIndex++, sMainScrews, sMainScrewName);
	sMainScrew.setCategory(sCatMounting);
	sMainScrew.setDescription(T("|Sets how the anchor will be fixed on the ground|"));
	int nMainScrew = sMainScrews.find(sMainScrew);
	
	String sMainScrewDiaName = "E - " + T("|Screw Diameter|");
	PropDouble dMainScrewDia (nDoubleIndex++, dMainScrewDias, sMainScrewDiaName);
	dMainScrewDia.setCategory(sCatMounting);
	dMainScrewDia.setDescription(T("|Sets the diameter of the anchoring screw|"));

// tooling properties
	String sCatTooling = T("|Tooling|");
	
	String sMillDepthName = "F - " + T("|Mill depth|");
	PropDouble dMillDepth (nDoubleIndex++, U(0), sMillDepthName);
	dMillDepth.setCategory(sCatTooling);
	dMillDepth.setDescription(T("|Defines the depth of the milling, the anchor sits in|"));
	
	String sMillOversizeName = "G - " + T("|Oversize milling|");
	PropDouble dMillOversize (nDoubleIndex++, U(5), sMillOversizeName);
	dMillOversize.setCategory(sCatTooling);
	dMillOversize.setDescription(T("|Defines the oversize of the milling, the anchor sits in|"));
	
	String sNoNailName = "H - " + T("|No nail areas|");
	PropString sNoNail (nStringIndex++, sNoYes, sNoNailName);
	sNoNail.setCategory(sCatTooling);
	sNoNail.setDescription(T("|Defines, if no nail areas will be added to StickFrame walls|") + "\n(" +
								T("|You need hsbCAM module for this|") + ")");
	int nNoNail = sNoYes.find(sNoNail);

// select properties from selected Article
	String sArticleNumber = sArticleNumbers[nArticle];
	
	// geometry
	double dHeight = dHeights[nArticle];
	double dWidth = dWidths[nArticle];
	double dDepth = dDepths[nArticle];
	double dThickness = dThicknesses[nArticle];
	double dHoleDiaTop = dHoleDiaTops[nArticle];
	double dHoleInterdistTop = dHoleInterdistTops[nArticle];
	double dHoleOffsetTop = dHoleOffsetTops[nArticle];
	double dHoleOffsetTopSide = dHoleOffsetTopSides[nArticle];
	double dHoleDiaBottom = dHoleDiaBottoms[nArticle];
	double dHoleOffsetBottom = dHoleOffsetBottoms[nArticle];
	double dHoleInterdistBottom = dHoleInterdistBottoms[nArticle];
	double dHoleOffsetBottomSide = dHoleOffsetBottomSides[nArticle];
	
	// hardware
	int nQuantNailsFull = nQuantNailsFulls[nArticle];
	String sNailName = sNailNames[nNailType];
	String sNailArticle = sNailArticles[nNailType];
	double dNailDia = dNailDias[nNailType];
	double dNailLength = dNailLengths[nNailType];
	String sMainScrewArticle = sMainScrewArticles[nMainScrew];
	
	// reinforcement washer
	String sNameReinfWasher = sNameReinfWashers[nArticle];
	String sArticleReinfWasher = sArticleReinfWashers[nArticle];
	
	double dWasherWidth = dWasherWidths[nArticle];
	double dWasherDepth = dWasherDepths[nArticle];
	double dWasherThickness = dWasherThicknesses[nArticle];
	double dWasherDia = dWasherDias[nArticle];
	
// bOnInsert
	if(_bOnInsert)
	{
		if (insertCycleCount()>1) { eraseInstance(); return; }
					
	// silent/dialog
		String sKey = _kExecuteKey;
		sKey.makeUpper();

		if (sKey.length()>0)
		{
			String sEntries[] = TslInst().getListOfCatalogNames(scriptName());
			for(int i=0;i<sEntries.length();i++)
				sEntries[i] = sEntries[i].makeUpper();	
			if (sEntries.find(sKey)>-1)
				setPropValuesFromCatalog(sKey);
			else
				setPropValuesFromCatalog(T("|_LastInserted|"));					
		}		
		showDialog();
		

	// prepare TSL cloning
		TslInst tslNew;
		Vector3d vecXTsl= _XE;
		Vector3d vecYTsl= _YE;
		GenBeam gbsTsl[0];
		Entity entsTsl[0];
		Point3d ptsTsl[0];
		int nProps[]={};
		double dProps[]={dMainScrewDia, dMillDepth, dMillOversize};
		String sProps[]={sArticleName, sWasher, sNailType, sMainScrew, sNoNail};
		Map mapTsl;	
		String sScriptname = scriptName();	
		
	// prompt for one or more beams or panels
		Entity entRefs[0];
		Entity entRefSips[0];
		Beam bmRefs[0];
		Sip sipRefs[0];
		TslInst tslTemp;
		
	// prompt for reference objects (beams)
		PrEntity ssRef(T("|Select beam(s) or panel(s)|"), Beam());
		ssRef.addAllowedClass(Sip());
	  	if (ssRef.go())
			entRefs.append(ssRef.set());
				
	// not horizontal beams will be sorted out, directly
		int nRemove;
		for (int i=entRefs.length()-1; i>=0; i--)
		{
			if (entRefs[i].bIsKindOf(Beam()) == TRUE)
			{
				Beam bm = (Beam) entRefs[i];
				if (!bm.vecX().isPerpendicularTo(_ZW))
					nRemove++;
				else
					bmRefs.append(bm);
			}
			
			if (entRefs[i].bIsKindOf(Sip()) == TRUE)
				sipRefs.append((Sip) entRefs[i]);
		}
		if (nRemove > 0)
			reportMessage("\n" + nRemove + T("|not horizontal beams were filtered out|"));
		
	// prompt for insert side, if Beam array > 0
		Point3d ptInsertSide;
		for (int i=0; i<bmRefs.length(); i++)
		{
			Beam bmThis = bmRefs[i];
			Element elBeam = bmThis.element();
			Vector3d vecAlign;
			Vector3d vecInsertSide;
			Point3d ptInsert;
		
		// create a highlight TSL
			Beam bm[] = {bmThis};
			ptsTsl.setLength(0);
			mapTsl.setInt("Highlight", 1);
			tslTemp.dbCreate(scriptName(), vecXTsl ,vecYTsl, bm, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);	
	
		// prompt for anchor alignment
			if (elBeam.bIsValid() == TRUE && elBeam.bIsKindOf(ElementWall()))
				vecAlign = elBeam.vecY();
			
			else
				vecAlign = _ZW;
				
			
			
			PrPoint ssP("\n"+ T("|Select insert point|") + " " + T("|or|") + " " + T("|<Enter> to continue|")); 
			while (ssP.go()==_kOk)
			{			
			
				Point3d pt = ssP.value();
				Vector3d vecInsertRef (bmThis.vecX().crossProduct(_ZW));
				Vector3d vecInsertSide (pt - bmThis.ptCen());
				int nSide = 1;
				if (vecInsertRef.dotProduct(vecInsertSide) != 0)
					nSide = vecInsertRef.dotProduct(vecInsertSide) / abs(vecInsertRef.dotProduct(vecInsertSide));
					
				Line lnInsert (bmThis.ptCen(), bmThis.vecX());
				lnInsert.transformBy(bmThis.vecD(nSide*vecInsertRef) * .5*bmThis.dD(nSide*vecInsertRef));
				lnInsert.transformBy(bmThis.vecD(-_ZW) * .5*bmThis.dD(-_ZW));
				
				pt = lnInsert.closestPointTo(pt);
				
				
				mapTsl.setInt("Highlight", 0);
				
				mapTsl.setVector3d("vecAlign", vecAlign);
								
				gbsTsl.setLength(0);
				gbsTsl.append(bmThis);
				
				ptsTsl.setLength(0);
				ptsTsl.append(pt);
				
				tslNew.dbCreate(scriptName(), vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
						nProps, dProps, sProps,_kModelSpace, mapTsl);			
			}// do while point
			
		// delete highlight 
			tslTemp.dbErase();

	
	
	
	
	
	
		}
		
		
		for (int i=0; i<sipRefs.length(); i++)
		{	
			Sip sipThis = sipRefs[i];
			Element elSip = sipThis.element();
			Vector3d vecAlign;
			Vector3d vecInsertSide;
			Point3d ptInsert;
			Quader qdSip (sipThis.ptCen(), sipThis.vecX(), sipThis.vecY(), sipThis.vecZ(), sipThis.dL(), sipThis.dW(), sipThis.dH());
			
		// create a highlight TSL
			Sip sp[] = {sipThis};
			ptsTsl.setLength(0);
			mapTsl.setInt("Highlight", 1);
			tslTemp.dbCreate(scriptName(), vecXTsl ,vecYTsl,sp, entsTsl, ptsTsl, nProps, dProps, sProps,_kModelSpace, mapTsl);	

		// prompt for anchor alignment
			if (elSip.bIsValid() == TRUE && elSip.bIsKindOf(ElementWall()))
				vecAlign = elSip.vecY();
				
			else if (sipThis.vecZ().isPerpendicularTo(_ZU) == TRUE)
			{
				reportMessage("\n" + T("|Panel is vertical aligned in the current coordinate system|") + " --> " + T("|The suggested anchor alignment is in negative Z direction (downwards)|"));
					vecAlign = _ZU;
			}
			
			else
			{
				Point3d ptAlign;
				PrPoint ssAlignPoint("\n"+ T("|Set the anchor alignment|"), sipThis.ptCen()); 
				if (ssAlignPoint.go()==_kOk)
					ptAlign = ssAlignPoint.value();
				Plane pnAlign (sipThis.ptCen(), sipThis.vecZ());
				ptAlign = pnAlign.closestPointTo(ptAlign);
				vecAlign = (sipThis.ptCen()-ptAlign);
			}
			
			PrPoint ssP("\n"+ T("|Select insert point|") + " " + T("|or|") + " " + T("|<Enter> to continue|")); 
			while (ssP.go()==_kOk)
			{			
				Point3d pt = ssP.value();
				Vector3d vecInsertSide (pt - sipThis.ptCen());
				int nSipSide = 1;
				if (sipThis.vecZ().dotProduct(vecInsertSide) != 0)
					nSipSide = sipThis.vecZ().dotProduct(vecInsertSide) / abs(sipThis.vecZ().dotProduct(vecInsertSide));
				Plane pnInsert (sipThis.ptCen()+sipThis.vecZ()*nSipSide*.5*sipThis.dH(), sipThis.vecZ());
				pt = pnInsert.closestPointTo(pt);
				
			// when sip is part of an element, project insert points to the wall bottom edge
				if (elSip.bIsValid() == TRUE && elSip.bIsKindOf(ElementWall()))
				{
					Plane pnBottom (sipThis.ptCen()-elSip.vecY()*qdSip.dD(elSip.vecY()), elSip.vecY());
					pt = pnBottom.closestPointTo(pt);
//					reportMessage("\n" + sipThis.dD(elSip.vecY()));
				}
			
			// when sip is vertically aligned in current UCS, project insert points to the bottom edge
				else if (sipThis.vecZ().isPerpendicularTo(_ZU) == TRUE)
				{
					Plane pnBottom (sipThis.ptCen()-_ZU*qdSip.dD(_ZU), _ZU);
					pt = pnBottom.closestPointTo(pt);
				}
				
				
				
				mapTsl.setInt("Highlight", 0);
				
				mapTsl.setVector3d("vecAlign", vecAlign);
								
				gbsTsl.setLength(0);
				gbsTsl.append(sipThis);
				
				ptsTsl.setLength(0);
				ptsTsl.append(pt);
				
				tslNew.dbCreate(scriptName(), vecXTsl ,vecYTsl,gbsTsl, entsTsl, ptsTsl, 
						nProps, dProps, sProps,_kModelSpace, mapTsl);			
			}// do while point
			
		// delete highlight 
			tslTemp.dbErase();
		}
		
		
		//eraseInstance();			
		return;
	}	
// end on insert ____________________________________________________________________________________________________________________________________________________________








// Highlight mode
if (_Map.hasInt("Highlight"))
{


	int nHighlight = _Map.getInt("Highlight");
	if (nHighlight == 1)
	{
	
		if (_bOnRecalc && _kExecuteKey == sDoubleClick)
		{
			eraseInstance();
			return;
		}
	
	
		for (int i=0; i<_GenBeam.length(); i++)
		{
			Body bd = _GenBeam[i].envelopeBody();
			PlaneProfile pp = bd.getSlice(Plane (_GenBeam[i].ptCen(), _GenBeam[i].vecZ()));
			
			Hatch ha ("ANSI37", 10);
			Display dp (6);
			dp.draw(pp, ha);
			setOPMKey("Highlight");
		}
		return;
	}
}
	
	
	
	
	
		

// Normal mode ____________________________________________________________________________________________________________________________________________________________
// validate reference objects

	if (_Beam.length() < 1 && _Sip.length() < 1 || (_Beam.length() >= 1 && _Sip.length() >= 1))
	{	
		reportMessage("\n" + T("|No reference objects found|") + " ---> " + T("|Tool will be deleted|"));
		if (!bDebug) eraseInstance();
		return;
	}
	
	if (_Map.hasVector3d("vecAlign") == 0) // highlight mode
	{	
		reportMessage("\n" + T("|No alignment definition found|") + " ---> " + T("|Tool will be deleted|"));
		if (!bDebug) eraseInstance();
		return;
	}
	
// declare standards	
	Beam bm = _Beam0;
	Sip sip = _Sip0;
	Element el = _GenBeam[0].element();
	Beam bmToMill[0];
	GenBeam gbToMill[] = {_GenBeam[0]};
	int bHasElement;

// determine, if reference GenBeam is part of an Element	
	if (el.bIsValid() == TRUE)
	{
		bHasElement = 1;
		if (bm.bIsValid() == TRUE)
		{
			bmToMill = el.beam();
			for (int i=0; i<bmToMill.length(); i++)
			{
				gbToMill.append(bmToMill[i]);
			}
		}
	}
	
// assignment
	assignToGroups(_GenBeam[0], 'Z');
	
// erase and copy with beams
	setEraseAndCopyWithBeams(_kBeam0);

// detrmine if Beam or Panel mode	
	int nMode; // 0 = Sip-Mode, 1 = Beam-Mode	
	if (bm.bIsValid() == TRUE)
	{
		nMode = 1;
		if (bDebug) reportMessage("\n" + "Beam Mode");
	}
	else
		if (bDebug) reportMessage("\n" + "Panel Mode");
	
	Vector3d vecX, vecY, vecZ;
	Vector3d vecInsertSide, vecInsertPerp;
	int nSide;
	double dInsert;

// set position and alignment for beam mode	
	if (nMode == 1) // beam mode
	{
		if (!bm.vecX().isPerpendicularTo(_ZW))
		{
			reportMessage("\n" + T("|The reference beam is not horizontal|") + " ---> " + T("|Tool will be deleted|"));
			if (!bDebug) eraseInstance();
			return;
		}
			
		Vector3d vecVertical = _ZW;
		if (bHasElement == 1)
			vecVertical = el.vecY();
			
		Plane pnBottom (bm.ptCen()-bm.vecD(vecVertical)*.5*bm.dD(vecVertical), vecVertical);
		Point3d ptBottom = pnBottom.closestPointTo(bm.ptCen());
//		ptBottom.vis(2);
		_Pt0 = pnBottom.closestPointTo(_Pt0);
//		_Pt0.vis(2);
	
	// fix point to one of the bottom edges of the beam
		vecInsertSide = bm.vecD(_Pt0 - ptBottom);
		Vector3d vec = bm.vecX();
		if ((_Pt0 - ptBottom).isParallelTo(bm.vecX()) || (_Pt0 - ptBottom).length() == 0)
			vecInsertSide = bm.vecX().crossProduct(_Pt0 - bm.ptCen());
		
		vecInsertSide.normalize();
		vecInsertSide.vis(_Pt0, 2);
		double dInsert = .5*bm.dD(vecInsertSide);
		
		vecInsertPerp = vecInsertSide.crossProduct(_ZW);
		vecInsertPerp.normalize();
		vecInsertPerp.vis(_Pt0, 30);

		PLine pl (ptBottom + vecInsertSide*dInsert + bm.vecX()*.5*bm.dL(), ptBottom + vecInsertSide*dInsert - bm.vecX()*.5*bm.dL());
		pl.vis(5);

		_Pt0 = pl.closestPointTo(_Pt0);

	// declare the vectors
		vecZ = vecVertical;
		vecY = vecInsertSide;
		vecX = vecY.crossProduct(vecZ);
	}
	
	
// set position and alignment for panel mode			
	else // sip mode
	{
	// determine insert side
		nSide = 1;
		vecInsertSide = _Pt0 - sip.ptCen();
		if (sip.vecZ().dotProduct(vecInsertSide) != 0)
		nSide = sip.vecZ().dotProduct(vecInsertSide) / abs(sip.vecZ().dotProduct(vecInsertSide));
		
	// fix point to outer edges of the panel
		PlaneProfile ppSip (sip.plShadowCnc());
		_Pt0 = ppSip.closestPointTo(_Pt0);
		Plane pnInsert (sip.ptCen()+sip.vecZ()*nSide*.5*sip.dH(), sip.vecZ());
		_Pt0 = pnInsert.closestPointTo(_Pt0);
		
	// 
		PLine plSipEdge (sip.vecZ());
		PlaneProfile ppSipSide = sip.realBody().extractContactFaceInPlane(pnInsert, U(10));
		PLine plSipEdges[] = ppSipSide.allRings();
		int nIsOpenings[] = ppSipSide.ringIsOpening();
		
		if (plSipEdges.length() > 0)
			plSipEdge = plSipEdges[0];
		
		
		ppSipSide.shrink(-.5*dWidth-dMillOversize);
		ppSipSide.shrink(.5*dWidth+dMillOversize);
		ppSipSide.vis(6);
	
	// declare the vectors
		vecZ = _Map.getVector3d("vecAlign");
		vecY = nSide*sip.vecZ();
		vecX = vecY.crossProduct(vecZ);
	}
	
	vecX.normalize();
	vecY.normalize();
	vecZ.normalize();
	
	vecX.vis(_Pt0, 1);
	vecY.vis(_Pt0, 3);
	vecZ.vis(_Pt0, 5);
	
// create recalc trigger to flip vecZ alignment (only in Panel mode)
	String sTriggerFlipZ = T("|Flip Z alignment|");
	if (nMode == 0)
		addRecalcTrigger(_kContext, sTriggerFlipZ);

	if (nMode == 0 && _bOnRecalc && (_kExecuteKey == sDoubleClick || _kExecuteKey == sTriggerFlipZ))
	{
		reportMessage("\n" + "Z flip triggered");
		vecZ = -vecZ;
		_Map.setVector3d("vecAlign", vecZ);
		setExecutionLoops(2);
	}
	
// create recalc trigger to align vecZ (only in Panel mode)
	String sSetVecZ = T("|Set Z alignment|");
	if (nMode == 0)
		addRecalcTrigger(_kContext, sSetVecZ);

	if (nMode == 0 && _bOnRecalc && _kExecuteKey == sSetVecZ)
	{
		Point3d ptZs[0];
		Point3d ptZ = _Pt0 + vecZ*U(100);
		reportMessage("\n" + "set Z alignment triggered");
		PrPoint ssPtZ (T("|select Z direction|"), _Pt0);
			if (ssPtZ.go()==_kOk)
			{
				ptZs.append(ssPtZ.value());
				ptZ = ptZs[0];
				vecZ = ptZ - _Pt0;
				vecZ = vecZ.crossProduct(sip.vecZ()).crossProduct(-sip.vecZ());
			}
					
		_Map.setVector3d("vecAlign", vecZ);
		setExecutionLoops(2);
	}
	
// tooling _____________________________________________________________________________________________________________________________________________________________
	if (dMillDepth > 0)
	{
		BeamCut bcAnchor (_Pt0, vecX, vecY, vecZ, dWidth+2*dMillOversize, dMillDepth, 2*(dHeight+dMillOversize), 0,-1,0);
		//bcAnchor.cuttingBody().vis(2);
		bcAnchor.addMeToGenBeamsIntersect(gbToMill);
	}
	
	if (nNoNail == 1 && bHasElement == 1 && el.bIsKindOf(ElementWallSF()))
	{
		PLine plNoNail(_Pt0 - vecX*(.5*dWidth+dMillOversize), _Pt0 - vecX*(.5*dWidth+dMillOversize) + vecZ*(dHeight+dMillOversize), _Pt0 + vecX*(.5*dWidth+dMillOversize) + vecZ*(dHeight+dMillOversize), _Pt0 + vecX*(.5*dWidth+dMillOversize));
		plNoNail.close();
		
		for (int i=1; i<6; i++)
		{
			if (el.zone(nSide*i).dH() > 0)
			{
				ElemNoNail enn (nSide*i, plNoNail);
				el.addTool(enn);
			}
		}
	}
	
	
// draw body, that represents the anchor
	_ThisInst.setHyperlink("http://www.rothoblaas.com/products/fastening/brackets-and-plates/shear-angle-brackets-and-plates-for-buildings");
	Display dp (9);
	Point3d ptRef = _Pt0 - vecY*dMillDepth;
	Plane pnNail (ptRef + vecY*(dThickness+U(.1)), vecY);
	PlaneProfile ppNails[0];
	PlaneProfile ppNotNailed[0];
	
	Body bdBottomPlate (ptRef, vecX, vecY, vecZ, dWidth, dDepth, dThickness, 0,1,1);
	if (dHoleDiaBottom != U(5)) // only create the big holes for the screw anchors (the small ones for nails are just displayed as filled circles)
	{
		for (int i=0; i<2; i++)
		{
			int nDir = 1;
			for (int j = 0; j < 2; j++)
			{
				Body bdBottomDrill (ptRef - nDir * vecX*(.5*dWidth-dHoleOffsetBottomSide)+ vecZ * U(100), ptRef - nDir * vecX*(.5*dWidth-dHoleOffsetBottomSide)- vecZ * U(100), .5 * dHoleDiaBottom);
				bdBottomDrill.transformBy(vecY * (i*dHoleInterdistBottom + dHoleOffsetBottom + dThickness));
				bdBottomPlate = bdBottomPlate - bdBottomDrill;
				nDir *= -1;
			}
		}
	}
	
	bdBottomPlate.vis(6);
	
	Body bdTopPlate (ptRef, vecX, vecY, vecZ, dWidth, dThickness, dHeight, 0,1,1);
	Body bdTest (ptRef, vecX, vecY, vecZ, dWidth, U(40), U(800), 0,-1,0);
	bdTest.intersectWith(_GenBeam[0].envelopeBody());
	double dTimberHeightBehind = bdTest.lengthInDirection(vecZ);
	
	bdTest.vis(1);
	
// drills in vertical part (the small ones for the nails, that are not modeled with the body)
	int nQuantDrills = (dWidth-(2*dHoleOffsetTopSide))/U(40)+1;
	
	int nQuantDrillLines = 6;
	int nQuantDrillLinesFull;
	if (nArticle > 2)
	{ 
		if (dTimberHeightBehind >= U(90))
			nQuantDrillLinesFull = 6;
		else if (dTimberHeightBehind >= U(80))
			nQuantDrillLinesFull = 5;
		else if (dTimberHeightBehind >= U(70))
			nQuantDrillLinesFull = 3;
		else if (dTimberHeightBehind >= U(60))
			nQuantDrillLinesFull = 2;
	}
	
	else
	{ 
		if (dTimberHeightBehind >= U(140))
			nQuantDrillLinesFull = 6;
	}
	
	if (nQuantDrillLinesFull < 1)
	{ 
		reportMessage("\n" + T("|Bottom beam's sction height is to small for this anchor|") + " ---> " + T("|Tool will be deleted|"));
		if (!bDebug) eraseInstance();
		return;
	}
	
	
	PLine plDrill;
	plDrill.createCircle(ptRef + vecX*(.5*dWidth - dHoleOffsetTopSide) + vecY * (dThickness+dEps) + vecZ*dHoleOffsetTop, vecY, .5*dHoleDiaTop);
	
	for (int i=0; i<nQuantDrillLines; i++)
	{
		for (int j = 0; j < nQuantDrills; j++)
		{
			int nUneven = i / 2;
			nUneven = i - 2 * nUneven;
			
			PlaneProfile ppNail(plDrill);
			ppNail.transformBy(vecZ * (i * .5 * dHoleInterdistTop) - vecX * (j * U(40) + nUneven * U(20)));
			
			ppNail.vis(6);
			if (i > nQuantDrillLinesFull-1)
				ppNotNailed.append(ppNail);
			else
				ppNails.append(ppNail);
		}
	}
	
// drills in bottom part (the small ones for the nails, that are not modeled with the body)
	PLine plDrillBottom (vecZ);
	plDrillBottom.createCircle(ptRef + vecX*(.5*dWidth - dHoleOffsetBottomSide) + vecY*dHoleOffsetBottom + vecZ * (dThickness+dEps), vecZ, .5*dHoleDiaBottom);
	
	if (dHoleDiaBottom == U(5))
	{
		for (int i = 0; i < 6; i++)
		{
			for (int j = 0; j < nQuantDrills; j++)
			{
				int nUneven = i / 2;
				nUneven = i - 2 * nUneven;
				
				PlaneProfile ppNail(plDrillBottom);
				ppNail.transformBy(vecY * (i * .5 * dHoleInterdistTop) - vecX * (j * U(40) + nUneven * U(20)));
				
				ppNail.vis(6);
				ppNails.append(ppNail);
			}
		}
	}
	
	Body bdAnchor = bdBottomPlate + bdTopPlate;
	dp.draw(bdAnchor);
	
	if (nWasher == 1 && nArticle < 2)
	{
		Body bdWasher (ptRef+vecZ*dThickness+vecY*dThickness, vecX, vecY, vecZ, dWasherWidth, dWasherDepth, dWasherThickness, 0,1,1);
		
		if (dHoleDiaBottom != U(5))
		{
			int nDir = 1;
			for (int i=0; i<2; i++)
			{
				
				Body bdWasherDrill (ptRef - nDir * vecX*(.5*dWidth-dHoleOffsetBottomSide)+ vecZ * U(100), ptRef - nDir * vecX*(.5*dWidth-dHoleOffsetBottomSide)- vecZ * U(100), .5 * dWasherDia);
				bdWasherDrill.transformBy(vecY * (dHoleOffsetBottom + dThickness));
				bdWasher = bdWasher - bdWasherDrill;
				nDir *= -1;
			}
		}
		
		dp.draw(bdWasher);
	}
	
	for (int i=0; i<ppNotNailed.length(); i++)
	{
		dp.draw(ppNotNailed[i]);
	}

	dp.color(1);
				
	for (int i=0; i<ppNails.length(); i++)
	{
		dp.draw(ppNails[i], _kDrawFilled);
	}
	

// hardware _______________________________________________________________________________________________________________________________________________________________
	String sRecalcHardwares[] = {sArticleNameName, sWasherName, sNailTypeName, sMainScrewName};

	if (_bOnDbCreated || sRecalcHardwares.find(_kNameLastChangedProp) >-1)
	{
		HardWrComp hwComps[0];	
			
		String sDescription = T("|Tensile anchor|") + " - " + T("|Type|") + " " + sArticleName;
		
	// anchor itself	
		HardWrComp hw(sArticleNumber , 1);	
		hw.setCategory(T("|Anchor|"));
		hw.setManufacturer("Rothoblaas");
		hw.setName(sArticleName);
		hw.setModel(sArticleName);
		hw.setMaterial(T("|Steel|"));
		hw.setDescription(sDescription);
		hw.setDScaleX(dHeight);
		hw.setDScaleY(dWidth);
		hw.setDScaleZ(dDepth);	
		hwComps.append(hw);
	
	// screws to the wood		
		HardWrComp hwScrewTop(sNailArticle, ppNails.length());	
		hwScrewTop.setCategory(T("|Anchor|"));
		hwScrewTop.setManufacturer("Rothoblaas");
		hwScrewTop.setName(sNailName);
		hwScrewTop.setModel(sNailName);
		hwScrewTop.setMaterial(T("|Steel|"));		
		hwScrewTop.setDescription(sNailType);
		hwScrewTop.setDScaleX(dNailLength);
		hwScrewTop.setDScaleY(dNailDia);
		hwScrewTop.setDScaleZ(0);	
		hwComps.append(hwScrewTop);
		
	// screws to the ground	(only if dHoleDiaBottom > 5mm)	
		if (dHoleDiaBottom > U(5))
		{
			HardWrComp hwScrewBottom(sMainScrewArticle, nMainScrewQuant);
			hwScrewBottom.setCategory(T("|Anchor|"));
			hwScrewBottom.setManufacturer("Rothoblaas");
			hwScrewBottom.setName(sMainScrew);
			hwScrewBottom.setModel("M" + dMainScrewDia);
			hwScrewBottom.setMaterial(T("|Steel|"));
			hwScrewBottom.setDescription(sMainScrew + " M" + dMainScrewDia);
			hwScrewBottom.setDScaleX(0);
			hwScrewBottom.setDScaleY(dMainScrewDia);
			hwScrewBottom.setDScaleZ(0);
			hwComps.append(hwScrewBottom);
		}
		
	// reinforcement washer
		if (nWasher == 1 && (nArticle == 0 ||nArticle == 1))
		{
			HardWrComp hwWasher(sArticleReinfWasher, 1);	
			hwWasher.setCategory(T("|Anchor|"));
			hwWasher.setManufacturer("Rothoblaas");
			hwWasher.setName(sNameReinfWasher);
			hwWasher.setModel(sNameReinfWasher + " d" + dWasherDia);
			hwWasher.setMaterial(T("|Steel|"));		
			hwWasher.setDescription(T("|Washer|") + " " + sNameReinfWasher);
			hwWasher.setDScaleX(dWasherWidth);
			hwWasher.setDScaleY(dWasherDepth);
			hwWasher.setDScaleZ(dWasherThickness);	
			hwComps.append(hwWasher);
		}		

		_ThisInst.setHardWrComps(hwComps);
	}
#End
#BeginThumbnail
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
'E;5%`'__V0``

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
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End