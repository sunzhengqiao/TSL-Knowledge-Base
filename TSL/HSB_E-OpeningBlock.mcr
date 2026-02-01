#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
03.03.2017  -  version 1.03
#End
#Type O
#NumBeamsReq 0
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl inserts a block in an openingSF
/// </summary>

/// <insert>
/// Select a set of elements
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.03" date="03.03.2017"></version>

/// <history>
/// 1.00 - 27.09.2016 - 	Pilot version
/// 1.01 - 03.03.2017 - 	Add option to specify a subfolder.
/// 1.02 - 03.03.2017 - 	Add extension while searching for file.
/// 1.03 - 03.03.2017 - 	Assign tsl to element and draw block on layer and zone.
/// </hsitory>

PropString subFolderProp(0, "", T("|Drawing subfolder|"));
subFolderProp.setDescription(T("|Specifies the subfolder of the drawing location.|") + TN("|This location is used to search for the opening blocks|"));

int zoneIndexes[] = {0,1,2,3,4,5,6,7,8,9,10};
PropInt zoneIndexProp(0, zoneIndexes, T("|Zone index|"));

String zoneLayers[] = {
	"Tooling",
	"Information",
	"Zone",
	"Element"
};
char zoneCharacters[] = {
	'T',
	'I',
	'Z',
	'E'
};
PropString zoneLayer(1, zoneLayers, T("|Layer|"));

// Set properties if inserted with an execute key
String catalogNames[] = TslInst().getListOfCatalogNames(scriptName());
if( catalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);

if (_bOnInsert) {
	if (insertCycleCount() > 1) {
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || catalogNames.find(_kExecuteKey) == -1 )
		showDialog();
	setCatalogFromPropValues(T("|_LastInserted|"));
	
	PrEntity ssElements(T("|Select elements|") + T(" |<Enter> to select openings|"), Element());
	Element selectedElements[0];
	Opening selectedOpenings[0];
	if (ssElements.go()) {
		selectedElements.append(ssElements.elementSet());
		for (int e=0;e<selectedElements.length();e++) {
			ElementWallSF el = (ElementWallSF)selectedElements[e];
			if (el.bIsValid())
				selectedOpenings.append(el.opening());
		}
	}

	if (selectedElements.length() < 1) {
		PrEntity ssOpenings(T("|Select openings|"), Opening());
		if (ssOpenings.go()) {
			Entity selectedOpeningEntities[] = ssOpenings.set();
			for (int o=0;o<selectedOpeningEntities.length();o++) {
				OpeningSF op = (OpeningSF)selectedOpeningEntities[o];
				if (op.bIsValid())
					selectedOpenings.append(op);
			}
		}
	}

	String strScriptName = scriptName();
	Vector3d vecUcsX(1,0,0);
	Vector3d vecUcsY(0,1,0);
	Beam lstBeams[0];
	Entity lstEntities[2];
	
	Point3d lstPoints[0];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
	Map mapTsl;
	mapTsl.setInt("ManualInserted", true);

	for (int o=0;o<selectedOpenings.length();o++) {
		Opening selectedOpening = selectedOpenings[o];
		if (!selectedOpening.bIsValid())
			continue;
		Element el = selectedOpening.element();
		if (!el.bIsValid())
			continue;
		
		lstEntities[0] = el;
		lstEntities[1] = selectedOpening;

		TslInst tslNew;
		tslNew.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
	}		
	
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

if (_Entity.length() != 2) {
	reportNotice(T("|Opening block cannot be inserted.|"));
	eraseInstance();
	return;
}

Element el = _Element[0];
CoordSys csEl = el.coordSys();
Point3d elOrg = csEl.ptOrg();
Vector3d elX = csEl.vecX();
Vector3d elY = csEl.vecY();
Vector3d elZ = csEl.vecZ();

assignToElementGroup(el, true, 0, 'E');

int zoneIndex = zoneIndexProp;
if (zoneIndex > 5)
	zoneIndex = 5 - zoneIndex;
char zoneCharacter = zoneCharacters[zoneLayers.find(zoneLayer,0)];

Display blockDisplay(-1);
blockDisplay.elemZone(el, zoneIndex, zoneCharacter);
blockDisplay.textHeight(U(25));

OpeningSF op = (OpeningSF)_Entity[1];
if (!op.bIsValid()) {
	reportNotice("\n" + scriptName() + TN("|Invalid opening selected.|"));
	eraseInstance();
	return;
}

Point3d openingVertices[] = op.plShape().vertexPoints(true);
Point3d openingVerticesX[] = Line(elOrg, elX).orderPoints(openingVertices);
Point3d openingVerticesY[] = Line(elOrg, elY).orderPoints(openingVertices);

Point3d openingReferencePosition = openingVerticesX[0];
openingReferencePosition += elY * elY.dotProduct(openingVerticesY[0] - openingReferencePosition);

String openingBlockName = op.openingDescr().token(0,"-");
String subFolder = "\\";
if (subFolderProp != "")
	subFolder += (subFolderProp + "\\");
String openingBlockFullPath = _kPathDwg + subFolder + openingBlockName +".dwg";

int isOpeningBlockAvailable = false;
Block blockOpening;
if (_BlockNames.find(openingBlockName) > -1) {
	isOpeningBlockAvailable = true;
	blockOpening = Block(openingBlockName);
}
else if (findFile(openingBlockFullPath) == openingBlockFullPath) {
	isOpeningBlockAvailable = true;
	blockOpening = Block(openingBlockFullPath);
}

if (isOpeningBlockAvailable)
	blockDisplay.draw(blockOpening, openingReferencePosition, elX, elY, elZ);
else 
	blockDisplay.draw(T("|Cannot find| ") + openingBlockFullPath, openingReferencePosition, elX, elY, 1, 1);
	
#End
#BeginThumbnail



#End