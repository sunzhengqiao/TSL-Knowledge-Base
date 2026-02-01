#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
22.09.2015  -  version 1.01
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This creates headers under the topplate
/// </summary>

/// <insert>
/// Select a viewport
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.01" date="22.09.2015"></version>

/// <history>
/// AS - 1.00 - 21.09.2015 -	Pilot version
/// AS - 1.01 - 22.09.2015 -	Create header, set beamcodes.
/// </history>

String categories[] = {
	T("|Header|"),
	T("|Supporting beams|")
};

PropInt numberOfHeaders(0, 2, T("|Number of headers|"));
numberOfHeaders.setDescription(T("|Sets the number of headers.|"));
numberOfHeaders.setCategory(categories[0]);

PropDouble headerW(0, U(0), T("|Header width|"));
headerW.setDescription(T("|Sets the width of the headers.|") + TN("|The default beam width for the element is used when an invalid height is specified.|"));
headerW.setCategory(categories[0]);

PropDouble headerH(1, U(0), T("|Header height|"));
headerH.setDescription(T("|Sets the height of the headers.|") + TN("|The default beam height for the element is used when an invalid height is specified.|"));
headerH.setCategory(categories[0]);



PropInt numberOfSupportingBeamsLeft(1, 2, T("|Number of supporting beams on the left-hand side|"));
numberOfSupportingBeamsLeft.setDescription(T("|Sets the number of supporting beams on the left-hand side.|"));
numberOfSupportingBeamsLeft.setCategory(categories[1]);

PropInt numberOfSupportingBeamsRight(2, 2, T("|Number of supporting beams on the right-hand side|"));
numberOfSupportingBeamsRight.setDescription(T("|Sets the number of supporting beams on the right-hand side.|"));
numberOfSupportingBeamsRight.setCategory(categories[1]);

PropDouble supportingBeamW(2, U(0), T("|Supporting beams width|"));
supportingBeamW.setDescription(T("|Sets the width of the supporting beams.|") + TN("|The default beam width for the element is used when an invalid height is specified.|"));
supportingBeamW.setCategory(categories[1]);


// Set properties if inserted with an execute key
String catalogNames[] = TslInst().getListOfCatalogNames("HSB_W-CreateHeader");
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
	
	PrEntity ssOpenings(T("|Select openings|"), OpeningSF());
	if (ssOpenings.go()) {
		Entity selectedEntities[] = ssOpenings.set();
		
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

		for (int e=0;e<selectedEntities.length();e++) {
			OpeningSF selectedOpening = (OpeningSF)selectedEntities[e];
			if (!selectedOpening.bIsValid())
				continue;
			
			lstEntities[0] = selectedOpening;

			TslInst tslNew;
			tslNew.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
		}		
	}
	
	eraseInstance();
	return;
}

if (_Entity.length() == 0) {
	reportWarning(T("|invalid or no opening selected.|"));
	eraseInstance();
	return;
}

// set properties from catalog
if (_bOnDbCreated)
	setPropValuesFromCatalog(T("|_LastInserted|"));

int manualInserted = false;
if (_Map.hasInt("ManualInserted")) {
	manualInserted = _Map.getInt("ManualInserted");
	_Map.removeAt("ManualInserted", true);
}


OpeningSF op = (OpeningSF)_Entity[0];
if (!op.bIsValid()) {
	reportWarning(T("|The selected entity is not an opening.|"));
	eraseInstance();
	return;
}

Element el = op.element();
if (!el.bIsValid()) {
	reportWarning(T("|The selected opening is not attached to a valid element.|"));
	eraseInstance();
	return;
}

Vector3d elX = el.coordSys().vecX();
Vector3d elY = el.coordSys().vecY();
Vector3d elZ = el.coordSys().vecZ();

Point3d elementFront = el.coordSys().ptOrg();
Point3d elementBack = el.zone(-1).coordSys().ptOrg();
elementFront.vis(1);
elementBack.vis(1);
_Pt0.setToAverage(op.plShape().vertexPoints(true));
_Pt0 += elZ * elZ.dotProduct((elementFront + elementBack)/2 - _Pt0);
_Pt0.vis(3);

double openingWidth = op.width() + 2* op.dGapSide();

Beam beams[] = el.beam();

//Find beams on the left and right of this opening.
Beam leftBeams[0];
Beam rightBeams[0];

Beam beamsAboveOpening[] = Beam().filterBeamsHalfLineIntersectSort(beams, _Pt0, elY);
if (beamsAboveOpening.length() == 0) {
	reportWarning(T("|Opening frame not found.|"));
	eraseInstance();
	return;
}
// Take the module name for this opening from the first beam above the opening.
String moduleName = beamsAboveOpening[0].module();
if (moduleName == "") {
	reportWarning(T("|Module name not found.|"));
	eraseInstance();
	return;
}
// Get all the beams which are part of this opening.
Beam moduleBeams[0];
for (int b=0;b<beams.length();b++) {
	Beam bm = beams[b];
	if (bm.module() == moduleName)
		moduleBeams.append(bm);
}
Beam beamsLeftFromOpening[] = Beam().filterBeamsHalfLineIntersectSort(moduleBeams, _Pt0, -elX);
if (beamsLeftFromOpening.length() == 0) {
	reportWarning(T("|Opening frame not found on left hand side.|"));
	eraseInstance();
	return;
}
Beam beamsRightFromOpening[] = Beam().filterBeamsHalfLineIntersectSort(moduleBeams, _Pt0, elX);
if (beamsRightFromOpening.length() == 0) {
	reportWarning(T("|Opening frame not found on right hand side.|"));
	eraseInstance();
	return;
}

// Find topplate
Beam topPlate;
for (int b=0;b<beamsAboveOpening.length();b++) {
	Beam bm = beamsAboveOpening[b];
	if (bm.type() == _kSFTopPlate) {
		topPlate = bm;
		break;
	}
}
if (!topPlate.bIsValid()) {
	reportWarning(T("|Top plate not found.|"));
	eraseInstance();
	return;
}

Point3d headerPosition = Line(_Pt0, elY).intersect(Plane(topPlate.ptCen(), topPlate.vecD(elY)), -0.5 * topPlate.dD(elY));
headerPosition.vis(3);

// Default beam sizes are used if one the beam dimensions is invalid.
double defaultBeamWidth = el.dBeamHeight();
double defaultBeamHeight = el.dBeamWidth();
// Resolve the properties.
double headerWidth = headerW;
if (headerWidth <= 0)
	headerWidth = defaultBeamWidth;
double headerHeight = headerH;
if (headerHeight <= 0)
	headerHeight = defaultBeamHeight;
double supportingBeamWidth = supportingBeamW;
if (supportingBeamWidth <= 0)
	supportingBeamWidth = defaultBeamWidth;

Point3d normalCutLeft = headerPosition - elX * (0.5 * openingWidth + numberOfSupportingBeamsLeft * supportingBeamWidth);
normalCutLeft.vis(5);
Cut cutLeft(normalCutLeft, -elX);
Point3d normalCutRight = headerPosition + elX * (0.5 * openingWidth + numberOfSupportingBeamsRight * supportingBeamWidth);
normalCutRight.vis(5);
Cut cutRight(normalCutRight, elX);

// Define the header positions.
// First position is on the front of the frame.
Point3d headerInsertionPoints[] = {
	headerPosition + elZ * elZ.dotProduct(elementFront - headerPosition)
};
int flagsY[] = {
	-1
};
// Second position is at the back of the frame.
if (numberOfHeaders > 1) {
	headerInsertionPoints.append(headerPosition + elZ * elZ.dotProduct(elementBack - headerPosition));
	flagsY.append(1);
}
// The remaining positions are directly behind the header at the front of the frame.
for (int i=2;i<numberOfHeaders;i++) {
	headerInsertionPoints.append(headerPosition + elZ * (elZ.dotProduct(elementFront - headerPosition) - (i-1) * headerWidth));
	flagsY.append(-1);
}

// Create the headers
for (int h=0;h<headerInsertionPoints.length();h++) {
	Point3d headerPosition = headerInsertionPoints[h];
	int flagY = flagsY[h];
	headerPosition.vis(flagY);
	
	Beam header;
	header.dbCreate(headerPosition, elX, elZ, -elY, U(50000), headerWidth, headerHeight, 0, flagY, 1);
	header.addToolStatic(cutLeft, _kStretchOnInsert);
	header.addToolStatic(cutRight, _kStretchOnInsert);
	
	header.assignToElementGroup(el, true, 0, 'Z');
	header.setType(_kHeader);
	header.setColor(32);
	String paddedIndex = h+1;
	while (paddedIndex.length() < 2)
		paddedIndex = "0" + paddedIndex;
	header.setBeamCode("OH-"+paddedIndex);
}

// Cut to apply to the supporting beams.
Cut cutSupportingBeam(headerPosition - elY * headerHeight, elY);
// Reposition the supporting beams at the left-hand side.
// But first we create extra beams if needed.
while (beamsLeftFromOpening.length() <= numberOfSupportingBeamsLeft) {
	Beam newBeam = beamsLeftFromOpening[beamsLeftFromOpening.length() - 1].dbCopy();
	newBeam.transformBy(-elX * newBeam.dD(elX));
	
	String fullBeamCode = newBeam.beamCode();
	String beamCode = fullBeamCode.token(0);
	int index = beamCode.token(1, '-').atoi();
	if (index > 0) {
		index++;
		String paddedIndex = index;
		while (paddedIndex.length() < 2)
			paddedIndex = "0" + paddedIndex;
		
		fullBeamCode = beamCode.token(0, '-') + "-" + paddedIndex + fullBeamCode.trimLeft(beamCode);
		newBeam.setBeamCode(fullBeamCode);
	}
	
	beamsLeftFromOpening.append(newBeam);	
}
// Reposition the beams
double transformationLeft = U(0);
for (int s=0;s<beamsLeftFromOpening.length();s++) {
	Beam bm = beamsLeftFromOpening[s];
	double beamWidth = bm.dD(elX);
	
	double thisTransformation;
	if (s<numberOfSupportingBeamsLeft) {
		bm.setD(bm.vecD(elX), supportingBeamWidth);
		thisTransformation = (supportingBeamWidth - beamWidth)/2;
	}
	bm.transformBy(-elX * (thisTransformation + transformationLeft));
	transformationLeft += 2 * thisTransformation;
	
	if (s<numberOfSupportingBeamsLeft) {
		bm.setType(_kSFSupportingBeam);
		bm.addToolStatic(cutSupportingBeam, _kStretchOnInsert);
	}
	else {
		bm.setType(_kKingStud);
	}
}

// Reposition the supporting beams at the right-hand side.
// But first we create extra beams if needed.
while (beamsRightFromOpening.length() <= numberOfSupportingBeamsRight) {
	Beam newBeam = beamsRightFromOpening[beamsRightFromOpening.length() - 1].dbCopy();
	newBeam.transformBy(elX * newBeam.dD(elX));
	
	String fullBeamCode = newBeam.beamCode();
	String beamCode = fullBeamCode.token(0);
	int index = beamCode.token(1, '-').atoi();
	if (index > 0) {
		index++;
		String paddedIndex = index;
		while (paddedIndex.length() < 2)
			paddedIndex = "0" + paddedIndex;
		
		fullBeamCode = beamCode.token(0, '-') + "-" + paddedIndex + fullBeamCode.trimLeft(beamCode);
		newBeam.setBeamCode(fullBeamCode);
	}
	
	beamsRightFromOpening.append(newBeam);	
}
// Reposition the beams
double transformationRight = U(0);
for (int s=0;s<beamsRightFromOpening.length();s++) {
	Beam bm = beamsRightFromOpening[s];
	double beamWidth = bm.dD(elX);
	
	double thisTransformation;
	if (s<numberOfSupportingBeamsRight) {
		bm.setD(bm.vecD(elX), supportingBeamWidth);
		thisTransformation = (supportingBeamWidth - beamWidth)/2;
	}
	bm.transformBy(elX * (thisTransformation + transformationRight));
	transformationRight += 2 * thisTransformation;
	
	if (s<numberOfSupportingBeamsRight) {
		bm.setType(_kSFSupportingBeam);
		bm.addToolStatic(cutSupportingBeam, _kStretchOnInsert);
	}
	else {
		bm.setType(_kKingStud);
	}
}

if (manualInserted || _bOnElementConstructed) {
	eraseInstance();
	return;
}
#End
#BeginThumbnail

#End