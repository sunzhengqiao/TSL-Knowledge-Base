#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
26.09.2018  -  version 1.02
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
/// 
/// </summary>

/// <insert>
///
/// </insert>

/// <remark Lang=en>
/// -
/// </remark>

/// <version  value="1.02" date="26.09.2018"></version>

/// <history>
/// AS - 1.00 - 04.04.2018 -	Pilot version
/// AS - 1.01 - 11.05.2018 -	Make walls meet the longest points of the top plate.
/// AS - 1.02 - 26.09.2018 -	Set grouping data to linked elements.
/// </history>

int logLevel = 1; // 0 = logError, 1 = logWarning, 2 = logInfo.
int logError = (logLevel > -1);
int logWarning = (logLevel > 0);
int logInfo = (logLevel > 1);

String separator = '-';

//Groupnames
Group floorGroups[0];
String groupNames[0];
Group allGroups[] = Group().allExistingGroups();
for( int i=0;i<allGroups.length();i++ ){
	Group grp = allGroups[i];
	if (grp.namePart(2) != "" || grp.namePart(1) == "")
		continue;
	
	floorGroups.append(grp);
	groupNames.append(grp.name());
}

PropString groupNameDummyKneeWalls(3, groupNames, T("|Group name dummy knee walls|"));
if (_bOnInsert)
	showDialog();
groupNameDummyKneeWalls.setReadOnly(true);
Group groupDummyKneeWalls = floorGroups[groupNames.find(groupNameDummyKneeWalls, 0)];

Entity kneeWallEntities[] = groupDummyKneeWalls.collectEntities(true, ElementWallSF(), _kModelSpace);
ElementWallSF dummyKneeWalls[0];
String dummyKneeWallTypes[0];
for (int k=0;k<kneeWallEntities.length();k++) 
{
	ElementWallSF kneeWall = (ElementWallSF)kneeWallEntities[k];
	if (!kneeWall.bIsValid())
		continue;
	
	String kneeWallType = kneeWall.code();
	if (dummyKneeWallTypes.find(kneeWallType) != -1)
		continue;
	
	dummyKneeWalls.append(kneeWall);
	dummyKneeWallTypes.append(kneeWallType);
}

PropString kneeWallType(4, dummyKneeWallTypes, T("|Knee wall type|"), 0);
PropString groupNameKneeWalls(6, groupNames, T("|Group name knee walls|"));

String filterDefinitionTslName = "HSB_G-FilterGenBeams";

PropString propBeamCodesTopPlates(0, "", T("|Beam codes top plates|"));
PropString propBeamCodesBottomPlates(1, "", T("|Beam codes bottom plates|"));
PropString propBeamCodesStuds(2, "", T("|Beam codes studs|"));
PropString propBeamCodesZone6(5, "", T("|Beam codes zone| 6"));

String catalogNames[] = TslInst().getListOfCatalogNames(scriptName());
if (_kExecuteKey != "" && catalogNames.find(_kExecuteKey) != -1) 
 setPropValuesFromCatalog(_kExecuteKey);

if (_bOnInsert) 
{
	if (insertCycleCount() > 1) 
	{
		eraseInstance();
		return;
	}
	if( _kExecuteKey == "" || catalogNames.find(_kExecuteKey) == -1 )
		showDialog();
	setCatalogFromPropValues(T("_LastInserted"));
 	
 	Element  selectedElements[0];
	PrEntity ssE(T("|Select elements|"), Element());
	if (ssE.go())
		selectedElements.append(ssE.elementSet());
	
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
		Element selectedElement = selectedElements[e];
		if (!selectedElement.bIsValid())
			continue;
	
		lstEntities[0] = selectedElement;
	
		TslInst tslNew;
		tslNew.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
	}
 
	eraseInstance();
	return;
}

if( _Element.length() != 1 ){
	reportWarning(TN("|No element selected!|"));
	eraseInstance();
	return;
}

int manualInserted = false;
if (_Map.hasInt("ManualInserted")) {
	manualInserted = _Map.getInt("ManualInserted");
}

// set properties from catalog
if (_bOnDbCreated && manualInserted) 
{
	setPropValuesFromCatalog(T("|_LastInserted|"));
	
	Group groupDummyKneeWalls = floorGroups[groupNames.find(groupNameDummyKneeWalls, 0)];

	Entity kneeWallEntities[] = groupDummyKneeWalls.collectEntities(true, ElementWallSF(), _kModelSpace);
	dummyKneeWalls.setLength(0);
	dummyKneeWallTypes.setLength(0);
	for (int k=0;k<kneeWallEntities.length();k++) 
	{
		ElementWallSF kneeWall = (ElementWallSF)kneeWallEntities[k];
		if (!kneeWall.bIsValid())
			continue;
		
		String kneeWallType = kneeWall.code();
		if (dummyKneeWallTypes.find(kneeWallType) != -1)
			continue;
		
		dummyKneeWalls.append(kneeWall);
		dummyKneeWallTypes.append(kneeWallType);
	}
}

Group floorGroupKneeWalls = floorGroups[groupNames.find(groupNameKneeWalls, 0)];

//reportNotice("\n\nAvailable types: " + dummyKneeWallTypes);
//reportNotice("\nType: " + kneeWallType);

for (int m=0;m<_Map.length();m++)
{
	if(_Map.keyAt(m) != "KneeWall" || !_Map.hasEntity(m))
		continue;
	
	Entity ent = _Map.getEntity(m);
	ent.dbErase();
	_Map.removeAt(m, true);
	m--;
}

ElementWallSF dummyKneeWall = dummyKneeWalls[dummyKneeWallTypes.find(kneeWallType, 0)];
CoordSys csDummy = dummyKneeWall.coordSys();
Point3d dummyOrg = csDummy.ptOrg();
Vector3d dummyX = csDummy.vecX();
Vector3d dummyY = csDummy.vecY();
Vector3d dummyZ = csDummy.vecZ();

Element el = _Element[0];
CoordSys csEl = el.coordSys();
Point3d elOrg = csEl.ptOrg();
Vector3d elX = csEl.vecX();
Vector3d elY = csEl.vecY();
Vector3d elZ = csEl.vecZ();
_Pt0 = elOrg;

GenBeam genBeams[] = el.genBeam();

Entity genBeamEntities[0];
for (int b=0;b<genBeams.length();b++)
	genBeamEntities.append(genBeams[b]);

//region GetKneeWallEntities
Map filterGenBeamsMap;
filterGenBeamsMap.setEntityArray(genBeamEntities, false, "GenBeams", "GenBeams", "GenBeam");
filterGenBeamsMap.setString("BeamCode[]", propBeamCodesTopPlates);
filterGenBeamsMap.setInt("Exclude", false);
int successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, "", filterGenBeamsMap);
if (!successfullyFiltered) {
	reportWarning(T("|Beams could not be filtered!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
	eraseInstance();
	return;
} 
Entity topPlateBeamEntities[] = filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam");
Beam topPlates[0];
Point3d topPlateVertices[0];
for (int e=0;e<topPlateBeamEntities.length();e++) 
{
	Beam bm = (Beam)topPlateBeamEntities[e];
	if (!bm.bIsValid())
		continue;
	
	topPlates.append(bm);
	topPlateVertices.append(bm.envelopeBody(false, false).allVertices());
}
if (topPlates.length() == 0)
{
	if (logInfo)
		reportNotice(TN("|No top plates found!|"));
	eraseInstance();
	return;
}

filterGenBeamsMap.setEntityArray(genBeamEntities, false, "GenBeams", "GenBeams", "GenBeam");
filterGenBeamsMap.setString("BeamCode[]", propBeamCodesBottomPlates);
filterGenBeamsMap.setInt("Exclude", false);
successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, "", filterGenBeamsMap);
if (!successfullyFiltered) {
	reportWarning(T("|Beams could not be filtered!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
	eraseInstance();
	return;
} 
Entity bottomPlateBeamEntities[] = filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam");
Beam bottomPlates[0];
Point3d bottomPlateVertices[0];
for (int e=0;e<bottomPlateBeamEntities.length();e++) 
{
	Beam bm = (Beam)bottomPlateBeamEntities[e];
	if (!bm.bIsValid())
		continue;
	
	bottomPlates.append(bm);
	bottomPlateVertices.append(bm.envelopeBody(false, false).allVertices());
}
if (bottomPlates.length() == 0)
{	if (logInfo)
		reportNotice(TN("|No bottom plates found!|"));
	eraseInstance();
	return;
}

filterGenBeamsMap.setEntityArray(genBeamEntities, false, "GenBeams", "GenBeams", "GenBeam");
filterGenBeamsMap.setString("BeamCode[]", propBeamCodesStuds);
filterGenBeamsMap.setInt("Exclude", false);
successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, "", filterGenBeamsMap);
if (!successfullyFiltered) {
	reportWarning(T("|Beams could not be filtered!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
	eraseInstance();
	return;
} 
Entity studBeamEntities[] = filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam");
Beam studs[0];
for (int e=0;e<studBeamEntities.length();e++) 
{
	Beam bm = (Beam)studBeamEntities[e];
	if (bm.bIsValid())
		studs.append(bm);
}
if (studs.length() == 0)
{
	reportNotice(TN("|No studs found!|"));
	eraseInstance();
	return;
}

filterGenBeamsMap.setEntityArray(genBeamEntities, false, "GenBeams", "GenBeams", "GenBeam");
filterGenBeamsMap.setString("BeamCode[]", propBeamCodesZone6);
filterGenBeamsMap.setInt("Exclude", false);
successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, "", filterGenBeamsMap);
if (!successfullyFiltered) {
	reportWarning(T("|Beams could not be filtered!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
	eraseInstance();
	return;
} 
Entity zone6GenBeamEntities[] = filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam");
GenBeam zone6GenBeams[0];
for (int e=0;e<zone6GenBeamEntities.length();e++) 
{
	GenBeam gBm = (GenBeam)zone6GenBeamEntities[e];
	if (gBm.bIsValid())
		zone6GenBeams.append(gBm);
}
//endregion

Point3d kneeWallOrg = elOrg;
Vector3d kneeWallX = elX;
Vector3d kneeWallY = _ZW;
Vector3d kneeWallZ = kneeWallX.crossProduct(kneeWallY);

// Update origin point and calculate start and end point based on top plate vertices.
Point3d topPlateVerticesX[] = Line(kneeWallOrg, kneeWallX).orderPoints(topPlateVertices);
Point3d topPlateVerticesY[] = Line(kneeWallOrg, kneeWallY).orderPoints(topPlateVertices);
Point3d topPlateVerticesZ[] = Line(kneeWallOrg, kneeWallZ).orderPoints(topPlateVertices);
kneeWallOrg = topPlateVerticesZ[topPlateVerticesZ.length() - 1];
kneeWallOrg += kneeWallX * kneeWallX.dotProduct(topPlateVerticesX[0] - kneeWallOrg);

Point3d kneeWallEnd = kneeWallOrg;
kneeWallEnd += kneeWallX * kneeWallX.dotProduct(topPlateVerticesX[topPlateVerticesX.length() - 1] - kneeWallEnd);

ElementWallSF kneeWall = dummyKneeWall.dbCopy();
CoordSys dummyToReal;
dummyToReal.setToAlignCoordSys(dummyOrg, dummyX, dummyY, dummyZ, kneeWallOrg, kneeWallX, kneeWallY, kneeWallZ);
kneeWall.transformBy(dummyToReal);
_Map.appendEntity("KneeWall", kneeWall);

Wall wall = (Wall)kneeWall;
if (!wall.bIsValid())
{
	eraseInstance();
	return;
}
wall.setStartEnd(kneeWallOrg, kneeWallEnd);
kneeWall.setPtArrow((kneeWallOrg + kneeWallEnd)/2);
// Rename the group of the new knee wall
Group elementGroup = kneeWall.elementGroup();
Group newElementGroup = Group(floorGroupKneeWalls.namePart(0), floorGroupKneeWalls.namePart(1), elementGroup.namePart(2));
int groupIsRenamed = elementGroup.dbRename(newElementGroup);
if( !groupIsRenamed )
	reportNotice(TN("|Group was not renamed|!"));

int wallRoofLineSet = kneeWall.setWallRoofLine(true);
int startStretched = kneeWall.stretchOutlineTo(Plane(kneeWallOrg, -kneeWallX));
int endStretched = kneeWall.stretchOutlineTo(Plane(kneeWallEnd, kneeWallX));

Cut endCut(kneeWallEnd, kneeWallX);
Cut startCut(kneeWallOrg, -kneeWallX);
for (int i=0; i<bottomPlates.length();i++)
{
	Beam bm = bottomPlates[i];
	bm.addToolStatic(startCut, _kStretchOnInsert);
	bm.addToolStatic(endCut, _kStretchOnInsert);
	
	bm.assignToElementGroup(kneeWall, true, 0, 'Z');
}
for (int i=0; i<topPlates.length();i++)
{
	Beam bm = topPlates[i];
	bm.addToolStatic(startCut, _kStretchOnInsert);
	bm.addToolStatic(endCut, _kStretchOnInsert);
	
	bm.assignToElementGroup(kneeWall, true, 0, 'Z');
}
for (int i=0; i<studs.length();i++)
{
	Beam bm = studs[i];
	bm.addToolStatic(startCut, _kStretchOnInsert);
	bm.addToolStatic(endCut, _kStretchOnInsert);
	
	studs[i].assignToElementGroup(kneeWall, true, 0, 'Z');
}
for (int i=0; i<zone6GenBeams.length();i++)
{
	GenBeam gBm = zone6GenBeams[i];
	gBm.addToolStatic(startCut, _kStretchOnInsert);
	gBm.addToolStatic(endCut, _kStretchOnInsert);
	
	zone6GenBeams[i].assignToElementGroup(kneeWall, true, -1, 'Z');
}

String roofElementNumber = el.number();
if(roofElementNumber.find(separator, 0) != -1)
	roofElementNumber = roofElementNumber.token(1, separator);
kneeWall.setNumber(kneeWallType + "-" + roofElementNumber);

// Set the grouping data for the roof and wall element.
String groupName = roofElementNumber;

String groupingChildKey = "Hsb_RoofWallChild";
String parentUIDKey = "ParentUID";

//region Add grouping data.
Map groupingData;
String parentUID;
parentUID.format("%03s", groupName);
groupingData.setString(parentUIDKey, parentUID);

el.setSubMapX(groupingChildKey, groupingData);
kneeWall.setSubMapX(groupingChildKey, groupingData);

eraseInstance();
return;
#End
#BeginThumbnail


#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="mpIDESettings">
    <dbl nm="PreviewTextHeight" ut="N" vl="1" />
  </lst>
  <lst nm="mpTslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End