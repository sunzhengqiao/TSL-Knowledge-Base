#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
16.10.2014  -  version 1.04



#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 4
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// 
/// </summary>

/// <insert>
/// -
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.04" date="16.10.2014"></version>

/// <history>
/// AS - 1.00 - 03.07.2014 - 	Pilot version.
/// AS - 1.01 - 03.07.2014 - 	Add sheeting distribution.
/// AS - 1.02 - 10.09.2014 - 	Report infinite loops.
/// AS - 1.03 - 15.09.2014 - 	First row and column were not created.
/// AS - 1.04 - 16.10.2014 - 	Ignore small sheet sizes. Create first and last lath.
/// </hsitory>

double dEps = Unit(0.1, "mm");

PropString sSeparatorLathDistribution(3, "", T("|Lath distribution|"));
sSeparatorLathDistribution.setReadOnly(true);
PropDouble dLathSpacing(2, U(1250)/3, "     "+T("|Spacing|"));
dLathSpacing.setDescription(T("|Sets the spacing between the laths.|"));
PropDouble dLathW(3, U(40), "     "+T("|Beam width|"));
dLathW.setDescription(T("|Sets the width of the laths.|"));
PropDouble dLathStartH(4, U(220), "     "+T("|Maximum beam height|"));
dLathStartH.setDescription(T("|Sets the height of the heighest lath.|"));
PropDouble dSlopePercentage(5, 2, "     "+T("|Slope| [%]"));
dSlopePercentage.setDescription(T("|Sets the slope| [%]."));


PropString sSeparatorLathProperties(4, "", T("|Lath properties|"));
sSeparatorLathProperties.setReadOnly(true);
PropInt nLathColor(2, 52, "     "+T("|Lath color|"));
nLathColor.setDescription(T("|Sets the color of the laths.|"));
PropString sLathName(5, "", "     "+T("|Lath name|"));
sLathName.setDescription(T("|Sets the name of the laths.|"));
PropString sLathMaterial(6, "", "     "+T("|Lath material|"));
sLathMaterial.setDescription(T("|Sets the material of the laths.|"));
PropString sLathGrade(7, "", "     "+T("|Lath grade|"));
sLathGrade.setDescription(T("|Sets the grade of the laths.|"));
PropString sLathInformation(8, "", "     "+T("|Lath information|"));
sLathInformation.setDescription(T("|Sets the information of the laths.|"));
PropString sLathLabel(9, "", "     "+T("|Lath label|"));
sLathLabel.setDescription(T("|Sets the label of the laths.|"));
PropString sLathSubLabel(10, "", "     "+T("|Lath sublabel|"));
sLathSubLabel.setDescription(T("|Sets the sublabel of the laths.|"));
PropString sLathSubLabel2(11, "", "     "+T("|Lath sublabel 2|"));
sLathSubLabel2.setDescription(T("|Sets the sublabel 2 of the laths.|"));
PropString sLathCode(12, "", "     "+T("|Lath code|"));
sLathCode.setDescription(T("|Sets the beam code of the laths.|"));


PropString sSeparatorSheetDistribution(13, "", T("|Sheet distribution|"));
sSeparatorSheetDistribution.setReadOnly(true);
PropDouble dSheetW(6, U(1250), "     "+T("|Sheet width|"));
dSheetW.setDescription(T("|Sets the sheet width|"));
PropDouble dSheetL(7, U(1430), "     "+T("|Sheet length|"));
dSheetL.setDescription(T("|Sets the sheet length|"));
PropDouble dSheetH(8, U(18), "     "+T("|Sheet height|"));
dSheetH.setDescription(T("|Sets the sheet height|"));
PropDouble dSheetGap(9, U(0), "     "+T("|Gap between sheets|"));
dSheetGap.setDescription(T("|Sets the gap between sheets|"));


PropString sSeparatorSheetProperties(14, "", T("|Sheet properties|"));
sSeparatorSheetProperties.setReadOnly(true);
PropInt nSheetColor(3, 60, "     "+T("|Sheet color|"));
nSheetColor.setDescription(T("|Sets the color of the sheets.|"));
PropString sSheetName(15, "", "     "+T("|Sheet name|"));
sSheetName.setDescription(T("|Sets the name of the sheets.|"));
PropString sSheetMaterial(16, "", "     "+T("|Sheet material|"));
sSheetMaterial.setDescription(T("|Sets the material of the sheets.|"));
PropString sSheetGrade(17, "", "     "+T("|Sheet grade|"));
sSheetGrade.setDescription(T("|Sets the grade of the sheets.|"));
PropString sSheetInformation(18, "", "     "+T("|Sheet information|"));
sSheetInformation.setDescription(T("|Sets the information of the sheets.|"));
PropString sSheetLabel(19, "", "     "+T("|Sheet label|"));
sSheetLabel.setDescription(T("|Sets the label of the sheets.|"));
PropString sSheetSubLabel(20, "", "     "+T("|Sheet sublabel|"));
sSheetSubLabel.setDescription(T("|Sets the sublabel of the sheets.|"));
PropString sSheetSubLabel2(21, "", "     "+T("|Sheet sublabel 2|"));
sSheetSubLabel2.setDescription(T("|Sets the sublabel 2 of the sheets.|"));
PropString sSheetCode(22, "", "     "+T("|Sheet code|"));
sSheetCode.setDescription(T("|Sets the beam code of the sheets.|"));



PropString sSeparatorSymbol(1, "", T("|Symbol|"));
sSeparatorSymbol.setReadOnly(true);
PropString sLayerSymbol(2, "0", "     "+T("|Layer symbol|"));
sLayerSymbol.setDescription(T("|Sets the layer for the symbol|"));
PropDouble dSymbolSize(0, U(100), "     "+T("|Symbol size|"));
dSymbolSize.setDescription(T("|Sets the size used to create the symbol.|"));
PropInt nColorSymbol(0, -1, "     "+T("|Color symbol|"));
nColorSymbol.setDescription(T("|Sets the color of the symbol.|"));
PropInt nColorText(1, 1, "     "+T("|Color text|"));
nColorText.setDescription(T("|Sets the color of text next to the symbol.|"));
PropString sDimStyle(0, _DimStyles, "     "+T("|Dimension style|"));
sDimStyle.setDescription(T("|Sets the dimension style.|") + 
	TN("|The text style specified in this dimension style is used.|"));
PropDouble dTextSize(1, -U(1), "     "+T("|Text size|"));
dTextSize.setDescription(T("|Sets the text size.|") + 
	TN("|If set to zero, or less, the text size from the dimsension style is used.|"));


String arSCatalogNames[] = TslInst().getListOfCatalogNames("HSB_R-AngleForFlatRoof");
if( _bOnDbCreated && arSCatalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);

if (_bOnInsert) {
	if (insertCycleCount() > 1) {
		eraseInstance();
		return;
	}
	
	if (_kExecuteKey == "" || arSCatalogNames.find(_kExecuteKey) == -1)
		showDialog();
	
	PrEntity ssE(T("|Select a set of elements|"), ElementRoof());
	if (ssE.go())
		_Element.append(ssE.elementSet());
	
	_Pt0 = getPoint(T("|Select start point for distribution|"));
	
	return;
}

// Are there elements selected? If not: show a message and kill the tsl.
if (_Element.length() == 0) {
	reportMessage(scriptName() + TN("|There are no elements selected.|"));
	eraseInstance();
	return;
}

Element elMain = _Element[0];
CoordSys csElMain = elMain.coordSys();
Point3d ptElMain = csElMain.ptOrg();
Vector3d vxElMain = csElMain.vecX();
Vector3d vyElMain = csElMain.vecY();
Vector3d vzElMain = csElMain.vecZ();

// Project _Pt0 to element.
Plane pnZMain(ptElMain, vzElMain);
_Pt0 = pnZMain.closestPointTo(_Pt0);

Line lnX(_Pt0, vxElMain);
Line lnY(_Pt0, vyElMain);

// The vectors for the beam distribution in zone 1.
Vector3d vxLath = vxElMain;
Vector3d vyLath = vyElMain;
Vector3d vzLath = vzElMain;

// The vectors for the sheet distribution in zone 2.
Vector3d vxSheet = vxElMain;
Vector3d vySheet = vyElMain;
Vector3d vzSheet = vzElMain;

double dSlope = dSlopePercentage/100;

// Display used for debug info.
Display dpDebug(nColorText);
dpDebug.dimStyle(sDimStyle);
if (dTextSize > 0)
	dpDebug.textHeight(dTextSize);

for (int e = 0; e < _Element.length(); e++) {
	Element el = _Element[e];
	
	// Distribute laths in zone 1
	{
		// Delete the genbeams from zone 1
		GenBeam arGBmZn1[] = el.genBeam(1);
		for (int i=0;i<arGBmZn1.length();i++ )
			arGBmZn1[i].dbErase();
			
		// Get the profile without the openings.
		PlaneProfile profBruttoZn1 = el.profBrutto(1);
		profBruttoZn1.vis(e);
			
		// Get the extremes of this area
		Point3d arPtZn1[] = profBruttoZn1.getGripVertexPoints();
		Point3d arPtZn1X[] = lnX.orderPoints(arPtZn1);
		Point3d arPtZn1Y[] = lnY.orderPoints(arPtZn1);
		if ((arPtZn1X.length() * arPtZn1Y.length()) <= 0) {
			reportNotice(TN("|Invalid zone outline for element| ") + el.number() + ".");
			continue;
		}
		
		Point3d ptBL = arPtZn1X[0];
		ptBL += vyElMain * vyElMain.dotProduct(arPtZn1Y[0] - ptBL);
		Point3d ptTR = arPtZn1X[arPtZn1.length() - 1];
		ptTR += vyElMain * vyElMain.dotProduct(arPtZn1Y[arPtZn1Y.length() - 1] - ptTR);
		
		LineSeg lnSegMinMax(ptBL, ptTR);
		lnSegMinMax.vis(e);
		
		Point3d ptStartDistribution = lnSegMinMax.ptMid();
		ptStartDistribution += vyElMain * vyElMain.dotProduct(ptBL - ptStartDistribution);
		
		// Correct start distribution. This point must be 'on grid' with _Pt0.
		double dyBLToPt0 = vyElMain.dotProduct(_Pt0 - ptBL);
		double dNrOfSpacing = dyBLToPt0/dLathSpacing;
		double dCorrection = dNrOfSpacing - int(dNrOfSpacing);
		if (dCorrection < 0)
			dCorrection += 1;
		
		ptStartDistribution += vyElMain * dCorrection * dLathSpacing;
		ptStartDistribution.vis(e);
		
		// Get the profile of zone 1 with the openings.
		PlaneProfile profNettoZn1 = el.profNetto(1);
		profNettoZn1.shrink(-U(0.1));
		
		Point3d arPtLath[0];
		Point3d ptLath = ptStartDistribution;
		int nNrOfExecutions = -1;
		while (vyElMain.dotProduct(ptTR - ptLath) > dLathSpacing) {
			// Set this while loop to a maximum of 100 loops.
			nNrOfExecutions++;	
			if (nNrOfExecutions > 99){
				reportWarning(TN("|Infinite loop detected in| ")+scriptName()+".");
				break;
			}
			ptLath = ptStartDistribution + vyElMain * nNrOfExecutions * dLathSpacing;
			//ptLath.vis(e);
			arPtLath.append(ptLath);
		}
		
		// Add first and last lath.
		if (arPtLath.length()>0) {
			if (vyElMain.dotProduct(arPtLath[0] - ptBL) > (1.5 * dLathW))
				arPtLath.insertAt(0, ptBL + vyElMain * 0.5 * dLathW);
			if (vyElMain.dotProduct(ptTR - arPtLath[arPtLath.length() - 1]) > (1.5 * dLathW))
				arPtLath.append(ptTR - vyElMain * 0.5 * dLathW);
		}
		
		for (int i=0;i<arPtLath.length();i++) {
			Point3d ptLath = arPtLath[i];
			double dLathH = dLathStartH - (abs(vyElMain.dotProduct(_Pt0 - ptLath))/* + 0.5 * dLathW*/)* dSlope;
			if (_bOnDebug)
				dpDebug.draw(dLathH, ptLath, vxElMain, vyElMain, 1, 0);
			
			// Beam extremes
			Point3d ptLathBL = ptLath - vyLath * 0.5 * dLathW;
			ptLathBL += vxLath * vxLath.dotProduct(ptBL - ptLathBL);
			Point3d ptLathTR = ptLath + vyLath * 0.5 * dLathW;
			ptLathTR += vxLath * vxLath.dotProduct(ptTR - ptLathTR);
			
			// Create a pprofile of the beam.
			PLine plLath(vzLath);
			plLath.createRectangle(LineSeg(ptLathBL, ptLathTR), vxLath, vyLath);
			PlaneProfile ppLath(CoordSys(ptLath, vxLath, vyLath, vzLath));
			ppLath.joinRing(plLath, _kAdd);
			// Intersect it with the zone profile. 
			int bIntersect = ppLath.intersectWith(profNettoZn1);
			if (!bIntersect)
				continue;
			//Create beams in the resulting rings.
			if (_bOnDebug)
				dpDebug.draw(ppLath);
			PLine arPlLath[] = ppLath.allRings();
			int arPlIsRing[] = ppLath.ringIsOpening();
			for (int i=0;i<arPlLath.length();i++) {
				if (arPlIsRing[i])
					continue;
				
				PLine plLath = arPlLath[i];
				Body bdLath(plLath, vzLath * dLathH, 1);
				if (_bOnDebug)
					dpDebug.draw(bdLath);
				
				// Create the actual beam.
				Beam lath;
				lath.dbCreate(bdLath, vxLath, vyLath, vzLath);
				lath.assignToElementGroup(el, true, 1, 'Z');
				lath.setColor(nLathColor);
				lath.setName(sLathName);
				lath.setMaterial(sLathMaterial);
				lath.setGrade(sLathGrade);
				lath.setInformation(sLathInformation);
				lath.setLabel(sLathLabel);
				lath.setSubLabel(sLathSubLabel);
				lath.setSubLabel2(sLathSubLabel2);
				lath.setBeamCode(sLathCode);
				lath.setType(_kLath);
				lath.setHsbId("4200");
			}
		}
	}
	
	// Distribute sheets in zone 2
	{
		double dSheetSpacing = dSheetW + dSheetGap;
		// Delete the genbeams from zone 2
		GenBeam arGBmZn[] = el.genBeam(2);
		for (int i=0;i<arGBmZn.length();i++ )
			arGBmZn[i].dbErase();
			
		// Get the profile without the openings.
		PlaneProfile profBruttoZn = el.profBrutto(2);
		profBruttoZn.vis(e);
			
		// Get the extremes of this area
		Point3d arPtZn[] = profBruttoZn.getGripVertexPoints();
		Point3d arPtZnX[] = lnX.orderPoints(arPtZn);
		Point3d arPtZnY[] = lnY.orderPoints(arPtZn);
		if ((arPtZnX.length() * arPtZnY.length()) <= 0) {
			reportNotice(TN("|Invalid zone outline for element| ") + el.number() + ".");
			continue;
		}
		
		Point3d ptBL = arPtZnX[0];
		ptBL += vyElMain * vyElMain.dotProduct(arPtZnY[0] - ptBL);
		Point3d ptTR = arPtZnX[arPtZn.length() - 1];
		ptTR += vyElMain * vyElMain.dotProduct(arPtZnY[arPtZnY.length() - 1] - ptTR);
		
		LineSeg lnSegMinMax(ptBL, ptTR);
		lnSegMinMax.vis(e);
		
		Point3d ptStartDistribution = lnSegMinMax.ptMid();
		ptStartDistribution += vyElMain * vyElMain.dotProduct(ptBL - ptStartDistribution);
		
		// Correct start distribution. This point must be 'on grid' with _Pt0.
		double dyBLToPt0 = vyElMain.dotProduct(_Pt0 - ptBL + vyElMain * 0.5 * dSheetGap);
		double dNrOfSpacing = dyBLToPt0/dSheetSpacing;
		double dCorrection = dNrOfSpacing - int(dNrOfSpacing);
		if (dCorrection < 0)
			dCorrection += 1;
		
		ptStartDistribution += vyElMain * (dCorrection - 1) * dSheetSpacing;
		ptStartDistribution += vxElMain * vxElMain.dotProduct(ptBL - ptStartDistribution);
		ptStartDistribution.vis(e);
		
		Point3d ptSheet = ptStartDistribution;
		int nNrOfExecutions = -1;
		while (vyElMain.dotProduct(ptTR - ptSheet) > dSheetSpacing) {
			// Set this while loop to a maximum of 100 loops.
			nNrOfExecutions++;	
			if (nNrOfExecutions > 99){
				reportWarning(TN("|Infinite loop detected in| ")+scriptName()+".");
				break;
			}
					
			ptSheet = ptStartDistribution + vyElMain * nNrOfExecutions * dSheetSpacing + vzElMain * dLathStartH;
			//ptSheet.vis(e);
			
			// Sheet extremes
			Point3d ptSheetBL = ptSheet;
			Point3d ptSheetTR = ptSheet + vySheet * dSheetW;
			ptSheetTR += vxSheet * vxSheet.dotProduct(ptTR - ptSheetTR);
			
			// Get the profile of zone 1 with the openings.
			PlaneProfile profNettoZn = el.profNetto(2);
			profNettoZn.shrink(-U(0.1));
			
			// Create the profiles for the sheets.
			int nNrOfExecutionsForThisRow = -1;
			while (vxElMain.dotProduct(ptSheetTR - ptSheet) > 0 || nNrOfExecutionsForThisRow == 0) {
				// Set this while loop to a maximum of 100 loops.
				nNrOfExecutionsForThisRow++;	
				if (nNrOfExecutionsForThisRow > 99){
					reportWarning(TN("|Infinite loop detected in| ")+scriptName()+".");
					break;
				}
					
				Point3d ptThisSheetBL = ptSheet;
				Point3d ptThisSheetTR = ptSheet + vxSheet * dSheetL + vySheet * dSheetW;

				// Create a profile for the sheet.
				PLine plSheet(vzSheet);
				plSheet.createRectangle(LineSeg(ptThisSheetBL, ptThisSheetTR), vxSheet, vySheet);
				PlaneProfile ppSheet(CoordSys(ptSheet, vxSheet, vySheet, vzSheet));
				ppSheet.joinRing(plSheet, _kAdd);
				
				int bCreateSheet = true;
				// Intersect it with the zone profile. 
				if (!ppSheet.intersectWith(profNettoZn))
					bCreateSheet = false;
				// Valid size?
				LineSeg lnSegExtends = ppSheet.extentInDir(vxSheet);
				if (abs(vxSheet.dotProduct(lnSegExtends.ptEnd() - lnSegExtends.ptStart())) < U(10))
					bCreateSheet = false;
				if (abs(vySheet.dotProduct(lnSegExtends.ptEnd() - lnSegExtends.ptStart())) < U(10))
					bCreateSheet = false;
				
				if (bCreateSheet) {
					//Create beams in the resulting rings.
					if (_bOnDebug)
						dpDebug.draw(ppSheet);
					
					// Create the actual sheet.
					Sheet sheet;
					sheet.dbCreate(ppSheet, dSheetH, 1);
					sheet.assignToElementGroup(el, true, 2, 'Z');
					sheet.setColor(nSheetColor);
					sheet.setName(sSheetName);
					sheet.setMaterial(sSheetMaterial);
					sheet.setGrade(sSheetGrade);
					sheet.setInformation(sSheetInformation);
					sheet.setLabel(sSheetLabel);
					sheet.setSubLabel(sSheetSubLabel);
					sheet.setSubLabel2(sSheetSubLabel2);
					sheet.setBeamCode(sSheetCode);
					sheet.setType(_kSheeting);
					sheet.setHsbId("4242");
					
					double dAngle = atan(dSlopePercentage, 100.0);
					if (vyElMain.dotProduct(ptSheet - _Pt0) > 0)
						dAngle *= -1;
					// Rotate the sheet.	
					CoordSys csRotate;
					csRotate.setToRotation(dAngle, vxElMain, _Pt0 + vzElMain * dLathStartH);
					sheet.transformBy(csRotate);
				}
				
				// Move to next column.
				ptSheet += vxSheet * dSheetL;
			}
		}
	}	
}

// Draw the symbol.
Display dpText(nColorText);
dpText.layer(sLayerSymbol);
dpText.dimStyle(sDimStyle);
if (dTextSize > 0)
	dpText.textHeight(dTextSize);
Display dpSymbol(nColorSymbol);
dpSymbol.layer(sLayerSymbol);

PLine plStart(vzElMain);
plStart.addVertex(_Pt0 - vxElMain * 0.5 * dSymbolSize);
plStart.addVertex(_Pt0 + vxElMain * 0.5 * dSymbolSize);
dpSymbol.draw(plStart);

PLine plArrow(vzElMain);
plArrow.addVertex(_Pt0);
plArrow.addVertex(_Pt0 + vyElMain * 2 * dSymbolSize);
plArrow.addVertex(_Pt0 + vyElMain * 1.65 * dSymbolSize + vxElMain * 0.35 * dSymbolSize);
plArrow.addVertex(_Pt0 + vyElMain * 2 * dSymbolSize);
plArrow.addVertex(_Pt0 + vyElMain * 1.65 * dSymbolSize - vxElMain * 0.35 * dSymbolSize);
dpSymbol.draw(plArrow);

String sSlope;
sSlope.formatUnit(dSlopePercentage, 2, 0);
sSlope += "%";
Point3d ptText = _Pt0 + vyElMain * dSymbolSize + vxElMain * 0.15 * dSymbolSize;
dpText.draw(sSlope, ptText, vxElMain, vyElMain, 1, 0);

CoordSys csMirror;
csMirror.setToMirroring(Plane(_Pt0, vyElMain));

plArrow.transformBy(csMirror);
dpSymbol.draw(plArrow);
ptText.transformBy(csMirror);
dpText.draw(sSlope, ptText, vxElMain, vyElMain, 1, 0);





#End
#BeginThumbnail
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
4#@''MS7K=>W3FIQYCS9QY'8__]EI
`




#End