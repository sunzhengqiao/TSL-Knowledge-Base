#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
26.09.2016  -  version 1.01
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
/// This tsl shows element information in a specified display representation.
/// </summary>

/// <insert>
/// Select a position
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.01" date="26.09.2016"></version>

/// <history>
/// AS - 1.00 - 17.06.2016 -	Pilot version.
/// AS - 1.01 - 26.09.2016 -	Store information in _Map for dxf output.
/// </history>

String categories[] = {
	T("|Outline|"),
	T("|Element number|")
};

PropString showInDisplayRepresentation(1, _ThisInst.dispRepNames() , T("|Show in display representation|"));

PropInt elementOutlineColor(0, 1, T("|Color element outline|"));
elementOutlineColor.setCategory(categories[0]);

PropString elementNumberDimStyle(0, _DimStyles, T("|Dimension style element number|"));
elementNumberDimStyle.setCategory(categories[1]);
PropInt elementNumberColor(1, 1, T("|Color element number|"));
elementNumberColor.setCategory(categories[1]);

// Set properties if inserted with an execute key
String catalogNames[] = TslInst().getListOfCatalogNames("HSB_G-ElementInformation");
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
	
	PrEntity ssElements(T("|Select elements|"), Element());
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
			Element selectedElement = selectedElements[e];
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

Element el = _Element[0];
CoordSys elCoordSys = el.coordSys();
Point3d elOrg = elCoordSys.ptOrg();
Vector3d elX = elCoordSys.vecX();
Vector3d elY = elCoordSys.vecY();
Vector3d elZ = elCoordSys.vecZ();
_Pt0 = elOrg;

_ThisInst.setAllowGripAtPt0(false);
assignToElementGroup(el, true, 0, 'I');

Display outlineDisplay(elementOutlineColor);
outlineDisplay.showInDispRep(showInDisplayRepresentation);

Display numberDisplay(elementNumberColor);
numberDisplay.dimStyle(elementNumberDimStyle);
numberDisplay.showInDispRep(showInDisplayRepresentation);

PlaneProfile elementOutline = el.profBrutto(0);
outlineDisplay.draw(elementOutline);

Point3d elementOutlineVertices[] = elementOutline.getGripVertexPoints();
Point3d elementOutlineVerticesX[] = Line(elOrg, elX).orderPoints(elementOutlineVertices);
Point3d elementOutlineVerticesY[] = Line(elOrg, elY).orderPoints(elementOutlineVertices);

Point3d elementNumberPosition;
elementNumberPosition.setToAverage(elementOutlineVertices);
if (elementOutlineVerticesX.length() > 0 && elementOutlineVerticesY.length() > 0) {
	elementNumberPosition = (elementOutlineVerticesX[0] + elementOutlineVerticesX[elementOutlineVerticesX.length() - 1])/2;
	elementNumberPosition += elY * elY.dotProduct((elementOutlineVerticesY[0] + elementOutlineVerticesY[elementOutlineVerticesY.length() - 1])/2 - elementNumberPosition);
}

numberDisplay.draw(el.number(), elementNumberPosition, elX, elY, 0, 0);

// Store information in Map of tsl.
Map dxfMap;
PLine elementOutlineRings[] = elementOutline.allRings();
for (int r=0;r<elementOutlineRings.length();r++) {
	PLine ring = elementOutlineRings[r];
	dxfMap.appendPLine("PLine", ring, _kAbsolute);
}

Map textMap;
textMap.setString("Text", el.number());
textMap.setPoint3d("Position", elementNumberPosition, _kAbsolute);
textMap.setPoint3d("VecX", elX, _kAbsolute);
textMap.setPoint3d("VecY", elY, _kAbsolute);

dxfMap.appendMap("Text", textMap);

_Map.setMap("Dxf", dxfMap);
#End
#BeginThumbnail

#End