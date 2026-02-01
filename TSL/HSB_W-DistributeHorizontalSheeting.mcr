#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
20.03.2017  -  version 1.05

This tsl distributes the horizontal sheeting based on a distribution point.
Insert: Select a set of elements, or attach to element definition.
Remarks: The distribution point is found automatically.
Version 1.05 - 20.03.2017 - Do not create very small sheets.
Version 1.04 - 15.06.2016 - Add option to set beamcode of first sheet above distribution point
Version 1.03 - 04.04.2016 - Disable correction in the element x direction.
Version 1.02 - 24.11.2015 - Do not remove sheeting with material "Musband"
Version 1.01 - 24.09.2015 - Use zone variables if available.
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 5
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl distributes the horizontal sheeting based on a distribution point.
/// </summary>

/// <insert>
/// Select a set elements.
/// </insert>

/// <remark Lang=en>
///  The distribution point is found automatically.
/// </remark>

/// <version  value="1.05" date="20.03.2017"></version>

/// <history>
/// AS - 1.00 - 23.09.2015 - Pilot version
/// AS - 1.01 - 24.09.2015 - Use zone variables if available.
/// AS - 1.02 - 24.11.2015 - Do not remove sheeting with material "Musband"
/// AS - 1.03 - 04.04.2016 - Disable correction in the element x direction.
/// AS - 1.04 - 15.06.2016 - Add option to set beamcode of first sheet above distribution point
/// AS - 1.05 - 20.03.2017 - Do not create very small sheets.
/// </history>

String distributionPointScriptName = "HSB_G-DistributionPoint";

double areaTolerance = Unit(10, "mm");

String categories[] = {
	T("|Distribution|"),
	T("|Sheeting dimensions|"),
	T("|Sheeting properties|")
};

String yesNo[] = {T("|Yes|"), T("|No|")};
int zoneIndexes[] = {1,2,3,4,5,6,7,8,9,10};

PropInt sequenceNumber(3, 0, T("|Sequence number|"));
sequenceNumber.setDescription(T("|The sequence number is used to sort the list of tsl's during generate construction|"));

PropInt distributionNumber(0, 0, T("|Distribution number|"));
distributionNumber.setCategory(categories[0]);
PropInt propZoneIndex(2, zoneIndexes, T("|Zone index|"));
propZoneIndex.setCategory(categories[0]);

PropDouble propMaximumSheetLength(0, U(6000), T("|Maximum sheet length|"));
propMaximumSheetLength.setCategory(categories[1]);
propMaximumSheetLength.setDescription(T("|Sets the maximum length of the sheet.|"));
PropDouble propSheetWidth(1, U(240), T("|Sheet width|"));
propSheetWidth.setCategory(categories[1]);
propSheetWidth.setDescription(T("|Sets the width of the sheet.|"));
PropDouble propSheetThickness(4, U(0), T("|Sheet thickness|"));
propSheetThickness.setCategory(categories[1]);
propSheetThickness.setDescription(T("|Sets the thickness of the sheet.|") + TN("|The thickness of the zone is used if this value is set to 0|"));

PropDouble propGapX(2, U(0), T("|Gap in length direction|"));
propGapX.setCategory(categories[1]);
PropDouble propGapY(3, U(0), T("|Gap in width direction|"));
propGapY.setCategory(categories[1]);

PropInt propSheetColor(1, 1, T("|Sheet color|"));
propSheetColor.setCategory(categories[2]);
PropString propSheetMaterial(0, "", T("|Sheet material|"));
propSheetMaterial.setCategory(categories[2]);
PropString beamCodeFirstSheetAboveDistributionPoint(1, "", T("|Beam code first sheet above distribution point|"));
beamCodeFirstSheetAboveDistributionPoint.setCategory(categories[2]);

// Set properties if inserted with an execute key
String catalogNames[] = TslInst().getListOfCatalogNames("HSB_W-DistributeHorizontalSheeting");
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
	
	PrEntity ssElements(T("|Select elements|"), ElementWallSF());
	if (ssElements.go()) {
		Element selectedElements[] = ssElements.elementSet();
		
		String strScriptName = scriptName();
		Vector3d vecUcsX(1,0,0);
		Vector3d vecUcsY(0,1,0);
		Beam lstBeams[0];
		Entity lstEntities[1];
		
		Point3d lstPoints[0];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
		Map mapTsl;
		mapTsl.setInt("ManualInserted", true);

		for (int e=0;e<selectedElements.length();e++) {
			ElementWallSF selectedElement = (ElementWallSF)selectedElements[e];
			if (!selectedElement.bIsValid())
				continue;
			
			lstEntities[0] = selectedElement;

			TslInst tslNew;
			tslNew.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
		}		
	}
	
	eraseInstance();
	return;
}

if (_Element.length() == 0) {
	reportWarning(T("|invalid or no element selected.|"));
	eraseInstance();
	return;
}

int manualInserted = false;
if (_Map.hasInt("ManualInserted")) {
	manualInserted = _Map.getInt("ManualInserted");
	_Map.removeAt("ManualInserted", true);
}

// set properties from catalog
if (_bOnDbCreated && manualInserted)
	setPropValuesFromCatalog(T("|_LastInserted|"));

// Set the sequence number
_ThisInst.setSequenceNumber(sequenceNumber);

if (_bOnElementConstructed || manualInserted || _bOnRecalc || _bOnDebug) {
	// We need a valid element. Stop execution if the element is not valid.
	Element el = _Element[0];
	if (!el.bIsValid()) {
		reportWarning(
			T("|The selected element is not a valid element.|") +
			TN("|The distribution is not added!|"));
		eraseInstance();
		return;
	}
	_ThisInst.assignToElementGroup(el, true, 0, 'E');

	int setBeamCodeFirstSheetAboveDistributionPoint = (beamCodeFirstSheetAboveDistributionPoint != "");

	int allowSheetingBelowDistributionPoint = true;
	int zoneIndex = propZoneIndex;
	if (zoneIndex>5)
		zoneIndex = 5 - zoneIndex;
	
	ElemZone zone = el.zone(zoneIndex);
	// Get all the zone properties and apply them to this distribution if required..
	String zoneCode = zone.code();
	String zoneDistribution = zone.distribution();
	if (zoneDistribution != "Horizontal Lap Siding") {
		reportWarning(
			el.number() + 
			TN("|The distribution of selected zone is not set to horizontal lap siding|"));
		eraseInstance();
		return;
	}
	
	// Material
	String zoneMaterial = zone.material();
	String sheetMaterial = propSheetMaterial;
	if (sheetMaterial == "")
		sheetMaterial = zoneMaterial;
	//Color
	int zoneColor = zone.color();
	int sheetColor = propSheetColor;
	if (sheetColor <= 0)
		sheetColor = zoneColor;
	// Thickness
	double zoneThickness = zone.dH();
	double sheetThickness = propSheetThickness;
	if (sheetThickness <= U(0))
		sheetThickness = zoneThickness;
	// Maximum length
	double maximumSheetLengthForZone = zone.dVar("Max. Length");
	double maximumSheetLength = propMaximumSheetLength;
	if (maximumSheetLength <= 0)
		maximumSheetLength = maximumSheetLengthForZone;
	double gapX = propGapX;
	// Width
	double spacingForZone = zone.dVar(3);// Spacing as key does not seem to work.
	double heightForZone = zone.dVar("Height");
	double sheetWidth = propSheetWidth;
	double gapY = propGapY;
	if (sheetWidth <= U(0)) {
		sheetWidth = heightForZone;
		gapY = spacingForZone - heightForZone;
	}
	
	Group elementGroup = el.elementGroup();
	Group floorGroup(elementGroup.namePart(0), elementGroup.namePart(1), "");
	
	// Find distribution point
	TslInst distributionPoint;
	Entity distributionPointEntities[] = floorGroup.collectEntities(false, TslInst(), _kModelSpace);
	for (int d=0;d<distributionPointEntities.length();d++) {
		TslInst tsl = (TslInst)distributionPointEntities[d];
		if (!tsl.bIsValid())
			continue;
		
		if (tsl.scriptName() == distributionPointScriptName) {
			if (tsl.propInt(0) != distributionNumber)
				continue;
			
			distributionPoint = tsl;
			break;
		}
	}
	
	// Validate distribution point.
	if (!distributionPoint.bIsValid()) {
		reportWarning(
			el.number() + 
			TN("|Distribution point with number| ") + distributionNumber + T(" |cannot be found|!"));
		eraseInstance();
		return;
	}
	
	// Make this tsl dependent on distribution point.
	if (_Entity.find(distributionPoint) == -1)
		_Entity.append(distributionPoint);
	setDependencyOnEntity(distributionPoint);
	
	// Element origin and vectors.
	Point3d elOrg = el.coordSys().ptOrg();
	Vector3d elX = el.coordSys().vecX();
	Vector3d elY = el.coordSys().vecY();
	Vector3d elZ = el.coordSys().vecZ();
	
	Line lnX(elOrg, elX);
	Line lnY(elOrg, elY);
	
	CoordSys zoneCoordSys = el.zone(zoneIndex).coordSys();
	
	_Pt0 = distributionPoint.ptOrg();
	_Pt0 = Line(el.zone(zoneIndex).coordSys().ptOrg(), elY).closestPointTo(_Pt0);
	
	PlaneProfile zoneProfile = el.profNetto(zoneIndex);
	zoneProfile.vis(1);

	PLine profileRings[] = zoneProfile.allRings();
	if( profileRings.length() == 0 )
		return;
	PLine mainRing = profileRings[0];
	
	//Area grip vertex points
	Point3d zoneVertices[] = zoneProfile.getGripVertexPoints();
	
	//Order points
	Point3d zoneVerticesX[] = lnX.orderPoints(zoneVertices);
	Point3d zoneVerticesY[] = lnY.orderPoints(zoneVertices);
	if ((zoneVerticesX.length() * zoneVerticesY.length()) <= 0) {
		reportWarning(
			el.number() + 
			TN("|Zone vertices are not valid!|"));
		eraseInstance();
		return;
	}
	
	Point3d pxMin = zoneVerticesX[0];
	Point3d pxMax = zoneVerticesX[zoneVerticesX.length() - 1];
	pxMin.vis();
	pxMax.vis();
	
	// Set the length to the max required length if it was not specified.
	if (maximumSheetLength <= 0)
		maximumSheetLength = elX.dotProduct(zoneVerticesX[zoneVerticesX.length() - 1]- zoneVerticesX[0]) + U(10); // Give it a bit extra length.
	
	// Start point for distribution is lower-left hand corner of the box around the area.
	Point3d startDistribution = zoneVerticesX[0] + elY * elY.dotProduct(zoneVerticesY[0] - zoneVerticesX[0]);
	
	// Distances of distribution point to _Pt0.
	double startX = elX.dotProduct(_Pt0 - startDistribution);
	double startY = elY.dotProduct(_Pt0 - startDistribution);
	
	if (startY > 0 && !allowSheetingBelowDistributionPoint) {
		startY = 0;
		startDistribution += elY * elY.dotProduct(_Pt0 - startDistribution);
	}
	
//	// Adjust start point. The user has picked a point. The calculated startpoint has to be corrected in the -x and -y direction.
//	double correctionX = startX/(maximumSheetLength + gapX);
//	correctionX -= int(correctionX);
//	if (correctionX > 0)
//		startDistribution -= elX * (1 - correctionX) * (maximumSheetLength + gapX);
	
	if (allowSheetingBelowDistributionPoint) {
		double correctionY = startY/(sheetWidth + gapY);
		correctionY -= int(correctionY);
		if (correctionY < 0)
			correctionY++;
		startDistribution -= elY * (1 - correctionY) * (sheetWidth + gapY);
	}
	
	startDistribution .vis(3);
	
	// Remove existing sheeting for this zone
	Sheet existingSheeting[] = el.sheet(zoneIndex);
	for (int s=0;s<existingSheeting.length();s++) {
		if (existingSheeting[s].material() == "Musband")
			continue;
		existingSheeting[s].dbErase();
	}
	
	// Create sheeting
	// Get the extreme points of the area. The distribution should stop once it crosses these points.
	Point3d distributionEnd = zoneVerticesX[zoneVerticesX.length() - 1];
	distributionEnd += elY * elY.dotProduct(zoneVerticesY[zoneVerticesY.length() - 1] - distributionEnd);
	distributionEnd.vis(1);
	
	if ((maximumSheetLength * sheetWidth * sheetThickness) <= U(0)) {
		reportWarning(
			el.number() + 
			TN("|Invalid sheet sizes|!"));
		eraseInstance();
		return;
	}
	
	// Rows.
	int beamCodeFirstSheetSet = false;
	int rowIndex = 0;
	int nextRowAllowed = true;
	while( nextRowAllowed ){
		if( rowIndex > 500 )
			break;
		rowIndex++;
		
		Point3d columnPosition = startDistribution;
		
		// Columns.
		int beamCodeFirstSheetSetForTheseColumns = false;
		int nColumnIndex = 0;
		nextRowAllowed = true;
		while (true) {
			if( nColumnIndex > 500 )
				break;
			nColumnIndex++;
	
			//Points to create the envelope of the sheet as a planeProfile
			Point3d sheetBL = columnPosition;
			// Is this position still valid?
			if( elX.dotProduct(distributionEnd - sheetBL) < 0 ){
				sheetBL.vis(1);
				break;
			}
			if( elY.dotProduct(distributionEnd - sheetBL) < 0 ){
				sheetBL.vis(1);
				nextRowAllowed = false;
				break;
			}		
			Point3d sheetBR = sheetBL + elX * maximumSheetLength;
			Point3d sheetTR = sheetBR + elY * sheetWidth;
			Point3d sheetTL = sheetTR - elX * maximumSheetLength;
			PLine sheetOutline(sheetBL, sheetBR, sheetTR, sheetTL);
			
			//Create a plane profile with a normal and add a ring
			PlaneProfile sheetProfile(zoneCoordSys);
			sheetProfile.joinRing(sheetOutline, _kAdd);
			sheetProfile.vis();
			
			if( sheetProfile.intersectWith(zoneProfile) ){
				//dbCreate the sheet
				int beamCodeFirstSheetSetForTheseRings = false;
				PLine sheetRings[] = sheetProfile.allRings();
				int sheetRngIsOpening[] = sheetProfile.ringIsOpening();
				for( int i=0;i<sheetRings.length();i++ ){
					//Ignore openings
					if( sheetRngIsOpening[i] )
						continue;
					//Get this pline and create a planeprofile with it.
					PLine thisRing = sheetRings[i];
					//Create a plane profile with a normal and add a ring
					PlaneProfile thisSheetProfile(zoneCoordSys);
					thisSheetProfile.joinRing(thisRing, _kAdd);thisSheetProfile.vis(5);
					thisSheetProfile.vis(i);
					
					if(thisSheetProfile.area() < areaTolerance)
						continue;
					
					//Create the sheet
					Sheet sh;
					sh.dbCreate(thisSheetProfile, sheetThickness, 1);
					sh.setColor(sheetColor);
					sh.setMaterial(sheetMaterial);
					sh.assignToElementGroup(el, true, zoneIndex, 'Z');
					if (setBeamCodeFirstSheetAboveDistributionPoint && !beamCodeFirstSheetSet && elY.dotProduct(sh.ptCen() - _Pt0) > 0) {
						sh.setBeamCode(beamCodeFirstSheetAboveDistributionPoint);
						beamCodeFirstSheetSetForTheseRings = true;
					}
				}
				if (beamCodeFirstSheetSetForTheseRings)
					beamCodeFirstSheetSetForTheseColumns = true;
			}
			//Next column
			columnPosition += elX * (maximumSheetLength + gapX);
		}
		if (beamCodeFirstSheetSetForTheseColumns)
			beamCodeFirstSheetSet = true;
		//Next row
		startDistribution += elY * (sheetWidth + gapY);
	}
	
	eraseInstance();
	return;
}
#End
#BeginThumbnail
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
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
M@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`
M"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`*
M***`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HH
MHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`"BBB
D@`HHHH`****`"BBB@`HHHH`****`"BBB@`HHHH`****`/__9
`







#End