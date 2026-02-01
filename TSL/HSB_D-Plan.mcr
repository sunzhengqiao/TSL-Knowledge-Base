#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
14.06.2017  -  version 1.03
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 0
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl takes care of the plan dimensioning. It inserts dimension lines for openings, the perimeter and the extremes.
/// </summary>

/// <insert>
/// Select a position
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.03" date="14.06.2017"></version>

/// <history>
/// AS - 1.00 - 17.06.2016 -	Pilot version.
/// AS - 1.01 - 27.09.2016 -	Support mulitple external rings.
/// AS - 1.02 - 27.09.2016 -	Add option to use grid lines as reference.
/// AS - 1.03 - 14.06.2017 -	Add support for panel walls
/// </history>


double vectorTolerance = Unit(0.01, "mm");

String categories[] = {
	T("|Floorgroup|"),
	T("|Constructive beams|"),
	T("|General dimension settings|"),
	T("|Opening dimensions|"),
	T("|Perimeter dimensions|"),
	T("|Overall dimensions|"),
	T("|Name and description|")
};

String yesNo[] = {T("|Yes|"), T("|No|")};

//Floorgroup to dimension
String floorGroupNames[0];
Group floorGroups[0];
Group allGroups[] = Group().allExistingGroups();
for (int g=0;g<allGroups.length();g++) {
	Group grp = allGroups[g];
	if( grp.namePart(2) == "" && grp.namePart(1) != ""){
		floorGroupNames.append(grp.name());
		floorGroups.append(grp);
	}
}
PropString floorGroupName(0, floorGroupNames, T("|Floorgroup|"));
floorGroupName.setCategory(categories[0]);
floorGroupName.setDescription(T("|Specifies the floorgroup to dimension.|"));
// Merge elements in the selected floorgroup if they are within two times the merge distance from each other.
double mergeDistance = U(50);

PropString dimensionStyleConstructiveBeams(1, _DimStyles, T("|Dimension style constructive beams|"));
dimensionStyleConstructiveBeams.setCategory(categories[1]);
dimensionStyleConstructiveBeams.setDescription(T("|Sets the dimension style for the text shown at constructive beams.|"));
PropDouble textSizeConstructiveBeams(0, U(-1), T("|Text size constructive beams|"));
textSizeConstructiveBeams.setCategory(categories[1]);
textSizeConstructiveBeams.setDescription(T("|Sets the text size for the text shown at constructive beams.|") + 
											 TN("|It uses the text size specified in the dimension style if it is set to zero, or less.|"));
PropInt textColorConstructiveBeams(0, -1, T("|Text color constructive beams|"));
textColorConstructiveBeams.setCategory(categories[1]);
textColorConstructiveBeams.setDescription(T("|Sets the text color for the text shown at constructive beams.|"));


PropDouble offsetDimensionLines(1, U(1000), T("|Offset dimension lines|"));
offsetDimensionLines.setCategory(categories[2]);
offsetDimensionLines.setDescription(T("|Sets the offset of the first dimension line to the elements of the selected floorgroup.|"));
PropDouble distanceBetweenDimensionLines(2, U(400), T("|Distance between dimension lines|"));
distanceBetweenDimensionLines.setCategory(categories[2]);
distanceBetweenDimensionLines.setDescription(T("|Sets the distance between the dimension lines.|"));
PropString showInDisplayRepresentation(4, TslInst().dispRepNames(), T("|Show in display representation|"));
showInDisplayRepresentation.setCategory(categories[2]);
showInDisplayRepresentation.setDescription(T("|Sets the display representation for drawing the dimension lines.|"));
PropString floorGroupNameDimensionLines(5, floorGroupNames, T("|Assign dimension lines to group|"));
floorGroupNameDimensionLines.setCategory(categories[2]);
floorGroupNameDimensionLines.setDescription(T("|Sets the floor group for the dimension lines.|"));
PropString useElementOutlineAsFrameOutlineProp(12, yesNo, T("|Use element outline as frame outline|"));
useElementOutlineAsFrameOutlineProp.setCategory(categories[2]);
useElementOutlineAsFrameOutlineProp.setDescription(T("|Specifies if the outline can be used as frame outline or the beams should be used.|"));
PropString gridAsReferenceProp(13, yesNo, T("|Use grid as reference|"),1);
gridAsReferenceProp.setCategory(categories[2]);
gridAsReferenceProp.setDescription(T("|Sets the grid as reference.|") + T(" |This can be overruled per dimension object.|"));
PropDouble gridTolerance(3, U(1000), T("|Grid tolerance|"));
gridTolerance.setCategory(categories[2]);
gridTolerance.setDescription(T("|Extend the extrems with the grid tolerance to find intersecting grid lines.|"));


String scriptNameDimensionTsl  = "HSB_D-Aligned";
String catalogsDimensionTsl[] = TslInst().getListOfCatalogNames(scriptNameDimensionTsl);

PropString catalogOpeningDimensionLines(2, catalogsDimensionTsl, T("|Catalog opening dimension lines|"));
catalogOpeningDimensionLines.setCategory(categories[3]);
catalogOpeningDimensionLines.setDescription(T("|Specifies what catalog to use for the properties of the dimension lines for the openings.|"));
PropString descriptionOpeningDimensionLines(3, T("|Openings|"), T("|Description at opening dimension lines|"));
descriptionOpeningDimensionLines.setCategory(categories[3]);
descriptionOpeningDimensionLines.setDescription(T("|Specifies what description should be made visible next to the dimension lines for the openings.|"));
PropString gridAsReferenceForOpeningsProp(14, yesNo, T("|Use grid as reference for opening dimension lines|"),0);
gridAsReferenceForOpeningsProp.setCategory(categories[3]);
gridAsReferenceForOpeningsProp.setDescription(T("|Sets the grid as reference for opening dimension lines.|"));


PropString catalogPerimeterDimensionLines(6, catalogsDimensionTsl, T("|Catalog perimeter dimension lines|"));
catalogPerimeterDimensionLines.setCategory(categories[4]);
catalogPerimeterDimensionLines.setDescription(T("|Specifies what catalog to use for the properties of the dimension lines for the perimeter.|"));
PropString descriptionPerimeterDimensionLines(7, T("|Perimeter|"), T("|Description at perimeter dimension lines|"));
descriptionPerimeterDimensionLines.setCategory(categories[4]);
descriptionPerimeterDimensionLines.setDescription(T("|Specifies what description should be made visible next to the dimension lines for the perimeter.|"));
PropString gridAsReferenceForPerimeterProp(15, yesNo, T("|Use grid as reference for perimeter dimension lines|"),0);
gridAsReferenceForPerimeterProp.setCategory(categories[4]);
gridAsReferenceForPerimeterProp.setDescription(T("|Sets the grid as reference for perimeter dimension lines.|"));


PropString catalogOverallDimensionLines(8, catalogsDimensionTsl, T("|Catalog overall dimension lines|"));
catalogOverallDimensionLines.setCategory(categories[5]);
catalogOverallDimensionLines.setDescription(T("|Specifies what catalog to use for the properties of the overall dimension lines.|"));
PropString descriptionOverallDimensionLines(9, T("|Overall|"), T("|Description at overall dimension lines|"));
descriptionOverallDimensionLines.setCategory(categories[5]);
descriptionOverallDimensionLines.setDescription(T("|Specifies what description should be made visible next to the overall dimension lines.|"));


PropString instanceDescription(10, "", T("|Description|"));
instanceDescription.setCategory(categories[6]);
instanceDescription.setDescription(T("|Sets the description of this instance.|"));
PropString dimensionStyleName(11, _DimStyles, T("|Dimension style name and description|"));
dimensionStyleName.setCategory(categories[6]);
dimensionStyleName.setDescription(T("|Sets the dimension style used to draw the name and description.|"));
PropInt colorName(1, -1, T("|Color name and description|"));
colorName.setCategory(categories[6]);
colorName.setDescription(T("|Sets the color of the name and description.|"));


// Set properties if inserted with an execute key
String catalogNames[] = TslInst().getListOfCatalogNames("Støren_D-Plan");
if (_kExecuteKey != "" && catalogNames.find(_kExecuteKey) != -1) 
	setPropValuesFromCatalog(_kExecuteKey);

if (_bOnInsert) {
	if (insertCycleCount() > 1) {
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || catalogNames.find(_kExecuteKey) == -1 )
		showDialog();
	setCatalogFromPropValues(T("|_LastInserted|"));
	
	_Pt0 = getPoint(T("|Select position.|"));
	
	return;
}


String recalcTriggers[] = {
	T("|Recalculate dimensions|")
};
for( int i=0;i<recalcTriggers.length();i++ )
	addRecalcTrigger(_kContext, recalcTriggers[i] );

String showInDisplayRepresentations[] = {
	showInDisplayRepresentation
};

Group floorGroup = floorGroups[floorGroupNames.find(floorGroupName,0)];
Group floorGroupDimensionLines = floorGroups[floorGroupNames.find(floorGroupNameDimensionLines,0)];

_ThisInst.assignToLayer("0");
// First we assign it to the tooling layer, which is a no-plot layer. We draw the name on that layer. Later we will assign te tsl to the dimension layer.
floorGroupDimensionLines.addEntity(_ThisInst, true, 0, 'T');
String instanceToolingLayer = _ThisInst.layerName();

// Draw the name and description
String instanceNameAndDescription = _ThisInst.scriptName();
if( instanceDescription.length() > 0 )
	instanceNameAndDescription += (" - "+instanceDescription);

// Draw in specified display representations
for (int d=0;d<showInDisplayRepresentations.length();d++) {
	String displayRepresentation = showInDisplayRepresentations[d];

	Display nameDisplay(colorName);
	nameDisplay.dimStyle(dimensionStyleName);
	nameDisplay.layer(instanceToolingLayer);
	nameDisplay.showInDispRep(displayRepresentation);
	nameDisplay.draw(instanceNameAndDescription, _Pt0, _XW, _YW, 1, 2);
	nameDisplay.draw(floorGroupNameDimensionLines, _Pt0, _XW, _YW, 1, -1);
}

int useElementOutlineAsFrameOutline = (yesNo.find(useElementOutlineAsFrameOutlineProp) == 0);

//Assign the instance to the dimension layer.
floorGroupDimensionLines.addEntity(_ThisInst, true, 0, 'D');


CoordSys floorCoordSys(_PtW, _XW, _YW, _ZW);

// Get all the extrusion profiles from this floorgroup. Only take the ones which are not part of an element.
Entity floorGroupBeamEntities[] = floorGroup.collectEntities(true, Beam(), _kModelSpace);
for (int e=0;e<floorGroupBeamEntities.length();e++) {
	Beam bm = (Beam)floorGroupBeamEntities[e];
	if (!bm.bIsValid())
		continue;
	
	if (bm.bIsDummy())
		continue;
	
	Element el = bm.element();
	if (el.bIsValid())
		continue;
	
	String informationToDisplay = bm.extrProfile() + ", L=" + String().formatUnit(bm.solidLength(), 2, 0) + "mm";
	
	Point3d textPosition = bm.ptCenSolid();
	Vector3d textDirection = bm.vecX();
	Vector3d textUpDirection = _ZW.crossProduct(textDirection);
	textUpDirection.normalize();
	// Correct the read direction if needed.
	if (textUpDirection.dotProduct(-_XW + _YW) < 0) {
		textDirection *= -1;
		textUpDirection *= -1;
	}
	double horizontalAlignment = 0;
	double verticalAlignment = 3.5;
	
	for (int d=0;d<showInDisplayRepresentations.length();d++) {
		String displayRepresentation = showInDisplayRepresentations[d];
		
		Display constructiveBeamsDisplay(textColorConstructiveBeams);
		constructiveBeamsDisplay.showInDispRep(displayRepresentation);
		constructiveBeamsDisplay.dimStyle(dimensionStyleConstructiveBeams);
		if (textSizeConstructiveBeams > 0)
			constructiveBeamsDisplay.textHeight(textSizeConstructiveBeams);
		
		constructiveBeamsDisplay.draw(informationToDisplay, textPosition, textDirection, textUpDirection, horizontalAlignment, verticalAlignment);
	}
}

// Get all the elements from this group and calculate the extremes. The extremes are used to offset the dimension lines.
Entity floorGroupElementEntities[] = floorGroup.collectEntities(false, Element(), _kModelSpace);
PlaneProfile floorProfile(floorCoordSys);
Element elements[0];
Opening openings[0];
PlaneProfile elementProfiles[0];
int floorGroupContainsWalls = false;
int floorGroupContainsFloors = false;
for (int e=0;e<floorGroupElementEntities.length();e++) {
	Element el = (Element)floorGroupElementEntities[e];
	if (!el.bIsValid())
		continue;
	
	ElementRoof elRf = (ElementRoof)el;
	int elementIsARoof = false;
	int elementIsAFloor = false;
	if (elRf.bIsValid()) {
		elementIsAFloor = elRf.bIsAFloor();
		elementIsARoof = !elementIsAFloor;
	}
	int elementIsAWall = el.bIsA(ElementWallSF());
	int elementIsALogWall = el.bIsA(ElementLog());
	int elementIsAPanelWall = !(elementIsAFloor || elementIsALogWall || elementIsARoof || elementIsAWall);
	
	if (elementIsAFloor)
		floorGroupContainsFloors = true;

	Point3d elOrg = el.coordSys().ptOrg();
	Vector3d elX = el.coordSys().vecX();
	Vector3d elY = el.coordSys().vecY();
	Vector3d elZ = el.coordSys().vecZ();
	
	PlaneProfile elementProfile(floorCoordSys);
	
	if (elementIsAWall || elementIsALogWall || elementIsAPanelWall) 
	{
		floorGroupContainsWalls = true;
		Point3d elementFrameVertices[0];
		
		if (useElementOutlineAsFrameOutline) {
			elementFrameVertices = el.plOutlineWall().vertexPoints(true);
		}
		else
		{
			GenBeam genBeams[0];
			if (elementIsAWall || elementIsALogWall)
			{
				Beam beams[] = el.beam();
				for (int b=0;b<beams.length();b++)
					genBeams.append(beams[b]);
			}
			else if (elementIsAPanelWall)
			{
				Sip sips[] = el.sip();
				for (int s=0;s<sips.length();s++)
					genBeams.append(sips[s]);
			}
			
			for (int g=0;g<genBeams.length();g++) {
				GenBeam gBm = genBeams[g];
				// Ignore beams outside boundaries of zone 0.
				if (elZ.dotProduct(gBm.ptCen() - elOrg) > 0)
					continue;
				if (elZ.dotProduct(el.zone(-1).coordSys().ptOrg() - gBm.ptCen()) > 0)
					continue;
				
				elementFrameVertices.append(gBm.envelopeBody().allVertices());
			}
		}
		
		Point3d elementFrameVerticesX[] = Line(elOrg, elX).orderPoints(elementFrameVertices);
		Point3d elementFrameVerticesY[] = Line(elOrg, elY).orderPoints(elementFrameVertices);
		Point3d elementFrameVerticesZ[] = Line(elOrg, elZ).orderPoints(elementFrameVertices);
		if (elementFrameVerticesX.length() == 0 || elementFrameVerticesX.length() == 0 || elementFrameVerticesX.length() == 0)
			continue;
		
		Point3d min = elementFrameVerticesX[0];
		min += elY * elY.dotProduct(elementFrameVerticesY[0] - min);
		min += elZ * elZ.dotProduct(elementFrameVerticesZ[0] - min);
		
		Point3d max = elementFrameVerticesX[elementFrameVerticesX.length() - 1];
		max += elY * elY.dotProduct(elementFrameVerticesY[elementFrameVerticesY.length() - 1] - max);
		max += elZ * elZ.dotProduct(elementFrameVerticesZ[elementFrameVerticesZ.length() - 1] - max);
		
		LineSeg minMaxSegment(min, max);
	//	minMaxSegment.vis(1);

		PLine elementOutline(elY);
		elementOutline.createRectangle(minMaxSegment, elX, -elZ);
		elementProfile.joinRing(elementOutline, _kAdd);
	}
	else {
		elementProfile = el.profNetto(0);
	}
//	elementOutline.vis(3);	
	elementProfile.shrink(-mergeDistance);
	floorProfile.unionWith(elementProfile);
	
	// Store the element and the profile.
	elements.append(el);
	elementProfiles.append(elementProfile);
	openings.append(el.opening());
}

floorProfile.shrink(mergeDistance);
floorProfile.vis(5);

LineSeg floorDiagonal = floorProfile.extentInDir(_XW);
floorDiagonal.vis(2);
Point3d floorMin = floorDiagonal.ptStart();
Point3d floorMax = floorDiagonal.ptEnd();
floorMin.vis(1);
floorMax.vis(1);
Point3d floorCenter = (floorMin + floorMax)/2;

// The extremes of the floorplan.
Point3d extremes[] = {
	floorMin,
	floorMax
};

// Grid lines between the extremes (+ offset).
Grid floorGrid = floorGroup.grid();

CoordSys csGrid = floorGrid.coordSys();
Vector3d gridX = csGrid.vecX();
Vector3d gridY = csGrid.vecY();

Point3d gridIntersectionsX[] = floorGrid.intersectPoints(LineSeg(floorMin, floorMax), gridX, gridTolerance);
Point3d gridIntersectionsY[] = floorGrid.intersectPoints(LineSeg(floorMin, floorMax), gridY, gridTolerance);


// Perimeter vertices
Point3d perimeterLeft[0];
Point3d perimeterBottom[0];
Point3d perimeterRight[0];
Point3d perimeterTop[0];
PLine floorRings[] = floorProfile.allRings();
int floorRingIsOpening[] = floorProfile.ringIsOpening();

PLine outerRings[0];
PLine openingRings[0];
for (int r=0;r<floorRings.length();r++) {
	PLine ring = floorRings[r];
	
	if (floorRingIsOpening[r]) {
		openingRings.append(ring);
		continue;
	}
	
	Point3d floorVertices[] = ring.vertexPoints(true);
	if (floorVertices.length() == 0)
		continue;
	
	outerRings.append(ring);
	
	floorVertices.append(floorVertices[0]);
	for (int v=0;v<(floorVertices.length() - 1);v++) {
		Point3d from = floorVertices[v];
		Point3d to = floorVertices[v+1];
		Point3d mid = (from + to)/2;
		
		Vector3d direction(to-from);
		if (direction.length() < U(5))
			continue;	
		direction.normalize();
		
		Vector3d normal = -_ZW.crossProduct(direction);
		Point3d intersectingPoints[] = ring.intersectPoints(mid, normal);
		if (intersectingPoints.length() > 0) {
			if (normal.dotProduct(intersectingPoints[intersectingPoints.length() - 1] - mid) > U(50))
				continue;
		}
		normal.vis(mid, v);
		
		double normalX = _XW.dotProduct(normal);
		double normalY = _YW.dotProduct(normal);
		
		if (abs(normalX) < vectorTolerance) { // horizontal
			if (normalY < 0) {// bottom
				perimeterBottom.append(from);
				perimeterBottom.append(to);
			}
			else{ // top
				perimeterTop.append(from);
				perimeterTop.append(to);
			}
		}
		else if (abs(normalY) < vectorTolerance) { // vertical
			if (normalX < 0) {// left
				perimeterLeft.append(from);
				perimeterLeft.append(to);
			}
			else{ // right
				perimeterRight.append(from);
				perimeterRight.append(to);
			}
		}
	}
}

// Opening vertices
Point3d openingLeft[0];
Point3d openingBottom[0];
Point3d openingRight[0];
Point3d openingTop[0];

if (floorGroupContainsWalls) {
	PlaneProfile shrinkedOutline(floorCoordSys);
	for (int r=0;r<outerRings.length();r++) {
		PLine outerRing = outerRings[r];
		shrinkedOutline.joinRing(outerRing, _kAdd);
	}
	shrinkedOutline.shrink(U(25));
	shrinkedOutline.vis(3);
	
	for (int o=0;o<openings.length();o++) {
		Opening op = openings[o];
		if (!op.bIsValid())
			continue;
		
		Element el = op.element();
		if (!el.bIsValid())
			continue;
		
		Point3d elOrg  =el.coordSys().ptOrg();
		Vector3d elX = el.coordSys().vecX();
		Vector3d elY = el.coordSys().vecY();
		Vector3d elZ = el.coordSys().vecZ();
		
		PLine openingOutline = op.plShape();
		
		Point3d openingVertices[] = openingOutline.vertexPoints(true);
		openingVertices = Line(elOrg, elX).projectPoints(openingVertices);
		openingVertices = Line(elOrg, elX).orderPoints(openingVertices);
		
		if (openingVertices.length() == 0)
			continue;
		
		double gapSide;
		OpeningSF opSf = (OpeningSF)op;
		if (opSf.bIsValid())
			gapSide = opSf.dGapSide();
		
		Vector3d normal = elZ;
		Point3d left = openingVertices[0] - elX * gapSide; 
		Point3d right = openingVertices[openingVertices.length() - 1] + elX * gapSide; 
		Point3d mid = (left+right)/2;
		if (shrinkedOutline.pointInProfile(mid) != _kPointOutsideProfile)
			continue;
			
		int validOpeningPosition = false;
		for (int r=0;r<outerRings.length();r++) {
			PLine outerRing = outerRings[r];
			
			Point3d intersectingPoints[] = outerRing.intersectPoints(mid, normal);
			if (intersectingPoints.length() > 0) {
				if (normal.dotProduct(intersectingPoints[intersectingPoints.length() - 1] - mid) <= U(50))
					validOpeningPosition = true;
			}
		}
		
		if (!validOpeningPosition)
			continue;
		
		double normalX = _XW.dotProduct(normal);
		double normalY = _YW.dotProduct(normal);
		
		if (abs(normalX) < vectorTolerance) { // horizontal
			if (normalY < 0) {// bottom
				openingBottom.append(left);
				openingBottom.append(right);
			}
			else{ // top
				openingTop.append(left);
				openingTop.append(right);
			}
		}
		else if (abs(normalY) < vectorTolerance) { // vertical
			if (normalX < 0) {// left
				openingLeft.append(left);
				openingLeft.append(right);
			}
			else{ // right
				openingRight.append(left);
				openingRight.append(right);
			}
		}
	}
	
	if (openingLeft.length() > 0)
		openingLeft.append(perimeterLeft);
	if (openingRight.length() > 0)
		openingRight.append(perimeterRight);
	if (openingBottom.length() > 0)
		openingBottom.append(perimeterBottom);
	if (openingTop.length() > 0)
		openingTop.append(perimeterTop);
}
if (floorGroupContainsFloors) {
	for (int r=0;r < openingRings.length();r++) {
		Point3d openingVertices[] = openingRings[r].vertexPoints(true);
		
		for (int v=0;v < openingVertices.length();v++) {
			Point3d pt = openingVertices[v];
			
			double xOffsetFromCenter = _XW.dotProduct(pt - floorCenter);
			if (xOffsetFromCenter < 0)
				openingLeft.append(pt);
			else
				openingRight.append(pt);
			
			double yOffsetFromCenter = _YW.dotProduct(pt - floorCenter);
			if (yOffsetFromCenter < 0)
				openingBottom.append(pt);
			else
				openingTop.append(pt);
		}
	}
}

int useGridAsReference = yesNo.find(gridAsReferenceProp) == 0;
int useGridAsReferenceForOpenings = (useGridAsReference && yesNo.find(gridAsReferenceForOpeningsProp) == 0);
int useGridAsReferenceForPerimeter = (useGridAsReference && yesNo.find(gridAsReferenceForPerimeterProp) == 0);


int recalculateDimlines = false;
if (!_Map.hasEntity("Dimension"))
	recalculateDimlines = true;

// On recalc dimension lines trigger
if (_kExecuteKey == recalcTriggers[0])
	recalculateDimlines = true;

// Create or recalculate the dimension lines
if (recalculateDimlines) {
	

	// Delete existing dimension lines.
	for (int i=0;i<_Map.length();i++) {
		if (_Map.keyAt(i) != "Dimension" || !_Map.hasEntity(i))
			continue;
		
		Entity dimensionEntity = _Map.getEntity(i);
		int isLocked = false;
		if (dimensionEntity.subMapXKeys().find("MasterInfo")) {
			Map masterInfo = dimensionEntity.subMapX("MasterInfo");
			isLocked = masterInfo.getInt("Locked");
		}
		
		if (!isLocked) {
			dimensionEntity.dbErase();		
			_Map.removeAt(i, true);
			i--;
		}
	}
	
	Element lstElements[0];
	Beam lstBeams[0];
	Point3d lstPoints[0];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
	Map mapTsl;
	
	Vector3d dimensionDirection;
	Vector3d dimensionUpDirection;
	
	Point3d dimensionPositionLeft = floorMin - _XW * offsetDimensionLines;
	Point3d dimensionPositionBottom = floorMin - _YW * offsetDimensionLines;
	Point3d dimensionPositionRight = floorMax + _XW * offsetDimensionLines;
	Point3d dimensionPositionTop = floorMax + _YW * offsetDimensionLines;
	
	Line lineLeft(floorMin, _YW);
	Line lineBottom(floorMin, _XW);
	Line lineRight(floorMax, _YW);
	Line lineTop(floorMax, _XW);
	
	Map dimensionLineDefinitions;
	Map dimensionLineDefinition;
		
	// Opening left
	if (openingLeft.length() > 0) {
		if (useGridAsReferenceForOpenings)
			openingLeft.append(gridIntersectionsY);

		dimensionLineDefinition = Map();
		dimensionLineDefinition.setPoint3d("Position", dimensionPositionLeft, _kAbsolute);
		dimensionLineDefinition.setPoint3d("Direction", _YW, _kAbsolute);
		dimensionLineDefinition.setPoint3d("UpDirection", -_XW, _kAbsolute);
		dimensionLineDefinition.setPoint3dArray("Points", openingLeft);
		dimensionLineDefinition.setString("Catalog", catalogOpeningDimensionLines);
		dimensionLineDefinition.setString("Description", descriptionOpeningDimensionLines);
		dimensionLineDefinition.setPoint3d("ProjectPointsTo", floorMin, _kAbsolute);
		
		dimensionLineDefinitions.appendMap("DimensionLineDefinition", dimensionLineDefinition);
		
		dimensionPositionLeft -= _XW * distanceBetweenDimensionLines;
	}
	// Opening bottom
	if (openingBottom.length() > 0) {
		if (useGridAsReferenceForOpenings)
			openingBottom.append(gridIntersectionsX);

		dimensionLineDefinition = Map();
		dimensionLineDefinition.setPoint3d("Position", dimensionPositionBottom, _kAbsolute);
		dimensionLineDefinition.setPoint3d("Direction", _XW, _kAbsolute);
		dimensionLineDefinition.setPoint3d("UpDirection", _YW, _kAbsolute);
		dimensionLineDefinition.setPoint3dArray("Points", openingBottom);
		dimensionLineDefinition.setString("Catalog", catalogOpeningDimensionLines);
		dimensionLineDefinition.setString("Description", descriptionOpeningDimensionLines);
		dimensionLineDefinition.setPoint3d("ProjectPointsTo", floorMin, _kAbsolute);

		dimensionLineDefinitions.appendMap("DimensionLineDefinition", dimensionLineDefinition);
		
		dimensionPositionBottom -= _YW * distanceBetweenDimensionLines;
	}
	// Opening right
	if (openingRight.length() > 0) {
		if (useGridAsReferenceForOpenings)
			openingRight.append(gridIntersectionsY);
			
		dimensionLineDefinition = Map();
		dimensionLineDefinition.setPoint3d("Position", dimensionPositionRight, _kAbsolute);
		dimensionLineDefinition.setPoint3d("Direction", _YW, _kAbsolute);
		dimensionLineDefinition.setPoint3d("UpDirection", -_XW, _kAbsolute);
		dimensionLineDefinition.setPoint3dArray("Points", openingRight);
		dimensionLineDefinition.setString("Catalog", catalogOpeningDimensionLines);
		dimensionLineDefinition.setString("Description", descriptionOpeningDimensionLines);
		dimensionLineDefinition.setPoint3d("ProjectPointsTo", floorMax, _kAbsolute);

		dimensionLineDefinitions.appendMap("DimensionLineDefinition", dimensionLineDefinition);
		
		dimensionPositionRight += _XW * distanceBetweenDimensionLines;
	}
	// Opening top
	if (openingTop.length() > 0) {
		if (useGridAsReferenceForOpenings)
			openingTop.append(gridIntersectionsX);
			
		dimensionLineDefinition = Map();
		dimensionLineDefinition.setPoint3d("Position", dimensionPositionTop, _kAbsolute);
		dimensionLineDefinition.setPoint3d("Direction", _XW, _kAbsolute);
		dimensionLineDefinition.setPoint3d("UpDirection", _YW, _kAbsolute);
		dimensionLineDefinition.setPoint3dArray("Points", openingTop);
		dimensionLineDefinition.setString("Catalog", catalogOpeningDimensionLines);
		dimensionLineDefinition.setString("Description", descriptionOpeningDimensionLines);
		dimensionLineDefinition.setPoint3d("ProjectPointsTo", floorMax, _kAbsolute);

		dimensionLineDefinitions.appendMap("DimensionLineDefinition", dimensionLineDefinition);
		
		dimensionPositionTop += _YW * distanceBetweenDimensionLines;
	}
	
	// Perimeter left
	if (perimeterLeft.length() > 0) {
		if (useGridAsReferenceForPerimeter)
			perimeterLeft.append(gridIntersectionsY);
			
		dimensionLineDefinition = Map();
		dimensionLineDefinition.setPoint3d("Position", dimensionPositionLeft, _kAbsolute);
		dimensionLineDefinition.setPoint3d("Direction", _YW, _kAbsolute);
		dimensionLineDefinition.setPoint3d("UpDirection", -_XW, _kAbsolute);
		dimensionLineDefinition.setPoint3dArray("Points", perimeterLeft);
		dimensionLineDefinition.setString("Catalog", catalogPerimeterDimensionLines);
		dimensionLineDefinition.setString("Description", descriptionPerimeterDimensionLines);
		dimensionLineDefinition.setPoint3d("ProjectPointsTo", floorMin, _kAbsolute);
		
		dimensionLineDefinitions.appendMap("DimensionLineDefinition", dimensionLineDefinition);
		
		dimensionPositionLeft -= _XW * distanceBetweenDimensionLines;
	}

	// Perimeter bottom
	if (perimeterBottom.length() > 0) {
		if (useGridAsReferenceForPerimeter)
			perimeterBottom.append(gridIntersectionsX);
			
		dimensionLineDefinition = Map();
		dimensionLineDefinition.setPoint3d("Position", dimensionPositionBottom, _kAbsolute);
		dimensionLineDefinition.setPoint3d("Direction", _XW, _kAbsolute);
		dimensionLineDefinition.setPoint3d("UpDirection", _YW, _kAbsolute);
		dimensionLineDefinition.setPoint3dArray("Points", perimeterBottom);
		dimensionLineDefinition.setString("Catalog", catalogPerimeterDimensionLines);
		dimensionLineDefinition.setString("Description", descriptionPerimeterDimensionLines);
		dimensionLineDefinition.setPoint3d("ProjectPointsTo", floorMin, _kAbsolute);

		dimensionLineDefinitions.appendMap("DimensionLineDefinition", dimensionLineDefinition);
		
		dimensionPositionBottom -= _YW * distanceBetweenDimensionLines;
	}
	// Perimeter right
	if (perimeterRight.length() > 0) {
		if (useGridAsReferenceForPerimeter)
			perimeterRight.append(gridIntersectionsY);
			
		dimensionLineDefinition = Map();
		dimensionLineDefinition.setPoint3d("Position", dimensionPositionRight, _kAbsolute);
		dimensionLineDefinition.setPoint3d("Direction", _YW, _kAbsolute);
		dimensionLineDefinition.setPoint3d("UpDirection", -_XW, _kAbsolute);
		dimensionLineDefinition.setPoint3dArray("Points", perimeterRight);
		dimensionLineDefinition.setString("Catalog", catalogPerimeterDimensionLines);
		dimensionLineDefinition.setString("Description", descriptionPerimeterDimensionLines);
		dimensionLineDefinition.setPoint3d("ProjectPointsTo", floorMax, _kAbsolute);

		dimensionLineDefinitions.appendMap("DimensionLineDefinition", dimensionLineDefinition);
		
		dimensionPositionRight += _XW * distanceBetweenDimensionLines;
	}
	// Perimeter top
	if (perimeterTop.length() > 0) {
		if (useGridAsReferenceForPerimeter)
			perimeterTop.append(gridIntersectionsX);
			
		dimensionLineDefinition = Map();
		dimensionLineDefinition.setPoint3d("Position", dimensionPositionTop, _kAbsolute);
		dimensionLineDefinition.setPoint3d("Direction", _XW, _kAbsolute);
		dimensionLineDefinition.setPoint3d("UpDirection", _YW, _kAbsolute);
		dimensionLineDefinition.setPoint3dArray("Points", perimeterTop);
		dimensionLineDefinition.setString("Catalog", catalogPerimeterDimensionLines);
		dimensionLineDefinition.setString("Description", descriptionPerimeterDimensionLines);
		dimensionLineDefinition.setPoint3d("ProjectPointsTo", floorMax, _kAbsolute);

		dimensionLineDefinitions.appendMap("DimensionLineDefinition", dimensionLineDefinition);
		
		dimensionPositionTop += _YW * distanceBetweenDimensionLines;
	}

	// Overall left
	if (extremes.length() > 0) {			
		dimensionLineDefinition = Map();
		dimensionLineDefinition.setPoint3d("Position", dimensionPositionLeft, _kAbsolute);
		dimensionLineDefinition.setPoint3d("Direction", _YW, _kAbsolute);
		dimensionLineDefinition.setPoint3d("UpDirection", -_XW, _kAbsolute);
		dimensionLineDefinition.setPoint3dArray("Points", extremes);
		dimensionLineDefinition.setString("Catalog", catalogOverallDimensionLines);
		dimensionLineDefinition.setString("Description", descriptionOverallDimensionLines);
		dimensionLineDefinition.setPoint3d("ProjectPointsTo", floorMin, _kAbsolute);
		
		dimensionLineDefinitions.appendMap("DimensionLineDefinition", dimensionLineDefinition);
		
		dimensionPositionLeft -= _XW * distanceBetweenDimensionLines;
	}

	// Overall bottom
	if (extremes.length() > 0) {
		dimensionLineDefinition = Map();
		dimensionLineDefinition.setPoint3d("Position", dimensionPositionBottom, _kAbsolute);
		dimensionLineDefinition.setPoint3d("Direction", _XW, _kAbsolute);
		dimensionLineDefinition.setPoint3d("UpDirection", _YW, _kAbsolute);
		dimensionLineDefinition.setPoint3dArray("Points", extremes);
		dimensionLineDefinition.setString("Catalog", catalogOverallDimensionLines);
		dimensionLineDefinition.setString("Description", descriptionOverallDimensionLines);
		dimensionLineDefinition.setPoint3d("ProjectPointsTo", floorMin, _kAbsolute);

		dimensionLineDefinitions.appendMap("DimensionLineDefinition", dimensionLineDefinition);
		
		dimensionPositionBottom -= _YW * distanceBetweenDimensionLines;
	}
	// Overall right
	if (extremes.length() > 0) {
		dimensionLineDefinition = Map();
		dimensionLineDefinition.setPoint3d("Position", dimensionPositionRight, _kAbsolute);
		dimensionLineDefinition.setPoint3d("Direction", _YW, _kAbsolute);
		dimensionLineDefinition.setPoint3d("UpDirection", -_XW, _kAbsolute);
		dimensionLineDefinition.setPoint3dArray("Points", extremes);
		dimensionLineDefinition.setString("Catalog", catalogOverallDimensionLines);
		dimensionLineDefinition.setString("Description", descriptionOverallDimensionLines);
		dimensionLineDefinition.setPoint3d("ProjectPointsTo", floorMax, _kAbsolute);

		dimensionLineDefinitions.appendMap("DimensionLineDefinition", dimensionLineDefinition);
		
		dimensionPositionRight += _XW * distanceBetweenDimensionLines;
	}
	// Overall top
	if (extremes.length() > 0) {
		dimensionLineDefinition = Map();
		dimensionLineDefinition.setPoint3d("Position", dimensionPositionTop, _kAbsolute);
		dimensionLineDefinition.setPoint3d("Direction", _XW, _kAbsolute);
		dimensionLineDefinition.setPoint3d("UpDirection", _YW, _kAbsolute);
		dimensionLineDefinition.setPoint3dArray("Points", extremes);
		dimensionLineDefinition.setString("Catalog", catalogOverallDimensionLines);
		dimensionLineDefinition.setString("Description", descriptionOverallDimensionLines);
		dimensionLineDefinition.setPoint3d("ProjectPointsTo", floorMax, _kAbsolute);

		dimensionLineDefinitions.appendMap("DimensionLineDefinition", dimensionLineDefinition);
		
		dimensionPositionTop += _YW * distanceBetweenDimensionLines;
	}
	
	
	Point3d refereceStart[] = {
		floorMin
	};
	Point3d refereceEnd[] = {
		floorMax
	};
	for (int d=0;d<dimensionLineDefinitions.length();d++) {
		if (!dimensionLineDefinitions.hasMap(d) || dimensionLineDefinitions.keyAt(d) != "DimensionLineDefinition")
			continue;
		
		Map dimensionLineDefinition = dimensionLineDefinitions.getMap(d);
		
		Point3d position = dimensionLineDefinition.getPoint3d("Position");
		Vector3d direction = dimensionLineDefinition.getPoint3d("Direction");
		Vector3d upDirection = dimensionLineDefinition.getPoint3d("UpDirection");
		
		Point3d points[] = dimensionLineDefinition.getPoint3dArray("Points");
		
		String catalog = dimensionLineDefinition.getString("Catalog");
		String description = dimensionLineDefinition.getString("Description");

		// Set map data for dimension tsl.
		mapTsl = Map();
		mapTsl.setPoint3d("VecX", position + direction * U(100));
		
		lstPoints.setLength(0);
		lstPoints.append(refereceStart);
		lstPoints.append(points);
		lstPoints.append(refereceEnd);
		
		// Project points?
		if (dimensionLineDefinition.hasPoint3d("ProjectPointsTo")) {
			Point3d projectPointsTo = dimensionLineDefinition.getPoint3d("ProjectPointsTo");
			Line ln(projectPointsTo, direction);
			lstPoints = ln.projectPoints(lstPoints);
		}		
		lstPoints.insertAt(0, position);

		TslInst dimensionLine;
		dimensionLine.dbCreate(
			scriptNameDimensionTsl, direction, upDirection,
			lstBeams, lstElements, lstPoints , 
			lstPropInt, lstPropDouble,lstPropString, _kModelSpace, mapTsl
		); // create new instance	
		dimensionLine.setPropValuesFromCatalog(catalog);
		dimensionLine.setPropString(8, description);
		dimensionLine.setPropString(11, floorGroupNameDimensionLines);
		dimensionLine.setPropString(12, showInDisplayRepresentation);
		
		_Map.appendEntity("Dimension", dimensionLine);
	}
}
#End
#BeginThumbnail




#End