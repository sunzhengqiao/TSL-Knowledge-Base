#Version 8
#BeginDescription



#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 0
#KeyWords 
#BeginContents
//Epsylon value; units used in tsl are mm
double dEps = Unit(.1,"mm");

String combinationTypes[] = {
	T("|Length combination|"),
	T("|Width combination|")
};

String arSYesNo[] = {T("|Yes|"), T("|No|")};
int arNYesNo[] = {_kYes, _kNo};

PropString seperator01(0, "", T("|Combination|"));
seperator01.setReadOnly(true);
PropString combinationType(1, combinationTypes, "     "+T("|Combination type|"));
PropDouble gapBetweenElements(0, U(40), "     "+T("|Gap between elements|"));
PropDouble optimizedWidth(2, U(1020), "     "+T("|Optimized width|"));
optimizedWidth.setDescription(T("|Optimize the width of the combination to the specified width|.") + 
										T("|Zero means that the real width is taken|."));
PropDouble extraWidth(3, U(2), "     "+T("|Extra width|"));
//Maximum length of elements
PropDouble dMaxLength(4, U(8000), "     "+T("Maximum length"));
PropDouble dRoundTo(5, U(250), "     "+T("|Round length to|"));

PropString seperator02(2, "", T("|Dimension|"));
seperator02.setReadOnly(true);
PropString dimensionStyle(3, _DimStyles, "     "+T("|Dimension style|"));
PropDouble offsetDimensionLine(1, U(200), "     "+T("|Offset dimension lines|"));

PropString seperator03(4, "", T("|Visualization|"));
seperator03.setReadOnly(true);
PropString sShowOutline(5, arSYesNo, "     "+T("|Show outline|"),1);
PropString sLineTypeBack(6, _LineTypes, "     "+T("|Linetype back|"));



if (_bOnInsert) {
	Element elements[0];
	Group floorGroup = Group();
	
	showDialog();
	
	PrEntity ssE(T("|Select one or two elements|"), ElementRoof());
	if (ssE.go()) {
		Element selectedElements[] = ssE.elementSet();
		
		// Its not allowed to select more than two elements.
		if (selectedElements.length() > 2) {
			reportWarning(TN("|More than two elements selected|.")+TN("|The tsl will be erased|."));
			eraseInstance();
			return;
		}
		
		// Validate if the elements are from the same floorgroup 
		// and if they are not already part of a combination.
		for (int i=0;i<selectedElements.length();i++) {
			Element selectedElement = selectedElements[i];
			
			// The elements must be part of the same floorgroup.
			Group elementGroup = selectedElement.elementGroup();
			if (i==0) {
				floorGroup = Group(elementGroup.namePart(0), elementGroup.namePart(1), "");
			}
			else{
				if (floorGroup.name() != Group(elementGroup.namePart(0), elementGroup.namePart(1), "").name()) {
					reportWarning(TN("|The selected elements are not part of the same floorgroup|!"));
					eraseInstance();
					return;
				}
			}
			
			// The element can only be part of one combination.
			TslInst attachedTsls[] = selectedElement.tslInst();
			for (int i=0;i<attachedTsls.length();i++) {
				TslInst attachedTsl = attachedTsls[i];
				if (attachedTsl.scriptName() == "HSB_E-Combination") {
					reportWarning(TN("|Element| ")+selectedElement.number()+T(" |is already part of a combination|."));
					eraseInstance();
					return;
				}
			}
		}
		
		_Element.append(selectedElements);
	}

	_Pt0 = getPoint(T("|Select a position to visualize the combination|"));
	
	//End of insert
	return;
}

// One or two elements are required.
if (_Element.length() == 0 || _Element.length() > 2) {
	reportWarning(TN("|Invalid number of elements selected|!"));
	eraseInstance();
	return;
}


// Get the floorgroup of the element(s).
Group floorGroup = Group();
for (int i=0;i<_Element.length();i++) {
	Element selectedElement = _Element[i];
	
	// The elements must be part of the same floorgroup.
	Group elementGroup = selectedElement.elementGroup();
	if (i==0) {
		floorGroup = Group(elementGroup.namePart(0), elementGroup.namePart(1), "");
	}
	else{
		if (floorGroup.name() != Group(elementGroup.namePart(0), elementGroup.namePart(1), "").name()) {
			reportWarning(TN("|The selected elements are not part of the same floorgroup|!"));
			eraseInstance();
			return;
		}
	}
}


// Resolve properties
int combinationTypeIndex = combinationTypes.find(combinationType,0);
int bShowOutline = arNYesNo[arSYesNo.find(sShowOutline,1)];


Display dimensionDisplay(-1);
dimensionDisplay.dimStyle(dimensionStyle);
Display visualizationDisplay(-1);
Display idDisplay(-1);
idDisplay.dimStyle(dimensionStyle);
Display outlineBackDisplay(-1);
outlineBackDisplay.lineType(sLineTypeBack);

// Name and subtype of combination element
String combinationElementName;
String combinationElementSubType;

String description;
double width = 0;
double length = 0;
double optimizedLength = 0;
String roofAngle;

if (_Element.length() == 1) {
	// Optimize the single element.
	
}
else{
	// Combine the two elements.
	PLine elementOutlines[0];
	for (int i=0;i<_Element.length();i++) {
		Element el = _Element[i];
		
		PlaneProfile elementProfile = el.profBrutto(0);
		elementProfile.unionWith(el.profBrutto(-1));

		PLine elementRings[] = elementProfile.allRings();
		if (elementRings.length() == 0){
			reportWarning(TN("|Element| ")+el.number()+T(" |has an invalid outline|."));
			eraseInstance();
			return;
		}
		PLine pl = elementRings[0];//el.plEnvelope();
		elementOutlines.append(pl);
		
		// Compose name and sub-type for combination element
		if (i == 0){
			combinationElementName += el.number();
			combinationElementSubType +=el.subType();
			
			double dRoofAngle = _ZW.angleTo(el.vecZ(), el.vecX());
			roofAngle.formatUnit(dRoofAngle, 2, 0);
		}
		else{
			combinationElementName += ("_"+el.number());
			combinationElementSubType +=("/"+el.subType());
		}
		
		//Add element to _Map
		_Map.setEntity("Element "+(i+1), el);
		_Map.setString("Element "+(i+1), el.number());
		
		//Description
		description = el.code();
	}
	
	if (elementOutlines.length() != 2) {
		reportWarning(TN("|Invalid number of plines selected|."));
		eraseInstance();
		return;
	}
	
	CoordSys csMain(_Pt0, _XW, _YW, _ZW);
	Line lnX(csMain.ptOrg(), csMain.vecX());
	Line lnY(csMain.ptOrg(), csMain.vecY());
		
	CoordSys csCombination(_Pt0, _XW, _YW, _ZW);
	double arDRotate[] = {0, 180};
	if (combinationTypeIndex == 1) {// Width combination
		csCombination = CoordSys(_Pt0, -_YW, _XW, _ZW);
		arDRotate.setLength(0);
		arDRotate.append(0);
	}
	
	Element elementA = _Element[0];
	Element elementB = _Element[1];
	CoordSys csElementA = elementA.coordSys();
	CoordSys csElementB = elementB.coordSys();

	double combinationLengths[0];
	double combinationWidths[0];
	PLine arPlCombinationA[0];
	PLine arPlCombinationB[0];
	CoordSys arCsElementAToVisualization[0];
	CoordSys arCsElementBToVisualization[0];
	Point3d bottomLefts[0];
	Point3d topRights[0];
	
	for (int i=0;i<arDRotate.length();i++) {
		double dRotationA = arDRotate[i];
		
		// Transform the poly line to the visualization location of the combination
		CoordSys csElementAToVisualization;
		csElementAToVisualization.setToAlignCoordSys(
			csElementA.ptOrg(), csElementA.vecX(), csElementA.vecY(), csElementA.vecZ(),
			_Pt0, _XU, _YU, _ZU
		);
		PLine plCombinationA = elementOutlines[0];
		plCombinationA.transformBy(csElementAToVisualization);
	
		// Rotate the first pline.
		CoordSys csRotateA;
		csRotateA.setToRotation(dRotationA, csMain.vecZ(), _Pt0);		
		plCombinationA.transformBy(csRotateA);
		csElementAToVisualization.transformBy(csRotateA);
		
		// Move it to _Pt0 again.
		Point3d arPtPlA[] = plCombinationA.vertexPoints(true);
		Point3d arPtPlAX[] = lnX.orderPoints(arPtPlA);
		Point3d arPtPlAY[] = lnY.orderPoints(arPtPlA);
		if ((arPtPlAX.length() * arPtPlAY.length()) <= 0)
			continue;
		Point3d ptPlOrgA = arPtPlAX[0];
		ptPlOrgA += csMain.vecY() * csMain.vecY().dotProduct(arPtPlAY[0] - ptPlOrgA);
		CoordSys csAToPt0;
		csAToPt0.setToTranslation(_Pt0 - ptPlOrgA);
		plCombinationA.transformBy(csAToPt0);
		csElementAToVisualization.transformBy(csAToPt0);
		
		PlaneProfile ppA(csMain);
		ppA.joinRing(plCombinationA, _kAdd);
		
		for (int j=0;j<arDRotate.length();j++) {
			double dRotationB = arDRotate[j];
			
			// Transform the poly line to the visualization location of the combination 
			CoordSys csElementBToVisualization;
			csElementBToVisualization.setToAlignCoordSys(
				csElementB.ptOrg(), csElementB.vecX(), csElementB.vecY(), csElementB.vecZ(),
				_Pt0, _XU, _YU, _ZU
			);
			PLine plCombinationB = elementOutlines[1];
			plCombinationB.transformBy(csElementBToVisualization);
				
			// Rotate the second pline.
			CoordSys csRotateB;
			csRotateB.setToRotation(dRotationB, csMain.vecZ(), _Pt0);
			plCombinationB.transformBy(csRotateB);
			csElementBToVisualization.transformBy(csRotateB);
			
			// Move it to _Pt0 again.
			Point3d arPtPlB[] = plCombinationB.vertexPoints(true);
			Point3d arPtPlBX[] = lnX.orderPoints(arPtPlB);
			Point3d arPtPlBY[] = lnY.orderPoints(arPtPlB);
			if ((arPtPlBX.length() * arPtPlBY.length()) <= 0)
				continue;
			Point3d ptPlOrgB = arPtPlBX[0];
			ptPlOrgB += csMain.vecY() * csMain.vecY().dotProduct(arPtPlBY[0] - ptPlOrgB);
			CoordSys csBToPt0;
			csBToPt0.setToTranslation(_Pt0 - ptPlOrgB);
			plCombinationB.transformBy(csBToPt0);
			csElementBToVisualization.transformBy(csBToPt0);
			
			// Move it outside the first pline.
			// Take an educated guess first.
			CoordSys csFirstMove;
			csFirstMove.setToTranslation(csCombination.vecY() * csCombination.vecY().dotProduct(arPtPlAY[arPtPlAY.length() - 1] - arPtPlAY[0]));
			plCombinationB.transformBy(csFirstMove);
			csElementBToVisualization.transformBy(csFirstMove);
			// The transformation above probably makes the while loop underneath redundant.
			int nNrOfAttempts = 0;
			while (nNrOfAttempts < 25) {
				PlaneProfile ppB(csMain);
				ppB.joinRing(plCombinationB, _kAdd);
				
				int bHasIntersection = ppB.intersectWith(ppA);
				if (!bHasIntersection)
					break;
				
				LineSeg lnSegIntersection = ppB.extentInDir(csCombination.vecY());
				CoordSys csMoveOutA;
				csMoveOutA.setToTranslation(csCombination.vecY() * abs(csMain.vecY().dotProduct(lnSegIntersection.ptEnd() - lnSegIntersection.ptStart())));
				plCombinationB.transformBy(csMoveOutA);
				csElementBToVisualization.transformBy(csMoveOutA);
				
				nNrOfAttempts ++;
			}
			
			// Correct position. Its probably moved out too far.
			double dCorrection;
			int bCorrectionSet = false;
			Point3d arPtA[] = plCombinationA.vertexPoints(true);
			Point3d arPtB[] = plCombinationB.vertexPoints(true);
			
			for (int k=0;k<arPtA.length();k++) {
				Point3d pt = arPtA[k];
				Plane pnPtA(pt, csCombination.vecX());
				Point3d arPtOnB[] = plCombinationB.intersectPoints(pnPtA);
				for (int l=0;l<arPtOnB.length();l++) {
					Point3d ptOnB = arPtOnB[l];
					double dToPtOnB = abs(csCombination.vecY().dotProduct(ptOnB - pt));
					
					if (!bCorrectionSet) {
						bCorrectionSet = true;
						dCorrection = dToPtOnB;
					}
					else if (dToPtOnB < dCorrection) {
						dCorrection = dToPtOnB;
					}
				}
			}
			for (int k=0;k<arPtB.length();k++) {
				Point3d pt = arPtB[k];
				Plane pnPtB(pt, csCombination.vecX());
				Point3d arPtOnA[] = plCombinationA.intersectPoints(pnPtB);
				for (int l=0;l<arPtOnA.length();l++) {
					Point3d ptOnA = arPtOnA[l];
					double dToPtOnA = abs(csCombination.vecY().dotProduct(ptOnA - pt));
					
					if (!bCorrectionSet) {
						bCorrectionSet = true;
						dCorrection = dToPtOnA;
					}
					else if (dToPtOnA < dCorrection) {
						dCorrection = dToPtOnA;
					}
				}
			}
			
			// Correct position
			if (bCorrectionSet){
				plCombinationB.transformBy(-csCombination.vecY() * dCorrection);
				csElementBToVisualization.transformBy(-csCombination.vecY() * dCorrection);
			}
			// Add the gap.
			plCombinationB.transformBy(csCombination.vecY() * gapBetweenElements);
			csElementBToVisualization.transformBy(csCombination.vecY() * gapBetweenElements);
			
			Point3d combinationVertices[0];
			combinationVertices.append(plCombinationA.vertexPoints(true));
			combinationVertices.append(plCombinationB.vertexPoints(true));
			Point3d combinationVerticesX[] = lnX.orderPoints(combinationVertices);
			Point3d combinationVerticesY[] = lnY.orderPoints(combinationVertices);
			
			double combinationLength = csMain.vecY().dotProduct(combinationVerticesY[combinationVerticesY.length() - 1] - combinationVerticesY[0]);
			double combinationWidth = csMain.vecX().dotProduct(combinationVerticesX[combinationVerticesX.length() - 1] - combinationVerticesX[0]);
			if( optimizedWidth > 0 && (combinationWidth - optimizedWidth) > dEps ){
				reportMessage(T("|Invalid width|, ")+T("|skip combination|."));
				continue;
			}
			
			Point3d bottomLeft = combinationVerticesX[0];
			bottomLeft += csMain.vecY() * csMain.vecY().dotProduct(combinationVerticesY[0] - bottomLeft);
			Point3d topRight = combinationVerticesX[combinationVerticesX.length() - 1];
			topRight += csMain.vecY() * csMain.vecY().dotProduct(combinationVerticesY[combinationVerticesY.length() - 1] - topRight);
			
			combinationLengths.append(combinationLength);
			combinationWidths.append(combinationWidth);
			arPlCombinationA.append(plCombinationA);
			arPlCombinationB.append(plCombinationB);			
			arCsElementAToVisualization.append(csElementAToVisualization);
			arCsElementBToVisualization.append(csElementBToVisualization);
			bottomLefts.append(bottomLeft);
			topRights.append(topRight);
		}
	}
	
	for (int s1=1;s1<combinationLengths.length();s1++) { 
		int s11 = s1;
		for (int s2=s1-1;s2>=0;s2--) {
			if (combinationLengths[s11] < combinationLengths[s2]) {
				combinationLengths.swap(s2, s11);
				combinationWidths.swap(s2, s11);
				arPlCombinationA.swap(s2, s11);
				arPlCombinationB.swap(s2, s11);
				arCsElementAToVisualization.swap(s2, s11);
				arCsElementBToVisualization.swap(s2, s11);
				bottomLefts.swap(s2, s11);
				topRights.swap(s2, s11);
				
				s11=s2;
			}
		}
	}
	
	if (combinationLengths.length() == 0){
		reportWarning(TN("|No combinations created|!"));
		eraseInstance();
		return;
	}
	
	Display dpA(1);
	Display dpB(3);
	double dOffset = U(2000);
	for (int i=0;i<combinationLengths.length();i++) {
		double optimalCombinationLength = combinationLengths[i];
		double combinationWidth = combinationWidths[i];
		PLine plCombinationA = arPlCombinationA[i];
		PLine plCombinationB = arPlCombinationB[i];
		CoordSys csElementAToVisualization = arCsElementAToVisualization[i];
		CoordSys csElementBToVisualization = arCsElementBToVisualization[i];
		Point3d bottomLeft = bottomLefts[i] - csMain.vecX() * 0.5 * (extraWidth + (optimizedWidth - combinationWidth));
		Point3d topRight  = topRights[i] + csMain.vecX() * 0.5 * (extraWidth + (optimizedWidth - combinationWidth));
		if( dRoundTo > 0 ){
			double dRound = optimalCombinationLength/dRoundTo;
			if( dRound - (int)dRound > 0.01 ){
				topRight += csMain.vecY() * csMain.vecY().dotProduct(bottomLeft + csMain.vecY() * ((int)dRound + 1) * dRoundTo - topRight);
			}
		}
		
		optimizedLength = csMain.vecY().dotProduct(topRight - bottomLeft);
		
		plCombinationA.transformBy(csMain.vecX() * i * dOffset);
		plCombinationB.transformBy(csMain.vecX() * i * dOffset);
			
//		dpA.draw(plCombinationA);
//		dpB.draw(plCombinationB);
				
		// Add dimension lines to the combination.
		Point3d dimensionPoints[] = {
			bottomLeft,
			topRight
		};
		
		DimLine horizontalDimensionLine(bottomLeft - csMain.vecY() * offsetDimensionLine, csMain.vecX(), csMain.vecY());
		DimLine verticalDimensionLine(bottomLeft - csMain.vecX() * offsetDimensionLine, csMain.vecY(), -csMain.vecX());
		DimLine dimensionLines[] = {
			horizontalDimensionLine,
			verticalDimensionLine
		};
		for (int j=0;j<dimensionLines.length();j++) {
			DimLine dimensionLine = dimensionLines[j];
			Dim dimension(dimensionLine, dimensionPoints, "<>", "<>", _kDimPar, _kDimNone);
			dimensionDisplay.draw(dimension);
		}			
		
		// Create the combination element
		ElementRoof combinationElement;
		if (!_Map.hasEntity("CombinationElement")) {
			PLine combinationElementOutline(csMain.vecZ());
			combinationElementOutline.createRectangle(LineSeg(bottomLeft, topRight), csMain.vecX(), csMain.vecY());
			
			// Create group
			Group combinationElementGroup = floorGroup;
			combinationElementGroup .setNamePart(1, floorGroup.namePart(1) + "-CMB");
			combinationElementGroup .setNamePart(2, "CMB-"+combinationElementName);
			
			// Create Combination-Element
			combinationElement.dbCreate(combinationElementGroup , combinationElementOutline);
			combinationElement.setVecY(csMain.vecY());
			combinationElement.setSubType(combinationElementSubType);
			
			_Map.setEntity("CombinationElement", combinationElement);
		}
		else{
			Entity ent = _Map.getEntity("CombinationElement");
			combinationElement = (ElementRoof)ent;
		}
		_ThisInst.assignToElementGroup(combinationElement, true);
		
		Element arElCombination[] = {
			elementA,
			elementB
		};
		CoordSys arCsElementToVisualization[] = {
			csElementAToVisualization,
			csElementBToVisualization
		};
		
		for( int j=0;j<arElCombination.length();j++ ){
			Element element = arElCombination[j];
			CoordSys csElementToVisualization = arCsElementToVisualization[j];
			
			if( bShowOutline ){
				int outlineIsDrawn = false;
				TslInst arTsl[] = element.tslInst();
				for( int k=0;k<arTsl.length();k++ ){
					TslInst tsl = arTsl[k];
					if( tsl.scriptName() == "UN-ElementOutline" ){
						Map mapTsl = tsl.map();
						if( !mapTsl.hasPLine("Front") || !mapTsl.hasPLine("Back") ){
							reportMessage(TN("|Update UN-ElementOutline|"));
							continue;
						}
						PLine plFront = mapTsl.getPLine("Front");
						Point3d arPtFront[] = plFront.vertexPoints(true);
						Point3d ptCenter = Body(plFront,element.vecZ()).ptCen();
						
						plFront.transformBy(csElementToVisualization);
						visualizationDisplay.color(element.zone(1).color());
						visualizationDisplay.elemZone(element, 1, 'Z');
						visualizationDisplay.draw(plFront);
						
						PLine plBack = mapTsl.getPLine("Back");
						plBack.transformBy(csElementToVisualization);
						outlineBackDisplay.color(element.zone(-1).color());
						outlineBackDisplay.elemZone(element, -1, 'Z');
						outlineBackDisplay.draw(plBack);
						
						Point3d arPtFrontX[] = Line(element.ptOrg(), element.vecX()).orderPoints(arPtFront);
						Point3d arPtFrontY[] = Line(element.ptOrg(), element.vecY()).orderPoints(arPtFront);
						
						Point3d ptMiddle = (arPtFrontX[0] + arPtFrontX[arPtFrontX.length() - 1])/2;
						
						ptMiddle += element.vecY() * element.vecY().dotProduct(ptCenter - ptMiddle);//( 3 * arPtFrontY[0] + arPtFrontY[arPtFrontY.length() - 1])/4 - ptMiddle);
						ptMiddle.transformBy(csElementToVisualization);
						idDisplay.draw(element.number(), ptMiddle, _XW, _YW, 0, 1.5);
						idDisplay.draw(element.subType(), ptMiddle, _XW, _YW, 0, -1.5);
						
						outlineIsDrawn = true;
						break;
					}
				}
				if( !outlineIsDrawn ){
					dpA.draw(plCombinationA);
					dpB.draw(plCombinationB);
				}
			}
			else{
				// Draw element genbeams.
				GenBeam elementGenBeams[] = element.genBeam();
				for (int k=0;k<elementGenBeams.length();k++) {
					GenBeam gBm = elementGenBeams[k];
					Body bdGBm = gBm.realBody();//envelopeBody(false, true);
					bdGBm.transformBy(csElementToVisualization);
					//bdGBm.transformBy( _XW * 2000 * j);
					visualizationDisplay.color(gBm.color());
					visualizationDisplay.elemZone(combinationElement, gBm.myZoneIndex(), 'Z');
					visualizationDisplay.draw(bdGBm);
				}
			}
		}
		
		length = optimalCombinationLength;
		width = combinationWidth;
		
		//Location in combination element
		CoordSys csElInCombination = _Element[0].coordSys();
		csElInCombination.transformBy(csElementAToVisualization );
		Point3d ptElInCombination = csElInCombination.ptOrg();
		Vector3d vxElInCombination = csElInCombination.vecX();
		Vector3d vyElInCombination = csElInCombination.vecY();
		Vector3d vzElInCombination = csElInCombination.vecZ();
		
		Map mapElement;
		mapElement.setEntity("SingleElement", _Element[0]);
		mapElement.setPoint3d("PtOrg", ptElInCombination, _kAbsolute);
		mapElement.setVector3d("VecX", vxElInCombination , _kAbsolute);
		mapElement.setVector3d("VecY", vyElInCombination , _kAbsolute);
		mapElement.setVector3d("VecZ", vzElInCombination , _kAbsolute);
		
		_Map.setMap(_Element[0].number(), mapElement); 
		
		csElInCombination = _Element[1].coordSys();
		csElInCombination.transformBy(csElementBToVisualization );
		ptElInCombination = csElInCombination.ptOrg();
		vxElInCombination = csElInCombination.vecX();
		vyElInCombination = csElInCombination.vecY();
		vzElInCombination = csElInCombination.vecZ();
		
		mapElement = Map();
		mapElement.setEntity("SingleElement", _Element[1]);
		mapElement.setPoint3d("PtOrg", ptElInCombination, _kAbsolute);
		mapElement.setVector3d("VecX", vxElInCombination , _kAbsolute);
		mapElement.setVector3d("VecY", vyElInCombination , _kAbsolute);
		mapElement.setVector3d("VecZ", vzElInCombination , _kAbsolute);
		
		_Map.setMap(_Element[1].number(), mapElement);
		
		break;
	}
}

// Store data for combinations
_Map.setString("Description", description);
_Map.setString("Combination type", combinationType);
_Map.setDouble("Width", width);
_Map.setDouble("Optimized width", optimizedWidth);
_Map.setDouble("Length", length);
_Map.setDouble("Optimized length", optimizedLength);
_Map.setString("EdgeDetail", "|--|");
_Map.setString("RoofAngle", roofAngle);
_Map.setString("ValleyAngle", "0");
_Map.setString("RidgeAngle", "0");



#End
#BeginThumbnail



#End