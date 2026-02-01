#Version 8
#BeginDescription
Last modified by: Anno Sportel (anno.sportel@hsbcad.com)
12.07.2016  -  version 1.01
#End
#Type E
#NumBeamsReq 1
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 1
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl adds a mark to a sheet at the element zone vec-z side of the sheet.
/// </summary>

/// <insert>
/// Select a set of sheets.
/// </insert>

/// <remark Lang=en>
/// 
/// </remark>

/// <version  value="1.01" date="12.07.2016"></version>

/// <history>
/// AS - 1.00 - 24.06.2016 -	Pilot version
/// AS - 1.01 - 12.07.2016 -	Add option to mark the viewside or the opposite side.
/// </history>

PropString markText(0, "", T("|Text|"));

PropDouble textSize(0, U(15), T("|Text size|"));

String yesNo[] = {T("|Yes|"), T("|No|")};
PropString propMarkViewSde(1, yesNo, T("|Mark view side|"));

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
	
	PrEntity ssSheets(T("|Select sheets|"), Sheet());
	if (ssSheets.go()) {
		Sheet selectedSheets[] = ssSheets.sheetSet();
		
		String strScriptName = scriptName();
		Vector3d vecUcsX(1,0,0);
		Vector3d vecUcsY(0,1,0);
		Sheet lstSheets[1];
		Entity lstEntities[0];
		
		Point3d lstPoints[1];
		int lstPropInt[0];
		double lstPropDouble[0];
		String lstPropString[0];
		Map mapTsl;
		mapTsl.setInt("ManualInserted", true);

		for (int e=0;e<selectedSheets.length();e++) {
			Sheet selectedSheet = selectedSheets[e];
			if (!selectedSheet.bIsValid())
				continue;
			
			lstSheets[0] = selectedSheet;
			lstPoints[0] = selectedSheet.ptCen();
			
			TslInst tslNew;
			tslNew.dbCreate(strScriptName, vecUcsX,vecUcsY,lstSheets, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
		}		
	}
	
	eraseInstance();
	return;
}

if (_Sheet.length() == 0) {
	reportWarning(T("|invalid or no sheet selected.|"));
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

Element el = _Sheet0.element();
if (!el.bIsValid()) {
	reportNotice(T("|Sheet must be part of an element|"));
	eraseInstance();
	return;
}

int markViewSide = (yesNo.find(propMarkViewSde) == 0);

int zoneIndexSheet = _Sheet0.myZoneIndex();
assignToElementGroup(el, true, zoneIndexSheet, 'T');

CoordSys znCoordSys = el.zone(zoneIndexSheet).coordSys();
Vector3d znX = znCoordSys.vecX();
Vector3d znY = znCoordSys.vecY();
Vector3d znZ = znCoordSys.vecZ();

Point3d markPosition = _Sheet0.ptCen();
Vector3d normal = _Sheet0.vecD(znZ);
if (!markViewSide)
	normal *= -1;

Mark mark(markPosition, normal, markText);

if (markText != "")
	mark.suppressLine();

_Sheet0.addTool(mark);

_ThisInst.setAllowGripAtPt0(false);

Display markDisplay(1);
markDisplay.textHeight(textSize);

Point3d markTextPosition = markPosition + normal * 0.6* _Sheet0.dD(znZ);
markDisplay.draw(markText, markTextPosition, znX, znY, 0, 0);

double textLength = textSize;
if (markText != "")
	textLength = markText.length() * textSize;

PLine markOutline(znZ);
markOutline.addVertex(markTextPosition - znY * 0.6 * textSize - znX * 0.5 * textLength);
markOutline.addVertex(markTextPosition - znY * 0.6 * textSize + znX * 0.5 * textLength);
markDisplay.draw(markOutline);
#End
#BeginThumbnail


#End