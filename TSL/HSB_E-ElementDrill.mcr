#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
18.08.2015  -  version 1.00
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
/// <summary Lang=en>
/// Tsl to create elem drills on a specific zone.
/// </summary>

/// <insert>
/// Select element. Select positions.
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.00" date="18.08.2015"></version>

/// <history>
/// AS - 1.00 - 18.08.2015 -  Pilot version.
/// </hsitory>

int zones[] = {1,2,3,4,5,6,7,8,9,10};

PropInt znIndex(0, zones, T("|Zone index|"));
znIndex.setDescription(T("|The zone to drill.|"));

PropDouble drillDiameter(0, U(10), T("|Drill diameter|"));
drillDiameter.setDescription(T("|Sets the drill diameter.|"));

PropDouble drillDepth(1, U(0), T("|Drill depth|"));
drillDepth.setDescription(T("|Sets the depth of the drill.|") + T(" |Zero means that it uses the thickness of the zone.|"));

PropInt toolIndex(1, 0, T("|Tool index|"));
toolIndex.setDescription(T("|Sets the tool index.|"));

if (_bOnInsert) {
	if (insertCycleCount() > 1) {
		eraseInstance();
		return;
	}
	
	showDialog();
	setCatalogFromPropValues(T("_LastInserted"));
	
	// Select an element
	Element selectedElement = getElement(T("|Select an element|"));
	
	Point3d pointsToDrill[0];
	Point3d lastPoint= getPoint(T("|Select position|"));
	pointsToDrill.append(lastPoint);
	while (true) {
		PrPoint ssP2("\nSelect next point",lastPoint); 
		if (ssP2.go()==_kOk) { // do the actual query
			lastPoint = ssP2.value(); // retrieve the selected point
			pointsToDrill.append(lastPoint); // append the selected points to the list of grippoints _PtG
		}
		else { // no proper selection
			break; // out of infinite while
		}
	}
	
	String strScriptName = scriptName();
	Vector3d vecUcsX(1,0,0);
	Vector3d vecUcsY(0,1,0);
	Beam lstBeams[0];
	Element lstElements[1];
	
	Point3d lstPoints[1];
	int lstPropInt[0];
	double lstPropDouble[0];
	String lstPropString[0];
	Map mapTsl;
	
	lstElements[0] = selectedElement;
	for (int p=0;p<pointsToDrill.length();p++) {
		Point3d pointToDrill = pointsToDrill[p];
		lstPoints[0] = pointToDrill;
		
		TslInst tslNew;
		tslNew.dbCreate(strScriptName, vecUcsX,vecUcsY,lstBeams, lstElements, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
		if (tslNew.bIsValid())
			tslNew.setPropValuesFromCatalog(T("|_LastInserted|"));
	}
	
		eraseInstance();
	return;
}

if (_Element.length() == 0) {
	reportWarning(T("|No element selected|!"));
	eraseInstance();
	return;
}

Element el = _Element[0];
Vector3d vz = el.coordSys().vecZ();

int side = 1;
int zoneIndex = znIndex;
if (znIndex > 5) {
	zoneIndex = 5 - znIndex;
	side *= -1;
}

double depth = drillDepth;
if (drillDepth <= 0)
	depth = el.zone(zoneIndex).dH();

ElemDrill elemDrill(zoneIndex, _Pt0, -vz * side, depth, drillDiameter, toolIndex);
el.addTool(elemDrill);
#End
#BeginThumbnail

#End