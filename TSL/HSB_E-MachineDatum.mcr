#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
08.01.2018  -  version 1.03
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
/// Tsl to show the datum position.
/// </summary>

/// <insert>
/// -
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.01" date="03.03.2017"></version>

/// <history>
/// 1.00 - 26.09.2016 - 	Pilot version
/// 1.01 - 03.03.2017 - 	Add description to filter option.
/// 1.02 - 08.01.2018  - 	Add  option to draw a block on datum
/// 1.03 - 08.01.2018  - 	Add  option to draw a block on datum also on the model
/// </hsitory>

String categories[] = {
	T("|Orientation|"),
	T("|Filter|"),
	T("|Machine datum|")
};

String flipDirections[] = {T("|None|"), T("|Flip over X|"), T("|Flip over Y|"), T("|Flip over X and Y|")};
PropString flipDirection(0, flipDirections, T("|Flip direction|"),0);
flipDirection.setCategory(categories[0]);

double rotations[] = {0,90,180,270};
PropDouble rotation(0, rotations, T("|Rotation|"),0);
rotation.setFormat(_kAngle);
rotation.setCategory(categories[0]);


String filterDefinitionTslName = "HSB_G-FilterGenBeams";
String filterDefinitions[] = TslInst().getListOfCatalogNames(filterDefinitionTslName);

PropString filterDefinition(0, filterDefinitions, T("|Filter definition|"));
filterDefinition.setDescription(T("|Filter definition.|") + TN("|Use| ") + filterDefinitionTslName + T(" |to define the filters|."));
filterDefinition.setCategory(categories[1]);

PropString machineName(2, "", T("|Machine name|"));
machineName.setCategory(categories[2]);

PropDouble datumSymbolSize(1, U(1000), T("|Symbol size|"));
datumSymbolSize.setCategory(categories[2]);

PropDouble datumTextSize(2, U(100), T("|Text size|"));
datumTextSize.setCategory(categories[2]);

PropInt datumColor(0, 1, T("|Symbol color|"));
datumColor.setCategory(categories[2]);

int zoneIndexes[] = {0,1,2,3,4,5,6,7,8,9,10};
PropInt zoneIndexProp(1, zoneIndexes, T("|Zone index|"));
zoneIndexProp.setCategory(categories[2]);

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
PropString zoneLayer(3, zoneLayers, T("|Layer|"));
zoneLayer.setCategory(categories[2]);

String blockNamesArray[] ={T("|None|")};
blockNamesArray.append(_BlockNames);
PropString blockName(4,blockNamesArray,T("|Select a Block|"));
int selectedBlockIndex = blockNamesArray.find(blockName);

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
	
	PrEntity ssElements(T("|Select elements|") + T(" |<Enter> to select a viewport|"), Element());
	Element selectedElements[0];
	if (ssElements.go())
		selectedElements.append(ssElements.elementSet());
		
	if (selectedElements.length() < 1) {
		_Viewport.append(getViewport(T("|Select a viewport|")));
		return;
	}

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

Element el;
Viewport vp;
if (_Element.length() > 0) {
	el = _Element[0];
	
	int manualInserted = false;
	if (_Map.hasInt("ManualInserted")) {
		manualInserted = _Map.getInt("ManualInserted");
		_Map.removeAt("ManualInserted", true);
	}
	
	// set properties from catalog
	if (_bOnDbCreated && manualInserted)
		setPropValuesFromCatalog(T("|_LastInserted|"));
}
else if (_Viewport.length() > 0){
	vp = _Viewport[0];
	el = vp.element();
}

if (!el.bIsValid()) {
	if (_Viewport.length() > 0) 
		return;
	
	reportWarning(T("|Selected element is not valid.|"));
	eraseInstance();
	return;
}

CoordSys csEl = el.coordSys();
Point3d elOrg = csEl.ptOrg();
Vector3d elX = csEl.vecX();
Vector3d elY = csEl.vecY();
Vector3d elZ = csEl.vecZ();
_Pt0 = elOrg;

CoordSys machineCoordSys = csEl;
machineCoordSys .vis(1);

// Flip
int flipIndex = flipDirections.find(flipDirection,0);
CoordSys flipTransformation;
if (flipIndex == 1)
	flipTransformation.setToAlignCoordSys(elOrg, elX, elY, elZ, elOrg, elX, -elY, -elZ);
else if (flipIndex ==2)
	flipTransformation.setToAlignCoordSys(elOrg, elX, elY, elZ, elOrg, -elX, elY, -elZ);
else if (flipIndex == 3)
	flipTransformation.setToAlignCoordSys(elOrg, elX, elY, elZ, elOrg, -elX, -elY, elZ);

if (flipIndex > 0) {
	machineCoordSys .transformBy(flipTransformation);
	machineCoordSys .vis(2);
}

// Rotate
CoordSys rotateTransformation;
rotateTransformation.setToRotation(rotation, elZ, elOrg);

if (rotation > 0) {
	machineCoordSys .transformBy(rotateTransformation);
	machineCoordSys .vis(3);
}

GenBeam genBeams[] = el.genBeam();
Entity genBeamEntities[0];
for (int g=0;g<genBeams.length();g++)
	genBeamEntities.append(genBeams[g]);

Map filterGenBeamsMap;
filterGenBeamsMap.setEntityArray(genBeamEntities, false, "GenBeams", "GenBeams", "GenBeam");
int successfullyFiltered = TslInst().callMapIO(filterDefinitionTslName, filterDefinition, filterGenBeamsMap);
if (!successfullyFiltered) {
	reportWarning(T("|Beams could not be filtered!|") + TN("|Make sure that the tsl| ") + filterDefinitionTslName + T(" |is loaded in the drawing|."));
	eraseInstance();
	return;
} 
genBeamEntities = filterGenBeamsMap.getEntityArray("GenBeams", "GenBeams", "GenBeam");

Point3d vertices[0];
for (int g=0;g<genBeamEntities.length();g++) {
	GenBeam gBm = (GenBeam)genBeamEntities[g];
	if (!gBm.bIsValid())
		continue;
	
	vertices.append(gBm.realBody().allVertices());
}

Point3d machineOrg = machineCoordSys.ptOrg();
Vector3d machineX = machineCoordSys.vecX();
Vector3d machineY = machineCoordSys.vecY();
Vector3d machineZ = machineCoordSys.vecZ();

Line lnX(machineOrg, machineX);
Line lnY(machineOrg, machineY);
Line lnZ(machineOrg, machineZ);

Point3d verticesX[] = lnX.orderPoints(vertices);
Point3d verticesY[] = lnY.orderPoints(vertices);
Point3d verticesZ[] = lnZ.orderPoints(vertices);

if ((verticesX.length() * verticesY.length() * verticesZ.length()) <= 0) 
	return;

machineOrg = verticesX[0];
machineOrg += machineY * machineY.dotProduct(verticesY[0] - machineOrg);
machineOrg += machineZ * machineZ.dotProduct(verticesZ[0] - machineOrg);

machineX.vis(machineOrg, 1);
machineY.vis(machineOrg, 3);
machineZ.vis(machineOrg, 150);

PLine datumSymbolX(machineOrg, machineOrg + machineX * datumSymbolSize);
PLine datumSymbolY(machineOrg, machineOrg + machineY * datumSymbolSize);
PLine datumSymbolZ(machineOrg, machineOrg + machineZ * datumSymbolSize);

int zoneIndex = zoneIndexProp;
if (zoneIndex > 5)
	zoneIndex = 5 - zoneIndex;
char zoneCharacter = zoneCharacters[zoneLayers.find(zoneLayer,0)];

Display datumDisplay(datumColor);
datumDisplay.elemZone(el, zoneIndex, zoneCharacter);
datumDisplay.textHeight(datumTextSize);

Point3d nameOrigin = machineOrg + machineX * 0.5 * datumTextSize;
Vector3d nameX = machineX;
Vector3d nameY = machineY;

if (_Viewport.length() > 0) {
	CoordSys ms2ps;
	ms2ps = _Viewport[0].coordSys();
	
	datumSymbolX.transformBy(ms2ps);
	datumSymbolY.transformBy(ms2ps);
	datumSymbolZ.transformBy(ms2ps);
	
	nameOrigin.transformBy(ms2ps);
	nameX.transformBy(ms2ps);
	nameX.normalize();
	nameY.transformBy(ms2ps);
	nameY.normalize();
	
	if( _BlockNames.find(blockName) != -1)
	{
		Block blck(blockName );
		
		datumDisplay.draw(blck,nameOrigin,_XW, _YW,_ZW);
	 
	}
	else
	{
	datumDisplay.draw(datumSymbolX);
	datumDisplay.draw(datumSymbolY);
	datumDisplay.draw(datumSymbolZ);
	}
}
else
{
		//if a block is selected draw the block else the lines
	if( _BlockNames.find(blockName) != -1)
	{
		Block blck(blockName );
		
		datumDisplay.draw(blck,nameOrigin, machineX, machineY, machineZ);
	 
	}
	else
	{
		datumDisplay.draw(datumSymbolX);
		datumDisplay.draw(datumSymbolY);
		datumDisplay.draw(datumSymbolZ);
	}
}

_Pt0 = nameOrigin;
datumDisplay.draw(machineName, nameOrigin, nameX, nameY, 1, 1.5);




#End
#BeginThumbnail






#End