#Version 8
#BeginDescription
Last modified by: Yarnick Boertje (support.nl@hsbcad.com)
02.05.2017  -  version 1.01

This tsl displays the number of the element.
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
/// This tsl displays the number of the element.
/// </summary>

/// <insert>
/// Select a set of elements.
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.01" date="02.05.2017"></version>

/// <history>
/// YB - 1.00 - 02.05.2017 -	Pilot version
/// YB - 1.01 - 02.05.2017 - 	Attached the TSL to the element.
/// </history>

// Properties
double vectorTolerance = U(0.01, "mm");

String categories[] = { T("|Display|"), T("|Positioning|")};

// Display
PropInt displayColor(0, U(0), T("|Display color|"));
displayColor.setCategory(categories[0]);
PropInt displayHeight(1, U(10), T("|Text height|"));
displayHeight.setCategory(categories[0]);
PropString sDimStyle(1 ,_DimStyles, T("|Dimension style|"));
sDimStyle.setCategory(categories[0]);

// Positioning
String displayLocations[] = { T("|No display|"), T("|Bottom left|"), T("|Bottom center|"), T("|Bottom right|"), T("|Center left|"), T("|Center|"), T("|Center right|"), T("|Top left|"), T("|Top center|"), T("|Top right|")};
PropString displayLocation(0, displayLocations, T("|Display positioning|"));
displayLocation.setCategory(categories[1]);
PropDouble horizontalOffset(0, U(0), T("|Horizontal offset|"));
horizontalOffset.setCategory(categories[1]);
PropDouble verticalOffset(1, U(0), T("|Vertical offset|"));
verticalOffset.setCategory(categories[1]);

String catalogNames[] = TslInst().getListOfCatalogNames(scriptName());
if (_kExecuteKey != "" && catalogNames.find(_kExecuteKey) != -1) 
 	setPropValuesFromCatalog(_kExecuteKey);

if (_bOnInsert) {
	if (insertCycleCount() > 1) {
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
 	setPropValuesFromCatalog(T("|_LastInserted|"));
 	
int displayIndex = displayLocations.find(displayLocation);
 	
Element el = _Element[0];
assignToElementGroup(el, true, 0, 'E');
Vector3d elX = el.vecX();
Vector3d elY = el.vecY();

_Pt0 = el.ptOrg();
String elNumber = el.number();

Point3d elOrg = _Pt0 + elX * horizontalOffset + elY * verticalOffset;
Point3d gridPoints[] = PlaneProfile(el.plEnvelope()).getGripVertexPoints();
Point3d gridPointsX[] = Line(elOrg, elX).orderPoints(gridPoints);
Point3d gridPointsY[] = Line(elOrg, elX).orderPoints(gridPoints);

double elWidth = abs(elX.dotProduct(gridPointsX[gridPointsX.length() - 1] - gridPointsX[0]));
double elHeight = abs(elY.dotProduct(gridPointsY[gridPointsY.length() - 1] - gridPointsY[0]));

if(displayIndex == 0)
	return;
if(displayIndex == 2 || displayIndex == 5 || displayIndex == 8)
	elOrg += elX * 0.5 * elWidth;
if(displayIndex == 3 || displayIndex == 6 || displayIndex == 9)
	elOrg += elX * elWidth;
if(displayIndex == 4 || displayIndex == 5 || displayIndex == 6)
	elOrg += elY * 0.5 * elHeight;
if(displayIndex == 7 || displayIndex == 8 || displayIndex == 9)
	elOrg += elY * elHeight;

Display dp(displayColor);
dp.elemZone(el, 0, 'I');
dp.dimStyle(sDimStyle);
dp.textHeight(displayHeight);
dp.draw(elNumber, elOrg, elX, elY, 0, 0);
#End
#BeginThumbnail

#End