#Version 8
#BeginDescription
Last modified by: Robert Pol (robert.pol@hsbcad.com)
25.01.2018  -  version 1.02

1.3 19/03/2025 Add mapx convention Author: Robert Pol
#End
#Type E
#NumBeamsReq 1
#NumPointsGrip 0
#DxaOut 1
#ImplInsert 1
#FileState 1
#MajorVersion 1
#MinorVersion 3
#KeyWords 
#BeginContents
/// <summary Lang=en>
/// This tsl visualises the grain direction of sheets. The grain direction is attached as property set.
/// </summary>

/// <insert>
/// Select a set of sheets.
/// </insert>

/// <remark Lang=en>
/// Requires the property set 'hsbGeometryData'. 
/// </remark>

/// <version  value="1.02" date="25.01.2018"></version>

/// <history>
/// AS - 1.00 - 05.01.2017 -	Pilot version
/// RP - 1.01 - 25.01.2018 -	Set conventions for export extension (set sheet ucs convention)
/// RP - 1.02 - 25.01.2018 -	Bug with setting of mapx boleean -1
/// </history>

PropInt colorGrainDirection(0, 1, T("|Color grain direction|"));

String yesNo[] = {T("|Yes|"), T("|No|")};
PropString propMarkViewSde(1, yesNo, T("|Mark view side|"));
PropString propMarkText(2, "Z", T("|Mark text|"));

String recalcTriggers[] = 
{
	T("|Swap grain direction|"),
	T("|Swap view side|"),
	T("|Remove grain direction|")
};
for (int r=0;r<recalcTriggers.length();r++)
	addRecalcTrigger(_kContext, recalcTriggers[r]);


// Set properties if inserted with an execute key
String catalogNames[] = TslInst().getListOfCatalogNames(scriptName());
if( catalogNames.find(_kExecuteKey) != -1 ) 
	setPropValuesFromCatalog(_kExecuteKey);

if (_bOnInsert)
{
	if (insertCycleCount()>1)
	{
		eraseInstance();
		return;
	}
	
	if( _kExecuteKey == "" || catalogNames.find(_kExecuteKey) == -1 )
		showDialog();
	setCatalogFromPropValues(T("|_LastInserted|"));
	
	PrEntity ssSh(T("|Select sheets|"), Sheet());
	Sheet selectedSheets[0];
	if (ssSh.go())
		selectedSheets.append(ssSh.sheetSet());
	
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
		Sheet selectedSheet = (Sheet)selectedSheets[e];
		if (!selectedSheet.bIsValid())
			continue;
		
		lstSheets[0] = selectedSheet;
		lstPoints[0] = selectedSheet.ptCen();
		
		TslInst tslNew;
		tslNew.dbCreate(strScriptName, vecUcsX,vecUcsY,lstSheets, lstEntities, lstPoints, lstPropInt, lstPropDouble, lstPropString, _kModelSpace, mapTsl);
	}
	
	eraseInstance();
	return;
}

if (_Sheet.length() == 0) 
{
	reportWarning(T("|invalid or no sheet selected.|"));
	eraseInstance();
	return;
}

int manualInserted = false;
if (_Map.hasInt("ManualInserted")) 
{
	manualInserted = _Map.getInt("ManualInserted");
	_Map.removeAt("ManualInserted", true);
}

// set properties from catalog
if (_bOnDbCreated && manualInserted)
	setPropValuesFromCatalog(T("|_LastInserted|"));

Sheet sh = _Sheet0;
setDependencyOnEntity(sh);
//if (sh.attachedPropSetNames().find("hsbGeometryData") == -1) 
//{
//	eraseInstance();
//	return;
//}
//
String grainDirectionProperties[] = {"GrainDirection"};
Map grainDirectionPropertyMap = sh.getAttachedPropSetMap("hsbGeometryData", grainDirectionProperties);
int grainDirection = grainDirectionPropertyMap.getInt("GrainDirection");
//if (grainDirection == 0)
//{
//	eraseInstance();
//	return;
//}

_Entity.append(sh);

int swapGrainDirection = false;
// Swap on double click...
String doubleClick= "TslDoubleClick";
if (_bOnRecalc && _kExecuteKey==doubleClick)
	swapGrainDirection = true;
//... and on recalc trigger
if (_kExecuteKey == recalcTriggers[0])
	swapGrainDirection = true;

if (swapGrainDirection) 
{
	if (grainDirection == 1)
		grainDirection = 2;
	else if (grainDirection == 2)
		grainDirection = 1;
	
	grainDirectionPropertyMap.setInt("GrainDirection", grainDirection);
	sh.setAttachedPropSetFromMap("hsbGeometryData", grainDirectionPropertyMap);
}

if (_kExecuteKey == recalcTriggers[2]) 
{ 
	grainDirection = 0;
	grainDirectionPropertyMap.setInt("GrainDirection", grainDirection);
	sh.setAttachedPropSetFromMap("hsbGeometryData", grainDirectionPropertyMap);
	
	eraseInstance();
	return;
}

	// set grain direction in MapX (Exporter convention)
	Map mapGrainDirection;
	if (grainDirection == 1)
	{
		mapGrainDirection.setVector3d("Direction", sh.vecX());
	}
	else if (grainDirection == 2)
	{
		mapGrainDirection.setVector3d("Direction", sh.vecY());
	}	
	sh.setSubMapX("GrainDirection", mapGrainDirection);

Map hsbGeometryDataMap = sh.subMapX("hsbGeometryData");
int side = hsbGeometryDataMap.getInt("ZDirectionSwitch");
if (side == true)
{
	side = 1;
}
else if (side == false)
{
	side = -1;
}

if (_kExecuteKey == recalcTriggers[1]) 
{ 
	side *= -1;
	hsbGeometryDataMap.setInt("ZDirectionSwitch", side ==1);
	sh.setSubMapX("hsbGeometryData", hsbGeometryDataMap);
}

Display display(colorGrainDirection);

Point3d grainDirectionPosition = _Pt0;
Vector3d normal = sh.vecZ() * side;

grainDirectionPosition -= normal * sh.solidHeight() * 0.5;
sh.realBody().vis(1);
grainDirectionPosition.vis(3);
Vector3d grainDirectionVector = _X0;
if (grainDirection == 2)
	grainDirectionVector = _Y0;

PLine grainDirectionSymbol(_Z0);
grainDirectionSymbol.addVertex(grainDirectionPosition - grainDirectionVector * 30 + grainDirectionVector.crossProduct(_Z0) * 10);
grainDirectionSymbol.addVertex(grainDirectionPosition - grainDirectionVector * 50);
grainDirectionSymbol.addVertex(grainDirectionPosition + grainDirectionVector * 50);
grainDirectionSymbol.addVertex(grainDirectionPosition + grainDirectionVector * 30 - grainDirectionVector.crossProduct(_Z0) * 10);
grainDirectionSymbol.vis(1);

display.draw(grainDirectionSymbol);

int markViewSide = (yesNo.find(propMarkViewSde) == 0);

if (markViewSide)
{
	Mark mark(grainDirectionPosition, normal, propMarkText);
	
	if (propMarkText != "")
		mark.suppressLine();
	
	sh.addTool(mark);	
}



#End
#BeginThumbnail




#End
#BeginMapX
<?xml version="1.0" encoding="utf-16"?>
<Hsb_Map>
  <lst nm="TslIDESettings">
    <lst nm="HostSettings">
      <dbl nm="PreviewTextHeight" ut="L" vl="1" />
    </lst>
    <lst nm="{E1BE2767-6E4B-4299-BBF2-FB3E14445A54}">
      <lst nm="BreakPoints" />
    </lst>
  </lst>
  <lst nm="VersionHistory[]">
    <lst nm="Version">
      <str nm="Comment" vl="Add mapx convention" />
      <int nm="MajorVersion" vl="1" />
      <int nm="MinorVersion" vl="3" />
      <str nm="Date" vl="3/19/2025 1:27:50 PM" />
    </lst>
  </lst>
  <lst nm="TslInfo" />
  <unit ut="L" uv="millimeter" />
  <unit ut="A" uv="radian" />
</Hsb_Map>
#End